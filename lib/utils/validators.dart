class Validators {
  // Validação de CPF
  static bool isValidCPF(String cpf) {
    cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    if (cpf.length != 11 || RegExp(r'^(\d)\1*$').hasMatch(cpf)) return false;

    List<int> digits = cpf.split('').map(int.parse).toList();

    int sum = 0;
    for (int i = 0; i < 9; i++) sum += digits[i] * (10 - i);
    int firstCheck = (sum * 10) % 11;
    if (firstCheck == 10) firstCheck = 0;
    if (firstCheck != digits[9]) return false;

    sum = 0;
    for (int i = 0; i < 10; i++) sum += digits[i] * (11 - i);
    int secondCheck = (sum * 10) % 11;
    if (secondCheck == 10) secondCheck = 0;
    if (secondCheck != digits[10]) return false;

    return true;
  }

  // Validação de CNPJ
  static bool isValidCNPJ(String cnpj) {
    cnpj = cnpj.replaceAll(RegExp(r'[^0-9]'), '');
    if (cnpj.length != 14 || RegExp(r'^(\d)\1*$').hasMatch(cnpj)) return false;

    List<int> digits = cnpj.split('').map(int.parse).toList();
    List<int> multipliers1 = [5,4,3,2,9,8,7,6,5,4,3,2];
    List<int> multipliers2 = [6,5,4,3,2,9,8,7,6,5,4,3,2];

    int sum = 0;
    for (int i = 0; i < 12; i++) sum += digits[i] * multipliers1[i];
    int firstCheck = sum % 11;
    firstCheck = firstCheck < 2 ? 0 : 11 - firstCheck;
    if (firstCheck != digits[12]) return false;

    sum = 0;
    for (int i = 0; i < 13; i++) sum += digits[i] * multipliers2[i];
    int secondCheck = sum % 11;
    secondCheck = secondCheck < 2 ? 0 : 11 - secondCheck;
    if (secondCheck != digits[13]) return false;

    return true;
  }

  // Validação simples de e-mail
  static bool isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  // Validação simples de telefone (mínimo 10 dígitos)
  static bool isValidPhone(String phone) {
    phone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    return phone.length >= 10;
  }
}
