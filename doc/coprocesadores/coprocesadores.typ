// Get Polylux from the official package repository
#import "@preview/polylux:0.4.0": *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "@preview/pinit:0.2.2": *
#import "@preview/thmbox:0.3.0": *
#import "@preview/mitex:0.2.5": *
#import "@preview/tablem:0.3.0": tablem,three-line-table


#show: codly-init.with()
#codly(zebra-fill: none)

// Make the paper dimensions fit for a presentation and the text larger
#let ukj-blue = rgb(0, 84, 163)

// Make the paper dimensions fit for a presentation and the text larger
#set page(paper: "presentation-16-9")
#set text(size: 20pt, font: "Lato")

#show <a>: set text(blue)

#show raw: it => {
  show regex("pin\d"): it => pin(eval(it.text.slice(3)))
  it
}


#codly(
  languages: (
    rust: (name: "Rust", icon: "🦀", color: rgb("#CE412B")),
    python : (name : "Python", icon : "🐍")
  )
)

// Use #slide to create a slide and style it using your favourite Typst functions
#slide[
  #set align(horizon)
  = Coprocesadores : GPU, TPU y FPGA

  Hermilo

  17 de Febrero de 2026
]

#slide[
  = Coprocesadores : ¿Por qué?

  - Funcionalidad especializada.
    - Funciones no encontradas en CPU genérico.
    - Más rápidas que un CPU genérico.
  - Diseño simplificado.
    - Menos costo que un CPU genérico.
    - No puede ejecutar sistema operativo.
    - Requiere de un CPU anfitrión.
  - Más poder de cómputo a menor costo.
  - Más compacto.
    - Menos espacio.
    - Menos energía.
]

#slide[
  = Coprocesadores : Lo dificil.
  - Sistemas Heterogéneos.
    - CPU
    - Coprocesador.
  - Detalles dependen del tipo de Coprocesador.
  - Madurez de herramienta.
  - Rendimiento práctico mucho menor que teórico.
]

#slide[
  = Tipos de Coprocesadores
  - Targetas de video : GPU.
    - Cómputo de alto rendimiento aprovecha mercado de video de alta calidad.
    - Entrenamiento Deep Learning.

  - FPGA.
    - Circuitos programables.
    - Rápido y flexible.
    - Más lejos del diseño de un CPU genérico.
  - TPU
    - Para acelerar TensorFlow, PyTorch y JAX.
    - Diseñado para sistemas embebidos. Casos de uso potenciales: Procesamiento de Audio, Procesamiento de Imágenes, Interacción con el usuario, etc. 



]

#slide[
  = FPGA (Field Programmable Gate Array)

#toolbox.side-by-side(gutter: 3mm, columns: (2fr, 2fr), 

  [

    #text(font: "Lato", size : 17pt)[
  - Circuito integrado semiconductor reprogramable que permite configurar la lógica digital interna después de su fabricación
  - Uso en electrónica programable. 
  - Diferentes fabricantes:
    - Altera
      - Intel compró Altera en 2015
    - Xylinx.
  - Programación tipicamente en Verilog.
  - Existen compiladores para HPC para C y Fortran.
  - #text(fill: ukj-blue)[*Usado para resolver Modelos de Equilibrio General*]
    ]

  ], 
        [

 #figure(
        image("images/fpga_placa.jpg", width: 95%),
        numbering: none
      )
      ]

  )

]


#slide[
  #text(font: "Lato", size : 14pt)[= Programming FPGAs for Economics : An Introduction to Electrical Engineering Economics @cheela2025programming]
    #figure(
      image("images/fpga.png", width: 63%),
    ) 
]


#slide[
  = GPU (Graphics processing unit)
  - Mercado dominado por NVIDIA.
  - Arquitecturas : Tesla, Fermi, Kepler, Maxwell, Pascal, Volta, Turing, etc.
  - #text(fill: ukj-blue)[*CUDA*] : introducida 2007, con tesla.
  - Parecido a C.
  - Es posible programar GPU con #text(fill: ukj-blue)[*OpenMP*] siguiendo el modelo fork-join.
  - Problema : Portabilidad.
  - #text(fill: ukj-blue)[*Mojo*]!!
]

