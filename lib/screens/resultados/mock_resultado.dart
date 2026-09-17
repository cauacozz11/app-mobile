import 'package:app_mobile/models/alternativa.dart';
import 'package:app_mobile/models/prova.dart';
import 'package:app_mobile/models/questao.dart';
import 'package:app_mobile/models/resultado.dart';

final provaMock = Prova(
  id: '1',
  titulo: 'Avaliação 02',
  disciplina: 'Engenharia de Software',
  dataCriacao: DateTime.now(),
  questoes: [
    Questao(
      id: 'q1',
      enunciado: 'Qual estrutura organiza o app em telas navegáveis?',
      alternativas: [
        Alternativa(texto: 'Widget', ordem: 0),
        Alternativa(texto: 'Model', ordem: 1),
        Alternativa(texto: 'Route', ordem: 2),
      ],
      indiceAlternativaCorreta: 2,
    ),
    Questao(
      id: 'q2',
      enunciado: 'Qual comando instala as dependências do projeto?',
      alternativas: [
        Alternativa(texto: 'flutter pub get', ordem: 0),
        Alternativa(texto: 'flutter run', ordem: 1),
        Alternativa(texto: 'flutter build', ordem: 2),
      ],
      indiceAlternativaCorreta: 0,
    ),
    Questao(
      id: 'q3',
      enunciado: 'Qual widget é usado para navegação entre telas?',
      alternativas: [
        Alternativa(texto: 'Navigator', ordem: 0),
        Alternativa(texto: 'Container', ordem: 1),
        Alternativa(texto: 'Column', ordem: 2),
      ],
      indiceAlternativaCorreta: 0,
    ),
    Questao(
      id: 'q4',
      enunciado: 'Qual comando cria um novo branch e já muda pra ele?',
      alternativas: [
        Alternativa(texto: 'git branch nome', ordem: 0),
        Alternativa(texto: 'git checkout -b nome', ordem: 1),
        Alternativa(texto: 'git merge nome', ordem: 2),
      ],
      indiceAlternativaCorreta: 1,
    ),
    Questao(
      id: 'q5',
      enunciado: 'O que o Provider/StatefulWidget ajuda a controlar?',
      alternativas: [
        Alternativa(texto: 'O estado da interface', ordem: 0),
        Alternativa(texto: 'A conexão com o banco', ordem: 1),
        Alternativa(texto: 'O tamanho do APK', ordem: 2),
      ],
      indiceAlternativaCorreta: 0,
    ),
    Questao(
      id: 'q6',
      enunciado: 'Qual widget organiza itens em uma lista rolável?',
      alternativas: [
        Alternativa(texto: 'ListView', ordem: 0),
        Alternativa(texto: 'Row', ordem: 1),
        Alternativa(texto: 'Stack', ordem: 2),
      ],
      indiceAlternativaCorreta: 0,
    ),
    Questao(
      id: 'q7',
      enunciado: 'Na N1 do projeto, os dados exibidos são:',
      alternativas: [
        Alternativa(texto: 'Vindos do Firebase Firestore', ordem: 0),
        Alternativa(texto: 'Fictícios (mock)', ordem: 1),
        Alternativa(texto: 'Importados de uma planilha', ordem: 2),
      ],
      indiceAlternativaCorreta: 1,
    ),
    Questao(
      id: 'q8',
      enunciado: 'Quem precisa aprovar um Pull Request antes do merge?',
      alternativas: [
        Alternativa(texto: 'O próprio autor do PR', ordem: 0),
        Alternativa(texto: 'Outro membro do grupo', ordem: 1),
        Alternativa(texto: 'Não precisa de aprovação', ordem: 2),
      ],
      indiceAlternativaCorreta: 1,
    ),
    Questao(
      id: 'q9',
      enunciado: 'Qual arquivo trava as versões exatas das dependências?',
      alternativas: [
        Alternativa(texto: 'pubspec.yaml', ordem: 0),
        Alternativa(texto: 'pubspec.lock', ordem: 1),
        Alternativa(texto: 'analysis_options.yaml', ordem: 2),
      ],
      indiceAlternativaCorreta: 1,
    ),
    Questao(
      id: 'q10',
      enunciado: 'O que a conexão com banco de dados (Firestore) entrega ao projeto?',
      alternativas: [
        Alternativa(texto: 'Só entra a partir da N2', ordem: 0),
        Alternativa(texto: 'Já está pronta desde a N1', ordem: 1),
        Alternativa(texto: 'Não faz parte do escopo do projeto', ordem: 2),
      ],
      indiceAlternativaCorreta: 0,
    ),
  ],
);

final resultadoMock = Resultado(
  id: 'r1',
  provaId: provaMock.id,
  respostasMarcadas: [2, 0, 1, 1, 0, 0, 0, 1, 1, 0],
  nota: 8.0,
);
