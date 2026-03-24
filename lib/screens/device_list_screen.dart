import 'package:cartaz/screens/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import '../models/device.dart';

class DeviceListScreen extends StatefulWidget {
  const DeviceListScreen({super.key});

  @override
  State<DeviceListScreen> createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> {
  final List<Device> devices = [
    Device(
      id: 1,
      uuid: "d8547f8c-3dce-47dd-a312-026e87ec3a94",
      available: true,
      isNew: true,
    ),
    Device(
      id: 2,
      uuid: "9a324593-ed19-4472-8d28-74d58583cf8f",
      available: true,
      isNew: true,
    ),
    Device(
      id: 3,
      uuid: "efe0f328-7aa9-46b8-98bb-4237197c61b0",
      available: true,
      isNew: true,
    ),
    Device(
      id: 4,
      uuid: "80f0c884-54ab-4567-8cba-6d4abe8e2954",
      available: true,
      isNew: true,
    ),
    Device(
      id: 5,
      uuid: "c16c82a4-8bb4-47a7-a67c-416b17828747",
      available: true,
      isNew: true,
    ),
    Device(
      id: 6,
      uuid: "427f6f67-ea61-4b89-aac2-f5fab64bda64",
      available: true,
      isNew: true,
    ),
    Device(
      id: 7,
      uuid: "768c763f-6443-4f34-ae57-086ab497ecc9",
      available: true,
      isNew: true,
    ),
    Device(
      id: 8,
      uuid: "e8cd1be1-a7de-4ecc-a8e5-38cbe4ad7bfe",
      available: true,
      isNew: true,
    ),
    Device(
      id: 9,
      uuid: "7590a242-c757-4a26-ada0-2927344ca962",
      available: true,
      isNew: true,
    ),
    Device(
      id: 10,
      uuid: "aa71d213-a987-4be6-b2ec-e56c909d69a0",
      available: true,
      isNew: true,
    ),
    Device(
      id: 11,
      uuid: "8d6c819d-bd6f-4077-a147-ee20ce1a677b",
      available: true,
      isNew: true,
    ),
    Device(
      id: 12,
      uuid: "e5a1fd6d-dd77-4b8a-ab04-ab18da6c7f08",
      available: true,
      isNew: true,
    ),
    Device(
      id: 13,
      uuid: "1e4b9296-956a-432e-adb3-a49cc22f16f5",
      available: true,
      isNew: true,
    ),
  ];
  bool isPremiun = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getUserStatus();
  }

  Future<void> getUserStatus(Device device) async {
    final prefer = await SharedPreferences.getInstance();
    setState(() {
      isPremiun = prefer.getBool("isPremiun") ?? false;
    });
    if (isPremiun|| device.id==1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => QuizScreen(device: device)),
      );
    } else {
      _showWarningDialog();
    }
  }

  void _showWarningDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Atenção!'),
        content: Text(
          'Conteudo reservado a usuarios Premiuns    '
          'Contacte-nos',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("Exames Disponíveis")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: devices.length,
        itemBuilder: (context, index) {
          final device = devices[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text("Exame #${device.id}"),
              subtitle: Text("Categoria Profissional -G"),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (device.isNew)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "NOVO",
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Icon(
                    device.available ? Icons.check_circle : Icons.cancel,
                    color: device.available ? Colors.blue : Colors.red,
                  ),
                ],
              ),
              onTap: () {
                getUserStatus(device);
              },
            ),
          );
        },
      ),
    );
  }
}
