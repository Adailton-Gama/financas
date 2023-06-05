import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financas/pages/mainMenu.dart';
import 'package:financas/repository/repository.dart';
import 'package:financas/widgets/listAluno.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:vibration/vibration.dart';
import '../models/alunos.dart';

class GerirAlunos extends StatefulWidget {
  const GerirAlunos({Key? key}) : super(key: key);
  @override
  State<GerirAlunos> createState() => _GerirAlunosState();
}

class _GerirAlunosState extends State<GerirAlunos> {
  final CollectionReference _alunosref =
      FirebaseFirestore.instance.collection('alunos');
  final MaskTextInputFormatter datemask =
      MaskTextInputFormatter(mask: "##/##/####");
  final MaskTextInputFormatter telmask =
      MaskTextInputFormatter(mask: '(##) #####-####');
  List<Alunos> alunos = [];
  var count = 0;
  int pagamento = 0;
  @override
  void initState() {
    super.initState();
    attValores();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                //AppBar
                Container(
                  height: 77,
                  width: MediaQuery.of(context).size.width * 1,
                  color: const Color.fromRGBO(61, 61, 61, 1),
                  child: Row(
                    children: [
                      Image.asset('assets/app/logo.png'),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: const Text(
                          'GESTÃO DE ALUNOS',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //Body:
                Container(
                  margin:
                      EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          'ALUNOS\n CADASTRADOS',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Arial',
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.5,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(38, 38, 38, 1),
                              borderRadius: BorderRadius.circular(5)),
                          child: StreamBuilder(
                              stream: _alunosref.snapshots(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasData) {
                                  return Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: ListView.builder(
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          final DocumentSnapshot
                                              documentSnapshot =
                                              snapshot.data!.docs[index];

                                          return Container(
                                            margin: EdgeInsets.only(bottom: 5),
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Color.fromRGBO(
                                                            61, 61, 61, 1)),
                                              ),
                                              onPressed: () {
                                                EditAluno(documentSnapshot.id
                                                    .toString());
                                              },
                                              child: Slidable(
                                                actionPane:
                                                    SlidableScrollActionPane(),
                                                secondaryActions: [
                                                  IconSlideAction(
                                                    color: Colors.red,
                                                    icon: Icons.delete,
                                                    caption: 'Deletar',
                                                    onTap: () {
                                                      onDelete(documentSnapshot
                                                          .id
                                                          .toString());
                                                    },
                                                  ),
                                                ],
                                                child: Container(
                                                  alignment: Alignment.topLeft,
                                                  padding: EdgeInsets.all(5),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Plano: ${documentSnapshot['plano']}',
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            '${documentSnapshot['nome']}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            '${documentSnapshot['telefone']}',
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  );
                                } else if (snapshot.hasError) {
                                  print('erro: ${snapshot.error.toString()}');
                                  return Center(
                                    child: Text(
                                        'error: ${snapshot.error.toString()}'),
                                  );
                                }
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total de Alunos: ${count}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 10),
                              ),
                              Text(
                                'Valor Total Estimado: R\$ ${pagamento.toString()}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 10, left: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  Future.delayed(Duration(milliseconds: 300))
                                      .then((value) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                const MainMenu())));
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color.fromRGBO(61, 61, 61, 1)),
                                ),
                                child: Container(
                                  child: Row(
                                    children: const [
                                      Icon(Icons.arrow_back),
                                      Text('VOLTAR')
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () => AddAluno(),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color.fromRGBO(61, 61, 61, 1)),
                                ),
                                child: SizedBox(
                                  width: 50,
                                  height: 67,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/app/alunos.png',
                                        width: 34,
                                        height: 34,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'ADD',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void AddAluno() async {
    var rdnid = new Random().nextInt(1000);
    final TextEditingController id = TextEditingController();
    final TextEditingController nome = TextEditingController();
    final TextEditingController plano = TextEditingController();
    final TextEditingController dPagamento = TextEditingController();
    final TextEditingController valor = TextEditingController();
    final TextEditingController telefone = TextEditingController();
    final TextEditingController obs = TextEditingController();
    setState(() {
      id.text = rdnid.toString();
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                backgroundColor: Color.fromRGBO(61, 61, 61, 1),
                content: SingleChildScrollView(
                  child: Container(
                      color: Color.fromRGBO(61, 61, 61, 1),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('DADOS DO ALUNO',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            height: 30,
                            child: TextField(
                              controller: id,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 0, 12, 0),
                                hintText: 'ID: ',
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(91, 91, 91, 1),
                                        width: 1)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(91, 91, 91, 1),
                                        width: 1)),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            height: 30,
                            child: TextField(
                              controller: nome,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 0, 12, 0),
                                hintText: 'NOME: ',
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(91, 91, 91, 1),
                                        width: 1)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(91, 91, 91, 1),
                                        width: 1)),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            height: 30,
                            child: TextField(
                              controller: plano,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 0, 12, 0),
                                hintText: 'PLANO: ',
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(91, 91, 91, 1),
                                        width: 1)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(91, 91, 91, 1),
                                        width: 1)),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            height: 30,
                            child: TextField(
                              controller: dPagamento,
                              inputFormatters: [datemask],
                              keyboardType: TextInputType.number,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 0, 12, 0),
                                hintText: 'DIA DE PAGAMENTO: ',
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(91, 91, 91, 1),
                                        width: 1)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(91, 91, 91, 1),
                                        width: 1)),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            height: 30,
                            child: TextField(
                              keyboardType: TextInputType.numberWithOptions(),
                              controller: valor,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 0, 12, 0),
                                hintText: 'VALOR: ',
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(91, 91, 91, 1),
                                        width: 1)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(91, 91, 91, 1),
                                        width: 1)),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            height: 30,
                            child: TextField(
                              controller: telefone,
                              inputFormatters: [telmask],
                              keyboardType: TextInputType.number,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 0, 12, 0),
                                hintText: 'TELEFONE: ',
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(91, 91, 91, 1),
                                        width: 1)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(91, 91, 91, 1),
                                        width: 1)),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            margin: EdgeInsets.only(bottom: 20),
                            height: 30,
                            child: TextField(
                              controller: obs,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 0, 12, 0),
                                hintText: 'OBSERVAÇÕES: ',
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(91, 91, 91, 1),
                                        width: 1)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(91, 91, 91, 1),
                                        width: 1)),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    if (nome.text == '' ||
                                        id.text == '' ||
                                        plano.text == '' ||
                                        dPagamento.text == '' ||
                                        valor.text == '' ||
                                        telefone.text == '') {
                                      Vibration.vibrate();
                                      ScaffoldMessenger.of(context)
                                          .clearSnackBars();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                          'Favor preencher os dados dos alunos!',
                                          textAlign: TextAlign.center,
                                        ),
                                        duration: Duration(seconds: 3),
                                        backgroundColor:
                                            Color.fromRGBO(30, 30, 30, 1),
                                      ));
                                    } else {
                                      Alunos newAluno = Alunos(
                                        id: int.parse(id.text),
                                        nome: nome.text.toUpperCase(),
                                        plano: plano.text,
                                        dPagamento: dPagamento.text,
                                        valor: int.parse(valor.text),
                                        telefone: telefone.text,
                                        observacoes: obs.text,
                                        pago: false,
                                        dqpago: '',
                                      );
                                      alunos.add(newAluno);

                                      setState(() {
                                        final docUser = FirebaseFirestore
                                            .instance
                                            .collection('alunos')
                                            .doc(nome.text);
                                        docUser.set(newAluno.toJson());
                                        attValores();
                                      });
                                      Future.delayed(
                                              Duration(milliseconds: 300))
                                          .then((value) =>
                                              Navigator.pop(context));
                                    }
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.black),
                                ),
                                child: Container(
                                  child: Row(
                                    children: const [Text('CADASTRAR')],
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  Future.delayed(Duration(milliseconds: 300))
                                      .then((value) {
                                    Navigator.pop(context);
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.black),
                                ),
                                child: Container(
                                  child: Row(
                                    children: const [Text('VOLTAR')],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      )),
                ),
              ));
    });
  }

  void onDelete(String alunos) {
    setState(() {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      final docRef = firebaseFirestore.collection('alunos').doc(alunos);

      docRef.delete();
      attValores();
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('O aluno(a): ${alunos} foi removida com sucesso!',
              style: const TextStyle(color: Colors.white)),
          duration: Duration(seconds: 5),
        ),
      );
    });
  }

  void EditAluno(String alunos) {
    print(alunos);
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final TextEditingController id = TextEditingController();
    final TextEditingController nome = TextEditingController();
    final TextEditingController plano = TextEditingController();
    final TextEditingController dPagamento = TextEditingController();
    final TextEditingController valor = TextEditingController();
    final TextEditingController telefone = TextEditingController();
    final TextEditingController obs = TextEditingController();

    setState(() {
      final docRef = firebaseFirestore.collection('alunos').doc(alunos);
      docRef.get().then((DocumentSnapshot aluno) {
        final data = aluno.data() as Map<String, dynamic>;
        id.text = data['id'].toString();
        nome.text = data['nome'];
        plano.text = data['plano'];
        dPagamento.text = data['dPagamento'];
        valor.text = data['valor'].toString();
        telefone.text = data['telefone'];
        obs.text = data['observacoes'];
      }, onError: (e) => print('error: $e'));

      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                backgroundColor: Color.fromRGBO(61, 61, 61, 1),
                content: SingleChildScrollView(
                  child: Container(
                      color: Color.fromRGBO(61, 61, 61, 1),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('DADOS DO ALUNO',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            height: 30,
                            child: TextField(
                              controller: id,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 0, 12, 0),
                                hintText: 'ID: ',
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(91, 91, 91, 1),
                                        width: 1)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(91, 91, 91, 1),
                                        width: 1)),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            height: 30,
                            child: TextField(
                              controller: nome,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 0, 12, 0),
                                hintText: 'NOME: ',
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(91, 91, 91, 1),
                                        width: 1)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(91, 91, 91, 1),
                                        width: 1)),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            height: 30,
                            child: TextField(
                              controller: plano,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 0, 12, 0),
                                hintText: 'PLANO: ',
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(91, 91, 91, 1),
                                        width: 1)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(91, 91, 91, 1),
                                        width: 1)),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            height: 30,
                            child: TextField(
                              controller: dPagamento,
                              inputFormatters: [datemask],
                              keyboardType: TextInputType.number,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 0, 12, 0),
                                hintText: 'DIA DE PAGAMENTO: ',
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(91, 91, 91, 1),
                                        width: 1)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(91, 91, 91, 1),
                                        width: 1)),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            height: 30,
                            child: TextField(
                              keyboardType: TextInputType.numberWithOptions(),
                              controller: valor,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 0, 12, 0),
                                hintText: 'VALOR: ',
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(91, 91, 91, 1),
                                        width: 1)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(91, 91, 91, 1),
                                        width: 1)),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            height: 30,
                            child: TextField(
                              controller: telefone,
                              inputFormatters: [telmask],
                              keyboardType: TextInputType.number,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 0, 12, 0),
                                hintText: 'TELEFONE: ',
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(91, 91, 91, 1),
                                        width: 1)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(91, 91, 91, 1),
                                        width: 1)),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            margin: EdgeInsets.only(bottom: 20),
                            height: 30,
                            child: TextField(
                              controller: obs,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 0, 12, 0),
                                hintText: 'OBSERVAÇÕES: ',
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(91, 91, 91, 1),
                                        width: 1)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(91, 91, 91, 1),
                                        width: 1)),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    Alunos newAluno = Alunos(
                                      id: int.parse(id.text),
                                      nome: nome.text,
                                      plano: plano.text,
                                      dPagamento: dPagamento.text,
                                      valor: int.parse(valor.text),
                                      telefone: telefone.text,
                                      observacoes: obs.text,
                                      dqpago: '',
                                      pago: false,
                                    );
                                    docRef.update(newAluno.toJson());
                                    attValores();
                                    ScaffoldMessenger.of(context)
                                        .clearSnackBars();
                                    Future.delayed(Duration(milliseconds: 300))
                                        .then((value) {
                                      Navigator.pop(context);
                                    });
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.black),
                                ),
                                child: Container(
                                  child: Row(
                                    children: const [Text('EDITAR')],
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  Future.delayed(Duration(milliseconds: 300))
                                      .then((value) {
                                    Navigator.pop(context);
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.black),
                                ),
                                child: Container(
                                  child: Row(
                                    children: const [Text('VOLTAR')],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      )),
                ),
              ));
    });
  }

  void attValores() {
    setState(() {
      setState(() {
        pagamento = 0;
        FirebaseFirestore fi = FirebaseFirestore.instance;
        fi.collection('alunos').get().then(
          (value) {
            setState(() {
              count = value.size;
            });
            print(count);
          },
        );
      });
      setState(() {
        FirebaseFirestore fi = FirebaseFirestore.instance;
        fi
            .collection('alunos')
            .get()
            .then((snap) => snap.docs.forEach((element) {
                  print(element['valor'].toString());
                  pagamento += int.parse(element['valor'].toString());
                }));
        print(pagamento);
      });
    });
  }
}
