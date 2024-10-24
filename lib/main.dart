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
  final TextEditingController _startStateController = TextEditingController();
  final TextEditingController _finalStatesController = TextEditingController();

  Map<String, Map<String, TextEditingController>> _transitionControllers = {};

  String _minimizedDfa = "";
  String _errorMessage = "";

  // Generates transition input fields dynamically.
  void _generateTransitionFields() {
    final states = _statesController.text.split(',').map((s) => s.trim()).toList();
    final alphabet = _alphabetController.text.split(',').map((a) => a.trim()).toList();

    setState(() {
      _transitionControllers = {
        for (var state in states)
          state: {
            for (var symbol in alphabet)
              symbol: TextEditingController(),
          }
      };
    });
  }

  // Parses user input into a DFA object.
  DFA _parseDFA() {
    final states = _statesController.text.split(',').map((s) => s.trim()).toList();
    final alphabet = _alphabetController.text.split(',').map((a) => a.trim()).toList();
    final startState = _startStateController.text.trim();
    final finalStates = _finalStatesController.text.split(',').map((f) => f.trim()).toList();

    final transitions = <String, Map<String, String>>{};
    for (var state in _transitionControllers.keys) {
      transitions[state] = {};
      for (var symbol in _transitionControllers[state]!.keys) {
        final destination = _transitionControllers[state]![symbol]!.text.trim();
        transitions[state]![symbol] = destination;
      }
    }

    return DFA(
      states: states,
      alphabet: alphabet,
      startState: startState,
      finalStates: finalStates,
      transitions: transitions,
    );
  }

  void _minimizeDfa() {
    try {
      final dfa = _parseDFA();
      _validateDFA(dfa);

      final minimizedDfa = minimizeDFA(dfa);
      setState(() {
        _errorMessage = "";
        _minimizedDfa = minimizedDfa.toString();
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _minimizedDfa = "";
      });
    }
  }

  void _validateDFA(DFA dfa) {
    if (!dfa.states.contains(dfa.startState)) {
      throw Exception('Start state must be one of the states.');
    }
    if (!dfa.finalStates.every((f) => dfa.states.contains(f))) {
      throw Exception('All final states must be valid states.');
    }
    for (var fromState in dfa.transitions.keys) {
      if (!dfa.states.contains(fromState)) {
        throw Exception('Invalid state in transition: $fromState');
      }
      for (var symbol in dfa.transitions[fromState]!.keys) {
        if (!dfa.alphabet.contains(symbol)) {
          throw Exception('Invalid symbol in transition: $symbol');
        }
      }
    }
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
                onChanged: (_) => _generateTransitionFields(),
              ),
              TextField(
                controller: _alphabetController,
                decoration: InputDecoration(labelText: 'Alphabet (comma-separated)'),
                onChanged: (_) => _generateTransitionFields(),
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
              Text('Transitions:', style: TextStyle(fontWeight: FontWeight.bold)),
              _buildTransitionInputs(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _minimizeDfa,
                child: Text('Minimize DFA'),
              ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    'Error: $_errorMessage',
                    style: TextStyle(color: Colors.red),
                  ),
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

  Widget _buildTransitionInputs() {
    if (_transitionControllers.isEmpty) return Container();

    final transitionWidgets = <Widget>[];
    _transitionControllers.forEach((state, symbols) {
      transitionWidgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text('State: $state', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      );
      symbols.forEach((symbol, controller) {
        transitionWidgets.add(
          Row(
            children: [
              Text('On "$symbol" → ', style: TextStyle(fontSize: 16)),
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(labelText: 'Next State'),
                ),
              ),
            ],
          ),
        );
      });
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: transitionWidgets,
    );
  }
}
