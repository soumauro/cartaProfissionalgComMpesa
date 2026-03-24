import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateCodePage extends StatefulWidget {
  const CreateCodePage({super.key});

  @override
  State<CreateCodePage> createState() => _CreateCodePageState();
}

class _CreateCodePageState extends State<CreateCodePage> {
  final controller = TextEditingController();
  bool loading = false;

  Future<void> createCode() async {
    final code = controller.text.trim().toUpperCase();
    if (code.isEmpty) return;

    setState(() => loading = true);

    await FirebaseFirestore.instance.collection('codes').add({
      'code': code,
      'available': true,
      'createdAt': FieldValue.serverTimestamp(),
    });

    controller.clear();
    setState(() => loading = false);

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Código criado!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar Código')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Código',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : createCode,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text('Salvar'),
            )
          ],
        ),
      ),
    );
  }
}