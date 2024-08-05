import 'dart:developer';
import 'package:fixit_provider/config.dart';

class AcceptedBookingProvider with ChangeNotifier {
  BookingModel? bookingModel;
  int selectIndex = 0;
  List statusList = [];
  String amount = "0", id = '';
  bool? isAssign = false;

  TextEditingController amountCtrl = TextEditingController();

  FocusNode amountFocus = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  onReady(context) {
    selectIndex =0;
    dynamic data = ModalRoute.of(context)!.settings.arguments ?? "";
    if (isFreelancer != true) {
      /*  if(data != ""){
        amount = data["amount"] ?? "0";
        isAssign = data["assign_me"] ?? false;
      }*/
    }

    id = data.toString();

    notifyListeners();
    getBookingDetailById(context, id);
  }

  onServicemenChange(index) {
    selectIndex = index;
    notifyListeners();
  }

  onAssignTap(context) {
    if ((bookingModel!.requiredServicemen ?? 1) > 1) {
      route.pushNamed(context, routeName.bookingServicemenList, arg: {
        "servicemen": bookingModel!.requiredServicemen ?? 1,
        "data": bookingModel!
      }).then((e) {
        log("ee onAssignTap:$e");
        if (e != null) {
          List<ServicemanModel> serMan = e;
          List ids = [];
          for (var d in serMan) {
            ids.add(d.id);
          }

          log("SSS :$ids");
         assignServiceman(context, ids,isDirectBack: true);
        }
      });
    } else {
      //
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context1) {
            return SelectServicemenSheet(
                arguments:bookingModel!.requiredServicemen ?? 1);
          });
    }
  }

  onTapContinue(context, arguments) {
    if (selectIndex == 0) {
      showDialog(
          context: context,
          builder: (context1) => AppAlertDialogCommon(
              height: Sizes.s145,
              title: appFonts.assignToMe,
              firstBText: appFonts.cancel,
              secondBText: appFonts.yes,
              image: eImageAssets.assignMe,
              subtext: appFonts.areYouSureYourself,
              secondBTap: () {

                 assignServiceman(context, [userModel!.id]);
              },
              firstBTap: () {
                route.pop(context);
                route.pop(context);
              }));
    } else {
      log("ARGSSSSMGVHF $arguments");
      route.pushNamed(context, routeName.bookingServicemenList,
          arg: {"servicemen": arguments, "data": bookingModel!}).then((e) {
        log("ee onTapContinue:$bookingModel");
        if (e != null) {
          List<ServicemanModel> serMan = e;
          List ids = [];
          for (var d in serMan) {
            ids.add(d.id);
          }

          log("SSS :$ids");
          assignServiceman(context, ids);
        }
      });
    }
  }

  //assign serviceman
  assignServiceman(context, List val,{isDirectBack= false}) async {
    try {
      await getBookingDetailById(context, id);
      showLoading(context);
      notifyListeners();

      var body = {"booking_id": bookingModel!.id, "servicemen_ids": val};
      log("ASSSIGN BODY : $body");
      await apiServices
          .postApi(api.assignBooking, body, isToken: true)
          .then((value) {
        hideLoading(context);

        notifyListeners();
        if (value.isSuccess!) {
          final common =
              Provider.of<UserDataApiProvider>(context, listen: false);
          common.getBookingHistory(context);
          if(isDirectBack){
            BookingModel book = bookingModel!;
            route.pop(context);

            route.pushNamed(context, routeName.assignBooking, arg: book.id);
          }else {
            if (selectIndex == 0) {
              BookingModel book = bookingModel!;
              route.pop(context);
              route.pop(context);
              route.pop(context);
              route.pushNamed(context, routeName.assignBooking, arg: book.id);
            } else {
              BookingModel book = bookingModel!;
              route.pop(context);
              route.pop(context);

              route.pushNamed(context, routeName.assignBooking, arg: book.id);
            }
          }
        } else {
          route.pop(context);
          route.pop(context);
          snackBarMessengers(context,
              color: appColor(context).appTheme.red, message: value.message);
        }
      });
    } catch (e) {
      hideLoading(context);
      notifyListeners();
      log("EEEE assignServiceman : $e");
    }
  }

  onBack(context, isBack) {
    bookingModel = null;
    notifyListeners();
    if (isBack) {
      route.pop(context);
    }
  }

  onRefresh(context) async {
    showLoading(context);
    notifyListeners();
    await getBookingDetailById(context, bookingModel!.id);
    hideLoading(context);
    notifyListeners();
  }

  //booking detail by id
  getBookingDetailById(context, id) async {
    try {
      await apiServices
          .getApi("${api.booking}/$id", [], isToken: true, isData: true)
          .then((value) {
        if (value.isSuccess!) {
          log("DHRUVU :${value.data}");
          notifyListeners();
          bookingModel = BookingModel.fromJson(value.data);
          notifyListeners();
        } else {
          notifyListeners();
        }
      });
    } catch (e) {
      notifyListeners();
    }
  }
}
