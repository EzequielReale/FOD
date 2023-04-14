# Repaso

## Arboles

- Arbol B

    Dado un árbolB de orden 4 y utilizando política izquierda,para cada operación dada:

    a.Dibuje el árbol resultante.

    b.Explique brevemente las decisiones tomadas.

    c.Escriba las lecturasyescrituras.

    Operaciones:+250,+174,-25,-150

    Nodo2:3,i,0(50)1(150)3(214)4

    Nodo0:1,h,(25)

    Nodo1:2,h,(126)(130)

    Nodo3:3,h,(170)(187)(199)

    Nodo4:3,h,(340)(367)(491)

    ver todos los arboles resultantes en cada operación por favor(en algunos casos se hace paso por paso):


    ```
                2[0(50)1(150)3(214)4 ]

        0[25]  1[126,130] 3[(170)(187)(199)]  4[(340)(367)(491)]
    ```

    ```
        +250 : L2,L4,E4,E5,E2,E6,E7 //Izquierdo Derecho Raiz
        +250 : L2,L4,E5,E4,E6,E2,E7 //Derecho Izquierdo Raiz
        
                            E7[2(214)6]

                2[0(50)1(150)3 ]  6[4(367)5]

        0[25]  1[126,130] 3[(170)(187)(199)]  4[(250)(340)] 5[(491)]
    ```

    ```
        +174 : L7,L2,L3,E3,E8,E2  //Izquierdo Derecho Raiz
        +174 : L7,L2,L3,E8,E3,E2 //Derecho Izquierdo Raiz
        
                            7[2(214)6]

                2[0(50)1(150)3(187)8]  6[4(367)5]

        0[25]  1[126,130] 3[(170)(174)] 8[(199)] 4[(250)(340)] 5[(491)]
    ```

    ```
        -25 : L7,L2,L0,L1,E1,E0,E2
        -25 : L7,L2,L0,L1,E0,E1,E2
        
                            7[2(214)6]

                2[0(126)1(150)3(187)8]  6[4(367)5]

        0[50]  1[130] 3[(170)(174)] 8[(199)] 4[(250)(340)] 5[(491)]
    ```

    ```
        -150 : L7,L2,L3,E3,E2
        
                            7[2(214)6]

                2[0(126)1(170)3(187)8]  6[4(367)5]

        0[50]  1[130] 3[(174)] 8[(199)] 4[(250)(340)] 5[(491)]
    ```

    ```
        -170 : L7,L2,L3,L1,E1,(N3 LIBERADO),E2
        
                            7[2(214)6]

                2[0(126)1(187)8]  6[4(367)5]

        0[50]  1[(130)(174)] 8[(199)] 4[(250)(340)] 5[(491)]
    ```

## Archivos

- ### Lista invertida

    Se dispone de un archivo que contiene información de jugadores de futbol.
    
    Se sabe que el archivo utiliza la técnica de lista invertida para aprovechamiento de espacio.Es decir,las bajas se realizan apilando registros borradosylas altas reutilizando registros borrados.El registro en la posición0del archivo se usa como cabecera de la pila de registros borrados.El campo de enlace es el campo dni.

    Nota: El valor0en el campo dni significa que no existen registros borrados,yel valor -N indica que el próximo registroareutilizar es elN,siendo éste un número relativo de registro válido.

    ```pas
    const
        valorAlto=9999;
    Type
        tJugador = Record
            dni : longInt:
            nombre:String:
            apellido:String:
            pais nacimiento:String
        end;
        tArchivo=File of tJugador:
    ```

    Se solicita implementar los siguientes módulos:

    - Abre el archivo y agrega un jugador,el mismo se recibe como parámetroydebe utilizar la política descripta anteriormente para recuperación de espacio

    - Abre el archivo y elimina el jugador con el dni recibido como parámetro(si existe),manteniendo la política descripta anteriormente

    ```pas
    program Parcial;

    procedure Baja(var a:tArchivo;dni_borrar:longInt);
    var
        dato,cabecera:tJugador;
    begin
        Reset(a);
        Leer(a,cabecera);
        Leer(a,dato);
        while (dato.dni <> valorAlto) and (dato.dni <> dni_borrar) do
             Leer(a,dato);
        if (dato.dni = dni_borrar) then begin
            Seek(a,filePos(a)-1);
            write(a,cabecera);
            cabecera.dni := (filePos(a) -1) * -1;
            seek(a, 0);
            write(a, cabecera);
        end;
        Close(a);
    end;

    procedure Alta(var a:tArchivo;jugador:tJugador);
    var
        cabecera:tJugador;
    begin
        Reset(a);
        Leer(a,cabecera);
        if (cabecera.dni = 0) then begin
            Seek(a, fileSize(a));
            Write(a, jugador);
        end
        else begin
            Seek(a,(cabecera.dni*-1));
            Leer(a,cabecera);
            Seek(a,filePos(a)-1);    
            write(a,jugador);
            Seek(a,0);
            write(a,cabecera);
        end;
        Close(a);
    end;
    ```