#slide[
  = Mojo is blazing fast
  - #text(fill: ukj-blue)[*100-1000X faster*] than Python.
  - Full power of modern CPUs.
    - SIMD, threads, NUMA, etc.
    - New MLIR-based compiler.
  - Works on GPU too.
    - #text(fill: ukj-blue)[*Same Language*] for both CPU and GPU.
  - Power of Pythonic Mojo code.
    - Easy to learn.
    - Great for low level performance.
    - Powerful metaprogramming.
]

#slide[
  = CPU, diseño orientado a latencia, GPU, diseño orientado a throughput #footnote[#text(font: "Lato", size : 11pt)[The NVIDIA H100, for example, can run 16,896 threads simultaneously in a single clock cycle, with over 270,000 threads queued for execution.]].
    #figure(
      image("images/cpu-gpu.png", width:65%),
    ) 
]

#slide[
  = Cómputo Heterogéneo
    #figure(
      image("images/pci_express.png", width:70%),
    ) 
]

#slide[
  #text(font: "Lato", size : 30pt)[
  = Conceptos clave
  - #text(fill: ukj-blue)[*Kernel*].
  - #text(fill: ukj-blue)[*Thread / Block / Grid*]
  - #text(fill: ukj-blue)[*Host / Device Memory*]
  - #text(fill: ukj-blue)[*Global / Shared Memory*]
  ]
]

#slide[
  = Kernel

#toolbox.side-by-side(gutter: 3mm, columns: (2fr, 2fr), 

  [

    #text(font: "Lato", size : 24pt)[
  Kernel function o GPU Kernel es simplemente una función que se ejecuta en la GPU, ejecutando un cálculo específico en un conjunto grande de datos en paralelo mediante miles o millones de threads.
    ]

  ], 
        [

    #text(font: "Lato", size : 10pt)[
  ```python 
from std.gpu import block_dim, block_idx, thread_idx
from std.math import ceildiv
# Calculate the number of thread blocks needed by dividing the vector size
# by the block size and rounding up.
comptime block_size = 256
comptime num_blocks = ceildiv(vector_size, block_size)


def vector_addition(
    lhs_tensor: LayoutTensor[float_dtype, layout, MutAnyOrigin],
    rhs_tensor: LayoutTensor[float_dtype, layout, MutAnyOrigin],
    out_tensor: LayoutTensor[float_dtype, layout, MutAnyOrigin],
):
    """Calculate the element-wise sum of two vectors on the GPU."""

    # Calculate the index of the vector element for the thread to process
    var tid = block_idx.x * block_dim.x + thread_idx.x

    # Don't process out of bounds elements
    if tid < vector_size:
        out_tensor[tid] = lhs_tensor[tid] + rhs_tensor[tid]

  ```]
      ]

  )

]

#slide[
  = Thread

#toolbox.side-by-side(gutter: 3mm, columns: (2fr, 2fr), 

  [

    #text(font: "Lato", size : 15pt)[
      - Unidad básica de una ejecución paralela en una GPU. 
      - Cada thread corre el mismo kernel function pero procesa diferentes piezas de datos.
      - Un #text(fill: ukj-blue)[*thread block*] es un grupo cordinado de threads que pueden compartir memoria y sincronizarse entre sí.
      - Thread dentro de un bloque pueden comunicarse muy eficientemente. 
      - Un #text(fill: ukj-blue)[*grid*] es el nivel top de la estructura organizacional para la ejecución del kernel function.
      - Un grid consiste de múltiples bloques de threads que se dividen aún más en threads individuales que ejecutan el kernel function concurrentemente. 

    ]

  ], 
        [

 #figure(
        image("images/grid.png", width: 80%),
        numbering: none
      )
      ]

  )
]

#slide[
  = Organization of thread blocks and threads within a grid. 


 #figure(
        image("images/grid_organizacion.png", width: 69%),
        numbering: none
      )
]

#slide[
  = Global Memory y Shared Memory


    #text(font: "Lato", size : 25pt)[
      - #text(fill: ukj-blue)[*Global Memory*] es el espacio de memoria principal de la GPU accesible para todos los threads. 
      - El grande, pero relativamente lenta.
      - #text(fill: ukj-blue)[*Shared Memory*] es una memoria rápida onchip que los thread en un bloque usan para comunicarse.
      - Es varios órdenes de magnitud más rápida que la memoria global, lo que la hace crítica para el desempeño. 
    ]

]

