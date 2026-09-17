# PROVALEVE

Provas mais simples. Tempo para ensinar.

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

O projeto contempla inicialmente:

* Abertura do aplicativo;
* Login do professor;
* Gerenciamento das provas;
* Criação de provas;
* Banco de questões;
* Cadastro de novas questões;
* Definição do gabarito;
* Correção automatizada;
* Visualização dos resultados;
* Visualização de acertos e erros;
* Visualização das respostas marcadas;
* Consulta detalhada das questões corrigidas.

Essas funcionalidades correspondem ao fluxo apresentado nos wireframes do aplicativo.

### 3.2 Funcionalidades previstas para evolução

Foram levantadas também algumas funcionalidades adicionais que podem ser incorporadas posteriormente:

* Importação da lista de alunos;
* Geração de provas individualizadas por aluno;
* Geração de relatório de notas;
* Exportação dos resultados para Excel;
* Edição do layout da prova gerada.

Essas funcionalidades foram apresentadas pelo cliente como sugestões adicionais ao projeto.

### 3.3 Fora do escopo inicial

Não fazem parte do escopo inicial:

* Cadastro livre de professores pelo aplicativo;
* Gerenciamento acadêmico completo da instituição;
* Criação de conteúdo educacional;
* Correção de questões discursivas;
* Funcionalidades que não estejam relacionadas ao processo de criação, aplicação e correção de provas.

---

# 4. Requisitos Funcionais — RF

| Código   | Requisito                                                                        |
| -------- | -------------------------------------------------------------------------------- |
| **RF01** | O sistema deve permitir que o professor realize login utilizando e-mail e senha. |
| **RF02** | O sistema deve permitir a recuperação de senha.                                  |
| **RF03** | O sistema deve permitir visualizar as provas do professor.                       |
| **RF04** | O sistema deve permitir pesquisar provas.                                        |
| **RF05** | O sistema deve permitir filtrar provas por situação.                             |
| **RF06** | O sistema deve permitir criar uma nova prova.                                    |
| **RF07** | O sistema deve permitir selecionar questões para compor uma prova.               |
| **RF08** | O sistema deve permitir pesquisar questões no banco de questões.                 |
| **RF09** | O sistema deve permitir cadastrar novas questões.                                |
| **RF10** | O sistema deve permitir cadastrar alternativas para uma questão.                 |
| **RF11** | O sistema deve permitir definir a alternativa correta de uma questão.            |
| **RF12** | O sistema deve permitir editar questões cadastradas.                             |
| **RF13** | O sistema deve permitir duplicar questões.                                       |
| **RF14** | O sistema deve permitir excluir questões.                                        |
| **RF15** | O sistema deve permitir salvar uma questão como rascunho.                        |
| **RF16** | O sistema deve realizar a correção automatizada das provas.                      |
| **RF17** | O sistema deve apresentar a nota obtida pelo aluno.                              |
| **RF18** | O sistema deve apresentar a quantidade de acertos e erros.                       |
| **RF19** | O sistema deve apresentar a resposta marcada pelo aluno.                         |
| **RF20** | O sistema deve apresentar a alternativa correta nas questões erradas.            |
| **RF21** | O sistema deve permitir visualizar a correção detalhada da prova.                |
| **RF22** | O sistema deve permitir compartilhar ou exportar o resultado.                    |

Os requisitos foram definidos a partir das funcionalidades descritas nos wireframes e das necessidades apresentadas pelo cliente.

---

# 5. Requisitos Não Funcionais — RNF

| Código    | Requisito                                                                                    |
| --------- | -------------------------------------------------------------------------------------------- |
| **RNF01** | A interface deve ser simples e fácil de utilizar.                                            |
| **RNF02** | A navegação deve ser lógica e objetiva.                                                      |
| **RNF03** | As informações devem ser apresentadas de forma clara e organizada.                           |
| **RNF04** | O sistema deve proteger as informações de acesso do professor.                               |
| **RNF05** | O resultado da correção deve ser apresentado de forma rápida.                                |
| **RNF06** | A interface deve evitar excesso de elementos visuais.                                        |
| **RNF07** | Os acertos e erros devem possuir identificação visual clara.                                 |
| **RNF08** | Cada professor deve ter acesso somente às suas próprias provas e questões.                   |
| **RNF09** | O sistema deve apresentar mensagens de erro quando ocorrerem problemas durante uma operação. |
| **RNF10** | O aplicativo deve possuir uma interface adequada para dispositivos móveis.                   |

A preferência do cliente é por uma interface minimalista, lógica, amigável e com poucos elementos na tela.

---

# 6. Telas Principais

O ProvaLeve possui 7 telas principais definidas nos wireframes.

## 6.1 Abertura

É a primeira tela apresentada ao iniciar o aplicativo.

Função:

* Apresentar a identidade visual do ProvaLeve;
* Exibir o nome e slogan;
* Apresentar o carregamento inicial;
* Encaminhar o usuário para o login.

---

## 6.2 Login

Tela responsável pela autenticação do professor.

Elementos principais:

* Campo de e-mail;
* Campo de senha;
* Exibição/ocultação da senha;
* Recuperação de senha;
* Botão "Entrar".

---

## 6.3 Minhas Provas

Tela principal apresentada após o login.

Elementos principais:

* Perfil do professor;
* Lista de provas;
* Busca;
* Filtros;
* Status das provas;
* Acesso aos resultados;
* Botão para criar uma nova prova.

---

## 6.4 Criar Prova

Tela utilizada para montar uma nova prova utilizando questões cadastradas.

Elementos principais:

* Título da prova;
* Disciplina;
* Busca de questões;
* Filtros;
* Seleção das questões;
* Contador de questões selecionadas;
* Visualização dos detalhes das questões.

---

## 6.5 Banco de Questões

Tela responsável por centralizar as questões cadastradas.

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

## 6.6 Nova Questão

Tela destinada ao cadastro de uma nova questão de múltipla escolha.

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

## 6.7 Resultado da Prova

Tela responsável pela apresentação do resultado após a correção.

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

# 7. Fluxo Principal do Sistema


ABERTURA
   ↓
LOGIN
   ↓
MINHAS PROVAS
   ↓
┌─────────────────────┐
│                     │
↓                     ↓
CRIAR PROVA      BANCO DE QUESTÕES
│                     │
↓                     ↓
SELECIONAR        NOVA QUESTÃO
QUESTÕES              │
│                     ↓
└──────────────→ BANCO DE QUESTÕES
          ↓
      CRIAR PROVA
          ↓
       CORREÇÃO
          ↓
   RESULTADO DA PROVA

---

# 8. Público-Alvo

O ProvaLeve é destinado principalmente a professores que trabalham com avaliações e possuem um grande volume de provas para corrigir.

O sistema busca reduzir o tempo utilizado na correção e facilitar a análise dos resultados obtidos pelos alunos.

---

# 9. Interface e Experiência de Uso

A interface do ProvaLeve foi planejada para ser simples, amigável e objetiva.

A proposta considera uma navegação lógica e uma quantidade reduzida de elementos na tela, seguindo a preferência apresentada pelo cliente por uma experiência mais minimalista.

Os wireframes foram desenvolvidos para validar o fluxo de utilização do aplicativo antes da implementação das funcionalidades.

---

# 10. Status do Projeto

Status: Em desenvolvimento 🚧

Atualmente, o projeto possui o levantamento das necessidades do cliente, definição do escopo, requisitos funcionais e não funcionais e wireframes das principais telas.
link do vídeo: https://www.youtube.com/watch?v=Q-urOUDrMoM
---
