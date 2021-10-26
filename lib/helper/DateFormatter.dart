import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

//Year = y /Month = M /Day = d
//Hour = H /Minute = m / Second = s

class DateFormatter {
  exibirDiaMesAnoHoraMinSeg(String datetime) {
    initializeDateFormatting("pt_BR");
    var formatador = DateFormat("dd-MM-yyyy HH:mm:ss");

    DateTime dataConvertida = DateTime.parse(datetime);
    String resultadoFormatado = formatador.format(dataConvertida);
    return resultadoFormatado;
  }

  exibirDiaMesAnoHoraMin(String datetime) {
    initializeDateFormatting("pt_BR");
    var formatador = DateFormat("dd-MM-yyyy HH:mm");

    DateTime dataConvertida = DateTime.parse(datetime);
    String resultadoFormatado = formatador.format(dataConvertida);
    return resultadoFormatado;
  }

  exibirDiaMesAno(String datetime) {
    initializeDateFormatting("pt_BR");
    var formatador = DateFormat("dd-MM-yyyy");

    DateTime dataConvertida = DateTime.parse(datetime);
    String resultadoFormatado = formatador.format(dataConvertida);
    return resultadoFormatado;
  }

  exibirHoraMinSeg(String datetime) {
    initializeDateFormatting("pt_BR");
    var formatador = DateFormat("HH:mm:ss");

    DateTime dataConvertida = DateTime.parse(datetime);
    String resultadoFormatado = formatador.format(dataConvertida);
    return resultadoFormatado;
  }

  exibirHoraMin(String datetime) {
    initializeDateFormatting("pt_BR");
    var formatador = DateFormat("HH:mm");

    DateTime dataConvertida = DateTime.parse(datetime);
    String resultadoFormatado = formatador.format(dataConvertida);
    return resultadoFormatado;
  }

  gerarHoraId() {
    initializeDateFormatting("pt_BR");
    var formatador = DateFormat("yyyyMMddHHmmss");

    DateTime dataConvertida = DateTime.now();
    int resultadoFormatado = int.parse(formatador.format(dataConvertida));
    return resultadoFormatado;
  }
}
