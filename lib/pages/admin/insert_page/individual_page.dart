// import 'package:flutter/material.dart';
// import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
// import 'package:search_cep/search_cep.dart';
// import 'package:webapp/controller/horarios_locais_controller.dart';
// import 'package:webapp/data/horarios_locais_repository.dart';
// import 'package:webapp/enums.dart';
// import 'package:webapp/functions/classes/separete.dart';
// import 'package:webapp/functions/validators/date_validator.dart';
// import 'package:webapp/pages/admin/insert_page/widgets/card_section_widget.dart';
// import 'package:webapp/pages/widgets/text_field_custom.dart';

// class InscricaoManualPage extends StatelessWidget {
//   const InscricaoManualPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var maskFormatterPhone = MaskTextInputFormatter(mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});

//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Inscrição manual'),
//           centerTitle: true,
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 CardSectionWidget(
//                   title: 'Informações básicas',
//                   content: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       TextFieldCustom(controller: TextEditingController(), labelText: 'Nome', filled: true),
//                       TextFieldCustom(controller: TextEditingController(), labelText: 'Nome da Mãe', filled: true),
//                       TextFieldCustom(controller: TextEditingController(), labelText: 'Nome do Pai', filled: true),
//                       TextFieldCustom(controller: TextEditingController(), labelText: 'Nome do Responsável', filled: true),
//                       const _SecaoNascimento()
//                     ],
//                   ),
//                 ),
//                 const Divider(),
//                 const CardSectionWidget(title: 'Endereço', content: _SecaoEndereco()),
//                 const Divider(),
//                 CardSectionWidget(
//                   title: 'Contato',
//                   content: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       TextFieldCustom(
//                         controller: TextEditingController(),
//                         labelText: 'WhatsApp',
//                         filled: true,
//                         formatter: [maskFormatterPhone],
//                       ),
//                       TextFieldCustom(controller: TextEditingController(), labelText: 'E-mail', filled: true),
//                     ],
//                   ),
//                 ),
//                 const Divider(),
//                 // CardSectionWidget(
//                 //   title: 'Local e Horário',
//                 //   content: _SectionLocalHorario(etapa),
//                 // ),
//                 // const Divider(),
//               ],
//             ),
//           ),
//         ));
//   }
// }

// class _SecaoNascimento extends StatefulWidget {
//   const _SecaoNascimento();

//   @override
//   State<_SecaoNascimento> createState() => __SecaoNascimentoState();
// }

// class __SecaoNascimentoState extends State<_SecaoNascimento> {
//   final TextEditingController controller = TextEditingController();

//   var maskFormatter = MaskTextInputFormatter(mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});

//   Map<String, dynamic>? age;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         TextFieldCustom(
//           controller: controller,
//           validator: (value) => checkDate(maskFormatter.getMaskedText()),
//           formatter: [maskFormatter],
//           labelText: 'Data de Nascimento',
//           filled: true,
//           onChanged: (value) {
//             if (value.length == 10) {
//               setState(() {
//                 age = separeteByAge(maskFormatter.getMaskedText());
//               });
//             }
//             if (value.length != 10) {
//               setState(() {
//                 age = null;
//               });
//             }
//           },
//         ),
//         if (age != null) Text('Idade: ${age?['idade']}'),
//         if (age != null) Text('Etapa: ${_extractTextFromTurma(age?['etapa'])}'),
//       ],
//     );
//   }

//   String _extractTextFromTurma(Turma turma) {
//     switch (turma) {
//       case Turma.eucaristia1:
//         return '1º Etapa - Eucaristia';
//       case Turma.eucaristia2:
//         return '2º Etapa - Eucaristia';
//       case Turma.eucaristia3:
//         return '3º Etapa - Eucaristia';
//       case Turma.crisma1:
//         return '1º Etapa - Crisma';
//       case Turma.crisma2:
//         return '2º Etapa - Crisma';
//       case Turma.crisma3:
//         return '3º Etapa - Crisma';
//       case Turma.jovens:
//         return 'Jovens';
//       case Turma.adultos:
//         return 'Adultos';
//       default:
//         return 'Erro';
//     }
//   }
// }

// class _SecaoEndereco extends StatefulWidget {
//   const _SecaoEndereco();

//   @override
//   State<_SecaoEndereco> createState() => __SecaoEnderecoState();
// }

// class __SecaoEnderecoState extends State<_SecaoEndereco> {
//   bool isLoading = false;
//   String hintText = 'Digite o CEP de sua residência*';

//   ViaCepInfo? cepInfo;
//   String? cepError;

//   final TextEditingController cepController = TextEditingController();
//   final TextEditingController numeroController = TextEditingController();
//   final TextEditingController complementoController = TextEditingController();

//   final maskFormatter = MaskTextInputFormatter(mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         TextFieldCustom(
//           filled: true,
//           controller: cepController,
//           formatter: [maskFormatter],
//           labelText: 'Digite o seu CEP:',
//           iconPrefix: const Icon(Icons.pin_drop),
//           onChanged: (value) async {
//             if (value.length == 9) {
//               setState(() {
//                 isLoading = true;
//               });

//               final viaCepSearchCep = ViaCepSearchCep();
//               final infoCepJson = await viaCepSearchCep.searchInfoByCep(cep: maskFormatter.getUnmaskedText());

//               setState(() {
//                 isLoading = false;
//                 hintText = value;
//                 infoCepJson.fold((l) {
//                   cepInfo = null;
//                   return cepError = l.errorMessage;
//                 }, (data) {
//                   cepError = null;
//                   return cepInfo = data;
//                 });
//               });
//             }
//           },
//           hintText: hintText,
//         ),
//         if (isLoading) const Text('Buscando o seu endereço...'),
//         if (cepError != null) Text('[Erro] -> $cepError', style: const TextStyle()),
//         if (cepInfo != null)
//           Column(
//             children: [
//               const SizedBox(height: 15),
//               TextFieldCustom(
//                 filled: true,
//                 controller: TextEditingController(),
//                 labelText: 'Rua:',
//                 readOnly: true,
//                 hintText: cepInfo!.logradouro,
//               ),
//               const SizedBox(height: 15),
//               TextFieldCustom(
//                 filled: true,
//                 controller: TextEditingController(),
//                 labelText: 'Bairro:',
//                 readOnly: true,
//                 hintText: cepInfo!.bairro,
//               ),
//               const SizedBox(height: 15),
//               TextFieldCustom(
//                 filled: true,
//                 controller: TextEditingController(),
//                 labelText: 'Cidade:',
//                 readOnly: true,
//                 hintText: cepInfo!.localidade,
//               ),
//               const SizedBox(height: 15),
//               TextFieldCustom(
//                 filled: true,
//                 controller: TextEditingController(),
//                 labelText: 'Estado',
//                 readOnly: true,
//                 hintText: cepInfo!.uf,
//               ),
//               const SizedBox(height: 15),
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextFieldCustom(
//                       filled: true,
//                       controller: numeroController,
//                       labelText: 'Número:',
//                       hintText: 'Digite o número de sua residência*',
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return '⚠️ Este campo é obrigatório.';
//                         }
//                         return null;
//                       },
//                     ),
//                   ),
//                   const SizedBox(width: 15),
//                   Expanded(
//                     child: TextFieldCustom(
//                       filled: true,
//                       controller: complementoController,
//                       labelText: 'Complemento',
//                       hintText: 'Caso tenha complemento.',
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//       ],
//     );
//   }
// }

// class _SectionLocalHorario extends StatefulWidget {
//   final String etapa;
//   const _SectionLocalHorario(this.etapa);

//   @override
//   State<_SectionLocalHorario> createState() => __SectionLocalHorarioState();
// }

// class __SectionLocalHorarioState extends State<_SectionLocalHorario> {
//   final HorariosLocaisController horariosLocaisController = HorariosLocaisController(HorariosLocaisRepository());

//   String? selectedValue;

//   @override
//   Widget build(BuildContext context) {
//     String etapaCut = widget.etapa.contains('-') ? widget.etapa.split(' ').last : widget.etapa;
//     return widget.etapa != 'Adultos'
//         ? FutureBuilder(
//             future: horariosLocaisController.getHorariosLocais(etapaCut.toLowerCase()),
//             builder: (context, snapshot) {
//               return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         const Text(
//                           'Selecione o local de sua PREFERÊNCIA:',
//                           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                           textAlign: TextAlign.center,
//                         ),
//                         const Text(
//                           'Lembrando: O local selecionado poderá ser alterado pela coordenação',
//                           style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
//                           textAlign: TextAlign.center,
//                         ),
//                         DropdownButtonFormField(
//                             decoration: InputDecoration(
//                               hintText: snapshot.connectionState == ConnectionState.waiting ? 'Carregando...' : 'Selecione...',
//                               enabledBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(color: Colors.grey[600]!, width: 2),
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               border: OutlineInputBorder(
//                                 borderSide: BorderSide(color: Colors.grey[600]!, width: 2),
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               filled: true,
//                               fillColor: Colors.grey[400],
//                             ),
//                             borderRadius: BorderRadius.circular(20),
//                             validator: (value) => value == null ? "⚠️ É necessário escolher uma opção." : null,
//                             dropdownColor: Colors.grey[400],
//                             value: selectedValue,
//                             onChanged: (dynamic newValue) {
//                               setState(() {
//                                 selectedValue = newValue!;
//                               });
//                             },
//                             items: snapshot.data == null ? [] : snapshot.data!.map<DropdownMenuItem<String>>((e) => DropdownMenuItem<String>(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList()),
//                       ],
//                     ),
//                   ));
//             },
//           )
//         : const Center(
//             child: Text(
//               'O seu local e horário de encontro será informado pela coordenação.',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),
//           );
//   }
// }
