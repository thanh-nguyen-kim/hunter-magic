/// @desc Vector2 Helper struct
function Vector2(_x, _y) constructor {
    x = _x;
    y = _y;
    
    static Distance = function(_v1, _v2) {
        return point_distance(_v1.x, _v1.y, _v2.x, _v2.y);
    }
    
    static Lerp = function(_v1, _v2, _t) {
        return new Vector2(lerp(_v1.x, _v2.x, _t), lerp(_v1.y, _v2.y, _t));   
    }
}

/// @desc Score Struct
function Score() constructor {
    positionDistance = 0;
    curvatureDistance = 0;
    angleDistance = 0;
    
    static get_final_score = function() {
        var posScore = clamp(1 - positionDistance / 50, 0, 1);
        var curvScore = clamp(1 - curvatureDistance / 50, 0, 1);
        var angleScore = clamp(1 - angleDistance / 50, 0, 1);
        return clamp((4 * posScore + 1 * curvScore + 1 * angleScore) / 6, 0, 1);
    }
    
    static InitMax = function() {
        positionDistance = 999999; // Float max approximation
        curvatureDistance = 999999;
        angleDistance = 999999;
    }
    
    static MaxDistance = function() {
        var res = new Score();
        res.InitMax();
        return res;
    }
}

/// @desc Result Container
function RecognitionResult() constructor {
    gesture = undefined; // GesturePattern
    _score = undefined;   // Score struct
    recognitionTime = 0;
    
    static Empty = function() {
        return new RecognitionResult();
    }
}

/// @desc Stores a single stroke of the gesture (equivalent to C# GestureLine)
function GestureLine() constructor {
    points = [];        // Array of Vector2
    closedLine = false; // Bool
}

