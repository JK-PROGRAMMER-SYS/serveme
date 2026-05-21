import 'package:flutter/services.dart';

class Masks {
  // Apenas números
  static TextInputFormatter digitsOnly = FilteringTextInputFormatter.digitsOnly;

  // Formatar CPF: 000.000.000-00
  static String formatCPF(String value) {
    value = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (value.length > 11) value = value.substring(0, 11);

    if (value.length >= 9) {
      return "${value.substring(0,3)}.${value.substring(3,6)}.${value.substring(6,9)}-${value.substring(9)}";
    } else if (value.length >= 6) {
      return "${value.substring(0,3)}.${value.substring(3,6)}.${value.substring(6)}";
    } else if (value.length >= 3) {
      return "${value.substring(0,3)}.${value.substring(3)}";
    }
    return value;
  }

  // Formatar CNPJ: 00.000.000/0000-00
  static String formatCNPJ(String value) {
    value = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (value.length > 14) value = value.substring(0, 14);

    if (value.length >= 12) {
      return "${value.substring(0,2)}.${value.substring(2,5)}.${value.substring(5,8)}/${value.substring(8,12)}-${value.substring(12)}";
    } else if (value.length >= 8) {
      return "${value.substring(0,2)}.${value.substring(2,5)}.${value.substring(5,8)}/${value.substring(8)}";
    } else if (value.length >= 5) {
      return "${value.substring(0,2)}.${value.substring(2,5)}.${value.substring(5)}";
    } else if (value.length >= 2) {
      return "${value.substring(0,2)}.${value.substring(2)}";
    }
    return value;
  }
}
