import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financas/pages/mainMenu.dart';
import 'package:financas/widgets/mensal.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../models/alunos.dart';
import '../repository/repository.dart';

bool pgStatus = false;

class Mensalidades extends StatefulWidget {
  const Mensalidades({Key? key}) : super(key: key);

  @override
  State<Mensalidades> createState() => _MensalidadesState();
}

class _MensalidadesState extends State<Mensalidades> {
  final AlunoRepository alunoRepository = AlunoRepository();
  final MaskTextInputFormatter datemask =
      MaskTextInputFormatter(mask: '##/##/####');
  List<Alunos> alunos = [];
  var count = 0;
  int pagamento = 0;
  int recebido = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    attValores();
  }

  @override
  Widget build(BuildContext context) {
    final CollectionReference _alunosRef =
        FirebaseFirestore.instance.collection('alunos');
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
                          'MENSALIDADES',
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
                          'CONTROLE DE \n MENSALIDADES',
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
                            stream: _alunosRef.snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                                return Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: ListView.builder(
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      final DocumentSnapshot documentSnapshot =
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
                                          onPressed: () => editMensalidade(
                                              documentSnapshot.id.toString()),
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
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '${documentSnapshot['nome']}',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'R\$ ${documentSnapshot['valor']} - Status: ${documentSnapshot['status'] ? 'Pago' : 'Pendente'}',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          color:
                                                              documentSnapshot[
                                                                      'status']
                                                                  ? Colors.green
                                                                  : Colors.red,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                                ;
                              } else if (snapshot.hasError) {
                                print('error: ${snapshot.error.toString()}');
                                return Center(
                                  child: Text(snapshot.error.toString()),
                                );
                              }
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total de Alunos: $count',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 10),
                              ),
                              Text(
                                'Valor Total: R\$ $pagamento',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Valor Recebido: R\$ $recebido',
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
                            mainAxisAlignment: MainAxisAlignment.end,
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

  void editMensalidade(String aluno) {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final TextEditingController id = TextEditingController();
    final TextEditingController nome = TextEditingController();
    final TextEditingController plano = TextEditingController();
    final TextEditingController dPagamento = TextEditingController();
    final TextEditingController dqpago = TextEditingController();
    final TextEditingController valor = TextEditingController();
    final TextEditingController obs = TextEditingController();

    setState(() {
      final docRef = firebaseFirestore.collection('alunos').doc(aluno);
      docRef.get().then((DocumentSnapshot aluno) {
        final data = aluno.data() as Map<String, dynamic>;
        id.text = data['id'].toString();
        nome.text = data['nome'];
        plano.text = data['plano'];
        dPagamento.text = data['dPagamento'];
        valor.text = data['valor'].toString();
        obs.text = data['observacoes'];

        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  backgroundColor: Color.fromRGBO(61, 61, 61, 1),
                  content: Container(
                      color: Color.fromRGBO(61, 61, 61, 1),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('DADOS DO PAGAMENTO',
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
                                hintText: 'DATA DE VENCIMENTO: ',
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
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  if (data['status'] == true) {
                                    setState(() {
                                      docRef.update({'status': false});
                                      setState(() {});
                                      pgStatus = false;
                                    });
                                    recebido -=
                                        int.parse(data['valor'].toString());
                                  } else {
                                    recebido +=
                                        int.parse(data['valor'].toString());
                                    setState(() {
                                      docRef.update({'status': true});
                                      setState(() {});
                                      pgStatus = true;
                                    });
                                  }
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor: pgStatus
                                    ? MaterialStateProperty.all<Color>(
                                        Colors.green)
                                    : MaterialStateProperty.all<Color>(
                                        Colors.red),
                              ),
                              child: Container(
                                child: Row(
                                  children: [
                                    Text(pgStatus ? 'PAGO' : 'PENDENTE')
                                  ],
                                ),
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
                                    int controle = 1;
                                    if (controle == '') {
                                      print(1);
                                    } else {
                                      Alunos editAluno = Alunos(
                                        id: int.parse(id.text),
                                        nome: nome.text,
                                        plano: plano.text,
                                        dPagamento: dPagamento.text,
                                        valor: int.parse(valor.text),
                                        observacoes: obs.text,
                                        pago: pgStatus,
                                        telefone: data['telefone'],
                                      );

                                      docRef.update(editAluno.toJson());
                                      ScaffoldMessenger.of(context)
                                          .clearSnackBars();
                                      Future.delayed(
                                              Duration(milliseconds: 300))
                                          .then((value) {
                                        Navigator.pop(context);
                                      });
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
                                    children: const [Text('CONFIRMAR')],
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
                ));
      }, onError: (e) => print('error: $e'));
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

      setState(() {
        FirebaseFirestore fi = FirebaseFirestore.instance;
        fi
            .collection('alunos')
            .get()
            .then((snap) => snap.docs.forEach((element) {
                  print(element['status']);
                  if (element['status'] == true) {
                    recebido += int.parse(element['valor'].toString());
                  }
                }));
        print(recebido);
      });
    });
  }
}
