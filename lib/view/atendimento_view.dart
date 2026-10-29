import 'dart:io';
import 'package:flutter/material.dart';
import '../data/models/chamado_model.dart';
import '../viewModel/atendimento_view_model.dart';

class AtendimentoView extends StatefulWidget {
  const AtendimentoView({super.key});

  @override
  State<AtendimentoView> createState() => _AtendimentoViewState();
}

class _AtendimentoViewState extends State<AtendimentoView> {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  final AtendimentoViewModel _viewModel = AtendimentoViewModel();

  String? _categoria;
  DateTime _data = DateTime.now();

  @override
  void dispose() {
    _descricaoController.dispose();
    super.dispose();
  }

  String _dataTexto(DateTime d) {
    final dia = d.day.toString().padLeft(2, '0');
    final mes = d.month.toString().padLeft(2, '0');
    return '$dia/$mes/${d.year}';
  }

  Future<void> _escolherData() async {
    final escolhida = await showDatePicker(
      context: context,
      initialDate: _data,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (escolhida != null) {
      setState(() {
        _data = escolhida;
      });
    }
  }

  Future<void> _concluir(ChamadoModel chamado) async {
    // Valida o formulário
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha os campos obrigatórios')),
      );
      return;
    }

    final deuCerto = await _viewModel.concluir(
      chamadoId: chamado.id,
      categoria: _categoria!,
      descricao: _descricaoController.text,
      data: _data,
    );

    if (!mounted) return;

    if (deuCerto) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Atendimento salvo! Será enviado quando houver internet.')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível salvar o atendimento')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final chamado = ModalRoute.of(context)!.settings.arguments as ChamadoModel;

    return Scaffold(
      appBar: AppBar(title: Text('Chamado ${chamado.codigoCliente}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${chamado.codigoCliente} - ${chamado.nomeCliente}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Categoria: ${chamado.categoriaInformada}'),
                    Text(chamado.descricaoProblema),
                    Text(chamado.enderecoCompleto),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Categoria do parecer técnico',
                      border: OutlineInputBorder(),
                    ),
                    items: _viewModel.categorias
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (valor) {
                      _categoria = valor;
                    },
                    validator: (valor) {
                      if (valor == null) return 'Escolha uma categoria';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descricaoController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Descrição do procedimento',
                      border: OutlineInputBorder(),
                    ),
                    validator: (valor) {
                      if (valor == null || valor.trim().length < 10) {
                        return 'Descreva com pelo menos 10 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.calendar_today),
                    title: Text('Data de conclusão: ${_dataTexto(_data)}'),
                    trailing: TextButton(
                      onPressed: _escolherData,
                      child: const Text('Alterar'),
                    ),
                  ),
                ],
              ),
            ),
            // Foto
            ListenableBuilder(
              listenable: _viewModel,
              builder: (context, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_viewModel.caminhoFoto != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Image.file(
                          File(_viewModel.caminhoFoto!),
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    Wrap(
                      spacing: 8,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => _viewModel.escolherFoto(usarCamera: true),
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Câmera'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => _viewModel.escolherFoto(usarCamera: false),
                          icon: const Icon(Icons.photo_library),
                          label: const Text('Galeria'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _viewModel.salvando ? null : () => _concluir(chamado),
                        child: _viewModel.salvando
                            ? const CircularProgressIndicator()
                            : const Text('Concluir atendimento'),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}