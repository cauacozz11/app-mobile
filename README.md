# PROVALEVE

Provas mais simples. Tempo para ensinar.

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Git](https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)

![Status](https://img.shields.io/badge/Status-Conclu%C3%ADdo-brightgreen?style=for-the-badge)
![Entrega](https://img.shields.io/badge/Entrega-Final%20(N3)-blue?style=for-the-badge)
![Licença](https://img.shields.io/badge/Licen%C3%A7a-MIT-green?style=for-the-badge)

</div>

---

## Equipe

| Integrante                        |
| --------------------------------- |
| Cauã Cozzarin                     |
| Mateus Wroblewski                 |
| Mário Augusto Bussarello Volpato  |
| Felipe Tomio Maciel               |
| Matheus Henrique Pompeu           |

---

## Sumário

* [Equipe](#equipe)
* [1. Resumo do Projeto](#1-resumo-do-projeto)
* [2. Objetivo](#2-objetivo)
* [3. Escopo Delimitado](#3-escopo-delimitado)
  * [3.1 Funcionalidades dentro do escopo](#31-funcionalidades-dentro-do-escopo)
  * [3.2 Funcionalidades previstas para evolução](#32-funcionalidades-previstas-para-evolução)
  * [3.3 Fora do escopo inicial](#33-fora-do-escopo-inicial)
* [4. Requisitos Funcionais — RF](#4-requisitos-funcionais--rf)
* [5. Requisitos Não Funcionais — RNF](#5-requisitos-não-funcionais--rnf)
* [6. Telas Principais](#6-telas-principais)
  * [6.1 Abertura](#61-abertura)
  * [6.2 Login](#62-login)
  * [6.3 Minhas Provas](#63-minhas-provas)
  * [6.4 Criar Prova](#64-criar-prova)
  * [6.5 Banco de Questões](#65-banco-de-questões)
  * [6.6 Nova Questão](#66-nova-questão)
  * [6.7 Resultado da Prova](#67-resultado-da-prova)
  * [6.8 Correção da Prova](#68-correção-da-prova)
  * [6.9 Lista de Resultados](#69-lista-de-resultados)
  * [6.10 Criar Conta](#610-criar-conta)
  * [6.11 Turmas e Disciplinas](#611-turmas-e-disciplinas)
  * [6.12 Visualizar Prova](#612-visualizar-prova)
  * [6.13 PDF da Prova e Gabarito com QRCode](#613-pdf-da-prova-e-gabarito-com-qrcode)
  * [6.14 Leitura do QRCode](#614-leitura-do-qrcode)
  * [6.15 Gabarito do Aluno](#615-gabarito-do-aluno)
* [7. Fluxo Principal do Sistema](#7-fluxo-principal-do-sistema)
* [8. Público-Alvo](#8-público-alvo)
* [9. Interface e Experiência de Uso](#9-interface-e-experiência-de-uso)
* [10. Status do Projeto](#10-status-do-projeto)
  * [10.1 Estado da integração com o banco de dados](#101-estado-da-integração-com-o-banco-de-dados)
  * [10.2 Configuração do Firebase no aplicativo](#102-configuração-do-firebase-no-aplicativo)
* [11. Como Rodar o Projeto](#11-como-rodar-o-projeto)
* [12. Stack Tecnológica](#12-stack-tecnológica)
* [13. Estrutura de Pastas](#13-estrutura-de-pastas)
* [14. Modelo de Dados](#14-modelo-de-dados)
* [15. Backlog de Atividades da N2](#15-backlog-de-atividades-da-n2)
* [16. Entrega Final (N3)](#16-entrega-final-n3)

---

## 1. Resumo do Projeto

O ProvaLeve é um aplicativo desenvolvido para auxiliar professores no processo de criação, organização e correção de provas.

O projeto surgiu a partir da necessidade de reduzir o tempo gasto pelos professores com a correção de avaliações. Durante períodos de provas, um professor pode ter um grande volume de avaliações para corrigir, tornando esse processo demorado.

A proposta do ProvaLeve é centralizar o processo de avaliação em uma aplicação, permitindo o gerenciamento de questões e provas, além da apresentação dos resultados após a correção.

O sistema também busca facilitar a análise do desempenho dos alunos, apresentando informações como acertos, erros, resposta marcada e alternativa correta.

---

## 2. Objetivo

O objetivo principal do ProvaLeve é simplificar e automatizar o processo de avaliação, reduzindo o trabalho manual realizado pelos professores.

O sistema tem como objetivos:

* Facilitar a criação de provas;
* Permitir o gerenciamento de um banco de questões;
* Reutilizar questões cadastradas;
* Automatizar a correção das provas;
* Apresentar os resultados de forma rápida;
* Facilitar a visualização de acertos e erros;
* Permitir a análise das respostas dos alunos.

A correção automatizada foi identificada pelo cliente como a funcionalidade mais importante do sistema.

---

## 3. Escopo Delimitado

### 3.1 Funcionalidades dentro do escopo

As funcionalidades dentro do escopo do projeto são:

* Abertura do aplicativo;
* Cadastro e login do professor (Firebase Authentication);
* Cadastro de turmas e disciplinas;
* Gerenciamento das provas;
* Criação de provas, com embaralhamento de questões e de alternativas;
* Visualização e edição da prova gerada;
* Banco de questões;
* Cadastro de novas questões;
* Definição do gabarito;
* Exportação da prova em PDF, com o gabarito e o QRCode em página separada;
* Correção pela leitura do QRCode;
* Visualização dos resultados;
* Visualização de acertos e erros;
* Visualização das respostas marcadas;
* Consulta detalhada das questões corrigidas;
* Relatório da prova corrigida em PDF.

Essas funcionalidades foram definidas nos wireframes do aplicativo e implementadas no app Flutter.

### 3.2 Funcionalidades previstas para evolução

Foram levantadas também algumas funcionalidades adicionais que podem ser incorporadas posteriormente:

* Importação da lista de alunos;
* Geração de provas individualizadas por aluno;
* Exportação dos resultados para Excel;
* Edição do layout da prova gerada.

Essas funcionalidades foram apresentadas pelo cliente como sugestões adicionais ao projeto.

### 3.3 Fora do escopo inicial

Não fazem parte do escopo inicial:

* Gerenciamento acadêmico completo da instituição;
* Criação de conteúdo educacional;
* Correção de questões discursivas;
* Funcionalidades que não estejam relacionadas ao processo de criação, aplicação e correção de provas.

---

## 4. Requisitos Funcionais — RF

| Código   | Requisito | Situação |
| -------- | --------- | -------- |
| **RF01** | O sistema deve permitir que o professor realize login utilizando e-mail e senha. | Atendido (Firebase Authentication) |
| **RF02** | O sistema deve permitir a recuperação de senha. | Parcial |
| **RF03** | O sistema deve permitir visualizar as provas do professor. | Atendido (Firestore) |
| **RF04** | O sistema deve permitir pesquisar provas. | Atendido (Firestore) |
| **RF05** | O sistema deve permitir filtrar provas por situação. | Atendido (Firestore) |
| **RF06** | O sistema deve permitir criar uma nova prova. | Atendido (Firestore) |
| **RF07** | O sistema deve permitir selecionar questões para compor uma prova. | Atendido (Firestore) |
| **RF08** | O sistema deve permitir pesquisar questões no banco de questões. | Atendido (Firestore) |
| **RF09** | O sistema deve permitir cadastrar novas questões. | Atendido (Firestore) |
| **RF10** | O sistema deve permitir cadastrar alternativas para uma questão. | Atendido (Firestore) |
| **RF11** | O sistema deve permitir definir a alternativa correta de uma questão. | Atendido (Firestore) |
| **RF12** | O sistema deve permitir editar questões cadastradas. | Atendido (Firestore) |
| **RF13** | O sistema deve permitir duplicar questões. | Atendido (Firestore) |
| **RF14** | O sistema deve permitir excluir questões. | Atendido (Firestore) |
| **RF15** | O sistema deve permitir salvar uma questão como rascunho. | Atendido (Firestore) |
| **RF16** | O sistema deve realizar a correção automatizada das provas. | Atendido (correção pela leitura do QRCode, com a nota calculada e salva no Firestore) |
| **RF17** | O sistema deve permitir que o professor visualize a nota obtida pelo aluno. | Atendido (Firestore) |
| **RF18** | O sistema deve permitir que o professor visualize a quantidade de acertos e erros do aluno. | Atendido (Firestore) |
| **RF19** | O sistema deve permitir que o professor visualize a resposta marcada pelo aluno. | Atendido (Firestore) |
| **RF20** | O sistema deve permitir que o professor visualize a alternativa correta nas questões em que o aluno errou. | Atendido (Firestore) |
| **RF21** | O sistema deve permitir que o professor visualize a correção detalhada da prova do aluno. | Atendido (Firestore) |
| **RF22** | O sistema deve permitir compartilhar ou exportar o resultado. | Atendido (compartilhamento com share_plus) |
| **RF23** | O sistema deve permitir que o professor crie uma conta (cadastro). | Atendido (Firebase Authentication e coleção `usuarios`) |
| **RF24** | O sistema deve permitir cadastrar turmas e disciplinas. | Atendido (Firestore) |
| **RF25** | O sistema deve permitir associar a prova a uma turma. | Atendido (Firestore) |
| **RF26** | O sistema deve permitir embaralhar as questões e as alternativas ao gerar a prova. | Atendido |
| **RF27** | O sistema deve permitir visualizar e editar a prova gerada. | Atendido (Firestore) |
| **RF28** | O sistema deve exportar a prova em PDF, com o gabarito e o QRCode em página separada das questões. | Atendido |
| **RF29** | O sistema deve corrigir a prova pela leitura do QRCode, exibindo e salvando a nota do aluno. | Atendido (Firestore) |
| **RF30** | O sistema deve mostrar o status da prova após as correções e gerar o relatório. | Atendido (status "Corrigida" e relatório em PDF) |

Os requisitos RF01 a RF22 foram definidos a partir das funcionalidades descritas nos wireframes e das necessidades apresentadas pelo cliente. Os requisitos RF23 a RF30 vieram das funcionalidades pedidas pelo cliente para a entrega final. A coluna Situação mostra o que está implementado no aplicativo.

Legenda da situação:

* **Atendido (Firestore):** a funcionalidade está implementada e grava ou lê os dados no Firestore. As provas (RF03 a RF06) usam o `ProvasRepository`, as questões (RF07 e RF08 a RF15) usam o `QuestoesRepository`, as turmas (RF24 e RF25) usam o `TurmasRepository` e os resultados (RF17 a RF21 e RF29) usam o `ResultadosRepository`;
* **Atendido (Firebase Authentication):** a conta do professor é criada e validada pelo Firebase Authentication, e o perfil fica na coleção `usuarios`;
* **Atendido (compartilhamento com share_plus):** o resultado é compartilhado pelo menu de compartilhamento do celular;
* **Parcial:** existe apenas a interface, sem a lógica completa;
* **Não atendido:** ainda não foi implementado.

Observação sobre a correção (RF16 e RF29): o PDF da prova traz um QRCode com o identificador da prova. Ao ler esse QRCode, o aplicativo reconhece a prova e abre a tela de correção, onde o professor informa o nome do aluno e marca a alternativa escolhida em cada questão. O aplicativo também gera o **gabarito do aluno**: o aluno marca as respostas no celular e a tela gera um QRCode que já leva o nome e as respostas; ao ler esse QRCode, a correção é feita sozinha, sem marcação manual. Nos dois casos, o aplicativo calcula acertos, erros e nota, grava o resultado na coleção `resultados`, muda a prova para "corrigida" e mostra a nota na tela. A tela de resultado (RF17 a RF21) é voltada ao professor, e não ao aluno.

Observação sobre o Firestore e os dados locais: o banco de questões lista, cria, edita, duplica e exclui as questões no Firestore (RF08 a RF15), e a lista é carregada do banco sempre que a tela é aberta. A tela de criar prova (RF07) lista as questões publicadas do banco (sem os rascunhos) para o professor escolher. Os resultados (RF17 a RF21) vêm do Firestore: ao tocar em "Ver resultado" ou "Visualizar Resultados" em uma prova corrigida, o aplicativo lista os resultados gravados na coleção `resultados` (`listarPorProva`), com a média da turma e a nota e os acertos de cada aluno, e a tela de resultado mostra o nome do aluno, as respostas marcadas e a correção detalhada. Recuperar senha (RF02) mostra apenas um aviso orientando o professor a falar com a instituição.

---

## 5. Requisitos Não Funcionais — RNF

| Código    | Requisito                                                                                    | Situação |
| --------- | -------------------------------------------------------------------------------------------- | -------- |
| **RNF01** | A interface deve ser simples e fácil de utilizar.                                            | Atendido (telas minimalistas, seguindo os wireframes) |
| **RNF02** | A navegação deve ser lógica e objetiva.                                                      | Atendido (rotas nomeadas, seguindo o fluxo da seção 7) |
| **RNF03** | As informações devem ser apresentadas de forma clara e organizada.                           | Atendido |
| **RNF04** | O sistema deve proteger as informações de acesso do professor.                               | Atendido (a senha fica oculta na tela, é validada pelo Firebase Authentication e não é gravada no Firestore) |
| **RNF05** | O resultado da correção deve ser apresentado de forma rápida.                                | Atendido (a nota é calculada no próprio aplicativo, em `lib/utils/correcao.dart`, sem depender de rede) |
| **RNF06** | A interface deve evitar excesso de elementos visuais.                                        | Atendido |
| **RNF07** | Os acertos e erros devem possuir identificação visual clara.                                 | Atendido (cores e ícones de certo e errado na tela de resultado) |
| **RNF08** | Cada professor deve ter acesso somente às suas próprias provas e questões.                   | Atendido (o `professorId`, que é o uid do Firebase Authentication, é gravado em cada documento e as consultas são filtradas por ele em `lib/data/firestore_repository.dart`) |
| **RNF09** | O sistema deve apresentar mensagens de erro quando ocorrerem problemas durante uma operação. | Atendido (mensagens de erro em `lib/utils/mensagem_erro.dart`, estados de carregando, vazio e erro em `lib/widgets/estado_tela.dart` e avisos nas telas) |
| **RNF10** | O aplicativo deve possuir uma interface adequada para dispositivos móveis.                   | Atendido (aplicativo Flutter com layout para celular) |

A preferência do cliente é por uma interface minimalista, lógica, amigável e com poucos elementos na tela.

---

## 6. Telas Principais

O ProvaLeve possui 15 telas principais implementadas em Flutter. As telas 6.1 a 6.9 vieram dos wireframes; as telas 6.10 a 6.15 foram criadas para as funcionalidades da entrega final.

### 6.1 Abertura

É a primeira tela apresentada ao iniciar o aplicativo.

![Tela de abertura](docs/telas/01-abertura.png)

*Figura 6.1 — Tela de abertura com a identidade visual do ProvaLeve.*

Função:

* Apresentar a identidade visual do ProvaLeve;
* Exibir o nome e slogan;
* Apresentar o carregamento inicial;
* Encaminhar o usuário para o login.

---

### 6.2 Login

Tela responsável pela autenticação do professor.

![Tela de login](docs/telas/02-login.png)

*Figura 6.2 — Tela de login com e-mail e senha.*

Elementos principais:

* Campo de e-mail;
* Campo de senha;
* Exibição/ocultação da senha;
* Recuperação de senha;
* Botão "Entrar", que valida o e-mail e a senha no Firebase Authentication;
* Link "Ainda não tem conta? Criar conta", que abre o cadastro (6.10).

---

### 6.3 Minhas Provas

Tela principal apresentada após o login.

![Tela Minhas Provas](docs/telas/03-minhas-provas.png)

*Figura 6.3 — Lista de provas do professor, com busca e filtros por situação.*

Elementos principais:

* Perfil do professor;
* Lista de provas;
* Busca;
* Filtros;
* Status das provas (rascunho, pronta e corrigida);
* Acesso aos resultados;
* Botão "Ler QRCode", para corrigir uma prova a partir do QRCode;
* Botão "Nova prova";
* Menu inferior com Provas, Questões, Turmas e Perfil.

Ao tocar em uma prova, abrem os detalhes com as ações de acordo com o status: "Ver questões da prova", "Editar prova", "Exportar PDF (prova e gabarito)", "Corrigir lendo o QRCode do gabarito", "Gerar gabarito do aluno (QRCode)", "Corrigir prova" e "Visualizar Resultados".

---

### 6.4 Criar Prova

Tela utilizada para montar uma nova prova utilizando questões cadastradas.

![Tela Criar Prova](docs/telas/04-criar-prova.png)

*Figura 6.4 — Montagem de uma prova com a seleção das questões.*

Elementos principais:

* Título da prova;
* Disciplina;
* Turma (opcional, entre as turmas da disciplina escolhida);
* Busca de questões;
* Filtros;
* Seleção das questões do banco;
* Contador de questões selecionadas;
* Visualização dos detalhes das questões;
* Opções "Embaralhar questões" e "Embaralhar alternativas";
* Salvar como rascunho ou postar a prova.

Ao embaralhar as alternativas, a alternativa correta acompanha a nova posição, então o gabarito e a correção continuam certos (`lib/utils/embaralhar.dart`). A mesma janela é usada para editar uma prova em rascunho ou já postada.

---

### 6.5 Banco de Questões

Tela responsável por centralizar as questões cadastradas.

![Tela Banco de Questões](docs/telas/05-banco-questoes.png)

*Figura 6.5 — Banco de questões com busca, filtros e ações sobre cada questão.*

Elementos principais:

* Quantidade de questões cadastradas;
* Busca;
* Filtros;
* Organização por disciplina;
* Nível de dificuldade;
* Editar questão;
* Duplicar questão;
* Excluir questão;
* Criar nova questão.

---

### 6.6 Nova Questão

Tela destinada ao cadastro de uma nova questão de múltipla escolha.

![Tela Nova Questão](docs/telas/06-nova-questao.png)

*Figura 6.6 — Cadastro de uma questão de múltipla escolha com definição do gabarito.*

Elementos principais:

* Disciplina;
* Enunciado;
* Alternativas;
* Reordenação das alternativas;
* Definição do gabarito;
* Adição de alternativas;
* Salvar como rascunho;
* Salvar questão.

---

### 6.7 Resultado da Prova

Tela voltada ao professor, responsável pela apresentação do resultado de um aluno após a correção da prova. O aluno não acessa o aplicativo: é o professor quem visualiza a nota, o desempenho e as respostas do aluno.

![Tela Resultado da Prova](docs/telas/07-resultado.png)

*Figura 6.7 — Resultado de um aluno com nota, acertos, erros e correção detalhada.*

Elementos principais:

* Nota;
* Percentual de desempenho;
* Quantidade de acertos;
* Quantidade de erros;
* Filtro entre acertos e erros;
* Resposta marcada;
* Alternativa correta;
* Correção detalhada;
* Compartilhamento do resultado.

---

### 6.8 Correção da Prova

Tela em que o professor corrige a prova de um aluno. Ela é aberta pela leitura do QRCode da prova (6.14) ou pelos detalhes de uma prova já postada ("Corrigir prova"), e também pode ser usada de novo para corrigir a prova de outro aluno. O professor informa o nome do aluno e marca a alternativa que o aluno escolheu em cada questão. O aplicativo calcula os acertos, os erros e a nota, grava o resultado na coleção `resultados` do Firestore e muda a prova para "corrigida". Em seguida, abre a tela de resultado.

![Tela Correção da Prova](docs/telas/08-correcao.png)

*Figura 6.8 — Correção de uma prova com o nome do aluno e as respostas marcadas pelo professor.*

Elementos principais:

* Título e disciplina da prova;
* Campo com o nome do aluno (obrigatório);
* Lista das questões, com as alternativas para marcar a resposta do aluno;
* Contador de questões marcadas;
* Aviso de questões em branco, que contam como erro;
* Botão "Corrigir e salvar".

---

### 6.9 Lista de Resultados

Tela aberta por "Visualizar Resultados" (ou "Ver resultado") em uma prova corrigida na tela Minhas Provas. Ela lê do Firestore os resultados gravados na correção daquela prova e mostra o desempenho da turma. Ao tocar em um aluno, o professor abre a tela de resultado (6.7) com o nome, a nota e a correção detalhada.

![Tela Lista de Resultados](docs/telas/09-lista-resultados.png)

*Figura 6.9 — Lista dos alunos corrigidos de uma prova, com a média da turma, a nota e os acertos de cada um.*

Elementos principais:

* Título e disciplina da prova;
* Quantidade de alunos corrigidos;
* Média da turma;
* Lista de alunos, em ordem alfabética, com a nota e os acertos de cada um;
* Botão "Exportar relatório (PDF)";
* Estados de carregando, erro (com "Tentar novamente") e "Nenhum aluno corrigido".

O relatório em PDF (`lib/utils/relatorio_pdf.dart`) traz o título, a disciplina, a turma e o status da prova, a quantidade de alunos corrigidos, a média da turma, a maior e a menor nota, e uma tabela com os acertos e a nota de cada aluno.

---

### 6.10 Criar Conta

Tela de cadastro do professor, aberta pelo link "Ainda não tem conta? Criar conta" no login.

Elementos principais:

* Nome completo (mínimo de 3 caracteres);
* E-mail;
* Instituição (opcional);
* Disciplinas, separadas por vírgula (opcional);
* Senha (mínimo de 6 caracteres) e confirmação da senha;
* Botão "Criar conta".

A conta é criada no Firebase Authentication e o perfil (nome, e-mail, instituição e disciplinas) é gravado na coleção `usuarios`, sem a senha. Depois do cadastro, o professor já entra no aplicativo.

Para a conta nova não começar vazia, o cadastro grava dados de exemplo (`lib/data/dados_demo.dart`): 50 questões no banco (10 de cada disciplina: Matemática, Ciências, História, Geografia e Português), a turma "8º ano A" de Matemática e a prova postada "Avaliação de Matemática — 8º ano A", com 5 questões. Essa prova tem sempre o mesmo id e o mesmo conteúdo, então o PDF dela pode ser impresso antes e o QRCode impresso funciona na conta criada depois. A cada conta nova, a prova de exemplo passa a ser dessa conta.

---

### 6.11 Turmas e Disciplinas

Tela aberta pela aba "Turmas" do menu inferior. Lista as turmas do professor gravadas na coleção `turmas` do Firestore.

Elementos principais:

* Lista das turmas, com o nome e a disciplina;
* Botão "Nova turma", com o nome da turma e a disciplina;
* Excluir turma, com confirmação;
* Estados de carregando, erro e "Nenhuma turma criada".

---

### 6.12 Visualizar Prova

Tela aberta por "Ver questões da prova" nos detalhes de uma prova. Mostra a prova como foi gerada, já com a ordem das questões e das alternativas depois do embaralhamento, e destaca a alternativa correta de cada questão.

---

### 6.13 PDF da Prova e Gabarito com QRCode

Gerado por "Exportar PDF (prova e gabarito)" nos detalhes de uma prova (`lib/utils/prova_pdf.dart`). O PDF tem duas partes, em páginas separadas:

* **Folha de questões:** título, disciplina, turma, campos de nome e data do aluno, o QRCode da prova e as questões com as alternativas;
* **Gabarito:** em página separada das questões, com o QRCode da prova e a alternativa correta de cada questão.

O PDF pode ser visualizado, impresso ou compartilhado pelo próprio celular.

---

### 6.14 Leitura do QRCode

Tela aberta pelo botão "Ler QRCode" em Minhas Provas ou por "Corrigir lendo o QRCode do gabarito" nos detalhes de uma prova. Usa a câmera do celular para ler o QRCode:

* **QRCode da prova (impresso no PDF):** o aplicativo reconhece a prova e abre a tela de correção (6.8);
* **QRCode do gabarito do aluno (6.15):** o aplicativo corrige a prova sozinho, salva o resultado e mostra a nota.

O aplicativo avisa quando o QRCode é de outra prova, de uma prova que não é do professor logado ou de uma prova ainda em rascunho.

---

### 6.15 Gabarito do Aluno

Tela aberta por "Gerar gabarito do aluno (QRCode)" nos detalhes de uma prova postada. O aluno informa o nome e marca a alternativa de cada questão; a tela gera um QRCode com o nome e as respostas. Ao ler esse QRCode (6.14), a correção é feita sem marcação manual.

---

## 7. Fluxo Principal do Sistema

```text
ABERTURA
   ↓
LOGIN ←→ CRIAR CONTA
   ↓
MINHAS PROVAS ──→ TURMAS (nova turma/disciplina)
   │
   ├──→ BANCO DE QUESTÕES ──→ NOVA QUESTÃO
   │
   ↓
NOVA PROVA (questões do banco + turma + embaralhamento)
   ↓
VISUALIZAR / EDITAR PROVA
   ↓
EXPORTAR PDF (questões + gabarito com QRCode)
   ↓
LEITURA DO QRCODE
   ↓
CORREÇÃO (nota calculada e salva)
   ↓
RESULTADO DA PROVA
   ↓
LISTA DE RESULTADOS (status "Corrigida" + relatório em PDF)
```

---

## 8. Público-Alvo

O ProvaLeve é destinado principalmente a professores que trabalham com avaliações e possuem um grande volume de provas para corrigir.

O sistema busca reduzir o tempo utilizado na correção e facilitar a análise dos resultados obtidos pelos alunos.

---

## 9. Interface e Experiência de Uso

A interface do ProvaLeve foi projetada para ser simples, amigável e objetiva.

A proposta considera uma navegação lógica e uma quantidade reduzida de elementos na tela, seguindo a preferência apresentada pelo cliente por uma experiência mais minimalista.

Os wireframes validaram o fluxo de utilização do aplicativo, e as telas implementadas em Flutter seguem esse fluxo.

---

## 10. Status do Projeto

Status: Concluído ✅

Entrega atual: entrega final (N3).

O aplicativo cobre todo o fluxo pedido pelo cliente, do cadastro do professor ao relatório da prova corrigida, com os dados no Firebase:

* **Cadastro e login:** a conta do professor é criada e validada pelo Firebase Authentication, e o perfil fica na coleção `usuarios` (RF01, RF23 e RNF04);
* **Turmas e disciplinas:** cadastro e exclusão de turmas na coleção `turmas`, e associação da prova a uma turma (RF24 e RF25);
* **Embaralhamento:** ao gerar a prova, as questões e as alternativas podem ser embaralhadas, e a alternativa correta acompanha a nova posição (RF26);
* **Visualizar e editar prova:** "Ver questões da prova" mostra a prova gerada e "Editar prova" altera rascunhos e provas postadas (RF27);
* **PDF com QRCode:** a prova é exportada em PDF com as questões e, em página separada, o gabarito com o QRCode (RF28);
* **Correção pelo QRCode:** a câmera lê o QRCode da prova ou do gabarito do aluno, e a nota é calculada, salva e mostrada na tela (RF16 e RF29);
* **Status e relatório:** a prova corrigida aparece como "Corrigida" e a lista de resultados gera o relatório em PDF (RF30);
* **Minhas Provas:** lista, pesquisa e filtra as provas gravadas no Firestore, cria novas provas e atualiza rascunhos e provas postadas;
* **Banco de Questões e Nova Questão:** a tela lista as questões do Firestore ao abrir e permite criar, editar, duplicar e excluir questões (inclusive rascunhos) direto no Firestore;
* **Criar Prova:** a seleção de questões lê as questões publicadas do Firestore (sem rascunhos), com busca e filtro por dificuldade, e tem estados de carregando, erro e vazio (RF07);
* **Camada de acesso a dados:** `ProvasRepository`, `QuestoesRepository`, `ResultadosRepository` e `TurmasRepository`, em `lib/data/`, gravam o `professorId` e filtram as consultas por ele (RNF08); o `UsuariosRepository` guarda o perfil do professor;
* **Tratamento de erros:** mensagens de erro, estados de carregando, lista vazia e erro, e avisos nas telas (RNF09);
* **Correção da prova:** aberta pela leitura do QRCode; o aplicativo calcula acertos, erros e nota, grava o resultado na coleção `resultados` e muda a prova para "corrigida" (RF16);
* **Lista de resultados:** "Visualizar Resultados" em Minhas Provas lista os resultados reais da prova lidos do Firestore, com a média da turma e a nota e os acertos de cada aluno (RF17 a RF21);
* **Resultado da prova:** mostra o nome do aluno, a nota, os acertos e erros e a correção detalhada, e pode ser compartilhado pelo menu de compartilhamento do celular (RF22).

O que continua parcial:

* Recuperação de senha (RF02): "Esqueci minha senha" mostra um aviso orientando o professor a falar com a instituição.

Vídeo de apresentação: https://www.youtube.com/watch?v=Q-urOUDrMoM


### 10.1 Estado da integração com o banco de dados

O ProvaLeve usa o **Cloud Firestore** (Firebase) como banco de dados. A tabela mostra, para cada parte do aplicativo, se ela já lê e grava no Firestore ou se ainda usa dados locais.

| Parte do aplicativo | Operação | Estado | Onde está |
| ------------------- | -------- | ------ | --------- |
| Inicialização do Firebase | Conexão do aplicativo com o projeto Firebase | Integrada | `lib/main.dart` e `lib/firebase_options.dart` |
| Classes de domínio | Conversão de e para o Firestore (`toMap` e `fromMap`) | Integrada | `lib/models/` |
| Criar Conta | Criar a conta e gravar o perfil do professor | Integrada | `lib/utils/autenticacao.dart` e `UsuariosRepository` |
| Login | Entrar com e-mail e senha | Integrada (Firebase Authentication) | `lib/utils/autenticacao.dart` |
| Recuperar senha | Aviso para falar com a instituição | Local | `lib/screens/login/` |
| Turmas | Listar, criar e excluir turmas e disciplinas | Integrada | `TurmasRepository` |
| Minhas Provas | Listar, pesquisar, filtrar, criar e atualizar provas | Integrada | `ProvasRepository` |
| Criar Prova | Listar as questões publicadas para seleção | Integrada | `QuestoesRepository` |
| Banco de Questões | Listar, editar, duplicar e excluir questões | Integrada | `QuestoesRepository` |
| Nova Questão | Criar questão e salvar como rascunho | Integrada | `QuestoesRepository` |
| Correção pelo QRCode | Gravar o resultado do aluno e mudar a prova para "corrigida" | Integrada | `ResultadosRepository` e `ProvasRepository` |
| Lista de Resultados e Resultado da Prova | Ler os resultados gravados de uma prova | Integrada | `ResultadosRepository` |
| PDF da prova e relatório | Gerar os PDFs no próprio celular | Local (gerado no aparelho) | `lib/utils/prova_pdf.dart` e `lib/utils/relatorio_pdf.dart` |
| Perfil | Mostrar os dados do professor logado | Integrada | `UsuariosRepository` |

Legenda:

* **Integrada:** a parte lê ou grava os dados no Firestore, sem lista fixa no código;
* **Local:** a parte não depende do banco de dados.

Validação e tratamento de erros nas operações com o banco:

* Os campos são validados antes de gravar. O login e o cadastro usam os validadores de `lib/utils/validators.dart` (nome, e-mail, senha e confirmação da senha), e os erros do Firebase Authentication (e-mail já cadastrado, senha fraca, e-mail ou senha inválidos, sem internet) viram mensagens claras para o professor. O cadastro de questão exige a disciplina, o enunciado (mínimo de 10 caracteres), todas as alternativas preenchidas e sem repetição, e a alternativa correta marcada;
* Ao editar uma questão, "Salvar rascunho" também exige os dados completos, para não sobrescrever no banco uma questão válida com dados incompletos;
* Editar, duplicar e excluir mostram um aviso de sucesso ou de erro ao gravar, e excluir pede confirmação antes;
* As listas têm estados de carregando, vazio e erro (RNF09).

Os campos de cada coleção estão na seção [14. Modelo de Dados](#14-modelo-de-dados).

### 10.2 Configuração do Firebase no aplicativo

A conexão do aplicativo Android com o Firebase foi feita assim:

1. O projeto **ProvaLeve** (`provaleve-46c08`, plano Spark) foi criado no console do Firebase, e o **Cloud Firestore** e o **Authentication** (login por e-mail e senha) foram ativados;
2. As dependências `firebase_core`, `cloud_firestore` e `firebase_auth` foram adicionadas ao `pubspec.yaml` (versões na seção [12. Stack Tecnológica](#12-stack-tecnológica));
3. O comando `flutterfire configure` (plataforma Android) gerou o arquivo `lib/firebase_options.dart` e o arquivo `android/app/google-services.json`;
4. No `lib/main.dart`, o Firebase é inicializado antes de abrir o aplicativo:

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

Observações:

* O `google-services.json` não fica no repositório. Para rodar o aplicativo, veja o passo 2 da seção [11. Como Rodar o Projeto](#11-como-rodar-o-projeto);
* O acesso ao console do Firebase é feito por permissão da conta. Para ver os dados no console, peça ao responsável pelo Firebase do grupo para adicionar o seu e-mail ao projeto.

---

## 11. Como Rodar o Projeto

### Pré-requisitos

* [Flutter SDK](https://docs.flutter.dev/get-started/install) com Dart ^3.13.2;
* Android Studio (ou VS Code) com o plugin do Flutter;
* Um emulador Android ou um celular com depuração USB ativada (para ler o QRCode, use um celular com câmera);
* Git.

O aplicativo está configurado para **Android**. As versões para Windows, web e iOS não têm o Firebase configurado.

Para conferir o ambiente:

```bash
flutter doctor
```

### Passo a passo

```bash
# 1. Clonar o repositório
git clone https://github.com/cauacozz11/app-mobile.git
cd app-mobile

# 2. Colocar o arquivo google-services.json em android/app/
#    (ele não vem no repositório; veja a observação abaixo)

# 3. Baixar as dependências
flutter pub get

# 4. Listar os dispositivos disponíveis
flutter devices

# 5. Executar o aplicativo
flutter run
```

### Observações

* **Passo 2, obrigatório:** para compilar o app, é necessário o arquivo `google-services.json` do projeto Firebase em `android/app/google-services.json`. Ele não fica no repositório (está no `.gitignore`); peça ao responsável pelo Firebase do grupo e copie o arquivo para essa pasta antes de rodar o `flutter run`.
* Para entrar no aplicativo, crie uma conta em "Ainda não tem conta? Criar conta" na tela de login e depois entre com o e-mail e a senha cadastrados.

### Gerar o APK

```bash
flutter build apk --release
```

O APK fica em `build/app/outputs/flutter-apk/app-release.apk`. Para instalar, copie o arquivo para o celular Android e abra-o (é preciso permitir a instalação de fontes desconhecidas).

---

## 12. Stack Tecnológica

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat-square&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat-square&logo=firebase&logoColor=black)
![Cloud Firestore](https://img.shields.io/badge/Cloud%20Firestore-FF6F00?style=flat-square&logo=firebase&logoColor=white)

* **Flutter:** framework usado para criar o aplicativo móvel (interface em Material Design);
* **Dart:** linguagem do aplicativo, com SDK `^3.13.2` (definido no `pubspec.yaml`);
* **Firebase:** plataforma do projeto, inicializada no app pelo `firebase_core` (`^5.1.0`);
* **Cloud Firestore:** banco de dados NoSQL do projeto, acessado pelo pacote `cloud_firestore` (`^7.1.0`);
* **Firebase Authentication:** cadastro e login do professor por e-mail e senha, pelo pacote `firebase_auth` (`^7.1.0`);
* **share_plus:** pacote (`^13.3.1`) usado para compartilhar o resultado da prova pelo menu de compartilhamento do celular;
* **pdf** (`^3.11.3`) e **printing** (`^5.14.2`): geração do PDF da prova, do gabarito e do relatório, e a visualização, impressão e compartilhamento do PDF;
* **barcode** (`^2.2.8`): desenho do QRCode dentro do PDF;
* **qr_flutter** (`^4.1.0`): QRCode do gabarito do aluno na tela do celular;
* **mobile_scanner** (`^7.0.1`): leitura do QRCode pela câmera do celular.

---

## 13. Estrutura de Pastas

```text
app-mobile/
├── docs/
│   ├── modelo_firestore.md
│   ├── telas/
│   └── testes/
├── lib/
│   ├── data/
│   │   ├── dados_demo.dart
│   │   ├── firestore_repository.dart
│   │   ├── provas_repository.dart
│   │   ├── questoes_repository.dart
│   │   ├── resultados_repository.dart
│   │   ├── turmas_repository.dart
│   │   └── usuarios_repository.dart
│   ├── models/
│   │   ├── alternativa.dart
│   │   ├── prova.dart
│   │   ├── questao.dart
│   │   ├── resultado.dart
│   │   ├── sessao.dart
│   │   ├── turma.dart
│   │   └── usuario.dart
│   ├── screens/
│   │   ├── correcao/
│   │   ├── login/
│   │   ├── perfil/
│   │   ├── provas/
│   │   ├── questoes/
│   │   ├── resultados/
│   │   ├── turmas/
│   │   └── splash.dart
│   ├── utils/
│   │   ├── autenticacao.dart
│   │   ├── correcao.dart
│   │   ├── embaralhar.dart
│   │   ├── mensagem_erro.dart
│   │   ├── prova_pdf.dart
│   │   ├── relatorio_pdf.dart
│   │   └── validators.dart
│   ├── widgets/
│   │   └── estado_tela.dart
│   ├── firebase_options.dart
│   └── main.dart
├── test/
│   ├── correcao_test.dart
│   └── mensagem_erro_test.dart
└── pubspec.yaml
```

* **docs/:** documentação do projeto. `modelo_firestore.md` descreve as coleções do Firestore, `telas/` guarda os prints das telas usados neste README e `testes/` traz o relatório de testes do fluxo completo com as evidências;
* **lib/data/:** camada de acesso ao Firestore. `FirestoreRepository` tem as operações comuns (listar, buscar, criar, atualizar e excluir, com `professorId`) e cada coleção tem o seu repositório; o `UsuariosRepository` guarda o perfil do professor, com o uid do Firebase Authentication como id;
* **lib/models/:** classes de domínio (`Usuario`, `Questao`, `Alternativa`, `Prova`, `Resultado`, `Turma`), com conversão de e para o Firestore (`toMap` e `fromMap`), e a `Sessao`, que guarda o professor logado;
* **lib/screens/:** as telas do aplicativo, uma subpasta para cada área:
  * **correcao/:** correção da prova (`correcao_prova_screen.dart`), leitura do QRCode pela câmera (`leitor_qr_screen.dart`) e gabarito do aluno com QRCode (`gabarito_aluno_screen.dart`);
  * **login/:** tela de login, tela de cadastro (`cadastro_screen.dart`) e os usuários de teste usados no desenvolvimento (`mock_usuario.dart`);
  * **perfil/:** tela de perfil do professor;
  * **provas/:** listagem de provas (Minhas Provas), janela de criação e edição de prova (`criar_prova_modal.dart`) e visualização da prova (`visualizar_prova_screen.dart`);
  * **questoes/:** banco de questões, cadastro de nova questão e a classe `QuestaoCadastrada`;
  * **resultados/:** lista de resultados de uma prova (`lista_resultados_screen.dart`) e tela de resultado de um aluno (`resultado_prova_screen.dart`);
  * **turmas/:** turmas e disciplinas do professor (`turmas_screen.dart`);
  * **splash.dart:** tela de abertura;
* **lib/utils/:** funções de apoio: cadastro e login pelo Firebase Authentication (`autenticacao.dart`), validação de campos (`validators.dart`), a conta da correção (`correcao.dart`), o embaralhamento de questões e alternativas (`embaralhar.dart`), o PDF da prova com o gabarito e o QRCode (`prova_pdf.dart`), o relatório em PDF (`relatorio_pdf.dart`) e as mensagens de erro para o professor (`mensagem_erro.dart`);
* **lib/widgets/:** componentes reutilizáveis; `estado_tela.dart` traz os estados de carregando, lista vazia e erro;
* **test/:** testes automatizados: `correcao_test.dart` (conta da correção e leitura do resultado) e `mensagem_erro_test.dart` (mensagens de erro).

---

## 14. Modelo de Dados

O ProvaLeve guarda os dados em cinco coleções na raiz do Firestore. Em todas elas o id do documento é o mesmo `id` da classe de domínio; em `usuarios`, é o uid do Firebase Authentication.

| Coleção | O que guarda | Situação no app |
| ------- | ------------ | --------------- |
| `usuarios` | Dados do professor: nome, e-mail, instituição e disciplinas (a senha não é gravada; ela fica no Firebase Authentication). | Gravada no cadastro e lida no login. |
| `turmas` | Turmas do professor: nome e disciplina. | Lida, gravada e excluída pela tela de turmas e lida na criação da prova. |
| `questoes` | Banco de questões do professor: disciplina, dificuldade, rascunho, enunciado, alternativas e alternativa correta. | Lida, gravada, editada e excluída pelo banco de questões. |
| `provas` | Provas montadas pelo professor: título, disciplina, situação, data, turma (`turmaId` e `turmaNome`) e uma cópia das questões escolhidas, já na ordem embaralhada. | Lida e gravada pela tela Minhas Provas. |
| `resultados` | Resultado da correção de um aluno: prova corrigida, nome do aluno, respostas marcadas e nota. | Gravada pela correção (um documento por aluno corrigido, com o nome do aluno) e lida pela lista de resultados e pelo relatório. |

As coleções `turmas`, `questoes`, `provas` e `resultados` guardam o `professorId`, que liga cada documento ao professor dono dele e permite listar só os dados dele (RNF08). A prova guarda uma cópia das questões, então editar ou excluir uma questão do banco não altera uma prova já montada.

O diagrama, os campos de cada coleção e as decisões de modelagem estão em [docs/modelo_firestore.md](docs/modelo_firestore.md).

---

## 15. Backlog de Atividades da N2

O backlog segue o planejamento da N2 (`PlanejamentoN2.xlsx`). O status considera o que já foi mesclado na branch `main` por commit ou Pull Request.

### Cauã Cozzarin

| Tarefa | Prazo | Status |
| ------ | ----- | ------ |
| 1. Reunião de planejamento e divisão de tarefas | 02/10/2026 | Concluído |
| 8. Tela 1: trocar dados mock por leitura do Firestore | 16/10/2026 | Concluído |
| 12. Funcionalidade central do escopo do cliente (ponta a ponta): tela de correção da prova (PR #39) | 22/10/2026 | Concluído |
| 19. Zerar PRs pendentes e merge final | 27/10/2026 | Concluído |
| 22. Diário de bordo individual – Cauã Cozzarin | 29/10/2026 | Concluído |
| Extra: ajustes gerais (renomear `validators.dart` e remover o teste de conexão do `main.dart`, PR #37) | — | Concluído |
| Extra: Visualizar Resultados com a lista de resultados reais lidos do Firestore e remoção do `mock_resultado.dart` (PR #40) | — | Concluído |

### Mateus Wroblewski

| Tarefa | Prazo | Status |
| ------ | ----- | ------ |
| 2. Levantar pendências da N1 (itens "não atendido" do README) | 05/10/2026 | Concluído |
| 3. Ampliar e ajustar as Issues no repositório (Issues #23 a #31) | 06/10/2026 | Concluído |
| 9. Tela 2: trocar dados mock por gravação no Firestore (Nova Questão, PR #33) | 16/10/2026 | Concluído |
| 16. Ajustes pendentes da N1 (RNF e tela de resultado) | 23/10/2026 | Concluído |
| 20. README v2: escopo, telas e RF/RNF (PR #22 e esta atualização) | 28/10/2026 | Concluído |
| 23. Diário de bordo individual – Mateus Wroblewski | 29/10/2026 | Concluído |
| Extra: revisão dos PRs #21, #32 e #34 | — | Concluído |
| Extra: merge do PR #32 | — | Concluído |
| Extra: Banco de Questões carregando do Firestore, sem dados mock (PR #38) | — | Concluído |

### Mário Augusto Bussarello Volpato

| Tarefa | Prazo | Status |
| ------ | ----- | ------ |
| 4. Criar projeto Firebase, ativar Firestore e conectar o app | 06/10/2026 | Concluído |
| 10. Tela 3: edição e exclusão no Firestore | 19/10/2026 | Concluído |
| 14. Validação de formulários antes de gravar | 21/10/2026 | Concluído |
| 21. README v2: estado da integração com o banco | 28/10/2026 | Concluído |
| 24. Diário de bordo individual – Mário Augusto Bussarello Volpato | 29/10/2026 | Concluído |

### Felipe Tomio Maciel

| Tarefa | Prazo | Status |
| ------ | ----- | ------ |
| 5. Modelar coleções e documentos do Firestore | 06/10/2026 | Concluído |
| 7. Criar camada de acesso a dados (CRUD com Firestore) | 13/10/2026 | Concluído |
| 13. Tratamento de erros e telas vazias/carregando | 22/10/2026 | Concluído |
| 17. Testes do fluxo completo e dos RNF | 26/10/2026 | Concluído |
| 25. Diário de bordo individual – Felipe Tomio Maciel | 29/10/2026 | Concluído |

### Matheus Henrique Pompeu

| Tarefa | Prazo | Status |
| ------ | ----- | ------ |
| 6. Ampliar/ajustar classes de domínio | 09/10/2026 | Concluído |
| 11. Tela 4: consulta/filtros no Firestore | 19/10/2026 | Concluído |
| 15. Ajustes pendentes da N1 (telas/RF) | 23/10/2026 | Concluído |
| 18. Revisão e merge dos PRs (semanas 1 a 4) | 27/10/2026 | Concluído |
| 26. Diário de bordo individual – Matheus Henrique Pompeu | 29/10/2026 | Concluído |

---

## 16. Entrega Final (N3)

Na entrega final, o aplicativo recebeu as funcionalidades pedidas pelo cliente para completar o fluxo de criação, impressão e correção das provas (PR #47):

| Funcionalidade | Requisito | Onde está |
| -------------- | --------- | --------- |
| Criar conta com Firebase Authentication | RF23 | `lib/screens/login/cadastro_screen.dart` e `lib/utils/autenticacao.dart` |
| Login pelo Firebase Authentication | RF01 e RNF04 | `lib/screens/login/login.dart` e `lib/utils/autenticacao.dart` |
| Turmas e disciplinas no Firestore, com a prova associada a uma turma | RF24 e RF25 | `lib/screens/turmas/` e `lib/data/turmas_repository.dart` |
| Embaralhar questões e alternativas ao gerar a prova | RF26 | `lib/utils/embaralhar.dart` |
| Ver as questões e editar a prova postada | RF27 | `lib/screens/provas/visualizar_prova_screen.dart` e `criar_prova_modal.dart` |
| Exportar o PDF da prova e do gabarito com QRCode | RF28 | `lib/utils/prova_pdf.dart` |
| Corrigir a prova pela leitura do QRCode, com a nota calculada e salva | RF16 e RF29 | `lib/screens/correcao/` |
| Gerar o QRCode do gabarito do aluno | RF29 | `lib/screens/correcao/gabarito_aluno_screen.dart` |
| Relatório em PDF da prova corrigida | RF30 | `lib/utils/relatorio_pdf.dart` |
| Dados de exemplo gravados no cadastro (questões, turma e prova de demonstração) | — | `lib/data/dados_demo.dart` |
| Sair da conta também desconecta do Firebase Authentication | RNF04 | `lib/screens/perfil/perfil_screen.dart` e `lib/utils/autenticacao.dart` |

### Roteiro da apresentação

A demonstração segue a ordem das funcionalidades pedidas pelo cliente:

1. Criar uma nova conta de professor;
2. Fazer login com a conta criada;
3. Criar uma turma/disciplina;
4. Cadastrar uma questão no banco de questões;
5. Gerar uma prova com questões do banco, configurando o embaralhamento de questões e de alternativas;
6. Abrir a prova gerada para conferir e editar;
7. Exportar a prova em PDF, com a folha de questões e, em página separada, o gabarito com QRCode;
8. Corrigir a prova impressa pela leitura do QRCode, exibindo a nota do aluno;
9. Mostrar que a nota foi salva na lista de resultados;
10. Mostrar o status "Corrigida" da prova e o relatório em PDF.
