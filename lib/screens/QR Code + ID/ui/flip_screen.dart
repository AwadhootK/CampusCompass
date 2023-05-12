import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../QrCode.dart';
import './result_screen.dart';

class FlipWidget extends StatefulWidget {
  final String code;
  bool isLogin;

  FlipWidget({required this.code, required this.isLogin});

  @override
  _FlipWidgetState createState() => _FlipWidgetState();
}

class _FlipWidgetState extends State<FlipWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFrontVisible = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleCard() {
    if (_isFrontVisible) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    setState(() {
      _isFrontVisible = !_isFrontVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _toggleCard,
          child: Text(
            _isFrontVisible ? 'Generate QR Code' : 'View ID',
          ),
        ),
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(math.pi * _animation.value),
                child: _isFrontVisible
                    ? SizedBox(
                        child: ResultScreen(
                          code: widget.code,
                          isLogin: true,
                        ),
                      )
                    : const QrCode(),
              ),
            );
          },
        ),
      ],
    );
  }
}
