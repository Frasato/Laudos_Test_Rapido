import 'package:flutter/material.dart';
import 'package:laudos_shalom/screens/form_covid.dart';
import 'package:laudos_shalom/screens/form_dengue.dart';
import 'package:laudos_shalom/screens/home.dart';
import 'package:window_manager/window_manager.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(
    size: Size(800, 600),
    center: true,
    minimumSize: Size(800, 600),
    maximumSize: Size(800, 600),
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  windowManager.setTitle("Laudos Shalom");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const Home(),
        '/covid': (context) => const FormCovid(),
        '/dengue': (context) => const FormDengue()
      },
    );
  }
}