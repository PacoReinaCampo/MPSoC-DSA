# Módulo I. Requisitos

Se han publicado numerosos libros de VHDL, demostrando que los HDLs son muy flexibles. Existen múltiples maneras de codificar un diseño en VHDL, pero hay razones para que la codificación sea siguiendo unas pautas a la hora de generar un código. Estas reglas generales se basan en:

* El código debe sintetizarse en todos los entornos independientemente del fabricante.

* El código debe ser claro, ya que es habitual trabajar en equipos y por tanto el estilo debe facilitar su legibilidad por otros miembros del equipo.

* El código ha de cumplir unas normas de estilo. Seguir unas directrices únicas facilita su interpretación y la reusabilidad de un diseño.

* El diseñador debe controlar bien cuanto sea posible el circuito que se sintetizará desde el código. Esto significa que se debe seguir unas pautas de codificación, que lleven a un único circuito con la misma arquitectura, considerando cualquier sitetizador.

* El código debe ser fácilmente depurable. Cuanto más rigurosa sea la escritura del código más fácil será el proceso de la detección de errores.

Éstas y otras razones llevan a definir unas reglas de estilo de codificación, usualmente en grado de recomendación, pero que si desea calificar el código de un diseño bajo norma ò se pretende que se aceptado por los grandes centros de diseño se deben seguir fielmente. Cada una se le designa por un código, que en nuestro caso es propio de este capítulo. En particular serán una mezcla de dos juegos de reglas, las numeradas por 0XX son recomendaciones para la norma DO-254 y las 1XX son aquella que adicionalmente recomienda la agencia espacial francesa, CNES, para realizar diseños. Se ha evitado duplicar reglas, por tanto aquellas ya escritas para la norma DO-254 se omiten en las de CNES. Las reglas se toman de estos dos documentos y se mencionan como bibliografía.

## Requisitos de Diseño

Las reglas de estilo se pueden dividir en cuatro grandes grupos de reglas permitiendo una clasificación inicial:

1. Prácticas de codificación.
2. Tratamiento de la señal de reloj.
3. Reglas para una síntesis segura.
4. Revisión de código.

Cada regla tiene un grado de cumplimiento. El seguimiento ò no de una regla tiene diferente calificación, que categorizaremos como 'Error', 'Warning' ò 'Note', lo que provee una medida del impacto de la regla en la calidad de un código.

Como norma general, los errores deben ser corregidos, las alarmas deben también corregirse, aunque se admiten excepciones bien justificadas y documentadas. Las notas deben ser simplemente verificadas.

El seguimiento de las normas de estilo es sólo parte del problema. La otra parte se encuentra en la adecuada elección de los parámetros de síntesis, aunque esto ya depende de la herramienta que se esté utilizando.

### Prácticas de codificación

PC001. Evitar usar tipos incorrectos de VHDL. Categoría: Error. No usar declaraciones de señal incorrecta, en cuanto a tipos, rangos y/o cotas.

PC002. Evitar hacer asignaciones duplicadas. Categoría: Warning. La misma señal no debe asignarse más de una vez en la misma región de código.

PC003. Evitar asignaciones a valores de tamaño prefijado. Categoría: Warning. Para diseñar IPs reutilizables ò por razones de portabilidad, el utilizar valores numéricos de longitud prefijado resulta una limitación.

PC004. Evitar asignaciones de código a vectores de tamaño fijo. Categoría: Note. Para asignaciones en valores de reset, usar preferentemente la macro con tamaño variable.

PC005. Utilizar un estilo consistente de codificación de FSM. Categoría: Error:

a. Un diseño de una FSM debe ser definido de una forma consistente sobre un conjunto consistente de estados.
b. La codificación de los estados de una FSM debe permitir ser flexible, no deben ser prefijada usando tipos enumerados.

PC006. Utilizar las transiciones de las FSM de manera segura. Categoría: Error:

a. La FSM debe tener definido un estado de reset bien definido.
b. Todos los estados deben transicionar a estados definidos con lo que una condición de error debe ser procesada consecuentemente.
c. No deben existir estados no alcanzables ò estados que no transiciones a otros.
d. Debe existir una transición por defecto sobre todo, en máquinas incompletamente especificadas.

PC007. Evitar rangos desajustados. Categoría: Warning. Los rangos de los vectores en ambos lados de una asignación, comparación ò asociación deben coincidir.

PC008. Asegurar una lista de sensibilidad con todas las señales. Categoría: Warning. Las listas deben ser sensibles a aquellas señales que forman parte de un proceso.

