 import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/pages/pagina.dart';
import 'package:myapp/pages/pagina_cria_produto.dart';
import 'package:myapp/pages/pagina_login.dart';
import 'package:myapp/pages/pagina_mapa.dart';
import 'package:myapp/util/amizade_provider.dart';
import 'package:myapp/util/mapa_provider.dart';
import 'package:myapp/util/produto_provider.dart';
import 'package:myapp/util/user_provider.dart';
import 'package:myapp/util/usuario.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => MapaProvider()),
        ChangeNotifierProvider(create: (_) => ProdutoProvider()),
        ChangeNotifierProvider(create:  (_) => AmizadeProvider()),
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
    home: userProvider.user != null
        ? const Pagina()
        : const PaginaLogin(),
  );
}
}