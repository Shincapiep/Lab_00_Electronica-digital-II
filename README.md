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

### 1. Objetivo Del Ejercicio

- Validar la correcta instalación y funcionamiento del software instalado previamente: Visual Studio Code, Icarus Verilog (`iverilog`) y GTKWave.
- Compilar y simular un módulo combinacional básico en Verilog para confirmar la generación del archivo `.vcd`.
- Inspeccionar y verificar el comportamiento temporal de las señales lógicas en el visor de ondas GTKWave.

### 2. Procedimiento Experimental

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

### 3. Simulación Virtual en GTKwave

En la siguiente imágen se observa el resultado de la simulación en gtkwave:

<img width="916" height="191" alt="image" src="https://github.com/user-attachments/assets/3b4dbbb2-3cd9-4f7c-8377-c3044922d19f" />


Como se puede ver en la imagen anterior, el comportamiento de la prueba fue el esperado, ya que las salidas generadas concuerdan exactamente con el funcionamiento de las funciones lógicas AND, OR y XOR.
- Comportamiento AND (`y_and`): Su valor es 1 únicamente en el intervalo de 30 ns a 40 ns cuando ambas entradas están activas.
- Comportamiento OR (`y_or`): Su valor es 1 únicamente en el intervalo de 10 ns a 40 ns cuando al menos una de las dos entradas están activas.
- Comportamiento xor (`y_xor`): Su valor es 1 únicamente en el intervalo de 10 ns a 30 ns cuando ambas entradas tienen valores diferentes entre si.

---

##  Ejercicio 1: FSM de Control – Semáforo Simple

### 1.1 Planteamiento del Diseño

Para este ejercicio se diseñó un controlador de un semáforo simple mediante una Máquina de Estados Finitos (FSM) tipo Moore. Pero antes de continuar, se debe mencionar un cambio realizado en el ejercicio original. Dado que en los sistemas de tránsito reales el ciclo de transición de un semáforo no pasa directamente de Rojo a Verde. Se ha añadido una segunda fase de Luz Amarilla para advertir a los conductores el cambio de luz roja a luz verde.

El sistema cuenta con un contador interno que controla la permanencia en cada estado según la cantidad requerida de periodos de reloj ($T_{clk} = 10\text{ ns}$). El ciclo secuencial completo consta de 4 estados y una duración total de 13 ciclos de reloj:

- **Estado `S_Verde` ($S_0$ - Luz Verde):** Dura 5 ciclos de reloj.
- **Estado `S_Amarillo1` ($S_1$ - Luz Amarilla 1):** Dura 2 ciclos de reloj (Transición hacia Rojo).
- **Estado `S_Rojo` ($S_2$ - Luz Roja):** Dura 4 ciclos de reloj.
- **Estado `S_Amarillo2` ($S_3$ - Luz Amarilla 2):** Dura 2 ciclos de reloj (Transición hacia Verde).

### 1.2 Máquina de estados (FSM)

Dado que ya se identificaron los estados y duraciones necesarios para diseñar la maquina de estados de este ejercicio, solo falta elegir las entradas y salidas necesarias. Estas son:

- **Entradas:** `clk` (reloj del sistema) y `reset`.
- **Salidas:** `verde`, `amarillo` y `rojo`.

La maquina de estados diseñada se muestra a continuación:

<img width="815" height="571" alt="image" src="https://github.com/user-attachments/assets/7d678e04-dc9c-49a7-ac66-7d6fd61dea3a" />

