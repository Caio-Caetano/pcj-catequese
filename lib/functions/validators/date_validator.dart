String? checkDate(String? date) {
  if (date == null || date.isEmpty) return '⚠️ Por favor preencha esse campo.';

  if (!isValidDate(date)) return '❌ Erro! Não é uma data válida.';

  return null;
}

bool isValidDate(String input) {
  final parts = input.split('/');

  final int d = int.parse(parts[0]);
  final int m = int.parse(parts[1]);
  final int y = int.parse(parts[2]);

  if (d > 31 || d <= 0) return false;
  if (m > 12 || m <= 0) return false;
  if (y > DateTime.now().year || y <= 1900) return false;

  return true;
}
