import 'package:chatmate/screens/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:chatmate/common/message.dart';
import 'package:chatmate/model/chat_session.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required for Hive
  await dotenv.load(fileName: ".env");

  // Validate API keys
  if (dotenv.env['GEMINI_API_KEY'] == null || dotenv.env['GEMINI_API_KEY']!.isEmpty ||
      dotenv.env['GEMINI_IMAGE_API_KEY'] == null || dotenv.env['GEMINI_IMAGE_API_KEY']!.isEmpty) {
    // Display an error and prevent app from running or show a placeholder
    runApp(const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            'Error: API keys not found in .env file. Please configure them.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
        ),
      ),
    ));
    return; // Stop execution
  }

  await Hive.initFlutter();
  Hive.registerAdapter(MessageAdapter());
  Hive.registerAdapter(ChatSessionsAdapter());
  await Hive.openBox<ChatSessions>('chatSessionsBox'); // Open the box

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChatMate',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.white,
          ),
          useMaterial3: true,
          fontFamily: GoogleFonts.poppins().fontFamily),
      home: const HomePage(),
    );
  }
}
