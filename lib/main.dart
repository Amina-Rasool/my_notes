import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'presentation/note_cubic.dart';
import 'presentation/note_screen.dart';
import 'presentation/auth/signup_screen.dart'; // Ensure karein ye path sahi ho

void main() async {
  // Binding aur Firebase initialization
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NoteCubit()..loadNotes(),
      child: MaterialApp(
        title: 'Efficient Task List',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
        ),
        // Sab se pehle Signup Screen khulegi
        home: SignupScreen(),
      ),
    );
  }
}