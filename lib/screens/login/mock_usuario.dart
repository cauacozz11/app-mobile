import 'package:app_mobile/models/usuario.dart';

const usuariosMock = <Usuario>[
  Usuario(
    id: '1',
    nome: 'Cauã Costa',
    email: 'caua@provaleve.com',
    senha: '123456',
    instituicao: 'Colégio Estadual',
    disciplinas: ['Engenharia de Software'],
  ),
  Usuario(
    id: '2',
    nome: 'Mario Silva',
    email: 'mario@provaleve.com',
    senha: '123456',
    instituicao: 'Colégio Estadual',
    disciplinas: ['História', 'Geografia'],
  ),
  Usuario(
    id: '3',
    nome: 'Ana Carolina',
    email: 'professor@escola.com',
    senha: 'provaleve',
    instituicao: 'Colégio Estadual',
    disciplinas: ['Matemática', 'Ciências'],
  ),
];
