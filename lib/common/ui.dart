import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' hide OnTap;
import 'package:get/get.dart';

import '../app/services/settings_service.dart';

class Ui {
  static GetSnackBar SuccessSnackBar(
      {String title = 'Success', String message}) {
    Get.log("[$title] $message");
    return GetSnackBar(
      // titleText: Text(title.tr,
      //     style: Get.textTheme.headline6
      //         .merge(TextStyle(color: Get.theme.primaryColor))),
      messageText: Center(
        child: Text(message,
            style: Get.textTheme.bodyMedium
                .merge(TextStyle(color: Get.theme.primaryColor))),
      ),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(20),
      backgroundColor: Get.theme.colorScheme.secondary,
      // icon: Icon(Icons.check_circle_outline,
      //     size: 25, color: Get.theme.primaryColor),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      borderRadius: 30,
      dismissDirection: DismissDirection.horizontal,
      duration: const Duration(seconds: 2),
    );
  }

  static GetSnackBar ErrorSnackBar({String title = 'Error', String message}) {
    Get.log("[$title] $message", isError: true);
    return GetSnackBar(
      // titleText: Text(title.tr,
      //     style: Get.textTheme.headline6
      //         .merge(TextStyle(color: Get.theme.primaryColor))),
      messageText: Center(
        child: Text(message.substring(0, min(message.length, 200)),
            style: Get.textTheme.bodyMedium
                .merge(TextStyle(color:Get.theme.primaryColor))),
      ),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(20),
      backgroundColor: Get.theme.colorScheme.secondary,
      // icon: Icon(Icons.remove_circle_outline,
      //     size: 25, color: Get.theme.primaryColor),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      borderRadius: 30,
      duration: const Duration(seconds: 2),
    );
  }

  static GetSnackBar defaultSnackBar({String title = 'Alert', String message}) {
    Get.log("[$title] $message", isError: false);
    return GetSnackBar(
      // titleText: Text(title.tr,
      //     style: Get.textTheme.headline6
      //         .merge(TextStyle(color: Get.theme.hintColor))),
      messageText: Center(
        child: Text(message,
            style: Get.textTheme.bodyMedium
                .merge(TextStyle(color: Get.theme.primaryColor))),
      ),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(20),
      backgroundColor:Get.theme.colorScheme.secondary,
      // borderColor: Get.theme.focusColor.withOpacity(0.1),
      // icon: Icon(Icons.warning_amber_rounded,
      //     size: 25, color: Get.theme.hintColor),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      borderRadius: 30,
      duration: const Duration(seconds: 2),
    );
  }

  static GetSnackBar notificationSnackBar(
      {String title = 'اشعار',
        String message,
        OnTap onTap,
        Widget mainButton}) {
    Get.log("[$title] $message", isError: false);
    return GetSnackBar(
      onTap: onTap,
      mainButton: mainButton,
      // titleText: Text(title.tr,
      //     style: Get.textTheme.headline6
      //         .merge(TextStyle(color: Get.theme.hintColor))),
      messageText: Center(
        child: Text(message,
            style: Get.textTheme.bodyMedium
                .merge(TextStyle(color: Get.theme.primaryColor))),
      ),
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(20),
      backgroundColor: Get.theme.colorScheme.secondary,
      // borderColor: Get.theme.colorScheme.secondary,
      // icon:
      // Icon(Icons.notifications_none, size: 25, color: Get.theme.hintColor),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      borderRadius: 30,
      duration: const Duration(seconds: 2),
    );
  }

  static Color parseColor(String hexCode, {double opacity}) {
    try {
      return Color(int.parse(hexCode.replaceAll("#", "0xFF")))
          .withOpacity(opacity ?? 1);
    } catch (e) {
      return const Color(0xFFCCCCCC).withOpacity(opacity ?? 1);
    }
  }

