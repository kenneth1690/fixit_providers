import 'dart:developer';
import 'package:fixit_provider/screens/app_pages_screens/add_new_service_screen/layouts/add_faq.dart';
import 'package:http_parser/http_parser.dart' as http;
import 'package:http/http.dart' as https;
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:fixit_provider/config.dart';
import 'package:fixit_provider/screens/app_pages_screens/add_new_service_screen/layouts/category_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import 'package:mime/mime.dart' as mime;

class AddNewServiceProvider with ChangeNotifier {
  CategoryModel? categoryValue;
  CategoryModel? subCategoryValue;
  Services? services;
  List faqList = [];
  List<ServiceFaqModel> serviceFaq = [];
  List<CategoryModel> newCategoryList = [];

  List<CategoryModel> categories = [], newCatList = [];
  String? durationValue;
  int selectIndex = 0, selected = -1;
  int? taxIndex;
  bool isSwitch = true, isEdit = false;
  final multiSelectKey = GlobalKey<FormFieldState>();
  TextEditingController filterSearchCtrl = TextEditingController();
  final FocusNode filterSearchFocus = FocusNode();

  String argData = 'NULL';
  List<CategoryModel> subCategory = [];
  String commission = "";

  TextEditingController serviceName = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController duration = TextEditingController();
  TextEditingController availableService = TextEditingController();
  TextEditingController minRequired = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController discount = TextEditingController();
  TextEditingController tax = TextEditingController();


  FocusNode serviceNameFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();
  FocusNode durationFocus = FocusNode();
  FocusNode availableServiceFocus = FocusNode();
  FocusNode minRequiredFocus = FocusNode();
  FocusNode amountFocus = FocusNode();
  FocusNode discountFocus = FocusNode();
  FocusNode taxFocus = FocusNode();

  XFile? imageFile, thumbFile;
  GlobalKey<FormState> addServiceFormKey = GlobalKey<FormState>();
  String? thumbImage;
  List image = [];

  // on page initialise data fetch
  onReady(context) async {
    // TODO: implement initState
    log("dfn");
    final allUserApi = Provider.of<UserDataApiProvider>(context, listen: false);
    allUserApi.commonCallApi(context);
    final all = Provider.of<CommonApiProvider>(context, listen: false);
    all.commonApi(context);
    dynamic data = ModalRoute.of(context)!.settings.arguments ?? "";
    newCatList = allCategoryList;


    descriptionFocus.addListener(() {
      notifyListeners();
    });

    if (data != "") {
      isEdit = data["isEdit"] ?? false;
      services = data['service'];
      if (data['serviceFaq'] != null) {
        serviceFaq = serviceFaq;
      } else {
        await getServiceFaqId(context, services!.id);
      }

      serviceName.text = services!.title!;
      log("services!.categories :${services!.categories}");
      if (services!.categories != null) {
        services!.categories!.asMap().entries.forEach((element) {
          /* ValueItem<int> valueItem =
              ValueItem(label: element.value.title!, value: element.value.id);
*/
          if (!categories.contains(element.value)) {
            categories.add(element.value);
          }
          notifyListeners();
        });
      }

      categories.asMap().entries.forEach((e) {
        int index =
            allCategoryList.indexWhere((element) => element.id == e.value.id);
        if (index >= 0) {
          newCategoryList.add(allCategoryList[index]);
        }
      });
      for (var d in serviceFaq) {
        var a = {
          'question': d.question,
          'answer': d.answer,
        };
        faqList.add(a);
      }
      notifyListeners();
      if (newCategoryList.isNotEmpty) {
        var largestGeekValue = newCategoryList.reduce((current, next) =>
            double.parse(current.commission!.toString()) > double.parse(next.commission!.toString())
                ? current
                : next);

        commission = largestGeekValue.commission!.toString();
      } else {
        commission = "0.0";
      }

      log("services!.serviceAvailabilities  :${services!.serviceAvailabilities}");

      selectIndex =
          services!.discount != null && services!.discount != "0.00" ? 1 : 0;
      description.text = services!.description ?? "";


      discount.text =
          (services!.discount!).toStringAsFixed(0).toString();
      duration.text = services!.duration!;
      log("services!.durationUnit! :${services!.durationUnit!}");
      if (services!.durationUnit == "hour") {
        durationValue = capitalizeFirstLetter(services!.durationUnit == "hour"
            ? "hours"
            : services!.durationUnit!);
      } else {
        durationValue = capitalizeFirstLetter(services!.durationUnit == "minute"
            ? "minutes"
            : services!.durationUnit!);
      }
      minRequired.text = services!.requiredServicemen != null ? services!.requiredServicemen.toString() :"1";
      amount.text = services!.price!.toString();

      int taxVal = taxList
          .indexWhere((element) => element.id.toString() == services!.taxId.toString());
      if (taxVal >= 0) {
        taxIndex = int.parse(services!.taxId!.toString());
      }
      isSwitch = services!.status == "1" ? true : false;

      if (services!.media != null && services!.media!.isNotEmpty) {
        for (var d in services!.media!) {
          log("d.collectionName :${d.collectionName}");
          if (d.collectionName == "thumbnail") {
            thumbImage = d.originalUrl!;
          }
        }
      }
      notifyListeners();
    } else {
      taxIndex = null;
      faqList = [];
    }
  }

