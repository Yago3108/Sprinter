  import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/infrastructure/presentation/screens/pagina.dart';
import 'package:myapp/infrastructure/presentation/screens/pagina_login.dart';
import 'package:myapp/infrastructure/presentation/providers/amizade_provider.dart';
import 'package:myapp/infrastructure/presentation/providers/estatistica_provider.dart';
import 'package:myapp/infrastructure/presentation/providers/mapa_provider.dart';
import 'package:myapp/infrastructure/presentation/providers/produto_provider.dart'; 
import 'package:myapp/infrastructure/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';
 
Future<void> main() async { 
  WidgetsFlutterBinding.ensureInitialized(); // inicializa o binding
  await Firebase.initializeApp(); // inicializa o firebase
  runApp(
    MultiProvider(
      providers: [
        // providers da aplicação
        ChangeNotifierProvider(create: (_) => UserProvider()),
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
      home: userProvider.user != null ? const Pagina() : const PaginaLogin(),
    );
  }
}