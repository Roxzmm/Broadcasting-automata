globals [
  lattice   ;; only those patches where both pxcor and pycor are even
]


to setup
  clear-all
  set lattice patches with [pxcor mod 2 = 0 and pycor mod 2 = 0]
  if count lattice != count patches / 4
    [ user-message "The world size must be even in both dimensions."
      stop ]
  ask patches
    [ set pcolor white ]
  ask patches
    [ if random-float 100 < density
        [ set pcolor black ] ]
  reset-ticks
end

to go
  ask lattice [ do-rule  1 ]  ;; propagation
  ask lattice [ do-rule -1 ]  ;; collision
  tick
end

to go-reverse  ;; applying rules to the lattice in reverse order reverses the system
  ask lattice [ do-rule -1 ]  ;; collision
  ask lattice [ do-rule  1 ]  ;; propagation
  tick
end

;; grid = 1 if even lattice, grid = -1 if odd lattice
to do-rule [grid]
  let a self
  let b patch-at (- grid) 0
  let c patch-at 0 grid
  let d patch-at (- grid) grid

  ifelse ([pcolor] of a) != ([pcolor] of b) and
         ([pcolor] of c) != ([pcolor] of d)
    [ swap-pcolor a b
      swap-pcolor c d ]
    [ swap-pcolor a d
      swap-pcolor b c ]
end

to swap-pcolor [p1 p2]
  ask p1 [
    let temp pcolor
    set pcolor [pcolor] of p2
    ask p2 [ set pcolor temp ]
  ]
end

to draw-circle
  while [mouse-down?]
    [ ask patch mouse-xcor mouse-ycor
        [ ask patches in-radius radius
            [ set pcolor black ] ]
      display ]
end


; Copyright 2002 Uri Wilensky.
; See Info tab for full copyright and license.