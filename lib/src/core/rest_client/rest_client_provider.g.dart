// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rest_client_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(restClient)
const restClientProvider = RestClientProvider._();

final class RestClientProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  const RestClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'restClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$restClientHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return restClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$restClientHash() => r'7aff52df1d545dbc403cd826a3eee5081af4b8f1';
