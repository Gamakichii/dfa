import 'dfa_model.dart';

DFA minimizeDFA(DFA dfa) {
  final nonFinalStates =
  dfa.states.where((s) => !dfa.finalStates.contains(s)).toList();
  List<List<String>> partitions = [
    dfa.finalStates,
    nonFinalStates,
  ];

  bool partitionChanged = true;

  while (partitionChanged) {
    partitionChanged = false;
    final newPartitions = <List<String>>[];

    for (var group in partitions) {
      final splitGroups = <String, List<String>>{};

      for (var state in group) {
        final key = dfa.alphabet.map((symbol) {
          final nextState = dfa.transitions[state]?[symbol] ?? '';
          return partitions.indexWhere((p) => p.contains(nextState));
        }).join(',');

        splitGroups.putIfAbsent(key, () => []).add(state);
      }

      newPartitions.addAll(splitGroups.values);
      if (splitGroups.length > 1) partitionChanged = true;
    }
    partitions = newPartitions;
  }

  final newStates = partitions.map((p) => p.join('_')).toList();
  final newStartState =
  newStates.firstWhere((s) => s.contains(dfa.startState));
  final newFinalStates = newStates
      .where((s) => s.split('_').any((st) => dfa.finalStates.contains(st)))
      .toList();

  final newTransitions = <String, Map<String, String>>{};
  for (var partition in partitions) {
    final representative = partition.first;
    final newState = partition.join('_');
    newTransitions[newState] = {};

    for (var symbol in dfa.alphabet) {
      final nextState = dfa.transitions[representative]?[symbol] ?? '';
      final targetPartition =
      partitions.firstWhere((p) => p.contains(nextState));
      newTransitions[newState]![symbol] = targetPartition.join('_');
    }
  }

  return DFA(
    states: newStates,
    alphabet: dfa.alphabet,
    startState: newStartState,
    finalStates: newFinalStates,
    transitions: newTransitions,
  );
}