  static List<Icon> getStarsList(double rate, {double size = 18}) {
    var list = <Icon>[];
    list = List.generate(rate.floor(), (index) {
      return Icon(Icons.star, size: size, color: Get.theme.colorScheme.secondary);
    });
    if (rate - rate.floor() > 0) {
      list.add(Icon(Icons.star_half, size: size, color:Get.theme.colorScheme.secondary));
    }
    list.addAll(
        List.generate(5 - rate.floor() - (rate - rate.floor()).ceil(), (index) {
          return Icon(Icons.star_border, size: size, color: Get.theme.colorScheme.secondary);
        }));
    return list;
  }

  static Widget getPrice(double myPrice,
      {TextStyle style, String zeroPlaceholder = '-', String unit,bool noUnit=true}) {
    var _setting = Get.find<SettingsService>();
    if (style != null) {
      style = style.merge(TextStyle(fontSize: style.fontSize + 2));
    }
    try {
      if (myPrice == 0) {
        return Text('0', style: style ?? Get.textTheme.subtitle2);
      }
      return RichText(
        softWrap: false,
        overflow: TextOverflow.fade,
        maxLines: 1,
        text: _setting.setting.value.currencyRight != null &&
            _setting.setting.value?.currencyRight == false
            ? TextSpan(
          text: _setting.setting.value?.defaultCurrency,
          style: getPriceStyle(style),
          children: <TextSpan>[
            if (noUnit == true )
              TextSpan(
                  text: myPrice.toStringAsFixed(_setting.setting.value?.defaultCurrencyDecimalDigits) ??
                      '',
                  style: style ?? Get.textTheme.subtitle2),
            if (unit != null )
              TextSpan(text: " $unit ", style: getPriceStyle(style)),
          ],
        )
            : TextSpan(
          text: "${myPrice.toStringAsFixed(_setting.setting.value?.defaultCurrencyDecimalDigits)} " ??
              '',
          style: style ?? Get.textTheme.subtitle2,
          children: <TextSpan>[
            if (noUnit == true )
              TextSpan(
                  text: _setting.setting.value?.defaultCurrency,
                  style: getPriceStyle(style)),
            if (unit != null)
              TextSpan(text: " $unit ", style: getPriceStyle(style)),
          ],
        ),
      );
    } catch (e) {
      return const Text('');
    }
  }

