import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financas/pages/mainMenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:vibration/vibration.dart';
import '../models/alunos.dart';
import '../repository/repository.dart';
import '../widgets/diaria.dart';

bool pgStatus = false;

class DiariasPage extends StatefulWidget {
  const DiariasPage({Key? key}) : super(key: key);

  @override
  State<DiariasPage> createState() => _DiariasPageState();
}

class _DiariasPageState extends State<DiariasPage> {
  final CollectionReference _diariasRef =
      FirebaseFirestore.instance.collection('diarias');

  final MaskTextInputFormatter datemask =
      MaskTextInputFormatter(mask: "##/##/####");
  final MaskTextInputFormatter telmask =
      MaskTextInputFormatter(mask: '(##) #####-####');
  List<Diarias> diarias = [];
  var count;
  int pagamento = 0;
  int recebido = 0;
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
                        'DIÁRIAS',
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
                        'CONTROLE DE \n PAGAMENTOS',
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
                          stream: _diariasRef.snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                                          child: Slidable(
                                            actionPane:
                                                SlidableStrechActionPane(),
                                            secondaryActions: [
                                              IconSlideAction(
                                                color: Colors.red,
                                                icon: Icons.delete,
                                                caption: 'Deletar',
                                                onTap: () {
                                                  onDelete(documentSnapshot.id
                                                      .toString());
                                                },
                                              ),
                                            ],
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Color.fromRGBO(
                                                            61, 61, 61, 1)),
                                              ),
                                              onPressed: () {
                                                editDiaria(documentSnapshot.id
                                                    .toString());
                                              },
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
                                                          'Data: ${documentSnapshot['dPagamento']}',
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
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
                                                              color:
                                                                  Colors.white,
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
                                                          'R\$ ${documentSnapshot['valor']} - Status: ${documentSnapshot['status'] ? 'Pago' : 'Pendente'}',
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              color: documentSnapshot[
                                                                      'status']
                                                                  ? Colors.green
                                                                  : Colors.red,
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
                                      }));
                            } else if (snapshot.hasError) {
                              print('erro: ${snapshot.error.toString()}');
                              return Center(
                                child:
                                    Text('error: ${snapshot.error.toString()}'),
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
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Valor Total: R\$ $pagamento',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 10),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Valor Total Recebido: R\$ $recebido',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 10),
                                    ),
                                  ],
                                ),
                              ],
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
                                ScaffoldMessenger.of(context).clearSnackBars();
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
                            ElevatedButton(
                              onPressed: () => addDiaria(),
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
                                      'assets/app/diarias.png',
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
    );
  }

  void editDiaria(String diaria) {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    final TextEditingController id = TextEditingController();
    final TextEditingController nome = TextEditingController();
    final TextEditingController dPagamento = TextEditingController();
    final TextEditingController valor = TextEditingController();
    final TextEditingController obs = TextEditingController();
    setState(() {
      final docRef = firebaseFirestore.collection('diarias').doc(diaria);
      docRef.get().then((DocumentSnapshot diaria) {
        final data = diaria.data() as Map<String, dynamic>;
        id.text = data['id'].toString();
        nome.text = data['nome'];
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
                              controller: dPagamento,
                              inputFormatters: [datemask],
                              keyboardType: TextInputType.number,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 0, 12, 0),
                                hintText: 'DATA DE PAGAMENTO: ',
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
                                  if (data['pago'] == true) {
                                    data['pago'] = false;
                                    pgStatus = false;
                                    docRef.update({'status': pgStatus});
                                  } else {
                                    data['pago'] = true;
                                    pgStatus = true;
                                    docRef.update({'status': pgStatus});
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
                                    docRef.update({
                                      'dPagamento': dPagamento.text,
                                      'id': id.text,
                                      'nome': nome.text,
                                      'observacoes': obs.text,
                                      'status': pgStatus,
                                      'valor': valor.text,
                                    });
                                    attValores();
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

  void addDiaria() {
    var rdnid = new Random().nextInt(1000);
    final TextEditingController id = TextEditingController();
    final TextEditingController nome = TextEditingController();
    final TextEditingController dPagamento = TextEditingController();
    final TextEditingController valor = TextEditingController();
    final TextEditingController obs = TextEditingController();
    setState(() {
      id.text = rdnid.toString();
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                backgroundColor: Color.fromRGBO(61, 61, 61, 1),
                content: Container(
                    color: Color.fromRGBO(61, 61, 61, 1),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('CADASTRAR NOVA DIÁRIA',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
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
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
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
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          height: 30,
                          child: TextField(
                            controller: dPagamento,
                            inputFormatters: [
                              datemask,
                            ],
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                              hintText: 'DATA DE PAGAMENTO: ',
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
                          margin: EdgeInsets.only(bottom: 20),
                          height: 30,
                          child: TextField(
                            controller: obs,
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
                                      dPagamento.text == '' ||
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
                                    Diarias newDiaria = Diarias(
                                      id: int.parse(id.text),
                                      nome: nome.text,
                                      dPagamento: dPagamento.text,
                                      valor: valor.text,
                                      pago: true,
                                      observacoes: obs.text,
                                    );
                                    FirebaseFirestore.instance
                                        .collection('diarias')
                                        .doc(id.text)
                                        .set(newDiaria.toJson());
                                    attValores();

                                    ScaffoldMessenger.of(context)
                                        .clearSnackBars();
                                    Future.delayed(Duration(milliseconds: 300))
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
        fi.collection('diarias').get().then(
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
            .collection('diarias')
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
            .collection('diarias')
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

  void onDelete(String diaria) {
    setState(() {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      final docRef = firebaseFirestore.collection('diarias').doc(diaria);

      docRef.delete();
      attValores();
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('O aluno(a): ${diaria} foi removido(a) com sucesso!',
              style: const TextStyle(color: Colors.white)),
          duration: Duration(seconds: 5),
        ),
      );
    });
  }
}
