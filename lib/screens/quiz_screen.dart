import 'package:cartaz/screens/device_detail_screen.dart';
import 'package:flutter/material.dart';
import '../models/device.dart';
import '../models/question.dart';
import '../models/user_answer.dart';
import '../data/questions_data.dart';
import '../widgets/question_card.dart';
import 'quiz_result_screen.dart';

class QuizScreen extends StatefulWidget {
  final Device device;

  const QuizScreen({super.key, required this.device});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<Question> deviceQuestions;
  late PageController _pageController;
  final Map<int, String> _userAnswers = {};
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Agora questions já é List<Question>
    deviceQuestions = questions
        .where((q) => q.uuid == widget.device.uuid)
        .where((q) => q.isValid)
        .toList();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentIndex < deviceQuestions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _submitQuiz() {
    // Verificar se todas as perguntas foram respondidas
    if (_userAnswers.length < deviceQuestions.length) {
      _showWarningDialog();
      return;
    }

    List<UserAnswer> results = [];
    int correctCount = 0;

    for (var question in deviceQuestions) {
      final selectedAnswer = _userAnswers[question.id] ?? '';
      final isCorrect = selectedAnswer.trim().toUpperCase() == 
                        question.answer.trim().toUpperCase();

      if (isCorrect) correctCount++;
      
      results.add(UserAnswer(
        questionId: question.id,
        selectedAnswer: selectedAnswer,
        isCorrect: isCorrect,
      ));
    }

    final passed = correctCount >= 18;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultScreen(
          device: widget.device,
          results: results,
          totalQuestions: deviceQuestions.length,
          correctCount: correctCount,
          passed: passed,
          userAnswers: _userAnswers,
          questions: deviceQuestions,
        ),
      ),
    );
  }

  void _showWarningDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Atenção!'),
        content: Text(
          'Você respondeu ${_userAnswers.length} de ${deviceQuestions.length} perguntas. '
          'Deseja finalizar mesmo assim?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _submitQuiz();
            },
            child: const Text('Finalizar'),
          ),
        ],
      ),
    );
  }

  void _resetQuiz() {
    setState(() {
      _userAnswers.clear();
      _currentIndex = 0;
      _pageController.jumpToPage(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (deviceQuestions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Quiz ${widget.device.id}'),
        ),
        body: const Center(
          child: Text('Nenhuma pergunta disponível para este exame'),
        ),
      );
    }

    final progress = _userAnswers.length / deviceQuestions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz ${widget.device.id}'),
        actions: [
          TextButton(onPressed: (){
            Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DeviceDetailScreen(device: widget.device),
                  ));


          }, child: Text('Ver Resumo')),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetQuiz,
            tooltip: 'Reiniciar Quiz',
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de progresso
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progresso',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      '${_userAnswers.length}/${deviceQuestions.length}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progress == 1.0 ? Colors.green : Colors.blue,
                  ),
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(5),
                ),
              ],
            ),
          ),

          // Perguntas
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: deviceQuestions.length,
              itemBuilder: (context, index) {
                final question = deviceQuestions[index];
                final selectedAnswer = _userAnswers[question.id];

                return QuestionCard(
                  question: question,
                  index: index,
                  total: deviceQuestions.length,
                  selectedAnswer: selectedAnswer,
                  onAnswerSelected: (answer) {
                    setState(() {
                      _userAnswers[question.id] = answer;
                    });
                  },
                );
              },
            ),
          ),

          // Navegação
          _buildNavigation(),
        ],
      ),
    );
  }

  Widget _buildNavigation() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Botão anterior
          if (_currentIndex > 0)
            ElevatedButton.icon(
              onPressed: _previousPage,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Anterior'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.black,
              ),
            )
          else
            const SizedBox(width: 100),

          // Indicador da página
          Text(
            '${_currentIndex + 1}/${deviceQuestions.length}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Botão próximo ou finalizar
          _currentIndex == deviceQuestions.length - 1
              ? ElevatedButton.icon(
                  onPressed: _submitQuiz,
                  icon: const Icon(Icons.check),
                  label: const Text('Finalizar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                )
              : ElevatedButton.icon(
                  onPressed: _nextPage,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Próximo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
        ],
      ),
    );
  }
}