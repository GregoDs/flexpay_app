import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WithdrawPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      resizeToAvoidBottomInset: true, // Ensures UI adjusts when keyboard appears
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDarkMode ? Colors.white : Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Withdraw",
          style: GoogleFonts.montserrat(
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag, // Hide keyboard when scrolling
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: screenWidth * 0.05),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      "Make a withdrawal from your wallet to facilitate easy purchases on the Flexpay ecosystem",
                      style: GoogleFonts.montserrat(
                        fontSize: screenWidth * 0.04,
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              Divider(color: Colors.blue, thickness: 2, endIndent: screenWidth * 0.75),
              SizedBox(height: screenHeight * 0.03),
              Text(
                "Withdraw to",
                style: GoogleFonts.montserrat(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: screenWidth * 0.2,
                      height: screenWidth * 0.2,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.phone_android, color: Colors.blue, size: screenWidth * 0.1),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "M-Pesa",
                      style: GoogleFonts.montserrat(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Text(
                "Phone Number",
                style: GoogleFonts.montserrat(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 8),
              TextFieldContainer(
                child: TextField(
                  style: GoogleFonts.montserrat(
                    fontSize: screenWidth * 0.045,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: "Enter Phone Number",
                    border: InputBorder.none,
                    hintStyle: GoogleFonts.montserrat(
                      color: isDarkMode ? Colors.white70 : Colors.black45,
                      fontSize: screenWidth * 0.04,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              Text(
                "Enter Amount (KES)",
                style: GoogleFonts.montserrat(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 8),
              TextFieldContainer(
                child: TextField(
                  style: GoogleFonts.montserrat(
                    fontSize: screenWidth * 0.045,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: "Enter Amount (KES)",
                    border: InputBorder.none,
                    hintStyle: GoogleFonts.montserrat(
                      color: isDarkMode ? Colors.white70 : Colors.black45,
                      fontSize: screenWidth * 0.04,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: screenHeight * 0.07,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Withdraw",
                      style: GoogleFonts.montserrat(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03), // Extra space for safe scrolling
            ],
          ),
        ),
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
    );
  }
}

// Extracted reusable widget for TextField container
class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: MediaQuery.of(context).size.height * 0.07,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5.0),
      child: child,
    );
  }
}