import 'package:flexpay/features/flexchama/mappers/membership_mapper.dart';
import 'package:flexpay/features/flexchama/models/profile_model/chama_profile_model.dart';
import 'package:flexpay/features/flexchama/models/savings_model/chama_savings_model.dart';
import 'package:flexpay/features/flexchama/repo/chama_repo.dart';
import 'package:flexpay/utils/services/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chama_state.dart';
import 'package:flexpay/features/flexchama/models/products_model/chama_products_model.dart';

class ChamaCubit extends Cubit<ChamaState> {
  final ChamaRepo _chamaRepo;

  // Store last fetched profile
  ChamaProfile? _currentProfile;

  // In-memory cache for snappy UI
  ChamaSavingsResponse? _cachedSavings;
  UserChamasResponse? _cachedUserChamas;
  final Map<String, ChamaProductsResponse> _cachedProductsByType = {};

  ChamaCubit(this._chamaRepo) : super(ChamaInitial());

  /// ---------------- Fetch Profile ----------------
  Future<void> fetchChamaUserProfile() async {
    emit(ChamaProfileLoading());
    try {
      final profile = await _chamaRepo.fetchChamaUserProfile();

      if (profile == null) {
        emit(
          const ChamaNotMember(
            message: "You are not a member of FlexChama. Please register.",
          ),
        );
      } else {
        _currentProfile = profile; // store the fetched profile
        emit(ChamaProfileFetched(profile));
        // Automatically fetch savings after profile
        fetchChamaUserSavings();
      }
    } catch (e) {
      final errorMsg = e.toString().toLowerCase();
      if (errorMsg.contains("member not found")) {
        emit(
          const ChamaNotMember(
            message: "You are not a member of FlexChama. Please register.",
          ),
        );
      } else {
        // ✅ Even on error, emit empty savings so page renders
        emit(
          ChamaSavingsFetched(
            ChamaSavingsResponse.empty(errorMessage: e.toString()),
          ),
        );
        // emit(ChamaError(e.toString()));
      }
    }
  }

  /// ---------------- Fetch Chama User Savings ----------------
  Future<void> fetchChamaUserSavings() async {
    emit(ChamaSavingsLoading(previousProfile: _currentProfile));

    final savingsResponse = await _chamaRepo.fetchUserChamaSavings();

    // ✅ Always emit Fetched so FlexChama page renders
    emit(ChamaSavingsFetched(savingsResponse));

    // ✅ Show error if there is one in the logs..the user doesnt need to see the errors here
    // Show snackbar only for non-400 errors
    if (savingsResponse.errors?.isNotEmpty ?? false) {
      final errorMsg = savingsResponse.errors!.first.toString();

      if (!errorMsg.toLowerCase().contains("member product not found")) {
        // Show error only for serious errors
        AppLogger.log("⚠️ Non-400 error: $errorMsg");
      } else {
        AppLogger.log("ℹ️ 400 error ignored for UI: $errorMsg");
      }
    }
  }

  /// ---------------- Register Chama User ----------------
  Future<void> registerChamaUser({
    required String firstName,
    required String lastName,
    required String idNumber,
    required String phoneNumber,
    String? dob,
    required String gender,
  }) async {
    emit(ChamaRegistrationLoading());

    try {
      final response = await _chamaRepo.registerChamaUser(
        firstName: firstName,
        lastName: lastName,
        idNumber: idNumber,
        phoneNumber: phoneNumber,
        dob: dob,
        gender: gender,
      );

      emit(ChamaRegistrationSuccess(response));

      final membership = response.data.user.membership;
      // final chamaUser = response.data.user;

      //Convert Membership to ChamaProfile
      final profile = membership.toChamaProfile();
      _currentProfile = profile;

      //Emit the profile state for flexchama
      emit(ChamaProfileFetched(profile));

      // // Optional: Automatically fetch profile after successful registration
      // // fetchChamaUserSavings();
      // await fetchChamaUserProfile();
      await fetchChamaUserSavings();
    } catch (e) {
      emit(ChamaRegistrationFailure(e.toString()));
    }
  }

  /// ---------------- Get All Chama Products ----------------
  Future<void> getAllChamaProducts({required String type}) async {
    emit(ChamaAllProductsLoading());

    try {
      final response = await _chamaRepo.getAllChamaProducts(type: type);
      emit(ChamaAllProductsFetched(response));
    } catch (e) {
      emit(ChamaAllProductsFailure(e.toString()));
    }
  }

  /// ---------------- Get User Chamas  ----------------
  Future<void> getUserChamas() async {
    emit(UserChamasLoading());

    try {
      final response = await _chamaRepo.getUserChamas();
      emit(UserChamasFetched(response));
    } catch (e) {
      emit(UserChamasFailure(e.toString()));
    }
  }

