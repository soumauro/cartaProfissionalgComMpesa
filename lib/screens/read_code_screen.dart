import 'package:cartaz/screens/rules_screan.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class UseCodePage extends StatefulWidget {
  const UseCodePage({super.key});

  @override
  State<UseCodePage> createState() => _UseCodePageState();
}

class _UseCodePageState extends State<UseCodePage> {
  final controller = TextEditingController();
  bool loading = false;
  String result = "";
  final String phoneNumber = "258845410815";

  // ================= CONTATO =================

  Future<void> openWhatsApp() async {
    final Uri url = Uri.parse(
      "https://wa.me/$phoneNumber?text=${Uri.encodeComponent("Olá, gostaria de adquirir um código. v2")}",
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

  // ================= PREMIUM =================

  Future<void> addOneMonthToUser() async {
    final prefs = await SharedPreferences.getInstance();

    DateTime now = DateTime.now();
    String? savedDate = prefs.getString("premiumExpiresAt");

    DateTime newDate;

    if (savedDate != null) {
      DateTime currentExpire = DateTime.parse(savedDate);

      if (currentExpire.isAfter(now)) {
        // ainda ativo → soma mais 30 dias
        newDate = currentExpire.add(const Duration(days: 30));
      } else {
        // expirado → começa de hoje
        newDate = now.add(const Duration(days: 30));
      }
    } else {
      // nunca teve
      newDate = now.add(const Duration(days: 30));
    }

    await prefs.setBool("isPremiun", true);
    await prefs.setString("premiumExpiresAt", newDate.toIso8601String());
  }

  // ================= VALIDAR PREMIUM =================

  Future<bool> isPremiumUser() async {
    final prefs = await SharedPreferences.getInstance();

    String? date = prefs.getString("premiumExpiresAt");

    if (date == null) return false;

    return DateTime.parse(date).isAfter(DateTime.now());
  }

  // ================= VERIFICAR CÓDIGO =================

  Future<void> checkCode() async {
    final code = controller.text.trim().toUpperCase();
    if (code.isEmpty) return;

    setState(() {
      loading = true;
      result = "";
    });

    try {
      final query = await FirebaseFirestore.instance
          .collection('codes')
          .where('code', isEqualTo: code)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        result = "Código não encontrado ❌";
      } else {
        final doc = query.docs.first;
        final data = doc.data();

        // 🔴 Verificar expiração do código
        if (data['expiresAt'] != null &&
            data['expiresAt'].toDate().isBefore(DateTime.now())) {
          result = "Código expirado ⏰";
        }
        // 🟢 Código válido
        else if (data['available'] == true) {
          await doc.reference.update({'available': false});

          await addOneMonthToUser();

          result = "Código válido ✅ (1 mês adicionado)";
        }
        // 🟡 Já usado
        else {
          result = "Código já usado ⚠️";
        }
      }
    } catch (e) {
      result = "Erro ao verificar código ❌";
    }

    setState(() => loading = false);
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usar Código')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Digite o código',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : checkCode,
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Verificar'),
            ),
            const SizedBox(height: 20),
            Text(
              result,
              style: const TextStyle(fontSize: 18),
            )
          ],
        ),
      ),

      // ================= CONTATOS =================

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
                  onTap: openWhatsApp,
                ),
                ContactButton(
                  icon: Icons.call,
                  label: "Chamada",
                  color: Colors.blue,
                  onTap: makeCall,
                ),
                ContactButton(
                  icon: Icons.sms,
                  label: "SMS",
                  color: Colors.orange,
                  onTap: sendSMS,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}