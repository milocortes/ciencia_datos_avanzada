// Get Polylux from the official package repository
#import "@preview/polylux:0.4.0": *
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.1": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "@preview/pinit:0.2.2": *
#import "@preview/thmbox:0.3.0": *

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
    ]

  ], 
        [

 #figure(
        image("images/tpu.jpeg", width: 95%),
        numbering: none
      )
      ]

  )

]


#slide[
  = JAX
]
#slide[
  #bibliography("references.bib",  style: "apa")
]