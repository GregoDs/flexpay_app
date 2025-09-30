import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    Color backgroundColor = isDarkMode ? Colors.black : Colors.white;
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    Color cardColor = isDarkMode ? Colors.grey[850]! : Colors.grey[200]!;
    Color buttonColor = isDarkMode ? Colors.blue[400]! : Colors.blue[700]!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Top Up",
          style: GoogleFonts.montserrat(
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: screenWidth * 0.05),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      "Make a Top-up to your wallet to facilitate easy purchases on the\nFlexpay eco-system",
                      style: GoogleFonts.montserrat(
                        fontSize: screenWidth * 0.04,
                        color: textColor.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              Divider(color: Colors.blue, thickness: 2, endIndent: screenWidth * 0.75),
              SizedBox(height: screenHeight * 0.03),

              // **Select Top Up Method**
              Text(
                "Select Top Up Method",
                style: GoogleFonts.montserrat(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              // **M-Pesa Box**
              Center(
                child: Column(
                  children: [
                    Container(
                      width: screenWidth * 0.2,
                      height: screenWidth * 0.2,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(12),
                        color: isDarkMode ? Colors.grey[800] : Colors.transparent,
                      ),
                      child: Icon(Icons.phone_android, color: Colors.blue, size: screenWidth * 0.1),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "M-Pesa",
                      style: GoogleFonts.montserrat(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              // **Phone Number Field**
              Text(
                "Phone Number",
                style: GoogleFonts.montserrat(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500, color: textColor),
              ),
              SizedBox(height: 8),
              Container(
                height: screenHeight * 0.07,
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 13, vertical: 8.0),
                child: TextField(
                  style: GoogleFonts.montserrat(fontSize: screenWidth * 0.045, color: textColor),
                  decoration: InputDecoration(
                    hintText: "Enter Phone Number",
                    border: InputBorder.none,
                    hintStyle: GoogleFonts.montserrat(color: textColor.withOpacity(0.6), fontSize: screenWidth * 0.04),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),

              // **Enter Amount Field**
              Text(
                "Enter Amount (KES)",
                style: GoogleFonts.montserrat(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500, color: textColor),
              ),
              SizedBox(height: 8),
              Container(
                height: screenHeight * 0.07,
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
                child: TextField(
                  style: GoogleFonts.montserrat(fontSize: screenWidth * 0.045, color: textColor),
                  decoration: InputDecoration(
                    hintText: "Enter Amount (KES)",
                    border: InputBorder.none,
                    hintStyle: GoogleFonts.montserrat(color: textColor.withOpacity(0.6), fontSize: screenWidth * 0.04),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),

              // **Top Up Button**
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: screenHeight * 0.07,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Top Up",
                      style: GoogleFonts.montserrat(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}