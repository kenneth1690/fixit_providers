import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../../config.dart';

class ResetPasswordProvider extends ChangeNotifier {
  TextEditingController txtNewPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();
  GlobalKey<FormState> resetFormKey = GlobalKey<FormState>();
  bool isNewPassword = true, isConfirmPassword = true;
  String? email, otp;
  Future<ui.Image>? loadingImage;
  final FocusNode passwordFocus = FocusNode();
  final FocusNode confirmPasswordFocus = FocusNode();

  double slider = 4.0;

  //new password see tap
  newPasswordSeenTap() {
    isNewPassword = !isNewPassword;
    notifyListeners();
  }

  //confirm password see tap
  confirmPasswordSeenTap() {
    isConfirmPassword = !isConfirmPassword;
    notifyListeners();
  }

  //rest password Api
  resetPassword(context) async {
    route.pop(context);
    if (resetFormKey.currentState!.validate()) {
      showLoading(context);
      notifyListeners();

      var body = {
        "password": txtNewPassword.text,
        "password_confirmation": txtConfirmPassword.text,
        "otp": otp,
        "email": email
      };

      try {
        await apiServices
            .postApi(api.updatePassword, jsonEncode(body))
            .then((value) {
          hideLoading(context);
          notifyListeners();
          if (value.isSuccess!) {
            showCupertinoDialog(
                context: context,
                builder: (context1) {
                  return AlertDialogCommon(
                      title: appFonts.successfullyChanged,
                      height: Sizes.s140,
                      image: eGifAssets.successGif,
                      subtext: language(context, appFonts.thankYou),
                      bText1: language(context, appFonts.loginAgain),
                      b1OnTap: () {
                        txtNewPassword.text = "";
                        txtConfirmPassword.text = "";
                        notifyListeners();

                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    MultiProvider(providers: [
                                      ChangeNotifierProvider(
                                          create: (_) =>
                                              LoginAsServicemanProvider()),
                                      ChangeNotifierProvider(
                                          create: (_) => LoginAsProvider()),
                                      ChangeNotifierProvider(
                                          create: (_) =>
                                              ForgetPasswordProvider()),
                                      ChangeNotifierProvider(
                                          create: (_) => VerifyOtpProvider()),
                                    ], child: const IntroScreen())),
                            ModalRoute.withName(routeName.intro));
                      });
                });
          } else {
            hideLoading(context);
            snackBarMessengers(context,
                message: value.message, color: appColor(context).appTheme.red);
          }
        });
      } catch (e) {
        hideLoading(context);
        notifyListeners();
      }
    }
  }

  getArg(context) {
    dynamic data = ModalRoute.of(context)!.settings.arguments;
    email = data['email'];
    otp = data['otp'];
    notifyListeners();
  }

}