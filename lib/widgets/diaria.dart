import 'package:financas/models/alunos.dart';
import 'package:financas/repository/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ItemDiaria extends StatefulWidget {
  const ItemDiaria(
      {Key? key,
      required this.diaria,
      required this.editDiaria,
      required this.onDelete})
      : super(key: key);
  final Diarias diaria;
  final Function editDiaria;
  final Function onDelete;
  @override
  State<ItemDiaria> createState() => Item_DiariaState();
}

class Item_DiariaState extends State<ItemDiaria> {
  final DiariasRepository diariasRepository = DiariasRepository();
  final MaskTextInputFormatter datemask =
      MaskTextInputFormatter(mask: "##/##/####");
  final MaskTextInputFormatter telmask =
      MaskTextInputFormatter(mask: '(##) #####-####');
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Slidable(
        actionPane: SlidableStrechActionPane(),
        secondaryActions: [
          IconSlideAction(
            color: Colors.red,
            icon: Icons.delete,
            caption: 'Deletar',
            onTap: () {
              widget.onDelete(widget.diaria);
            },
          ),
        ],
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Color.fromRGBO(61, 61, 61, 1)),
          ),
          onPressed: () {
            widget.editDiaria(widget.diaria);
          },
          child: Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Data: ${widget.diaria.dPagamento}',
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
                      '${widget.diaria.nome}',
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
                      'R\$ ${widget.diaria.valor} - Status: ${widget.diaria.pago ? 'Pago' : 'Pendente'}',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: widget.diaria.pago ? Colors.green : Colors.red,
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
