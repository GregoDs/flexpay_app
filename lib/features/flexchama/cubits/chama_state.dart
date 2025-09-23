import 'package:equatable/equatable.dart';
import 'package:flexpay/features/flexchama/models/chama_profile_model/chama_profile_model.dart';
import 'package:flexpay/features/flexchama/models/chama_reg_model/chama_reg_model.dart';
import 'package:flexpay/features/flexchama/models/chama_savings_model/chama_savings_model.dart';

abstract class ChamaState extends Equatable {
  const ChamaState();

  @override
  List<Object?> get props => [];
}

/// ---------------- Profile States ----------------
class ChamaInitial extends ChamaState {}

class ChamaProfileLoading extends ChamaState {}



/// ---------------- Savings States ----------------
class ChamaSavingsLoading extends ChamaState {
  final ChamaProfile? previousProfile;

  const ChamaSavingsLoading({this.previousProfile});

  @override
  List<Object?> get props => [previousProfile];
}

class ChamaProfileFetched extends ChamaState {
  final ChamaProfile profile;

  const ChamaProfileFetched(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ChamaNotMember extends ChamaState {
  final String? message;

  const ChamaNotMember({this.message});

  @override
  List<Object?> get props => [message];
}

/// ---------------- Savings States ----------------
class ChamaSavingsFetched extends ChamaState {
  final ChamaSavingsResponse savingsResponse;

  const ChamaSavingsFetched(this.savingsResponse);

  @override
  List<Object?> get props => [savingsResponse];

}

/// ---------------- Registration States ----------------
class ChamaRegistrationInitial extends ChamaState {}

class ChamaRegistrationLoading extends ChamaState {}

class ChamaRegistrationProfile extends ChamaState {
  final ChamaProfile profile;
  final ChamaUser user;

  const ChamaRegistrationProfile({
    required this.profile,
    required this.user,
  });

  @override
  List<Object?> get props => [profile, user];
}

class ChamaRegistrationSuccess extends ChamaState {
  final ChamaRegistrationResponse response;

  const ChamaRegistrationSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class ChamaRegistrationFailure extends ChamaState {
  final String message;

  const ChamaRegistrationFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// ---------------- Error States ----------------
class ChamaError extends ChamaState {
  final String message;

  const ChamaError(this.message);

  @override
  List<Object?> get props => [message];
}
