import 'package:flutter/material.dart';
import '../models/device.dart';
import '../models/question.dart';
import '../models/user_answer.dart';

class QuizResultScreen extends StatelessWidget {
  final Device device;
  final List<UserAnswer> results;
  final int totalQuestions;
  final int correctCount;
  final bool passed;
  final Map<int, String> userAnswers;
  final List<Question> questions; // Mudado para List<Question>

  const QuizResultScreen({
    super.key,
    required this.device,
    required this.results,
    required this.totalQuestions,
    required this.correctCount,
    required this.passed,
    required this.userAnswers,
    required this.questions,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (correctCount / totalQuestions) * 100;
    final wrongCount = totalQuestions - correctCount;

    return Scaffold(
      appBar: AppBar(
        title: Text('Resultado - ${device.id}'),
        backgroundColor: passed ? Colors.green : Colors.red,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Card de resultado principal
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Ícone de resultado
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: passed 
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        passed ? Icons.emoji_events : Icons.sentiment_dissatisfied,
                        size: 80,
                        color: passed ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Status
                    Text(
                      passed ? 'APROVADO!' : 'REPROVADO!',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: passed ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Estatísticas
                    _buildStatRow('Total de Perguntas', '$totalQuestions'),
                    const Divider(),
                    _buildStatRow(
                      'Respostas Corretas', 
                      '$correctCount',
                      color: Colors.green,
                    ),
                    _buildStatRow(
                      'Respostas Erradas', 
                      '$wrongCount',
                      color: Colors.red,
                    ),
                    const Divider(),
                    _buildStatRow(
                      'Pontuação', 
                      '${percentage.toStringAsFixed(1)}%',
                      isBold: true,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Nota mínima
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.info_outline, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Nota mínima: 18 acertos',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Botões de ação
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    icon: const Icon(Icons.home),
                    label: const Text('Início'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tentar Novamente'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Revisão das respostas
            const Text(
              'Revisão das Respostas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Lista de revisão
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                final userAnswer = userAnswers[question.id] ?? 'N/A';
                final isCorrect = userAnswer.trim().toUpperCase() == 
                                  question.answer.trim().toUpperCase();

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: isCorrect ? Colors.green : Colors.red,
                      radius: 14,
                      child: Icon(
                        isCorrect ? Icons.check : Icons.close,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      'Pergunta ${index + 1}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Sua resposta: $userAnswer',
                      style: TextStyle(
                        color: isCorrect ? Colors.green : Colors.red,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              question.question,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 12),
                            
                            // Mostrar todas as opções disponíveis
                            ...question.availableOptions.map((option) => 
                              Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: option.key == question.answer
                                      ? Colors.green.withOpacity(0.1)
                                      : (option.key == userAnswer && !isCorrect
                                          ? Colors.red.withOpacity(0.1)
                                          : null),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: option.key == question.answer
                                        ? Colors.green
                                        : (option.key == userAnswer && !isCorrect
                                            ? Colors.red
                                            : Colors.grey.shade300),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: option.key == question.answer
                                            ? Colors.green
                                            : (option.key == userAnswer && !isCorrect
                                                ? Colors.red
                                                : Colors.grey.shade200),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          option.key,
                                          style: TextStyle(
                                            color: option.key == question.answer ||
                                                    (option.key == userAnswer && !isCorrect)
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        option.value,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    if (option.key == question.answer)
                                      const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 20,
                                      ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),
                            
                            // Resposta correta em destaque
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.info_outline,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Resposta correta: ${question.answer}) ${_getOptionText(question, question.answer)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, {Color? color, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _getOptionText(Question question, String optionKey) {
    return question.getOptionText(optionKey);
  }
}