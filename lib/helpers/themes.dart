import 'package:flutter/material.dart';

//COLOR
const Color primaryColor = Color(0xff2C96F1);
const Color whiteColor = Color(0xffffffff);
const Color redColor = Color(0xffFF0000);
const Color primaryTextColor = Color(0xff1b1b1c);
const Color softGreyColor = Color(0xFFaaaaaa);
const Color greyColor = Color(0xFF515151);
const Color lightgreyColor = Color(0xff777777);

//Margins
const double defaultMargin = 20.0;

//FONT STYLES
TextStyle primaryTextStyle =
    const TextStyle(color: primaryTextColor, fontSize: 16);

TextStyle primaryBigTextStyle =
    const TextStyle(color: primaryTextColor, fontSize: 22);

TextStyle sectionTitle = const TextStyle(
    color: primaryTextColor, fontSize: 16, fontWeight: FontWeight.bold);

TextStyle productTotalReview = const TextStyle(
    color: softGreyColor, fontSize: 11, fontWeight: FontWeight.bold);

TextStyle productTotalReviewLight =
    const TextStyle(color: softGreyColor, fontSize: 11);

TextStyle productName = const TextStyle(color: greyColor, fontSize: 12);

TextStyle productPrice = const TextStyle(
    color: primaryTextColor, fontSize: 13, fontWeight: FontWeight.bold);

TextStyle productSale = const TextStyle(color: softGreyColor, fontSize: 11);

TextStyle buttonTextStyle = const TextStyle(
    color: primaryColor, fontSize: 18, fontWeight: FontWeight.w600);
