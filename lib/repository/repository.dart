import 'dart:convert';
import 'package:financas/models/alunos.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String alunolistkey = 'alunolistkey';
const String countAluno = 'count';
const String diarialistkey = 'diarialistkey';
const String countDiaria = 'countdiaria';
const String despesalistkey = 'despesalistkey';
const String countDespesas = 'countdespesas';

class AlunoRepository {
  late SharedPreferences sharedPreferences;

  Future<List<Alunos>> getAlunos() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(alunolistkey) ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) => Alunos.fromJson(e)).toList();
  }

  void saveAlunoList(List<Alunos> alunos) {
    final String jsonString = json.encode(alunos);
    sharedPreferences.setString(alunolistkey, jsonString);
  }
}

class DiariasRepository {
  late SharedPreferences sharedPreferences;

  Future<List<Diarias>> getDiarias() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString =
        sharedPreferences.getString(diarialistkey) ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) => Diarias.fromJson(e)).toList();
  }

  void saveDiariaList(List<Diarias> diarias) {
    final String jsonString = json.encode(diarias);
    sharedPreferences.setString(diarialistkey, jsonString);
  }
}

class DespesasRepository {
  late SharedPreferences sharedPreferences;

  Future<List<Despesas>> getDespesas() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString =
        sharedPreferences.getString(despesalistkey) ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) => Despesas.fromJson(e)).toList();
  }

  void saveDespesasList(List<Despesas> despesas) {
    final String jsonString = json.encode(despesas);
    sharedPreferences.setString(despesalistkey, jsonString);
  }
}
