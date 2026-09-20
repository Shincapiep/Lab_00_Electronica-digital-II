# Laboratorio 00: Introducción a Verilog, Simulación y Máquinas de Estados Finitos (FSM)
**Asignatura:** Electrónica Digital II  
**Semestre:** 2026-2  

---

##  Integrantes del Equipo
- **Samuel Hincapie Perilla**
- **Eduardo Felipe Camacho Lara**
- **Gabriel Alberto Rodríguez Rincón**

---

##  Introducción y Entorno de Trabajo

Para el desarrollo de esta práctica se configuró un entorno de simulación ligero compuesto por:
- **Icarus Verilog (`iverilog`):** Compilador y simulador HDL.
- **GTKWave:** Visualizador de ondas en formato VCD (`.vcd`).
- **Visual Studio Code:** Editor de código base.

---

## Ejercicio 0: Smoke Test

### 1. Objetivo Del Ejercicio:
- Validar la correcta instalación y funcionamiento del software instalado previamente: Visual Studio Code, Icarus Verilog (`iverilog`) y GTKWave.
- Compilar y simular un módulo combinacional básico en Verilog para confirmar la generación del archivo `.vcd`.
- Inspeccionar y verificar el comportamiento temporal de las señales lógicas en el visor de ondas GTKWave.

### 2. Procedimiento Experimental:
Lo primero que se hizo para comenzar con la práctica fue descargar los archivos `smoke_andor.v` y `tb_smoke_andor.v` del repositorio de Github de la clase. Luego estos fueron abiertos y revisados en el entorno de desarrollo Visual Studio Code. La función de cada uno es la siguiente:
- `smoke_andor.v`: Módulo que implementa la lógica combinacional de las compuertas AND, OR y XOR.
- `tb_smoke_andor.v`: Banco de pruebas (Testbench) encargado de instanciar el módulo principal, aplicar los estímulos de entrada y generar el archivo `.vcd`.


Para ello se utilizó la terminal de Visual Studio Code, donde se ejecutó la compilación del código mediante el ejecutable de Icarus Verilog (iverilog) especificando el nombre del archivo de salida compilado (tb_smoke_andor.vvp):
```bash
iverilog -o tb_smoke_andor.vvp tb_smoke_andor.v
```
A continuación, se ejecutó el motor de simulación vvp para procesar el binario y generar el archivo `.vcd` correspondiente:
```bash
vvp tb_smoke_andor.vvp
```
Se abrió la herramienta GTKWave y se cargó el archivo de simulación .vcd generado.
```bash
gtkwave
```

### 3. Simulación Virtual en GTKwave:
En la siguiente imágen se observa el resultado de la simulación en gtkwave:

<img width="916" height="191" alt="image" src="https://github.com/user-attachments/assets/3b4dbbb2-3cd9-4f7c-8377-c3044922d19f" />


Como se puede ver en la imagen anterior, el comportamiento de la prueba fue el esperado, ya que las salidas generadas concuerdan exactamente con el funcionamiento de las funciones lógicas AND, OR y XOR.
- Comportamiento AND (`y_and`): Su valor es 1 únicamente en el intervalo de 30 ns a 40 ns cuando ambas entradas están activas.
- Comportamiento OR (`y_or`): Su valor es 1 únicamente en el intervalo de 10 ns a 40 ns cuando al menos una de las dos entradas están activas.
- Comportamiento xor (`y_xor`): Su valor es 1 únicamente en el intervalo de 10 ns a 30 ns cuando ambas entradas tienen valores diferentes entre si.

---

##  Ejercicio 1: FSM de Control – Semáforo Simple

### 1.1 Planteamiento del Diseño:
Para este ejercicio se diseñó un controlador de un semáforo simple mediante una Máquina de Estados Finitos (FSM) tipo Moore. Pero antes de continuar, se debe mencionar un cambio realizado en el ejercicio original. Dado que en los sistemas de tránsito reales el ciclo de transición de un semáforo no pasa directamente de Rojo a Verde. Se ha añadido una segunda fase de Luz Amarilla para advertir a los conductores el cambio de luz roja a luz verde.

El sistema cuenta con un contador interno que controla la permanencia en cada estado según la cantidad requerida de periodos de reloj ($T_{clk} = 10\text{ ns}$). El ciclo secuencial completo consta de 4 estados y una duración total de 13 ciclos de reloj:

- **`S_Verde` ($S_0$ - Luz Verde):** Dura 5 ciclos de reloj.
- **`S_Amarillo1` ($S_1$ - Luz Amarilla 1):** Dura 2 ciclos de reloj (Transición hacia Rojo).
- **`S_Rojo` ($S_2$ - Luz Roja):** Dura 4 ciclos de reloj.
- **`S_Amarillo2` ($S_3$ - Luz Amarilla 2):** Dura 2 ciclos de reloj (Transición hacia Verde).

### 1.2 Máquina de estados (FSM):
Dado que ya se identificaron los estados y duraciones necesarios para diseñar la maquina de estados de este ejercicio, solo falta elegir las entradas y salidas necesarias. Estas son:

- **Entradas:** `clk` (reloj del sistema) y `reset`.
- **Salidas:** `verde`, `amarillo` y `rojo`.

La maquina de estados diseñada se muestra a continuación:

<img width="815" height="571" alt="image" src="https://github.com/user-attachments/assets/7d678e04-dc9c-49a7-ac66-7d6fd61dea3a" />

### 1.3 Resultados de Simulación y Análisis (GTKWave)

