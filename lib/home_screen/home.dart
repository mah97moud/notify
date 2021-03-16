import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
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
  @override
  void initState() {
    _totalNotifications = 0;
    super.initState();
    registerNotification();
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
    }).catchError((e) {
      print('Error: $e');
    });
  }
}
