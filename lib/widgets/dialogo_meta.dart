import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utilitarios/valor.dart';
import 'dialogo_registro.dart'; // Importa o CurrencyInputFormatter que criámos anteriormente

class DialogoMeta extends StatefulWidget {
  const DialogoMeta({super.key});

  @override
  State<DialogoMeta> createState() => _DialogoMetaState();
}

class _DialogoMetaState extends State<DialogoMeta> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
  String? _erroNome;
  String? _erroValor;

  @override
  void dispose() {
    _nomeController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  void _criar() {
    final nome = _nomeController.text.trim();
    // Extrai o valor numérico limpo a partir do texto formatado com "R$"
    final valor = parseValor(_valorController.text);

    setState(() {
      _erroNome = nome.isEmpty ? 'Dê um nome para a meta' : null;
      _erroValor = valor <= 0 ? 'Digite um valor maior que zero' : null;
    });

    if (_erroNome == null && _erroValor == null) {
      Navigator.pop(context, {'nome': nome, 'valorTotal': valor, 'valorGuardado': 0.0});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Criar Nova Meta', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nomeController,
            decoration: InputDecoration(
              labelText: 'Nome da Meta',
              errorText: _erroNome,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _valorController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CurrencyInputFormatter(), // Aplica a máscara automática de moeda
            ],
            onChanged: (_) {
              if (_erroValor != null) setState(() => _erroValor = null);
            },
            decoration: InputDecoration(
              labelText: 'Valor Total',
              errorText: _erroValor,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar', style: TextStyle(color: Colors.grey))),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          onPressed: _criar,
          child: const Text('Criar'),
        ),
      ],
    );
  }
}