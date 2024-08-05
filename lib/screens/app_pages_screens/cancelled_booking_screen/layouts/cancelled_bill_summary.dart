import '../../../../config.dart';

class CancelledBillSummary extends StatelessWidget {
  final BookingModel? bookingModel;

  const CancelledBillSummary({super.key, this.bookingModel});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(appColor(context).appTheme.isDark
                    ? eImageAssets.bookingDetailBg
                    : eImageAssets.pendingBillBg),
                fit: BoxFit.fill)),
        child: Column(children: [
          BillRowCommon(
              title: appFonts.perServiceCharge,
              price:
                  "${getSymbol(context)}${(currency(context).currencyVal * bookingModel!.perServicemanCharge!).ceilToDouble()}"),
          BillRowCommon(
                  title:
                      "${bookingModel!.totalServicemen == "0" ? 1 : bookingModel!.totalServicemen} ${language(context, appFonts.serviceman)} (${getSymbol(context)}${(currency(context).currencyVal * bookingModel!.perServicemanCharge!).ceilToDouble()} × ${bookingModel!.totalServicemen == "0" ? 1 : bookingModel!.totalServicemen})",
                  price:
                      "${getSymbol(context)}${(currency(context).currencyVal * bookingModel!.subtotal!).ceilToDouble()}",
                  style: appCss.dmDenseMedium14
                      .textColor(appColor(context).appTheme.darkText))
              .paddingSymmetric(vertical: Insets.i18),
          if (bookingModel!.coupon != null)
            BillRowCommon(
                title:
                    "Coupon discount ( ${bookingModel!.coupon!.amount}${bookingModel!.coupon!.type == "percentage" ? "%" : "off"})",
                price:
                    "-${getSymbol(context)}${currency(context).currencyVal * bookingModel!.couponTotalDiscount!}",
                style: appCss.dmDenseMedium14
                    .textColor(appColor(context).appTheme.red)),
          if (bookingModel!.coupon != null) const VSpace(Sizes.s18),
          BillRowCommon(
              title: appFonts.tax,
              price:
                  "+${getSymbol(context)}${(currency(context).currencyVal * bookingModel!.tax!)}",
              color: appColor(context).appTheme.online),
          BillRowCommon(
                  title: appFonts.platformFees,
                  price:
                      "+${getSymbol(context)}${(currency(context).currencyVal * (bookingModel!.platformFees ?? 0.0)).ceilToDouble()}",
                  color: appColor(context).appTheme.online)
              .padding(top: Insets.i18, bottom: Insets.i10),
          Divider(
                  color: appColor(context).appTheme.stroke,
                  thickness: 1,
                  height: 1,
                  endIndent: 6,
                  indent: 6)
              .paddingOnly(bottom: Insets.i20),
          BillRowCommon(
                  title: appFonts.totalAmount,
                  price:
                      "${getSymbol(context)}${(currency(context).currencyVal * bookingModel!.total!)}",
                  styleTitle: appCss.dmDenseMedium14
                      .textColor(appColor(context).appTheme.darkText),
                  style: appCss.dmDenseBold16
                      .textColor(appColor(context).appTheme.primary))
              .paddingOnly(bottom: Insets.i10)
        ]).paddingSymmetric(vertical: Insets.i20));
  }
}
