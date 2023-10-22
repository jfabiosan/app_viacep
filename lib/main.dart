import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController cepController = TextEditingController();
  String result = '';

  Future<void> fetchAddress() async {
    final cep = cepController.text;
    final response =
        await http.get(Uri.parse("https://viacep.com.br/ws/$cep/json/"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        result = 'CEP: $cep\n'
            'Logradouro: ${data['logradouro']}\n'
            'Bairro: ${data['bairro']}\n'
            'Cidade: ${data['localidade']}\n'
            'Estado: ${data['uf']}';
      });
    } else {
      setState(() {
        result = 'CEP não encontrado';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta de CEP'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: cepController,
                decoration: const InputDecoration(labelText: 'Digite o CEP'),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: fetchAddress,
                child: const Text('Consultar CEP'),
              ),
              const SizedBox(height: 20),
              Text(result),
            ],
          ),
        ),
      ),
    );
  }
}
