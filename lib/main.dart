import 'package:fixit_provider/providers/common_providers/notification_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'common/languages/app_language.dart';
import 'common/theme/app_theme.dart';
import 'config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      name: 'Fixit',
      options: const FirebaseOptions(
          apiKey: "AIzaSyBLT6o5-8VqNKJNlkTaIRq2RVeN5xE5zGA",
          projectId: "fixit-db226",
          messagingSenderId: "186901032010",
          appId: "1:186901032010:android:b5c732cd46b148cb740ab3"));


  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, AsyncSnapshot<SharedPreferences> snapData) {
          if (snapData.hasData) {
            return MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                      create: (_) => ThemeService(snapData.data!,context)),
                  ChangeNotifierProvider(create: (_) => SplashProvider()),

                  ChangeNotifierProvider(
                      create: (_) => LanguageProvider(snapData.data!)),
                  ChangeNotifierProvider(
                      create: (_) => CurrencyProvider(snapData.data!)),
                  ChangeNotifierProvider(create: (_) => LoginAsProvider()),
                  ChangeNotifierProvider(create: (_) => LoadingProvider()),
                  ChangeNotifierProvider(
                      create: (_) => LoginAsServicemanProvider()),
                  ChangeNotifierProvider(
                      create: (_) => ForgetPasswordProvider()),
                  ChangeNotifierProvider(create: (_) => VerifyOtpProvider()),
                  ChangeNotifierProvider(
                      create: (_) => ResetPasswordProvider()),
                  ChangeNotifierProvider(create: (_) => IntroProvider()),
                  ChangeNotifierProvider(
                      create: (_) => SignUpCompanyProvider()),
                  ChangeNotifierProvider(create: (_) => LocationProvider()),
                  ChangeNotifierProvider(create: (_) => DashboardProvider()),
                  ChangeNotifierProvider(create: (_) => HomeProvider()),
                  ChangeNotifierProvider(
                      create: (_) => EarningHistoryProvider()),
                  ChangeNotifierProvider(create: (_) => NotificationProvider()),
                  ChangeNotifierProvider(create: (_) => ServiceListProvider()),
                  ChangeNotifierProvider(
                      create: (_) => AddNewServiceProvider()),
                  ChangeNotifierProvider(
                      create: (_) => ServiceDetailsProvider()),
                  ChangeNotifierProvider(
                      create: (_) => ServiceReviewProvider()),
                  ChangeNotifierProvider(
                      create: (_) => CategoriesListProvider()),
                  ChangeNotifierProvider(
                      create: (_) => ServicemanListProvider()),
                  ChangeNotifierProvider(
                      create: (_) => AddServicemenProvider()),
                  ChangeNotifierProvider(
                      create: (_) => LatestBLogDetailsProvider()),
                  ChangeNotifierProvider(create: (_) => ProfileProvider()),
                  ChangeNotifierProvider(
                      create: (_) => ChangePasswordProvider()),
                  ChangeNotifierProvider(
                      create: (_) => CompanyDetailProvider()),
                  ChangeNotifierProvider(
                      create: (_) => AppSettingProvider(snapData.data!)),
                  ChangeNotifierProvider(
                      create: (_) => ProfileDetailProvider()),
                  ChangeNotifierProvider(create: (_) => BankDetailProvider()),
                  ChangeNotifierProvider(create: (_) => TimeSlotProvider()),
                  ChangeNotifierProvider(create: (_) => PackageListProvider()),
                  ChangeNotifierProvider(create: (_) => ProviderDetailsProvider()),
                  ChangeNotifierProvider(
                      create: (_) => PackageDetailProvider()),
                  ChangeNotifierProvider(create: (_) => AddPackageProvider()),
                  ChangeNotifierProvider(
                      create: (_) => SelectServiceProvider()),
                  ChangeNotifierProvider(
                      create: (_) => BookingDetailsProvider()),
                  ChangeNotifierProvider(
                      create: (_) => CommissionInfoProvider()),
                  ChangeNotifierProvider(create: (_) => PlanDetailsProvider()),
                  ChangeNotifierProvider(create: (_) => CheckoutWebViewProvider()),
                  ChangeNotifierProvider(
                      create: (_) => SubscriptionPlanProvider()),
                  ChangeNotifierProvider(create: (_) => WalletProvider()),
                  ChangeNotifierProvider(create: (_) => BookingProvider()),
                  ChangeNotifierProvider(create: (_) => NoInternetProvider()),
                  ChangeNotifierProvider(
                      create: (_) => PendingBookingProvider()),
                  ChangeNotifierProvider(
                      create: (_) => AcceptedBookingProvider()),
                  ChangeNotifierProvider(
                      create: (_) => BookingServicemenListProvider()),
                  ChangeNotifierProvider(create: (_) => ChatProvider()),
                  ChangeNotifierProvider(
                      create: (_) => AssignBookingProvider()),
                  ChangeNotifierProvider(
                      create: (_) => PendingApprovalBookingProvider()),
                  ChangeNotifierProvider(
                      create: (_) => OngoingBookingProvider()),
                  ChangeNotifierProvider(
                      create: (_) => AddExtraChargesProvider()),
                  ChangeNotifierProvider(create: (_) => HoldBookingProvider()),
                  ChangeNotifierProvider(
                      create: (_) => CompletedBookingProvider()),
                  ChangeNotifierProvider(
                      create: (_) => AddServiceProofProvider()),
                  ChangeNotifierProvider(
                      create: (_) => CancelledBookingProvider()),
                  ChangeNotifierProvider(create: (_) => ChatHistoryProvider()),
                  ChangeNotifierProvider(create: (_) => DeleteDialogProvider()),
                  ChangeNotifierProvider(create: (_) => LocationListProvider()),
                  ChangeNotifierProvider(
                      create: (_) => ServicemenDetailProvider()),
                  ChangeNotifierProvider(create: (_) => NewLocationProvider()),
                  ChangeNotifierProvider(
                      create: (_) => IdVerificationProvider()),
                  ChangeNotifierProvider(
                      create: (_) => CommissionHistoryProvider()),
                  ChangeNotifierProvider(create: (_) => SearchProvider()),
                  ChangeNotifierProvider(create: (_) => ViewLocationProvider()),
                  ChangeNotifierProvider(create: (_) => CommonApiProvider()),
                  ChangeNotifierProvider(create: (_) => UserDataApiProvider()),

                  ChangeNotifierProvider(create: (_) => PaymentProvider()),
                ],
                child: RouteToPage());
          } else {
            return MaterialApp(
                theme: AppTheme.fromType(ThemeType.light).themeData,
                darkTheme: AppTheme.fromType(ThemeType.dark).themeData,
                themeMode: ThemeMode.light,
                debugShowCheckedModeBanner: false,
                home: const SplashLayout());
          }
        });
  }
}


class RouteToPage extends StatefulWidget {
  const RouteToPage({super.key});

  @override
  State<RouteToPage> createState() => _RouteToPageState();
}

class _RouteToPageState extends State<RouteToPage> {
  @override
  void initState() {
    // TODO: implement initState
    CustomNotificationController().initNotification(context);
    setState(() {

    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Consumer<ThemeService>(builder: (context, theme, child) {
      return Consumer<LanguageProvider>(
          builder: (context, lang, child) {
            return Consumer<CurrencyProvider>(
                builder: (context, currency, child) {

                  return MaterialApp(
                      title: 'Fixit Provider',

                      debugShowCheckedModeBanner: false,
                      theme: AppTheme.fromType(ThemeType.light).themeData,
                      darkTheme:
                      AppTheme.fromType(ThemeType.dark).themeData,
                      locale: lang.locale,
                      localizationsDelegates: const [
                        AppLocalizations.delegate,
                        AppLocalizationDelagate(),
                        GlobalMaterialLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                        GlobalCupertinoLocalizations.delegate
                      ],
                      supportedLocales: appArray.localList,
                      themeMode: theme.theme,
                      initialRoute: "/",
                      routes: appRoute.route);
                });
          });
    });
  }
}
