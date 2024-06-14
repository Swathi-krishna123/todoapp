import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/firebase_options.dart';
import 'package:todo_app/screens/home_page.dart';
import 'package:todo_app/screens/login_view.dart';
import 'package:todo_app/screens/register_view.dart';
import 'package:todo_app/screens/splash_view.dart';
import 'package:todo_app/screens/task_page.dart';

void main()async{
WidgetsFlutterBinding.ensureInitialized;

 await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        '/': (context) => const LoginView(),
        '/register': (context) => const RegisterView(),
        '/home':(context) => const HomePage(),
        '/taskpage':(context) => const TaskPage(),
        '/splash':(context) =>const SplashView()
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: const TextTheme(
            displayMedium: TextStyle(color: Colors.white, fontSize: 18),
            displaySmall: TextStyle(color: Colors.white70, fontSize: 14)),
        scaffoldBackgroundColor: const Color.fromARGB(255, 3, 37, 65),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 3, 37, 65),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
      

