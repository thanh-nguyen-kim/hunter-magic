// Event: Create of obj_game_controller
global._score = 0;
global.combo = 0;          // Current combo count
global.combo_timer = 0;    // Timer to reset combo if player is too slow
global.combo_max_time = 2.0; // Player has 2 seconds to land the next hit
receiver = new Receiver();
receiver.add("pattern_matched",function(){
	global.combo++;
	global.combo_timer=global.combo_max_time;
})
// 1. Open the file
ini_open("save_data.ini");

// 2. Read the value
// Arguments: "Section", "Key", Default Value (if file doesn't exist yet)
// Unity: global.highscore = PlayerPrefs.GetInt("highscore", 0);
global._highscore = ini_read_real("Player", "highscore", 0);

// 3. Close it
ini_close();