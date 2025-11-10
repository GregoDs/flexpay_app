import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

/// ==========================================================
/// 🧭 HOME SCREEN SHIMMERS
/// ==========================================================

/// 🧭 1️⃣ AppBar shimmer — only the balance section shimmers
class AppBarBalanceShimmer extends StatelessWidget {
  const AppBarBalanceShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(height: 32, color: Colors.white),
          ),
        ),
        SizedBox(width: 8),
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Icon(Icons.visibility, size: 24, color: Colors.white),
        ),
      ],
    );
  }
}

/// 🧩 2️⃣ TransactionDetails shimmer — full list shimmer
class TransactionDetailsShimmer extends StatelessWidget {
  const TransactionDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "All Transactions",
          style: GoogleFonts.montserrat(fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_downward, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10, // show 10 shimmer items
        itemBuilder: (context, index) {
          return const _TransactionItemShimmer();
        },
      ),
    );
  }
}

/// 💡 Small shimmer card for each transaction
class _TransactionItemShimmer extends StatelessWidget {
  const _TransactionItemShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left column (description + date)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 6),
                  Container(width: 100, height: 12, color: Colors.white),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Right side (amount placeholder)
            Container(width: 60, height: 16, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
