import 'dart:developer';

import 'package:fixit_provider/screens/bottom_screens/home_screen/home_shimmer/home_shimmer.dart';

import '../../../config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  AnimationStatus status = AnimationStatus.dismissed;

  @override
  void dispose() {
    controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));
    animation = Tween(end: 1.0, begin: 0.0).animate(controller)
      ..addListener(() {
        setState(() {});
        controller.repeat();
      })
      ..addStatusListener((status) {
        status = status;
      });
    controller.repeat();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<HomeProvider, BookingProvider, DashboardProvider>(
        builder: (context1, value, booking, dashCtrl, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(const Duration(milliseconds: 100),
              () => value.onReady(context, this)),
          child: value.isSkeleton
              ? const HomeShimmer()
              : RefreshIndicator(
                  onRefresh: () async {
                    return dashCtrl.onRefresh(context);
                  },
                  child: Scaffold(
                      appBar: AppBar(
                          leadingWidth: MediaQuery.of(context).size.width,
                          leading: userModel != null
                              ? const HomeAppBar()
                              : Container()),
                      body: userModel == null
                          ? Container()
                          : SingleChildScrollView(
                              controller: value.scrollController,
                              child: Column(children: [
                                const VSpace(Sizes.s15),
                                if (isServiceman) const ProviderInfo(),
                                WalletBalanceLayout(
                                    onTap: () => value.onWithdraw(context)),
                                const VSpace(Sizes.s16),
                                if (isServiceman)
                                  ServicemanStatistics(animation: animation)
                                else
                                  Column(children: [
                                    /*Row(
                                          children: [
                                            Expanded(child:  GridViewLayout(
                                                data: appArray.earningList[0],
                                                index: 0,
                                                animation: animation,
                                                onTap: () =>
                                                    value.onTapOption(
                                                        0,
                                                        context))),
                                            const HSpace(Sizes.s12),
                                            Expanded(child:  GridViewLayout(
                                                data: appArray.earningList[1],
                                                index: 1,
                                                animation: animation,
                                                onTap: () =>
                                                    value.onTapOption(
                                                        1,
                                                        context))),
                                          ],
                                        )*/
                                    Row(children: [
                                      ...appArray.earningList
                                          .getRange(0, 2)
                                          .toList()
                                          .asMap()
                                          .entries
                                          .map((e) => Expanded(
                                                  child: Row(children: [
                                                Expanded(
                                                    child: GridViewLayout(
                                                        data: e.value,
                                                        index: e.key,
                                                        isHeight: false,
                                                        animation: animation,
                                                        onTap: () =>
                                                            value.onTapOption(
                                                                e.key,
                                                                context,
                                                                e.value[
                                                                    'title']))),
                                                if (e.key == 0)
                                                  const HSpace(Sizes.s12)
                                              ])))
                                    ]),
                                    const VSpace(Sizes.s12),
                                    Row(children: [
                                      ...appArray.earningList
                                          .getRange(2, 5)
                                          .toList()
                                          .asMap()
                                          .entries
                                          .map((e) => Expanded(
                                                  child: Row(children: [
                                                Expanded(
                                                    child: GridViewLayout(
                                                        data: e.value,
                                                        index: e.key,
                                                        animation: animation,
                                                        onTap: () =>
                                                            value.onTapOption(
                                                                e.key,
                                                                context,
                                                                e.value[
                                                                    'title']))),
                                                if (e.key !=
                                                    appArray.earningList
                                                            .getRange(2, 5)
                                                            .length -
                                                        1)
                                                  const HSpace(Sizes.s12)
                                              ])))
                                    ])
                                  ]).marginSymmetric(
                                      horizontal: Sizes
                                          .s20) /* StaggeredGrid.count(
                                    crossAxisCount: 10,
                                    mainAxisSpacing: 12,
                                    crossAxisSpacing: 12,
                                    children: appArray.earningList
                                        .asMap()
                                        .entries
                                        .map((e) => GridViewLayout(
                                            data: e.value,
                                            index: e.key,
                                            animation: animation,
                                            onTap: () => value.onTapOption(
                                                e.key, context)))
                                        .toList())
                                .paddingSymmetric(horizontal: Insets.i20)*/
                                ,
                                if (!isServiceman) const VSpace(Sizes.s25),
                                if (booking.bookingList.isNotEmpty)
                                  if (isServiceman)
                                    Column(children: [
                                      HeadingRowCommon(
                                          isViewAllShow:
                                              booking.bookingList.length >= 10,
                                          title: appFonts.recentBooking,
                                          onTap: () =>
                                              value.onTapIndexOne(dashCtrl)),
                                      const VSpace(Sizes.s15),
                                      booking.bookingList.length > 2
                                          ? Column(children: [
                                              ...booking.bookingList
                                                  .getRange(0, 2)
                                                  .toList()
                                                  .asMap()
                                                  .entries
                                                  .map((e) => BookingLayout(
                                                      data: e.value,
                                                      onTap: () =>
                                                          value.onTapBookings(
                                                              e.value,
                                                              context)))
                                            ])
                                          : Column(children: [
                                              ...booking.bookingList
                                                  .toList()
                                                  .asMap()
                                                  .entries
                                                  .map((e) => BookingLayout(
                                                      data: e.value,
                                                      onTap: () =>
                                                          value.onTapBookings(
                                                              e.value,
                                                              context)))
                                            ])
                                    ])
                                        .padding(
                                          horizontal: Insets.i20,
                                          top: Insets.i25,
                                        )
                                        .decorated(
                                            color: appColor(context)
                                                .appTheme
                                                .whiteColor),
                                const StaticDetailChart(),
                                const AllCategoriesLayout()
                              ]).paddingOnly(bottom: Insets.i110))),
                ));
    });
  }
}
