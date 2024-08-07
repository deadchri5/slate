---
title: API CVA

language_tabs: # must be one of https://github.com/rouge-ruby/rouge/wiki/List-of-supported-languages-and-lexers
  - shell
  - php
  - python
  - javascript

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
    content: Documentation for the CVA SERVICES API
---

# Introducción

Bienvenido a la documentacion de la API de Grupo CVA. Nuestra API proporciona una serie de endpoints diseñados para facilitar la integración y el acceso a nuestros servicios de manera eficiente y segura.

Esta API está basada en nuestra anterior API [CVA WEB SERVICE](https://www.grupocva.com/api/docs/documentationWebService.html).

Conecta tu página con nuestro Web Service y obtén en tiempo real, inventarios, precios, promociones, descripción e imágenes de producto. Ofrecemos los datos en formato <b>JSON</b>.

**Términos de uso**

** *Es muy importante tomar en cuenta el vencimiento de la promoción, las promociones mostradas pueden expirar por fecha o por existencias, así que se tiene la responsabilidad de leer el dato, y tomarlo en cuenta para cuando lo ofrezcan, así como saber que ustedes pudieron mostrar un precio y al momento que levanten el pedido pueden haber agotado existencias.*

** *Al utilizar el Webservice usted acepta el funcionamiento del mismo y que las promociones, existencias, precios y disponibilidad puede cambiar sin previo aviso, por lo que se recomienda siempre consultar en tiempo real.*

# Autenticación

> Peticíon para generar un token:

```php
echo 'hola';
```

```python
import kittn

api = kittn.authorize('cva')
```

```shell
# Asegurate de colocar las cabeceras correctas en la petición
curl --location 'http://api-cvaservices.test/api/v1/user/login' \
    --header 'Content-Type: application/json' \
    --data '{
        "user": "USUARIO",
        "password": "CONTRASEÑA" 
    }'
```

> Retorna un JSON con la siguiente estructura:

```json
{
  "usuario": "USUARIO",
  "token" : "KpUIc576Pb00TJHKGaNiXyUvNR8uTE3KKB8bSJv3"
}
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
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

# Lista de Precios

## Buscar catálogo de productos

```php
import kittn

api = kittn.authorize('meowmeowmeow')
api.kittens.get()
```
> Peticíon para obtener la lista de precios:

```shell
# Obtiene el catalógo completo
curl --location 'http://api-cvaservices.test/api/v1/catalogo_clientes/lista_precios' \
     --header 'Authorization: Bearer TU_API_TOKEN'

# Obtiene las impresoras de la marca HP con su información del SAT
curl  --location 'http://api-cvaservices.test/api/v1/catalogo_clientes/lista_precios?marca=hp&grupo=impresoras&codigosat=true' \
      --header 'Authorization: Bearer TU_API_TOKEN'
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
let kittens = api.kittens.get();
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
  ],
  "paginacion": {
      "total_paginas": 300,
      "pagina": 1
  }
}
```

Este endpoint retorna la lista de los productos de catálogo disponibles.

### Petición HTTP

`GET http://api-cvaservices.test/api/v1/catalogo_clientes/lista_precios`

`Authorization Bearer TU_API_TOKEN`

### Parametros de la query (Query parameters)

**Puntos a considerar**

- Si se llama el endpoint sin ningún parametro, se asume que usted quiere consultar el cátalogo de productos completo.
- Es importante mencionar que los parametros "codigo" y "clave" retornarán solamente el producto que está buscando teniendo más peso "clave".

