// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splash_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Notifier managing splash screen loading logic (Riverpod 3.x pattern)
/// Following TECHNICAL_OVERVIEW.md principles with modern Riverpod API

@ProviderFor(SplashNotifier)
final splashProvider = SplashNotifierProvider._();

/// Notifier managing splash screen loading logic (Riverpod 3.x pattern)
/// Following TECHNICAL_OVERVIEW.md principles with modern Riverpod API
final class SplashNotifierProvider
    extends $NotifierProvider<SplashNotifier, SplashState> {
  /// Notifier managing splash screen loading logic (Riverpod 3.x pattern)
  /// Following TECHNICAL_OVERVIEW.md principles with modern Riverpod API
  SplashNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'splashProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$splashNotifierHash();

  @$internal
  @override
  SplashNotifier create() => SplashNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SplashState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SplashState>(value),
    );
  }
}

String _$splashNotifierHash() => r'17e332615aa1311b950359ac93b53fd3edccb134';

/// Notifier managing splash screen loading logic (Riverpod 3.x pattern)
/// Following TECHNICAL_OVERVIEW.md principles with modern Riverpod API

abstract class _$SplashNotifier extends $Notifier<SplashState> {
  SplashState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SplashState, SplashState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SplashState, SplashState>,
              SplashState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
