import 'package:cartaz/screens/about_screen.dart';
import 'package:cartaz/screens/creat_auto_codes.dart';
//import 'package:cartaz/screens/create_code_screen.dart';
import 'package:cartaz/screens/device_list_screen.dart';
import 'package:cartaz/screens/paymentchoise.dart';
// import 'package:cartaz/screens/read_code_screen.dart';
import 'package:cartaz/screens/rules_screan.dart';
import 'package:cartaz/screens/used_codes.dart';
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
  final List<Widget> admin = [CreateAutoCodePage(), UsedCodesPage()];
  final List<Widget> pages = [
    DeviceListScreen(),
    RulesPage(),
    PaymentChoicePage(),
    AboutPage(),
  ];
  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final preferedShere = await SharedPreferences.getInstance();
    setState(() {
      preminUser = preferedShere.getBool("isPremiun") ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profissional -G"),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              !preminUser ? "Basico" : "Premiun",
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        ],
      ),
      body: IndexedStack(index: currentPageIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Icons.home), label: "Exames"),
          NavigationDestination(icon: Icon(Icons.rule), label: "regras"),
          NavigationDestination(icon: Icon(Icons.pin), label: 'codigos'),
          NavigationDestination(
            icon: Icon(Icons.people_alt_sharp),
            label: 'Sobre Nós',
          ),
        ],
      ),
    );
  }
}