  getServiceFaqId(context, serviceId) async {
    try {
      await apiServices
          .getApi("${api.serviceFaq}?service_id=$serviceId", [],
              isData: true, isMessage: false)
          .then((value) {
        if (value.isSuccess!) {
          for (var d in value.data) {
            if (!serviceFaq.contains(ServiceFaqModel.fromJson(d))) {
              serviceFaq.add(ServiceFaqModel.fromJson(d));
            }
          }
          log("serviceFaq :${serviceFaq.length}");
          notifyListeners();
        } else {
          notifyListeners();
        }
      });
    } catch (e) {
      log("ERRROEEE getServiceFaqId : $e");
      notifyListeners();
    }
  }

  //add faq
  addFaq(context) {
    route.push(context, AddFaq(faqList: faqList)).then((e) {
      if (e != null) {
        faqList = e;
      }
      notifyListeners();
    });
  }

  onExpansionChange(newState, index) {
    log("dghfdkg:$newState");
    if (newState) {
      const Duration(seconds: 20000);
      selected = index;
      notifyListeners();
    } else {
      selected = -1;
      notifyListeners();
    }
  }

  //category list
  getCategory({search}) async {
    // notifyListeners();
    try {
      String apiUrl = "${api.category}?providerId=${userModel!.id}";
      if (search != null) {
        apiUrl = "${api.category}?providerId=${userModel!.id}&search=$search";
      } else {
        apiUrl = "${api.category}?providerId=${userModel!.id}";
      }
      await apiServices.getApi(apiUrl, []).then((value) {
        newCatList = [];
        if (value.isSuccess!) {
          List category = value.data;
          for (var data in category.reversed.toList()) {
            if (!newCatList.contains(CategoryModel.fromJson(data))) {
              newCatList.add(CategoryModel.fromJson(data));
            }
            notifyListeners();
          }
        }
      });
    } catch (e) {
      notifyListeners();
    }
  }

