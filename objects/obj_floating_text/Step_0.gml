// Event: Step

// 1. Fade out slowly
image_alpha -= 0.02; // Disappear over 50 frames (1 / 0.02 = 50)

// 2. Destroy when invisible
if (image_alpha <= 0) {
    instance_destroy();
}