- Merge, corte control

    Una cadena de restaurantes posee un archivo de productos que tieneala venta,de cada producto se registra:código de producto,nombre,descripción,código de barras,categoría de producto,stock actualystock mínimo.Diariamente el depósito debe efectuar envíosacada uno de los tres restaurantes que se encuentran en la ciudad de Laprida. Para esto,cada restaurante envia un archivo por mail con los pedidos de productos.Cada pedido contiene:código de producto,cantidad pedidayuna breve descripción del producto.
    
    Se pide realizar el proceso de actualización del archivo maestro con los tres archivos de detalle,obteniendo un informe de aquellos productos que quedaron por debajo del stock mínimo y sobre estos productos informar la categoría a la que pertenecen. 
    
    Además,informar aquellos pedidos que no pudieron satisfacerse totalmente por falta de stock,indicando la diferencia que no pudo ser enviada a cada restaurante.Si el stock no es suficiente para satisfacer un pedido en su totalidad,entonces el mismo debe satisfacerse con la cantidad que se disponga.
    
    Nota:Todos los archivos están ordenados por código de producto

    ```pas
    program Parcial;
    const
        DIMF = 3;
        VALORALTO = 9999;
    
    type
        cadena20 = string[20];
        producto = record
            codigo:integer;
            nombre:cadena20;
            codigo_barras:integer;
            categoria:cadena20;
            stock_actual:integer;
            stock_min:integer;
        end;
        registroD = record
            codigo:integer;
            cant_pedida:integer;
            descripcion:cadena20;
        end;
        archivoM = file of producto;
        archivoD = file of registroD;
        vector_archivoD = array [1..DINF] of archivoD;
        vector_datosD = array [1..DIMF] of registroD;

    //________________________________________
    procedure ResetDetalles(var vd:vector_archivoD;var vdd:vector_datosD);
    var
        i:integer;
        iStr:cadena20;
    begin
        for i:=1 to DIMF do
        begin
            Str(i,iStr);
            assign(vd[i],'detalle'+iStr);
            reset(vd[i]);
            LeerD(vd[i],vdd[i]);
        end;
    end;
    //________________________________________
    procedure CloseDetalles(var vd:vector_archivoD);
    var
        i:integer;
    begin
        for i:=1 to DIMF do
            Close(vd[i]);
    end;
    //________________________________________
    procedure LeerM(var m:archivoM;dato:producto);
    begin
        if not eof (m) then
            Read(m,dato)
        else
            dato.codigo:=VALORALTO;
    end;
    procedure LeerD(var d:archivoD;dato:registroD);
    begin
        if not eof (d) then
            Read(d,dato)
        else
            dato.codigo:=VALORALTO;
    end;
    //________________________________________
    procedure minimo(var vd:vector_archivoD;var vdd:vector_datosD;var min:archivoD;var minPos:integer);
    var
        i:integer;
    begin
        min.codigo:=VALORALTO;
        for i:=1 to DIMF do
        begin
            if (vdd[i].codigo< min.codigo ) then
            begin
                min:=vdd[i];
                minPos:=i;
            end;
        end;
        if (min.codigo <> VALORALTO) then 
            LeerD(vd[minPos],vdd[minPos]);
    end;
    //________________________________________
    procedure Merge(var m:archivoM;var vd:vector_archivoD;var vdd:vector_datosD);
    var
        datoM:producto;
        min:producto;
        posMin:integer;
        diferencia:integer;
    begin
        posMin:=valorAlto;
        diferencia:=0;
        Reset(m);
        ResetDetalles(vd,vdd);
        minimo(vd,vdd,min,posMin);
        while (min.codigo<>VALORALTO) do
        begin
            LeerM(m,datoM);
            while (datoM.codigo <> min.codigo) do
                LeerM(m,datoM);
            while (datoM.codigo = min.codigo) and (min.codigo<>VALORALTO) do begin
                if (datoM.stock_actual < min.cant_pedida) then
                begin
                    diferencia = (datoM.stock_actual - min.cant_pedida)*-1;
                    writenln('Diferencia ', diferencia, 'en la sucursal ', posMin); 
                end;
                datoM.stock_actual:=datoM.stock_actual - min.cant_pedida;
                if (datoM.stock_actual< 0) then
                    datoM.stock_actual:=0;
                minimo(vd,vdd,min,posMin);
            end;
            if (datoM.stock_actual < datoM.stock_min) then
            begin
                writeln(datoM.codigo);
                writeln(datoM.categoria);
            end;

            seek(m,filePos(m)-1);
            write(m,datoM);
        end;
        Close(m);
        CloseDetalles(vd);
    end;
    //________________________________________
    var
        m:archivoM;
        vd:vector_archivoD;
        vdd:vector_datosD;
    begin
        Assign(m,'maestro.data');
        Merge(m,vd,vdd);
    end;
    ```

    ### Otra manera de ver arreglos de archivos

    ```pas
    program test;

    const
        CANT_SUCURSALES= 3;

    type
        producto = record
            codigo:integer;
            nombre:string;
            codigo_barras:integer;
            categoria:string;
            stock_actual:integer;
            stock_min:integer;
        end;
        pedido = record
            codigo:integer;
            cant_pedida:integer;
            descripcion:string;
        end;
        arch_maestro = file of producto;
        arch_pedidos = file of pedidos;

        sucursal = record
            detalle : arch_pedidos;
            reg : pedido;
            nombre : string;
        end;

        vector_sucursales = array[1..CANT_SUCURSALES] of sucursal;

    procedure resetSucursales(var vSucursales: vector_sucursales);
    var
        i: integer;
        nombre: string;
    begin
        for i:= 1 to CANT_SUCURSALES do begin
            readln(vSucursales[i].nombre);
            assign(vSucursales[i].detalle, vSucursales[i].nombre);
            reset(vSucursales[i].detalle);
            leerPedido(vSucursales[i].detalle, vSucursales[i].reg);
        end;
    end;

    procedure resetSucursales(var vSucursales: vector_sucursales);
    var
        i: integer;
    begin
        for i:= 1 to CANT_SUCURSALES do begin
            close(vSucursales[i].detalle);
        end;
    end;

    procedure minimo(var vSucursales: vector_sucursales; var min: pedido; var nom: string);
    var
        i:integer;
        pos: integer;
    begin
        min.codigo:=VALORALTO;
        for i:=1 to DIMF do
        begin
            if (vSucursales[i].reg.codigo < min.codigo) then
            begin
                min:=vSucursales[i].reg;
                nom:= vSucursales[i].nombre;
                pos:= i;
            end;
        end;
        if (min.codigo <> VALORALTO) then 
            LeerD(vSucursales[pos].detalle,vSucursales[pos].reg);
    end;
    ```

