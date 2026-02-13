// Event: Step

if (global.state == "intro") {
    // --- INTRO LOGIC ---
    
    // Move up automatically
    y -= 2; 
    
    // Set animation to run/walk
    //sprite_index = spr_player_run; 
    
    // Check if we reached the target height
    // (Note: y gets smaller as you go up)
    if (y <= target_y) {
        y = target_y;       // Snap to exact position
        global.state = "playing";  // Switch state to give player control
    }
}
else if (global.state == "playing") {
    if (mouse_check_button(mb_left)) {
        // Direct Snap: Set Player X to Mouse X
        x = mouse_x;
        
        // Important: Set speed to 0 so momentum doesn't carry over
        hsp = 0; 
    }
}