import 'package:flutter/material.dart';
import 'dfa_model.dart';
import 'dfa_minimizer.dart';

void main() {
  runApp(DfaMinimizerApp());
}

class DfaMinimizerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DfaInputScreen(),
    );
  }
}

class DfaInputScreen extends StatefulWidget {
  @override
  _DfaInputScreenState createState() => _DfaInputScreenState();
}

class _DfaInputScreenState extends State<DfaInputScreen> {
  final TextEditingController _statesController = TextEditingController();
  final TextEditingController _alphabetController = TextEditingController();
  final TextEditingController _transitionsController = TextEditingController();
  final TextEditingController _startStateController = TextEditingController();
  final TextEditingController _finalStatesController = TextEditingController();

  String _minimizedDfa = "";

  void _minimizeDfa() {
    final dfa = DFA(
      states: _statesController.text.split(','),
      alphabet: _alphabetController.text.split(','),
      startState: _startStateController.text.trim(),
      finalStates: _finalStatesController.text.split(','),
      transitions: parseTransitions(_transitionsController.text),
    );

    final minimizedDfa = minimizeDFA(dfa);
    setState(() {
      _minimizedDfa = minimizedDfa.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('DFA Minimizer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _statesController,
                decoration: InputDecoration(labelText: 'States (comma-separated)'),
              ),
              TextField(
                controller: _alphabetController,
                decoration: InputDecoration(labelText: 'Alphabet (comma-separated)'),
              ),
              TextField(
                controller: _transitionsController,
                decoration: InputDecoration(
                    labelText: 'Transitions (e.g., q0,a=q1;q1,b=q2)'),
              ),
              TextField(
                controller: _startStateController,
                decoration: InputDecoration(labelText: 'Start State'),
              ),
              TextField(
                controller: _finalStatesController,
                decoration: InputDecoration(labelText: 'Final States (comma-separated)'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _minimizeDfa,
                child: Text('Minimize DFA'),
              ),
              SizedBox(height: 20),
              Text('Minimized DFA:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(_minimizedDfa),
            ],
          ),
        ),
      ),
    );
  }
}
