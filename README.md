# MIPS Battleship Board Placement

A MIPS assembly project for validating and placing five numbered ship shapes on a
two-dimensional Battleship board. The program stores the board as a row-major byte
array and works directly with memory addresses, registers, branches, and subroutine
calls.

## Features

- Clears a board of any configured width and height
- Converts row and column coordinates into byte offsets
- Detects occupied cells and coordinates outside the board
- Places seven provided ship shapes in as many as four orientations
- Validates each ship's type and orientation before modifying the board
- Clears the board if a ship overlaps another ship or extends beyond an edge
- Prints the numeric board through MIPS syscalls

Each ship is represented by four words:

```text
type, orientation, starting row, starting column
```

The five ships are written to the board with values `1` through `5`, making their
occupied cells easy to distinguish in the printed output.

## Main Routines

| Routine | Purpose |
|---|---|
| `zeroOut` | Sets every byte in the board to zero |
| `place_tile` | Places one ship value after checking bounds and occupancy |
| `placePieceOnBoard` | Selects a ship type and orientation and places all four cells |
| `test_fit` | Validates and attempts to place an array of five ships |
| `printBoard` | Prints the board one row at a time |

`place_tile` returns `0` after a successful placement, `1` for an occupied cell, and
`2` for an out-of-bounds coordinate. `test_fit` returns `4` when a ship has an invalid
type or orientation.

## Repository Structure

```text
hw5.asm             Completed board logic and public routines
skeleton.asm        Provided ship-shape placement cases
MarsFall2020.jar    Provided MARS simulator
tests/
  zero_test1.asm    Clears and prints a populated board
  print_test1.asm   Prints a sample board
  place_test1.asm   Places one cell on an empty board
  place_test5.asm   Exercises individual ship placement
  fit_test1.asm     Validates and places a five-ship configuration
```

## Running the Project

Java is required to launch the included MARS simulator:

```bash
java -jar MarsFall2020.jar
```

In MARS, open one of the files under `tests/`, assemble it, and run it. Run MARS from
the repository root so each test's `.include "hw5.asm"` directive resolves correctly.
The test programs print return values and board contents to the Run I/O window.

## Testing

The files under `tests/` are manual assembly drivers rather than an automated test
suite. Together they exercise board clearing, board output, cell placement, complete
ship placement, and five-ship validation. Their output must be inspected in MARS.

The bundled MARS version did not complete a headless command-line run in the current
environment, so the tests have not been rerun as part of this documentation update.

## Context

I completed this project individually for Stony Brook University's CSE 220 course.
The initial commit contains the MARS simulator, starter function stubs, ship-placement
skeleton, and test drivers provided for the assignment.

My work after the initial commit implemented the board-clearing, cell-placement,
printing, complete-ship placement, and five-ship validation routines in `hw5.asm`,
including the remaining T-shaped placement case. I also made small corrections to the
provided placement test inputs.
