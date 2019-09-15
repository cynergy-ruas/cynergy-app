import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';


class FirebaseNotifications {

    static _FirebaseNotifications _instance;

    static _FirebaseNotifications instance() {
    /**
     * returns the created instance of this class.
     * 
     * Returns:
     *  FirebaseNotifications: The instance of this class.
     */

    if (_instance == null) {
      _instance = _FirebaseNotifications();
    }

    return _instance;
  }
}


class _FirebaseNotifications {
  FirebaseMessaging _firebaseMessaging;

  void setUpFirebase({@required VoidCallback onResume, @required VoidCallback onLaunch, @required VoidCallback onMessage}) {
    /**
     * Setting up firebase cloud messaging
     * 
     * Args:
     *  onResume (VoidCallback): Callback executed when app resumes
     *  onLaunch (VoidCallback): Callback executed when app launches upon notification click
     *  onMessage (VoidCallback): Callback executed when app is running and a notification occurs
     * 
     * Returns:
     *  void
     */

    _firebaseMessaging = FirebaseMessaging();
    firebaseCloudMessagingListeners(onResume, onLaunch, onMessage);
  }

  void firebaseCloudMessagingListeners(VoidCallback onResume, VoidCallback onLaunch, VoidCallback onMessage) {
    /**
     * Performing FCM configuration.
     * 
     * Returns:
     *  void
     */

    if (Platform.isIOS) iOSPermission();

    _firebaseMessaging.getToken().then((token) {
      print(token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        onMessage();
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
        onResume();
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
        onLaunch();
      },
    );
  }

  void subscribeToNewEvents() {
    _firebaseMessaging.subscribeToTopic("new_events");
  }

  void unsubsribeFromNewEvents() {
    _firebaseMessaging.unsubscribeFromTopic("new_events");
  }

  void iOSPermission() {
    /**
     * Requests for permission to send notifications (iOS only).
     * 
     * Returns:
     *  void
     */
    
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }
}