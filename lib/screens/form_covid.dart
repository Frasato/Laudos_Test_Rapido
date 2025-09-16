import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class FormCovid extends StatefulWidget {
  const FormCovid({super.key});

  @override
  State<StatefulWidget> createState() => _FormCovidState();
}

class _FormCovidState extends State<FormCovid> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _idadeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _municipioController = TextEditingController();
  final TextEditingController _dataColetaController = TextEditingController();
  final TextEditingController _loteController = TextEditingController();
  final TextEditingController _sintomasController = TextEditingController();
  final TextEditingController _responsavelController = TextEditingController();
  final TextEditingController _crfController = TextEditingController();

  String _sexo = 'Feminino';
  bool _detectavel = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _idadeController.dispose();
    _telefoneController.dispose();
    _cpfController.dispose();
    _enderecoController.dispose();
    _municipioController.dispose();
    _dataColetaController.dispose();
    _loteController.dispose();
    _sintomasController.dispose();
    _responsavelController.dispose();
    _crfController.dispose();
    super.dispose();
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
                    pw.Text(
                      'DROGARIAS SHALOM POPULAR - SEVERÍNIA - SP',
                      style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text('Avenida Severino Sicchieri 307, Centro - Severínia - SP'),
                    pw.Text('CNPJ: 03.502.426/0001-31'),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      'VÍRUS RESPIRATÓRIO',
                      style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 25),

              pw.Text('Paciente: ${_nomeController.text}'),
              pw.SizedBox(height: 10),
              pw.Text('Idade: ${_idadeController.text} anos'),
              pw.SizedBox(height: 10),
              pw.Text('Sexo: $_sexo'),
              pw.SizedBox(height: 10),
              pw.Text('Telefone: ${_telefoneController.text}'),
              pw.SizedBox(height: 10),
              pw.Text('CPF: ${_cpfController.text}'),
              pw.SizedBox(height: 10),
              pw.Text('Endereço: ${_enderecoController.text}'),
              pw.SizedBox(height: 10),
              pw.Text('Município: ${_municipioController.text}'),
              pw.SizedBox(height: 10),
              pw.Text('Assinatura Paciente: ____________________'),
              pw.SizedBox(height: 25),

              pw.Text('Método: Teste Rápido (SWAP)'),
              pw.SizedBox(height: 10),
              pw.Text('Data da Coleta: ${_dataColetaController.text}'),
              pw.SizedBox(height: 10),
              pw.Text('Lote: ${_loteController.text}'),
              pw.SizedBox(height: 10),
              pw.Text('Sintomas: ${_sintomasController.text}'),
              pw.SizedBox(height: 10),
              pw.Text('Detectável: ${_detectavel ? "Sim" : "Não"}'),
              pw.SizedBox(height: 10),
              pw.Text('Corona vírus SARS-Cov2'),
              pw.SizedBox(height: 25),

              pw.Text(
                'Observações:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text('1- O teste rápido é utilizado como apoio diagnóstico para COVID-19.'),
              pw.Text('2- Deverão ser realizados somente os testes que tiveram registro na Agência Nacional de Vigilância Sanitária, acompanhados de laudo de avaliação do Instituto Nacional de Controle de Qualidade em Saúde da Fundação Oswaldo Cruz (INCOS/Fiocruz).'),
              pw.Text('3- O teste será informado à vigilância epidemiológica do município.'),
              pw.Text('4- Caso o paciente não cumpra com o isolamento, serão tomadas as medidas cabíveis pela vigilância epidemiológica do município.'),
              pw.SizedBox(height: 25),

              pw.Text('_______________________________________________ Data: ${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year}'),
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
        dialogTitle: 'Salvar Laudo COVID',
        fileName: 'laudo_covid_${DateTime.now().millisecondsSinceEpoch}.pdf',
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
    body: Container(
      width: double.infinity,
      height: double.infinity,
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
                    'VÍRUS RESPIRATÓRIO',
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
                labelText: 'Nome do Paciente',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _idadeController,
                    decoration: const InputDecoration(
                      labelText: 'Idade',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _sexo,
                    decoration: const InputDecoration(
                      labelText: 'Sexo',
                      border: OutlineInputBorder(),
                    ),
                    items: ['Feminino', 'Masculino']
                        .map((String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ))
                        .toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _sexo = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _telefoneController,
              decoration: const InputDecoration(
                labelText: 'Telefone',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _cpfController,
              decoration: const InputDecoration(
                labelText: 'CPF',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _enderecoController,
              decoration: const InputDecoration(
                labelText: 'Endereço',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _municipioController,
              decoration: const InputDecoration(
                labelText: 'Município',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'DADOS DO TESTE',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _dataColetaController,
              decoration: const InputDecoration(
                labelText: 'Data da Coleta (dd/mm/aaaa)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _loteController,
              decoration: const InputDecoration(
                labelText: 'Lote',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _sintomasController,
              decoration: const InputDecoration(
                labelText: 'Sintomas',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                const Text('Detectável: '),
                Radio<bool>(
                  value: true,
                  groupValue: _detectavel,
                  onChanged: (bool? value) {
                    setState(() {
                      _detectavel = value!;
                    });
                  },
                ),
                const Text('Sim'),
                Radio<bool>(
                  value: false,
                  groupValue: _detectavel,
                  onChanged: (bool? value) {
                    setState(() {
                      _detectavel = value!;
                    });
                  },
                ),
                const Text('Não'),
              ],
            ),
            const SizedBox(height: 20),

            const Text(
              'RESPONSÁVEL TÉCNICO',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _responsavelController,
              decoration: const InputDecoration(
                labelText: 'Nome do Responsável Técnico',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _crfController,
              decoration: const InputDecoration(
                labelText: 'CRF',
                border: OutlineInputBorder(),
              ),
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
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _savePdf,
                  icon: const Icon(Icons.save),
                  label: const Text('Salvar PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
  );
}