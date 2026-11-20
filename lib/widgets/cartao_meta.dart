import 'package:flutter/material.dart';

class CartaoMeta extends StatelessWidget {
  final Map meta;
  final VoidCallback onGuardar;
  final VoidCallback onRetirar;
  final VoidCallback onDeletar;

  const CartaoMeta({
    super.key,
    required this.meta,
    required this.onGuardar,
    required this.onRetirar,
    required this.onDeletar,
  });

  @override
  Widget build(BuildContext context) {
    double progresso = meta['valorGuardado'] / meta['valorTotal'];
    if (progresso > 1.0) progresso = 1.0;

    return Container(
      width: 320, 
      margin: const EdgeInsets.only(right: 16, bottom: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // Fundo limpo
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200), // Borda subtil
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '🎯 ${meta['nome']}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: onDeletar,
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          LinearProgressIndicator(
            value: progresso,
            minHeight: 8,
            borderRadius: BorderRadius.circular(10),
            backgroundColor: Colors.teal.shade50,
            color: Colors.teal,
          ),
          
          const SizedBox(height: 8),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'R\$ ${meta['valorGuardado'].toStringAsFixed(0)} / ${meta['valorTotal'].toStringAsFixed(0)}', 
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700)
              ),
              Text(
                '${(progresso * 100).toInt()}%', 
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Botões Minimalistas
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: onRetirar,
                  icon: const Icon(Icons.remove_circle_outline, color: Colors.orange, size: 18),
                  label: const Text('Retirar', style: TextStyle(color: Colors.orange, fontSize: 13)),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onGuardar,
                  icon: const Icon(Icons.add_circle_outline, size: 18),
                  label: const Text('Guardar', style: TextStyle(fontSize: 13)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}