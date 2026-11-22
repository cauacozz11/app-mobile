import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:app_mobile/utils/prova_pdf.dart';

/// Lê o QRCode do gabarito da prova e devolve, no `pop`, o id da prova lida.
/// Devolve `null` se o professor voltar sem ler nada.
class LeitorQrScreen extends StatefulWidget {
  const LeitorQrScreen({super.key});

  @override
  State<LeitorQrScreen> createState() => _LeitorQrScreenState();
}

class _LeitorQrScreenState extends State<LeitorQrScreen> {
  final MobileScannerController _controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  bool _lido = false;
  bool _codigoInvalido = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _aoDetectar(BarcodeCapture captura) {
    if (_lido) return;
    for (final codigo in captura.barcodes) {
      final id = provaIdDoQr(codigo.rawValue);
      if (id != null) {
        _lido = true;
        Navigator.of(context).pop(id);
        return;
      }
    }
    if (!_codigoInvalido) setState(() => _codigoInvalido = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ler QRCode da prova'),
        backgroundColor: const Color(0xFF22555A),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _aoDetectar,
            errorBuilder: (context, erro) => const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Não foi possível abrir a câmera. Permita o acesso à câmera nas configurações do aparelho e tente novamente.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 32,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _codigoInvalido
                    ? 'Esse QRCode não é de uma prova do ProvaLeve. Aponte para o QRCode do gabarito.'
                    : 'Aponte a câmera para o QRCode do gabarito da prova.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
