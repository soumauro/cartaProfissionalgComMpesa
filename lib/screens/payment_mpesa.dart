import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MpesaPaymentPage extends StatefulWidget {
  final String planType;
  final double amount;
  final int durationDays;

  const MpesaPaymentPage({
    super.key,
    required this.planType,
    required this.amount,
    required this.durationDays,
  });

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

  // ==================== ADICIONAR DIAS AO PREMIUM ====================
  Future<void> addPremiumDays(int days) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      DateTime now = DateTime.now();
      String? savedDate = prefs.getString("premiumExpiresAt");

      DateTime newDate;

      if (savedDate != null) {
        DateTime currentExpire = DateTime.parse(savedDate);

        if (currentExpire.isAfter(now)) {
          newDate = currentExpire.add(Duration(days: days));
        } else {
          newDate = now.add(Duration(days: days));
        }
      } else {
        newDate = now.add(Duration(days: days));
      }

      await prefs.setBool("isPremium", true);
      await prefs.setString("premiumExpiresAt", newDate.toIso8601String());
      
      debugPrint("Premium ativado até: $newDate");
    } catch (e) {
      throw Exception("Erro ao ativar premium: $e");
    }
  }

  // ==================== PAGAMENTO ====================
  Future<void> pagar() async {
    FocusScope.of(context).unfocus();

    String phone = controller.text.trim();
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
        body: jsonEncode({
          "phoneNumber": "258$phone", 
          "amount": widget.amount.toInt()
        }),
      );

      if (response.statusCode == 200) {
        await addPremiumDays(widget.durationDays);

        DateTime expireDate = DateTime.now().add(Duration(days: widget.durationDays));

        setState(() {
          message = 
              "✅ Pagamento realizado com sucesso!\n\n"
              "Plano: ${widget.planType}\n"
              "Valor: ${widget.amount.toStringAsFixed(0)} MT\n"
              "Premium ativo até ${expireDate.day}/${expireDate.month}/${expireDate.year} 🎉";
          messageColor = Colors.green;
        });

        // Voltar após 3 segundos
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pop(context);
        });
      } else {
        setState(() {
          message = "❌ Falha no pagamento (${response.statusCode})";
          messageColor = Colors.red;
        });
      }
    } catch (e) {
      setState(() {
        message = "⚠️ Erro de conexão: $e";
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
        title: Text("Pagamento M-Pesa - ${widget.planType}"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        ///padding: const EdgeInsets.all(20),
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
                gradient: LinearGradient(
                  colors: [Colors.green.shade400, Colors.green.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Column(
                children: [
                  Text(
                    "${widget.planType}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "${widget.amount.toStringAsFixed(0)} MT",
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "${widget.durationDays} dias de acesso",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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

        ///    const Spacer(),

            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline, size: 14, color: Colors.grey),
                  SizedBox(width: 5),
                  Text(
                    "Você receberá um pedido de pagamento no seu M-Pesa",
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}