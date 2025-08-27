import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionDetailsPage extends StatelessWidget {
  final String transactionId;

  const TransactionDetailsPage({super.key, required this.transactionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("All Transactions",
            style: GoogleFonts.montserrat(fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_downward, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop(); // Slide back down
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _transactionItem("03 Feb 2025 21:35", "Booking", "Ksh 1", false),
          _transactionItem(
              "Feb 19, 2025", "Boxer Motor Booking", "+Ksh 2,000.00", true),
          _transactionItem("03 Feb 2025 21:35", "Booking", "Ksh 1", true),
          _transactionItem("Feb 15, 2025", "Fridge", "-Ksh 50.00", false),
          _transactionItem(
              "Feb 10, 2025", "Vitron TV Booking", "+Ksh 500.00", true),
        ],
      ),
    );
  }

  Widget _transactionItem(
      String dateTime, String description, String amount, bool isIncome) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(description,
                  style: GoogleFonts.montserrat(
                      fontSize: 16, color: Colors.black)),
              Text(dateTime,
                  style: GoogleFonts.montserrat(
                      fontSize: 14, color: Colors.black.withOpacity(0.6))),
            ],
          ),
          Text(
            amount,
            style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isIncome ? Colors.green : Colors.red),
          ),
        ],
      ),
    );
  }
}
