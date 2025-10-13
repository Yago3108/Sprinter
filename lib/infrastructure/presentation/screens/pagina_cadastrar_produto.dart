import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/infrastructure/presentation/app/components/textfield_componente.dart';
import 'package:myapp/modules/produto/produto_usecases.dart';
import 'package:provider/provider.dart';
import 'package:myapp/infrastructure/presentation/providers/produto_provider.dart';

class PaginaCadastrarProduto extends StatefulWidget {
  const PaginaCadastrarProduto({super.key});

  @override
  State<PaginaCadastrarProduto> createState() => _PaginaCadastrarProdutoState();
}

class _PaginaCadastrarProdutoState extends State<PaginaCadastrarProduto> {
  final _formKey = GlobalKey<FormState>();

  // controllers
  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerDescricao = TextEditingController();
  final TextEditingController _controllerPreco = TextEditingController();
  final TextEditingController _controllerTipo = TextEditingController();
  final TextEditingController _controllerQuantidade = TextEditingController();

  // erros
  String? _erroNome;
  String? _erroDescricao;
  String? _erroPreco;
  String? _erroTipo;
  String? _erroQuantidade;
  String? _erroImagem;

  final ProdutoUseCases produtoUseCases = ProdutoUseCases();

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

  Future<void> _cadastrarProduto() async {
    try {
      await produtoUseCases.cadastrarProduto(_controllerNome.text, _controllerDescricao, _controllerPreco, _controllerTipo, _controllerQuantidade);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Produto')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFieldComponente(
                controller: _controllerNome,
                hint: "Nome do Produto",
                label: "Nome",
                error: _erroNome,
              ),
              const SizedBox(height: 30),
              TextFieldComponente(
                controller: _controllerDescricao,
                hint: "Descrição do Produto",
                label: "Descrição",
                error: _erroDescricao,
              ),
              const SizedBox(height: 30),
              TextFieldComponente(
                controller: _controllerPreco,
                hint: "Preço do Produto",
                label: "Preço",
                error: _erroPreco,
              ),
              const SizedBox(height: 30),
              TextFieldComponente(
                controller: _controllerTipo,
                hint: "Tipo do Produto",
                label: "Tipo",
                error: _erroTipo,
              ),
              const SizedBox(height: 30),
              TextFieldComponente(
                controller: _controllerQuantidade,
                hint: "Quantidade do Produto",
                label: "Quantidade",
                error: _erroQuantidade,
              ),
              const SizedBox(height: 30),
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
              ElevatedButton(
                onPressed: _salvarProduto,
                child: const Text('Salvar Produto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
