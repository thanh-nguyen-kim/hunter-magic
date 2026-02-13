// Event: Create of obj_spawner
// --- SPALWNING VARIABLES ---
spawn_timer = 0;
spawn_delay = 3.0;      // Start: One enemy every 3 seconds
min_spawn_delay = 0.5;  // Limit: Never faster than 0.5s

// --- DIFFICULTY VARIABLES ---
difficulty_timer = 0;   
difficulty_interval = 20.0; // Increase difficulty every 20 seconds
difficulty_step = 0.2;      // Reduce spawn delay by 0.2s each time
room_width =1080;
// Event: Create
global.game_over = false; // The game starts in a playing state

// Base speed for enemies
global.base_speed = 2; 

// Current speed (Starts equal to base)
global.enemy_speed = global.base_speed;

// Timer for speed increase
speed_up_timer = 0;
speed_up_interval = 30.0; // 30 seconds