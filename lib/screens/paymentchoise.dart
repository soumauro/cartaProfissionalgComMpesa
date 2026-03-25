import 'package:cartaz/screens/read_code_screen.dart';
import 'package:flutter/material.dart';
import 'payment_mpesa.dart';

class PaymentChoicePage extends StatelessWidget {
  const PaymentChoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Escolher Pagamento"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const Text(
              "Escolha o método de pagamento",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Text(
              "Plano mensal - 247 MT",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 40),

            // ================= MPESA =================
            PaymentCard(
              title: "M-Pesa",
              subtitle: "Pagamento rápido e seguro",
              color: Colors.green,
              icon: Icons.phone_android,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MpesaPaymentPage()),
                );
              },
            ),

            const SizedBox(height: 20),

            // ================= EMOLA =================
            PaymentCard(
              title: "e-Mola",
              subtitle: "Pague com sua conta e-Mola",
              color: Colors.orange,
              icon: Icons.account_balance_wallet,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UseCodePage()),
                );
              },
            ),

            const Spacer(),

            const Text(
              "Pagamento seguro 🔒",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= CARD CUSTOM =================

class PaymentCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const PaymentCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color,
              child: Icon(icon, color: Colors.white),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(subtitle, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),

            const Icon(Icons.arrow_forward_ios, size: 18),
          ],
        ),
      ),
    );
  }
}
