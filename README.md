# Discrete System Properties Analysis in MATLAB

This repository contains a MATLAB project developed for the "Signals and Systems" course. It implements a discrete-time system that models a **Signal Power Detector** (Moving Average of Squares).

## System Description
The system is defined by the following difference equation:
`y[n] = 0.5 * x[n]^2 + 0.5 * x[n-1]^2`

It calculates the average power between the current and the previous sample, introducing a non-linear effect with memory.

## Features
- **Manual Implementation:** The system logic is implemented using standard loops without relying on MATLAB's built-in system toolboxes.
- **Linearity Check:** Demonstrates numerically and graphically that the system is **Non-Linear** (due to the quadratic term).
- **Time-Invariance Check:** Demonstrates that the system is **Time-Invariant** (parameters do not change over time).
- **Visualization:** Includes clean plots comparing input/output signals and error metrics.

## Requirements
- MATLAB R2025b (or newer)
