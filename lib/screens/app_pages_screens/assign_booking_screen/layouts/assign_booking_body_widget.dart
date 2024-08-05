import '../../../../config.dart';

class AssignBookingBodyWidget extends StatelessWidget {
  const AssignBookingBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AssignBookingProvider>(builder: (context, value, child) {
      return Stack(alignment: Alignment.bottomCenter, children: [
        SingleChildScrollView(
            child: Column(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            StatusDetailLayout(
                data: value.bookingModel,
                onTapStatus: () =>
                    showBookingStatus(context, value.bookingModel)),
            if (value.amount != null)
              ServicemenPayableLayout(amount: value.amount),
            Text(language(context, appFonts.billSummary),
                    style: appCss.dmDenseMedium14
                        .textColor(appColor(context).appTheme.darkText))
                .paddingOnly(top: Insets.i25, bottom: Insets.i10),
            AssignBillLayout(bookingModel: value.bookingModel),
            const VSpace(Sizes.s20),
            if (value.bookingModel!.service!.reviews!.isNotEmpty)
              ReviewListWithTitle(reviews: value.bookingModel!.service!.reviews!)
          ]).padding(
              horizontal: Insets.i20,
              top: Insets.i20,
              bottom: value.isServicemen != true ? Insets.i100 : Insets.i80)
        ])),
        if (value.bookingModel!.servicemen!.isNotEmpty)
          if (value.bookingModel!.servicemen!
              .where((element) =>
                  element.id.toString() == userModel!.id.toString())
              .isNotEmpty)
            Material(
                elevation: 20,
                child: BottomSheetButtonCommon(
                        textOne: appFonts.cancelService,
                        textTwo: appFonts.startDriving,
                        clearTap: () => value.onCancel(context),
                        applyTap: () => value.onStartServicePass(context))
                    .paddingAll(Insets.i20)
                    .decorated(color: appColor(context).appTheme.whiteBg))
      ]);
    });
  }
}
