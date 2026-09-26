---
name: "reporte-de-caso-odontologico"
description: "Construye paso a paso, en una sola conversacion, un Reporte de Caso Clinico odontologico completo, empezando por fijar el titulo con control de correspondencia (titulo, resumen, palabras clave DeCS, introduccion, presentacion del caso, discusion, conclusiones y bibliografia Vancouver), con literatura real via Consensus presentada en tabla para tu seleccion. Activala con 'EMPEZAMOS', 'REDACTA EL REPORTE DE CASO', 'ARTICULO DE REPORTE DE CASO' o cuando el usuario comparta un caso clinico propio para publicarlo."
---

# Articulo de Reporte de Caso (Odontologia)

Esta skill construye, en una sola conversacion guiada, un **Reporte de Caso Clinico** odontologico completo y publicable, siguiendo la estructura fija de la guia institucional del usuario. A diferencia de las skills hermanas (`introduccion-articulo-odontologico`, `metodologia-articulo-odontologico`, `resultados-articulo-odontologico`, `discusion-articulo-new`), que redactan una seccion de un articulo de investigacion clasico (con metodologia y resultados propios) sobre un Word ya existente, esta skill cubre **todo un reporte de caso** de punta a punta, con su propia logica: primero se fija el titulo con rigor metodologico, despues se ancla en literatura real a partir de el, y recien despues se construye sobre los datos reales del caso del usuario.

El principio que gobierna toda la skill: **nada se inventa**. Ni cifras clinicas, ni hallazgos, ni estudios, ni citas Vancouver. Cuando falte un dato real (del caso o de la literatura), se pregunta o se busca — nunca se completa con relleno generico. Si en cualquier paso surge una duda razonable (un dato ambiguo, una eleccion con mas de una opcion valida, algo que el usuario dijo pero no queda del todo claro), preguntala en el momento en vez de asumir y seguir de largo — es preferible una pregunta de mas que una decision silenciosa que despues haya que deshacer.

## Cuando activarse

Se activa cuando el usuario:
1. Escribe **"EMPEZAMOS"** (disparador corto para arrancar directo con el Paso 1), **"REDACTA EL REPORTE DE CASO"** o **"ARTICULO DE REPORTE DE CASO"** (o expresiones equivalentes: "ayudame a armar mi reporte de caso clinico", "necesito escribir un reporte de caso odontologico", "convierte este caso en un articulo"), o
2. Comparte un caso clinico propio (datos de paciente, hallazgos, procedimiento realizado) pidiendo ayuda para publicarlo o redactarlo como articulo.

### Punto de entrada: caso nuevo vs. caso ya empezado

Antes de arrancar el Paso 1, revisa si el usuario ya trae algo escrito (un Word propio, o texto pegado en el chat con alguna seccion redactada):
- **Caso nuevo (sin nada escrito):** segui el flujo completo desde el Paso 1.
- **Caso ya empezado:** leelo primero completo, identifica que secciones del listado de mas abajo ya estan resueltas (titulo, palabras clave, literatura reunida, subsecciones 2.1-2.6, introduccion, discusion, conclusiones, bibliografia, resumen) y cuales faltan o estan incompletas. Confirmale al usuario en una lista corta que detectaste como hecho y que falta, y segui el flujo **solo desde el primer paso pendiente** — no repitas trabajo ya resuelto ni vuelvas a preguntar datos que el documento ya deja claros. Si algo escrito contradice lo que el usuario cuenta ahora (una cifra distinta, un dato que cambio), señalalo y preguntá cuál vale.

Si el usuario ya subio un Word (borrador propio o la plantilla/guia institucional), usalo como base y respeta su formato. Si no subio ningun archivo, se construye desde cero con las especificaciones de formato del Paso 12 — no hace falta pedirle un Word vacio antes de empezar.

## Vista general del orden de trabajo

Este es el orden real en el que se construye el articulo — no es el orden en el que aparecen las secciones en el documento final. Seguirlo en este orden evita el error mas comun de estas skills: escribir contenido antes de tener con que fundamentarlo. El punto de partida es siempre el **titulo**: de ahi sale el diagnostico/tecnica central que ancla la busqueda de literatura, y ese titulo se revisa una ultima vez recien al final, cuando ya se sabe exactamente que se escribio.

