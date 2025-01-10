import 'package:flutter/material.dart';

class TypingText extends StatefulWidget {
  final String text;
  final Duration typingSpeed;
  final TextStyle? style;

  const TypingText({
    super.key,
    required this.text,
    this.typingSpeed = const Duration(milliseconds: 50),
    this.style,
  });

  @override
  State<TypingText> createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText> {
  String _displayedText = '';
  int _charIndex = 0;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() async {
    while (_charIndex < widget.text.length) {
      await Future.delayed(widget.typingSpeed);
      if (mounted) {
        setState(() {
          _charIndex++;
          _displayedText = widget.text.substring(0, _charIndex);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayedText,
      style: widget.style ?? const TextStyle(fontSize: 16),
    );
  }
} 