import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MpesaPaymentPage extends StatefulWidget {
  const MpesaPaymentPage({super.key});

  @override
  State<MpesaPaymentPage> createState() => _MpesaPaymentPageState();
}

class _MpesaPaymentPageState extends State<MpesaPaymentPage> {
  final controller = TextEditingController();
  bool loading = false;
  String message = "";
  Color messageColor = Colors.black;

  final String url =
      "https://us-central1-nhonga.cloudfunctions.net/mpesaPayment";

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // ==================== ADICIONAR 1 MÊS ====================
  Future<void> addOneMonthToUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      DateTime now = DateTime.now();
      String? savedDate = prefs.getString("premiumExpiresAt");

      DateTime newDate;

      if (savedDate != null) {
        DateTime currentExpire = DateTime.parse(savedDate);

        if (currentExpire.isAfter(now)) {
          newDate = currentExpire.add(const Duration(days: 30));
        } else {
          newDate = now.add(const Duration(days: 30));
        }
      } else {
        newDate = now.add(const Duration(days: 30));
      }

      await prefs.setBool("isPremium", true);
      //await prefs.setBool("isPremium", true);
      await prefs.setString("premiumExpiresAt", newDate.toIso8601String());

   //   print("Premium ativado até: $newDate");
    } catch (e) {
      throw ("Erro ao ativar premium: $e");
    }
  }

  // ==================== PAGAMENTO ====================
  Future<void> pagar() async {
    FocusScope.of(context).unfocus();

    String phone = controller.text.trim();

    // Remove tudo que não for número
    phone = phone.replaceAll(RegExp(r'[^\d]'), '');

    // Validação
    if (phone.length != 9 ||
        !(phone.startsWith("84") || phone.startsWith("85"))) {
      setState(() {
        message = "❌ Número inválido (use 84xxxxxxx ou 85xxxxxxx)";
        messageColor = Colors.red;
      });
      return;
    }

    setState(() {
      loading = true;
      message = "";
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phoneNumber": "258$phone", "amount": 247}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // ✅ ATIVA PREMIUM
        await addOneMonthToUser();

        DateTime expire = DateTime.now().add(const Duration(days: 30));

        setState(() {
          message =
              "✅ Pagamento realizado com sucesso!\n\nPremium ativo até ${expire.day}/${expire.month}/${expire.year} 🎉";
          messageColor = Colors.green;
        });
      } else {
        setState(() {
          message = "❌ Falha no pagamento (${response.statusCode})";
          messageColor = Colors.red;
        });
      }
    } catch (e) {
      setState(() {
        message = "⚠️ Erro de conexão";
        messageColor = Colors.orange;
      });
    }

    setState(() {
      loading = false;
    });
  }

  // ==================== UI ====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pagamento M-Pesa"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const Text(
              "Plano Premium",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "247 MT / mês",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              maxLength: 9,
              decoration: InputDecoration(
                labelText: "Número M-Pesa",
                hintText: "841234567",
                helperText: "Digite sem o 258",
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                counterText: "",
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : pagar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Pagar", style: TextStyle(fontSize: 18)),
              ),
            ),

            const SizedBox(height: 20),

            if (message.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: messageColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  message,
                  style: TextStyle(color: messageColor),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