  /// ---------------- Fetch All Products At Once (with cache) ----------------
  Future<void> fetchAllChamaDetails({
    String type = "yearly",
    bool refreshListOnly = false,
    bool forceRefresh = false,
  }) async {
    final hasSavings = _cachedSavings != null;
    final hasUserChamas = _cachedUserChamas != null;
    final hasProductsForType = _cachedProductsByType.containsKey(type);

    // Serve from cache when available and not forcing refresh
    if (!forceRefresh && hasSavings && hasUserChamas && hasProductsForType) {
      final current = ChamaViewState(
        isWalletLoading: false,
        isListLoading: false,
        savings: _cachedSavings,
        userChamas: _cachedUserChamas,
        allProducts: _cachedProductsByType[type],
      );

      // If only the list is meant to show loading (tab switch), keep wallet intact
      if (refreshListOnly) {
        emit(
          ChamaViewState(
            isWalletLoading: false,
            isListLoading: false,
            savings: current.savings,
            userChamas: current.userChamas,
            allProducts: current.allProducts,
          ),
        );
      } else {
        emit(current);
      }
      return;
    }

    // Determine loading states
    if (refreshListOnly) {
      emit(
        ChamaViewState(
          isListLoading: true,
          isWalletLoading: false,
          savings: state is ChamaViewState
              ? (state as ChamaViewState).savings
              : _cachedSavings,
          userChamas: state is ChamaViewState
              ? (state as ChamaViewState).userChamas
              : _cachedUserChamas,
          allProducts: state is ChamaViewState
              ? (state as ChamaViewState).allProducts
              : _cachedProductsByType[type],
        ),
      );
    } else {
      emit(const ChamaViewState(isWalletLoading: true, isListLoading: true));
    }

    try {
      // Fetch only what is missing or when forcing refresh
      final futures = <Future>[];
      if (forceRefresh || !hasSavings)
        futures.add(_chamaRepo.fetchUserChamaSavings());
      if (forceRefresh || !hasUserChamas) futures.add(_chamaRepo.getUserChamas());
      if (forceRefresh || !hasProductsForType)
        futures.add(_chamaRepo.getAllChamaProducts(type: type));

      final results = await Future.wait(futures);

      int idx = 0;
      if (forceRefresh || !hasSavings) {
        _cachedSavings = results[idx++] as ChamaSavingsResponse;
      }
      if (forceRefresh || !hasUserChamas) {
        _cachedUserChamas = results[idx++] as UserChamasResponse;
      }
      if (forceRefresh || !hasProductsForType) {
        _cachedProductsByType[type] = results[idx++] as ChamaProductsResponse;
      }
      // updated cache timestamp if needed later

      emit(
        ChamaViewState(
          isWalletLoading: false,
          isListLoading: false,
          savings: _cachedSavings,
          userChamas: _cachedUserChamas,
          allProducts: _cachedProductsByType[type],
        ),
      );
    } catch (e) {
      emit(ChamaError(e.toString()));
    }
  }

  /// ---------------- Subscribe to Chama ----------------
  Future<void> subscribeToChama({
    required int productId,
    required double depositAmount,
  }) async {
    emit(SubscribeChamaLoading());
    try {
      final response = await _chamaRepo.subscribeChama(
        productId: productId,
        depositAmount: depositAmount,
      );
      emit(SubscribeChamaSuccess(response));
      // Invalidate caches and refresh next view
      _cachedSavings = null;
      _cachedUserChamas = null;
      // Keep products cache; product catalog rarely changes here
    } catch (e) {
      emit(SubscribeChamaFailure(e.toString()));
    }
  }

  /// ---------------- Save to Chama (Mpesa) ----------------
  Future<void> saveToChamaMpesa({
    required int productId,
    required double amount,
  }) async {
    emit(SaveToChamaLoading());
    try {
      final response = await _chamaRepo.saveToChama(
        productId: productId,
        amount: amount,
      );
      emit(SaveToChamaSuccess(response));
      // Invalidate caches and refresh next view
      _cachedSavings = null;
      //Immediatey refresh userChamas
      await getUserChamas();
    } catch (e) {
      emit(SaveToChamaFailure(e.toString()));
    }
  }

  /// ---------------- Save to Chama (Wallet) ----------------
  Future<void> payChamaViaWallet({
    required int productId,
    required double amount,
  }) async {
    emit(PayChamaWalletLoading());
    try {
      final response = await _chamaRepo.payChamaViaWallet(
        productId: productId,
        amount: amount,
      );
      emit(PayChamaWalletSuccess(response));
      // Invalidate caches and refresh next view
      _cachedSavings = null;
      await getUserChamas();
    } catch (e) {
      emit(PayChamaWalletFailure(e.toString()));
    }
  }

  /// Make referral in chama page
  Future<void> makeReferral(String phoneNumber) async {
    emit(ChamaReferralLoading());
    try {
      final referralResponse = await _chamaRepo.makeReferral(phoneNumber);
      emit(ChamaReferralSuccess(referralResponse));
    } catch (e) {
      emit(ChamaReferralFailure(e.toString()));
    }
  }
}