#slide[
  = Shared Memory
  #figure(
        image("images/shared_memory.png", width: 110%),
        numbering: none
      ) 
]
#slide[
  = Aceleradores para Machine Learning y Deep Learning

  - Intensivos en Álgebra Lineal.
  - Productos para:
    - Equipos portátiles.
    - Sistemas embebidos (e.g coches)
]


#slide[
  = TPU (Google Tensor Processing Unit)

#toolbox.side-by-side(gutter: 3mm, columns: (2fr, 2fr), 

  [

    #text(font: "Lato", size : 24pt)[
  - Para acelerar TensorFlow y #text(fill: ukj-blue)[*JAX*]
  - Acelerar el proceso de Entrenamiento.

 #figure(
        image("images/jackson-pic1.png", width: 60%),
        numbering: none, 
        caption: [Synaptics Coral Dev Board]
      )
    ]

  ], 
        [

 #figure(
        image("images/tpu.jpeg", width: 50%),
        numbering: none
      )
 #figure(
        image("images/coral_tpu.jpeg", width: 45%),
        numbering: none, 
        caption: [Coral Edge TPU]
      )

      ]

  )

]


#slide[
  = JAX : A flexible and fast opensource numerical computing library from Google DeepMind

#toolbox.side-by-side(gutter: 3mm, columns: (2fr, 2fr), 

  [

    #text(font: "Lato", size : 17pt)[
  - JAX proporciona una API estilo NumPy para la adopción fácil de ideas o pruebas de concepto en Cómputo Científico o Machine Learning.
  - Obtenemos un mayor speed-up simplemente sustituyendo NumPy por JAX NumPy. 
    ]

  ], 
        [


  #text(font: "Lato", size : 14pt)[
  ```python 
  import jax.numpy as jnp 

  def predict(params, inputs):
    for W,b in params:
      outputs = jnp.dot(inputs, W) + b 
      inputs = jnp.tanh(outputs)

    return outputs 

  def loss(params, batch):
    inputs, targets = batch 
    preds = predict(params, inputs)
    
    return jnp.sum((preds - targets)**2) 
  ```
      ]
  ]
  )
]

#slide[
  = JAX Function Transformation : Automatic Differentation.


#toolbox.side-by-side(gutter: 3mm, columns: (2fr, 2fr), 

  [

    #text(font: "Lato", size : 17pt)[
  - Gradient Transformation : JAX toma cualquier función como input y la transforma en una función que calcula el gradiente de la función original.
  - Esto lo logra mediante #text(fill: ukj-blue)[*Diferenciación Automática*], comunmente llamada #text(fill: ukj-blue)[*autodiff*], una herramienta crucial en Machine Learning y tareas de optimización.
  - En este caso transformamos la función de pérdida con `grad` y esto nos permitiría calcular el gradiente de nuestra función de pérdida y ajustar los pesos de nuestro modelo para minimizar el error.
    ]

  ], 
        [

    #text(font: "Lato", size : 13pt)[
#codly(highlights: (
  (line: 2, start: 1, end: none, fill: red),
  (line: 17, start: 1, end: none, fill: red),
))
  ```python 
  import jax.numpy as jnp 
  from jax import grad

  def predict(params, inputs):
    for W,b in params:
      outputs = jnp.dot(inputs, W) + b 
      inputs = jnp.tanh(outputs)

    return outputs 

  def loss(params, batch):
    inputs, targets = batch 
    preds = predict(params, inputs)
    
    return jnp.sum((preds - targets)**2) 

  gradient_fun = grad(loss)
  ```
      ]
  ]
  )
]


#slide[
  = JAX Function Transformation : Batching.


#toolbox.side-by-side(gutter: 3mm, columns: (2fr, 2fr), 

  [

    #text(font: "Lato", size : 17pt)[
  - La función `vmap` facilita la operación de tomar una función que fue escrita para un elemento en una función que funcione para muchos elementos, operación comunmente denominada como #text(fill: ukj-blue)[*vectorización*] o #text(fill: ukj-blue)[*batching*].
  - En este ejemplo vectorizamos la función que calcula el gradiente de nuestra función de pérdida usando `vmap`, permitiendo calcular los gradientes para múltiples elementos.
    ]

  ], 
        [

    #text(font: "Lato", size : 12pt)[
#codly(highlights: (
  (line: 2, start: 1, end: none, fill: red),
  (line: 18, start: 1, end: none, fill: red),
))
  ```python 
  import jax.numpy as jnp 
  from jax import grad, vmap

  def predict(params, inputs):
    for W,b in params:
      outputs = jnp.dot(inputs, W) + b 
      inputs = jnp.tanh(outputs)

    return outputs 

  def loss(params, batch):
    inputs, targets = batch 
    preds = predict(params, inputs)
    
    return jnp.sum((preds - targets)**2) 

  gradient_fun = grad(loss)
  perexample_grads = vmap(grad(loss), in_axes = (None,0))
  ```
      ]
  ]
  )
]


