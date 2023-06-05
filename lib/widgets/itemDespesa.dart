import 'package:financas/models/alunos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ItemDespesa extends StatefulWidget {
  const ItemDespesa(
      {Key? key,
      required this.despesa,
      required this.editDespesa,
      required this.onDelete})
      : super(key: key);
  final Despesas despesa;
  final Function editDespesa;
  final Function onDelete;
  @override
  State<ItemDespesa> createState() => _ItemDespesaState();
}

class _ItemDespesaState extends State<ItemDespesa> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Slidable(
        actionPane: SlidableStrechActionPane(),
        secondaryActions: [
          IconSlideAction(
            color: Colors.red,
            icon: Icons.delete,
            caption: 'Deletar',
            onTap: () {
              widget.onDelete(widget.despesa);
            },
          ),
        ],
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(const Color.fromRGBO(61, 61, 61, 1)),
          ),
          onPressed: () => widget.editDespesa(widget.despesa),
          child: Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Data de Vencimento: ${widget.despesa.dVencimento}',
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
                      '${widget.despesa.nome}',
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
                      'R\$ ${widget.despesa.valor} - Status: ${widget.despesa.pago ? 'Pago' : 'Pendente'}',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color:
                              widget.despesa.pago ? Colors.green : Colors.red,
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
