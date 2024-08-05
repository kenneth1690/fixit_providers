import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import '../../config.dart';
import 'package:http/http.dart' as http;


import '../../helper/navigation_class.dart';

Future<String> downloadAndSaveFile(String url, String fileName) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final String filePath = '${directory.path}/$fileName';
  final http.Response response = await http.get(Uri.parse(url));
  final File file = File(filePath);
  await file.writeAsBytes(response.bodyBytes);
  return filePath;
}

bool isFlutterLocalNotificationsInitialized = false;

//when app in background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling a background message ${message.messageId}');
  debugPrint("message.datass : ${message.data}");
  //await Firebase.initializeApp();
  await Firebase.initializeApp(options: const FirebaseOptions(
      apiKey: "AIzaSyBLT6o5-8VqNKJNlkTaIRq2RVeN5xE5zGA",
      projectId: "fixit-db226",
      messagingSenderId: "186901032010",
      appId: "1:186901032010:android:b5c732cd46b148cb740ab3"));
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
 // showFlutterNotification(message,);
}

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }

  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) async {
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin!
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel!);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.

  RemoteNotification? notification = message.notification;
  if (message.data["type"] == "booking") {
    getBookingDetailById(navigatorKey.currentContext, message.data['booking_id']);
  } else if (message.data["type"] == "chat") {
    log("CAT ${message.data}");

    navigatorKey.currentState!.pushNamed(
      routeName.chat,
      arguments:{
        "image": message.data['image'],
        "name": message.data["name"],
        "role": message.data["role"],
        "userId": message.data['pId'],
        "token": message.data['token'],
        "phone": message.data['phone'],
        "code": message.data['code'],
        "bookingId": message.data['bookingId']??"",
      } ,
    ) .then((e) {
      debugPrint("SAVE ");

      saveNotificationApi(navigatorKey.currentContext, notification!.body, notification.title,
          message.data['userId'], message.data['image']);

      navigatorKey.currentState!.pushNamedAndRemoveUntil(routeName.dashboard, (route) => false);

    });
  }
  if (message.data["image"] != null && message.data["image"] != "") {
    final http.Response response =
        await http.get(Uri.parse(message.data["image"]));
    BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(
      ByteArrayAndroidBitmap.fromBase64String(base64Encode(response.bodyBytes)),
      largeIcon: ByteArrayAndroidBitmap.fromBase64String(
          base64Encode(response.bodyBytes)),
    );

    flutterLocalNotificationsPlugin!.show(
      notification.hashCode,
      notification!.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel!.id,
          channel!.name,
          channelDescription: channel!.description,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          styleInformation: bigPictureStyleInformation,

          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  } else {
    flutterLocalNotificationsPlugin!.show(
      notification.hashCode,
      notification!.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel!.id,
          channel!.name,
          channelDescription: channel!.description,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }
}

/// Create a [AndroidNotificationChannel] for heads up notifications
AndroidNotificationChannel? channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

class CustomNotificationController {
  AndroidNotificationChannel? channel;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification(context) async {
    debugPrint('initCall');
    //when app in background
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool notification = prefs.getBool(session.isNotification) ?? true;

    prefs.setBool(session.isNotification, notification);

    log("initCall :$notification");
    //when app in background
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    if(notification) {

      if (!kIsWeb) {
        channel = const AndroidNotificationChannel(
          'high_importance_channel', // id
          'High Importance Notifications', // titledescription
          importance: Importance.high,
        );

        flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

        /// We use this channel in the `AndroidManifest.xml` file to override the
        /// default FCM channel to enable heads up notifications.
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(channel!);
      }

      //when app is [closed | killed | terminated]
      FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage? message) {
        if (message != null) {
          flutterLocalNotificationsPlugin.cancelAll();
          debugPrint("INIIIII:$message");
          showFlutterNotification(message, true, context);
        }
      });

      var initialzationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
      var initializationSettings = InitializationSettings(
        android: initialzationSettingsAndroid,
      );

      flutterLocalNotificationsPlugin.initialize(initializationSettings);

      //when app in foreground
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        RemoteNotification notification = message.notification!;

        AndroidNotification? android = message.notification?.android;

        debugPrint("Njdfh :$notification");
        debugPrint("Njdfh :${message.data["image"]}");
        if (android != null && !kIsWeb) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel!.id,
                channel!.name,
                channelDescription: channel!.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: '@mipmap/ic_launcher',
              ),
            ),
          );
        }
        // ignore: unnecessary_null_comparison
        debugPrint("notification1 : ${message.data}");
        flutterLocalNotificationsPlugin.cancelAll();

        showFlutterNotification(message, false, context);
      });

      //when app in background
      FirebaseMessaging.onMessageOpenedApp.listen((
          RemoteMessage message) async {
        debugPrint('A new onMessageOpenedApp event was published!');
        debugPrint("onMessageOpenedApp: $message");
        flutterLocalNotificationsPlugin.cancelAll();
        AndroidNotification? android = message.notification?.android;
        if (android != null) {
          showFlutterNotification(message, true, context);
        }
      });
      requestPermissions();
    }
  }


  void showFlutterNotification(RemoteMessage message, isOpen,context) async {

    RemoteNotification? notification = message.notification;

    if (isOpen) {
      if (message.data["type"] == "booking") {
        getBookingDetailById(context, message.data['booking_id']);
      } else if (message.data["type"] == "chat") {
        log("routeName.chat :${message.data}");

        Navigator.pushNamed(context, routeName.chat, arguments: {
          "image": message.data['image'],
          "name": message.data["name"],
          "role": message.data["role"],
          "userId": message.data['pId'],
          "token": message.data['token'],
          "phone": message.data['phone'],
          "code": message.data['code'],
          "bookingId": message.data['bookingId']??"",
        },).then((e) {
          debugPrint("SAVE ");

          saveNotificationApi(context, notification!.body, notification.title,
              message.data['userId'], message.data['image']);

          navigatorKey.currentState!.pushNamedAndRemoveUntil(routeName.dashboard, (route) => false);

        });
      }
    }
    log("IKII :${message.data["image"]}");

  }

  requestPermissions() async {
    NotificationSettings settings =
    await FirebaseMessaging.instance.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true
    );

    log("settings.authorizationStatus: ${settings.authorizationStatus}");
  }
}


