---
title: API CVA

language_tabs: # must be one of https://github.com/rouge-ruby/rouge/wiki/List-of-supported-languages-and-lexers
  - shell

toc_footers:
  - <span>Dudas o preguntas</span>
  - <span>Departamento de Desarrollo:</span>
  - </br>
  - <span>Juan Alfaro</span>
  - <a href="mailto:jalfaro@grupocva.com">jalfaro@grupocva.com</a>
  - </br>
  - <span>Ing. David Solórzano</span>
  - <a href="mailto:sdavid@grupocva.com">sdavid@grupocva.com</a>
  - </br>
  - <span>Ing. Christian Ochoa</span>
  - <a href="mailto:ochoac@grupocva.com">ochoac@grupocva.com</a>

includes:
  - errors

search: true

code_clipboard: true

meta:
  - name: description
    content: Documentación para los CVA SERVICES API
---

# Introducción

Bienvenido a la documentacion de la API de Grupo CVA. Nuestra API proporciona una serie de endpoints diseñados para facilitar la integración y el acceso a nuestros servicios de manera eficiente y segura.

Esta API está basada en nuestra anterior API [CVA WEB SERVICE](https://www.grupocva.com/api/docs/documentationWebService.html).

Conecta tu página con nuestro Web Service y obtén en tiempo real, inventarios, precios, promociones, descripción e imágenes de producto. Ofrecemos los datos en formato <b>JSON</b>.

# Consideraciones

Se recomienda realicen todas tus transacciones en línea (es decir que no hagas una descarga de todo el catálogo una sola vez, si no realizar las consultas al momento) porque aunque hasta el momento no hay, puede haber promociones que tengan vencimiento por hora y está en nuestro ámbito implementarlo, ustedes a través del campo de vencimiento quedan avisados de la expiración, además se darían cuenta cuando una promoción dejo de existir porque las existencias hayan agotado.

Aunque podemos proveerle el catálogo completo para que se actualice cada que usted lo consulte, este método __PARA NADA LO RECOMENDAMOS__, ya que nuestro catálogo es muy amplio y se encuentra en crecimiento constante, una consulta de esta información puede llegar a medir hasta 90 MB y consumirá ancho de banda tanto de su empresa como la nuestra, sin embargo si su aplicación así lo requiere existe este método, evítelo en la manera que te sea posible, consulte con su programador para hacer consultas específicas.

** *Al utilizar el Webservice acepta el funcionamiento del mismo y que las promociones, existencias, precios y disponibilidad puede cambiar sin previo avisa, por lo que se recomienda siempre consultar en tiempo real.*

# Autenticación

> Peticíon para generar un token:

```shell
# Asegurate de colocar las cabeceras correctas en la petición
curl --location 'http://api-cvaservices.test/api/v2/user/login' \
    --header 'Content-Type: application/json' \
    --data '{
        "user": "USUARIO",
        "password": "CONTRASEÑA" 
    }'
```

> Retorna un JSON con la siguiente estructura:

```json
{
    "usuario": {
        "id_cliente": 666,
        "clave_cliente": 66666,
        "usuario": "USUARIO"
    },
    "token": "TU_API_TOKEN"
}
```

Para poder acceder a los endpoints que listan productos, necesitas generar un token de autorización.

**Parametros del cuerpo de la petición**

Parametro | Tipo | Descripción
--------- | ----------- | -----------
user  | string |Tu usuario CVA
password | string | La contraseña de tu usuario

**Pasos a seguir**

1. **Generar el token**: Antes de hacer cualquier solicitud a los endpoints de productos, asegúrate de haber generado tu token.
2. **Enviar el token**: Cuando hagas la solicitud, incluye el token en la cabecera de todas tus solicitudes
 "Authorization" utilizando el esquema "Bearer".

Como lo siguiente:

`Authorization: Bearer YOUR_TOKEN`

<aside class="notice">
Tienes que reemplazar <code>YOUR_TOKEN</code> con tu token personal.
</aside>
<aside class="warning">
El token tiene una validez de <strong>1 hora</strong> desde su generación. Una vez que caduca, es necesario generar un nuevo token.
</aside>

# Filtro de productos

## Catálogo completo

> Peticíon para obtener la lista de precios:

```shell
# Obtiene el catalógo completo
curl --location 'http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios' \
     --header 'Authorization: Bearer TU_API_TOKEN'

# Obtiene las impresoras de la marca HP con su información del SAT
curl  --location 'http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?marca=hp&grupo=impresoras&codigosat=true' \
      --header 'Authorization: Bearer TU_API_TOKEN'
```

> La petición retorna un JSON como el siguiente:

```json
{
  "articulos": [
    {
      "id": 10431032,
      "clave": "SWS-5678",
      "codigo_fabricante": "HW-POS-NST1789I5-W-8GB/240GB",
      "descripcion": "SOFT RESTAURANT PUNTO DE VENTA POS 17 PULG/CORE I5/8GB RAM/240GB SSD/WINDOWS/VESA",
      "principal": "SOFTWARE",
      "grupo": "SOFTWARE",
      "disponible": 0,
      "marca": "SOFT RESTAURANT",
      "garantia": "SG",
      "clase": "AC",
      "moneda": "Pesos",
      "precio": 15877.44,
      "imagen": "https://www.grupocva.com/detalle_articulo/10431032.jpg",
      "disponibleCD": 0
    },
    ... Más artículos
  ]
}
```

Este endpoint retorna la lista de los productos de catálogo disponibles.

### Petición HTTP

`GET http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios`

`Authorization Bearer TU_API_TOKEN`

### Parametros de la query (Query parameters)

**Puntos a considerar**

- Si se llama el endpoint sin ningún parametro, se asume que usted quiere consultar el cátalogo de productos completo.
- Es importante mencionar que los parametros "codigo" y "clave" retornarán solamente el producto que está buscando teniendo más peso "clave".

Parametro | Tipo | Descripción
--------- | ----------- | -----------
codigo  | string | Código CVA del producto
clave  | string | Código del fabricante (Número de parte)
marca  | string | Nombre de la marca (Véase) [Marcas](#marcas)
grupo  | string | Nombre del grupo (Véase) [Grupos](#grupos)
desc  | string | Buscar mediante cadena de texto libre
porcentaje  | float | Le incrementa el porcentaje indicado al precio, para calcular utilidad
MonedaPesos | bool | regresa el precio de todos los productos en pesos méxicanos
subgrupo | bool | Regresa el subgrupo del producto
dt | bool | Regresa la descripción técnica
dc | bool | Rregresa la descripción comercial
TipoProducto | bool | 	Regresa el tipo de producto, si es producto o paquete
depto | bool | 	Regresa el departamento al que pertenece
codigosat | bool | 	Regresa la información que el SAT requiere del 
page | int | Número de página que quieres consultar de la respuesta

### Ejemplo de busqueda con parametros

Si desea buscar por uno o varios de los parámetros listados anteriormente, debe agregarlos a la URL en forma de query. Por ejemplo, si quiere filtrar sus resultados por la marca *Apple*, debe especificarlo en la petición de la siguiente manera:

`GET http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?marca=apple`

De esta manera usted puede buscar de una forma más especifica lo que busca

`GET http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?marca=hp&grupo=impresoras&codigosat=true`

** *Esta petición retornará las impresoras de la marca HP, con su información SAT.*

<aside class="notice">
Es importante mencionar que la consulta <b>TOTAL</b> del catálogo <strong>NO</strong> está disponible de las <strong>9:00</strong> hasta <strong>19:00</strong> (Hora ciudad de México) por lo que se recomienda ser lo más preciso como le sea posible con sus búsquedas, debido a la carga que representa en la base de datos.
</aside>

## Producto individual

> Buscar un producto en específico

```shell
# Busqueda por clave
curl  --location 'http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?clave=PR-2586' \
      --header 'Authorization: Bearer TU_API_TOKEN'

# Busqueda por número de pieza
curl  --location 'http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?codigo=6QN28A#BGJ' \
      --header 'Authorization: Bearer TU_API_TOKEN'
```

> Cuando la búsqueda sea exitosa se retorna una respuesta como la siguiente:

```json
{
    "id": 10412212,
    "clave": "PR-2586",
    "codigo_fabricante": "6QN28A#BGJ",
    "descripcion": "IMPRESORA HP OPS ENTERPRISE 5700DN, 45 PPM NEGRO/ COLOR, LASERJET, DUPLEX, USB, ETHERNET,BLUETOOTH, WIFI-DIRECT(SUSTITUTO M555DN)",
    "principal": "IMPRESION",
    "grupo": "IMPRESORAS",
    "disponible": 3,
    "marca": "HP",
    "garantia": "1 AÑO",
    "clase": "AC",
    "moneda": "Pesos",
    "precio": 16597.83,
    "imagen": "https://www.grupocva.com/detalle_articulo/10412212.jpg",
    "disponibleCD": 6
}
```

Este endpoint es el mismo que el anterior, pero si se envía como parámetro la clave CVA o el código del fabricante, el sistema asume que se desea obtener la información de ese producto en específico.

**Ejemplo de busqueda**

- Busca por clave

`GET http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?clave=PR-2586`

Se está buscando especificamente el producto con la clave interna de CVA "PR-2586"

- Busca por pieza

`GET http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?codigo=6QN28A#BGJ`

Se está buscando especificamente el producto por el número de pieza del fábricante "6QN28A#BGJ"

<aside class="notice">
  Toma en cuenta que para la búsqueda individual los parámetros deben ser precisos, asegúrate de tener correctas las claves que deseas consultar.
</aside>

## Por marca

> Buscar productos por marca

```shell
# Obtiene los productos de la marca Acteck
curl  --location 'http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?marca=acteck' \
      --header 'Authorization: Bearer TU_API_TOKEN'
```

> La petición retorna un JSON como el siguiente:

```json
{
    "articulos": [
        {
            "id": 10427123,
            "clave": "CS-978",
            "codigo_fabricante": "AC-935708",
            "descripcion": "GABINETE ACTECK VIKEN GM434 / MEDIA TORRE / MICRO ATX, MINI ITX / FUENTE 500W / ILUMINACION RGB / PANEL CRISTAL TEMPLADO, METAL / BLANCO / AC-935708",
            "principal": "COMPONENTES",
            "grupo": "GABINETES",
            "disponible": 3,
            "marca": "ACTECK",
            "garantia": "1 AÑO",
            "clase": "AC",
            "moneda": "Pesos",
            "precio": 637.26,
            "imagen": "https://www.grupocva.com/detalle_articulo/10427123.jpg",
            "disponibleCD": 0
        },
        ... más articulos
    ]
}
```

Con el parámetro marca, por ejemplo, ACTECK, se obtienen todos los productos de esa marca. 

Consulte el [catálogo de marcas](#marcas) para consultar todas las opciones.


### HTTP Request

`GET http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?marca=acteck`

Este parámetro no distingue entre mayúsculas y minúsculas, por lo que puede realizar su búsqueda independientemente del uso de letras minúsculas o mayúsculas.

### Query Parameters

Parametro | Tipo | Descripción | Valor por defecto
--------- | ----------- | ----------- | -----------
marca | string |Marca que se desea búscar | null


## Por grupo


> Buscar productos por grupo

```shell
# Obtiene los productos de la marca Acteck
curl  --location 'http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?grupo=bocinas' \
      --header 'Authorization: Bearer TU_API_TOKEN'
```


> La petición retorna un JSON como el siguiente:

```json
{
    "articulos": [
        {
            "id": 10431052,
            "clave": "SPK-2527",
            "codigo_fabricante": "72D1AA",
            "descripcion": "ALTAVOZ MANOS LIBRES HP POLY 72D1AA SYNC20+ M /VERSION MICROSOFT TEAMS USB-C PORTATIL CONECTIVIDAD USB Y BLUETOOTH IP64 BATERIA HASTA 20 H",
            "principal": "AUDIO",
            "grupo": "BOCINAS",
            "disponible": 1,
            "marca": "POLY",
            "garantia": "1 AÑO",
            "clase": "AC",
            "moneda": "Dolares",
            "precio": 157.79,
            "imagen": "https://www.grupocva.com/detalle_articulo/10431052.jpg",
            "disponibleCD": 0
        },
        ... más articulos
    ]
}
```

Con el parámetro grupo, por ejemplo, "Bocinas", se obtienen todos los productos que pertenezcan a ese grupo.

Consulte el [catálogo de grupos](#grupos) para consultar todas las opciones.


### HTTP Request

`GET http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?grupo=bocinas`

Este parámetro no distingue entre mayúsculas y minúsculas, por lo que puede realizar su búsqueda independientemente del uso de letras minúsculas o mayúsculas.

### Query Parameters

Parametro | Tipo | Descripción | Valor por defecto
--------- | ----------- | ----------- | -----------
grupo | string | Grupo que se desea búscar | null


## Por grupo2

> Buscar productos por grupo2

```shell
# Obtiene los productos del grupo con ID 268
curl  --location 'http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?grupo2=268' \
      --header 'Authorization: Bearer TU_API_TOKEN'

# Obtiene los productos de los grupos 268 y 15462 este filtro combina bocinas con el subgrupo bafle
curl  --location 'http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?grupo2=268,15462' \
      --header 'Authorization: Bearer TU_API_TOKEN'
```

> La petición retorna un JSON como el siguiente:

```json
{
    "articulos": [
        {
            "id": 10431052,
            "clave": "SPK-2527",
            "codigo_fabricante": "72D1AA",
            "descripcion": "ALTAVOZ MANOS LIBRES HP POLY 72D1AA SYNC20+ M /VERSION MICROSOFT TEAMS USB-C PORTATIL CONECTIVIDAD USB Y BLUETOOTH IP64 BATERIA HASTA 20 H",
            "principal": "AUDIO",
            "grupo": "BOCINAS",
            "disponible": 1,
            "marca": "POLY",
            "garantia": "1 AÑO",
            "clase": "AC",
            "moneda": "Dolares",
            "precio": 157.79,
            "imagen": "https://www.grupocva.com/detalle_articulo/10431052.jpg",
            "disponibleCD": 0
        },
        {
            "id": 10426372,
            "clave": "SPK-2495",
            "codigo_fabricante": "PC-114017",
            "descripcion": "BAFLE BLUETOOTH INALAMBRICO 8 CON MICROFONO INCLUIDO Y LUZ RGB JOY PERFECT CHOICE",
            "principal": "AUDIO",
            "grupo": "BOCINAS",
            "disponible": 8,
            "marca": "PERFECT CHOICE",
            "garantia": "1 AÑO",
            "clase": "AC",
            "moneda": "Pesos",
            "precio": 1714.27,
            "imagen": "https://www.grupocva.com/detalle_articulo/10426372.jpg",
            "disponibleCD": 6
        },
        ... más articulos
    ]
}
```

Con el parámetro grupo2, es otra manera de buscar por grupos, pero a diferencia de la manera tradicional, esta opcion te da la oportunidad de 
concaternar grupos con subgrupos.

Ten en cuenta que para buscar con el parametro grupo2, se manda el ID del/os grupos a consultar separados por coma ",".

### Ejemplos con HTTP Request

`GET http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?grupo2=268`

`GET http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?grupo2=268,15462`

### Query Parameters

Parametro | Tipo | Descripción | Valor por defecto
--------- | ----------- | ----------- | -----------
grupo2 | string | IDS de grupos a buscar separados por comas | null


## Por búsqueda genérica

> Buscar productos por búsqueda genérica

```shell
# Obtiene los productos que contengan en la descripción la palabra "GAMING"
curl  --location 'http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?desc=GAMING' \
      --header 'Authorization: Bearer TU_API_TOKEN'
```

> La petición retorna un JSON como el siguiente:

```json
{
    "articulos": [
        {
            "id": 10430953,
            "clave": "NOT-9804",
            "codigo_fabricante": "82XV00PRLM",
            "descripcion": "LAPTOP LENOVO IDEA GAMING LOQ 15IRH8 / CORE I5-12450H / 8GB DDR5 / 512GB SSD / RTX 2050 4GB / 15.6 FHD (1920X1080) / STORM GREY / WIN 11 HOME / 1 YR CS",
            "principal": "COMPUTADORAS",
            "grupo": "PORTATILES",
            "disponible": 0,
            "marca": "LENOVO",
            "garantia": "1 AÑO",
            "clase": "AC",
            "moneda": "Pesos",
            "precio": 12873.6,
            "imagen": "https://www.grupocva.com/detalle_articulo/10430953.jpg",
            "disponibleCD": 0
        },
        {
            "id": 10427317,
            "clave": "MS-1605",
            "codigo_fabricante": "CH-9319511-NA2",
            "descripcion": "MOUSE CORSAIR M65 RGB ULTRA WIRELESS /LED/ INALAMBRICO / OPTICO / 26000 DPI / GAMING/ WHITE",
            "principal": "COMPONENTES",
            "grupo": "MOUSE",
            "disponible": 1,
            "marca": "CORSAIR",
            "garantia": "1 AÑO",
            "clase": "AC",
            "moneda": "Dolares",
            "precio": 98.17,
            "imagen": "https://www.grupocva.com/detalle_articulo/10427317.jpg",
            "disponibleCD": 0
        },
        ... más articulos
    ],
}
```

Con el parámetro **desc**, puedes realizar búsquedas genéricas (realiza la búsqueda dentro de la descripcion corta de producto).
Ejemplo: una búsqueda genérica que contenga la palabra clave **GAMING**.

### Ejemplos con HTTP Request

`GET http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?desc=GAMING`

Este parámetro no distingue entre mayúsculas y minúsculas, por lo que puede realizar su búsqueda independientemente del uso de letras minúsculas o mayúsculas.

### Query Parameters

Parametro | Tipo | Descripción | Valor por defecto
--------- | ----------- | ----------- | -----------
desc | string | Palabra clave que se buscará en la descripcion de los productos | null

<aside class="warning">
Este filtro está restringido y solo se puede utilizar fuera del horario laboral de CVA. En otras palabras, no está disponible 
para su uso entre las 9:00 AM y las 7:00 PM, debido al ancho de banda que consume el utilizarlo.
</aside>

## Por solución

> Buscar productos por solución

```shell
# Obtiene los productos que contengan en la descripción la palabra "GAMING"
curl  --location 'http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?marca=acteck&Solucion=21' \
      --header 'Authorization: Bearer TU_API_TOKEN'
```


> La petición retorna un JSON como el siguiente:

```json
{
    "articulos": [
        {
            "id": 10407154,
            "clave": "AC-11776",
            "codigo_fabricante": "AC-936590",
            "descripcion": "SOPORTE ACTECK VAULT STATION BD414 / BASE PARA DIADEMA Y CONTROL / SILICON / ANTIDESLIZANTE / AJUSTABLE / NEGRO / AC-936590",
            "principal": "ACCESORIOS",
            "grupo": "ACCESORIOS",
            "disponible": 0,
            "marca": "ACTECK",
            "garantia": "SG",
            "clase": "AC",
            "moneda": "Pesos",
            "precio": 194.37,
            "imagen": "https://www.grupocva.com/detalle_articulo/10407154.jpg",
            "disponibleCD": 27
        },
        {
            "id": 10361512,
            "clave": "AC-10931",
            "codigo_fabricante": "AC-934992",
            "descripcion": "BARRA DE LUZ PARA LAPTOP Y MONITOR LUMINATE SHADE BL460 / ULTRA DELGADO / USB C / NEGRO/ ADVANCED SERIES / AC-934992",
            "principal": "ACCESORIOS",
            "grupo": "ACCESORIOS",
            "disponible": 5,
            "marca": "ACTECK",
            "garantia": "1 AÑO",
            "clase": "AC",
            "moneda": "Pesos",
            "precio": 265.88,
            "imagen": "https://www.grupocva.com/detalle_articulo/10361512.jpg",
            "disponibleCD": 0
        }
    ],
    ...
}
```

Usando el parámetro `Solucion=(ID de Solucion)`, puedes filtrar productos específicos según la solución deseada. Para consultar el ID de 
cada solución, revisa el catálogo de Soluciones.

Por ejemplo, al utilizar `Solucion=21` y `marca=Acteck`, la consulta filtrará los productos de la categoría "Gamer" que pertenecen a 
la marca Acteck.

Consulte el [catálogo de soluciones](#soluciones) para consultar todas las opciones.

### Ejemplos con HTTP Request

`GET http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?marca=acteck&Solucion=21`

### Query Parameters

Parametro | Tipo | Descripción | Valor por defecto
--------- | ----------- | ----------- | -----------
Solucion | int | Este parametro aplicará el filtro con la solución | null

# Parametros adicionales

## Precio especial ME

```shell
# Obtiene los productos que contengan en la descripción la palabra "GAMING"
curl  --location 'http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?clave=PR-2586&TipoCompra=true' \
      --header 'Authorization: Bearer TU_API_TOKEN'
```

> La petición retorna un JSON como el siguiente:

```json
{
    {
    "id": 10412212,
    "clave": "PR-2586",
    "codigo_fabricante": "6QN28A#BGJ",
    "descripcion": "IMPRESORA HP OPS LASERJET ENTERPRISE 5700DN, 45 PPM NEGRO/ COLOR, LASER COLOR, USB, WIFI, ETHERNET (RED), DUPLEX, ADF, BLUETOOTH (SUSTITUTO M555DN)",
    "principal": "IMPRESION",
    "grupo": "IMPRESORAS",
    "disponible": 0,
    "marca": "HP",
    "garantia": "1 AÑO",
    "clase": "AC",
    "moneda": "Pesos",
    "precio": 16930.58, <--- Precio especial
    "imagen": "https://www.grupocva.com/detalle_articulo/10412212.jpg",
    "disponibleCD": 6
}
}
```

Los productos tienen un precio especial cuando se ordenan a través del sistema ME. Para que el Webservice muestre este precio, debes utilizar el parámetro `TipoCompra = true`. Por defecto, se muestran los precios aplicables al levantar los productos en la sucursal.

### Query Parameters

Parametro | Tipo | Descripción | Valor por defecto
--------- | ----------- | ----------- | -----------
TipoCompra | bool | Activa el precio especial ME | false

✅ Este parámetro se puede aplicar tanto a consultas que retornan un solo producto como a aquellas que devuelven una lista de productos.

<aside class="notice">
Si activas este parámetro, recuerda que el precio especial solo se respeta si los productos se levantan en el sistema ME.
</aside>

## Porcentaje de útilidad

> Agregar porcentaje

```shell
# Obtiene los productos que contengan en la descripción la palabra "GAMING"
curl  --location 'http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?clave=PR-2586&porcentaje=16' \
      --header 'Authorization: Bearer TU_API_TOKEN'
```

> La petición retorna un JSON como el siguiente:

```json
{
    "id": 10412212,
    "clave": "PR-2586",
    "codigo_fabricante": "6QN28A#BGJ",
    "descripcion": "IMPRESORA HP OPS ENTERPRISE 5700DN, 45 PPM NEGRO/ COLOR, LASERJET, DUPLEX, USB, ETHERNET,BLUETOOTH, WIFI-DIRECT(SUSTITUTO M555DN)",
    "principal": "IMPRESION",
    "grupo": "IMPRESORAS",
    "disponible": 3,
    "marca": "HP",
    "garantia": "1 AÑO",
    "clase": "AC",
    "moneda": "Pesos",
    "precio": 19253.48,
    "imagen": "https://www.grupocva.com/detalle_articulo/10412212.jpg",
    "disponibleCD": 6
}
```

Con el parámetro **porcentaje**, permite aumentar un porcentaje sobre nuestro precio para calcular su utilidad.

### Ejemplos con HTTP Request

Subir porcentaje de 16% al producto con clave PR-2586, lo que aumentará directamente en el nodo "precio" del producto ese porcentaje.

`GET http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?clave=PR-2586&porcentaje=16`


<aside class="notice">
Los precios sin porcentaje se encuentran sin IVA, por lo que es recomendable agregar el IVA en el porcentaje para contemplar el impuesto.
</aside>

### Aplicar descuento a lista de productos

Aplicar el paramerametro en consultas que retornan más de un nodo aumentará el porcentaje sobre el precio en todos los nodos de la respuesta.

`http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?clave=PR-2586&porcentaje=16`

### Query Parameters

Parametro | Tipo | Descripción | Valor por defecto
--------- | ----------- | ----------- | -----------
porcentaje | int | Le incrementa el porcentaje indicado al precio, para calcular utilidad | null

## Promociones

> Promociones:

```shell
curl --location 'http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?marca=ghia&promos=true' \
     --header 'Authorization: Bearer TU_API_TOKEN'
```

> La petición agrega a la respuesta JSON la llave "promociones":

```json
{
    "articulos": [
        {
            "id": 10430092,
            "clave": "PCGHIA-3454",
            "codigo_fabricante": "AMD RYZEN SERIES",
            "descripcion": "GHIA FRONTIER SLIM 2.0 / AMD RYZEN 5 5600GT MAX 4.6 GHZ / RAM 8 GB / SSD NVME 1 TB / WIN 11 PRO",
            "principal": "COMPUTADORAS",
            "grupo": "PC´S",
            "disponible": 0,
            "marca": "GHIA",
            "garantia": "1 AÑO",
            "clase": "AC",
            "moneda": "Pesos",
            "precio": 8443.89,
            "imagen": "https://www.grupocva.com/detalle_articulo/10430092.jpg",
            "disponibleCD": 0,
            "promociones": {
                "total_descuento": 10,
                "moneda_descuento": "Dolares",
                "precio_descuento": 8250.59,
                "moneda_precio_descuento": "Pesos",
                "clave_promocion": 608796,
                "descripcion_promocion": "\"¡Actualiza tu poder! Descuentos en equipos con procesadores AMD Ryzen, promocion sujeta a unidades",
                "promocion_vencimiento": "28/09/2024",
                "disponible_en_promocion": 0
            }
        },
        ...
    ]
}
```

En CVA, manejamos una lista de promociones disponibles para nuestros productos. Si un producto tiene más de una promoción aplicable, siempre seleccionamos la que ofrece el mejor descuento. Para activar la aplicación de promociones, utiliza el parámetro `promos = true`

### Query parameters

Parametro | Tipo | Descripción | Valor por defecto
--------- | ----------- | ----------- | -----------
promos | bool | Mostrará la información de la promoción que se encontró | false

### Ejemplos HTTP REQUEST

- Obtener todos los productos de la marca "_GHIA_", con sus promociones.

`GET http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?marca=ghia&promos=true`

- Obtener el producto con clave "_PCGHIA-3454_", con sus promociones.

`GET http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?clave=PCGHIA-3454&promos=true`

✅ Este parámetro se puede aplicar tanto a consultas que retornan un solo producto como a aquellas que devuelven una lista de productos.

⚠️ No todos los productos tienen promociones, por lo que algunos regresan el valor `null` en su lugar.

### IMPORTANTE

Toma lo siguiente en cuenta con las promociones:

<aside class="notice">
Es crucial tener en cuenta el vencimiento de las promociones. Las promociones pueden expirar por fecha o por agotamiento de existencias. Por lo tanto, es su responsabilidad verificar esta información y considerarla al ofrecer las promociones. Tengan en cuenta que el precio mostrado podría cambiar si las existencias se agotan antes de realizar el pedido.
</aside>

** *Al utilizar el Webservice usted acepta el funcionamiento del mismo y que las promociones, existencias, precios y disponibilidad puede cambiar sin previo aviso, por lo que se recomienda siempre consultar en tiempo real.*

## Manejo de paquetes

> Ejemplo de solicitud

```shell
curl --location 'http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?clave=PAQ-586&TipoProducto=true' \
     --header 'Authorization: Bearer TU_API_TOKEN'
```

> Respuesta completa

```json
{
    "id": 10132410,
    "clave": "PAQ-586",
    "codigo_fabricante": "DELL",
    "descripcion": "Kit Teclado KB-645 Mouse MS-1105",
    "principal": null,
    "grupo": null,
    "disponible": 0,
    "marca": null,
    "garantia": "SG",
    "clase": "AC",
    "moneda": "Pesos",
    "precio": 307.52,
    "imagen": "https://www.grupocva.com/detalle_articulo/10132410.jpg",
    "disponibleCD": 0,
    "producto_paquete": {
        "tipo": "PAQUETE",
        "componentes": "MS-1105, KB-645"
    }
}
```

La logística de CVA establece que los paquetes no siempre tienen marca, grupo o clasificadores generales. Estos clasificadores son más 
comunes en los productos individuales. Al agregar el parámetro `TipoProducto = true`, se determina si se muestra el campo "*producto_paquete*".

Campo **producto_paquete**:

- Si el producto es simple, el valor será __PRODUCTO__.
- Si el producto es un paquete, el valor será __PAQUETE__.

Parametro | Tipo | Descripción | Valor por defecto
--------- | ----------- | ----------- | -----------
TipoProducto | bool | Mostrará la información del paquete en caso de que lo sea. | false

✅ Este parámetro se puede aplicar tanto a consultas que retornan un solo producto como a aquellas que devuelven una lista de productos.

Elemento **componentes**

> campo que se le añadio

```json
"producto_paquete": {
        "tipo": "PAQUETE",
        "componentes": "MS-1105, KB-645"
}
```
- Este elemento lista los productos que conforman el paquete (cuando valor es __PAQUETE__), permitiendo al usuario listar 
las claves CVA de cada componente que conforma el pedido.

- Los elementos dentro del campo "__componentes__", siempre son claves CVA.

## Disponibilidad en sucursales

> Disponibilidad en sucursales

```shell
curl --location 'http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?clave=CV-1856&sucursales=true' \
     --header 'Authorization: Bearer TU_API_TOKEN'
```

> La petición retorna un JSON como el siguiente:

```json
{
    "articulos": [
        {
            ... campos adicionales
            "disponibilidad_sucursales": [
                {
                    "nombre": "MEXICO CENTRO DE DISTRIBUCION",
                    "disponible": 0
                },
                {
                    "nombre": "MONTERREY CENTRO DE DISTRIBUCION",
                    "disponible": 0
                },
                {
                    "nombre": "VENTAS CANCUN",
                    "disponible": 0
                },
                {
                    "nombre": "VENTAS CHIHUAHUA",
                    "disponible": 0
                },
                {
                    "nombre": "VENTAS COLIMA",
                    "disponible": 0
                },
                {
                    "nombre": "VENTAS CULIACAN",
                    "disponible": 0
                },
                {
                    "nombre": "VENTAS DF TALLER",
                    "disponible": 0
                },
                {
                    "nombre": "VENTAS HERMOSILLO",
                    "disponible": 0
                },
                {
                    "nombre": "VENTAS LEON",
                    "disponible": 0
                },
                {
                    "nombre": "VENTAS MERIDA",
                    "disponible": 0
                },
                {
                    "nombre": "VENTAS MONTERREY",
                    "disponible": 10
                },
                {
                    "nombre": "VENTAS MORELIA",
                    "disponible": 0
                },
                {
                    "nombre": "VENTAS OAXACA",
                    "disponible": 0
                },
                {
                    "nombre": "VENTAS PACHUCA",
                    "disponible": 0
                },
                {
                    "nombre": "VENTAS PUEBLA",
                    "disponible": 0
                },
                {
                    "nombre": "VENTAS QUERETARO",
                    "disponible": 0
                },
                {
                    "nombre": "VENTAS TEPIC",
                    "disponible": 0
                },
                {
                    "nombre": "VENTAS TOLUCA",
                    "disponible": 5
                },
                {
                    "nombre": "VENTAS TORREON",
                    "disponible": 0
                },
                {
                    "nombre": "VENTAS TUXTLA",
                    "disponible": 0
                },
                {
                    "nombre": "VENTAS VERACRUZ",
                    "disponible": 0
                },
                {
                    "nombre": "VENTAS VILLAHERMOSA",
                    "disponible": 0
                },
                {
                    "nombre": "TOTAL",
                    "disponible": 15
                }
            ]
        },
        ... más productos
    ]
```
Consulta la disponibilidad de el/los productos en cada una de las sucursales.

### Ejemplos con HTTP Request

- Busca la disponibilidad en sucursales del producto con clave "_CV-1856_"

`GET http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?clave=CV-1856&sucursales=true`

- Busca la disponibilidad en sucursales de todos los productos de la marca "_ghia_"

`GET http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?marca=ghia&sucursales=true`


✅ Este parámetro se puede aplicar tanto a consultas que retornan un solo producto como a aquellas que devuelven una lista de productos.

### Query Parameters

Parametro | Tipo | Descripción | Valor por defecto
--------- | ----------- | ----------- | -----------
sucursales | bool | Mostrará la existencia del producto en cada una de las sucursales | false

** *El Precio de un producto puede variar de una sucursal a otra así como el precio del flete depende de la distancia origen y destino.*

<aside class="notice">
El Precio de un producto puede variar de una sucursal a otra así como el precio del flete depende de la distancia origen y destino.
</aside>

## Subgrupo

Si el parametro `subgrupo = true` se agrega a la respuesta el nodo en el que indica el subgrupo del producto.

> Obtener subgrupo de el/los artículos

```shell
curl  --location 'http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?clave=KB-890&subgpo=true' \
      --header 'Authorization: Bearer TU_API_TOKEN'
```

> La petición agrega a la respuesta JSON la llave:

```json
{
    "subgrupo": "GAMERS"
}
```

### Ejemplos HTTP REQUEST

Obtener el subgrupo del producto con clave: KB-890

`http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?clave=KB-890&subgpo=true`

Obtener el subgrupo de todos los articulos de una lista de productos

`http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?subgpo=true`

### Query Parameters

Parametro | Tipo | Descripción | Valor por defecto
--------- | ----------- | ----------- | -----------
subgpo | bool | Mostrará el nombre del subgrupo del producto | false

## Mostrar tipo de cambio

Si el parámetro `tc = true` se añadirán los campos de valor de tipo de cambio de dólar y su última fecha de actualización por nuestra parte, si está en cero o no incluyes el parámetro no se mostrá el elemento en la respuesta.

> Mostrar tipo de cambio

```shell
curl  --location 'http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?clave=KB-890&tc=true' \
      --header 'Authorization: Bearer TU_API_TOKEN'
```

> La petición agrega a la respuesta JSON las llaves:

```json
{
    "tipo_cambio": 18.07,
    "fecha_actualizacion_tipo_cambio": "19/07/2024 11:04:18"
}
```

### Ejemplos HTTP REQUEST

Obtener el producto con clave: **KB-890** con su tipo de cambio

`http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?clave=KB-890&tc=true`

### Query Parameters

Parametro | Tipo | Descripción | Valor por defecto
--------- | ----------- | ----------- | -----------
tc | bool | Mostrará el tipo de cambio | false

✅ Este parámetro se puede aplicar tanto a consultas que retornan un solo producto como a aquellas que devuelven una lista de productos.

<aside class="notice">
Se aclara que el uso del tipo de cambio publicado es totalmente del dominio de CVA, sujeto a cambios durante el día sin previo aviso (es por eso que también te estamos brindando la fecha de última actualización del tc), <b>SE RECOMIENDA</b> realizar las actualizaciones en tiempo real, de esa manera siempre se tiene el precio actualizado incluso con los cambios que se puedan generar en el día.
</aside>

## Parámetro "tipo"

Si el parámetro `tipo = true` entonces la API te agregará una llave al JSON de respuesta **"TipoProducto"**  Este es el equivalente para el servicio web de los “productos por salir” estos productos están disponibles solo hasta agotar existencias y no genera backorder o sea que no compran aunque sean solicitados (se ponen por salir porque es posible que ni el proveedor siga surtiendo el producto o este descontinuado), ósea que se debe limitar a ofrecer la existencia mostrada.

> Parámetro "tipo"

```shell
curl  --location 'http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?clave=SPK-2093&tipo=true' \
      --header 'Authorization: Bearer TU_API_TOKEN'
```

> La petición agrega a la respuesta JSON las llaves:

```json
{
    "tipo_producto": "EXISTENCIA"
}
```

### Ejemplos HTTP REQUEST

Obtener el producto con clave: **SPK-2093** con su tipo de cambio

`GET http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?clave=SPK-2093&tipo=true`

### Query Parameters

Parametro | Tipo | Descripción | Valor por defecto
--------- | ----------- | ----------- | -----------
tipo | bool | Mostrará el tipo de producto | false

✅ Este parámetro se puede aplicar tanto a consultas que retornan un solo producto como a aquellas que devuelven una lista de productos.

## Parámetro "Depto"

> Parámetro "Depto"

```shell
curl  --location 'http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?clave=SPK-2093&depto=true' \
      --header 'Authorization: Bearer TU_API_TOKEN'
```

> La petición agrega a la respuesta JSON las llaves:

```json
{
    "departamento": {
        "id": 1261,
        "nombre": "POR SALIR"
    }
}
```

CVA clasifica los productos de acuerdo a su tiempo de vida o de acuerdo a su forma de adquirir o comprar el producto, al activar el parámetro
 `depto = true` la respuesta regresará una llave dentro de la respuesta JSON llamada **"Departamento"** en donde puede contener una serie de nomenclaturas.

### Significado de las nomenclaturas

 Valor | Significado
--------- | -----------
A | PRODUCTO CON VENTA ALTA LOS PRODUCTOS TIENEN UNA EXISTENCIA ALTA Y REGULAR EN LAS SUCURSALES.
B | PRODUCTO CON VENTAS MEDIAS LOS PRODUCTOS TIENEN MEDIANA EXISTENCIA Y SU RESURTIDO ES REGULAR.
C | PRODUCTO CON BAJAS VENTAS ESTE PRODUCTO MANTIENE UN INVENTARIO BAJO.
POR SALIR | YA NO SE SURTE Y ESTARA LIMITADA A LAS EXISTENCIAS ACTUALES.
S P C D | SE TIENE EXISTENCIA EN EL CENTRO DE DISTRIBUCION
SPF | PRODUCTOS BAJO PEDIDO.

### Ejemplos HTTP REQUEST

Obtener el producto con clave: **SPK-2093** con su departamento.

`GET http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?clave=SPK-2093&depto=true`

### Query Parameters

Parametro | Tipo | Descripción | Valor por defecto
--------- | ----------- | ----------- | -----------
depto | bool | Mostrará el departamento del producto | false

✅ Este parámetro se puede aplicar tanto a consultas que retornan un solo producto como a aquellas que devuelven una lista de productos.

## Descripciones enriquecidas

> Descripciones enriquecidas

```shell
curl  --location 'http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?clave=SPK-2093&dt=true&dc=true' \
      --header 'Authorization: Bearer TU_API_TOKEN'
```

> La petición agrega a la respuesta JSON las llaves:

```json
{
    "ficha_tecnica": "HEADSET - MAGENTA ( TIPO DIADEMA ) - TAMANO BOCINA: 40MM- INDEPENDIENCIA: 32 ohms±15%- SENSIBILIDAD: 108 dB±3db- RANGO DE FRECUENCIA: 20Hz 2000Hz- MICROFONO: 6MM X 5MM- SENSIBILIDAD DE MICROFONO: -38dB±3db- INDEPENDENCIA DE MICROFONO: 2200ohms- DIRECCION: TODAS LAS DIRECCIONES- LARGO DE LINEA: 2.2M±15%- VOLTAJE DE TRABAJO DE LED : 5V cc- CORRIENTE DE TRABAJO: 100mA- INTERFAZ DE AURICULAR:  USB+3.5- CONTROL DE AUDIO- MICROFONO RETRACTIL CON CANCELACION DE RUIDO- ADAPTADOR DE AUDIO PARA PC- CABLE CON RECUBRIMIENTO EN NAILON- OREJAS DESMONTABLES - COMPATIBLE CON: XBOX, PLAYSTATION, WINDOWS, ANDROID, LINUX Y MAC- UN ANO DE GARANTIA",
    "ficha_comercial": "JUEGA COMO UN PROFECIONAL CON LOS HEADSET \"OGH03\" DISENADOS PARA UN VERDADERO GAMER.DISFRUTA DEL MEJOR RENDIMINETO DE AUDIO CON LA MEJOR COMODIDAD GRACIAS A SUS ALHOMADILLAS BIEN ALCOCHONADAS QUE TE PERMITEN MANTENER EL RUIDO EXTERIOR AL MINIMO Y DISFRUTAR DE UN SONIDO CLARO, MICROFONO CON CANCELACION DE RUIDO PARA UNA COMUNICACION CLARA MIENTRAS JUEGAS.- COMPATIBLE CON: XBOX, PLAYSTATION, WINDOWS, ANDROID, LINUX Y MAC"
}
```

Usted tiene la opción de mandar los parametros `dt = true` y `dc = true` 

El parámetro `dt` se encarga de agregar la información técnica dentro de la respuesta JSON.

El parámetro `dc` se encarga de agregar la información comercial dentro de la respuesta JSON.

### Query parameters

Parametro | Tipo | Descripción | Valor por defecto
--------- | ----------- | ----------- | -----------
dt | bool | Mostrará la descripción técnica del producto | false
dc | bool | Mostrará la descripción comercial del producto | false

### Ejemplos HTTP REQUEST

Obtener el producto con clave: **SPK-2093** con sus descripciones.

`GET http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?clave=SPK-2093&dt=true&dc=true`

✅ Este parámetro se puede aplicar tanto a consultas que retornan un solo producto como a aquellas que devuelven una lista de productos.

## UPC

> Agregar UPC a la respuesta del producto

```shell
curl --location 'http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?marca=PHILIPS&upc=true' \
--header 'Authorization: Bearer TU_API_TOKEN'
```

> La petición agrega a la respuesta JSON las llaves:

```json
{
    "upc": "840063202375"
}
```

Para obtener el UPC _(Código Universal de Producto)_ de producto se debe añadir el parametro `upc = true`

### Query parameters

Parametro | Tipo | Descripción | Valor por defecto
--------- | ----------- | ----------- | -----------
upc | bool | Mostrará el código univesal del producto | false

### Ejemplos HTTP REQUEST

Obtener el UPC de los productos de la marca `Philips`.

`GET http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?marca=PHILIPS&upc=true`

✅ Este parámetro se puede aplicar tanto a consultas que retornan un solo producto como a aquellas que devuelven una lista de productos.

## Información SAT

> Agregar información del SAT a la respuesta del producto

```shell
curl --location 'http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?clave=KB-645&codigosat=true' \
--header 'Authorization: Bearer TU_API_TOKEN'
```

> La petición agrega a la respuesta JSON las llaves:

```json
"sat_info": {
    "clave": 43211706,
    "descripcion": "Teclados"
}
```

Para obtener la descripción del SAT _(Servicio de Administración Tributaria)_ del producto se debe añadir el parametro `codigosat = true`

### Query parameters

Parametro | Tipo | Descripción | Valor por defecto
--------- | ----------- | ----------- | -----------
codigosat | bool | Mostrará el id y la descripción SAT del producto | false

### Ejemplos HTTP REQUEST

Obtener la información SAT del producto `KB-645`.

`GET http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?clave=KB-645&codigosat=true`

✅ Este parámetro se puede aplicar tanto a consultas que retornan un solo producto como a aquellas que devuelven una lista de productos.

## Imágenes

> Imágenes

```shell
curl  --location 'http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?clave=SPK-2093&images=true' \
      --header 'Authorization: Bearer TU_API_TOKEN'
```

> La petición agrega a la respuesta JSON las llaves:

```json
{
    "id": 10253052,
    "clave": "SPK-2093",
    "codigo_fabricante": "OGH03",
    "descripcion": "AUDIFONOS GAMER OCELOT TIPO DIADEMA/OVER-EAR/USB/3.5MM/COLOR ROSA CON NEGRO/ALAMBRICOS/ILUMINACION BLANCA/CONTROL DE AUDIO/MICROFONO CANCELACION DE RUIDO/AJUSTABLES/MULTIPLATAFORMA",
    "principal": "AUDIO",
    "grupo": "AUDIFONOS Y MICRO",
    "disponible": 240,
    "marca": "OCELOT GAMING",
    "garantia": "1 AÑO",
    "clase": "AC",
    "moneda": "Dolares",
    "precio": 19.89,
    "imagen": "https://www.grupocva.com/detalle_articulo/10253052.jpg",
    "disponibleCD": 61,
    "imagenes": [
        "https://www.grupocva.com/detalle_articulo/img_large.php?id=323327",
        "https://www.grupocva.com/detalle_articulo/img_large.php?id=323331",
        "https://www.grupocva.com/detalle_articulo/img_large.php?id=323330",
        "https://www.grupocva.com/detalle_articulo/img_large.php?id=323328",
        "https://www.grupocva.com/detalle_articulo/img_large.php?id=323329"
    ],
}
```

Para obtener imágenes de alta resolución de tu producto tiene que enviar el parámeto `images = true`.

Esta forma de consultar imágenes resulta más conveniente, sin embargo si sólo requiere lás imágenes sin ninguna información extra, es
recomendable usar [Imágenes](#imagenes-2).

### Query parameters

Parametro | Tipo | Descripción | Valor por defecto
--------- | ----------- | ----------- | -----------
images | bool | Mostrará el arreglo de imágenes ligadas al producto | false

### Ejemplos HTTP REQUEST

Obtener el producto con clave: **SPK-2093** con sus imágenes.

`GET http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?clave=SPK-2093&images=true`

✅ Este parámetro se puede aplicar tanto a consultas que retornan un solo producto como a aquellas que devuelven una lista de productos.

⚠️ No todos los productos tienen imágenes, por lo que algunos regresan el valor `null`

<aside class="warning">
<b>NO</b> se recomienda enviar este parámetro en consultas que devuelvan una lista extensa de productos, ya que esto puede <b>aumentar</b> 
drásticamente el <b>tiempo de respuesta</b> de la API. Se aconseja utilizar este parámetro únicamente en consultas individuales para garantizar
un rendimiento óptimo.
</aside>

## Dimensiones del producto

> Agregar porcentaje

```shell
# Obtiene los productos que contengan en la descripción la palabra "GAMING"
curl --location 'http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?clave=FRE-6&dimen=true' \
     --header 'Authorization: Bearer TU_API_TOKEN'
```

> La petición retorna un JSON como el siguiente:

```json
{
    {
    "id": 10367838,
    "clave": "FRE-6",
    "codigo_fabricante": "MFA01",
    "descripcion": "FREIDORA DE AIRE DIGITAL MIRATI CON CAPACIDAD DE 5 LITROS, 7 MODOS PREESTABLECIDOS, TEMPERATURA DE 60C-200C",
    "principal": "PREPARACIÓN DSE ALIMENTOS",
    "grupo": "PREPARACIÓN DSE ALIMENTOS",
    "disponible": 0,
    "marca": "MIRATI",
    "garantia": "1 AÑO",
    "clase": "AC",
    "moneda": "Pesos",
    "precio": 627.41,
    "imagen": "https://www.grupocva.com/detalle_articulo/10367838.jpg",
    "disponibleCD": 0,
    "dimensiones": {
        "medidas": "0.354, 0.336, 0.336",
        "alto": 0.354,
        "ancho": 0.336,
        "profundidad": 0.336,
        "peso": 5,
        "unidad_logitud": "M",
        "unidad_peso": "KG"
    }
}
}
```

Para consultar las dimensiones de un producto, utiliza el parámetro `dimen=1` Este parámetro retornará las dimensiones en metros 
y el peso en kilogramos.

### Ejemplos con HTTP Request

Obtener el producto con clave "_FRE-6_" con sus dimensiones. 

`GET http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?clave=FRE-6&dimen=true`

✅ Este parámetro se puede aplicar tanto a consultas que retornan un solo producto como a aquellas que devuelven una lista de productos.

## Transito a sucursal

> Obtener el transito a sucursal

```shell
# Obtiene los el tránsito a sucursal
curl --location 'http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?clave=CSP-438&trans=true' \
     --header 'Authorization: Bearer TU_API_TOKEN'
```

> La petición agrega a la respuesta JSON las llaves:

```json
{
    "en_transito": 3
}
```

Utilizando el parámetro `trans=1` podemos obtener la cantidad en tránsito a la sucursal.

### Ejemplos con HTTP Request

Obtener el producto con clave "_CSP-438_" con su cantidad en tránsito. 

`GET http://api-cvaservices.test/api/v2/catalogo_clientes/lista_precios?clave=CSP-438&trans=true`

✅ Este parámetro se puede aplicar tanto a consultas que retornan un solo producto como a aquellas que devuelven una lista de productos.

### Query parameters

Parametro | Tipo | Descripción | Valor por defecto
--------- | ----------- | ----------- | -----------
trans | bool | Mostrará la cantidad en tránsito a la sucursal | false

# Información técnica

## Obtener la información técnica de un producto

> Obtener información técnica del producto

```shell
# Obtiene los productos que contengan en la descripción la palabra "GAMING"
curl --location 'http://api-cvaservices.test/api/v2/catalogo_clientes/informacion_tecnica?clave=RELOJ-27' \
     --header 'Authorization: Bearer TU_API_TOKEN'
```

> La petición retorna un JSON como el siguiente:

```json
{
    "especificaciones": [
        {
            "nombre": "MONITOREA",
            "valor": "CALORIAS"
        },
        {
            "nombre": "MONITOREA",
            "valor": "PASOS "
        },
        {
            "nombre": "LLAMADA ENTRANTE",
            "valor": "SI "
        },
        {
            "nombre": "RESISTENTE AL AGUA",
            "valor": "SI"
        },
        {
            "nombre": "INCLUYE ALTAVOZ",
            "valor": "SI"
        },
        {
            "nombre": "DISPLAY TACTIL",
            "valor": "SI"
        },
        {
            "nombre": "NOTIFICACIONES",
            "valor": "TWITTER"
        },
        {
            "nombre": "NOTIFICACIONES",
            "valor": "SI"
        },
        {
            "nombre": "NOTIFICACIONES",
            "valor": "FACEBOOK"
        },
        {
            "nombre": "NOTIFICACIONES",
            "valor": "LLAMADA ENTRANTE"
        },
        {
            "nombre": "NOTIFICACIONES",
            "valor": "WHATS APP"
        },
        {
            "nombre": "NOTIFICACIONES",
            "valor": "CORREO ELECTRONICO"
        },
        {
            "nombre": "INTERFAZ",
            "valor": "BLUETOOTH"
        },
        {
            "nombre": "COMPATIBILIDAD",
            "valor": "ANDROID 4.3 O SUPERIOR"
        },
        {
            "nombre": "COMPATIBILIDAD",
            "valor": "IOS 8 O SUPERIOR"
        },
        {
            "nombre": "RESOLUCION",
            "valor": "240 X 240 P"
        },
        {
            "nombre": "TIPO DE MATERIAL",
            "valor": "METAL"
        },
        {
            "nombre": "TIPO DE MATERIAL",
            "valor": "HULE"
        },
        {
            "nombre": "DURACION DE BATERIA APROXIMADA",
            "valor": "24 HRS"
        },
        {
            "nombre": "COLOR",
            "valor": "BLANCO"
        },
        {
            "nombre": "TIPO DE PANTALLA",
            "valor": "LCD"
        },
        {
            "nombre": "RESISTENTE A SALPICADURAS",
            "valor": "SI"
        }
    ]
}
```

Puedes obtener la información técnica de un producto desglosada en sus características principales. 
Para ello, debes utilizar el parámetro `clave`.

### Ejemplos con HTTP Request

Obtener la información técnica del prodcuto con clave **_RELOJ-27_**.

`GET http://api-cvaservices.test/api/v2/catalogo_clientes/informacion_tecnica?clave=RELOJ-27`


<aside class="notice">
Para consultar esta información es necesario enviar tu token de acceso.
</aside>

# Imágenes


## Imágenes de mejor calidad

> Petición para obtener las imágenes

```shell
curl --location 'http://api-cvaservices.test/api/v2/catalogo_clientes/imagenes_alta?clave=PC-6150' \
     --header 'Authorization: Bearer TU_API_TOKEN'
```

> json de respuesta

```json
{
    "imagenes": [
        "https://www.grupocva.com/detalle_articulo/img_large.php?id=341116",
        "https://www.grupocva.com/detalle_articulo/img_large.php?id=341118",
        "https://www.grupocva.com/detalle_articulo/img_large.php?id=341106",
        "https://www.grupocva.com/detalle_articulo/img_large.php?id=341110",
        "https://www.grupocva.com/detalle_articulo/img_large.php?id=341108"
    ]
}
```

También tienes la opción de obtener las imágenes en la misma búsqueda del producto (véase [Imágenes](#imagenes)). Sin embargo, si usted solamente requiere las imágenes del producto, es mejor usar este endpoint, ya que es una consulta mejor optimizada.

### Query parameters

Parametro | Tipo | Descripción | Valor por defecto
--------- | ----------- | ----------- | -----------
clave | string | Clave CVA del producto | false

### Ejemplos con HTTP Request

Obtener imágenes del producto con clave "_PC-6150_". 

`GET http://api-cvaservices.test/api/v2/catalogo_clientes/imagenes_alta?clave=PC-6150`


⚠️ No todos los productos tienen imágenes, por lo que algunos regresan el valor `null`.

# Catálogos

## Marcas

> Catálogo de marcas

```shell
curl --location 'http://api-cvaservices.test/api/v2/catalogo_clientes/marcas'
```

> json de respuesta

```json
{
    "marcas": [
        {
            "marca": "ACER"
        },
        {
            "marca": "ACTECK"
        },
        {
            "marca": "ADATA"
        },
        {
            "marca": "ADESSO"
        },
        {
            "marca": "AMD"
        },
        -- entre otros --
    ]
}
```

En Grupo CVA, el catálogo de marcas incluye una amplia variedad de opciones en tecnología. Para consultarlas se hace usando 
el endpoint de marcas

<aside class="success">
Para consultar este endpoint no se necesita estar autenticado con token.
</aside>

## Marcas con ID

> Catálogo de marcas 2

```shell
curl --location 'http://api-cvaservices.test/api/v2/catalogo_clientes/marcas2'
```

> json de respuesta

```json
{
    "marcas": [
        {
            "clave": "3",
            "marca": "ACER"
        },
        {
            "clave": "4",
            "marca": "ACTECK"
        },
        {
            "clave": "123",
            "marca": "ADATA"
        },
        {
            "clave": "299",
            "marca": "ADESSO"
        },
        {
            "clave": "5",
            "marca": "AMD"
        },
        -- entre otros --
    ]
}
```

En Grupo CVA, el catálogo de marcas incluye una amplia variedad de opciones en tecnología. Para consultarlas se hace usando 
el endpoint de marcas

<aside class="success">
Para consultar este endpoint no se necesita estar autenticado con token.
</aside>

## Grupos

> Catálogo Grupos

```shell
curl --location 'http://api-cvaservices.test/api/v2/catalogo_clientes/grupos'
```

> json de respuesta

```json
{
	"grupos": [
		{
			"grupo": "ACCESO VIDEOCONFERENCIA"
		},
		{
			"grupo": "ACCESORIOS"
		},
		{
			"grupo": "AIRE ACONDICIONADO"
		},
		{
			"grupo": "ALARMAS"
		},
		{
			"grupo": "ALMACENAMIENTO"
		},
		{
			"grupo": "ANTENAS"
		},
		{
			"grupo": "ASPIRADORAS"
		},
        -- Entre otros --
	]
}
```

Catálogo de los grupos de productos de CVA

<aside class="success">
Para consultar este endpoint no se necesita estar autenticado con token.
</aside>

## Soluciones

> Catálogo de soluciones

```shell
curl --location 'http://api-cvaservices.test/api/v2/catalogo_clientes/soluciones'
```

> json de respuesta

```json
{
	"soluciones": [
		{
			"clave": "1",
			"descripcion": "ALMACENAMIENTO"
		},
		{
			"clave": "2",
			"descripcion": "CABLEADO ESTRUCTURADO"
		},
		{
			"clave": "22",
			"descripcion": "CIBERSEGURIDAD"
		},
		{
			"clave": "3",
			"descripcion": "COMPONENTES ( OEM )"
		},
		{
			"clave": "4",
			"descripcion": "CÓMPUTO"
		},
		-- Entre otros --
	]
}
```
Listado del catálogo de soluciones.

<aside class="success">
Para consultar este endpoint no se necesita estar autenticado con token.
</aside>

## Ciudades

> Obtener las ciudades

```shell
curl --location 'http://api-cvaservices.test/api/v2/catalogo_clientes/ciudades'
```

> json de respuesta

```json
{
	"estados": [
		{
			"estado": {
				"clave": "1",
				"descripcion": "AGUASCALIENTES",
				"ciudades": [
					{
						"clave": "1",
						"descripcion": "AGUASCALIENTES"
					},
					{
						"clave": "2",
						"descripcion": "ASIENTOS"
					},
					{
						"clave": "3",
						"descripcion": "CALVILLO"
					},
					{
						"clave": "4",
						"descripcion": "COSIO"
					},
					{
						"clave": "5",
						"descripcion": "JESUS MARIA"
					},
					{
						"clave": "6",
						"descripcion": "EL LLANO"
					},
					{
						"clave": "7",
						"descripcion": "PABELLON DE ARTEAGA"
					},
					{
						"clave": "8",
						"descripcion": "RINCON DE ROMOS"
					},
					{
						"clave": "9",
						"descripcion": "SAN FRANCISCO DE LOS ROMO"
					},
					{
						"clave": "10",
						"descripcion": "SAN JOSE DE GRACIA"
					},
					{
						"clave": "11",
						"descripcion": "TEPEZALA"
					}
				]
			},
            -- otros --
		},
    ]
}
```

Obtiene los estados con las cuidades.

<aside class="success">
Para consultar este endpoint no se necesita estar autenticado con token.
</aside>

## Sucursales

> Obtener las ciudades

```shell
curl --location 'http://api-cvaservices.test/api/v2/catalogo_clientes/sucursales'
```

> json de respuesta

```json
{
	"sucursales": [
		{
			"clave": "1",
			"nombre": "GUADALAJARA",
			"cp": "44900"
		},
		{
			"clave": "3",
			"nombre": "MORELIA",
			"cp": "58000"
		},
		{
			"clave": "4",
			"nombre": "LEON",
			"cp": "37200"
		},
		{
			"clave": "5",
			"nombre": "CULIACAN",
			"cp": "80200"
		},
		{
			"clave": "6",
			"nombre": "QUERETARO",
			"cp": "76148"
		},
        -- entre otros --
	]
}
```

Obtiene los catálogos de sucursales.

<aside class="success">
Para consultar este endpoint no se necesita estar autenticado con token.
</aside>

## Paqueterías

> Obtener las paqueterías

```shell
curl --location 'http://api-cvaservices.test/api/v2/catalogo_clientes/paqueteria'
```

> json de respuesta

```json
{
	"paqueterias": [
		{
			"clave": "86",
			"descripcion": "AOM GLOBAL EXPRESS"
		},
		{
			"clave": "10",
			"descripcion": "AUTOBUSES ESTRELLA BLANCA"
		},
		{
			"clave": "7",
			"descripcion": "DHL"
		},
		{
			"clave": "42",
			"descripcion": "DIPAQ"
		},
        -- entre otros --
	]
}
```

Obtiene los catálogos de paqueterías.

<aside class="success">
Para consultar este endpoint no se necesita estar autenticado con token.
</aside>

# Pedidos Web

## Listado

> Lista tus pedidos

```shell
curl --location --request POST 'http://api-cvaservices.test/api/v2/pedidos_web/lista_pedidos' \
     --header 'Authorization: Bearer TU_API_TOKEN'
```

> Ejemplo de respuesta

```json
{
    "pedidos": [
        {
            "Numero": "NGB-987217",
            "Total": 8770.69,
            "Moneda": "MN",
            "NumOC": null,
            "Almacen": "VENTAS GUADALAJARA",
            "Asignado": "INCOMPLETO",
            "FechaAsignado": "31/07/2024"
        },
        {
            "Numero": "NGB-675786",
            "Total": 19140,
            "Moneda": "USD",
            "NumOC": null,
            "Almacen": "GUADALAJARA CENTRO DE DISTRIBUCION",
            "Asignado": "INCOMPLETO",
            "FechaAsignado": null
        },
        {
            "Numero": "NGB-670741",
            "Total": 232,
            "Moneda": "USD",
            "NumOC": null,
            "Almacen": "VENTAS MONTERREY",
            "Asignado": "INCOMPLETO",
            "FechaAsignado": null
        },
        ...
    ],
    "status": "ok"
}
```


Obtiene los pedidos del usuario.


## Pedido orden compra

> Ver las ordenes de compra

```shell
curl --location 'http://api-cvaservices.test/api/v2/pedidos_web/pedido_orden_compra' \
--header 'Authorization: Bearer TU_API_TOKEN' \
--header 'Content-Type: application/json' \
--data '{
    "orden": "ORDEN-001"
}'
```

> Ejemplo de respuesta

```json
{
    "orden": "ORDEN-001",
    "pedidos": [
        "G-324875",
        "G-337327",
        "G-340819",
        "G-373449",
        "G-396161",
        "G-403616",
    ],
    "status": "ok"
}
```

Devuelve los pedidos de la orden de compra.

## Consultar información de facturas

> Ver la información de las facturas

```shell
curl --location 'http://api-cvaservices.test/api/v2/pedidos_web/consultar_factura' \
--header 'Authorization: Bearer TU_API_TOKEN' \
--header 'Content-Type: application/json' \
--data '{
    "factura": "GB-1111"
}'
```

> Ejemplo de respuesta

```json
{
    "factura": {
        "total": 768.94,
        "saldo": 0,
        "moneda": "MN",
        "fecha_factura": "10/12/2010",
        "num_oc": null,
        "almacen": "VENTAS GUADALAJARA",
        "observaciones": null,
        "calle_envio": null,
        "numero_envio": null,
        "numero_int_envio": null,
        "colonia_envio": null,
        "cp_envio": null,
        "estado_envio": null,
        "ciudad_envio": null,
        "atencion": null,
        "flete": "Sin Flete",
        "tipo_envio": null,
        "paqueteria": null,
        "guia": null,
        "productos": [
            {
                "clave": "KB-304",
                "fabricante": "920-001475",
                "cantidad": 1,
                "precio_sin_iva": 168.6927,
                "iva": 26.99
            },
            {
                "clave": "CN-779",
                "fabricante": "CLT-K409S/XAX",
                "cantidad": 1,
                "precio_sin_iva": 494.1859,
                "iva": 79.07
            }
        ]
    },
    "status": "ok"
}
```

Devuelve los datos de la factura, así como los productos que vienen en la misma.

El web service recibe un JSON con el código de la factura. ejemplo (__GB-111__).

En el ejemplo de respuesta se puede ver como es la estructura que regresa el endpoint.

## Consultar pedido

```shell
curl --location 'http://api-cvaservices.test/api/v2/pedidos_web/consultar_pedido' \
--header 'Authorization: Bearer TU_API_TOKEN' \
--header 'Content-Type: application/json' \
--data '{
    "pedido": "G-337327"
}'
```
> Ejemplo de respuesta

```json
{
    "pedido": {
        "estatus": "FACTURADO",
        "factura": "G-228920",
        "total": 155.25,
        "moneda": "MN",
        "fecha_pedido": "22/06/2009",
        "num_oc": "ROBERTO",
        "almacen": "VENTAS GUADALAJARA",
        "observaciones": "RECOGEN    ",
        "calle_envio": null,
        "numero_envio": null,
        "ciudad_envio": null,
        "atencion": null,
        "flete": null,
        "tipo_envio": null,
        "paqueteria": null,
        "guia": null,
        "productos": [
            {
                "clave": "RAM-1042",
                "fabricante": "SDSDB-004G-B35",
                "cantidad": 1,
                "precio_sin_iva": 135,
                "iva": 21.6
            }
        ]
    },
    "status": "ok"
}
```

Devuelve la información de un pedido