#slide[
  = JAX Function Transformation : Compilation.


#toolbox.side-by-side(gutter: 3mm, columns: (2fr, 2fr), 

  [

    #text(font: "Lato", size : 17pt)[
  - ¿JAX cómo acelera el procesamiento? JAX puede ejecutar compilación Just-In-Time, JIT, para crear código optimizado que pueda ejecutarse rapidamente.
  - La compilación permite reducir la latencia y usar nuestro hardware eficientemente de forma automática, eliminando salidas no usadas y recomputaciones innecesarias.}
  - También podemos compilar las operaciones de diferenciación automática. 
    ]

  ], 
        [

    #text(font: "Lato", size : 11pt)[
#codly(highlights: (
  (line: 2, start: 1, end: none, fill: red),
  (line: 17, start: 1, end: none, fill: red),
  (line: 18, start: 1, end: none, fill: red),
))
  ```python 
  import jax.numpy as jnp 
  from jax import grad, vmap, jit

  def predict(params, inputs):
    for W,b in params:
      outputs = jnp.dot(inputs, W) + b 
      inputs = jnp.tanh(outputs)

    return outputs 

  def loss(params, batch):
    inputs, targets = batch 
    preds = predict(params, inputs)
    
    return jnp.sum((preds - targets)**2) 

  gradient_fun = jit(grad(loss))
  perexample_grads = jit(vmap(grad(loss), in_axes = (None,0)))
  ```
      ]
  ]
  )
]

#slide[
  = JAX : A flexible and fast numerical computing library 

 #figure(
        image("images/jax_roadmap.png", width: 50%),
        numbering: none, 
        caption: text(font: "Lato", size : 14pt)[JAX provides a set of composable function
transformations for Python + NumPy code for compilation, vectorization, parallelization, and automatic differentiation. Source : @sapunov2024deep]
      )
]
#slide[
  = JAX : Run anywhere and scale automatically

#figure(
  stack(
    dir: ltr, // Aligns elements horizontally
    spacing: 1em, // Adds space between figures
    image("images/gpu.jpeg", width: 35%),
    image("images/tpu.jpeg", width: 35%),
    image("images/gpu_cluster.jpg", width: 35%),
  ),
) 
  #text(size: 30pt, font: "Lato")[
    *Any hardware: CPU, GPU (NVIDIA & AMD), TPU Unified API: Any scale* #import emoji: face
  ]
]

#slide[
  = Evaluemos JAX usando CPU y GPU #link("https://colab.research.google.com/github/milocortes/ciencia_datos_avanzada/blob/main/notebooks/jax_performance_cpu_gpu.ipynb")[#emoji.face.nerd #emoji.computer]
    #text(font: "Lato", size : 12pt)[
  ```python 
  import numpy as np
  import jax.numpy as jnp 
  from jax import device_put, devices, jit
  # a function with some amount of calculations 
  def f(x):
    y1 = x + x*x + 3
    y2 = x*x + x*x.T
    return y1*y2
  # generate some random data
  x = np.random.randn(3_000, 3_000).astype('float32')
  jax_x_gpu = device_put(jnp.array(x), devices("gpu")[0])
  jax_x_cpu = device_put(jnp.array(x), devices("cpu")[0])
  # compile function to CPU and GPU backends with JAX
  jax_f_gpu = jit(f, backend = "gpu")
  jax_f_cpu = jit(f, backend = "cpu")
  # warm-up
  jax_f_cpu(jax_x_cpu)
  jax_f_gpu(jax_x_gpu)
  ```
      ]

]

