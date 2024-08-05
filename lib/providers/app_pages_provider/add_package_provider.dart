import 'dart:developer';
import 'package:fixit_provider/config.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import '../../widgets/year_dialog.dart';
import 'package:dio/dio.dart' as dio;

class AddPackageProvider with ChangeNotifier {
  TextEditingController packageCtrl = TextEditingController();
  TextEditingController hexaCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  TextEditingController amountCtrl = TextEditingController();
  TextEditingController discountCtrl = TextEditingController();
  TextEditingController disclaimerCtrl = TextEditingController();
  TextEditingController startDateCtrl = TextEditingController();
  TextEditingController endDateCtrl = TextEditingController();
  TextEditingController emptyCtrl = TextEditingController();

  FocusNode packageFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();
  FocusNode amountFocus = FocusNode();
  FocusNode discountFocus = FocusNode();
  FocusNode hexaFocus = FocusNode();
  FocusNode disclaimerFocus = FocusNode();
  FocusNode startDateFocus = FocusNode();
  FocusNode endDateFocus = FocusNode();

  Color? pickerColor;

  bool isSwitch = true, isEdit = false;
  GlobalKey<FormState> addPackageFormKey = GlobalKey<FormState>();
  DateTime? slotSelectedDay;
  DateTime slotSelectedYear = DateTime.now();
  dynamic chosenValue;
  DateTime? selectedDay;
  DateTime selectedYear = DateTime.now();
  final ValueNotifier<DateTime> focusedDay = ValueNotifier(DateTime.now());
  CalendarFormat calendarFormat = CalendarFormat.month;
  int demoInt = 0;
  PageController pageController = PageController();
  TextEditingController categoryCtrl = TextEditingController();
  RangeSelectionMode rangeSelectionMode = RangeSelectionMode
      .toggledOn; // Can be toggled on/off by longpressing a date
  DateTime? rangeStart;
  DateTime? rangeEnd;
  DateTime currentDate = DateTime.now();
  String? month, image;
  String showYear = 'Select Year';

  ServicePackageModel? servicePackageModel;

  //on back data clear
  onBack(context) {
    final value = Provider.of<SelectServiceProvider>(context, listen: false);
    isEdit = false;
    packageCtrl.text = "";
    amountCtrl.text = "";
    hexaCtrl.text = "";
    discountCtrl.text = "";
    startDateCtrl.text = "";
    endDateCtrl.text = "";
    descriptionCtrl.text = '';
    disclaimerCtrl.text = '';
    value.selectServiceList = [];
    notifyListeners();
  }

  //on back button data clear and set
  onBackButton(context) {
    final value = Provider.of<SelectServiceProvider>(context, listen: false);
    final userApi = Provider.of<UserDataApiProvider>(context, listen: false);
    userApi.getServicePackageList();
    isEdit = false;
    packageCtrl.text = "";
    amountCtrl.text = "";
    discountCtrl.text = "";
    hexaCtrl.text = "";
    startDateCtrl.text = "";
    endDateCtrl.text = "";
    descriptionCtrl.text = '';
    disclaimerCtrl.text = '';
    value.selectServiceList = [];
    notifyListeners();
    route.pop(context);
  }

