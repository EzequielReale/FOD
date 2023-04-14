program E7P2;

const
    VALOR_ALTO = 9999;
type
    producto = record
        cod, stock_act, stock_min: integer;
        nombre: string[20];
        precio: real;
    end;
    venta = record
        cod, cant: integer;
    end;

    maestro = file of producto;
    detalle = file of venta;

procedure crearMaestro(var m:maestro);
    procedure leerProducto(var p:producto);
    BEGIN
        with p do begin
            write('Codigo del producto: '); readln(cod);
            if (cod <> -1) then begin
                write('Nombre del producto: '); readln(nombre);
                write('Precio del producto: '); readln(precio);
                write('Stock actual: '); readln(stock_act);
                write('Stock minimo: '); readln(stock_min);
            end;
        end; 
    END;
var
    p:producto;
BEGIN
    rewrite(m);
    writeln(#10,'~~Datos del maestro:~~',#10);

    leerProducto(p);
    while(p.cod <> -1) do begin
        write(m,p);
        leerProducto(p);
    end;

    close(m);
END;

procedure crearDetalle(var d:detalle);
    procedure leerVenta(var v:venta);
    BEGIN
        with v do begin
            write('Codigo del producto: '); readln(cod);
            if (cod <> -1) then begin
                write('Cantidad de ventas: '); readln(cant);
            end;
        end;
    END;
var
    v:venta;
BEGIN  
    rewrite(d);
    writeln(#10,'~~Datos del detalle:~~',#10);

    leerVenta(v);
    while (v.cod <> -1) do begin
        write(d,v);
        leerVenta(v);
    end;

    close(d);
END;

procedure actualizar(var m:maestro; var d:detalle);
    procedure leer(var d:detalle; var v:venta);
    BEGIN
        if not(EOF(d)) then
            read(d, v)
        else
            v.cod:= VALOR_ALTO;
    END;
var
    p: producto;
    v, v_a: venta;
BEGIN
    reset(m);
    reset(d);

    leer(d,v);
    while (v.cod <> VALOR_ALTO) do begin
        v_a.cod:= v.cod;
        v_a.cant:= 0;

        while (v.cod = v_a.cod) do begin
            v_a.cant:= v_a.cant + v.cant;
            leer(d,v);
        end;

        read(m,p);
        while (p.cod <> v_a.cod) do
            read(m,p);

        p.stock_act:= p.stock_act - v_a.cant;
        seek(m,FilePos(m)-1);
        write(m,p);
    end;

    close(m);
    close(d);
END;

procedure listar_stock_min(var m:maestro);
var
    p: producto;
    txt: text;
BEGIN
    assign(txt, 'sin_stock.txt');
    reset(m);
    rewrite(txt);
    while(not EOF(m))do begin
        read(m, p);
        if(p.stock_act < p.stock_min)then
            with p do
                writeln(txt, 'Codigo de producto: ', cod, 
                '; Nombre: ', nombre, '; Precio: $',
                 precio:1:2, '; Stock actual: ', stock_act, '; Stock minimo: ', stock_min);
    end;
    close(txt);
    close(m);
END;

procedure imprimir(var m:maestro);
var
    p:producto;
BEGIN
    reset(m);

    while not(EOF(m)) do begin 
        read(m,p);
        writeln('Codigo: ',p.cod,'; Nombre: ',p.nombre,'; Precio: ',p.precio:1:2,'; Stock: ',p.stock_act,'; Stock minimo: ',p.stock_min);    
    end;

    close(m);
END;

var
m: maestro;
d: detalle;
BEGIN
    assign(m, 'maestro');
    assign(d, 'detalle');
    //crearMaestro(m);
    //crearDetalle(d);
    actualizar(m,d);
    listar_stock_min(m);
    imprimir(m);
END.