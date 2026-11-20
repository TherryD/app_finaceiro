import 'package:flutter/material.dart';

class ResumoCategorias extends StatelessWidget {
  final List historico;

  const ResumoCategorias({super.key, required this.historico});

  static const _transferencias = ['Investimento', 'Resgate'];

  bool _ehDoMesAtual(Map t) {
    final data = DateTime.tryParse(t['data']?.toString() ?? '');
    if (data == null) return true;
    final agora = DateTime.now();
    return data.year == agora.year && data.month == agora.month;
  }

  // Cores distintas e bem definidas para cada categoria
  Color _corDaCategoria(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'delivery':
        return Colors.orange;
      case 'padaria':
        return Colors.amber.shade700;
      case 'transporte':
        return Colors.blue;
      case 'contas':
        return Colors.redAccent;
      case 'compras':
        return Colors.purple;
      default:
        return Colors.teal.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    double entradas = 0;
    double saidas = 0;
    final Map<String, double> porCategoria = {};

    for (final item in historico) {
      final Map t = item;
      if (!_ehDoMesAtual(t)) continue;

      final categoria = t['categoria']?.toString() ?? 'Outros';
      if (_transferencias.contains(categoria)) continue;

      final valor = (t['valor'] as num).toDouble();
      if (t['tipo'] == 'Entrada') {
        entradas += valor;
      } else {
        saidas += valor;
        porCategoria[categoria] = (porCategoria[categoria] ?? 0) + valor;
      }
    }

    final categoriasOrdenadas = porCategoria.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final balanco = entradas - saidas;

    return Column(
      children: [
        // Cartão principal com Entradas, Saídas e Balanço
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 4))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Balanço do Mês', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 16),
              Row(
                children: [
                  _bloco('Entradas', entradas, Colors.green),
                  _bloco('Saídas', saidas, Colors.red),
                  _bloco('Balanço', balanco, balanco >= 0 ? Colors.teal : Colors.red),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Cartão do Gráfico Visual de Gastos por Categoria
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 4))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Gastos por Categoria', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 8),
              const Text('Distribuição visual das suas saídas no mês atual', style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 20),
              if (categoriasOrdenadas.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: Text('Nenhum gasto registrado neste mês.', style: TextStyle(color: Colors.grey))),
                )
              else ...[
                // Barra de Gráfico Proporcional Multicor Combinada
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 16,
                    child: Row(
                      children: categoriasOrdenadas.map((e) {
                        final proporcao = saidas > 0 ? e.value / saidas : 0.0;
                        return Expanded(
                          flex: (proporcao * 100).toInt().clamp(1, 100),
                          child: Container(color: _corDaCategoria(e.key)),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Linhas detalhadas de cada categoria com indicador de cor
                ...categoriasOrdenadas.map((e) => _linhaCategoria(e.key, e.value, saidas)),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _bloco(String titulo, double valor, Color cor) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          const SizedBox(height: 4),
          Text(
            'R\$ ${valor.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: cor),
          ),
        ],
      ),
    );
  }

  Widget _linhaCategoria(String nome, double valor, double totalSaidas) {
    final proporcao = totalSaidas > 0 ? valor / totalSaidas : 0.0;
    final cor = _corDaCategoria(nome);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(width: 12, height: 12, decoration: BoxDecoration(color: cor, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Text(nome, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87)),
                ],
              ),
              Text('R\$ ${valor.toStringAsFixed(2)} (${(proporcao * 100).toStringAsFixed(1)}%)', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: proporcao,
              minHeight: 8,
              backgroundColor: Colors.grey.shade100,
              color: cor,
            ),
          ),
        ],
      ),
    );
  }
}