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
  = Apache Arrow

  Hermilo

  4 de Septiembre 2025
]

#slide[
    == ¿Qué es Apache Arrow?
    #toolbox.side-by-side(gutter: 3mm, columns: (2fr, 1.5fr), 

  [
        #figure(
        image("images/apache_arrow.png", width: 100%),
        numbering: none
      )

  ], 
        [
        #figure(
        image("images/apache_arrow_logo.png", width: 75%),
        numbering: none
      )
        #text(font: "Lato", size : 12pt)[
          - Estandar de intercambio de datos. 
          - Un formato in-memory.
          - Un formato de Red. 
          - Un formato de Almacenamiento. 
          - Biblioteca de I/O
          - Biblioteca de cómputo vectorizado.
          - Biblioteca de manejo de dataframes.
          - Un query engine.
          - Administrador de datasets particionados.
        ]

      ]

  )
]

#slide[
  == PyArrow Arrays
    #toolbox.side-by-side(gutter: 3mm, columns: (2fr, 1.5fr), 

  [

    #text(font: "Lato", size : 14pt)[
  ```python 
  import pyarrow as pa 
  
  ## Arrays can be made of numbers
  >>> pa.array([1, 2, 3, 4, 5]) 

  ## Or strings
  >>> pa.array(["A", "B", "C", "D", "E"])

  ## Or even complex objects
  >>> pa.array([{"a" : 5}, {"b" : 10}])  

  ```
    ]

  ], 
        [
        #figure(
        image("images/apache_arrow_logo.png", width: 75%),
        numbering: none
      )
        #text(font: "Lato", size : 12pt)[
          - Estandar de intercambio de datos. 
          - Un formato in-memory.
          - Un formato de Red. 
          - Un formato de Almacenamiento. 
          - Biblioteca de I/O
          - Biblioteca de cómputo vectorizado.
          - Biblioteca de manejo de dataframes.
          - Un query engine.
          - Administrador de datasets particionados.
        ]

      ]

  )
]


