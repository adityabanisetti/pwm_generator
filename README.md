
# 8-Bit Digital PWM Generator in Verilog

A high-performance, synthesis-ready 8-bit Pulse Width Modulation (PWM) generator implemented in Verilog HDL. This repository contains the structural RTL design architecture, verification testbenches, mathematical models, and deployment configurations optimized for open-source simulation toolchains and hardware synthesis platforms.

---

## 📖 Theoretical Overview & Concept

Digital integrated circuits switch natively between binary rails: Ground ($0\text{V}$) or Supply Voltage ($V_{CC}$). To bridge the digital-to-analog boundary—allowing precise variable output properties like dimming a physical LED or throttling a DC motor's velocity—we leverage **Pulse Width Modulation (PWM)**. 

By cycling a digital output pin at high frequencies, the targeted inductive or capacitive physical load acts as a hardware **low-pass filter**, responding smoothly to the integrated **Average Voltage** ($V_{\text{avg}}$) across the operational timeline.

### 📐 Mathematical Formalism
The average voltage is derived by integrating the voltage function over one complete period:

$$V_{\text{avg}} = \frac{1}{T} \int_{0}^{T} V(t) \, dt = \frac{T_{\text{on}}}{T_{\text{on}} + T_{\text{off}}} \times V_{CC}$$

Because the ratio $\frac{T_{\text{on}}}{T}$ represents the exact mathematical definition of the **Duty Cycle ($D$)**, the calculation simplifies to:

$$V_{\text{avg}} = D \times V_{CC}$$

### Duty Cycle Profile Matrices
* **0% Duty Cycle:** Constant flat logic `LOW` ($0\text{V}$ steady state average).
* **25% Duty Cycle:** Active for $1/4$ of the period; delivers $0.25 \times V_{CC}$ average energy.
* **50% Duty Cycle:** Symmetrical square wave; active for exactly half the period duration.
* **75% Duty Cycle:** Active for $3/4$ of the period; delivers $0.75 \times V_{CC}$ average energy.
* **100% Duty Cycle:** Constant flat logic `HIGH` (Continuous $V_{CC}$ steady state).

---

## 🏗️ Hardware Architecture & System Clock Math

The module implements an 8-bit quantization metric, yielding $2^8 = 256$ discrete, highly reproducible duty cycle intervals (mapped smoothly via integer inputs from `0` to `255`).

### Functional Sub-Blocks
1. **8-Bit Synchronous Counter:** A sequential phase tracking accumulator tracking system clock rising edges (`clk`). Upon crossing its boundary limit (`8'hFF`), it inherently overflows back to `8'h00`, setting the static baseline period frequency of the modulated square wave.
2. **Behavioral Comparator:** A fast combinational evaluation block checking real-time counter positioning relative to the configuration `duty` input vector:
   * If $\text{Counter} < \text{Duty} \rightarrow$ `pwm_out` asserts `1'b1`
   * If $\text{Counter} \ge \text{Duty} \rightarrow$ `pwm_out` drops to `1'b0`
