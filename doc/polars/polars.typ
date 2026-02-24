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
  = Polars

  Hermilo

  4 de Septiembre 2025
]

#slide[
= Polars : Query Engine for DataFrames
  #figure(
        image("images/Polars_logo_1.png", width: 80%),
        numbering: none
      )

]

#slide[
= Polars : Query Engine for DataFrames

#text(font: "Lato", size : 16pt)[
  Polars es una biblioteca desarrollada en Rust que integra las siguientes características por diseño:
  - *Velocidad* : Rust es un lenguaje de system programmig conocido por su desempeño y seguridad.
  - *Paralelismo* : Aprovecha arquitecturas multicore he implementa algoritmos paralelos de work stealing.
  - *Eficiencia de memoria*: 
    - Polars utiliza evaluaciones lazy, lo que significa que una operación no es realizada hasta que esta es necesitada.
    - Las consultas pueden ser encadenadas y optimizadas antes de su ejecución, lo que se traduce en ejecuciones más eficientes de queries.
  - *Almacenamiento eficiente de datos* : Polars utiliza Apache Arrow como modelo de almacenamiento en memoria. Es decir, utiliza un formato columnar del almacenamiento de datos, lo cual resulta más eficiente que el tradicional almacenamiento basado en filas (como el utilizado por Pandas).
  - Diseñado para *out-of-core processing* (más grande que la RAM).
]
]
#slide[
= Polars : Query Engine for DataFrames
  #figure(
        image("images/Polars_logo_1.png", width: 80%),
        numbering: none
      )

]

#slide[
= Polars : Query Engine for DataFrames
  #figure(
        image("images/Polars_logo_1.png", width: 80%),
        numbering: none
      )

]

#slide[
  == Aceleración impulsada por NVIDIA-RAPIDS

#toolbox.side-by-side(gutter: 3mm, columns: (1.5fr, 2fr), 

  [

    #text(font: "Lato", size : 22pt)[
  Consideraciones de diseño : 
  - Misma semática.
  - Optimizador.
  - Parte de la biblioteca de Polars (no es necesario `import cudf_polars as pl`)
    ]

  ], 
        [
    #text(font: "Lato", size : 15pt)[
  ```python 
  query = (
    transaction.group_by("cust_id").agg(
      pl.cum("amount")
    ).sort(by = "amount", descending = True)
    .head()
  )

  # Run on the CPU 
  result_cpu = query.collect()

  # Run on the GPU
  result_gpu = query.collect(engine="gpu")

  # assert both result are equal
  pl.testing.assert_frame_equal(result_cpu, result_gpu)
  ```
    ]

      ]

  )
]

#slide[
  == Roadmap de un query 

  #figure(
        image("images/polars-roadmap.svg", width: 110%),
        numbering: none
      )
]

#slide[
  == Fase Lógica
  #figure(
        image("images/polars-logical.png", width: 110%),
        numbering: none
      )
]

#slide[
  == Optimizaciones

#toolbox.side-by-side(gutter: 3mm, columns: (1.5fr, 2fr), 

  [

    #text(font: "Lato", size : 22pt)[
  Vectorización ofrecida por NumPy: 
  - SI : Performance de C. 
  - NO : Optimizaciones.
    ]

  ], 
        [
    #text(font: "Lato", size : 12pt)[
  ```python 
import polars as pl

q = (
    pl.scan_csv('../datos/flights.csv')
    .select(['MONTH', 'ORIGIN_AIRPORT','DESTINATION_AIRPORT'])
    .filter(
        (pl.col('MONTH') == 5) &
        (pl.col('ORIGIN_AIRPORT') == 'SFO') &
        (pl.col('DESTINATION_AIRPORT') == 'SEA'))
)
%time
df = q.collect(no_optimization=True)
CPU times: user 3 μs, sys: 0 ns, total: 3 μs
Wall time: 5.48 μs
%time
df = q.collect()
CPU times: user 5 μs, sys: 0 ns, total: 5 μs
Wall time: 15.7 μs
  ```
    ]

      ]

  )

]

#slide[
  == Paralelismo : Work Stealing
  #figure(
        image("images/stealing.png", width: 55%),
        numbering: none
      )
]

#slide[
  == Polars Expressions

  #text(font: "Lato", size : 26pt)[
  *¿Qué es una expresión?*

  #text(fill: ukj-blue)[*Una expresión es un árbol de operaciones que*] #text(fill: red)[*describen*] cómo construir ona o más Series.

    ]
]


#slide[
  == Polars Expressions
#image("images/tree.png", width: 60%)

]