//save notification in database
saveNotificationApi(context, content, title, id, images) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  dynamic userData = pref.getString(session.user);
  userModel = UserModel.fromJson(jsonDecode(userData));
  log("userModel :${userModel}");
  var body = {
    "title": title,
    "message": content,
    "user_id": id,
    "type": "user",
    "images": images
  };
  debugPrint("ASSSIGN BODY : $body");
  try {
    await apiServices
        .postApi(api.saveNotification, body, isToken: true, isData: true)
        .then((value) {
      if (value.isSuccess!) {
        final common =
        Provider.of<UserDataApiProvider>(context, listen: false);
        common.getNotificationList();
      } else {}
    });
  } catch (e) {
    debugPrint("EEEE saveNotificationApi : $e");
  }
}

//booking detail by id
getBookingDetailById(context, id) async {
  try {
    await apiServices
        .getApi("${api.booking}/$id", [], isToken: true, isData: true)
        .then((value) {
      if (value.isSuccess!) {
        debugPrint("DHRUVU :${value.data}");

        BookingModel bookingModel = BookingModel.fromJson(value.data);
        if (bookingModel.bookingStatus!.slug ==
            appFonts.pending) {
          //route.pushNamed(context, routeName.packageBookingScreen);
          Navigator
              .pushNamed( context,routeName.pendingBooking,
              arguments: bookingModel.id)
              .then((e) {

            navigatorKey.currentState!.pushNamedAndRemoveUntil(routeName.dashboard, (route) => false);
          });
        } else if (bookingModel.bookingStatus!.slug ==
            appFonts.accepted) {
          if (isFreelancer) {
            Navigator
                .pushNamed( context,routeName.assignBooking,arguments: bookingModel.id).then((e) {
              navigatorKey.currentState!.pushNamedAndRemoveUntil(routeName.dashboard, (route) => false);
            }).then((e){

              navigatorKey.currentState!.pushNamedAndRemoveUntil(routeName.dashboard, (route) => false);
            });
          } else {
            Navigator
                .pushNamed( context,routeName.acceptedBooking,
                arguments: bookingModel.id)
                .then((e) {

              navigatorKey.currentState!.pushNamedAndRemoveUntil(routeName.dashboard, (route) => false);
            });
          }
          /* {"amount": "0", "assign_me": bookingModel.providerId.toString() == userModel!.id.toString()? true: false}*/
        } else if (bookingModel.bookingStatus!.slug ==
            appFonts.pendingApproval) {
          Navigator
              .pushNamed( context, routeName.pendingApprovalBooking,
              arguments: bookingModel.id)
              .then((e) {

            navigatorKey.currentState!.pushNamedAndRemoveUntil(routeName.dashboard, (route) => false);
          });
        } else if (bookingModel.bookingStatus!.slug ==
            appFonts.hold) {
          Navigator
              .pushNamed( context, routeName.holdBooking, arguments: bookingModel.id)
              .then((e) {

            navigatorKey.currentState!.pushNamedAndRemoveUntil(routeName.dashboard, (route) => false);
          });
        } else if (bookingModel.bookingStatus!.slug ==
            appFonts.hold) {
          Navigator
              .pushNamed( context, routeName.holdBooking, arguments: bookingModel.id)
              .then((e) {

            navigatorKey.currentState!.pushNamedAndRemoveUntil(routeName.dashboard, (route) => false);
          });
        } else if (bookingModel.bookingStatus!.slug ==
            appFonts.onGoing.toLowerCase() ||
            bookingModel.bookingStatus!.slug ==
                appFonts.ontheway ||
            bookingModel.bookingStatus!.slug ==
                appFonts.startAgain ||
            bookingModel.bookingStatus!.slug ==
                appFonts.onHold) {
          Navigator
              .pushNamed( context, routeName.ongoingBooking,
              arguments: bookingModel.id)
              .then((e) {
            navigatorKey.currentState!.pushNamedAndRemoveUntil(routeName.dashboard, (route) => false);
          });
        } else if (bookingModel.bookingStatus!.slug ==
            appFonts.completed) {
          Navigator
              .pushNamed( context, routeName.completedBooking,
              arguments: bookingModel.id)
              .then((e) {
            navigatorKey.currentState!.pushNamedAndRemoveUntil(routeName.dashboard, (route) => false);
          });
        } else if (bookingModel.bookingStatus!.slug ==
            appFonts.assigned) {
          Navigator
              .pushNamed( context,routeName.assignBooking,
              arguments: bookingModel.id)
              .then((e) {

            navigatorKey.currentState!.pushNamedAndRemoveUntil(routeName.dashboard, (route) => false);
          });
        } else if (bookingModel.bookingStatus!.slug ==
            appFonts.cancel) {
          Navigator
              .pushNamed( context, routeName.cancelledBooking,
              arguments: bookingModel.id)
              .then((e) {
            navigatorKey.currentState!.pushNamedAndRemoveUntil(routeName.dashboard, (route) => false);
          });
        }
      } else {}
    });
  } catch (e) {}
}