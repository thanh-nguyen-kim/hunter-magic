/// @function draw_line_dashed(x1, y1, x2, y2, dash_length, gap_length)
function draw_line_dashed(_x1, _y1, _x2, _y2, _dash, _gap) {
    var _dir = point_direction(_x1, _y1, _x2, _y2);
    var _len = point_distance(_x1, _y1, _x2, _y2);
    var _pos = 0;
    
    // Loop through the total length
    while (_pos < _len) {
        // Calculate start of this dash
        var _dx1 = _x1 + lengthdir_x(_pos, _dir);
        var _dy1 = _y1 + lengthdir_y(_pos, _dir);
        
        // Calculate end of this dash (clamp so it doesn't overshoot)
        var _dash_end = min(_pos + _dash, _len);
        var _dx2 = _x1 + lengthdir_x(_dash_end, _dir);
        var _dy2 = _y1 + lengthdir_y(_dash_end, _dir);
        
        // Draw the segment
        draw_line_width(_dx1, _dy1, _dx2, _dy2,7);
        
        // Advance position (Dash + Gap)
        _pos += _dash + _gap;
    }
}