El comportamiento de cada estado es el siguiente:
- **Estado `S_Verde` ($S_0$ - Luz Verde):** El sistema inicia forzado en este estado o retorna a él tras la activación del reset. Permanece en $S_0$ durante 5 ciclos de reloj (mientras contador < 4). Al cumplirse la condición contador == 4, transiciona automáticamente al estado $S_1$.
- **Estado `S_Amarillo1` ($S_1$ - Luz Amarilla 1):** Es la luz amarilla que ocurre durante la transición de luz verde a roja. Se mantiene durante 2 ciclos de reloj (mientras contador < 1). Al cumplirse contador == 1, transiciona hacia el estado $S_2$.
- **Estado `S_Rojo` ($S_2$ - Luz Roja):**  Se activa la luz roja durante 4 ciclos de reloj (mientras contador < 3). Al alcanzarse la condición contador == 3, transiciona al estado $S_3$.
- **Estado `S_Amarillo2` ($S_3$ - Luz Amarilla 2):** Es la luz amarilla que ocurre durante la transición de luz roja a verde. Permanece activo durante 2 ciclos de reloj (mientras contador < 1) y conmuta de retorno hacia $S_0$ cuando contador == 1, reiniciando así el ciclo del semáforo.

### 1.3 Resultados de Simulación y Análisis (GTKWave)

Nuevamente se utilizó Visual Studio Code para verificar el correcto funcionamiento de los códigos realizados tanto para el módulo que implementa la lógica combinacional del ejercicio (`semaforo.v`) como del testbench (`semaforo_tb.v`). Los comandos de compilación y visualización usados para este ejercicio manejan la misma estructura y orden que los utilizados para el smoke test, pero cambiando el nombre de los archivos:
```bash
iverilog -o semaforo_tb.vvp semaforo.v semaforo_tb.v
vvp semaforo_tb.vvp
gtkwave tb_semaforo.vcd
```
En la siguiente imágen se observa el resultado de la simulación en gtkwave.

<img width="1639" height="190" alt="image" src="https://github.com/user-attachments/assets/d6c51934-1ea6-46ba-aafb-89811373d6bf" />

A continuación se analiza el comportamiento de las señales en función del tiempo y los ciclos de reloj de acuerdo a la simulación:

1. **Condición de Reset Inicial ($0\text{ ns} \rightarrow 15\text{ ns}$):** Mientras la señal `rst` permanece en nivel alto (`rst = 1`), la FSM se fuerza al estado seguro de inicio $S_0$. Durante este intervalo se observa que la luz `verde` se mantiene en nivel alto (`1`) de forma constante, mientras que `amarillo` y `rojo` permanecen desactivadas (`0`).

2. **Luz Verde — Estado $S_0$ ($15\text{ ns} \rightarrow 65\text{ ns}$):** Una vez liberada la señal de reset (`rst = 0`), la señal `verde` permanece encendida durante 5 flancos de subida de reloj ($50\text{ ns}$).

3. **Luz Amarilla 1 — Estado $S_1$ ($65\text{ ns} \rightarrow 85\text{ ns}$):** Al alcanzarse el quinto ciclo, la señal `verde` conmuta a `0` y la señal `amarillo` pasa a `1` durante 2 flancos de reloj ($20\text{ ns}$).

4. **Luz Roja — Estado $S_2$ ($85\text{ ns} \rightarrow 125\text{ ns}$):** Cumplido el tiempo del estado $S_1$, la señal `amarillo` se apaga y se activa la señal `rojo` por un periodo de 4 flancos de reloj ($40\text{ ns}$).
   
5. **Luz Amarilla 2 — Estado $S_3$ ($125\text{ ns} \rightarrow 145\text{ ns}$):** Transcurrido el tiempo en rojo, la señal `rojo` se desactiva y se enciende nuevamente la señal `amarillo` durante 2 flancos de reloj ($20\text{ ns}$).

6. **Reinicio Cíclico Automático ($145\text{ ns}$ en adelante):** Al finalizar el segundo periodo en amarillo, la FSM retorna automáticamente al estado $S_0$ (`verde = 1`), repitiendo la secuencia completa de forma periódica e indefinida.

En base al análisis realizado de la simulación obtenida en GTKWave, se valida de manera satisfactoria el comportamiento de la Máquina de Estados Finitos (FSM) de tipo Moore diseñada para el control del semáforo, donde solo una luz (`verde`, `àmarillo` o `rojo`) está activa a la vez. Además, todas las transiciones ocurren de forma síncrona en el flanco positivo del reloj `clk`, eliminando posibles estados no deseados.

