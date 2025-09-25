import 'package:flexpay/features/flexchama/mappers/membership_mapper.dart';
import 'package:flexpay/features/flexchama/models/profile_model/chama_profile_model.dart';
import 'package:flexpay/features/flexchama/models/savings_model/chama_savings_model.dart';
import 'package:flexpay/features/flexchama/repo/chama_repo.dart';
import 'package:flexpay/utils/services/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chama_state.dart';

class ChamaCubit extends Cubit<ChamaState> {
  final ChamaRepo _repo;

  // Store last fetched profile
  ChamaProfile? _currentProfile;

  ChamaCubit(this._repo) : super(ChamaInitial());

  /// ---------------- Fetch Profile ----------------
  Future<void> fetchChamaUserProfile() async {
    emit(ChamaProfileLoading());
    try {
      final profile = await _repo.fetchChamaUserProfile();

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

    final savingsResponse = await _repo.fetchUserChamaSavings();

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
      final response = await _repo.registerChamaUser(
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
      final response = await _repo.getAllChamaProducts(type: type);
      emit(ChamaAllProductsFetched(response));
      
    } catch (e) {
      emit(ChamaAllProductsFailure(e.toString()));
    }
  }

  /// ---------------- Get User Chamas  ----------------
  Future<void> getUserChamas() async {
    emit(UserChamasLoading());

    try {
      final response = await _repo.getUserChamas();
      emit(UserChamasFetched(response));
    } catch (e) {
      emit(UserChamasFailure(e.toString()));
    }
  }



   /// ---------------- Fetch All At Once ----------------
  Future<void> fetchAllChamaDetails({String type = "yearly", bool refreshListOnly = false}) async {
    // 👉 if refreshListOnly = true → only shimmer the list, not wallet
    if (refreshListOnly) {
      emit(
        ChamaViewState(
          isListLoading: true,
          isWalletLoading: false,
          savings: state is ChamaViewState ? (state as ChamaViewState).savings : null,
          userChamas: state is ChamaViewState ? (state as ChamaViewState).userChamas : null,
          allProducts: state is ChamaViewState ? (state as ChamaViewState).allProducts : null,
        ),
      );
    } else {
      // 👉 full page loading (first time)
      emit(const ChamaViewState(isWalletLoading: true, isListLoading: true));
    }

    try {
      final savings = await _repo.fetchUserChamaSavings();
      final userChamas = await _repo.getUserChamas();
      final products = await _repo.getAllChamaProducts(type: type);

      emit(
        ChamaViewState(
          isWalletLoading: false,
          isListLoading: false,
          savings: savings,
          userChamas: userChamas,
          allProducts: products,
        ),
      );
    } catch (e) {
      emit(ChamaError(e.toString()));
    }
  }
}