PC009. Asegurar que la estructura de un subprograma es la correcta. Categoría: Warning. Cada subprograma debe tener:

a. Sólo un punto de salida.
b. No debe ser recursivo.
c. Acceso sólo a variables ò señales locales.

PC010. Asignar un valor antes de usar una señal. Categoría: Warning. Cada objeto debe tener un valor antes de ser asignado.

PC011. Evitar entradas no conectadas. Categoría: Error. Todas las señales de entrada deben estar conectadas y evitar señales flotantes con efectos impredecibles en síntesis.

PC012. Evitar señales de salidas no conectadas. Categoría: Note. Las señales de salida deben conectarse ò declararse intencionadamente como no-conectadas, usando la palabra reservada 'open'.

PC013. Declarar los objetos antes de ser usados. Categoría: Error. Los objetos, (señales constantes,…) han de ser declarados antes de usarse.

PC014. Evitar declaraciones de señales no utilizadas. Categoría: Warning. Todos los objetos que se declaren deben ser usados, por tanto no declarar objetos que no son utilizados en el código.

PC101. Señales de salida tipo 'buffer' quedan prohibidas. Categoría: Error. Aquella señales de salida que han de leerse en el interior de la entity pueden declararse como 'buffer', sin embargo este tipo se salida queda prohibido, para hacer el código más portable.

PC102. Tipos basados en 'records' no deben formar parte de los puertos de I/O entidades. Categoría: Warning. La conexión de entidades entre si debe ser mediante tipos de conexión naturales y no agrupaciones ò tipos no reales.

### Tratamiento de la señal de reloj

Controlar las señales de reloj ante potenciales errores en diseños, conteniendo varios dominios de reloj y transiciones asíncronas.

TR001. Analizar múltiples relojes asíncronos. Categoría: Error. La temporización de un diseño tiene múltiples relojes, asíncronos entre si, ò bien se admiten relojes generados internamente, todos los relojes deben ser analizados rigurosamente y en profundidad.

TR002. Evitar utilizar los dos flancos activos de reloj. Categoría: Error. No utilizar partes del circuito activas en flanco de subida y otras activas en flanco de bajada de la misma señal de reloj.

TR101. Diferentes dominios de reloj. Categoría: Warning. La conexión entre diferentes dominios de reloj debe utilizar mecanismo previamente aprobados.

TR102. Dialogar sistemas con dos dominios de reloj, basados en señales de preguntarespuesta. Categoría: Warning. Para garantizar una buena comunicación entre sistemas digitales asíncronos entre sí es recomendable usar mecanismos de 'handshake'.

TR103. Dialogar sistemas con dos dominios de reloj, basados en FIFOs de doble reloj. Categoría: Warning. La sincronización mediante FIFO de doble reloj tiene muchas formas de implementación. El tamaño de la FIFO se escoge para compensar las diferencias de frecuencias entre ambos dominios. La funcionalidad de este tipo de FIFOs se debe determinar a priori.

TR104. Dialogar sistemas con dos dominios de reloj, usar un módulo que genere todos los relojes. Categoría: Warning. Los relojes deben ser generados a partir de una frecuencia base, es decir, una única señal de reloj.

TR105. No reasignar la señal de reloj dentro de una entidad. Categoría: Error. La señal de reloj no debe ser nunca reasignada.

TR106. Limitación a un dominio de reloj en un mismo diseño. Categoría: Warning. Siempre que sea posible, sólo usar un solo dominio de reloj en un mismo diseño.

TR107. Limitación a un dominio de reloj en un mismo módulo. Categoría: Warning. Siempre que sea posible, sólo usar un solo dominio de reloj en un mismo módulo.

TR108. Limitación siempre el mismo flanco activo en un dominio de reloj. Categoría: Error. El flanco activo en un sólo dominio de reloj debe ser siempre el mismo.

TR109. Detección de flancos de señales mediante máquinas de estado. Categoría: Error. Una señal externa debe sincronizarse mediante un detector de flanco, debe ser capturada sin que entre en conflicto con la señal de reloj,

TR110. Evitar metastabilidad de registros en las entradas externas. Categoría: Error. Una señal externa de entrada debe sincronizarse usando al menos dos registros.

TR111. Usar registros para las salidas externas. Categoría: Error. Una señal externa debe sincronizarse usando el registro del pin de salida, si lo hay. De esta manera evitamos que existan glitches y lógica.

