import '../../../../config.dart';

class AssignMultipleServiceman extends StatelessWidget {
  final List<ServicemanModel> selectService;
  const AssignMultipleServiceman({super.key, required this.selectService});

  @override
  Widget build(BuildContext context) {
    return AlertDialogCommon(
        title: appFonts.assignToServicemen,
        subtext: appFonts.areYouSureServicemen,
        isBooked: true,
        isTwoButton: true,
        widget: Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Stack(alignment: Alignment.topRight, children: [
              Image.asset(eImageAssets.assignServicemen,
                  height: Sizes.s145, width: Sizes.s130),
              SizedBox(
                  height: Sizes.s34,
                  width: Sizes.s34,
                  child: Image.asset(eGifAssets.tick,
                      height: Sizes.s34, width: Sizes.s34))
                  .paddingOnly(top: Insets.i30)
            ]))
            .paddingOnly(top: Insets.i15)
            .decorated(
            color: appColor(context).appTheme.fieldCardBg,
            borderRadius: BorderRadius.circular(AppRadius.r10)),
        height: Sizes.s145,
        firstBText: appFonts.cancel,
        firstBTap: () => route.pop(context),
        secondBText: appFonts.yes,
        secondBTap: () {
          route.pop(context);

          route.pop(context,arg: selectService);

        });
  }
}
