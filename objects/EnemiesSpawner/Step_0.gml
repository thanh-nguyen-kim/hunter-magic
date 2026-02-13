// Event: Step
// IF GAME IS OVER, STOP RUNNING CODE BELOW
//if (!instance_exists(obj_gameover_panel)) {
//        instance_create_layer(0, 0, "Instances", obj_gameover_panel);
//    }
if (global.game_over == true){
	// Check if panel exists to prevent spawning 60 panels per second!
    if (!instance_exists(obj_gameover_panel)) {
        instance_create_layer(0, 0, "Instances", obj_gameover_panel);
    }
	exit;
}
var _dt = delta_time / 1000000; // Convert microseconds to seconds

// --- BLOCK A: SPAWN ENEMIES (The Game Loop) ---
spawn_timer += _dt;

if (spawn_timer >= spawn_delay) {
    // 1. Spawn the enemy
    var _x = 50 + random(room_width - 200);
    instance_create_layer(_x, -200, "Instances", obj_enemy_idle);
    
    // 2. Reset spawn timer
    spawn_timer -= spawn_delay;
}

// --- BLOCK B: INCREASE DIFFICULTY (The Progression Loop) ---
difficulty_timer += _dt;

if (difficulty_timer >= difficulty_interval) {
    // 1. Reduce the spawn delay (Make it faster)
    spawn_delay -= difficulty_step;
    
    // 2. Clamp it (Don't let it go below the limit!)
    // max(a, b) returns the larger number. 
    // If spawn_delay becomes 0.1, max(0.1, 0.5) returns 0.5.
    spawn_delay = max(spawn_delay, min_spawn_delay);

    // 3. Reset the difficulty timer
    difficulty_timer -= difficulty_interval;
}

// 1. Count up
speed_up_timer += delta_time / 1000000;

// 2. Check if 30 seconds have passed
if (speed_up_timer >= speed_up_interval) {
    
    // Increase speed by 1.5x (Multiply)
    global.enemy_speed *= 1.5;
    
    // Cap the limit at 3x the base speed (2 * 3 = 6)
    var _max_speed = global.base_speed * 3;
    
    if (global.enemy_speed > _max_speed) {
        global.enemy_speed = _max_speed;
    }
    
    // Reset timer to count another 30s
    speed_up_timer = 0;
    
}