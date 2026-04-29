import 'package:audioplayers/audioplayers.dart';

enum AUDIO{
  tick,
  start,
  end
}
class SoundPlayer {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playBeep(AUDIO audio) async {
    await _player.stop();
    switch(audio){
      case AUDIO.start:
      case AUDIO.end: 
        await _player.play(AssetSource('sfx/universfield-happy-message-ping-351298.mp3'));
        break;
      case AUDIO.tick:
        await _player.play(AssetSource('sfx/freesound_community-clock-tick-tik-tak-76043.mp3'));
        break;
    }
  }

  Future<void> stopBeep() async {
    await _player.stop();
  }

  Future<void> dispose() async {
    await _player.dispose(); 
  }
}