/// @desc Stores the entire gesture (multiple strokes) (equivalent to C# GestureData)
function GestureData() constructor {
    lines = []; // Array of GestureLine structs

    /// @func get_last_line()
    /// @desc Returns the last line in the array (Mimics C# LastLine property)
    static get_last_line = function() {
        var _count = array_length(lines);
        if (_count > 0) {
            return lines[_count - 1];
        }
        return undefined; // Return undefined if lines is empty
    }
}
/// @desc The definition of a specific gesture (e.g., "Circle", "Square")
/// @param {String} _id  The name of the gesture
function GesturePattern(_id = "New Gesture") constructor {
    
    // The name of the pattern
    id = _id;

    // The actual stroke data (GestureData struct from previous code)
    gesture = new GestureData();

    // Configuration flags
    useLinesOrder = false;      // Does it matter which stroke I draw first?
    useLinesDirections = true;  // Does it matter if I draw Left->Right vs Right->Left?

    // --- HELPER: QUICKLY ADD A STROKE ---
    // Usage: myPattern.add_stroke([ {x:10, y:10}, {x:20, y:20} ... ]);
    static add_stroke = function(_point_array) {
        var _newLine = new GestureLine();
        
        // Convert raw structs or Vectors into the format GestureData expects
        for (var i = 0; i < array_length(_point_array); i++) {
            var _pt = _point_array[i];
            // Ensure we are using the Vector2 constructor defined previously
            array_push(_newLine.points, new Vector2(_pt.x, _pt.y));
        }
        
        // Detect if it's a closed shape (logic optional, but good for circles/squares)
        // This is a simple distance check between start and end
        if (array_length(_newLine.points) > 2) {
            var _first = _newLine.points[0];
            var _last = _newLine.points[array_length(_newLine.points)-1];
            if (Vector2.Distance(_first, _last) < 20) {
                 _newLine.closedLine = true;
            }
        }
        
        array_push(gesture.lines, _newLine);
    }
}
/// @desc The Main Recognizer Class
function Recognizer() constructor {
    Detail = 100;
    patterns = []; // List of GesturePattern (add your templates here)
    
    // --- MAIN RECOGNIZE FUNCTION ---
    static Recognize = function(_data, _normalizeScale = true) {
        var _t_start = current_time;
        
        var normData = NormalizeData(_data, _normalizeScale);
        var found = findPattern(normData, _normalizeScale);
        
        found.recognitionTime = (current_time - _t_start) / 1000.0;
        return found;
    }

    // --- NORMALIZATION PIPELINE ---
    static NormalizeData = function(_data, _normalizeScale) {
        if (_normalizeScale) {
            return NormalizeDistribution(NormalizeScale(NormalizeClosedLines(_data)), Detail);
        } else {
            return NormalizeDistribution(NormalizeClosedLines(_data), Detail);
        }
    }

    static NormalizeClosedLines = function(_data) {
        var result = new GestureData();
        for (var i = 0; i < array_length(_data.lines); i++) {
            var _line = _data.lines[i];
            var resultLine = new GestureLine();
            
            // Clone points
            for (var p = 0; p < array_length(_line.points); p++) {
                array_push(resultLine.points, new Vector2(_line.points[p].x, _line.points[p].y));
            }
            resultLine.closedLine = _line.closedLine;

            if (_line.closedLine && array_length(resultLine.points) > 0) {
                var lastP = resultLine.points[array_length(resultLine.points)-1];
                var firstP = resultLine.points[0];
                array_push(resultLine.points, Vector2.Lerp(lastP, firstP, 0.99));
            }
            array_push(result.lines, resultLine);
        }
        return result;
    }
    
    static NormalizeScale = function(_data) {
        var rect = CalcRect(_data);
        var result = new GestureData();
        
        for (var i = 0; i < array_length(_data.lines); i++) {
            var _line = _data.lines[i];
            var newLine = new GestureLine();
            newLine.closedLine = _line.closedLine;
            
            for (var p = 0; p < array_length(_line.points); p++) {
                var pt = _line.points[p];
                // PointToNormalized logic
                var nx = (pt.x - rect.x) / rect.width;
                var ny = (pt.y - rect.y) / rect.height;
                array_push(newLine.points, new Vector2(nx, ny));
            }
            array_push(result.lines, newLine);
        }
        return result;
    }
    
    static NormalizeDistribution = function(_data, _n) {
        // If passed a list of points (overload simulation)
        if (is_array(_data)) {
            var path = _data;
            var realPos = [0];
            
            for (var i = 1; i < array_length(path); i++) {
                var dist = Vector2.Distance(path[i-1], path[i]);
                array_push(realPos, realPos[i-1] + dist);
            }
            
            var totalDist = realPos[array_length(realPos)-1];
            // Avoid division by zero
            if (totalDist == 0) totalDist = 0.0001; 
            
            var normPos = [];
            for(var k=0; k<array_length(realPos); k++) array_push(normPos, realPos[k] / totalDist);
            
            var resultPoints = [];
            for (var ti = 0; ti <= _n; ti++) {
                var t = ti / _n;
                array_push(resultPoints, FindByNormalized(path, normPos, t));
            }
            return resultPoints;
        }
        
        // If passed GestureData
        var result = new GestureData();
        for (var i = 0; i < array_length(_data.lines); i++) {
            var _line = _data.lines[i];
            var newLine = new GestureLine();
            newLine.points = NormalizeDistribution(_line.points, _n); // Recursive call
            newLine.closedLine = _line.closedLine;
            array_push(result.lines, newLine);
        }
        return result;
    }
    
    static FindByNormalized = function(_vs, _ts, _t) {
        var count = array_length(_ts);
        for (var i = 0; i < count - 1; i++) {
            var t1 = _ts[i];
            var t2 = _ts[i+1];
            if (t1 <= _t && _t <= t2) {
                var v1 = _vs[i];
                var v2 = _vs[i+1];
                // Inverse Lerp
                var tt = (_t - t1) / (t2 - t1);
                return Vector2.Lerp(v1, v2, tt);
            }
        }
        return (_t > 0.5) ? _vs[count-1] : _vs[0];
    }
    
    static CalcRect = function(_data) {
        if (array_length(_data.lines) == 0 || array_length(_data.lines[0].points) == 0) return {x:0, y:0, width:1, height:1};
        
        var minx = _data.lines[0].points[0].x;
        var maxx = minx;
        var miny = _data.lines[0].points[0].y;
        var maxy = miny;
        
        for (var j = 0; j < array_length(_data.lines); j++) {
            var pts = _data.lines[j].points;
            for (var i = 0; i < array_length(pts); i++) {
                var p = pts[i];
                minx = min(minx, p.x);
                maxx = max(maxx, p.x);
                miny = min(miny, p.y);
                maxy = max(maxy, p.y);
            }
        }
        
        // Make Square
        var w = maxx - minx;
        var h = maxy - miny;
        var rectSize = max(w, h);
        var cx = minx + w/2;
        var cy = miny + h/2;
        
        return {
            x: cx - rectSize/2,
            y: cy - rectSize/2,
            width: rectSize,
            height: rectSize
        };
    }

    // --- PATTERN MATCHING ---
    static findPattern = function(queryData, normalizeScale) {
        var bestGesture = undefined;
        var bestScoreObj = (new Score()).MaxDistance();
        
        // Generate indexes [0, 1, 2...]
        var indexes = [];
        for(var i=0; i<array_length(queryData.lines); i++) array_push(indexes, i);
        
        var permutIndexes = GenPermutations(indexes);
        var permutations = [];
        
        for(var i=0; i<array_length(permutIndexes); i++) {
             array_push(permutations, makePermutation(permutIndexes[i], queryData));   
        }
        
        var singlePermutation = [permutations[0]]; // Just the original order
        
        // Search
        var result = SearchThroughPatterns(0, array_length(patterns)-1, queryData, normalizeScale, permutations, singlePermutation);
        
        if (result._score.get_final_score() > bestScoreObj.get_final_score()) {
             // Logic Check: The original code does > but initializes with MaxDistance.
             // Usually Distance means lower is better, but the Score property 
             // in C# inverts it (1 - dist). So Higher Score is indeed better.
             // However, bestScoreObj is initialized with Max float values, resulting in score 0.
             // So this comparison is valid.
             bestScoreObj = result._score;
             bestGesture = result.gesture;
        }
        
        var finalRes = new RecognitionResult();
        finalRes.gesture = bestGesture;
        finalRes._score = bestScoreObj;
        return finalRes;
    }
    
    static SearchThroughPatterns = function(beginIndex, endIndex, queryData, normalizeScale, permutations, singlePermutation) {
        var bestGesture = undefined;
        var bestScoreObj = (new Score()).MaxDistance(); // Score 0
        
        for (var i = beginIndex; i <= endIndex; i++) {
            var gestureAsset = patterns[i];
            
            // NOTE: In GML, you should cache the normalized data inside the pattern 
            // to avoid re-calculating it every frame.
            var assetData = NormalizeData(gestureAsset.gesture, normalizeScale);
            
            if (array_length(assetData.lines) != array_length(queryData.lines)) continue;
            
            var permutationsToLook = gestureAsset.useLinesOrder ? singlePermutation : permutations;
            
            for (var k = 0; k < array_length(permutationsToLook); k++) {
                var data = permutationsToLook[k];
                var permutScore = CalcScore(data, assetData, gestureAsset.useLinesDirections);
                
                if (permutScore.get_final_score() > bestScoreObj.get_final_score()) {
                    bestScoreObj = permutScore;
                    bestGesture = gestureAsset;
                }
            }
        }
        
        var res = new RecognitionResult();
        res.gesture = bestGesture;
        res._score = bestScoreObj;
        return res;
    }
    
    // --- SCORING MATH ---
    static CalcScore = function(data1, data2, useLinesDirections) {
        if (array_length(data1.lines) == array_length(data2.lines)) {
            var lineScores = [];
            
            for(var i=0; i<array_length(data1.lines); i++) {
                var line1 = data1.lines[i].points;
                var line2Fwd = data2.lines[i].points;
                
                var scoreFwd = CalcListScore(line1, line2Fwd, data2.lines[i].closedLine);
                
                if (useLinesDirections) {
                    array_push(lineScores, scoreFwd);   
                } else {
                    // Backward
                    var line2Bwd = [];
                    // Reverse Copy
                    for(var r=array_length(line2Fwd)-1; r>=0; r--) array_push(line2Bwd, line2Fwd[r]);
                    
                    var scoreBwd = CalcListScore(line1, line2Bwd, data2.lines[i].closedLine);
                    
                    if (scoreFwd.get_final_score() > scoreBwd.get_final_score()) {
                        array_push(lineScores, scoreFwd);
                    } else {
                        array_push(lineScores, scoreBwd);
                    }
                }
            }
            
            // Average
            var finalScore = new Score();
            var sumPos = 0, sumAng = 0, sumCurv = 0;
            var count = array_length(lineScores);
            
            for(var i=0; i<count; i++) {
                sumPos += lineScores[i].positionDistance;
                sumAng += lineScores[i].angleDistance;
                sumCurv += lineScores[i].curvatureDistance;
            }
            
            if (count > 0) {
                finalScore.positionDistance = sumPos / count;
                finalScore.angleDistance = sumAng / count;
                finalScore.curvatureDistance = sumCurv / count;
            }
            return finalScore;
        } else {
             return (new Score()).MaxDistance();   
        }
    }
    
    static CalcListScore = function(points1, points2, points2IsClosed) {
        if (points2IsClosed) {
            // Circular list logic
             var points2Offset = [];
             var maxScore = (new Score()).MaxDistance(); // Score 0
             var count = array_length(points2);
             
             for(var offset = 0; offset < count; offset++) {
                 points2Offset = [];
                 for (var i = 0; i < count; i++) {
                     array_push(points2Offset, points2[(i + offset) % count]);   
                 }
                 
                 var sc = CalcLinearListScore(points1, points2Offset);
                 if (sc.get_final_score() > maxScore.get_final_score() || offset == 0) {
                     maxScore = sc;
                 }
             }
             return maxScore;
        } else {
            return CalcLinearListScore(points1, points2);   
        }
    }
    
    static CalcLinearListScore = function(points1, points2) {
        var s = new Score();
        s.positionDistance = CalcPositionDistance(points1, points2);
        s.curvatureDistance = CalcCurvatureDistance(points1, points2);
        s.angleDistance = CalcAngleDistance(points1, points2);
        return s;
    }
    
    static CalcPositionDistance = function(p1, p2) {
        var sqrt2 = 1.41421356;
        var sumDist = 0;
        var n = array_length(p1); // Assumes p1 and p2 same length due to normalization
        
        for(var i=0; i<n; i++) {
            var dist = Vector2.Distance(p1[i], p2[i]) / sqrt2;
            sumDist += dist;
        }
        return sumDist;
    }
    
    static CalcAngleDistance = function(p1, p2) {
        var a1 = CalcAngles(p1);
        var a2 = CalcAngles(p2);
        var sum = 0;
        var n = array_length(p1);
        for(var i=0; i<n; i++) {
            var diff = abs(angle_difference(a1[i], a2[i])) / 360.0;
            sum += diff;
        }
        return sum;
    }
    
    static CalcCurvatureDistance = function(p1, p2) {
        var c1 = CalcCurvature(p1);
        var c2 = CalcCurvature(p2);
        var sum = 0;
        var n = array_length(p1);
        for(var i=0; i<n; i++) {
            var diff = abs(c1[i] - c2[i]) / 360.0;
            sum += diff;
        }
        return sum;
    }
    
    static CalcAngles = function(points) {
        var step = 10;
        var result = [];
        var count = array_length(points);
        for(var i=0; i<count; i++) {
             var i1 = max(i - step, 0);
             var i2 = min(i + step, count - 1);
             var v1 = points[i1];
             var v2 = points[i2];
             // point_direction returns degrees 0-360
             var ang = point_direction(v1.x, v1.y, v2.x, v2.y);
             array_push(result, ang);
        }
        return result;
    }
    
    static CalcCurvature = function(points) {
        var step = 10;
        var result = [];
        var count = array_length(points);
        
        // Pad start
        for(var i=0; i<step; i++) array_push(result, 0);
        
        for(var i=step; i<count-step; i++) {
            var p1 = points[i-step];
            var p2 = points[i];
            var p3 = points[i+step];
            
            var ang1 = point_direction(p1.x, p1.y, p2.x, p2.y);
            var ang2 = point_direction(p2.x, p2.y, p3.x, p3.y);
            var delta = angle_difference(ang1, ang2); // Returns range -180 to 180
            array_push(result, delta);
        }
        
        // Pad end
        for(var i=0; i<step; i++) array_push(result, 0);
        
        return result;
    }

    // --- UTILITIES ---
    static GenPermutations = function(list, low = 0) {
        // Recursive permutation
        var result = [];
        var count = array_length(list);
        
        if (low + 1 >= count) {
            var copy = [];
            array_copy(copy, 0, list, 0, count);
            array_push(result, copy);
            return result;
        }
        
        var subPerms = GenPermutations(list, low + 1);
        for(var i=0; i<array_length(subPerms); i++) array_push(result, subPerms[i]);
        
        for (var i = low + 1; i < count; i++) {
            // Swap
            var temp = list[low]; list[low] = list[i]; list[i] = temp;
            
            var swappedSub = GenPermutations(list, low + 1);
            for(var k=0; k<array_length(swappedSub); k++) array_push(result, swappedSub[k]);
            
            // Swap back
            temp = list[low]; list[low] = list[i]; list[i] = temp;
        }
        return result;
    }
    
    static makePermutation = function(indexes, data) {
        var newData = new GestureData();
        for(var i=0; i<array_length(indexes); i++) {
            array_push(newData.lines, data.lines[indexes[i]]);
        }
        return newData;
    }
}