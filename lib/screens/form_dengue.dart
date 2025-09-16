import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class FormDengue extends StatefulWidget {
  const FormDengue({super.key});

  @override
  State<FormDengue> createState() => _FormDengueState();
}

class _FormDengueState extends State<FormDengue> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _nascimentoController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _municipioController = TextEditingController();
  final TextEditingController _dataColetaController = TextEditingController();
  final TextEditingController _loteController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _sintomasController = TextEditingController();
  final TextEditingController _responsavelController = TextEditingController();
  final TextEditingController _crfController = TextEditingController();

  final _dateMaskFormatter = MaskTextInputFormatter(mask: '##/##/####', filter: {'#': RegExp(r'[0-9]')});

  String _sexo = 'Masculino';
  bool _detectavel = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _nascimentoController.dispose();
    _telefoneController.dispose();
    _cpfController.dispose();
    _enderecoController.dispose();
    _numeroController.dispose();
    _bairroController.dispose();
    _municipioController.dispose();
    _dataColetaController.dispose();
    _loteController.dispose();
    _marcaController.dispose();
    _sintomasController.dispose();
    _responsavelController.dispose();
    _crfController.dispose();
    super.dispose();
  }

  String _formatterDate(String date){
    if(date.length == 8){
      return '${date.substring(0, 2)}/${date.substring(2, 4)}/${date.substring(4, 8)}';
    }
    return date;
  }

  Future<pw.Document> _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text('DROGARIAS SHALOM POPULAR - SEVERÍNIA - SP',
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.bold)),
                    pw.Text('Avenida Severino Sicchieri 307, Centro - Severínia - SP'),
                    pw.Text('CNPJ: 03.502.426/0001-31'),
                    pw.SizedBox(height: 10),
                    pw.Text('TESTE DE DENGUE',
                        style: pw.TextStyle(
                            fontSize: 14, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              ),
              pw.SizedBox(height: 25),

              pw.Text('Paciente: ${_nomeController.text}'),
              pw.SizedBox(height: 10),
              pw.Text('Data Nascimento: ${_formatterDate(_nascimentoController.text)}'),
              pw.SizedBox(height: 10),
              pw.Text('Sexo: $_sexo'),
              pw.SizedBox(height: 10),
              pw.Text('Telefone: ${_telefoneController.text}'),
              pw.SizedBox(height: 10),
              pw.Text('CPF: ${_cpfController.text}'),
              pw.SizedBox(height: 10),
              pw.Text('Endereço: ${_enderecoController.text}, Nº: ${_numeroController.text}'),
              pw.SizedBox(height: 10),
              pw.Text('Bairro: ${_bairroController.text}'),
              pw.SizedBox(height: 10),
              pw.Text('Município: ${_municipioController.text}'),
              pw.SizedBox(height: 10),
              pw.Text('Assinatura Paciente: ____________________'),
              pw.SizedBox(height: 25),

              pw.Text('Método: Imunocromatografia'),
              pw.SizedBox(height: 10),
              pw.Text('Amostra: Sangue Total'),
              pw.SizedBox(height: 10),
              pw.Text('Data da Coleta: ${_formatterDate(_dataColetaController.text)}'),
              pw.SizedBox(height: 10),
              pw.Text('Lote: ${_loteController.text}'),
              pw.SizedBox(height: 10),
              pw.Text('Marca: ${_marcaController.text}'),
              pw.SizedBox(height: 10),
              pw.Text('Sintomas: ${_sintomasController.text}'),
              pw.SizedBox(height: 10),
              pw.Text('Detectável: ${_detectavel ? "Sim" : "Não"}'),
              pw.SizedBox(height: 25),

              pw.Text('_______________________________________________ Data: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'),
              pw.SizedBox(height: 10),
              pw.Text('Responsável Técnico: ${_responsavelController.text} CRF: ${_crfController.text}'),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  Future<void> _printDocument() async {
    final pdf = await _generatePdf();
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  Future<void> _savePdf() async {
    try {
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Salvar Laudo Dengue',
        fileName: 'laudo_dengue_${DateTime.now().millisecondsSinceEpoch}.pdf',
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (outputFile != null) {
        final pdf = await _generatePdf();
        final file = File(outputFile);
        await file.writeAsBytes(await pdf.save());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF salvo com sucesso!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(onPressed: () => {Navigator.pushReplacementNamed(context, '/home')}, icon: Icon(Icons.close)),
                const Center(
                  child: Column(
                    children: [
                      Text(
                        'DROGARIAS SHALOM POPULAR - SEVERÍNIA - SP',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Text('Avenida Severino Sicchieri 307, Centro - Severínia - SP'),
                      Text('CNPJ: 03.502.426/0001-31'),
                      SizedBox(height: 10),
                      Text(
                        'TESTE DE DENGUE',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  'DADOS DO PACIENTE',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _nomeController,
                  decoration: const InputDecoration(
                      labelText: 'Nome Completo', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _nascimentoController,
                  decoration: const InputDecoration(
                      labelText: 'Data de Nascimento', border: OutlineInputBorder()),
                  inputFormatters: [_dateMaskFormatter],
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _sexo,
                  items: ['Masculino', 'Feminino']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => setState(() => _sexo = v!),
                  decoration: const InputDecoration(
                    labelText: 'Sexo',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _telefoneController,
                  decoration: const InputDecoration(
                      labelText: 'Telefone', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _cpfController,
                  decoration: const InputDecoration(
                      labelText: 'CPF', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _enderecoController,
                  decoration: const InputDecoration(
                      labelText: 'Endereço', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _numeroController,
                  decoration: const InputDecoration(
                      labelText: 'Número', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _bairroController,
                  decoration: const InputDecoration(
                      labelText: 'Bairro', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _municipioController,
                  decoration: const InputDecoration(
                      labelText: 'Município', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),

                const Text(
                  'DADOS DA COLETA',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _dataColetaController,
                  decoration: const InputDecoration(
                      labelText: 'Data da Coleta', border: OutlineInputBorder()),
                  inputFormatters: [_dateMaskFormatter],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _loteController,
                  decoration: const InputDecoration(
                      labelText: 'Lote', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _marcaController,
                  decoration: const InputDecoration(
                      labelText: 'Marca', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _sintomasController,
                  decoration: const InputDecoration(
                      labelText: 'Sintomas', border: OutlineInputBorder()),
                  maxLines: 2,
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    const Text('Detectável: '),
                    Radio<bool>(
                      value: true,
                      groupValue: _detectavel,
                      onChanged: (v) => setState(() => _detectavel = v!),
                    ),
                    const Text('Sim'),
                    Radio<bool>(
                      value: false,
                      groupValue: _detectavel,
                      onChanged: (v) => setState(() => _detectavel = v!),
                    ),
                    const Text('Não'),
                  ],
                ),
                const SizedBox(height: 20),

                const Text(
                  'DADOS DO RESPONSÁVEL TÉCNICO',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _responsavelController,
                  decoration: const InputDecoration(
                      labelText: 'Responsável Técnico',
                      border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _crfController,
                  decoration: const InputDecoration(
                      labelText: 'CRF',
                      border: OutlineInputBorder()),
                ),
                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _printDocument,
                      icon: const Icon(Icons.print),
                      label: const Text('Imprimir'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[700],
                          foregroundColor: Colors.white),
                    ),
                    ElevatedButton.icon(
                      onPressed: _savePdf,
                      icon: const Icon(Icons.save),
                      label: const Text('Salvar PDF'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          foregroundColor: Colors.white),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
}