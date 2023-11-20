import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:search_cep/search_cep.dart';
import 'package:webapp/pages/widgets/text_field_custom.dart';
import 'package:webapp/viewmodels/inscricao_view_model.dart';

class FormularioEndereco extends StatefulWidget {
  const FormularioEndereco({super.key, required this.etapa, required this.onSubmit});

  final String etapa;
  final VoidCallback onSubmit;

  @override
  State<FormularioEndereco> createState() => _FormularioEnderecoState();
}

class _FormularioEnderecoState extends State<FormularioEndereco> {
  bool isLoading = false;
  String hintText = 'Digite o CEP de sua residência*';

  ViaCepInfo? cepInfo;
  String? cepError;

  @override
  Widget build(BuildContext context) {
    final TextEditingController cepController = TextEditingController();
    final TextEditingController numeroController = TextEditingController();
    final TextEditingController complementoController = TextEditingController();

    final GlobalKey<FormState> key = GlobalKey<FormState>();

    final maskFormatter = MaskTextInputFormatter(mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});

    final inscricaoProvider = Provider.of<InscricaoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.etapa, style: const TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: key,
            child: Column(
              children: [
                TextFieldCustom(
                  controller: cepController,
                  formatter: [maskFormatter],
                  labelText: 'Digite o seu CEP:',
                  iconPrefix: const Icon(Icons.pin_drop),
                  onChanged: (value) async {
                    if (value.length == 9) {
                      setState(() {
                        isLoading = true;
                      });

                      final viaCepSearchCep = ViaCepSearchCep();
                      final infoCepJson = await viaCepSearchCep.searchInfoByCep(cep: maskFormatter.getUnmaskedText());

                      setState(() {
                        isLoading = false;
                        hintText = value;
                        infoCepJson.fold((l) {
                          cepInfo = null;
                          return cepError = l.errorMessage;
                        }, (data) {
                          cepError = null;
                          return cepInfo = data;
                        });
                      });
                    }
                  },
                  hintText: hintText,
                ),
                if (isLoading) const Text('Buscando o seu endereço...'),
                if (cepError != null) Text('[Erro] -> $cepError', style: const TextStyle()),
                if (cepInfo != null)
                  Column(
                    children: [
                      const SizedBox(height: 15),
                      TextFieldCustom(
                        controller: TextEditingController(),
                        labelText: 'Rua:',
                        readOnly: true,
                        hintText: cepInfo!.logradouro,
                      ),
                      const SizedBox(height: 15),
                      TextFieldCustom(
                        controller: TextEditingController(),
                        labelText: 'Bairro:',
                        readOnly: true,
                        hintText: cepInfo!.bairro,
                      ),
                      const SizedBox(height: 15),
                      TextFieldCustom(
                        controller: TextEditingController(),
                        labelText: 'Cidade:',
                        readOnly: true,
                        hintText: cepInfo!.localidade,
                      ),
                      const SizedBox(height: 15),
                      TextFieldCustom(
                        controller: TextEditingController(),
                        labelText: 'Estado',
                        readOnly: true,
                        hintText: cepInfo!.uf,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: TextFieldCustom(
                              controller: numeroController,
                              labelText: 'Número:',
                              hintText: 'Digite o número de sua residência*',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '⚠️ Este campo é obrigatório.';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: TextFieldCustom(
                              controller: complementoController,
                              labelText: 'Complemento',
                              hintText: 'Caso tenha complemento.',
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (cepInfo != null) {
            if (key.currentState!.validate()) {
              inscricaoProvider.updateEndereco({
                'cep': hintText,
                'rua': cepInfo!.logradouro!,
                'cidade': cepInfo!.localidade!,
                'uf': cepInfo!.uf!,
                'bairro': cepInfo!.bairro!,
                'numero': numeroController.text,
                'complemento': complementoController.text,
              });
              widget.onSubmit();
            }
          } else if (cepError != null) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Por favor digite o CEP corretamente antes de prosseguir.', style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: Colors.yellow,
            ));
          }
        },
        label: const Text('Avançar', style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.forward),
      ),
    );
  }
}
