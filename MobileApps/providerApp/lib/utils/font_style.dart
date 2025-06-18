import 'package:banny_table/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'constant.dart';

class AppFontStyle {

  static headerStyle(BoxConstraints constraints) {
    return TextStyle(
      color: CColor.black,
      fontSize: AppFontStyle.sizesFontManageTrackingChartWeb(1.3,constraints),
      fontFamily: Constant.fontFamilyPoppins,
      fontWeight: FontWeight.w400, /// Light
    );
  }

  /// customise style
  static styleW400(Color? color, double? fontSize) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontFamily: Constant.fontFamilyPoppins,
      fontWeight: FontWeight.w400, /// Light
    );
  }

  static styleW500(Color? color, double? fontSize) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontFamily: Constant.fontFamilyPoppins,
      fontWeight: FontWeight.w500, /// Medium
    );
  }

  static styleW600(Color? color, double? fontSize) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontFamily: Constant.fontFamilyPoppins,
      fontWeight: FontWeight.w600, /// Regular
    );
  }

  static styleW700(Color? color, double? fontSize) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontFamily: Constant.fontFamilyPoppins,
      fontWeight: FontWeight.w700, /// Bold
    );
  }

  static customizeStyle(
      {String? fontFamily, color, fontSize, fontWeight, height}) {
    return TextStyle(
      fontFamily: fontFamily,
      height: height,
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }


  static double sizesFontManageWeb( double value ,BoxConstraints constraints){
    double screenWidth = constraints.maxWidth;
    double scaleFactor = 10;
    if(screenWidth < 576){
      scaleFactor = 10.5;
    }else if(screenWidth < 768){
      scaleFactor = 12.0;
    }else if(screenWidth < 992){
      scaleFactor = 12.5;
    }else if(screenWidth < 1200){
      scaleFactor = 13.5;
    }else if(screenWidth < 1400){
      scaleFactor = 14.5;
    }else if(screenWidth > 1400){
      scaleFactor = 15.5;
    }
    return scaleFactor * value;

  }

  static double sizesFontManageHeadingWeb( double value ,BoxConstraints constraints){
    double screenWidth = constraints.maxWidth;
    double scaleFactor = 10;
    if(screenWidth < 576){
      scaleFactor = 10.5;
    }else if(screenWidth < 768){
      scaleFactor = 12.0;
    }else if(screenWidth < 992){
      scaleFactor = 12.5;
    }else if(screenWidth < 1200){
      scaleFactor = 15;
    }else if(screenWidth < 1400){
      scaleFactor = 17.5;
    }else if(screenWidth > 1400){
      scaleFactor = 17.5;
    }
    return scaleFactor * value;

  }

  static double sizesHeightManageWeb( double value ,BoxConstraints constraints){
    double screenWidth = constraints.maxHeight;
    double scaleFactor = 10;
    if(screenWidth < 576){
      scaleFactor = 10.5;
    }else if(screenWidth < 768){
      scaleFactor = 12.0;
    }else if(screenWidth < 992){
      scaleFactor = 12.5;
    }else if(screenWidth < 1200){
      scaleFactor = 13.5;
    }else if(screenWidth < 1400){
      scaleFactor = 14.5;
    }else if(screenWidth > 1400){
      scaleFactor = 15.5;
    }
    return scaleFactor * value;

  }

  static double sizesWidthManageWeb( double value ,BoxConstraints constraints){
    double screenWidth = constraints.maxWidth;
    double scaleFactor = 10;
    if(screenWidth < 576){
      scaleFactor = 10.5;
    }else if(screenWidth < 768){
      scaleFactor = 12.0;
    }else if(screenWidth < 992){
      scaleFactor = 12.5;
    }else if(screenWidth < 1200){
      scaleFactor = 13.5;
    }else if(screenWidth < 1400){
      scaleFactor = 14.5;
    }else if(screenWidth > 1400){
      scaleFactor = 15.5;
    }
    return scaleFactor * value;

  }


  static double sizesWidthManageTrackingChartWeb( double value ,BoxConstraints constraints){
    double screenWidth = constraints.maxWidth;
    double scaleFactor = 10;
    if(screenWidth < 480) {
      scaleFactor = 8.5;
    }else if(screenWidth < 576){
      scaleFactor = 10.5;
    }else if(screenWidth < 768){
      scaleFactor = 12.0;
    }else if(screenWidth < 992){
      scaleFactor = 12.5;
    }else if(screenWidth < 1200){
      scaleFactor = 13.0;
    }else if(screenWidth < 1400){
      scaleFactor = 12.5;
    }else if(screenWidth > 1400){
      scaleFactor = 12.0;
    }
    return scaleFactor * value;

  }


  static double sizesHeightTrackingChartWeb( double value ,BoxConstraints constraints){
    double screenWidth = constraints.maxHeight;
    double scaleFactor = 10;
    if(screenWidth < 576){
      scaleFactor = 10.5;
    }else if(screenWidth < 768){
      scaleFactor = 12.0;
    }else if(screenWidth < 992){
      scaleFactor = 12.5;
    }else if(screenWidth < 1200){
      scaleFactor = 13.5;
    }else if(screenWidth < 1400){
      scaleFactor = 14.5;
    }else if(screenWidth > 1400){
      scaleFactor = 15.5;
    }
    return scaleFactor * value;

  }


  static double sizesFontManageTrackingChartWeb( double value ,BoxConstraints constraints){
    double screenWidth = constraints.maxWidth;
    double scaleFactor = 10;
    if(screenWidth < 576){
      scaleFactor = 10.5;
    }else if(screenWidth < 768){
      scaleFactor = 12.0;
    }else if(screenWidth < 992){
      scaleFactor = 12.5;
    }else if(screenWidth < 1200){
      scaleFactor = 13.5;
    }else if(screenWidth < 1400){
      scaleFactor = 14.5;
    }else if(screenWidth > 1400){
      scaleFactor = 15.5;
    }
    return scaleFactor * value;

  }

  static double sizesFontManageTrackingChartBodyWeb( double value ,BoxConstraints constraints){
    double screenWidth = constraints.maxWidth;
    double scaleFactor = 10;
    if(screenWidth < 576){
      scaleFactor = 10.5;
    }else if(screenWidth < 768){
      scaleFactor = 12.0;
    }else if(screenWidth < 992){
      scaleFactor = 13.0;
    }else if(screenWidth < 1200){
      scaleFactor = 13.0;
    }else if(screenWidth < 1400){
      scaleFactor = 12.5;
    }else if(screenWidth > 1400){
      scaleFactor = 13.5;
    }
    return scaleFactor * value;

  }



  static double commonHeightForTrackingChartWeb(BoxConstraints constraints){
    return AppFontStyle.sizesHeightTrackingChartWeb(6.5, constraints);
  }

  static double commonHeightForTrackingChartBodyWeb(BoxConstraints constraints){
    return AppFontStyle.sizesHeightTrackingChartWeb(5.0, constraints);
  }

  static double commonFontSizeBodyWeb(BoxConstraints constraints){
    return AppFontStyle.sizesFontManageTrackingChartBodyWeb(1.2, constraints);
  }

  static double commonFontHeader(BoxConstraints constraints){
    return AppFontStyle.sizesWidthManageWeb(2.4,constraints);
  }

  static double commonFontHeaderSecond(BoxConstraints constraints){
    return AppFontStyle.sizesWidthManageWeb(1.6,constraints);
  }


}
