class Question {
  final int id;
  final bool available;
  final String uuid;
  final String question;
  final String? a;
  final String? b;
  final String? c; // Pode ser null
  final String? d; // Pode ser null
  final String answer;

  Question({
    required this.id,
    required this.available,
    required this.uuid,
    required this.question,
     this.a,
     this.b,
    this.c,
    this.d,
    required this.answer,
  });

  // Factory constructor para criar a partir de um Map
  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'] as int,
      available: map['available'] == 1,
      uuid: map['uuid'] as String,
      question: map['question'] as String,
      a: map['a'] as String? ?? '', // Se for null, usa string vazia
      b: map['b'] as String? ?? '', // Se for null, usa string vazia
      c: map['c'] as String? ?? "", // Mantém como null se não existir
      d: map['d'] as String? ?? '', // Mantém como null se não existir
      answer: map['answer'] as String,
    );
  }

  // Getter para verificar se uma opção existe e não está vazia
  bool hasOption(String letter) {
    switch (letter.toUpperCase()) {
      case 'A':
        return a != null && a!.isNotEmpty;
      case 'B':
        return b != null && b!.isNotEmpty;
      case 'C':
        return c != null && c!.isNotEmpty;
      case 'D':
        return d != null && d!.isNotEmpty;
      default:
        return false;
    }
  }

  // Getter para obter o texto de uma opção com segurança
  String getOptionText(String letter) {
    switch (letter.toUpperCase()) {
      case 'A':
        return a ?? "";
      case 'B':
        return b ?? "";
      case 'C':
        return c ?? ''; // Retorna string vazia se for null
      case 'D':
        return d ?? ''; // Retorna string vazia se for null
      default:
        return '';
    }
  }

  // Getter para verificar se a resposta é válida (existe)
  bool get hasValidAnswer {
    return hasOption(answer);
  }

  // Getter para lista de opções disponíveis (ignora nulls e vazios)
  List<MapEntry<String, String>> get availableOptions {
    final options = <MapEntry<String, String>>[];
    
    if (a != null && a!.isNotEmpty) options.add(MapEntry('A', a!));
    if (b != null && b!.isNotEmpty) options.add(MapEntry('B', b!));
    if (c != null && c!.isNotEmpty) options.add(MapEntry('C', c!));
    if (d != null && d!.isNotEmpty) options.add(MapEntry('D', d!));
    
    return options;
  }

  // Getter para número de opções disponíveis
  int get availableOptionsCount {
    return availableOptions.length;
  }

  // Verifica se a pergunta é válida (tem pergunta e pelo menos 2 opções)
  bool get isValid {
    return question.isNotEmpty && availableOptionsCount >= 2;
  }
}