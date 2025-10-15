import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/infrastructure/presentation/cadastro-usuario/estado_cadastro.dart';
import 'package:myapp/infrastructure/presentation/login/estado_login.dart';
import 'package:myapp/infrastructure/presentation/screens/pagina.dart';
import 'package:myapp/infrastructure/presentation/login/pagina_login.dart';
import 'package:myapp/infrastructure/presentation/providers/amizade_provider.dart';
import 'package:myapp/infrastructure/presentation/providers/estatistica_provider.dart';
import 'package:myapp/infrastructure/presentation/providers/mapa_provider.dart';
import 'package:myapp/infrastructure/presentation/providers/produto_provider.dart'; 
import 'package:myapp/infrastructure/presentation/providers/user_provider.dart';
import 'package:myapp/infrastructure/presentation/usuario/estado_usuario.dart';
import 'package:myapp/modules/usuario/usuario_repository.dart';
import 'package:myapp/modules/usuario/usuario_usecase.dart';
import 'package:provider/provider.dart';
 
Future<void> main() async { 
  WidgetsFlutterBinding.ensureInitialized(); // inicializa o binding
  await Firebase.initializeApp(); // inicializa o firebase

  final usuarioRepository = UsuarioRepository();
  final usuarioUseCase = UsuarioUseCase(usuarioRepository);

  runApp(
    MultiProvider(
      providers: [
        // providers da aplicação
        ChangeNotifierProvider(create: (_) => LoginProvider(usuarioUseCase: usuarioUseCase)),
        ChangeNotifierProvider(create: (_) => CadastroProvider(usuarioUseCase: usuarioUseCase)),
        ChangeNotifierProvider(create: (_) => UsuarioProvider()),
        ChangeNotifierProvider(create: (_) => MapaProvider()),
        ChangeNotifierProvider(create: (_) => ProdutoProvider()),
        ChangeNotifierProvider(create:  (_) => AmizadeProvider()), 
        ChangeNotifierProvider(create:  (_) => EstatisticaProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
     
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // verifica se o usuário já está logado
      home: userProvider.usuario != null ? const Pagina() : const PaginaLogin(),
    );
  }
}