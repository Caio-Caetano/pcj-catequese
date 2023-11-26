int getAge(DateTime bDay) {
  DateTime currentDate = DateTime.now();
  currentDate = DateTime(currentDate.year, 12, 31);
  int age = currentDate.year - bDay.year;

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