Parametro | Tipo | Descripción
--------- | ----------- | -----------
codigo  | string | Código CVA del producto
clave  | string | Código del fabricante (Número de parte)
marca  | string | Nombre de la marca (Véase) [Marcas](http://www.grupocva.com/catalogo_clientes_xml/marcas.xml)
grupo  | string | Nombre del grupo (Véase) [Grupos](http://www.grupocva.com/catalogo_clientes_xml/grupos.xml)
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

`GET http://api-cvaservices.test/api/v1/catalogo_clientes/lista_precios?marca=apple`

De esta manera usted puede buscar de una forma más especifica lo que busca

`GET http://api-cvaservices.test/api/v1/catalogo_clientes/lista_precios?marca=hp&grupo=impresoras&codigosat=true`

** *Esta petición retornará las impresoras de la marca HP, con su información SAT.*

<aside class="notice">
Es importante mencionar que la consulta <b>TOTAL</b> del catálogo <strong>NO</strong> está disponible de las <strong>9:00</strong> hasta <strong>19:00</strong> (Hora ciudad de México) por lo que se recomienda ser lo más preciso como le sea posible con sus búsquedas, debido a la carga que representa en la base de datos.
</aside>

## Buscar un producto en específico

```php
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
api.kittens.get(2)
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
api.kittens.get(2)
```

```shell
# Busqueda por clave
curl  --location 'http://api-cvaservices.test/api/v1/catalogo_clientes/lista_precios?clave=PR-2586' \
      --header 'Authorization: Bearer TU_API_TOKEN'

# Busqueda por número de pieza
curl  --location 'http://api-cvaservices.test/api/v1/catalogo_clientes/lista_precios?codigo=6QN28A#BGJ' \
      --header 'Authorization: Bearer TU_API_TOKEN'
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
let max = api.kittens.get(2);
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

`GET http://api-cvaservices.test/api/v1/catalogo_clientes/lista_precios?clave=PR-2586`

Se está buscando especificamente el producto con la clave interna de CVA "PR-2586"

- Busca por pieza

`GET http://api-cvaservices.test/api/v1/catalogo_clientes/lista_precios?codigo=6QN28A#BGJ`

Se está buscando especificamente el producto por el número de pieza del fábricante "6QN28A#BGJ"

<aside class="notice">
  Toma en cuenta que para la búsqueda individual los parámetros deben ser preciosos, asegúrate de tener correctas las claves que deseas consultar.
</aside>

## Buscar productos por marca

```php
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
api.kittens.delete(2)
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
api.kittens.delete(2)
```

```shell
# Obtiene los productos de la marca Acteck
curl  --location 'http://api-cvaservices.test/api/v1/catalogo_clientes/lista_precios?marca=acteck' \
      --header 'Authorization: Bearer TU_API_TOKEN'
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
let max = api.kittens.delete(2);
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
    ],
    "paginacion": {
        "total_paginas": 6,
        "pagina": 1
    }
}
```

Con el parámetro marca, por ejemplo, ACTECK, se obtienen todos los productos de esa marca. Consulte el 
[catálogo de marcas]('http://www.grupocva.com/catalogo_clientes_xml/marcas.xml') para consultar todas las marcas.


### HTTP Request

`GET http://api-cvaservices.test/api/v1/catalogo_clientes/lista_precios?marca=acteck`

Este parámetro no distingue entre mayúsculas y minúsculas, por lo que puede realizar su búsqueda independientemente del uso de letras minúsculas o mayúsculas.

### Query Parameters

Parametro | Tipo | Descripción | Valor por defecto
--------- | ----------- | ----------- | -----------
marca | string |Marca que se desea búscar | null
pagina | int | Página que se desea consultar | 1


## Buscar productos por grupo

```php
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
api.kittens.delete(2)
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
api.kittens.delete(2)
```

```shell
# Obtiene los productos de la marca Acteck
curl  --location 'http://api-cvaservices.test/api/v1/catalogo_clientes/lista_precios?grupo=bocinas&pagina=2' \
      --header 'Authorization: Bearer TU_API_TOKEN'
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
let max = api.kittens.delete(2);
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
    ],
    "paginacion": {
        "total_paginas": 10,
        "pagina": 2
    }
}
```

Con el parámetro grupo, por ejemplo, "Bocinas", se obtienen todos los productos que pertenezcan a ese grupo. Consulte el 
[catálogo de grupos]('http://www.grupocva.com/catalogo_clientes_xml/marcas.xml') para consultar todos los disponibles.


### HTTP Request

`GET http://api-cvaservices.test/api/v1/catalogo_clientes/lista_precios?grupo=bocinas&pagina=2`

Este parámetro no distingue entre mayúsculas y minúsculas, por lo que puede realizar su búsqueda independientemente del uso de letras minúsculas o mayúsculas.

### Query Parameters

Parametro | Tipo | Descripción | Valor por defecto
--------- | ----------- | ----------- | -----------
grupo | string | Grupo que se desea búscar | null
pagina | int | Página que se desea consultar | 1


## Buscar productos por grupo2

```php
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
api.kittens.delete(2)
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
api.kittens.delete(2)
```

```shell
# Obtiene los productos del grupo con ID 268
curl  --location 'http://api-cvaservices.test/api/v1/catalogo_clientes/lista_precios?grupo2=268' \
      --header 'Authorization: Bearer TU_API_TOKEN'

# Obtiene los productos de los grupos 268 y 15462 este filtro combina bocinas con el subgrupo bafle
curl  --location 'http://api-cvaservices.test/api/v1/catalogo_clientes/lista_precios?grupo2=268,15462' \
      --header 'Authorization: Bearer TU_API_TOKEN'
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
let max = api.kittens.delete(2);
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
    ],
    "paginacion": {
        "total_paginas": 3,
        "pagina": 1
    }
}
```

Con el parámetro grupo2, es otra manera de buscar por grupos, pero a diferencia de la manera tradicional, esta opcion te da la oportunidad de 
concaternar grupos con subgrupos.

Ten en cuenta que para buscar con el parametro grupo2, se manda el ID del/os grupos a consultar separados por coma ",".

### Ejemplos con HTTP Request

`GET http://api-cvaservices.test/api/v1/catalogo_clientes/lista_precios?grupo2=268`

`GET http://api-cvaservices.test/api/v1/catalogo_clientes/lista_precios?grupo2=268,15462`

### Query Parameters

Parametro | Tipo | Descripción | Valor por defecto
--------- | ----------- | ----------- | -----------
grupo2 | string | IDS de grupos a buscar separados por comas | null
pagina | int | Página que se desea consultar | 1


## Buscar productos por búsqueda genérica

```php
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
api.kittens.delete(2)
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
api.kittens.delete(2)
```

```shell
# Obtiene los productos que contengan en la descripción la palabra "GAMING"
curl  --location 'http://api-cvaservices.test/api/v1/catalogo_clientes/lista_precios?desc=GAMING' \
      --header 'Authorization: Bearer TU_API_TOKEN'
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
let max = api.kittens.delete(2);
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
    "paginacion": {
        "total_paginas": 45,
        "pagina": 1
    }
}
```

Con el parámetro **desc**, puedes realizar búsquedas genéricas (realiza la búsqueda dentro de la descripcion corta de producto).
Ejemplo: una búsqueda genérica que contenga la palabra clave **GAMING**.

### Ejemplos con HTTP Request

`GET http://api-cvaservices.test/api/v1/catalogo_clientes/lista_precios?desc=GAMING`

Este parámetro no distingue entre mayúsculas y minúsculas, por lo que puede realizar su búsqueda independientemente del uso de letras minúsculas o mayúsculas.

### Query Parameters

Parametro | Tipo | Descripción | Valor por defecto
--------- | ----------- | ----------- | -----------
desc | string | Palabra clave que se buscará en la descripcion de los productos | null
pagina | int | Página que se desea consultar | 1

## Agregar porcentaje

```php
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
api.kittens.delete(2)
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
api.kittens.delete(2)
```

```shell
# Obtiene los productos que contengan en la descripción la palabra "GAMING"
curl  --location 'http://api-cvaservices.test/api/v1/catalogo_clientes/lista_precios?clave=PR-2586&porcentaje=16' \
      --header 'Authorization: Bearer TU_API_TOKEN'
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
let max = api.kittens.delete(2);
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

`GET http://api-cvaservices.test/api/v1/catalogo_clientes/lista_precios?clave=PR-2586&porcentaje=16`


<aside class="notice">
Los precios sin porcentaje se encuentran sin IVA, por lo que es recomendable agregar el IVA en el porcentaje para contemplar el impuesto.
</aside>

### Aplicar descuento a lista de productos

Aplicar el paramerametro en consultas que retornan más de un nodo aumentará el porcentaje sobre el precio en todos los nodos de la respuesta.

`http://api-cvaservices.test/api/v1/catalogo_clientes/lista_precios?porcentaje=16`

### Query Parameters

Parametro | Tipo | Descripción | Valor por defecto
--------- | ----------- | ----------- | -----------
porcentaje | int | Le incrementa el porcentaje indicado al precio, para calcular utilidad | null

## Disponibilidad en sucursales

```php
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
api.kittens.delete(2)
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
api.kittens.delete(2)
```

```shell
curl --location 'http://api-cvaservices.test/api/v1/catalogo_clientes/lista_precios?sucursales=true' \
     --header 'Authorization: Bearer TU_API_TOKEN'
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
let max = api.kittens.delete(2);
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

`GET http://api-cvaservices.test/api/v1/catalogo_clientes/lista_precios?sucursales=true`


Este parámetro se puede aplicar tanto a consultas que retornan un solo producto como a aquellas que devuelven una lista de productos.

### Query Parameters

Parametro | Tipo | Descripción | Valor por defecto
--------- | ----------- | ----------- | -----------
sucursales | bool | Mostrará la existencia del producto en cada una de las sucursales | false

<aside class="notice">
El Precio de un producto puede variar de una sucursal a otra así como el precio del flete depende de la distancia origen y destino.
</aside>

## Obtener subgrupo de el/los artículos

Si el parametro `subgrupo = true` se agrega a la respuesta el nodo en el que indica el subgrupo del producto.

Este parámetro se puede aplicar tanto a consultas que retornan un solo producto como a aquellas que devuelven una lista de productos.

```shell
curl  --location 'http://api-cvaservices.test/api/v1/catalogo_clientes/lista_precios?clave=KB-890&subgpo=true' \
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

`http://api-cvaservices.test/api/v1/catalogo_clientes/lista_precios?clave=KB-890&subgpo=true`

Obtener el subgrupo de todos los articulos de una lista de productos

`http://api-cvaservices.test/api/v1/catalogo_clientes/lista_precios?subgpo=true`

### Query Parameters

Parametro | Tipo | Descripción | Valor por defecto
--------- | ----------- | ----------- | -----------
subgpo | bool | Mostrará el nombre del subgrupo del producto | false

## Mostrar tipo de cambio

Si el parámetro `tc = true` se añadirán los campos de valor de tipo de cambio de dólar y su última fecha de actualización por nuestra parte, si está en cero o no incluyes el parámetro no se mostrá el elemento en la respuesta.

```shell
curl  --location 'http://api-cvaservices.test/api/v1/catalogo_clientes/lista_precios?clave=KB-890&tc=true' \
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

`http://api-cvaservices.test/api/v1/catalogo_clientes/lista_precios?clave=KB-890&tc=true`

### Query Parameters

Parametro | Tipo | Descripción | Valor por defecto
--------- | ----------- | ----------- | -----------
tc | bool | Mostrará el tipo de cambio | false

<aside class="notice">
Se aclara que el uso del tipo de cambio publicado es totalmente del dominio de CVA, sujeto a cambios durante el día sin previo aviso (es por eso que también te estamos brindando la fecha de última actualización del tc), <b>SE RECOMIENDA</b> realizar las actualizaciones en tiempo real, de esa manera siempre se tiene el precio actualizado incluso con los cambios que se puedan generar en el día.
</aside>

## Parámetro "tipo"

Si el parámetro `tipo = true` entonces la API te agregará una llave al JSON de respuesta **"TipoProducto"**  Este es el equivalente para el servicio web de los “productos por salir” estos productos están disponibles solo hasta agotar existencias y no genera backorder o sea que no compran aunque sean solicitados (se ponen por salir porque es posible que ni el proveedor siga surtiendo el producto o este descontinuado), ósea que se debe limitar a ofrecer la existencia mostrada.

```shell
curl  --location 'http://api-cvaservices.test/api/v1/catalogo_clientes/lista_precios?clave=SPK-2093&tipo=true' \
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

`GET http://api-cvaservices.test/api/v1/catalogo_clientes/lista_precios?clave=SPK-2093&tipo=true`

### Query Parameters

Parametro | Tipo | Descripción | Valor por defecto
--------- | ----------- | ----------- | -----------
tipo | bool | Mostrará el tipo de producto | false

## Parámetro "Depto"

```shell
curl  --location 'http://api-cvaservices.test/api/v1/catalogo_clientes/lista_precios?clave=SPK-2093&depto=true' \
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

`GET http://api-cvaservices.test/api/v1/catalogo_clientes/lista_precios?clave=SPK-2093&depto=true`

### Query Parameters

Parametro | Tipo | Descripción | Valor por defecto
--------- | ----------- | ----------- | -----------
depto | bool | Mostrará el departamento del poroducto | false

## Descripciones enriquecidas

```shell
curl  --location 'http://api-cvaservices.test/api/v1/catalogo_clientes/lista_precios?clave=SPK-2093&dt=true&dc=true' \
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

`GET http://api-cvaservices.test/api/v1/catalogo_clientes/lista_precios?clave=SPK-2093&dt=true&dc=true`

✅ Los parámetros no dependen entre sí, por lo que puede solicitar únicamente el que necesita.

✅ Este parámetro se puede aplicar tanto a consultas que retornan un solo producto como a aquellas que devuelven una lista de productos.

## Imágenes

```shell
curl  --location 'http://api-cvaservices.test/api/v1/catalogo_clientes/lista_precios?clave=SPK-2093&images=true' \
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

Para obtener imágenes de alta resolución de tu producto tiene que enviar el parámeto `images = true`

### Query parameters

Parametro | Tipo | Descripción | Valor por defecto
--------- | ----------- | ----------- | -----------
images | bool | Mostrará el arreglo de imágenes ligadas al producto | false

### Ejemplos HTTP REQUEST

Obtener el producto con clave: **SPK-2093** con sus imágenes.

`GET http://api-cvaservices.test/api/v1/catalogo_clientes/lista_precios?clave=SPK-2093&images=true`

✅ Este parámetro se puede aplicar tanto a consultas que retornan un solo producto como a aquellas que devuelven una lista de productos.

⚠️ No todos los productos tienen imágenes, por lo que algunos regresan el valor `null`

<aside class="warning">
<b>NO</b> se recomienda enviar este parámetro en consultas que devuelvan una lista extensa de productos, ya que esto puede <b>aumentar</b> 
drásticamente el <b>tiempo de respuesta</b> de la API. Se aconseja utilizar este parámetro únicamente en consultas individuales para garantizar
un rendimiento óptimo.
</aside>