TR112. Claridad en la definición de máquinas de estados FSMs. Categoría: Warning. El código de una máquina de estados debe ser sencillo y claro, fácilmente interpretable y depurable, con implementación predecible. Se recomienda usar dos procedimientos uno síncrono y otro asíncrono para implementar una FSM.

TR113. Claridad en la definición de otros módulos síncronos. Categoría: Warning. El código de un módulo síncrono debe ser sencillo y claro, fácilmente interpretable y depurable, con implementación predecible. Se recomienda usar dos procedimientos uno síncrono y otro asíncrono para implementar dicho módulo síncrono.

### Reglas para una síntesis segura

SS001. Evitar ciertas implementaciones de la lógica. Categoría: Warning. Evitar realizar código que implique feed-throughs (conexiones-directas), retardos intencionados de la lógica ò drivers de triestados internos.

SS002. Asegurar selecciones 'case' bien hechas. Categoría: Error. La sentencia "case" debe contener:

a. Ser completa.
b. No tener sentencias duplicadas.
c. No tener selecciones no alcanzables.
d. Debe contener la opción "when others" como valor por defecto.

SS003. Evitar bucles combinacionales. Categoría: Error. No permitir que una señal que se genera en un momento dado mediante una lógica combinacional, siga una cadena lógica también exclusivamente combinacional y se convierta en entrada de la primera lógica.

SS004. Evitar inferencias de latches. Categoría: Error. Existen múltiple situaciones que pueden generar latches inintencionadamente. Se deben evitar todas ellas. Esta regla no es aplicable a las señales de reloj. Son:

a. Omisión de señales en listas de sensibilidad.
b. Sentencias condicionales que no determinen las salidas en todas las opciones.
c. Sentencias condicionales incompletas.

SS005. Evitar asignaciones de múltiples formas de onda. Categoría: Error. Las asignaciones con formas de onda son no-sintetizables. En general el VHDL no sintetizable debe ser evitado en síntesis.

SS006. Evitar múltiples asignaciones de una señal. Categoría: Error. Una señal debe ser asignada en un único bloque secuencial.

SS007. Evitar constantes sin asignación inmediata. Categoría: Warning. Todas las constantes deben tener un valor que debe asignarse sin que existan demoras.

SS008. Evitar usar relojes como datos. Categoría: Error. El reloj no debe mezclarse con la lógica de proceso de los datos.

SS009. Evitar que los datos se usen como reloj. Categoría: Error. Se debe evitar el que podríamos producir flancos activos a partir de pulsos imprevistos ò glitches cuyo ancho dependa de los retardos de puerta.

SS010. Evitar usar el reloj como reset ò viceversa. Categoría: Error. La misma señal de inicialización no debe emplearse como señal de evolución e igualmente al contrario.

SS011. Evitar puertas lógicas en líneas de reloj. Categoría: Error. Evitar que señales de reloj sean generadas a partir de lógica combinacional, actúen como relojes de registros. Si hubiera algún poderoso motivo para realizar una acción de diseño similar, deberá realizarse utilizando elementos especialmente diseñados para hacerlo con objetivo, siempre a bajo nivel, en cuyo caso cambiamos la categoría a nivel Warning.

SS012. Evitar dominios de relojes generados internamente. Categoría: Warning. Los dominios de relojes generados internos suelen no tener en cuenta los recursos dedicados para generar relojes. Por tanto han de ser generados con extremo cuidado.

SS013. Evitar reset asíncronos generados internamente. Categoría: Warning. Las señales de inicialización no deben generarse a partir de lógica interna, que contiene riesgos de glitches, y por tanto pulsos de forma incontrolada. Pueden generar señales de reset.

SS014. Evitar mezclar polaridades en el reset. Categoría: Error. La misma señal de reset no puede ser activa alta y baja en diferentes partes del circuito, ya que significaría que la señal de reset no tendría un estado activo concreto.

SS015. Evitar registros sin reset. Categoría: Warning. El control de reset lleva a un estado conocido un biestable con reset, si no lo tiene es imposible conocer el estado inicial de un sistema digital.

SS015. Evitar desactivar el reset de forma asíncrona. Categoría: Error. La señal de reset se debe desactivar de forma síncrona para evitar problemas de simultaneidad con el reloj.

SS016. Evitar usar valores iniciales de señales. Categoría: Error. Una señal toma un valor cuando es asignada, y por tanto los mecanismos de valores iniciales hacen que no funcionen. Distinto es que se asignen tras un reset.