**El código HDL y el Testbench se encuentran en la carpeta scr en el apartado destinado a este ejercicio.**

---

## Ejercicio 2: Acumulador Secuencial

### 2.1 Descripción del Diseño

Se implementó un acumulador secuencial síncrono controlado por una FSM. El sistema recibe una entrada de 4 bits ($x$) y un pulso de inicio (`start`). La acumulación se ejecuta ciclo a ciclo hasta alcanzar la condición límite parametrizada.

* **Parámetros y Entradas:** 
  - Entradas: `clk`, `rst`, `start`, `x[3:0]`.
  - Salidas: `acc[5:0]` (acumulador de 6 bits), `done` (bandera de finalización).
* **Variante Seleccionada (`VARIANTE = 3`):** Acumular $x$ de manera iterativa hasta que la suma alcance o supere el valor de 20 (`acc >= 20`).

---

### 2.2 Máquina de Estados y Datapath

El sistema combina una unidad de control FSM y una ruta de datos:

* **`IDLE` (`2'b00`):** Estado de reposo. Al detectar `start = 1`, carga la primera entrada en `acc` (`acc <= x`), inicializa el contador (`count <= 1`) y pasa a `ADD`.
* **`ADD` (`2'b01`):** Suma incrementalmente `acc <= acc + x` en cada flanco de subida. Mantiene la iteración mientras `acc < 20`. Al evaluar `acc >= 20`, transiciona a `DONE`.
* **`DONE` (`2'b10`):** Emite la señal `done = 1` confirmando el fin del procesamiento y regresa a `IDLE`.
  

#### 2.2.1 Identificacion de entradas y salidas FSM + datapath

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


#### 2.2.2 Construcción de la unidad de control FSM

Se muestra el diagrama de estados de la unidad de control, consta de 4 estados que controlan el datapath indetificado anterior mente para el caso numero 3 (acumula hasta 20), para simplificar la expresión de comparasion, en lugar de utilizar `acc >= 20`, se cambia por `acc < 20` manejando la lógica respectiva

![Diagrama de estados](Lab00/ImagenesAcc/Diagrama%20de%20estados%20Acc.png)


#### 2.2.3 Conexiones FSMD

Se establecen las conexiones que unen la unidad de control con el camino de datos presentando el flujo de conexiones del circuito digital para realizar el caso 3 del ejercicio. En este caso la maquina FSM es de tipología Moore


![Diagrama de estado](Lab00/ImagenesAcc/FSMD.png).

Nota: para los casos de contar 3 y 4 veces el numero `x` de la entrada se realiza un proceso similar utilizando el contador, para realizar un circuito con las tres funciones se utiliza un multiplexoor que permita seleccionar el tipo de funcion deseado.


### 2.3 Resultados de Simulación y Análisis (GTKWave)

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

---

## Ejercicio 3: Diseño y simulación de una ASM completa (Control + Datapath) (BONO)

### 3.1 Objetivo Del Ejercicio
El objetivo principal de este ejercicio es diseñar un transmisor serial síncrono de 8 bits. Supongamos que se tiene un número de 8 bits guardado dentro de un sistema donde cada uno de estos viajará o se moverá al tiempo. Sin embargo, para enviar ese dato a otro dispositivo externo, generalmente no se cuenta con 8 cables que envié cada uno un bit, sino un solo cable de salida asignado como `tx`. Es por ello que la tarea del circuito o la simulación es recibir los 8 bits todos juntos, ir sacando un bit a la vez por la línea tx (respetando un tiempo específico para cada bit) y avisar cuándo está ocupado transmitiendo y cuándo terminó. Las entradas y salidas con las que se cuentan son las siguientes:

- **Entradas:** `clk` (reloj del sistema), `reset`, `start` (Pulso de un ciclo para iniciar la transmisión) y `data_in[7:0]` (Byte a transmitir).
- **Salidas:** `tx` (Línea de salida serial), `busy` (Indica que la transmisión está en curso) y `done` (Pulso de 1 ciclo al finalizar la transmisión).

### 3.2 Planteamiento del Diseño

Para resolver este tipo de problemas de manera estructurada, lo ideal es dividir el sistema en dos grandes bloques que trabajan juntos, el datapath y la unidad de control (Estructura ASM). La función de cada uno será la siguiente:

- Datapath: Se puede ver como la maquinaria de un sistema, ya que es donde están los elementos que guardan o modifican datos como los registros, los contadores y los desplazadores. El Datapath no toma decisiones, solo ejecuta órdenes.
- Unidad de Control: Por otro lado, este es el cerebro, aquí no se guarda el dato de 8 bits ni se va a contar el tiempo directamente. Su único trabajo es mirar en qué punto del proceso se encuentra el sistema para enviar señales de control al Datapath y que este actúe.

Teniendo en cuenta las entradas y salidas mencionadas en el ejercicio, los bloques de esta ASM se verían por el momento de esta manera:

<img width="1067" height="570" alt="image" src="https://github.com/user-attachments/assets/59c9629f-17c6-407b-b266-4cd0aeab7298" />

### 3.2.1 Diagrama de Flujo de la ASM

El siguiente diagrama representa la máquina de estados algorítmica (ASM) encargada de la transmisión serial asíncrona de datos de 8 bits. Describe la interacción entre la FSM de control y el datapath, incorporando un generador de baudios mediante temporización por ciclos de reloj.

<img width="421" height="620" alt="image" src="https://github.com/user-attachments/assets/4794c3ab-46b5-464c-bd8f-e6b119fafba7" />

- `IDLE`: El sistema se encuentra a la espera de la señal de inicio. Mantiene la línea de transmisión en alto (`tx = 1`) y las banderas inactivas (`busy = 0`, `done = 0`). Se mantiene en un bucle sobre sí mismo mientras `start == 0`.

- `LOAD`: Al detectarse `start == 1`, se activa la señal de ocupado (`busy = 1`), se carga el dato de entrada en el registro de desplazamiento (`shift_reg = data_in`) y se inicializan los contadores de tiempo (`tick_cnt = 0`) y de trama (`bit_count = 0`).

- `BIT_HOLD`: Coloca en la línea de salida el bit menos significativo del registro (`tx = shift_reg[0]`). El sistema evalúa la condición de temporización `tick_cnt >= CLKS_PER_BIT - 2`. Mientras no se alcance el tiempo por bit, incrementa el contador `tick_cnt += 1` y se mantiene en este estado. Pero en el momento que llegue a completar los ciclos requeridos, avanza al estado de desplazamiento.

- `SHIFT_NEXT`: Ejecuta un desplazamiento lógico a la derecha en el registro (`shift_reg = shift_reg >> 1`), incrementa el contador de bits transmitidos (`bit_count += 1`) y reinicia el contador de baudios (`tick_cnt = 0`). Inmediatamente evalúa la condición de parada `bit_count == 8`; Si quedan bits por enviar, retorna a `BIT_HOLD` para procesar el siguiente bit. Pero si ya se transmitieron los 8 bits completos, desactiva la bandera de ocupado (`Next_busy = 0`) y pasa al estado final.

- `DONE`: Emite un pulso en alto en la señal `done = 1`, restaura la línea a reposo (`tx = 1`) y desactiva `busy = 0`. Finalizado este ciclo, retorna incondicionalmente a `IDLE` mediante el conector (1).

- `RESET`: Si en cualquier punto de la ejecución se activa la señal `reset == 1`, el sistema ejecuta la limpieza inmediata de todos los registros internos (`busy = 0`, `bit_count = 0`, `tick_cnt = 0`, `shift_reg = 0`) y fuerza el retorno a `IDLE` a través del conector (2).

