import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notify/dio_helper/dio_helper.dart';
import 'package:notify/models/push_notification_model.dart';
import 'package:notify/notificationBadge/notificationb_badge.dart';
import 'package:overlay_support/overlay_support.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _totalNotifications;
  FirebaseMessaging _messaging = FirebaseMessaging();
  PushNotification _notificationInfo;
  String token;
  @override
  void initState() {
    _totalNotifications = 0;
    super.initState();
    registerNotification();
  }

  Future<void> pushNotify() async {
    await DioHelper.postData(
      path: '/fcm/send',
      data: {
        "to":
            "frcQWeERTweVmi4BsHFtsS:APA91bGuP-BASaUtLSwdEr2XUttIFf9Oximk4cB6IB8Vqc6nQ7vQGgXcIYZuCDq4_cOcYLtFLbz9VQD0HM80J-QzC6xmDlI75zxUwa3W64hf8lW8sBXw9naZSSESqJ5EgzsKZu-hUc3V",
        "notification": {
          "body": "Body of Your Notification push notifications",
          "title": "Title of Your Notification",
          "vibrate": 1,
          "sound": 1,
          "largeIcon": "large_icon",
          "smallIcon": "small_icon",
          "is_background": false,
          "timestamp": "2020-12-29 22:00:00"
        },
        "data": {
          "body": "Body of Your Notification push notifications",
          "title": "Title of Your Notification",
          "key_1": "Value for key_1",
          "key_2": "Value for key_2"
        }
      },
    ).then((value) {
      print(value.toString());
    }).catchError((e) {
      // if (e.response) {
      //   print(e.response.data);
      //   print(e.response.headers);
      //   print(e.response.request);
      // } else {
      //   // Something happened in setting up or sending the request that triggered an Error
      //   print(e.request);
      //   print(e.message);
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notify'),
        brightness: Brightness.dark,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'App for capturing Firebase Push Notifications',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 16.0),
          NotificationBadge(totalNotifications: _totalNotifications),
          SizedBox(height: 16.0),
          RaisedButton(
            onPressed: () async {
              await pushNotify();
            },
            child: Text('Push'),
          ),
          // TODO: add the notification text here
          _notificationInfo != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TITLE: ${_notificationInfo.title}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'BODY: ${_notificationInfo.body}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  void registerNotification() async {
    //  on ios , this helps to take the user permissions
    await _messaging.requestNotificationPermissions(
      IosNotificationSettings(
        alert: true,
        badge: true,
        provisional: true,
        sound: true,
      ),
    );

    // TODO: handle the received notifications
    // For handling the received notifications
    _messaging.configure(
      onMessage: (message) async {
        print('onMessage received: $message');
        PushNotification notification = PushNotification.fromJson(message);
        setState(
          () {
            _notificationInfo = notification;
            _totalNotifications++;
          },
        );
        showSimpleNotification(
          Text(_notificationInfo.title),
          leading: NotificationBadge(
            totalNotifications: _totalNotifications,
          ),
          subtitle: Text(
            _notificationInfo.body,
          ),
          background: Colors.cyan[700],
          duration: Duration(seconds: 2),
        );
      },
    );
    // Used to get the current FCM token
    _messaging.getToken().then((token) {
      print('Token: $token');
      token = token;
    }).catchError((e) {
      print('Error: $e');
    });
  }
}