## Hashing

- ### Extensible

    Hashing
    
    Realice el proceso de dispersión mediante el método de hashing extensible,sabiendo que cada registro tiene capacidad para dos claves.El número natural indica el orden de llegada de las claves.Deberá explicar los pasos que realiza en cada operacióny dibujar los estados sucesivos correspondientes.

    Justifique brevemente.

    |Pos|Name|Hash|Pos|Name|Hash|
    |:-:|:-:|:-:|:-:|:-:|:-:|
    |1 |Java |10100111  |  2|C |10101010|
    |3 |Ruby |111110    |  4| Haskell| 1101111|
    |5 |Kotlin |110101  |  6 |Python |11110000|
    |7 |PHP| 1011101    |  8 |SQL |1011011|
    |9 |Pascal |110100   |  10 |Smalltalk |11100001|

    
    ```
    Java, hash 10100111
    0
    [0] --<> 0[Java, ]
    
    C, hash 10101010
    0
    [0] --<> 0[Java,C]

    Ruby, hash 111110
    1
    [0] --<> 1[C,Ruby]
    [1] --<> 1[Java, ]

    Haskell, hash 1101111
    1
    [0] --<> 1[C,Ruby]
    [1] --<> 1[Java, Haskell]

    Kotlin ,hash 110101
    2
    [00] --<> 1[C,Ruby]
    [10] --/
    [01] --<> 2[Kotlin]
    [11] --<> 2[Java, Haskell]

    Python ,hash 11110000
    2
    [00] --<> 2[Python]
    [10] --<> 2[C,Ruby]
    [01] --<> 2[Kotlin] 
    [11] --<> 2[Java, Haskell]

    PHP ,hash 1011101
    2
    [00] --<> 2[Python]
    [10] --<> 2[C,Ruby]
    [01] --<> 2[Kotlin,PHP]
    [11] --<> 2[Java, Haskell]

    SQL, 1011011
    3
    [000] --<> 2[Python]
    [100] --/
    [010] --<> 2[C,Ruby]
    [110] --/
    [001] --<> 2[Kotlin,PHP]
    [101] --/
    [011] --<> 3[SQL]
    [111] --<> 3[Java, Haskell]

    Pascal, 110100
    3
    [000] --<> 2[Python,Pascal]
    [100] --/
    [010] --<> 2[C,Ruby]
    [110] --/
    [001] --<> 2[Kotlin,PHP]
    [101] --/
    [011] --<> 3[SQL]
    [111] --<> 3[Java, Haskell]

    Smalltalk, 11100001
    3
    [000] --<> 2[Python,Pascal]
    [100] --/
    [010] --<> 2[C,Ruby]
    [110] --/
    [001] --<> 3[Smalltalk]
    [101] --<> 3[Kotlin, PHP]
    [011] --<> 3[SQL]
    [111] --<> 3[Java, Haskell]
    ```

