import 'package:app_mobile/data/provas_repository.dart';
import 'package:app_mobile/data/questoes_repository.dart';
import 'package:app_mobile/data/turmas_repository.dart';
import 'package:app_mobile/models/alternativa.dart';
import 'package:app_mobile/models/prova.dart';
import 'package:app_mobile/models/questao.dart';
import 'package:app_mobile/models/sessao.dart';
import 'package:app_mobile/models/turma.dart';
import 'package:app_mobile/screens/questoes/questao_cadastrada.dart';

/// Id fixo da prova de demonstração. O QRCode impresso traz esse id, então a
/// prova impressa antes da apresentação continua valendo para a conta criada na hora.
const String idProvaDemo = 'prova-demo-provaleve';

/// Dados de exemplo gravados para cada conta nova: questões no banco, uma turma
/// e a prova de demonstração já postada. Assim o professor recém-cadastrado já
/// encontra o app com dados para usar.
///
/// A prova de demonstração tem sempre o mesmo id e o mesmo conteúdo: ao criar
/// outra conta, ela passa a ser dessa conta nova (a anterior deixa de vê-la).
Future<void> carregarDadosDemo() async {
  final professorId = Sessao.usuarioAtual?.id;
  if (professorId == null) return;

  // Questões e turma levam o id do professor para não colidir entre contas.
  String id(String nome) => '$nome-$professorId';

  final questoes = [
    for (final (indice, q) in _questoesDemo.indexed)
      QuestaoCadastrada(
        questao: Questao(
          id: id('questao-demo-${indice + 1}'),
          enunciado: q.enunciado,
          alternativas: [
            for (final (ordem, texto) in q.alternativas.indexed)
              Alternativa(texto: texto, ordem: ordem),
          ],
          indiceAlternativaCorreta: q.correta,
        ),
        disciplina: q.disciplina,
        dificuldade: q.dificuldade,
      ),
  ];

  final turma = Turma(
    id: id('turma-demo'),
    nome: '8º ano A',
    disciplina: 'Matemática',
  );

  final prova = Prova(
    id: idProvaDemo,
    titulo: 'Avaliação de Matemática — 8º ano A',
    disciplina: 'Matemática',
    questoes: [for (final q in questoes.take(5)) q.questao],
    dataCriacao: DateTime(2026, 11, 25),
    status: 'pronta',
    turmaId: turma.id,
    turmaNome: turma.nome,
  );

  await Future.wait([
    for (final q in questoes) QuestoesRepository.instance.criar(q),
    TurmasRepository.instance.criar(turma),
    ProvasRepository.instance.criar(prova),
  ]);
}

class _QuestaoDemo {
  const _QuestaoDemo(
    this.disciplina,
    this.dificuldade,
    this.enunciado,
    this.alternativas,
    this.correta,
  );

  final String disciplina;
  final String dificuldade;
  final String enunciado;
  final List<String> alternativas;
  final int correta;
}