  onBottomSheet(context) {
    newCatList = allCategoryList;
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return const CategoryBottomSheet();
      },
    );
  }

  //on back data clear
  onBack(isBack) {
    isEdit = false;
    image = [];
    faqList = [];
    serviceFaq = [];
    services = null;
    thumbImage = null;

    categories = [];
    filterSearchCtrl.text = "";
    appArray.serviceImageList = [];
    categories = [];
    newCatList = [];
    newCategoryList = [];
    serviceName.text = "";
    thumbFile = null;
    imageFile = null;
    categoryValue = null;
    subCategoryValue = null;
    description.text = "";
    duration.text = "";
    availableService.text = "";
    minRequired.text = "";
    discount.text ="";
    selectIndex = 0;
    amount.text = "";
    taxIndex = null;

    isSwitch = false;

    taxIndex = null;
    durationValue = null;
    imageFile = null;
    thumbFile = null;
    image = [];

    appArray.serviceImageList = [];

    description.text = "";
    categories = [];
    notifyListeners();
  }

  //on back button data clear
  onBackButton(context) {
    route.pop(context);
    isEdit = false;
    image = [];
    thumbImage = "";
    serviceName.text = "";
    categoryValue = null;
    subCategoryValue = null;
    description.text = "";
    duration.text = "";
    availableService.text = "";
    minRequired.text = "";
    amount.text = "";
    taxIndex = null;

    isSwitch = false;

    notifyListeners();
  }

  //updateInformation
  void updateInformation(information) {
    argData = information;
    notifyListeners();
  }

  //on available service tap
  onAvailableServiceTap(context) async {
    var result = await route.push(context, const LocationListScreen());
    availableService.text = result;
    notifyListeners();
  }

  // GET IMAGE FROM GALLERY
  Future getImage(context, source, isThumbnail) async {
    final ImagePicker picker = ImagePicker();
    if (isThumbnail) {
      route.pop(context);
      thumbFile = (await picker.pickImage(source: source, imageQuality: 70))!;
    } else {
      route.pop(context);
      imageFile = (await picker.pickImage(source: source, imageQuality: 70))!;
      appArray.serviceImageList.add(imageFile!);
      notifyListeners();
    }
    notifyListeners();
  }

  //on image pick
  onImagePick(context, isThumbnail) {
    showLayout(context, onTap: (index) {
      if (index == 0) {
        if (isThumbnail) {
          getImage(context, ImageSource.gallery, isThumbnail);
        } else {
          getImage(context, ImageSource.gallery, isThumbnail);
        }
        notifyListeners();
      } else {
        if (isThumbnail) {
          getImage(context, ImageSource.camera, isThumbnail);
        } else {
          getImage(context, ImageSource.camera, isThumbnail);
        }
        notifyListeners();
      }
    });
  }

  // on remove service image
  onRemoveServiceImage(isThumbnail, {index}) {
    if (isThumbnail) {
      thumbFile = null;
      thumbImage = null;
      notifyListeners();
    } else {
      appArray.serviceImageList.removeAt(index);
      notifyListeners();
    }
  }

  onRemoveNetworkServiceImage(isThumbnail, {index}) {
    if (isThumbnail) {
      thumbFile = null;
      thumbImage = null;
      notifyListeners();
    } else {
      services!.media!.removeAt(index);
      notifyListeners();
    }
  }

  //service available switch
  onTapSwitch(val) {
    isSwitch = val;
    notifyListeners();
  }

  // tax selection
  onChangeTax(index) {
    log("indtaxIndexex :$index");
    taxIndex = index;
    notifyListeners();
  }

  //price change
  onChangePrice(index) {
    selectIndex = index;
    notifyListeners();
  }

  //category selection
  onChangeCategory(CategoryModel val, id) {
    newCategoryList = [];
    //categories = val;
    if (!categories.contains(val)) {
      log("val.parentId:: ${val.parentId}");
      if (val.parentId != null) {
        int index = newCatList.indexWhere(
            (element) => element.id.toString() == val.parentId.toString());
        if (index >= 0) {
          if (!categories.contains(newCatList[index])) {
            categories.add(newCatList[index]);
          }
        }
      }
      categories.add(val);
    } else {
      categories.remove(val);
    }

    notifyListeners();
    categories.asMap().entries.forEach((e) {
      int index =
          allCategoryList.indexWhere((element) => element.id == e.value.id);
      if (index >= 0) {
        newCategoryList.add(allCategoryList[index]);
      }
    });
    // notifyListeners();
    if (newCategoryList.isNotEmpty) {
      var largestGeekValue = newCategoryList.reduce((current, next) =>
          double.parse(current.commission!.toString()) > double.parse(next.commission!.toString())
              ? current
              : next);

      commission = largestGeekValue.commission!.toString();
    } else {
      commission = "0.0";
    }
    notifyListeners();
  }

  //select duration unit
  onChangeDuration(val) {
    durationValue = val;
    notifyListeners();
  }

  //add data validation
  addData(context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (addServiceFormKey.currentState!.validate()) {
      if (appArray.serviceImageList.isNotEmpty) {
        if (thumbFile != null) {
          if (categories.isNotEmpty) {
            if (durationValue != null) {
              if (taxIndex != null) {
                log("isSubscription:$isSubscription");
                if (isSubscription) {
                  if (allServiceList.length <
                      int.parse(
                          activeSubscription!.allowedMaxServices ?? "0")) {
                     addServiceApi(context);
                  } else {
                    snackBarMessengers(context,
                        message: language(
                            context,
                            appFonts.addUpToService(
                                context,
                                activeSubscription!.allowedMaxServices!
                                    .toString())));
                  }
                } else {
                  if (allServiceList.isEmpty) {
                    addServiceApi(context);
                  } else {
                    if (allServiceList.length <
                        int.parse(appSettingModel!
                                .defaultCreationLimits!.allowedMaxServices ??
                            "0")) {
                      addServiceApi(context);
                    } else {
                      snackBarMessengers(context,
                          message: language(
                              context,
                              appFonts.addUpToService(
                                  context,
                                  appSettingModel!
                                      .defaultCreationLimits!.allowedMaxServices
                                      .toString())));
                    }
                  }
                }
              } else {
                snackBarMessengers(context,
                    message: language(context, appFonts.pleaseSelectTax));
              }
            } else {
              snackBarMessengers(context,
                  message:
                      language(context, appFonts.pleaseSelectDurationUnit));
            }
          } else {
            snackBarMessengers(context,
                message: language(context, appFonts.pleaseSelectCategory));
          }
        } else {
          snackBarMessengers(context,
              message: language(context, appFonts.pleaseUploadThumbPhoto));
        }
      } else {
        snackBarMessengers(context,
            message: language(context, appFonts.pleaseUploadServiceImages));
      }
    }
  }

  //edit data validation
  editData(context) {
    log("message :${userModel!.media}");
    FocusScope.of(context).requestFocus(FocusNode());
    if (addServiceFormKey.currentState!.validate()) {
      if (services!.media != null && services!.media!.isNotEmpty) {
        editServiceApi(context);
      } else {
        snackBarMessengers(context,
            message: language(context, appFonts.pleaseUploadProfilePhoto));
      }
    }
  }

