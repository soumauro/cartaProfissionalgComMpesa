import 'package:flutter/material.dart';
import 'payment_mpesa.dart';
import 'read_code_screen.dart';

class PaymentChoicePage extends StatelessWidget {
  const PaymentChoicePage({super.key});

  // Verificar se a promoção ainda está ativa (até às 15h do dia atual)
  bool isPromotionActive() {
    final now = DateTime.now();
    final promotionDeadline = DateTime(now.year, now.month, now.day, 12, 30);
    return now.isBefore(promotionDeadline);
  }

  // Calcular preço com promoção
  double getPromotionPrice(double originalPrice) {
    if (isPromotionActive()) {
      return originalPrice * 0.8; // 30% de desconto
    }
    return originalPrice;
  }

  String getFormattedPrice(double price) {
    return "${price.toStringAsFixed(0)} MT";
  }

  @override
  Widget build(BuildContext context) {
    final bool promoActive = isPromotionActive();
    final String promoText = promoActive 
        ? "⚡ PROMOÇÃO ATÉ 12H: 30MIN - 20% OFF! ⚡" 
        : "Promoção encerrada";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Escolher Pagamento"),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: 
        
         SingleChildScrollView(
          physics: ScrollPhysics(),
           child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

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

SizedBox(height: 30,),

              const SizedBox(width: 5),
                    const Text(
                      "Pagamento 100% seguro via M-Pesa",
                      style: TextStyle(color: Colors.grey),
                    ),
              // Banner de promoção
              Container(
                ///padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: promoActive 
                        ? [Colors.orange, Colors.red.shade700]
                        : [Colors.grey, Colors.grey.shade600],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: promoActive ? [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ] : [],
                ),
                child: Row(
                  children: [
                    if (promoActive) ...[
                      const Icon(Icons.timer, color: Colors.white, size: 28),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "🔥 PROMOÇÃO RELÂMPAGO NO M-Pesa🔥",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Até às 12h:30MIN de hoje • 20% OFF em todos os planos!",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      const Icon(Icons.access_time, color: Colors.white, size: 28),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "⏰ Promoção encerrada • Volte amanhã!",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
           
              const SizedBox(height: 20),
           
              const Text(
                "Escolha seu plano Premium",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
           
              const SizedBox(height: 10),
           
              Text(
                promoText,
                style: TextStyle(
                  color: promoActive ? Colors.red : Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
           
              const SizedBox(height: 30),
           
              // ================= PLANO MENSAL =================
              PlanCard(
                title: "Plano Mensal",
                originalPrice: 250,
                finalPrice: promoActive ? 210 : 250,
                duration: "30 dias",
                savings: promoActive ? 74 : 0,
                color: Colors.blue,
                icon: Icons.calendar_month,
                promoActive: promoActive,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MpesaPaymentPage(
                        planType: "MENSAL",
                        amount: promoActive ? 210 : 250,
                        durationDays: 30,
                      ),
                    ),
                  );
                },
              ),
           
              const SizedBox(height: 15),
           
              // ================= PLANO TRIMESTRAL =================
              PlanCard(
                title: "Plano Trimestral",
                originalPrice: 600, // 247 * 3
                finalPrice: promoActive ? 450 : 600, // 247*3*0.7 = 519
                duration: "90 dias",
                savings: promoActive ? 222 : 0,
                extraBonus: "Economize 1 mês!",
                color: Colors.orange,
                icon: Icons.auto_awesome,
                promoActive: promoActive,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MpesaPaymentPage(
                        planType: "TRIMESTRAL",
                        amount: promoActive ? 450 : 600,
                        durationDays: 90,
                      ),
                    ),
                  );
                },
              ),
           
              const SizedBox(height: 15),
           
              // ================= PLANO ANUAL =================
              PlanCard(
                title: "Plano Anual",
                originalPrice: 1000, // 247 * 12
                finalPrice: promoActive ? 660 : 950, // 247*12*0.7 = 2075
                duration: "365 dias",
                savings: promoActive ? 700 : 1000,
                extraBonus: "⭐ Melhor custo-benefício! ⭐",
                color: Colors.purple,
                icon: Icons.star,
                promoActive: promoActive,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MpesaPaymentPage(
                        planType: "ANUAL",
                        amount: promoActive ? 700 : 1000,
                        durationDays: 365,
                      ),
                    ),
                  );
                },
              ),
           
              SizedBox(height: 20),
           
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.security, size: 16, color: Colors.green),
                    
                  ],
                ),
              ),
            ],
                   ),
         ),
      
    );
  }
}

// ================= CARD DE PLANO PERSONALIZADO =================
class PlanCard extends StatelessWidget {
  final String title;
  final double originalPrice;
  final double finalPrice;
  final String duration;
  final double savings;
  final String? extraBonus;
  final Color color;
  final IconData icon;
  final bool promoActive;
  final VoidCallback onTap;

  const PlanCard({
    super.key,
    required this.title,
    required this.originalPrice,
    required this.finalPrice,
    required this.duration,
    required this.savings,
    this.extraBonus,
    required this.color,
    required this.icon,
    required this.promoActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.15), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: promoActive ? color : Colors.grey.shade300,
            width: promoActive ? 2 : 1,
          ),
          boxShadow: promoActive ? [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ] : [],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: color,
                    radius: 20,
                    child: Icon(icon, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
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
                        Text(
                          duration,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (promoActive && originalPrice != finalPrice)
                        Text(
                          "${originalPrice.toStringAsFixed(0)} MT",
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                      Text(
                        "${finalPrice.toStringAsFixed(0)} MT",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              if (savings > 0) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.savings, size: 14, color: Colors.green),
                      const SizedBox(width: 4),
                      Text(
                        "Economize ${savings.toStringAsFixed(0)} MT",
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              if (extraBonus != null) ...[
                const SizedBox(height: 6),
                Text(
                  extraBonus!,
                  style: TextStyle(
                    color: Colors.orange.shade700,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              
              const SizedBox(height: 12),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Pagar Agora"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



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