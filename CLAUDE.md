# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Vanilla JS Tetris on HTML5 Canvas. No dependencies, no `package.json`, no build step, no tests, no linter. UI text and README are in Spanish — keep user-facing strings in Spanish.

## Running

```bash
open index.html                 # or serve statically:
python3 -m http.server 8000     # then http://localhost:8000
```

Verify changes by playing in the browser; there is no automated test suite.

## Architecture

All logic lives in `game.js` as a single classic script (`'use strict'`, no modules) loaded at the end of `index.html`. State is held in module-level `let` globals (`board`, `current`, `next`, `score`, `lines`, `level`, `paused`, `gameOver`, `dropInterval`, `animId`, …) and reset by `init()`, which is also the restart handler.

- **Color index = piece type.** `PIECES[type]` matrices store the type number (1–7) in filled cells, and `merge()` copies those values into `board`. So board cells, piece cells, and `COLORS[]` indices are all the same number — adding/reordering pieces requires keeping `PIECES` and `COLORS` aligned (index 0 is `null`/empty).
- **Collision** (`collide(shape, x, y)`) is the single source of truth for movement, rotation (`tryRotate` with kicks `[0,-1,1,-2,2]`), ghost projection (`ghostY`), drops, and game-over detection in `spawn()`. Cells with `y < 0` are allowed (above the board).
- **Piece lifecycle:** `lockPiece()` → `merge()` → `clearLines()` (updates score/lines/level/`dropInterval`) → `spawn()` (promotes `next` to `current`, may call `endGame()`).
- **Loop:** `requestAnimationFrame(loop)` accumulates `dt` into `dropAccum` and steps gravity when it exceeds `dropInterval`; `draw()` re-renders everything each frame. Pause/game-over stop the loop via `cancelAnimationFrame(animId)`; resuming resets `lastTime` before calling `loop` to avoid a large `dt`.
- **Overlay** (`#overlay`) is shared by PAUSA and GAME OVER states; its button always calls `init()`.

## Coupled values

`COLS × BLOCK` and `ROWS × BLOCK` must match the `<canvas id="board">` `width`/`height` in `index.html` (currently 300×600). The next-piece preview assumes a 4×4 grid of 30px cells matching `#next-canvas` (120×120).