### 3.2.2 Datapath

Teniendo en cuenta lo solicitado en el enunciado del problema y el diagrama de flujo de la ASM, el datapath va a estar compuesto por tres registros o contadores principales:

- Registro de Desplazamiento (`shift_reg [7:0]`): Almacena de forma paralela el byte de entrada (`data_in`) durante la fase de carga. Durante la transmisión, realiza desplazamientos hacia la derecha (`shift_reg <= {1'b0, shift_reg[7:1]}`), exponiendo progresivamente el bit menos significativo (`shift_reg[0]`) a la línea de salida tx.
- Contador de Tiempo (`tick_cnt`): Garantiza la sincronización temporal de cada bit. Mide la cantidad de ciclos de reloj transcurridos para el bit actual desde 0 hasta `CLKS_PER_BIT - 2`, asegurando que la línea tx permanezca estable durante el intervalo definido.
- Contador de Bits (`bit_count [3:0]`): Contabiliza los bits enviados individualmente. Su función es servir como condición de parada para que la Unidad de Control reconozca cuando se han transmitido los 8 bits del byte completo (`bit_count == 8`).

### 3.2.3 Unidad De Control (FSM)

Para que la unidad de control se comunique con el datapath y con el exterior, se requiere de una Máquina de Estados Finitos (FSM) que incluya los 5 estados solicitados en el problema:

<img width="691" height="562" alt="image" src="https://github.com/user-attachments/assets/68e678dd-04f0-4d40-874b-18512e0df174" />

El comportamiento de cada estado es el previsto en el digrama de flujo de la ASM:

- `IDLE`: Se mantiene la línea serial en alto (`tx = 1`), `busy = 0` y `done = 0`. También se mantiene el bucle hasta que la señal de inicio se active (`start = 1`) y así poder pasar al estado `LOAD`.

- `LOAD`: La duración es de 1 ciclo de reloj, se activa la bandera `busy = 1`, se habilita la carga en paralelo del dato de entrada en `shift_reg` y se reinician las referencias de `tick_cnt` y `bit_count` para luego seguir incondicionalmente al estado `BIT_HOLD`.

- `BIT_HOLD`: Mantiene la salida `tx` conectada al bit actual (`shift_reg[0]`) mientras `tick_cnt` incrementa. El estado dura `CLKS_PER_BIT` ciclos de reloj hasta que finaliza el tiempo estipulado para el bit, momento en que pasa a `SHIFT_NEXT`.

- `SHIFT_NEXT`: Ejecuta la orden de desplazamiento a la derecha en `shift_reg`, incrementa en una unidad el contador de bits (`bit_count`) y reinicia el contador de tiempo `tick_cnt`. Si `bit_count < 8`, el proceso va a regrasar a `BIT_HOLD` para procesar el siguiente bit. Pero si `bit_count == 8`, el proceso avanzará hacia `DONE`.

- `DONE`: La duración es de 1 ciclo de reloj. Tambien se indica que ya se terminó la transmisión al desactivar la bandera `busy = 0` y se genera un pulso positivo en `done = 1` para notificar al sistema externo que la transferencia concluyó. Después pasa incondicionalmente al estado `IDLE`.

### 3.3 Resultados de Simulación y Análisis (GTKWave)

La simulación realizada en GTKwave se muestra a continuación:

<img width="1634" height="351" alt="image" src="https://github.com/user-attachments/assets/61418496-9c91-4171-b072-172cf4170806" />

<img width="1632" height="341" alt="image" src="https://github.com/user-attachments/assets/627b5006-7bf6-4eb1-a840-3adcfd926727" />

La simulación realizada valida completamente el funcionamiento del transmisor serial registrando dos transmisiones consecutivas `8'hA5` (`10100101b`) y `8'h3C` (`00111100b`).

