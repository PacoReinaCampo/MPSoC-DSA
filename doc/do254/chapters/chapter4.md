# CONCLUSIÓN

El diseño y la verificación del hardware deben realizarse independientemente. Esto ofrece una doble capa de seguridad ya que el diseñador se centrará en que el hardware cumpla con los requerimientos, y a la vez de forma independiente se creará un sistema de verificación que permita testar el hardware y verificar que efectivamente se cumplen cada uno de los requerimientos.

El estándar DO-254 tiene un enfoque basado en requisitos tanto para el diseño como para la verificación. Desde las primeras fases de diseño se deberán definir los requisitos de alto nivel, otorgándoles un nombre y referencia únicos que ayudará a comprobarlos y revisarlos a lo largo de todo el proyecto.

|FOLDER        |NORMATIVE             |TECHNOLOGY     |
|-------------:|:---------------------|:--------------|
|requirements  | IEEE STD 1850-2010   | PSL           |
|              | OMG-2.5.1.           | UML           |
|certification | RTCA DO-254          |               |
|              | RTCA DO-178C         |               |
|quality       | ISO 9001-2015        |               |
|doc           | IEEE STD 1685-2014   | IP-XACT       |
|              | IEEE STD 1735-2014   |               |
|source        | RTCA DO-254          |               |
|              | RTCA DO-178C         |               |
|bench         | IEEE STD 1076-2019   | VHDL          |
|              | IEEE STD 1800-2017   | SystemVerilog |
|model         | IEEE STD 1076-2019   | VHDL          |
|              | IEEE STD 1800-2017   | SystemVerilog |
|osvvm         | IEEE STD 1076-2019   | VHDL          |
|rtl/src       | IEEE STD 1076-2019   | VHDL          |
|              | IEEE STD 1364-2005   | Verilog       |
|uvm           | IEEE STD 1800.2-2020 | UVM           |
: Project Folder

La planificación es una parte crítica dentro de la certificación DO-254. Es el primer punto en el que se deberá presentar ante las autoridades (EASA, FAA, etc.). El PHAC (Plan for Hardware Aspects of Certification) deberá mostrar cómo se ha incorporado el DO-254 en la planificación.

![Hardware Project Workflow](assets/chapter4/hardware-project.svg)

![Software Project Workflow](assets/chapter4/software-project.svg)

En la fase de diseño conceptual y con el fin de mantener un nivel más sencillo y manejable, los diseños grandes se disgregarán en componentes más pequeños. Para cada diseño conceptual de cada uno de estos componentes, el Lenguaje de Descripción de Hardware (HDL) debe ya tener en cuenta todos los requerimientos, manteniendo una trazabilidad lógica desde el diseño inicial de conjunto.

Cumplir con los estándares DO-254 es un reto, pero no es lo único que se debe cumplir. Además de asegurar la calidad del propio hardware se debe documentar cómo se va a conseguir, tarea que debe cumplirse mediante un Process Assurance o Quality Assurance Plan (QA). En este documento deberá indicarse qué persona u organización comprobará que se cumple lo previsto en la planificación y cómo se hará esa comprobación.

Es común que en los procesos de certificación de DO-254 los organismos oficiales busquen que esta tarea de Quality Assurance sea realizada por una organización independiente y cualificada, con experiencia en procesos de diseño y verificación (y no por alguien del propio equipo).

En este sentido existen diferencias entre DO-254 y DO-178C, orientado al Software Quality Assurance. En el caso que nos compete, el aseguramiento de la calidad del hardware incluye una auditoría a los proveedores y a los procesos que se generan tras su aprovisionamiento de hardware. Estos procesos deberán estar debidamente documentados y ofrecer repetibilidad de acuerdo con las especificaciones del proyecto.
