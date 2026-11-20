import 'package:flutter/material.dart';
import 'telas/dashboard.dart'; // Importa o arquivo que acabamos de criar

void main() async {
  // Garante que os bindings do Flutter estão prontos antes de chamar plugins nativos
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const AppFinanceiro());
}

class AppFinanceiro extends StatelessWidget {
  const AppFinanceiro({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finanças e Metas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const DashboardScreen(), // Chama a tela do arquivo dashboard.dart
    );
  }
}