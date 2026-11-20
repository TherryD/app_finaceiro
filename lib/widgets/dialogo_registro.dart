import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utilitarios/valor.dart';

// Formatador personalizado para exibir o valor em formato de moeda (R$ 0,00)
class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Remove tudo o que não for número
    String numbersOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (numbersOnly.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Converte para double dividindo por 100 para tratar os centavos
    double value = double.parse(numbersOnly) / 100;
    
    // Formata no padrão brasileiro (R$ X.XXX,XX)
    String newText = 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
    // Adiciona pontos de milhar se necessário
    if (value >= 1000) {
      List<String> parts = value.toStringAsFixed(2).split('.');
      String intPart = parts[0];
      String decPart = parts[1];
      
      RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
      intPart = intPart.replaceAllMapped(reg, (Match m) => '${m[1]}.');
      newText = 'R\$ $intPart,$decPart';
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class DialogoRegistro extends StatefulWidget {
  const DialogoRegistro({super.key});

  @override
  State<DialogoRegistro> createState() => _DialogoRegistroState();
}

class _DialogoRegistroState extends State<DialogoRegistro> {
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
  String tipoSelecionado = 'Saída';
  String categoriaSelecionada = 'Delivery';
  String? _erroValor;

  @override
  void dispose() {
    _descricaoController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  void _salvar() {
    // Extrai o valor numérico limpo a partir do texto formatado com "R$"
    final valor = parseValor(_valorController.text);
    if (valor <= 0) {
      setState(() => _erroValor = 'Digite um valor maior que zero');
      return;
    }
    Navigator.pop(context, {
      'descricao': _descricaoController.text.trim().isEmpty ? 'Sem descrição' : _descricaoController.text.trim(),
      'valor': valor,
      'tipo': tipoSelecionado,
      'categoria': tipoSelecionado == 'Entrada' ? 'Renda' : categoriaSelecionada,
      'data': DateTime.now().toIso8601String(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Novo Registro', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _descricaoController,
              decoration: InputDecoration(
                labelText: 'Descrição',
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
                labelText: 'Valor',
                errorText: _erroValor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(12)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: tipoSelecionado,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: 'Entrada', child: Text('Entrada')),
                    DropdownMenuItem(value: 'Saída', child: Text('Saída')),
                  ],
                  onChanged: (novo) => setState(() => tipoSelecionado = novo!),
                ),
              ),
            ),
            if (tipoSelecionado == 'Saída') ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(12)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: categoriaSelecionada,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: 'Delivery', child: Text('Delivery')),
                      DropdownMenuItem(value: 'Padaria', child: Text('Padaria')),
                      DropdownMenuItem(value: 'Transporte', child: Text('Transporte')),
                      DropdownMenuItem(value: 'Contas', child: Text('Contas')),
                      DropdownMenuItem(value: 'Outros', child: Text('Outros')),
                    ],
                    onChanged: (novaCat) => setState(() => categoriaSelecionada = novaCat!),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar', style: TextStyle(color: Colors.grey))),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          onPressed: _salvar,
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}