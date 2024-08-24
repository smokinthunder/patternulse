import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:patternpulse/config/firebase_options.dart';
import 'package:patternpulse/root.dart';
import 'package:patternpulse/config/theme.dart';
import 'package:patternpulse/routes/draw_route.dart';
import 'package:patternpulse/routes/upload_route.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DrawRouteProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UploadRouteProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Pattern Pulse',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: primaryColor500,
          useMaterial3: false,
        ),
        home: const RootView(currentScreen: 0),
      ),
    );
  }
}
