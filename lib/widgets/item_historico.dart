import 'package:flutter/material.dart';

class ItemHistorico extends StatelessWidget {
  final Map transacao; // Sem os símbolos para evitar o bug do chat
  final VoidCallback onDeletar; // Função que será chamada ao clicar na lixeira

  const ItemHistorico({
    super.key,
    required this.transacao,
    required this.onDeletar,
  });

  @override
  Widget build(BuildContext context) {
    final isEntrada = transacao['tipo'] == 'Entrada';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isEntrada ? Colors.green.shade50 : Colors.red.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(
            isEntrada ? Icons.arrow_upward : Icons.arrow_downward,
            color: isEntrada ? Colors.green : Colors.red,
            size: 20,
          ),
        ),
        title: Text(transacao['descricao'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text(transacao['categoria'], style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${isEntrada ? '+' : '-'} R\$ ${transacao['valor'].toStringAsFixed(2)}',
              style: TextStyle(color: isEntrada ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(width: 12),
            // Botão de apagar a transação
            GestureDetector(
              onTap: onDeletar,
              child: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
            ),
          ],
        ),
      ),
    );
  }
}