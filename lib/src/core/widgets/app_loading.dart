import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AppLoading extends StatelessWidget {
  final double size;
  const AppLoading({super.key, this.size = 60.0});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.threeRotatingDots(
        color: Color(0xFF00695C),
        size: size,
      ),
    );
  }
}