0. Detectar si es un caso nuevo o uno ya empezado (ver arriba)
1. **Titulo tentativo → titulo mejorado (ES/EN) + autores + tutor** — con control de correspondencia, primero de todo
2. Busqueda y curaduria de literatura real (Consensus) — tabla para que el usuario seleccione
3. Palabras clave DeCS/MeSH
4. Datos reales del caso, seccion por seccion (2.1 a 2.6), incluyendo consentimiento de publicacion
5. Introduccion (con la literatura seleccionada en el paso 2)
6. Discusion (con la literatura seleccionada, aplicada al caso)
7. Conclusiones
8. Bibliografia Vancouver (consolidada)
9. Resumen (ES) + Abstract (EN) + Keywords — **siempre al final**, nunca antes
10. Capa de voz humanizada
11. Control de calidad final (extension, consistencia, citas, y re-chequeo del titulo)
12. Ensamblado del Word final con formato exacto

El usuario ya confirmo un punto importante: el Resumen/Abstract se redacta recien cuando todo lo demas esta terminado, porque resume un articulo que todavia no existe si se hace antes. No lo adelantes aunque el documento base lo liste primero.

### Guardado progresivo (no esperar al final para tener algo tangible)

A medida que se cierra cada paso grande (titulo confirmado, palabras clave confirmadas, cada subseccion de 2.1-2.6, introduccion, discusion, conclusiones, bibliografia), actualiza un archivo de trabajo en Word con lo ya construido (usando la skill `docx`, con el formato del Paso 12 aplicado desde el principio) y guardalo en `/mnt/user-data/outputs/`. No hace falta presentarlo con `present_files` en cada paso intermedio — alcanza con mencionar brevemente "ya quedo guardado hasta aca" — pero si la conversacion se corta o el usuario pregunta por el avance, el documento real ya tiene que reflejar lo hecho, no solo el historial del chat. Esto tambien es lo que permite que la deteccion de "caso ya empezado" funcione en una sesion futura.

## Paso 1 — Titulo, autores y tutor (con control de correspondencia)

Este es el primer punto de todo el proceso: tener el titulo claro es lo que permite despues buscar literatura relevante y no generica. Trabajalo con el mismo rigor que la skill `enunciado-del-estudio` aplica a un enunciado de investigacion — no alcanza con rellenar una plantilla, hay que verificar que las piezas correspondan entre si.

**1. Pedir el titulo tentativo.** Pregunta: **"¿Cual es el titulo tentativo de tu caso?"** (ej. "alargamiento coronario de primer molar inferior con fines protesicos", o directamente una frase mas armada como "regeneracion osea guiada con injerto autologo en defecto de dehiscencia vestibular"). La mayoria de las veces el usuario ya tiene algo asi en mente, aunque no este en el formato final — no hace falta que lo piense como "diagnostico" o "tecnica" por separado, para eso estas vos. Si el usuario no tiene ni un titulo tentativo y solo sabe el diagnostico o la tecnica que trato, esa respuesta alcanza igual para seguir. De esa respuesta extraes el **diagnostico o la tecnica central del caso**, que es la pieza que ancla todo el resto del articulo, incluida la busqueda de literatura del Paso 2 — no sigas sin tenerla clara.

**2. Control de correspondencia, antes de proponer nada.** Revisa que el diagnostico/tecnica que identificaste en el titulo tentativo:
- Sea **especifico**, no una categoria demasiado amplia ("periodontitis" no sirve como eje del titulo si el caso trata puntualmente una regeneracion osea guiada en un defecto concreto; el titulo tiene que nombrar la intervencion o condicion real y acotada del caso, no la familia general a la que pertenece).
- No implique una **promesa que un reporte de caso no puede sostener**: nada de "eficacia comprobada", "demuestra que", "confirma" — esas son afirmaciones que requieren una muestra, no un caso unico (n=1). Si el titulo tentativo viene fraseado asi, señalalo y proponé una version descriptiva en su lugar.
- Quepa, junto con "REPORTE DE CASO", dentro del limite de 20 palabras.

Si encontras un desajuste real en alguno de estos tres puntos, decilo antes de pasar a proponer titulos — no lo corrijas en silencio.

