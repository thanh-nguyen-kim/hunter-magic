// Event: End Step

// 1. Safety Check: Does my parent still exist?
if (!instance_exists(owner)) {
    instance_destroy(); // If parent dies, I die too
    exit;
}

// 2. Snap to position
x = owner.x + offset_x;
y = owner.y + offset_y;

// 3. (Optional) Match other properties
depth = owner.depth - 1;           // Always draw in front of parent