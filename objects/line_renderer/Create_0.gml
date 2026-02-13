// Event: Create

// Array to store the path: [ {x: 100, y: 100}, {x: 105, y: 102}, ... ]
mouse_trail = []; 

// Control variable
is_drawing = false;

// 1. Create the Recognizer
global.myRecognizer = new Recognizer();

// --- 1. Horizontal Line ("-") ---
// Drawn Left to Right
var patHorz = new GesturePattern("-");
patHorz.useLinesDirections = true; 
// Define path: (0,0) -> (100,0)
patHorz.add_stroke([
    {x: 0,   y: 0}, 
    {x: 50,  y: 0}, 
    {x: 100, y: 0}
]);
array_push(global.myRecognizer.patterns, patHorz);


// --- 2. Vertical Line ("|") ---
// Drawn Top to Bottom
var patVert = new GesturePattern("|");
patVert.useLinesDirections = true;
// Define path: (0,0) -> (0,100)
patVert.add_stroke([
    {x: 0, y: 0}, 
    {x: 0, y: 50}, 
    {x: 0, y: 100}
]);
array_push(global.myRecognizer.patterns, patVert);


// --- 3. Letter V ("v") ---
// Drawn Top-Left -> Bottom-Middle -> Top-Right
var patV = new GesturePattern("v");
patV.useLinesDirections = true;
patV.add_stroke([
    {x: 0,   y: 0},   // Top Left
    {x: 60,  y: 100}, // Bottom Point
    {x: 120, y: 0}    // Top Right
]);
array_push(global.myRecognizer.patterns, patV);


// --- 4. Caret / Inverted V ("^") ---
// Drawn Bottom-Left -> Top-Middle -> Bottom-Right
var patCaret = new GesturePattern("^");
patCaret.useLinesDirections = true;
patCaret.add_stroke([
    {x: 0,   y: 100}, // Bottom Left
    {x: 50,  y: 0},   // Top Peak
    {x: 100, y: 100}  // Bottom Right
]);
array_push(global.myRecognizer.patterns, patCaret);

// Debug Confirmation
show_debug_message("Added 4 default patterns to recognizer.");