- ### Progresiva Encadenada

    Ops, +81, +69, +27, +51, +56, -45, -49.
    
    f(x) = x MOD 11

    |Direccion|Enlace|Clave|
    |:-:|:-:|:-:|
    |0| -1| |
    |1| 3| 45|
    |2| -1| 13|
    |3| -1| 89|
    |4| -1| |
    |5| -1| 49|
    |6| -1| |
    |7| -1| |
    |8| -1| 74|
    |9| -1| |
    |10|-1| |

    +81, 4

    L4,E4
    
    |Direccion|Enlace|Clave|
    |:-:|:-:|:-:|
    |0| -1| |
    |1| 3| 45|
    |2| -1| 13|
    |3| -1| 89|
    |4| -1| 4|
    |5| -1| 49|
    |6| -1| |
    |7| -1| |
    |8| -1| 74|
    |9| -1| |
    |10|-1| |

    +69, 3

    L3,L4,L5,L6,E6,L1,E1,E3

    |Direccion|Enlace|Clave|
    |:-:|:-:|:-:|
    |0| -1| |
    |1| 6| 45|
    |2| -1| 13|
    |3| -1| 69|
    |4| -1| 4|
    |5| -1| 49|
    |6| -1| 89|
    |7| -1| |
    |8| -1| 74|
    |9| -1| |
    |10|-1| |

    +27, 5

    L5,L6,L7,E7,E5

    |Direccion|Enlace|Clave|
    |:-:|:-:|:-:|
    |0| -1| |
    |1| 6| 45|
    |2| -1| 13|
    |3| -1| 69|
    |4| -1| 4|
    |5| 7| 49|
    |6| -1| 89|
    |7| -1| 27|
    |8| -1| 74|
    |9| -1| |
    |10|-1| |

    +51, 7

    L7,L8,L9,E9,L5,E5,E7

    |Direccion|Enlace|Clave|
    |:-:|:-:|:-:|
    |0| -1| |
    |1| 6| 45|
    |2| -1| 13|
    |3| -1| 69|
    |4| -1| 4|
    |5| 9| 49|
    |6| -1| 89|
    |7| -1| 51|
    |8| -1| 74|
    |9| -1| 27|
    |10|-1| |

    +56, 1

    L1,L6,L7,L8,L9,L10,E10,E1

    |Direccion|Enlace|Clave|
    |:-:|:-:|:-:|
    |0| -1| |
    |1| 10| 45|
    |2| -1| 13|
    |3| -1| 69|
    |4| -1| 4|
    |5| 9| 49|
    |6| -1| 89|
    |7| -1| 51|
    |8| -1| 74|
    |9| -1| 27|
    |10|6| 56|

    -45, 1

    L1,L10,E10,E1

    |Direccion|Enlace|Clave|
    |:-:|:-:|:-:|
    |0| -1|   |
    |1|  6| 56|
    |2| -1| 13|
    |3| -1| 69|
    |4| -1|  4|
    |5|  9| 49|
    |6| -1| 89|
    |7| -1| 51|
    |8| -1| 74|
    |9| -1| 27|
    |10|-1|   |

    -49, 5

    L5,L9,E9,E5

    |Direccion|Enlace|Clave|
    |:-:|:-:|:-:|
    |0| -1|   |
    |1|  6| 56|
    |2| -1| 13|
    |3| -1| 69|
    |4| -1|  4|
    |5| -1| 27|
    |6| -1| 89|
    |7| -1| 51|
    |8| -1| 74|
    |9| -1|   |
    |10|-1|   |

