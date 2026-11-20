import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BancoLocal {
  // Função para GUARDAR tudo no telemóvel/browser
  static Future<void> salvarDados({required double saldo, required List historico, required List metas}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('saldoAtual', saldo);
      await prefs.setString('historico', jsonEncode(historico));
      await prefs.setString('metas', jsonEncode(metas));
    } catch (e) {
      debugPrint('Erro ao salvar dados: $e');
    }
  }

  // Função para CARREGAR tudo com proteção contra dados corrompidos
  static Future carregarDados() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      double saldo = prefs.getDouble('saldoAtual') ?? 850.00;
      
      List historico = [];
      String? histString = prefs.getString('historico');
      if (histString != null) {
        try {
          historico = List.from(
            jsonDecode(histString).map((item) => Map<String, dynamic>.from(item))
          );
        } catch (_) {
          historico = []; // Se corromper, reseta para vazio para não travar
        }
      }

      List metas = [];
      String? metasString = prefs.getString('metas');
      if (metasString != null) {
        try {
          metas = List.from(
            jsonDecode(metasString).map((item) => Map<String, dynamic>.from(item))
          );
        } catch (_) {
          metas = [];
        }
      } 
      
      if (metas.isEmpty) {
        // Valores padrão na primeira vez que abre o app ou se limpou
        metas = [
          {'nome': 'Faculdade', 'valorTotal': 2000.00, 'valorGuardado': 1100.00}
        ];
      }

      return {
        'saldo': saldo,
        'historico': historico,
        'metas': metas,
      };
    } catch (e) {
      debugPrint('Erro ao carregar do banco local: $e');
      // Retorna valores padrão de segurança se o SharedPreferences falhar na web
      return {
        'saldo': 850.00,
        'historico': [],
        'metas': [{'nome': 'Faculdade', 'valorTotal': 2000.00, 'valorGuardado': 1100.00}],
      };
    }
  }
}