import 'package:bloc/bloc.dart';
import 'package:flexpay/features/goals/cubits/goals_state.dart';
import 'package:flexpay/features/goals/models/create_goal_response.dart/create_goal_response.dart';
import 'package:flexpay/features/goals/repo/goals_repo.dart';
import 'package:flexpay/utils/services/error_handler.dart';

class GoalsCubit extends Cubit<GoalsState> {
  final GoalsRepo _repo;

  GoalsCubit(this._repo) : super(GoalsInitial());

  /// 🟢 Create a new goal
  Future<void> createGoal({
    required String productName,
    required String targetAmount,
    required String startDate,
    required String endDate,
    required String frequency,
    required String frequencyContribution,
    required String deposit,
  }) async {
    emit(CreateGoalsLoading());
    try {
      final CreateGoalResponse response = await _repo.createGoal(
        productName: productName,
        targetAmount: targetAmount,
        startDate: startDate,
        endDate: endDate,
        frequency: frequency,
        frequencyContribution: frequencyContribution,
        deposit: deposit,
      );

      if (response.success == true) {
        emit(CreateGoalsSuccess(response));
      } else {
        emit(const CreateGoalsError("Goal creation failed. Please try again."));
      }
    } catch (e) {
      emit(CreateGoalsError(ErrorHandler.handleGenericError(e)));
    }
  }
}