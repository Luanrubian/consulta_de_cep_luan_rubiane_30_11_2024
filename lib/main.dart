import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cepController = TextEditingController();
  String _result = '';

  Future<void> _searchCEP() async {
    try {
      final response = await http.get(Uri.parse('https://viacep.com.br/ws/${_cepController.text}/json/'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _result = 'CEP: ${data['cep']}\n'
              'Logradouro: ${data['logradouro']}\n'
              'Complemento: ${data['complemento']}\n'
              'Bairro: ${data['bairro']}\n'
              'Localidade: ${data['localidade']}\n'
              'UF: ${data['uf']}';
        });
      } else {
        setState(() {
          _result = 'Erro ao consultar o CEP.';
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Erro: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta de CEP - Luan Rubiane - 30/11/2024'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cepController,
              decoration: const InputDecoration(labelText: 'Digite o CEP'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _searchCEP,
              child: const Text('Consultar'),
            ),
            const SizedBox(height: 16),
            Text(
              _result,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
