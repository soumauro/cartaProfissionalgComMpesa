import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RulesPage extends StatelessWidget {
  const RulesPage({super.key});

  final String phoneNumber = "258845410815"; // sem o +

  Future<void> openWhatsApp() async {
    final Uri url = Uri.parse(
      "https://wa.me/$phoneNumber?text=${Uri.encodeComponent("Olá, gostaria de adquirir um código.")}",
    );

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception("Não foi possível abrir o WhatsApp");
    }
  }

  Future<void> makeCall() async {
    final Uri telUrl = Uri.parse("tel:+$phoneNumber");

    if (!await launchUrl(telUrl)) {
      throw Exception("Não foi possível fazer a chamada");
    }
  }

  Future<void> sendSMS() async {
    final Uri smsUrl = Uri.parse("sms:+$phoneNumber");

    if (!await launchUrl(smsUrl)) {
      throw Exception("Não foi possível enviar SMS");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Regras dos Códigos"),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: const [
            SizedBox(height: 10),
            Icon(Icons.rule, size: 70, color: Colors.blue),
            SizedBox(height: 20),

            Text(
              "📌 Regras Importantes",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),

            RuleItem(
              icon: Icons.lock,
              text: "Cada código só pode ser usado uma única vez.",
            ),

            RuleItem(
              icon: Icons.attach_money,
              text: "Cada código custa 300 MTN.",
            ),

            RuleItem(
              icon: Icons.school,
              text:
                  "O código garante acesso total a todos os exames disponíveis no aplicativo.",
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "📞 Para adquirir um código entre em contacto:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ContactButton(
                  icon: Icons.chat,
                  label: "WhatsApp",
                  color: Colors.green,
                  onTap: () => openWhatsApp(),
                ),
                ContactButton(
                  icon: Icons.call,
                  label: "Chamada",
                  color: Colors.blue,
                  onTap: () => makeCall(),
                ),
                ContactButton(
                  icon: Icons.sms,
                  label: "SMS",
                  color: Colors.orange,
                  onTap: () => sendSMS(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RuleItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const RuleItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(text),
      ),
    );
  }
}

class ContactButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const ContactButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: CircleAvatar(
            radius: 28,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white),
          ),
        ),
        const SizedBox(height: 5),
        Text(label),
      ],
    );
  }
}
