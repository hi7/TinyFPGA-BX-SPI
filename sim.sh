#!/bin/bash
set -euo pipefail

echo "Simulate top.v icarus verilog"
iverilog -o top_tb.vvp top_tb.v
vvp top_tb.vvp

#echo "open GTKWave"
gtkwave top_tb.vcd
