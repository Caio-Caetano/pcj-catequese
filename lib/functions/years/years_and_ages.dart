int getAge(DateTime bDay, int anoReferencia) {
  DateTime currentDate = DateTime.now();
  currentDate = DateTime(anoReferencia, 12, 31);
  int age = anoReferencia - bDay.year;

  int birthMonth = bDay.month;
  int currentMonth = currentDate.month;

  if (birthMonth > currentMonth) {
    age--;
  } else if (birthMonth == currentMonth) {
    int birthDay = bDay.day;
    int currentDay = currentDate.day;
    if (birthDay > currentDay) {
      age--;
    }
  }

  return age;
}
