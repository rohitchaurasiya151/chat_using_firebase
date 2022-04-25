// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:provider/provider.dart';
// import '../../../Screens/Welcome/welcome_screen.dart';
// import '../../../constants.dart';
// import 'Screens/Signup/provider/SignUpProvider.dart';
//
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   Firebase.initializeApp();
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [ChangeNotifierProvider(create: (_) => SignUpProvider())],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         builder: EasyLoading.init(),
//         title: 'Flutter Auth',
//         theme: ThemeData(
//           primaryColor: kPrimaryColor,
//           scaffoldBackgroundColor: Colors.white,
//         ),
//         home: const WelcomeScreen(),
//       ),
//     );
//   }
// }

import 'package:chat_using_firebase/Screens/UserList/user_list_screen.dart';
import 'package:chat_using_firebase/config/firebase_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'Auth/auth_controller.dart';
import 'Screens/Signup/provider/SignUpProvider.dart';
import 'constant/firebase_auth_constant.dart';

final Future<FirebaseApp> firebaseInitialization =
    Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase.initializeApp();
  await firebaseInitialization.then((value) {
    Get.put(AuthController());
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(640, 1340),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_) => MultiProvider(
        providers: [ChangeNotifierProvider(create: (_)=>SignUpProvider())],
        child: GetMaterialApp(
          builder: EasyLoading.init(),
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: AppTheme.lightTheme,
          // we don't really have to put the home page here
          // GetX is going to navigate the user and clear the navigation stack
          home: const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

class AppTheme {
  //
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      color: Colors.blueAccent,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: Colors.black,
      onPrimary: Colors.white,
      secondary: Colors.red,
    ),
    cardTheme: const CardTheme(
      color: Colors.teal,
    ),
    iconTheme: const IconThemeData(
      color: Colors.white54,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        color: Colors.black,
        fontSize: 20.0,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(
        color: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: Colors.white,
        onPrimary: Colors.black,
        secondary: Colors.red,
      ),
      cardTheme: const CardTheme(
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white54,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          hintStyle: TextStyle(color: Colors.black),
          labelStyle: TextStyle(color: Colors.black),
          contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5)));
}
