import 'dart:convert';

class Alunos {
  int id;
  String nome;
  String plano;
  String dPagamento;
  int valor;
  String? telefone;
  String observacoes;
  bool? pago = false;
  String? dqpago;

  Alunos({
    required this.id,
    required this.nome,
    required this.plano,
    required this.dPagamento,
    required this.valor,
    this.telefone,
    required this.observacoes,
    this.pago,
    this.dqpago,
  });

  Alunos.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nome = json['nome'],
        plano = json['plano'],
        dPagamento = json['dPagamento'],
        valor = json['valor'],
        telefone = json['telefone'],
        observacoes = json['observacoes'],
        pago = json['status'],
        dqpago = json['diadopagamento'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'plano': plano,
      'dPagamento': dPagamento,
      'valor': valor,
      'telefone': telefone,
      'observacoes': observacoes,
      'status': pago,
      'diadopagamento': dqpago,
    };
  }
}

class Diarias {
  int id;
  String nome;
  String dPagamento;
  String valor;
  String observacoes;
  bool pago = false;

  Diarias(
      {required this.id,
      required this.nome,
      required this.dPagamento,
      required this.valor,
      required this.pago,
      required this.observacoes});
  Diarias.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nome = json['nome'],
        dPagamento = json['dPagamento'],
        valor = json['valor'],
        pago = json['status'],
        observacoes = json['observacoes'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'dPagamento': dPagamento,
      'valor': valor,
      'status': pago,
      'observacoes': observacoes,
    };
  }
}

class Despesas {
  int id;
  String nome;
  int valor;
  String dVencimento;
  bool pago = false;
  String observacoes;
  Despesas(
      {required this.id,
      required this.nome,
      required this.valor,
      required this.dVencimento,
      required this.pago,
      required this.observacoes});

  Despesas.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nome = json['nome'],
        valor = json['valor'],
        dVencimento = json['dVencimento'],
        pago = json['status'],
        observacoes = json['observacoes'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'valor': valor,
      'dVencimento': dVencimento,
      'status': pago,
      'observacoes': observacoes,
    };
  }
}
