import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:myapp/infrastructure/presentation/app/components/textfield_componente.dart';
import 'package:myapp/infrastructure/presentation/screens/pagina.dart';
import 'package:myapp/infrastructure/presentation/screens/pagina_perfil.dart';
import 'package:myapp/infrastructure/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaginaConfiguracao extends StatefulWidget {
  const PaginaConfiguracao({super.key});

  @override
  State<PaginaConfiguracao> createState() => _PaginaConfiguracaoState();
}

bool emailValido = true;

class _PaginaConfiguracaoState extends State<PaginaConfiguracao> {
  Future<void> validarEmail() async {
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email != null) {
      setState(() {
        emailValido = true;
      });
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'E-mail de recuperação de senha enviado com sucesso!',
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao enviar e-mail de recuperação de senha: $e'),
          ),
        );
      }
    } else {
      setState(() {
        emailValido = false;
      });
    }
  }
  TextEditingController controllerChat=TextEditingController();
  int senhaTestada=0;
  int cont=0;
  bool credWid=false;
  void testeSenha(BuildContext context){
       TextEditingController controllersSenha=TextEditingController();
      showDialog(context: context, builder:(context) => Dialog(
        child: SizedBox(
          width: 350,
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                   Padding(padding: EdgeInsets.only(top: 10)),
              ListTile(
                            leading: Icon(Icons.lock),
                            title: Text('Digite sua senha')),
              Padding(padding: EdgeInsets.only(top: 30)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFieldComponente(
                              controller:controllersSenha ,
                              hint: "Digite sua senha",
                              isPassword: true,
                              label: "Senha",
                            ),
                      ),
                   Padding(padding: EdgeInsets.only(top: 20)),
                          TextButton(
                            onPressed: () async {
                                  final userProvider = context.read<UserProvider>();
                                  bool funciona=await userProvider.redefinirCredenciais(controllersSenha.text);
                                  if(funciona==true){
                                    setState(() {
                                       credWid=true;
                                    });
                                   
                                  }
                              Navigator.pop(context);
                            },
                            child: Text('OK',
                            style: TextStyle(
                            fontFamily: "League Spartan",
                            color: Color.fromARGB(255, 5, 106,12 ),  
                            ),),
                          ),
                
            ],
          ),
        ),
                        
                    ),);
  }
  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final fotoBase64 = userProvider.user?.fotoPerfil;
    Uint8List? bytes;
    if (fotoBase64 != null && fotoBase64.isNotEmpty) {
      bytes = base64Decode(fotoBase64);
    }
    return Scaffold(
        appBar: AppBar(
          actionsPadding: EdgeInsets.only(right: 10),
          backgroundColor: Color.fromARGB(255, 5, 106, 12),
          iconTheme: IconThemeData(color: Colors.white),

          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>Pagina(key: null,)));
            },
            icon: Icon(Icons.arrow_back),
          ),
          actions: [
            IconButton(
              icon: CircleAvatar(
                backgroundImage: bytes != null
                    ? MemoryImage(bytes)
                    : AssetImage("assets/images/perfil_basico.jpg"),
                radius: 25,
              ),
              onPressed: () => {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => PaginaPerfil()),
                ),
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
               Padding(padding: EdgeInsets.only(top: 10)),
                Image.asset("assets/images/Logo_Sprinter.png", height: 100),
                Padding(padding: EdgeInsets.only(top: 10)),
                Padding(
                  padding: const EdgeInsets.only(right: 210),
                  child: Text("Olá, ${userProvider.user!.nome}!",
                  style: TextStyle(
                        fontSize: 36,
                        fontFamily: "League Spartan"
                      ),
                  ),
                ),
                 Padding(padding: EdgeInsets.only(top: 10)),
                    Padding(
                  padding: const EdgeInsets.only(right: 230),
                  child: Text("Configurações:",
                  style: TextStyle(
                        fontSize: 20,
                        fontFamily: "League Spartan"
                      ),
                  ),
                ),
                  Padding(padding: EdgeInsets.only(top: 15)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: () {
                          if(senhaTestada==0 && credWid==false){
                          testeSenha(context);
                          senhaTestada++;
                        }
                        if(senhaTestada==1){
                          senhaTestada=0;
                        }
                      },
                      child: ExpansionTile(
                        collapsedBackgroundColor: Colors.white,
                        collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide.none, 
                      ),
                      shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide.none, 
                      ),
                      iconColor: Color.fromARGB(255, 5, 106,12 ),  
                      textColor:Color.fromARGB(255, 5, 106,12 ) ,
                      backgroundColor: Colors.white,
                        title:ListTile(
                          leading: Icon(Icons.lock),
                          title: Text("Alterar credenciais",style: TextStyle(
                          fontSize: 20,
                          fontFamily: "League Spartan"
                        ),),
                        ),
                        enabled: credWid,
                          children: [
                        Container(height: 300,)
                      ],
                        ),
                    ),
                      
                  ),
                   Padding(padding: EdgeInsets.only(top: 20)),
               Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ExpansionTile(
                      collapsedBackgroundColor: Colors.white,
                      collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide.none, 
                    ),
                    shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide.none, 
                    ),
                    iconColor: Color.fromARGB(255, 5, 106,12 ),  
                    textColor:Color.fromARGB(255, 5, 106,12 ) ,
                    backgroundColor: Colors.white,
                      title:ListTile(
                        leading: Icon(Icons.chat_bubble),
                        title: Text("Suporte",style: TextStyle(
                        fontSize: 20,
                        fontFamily: "League Spartan"
                      ),),
                      ),
                      onExpansionChanged: (value) {
                        
                        if(cont==0){
                           showDialog(context: context, builder:(context) => AlertDialog(
                        title:ListTile(
                          leading: Icon(Icons.info_outline_rounded),
                          title: Text('Informação')),
                        content: Text('Suas dúvidas serão enviadas para o Email de suporte e serão respondidas APENAS no seu e-mail'),
                        actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK',
                          style: TextStyle(
                          fontFamily: "League Spartan",
                          color: Color.fromARGB(255, 5, 106,12 ),  
                          ),),
                        ),
                      ],
                    ),);
                        }
                                 cont++;
                       
                      },
                        children: [
                      SizedBox(
                        height: 250,
                        child: Column(
                          children: [
                        
                          ],
                        ),
                      ),
                      ListTile(
                        title: TextFieldComponente(key: null,
                        controller: controllerChat,
                        hint: "Digite a sua dúvida",
                        isPassword: false,
                        label: "",),
                        trailing: IconButton(onPressed: (){}, icon: Icon(Icons.send)),
                        )
                    ],
                      ),
                      
                  ),
                Padding(padding: EdgeInsets.only(top: 20)),
                 Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ExpansionTile(
                      collapsedBackgroundColor: Colors.white,
                      collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide.none, 
                    ),
                    shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide.none, 
                    ),
                    iconColor: Color.fromARGB(255, 5, 106,12 ),  
                    textColor:Color.fromARGB(255, 5, 106,12 ) ,
                    backgroundColor: Colors.white,
                      title:ListTile(
                        leading: Icon(Icons.info_outline_rounded),
                        title: Text("Sobre",style: TextStyle(
                        fontSize: 20,
                        fontFamily: "League Spartan"
                      ),),
                      ),
          
                        children: [
                     Padding(padding: EdgeInsets.only(top: 5)),
                     Image.asset("assets/images/Sprinter_simples.png", height: 70),
                      Padding(padding: EdgeInsets.only(top: 15)),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: ListTile(title: Text("Versão: 1.0.0",style: TextStyle(
                        fontSize: 18,
                        fontFamily: "League Spartan"
                      ),),),
                      ),
                         Padding(padding: EdgeInsets.only(top: 5)),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: ListTile(title: Text("Contato:sprintersuporte@gmail.com",style: TextStyle(
                        fontSize: 18,
                        fontFamily: "League Spartan"
                      ),),),
                      ),
                         Padding(padding: EdgeInsets.only(top: 15)),
                    ],
                      ),
                      
                  ),
                Padding(padding: EdgeInsets.only(top: 20)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    alignment: Alignment.center,
                    height: 70,
                    decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)
                    ),
                    child: ListTile(
                      leading: Icon(Icons.delete_outline_rounded,
                      color: Colors.red,
                      ),
                      title: Text("Excluir conta",style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontFamily: "League Spartan"
                    ),),
                    ),
                  ),
                ),
                   Padding(padding: EdgeInsets.only(top: 20)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    alignment: Alignment.center,
                    height: 70,
                    decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)
                    ),
                    child: ListTile(
                      leading: Icon(Icons.logout_rounded,
                      color: Colors.red,
                      ),
                      title: Text("Sair",style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontFamily: "League Spartan"
                    ),),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
}
}