Para la verificación se ejecutó el comando de compilación y visualización:
```bash
iverilog -o tb_semaforo.vvp semaforo.v tb_semaforo.v
vvp tb_semaforo.vvp
gtkwave semaforo.vcd
```
En la siguiente imágen se observa el resultado de la simulación en gtkwave.

![Simulación Semáforo en GTKWave](Lab00/semaforogtk.png)

---

## Ejercicio 2: Acumulador Secuencial

### 1. Descripción del Diseño
Se implementó un acumulador secuencial síncrono controlado por una FSM. El sistema recibe una entrada de 4 bits ($x$) y un pulso de inicio (`start`). La acumulación se ejecuta ciclo a ciclo hasta alcanzar la condición límite parametrizada.

* **Parámetros y Entradas:** 
  - Entradas: `clk`, `rst`, `start`, `x[3:0]`.
  - Salidas: `acc[5:0]` (acumulador de 6 bits), `done` (bandera de finalización).
* **Variante Seleccionada (`VARIANTE = 3`):** Acumular $x$ de manera iterativa hasta que la suma alcance o supere el valor de 20 (`acc >= 20`).

---

### 2. Máquina de Estados y Datapath

El sistema combina una unidad de control FSM y una ruta de datos:

* **`IDLE` (`2'b00`):** Estado de reposo. Al detectar `start = 1`, carga la primera entrada en `acc` (`acc <= x`), inicializa el contador (`count <= 1`) y pasa a `ADD`.
* **`ADD` (`2'b01`):** Suma incrementalmente `acc <= acc + x` en cada flanco de subida. Mantiene la iteración mientras `acc < 20`. Al evaluar `acc >= 20`, transiciona a `DONE`.
* **`DONE` (`2'b10`):** Emite la señal `done = 1` confirmando el fin del procesamiento y regresa a `IDLE`.
  

#### 2.1 Identificacion de entradas y salidas FSM + datapath

Para llevar a cabo el sistena, es necesario utilizar un registro que se encargue de guardar el valor que va acumulando `acc`, además de utilizar un sumador para realizar la operción respectiva. por otro lado, para las funciones de contar 3 y 4 veces se utilizará un contador que permita determinar el numero de cuenta realizada y por ultimo se usa un comparador para analizar el camino de datos.

![Diagrama de Caja negra](Lab00/ImagenesAcc/Entradas%20y%20salidas%20Acc.png)

Las entradas de la FSM de ña unidad de control son:
- CLK : permite cambiar entre estados dependiendo de su duración
- Start: Es el boton que activa la secuencia
- rst: Diferente al boton de rst del acumulador, se encarga de resetear solo la FSM devolviendola al estado inicial $S_0$
- OutComp: permite analizar la condiion deseada

Conexiones datapath:
- El sumador tiene sus dos entradas (sumandos) y la salida (suma), el sumador tiene la cantidad de bits necesaria para soportar la suma reequerida
- el registro de 6 bits `acc[5:0]` se encarga de almacenar el valor, con conexiones como `rstacc` responsable de resetearlo en cero y `Enacc` que funciona como habilitador para detener o empezar la suma, el cual será controlado por la  unidad de control.


#### 2.2 Construcción de la unidad de ccontrol FSM

Se muestra el diagrama de estados de la unidad de control, consta de 4 estados que controlan el datapath indetificado anterior mente para el caso numero 3 (acumula hasta 20), para simplificar la expresión de comparasion, en lugar de utilizar `acc >= 20`, se cambia por `acc < 20` manejando la lógica respectiva

![Diagrama de estados](Lab00/ImagenesAcc/Diagrama%20de%20estados%20Acc.png)


#### 2.3 Conexiones FSMD
Se establecen las conexiones que unen la unidad de control con el camino de datos presentando el flujo de conexiones del circuito digital para realizar el caso 3 del ejercicio. En este caso la maquina FSM es de tipología Moore


![Diagrama de estado](Lab00/ImagenesAcc/FSMD.png).

Nota: para los casos de contar 3 y 4 veces el numero `x` de la entrada se realiza un proceso similar utilizando el contador, para realizar un circuito con las tres funciones se utiliza un multiplexoor que permita seleccionar el tipo de funcion deseado.


### 3. Resultados de Simulación y Análisis (GTKWave)

Comandos ejecutados para la compilación y visualización:

```bash
iverilog -o acumulador.vvp acumulador.v tb_acumulador.v
vvp acumulador.vvp
gtkwave wave.vcd
```
Con el propósito de validar funcionalmente el comportamiento síncrono del acumulador y comprobar el correcto flujo de transiciones de la FSM, se ejecutó el entorno de simulación empleando Icarus Verilog y GTKWave. En la Figura se registran las formas de onda correspondientes a las señales principales del sistema (clk y acc ), donde se evidencia la acumulación progresiva en el tiempo.

Se escoge el valor `x = 1` y se desarrollan los respectivos casos 

- Para el caso número 1:

![Simulación Semáforo en GTKWave](Lab00/Acc1.png)

Se observa claramente como la variable de `acc` llega hasta 3 antes de caer a cero nuevamente, el contador ha hecho la suma de `x` tres veces

- Para el caso número 2:

![Simulación Semáforo en GTKWave](Lab00/Acc2.png).


La variable de `acc` llega hasta 4 antes de caer a cero nuevamente, el contador ha hecho la suma de `x` cuatro veces.


- Para el caso número 3:

![Simulación Semáforo en GTKWave](Lab00/Acc3.png)


la variable `acc` llega hasta 20 contando de uno en uno, se cumple la condición  `[acc < 20] = 0` o `[acc >= 20] = 1` por lo que la FSM pasa al estado $S_3$ volviendo nuevamente la salida a cero.
