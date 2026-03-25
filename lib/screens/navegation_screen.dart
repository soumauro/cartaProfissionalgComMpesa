import 'package:cartaz/screens/about_screen.dart';
//import 'package:cartaz/screens/creat_auto_codes.dart';
import 'package:cartaz/screens/device_list_screen.dart';
import 'package:cartaz/screens/paymentchoise.dart';
//import 'package:cartaz/screens/rules_screan.dart';
//import 'package:cartaz/screens/used_codes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavegationScreen extends StatefulWidget {
  const NavegationScreen({super.key});

  @override
  State<NavegationScreen> createState() => _NavegationScreenState();
}

class _NavegationScreenState extends State<NavegationScreen> {
  int currentPageIndex = 0;
  bool preminUser = false;
  String premiumExpiresAt = "";

  final List<Widget> pages = [
    DeviceListScreen(),
    //RulesPage(),
    PaymentChoicePage(),
    AboutPage(),
  ];

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  // ==================== VERIFICADOR PREMIUM ====================
  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();

    bool isPremium = prefs.getBool("isPremium") ?? false;
    String expire = prefs.getString("premiumExpiresAt") ?? "";

    // 🔥 VERIFICA SE EXPIROU
    if (isPremium && expire.isNotEmpty) {
      DateTime expireDate = DateTime.parse(expire);

      if (DateTime.now().isAfter(expireDate)) {
        // ❌ expirou → remove premium
        await prefs.setBool("isPremium", false);

        setState(() {
          preminUser = false;
          premiumExpiresAt = "";
        });

        return;
      }
    }

    setState(() {
      preminUser = isPremium;
      premiumExpiresAt = expire;
    });
  }

  // ==================== FORMATAR DATA ====================
  String formatDate(String date) {
    if (date.isEmpty) return "";

    DateTime d = DateTime.parse(date);
    return "${d.day}/${d.month}/${d.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        title: const Text(
          "Profissional G",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (preminUser && premiumExpiresAt.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Center(
                child: Text(
                  "Expira: ${formatDate(premiumExpiresAt)}",
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),

          // 🔥 BADGE MELHORADO
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: preminUser
                  ? const LinearGradient(
                      colors: [Colors.orange, Colors.deepOrange])
                  : const LinearGradient(
                      colors: [Colors.grey, Colors.black54]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              preminUser ? "PREMIUM" : "BÁSICO",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),

      // ==================== CONTEÚDO ====================
      body: IndexedStack(
        index: currentPageIndex,
        children: pages,
      ),

      // ==================== NAVIGATION ====================
      bottomNavigationBar: NavigationBar(
        height: 70,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Exames",
          ),
          
          NavigationDestination(
            icon: Icon(Icons.payment_outlined),
            selectedIcon: Icon(Icons.payment),
            label: "Premium",
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outline),
            selectedIcon: Icon(Icons.info),
            label: "Sobre",
          ),
        ],
      ),
    );
  }
}