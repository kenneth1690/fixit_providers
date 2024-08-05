import 'package:flutter/services.dart';

import '../../../../config.dart';
import 'category_selection.dart';

class FormCategoryLayout extends StatelessWidget {
  const FormCategoryLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final value = Provider.of<AddNewServiceProvider>(context);
    return Column(children: [
      ContainerWithTextLayout(title: language(context, appFonts.categories))
          .paddingOnly(top: Insets.i24, bottom: Insets.i12),
      const CategorySelectionLayout(),
      ContainerWithTextLayout(
              title: language(context, appFonts.applicableCommission))
          .paddingOnly(top: Insets.i24, bottom: Insets.i12),
      Column(children: [
        Container(
            decoration: ShapeDecoration(
                color: appColor(context).appTheme.stroke,
                shape: RoundedRectangleBorder(
                    borderRadius: SmoothBorderRadius(
                        cornerRadius: AppRadius.r8, cornerSmoothing: 0))),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    SvgPicture.asset(eSvgAssets.commission,
                        colorFilter: ColorFilter.mode(
                            appColor(context).appTheme.lightText,
                            BlendMode.srcIn)),
                    const HSpace(Sizes.s10),
                    Text("${value.commission}%",
                        style: appCss.dmDenseMedium14
                            .textColor(appColor(context).appTheme.lightText))
                  ]),
                  Text(language(context, appFonts.percentage),
                      style: appCss.dmDenseRegular12
                          .textColor(appColor(context).appTheme.lightText))
                ]).paddingAll(Insets.i15)),
        const VSpace(Sizes.s2),
        Text(language(context, appFonts.noteHighest),
            style: appCss.dmDenseMedium12
                .textColor(appColor(context).appTheme.red))
      ]).paddingSymmetric(horizontal: Insets.i20),
      ContainerWithTextLayout(title: language(context, appFonts.description))
          .paddingOnly(top: Insets.i24, bottom: Insets.i12),
      CommonDescriptionBox(
          focusNode: value.descriptionFocus, description: value.description),
      ContainerWithTextLayout(title: language(context, appFonts.timeForCompletion))
          .paddingOnly(top: Insets.i24, bottom: Insets.i12),
      Row(children: [
        Expanded(
          flex: 2,
            child: TextFieldCommon(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[1-9]")),
                ],
                focusNode: value.durationFocus,
                controller: value.duration,
                hintText: appFonts.addServiceTime,
                prefixIcon: eSvgAssets.timer)),
        const HSpace(Sizes.s6),
        Expanded(

            child: DarkDropDownLayout(
                isBig: true,
                val: value.durationValue,
                hintText: appFonts.hour,
                isIcon: false,
                durationList: appArray.durationList,
                onChanged: (val) => value.onChangeDuration(val)))
      ]).paddingSymmetric(horizontal: Insets.i20),

      ContainerWithTextLayout(
              title: language(context, appFonts.faq),
              title2: appFonts.addFaq,
              onTap: () => value.addFaq(context))
          .paddingOnly(top: Insets.i24, bottom: Insets.i12),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: Sizes.s20),
        padding: const EdgeInsets.all( Sizes.s15),
        decoration: ShapeDecoration(
            color: appColor(context).appTheme.whiteBg,
            shape: SmoothRectangleBorder(
                borderRadius:
                    SmoothBorderRadius(cornerRadius: 8, cornerSmoothing: 1))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (value.faqList.isNotEmpty)
              ...value.faqList.asMap().entries.map((e) => Container(
                    margin: const EdgeInsets.symmetric(vertical: Sizes.s8),
                    padding: const EdgeInsets.symmetric(horizontal: Sizes.s20),
                    decoration: ShapeDecoration(
                        shadows: [
                          BoxShadow(
                              blurRadius: 2,
                              spreadRadius: 2,
                              color: appColor(context)
                                  .appTheme
                                  .darkText
                                  .withOpacity(0.06))
                        ],
                        color: appColor(context).appTheme.whiteColor,
                        shape: SmoothRectangleBorder(
                            borderRadius: SmoothBorderRadius(
                                cornerRadius: 8, cornerSmoothing: 1))),
                    child: ExpansionTile(
                        expansionAnimationStyle:
                            AnimationStyle(curve: Curves.fastOutSlowIn),
                        key: Key(value.selected.toString()),
                        initiallyExpanded: e.key == value.selected,
                        onExpansionChanged: (newState) =>
                            value.onExpansionChange(newState, e.key),
                        //atten
                        tilePadding: EdgeInsets.zero,
                        collapsedIconColor: appColor(context).appTheme.darkText,
                        dense: true,
                        iconColor: appColor(context).appTheme.darkText,
                        title: Text("${e.value['question']}",
                            style: appCss.dmDenseMedium14.textColor(
                                appColor(context).appTheme.darkText)),
                        children: <Widget>[
                          Divider(
                            color: appColor(context).appTheme.stroke,
                            height: .5,
                            thickness: 0,
                          ),
                          ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: Sizes.s5),
                              title: Text("${e.value['answer']}",
                                  style:appCss.dmDenseLight14.textColor(appColor(context).appTheme.darkText.withOpacity(.8))))
                        ]),
                  )),
            if (value.faqList.isEmpty)
              Row(
                children: [
                  SvgPicture.asset(eSvgAssets.faq,
                      fit: BoxFit.scaleDown,
                      height: Sizes.s20,
                      colorFilter: ColorFilter.mode(
                          appColor(context).appTheme.lightText,
                          BlendMode.srcIn)),
                  const HSpace(Sizes.s15),
                  Text(language(context, appFonts.addFaq),
                      style: appCss.dmDenseMedium14
                          .textColor(appColor(context).appTheme.lightText)),
                ],
              ).paddingSymmetric(horizontal: Sizes.s5)
          ],
        ),
      ),
      ContainerWithTextLayout(
              title: language(context, appFonts.minRequiredServiceman))
          .paddingOnly(top: Insets.i24, bottom: Insets.i12),
      TextFieldCommon(
              keyboardType: TextInputType.number,
              focusNode: value.minRequiredFocus,
              controller: value.minRequired,
              hintText: appFonts.addNoOfServiceman,
              prefixIcon: eSvgAssets.tagUser)
          .paddingSymmetric(horizontal: Insets.i20)
    ]);
  }
}