  //on package delete confirmation popup
  onPackageDelete(context, sync) {
    final value = Provider.of<DeleteDialogProvider>(context, listen: false);

    value.onDeleteDialog(sync, context, eImageAssets.packageDelete,
        appFonts.deletePackages, appFonts.areYouSureDeletePackage, () {
      route.pop(context);
      value.onResetPass(
          context,
          language(context, appFonts.hurrayPackageDelete),
          language(context, appFonts.okay), () {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    });
    value.notifyListeners();
  }

  //page initialise data fetch
  onInit(context) {
    pickerColor = appColor(context).appTheme.primary;
    dynamic data = ModalRoute.of(context)!.settings.arguments ?? "";
    final value = Provider.of<SelectServiceProvider>(context, listen: false);

    if (data != "") {
      if (data["isEdit"] != "") {
        isEdit = data["isEdit"] ?? false;
      }
      if (data["data"] != null) {
        log("ARGSFDCGD :${data["data"]}");
        servicePackageModel = data['data'];
        packageCtrl.text = servicePackageModel!.title!;
        amountCtrl.text = servicePackageModel!.price!.toString();
        hexaCtrl.text = servicePackageModel!.hexaCode!;
        discountCtrl.text =
            (servicePackageModel!.discount!).toString();
        startDateCtrl.text = servicePackageModel!.startedAt!;
        endDateCtrl.text = servicePackageModel!.endedAt!;
        descriptionCtrl.text = servicePackageModel!.description!;
        disclaimerCtrl.text = servicePackageModel!.disclaimer ?? "";

        value.selectServiceList = servicePackageModel!.services!;
        isSwitch = servicePackageModel!.status == 1 ? true : false;
      }
    }
    focusedDay.value = DateTime.utc(focusedDay.value.year,
        focusedDay.value.month, focusedDay.value.day + 0);
    onDaySelected(focusedDay.value, focusedDay.value);
    DateTime dateTime = DateTime.now();
    int index = appArray.monthList
        .indexWhere((element) => element['index'] == dateTime.month);
    chosenValue = appArray.monthList[index];
    descriptionFocus.addListener(() {
      notifyListeners();
    });
    disclaimerFocus.addListener(() {
      notifyListeners();
    });
    notifyListeners();
  }

  //package active status change
  onSwitch(val) {
    isSwitch = val;
    notifyListeners();
  }

  //month selection
  onTapMonth(val) {
    month = val;
    notifyListeners();
  }

  //date range selection
  onRangeSelect(start, end, focusedDay) {
    selectedDay = null;
    currentDate = focusedDay;
    rangeStart = start;
    rangeEnd = end;
    log("STTT :$start");
    log("STTT :$rangeStart");
    log("STTT :$rangeEnd");
    rangeSelectionMode = RangeSelectionMode.toggledOn;
    startDateCtrl.text = DateFormat("dd-MM-yyyy").format(rangeStart!);
    endDateCtrl.text = rangeEnd != null ?DateFormat("dd-MM-yyyy").format(rangeEnd!) : "";
    notifyListeners();
  }

  //select year
  selectYear(context) async {
    showDialog(
        context: context,
        builder: (BuildContext context3) {
          return YearAlertDialog(
              selectedDate: selectedYear,
              onChanged: (DateTime dateTime) {
                selectedYear = dateTime;
                showYear = "${dateTime.year}";
                focusedDay.value = DateTime.utc(selectedYear.year,
                    chosenValue["index"], focusedDay.value.day + 0);
                onDaySelected(focusedDay.value, focusedDay.value);
                notifyListeners();
                route.pop(context);
                log("YEAR CHANGE : ${focusedDay.value}");
              });
        });
  }

  //right arrow button click functionality
  onRightArrow() {
    pageController.nextPage(
        duration: const Duration(microseconds: 200), curve: Curves.bounceIn);
    final newMonth = focusedDay.value.add(const Duration(days: 30));
    focusedDay.value = newMonth;
    int index = appArray.monthList
        .indexWhere((element) => element['index'] == focusedDay.value.month);
    chosenValue = appArray.monthList[index];
    selectedYear = DateTime.utc(focusedDay.value.year, focusedDay.value.month,
        focusedDay.value.day + 0);
    notifyListeners();
  }

  //left arrow button click functionality
  onLeftArrow() {
    if (focusedDay.value.month != DateTime.january ||
        focusedDay.value.year != DateTime.now().year) {
      pageController.previousPage(
          duration: const Duration(microseconds: 200), curve: Curves.bounceIn);
      final newMonth = focusedDay.value.subtract(const Duration(days: 30));
      focusedDay.value = newMonth;
      int index = appArray.monthList
          .indexWhere((element) => element['index'] == focusedDay.value.month);
      chosenValue = appArray.monthList[index];
      selectedYear = DateTime.utc(focusedDay.value.year, focusedDay.value.month,
          focusedDay.value.day + 0);
    }
    notifyListeners();
  }

  //date selection
  void onDaySelected(DateTime selectDay, DateTime fDay) {
    notifyListeners();
    focusedDay.value = selectDay;
  }

  //table calendar page change
  onPageCtrl(dayFocused) {
    focusedDay.value = dayFocused;
    demoInt = dayFocused.year;
    notifyListeners();
  }

// table calendar create
  onCalendarCreate(controller) {
    pageController = controller;
  }

  //month selection dropdown option
  onDropDownChange(choseVal) {
    notifyListeners();
    chosenValue = choseVal;

    notifyListeners();
    int index = choseVal['index'];
    focusedDay.value =
        DateTime.utc(focusedDay.value.year, index, focusedDay.value.day + 0);
    onDaySelected(focusedDay.value, focusedDay.value);
  }

  // date selection button and go to back
  onSelect(context) {
    route.pop(context);
    if (rangeEnd != null) {
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(milliseconds: 500),
          content: Text("opps!! you have not select date yet.",
              style: appCss.dmDenseMedium12
                  .textColor(appColor(context).appTheme.whiteColor)),
          backgroundColor: appColor(context).appTheme.red));
    }
    notifyListeners();
  }

