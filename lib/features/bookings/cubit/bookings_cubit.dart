import 'package:flexpay/features/bookings/cubit/bookings_state.dart';
import 'package:flexpay/features/bookings/models/bookings_models.dart';
import 'package:flexpay/features/bookings/repo/bookings_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class BookingsCubit extends Cubit<BookingsState> {
  final BookingsRepository _repository;

  BookingsCubit(this._repository) : super(BookingsInitial());

  Future<void> fetchBookingsByType(String userId,String type) async {
  emit(BookingsLoading());

  try {
    final bookings = switch (type.toLowerCase()) {
      'all' => await _repository.fetchAllBookings(userId),
      // 'active' => await _repository.fetchOpenBookings(),
      // 'completed' => await _repository.fetchClosedBookings(),
      // 'redeemed' => await _repository.fetchRedeemedBookings(),
      // 'unserviced' => await _repository.fetchUnservicedBookings(),
      _ => <Booking>[],
    };

    print('📦 BOOKINGS VALUE: $bookings');
    print('🔍 TYPE: ${bookings.runtimeType}');

    emit(BookingsFetched(bookings: bookings, bookingType: type));
  } catch (e) {
    emit(BookingsError('Failed to load $type bookings. ${e.toString()}'));
  }
}
}