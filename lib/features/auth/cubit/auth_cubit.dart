import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flexpay/features/auth/repo/auth_repo.dart';
import 'package:flexpay/utils/services/error_handler.dart';
import 'auth_state.dart';
class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _authRepo;

  AuthCubit(this._authRepo) : super(AuthInitial());

  Future<void> requestOtp(String phoneNumber) async {
    emit(AuthLoading());
    try {
      final response = await _authRepo.requestOtp(phoneNumber);
      
      if (response.data['success'] == true) {
        emit(AuthOtpSent(message: 'OTP sent successfully'));
        emit(AuthUserUpdated(userModel: _authRepo.userModel!));
      } else {
        emit(AuthError(
          errorMessage: ErrorHandler.extractErrorMessage(response.data),
        ));
      }
    } on DioException catch (e) {
      emit(AuthError(errorMessage: ErrorHandler.handleError(e)));
    } catch (e) {
      emit(AuthError(errorMessage: ErrorHandler.handleGenericError(e)));
    }
  }

  Future<void> verifyOtp(String phoneNumber, String otp) async {
    emit(AuthLoading());
    try {
      final response = await _authRepo.verifyOtp(phoneNumber, otp);
      
      if (response.data['success'] == true) {
        emit(AuthUserUpdated(userModel: _authRepo.userModel!));
      } else {
        emit(AuthError(
          errorMessage: ErrorHandler.extractErrorMessage(response.data),
        ));
      }
    } on DioException catch (e) {
      emit(AuthError(errorMessage: ErrorHandler.handleError(e)));
    } catch (e) {
      emit(AuthError(errorMessage: ErrorHandler.handleGenericError(e)));
    }
  }
}