**3. Formato exacto del titulo (normativa confirmada por el usuario):**
- **Español:** el titulo principal **completo en mayusculas**, sin punto final, seguido de un punto y luego **"REPORTE DE CASO"** tambien en mayusculas. Patron: `[DIAGNOSTICO O TECNICA CENTRAL, EN MAYUSCULAS]. REPORTE DE CASO`. Ejemplo: `ALARGAMIENTO CORONARIO DE PRIMER MOLAR INFERIOR CON FINES PROTESICOS. REPORTE DE CASO`. No uses dos puntos (:) como separador — va con punto y espacio, como en el ejemplo, y sin punto final despues de "REPORTE DE CASO".
- **Ingles:** el mismo patron, en title case (primera letra de cada palabra principal en mayuscula) y terminando en "Case Report": `[Diagnosis Or Central Technique]. Case Report`.

**4. Ofrecer 3 variantes mejoradas, humanizadas y con voz de clinico.** A partir del titulo tentativo, propone **exactamente 3 opciones mejoradas** que cumplan el control de correspondencia y el formato del punto 3 (por ejemplo, cambiando el enfasis entre tecnica y diagnostico, o incluyendo o no la ubicacion anatomica especifica), para que el usuario elija con su propio criterio cientifico cual describe mejor su caso. Las 3 opciones tienen que sonar como las redactaria **un odontologo clinico con experiencia real**, no como una reformulacion generica de IA: aplicales el mismo criterio que `voz-cientifica-humanizada-odontologia` usa para el resto del articulo (nada de conectores de relleno, nada de formulas simetricas o de manual, terminologia precisa y natural del campo) aunque en este paso todavia no corras el control completo de esa skill — es una version liviana, aplicada solo a estas frases cortas.

**5. Entrega estructurada.** Presenta, en este orden:
- Las 3 opciones de titulo en español
- Las 3 opciones de titulo en ingles (misma correspondencia 1 a 1 con las de español)
- Estructura identificada: cual es el diagnostico/tecnica central y, si aplica, que lo distingue de una entidad o tecnica relacionada
- Advertencia de correspondencia, **solo si** encontraste un desajuste real en el punto 2 (demasiado amplio, promete de mas, excede el limite de palabras)
- Dato por completar, si falta algo para poder cerrar el titulo

**6. Respetar la aprobacion.** Cuando el usuario diga "queda asi", "ese" o una expresion equivalente, tomalo como version definitiva y no sigas ofreciendo variantes ni retocandolo por tu cuenta — salvo que el mismo pida una revision mas adelante (por ejemplo, en el control de calidad del Paso 11, si el contenido final termino apartandose de lo que el titulo promete).

Pregunta tambien los **autores** (apellido + inicial + grado academico de cada uno) y el **tutor** (nombre completo + grado academico), datos que solo el usuario tiene.

## Paso 2 — Buscar y curar literatura real con Consensus

Usa `mcp__Consensus__search` sobre el diagnostico/tecnica central identificado en el Paso 1. El objetivo de este paso no es solo "conseguir algunas citas" sino darle al usuario un panorama amplio y reciente de la literatura para que el elija con criterio cientifico propio que va a usar:

- Reuni entre **15 y 20 fuentes reales**, priorizando las **publicadas en los ultimos 5 anos** (si para un tema muy especifico no hay tantas fuentes recientes, complementa con las mas relevantes aunque sean mas antiguas, y aclaraselo al usuario).
- Para cada fuente necesitas: titulo, autores, ano, y el **enlace** que trae el resultado de Consensus (para que el usuario pueda abrirla o descargarla si quiere revisarla el mismo).
- Presentaselas en una **tabla** con estas columnas: `# | Titulo | Autores (ano) | Aporte mas relevante para el caso | Enlace`. La columna de "aporte mas relevante" es la que mas trabajo de sintesis pide: en una frase, que le aportaria especificamente a este reporte de caso (una cifra de prevalencia, una tasa de exito de una tecnica comparable, un factor de riesgo, una controversia) — no una descripcion generica del estudio.
- Despues de la tabla, pregunta al usuario cuales quiere usar (todas, algunas, o si quiere que busques mas sobre algun angulo especifico que note que falta). Si el usuario tiene dudas sobre alguna fuente (por que la incluiste, que tan solida es, si hay algo mejor), respondelas ahi mismo antes de seguir — esta es la instancia pensada para que el filtre con su propio criterio clinico, no para aprobar en bloque.

