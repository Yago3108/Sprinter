import 'package:flutter/material.dart';
import 'package:myapp/infrastructure/presentation/providers/user_provider.dart';
import 'package:myapp/infrastructure/presentation/screens/pagina.dart';
import 'package:myapp/infrastructure/presentation/screens/pagina_login.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    if(!userProvider.isInitialized) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(30),
                  width: 250,
                  height: 250,
                  child: Image.asset("assets/images/Sprinter_simples.png"),
                ),
              ],
            ),
          ),
        ),
      );
    }
     
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: userProvider.user != null ? const Pagina() : const PaginaLogin(),
    );
  }
}