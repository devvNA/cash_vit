import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'splash_provider.g.dart';

/// Sealed class representing all possible splash screen states
/// Following TECHNICAL_OVERVIEW.md pattern for type-safe state management
sealed class SplashState {
  const SplashState();
}

/// Initial state when splash screen first loads
class SplashInitial extends SplashState {
  const SplashInitial();
}

/// Loading state with progress (0.0 to 1.0)
class SplashLoading extends SplashState {
  final double progress;

  const SplashLoading(this.progress);
}

/// Complete state - triggers navigation to next screen
class SplashComplete extends SplashState {
  const SplashComplete();
}

/// Notifier managing splash screen loading logic (Riverpod 3.x pattern)
/// Following TECHNICAL_OVERVIEW.md principles with modern Riverpod API
@riverpod
class SplashNotifier extends _$SplashNotifier {
  Timer? _timer;

  @override
  SplashState build() {
    // Cleanup timer when provider is disposed
    ref.onDispose(() {
      _timer?.cancel();
    });

    // Start loading with small delay to ensure UI is ready
    Future.microtask(() => _startLoading());

    // Return initial loading state
    return const SplashLoading(0.0);
  }

  /// Start loading animation (0% → 100% in 3 seconds)
  /// Updates every 10ms for smooth animation
  void _startLoading() {
    // Timer updates progress every 10ms (100 updates in 3 seconds)
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      final currentState = state;

      if (currentState is SplashLoading) {
        final newProgress = (currentState.progress + 0.01).clamp(0.0, 1.0);

        if (newProgress >= 1.0) {
          timer.cancel();
          state = const SplashComplete();
        } else {
          state = SplashLoading(newProgress);
        }
      }
    });
  }
}
