import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sobre Nós"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: const [
            SizedBox(height: 10),

            Icon(Icons.school, size: 80, color: Colors.blue),

            SizedBox(height: 20),

            Text(
              "Quem Somos",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "Somos uma plataforma dedicada a ajudar candidatos a prepararem-se para exames de forma prática, rápida e eficiente.",
              textAlign: TextAlign.justify,
            ),

            SizedBox(height: 20),

            Text(
              "Nossa Missão",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "Disponibilizar exames actualizados e organizados para garantir que os utilizadores tenham a melhor preparação possível.",
              textAlign: TextAlign.justify,
            ),

            SizedBox(height: 20),

            Text(
              "Contacto",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "Para adquirir um código ou obter suporte, entre em contacto connosco através de WhatsApp, chamada ou SMS. 845410815",
              textAlign: TextAlign.justify,
            ),

            SizedBox(height: 30),

            Text(
              "© 2026 Todos os direitos reservados.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}