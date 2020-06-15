globals [
  spoints
  iterations
  num-spoints
  chaincodes
  radius2
  cachespoints
  t0-activepoints
  t1-activepoints
]

breed [ cells cell ]
breed [ dots dot ]

dots-own [cell-index values amplitudes t1-amplitudes t2-amplitudes neighbor-dots msg-radius isobstacle?]

to setup
  clear-all

  resize-world 0 width 0 height
  set-patch-size unit-size

  ;; customized variables
  set cachespoints []
  set spoints []
  set iterations 1

  ;; setting for adding spoints and radius
  set num-spoints 2
  set radius2 [ 4.1 4.1 ]

  set t0-activepoints n-values num-spoints [[]]
  set t1-activepoints n-values num-spoints [[]]

  set chaincodes n-values num-spoints [[0]]
  ;; setting for chaincodes
  set chaincodes replace-item 0 chaincodes ["0" "1" "2" "3" "4" "5"]
  set chaincodes replace-item 1 chaincodes ["0" "1" "2" "3" "4" "5"]

;  set chaincodes replace-item 0 chaincodes ["a" "b"]
;  set chaincodes replace-item 1 chaincodes ["c" "d" "e"]

;  set chaincodes replace-item 0 chaincodes ["0" "1" "2" "3" "4" "5" "6"]
;  set chaincodes replace-item 1 chaincodes ["0" "1" "2" "3" "4" "5" "6"]

;  set chaincodes replace-item 0 chaincodes ["0" "1" "2" "3"]
;  set chaincodes replace-item 1 chaincodes ["0" "1" "2" "3"]

  ;; generate grids
  ask patches [ set pcolor white ]
  create-ordered-cells ((ceiling (height / (sqrt 3 / 2))) * width)
  ask cells [
    let row (floor (who / width))

    ifelse row mod 2 = 0
    [ setxy (who mod width) (row * (sqrt 3 / 2)) ]
    [ setxy ((who mod width) + 0.5) (row * (sqrt 3 / 2)) ]

    set color white
    set size 1.1
    set shape "hexagon"

    let tempindex who
    hatch-dots 1 [
      set color black
      set size 0.2
      set shape "circle"
      set cell-index tempindex
    ]
  ]

  ask dots [
    set values n-values num-spoints [0]
    set amplitudes n-values num-spoints [0]
    set t1-amplitudes n-values num-spoints [0]
    set t2-amplitudes n-values num-spoints [0]

    let tempneighbors []
    ask dots with [ distance myself <= 1.1 and distance myself > 0 ] [
      set tempneighbors (lput self tempneighbors)
    ]
    set neighbor-dots turtles with [member? self tempneighbors]
    set msg-radius radius2
    set isobstacle? false
  ]

  reset-ticks

  ;; setting for adding spoints manually
;  add-spoint-manually 50 75
;  add-spoint-manually 100 75
end

;; construct obstacles to stop broadcasting
to draw-obstacles
  while [ mouse-down? ]
  [ let selected (one-of dots with [ distancexy mouse-xcor mouse-ycor < 0.2 ])
    if selected != nobody [ ask selected  [
      set isobstacle? true
      ask cell cell-index [ set color black ]
      paint self

      foreach t0-activepoints [
        x -> if (position self x != false) [
        set t0-activepoints remove-item (position self x) x
        ]
      ]
    ]]
    display ]
end

;; add starting points to the lattice network (support add two automata to the same point)
to add-spoint
  while [ mouse-down? ]
  [
    let selected (one-of dots with [ distancexy mouse-xcor mouse-ycor < 0.2 ])
    if selected != nobody [
      ask selected [
        set color red
        set size 0.5]
      set cachespoints (lput selected cachespoints)
      set cachespoints remove-duplicates cachespoints]
  ]
  if length(cachespoints) = 1 [
    set spoints (lput item 0 cachespoints spoints)

    let tempindex (position (item 0 cachespoints) spoints)
    ask item 0 cachespoints [
      assign-message tempindex (last (item tempindex chaincodes))
      paint self
    ]

    let templist item tempindex t0-activepoints
      set templist (lput (item 0 cachespoints) templist)
      set t0-activepoints replace-item tempindex t0-activepoints templist

    set cachespoints []
    display
  ]
