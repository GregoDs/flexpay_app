import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Pretty Print Helper
String prettyPrintJson(dynamic jsonObj) {
  const encoder = JsonEncoder.withIndent('  ');
  return encoder.convert(jsonObj);
}



class SharedPreferencesHelper {
  static const String _tokenKey = 'token';
  static const String _userDataKey = 'user_data';
  static const String _bookingResponseKey = 'booking_response';
  static const String _bookingReferenceKey = 'booking_reference';
  static const String _validatedAmountKey = 'validated_amount';

  // Token Handling
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setBool('isLoggedIn', true);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.setBool('isLoggedIn', false);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userDataKey);
    await prefs.remove(_bookingReferenceKey);
    await prefs.remove(_validatedAmountKey);
    await prefs.remove(_bookingResponseKey);
    await prefs.setBool('isLoggedIn', false);

    print("User successfully logged out");
  }

  // User Data Handling
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDataKey, jsonEncode(userData));
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(_userDataKey);
    if (userDataString == null) return null;

    try {
      return jsonDecode(userDataString) as Map<String, dynamic>;
    } catch (e) {
      print("Failed to decode user data: $e");
      return null;
    }
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userDataKey);

  }

  
// // Save Closed Bookings
// static Future<void> saveClosedBookings(List<Booking> bookings) async {
//   final prefs = await SharedPreferences.getInstance();
//   final bookingsJsonList = bookings.map((booking) => booking.toJson()).toList();
//   final bookingsString = jsonEncode(bookingsJsonList);
//   await prefs.setString('closed_bookings', bookingsString);

//   // Log with pretty print
//   dev.log('📦 Saved closed bookings:\n${prettyPrintJson(bookingsJsonList)}',
//       name: 'SharedPreferencesHelper');
// }

// // Load Closed Bookings
// static Future<List<Booking>> loadClosedBookings() async {
//   final prefs = await SharedPreferences.getInstance();
//   final bookingsString = prefs.getString('closed_bookings');

//   if (bookingsString == null) {
//     dev.log('No closed bookings found in SharedPreferences.', name: 'SharedPreferencesHelper');
//     return [];
//   }

//   try {
//     final List<dynamic> decodedList = jsonDecode(bookingsString);

//     // Pretty log loaded bookings
//     dev.log('📥 Loaded closed bookings:\n${prettyPrintJson(decodedList)}',
//         name: 'SharedPreferencesHelper');

//     return decodedList.map((json) => Booking.fromJson(json)).toList();
//   } catch (e) {
//     dev.log('❌ Error loading closed bookings: $e', name: 'SharedPreferencesHelper');
//     return [];
//   }
// }


  // // Booking Data Handling
  // static Future<void> saveBookingData({
  //   required String bookingReference,
  //   required String bookingPrice,
  // }) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString(_bookingReferenceKey, bookingReference);
  //   await prefs.setString(_validatedAmountKey, bookingPrice);

  //   print("Booking data saved - Reference: $bookingReference, Price: $bookingPrice");
  // }

  // static Future<String?> getBookingReference() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getString(_bookingReferenceKey);
  // }

  // static Future<String?> getBookingPrice() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getString(_validatedAmountKey);
  // }

  // static Future<void> saveBookingResponse(BookingResponseModel response) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString(_bookingResponseKey, jsonEncode(response.toJson()));
  //   print("Full booking response saved");
  // }

  // static Future<BookingResponseModel?> getBookingResponse() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final jsonString = prefs.getString(_bookingResponseKey);

  //   if (jsonString != null) {
  //     try {
  //       final jsonMap = jsonDecode(jsonString);
  //       return BookingResponseModel.fromJson(jsonMap);
  //     } catch (e) {
  //       print("Failed to decode booking response: $e");
  //     }
  //   }
  //   return null;
  // }

  // static Future<void> clearBookingData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.remove(_bookingReferenceKey);
  //   await prefs.remove(_validatedAmountKey);
  //   await prefs.remove(_bookingResponseKey);
  //   print("Booking data cleared");
  // }
}