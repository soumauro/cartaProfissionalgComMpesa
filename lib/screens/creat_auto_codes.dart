import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class CreateAutoCodePage extends StatefulWidget {
  const CreateAutoCodePage({super.key});

  @override
  State<CreateAutoCodePage> createState() => _CreateAutoCodePageState();
}

class _CreateAutoCodePageState extends State<CreateAutoCodePage> {
  bool loading = false;
  String lastCode = "";

  String generateCode({int length = 8}) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();

    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

Future<void> createCode() async {
  setState(() => loading = true);

  String code = generateCode();

  DateTime now = DateTime.now();
  DateTime expiresAt = now.add(const Duration(days: 30));

  await FirebaseFirestore.instance.collection('codes').add({
    'code': code,
    'available': true,
    'createdAt': FieldValue.serverTimestamp(),
    'expiresAt': Timestamp.fromDate(expiresAt), // 👈 
  });

  setState(() {
    lastCode = code;
    loading = false;
  });

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Código mensal criado!")),
  );

}
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text("Gerar Código Automático")),
    body: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.auto_awesome),
            onPressed: loading ? null : createCode,
            label: loading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Gerar Código"),
          ),
          const SizedBox(height: 40),

          if (lastCode.isNotEmpty)
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      "Código Gerado",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      lastCode,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.copy),
                      label: const Text("Copiar Código"),
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(text: lastCode),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Código copiado com sucesso!"),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

}