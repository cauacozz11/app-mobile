import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:app_mobile/models/prova.dart';
import 'package:app_mobile/models/resultado.dart';
import 'package:app_mobile/screens/correcao/correcao_prova_screen.dart';
import 'package:app_mobile/utils/leitor_folha.dart';
import 'package:app_mobile/utils/prova_pdf.dart';

class _Cores {
  static const Color background = Color(0xFFF8F5F0);
  static const Color teal = Color(0xFF22555A);
  static const Color orange = Color(0xFFEC9E80);
  static const Color subtitleColor = Color(0xFF3A484D);
}

/// Corrige o gabarito de um aluno pela foto da folha de respostas: lê as
/// bolinhas marcadas, tenta ler o QRCode individual (nome do aluno) e abre a
/// correção com tudo preenchido para o professor conferir e salvar.
/// Devolve o [Resultado] salvo no `pop`.
class CorrigirGabaritoScreen extends StatefulWidget {
  const CorrigirGabaritoScreen({super.key, required this.prova});

  final Prova prova;

  @override
  State<CorrigirGabaritoScreen> createState() => _CorrigirGabaritoScreenState();
}

class _CorrigirGabaritoScreenState extends State<CorrigirGabaritoScreen> {
  bool _lendo = false;
  String? _erro;

  Future<ConteudoQr?> _lerQrIndividual(String caminho) async {
    final controlador = MobileScannerController(autoStart: false);
    try {
      final captura = await controlador.analyzeImage(caminho);
      for (final codigo in captura?.barcodes ?? const <Barcode>[]) {
        final conteudo = lerQr(codigo.rawValue);
        if (conteudo != null) return conteudo;
      }
    } catch (_) {
      // Sem o QRCode, o professor digita o nome do aluno.
    } finally {
      await controlador.dispose();
    }
    return null;
  }

  Future<void> _escolher(ImageSource fonte) async {
    setState(() => _erro = null);
    XFile? arquivo;
    try {
      arquivo = await ImagePicker().pickImage(
        source: fonte,
        maxWidth: 2400,
        imageQuality: 90,
      );
    } catch (_) {
      setState(() => _erro = 'Não foi possível abrir a câmera ou a galeria.');
      return;
    }
    if (arquivo == null || !mounted) return;

    setState(() => _lendo = true);
    final bytes = await arquivo.readAsBytes();
    final leitura = await lerFolha(
      bytes,
      widget.prova.questoes.length,
      alternativasDaFolha(widget.prova),
    );
    final qr = await _lerQrIndividual(arquivo.path);
    if (!mounted) return;
    setState(() => _lendo = false);

    if (leitura.erro != null) {
      setState(() => _erro = leitura.erro);
      return;
    }
    if (qr != null && qr.provaId != widget.prova.id) {
      setState(() => _erro = 'Essa folha é de outra prova.');
      return;
    }

    final nome = qr?.aluno ?? '';
    if (leitura.duvidosas.isNotEmpty) {
      final numeros = leitura.duvidosas.map((q) => q + 1).join(', ');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 6),
          content: Text(
            'Confira as questões $numeros: ficaram em branco ou com mais de uma marcação.',
          ),
        ),
      );
    }

    final resultado = await Navigator.of(context).push<Resultado>(
      MaterialPageRoute(
        builder: (context) => CorrecaoProvaScreen(
          prova: widget.prova,
          respostasIniciais: leitura.respostas,
          nomeInicial: nome,
        ),
      ),
    );
    if (!mounted) return;
    if (resultado != null) Navigator.of(context).pop(resultado);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _Cores.background,
      appBar: AppBar(
        title: const Text('Corrigir gabarito do aluno'),
        backgroundColor: _Cores.background,
        foregroundColor: _Cores.teal,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _lendo
            ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: _Cores.teal),
                    SizedBox(height: 16),
                    Text('Lendo a folha de respostas...'),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${widget.prova.titulo} · ${widget.prova.disciplina}',
                    style: const TextStyle(
                      color: _Cores.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Fotografe a folha de respostas do aluno, inteira e de frente, com boa luz, '
                    'mostrando os 4 quadrados pretos dos cantos. O app lê as bolinhas marcadas '
                    'e o QRCode do aluno, e mostra a correção para você conferir antes de salvar.',
                    style: TextStyle(color: _Cores.subtitleColor, height: 1.4),
                  ),
                  if (_erro != null) ...[
                    const SizedBox(height: 14),
                    Text(
                      _erro!,
                      style: const TextStyle(color: _Cores.orange, fontSize: 14),
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () => _escolher(ImageSource.camera),
                      icon: const Icon(Icons.photo_camera_outlined),
                      label: const Text(
                        'Fotografar a folha',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _Cores.teal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: () => _escolher(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library_outlined),
                      label: const Text(
                        'Escolher da galeria',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _Cores.teal,
                        side: const BorderSide(color: _Cores.teal),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