//add service
  addServiceApi(context) async {
    showLoading(context);
    notifyListeners();

    try {
      dynamic mimeTypeData;
      if (thumbFile != null) {
        mimeTypeData =
            lookupMimeType(thumbFile!.path, headerBytes: [0xFF, 0xD8])!
                .split('/');
      }
      log("thumbFile:4$thumbFile");
      log("thumbFile:4${thumbFile!.path} //z${thumbFile!.name}");
      var body = {
        'type': "fixed",
        "title": serviceName.text,
        if (thumbFile != null)
          'thumbnail': await dio.MultipartFile.fromFile(
              thumbFile!.path.toString(),
              filename: thumbFile!.name.toString(),
              contentType: MediaType(mimeTypeData[0], mimeTypeData[1])),
        "provider_id": userModel!.id,
        "price": amount.text,
        "discount": discount.text.isNotEmpty ? discount.text : 0,
        "tax_id": taxIndex,
        "duration": duration.text,
        "duration_unit": durationValue!.toLowerCase(),
        "description": description.text,
        "required_servicemen": minRequired.text,
        "is_featured": "1",
        "faqs": faqList,
        "isMultipleServiceman": minRequired.length > 1 ? "1" : 0,
        "status": isSwitch == true ? "1" : 0,
        for (var i = 0; i < categories.length; i++)
          "category_id[$i]": categories[i].id,
      };
      dio.FormData formData = dio.FormData.fromMap(body);

      for (var file in appArray.serviceImageList) {
        log("FILE :$file");
        formData.files.addAll([
          MapEntry(
              "image[]",
              await dio.MultipartFile.fromFile(
                file.path.toString(),
                filename: file.name.toString(),
              )),
        ]);
      }
      log("BODU :$body");
      log("BODU :${formData.files}");
      await apiServices
          .postApi(api.service, formData, isToken: true)
          .then((value) async {
        hideLoading(context);
        notifyListeners();
        log("SHHHH :${value.isSuccess}");
        log("SHHHH :${value.message}");
        log("SHHHH :${value.data}");
        if (value.isSuccess!) {
          final userApi =
              Provider.of<UserDataApiProvider>(context, listen: false);
          await userApi.getAllServiceList();
          await userApi.homeStatisticApi();
          await userApi.getCategory();
          onBack(false);
          snackBarMessengers(context,
              message: value.message,
              color: appColor(context).appTheme.primary);

          notifyListeners();

          route.pop(context);
        } else {
          final userApi =
              Provider.of<UserDataApiProvider>(context, listen: false);
          await userApi.getAllServiceList();
          Fluttertoast.showToast(msg: value.message);
        }
      });
    } catch (e) {
      hideLoading(context);
      notifyListeners();
      Fluttertoast.showToast(msg: e.toString());
      log("EEEE addServiceman : $e");
    }
  }

