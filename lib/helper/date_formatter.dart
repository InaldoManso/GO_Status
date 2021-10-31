import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

//Year = y /Month = M /Day = d
//Hour = H /Minute = m / Second = s

class DateFormatter {
  showDayMonthYearHoursMinSec(String datetime) {
    initializeDateFormatting("pt_BR");
    var formatter = DateFormat("dd-MM-yyyy HH:mm:ss");

    DateTime convertedDate = DateTime.parse(datetime);
    String formattedResult = formatter.format(convertedDate);
    return formattedResult;
  }

  showDayMonthYearHoursMin(String datetime) {
    initializeDateFormatting("pt_BR");
    var formatter = DateFormat("dd-MM-yyyy HH:mm");

    DateTime convertedDate = DateTime.parse(datetime);
    String formattedResult = formatter.format(convertedDate);
    return formattedResult;
  }

  showDayMonthYear(String datetime) {
    initializeDateFormatting("pt_BR");
    var formatter = DateFormat("dd-MM-yyyy");

    DateTime convertedDate = DateTime.parse(datetime);
    String formattedResult = formatter.format(convertedDate);
    return formattedResult;
  }

  showHoursMinSec(String datetime) {
    initializeDateFormatting("pt_BR");
    var formatter = DateFormat("HH:mm:ss");

    DateTime convertedDate = DateTime.parse(datetime);
    String formattedResult = formatter.format(convertedDate);
    return formattedResult;
  }

  showHoursMin(String datetime) {
    initializeDateFormatting("pt_BR");
    var formatter = DateFormat("HH:mm");

    DateTime convertedDate = DateTime.parse(datetime);
    String formattedResult = formatter.format(convertedDate);
    return formattedResult;
  }

  generateDateTimeIdentification() {
    initializeDateFormatting("pt_BR");
    var formatador = DateFormat("yyyyMMddHHmmss");

    DateTime dataConvertida = DateTime.now();
    int resultadoFormatado = int.parse(formatador.format(dataConvertida));
    return resultadoFormatado;
  }
}
