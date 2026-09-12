# Laboratorio 00: Introducción a Verilog, Simulación y Máquinas de Estados Finitos (FSM)
**Asignatura:** Electrónica Digital II  
**Semestre:** 2026-2  

---

##  Integrantes del Equipo
- **Samuel Hincapie Perilla**
- **Eduardo**
- **Gabriel**

---

##  Introducción y Entorno de Trabajo

Para el desarrollo de esta práctica se configuró un entorno de simulación ligero compuesto por:
- **Icarus Verilog (`iverilog`):** Compilador y simulador HDL.
- **GTKWave:** Visualizador de ondas en formato VCD (`.vcd`).
- **Visual Studio Code:** Editor de código base.

---

##  Ejercicio 1: FSM de Control – Semáforo Simple

### 1. Descripción del Diseño
Se implementó una Máquina de Estados Finitos (FSM) síncrona tipo Moore para controlar la secuencia cíclica de un semáforo vehicular de tres estados. 

El sistema cuenta con un contador interno que controla la permanencia en cada estado según la cantidad requerida de periodos de reloj ($T_{clk} = 10\text{ ns}$):
- **Estado $S_0$ (Verde):** Permanece 5 ciclos de reloj.
- **Estado $S_1$ (Amarillo):** Permanece 2 ciclos de reloj.
- **Estado $S_2$ (Rojo):** Permanece 4 ciclos de reloj.

Al completar el tiempo en el estado $S_2$, el sistema reinicia automáticamente el ciclo retornando al estado $S_0$.

### 2. Diagrama de estados
---

### 3. Resultados de Simulación y Análisis (GTKWave)

Para la verificación se ejecutó el comando de compilación y visualización:
```bash
iverilog -o tb_semaforo.vvp semaforo.v tb_semaforo.v
vvp tb_semaforo.vvp
gtkwave semaforo.vcd
```
En la siguiente imágen se observa el reusltado de la simulción en gtkwave.