**- Generación de Baudios y Sincronización**: Con una configuración de `CLK_PERIOD = 10 ns` y `CLKS_PER_BIT = 4`, cada bit en la línea `tx` se mantiene estable durante exactamente 4 ciclos de reloj ($40\text{ ns}$). El contador interno `tick_cnt` realiza la cuenta repetitiva de `0` a `3` ($CLKS\_PER\_BIT - 1$) para marcar la transición entre bits.

**- Desplazamiento del Registro Datapath (`shift_reg`)**: Durante cada paso por el estado `SHIFT_NEXT`, se aplica un desplazamiento lógico hacia la derecha (`shift_reg <= {1'b0, shift_reg[7:1]}`). El valor expuesto a la línea `tx` en todo momento corresponde a la posición menos significativa (`shift_reg[0]`), garantizando el envío del bit menos significativo primero.

En la primera transmisión (`8'hA5`), la evolución hexadecimal de `shift_reg` y el bit resultante en `tx` se observa así:

| Estado de Avance | `shift_reg` (Hex) | `shift_reg` (Binario) | Bit Emitido en `tx` (`shift_reg[0]`) |
| :---: | :---: | :---: | :---: |
| **Carga (`LOAD`)** | `A5` | `10100101` | **1** |
| Bit 1 | `52` | `01010010` | **0** |
| Bit 2 | `29` | `00101001` | **1** |
| Bit 3 | `14` | `00010100` | **0** |
| Bit 4 | `0A` | `00001010` | **0** |
| Bit 5 | `05` | `00000101` | **1** |
| Bit 6 | `02` | `00000010` | **0** |
| Bit 7 | `01` | `00000001` | **1** |
| **Fin (`DONE`)** | `00` | `00000000` | *(Línea en reposo: 1)* |

De forma análoga, la segunda transmisión (`8'h3C`) muestra el desplazamiento `3C` $\rightarrow$ `1E` $\rightarrow$ `0F` $\rightarrow$ `07` $\rightarrow$ `03` $\rightarrow$ `01` $\rightarrow$ `00`, emitiendo la secuencia serial `0, 0, 1, 1, 1, 1, 0, 0`.

---

### 3.4 Conclusiones

Con base en la simulación realizada, los diagramas de flujo y la FSM diseñada, se valida el cumplimiento de todas las condiciones especificadas:

1. **Transmisión Correcta de los 8 Bits:** 
   * Para `8'hA5`, la línea `tx` emite en orden exacto la trama: `1, 0, 1, 0, 0, 1, 0, 1`.
   * Para `8'h3C`, la línea `tx` emite en orden exacto la trama: `0, 0, 1, 1, 1, 1, 0, 0`.
2. **Duración Exacta de cada Bit (`CLKS_PER_BIT` ciclos):**
   * Cada bit permanece completamente estable durante $40\text{ ns}$ (4 ciclos de reloj de $10\text{ ns}$), sin generar glitches ni variaciones intermedias.
3. **Activación Correcta de la Señal `busy`:**
   * La señal `busy` conmuta a nivel alto ($1$) de manera síncrona al recibir el pulso de `start` y permanece activa (1) ininterrumpidamente durante todo el envío del byte, retornando a nivel bajo (0) únicamente al concluir los 8 bits.
4. **Activación de `done` por un Único Ciclo:**
   * Al finalizar la transmisión de cada byte (`bit_count == 8`), la bandera `done` se activa en nivel alto (1) durante exactamente 1 ciclo de reloj ($10\text{ ns}$) y retorna a 0 de forma inmediata en la transición a `IDLE`.
5. **Coherencia Interna del Sistema:**
   * La variable de estado (`state`) transiciona secuencialmente entre los valores binarios correspondientes a cada estado del sistema (`000` $\rightarrow$ `001` $\rightarrow$ `010` $\rightarrow$ `011` $\rightarrow \dots \rightarrow$ `100` $\rightarrow$ `000`).
   * El contador `bit_count` incrementa de manera ordenada de **0 a 8**, sirviendo como condición estricta de parada para la Unidad de Control.


---
