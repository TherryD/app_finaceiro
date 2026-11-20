import 'package:flutter/material.dart';

import '../servicos/banco_local.dart';
import '../widgets/cartao_meta.dart';
import '../widgets/item_historico.dart';
import '../widgets/menu_inferior.dart';
import '../widgets/dialogo_registro.dart';
import '../widgets/dialogo_meta.dart';
import '../widgets/dialogo_acao.dart';
import 'resumo_screen.dart'; // Importa a nova tela de resumo

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double saldoAtual = 0.0;
  List historico = [];
  List metas = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    _iniciarBancoDeDados();
  }

  Future<void> _iniciarBancoDeDados() async {
    final dados = await BancoLocal.carregarDados();
    if (!mounted) return;
    setState(() {
      saldoAtual = (dados['saldo'] as num).toDouble();
      historico = dados['historico'];
      metas = dados['metas'];
      carregando = false;
    });
  }

  void _atualizarESalvar() {
    BancoLocal.salvarDados(saldo: saldoAtual, historico: historico, metas: metas);
  }

  void _aviso(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  String _agora() => DateTime.now().toIso8601String();

  void _abrirMenuCriacao() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => MenuInferior(
        onNovoRegistro: _abrirJanelaNovoRegistro,
        onNovaMeta: _abrirJanelaNovaMeta,
      ),
    );
  }

  void _abrirResumo() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResumoScreen(historico: historico)),
    );
  }

  void _abrirJanelaNovoRegistro() async {
    final resultado = await showDialog(context: context, builder: (context) => const DialogoRegistro());
    if (resultado != null) {
      setState(() {
        final double valorTransacao = (resultado['valor'] as num).toDouble();
        if (resultado['tipo'] == 'Entrada') {
          saldoAtual += valorTransacao;
        } else {
          saldoAtual -= valorTransacao;
        }
        historico.insert(0, resultado);
      });
      _atualizarESalvar();
    }
  }

  void _abrirJanelaNovaMeta() async {
    final resultado = await showDialog(context: context, builder: (context) => const DialogoMeta());
    if (resultado != null) {
      setState(() {
        metas.add(resultado);
      });
      _atualizarESalvar();
    }
  }

  void _abrirJanelaGuardarMeta(int index) async {
    final valor = await showDialog(
      context: context,
      builder: (context) => DialogoAcao(nomeMeta: metas[index]['nome'], maximo: saldoAtual),
    );
    if (valor != null && valor > 0 && valor <= saldoAtual) {
      setState(() {
        saldoAtual -= valor;
        metas[index]['valorGuardado'] = (metas[index]['valorGuardado'] as num).toDouble() + valor;
        historico.insert(0, {
          'descricao': 'Investimento: ${metas[index]['nome']}',
          'valor': valor,
          'tipo': 'Saída',
          'categoria': 'Investimento',
          'data': _agora(),
        });
      });
      _atualizarESalvar();
    }
  }

  void _abrirJanelaRetirarMeta(int index) async {
    final double valorGuardadoMeta = (metas[index]['valorGuardado'] as num).toDouble();

    final valor = await showDialog(
      context: context,
      builder: (context) => DialogoAcao(
        nomeMeta: metas[index]['nome'],
        isResgate: true,
        maximo: valorGuardadoMeta,
      ),
    );
    if (valor != null && valor > 0 && valor <= valorGuardadoMeta) {
      setState(() {
        saldoAtual += valor;
        metas[index]['valorGuardado'] = valorGuardadoMeta - valor;
        historico.insert(0, {
          'descricao': 'Resgate: ${metas[index]['nome']}',
          'valor': valor,
          'tipo': 'Entrada',
          'categoria': 'Resgate',
          'data': _agora(),
        });
      });
      _atualizarESalvar();
    }
  }

  void _deletarMeta(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Apagar Meta?', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
        content: const Text('O dinheiro guardado voltará para o seu Saldo.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            onPressed: () {
              setState(() {
                final double valorGuardadoMeta = (metas[index]['valorGuardado'] as num).toDouble();
                saldoAtual += valorGuardadoMeta;
                metas.removeAt(index);
              });
              _atualizarESalvar();
              Navigator.pop(context);
            },
            child: const Text('Apagar'),
          ),
        ],
      ),
    );
  }

  void _deletarTransacao(int index) {
    final categoria = historico[index]['categoria'];
    if (categoria == 'Investimento' || categoria == 'Resgate') {
      _aviso('Para desfazer, use "Retirar" ou "Guardar" no cartão da meta.');
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Apagar Registo?', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
        content: const Text('Deseja apagar este histórico? O valor será revertido no seu Saldo Disponível.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            onPressed: () {
              setState(() {
                final transacao = historico[index];
                final double valorTransacao = (transacao['valor'] as num).toDouble();
                if (transacao['tipo'] == 'Entrada') {
                  saldoAtual -= valorTransacao;
                } else {
                  saldoAtual += valorTransacao;
                }
                historico.removeAt(index);
              });
              _atualizarESalvar();
              Navigator.pop(context);
            },
            child: const Text('Apagar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.teal)));
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Minhas Finanças', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.teal,
        elevation: 0,
        actions: [
          // Botão para abrir o Resumo do Mês em outra tela
          IconButton(
            icon: const Icon(Icons.bar_chart, color: Colors.white, size: 28),
            tooltip: 'Resumo do Mês',
            onPressed: _abrirResumo,
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.white, size: 28),
            tooltip: 'Adicionar',
            onPressed: _abrirMenuCriacao,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.teal.shade600, Colors.teal.shade300], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.teal.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 6))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Saldo Disponível', style: TextStyle(fontSize: 14, color: Colors.white70)),
                        const SizedBox(height: 8),
                        Text('R\$ ${saldoAtual.toStringAsFixed(2)}', style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text('Minhas Metas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 190,
                    child: metas.isEmpty
                        ? const Center(child: Text('Nenhuma meta criada.', style: TextStyle(color: Colors.grey)))
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            clipBehavior: Clip.none,
                            itemCount: metas.length,
                            itemBuilder: (context, index) => CartaoMeta(
                              meta: metas[index],
                              onGuardar: () => _abrirJanelaGuardarMeta(index),
                              onRetirar: () => _abrirJanelaRetirarMeta(index),
                              onDeletar: () => _deletarMeta(index),
                            ),
                          ),
                  ),
                  const SizedBox(height: 24),
                  // O resumo foi removido daqui e colocado na nova tela!
                  const Text('Histórico de Gastos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          if (historico.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: Text('Nenhuma transação.', style: TextStyle(color: Colors.grey))),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              sliver: SliverList.builder(
                itemCount: historico.length,
                itemBuilder: (context, index) => ItemHistorico(
                  transacao: historico[index],
                  onDeletar: () => _deletarTransacao(index),
                ),
              ),
            ),
        ],
      ),
    );
  }
}