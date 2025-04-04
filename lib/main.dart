// Импорт необходимых библиотек
import 'package:flutter/material.dart'; // Основная библиотека Flutter
import 'dart:js' as js; // Для взаимодействия с JavaScript
import 'package:universal_html/html.dart' as html; // Для работы с HTML

// Точка входа в приложение
void main() {
  runApp(const MyApp());
}

// Основной виджет приложения
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HTML to PDF Converter', // Заголовок приложения
      theme: ThemeData(
        primarySwatch: Colors.blue, // Основной цвет интерфейса
      ),
      home: const PdfConverterScreen(), // Главный экран
    );
  }
}

// Виджет экрана конвертации PDF
class PdfConverterScreen extends StatefulWidget {
  const PdfConverterScreen({super.key});

  @override
  State<PdfConverterScreen> createState() => _PdfConverterScreenState();
}

// Состояние экрана конвертации PDF
class _PdfConverterScreenState extends State<PdfConverterScreen> {
  final TextEditingController _htmlController =
      TextEditingController(); // Контроллер для ввода HTML
  String _status = ''; // Текущий статус операции

  // Функция генерации PDF
  Future<void> _generatePdf() async {
    // Проверка на пустой контент
    if (_htmlController.text.isEmpty) {
      setState(() => _status = 'HTML content is empty');
      return;
    }

    setState(() => _status = 'Generating PDF...');

    try {
      // Вызов JavaScript-функции для генерации PDF
      await js.context.callMethod('generatePdf', [_htmlController.text]);
      setState(() => _status = 'PDF generated successfully');
    } catch (e) {
      setState(() => _status = 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Отступы от краев
        child: Column(
          children: [
            // Текстовое поле для ввода HTML
            Expanded(
              child: TextField(
                controller: _htmlController,
                maxLines: null, // Неограниченное количество строк
                expands: true, // Растягивание на весь доступный размер
                decoration: const InputDecoration(
                  border: OutlineInputBorder(), // Рамка вокруг поля
                  hintText: 'Paste your HTML here...', // Подсказка
                  alignLabelWithHint: true, // Выравнивание подсказки
                ),
              ),
            ),
            const SizedBox(height: 16), // Отступ между элементами
            Row(
              children: [
                // Кнопка генерации PDF
                ElevatedButton(
                  onPressed: _generatePdf,
                  child: const Text('Generate PDF'),
                ),
                const SizedBox(width: 16), // Отступ между кнопкой и текстом
                Text(_status), // Отображение статуса
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _htmlController.dispose(); // Освобождение ресурсов контроллера
    super.dispose();
  }
}
