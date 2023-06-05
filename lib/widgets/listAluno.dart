import 'package:financas/models/alunos.dart';
import 'package:financas/repository/repository.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:financas/pages/gerirAlunos.dart';
import 'package:vibration/vibration.dart';

class listAluno extends StatefulWidget {
  const listAluno(
      {Key? key,
      required this.alunos,
      required this.onDelete,
      required this.EditAluno})
      : super(key: key);
  final Alunos alunos;
  final Function onDelete;
  final Function EditAluno;
  @override
  State<listAluno> createState() => _listAlunoState();
}

class _listAlunoState extends State<listAluno> {
  final MaskTextInputFormatter datemask =
      MaskTextInputFormatter(mask: "##/##/####");
  final MaskTextInputFormatter telmask =
      MaskTextInputFormatter(mask: '(##) #####-####');
  List<Alunos> alunos = [];
  AlunoRepository alunoRepository = AlunoRepository();
  int count = 0;
  double pagamento = 0;
  @override
  void initState() {
    super.initState();
    alunoRepository.getAlunos().then((value) {
      setState(() {
        alunos = value;
        count = alunos.length;
        for (Alunos aluno in alunos) {
          pagamento += aluno.valor;
        }
      });
    });
  }

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(Color.fromRGBO(61, 61, 61, 1)),
        ),
        onPressed: () {
          widget.EditAluno(widget.alunos);
        },
        child: Slidable(
          actionPane: SlidableScrollActionPane(),
          secondaryActions: [
            IconSlideAction(
              color: Colors.red,
              icon: Icons.delete,
              caption: 'Deletar',
              onTap: () {
                widget.onDelete(widget.alunos);
              },
            ),
          ],
          child: Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Plano: ${widget.alunos.plano}',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '${widget.alunos.nome}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '${widget.alunos.telefone}',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