Sigue al pie de la letra las instrucciones de citacion que trae el propio resultado de Consensus (numeracion [1][2] y el bloque de fuentes) cuando le muestres la tabla. Guarda las referencias que el usuario selecciono — mas adelante, cuando armes la Bibliografia del Paso 8, se renumeran a Vancouver **en el orden en que aparezcan citadas dentro del texto del articulo**, no en el orden de esta tabla.

Si la busqueda no trae suficiente respaldo para algo que el usuario quiere afirmar (una cifra, una comparacion), decilo explicitamente en vez de inventar una referencia — es preferible una Discusion con una afirmacion menos que una con una cita falsa. Si mas adelante (Introduccion o Discusion) hace falta una referencia que no estaba en esta tabla original, volve a buscar en Consensus en vez de improvisarla.

## Paso 3 — Palabras clave DeCS/MeSH

La norma exige 3 a 5 palabras clave validadas por los descriptores DeCS — nunca terminos libres inventados. Busca los descriptores reales para los conceptos centrales del caso en **DeCS/BIREME** (decs.bvsalud.org) usando WebSearch/WebFetch (ej. buscar el termino en espanol y confirmar su descriptor oficial y su equivalente en ingles). El sitio de DeCS puede ser dificil de leer directamente por su interfaz dinamica; si WebFetch no logra extraer el descriptor, usa WebSearch dirigido (por ejemplo `site:decs.bvsalud.org <termino>`) y, si aun asi no se puede confirmar de forma automatica, mostrale al usuario el termino candidato y pedile que lo verifique el mismo en decs.bvsalud.org antes de darlo por definitivo — no lo apruebes vos por cuenta propia si no pudiste confirmarlo. Cuando el DeCS ya trae el equivalente en ingles, usalo directamente como Keyword; si necesitas confirmarlo, contrastalo contra MeSH de PubMed.

Entrega al usuario la lista final de 3-5 palabras clave (ES) con su equivalente exacto en ingles (Keywords), y de donde salio cada una (para que pueda verificarlo el mismo si quiere).

## Paso 4 — Datos reales del caso clinico (seccion 2, subsecciones 2.1 a 2.6)

Esta es la seccion mas larga y la que mas cuidado de fidelidad requiere: es un caso real, no un ejercicio. Recorre cada subseccion preguntando puntualmente lo que falte — no completes con supuestos clinicos plausibles pero no confirmados. Podes preguntar todo junto o subseccion por subseccion, segun lo que el usuario ya te haya contado.

**2.1 Informacion del paciente y motivo de consulta.** Preguntar: edad, sexo, estado de salud general, motivo de consulta y donde se atendio (clinica privada, institucion, posgrado); antecedentes medicos relevantes con **dosis exacta** de cualquier farmaco y el razonamiento clinico de por que importa para el caso ("...lo cual puede provocar..."). Pedir tambien la fotografia clinica basal para la Figura 1 (recordarle proteger la identidad del paciente: una barra en los ojos no alcanza). En este mismo bloque, confirma explicitamente que el **paciente autorizo la publicacion del caso y de sus imagenes clinicas** (esto es distinto del consentimiento informado para el procedimiento, que va en 2.5) — si el usuario no lo menciona, preguntaselo directamente antes de seguir; es un requisito editorial estandar en reportes de caso, no un dato opcional.

**2.2 Hallazgos clinicos.** Extraorales (breve: simetria facial, ATM, ganglios). Intraorales con **parametros cuantificados** — profundidad de sondaje en mm, sangrado al sondaje si/no, movilidad segun Miller/Glickman, indice de placa — nunca solo adjetivos como "inflamado" o "movil". Si el usuario da un adjetivo sin numero, repregunta por el valor exacto. Cerrar con la impresion clinica/diagnostico presuntivo.

**2.3 Evaluacion diagnostica.** Que estudio se solicito y para que decision concreta serviria (no "se pidio tomografia" a secas). El hallazgo imagenologico/de laboratorio cuantificado que justifica la tecnica elegida despues. Pedir la imagen diagnostica para la Figura 2.

**2.4 Diagnostico y plan de tratamiento.** El diagnostico definitivo en una sola oracion. El plan elegido y que alternativas se consideraron y por que se descartaron.

