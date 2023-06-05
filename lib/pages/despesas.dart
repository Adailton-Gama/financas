import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financas/pages/mainMenu.dart';
import 'package:financas/repository/repository.dart';
import 'package:financas/widgets/itemDespesa.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:vibration/vibration.dart';

import '../models/alunos.dart';

bool pgStatus = false;

class DespesasPage extends StatefulWidget {
  const DespesasPage({Key? key}) : super(key: key);

  @override
  State<DespesasPage> createState() => _DespesasPageState();
}

class _DespesasPageState extends State<DespesasPage> {
  final CollectionReference _despesasRef =
      FirebaseFirestore.instance.collection('despesas');
  final MaskTextInputFormatter datemask =
      MaskTextInputFormatter(mask: "##/##/####");
  List<Despesas> despesas = [];
  int pagamento = 0;
  int recebido = 0;
  var count;
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
                        'DESPESAS',
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
                margin: const EdgeInsets.only(
                    top: 10, left: 10, right: 10, bottom: 0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        'CONTROLE DE \n DESPESAS',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Arial',
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.5,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(38, 38, 38, 1),
                            borderRadius: BorderRadius.circular(5)),
                        child: StreamBuilder(
                          stream: _despesasRef.snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    final DocumentSnapshot docSnapshot =
                                        snapshot.data!.docs[index];
                                    return Container(
                                      child: Slidable(
                                        actionPane: SlidableStrechActionPane(),
                                        secondaryActions: [
                                          IconSlideAction(
                                            color: Colors.red,
                                            icon: Icons.delete,
                                            caption: 'Deletar',
                                            onTap: () {
                                              onDelete(
                                                  docSnapshot.id.toString());
                                            },
                                          ),
                                        ],
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    const Color.fromRGBO(
                                                        61, 61, 61, 1)),
                                          ),
                                          onPressed: () => editDespesa(
                                              docSnapshot.id.toString()),
                                          child: Container(
                                            alignment: Alignment.topLeft,
                                            padding: const EdgeInsets.all(5),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Data de Vencimento: ${docSnapshot['dVencimento']}',
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
                                                      '${docSnapshot['nome']}',
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
                                                      'R\$ ${docSnapshot['valor']} - Status: ${docSnapshot['status'] ? 'Pago' : 'Pendente'}',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          color: docSnapshot[
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
                                      ),
                                    );
                                  },
                                ),
                              );
                            } else if (snapshot.hasError) {
                              print('error: ${snapshot.error.toString()}');
                              return Center(
                                child: Text('Erro ao carregar dados'),
                              );
                            }
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total de Contas: $count',
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
                        padding: const EdgeInsets.only(right: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Valor Pago: R\$ $recebido',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(right: 10, left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                Future.delayed(
                                        const Duration(milliseconds: 300))
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
                                        const Color.fromRGBO(61, 61, 61, 1)),
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
                            ElevatedButton(
                              onPressed: () => addDespesa(),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color.fromRGBO(61, 61, 61, 1)),
                              ),
                              child: Container(
                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/app/despesas.png',
                                      height: 34,
                                      width: 34,
                                    ),
                                    Text('ADD')
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
    );
  }

  void editDespesa(String despesa) {
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final TextEditingController id = TextEditingController();
    final TextEditingController nome = TextEditingController();
    final TextEditingController valor = TextEditingController();
    final TextEditingController dVencimento = TextEditingController();
    final TextEditingController dPagamento = TextEditingController();
    final TextEditingController observacoes = TextEditingController();
    setState(() {
      final docRef = firebaseFirestore.collection('despesas').doc(despesa);
      docRef.get().then((DocumentSnapshot despesa) {
        final data = despesa.data() as Map<String, dynamic>;
        id.text = data['id'].toString();
        nome.text = data['nome'];
        valor.text = data['valor'].toString();
        dVencimento.text = data['dVencimento'];
        dPagamento.text = data['dPagamento'];
        observacoes.text = data['observacoes'];

        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  backgroundColor: const Color.fromRGBO(61, 61, 61, 1),
                  content: Container(
                      color: const Color.fromRGBO(61, 61, 61, 1),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('DADOS DO PAGAMENTO',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            height: 30,
                            child: const TextField(
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
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            height: 30,
                            child: const TextField(
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
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            height: 30,
                            child: const TextField(
                              keyboardType: TextInputType.numberWithOptions(),
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
                            height: 35,
                            child: TextField(
                              inputFormatters: [datemask],
                              keyboardType: TextInputType.number,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 0, 12, 0),
                                hintText: 'Data de Vencimento: ',
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
                                    data['status'] = false;
                                    pgStatus = false;
                                    docRef.update({'status': pgStatus});
                                  } else {
                                    data['status'] = true;
                                    pgStatus = true;
                                    docRef.update({'status': pgStatus});
                                  }
                                  attValores();
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor: data['status']
                                    ? MaterialStateProperty.all<Color>(
                                        Colors.green)
                                    : MaterialStateProperty.all<Color>(
                                        Colors.red),
                              ),
                              child: Container(
                                child: Row(
                                  children: [
                                    Text(data['status'] ? 'PAGO' : 'PENDENTE')
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
                                  docRef.update({
                                    'id': id.text,
                                    'nome': nome.text,
                                    'valor': valor.text,
                                    'dVencimento': dVencimento.text,
                                    'dPagamento': dPagamento.text,
                                    'observacoes': observacoes.text,
                                    'status': pgStatus,
                                  });
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
      });
    });
  }

  void addDespesa() {
    var rdnid = new Random().nextInt(1000);
    final TextEditingController id = TextEditingController();
    final TextEditingController nome = TextEditingController();
    final TextEditingController valor = TextEditingController();
    final TextEditingController dVencimento = TextEditingController();
    final TextEditingController dPagamento = TextEditingController();
    final TextEditingController observacoes = TextEditingController();
    setState(() {
      id.text = rdnid.toString();
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                backgroundColor: const Color.fromRGBO(61, 61, 61, 1),
                content: Container(
                    color: const Color.fromRGBO(61, 61, 61, 1),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('DADOS DO PAGAMENTO',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          height: 30,
                          child: TextField(
                            controller: id,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(12, 0, 12, 0),
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
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          height: 30,
                          child: TextField(
                            controller: nome,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(12, 0, 12, 0),
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
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          height: 30,
                          child: TextField(
                            keyboardType: TextInputType.numberWithOptions(),
                            controller: valor,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(12, 0, 12, 0),
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
                          height: 35,
                          child: TextField(
                            controller: dVencimento,
                            inputFormatters: [datemask],
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                              hintText: 'Data de Vencimento: ',
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
                                if (pgStatus == true) {
                                  pgStatus = false;
                                } else {
                                  pgStatus = true;
                                }
                                attValores();
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
                            controller: observacoes,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(12, 0, 12, 0),
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
                                      dVencimento.text == '' ||
                                      valor.text == '') {
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
                                    Despesas newDespesa = Despesas(
                                        id: int.parse(id.text),
                                        nome: nome.text,
                                        valor: int.parse(valor.text),
                                        dVencimento: dVencimento.text,
                                        pago: pgStatus,
                                        observacoes: observacoes.text);
                                    FirebaseFirestore.instance
                                        .collection('despesas')
                                        .doc(id.text)
                                        .set(newDespesa.toJson());

                                    attValores();
                                  }
                                });
                                ScaffoldMessenger.of(context).clearSnackBars();
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
                                  children: const [Text('ADICIONAR')],
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).clearSnackBars();
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
    });
  }

  void attValores() {
    setState(() {
      setState(() {
        pagamento = 0;
        recebido = 0;
        FirebaseFirestore fi = FirebaseFirestore.instance;
        fi.collection('despesas').get().then(
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
            .collection('despesas')
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
            .collection('despesas')
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

  void onDelete(String despesa) {
    setState(() {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      final docRef = firebaseFirestore.collection('despesas').doc(despesa);

      docRef.delete();
      attValores();
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('A despesa: ${despesa} foi removida com sucesso!',
              style: const TextStyle(color: Colors.white)),
          duration: Duration(seconds: 5),
        ),
      );
    });
  }
}
