import 'package:fixit_provider/config.dart';
import 'package:flutter/material.dart';

import '../../add_new_location/layouts/county_drop_down.dart';
import '../../add_new_location/layouts/state_drop_down.dart';

class CompanyDetailUpdate extends StatelessWidget {
  const CompanyDetailUpdate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CompanyDetailProvider>(builder: (context1, value, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(DurationsDelay.ms150)
              .then((_) => value.getArg(context)),
          child: LoadingComponent(
            child: Scaffold(
                appBar: AppBarCommon(title: appFonts.companyDetails),
                body: SingleChildScrollView(
                    child: Column(children: [
                  Stack(children: [
                    FieldsBackground(),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ContainerWithTextLayout(title: appFonts.logo),
                          const VSpace(Sizes.s12),
                          value.imageFile != null
                              ? Stack(alignment: Alignment.bottomRight,
                                children: [
                                  CompanyLogoLayout(imageFile: value.imageFile)

                                      .paddingSymmetric(horizontal: Insets.i20),
                                  if(value.imageFile != null)
                                  Positioned(
                                    right: 10,
                                    child: SizedBox(
                                        child: SvgPicture.asset(eSvgAssets.add,
                                            height: Sizes.s14)
                                            .paddingAll(Insets.i7))
                                        .decorated(
                                        color: appColor(context).appTheme.stroke,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: appColor(context).appTheme.primary)).inkWell(
                                        onTap: () => value.onImagePick(context)),
                                  )
                                ],
                              )
                              : value.logo != null
                                  ? CompanyLogoLayoutNetwork(

                                          imageFile: value.logo)
                                      .inkWell(
                                          onTap: () =>
                                              value.onImagePick(context))
                                      .paddingSymmetric(horizontal: Insets.i20)
                                  :  Stack(alignment: Alignment.bottomRight,
                            children: [
                              CompanyLogoLayout(imageFile: value.imageFile)

                                  .paddingSymmetric(horizontal: Insets.i20),
                              if(value.imageFile != null)
                              Positioned(
                                right: 10,
                                child: SizedBox(
                                    child: SvgPicture.asset(eSvgAssets.add,
                                        height: Sizes.s14)
                                        .paddingAll(Insets.i7))
                                    .decorated(
                                    color: appColor(context).appTheme.stroke,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: appColor(context).appTheme.primary)).inkWell(
                                    onTap: () => value.onImagePick(context)),
                              )
                            ],
                          ),
                          ContainerWithTextLayout(title: appFonts.companyName)
                              .paddingOnly(top: Insets.i24, bottom: Insets.i8),
                          TextFieldCommon(
                                  controller: value.companyName,
                                  validator: (v) =>
                                      validation.nameValidation(context, v),
                                  focusNode: value.companyNameFocus,
                                  hintText: appFonts.enterCompanyName,
                                  prefixIcon: eSvgAssets.companyName)
                              .paddingSymmetric(horizontal: Insets.i20),
                          ContainerWithTextLayout(
                                  title: appFonts.companyPhoneNo)
                              .paddingOnly(top: Insets.i24, bottom: Insets.i8),
                          RegisterWidgetClass().phoneTextBox(
                              dialCode: value.dialCode,
                              context, value.companyPhone, value.phoneNameFocus,
                              onChanged: (CountryCodeCustom? code) =>
                                  value.changeDialCode(code!),
                              onFieldSubmitted: (values) =>
                                  validation.fieldFocusChange(
                                      context,
                                      value.phoneNameFocus,
                                      value.companyMailFocus)),
                          ContainerWithTextLayout(title: appFonts.companyMail)
                              .paddingOnly(top: Insets.i24, bottom: Insets.i8),
                          TextFieldCommon(
                                  validator: (v) =>
                                      validation.emailValidation(context, v),
                                  controller: value.companyMail,
                                  focusNode: value.companyMailFocus,
                                  keyboardType: TextInputType.emailAddress,
                                  hintText: appFonts.enterMail,
                                  prefixIcon: eSvgAssets.email)
                              .paddingSymmetric(horizontal: Insets.i20),
                          ContainerWithTextLayout(title: appFonts.description)
                              .paddingOnly(top: Insets.i24, bottom: Insets.i8),
                          Stack(children: [
                            TextFieldCommon(
                                    focusNode: value.descriptionFocus,
                                    isNumber: true,
                                    validator: (v) =>
                                        validation.dynamicTextValidation(
                                            context,
                                            v,
                                            appFonts.pleaseEnterDesc),
                                    controller: value.description,
                                    hintText: appFonts.enterDetails,
                                    maxLines: 3,
                                    minLines: 3,
                                    isMaxLine: true)
                                .paddingSymmetric(horizontal: Insets.i20),
                            SvgPicture.asset(eSvgAssets.details,
                                    fit: BoxFit.scaleDown,
                                    colorFilter: ColorFilter.mode(
                                        !value.descriptionFocus.hasFocus
                                            ? value.description.text.isNotEmpty
                                                ? appColor(context)
                                                    .appTheme
                                                    .darkText
                                                : appColor(context)
                                                    .appTheme
                                                    .lightText
                                            : appColor(context)
                                                .appTheme
                                                .darkText,
                                        BlendMode.srcIn))
                                .paddingOnly(
                                    left: rtl(context) ? 0 : Insets.i35,
                                    right: rtl(context) ? Insets.i35 : 0,
                                    top: Insets.i13)
                          ]),

                          ContainerWithTextLayout(title: appFonts.address)
                              .paddingOnly(bottom: Insets.i8),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: Sizes.s20),
                            padding: const EdgeInsets.symmetric(horizontal: Sizes.s20,vertical: Sizes.s20),
                            decoration: ShapeDecoration(
                              shape: SmoothRectangleBorder(
                                  borderRadius: SmoothBorderRadius(
                                      cornerRadius: 8,cornerSmoothing: 1
                                  )
                              ),
                              color: appColor(context).appTheme.whiteBg,

                            ),
                            child:  Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                value.areaData == null?
                                Text(language(context, appFonts.companyLocation),style:  appCss.dmDenseMedium14
                                    .textColor(appColor(context).appTheme.lightText)): Expanded(
                                  child: Text(value.areaData,style:  appCss.dmDenseMedium14
                                      .textColor(appColor(context).appTheme.darkText),),
                                ),
                                SvgPicture.asset(eSvgAssets.locationOut).inkWell(onTap: ()=> value.getLocation(context))
                              ],
                            ).marginOnly(bottom: Sizes.s10),
                          ),
                          const VSpace(Sizes.s20),
                          ContainerWithTextLayout(title: appFonts.street)
                              .paddingOnly(bottom: Insets.i8),
                          TextFieldCommon(
                              focusNode: value.streetFocus,
                              validator: (val) => validation.dynamicTextValidation(
                                  context, val, appFonts.pleaseEnterDesc),
                              controller: value.street,
                              hintText: appFonts.street,
                              prefixIcon: eSvgAssets.address)
                              .paddingSymmetric(horizontal: Insets.i20),
                          const VSpace(Sizes.s20),
                          ContainerWithTextLayout(title: appFonts.areaLocality)
                              .paddingOnly(bottom: Insets.i8),
                          TextFieldCommon(
                              focusNode: value.areaFocus,
                              validator: (val) => validation.dynamicTextValidation(
                                  context, val, appFonts.pleaseEnterArea),
                              controller: value.area,
                              hintText: appFonts.area,
                              prefixIcon: eSvgAssets.address)
                              .paddingSymmetric(horizontal: Insets.i20),

                          const VSpace(Sizes.s20),
                          ContainerWithTextLayout(title: appFonts.country)
                              .paddingOnly(bottom: Insets.i8),
                          const CountryDropDown(isUpdate: true,)
                              .paddingSymmetric(horizontal: Insets.i20),
                          const VSpace(Sizes.s20),
                          ContainerWithTextLayout(title: appFonts.state)
                              .paddingOnly(bottom: Insets.i8),
                          const StateDropDown(isUpdate: true)
                              .paddingSymmetric(horizontal: Insets.i20),
                        ]).paddingSymmetric(vertical: Sizes.s20)
                  ]),
                  ButtonCommon(title: appFonts.update, onTap: () => value.updateProfile(context))
                      .paddingOnly(bottom: Insets.i10, top: Insets.i40)
                ]).paddingAll(Insets.i20))),
          ));
    });
  }
}