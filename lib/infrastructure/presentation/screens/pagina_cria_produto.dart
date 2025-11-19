import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/infrastructure/presentation/widgets/button_componente.dart';
import 'package:myapp/infrastructure/presentation/widgets/textfield_componente.dart';
import 'package:provider/provider.dart';
import 'package:myapp/infrastructure/presentation/providers/produto_provider.dart';

class CriarProdutoPage extends StatefulWidget {
  const CriarProdutoPage({super.key});

  @override
  State<CriarProdutoPage> createState() => _CriarProdutoPageState();
}

class _CriarProdutoPageState extends State<CriarProdutoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _precoController = TextEditingController();
  final TextEditingController _tipoController = TextEditingController();
  final TextEditingController _quantidadeController = TextEditingController();

  File? _imagemSelecionada;
  bool _carregando = false;

  Future<void> _selecionarImagem() async {
    final picker = ImagePicker();
    final XFile? imagem = await picker.pickImage(source: ImageSource.gallery);
    if (imagem != null) {
      setState(() {
        _imagemSelecionada = File(imagem.path);
      });
    }
  }

  Future<void> _salvarProduto() async {
    if (!_formKey.currentState!.validate() || _imagemSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos e selecione uma imagem.'),
        ),
      );
      return;
    }

    setState(() {
      _carregando = true;
    });

    try {
      await Provider.of<ProdutoProvider>(
        context,
        listen: false,
      ).adicionarProduto(
        _nomeController.text,
        _descricaoController.text,
        int.parse(_precoController.text),
        _tipoController.text,
        _imagemSelecionada!,
        int.parse(_quantidadeController.text),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto adicionado com sucesso!')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro: $e')));
    } finally {
      setState(() {
        _carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        foregroundColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 5, 106, 12),
        title: const Text('Adicionar Produto'),
    ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFieldComponente(
                controller: _nomeController, 
                prefixIcon: Icons.shopping_basket, 
                hint: "Ingresso para cinema", 
                label: "Nome",
              ),
              const SizedBox(height: 20),
              TextFieldComponente(
                controller: _descricaoController, 
                prefixIcon: Icons.edit, 
                hint: "Ingresso para...", 
                label: "Descrição",
              ),
              const SizedBox(height: 20),
              TextFieldComponente(
                controller: _precoController, 
                prefixIcon: Icons.money, 
                hint: "35", 
                label: "Preço",
              ),
              const SizedBox(height: 20),
              TextFieldComponente(
                controller: _tipoController, 
                prefixIcon: Icons.shopping_bag, 
                hint: "Ingresso", 
                label: "Tipo",
              ),
              const SizedBox(height: 20),
              TextFieldComponente(
                controller: _quantidadeController,
                prefixIcon: Icons.numbers_outlined, 
                hint: "3", 
                label: "Quantidade",
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _selecionarImagem,
                child: _imagemSelecionada == null
                    ? Container(
                        height: 150,
                        color: Colors.grey[300],
                        child: const Center(child: Text('Selecionar Imagem')),
                      )
                    : Image.file(_imagemSelecionada!, height: 150),
              ),
              const SizedBox(height: 20),
              _carregando
                  ? const CircularProgressIndicator()
                  : ButtonComponente(
                    text: "Cadastrar", 
                    function: _salvarProduto,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
