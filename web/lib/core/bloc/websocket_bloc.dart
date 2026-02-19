import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class WebSocketEvent {}
class ToggleDevice extends WebSocketEvent {
  final String deviceId;
  final bool targetState;
  ToggleDevice(this.deviceId, this.targetState);
}
class DeviceStateChanged extends WebSocketEvent {
  final String deviceId;
  final bool newState;
  DeviceStateChanged(this.deviceId, this.newState);
}

// State
class WebSocketState {
  final Map<String, bool> deviceStates;
  final Map<String, String?> errors;

  WebSocketState({this.deviceStates = const {}, this.errors = const {}});

  WebSocketState copyWith({Map<String, bool>? deviceStates, Map<String, String?>? errors}) {
    return WebSocketState(
      deviceStates: deviceStates ?? this.deviceStates,
      errors: errors ?? this.errors,
    );
  }
}

// BLoC
class WebSocketBloc extends Bloc<WebSocketEvent, WebSocketState> {
  // Mock WebSocket sink for demonstration
  final Function(String, bool)? mockSocketSend;

  WebSocketBloc({this.mockSocketSend}) : super(WebSocketState()) {
    on<ToggleDevice>(_onToggleDevice);
    on<DeviceStateChanged>(_onDeviceStateChanged);
  }

  Future<void> _onToggleDevice(ToggleDevice event, Emitter<WebSocketState> emit) async {
    // 1. Optimistic Update
    final currentStates = Map<String, bool>.from(state.deviceStates);
    final previousState = currentStates[event.deviceId] ?? false;
    
    currentStates[event.deviceId] = event.targetState;
    emit(state.copyWith(deviceStates: currentStates));

    try {
      // 2. Send Command (Simulated)
      if (mockSocketSend != null) {
        await mockSocketSend!(event.deviceId, event.targetState);
      } else {
        // Simulate network delay and random failure for testing logic
        await Future.delayed(const Duration(milliseconds: 100));
        // throw Exception("Network Error"); // Uncomment to test fallback
      }
    } catch (e) {
      // 3. Fallback on Failure
      final revertedStates = Map<String, bool>.from(state.deviceStates);
      revertedStates[event.deviceId] = previousState;
      
      final newErrors = Map<String, String?>.from(state.errors);
      newErrors[event.deviceId] = "Failed to toggle device";
      
      emit(state.copyWith(deviceStates: revertedStates, errors: newErrors));
    }
  }

  void _onDeviceStateChanged(DeviceStateChanged event, Emitter<WebSocketState> emit) {
    final currentStates = Map<String, bool>.from(state.deviceStates);
    currentStates[event.deviceId] = event.newState;
    emit(state.copyWith(deviceStates: currentStates));
  }
}