//edit service
  editServiceApi(context) async {
    try {
      dynamic mimeTypeData;
      if (thumbFile != null) {
        mimeTypeData = mime.lookupMimeType(thumbFile!.path,
            headerBytes: [0xFF, 0xD8])!.split('/');
      }

      showLoading(context);
      notifyListeners();

      var body = {
        'type': "fixed",
        "title": serviceName.text,
        if (thumbFile != null)
          'thumbnail': await dio.MultipartFile.fromFile(
              thumbFile!.path.toString(),
              filename: thumbFile!.name.toString(),
              contentType: MediaType(mimeTypeData[0], mimeTypeData[1])),
        "user_id": userModel!.id,
        "price": amount.text,
        "discount": discount.text.isNotEmpty ? int.parse(discount.text) : 0,
        "tax_id": taxIndex,
        "duration": duration.text,
        "duration_unit": durationValue!.toLowerCase(),
        "description": description.text,
        "required_servicemen": minRequired.text,
        "faqs": faqList,
        "is_featured": services!.isFeatured,
        "isMultipleServiceman": minRequired.length > 1 ? "1" : 0,
        "status": isSwitch == true ? "1" : 0,
        for (var i = 0; i < categories.length; i++)
          "category_id[$i]": categories[i].id,
        "_method": "PUT"
      };
      dio.FormData formData = dio.FormData.fromMap(body);

      for (var file in appArray.serviceImageList) {
        formData.files.addAll([
          MapEntry(
              "image[]",
              await MultipartFile.fromFile(file.path,
                  filename: file.path.split('/').last)),
        ]);
      }

      log("BODY :$body");
      await apiServices
          .postApi("${api.service}/${services!.id}", formData, isToken: true)
          .then((value) async {
        log("CAL :${value.isSuccess} //${value.message}");
        hideLoading(context);
        notifyListeners();

        if (value.isSuccess!) {
          final userApi =
              Provider.of<UserDataApiProvider>(context, listen: false);
          await userApi.getAllServiceList();
          getServiceFaqId(context, services!.id);
          userApi.getCategory();
          onBack(false);
          snackBarMessengers(context,
              message: value.message,
              color: appColor(context).appTheme.primary);
          notifyListeners();
          route.pop(context);
          imageFile = null;

          appArray.servicemanDocImageList = [];

          description.text = "";
        } else {
          snackBarMessengers(context,
              message: value.message, color: appColor(context).appTheme.red);
          final userApi =
              Provider.of<UserDataApiProvider>(context, listen: false);
          await userApi.getAllServiceList();
          //route.pop(context);
          //route.pop(context);
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
}