#slide[
  #text(size: 16pt, font: "Lato")[
  = JAX para solucionar problema de optimización intertemporal de los hogares @fehr2018introduction #link("https://colab.research.google.com/github/milocortes/ciencia_datos_avanzada/blob/main/notebooks/jax_problema_optimizacion_intertemporal.ipynb")[#emoji.face.nerd #emoji.computer ]

  Considera el siguiente problema de optimización intertemporal de los hogares: La función de utilidad de los hogares está dada por

#mitext(`
\begin{equation}
    U(c_1,c_2,c_3) = \sum_{i=1}^3 \beta^{i-1} u(c_i)\qquad \text{con} \qquad u(c_i) = \dfrac{c_i^{1-\frac{1}{\gamma}}}{1 - \frac{1}{\gamma}}
\end{equation}
 `)

donde $c_i$ define el consumo en el periodo $i$ de vida, $beta$ denota la tasa de descuento y $gamma$ es la elasticidad de sustitución intertemporal.

Asume que los hogares reciben ingreso laboral $w$ en los primeros dos periodos y consumen todos sus ahorros en el tercer periodo, de manera que la restricción presupuestaria queda definida como:

#mitext(`
\begin{equation}
    \sum_{i=1}^{3} \dfrac{c_i}{(1+r)^{i-1}} = \sum_{i=1}^{2} \dfrac{w}{(1+r)^{i-1}}
\end{equation}
 `)
donde $r$ es la tasa de interés.

  ]
]

#slide[
Resuelve los niveles de consumo óptimo usando algún método de optimización de primer orden.

Procede de la siguiente manera:

- a) #mitext(`Sustituye la restricción presupuestaria en la función de utilidad de manera que esta dependa únicamente de $c_2$ y $c_3$.`)
- b) #mitext(`Minimiza la función $-\widetilde{U}(c_2,c_3)$ con el objetivo de obtener los valores óptimos de $c_2$ y $c_3$ ($c_2^*$ y $c_3^*$).`)
- c) #mitext(`Deriva $c_1^*$ de la restricción presupuestaria.`)

Usa los siguientes parámetros:
* $gamma=0.5$
* $beta=1$
]

#slide[
  Realiza el siguiente análisis de sensibilidad variando el valor de $w$ y $r$ de acuerdo a la siguiente tabla:

#three-line-table[
|   $w$ |   $r$ |   $c_1$ |   $c_2$ |   $c_3$ |
|------:|------:|--------:|------:|------:|
|     1 |   0   |    0.66 |  0.66 |  0.66 |
|     2 |   0   |    1.33 |  1.33 |  1.33 |
|     1 |   0.1 |    0.66 |  0.69 |  0.73 |
]

Los valores de $c_1$, $c_2$ y $c_3$ son los obtenidos por Fehr y Kindermann (2018).

]

#slide[
  = Solución 
- a) Podemos reducir la dimensión del problema de optimización al reformular la restricción presupuestaria de la siguiente manera:
#mitext(`
\begin{equation}
    c_1 = w + \dfrac{w - c_2}{1+r} - \dfrac{c_3}{(1+r)^2}
\end{equation}
`)

sustituyendo la nueva restricción en nuestra función objetivo, reducimos nuestro problema a un problema en dos dimensiones sin restricciones:

#mitext(`
\begin{equation}
    \widetilde{U}(c_2,c_3) = \dfrac{1}{1-\frac{1}{\gamma}} \Bigg[  w + \dfrac{w - c_2}{1+r} - \dfrac{c_3}{(1+r)^2} \Bigg]^{1-\frac{1}{\gamma}} + \beta \dfrac{c_2^{1-\frac{1}{\gamma}}}{1-\frac{1}{\gamma}}+ \beta^2 \dfrac{c_3^{1-\frac{1}{\gamma}}}{1-\frac{1}{\gamma}}
\end{equation}
`)


]

#slide[
  = Solución
- b) Reescribimos el problema de maximización de la utilidad en la siguiente forma:

#mitext(`
\begin{equation}
    \min_{c_2,c_3} -\widetilde{U}(c_2,c_3)
\end{equation}
`)

- *NOTA 1*: calcula el gradiente de la función #mitext(`$\widetilde{U}(c_2,c_3)$`) usando la función `grad` de JAX.
  
- *NOTA 2*: inicia la búsqueda en el punto #mitext(`$[c_2,c_3] = [0.2, 0.2]$`)
]
#slide[
  #bibliography("references.bib",  style: "apa")
]