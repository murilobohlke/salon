class AuthException implements Exception{
  static const Map<String,String> errors = {
    'EMAIL_EXISTS' : 'Usuário já cadastrado',
    'OPERATION_NOT_ALLOWED' : 'Operação não permitida',
    'TOO_MANY_ATTEMPTS_TRY_LATER' : 'Muitas tentativas, tente novamente mais tarde',
    'EMAIL_NOT_FOUND' : 'Usuário não encontrado',
    'INVALID_PASSWORD' : 'Senha incorreta',
    'USER_DISABLED' : 'Usuário desativado',
  };

  final String key;

  AuthException(this.key);

  @override
  String toString() {
    return errors[key] ?? 'Ocorreu um erro inesperado';
  }
}