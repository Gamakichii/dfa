class DFA {
  final List<String> states;
  final List<String> alphabet;
  final String startState;
  final List<String> finalStates;
  final Map<String, Map<String, String>> transitions;

  DFA({
    required this.states,
    required this.alphabet,
    required this.startState,
    required this.finalStates,
    required this.transitions,
  });

  @override
  String toString() {
    return 'States: $states\nAlphabet: $alphabet\nStart State: $startState\nFinal States: $finalStates\nTransitions: $transitions';
  }
}

Map<String, Map<String, String>> parseTransitions(String input) {
  final transitions = <String, Map<String, String>>{};
  final parts = input.split(';');

  for (var part in parts) {
    final transition = part.split('=');
    final fromStateAndSymbol = transition[0].split(',');
    final fromState = fromStateAndSymbol[0].trim();
    final symbol = fromStateAndSymbol[1].trim();
    final toState = transition[1].trim();

    if (!transitions.containsKey(fromState)) {
      transitions[fromState] = {};
    }
    transitions[fromState]![symbol] = toState;
  }

  return transitions;
}
