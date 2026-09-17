import 'package:flutter/material.dart';

import 'screens/splash.dart';
import 'screens/login/login.dart';
import 'screens/provas/listagem_provas_screen.dart';
import 'screens/provas/criar_prova_screen.dart';
import 'screens/questoes/banco_questoes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProvaLeve',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'sans-serif',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF22555A),
          primary: const Color(0xFF22555A),
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/provas': (context) => const ListagemProvasScreen(),
        '/criar-prova': (context) => const CriarProvaScreen(),
        '/questoes': (context) => const BancoQuestoesScreen(),
      },
    );
  }
}
