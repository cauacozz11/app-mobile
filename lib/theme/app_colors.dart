import 'package:flutter/material.dart';

// Paleta usada em splash.dart e replicada nas telas de questões,
// para manter a identidade visual do app (ProvaSmart).
const corNavyEscuro = Color(0xFF071B4D);
const corNavyClaro = Color(0xFF082A72);
const corAccentCiano = Color(0xFF00BFFF);
const corAccentAzul = Color(0xFF1689FF);

const gradienteNavy = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [corNavyEscuro, corNavyClaro],
);
