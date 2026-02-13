// Event: Draw

// Set alignment so text is centered on the object's x/y
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);

// Set the transparency (alpha) based on our Step event logic
draw_set_alpha(image_alpha);
draw_set_color(color);

// Draw the text
draw_text_transformed(x, y, text_to_show,2,2,0);

// Reset alpha/color to default so we don't mess up other objects
draw_set_alpha(1);
draw_set_color(c_white);