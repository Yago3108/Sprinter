import 'dart:typed_data';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/entities/amigo.dart';
import 'package:myapp/entities/amizade.dart';
import 'package:myapp/infrastructure/presentation/providers/amizade_provider.dart';
import 'package:myapp/infrastructure/presentation/providers/user_provider.dart';
import 'package:myapp/entities/usuario.dart';
import 'package:provider/provider.dart';

class PaginaPerfilAmizade extends StatefulWidget {
  final String uidAmigo;

  PaginaPerfilAmizade({super.key, required this.uidAmigo});

  @override
  PaginaPerfilAmizadeState createState() => PaginaPerfilAmizadeState();
}

class PaginaPerfilAmizadeState extends State<PaginaPerfilAmizade> {
   Usuario? amigo;
  Uint8List? fotoBytes;
  String? dataInicio;
  @override
  void initState() {
    super.initState();
        final userProvider = context.read<UserProvider>();
        userProvider.getUsuarioByUid(widget.uidAmigo);
        
  } 

 
  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
     final AmizadeProvider amizadeProvider = context.watch<AmizadeProvider>();
     amigo = userProvider.usuarioPesquisado;
    for (var i = 0; i <amizadeProvider.amigos.length ; i++) {
      Amigo amizade;
      amizade=amizadeProvider.amigos[i];
      final formatter = DateFormat('dd/MM/yyyy');

     if( amizade.uid==amigo?.uid){
      setState(() {
     dataInicio = formatter.format(amizade.dataInicio);
      });
     }
    }
     try {
            fotoBytes = userProvider.usuarioPesquisado?.fotoPerfil!;
          } catch (_) {
            fotoBytes = null;
          }
   
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actionsPadding: EdgeInsets.only(right: 10),
          backgroundColor: Color.fromARGB(255, 5, 106, 12),
          iconTheme: IconThemeData(color: Colors.white),

          centerTitle: true,
         
        ),
        body: Container(
               decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/fundo.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: ListView(
              children: [
                Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 30)),
      
                   CircleAvatar(
                                  backgroundImage: fotoBytes!= null && amigo!.fotoPerfil.isNotEmpty
                                      ? MemoryImage(fotoBytes!, scale: 75)
                                      : AssetImage(
                                          "assets/images/perfil_basico.jpg",
                                        ),
                                  radius: 75,
                                  child: Container(
                                    height: 375,
                                    width: 375,
                                    decoration: BoxDecoration(
                                      border: BoxBorder.all(
                                        color: Color.fromARGB(255, 29, 64, 26),
                                      ),
          
                                      borderRadius: BorderRadius.circular(75),
                                    ),
                                  ),
                                ),
                           Padding(padding: EdgeInsets.only(top: 10)),
                    Text(
                      amigo?.nome ?? "",
                      style: TextStyle(
                        fontFamily: 'League Spartan',
                        fontSize: 30,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 30)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  amigo?.carboCoins.toString() ?? "",
                                  style: TextStyle(
                                    fontFamily: 'League Spartan',
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsGeometry.only(top: 5),
                                ),
                                Text(
                                  "CarboCoins",
                                  style: TextStyle(
                                    fontFamily: 'League Spartan',
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        amigo?.distancia.toStringAsFixed(1) ?? "",
                                        style: TextStyle(
                                          fontFamily: 'League Spartan',
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsGeometry.only(top: 5),
                                ),
                                Text(
                                  "Distância",
                                  style: TextStyle(
                                    fontFamily: 'League Spartan',
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        amigo?.carbono.toStringAsFixed(0) ?? "",
                                        style: TextStyle(
                                          fontFamily: 'League Spartan',
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsGeometry.only(top: 5),
                                ),
                                Text(
                                  "Carbono",
                                  style: TextStyle(
                                    fontFamily: 'League Spartan',
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 30)),
                      Container(
                                      padding: EdgeInsets.all(20),
                                           decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white,
                        ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(padding: EdgeInsets.only(top: 10)),
                                          
                                           Text("Email",
                                          style: TextStyle(
                                            fontFamily: 'League Spartan', fontSize: 18
                                          ),),
                                          Container(
                                            width: 300,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.black, width: 1),
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(30),
                                              
                                            ),
                                            child: Center(
                                              child: Text(
                                                amigo?.email ?? "",
                                                style: TextStyle(fontFamily: 'Lao Muang Don', fontSize: 15),
                                              ),
                                            ),
                                          ),
                                       
                                       amizadeProvider.verificarAmigo(widget.uidAmigo)?   
                                         Column(
                                           children: [
                                               Padding(padding: EdgeInsets.only(top: 30)),
                                             Text("Início da amizade",
                                              style: TextStyle(
                                                fontFamily: 'League Spartan', fontSize: 18
                                              ),),
                                              Container(
                                                width: 300,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.black, width: 1),
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(30),
                                                ),
                                                child: Center( 
                                                  child: Text(
                                                    dataInicio ?? "",
                                                    style: TextStyle(fontFamily: 'League Spartan', fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                           ],
                                         ):SizedBox(),
                                                     Padding(padding: EdgeInsets.only(top: 30)),
                                          
                                         Text("Data de nascimento",
                                          style: TextStyle(
                                            fontFamily: 'League Spartan', fontSize: 18
                                          ),),
                                          Container(
                                            width: 300,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.black, width: 1),
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            child: Center(
                                              child: Text(
                                                amigo?.nascimento ?? "",
                                                style: TextStyle(fontFamily: 'League Spartan', fontSize: 15),
                                              ),
                                            ),
                                          ),

                                         
                                          Padding(padding: EdgeInsets.only(top: 10)),
                                        ],
                                      ),
                                    ),
                
                    Padding(padding: EdgeInsets.only(top: 30)),
                        
                    amizadeProvider.verificarAmigo(widget.uidAmigo)==false?
                    IconButton(
                      onPressed: () {
                        amizadeProvider.enviarPedidoAmizade(
                          userProvider.user!.nome,
                          userProvider.user!.uid,
                          widget.uidAmigo,
                        );
                        Navigator.pop(context);
                      },
                      icon: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 29, 64, 26),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ):Text("Seu Amigo",
                    style:TextStyle(
                    fontFamily: "League Spartan",
                    fontSize: 30,
                    color: Color.fromARGB(255, 238, 238, 238)
                    ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
  }
}
