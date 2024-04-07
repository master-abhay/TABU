import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_tutorial/services/auth_services.dart';
import 'package:firestore_tutorial/services/navigation_services.dart';
import 'package:firestore_tutorial/ui/home_Page.dart';
import 'package:firestore_tutorial/ui/login_page.dart';
import 'package:firestore_tutorial/utils.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  await setup();
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);

  runApp( MyApp());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebase();
  await registerServices();
}

class MyApp extends StatelessWidget {

  final GetIt _getIt = GetIt.instance;
  late NavigationServices _navigationServices;
  late AuthServices _authServices;

   MyApp({super.key}

       ){
    _navigationServices = _getIt.get<NavigationServices>();
    _authServices = _getIt.get<AuthServices>();
   }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',

        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          textTheme: GoogleFonts.abhayaLibreTextTheme(),
        ),
      navigatorKey: _navigationServices.navigatorStateKey,

      routes: _navigationServices.routes,
      initialRoute: _authServices.user != null ? "/home" : "/login",
        );
  }
}