// As 5 primeiras formam a prova de demonstração; não mude a ordem nem o
// conteúdo depois de imprimir a prova.
const _questoesDemo = [
  _QuestaoDemo('Matemática', 'Fácil', 'Qual é o resultado de 3/4 + 1/2?',
      ['4/6', '5/4', '1', '3/8'], 1),
  _QuestaoDemo('Matemática', 'Fácil', 'Qual é o valor de x na equação 2x + 6 = 14?',
      ['4', '3', '7', '10'], 0),
  _QuestaoDemo('Matemática', 'Média',
      'Qual é a área de um retângulo com 8 cm de base e 5 cm de altura?',
      ['13 cm²', '26 cm²', '40 cm²', '80 cm²'], 2),
  _QuestaoDemo('Matemática', 'Média', 'Quanto é 15% de 200?',
      ['15', '20', '25', '30'], 3),
  _QuestaoDemo('Matemática', 'Difícil', 'Qual é o valor de 2³ + 4²?',
      ['14', '24', '20', '28'], 1),
  _QuestaoDemo('Matemática', 'Fácil',
      'Quanto vale a soma dos ângulos internos de um triângulo?',
      ['90°', '180°', '270°', '360°'], 1),
  _QuestaoDemo('Matemática', 'Fácil', 'Qual é a raiz quadrada de 144?',
      ['11', '14', '12', '13'], 2),
  _QuestaoDemo('Matemática', 'Média',
      'Um produto de R\$ 80,00 teve desconto de 25%. Qual é o novo preço?',
      ['R\$ 55,00', 'R\$ 60,00', 'R\$ 65,00', 'R\$ 70,00'], 1),
  _QuestaoDemo('Matemática', 'Média',
      'Qual é o próximo número da sequência 2, 4, 8, 16, ...?',
      ['18', '24', '32', '20'], 2),
  _QuestaoDemo('Matemática', 'Fácil', 'Quanto é 7 × 8?',
      ['54', '56', '58', '64'], 1),

  // Ciências
  _QuestaoDemo('Ciências', 'Fácil', 'Qual é o planeta mais próximo do Sol?',
      ['Vênus', 'Terra', 'Mercúrio', 'Marte'], 2),
  _QuestaoDemo('Ciências', 'Média', 'Qual gás as plantas absorvem na fotossíntese?',
      ['Oxigênio', 'Gás carbônico', 'Nitrogênio', 'Hidrogênio'], 1),
  _QuestaoDemo('Ciências', 'Fácil',
      'Qual órgão bombeia o sangue pelo corpo humano?',
      ['Pulmão', 'Fígado', 'Coração', 'Rim'], 2),
  _QuestaoDemo('Ciências', 'Fácil', 'Qual é a fórmula química da água?',
      ['H₂O', 'CO₂', 'O₂', 'NaCl'], 0),
  _QuestaoDemo('Ciências', 'Fácil', 'Qual é o maior planeta do Sistema Solar?',
      ['Saturno', 'Júpiter', 'Netuno', 'Terra'], 1),
  _QuestaoDemo('Ciências', 'Média',
      'Em qual parte da célula eucarionte fica o material genético (DNA)?',
      ['Membrana', 'Citoplasma', 'Ribossomo', 'Núcleo'], 3),
  _QuestaoDemo('Ciências', 'Média',
      'Como se chama a passagem da água do estado líquido para o gasoso?',
      ['Fusão', 'Solidificação', 'Vaporização', 'Condensação'], 2),
  _QuestaoDemo('Ciências', 'Média', 'Qual é o maior osso do corpo humano?',
      ['Fêmur', 'Úmero', 'Tíbia', 'Crânio'], 0),
  _QuestaoDemo('Ciências', 'Difícil',
      'Quantos ossos tem, aproximadamente, o corpo humano adulto?',
      ['106', '206', '306', '156'], 1),
  _QuestaoDemo('Ciências', 'Fácil', 'Qual é a principal fonte de energia da Terra?',
      ['A Lua', 'O vento', 'O Sol', 'O petróleo'], 2),

  // História
  _QuestaoDemo('História', 'Fácil',
      'Em que ano o Brasil declarou a independência de Portugal?',
      ['1500', '1822', '1889', '1922'], 1),
  _QuestaoDemo('História', 'Média', 'Quem assinou a Lei Áurea em 1888?',
      ['Dom Pedro I', 'Dom Pedro II', 'Princesa Isabel', 'Marechal Deodoro'], 2),
  _QuestaoDemo('História', 'Fácil', 'Em que ano os portugueses chegaram ao Brasil?',
      ['1492', '1500', '1530', '1822'], 1),
  _QuestaoDemo('História', 'Média', 'Em que ano foi proclamada a República no Brasil?',
      ['1822', '1888', '1889', '1930'], 2),
  _QuestaoDemo('História', 'Fácil', 'Quem foi o primeiro imperador do Brasil?',
      ['Dom Pedro I', 'Dom João VI', 'Dom Pedro II', 'Getúlio Vargas'], 0),
  _QuestaoDemo('História', 'Fácil', 'Qual civilização construiu as pirâmides de Gizé?',
      ['Romana', 'Grega', 'Egípcia', 'Maia'], 2),
  _QuestaoDemo('História', 'Média', 'Em que ano começou a Segunda Guerra Mundial?',
      ['1914', '1929', '1939', '1945'], 2),
  _QuestaoDemo('História', 'Fácil', 'Qual navegador chegou à América em 1492?',
      ['Pedro Álvares Cabral', 'Cristóvão Colombo', 'Vasco da Gama',
          'Fernão de Magalhães'], 1),
  _QuestaoDemo('História', 'Difícil', 'Em que ano começou a Revolução Francesa?',
      ['1789', '1815', '1776', '1848'], 0),
  _QuestaoDemo('História', 'Média', 'Qual foi a primeira capital do Brasil?',
      ['Rio de Janeiro', 'Brasília', 'Salvador', 'São Paulo'], 2),

  // Geografia
  _QuestaoDemo('Geografia', 'Fácil', 'Qual é a capital do Brasil?',
      ['São Paulo', 'Rio de Janeiro', 'Brasília', 'Salvador'], 2),
  _QuestaoDemo('Geografia', 'Fácil',
      'Qual é o maior país da América do Sul em área?',
      ['Argentina', 'Brasil', 'Peru', 'Colômbia'], 1),
  _QuestaoDemo('Geografia', 'Fácil', 'Qual é o maior oceano do planeta?',
      ['Atlântico', 'Índico', 'Ártico', 'Pacífico'], 3),
  _QuestaoDemo('Geografia', 'Média',
      'Qual é o maior rio do Brasil em volume de água?',
      ['São Francisco', 'Paraná', 'Amazonas', 'Tocantins'], 2),
  _QuestaoDemo('Geografia', 'Fácil',
      'Em quantas regiões o IBGE divide o Brasil?',
      ['4', '5', '6', '7'], 1),
  _QuestaoDemo('Geografia', 'Média',
      'Qual linha imaginária divide a Terra em hemisfério Norte e hemisfério Sul?',
      ['Meridiano de Greenwich', 'Trópico de Capricórnio', 'Linha do Equador',
          'Trópico de Câncer'], 2),
  _QuestaoDemo('Geografia', 'Fácil',
      'Qual bioma brasileiro tem a maior floresta tropical do mundo?',
      ['Cerrado', 'Caatinga', 'Pampa', 'Amazônia'], 3),
  _QuestaoDemo('Geografia', 'Fácil', 'Qual é a capital de Santa Catarina?',
      ['Joinville', 'Florianópolis', 'Blumenau', 'Curitiba'], 1),
  _QuestaoDemo('Geografia', 'Média', 'Qual é o continente mais populoso?',
      ['África', 'Europa', 'Ásia', 'América'], 2),
  _QuestaoDemo('Geografia', 'Difícil', 'Qual é o ponto mais alto do Brasil?',
      ['Pico da Bandeira', 'Pico da Neblina', 'Monte Roraima', 'Pico Paraná'], 1),

  // Português
  _QuestaoDemo('Português', 'Fácil', 'Qual das palavras abaixo é um substantivo?',
      ['Correr', 'Bonito', 'Casa', 'Rapidamente'], 2),
  _QuestaoDemo('Português', 'Média', 'Qual é o plural de "cidadão"?',
      ['Cidadões', 'Cidadãos', 'Cidadães', 'Cidadans'], 1),
  _QuestaoDemo('Português', 'Média', 'Qual palavra está escrita corretamente?',
      ['Exceção', 'Excessão', 'Esceção', 'Execeção'], 0),
  _QuestaoDemo('Português', 'Fácil', 'Qual é o antônimo de "alegre"?',
      ['Feliz', 'Contente', 'Triste', 'Animado'], 2),
  _QuestaoDemo('Português', 'Fácil',
      'Na frase "O menino comeu a maçã", qual é o sujeito?',
      ['comeu', 'a maçã', 'O menino', 'maçã'], 2),
  _QuestaoDemo('Português', 'Fácil', 'Qual é o sinônimo de "rápido"?',
      ['Lento', 'Veloz', 'Calmo', 'Pesado'], 1),
  _QuestaoDemo('Português', 'Média', 'Quantas sílabas tem a palavra "computador"?',
      ['3', '4', '5', '2'], 1),
  _QuestaoDemo('Português', 'Média',
      'Qual das palavras é acentuada por ser proparoxítona?',
      ['Café', 'Lâmpada', 'Sofá', 'Até'], 1),
  _QuestaoDemo('Português', 'Difícil',
      'Qual figura de linguagem aparece em "Seus olhos são duas estrelas"?',
      ['Hipérbole', 'Metáfora', 'Ironia', 'Onomatopeia'], 1),
  _QuestaoDemo('Português', 'Média', 'Quem escreveu "Dom Casmurro"?',
      ['José de Alencar', 'Machado de Assis', 'Monteiro Lobato',
          'Carlos Drummond de Andrade'], 1),
];
