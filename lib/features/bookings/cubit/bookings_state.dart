import 'package:equatable/equatable.dart';
import 'package:flexpay/features/bookings/models/bookings_models.dart';


abstract class BookingsState extends Equatable {
  const BookingsState();

  @override
  List<Object?> get props => [];
}

class BookingsInitial extends BookingsState {}

class BookingsLoading extends BookingsState {}

class BookingsFetched extends BookingsState {
  final List<Booking> bookings;
  final String bookingType;

  const BookingsFetched({
    required this.bookings,
    required this.bookingType,
  });

  @override
  List<Object?> get props => [bookings, bookingType];
}

class BookingsError extends BookingsState {
  final String message;

  const BookingsError(this.message);

  @override
  List<Object?> get props => [message];
}