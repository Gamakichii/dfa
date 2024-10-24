import 'package:flutter_test/flutter_test.dart';
import 'package:dfa/dfa_model.dart';
import 'package:dfa/dfa_model.dart';

void main() {
  group('DFA Minimization', () {
    test('Minimizes a simple DFA correctly', () {
      final dfa = DFA(
        states: ['q0', 'q1', 'q2'],
        alphabet: ['a', 'b'],
        startState: 'q0',
        finalStates: ['q2'],
        transitions: {
          'q0': {'a': 'q1', 'b': 'q2'},
          'q1': {'a': 'q2', 'b': 'q0'},
          'q2': {'a': 'q2', 'b': 'q2'},
        },
      );

      final minimizedDfa = minimizeDFA(dfa);

      expect(minimizedDfa.states, equals(['q0_q1', 'q2']));
      expect(minimizedDfa.startState, equals('q0_q1'));
      expect(minimizedDfa.finalStates, equals(['q2']));
    });

    test('Handles trivial DFA with a single state', () {
      final dfa = DFA(
        states: ['q0'],
        alphabet: ['a'],
        startState: 'q0',
        finalStates: ['q0'],
        transitions: {
          'q0': {'a': 'q0'},
        },
      );

      final minimizedDfa = minimizeDFA(dfa);

      expect(minimizedDfa.states, equals(['q0']));
      expect(minimizedDfa.startState, equals('q0'));
      expect(minimizedDfa.finalStates, equals(['q0']));
    });

    test('Throws error on invalid input', () {
      expect(() {
        final dfa = DFA(
          states: ['q0', 'q1'],
          alphabet: ['a'],
          startState: 'q2', // Invalid start state
          finalStates: ['q1'],
          transitions: {
            'q0': {'a': 'q1'},
          },
        );
        minimizeDFA(dfa);
      }, throwsException);
    });
  });
}
