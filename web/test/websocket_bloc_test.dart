import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import '../lib/core/bloc/websocket_bloc.dart';

void main() {
  group('WebSocketBloc Optimistic UI', () {
    late WebSocketBloc bloc;

    blocTest<WebSocketBloc, WebSocketState>(
      'Optimistically updates state to TRUE, then succeeds',
      build: () => WebSocketBloc(mockSocketSend: (id, state) async {
        // Simulate success
        return;
      }),
      act: (bloc) => bloc.add(ToggleDevice('light_1', true)),
      expect: () => [
        isA<WebSocketState>().having((p0) => p0.deviceStates['light_1'], 'light_1 is true', true),
      ],
    );

    blocTest<WebSocketBloc, WebSocketState>(
      'Optimistically updates state to TRUE, then Reverts on Failure',
      build: () => WebSocketBloc(mockSocketSend: (id, state) async {
        throw Exception("Simulated Network Fail");
      }),
      act: (bloc) => bloc.add(ToggleDevice('light_1', true)),
      expect: () => [
        // 1. Optimistic Success
        isA<WebSocketState>().having((p0) => p0.deviceStates['light_1'], 'light_1 optimistic true', true),
        // 2. Revert (Fallback)
        isA<WebSocketState>().having((p0) => p0.deviceStates['light_1'], 'light_1 reverted to false', false)
                             .having((p0) => p0.errors['light_1'], 'has error', 'Failed to toggle device'),
      ],
    );
  });
}