end

to add-spoint-manually [ mxcor mycor ]
  if (num-spoints != 0) [
    let selected one-of dots with [ distancexy mxcor mycor < 0.2]
    if selected != nobody [
      ask selected [
        set color red
        set size 0.5]
      set cachespoints (lput selected cachespoints)
      set cachespoints remove-duplicates cachespoints]

    if length(cachespoints) = 1 [
      set spoints (lput item 0 cachespoints spoints)

      let tempindex (position (item 0 cachespoints) spoints)
      ask item 0 cachespoints [
        assign-message tempindex (last (item tempindex chaincodes))
        paint self
      ]

      let templist item tempindex t0-activepoints
      set templist (lput (item 0 cachespoints) templist)
      set t0-activepoints replace-item tempindex t0-activepoints templist

      set cachespoints []

      set num-spoints (num-spoints - 1)
      display
    ]
  ]
end

;; apply painting algorithm
to paint [ selecteddot ]
  ask selecteddot [

    ; customized painting function
;    let tempcolor white
;    if  item 0 values = "0" [ set tempcolor red ]
;    if  item 0 values = "1" [ set tempcolor yellow ]
;    if  item 0 values = "2" [ set tempcolor green ]
;    if  item 0 values = "3" [ set tempcolor lime ]
;    if  item 0 values = "1" [ set tempcolor red ]
;    if  item 0 values = "2" [ set tempcolor red ]
;    if  item 0 values = "3" [ set tempcolor red ]

;    if  item 0 values = "a" [ set tempcolor blue ]
;    if  item 0 values = "b" [ set tempcolor brown ]
;    if  item 1 values = "c" [ set tempcolor red ]
;    if  item 1 values = "d" [ set tempcolor yellow ]
;    if  item 1 values = "e" [ set tempcolor green ]
;    if  item 0 values = "a" and item 1 values = "c" [ set tempcolor lime ]
;    if  item 0 values = "a" and item 1 values = "d" [ set tempcolor cyan ]
;    if  item 0 values = "a" and item 1 values = "e" [ set tempcolor sky ]
;    if  item 0 values = "b" and item 1 values = "c" [ set tempcolor pink ]
;    if  item 0 values = "b" and item 1 values = "d" [ set tempcolor violet ]
;    if  item 0 values = "b" and item 1 values = "e" [ set tempcolor magenta ]

    let tempcolor red
    if position "0" values != false and position "2" values != false [ set tempcolor green ]
    if position "0" values != false and position "3" values != false [ set tempcolor green ]
    if position "1" values != false and position "4" values != false [ set tempcolor green ]
    if position "2" values != false and position "5" values != false [ set tempcolor green ]
    if position "3" values != false and position "5" values != false [ set tempcolor green ]
    if position "4" values != false and position "4" values != false [ set tempcolor green ]
    if position "1" values != false and position "1" values != false [ set tempcolor green ]
    if position "0" values != false and position "0" values != false [ set tempcolor blue ]
    if position "0" values != false and position "1" values != false [ set tempcolor blue ]
    if position "0" values != false and position "4" values != false [ set tempcolor blue ]
    if position "0" values != false and position "5" values != false [ set tempcolor blue ]
    if position "1" values != false and position "5" values != false [ set tempcolor blue ]
    if position "4" values != false and position "5" values != false [ set tempcolor blue ]
    if position "5" values != false and position "5" values != false [ set tempcolor blue ]

;    let tempcolor red
;    if position "0" values != false and position "1" values != false [ set tempcolor yellow ]
;    if position "0" values != false and position "2" values != false [ set tempcolor yellow ]
;    if position "1" values != false and position "1" values != false [ set tempcolor yellow ]
;    if position "2" values != false and position "3" values != false [ set tempcolor yellow ]
;    if position "3" values != false and position "3" values != false [ set tempcolor yellow ]

    if (isobstacle? = true) [
      set tempcolor black
    ]

    set color tempcolor
    ask cell cell-index [
        set color tempcolor ]]
