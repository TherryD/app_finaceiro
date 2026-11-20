import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utilitarios/valor.dart';

class DialogoAcao extends StatefulWidget {
  final String nomeMeta;
  final bool isResgate;
  final double maximo; // saldo disponível (guardar) ou valor guardado (retirar)

  const DialogoAcao({
    super.key,
    required this.nomeMeta,
    required this.maximo,
    this.isResgate = false,
  });

  @override
  State<DialogoAcao> createState() => _DialogoAcaoState();
}

class _DialogoAcaoState extends State<DialogoAcao> {
  final TextEditingController _valorController = TextEditingController();
  String? _erro;

  @override
  void dispose() {
    _valorController.dispose();
    super.dispose();
  }

  void _confirmar() {
    final valor = parseValor(_valorController.text);
    if (valor <= 0) {
      setState(() => _erro = 'Digite um valor maior que zero');
      return;
    }
    if (valor > widget.maximo) {
      setState(() => _erro = widget.isResgate
          ? 'A meta só tem R\$ ${widget.maximo.toStringAsFixed(2)}'
          : 'Saldo insuficiente (R\$ ${widget.maximo.toStringAsFixed(2)})');
      return;
    }
    Navigator.pop(context, valor);
  }

  @override
  Widget build(BuildContext context) {
    final cor = widget.isResgate ? Colors.orange : Colors.teal;

    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        widget.isResgate ? 'Resgatar de: ${widget.nomeMeta}' : 'Investir: ${widget.nomeMeta}',
        style: TextStyle(fontWeight: FontWeight.bold, color: cor),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.isResgate ? 'Quanto deseja retirar da meta?' : 'Quanto transferir para esta meta?'),
          const SizedBox(height: 12),
          TextField(
            controller: _valorController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
            ],
            onChanged: (_) {
              if (_erro != null) setState(() => _erro = null);
            },
            decoration: InputDecoration(
              labelText: 'Valor (R\$)',
              errorText: _erro,
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
          style: ElevatedButton.styleFrom(
            backgroundColor: cor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: _confirmar,
          child: Text(widget.isResgate ? 'Retirar' : 'Transferir'),
        ),
      ],
    );
  }
}