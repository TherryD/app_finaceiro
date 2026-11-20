import 'package:flutter/material.dart';
import '../widgets/resumo_categorias.dart';

class ResumoScreen extends StatelessWidget {
  final List historico;

  const ResumoScreen({super.key, required this.historico});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Resumo Financeiro', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Desempenho do Mês',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            ResumoCategorias(historico: historico),
          ],
        ),
      ),
    );
  }
}