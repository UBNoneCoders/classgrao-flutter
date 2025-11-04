import 'package:classgrao/src/core/widgets/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'splash_view_model.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(splashViewModelProvider.notifier).checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String?>(splashViewModelProvider, (previousState, nextState) {
      if (nextState != null) {
        Navigator.of(context).pushReplacementNamed(nextState);
      }
    });

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 250,
              ),
              const SizedBox(height: 32),
              AppLoading(),
            ],
          ),
        ),
      ),
    );
  }
}
