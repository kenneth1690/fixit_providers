import 'dart:developer';
import 'package:fixit_provider/providers/common_providers/notification_provider.dart';

import '../../config.dart';
import '../../screens/app_pages_screens/app_setting_screen/layouts/theme_layout.dart';

class AppSettingProvider with ChangeNotifier {
  int selectIndex = 0;
  bool isNotification = true;
  final SharedPreferences sharedPreferences;

  AppSettingProvider(this.sharedPreferences);

  //fetch height
  heightMQ(context) {
    double height = MediaQuery.of(context).size.height;
    return height;
  }

  //fetch width
  widthMQ(context) {
    double width = MediaQuery.of(context).size.width;
    return width;
  }

  showLayoutTheme(context) async {
    showDialog(
      context: context,
      builder: (context1) {
        return const AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: Insets.i20),
          shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius.all(SmoothRadius(
                  cornerRadius: AppRadius.r14, cornerSmoothing: 1))),
          content: ThemeSelect(),
        );
      },
    );
  }


  // app setting list tap data
  onTapData(context, index) {
    log("dsf");
    if(index ==0){
      showLayoutTheme(context);
      // showDialog(context: context, builder: (context) => AlertDialog(content: ,),);
    }else
    if (index == 2) {
      currencyBottomSheet(context);
    } else if (index == 3) {
      route.pushNamed(context, routeName.changeLanguage);
    } else if (index == 4) {
      route.pushNamed(context, routeName.changePassword);
    }
  }


  //on notification tap
  onNotification(val,context)async {
    isNotification = val;
    sharedPreferences.setBool(session.isNotification, isNotification);
    if(isNotification) {
      CustomNotificationController().initNotification(context);
    }
    notifyListeners();
  }

  // on back function
  onBack() {
    notifyListeners();
  }

  //currency selection
  onChangeButton(index) async {
    selectIndex = index;
    notifyListeners();
  }


  //currency update
  onUpdate(context, CurrencyModel data) {
    currency(context).priceSymbol = data.symbol.toString();
    final currencyData = Provider.of<CurrencyProvider>(context, listen: false);
    currencyData.currency = data;
    currencyData.currencyVal = (data.exchangeRate!);

    currencyData.notifyListeners();

    route.pop(context);
  }

  //currency list bottom sheet
  currencyBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context2) {
        return const CurrencyBottomSheet();
      },
    );
  }
}
