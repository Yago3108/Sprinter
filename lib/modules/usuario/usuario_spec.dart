abstract class IUsuarioUseCases {
  String? validarNome(String nome);

  String? validarCPF(String cpf);

  String? validarData(String data);

  String? validarEmail(String email);

  String? validarSenha(String senha);

  String? validarConfirmarSenha(String senha, String confirmarSenha);
}