double parseValor(String texto) {
  if (texto.isEmpty) return 0.0;
  
  // Remove o "R$", espaços, e troca pontos de milhar e vírgulas para o padrão aceito pelo double.parse
  String limpo = texto
      .replaceAll('R\$', '')
      .replaceAll('.', '')
      .replaceAll(',', '.')
      .trim();
      
  return double.tryParse(limpo) ?? 0.0;
}