import 'package:equatable/equatable.dart';
import 'package:flexpay/features/flexchama/models/chama_profile_model/chama_profile_model.dart';

abstract class ChamaState extends Equatable {
  const ChamaState();

  @override
  List<Object?> get props => [];
}

class ChamaInitial extends ChamaState {}

class ChamaLoading extends ChamaState {}

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

class ChamaError extends ChamaState {
  final String message;

  const ChamaError(this.message);

  @override
  List<Object?> get props => [message];
}