end

;; rule for automata to broadcast messages
to broadcast [ index centerpoint ]
  if (item index values != 0)[
    let radii item index msg-radius
    set radii sqrt(radii)

    let temppoints []
    ask dots with [ distance centerpoint <= radii ] [
      if (isobstacle? = false) [
        set temppoints (lput self temppoints)

        set amplitudes n-values length(spoints) [0]
        set t1-amplitudes n-values length(spoints) [0]
        set t2-amplitudes n-values length(spoints) [0]
      ]
    ]
    set temppoints remove-duplicates temppoints

    ask centerpoint [set t1-amplitudes replace-item 0 t1-amplitudes -10]
    let msg (item index values)
    let count-update (ceiling radii + 1)
    repeat count-update [
      foreach temppoints [ x -> ask x [update-amplitudes index msg] ]
      foreach temppoints [ x -> ask x [set t2-amplitudes t1-amplitudes] ]
      foreach temppoints [ x -> ask x [set t1-amplitudes amplitudes] ]
    ]
    let templist item index t1-activepoints
    set templist remove-duplicates templist
    set t1-activepoints replace-item index t1-activepoints templist
  ]
end

;; apply chain codes (chaincodes must be stored as list)
;; all startpoints must start at the same time
to assign-message [ index msg ]
  let num length(item index chaincodes)
  let msgindex (position msg (item index chaincodes))
  set msgindex (msgindex + 1)
  if (msgindex = length(item index chaincodes)) [
    set msgindex 0
  ]
  let code item msgindex (item index chaincodes)
  set values replace-item index values code
end

to update-amplitudes [ index msg ]
  let result ((sum [item 0 t1-amplitudes] of neighbor-dots) / 2 - (item 0 t2-amplitudes))
  set amplitudes replace-item 0 amplitudes result
  if (result != 0) [

    if (item index values = 0) [

      let templist item index t1-activepoints
      set templist (lput self templist)
      set t1-activepoints replace-item index t1-activepoints templist

      assign-message index msg
      paint self
    ]
  ]
end

to go
;  let temp 0
;  repeat length(spoints) [
  foreach t0-activepoints [ x ->
    foreach x [
      y -> ask y [ broadcast (position x t0-activepoints) y ]
    ]
;      broadcast temp x
  ]

;    set temp (temp + 1)
;  ]
  set t0-activepoints t1-activepoints
  set t1-activepoints n-values length(spoints) [[]]

;  ask dots [update-amplitudes]
;  ask dots [set t2-amplitudes t1-amplitudes]
;  ask dots [set t1-amplitudes amplitudes]

;  foreach spoints [ x -> broadcast x ]
;
;  set iterations (iterations + 1)
  tick
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
1034
835
-1
-1
16.0
1
10
1
1
1
0
0
0
1
0
50
0
50
1
1
1
ticks
30.0

BUTTON
18
272
81
305
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
60
316
138
349
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
12
125
184
158
height
height
4
200
50.0
1
1
NIL
HORIZONTAL

SLIDER
15
172
187
205
width
width
4
200
50.0
1
1
NIL
HORIZONTAL

SLIDER
15
215
187
248
unit-size
unit-size
1
100
16.0
1
1
NIL
HORIZONTAL

BUTTON
29
360
162
393
add-spoint
if num-spoints > 0 [\n  let temp length(spoints)\n  add-spoint \n\n  if temp < length(spoints)[\n    set num-spoints (num-spoints - 1)]]\n\nif num-spoints = 0 [ stop ]
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
95
272
191
305
go-once
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
19
406
180
439
NIL
draw-obstacles
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

hex
false
0
Polygon -7500403 true true 0 150 75 30 225 30 300 150 225 270 75 270

hexagon
false
0
Polygon -7500403 true true 148 300 15 225 15 75 148 0 283 75 283 225

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.4
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
