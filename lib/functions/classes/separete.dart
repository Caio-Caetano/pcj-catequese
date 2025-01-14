import 'package:intl/intl.dart';
import 'package:webapp/enums.dart';
import 'package:webapp/functions/years/years_and_ages.dart';

Map<String, dynamic> separeteByAge(String bDayString) {
  var inputFormat = DateFormat('dd/MM/yyyy');
  var date1 = inputFormat.parse(bDayString);

  var outputFormat = DateFormat('yyyy-MM-dd');
  var birthDate = DateTime.parse(outputFormat.format(date1));

  final int monthBDay = birthDate.month;

  var age = getAge(birthDate, 2025);

  // --------- [1º Eucaristia] ---------

  // Etapa 1 -> Jan & Jun = 7 || Jul & Dez = 8

  if ((age == 7 && (monthBDay >= 1 && monthBDay <= 6)) || (age == 8 && (monthBDay >= 7 && monthBDay <= 12))) {
    return {'etapa': Turma.eucaristia1, 'idade': age};
  }

  // Etapa 2 -> Jan & Jun = 8 || Jul & Dez = 9

  if ((age == 8 && (monthBDay >= 1 && monthBDay <= 6)) || (age == 9 && (monthBDay >= 7 && monthBDay <= 12))) {
    return {'etapa': Turma.eucaristia2, 'idade': age};
  }

  // Etapa 3 -> Jan & Jun = 9 || Jul & Dez = 10

  if ((age == 9 && (monthBDay >= 1 && monthBDay <= 6)) || (age == 10 && (monthBDay >= 7 && monthBDay <= 12))) {
    return {'etapa': Turma.eucaristia3, 'idade': age};
  }

  // --------- [Crisma] ---------

  // Etapa 1 -> Jan & Jun = 10 || Jul & Dez = 11

  if ((age == 10 && (monthBDay >= 1 && monthBDay <= 6)) || (age == 11 && (monthBDay >= 7 && monthBDay <= 12))) {
    return {'etapa': Turma.crisma1, 'idade': age};
  }

  // Etapa 2 -> Jan & Jun = 11 || Jul & Dez = 12

  if ((age == 11 && (monthBDay >= 1 && monthBDay <= 6)) || (age == 12 && (monthBDay >= 7 && monthBDay <= 12))) {
    return {'etapa': Turma.crisma2, 'idade': age};
  }

  // Etapa 3 -> Jan & Jun = 12 || Jul & Dez = 13

  if ((age == 12 && (monthBDay >= 1 && monthBDay <= 6)) || (age == 13 && (monthBDay >= 7 && monthBDay <= 12))) {
    return {'etapa': Turma.crisma3, 'idade': age};
  }

  // --------- [Jovens] ---------

  if (age >= 13 && age <= 17) {
    return {'etapa': Turma.jovens, 'idade': age};
  }

  // --------- [Adultos] ---------

  if (age >= 18) {
    return {'etapa': Turma.adultos, 'idade': age};
  }

  return {'etapa': Turma.erro, 'idade': age};
}
