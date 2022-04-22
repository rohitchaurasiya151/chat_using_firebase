import 'dart:io';

import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions get platformOptions {
if (Platform.isIOS || Platform.isMacOS) {
      // iOS and MacOS
      return const FirebaseOptions(
        apiKey: 'AIzaSyCydwK4PpvHjmnFBCFbq8KeaAdlVv-xpRc',
        appId: "1:311165853744:ios:deb9eecc4de268c4800df5",
        messagingSenderId: '311165853744',
        projectId: 'ketshopapp',
      );
    } else {
      return const FirebaseOptions(
        messagingSenderId: "311165853744",
        apiKey: 'AIzaSyBw8Q4O3PmZ1gUPuhUXiS9uB-Ul5bQl7M0',
        appId: '1:311165853744:android:1a3ac716a4acd8b3800df5',
        projectId: 'rohit-learn-feb-2022',
      );
    }
  }
}