**2.5 Procedimiento/intervencion terapeutica.** Fragmentar en tres bloques, cada uno en parrafos cortos:
- (a) Pre-quirurgico: consentimiento informado del procedimiento, interconsultas, aprobaciones medicas.
- (b) Quirurgico: **un parrafo por paso tecnico** (acceso, elevacion/injerto, colocacion, sutura...), cada uno con accion + instrumento/material con marca, calibre, dosis o medida exacta + el motivo de esa eleccion si aplica. No resumas todo el procedimiento en un solo parrafo largo aunque el usuario te lo cuente asi — desglosalo vos al redactar.
- (c) Post-quirurgico inmediato: medicacion exacta con dosis y duracion, instrucciones al paciente, fecha de la proxima cita.

Pedir la secuencia intraoperatoria (Figura 3) y el registro posoperatorio inmediato (Figura 4).

**2.6 Evolucion y seguimiento.** Un parrafo corto por cada control, con el plazo exacto al inicio ("a los 10 dias...", "a los 6 meses...") seguido del hallazgo clinico/radiografico y la complicacion si la hubo y como se manejo. Si el usuario menciona una complicacion menor, no la omitas ni la suavices: reportarla fortalece la credibilidad del caso. Cerrar con el estado final, el plazo total de seguimiento y la satisfaccion del paciente si la tiene. Pedir el control de seguimiento a mediano/largo plazo (Figura 5, comparable con la Figura 1).

## Paso 5 — Introduccion

Con la literatura seleccionada en el Paso 2 y el caso ya definido, redacta en este orden: (1-2) definicion general de la condicion/tecnica tal como la describe la literatura, sin mencionar aun al paciente; (3-5) profundizacion — diferenciarla de una entidad relacionada o explicar el criterio tecnico/valor de corte que determinara la decision del caso mas adelante; (6-7) estado del arte terapeutico con cifras reales de estudios previos y sus controversias; parrafo final con la frase-puente que anuncia el caso (patron: "De esto nace nuestro interes en mostrar..."). Cita en Vancouver solo lo que realmente respalda cada afirmacion, y solo de las fuentes que el usuario aprobo (o de nuevas busquedas puntuales que le muestres antes de usarlas).

## Paso 6 — Discusion

Estructura fija: parrafo 1, dato de contexto (cifra epidemiologica o de eficacia real, de la literatura seleccionada); parrafo 2, factores generales de riesgo del paciente y del operador que describe la literatura, todavia sin mencionar al caso propio; parrafo 3 — **el giro clave** — tomar cada factor recien listado y verificarlo uno por uno contra los datos reales de este paciente (esto es lo que distingue una discusion publicable de una revision bibliografica pegada al final, no te lo saltees); parrafos 4-6, uno por cada decision terapeutica clave del caso, cada uno citando un estudio real con cifra concreta (tasa de exito, n, meses de seguimiento) conectada con lo hecho; parrafo final, limitaciones reales del caso (algo que no se pudo controlar del todo).

## Paso 7 — Conclusiones

Dos parrafos: (1) una afirmacion practica derivada del caso — el aprendizaje concreto para la practica clinica, no un generico "el tratamiento fue exitoso"; (2) la condicion o advertencia que matiza esa afirmacion, o una recomendacion concreta para mejorar la practica futura. Evita cerrar solo con "se necesitan mas estudios" sin haber aportado antes algo especifico que si se aprendio de este caso.

## Paso 8 — Bibliografia (Vancouver)

Recorre el articulo completo (Introduccion, Discusion, y cualquier cita que haya quedado en otras secciones) y renumera todas las citas en Normas Vancouver, **por orden de aparicion en el texto**, no por orden de la tabla del Paso 2. Arma la lista final de referencias con los datos completos de cada estudio real seleccionado (nunca completar un dato bibliografico faltante por intuicion — si falta, volve a buscarlo).

## Paso 9 — Resumen (ES), Abstract (EN) y Keywords finales

Esto se redacta **al final**, cuando todas las demas secciones ya estan escritas — nunca antes, porque resume un articulo que en ese momento todavia no existe. Un solo bloque de 150 a 250 palabras, sin subtitulos, con 3 movimientos internos:
- Parrafo interno 1 — Antecedentes: por que este caso amerita reportarse (1-2 frases sobre la condicion/tecnica antes de mencionar al paciente).
- Parrafo interno 2 — Presentacion del caso: en una secuencia condensada, en este orden: sintomas principales, hallazgos clinicos principales, diagnostico e intervencion realizada, con cifras concretas (edad, medidas, materiales).
- Parrafo interno 3 — Resultado con plazo temporal explicito ("a los X meses..."), variaciones relevantes si las hubo, y la leccion principal de cierre.

