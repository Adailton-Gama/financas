// import 'package:financas/repository/repository.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/material.dart';
// import 'package:financas/pages/mensalidades.dart';
// import 'package:intl/intl.dart';
// import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
// import 'package:financas/models/alunos.dart';
// import 'package:vibration/vibration.dart';

// import '../models/alunos.dart';

// class ItemMensalidade extends StatefulWidget {
//   const ItemMensalidade(
//       {Key? key, required this.alunos, required this.editMensalidade})
//       : super(key: key);
//   final Alunos alunos;
//   final Function editMensalidade;
//   @override
//   State<ItemMensalidade> createState() => _ItemMensalidadeState();
// }

// class _ItemMensalidadeState extends State<ItemMensalidade> {
//   final MaskTextInputFormatter datemask =
//       MaskTextInputFormatter(mask: '##/##/####');
//   List<Alunos> alunos = [];
//   AlunoRepository alunoRepository = AlunoRepository();
//   var count;
//   int pagamento = 0;
//   bool venceu = true;
//   @override
//   void initState() {
//     super.initState();
//     alunoRepository.getAlunos().then((value) {
//       setState(() {
//         alunos = value;
//         count = alunos.length;
//         for (Alunos aluno in alunos) {
//           pagamento += aluno.valor;
//         }
//       });
//     });
//   }

//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 5),
//       child: ElevatedButton(
//         style: ButtonStyle(
//           backgroundColor:
//               MaterialStateProperty.all(Color.fromRGBO(61, 61, 61, 1)),
//         ),
//         onPressed: () => widget.editMensalidade(widget.alunos),
//         child: Container(
//           alignment: Alignment.topLeft,
//           padding: EdgeInsets.all(5),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Text(
//                     'Plano: ${widget.alunos.plano}',
//                     textAlign: TextAlign.start,
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w300),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   Text(
//                     '${widget.alunos.nome}',
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   Text(
//                     'R\$ ${widget.alunos.valor} - Status: ${widget.alunos.pago ? 'Pago' : 'Pendente'}',
//                     textAlign: TextAlign.start,
//                     style: TextStyle(
//                         color: widget.alunos.pago ? Colors.green : Colors.red,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w300),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
