import 'package:flutter/material.dart';

class MenuInferior extends StatelessWidget {
  final VoidCallback onNovoRegistro;
  final VoidCallback onNovaMeta;

  const MenuInferior({
    super.key,
    required this.onNovoRegistro,
    required this.onNovaMeta,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, height: 5, margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
          ),
          const Text('O que deseja adicionar?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ListTile(
            leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.teal.shade50, shape: BoxShape.circle), child: const Icon(Icons.swap_horiz, color: Colors.teal)),
            title: const Text('Novo Registro', style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: const Text('Adicionar entrada ou saída'),
            onTap: () { Navigator.pop(context); onNovoRegistro(); },
          ),
          const Divider(),
          ListTile(
            leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.orange.shade50, shape: BoxShape.circle), child: const Icon(Icons.flag, color: Colors.orange)),
            title: const Text('Nova Meta', style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: const Text('Criar um novo objetivo'),
            onTap: () { Navigator.pop(context); onNovaMeta(); },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}