SS017. Evitar la existencia de sentencias sin asignar ò no asignadas. Categoría: Error. La presencia de trozo de código que no se asignan por otras señales ò no son asignados a otras señales puede representar código muerto, pero que resulte hardware presente. Las reglas de oro en este caso son:

a. Cada registro ò latch instanciados deben ser usados y direccionados en un diseño.
b. Registros y latches que afectan a una lógica sin usar debieran ser examinados.

SS018. Asegurar la controlabilidad de todos los registros. Categoría: Error. Todos los registros han de ser accesibles desde señales de entrada primarias.

SS019. Evitar caminos combinacionales excesivamente largos. Categoría: Warning. Los caminos combinacionales no deben exceder de un determinado valor

SS020. Asegurar límites en los bucles y los anidamientos. Categoría: Warning. Las sentencias condicionales deben respetar un máximo de sentencias de anidamiento.

SS021. Asegurar consistencia en la definición del orden en los vectores. Categoría: Warning. Usar la misma formulación del orden y rango en los vectores, coherente.

SS101. Utilizar las librerías IEEE para codificar. Categoría: Error. La librería IEEE 'std_logic_1164' y la 'numeric_std' son las librerías correctas.

SS102. No usar variables en código RTL. Categoría: Warning. Las variables no dejar traza cuando se sintetizan y hay que evitar usarlas, si no se tiene esto en cuenta.

SS103. No usar comparaciones con igualdades estrictas. Categoría: Warning. Las síntesis de comparaciones con igualdades dan resultados de síntesis peores que las comparaciones simples: (< ò > en vez de <= ò >=).

SS104. Usar signed ò unsigned para hacer comparaciones y controlar tipo y rango. Categoría Error El uso de 'std_logic_vector' para hacer comparaciones puede llevar a errores impredecibles, mientras que signed ò unsigned son tipos mejor controlados.

### Revisión de código

El objetivo es redactar un código simple, fácil de leer y portable. Que pueda fácilmente reutilizarse y analizarse por los miembros del equipo de desarrollo.

RC001. Utilizar etiquetas siempre. Categoría: Note. Todas las sentencias, procesos, Bloques,… pueden ser etiquetadas para mejorar la claridad del mismo. La síntesis posterior mantiene los nombres asignados en dichas etiquetas.

RC002. Evitar diferenciar nombres usando mayúsculas y minúsculas. Categoría: Error. En VHDL no es sensible a mayúsculas y minúsculas.

RC003. Evitar usar el mismo nombre para señales en diferentes espacios de un diseño. Categoría: Warning, El mismo nombre, usado en diferentes partes del diseño, aunque tengan diferentes instancias que hagan la diferenciación, puede llevar a confusión.

RC004. Usar declaraciones de señales fácilmente reconocibles. Categoría: Note. Realizar declaraciones de las señales usando una declaración por línea.

RC005. Usar asignaciones de señales fácilmente reconocibles. Categoría: Note. Realizar asignaciones de las señales usando una declaración por línea.

RC006. Usar indentaciones consistentes. Categoría: Note. Mejorar la legibilidad de las señales realizando indentaciones consistentes.

RC007. Evitar indentaciones usando tabuladores. Categoría: Warning. Los tabuladores no deben utilizarse, debido a diferentes tratamientos por distintas plataformas.

RC008. Evitar ficheros de los diseño excesivamente largos. Categoría: Warning. Un fichero excesivamente largo resuelve muchos aspectos de un diseño. Reduce, en general, la portabilidad.

RC009. Utilizar nombres significativos para las señales relacionados con su comportamiento. Categoría: Warning. Para poder hacer un seguimiento de la funcionalidad.

RC010. Utilizar cabeceras de los ficheros consistentes. Categoría: Warning. Hacer una buena descripción del principio de funcionamiento y etiquetar bien diseño. Detalles como autor, fecha, versión, descripción, histórico, revisión,… facilitan la trazabilidad del mismo.

RC011. Utilizar suficientes comandos significativos en un solo fichero. Categoría: Warning. Un fichero ha de contener un número significativo de sentencias funcionalmente relevantes.

RC012. Utilizar suficientes comentarios en el código. Categoría: Note. Usar una buena política de comentarios.

RC013. Utilizar convenciones internas en los nombre de las señales. Categoría: Note. Una misma institución debe mantener una misma política de nombres de las señales, que sean fácilmente reconocibles. Por ejemplo, una señal activa baja puede terminar en 'z', las señales de entrada ò salida primaria deben pueden acabar en 'I' y en 'O' respectivamente.

