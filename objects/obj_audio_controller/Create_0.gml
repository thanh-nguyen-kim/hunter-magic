// Event: Create

var _music = Music;

// Only play if it isn't ALREADY playing
if (!audio_is_playing(_music)) {
    // Arguments: sound_id, priority, loop
    audio_play_sound(_music, 1000, true);
}