import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:chess_live/app/config/app_config.dart';
import 'dart:async';

class VoiceService {
  static final VoiceService _instance = VoiceService._internal();
  late RtcEngine _engine;
  late String _channelName;
  int _uid = 0;
  bool _isInitialized = false;
  bool _isMuted = false;
  bool _isSpeakerEnabled = true;

  final _connectionStateController = StreamController<bool>.broadcast();
  Stream<bool> get connectionStateStream => _connectionStateController.stream;

  factory VoiceService() {
    return _instance;
  }

  VoiceService._internal();

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _engine = createAgoraRtcEngine();
      await _engine.initialize(
        RtcEngineContext(
          appId: AppConfig.agoraAppId,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );

      // Enable audio module
      await _engine.enableAudio();
      await _engine.setAudioProfile(
        profile: AudioProfileType.audioProfileDefault,
        scenario: AudioScenarioType.audioScenarioChatRoom,
      );

      // Setup event handlers
      _setupEventHandlers();

      _isInitialized = true;
    } catch (e) {
      print('Error initializing Agora: $e');
      rethrow;
    }
  }

  void _setupEventHandlers() {
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          print('User joined channel: ${connection.channelId}');
          _connectionStateController.add(true);
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          print('Remote user joined: $remoteUid');
        },
        onUserOffline: (connection, remoteUid, reason) {
          print('Remote user offline: $remoteUid');
          _connectionStateController.add(false);
        },
        onError: (err) {
          print('Agora error: $err');
        },
      ),
    );
  }

  Future<void> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      throw Exception('Microphone permission denied');
    }
  }

  Future<void> joinChannel({
    required String channelName,
    required int uid,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      await requestMicrophonePermission();

      _channelName = channelName;
      _uid = uid;

      await _engine.joinChannel(
        token: AppConfig.agoraToken,
        channelId: channelName,
        uid: uid,
        options: const RtcChannelMediaOptions(
          autoSubscribeAudio: true,
          publishMicrophoneTrack: true,
        ),
      );
    } catch (e) {
      print('Error joining channel: $e');
      rethrow;
    }
  }

  Future<void> leaveChannel() async {
    try {
      await _engine.leaveChannel();
      _connectionStateController.add(false);
    } catch (e) {
      print('Error leaving channel: $e');
    }
  }

  Future<void> toggleMicrophone() async {
    try {
      _isMuted = !_isMuted;
      await _engine.muteLocalAudioStream(_isMuted);
    } catch (e) {
      print('Error toggling microphone: $e');
    }
  }

  Future<void> toggleSpeaker() async {
    try {
      _isSpeakerEnabled = !_isSpeakerEnabled;
      await _engine.setEnableSpeakerphone(_isSpeakerEnabled);
    } catch (e) {
      print('Error toggling speaker: $e');
    }
  }

  bool get isMuted => _isMuted;
  bool get isSpeakerEnabled => _isSpeakerEnabled;

  Future<void> dispose() async {
    try {
      await leaveChannel();
      await _engine.release();
      await _connectionStateController.close();
      _isInitialized = false;
    } catch (e) {
      print('Error disposing voice service: $e');
    }
  }
}
