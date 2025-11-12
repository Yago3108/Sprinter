import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/infrastructure/presentation/widgets/app.dart';
import 'package:myapp/infrastructure/presentation/providers/amizade_provider.dart';
import 'package:myapp/infrastructure/presentation/providers/estatistica_provider.dart';
import 'package:myapp/infrastructure/presentation/providers/mapa_provider.dart';
import 'package:myapp/infrastructure/presentation/providers/produto_provider.dart';
import 'package:myapp/infrastructure/presentation/providers/user_provider.dart';
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
        ChangeNotifierProvider(create:  (_) => EstatisticaProvider()),
      ],
      child: const MyApp(),
    ),
  );
}