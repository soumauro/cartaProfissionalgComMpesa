import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsedCodesPage extends StatelessWidget {
  const UsedCodesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Códigos Usados")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('codes')
            .where('available', isEqualTo: false)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                "Nenhum código foi usado ainda",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: const Icon(Icons.lock, color: Colors.red),
                  title: Text(
                    data['code'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Criado em: ${data['createdAt']?.toDate().toString() ?? '---'}",
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}