# Introducción

Los sistemas de criptografía asimétrica o de clave pública utilizan dos claves distintas: una de ellas puede ser pública, la otra es privada. La posesión de la clave pública no proporciona suficiente información para determinar cuál es la clave privada. Este tipo de sistemas se basa en la dificultad de encontrar la solución a ciertos problemas matemáticos. Uno de estos problemas es el llamado logaritmo discreto. Encontrar el valor de b dada la ecuación a^b^=c, cuando a y c son valores conocidos, puede ser un problema de complejidad exponencial para ciertos grupos finitos de gran tamaño; mientras el problema inverso, la exponenciación discreta puede ser evaluado eficientemente usando por ejemplo exponenciación binaria.

En el año 1982 el Departamento de Defensa de los Estados Unidos promueve un proyecto para desarrollar un lenguaje de descripción (conocido como MIL-STD-454L) de hardware que:

* Describiera los circuitos digitales de forma amplia: Funcionalidad, tecnología y conexionado.
* Permitiera describir y verificar los circuitos a todos los niveles: funcional, arquitectural y tecnológico (posteriormente matizaremos estas tres categorías).
* Describiera la tecnología misma, para poder diseñar circuitos que sean independientes de la propia tecnología o bien durante la puesta a punto del proceso de fabricación.
* Describiera modelos del entorno en el que se va a insertar el circuito de forma que hubiese unas posibilidades de verificación más amplias del propio circuito.

El lenguaje resultante es el VHDL, que responde a las siglas VHSIC HDL (Very High Speed Integrated Circuits, Hardware Description Language), y es ratificado por el Instituto para la Ingeniería Eléctrica y Electrónica (IEEE, en 1987) en la norma IEEE-1076. Aunque en este sentido el Verilog cumple las propuestas anteriormente anunciadas, el VHDL se impone como lenguaje estándar de diseño. Posteriormente veremos diferencias generales entre uno y otro. Por el momento nos referiremos a los HDLs como lenguajes alfanuméricos comprensibles para describir circuitos electrónicos en sentido amplio. En primer lugar veremos cuál ha sido la aportación de los HDLs en la metodología clásica de diseño.
