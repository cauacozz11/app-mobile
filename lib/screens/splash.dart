import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const Color background = Color(0xFFF8F5F0);
  static const Color blobColor = Color(0xFFF2EEE4);
  static const Color teal = Color(0xFF22555A);
  static const Color sage = Color(0xFF94AB9B);
  static const Color orange = Color(0xFFEC9E80);
  static const Color grayLine = Color(0xFFC3C6BF);
  static const Color cardWhite = Color(0xFFFBF9F5);
  static const Color subtitleColor = Color(0xFF3A484D);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  bool _navegando = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 2500), _irParaLogin);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _irParaLogin() {
    if (!mounted || _navegando) return;
    _navegando = true;
    _timer?.cancel();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: SplashScreen.background,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _irParaLogin,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: CustomPaint(
                  size: Size(size.width * 0.34, size.height * 0.19),
                  painter: BlobPainter(color: SplashScreen.blobColor),
                ),
              ),

              Positioned(
                bottom: 0,
                right: 0,
                child: Transform.rotate(
                  angle: 3.14159,
                  child: CustomPaint(
                    size: Size(size.width * 0.34, size.height * 0.19),
                    painter: BlobPainter(color: SplashScreen.blobColor),
                  ),
                ),
              ),

              SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const LogoCard(),
                              const SizedBox(height: 16),

                              RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Prova',
                                      style: TextStyle(
                                        color: SplashScreen.teal,
                                        fontSize: 38,
                                        fontWeight: FontWeight.w800,
                                        height: 1,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Leve',
                                      style: TextStyle(
                                        color: SplashScreen.sage,
                                        fontSize: 38,
                                        fontWeight: FontWeight.w800,
                                        height: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 56),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              child: Text(
                                'Provas mais simples. Tempo para ensinar.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: SplashScreen.subtitleColor,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            const _PageDots(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LogoCard extends StatelessWidget {
  const LogoCard({super.key, this.escala = 1});

  final double escala;

  @override
  Widget build(BuildContext context) {
    const double w = 132;
    const double h = 153;
    return SizedBox(
      width: w * 1.20 * escala,
      height: h * 1.16 * escala,
      child: CustomPaint(
        painter: _LogoPainter(escala: escala),
        size: Size(w * 1.20 * escala, h * 1.16 * escala),
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  const _LogoPainter({this.escala = 1});

  final double escala;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(escala);

    const cardW = 132.0;
    const cardH = 153.0;
    final cardRect = Rect.fromLTWH(0, 0, cardW, cardH);
    final rrect = RRect.fromRectAndRadius(cardRect, const Radius.circular(30));

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawRRect(rrect.shift(const Offset(2, 6)), shadowPaint);

    canvas.drawRRect(rrect, Paint()..color = SplashScreen.cardWhite);

    Offset rel(double fx, double fy) => Offset(fx * cardW, fy * cardH);

    const rowFy = [0.263, 0.495, 0.684, 0.874];
    const lineLenF = [0.56, 0.38, 0.26, 0.22];
    const circleFx = 0.244;
    const lineStartFx = 0.402;
    const filledIndex = 2;
    const circleRadius = 7.0;

    final circleOutlinePaint = Paint()
      ..color = SplashScreen.sage
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4;
    final circleFillPaint = Paint()..color = SplashScreen.teal;
    final linePaint = Paint()..color = SplashScreen.grayLine;

    for (var i = 0; i < rowFy.length; i++) {
      final center = rel(circleFx, rowFy[i]);
      if (i == filledIndex) {
        canvas.drawCircle(center, circleRadius, circleFillPaint);
      } else {
        canvas.drawCircle(center, circleRadius, circleOutlinePaint);
      }
      final lineStart = rel(lineStartFx, rowFy[i]);
      final lineLen = lineLenF[i] * cardW;
      final lineRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(lineStart.dx, lineStart.dy - 3, lineLen, 6),
        const Radius.circular(3),
      );
      canvas.drawRRect(lineRect, linePaint);
    }

    final checkPaint = Paint()
      ..color = SplashScreen.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final pStart = rel(0.60, 0.66);
    final pVertex = rel(0.72, 0.80);
    final pEnd = rel(0.90, 0.58);

    final checkPath = Path()
      ..moveTo(pStart.dx, pStart.dy)
      ..lineTo(pVertex.dx, pVertex.dy)
      ..lineTo(pEnd.dx, pEnd.dy);
    canvas.drawPath(checkPath, checkPaint);

    final sparklePaint = Paint()
      ..color = SplashScreen.sage
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    void sparkle(double fx0, double fy0, double fx1, double fy1) {
      canvas.drawLine(rel(fx0, fy0), rel(fx1, fy1), sparklePaint);
    }

    sparkle(0.85, -0.02, 0.86, -0.16);
    sparkle(0.95, 0.04, 1.05, -0.10);
    sparkle(1.06, 0.12, 1.20, 0.01);
  }

  @override
  bool shouldRepaint(covariant _LogoPainter oldDelegate) =>
      oldDelegate.escala != escala;
}

class BlobPainter extends CustomPainter {
  final Color color;
  const BlobPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final paint = Paint()..color = color;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(w * 0.70, 0)
      ..quadraticBezierTo(w * 0.31, h * 0.07, w * 0.64, h * 0.43)
      ..quadraticBezierTo(w * 0.73, h * 0.76, w * 0.25, h * 0.94)
      ..quadraticBezierTo(0, h, 0, h * 0.70)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PageDots extends StatelessWidget {
  const _PageDots();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _dot(active: true),
        const SizedBox(width: 8),
        _dot(active: false),
        const SizedBox(width: 8),
        _dot(active: false),
      ],
    );
  }

  Widget _dot({required bool active}) {
    return Container(
      width: active ? 10 : 7,
      height: active ? 10 : 7,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? SplashScreen.teal : SplashScreen.sage,
      ),
    );
  }
}
