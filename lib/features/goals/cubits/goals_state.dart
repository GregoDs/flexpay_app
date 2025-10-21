import 'package:equatable/equatable.dart';
import 'package:flexpay/features/goals/models/create_goal_response.dart/create_goal_response.dart';

abstract class GoalsState extends Equatable {
  const GoalsState();

  @override
  List<Object?> get props => [];
}

class GoalsInitial extends GoalsState {}

class CreateGoalsLoading extends GoalsState {}

class CreateGoalsSuccess extends GoalsState {
  final CreateGoalResponse response;

  const CreateGoalsSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class CreateGoalsError extends GoalsState {
  final String message;

  const CreateGoalsError(this.message);

  @override
  List<Object?> get props => [message];
}