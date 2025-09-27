import 'package:flutter/material.dart';

class SafetyScoreWidget extends StatefulWidget {
  final int score;
  const SafetyScoreWidget({super.key, required this.score});

  @override
  State<SafetyScoreWidget> createState() => _SafetyScoreWidgetState();
}

class _SafetyScoreWidgetState extends State<SafetyScoreWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _scoreAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scoreAnimation = Tween<double>(begin: 0, end: widget.score.toDouble()).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut)
    );
    _setupColorAnimation(0, widget.score);
    _controller.forward();
  }

  // This is called whenever the score changes, allowing the animation to re-run
  @override
  void didUpdateWidget(SafetyScoreWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.score != oldWidget.score) {
      _setupColorAnimation(oldWidget.score, widget.score);
      _scoreAnimation = Tween<double>(begin: oldWidget.score.toDouble(), end: widget.score.toDouble()).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut)
      );
      _controller.forward(from: 0.0);
    }
  }

  void _setupColorAnimation(int beginScore, int endScore) {
    _colorAnimation = ColorTween(
      begin: _getColorForScore(beginScore),
      end: _getColorForScore(endScore),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }

  // This function calculates the color based on the score
  Color _getColorForScore(int score) {
    // A smooth transition from Red -> Yellow -> Green
    if (score <= 50) {
      return Color.lerp(Colors.red.shade600, Colors.yellow.shade600, score / 50)!;
    } else {
      return Color.lerp(Colors.yellow.shade600, Colors.green.shade600, (score - 50) / 50)!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final animatedColor = _colorAnimation.value ?? Colors.grey;
        return AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // Outer shadow for a "lifting" effect
              boxShadow: [
                BoxShadow(
                  color: animatedColor.withOpacity(0.4),
                  blurRadius: 15,
                  spreadRadius: 2,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // The radial gradient creates the 3D look
                gradient: RadialGradient(
                  colors: [
                    HSLColor.fromColor(animatedColor).withLightness(0.6).toColor(),
                    animatedColor,
                  ],
                  center: const Alignment(-0.5, -0.5),
                  radius: 1.5,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${_scoreAnimation.value.toInt()}%',
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(1,2))]
                      ),
                    ),
                    const Text(
                      'Safety\nScore',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        shadows: [Shadow(color: Colors.black26, blurRadius: 2, offset: Offset(1,1))],
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}