RC101. Llamar 'clock' ò 'clk' a la señal de reloj. Categoría: Note. De esta forma es fácilmente identificable en el diseño.

RC102. Llamar 'reset' ò 'rst' a la señal de inicialización asíncrona. Categoría: Note. De esta forma es fácilmente identificable en el diseño.

RC103. Utilizar la extensión vhd en los ficheros. Categoría: Note. Los ficheros que contienen código VHDL deben ser reconocibles.

RC104. Utilizar nombres para los ficheros significativos. Categoría: Note. Los ficheros que contienen código deben hacer referencia a su contenido.

RC105. Nombrar las entidades como los ficheros. Categoría: Warning. Los ficheros han de nombrarse como las entidades que contienen hacer referencia a su comportamiento.

RC106. Usar una entidad por fichero. Categoría: Warning. Las entidades deben encapsularse con una entidad por fichero.

RC107. Usar una arquitectura por fichero. Categoría: Warning. Las arquitecturas deben encapsularse con una arquitectura por fichero.

RC108. Número de puertos I/O por línea. Categoría: Note. Por claridad, los I/O deben ocupar una por línea.

RC109. Instanciación de componentes explícitamente, por nombre. Categoría: Error. Los puertos de los componentes deben declararse explícitamente, por nombre, nunca por referencia.

RC110. Los tipos de puertos de las entidades deben seguir una organización. Categoría: Note. Seguir una ordenación coherente y previsible de los puertos de cada entidad. Por ejemplo por conectividad a otras entidades.

RC111. Puertos especiales de una entidad. Categoría: Note. Declara primeramente los puerto especiales como reloj ò reset.

RC112. Encapsular las instancias primitivas en entidades aparte. Categoría: Warning. Las primitivas hacen referencia a unidades funcionales que dependen de la tecnología de un fabricante u otro. (p. ej. memorias, PLL, multiplicadores,…). Es buena práctica escribir una entidad genérica que las determine.

RC113. Escribir los comentarios en inglés. Categoría: Note. Unificar el lenguaje para realizar los comentarios, que deben estar preferentemente en inglés.

RC114. Las simulaciones deben tener una extensión finita. Categoría: Error. La extensión de las simulaciones funcionales tienen está definida, por tanto tienen un vector final.

RC115. Uso de procedures y functions en testbech. Categoría: Error. Se recomiendan el uso de funciones y procedimientos en las sentencias de los testbenches, donde no se sintetiza un circuito.

RC116. Uso de 'wait' y 'after' en testbech. Categoría: Error. Se recomienda el uso de las sentencias wait y after en testbenches para la temporización de señales.

## Requisitos de Verificación

Verificar HDL bajo estándares vía una simple revisión puede ser considerado una manera de revisar para el cumplimiento de un estándar. Pero si se realiza mediante una herramienta automática, se debe calificar la propia herramienta.

Se debe realizar una 'evaluación absolutamente independiente' de la misma, pero dado que una vez sea la calificación de la herramienta, la propia herramienta no sustituye la revisión de ciertos aspectos del propio código. La revisión manual para entender el funcionamiento del código no puede ser sustituida por una revisión automática.

### Verificación Funcional

El VHDL así como el resto de los lenguajes de simulación utilizan un sistema basado en tabla de eventos para evaluar las sentencias del código y simulación de una entidad que ejecuta las instrucciones paralelamente. La lista de sensibilidad representa un mecanismo para vigilar la evaluación de un proceso cuando la señal sufre un cambio y por tanto emula el paralelismo inherente al hardware.

El sistema de simulación se basa en la evolución de una variable tiempo que se incrementa en un tiempo mínimo de discretización ò delta_time, y por tanto configura el entorno de simulación. Esa base de tiempo es el nivel máximo de detalle que permite discriminar la simulación. Por tanto podremos introducir modelos que describen un comportamiento de los elementos hardware sin más que implementar sus respuestas funcionales y temporales.

### Verificación Formal

La verificación formal consigue el mismo objetivo final: eliminar los errores del diseño. Una de las grandes diferencias entre la verificación formal y la funcional es el papel que desempeña la herramienta. La verificación formal utiliza un análisis estático basado en transformaciones matemáticas para determinar la corrección del comportamiento del hardware o del software, en contraste con las técnicas de verificación dinámica, como la simulación.
