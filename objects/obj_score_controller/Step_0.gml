// Event: Step

if (global.combo > 0) {
    // Count down
    global.combo_timer -= delta_time / 1000000;

    // Time's up! Reset combo
    if (global.combo_timer <= 0) {
        global.combo = 0;
    }
}