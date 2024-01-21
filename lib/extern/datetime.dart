extension UsefulChronos on DateTime {
  String monthName() => month == DateTime.january
      ? "January"
      : month == DateTime.february
          ? "February"
          : month == DateTime.march
              ? "March"
              : month == DateTime.april
                  ? "April"
                  : month == DateTime.may
                      ? "May"
                      : month == DateTime.june
                          ? "June"
                          : month == DateTime.july
                              ? "July"
                              : month == DateTime.august
                                  ? "August"
                                  : month == DateTime.september
                                      ? "September"
                                      : month == DateTime.october
                                          ? "October"
                                          : month == DateTime.november
                                              ? "November"
                                              : month ==
                                                      DateTime
                                                          .december
                                                  ? "December"
                                                  : "Unknown";
}