  static TextStyle getPriceStyle(TextStyle style) {
    if (style == null) {
      return Get.textTheme.subtitle2.merge(
        TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: Get.textTheme.subtitle2.fontSize - 4),
      );
    } else {
      return style.merge(
          TextStyle(fontWeight: FontWeight.w300, fontSize: style.fontSize - 4));
    }
  }

  static BoxDecoration getBoxDecoration(
      {Color color, double radius, Border border, Gradient gradient}) {
    return BoxDecoration(
      color: color ?? Get.theme.primaryColor,
      borderRadius: BorderRadius.all(Radius.circular(radius ?? 10)),
      boxShadow: [
        BoxShadow(
            color: Get.theme.focusColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5)),
      ],
      border:
      border ?? Border.all(color: Get.theme.focusColor.withOpacity(0.05)),
      gradient: gradient,
    );
  }

  static InputDecoration getInputDecoration(
      {String hintText = '',
        String errorText,
        IconData iconData,
        Widget suffixIcon,
        Widget suffix}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: Get.textTheme.caption,
      prefixIcon: iconData != null
          ? Icon(iconData, color: Get.theme.focusColor).marginOnly(right: 14)
          : const SizedBox(),
      prefixIconConstraints: iconData != null
          ? const BoxConstraints.expand(width: 38, height: 38)
          : const BoxConstraints.expand(width: 0, height: 0),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      contentPadding: const EdgeInsets.all(0),
      border: const OutlineInputBorder(borderSide: BorderSide.none),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
      enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
      suffixIcon: suffixIcon,
      suffix: suffix,
      errorText: errorText,
    );
  }

  static Html applyHtml(String html,
      {TextStyle style,
        TextAlign textAlign,
        Alignment alignment = Alignment.centerLeft}) {
    CustomRenderMatcher pMatcher() =>
            (context) => context.tree.element?.localName == "p";
    return Html(
      data: html.replaceAll('\r\n', '') ?? '',
      customRenders: {
        pMatcher(): CustomRender.widget(widget: (context, child) {
          return Text(
            context.tree.element.text,
            textAlign: textAlign,
            style: style == null
                ? Get.textTheme.bodyText1.merge(const TextStyle(fontSize: 11))
                : style.merge(const TextStyle(fontSize: 11)),
          );
        }),
      },
      style: {
        "*": Style(
          textAlign: textAlign,
          alignment: alignment,
          color: style == null ? Get.theme.hintColor : style.color,
          fontSize: style == null ? FontSize(16.0) : FontSize(style.fontSize),
          display: Display.inlineBlock,
          fontWeight: style == null ? FontWeight.w300 : style.fontWeight,
          width: Width.auto(),
        ),
        "li": Style(
          textAlign: textAlign,
          lineHeight: LineHeight.normal,
          listStylePosition: ListStylePosition.outside,
          fontSize: style == null ? FontSize(14.0) : FontSize(style.fontSize),
          display: Display.block,
        ),
        "h4,h5,h6": Style(
          textAlign: textAlign,
          fontSize:
          style == null ? FontSize(16.0) : FontSize(style.fontSize + 2),
        ),
        "h1,h2,h3": Style(
          textAlign: textAlign,
          lineHeight: LineHeight.number(2),
          fontSize:
          style == null ? FontSize(18.0) : FontSize(style.fontSize + 4),
        ),
        "br": Style(
          height: Height.auto(),
        ),
      },
    );
  }

  static BoxFit getBoxFit(String boxFit) {
    switch (boxFit) {
      case 'cover':
        return BoxFit.cover;
      case 'fill':
        return BoxFit.fill;
      case 'contain':
        return BoxFit.contain;
      case 'fit_height':
        return BoxFit.fitHeight;
      case 'fit_width':
        return BoxFit.fitWidth;
      case 'none':
        return BoxFit.none;
      case 'scale_down':
        return BoxFit.scaleDown;
      default:
        return BoxFit.cover;
    }
  }

  static Html removeHtml(String html,
      {TextStyle style,
        TextAlign textAlign,
        Alignment alignment = Alignment.centerLeft}) {
    CustomRenderMatcher pMatcher() =>
            (context) => context.tree.element?.localName == "p";
    return Html(
      data: html.replaceAll('\r\n', '') ?? '',
      customRenders: {
        pMatcher(): CustomRender.widget(widget: (context, child) {
          return Text(
            context.tree.element.text,
            textAlign: textAlign,
            style: style == null
                ? Get.textTheme.bodyText1.merge(const TextStyle(fontSize: 11))
                : style.merge(const TextStyle(fontSize: 11)),
          );
        }),
      },
      style: {
        "*": Style(
          textAlign: textAlign,
          alignment: alignment,
          color: style == null ? Get.theme.hintColor : style.color,
          fontSize: style == null ? FontSize(11.0) : FontSize(style.fontSize),
          display: Display.inlineBlock,
          fontWeight: style == null ? FontWeight.w300 : style.fontWeight,
          width: Width.auto(),
        ),
        "br": Style(
          height: Height.auto(),
        ),
      },
    );
  }

  static AlignmentDirectional getAlignmentDirectional(
      String alignmentDirectional) {
    switch (alignmentDirectional) {
      case 'top_start':
        return AlignmentDirectional.topStart;
      case 'top_center':
        return AlignmentDirectional.topCenter;
      case 'top_end':
        return AlignmentDirectional.topEnd;
      case 'center_start':
        return AlignmentDirectional.centerStart;
      case 'center':
        return AlignmentDirectional.topCenter;
      case 'center_end':
        return AlignmentDirectional.centerEnd;
      case 'bottom_start':
        return AlignmentDirectional.bottomStart;
      case 'bottom_center':
        return AlignmentDirectional.bottomCenter;
      case 'bottom_end':
        return AlignmentDirectional.bottomEnd;
      default:
        return AlignmentDirectional.bottomEnd;
    }
  }

  static CrossAxisAlignment getCrossAxisAlignment(String textPosition) {
    switch (textPosition) {
      case 'top_start':
        return CrossAxisAlignment.start;
      case 'top_center':
        return CrossAxisAlignment.center;
      case 'top_end':
        return CrossAxisAlignment.end;
      case 'center_start':
        return CrossAxisAlignment.center;
      case 'center':
        return CrossAxisAlignment.center;
      case 'center_end':
        return CrossAxisAlignment.center;
      case 'bottom_start':
        return CrossAxisAlignment.start;
      case 'bottom_center':
        return CrossAxisAlignment.center;
      case 'bottom_end':
        return CrossAxisAlignment.end;
      default:
        return CrossAxisAlignment.start;
    }
  }

  static bool isDesktop(BoxConstraints constraint) {
    return constraint.maxWidth >= 1280;
  }

  static bool isTablet(BoxConstraints constraint) {
    return constraint.maxWidth >= 768 && constraint.maxWidth <= 1280;
  }

  static bool isMobile(BoxConstraints constraint) {
    return constraint.maxWidth < 768;
  }

  static double col12(BoxConstraints constraint,
      {double desktopWidth = 1280,
        double tabletWidth = 768,
        double mobileWidth = 480}) {
    if (isMobile(constraint)) {
      return mobileWidth;
    } else if (isTablet(constraint)) {
      return tabletWidth;
    } else {
      return desktopWidth;
    }
  }

  static double col9(BoxConstraints constraint,
      {double desktopWidth = 1280,
        double tabletWidth = 768,
        double mobileWidth = 480}) {
    if (isMobile(constraint)) {
      return mobileWidth * 3 / 4;
    } else if (isTablet(constraint)) {
      return tabletWidth * 3 / 4;
    } else {
      return desktopWidth * 3 / 4;
    }
  }

  static double col8(BoxConstraints constraint,
      {double desktopWidth = 1280,
        double tabletWidth = 768,
        double mobileWidth = 480}) {
    if (isMobile(constraint)) {
      return mobileWidth * 2 / 3;
    } else if (isTablet(constraint)) {
      return tabletWidth * 2 / 3;
    } else {
      return desktopWidth * 2 / 3;
    }
  }

  static double col6(BoxConstraints constraint,
      {double desktopWidth = 1280,
        double tabletWidth = 768,
        double mobileWidth = 480}) {
    if (isMobile(constraint)) {
      return mobileWidth / 2;
    } else if (isTablet(constraint)) {
      return tabletWidth / 2;
    } else {
      return desktopWidth / 2;
    }
  }

  static double col4(BoxConstraints constraint,
      {double desktopWidth = 1280,
        double tabletWidth = 768,
        double mobileWidth = 480}) {
    if (isMobile(constraint)) {
      return mobileWidth * 1 / 3;
    } else if (isTablet(constraint)) {
      return tabletWidth * 1 / 3;
    } else {
      return desktopWidth * 1 / 3;
    }
  }

  static double col3(BoxConstraints constraint,
      {double desktopWidth = 1280,
        double tabletWidth = 768,
        double mobileWidth = 480}) {
    if (isMobile(constraint)) {
      return mobileWidth * 1 / 4;
    } else if (isTablet(constraint)) {
      return tabletWidth * 1 / 4;
    } else {
      return desktopWidth * 1 / 4;
    }
  }
}

class indicatorAdasa extends StatelessWidget {
  const indicatorAdasa({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(top: 200),
        child: SizedBox(
          height: 50,
          width: 50,
          child: CircularProgressIndicator.adaptive(
            // axisDirection: AxisDirection.down,
            // color: kSpecialColor,
            // backgroundColor: kSpecialColor,
          ),
        ),
      ),
    );
  }
}
