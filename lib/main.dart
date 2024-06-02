import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ridobiko/controllers/auth/auth_controller.dart';
import 'package:ridobiko/data/user_model.dart';
import 'package:ridobiko/repositories/auth/auth_repository.dart';
import 'package:ridobiko/screens/rental/MyHomePage.dart';
import 'package:ridobiko/screens/auth/Login_Screen.dart';
import 'package:ridobiko/utils/shared_pref.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesService.init();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const ProviderScope(child: MyApp()));
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
    ),
  );
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    print(message.notification!.title.toString());
    print(message.notification!.body.toString());
  }
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? user;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    user = await ref.read(authRepositoryProvider).getUserData();
    if (user != null) {
      ref.read(userProvider.notifier).update((state) => user);
      if (kDebugMode) {
        print(user!.token);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ridobiko',
      home: AnimatedSplashScreen(
        curve: Curves.easeInCirc,
        animationDuration: const Duration(seconds: 2),
        duration: 1000,
        splash: Image.asset("assets/images/logo.png", height: 100),
        nextScreen: user != null ? const MyHomePage() : const LoginScreen(),
        splashTransition: SplashTransition.scaleTransition,
        pageTransitionType: PageTransitionType.leftToRight,
        backgroundColor: Colors.white,
      ),
      theme: ThemeData.light().copyWith(),
      debugShowCheckedModeBanner: false,
    );
  }
}