- ### Dispersion Doble

    Ops: +58, +63, +78, +61, +89, -12, -78, -23.

    f1(x) = x MOD 11. f2(x) = x MOD 7 + 1

    |Direccion|Clave|
    |:-:|:-:|
    |0 |   |
    |1 | 23|
    |2 |   |
    |3 | 47|
    |4 | 15|
    |5 |   |
    |6 | 72|
    |7 |   |
    |8 | 30|
    |9 |   |
    |10|   |

    +58, HASH 3, DES 3

    L3,L6,L9,E9

    |Direccion|Clave|
    |:-:|:-:|
    |0 |   |
    |1 | 23|
    |2 |   |
    |3 | 47|
    |4 | 15|
    |5 |   |
    |6 | 72|
    |7 |   |
    |8 | 30|
    |9 | 58|
    |10|   |

    
    +63, HASH 8, DES 1

    L8, L9, L10

    |Direccion|Clave|
    |:-:|:-:|
    |0 |   |
    |1 | 23|
    |2 |   |
    |3 | 47|
    |4 | 15|
    |5 |   |
    |6 | 72|
    |7 |   |
    |8 | 30|
    |9 | 58|
    |10| 63|

    +78, HASH 1, DES 2

    L1, L3, L5, E5

    |Direccion|Clave|
    |:-:|:-:|
    |0 |   |
    |1 | 23|
    |2 |   |
    |3 | 47|
    |4 | 15|
    |5 | 78|
    |6 | 72|
    |7 |   |
    |8 | 30|
    |9 | 58|
    |10| 63|

    +61, HASH 6, DES 6

    L6, L1, L7, E7

    |Direccion|Clave|
    |:-:|:-:|
    |0 |   |
    |1 | 23|
    |2 |   |
    |3 | 47|
    |4 | 15|
    |5 | 78|
    |6 | 72|
    |7 | 61|
    |8 | 30|
    |9 | 58|
    |10| 63|

    +89, HASH 1, DES 6

    L1, L7, L2, E2

    |Direccion|Clave|
    |:-:|:-:|
    |0 |   |
    |1 | 23|
    |2 | 89|
    |3 | 47|
    |4 | 15|
    |5 | 78|
    |6 | 72|
    |7 | 61|
    |8 | 30|
    |9 | 58|
    |10| 63|

    -12, HASH 1, DES 6

    L1, L7, L2, L8, L3, L9, L4, L10, L5, L0 No existe

    |Direccion|Clave|
    |:-:|:-:|
    |0 |   |
    |1 | 23|
    |2 | 89|
    |3 | 47|
    |4 | 15|
    |5 | 78|
    |6 | 72|
    |7 | 61|
    |8 | 30|
    |9 | 58|
    |10| 63|

    -78, HASH 1, DES 2

    L1, L3, L5, E5

    |Direccion|Clave|
    |:-:|:-:|
    |0 |   |
    |1 | 23|
    |2 | 89|
    |3 | 47|
    |4 | 15|
    |5 | ##|
    |6 | 72|
    |7 | 61|
    |8 | 30|
    |9 | 58|
    |10| 63|

    -23, HASH 1

    L1, E1

    |Direccion|Clave|
    |:-:|:-:|
    |0 |   |
    |1 | ##|
    |2 | 89|
    |3 | 47|
    |4 | 15|
    |5 | ##|
    |6 | 72|
    |7 | 61|
    |8 | 30|
    |9 | 58|
    |10| 63|