  //on date select from calendar
  onDateSelect(context, date, {isStart = true}) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
              return Consumer<AddPackageProvider>(
                  builder: (context, value, child) {
                return const DateRangePickerLayout();
              });
            }));
  }

  //add data through api
  addData(context) {
    final services = Provider.of<SelectServiceProvider>(context, listen: false);
    FocusScope.of(context).requestFocus(FocusNode());
    if (addPackageFormKey.currentState!.validate()) {
      log("services.selectServiceList.length :${services.selectServiceList.length}");
      if (services.selectServiceList.isNotEmpty) {
        if (services.selectServiceList.length >= 2) {
          if (servicePackageModel != null) {
            editServicePackageApi(context, services.selectServiceList);
          } else {
            if (isSubscription) {
              if (servicePackageList.length <
                  int.parse(
                      activeSubscription!.allowedMaxServicePackages ?? "0")) {
                snackBarMessengers(context,
                    message: appFonts.addUpToServicePackage(
                        context,
                        activeSubscription!.allowedMaxServicePackages
                            .toString()));
              } else {
                snackBarMessengers(context,
                    message: language(
                        context, appFonts.youCanAddOnlyMinServicePackage));
              }
            } else {
              if (servicePackageList.length <
                  int.parse(appSettingModel!
                          .defaultCreationLimits!.allowedMaxServicePackages ??
                      "0")) {
                addServicePackageApi(context, services.selectServiceList);
              } else {
                snackBarMessengers(context,
                    message: appFonts.addUpToServiceman(
                        context,
                        activeSubscription!.allowedMaxServicePackages
                            .toString()));
              }
            }
          }
        } else {
          snackBarMessengers(context,
              message: language(context, appFonts.pleaseSelectAtLeastServices));
        }
      } else {
        snackBarMessengers(context,
            message: language(context, appFonts.pleaseSelectServices));
      }
    }
  }

  //add service package api
  addServicePackageApi(context, List serviceList) async {
    showLoading(context);
    notifyListeners();

    var body = {
      "title": packageCtrl.text,
      "hexa_code":
          hexaCtrl.text.contains("#") ? hexaCtrl.text : "#${hexaCtrl.text}",
      "provider_id": userModel!.id,
      "price": amountCtrl.text,
      "discount": discountCtrl.text.isNotEmpty ? discountCtrl.text : 0,
      "description": descriptionCtrl.text,
      "disclaimer": disclaimerCtrl.text,
      "started_at":
          DateFormat("dd-MMM-yyyy").format(DateTime.parse(startDateCtrl.text)),
      "ended_at":
          DateFormat("dd-MMM-yyyy").format(DateTime.parse(endDateCtrl.text)),
      "is_featured": "1",
      "status": isSwitch == true ? "1" : "0",
      for (var i = 0; i < serviceList.length; i++)
        "service_id[$i]": serviceList[i].id,
    };
    dio.FormData formData = dio.FormData.fromMap(body);

    log("BODY L$body");
    log("BODY L${userModel!.role!.name}");
    try {
      await apiServices
          .postApi(api.servicePackage, formData, isToken: true)
          .then((value) async {
        hideLoading(context);
        notifyListeners();
        log("SHHHH ");
        if (value.isSuccess!) {
          final userApi =
              Provider.of<UserDataApiProvider>(context, listen: false);
          await userApi.getServicePackageList();
          snackBarMessengers(context,
              message: value.message,
              color: appColor(context).appTheme.primary);

          notifyListeners();

          onBackButton(context);
        } else {
          final userApi =
              Provider.of<UserDataApiProvider>(context, listen: false);
          await userApi.getServicePackageList();

          snackBarMessengers(context,
              message: value.message, color: appColor(context).appTheme.red);
        }
      });
    } catch (e) {
      hideLoading(context);
      notifyListeners();
      snackBarMessengers(context,
          message: e.toString(), color: appColor(context).appTheme.red);
      log("EEEE addServiceman : $e");
    }
  }