Traduce el Resumen al ingles de forma fiel para el Abstract (va en cursiva completa en el documento). Confirma las Keywords en ingles ya validadas en el Paso 3.

## Paso 10 — Capa de voz humanizada (obligatorio)

Antes de dar el articulo como definitivo, corre el texto completo por `voz-cientifica-humanizada-odontologia` (lexico prohibido, estructura/ritmo, cierres, tono, autoauditoria de 6 puntos). Ningun reporte de caso se entrega sin pasar por este control. Si una frase queda en zona gris entre "senal de IA" y estilo academico valido, seguí el protocolo de esa skill: marcarla con un comentario de Word, no decidir por cuenta propia.

## Paso 11 — Control de calidad final

Antes de ensamblar la version definitiva, revisa el articulo completo de punta a punta:
- **Correspondencia del titulo:** con el articulo ya terminado, releé el titulo aprobado en el Paso 1 y verifica que siga correspondiendo a lo que efectivamente se escribio (el diagnostico/tecnica sigue siendo el eje real del caso, no aparecio un hallazgo mas relevante en el camino que el titulo deberia reflejar). Si detectas un desajuste, planteaselo al usuario — no lo cambies por tu cuenta, es su titulo aprobado.
- **Extension:** que el total quede dentro de las 5 a 7 paginas planas exigidas; si se paso o quedo corto, decidi con el usuario que ajustar (no cortes contenido clinico real por cuenta propia sin avisar).
- **Consistencia numerica:** que un mismo dato (edad, medidas, plazos de seguimiento, dosis) no aparezca distinto en dos secciones (por ejemplo, el resumen y la presentacion del caso).
- **Consistencia terminologica:** que los nombres de la tecnica, el diagnostico y los materiales se usen igual en todo el documento.
- **Citas Vancouver:** que no haya numeros duplicados para referencias distintas, que todas las citas en el texto tengan su entrada en la bibliografia y viceversa, y que el orden de aparicion coincida con la numeracion.

Si encontras alguna inconsistencia, resolvela con el usuario antes de seguir — no la corrijas en silencio si implica elegir entre dos datos que el mismo dio en momentos distintos.

## Paso 12 — Ensamblar el Word final

Usa la skill `docx`. Especificaciones de formato, exigidas sin excepcion:

| Elemento | Especificacion |
|---|---|
| Fuente | Times New Roman, 12 puntos |
| Interlineado | 1.5, sin espacio entre parrafos |
| Tamano de hoja | Carta |
| Alineacion | Justificado |
| Margenes | 2.5 cm en los cuatro lados |
| Sangria | Primera linea de cada parrafo, 1.27 cm a la izquierda |
| Extension total | 5 a 7 paginas planas |
| Titulos de seccion | Sistema decimal (1., 1.1., 1.1.1.) |
| Titulo del articulo | Ver formato exacto del Paso 1 (mayusculas + ". REPORTE DE CASO", sin dos puntos, sin punto final) |
| Figuras | Maximo 6x4 cm, titulo "Figura N.o X." + descripcion, pie con fuente y nota aclaratoria |
| Tablas | Uso limitado; nunca repetir info ya dicha en el texto; deben explicarse solas |
| Citacion | Vancouver, numeracion correlativa por orden de aparicion |

Si el usuario subio un Word (plantilla o borrador propio), continua en ese archivo respetando su formato existente en vez de imponer uno nuevo. Si no subio ninguno, crealo desde cero replicando exactamente esta tabla, incluyendo los recuadros reservados de 6x4 cm en el lugar de cada una de las 5 figuras con su titulo y pie ya redactados (aunque la imagen en si la inserte el usuario despues). Verifica el resultado renderizandolo antes de entregarlo.

## Paso 13 — Entregar

Guarda el archivo en `/mnt/user-data/outputs/` y presentalo con `present_files`. En el mensaje de entrega (no dentro del documento), resumi brevemente: el titulo final y si sufrio algun ajuste respecto al del Paso 1, cuantas referencias reales se incorporaron de las 15-20 revisadas y cuales selecciono el usuario, las palabras clave DeCS confirmadas, el resultado del control de calidad del Paso 11, y si quedo algo pendiente de verificar con el usuario (una figura sin adjuntar, un dato clinico sin confirmar, una cifra de la literatura que no se pudo respaldar).