//edit service package api
  editServicePackageApi(context, List serviceList) async {
    showLoading(context);
    notifyListeners();

    try {
      var body = {
        "title": packageCtrl.text,
        "hexa_code": hexaCtrl.text,
        "provider_id": userModel!.id,
        "price": amountCtrl.text,
        "discount": discountCtrl.text.isNotEmpty ? discountCtrl.text : 0,
        "description": descriptionCtrl.text,
        "disclaimer": disclaimerCtrl.text,
        "started_at": DateFormat("dd-MMM-yyyy")
            .format(DateTime.parse(startDateCtrl.text)),
        "ended_at":
            DateFormat("dd-MMM-yyyy").format(DateTime.parse(endDateCtrl.text)),
        "is_featured": "1",
        "status": isSwitch == true ? "1" : 0,
        "_method": "PUT",
        for (var i = 0; i < serviceList.length; i++)
          "service_id[$i]": serviceList[i].id,
      };
      dio.FormData formData = dio.FormData.fromMap(body);

      log("BODY L$body");
      await apiServices
          .postApi("${api.servicePackage}/${servicePackageModel!.id}", formData,
              isToken: true)
          .then((value) async {
        hideLoading(context);
        notifyListeners();
        log("SHHHH ");
        if (value.isSuccess!) {
          final userApi =
              Provider.of<UserDataApiProvider>(context, listen: false);
          await userApi.getServicePackageList();
          snackBarMessengers(context,
              message: value.message, color: appColor(context).appTheme.green);

          notifyListeners();

          onBackButton(context);
        } else {
          hideLoading(context);
          notifyListeners();
          final userApi =
              Provider.of<UserDataApiProvider>(context, listen: false);
          await userApi.getServicePackageList();
          route.pop(context);
        }
      });
    } catch (e) {
      hideLoading(context);
      notifyListeners();
      log("EEEE addServiceman : $e");
    }
  }

  showPicker(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor!,
              hexInputBar: true,
              hexInputController: hexaCtrl,
              onColorChanged: (value) {
                log("VALUE :${value.toHexString()}");
                pickerColor = value;
              },
            ),
            // Use Material color picker:
            //
            // child: MaterialPicker(
            //   pickerColor: pickerColor,
            //   onColorChanged: changeColor,
            //   showLabel: true, // only on portrait mode
            // ),
            //
            // Use Block color picker:
            //
            // child: BlockPicker(
            //   pickerColor: currentColor,
            //   onColorChanged: changeColor,
            // ),
            //
            // child: MultipleChoiceBlockPicker(
            //   pickerColors: currentColors,
            //   onColorsChanged: changeColors,
            // ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Got it'),
              onPressed: () {
                hexaCtrl.text = pickerColor!.toHexString();
  log("HEZX :${hexaCtrl.text}");
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}