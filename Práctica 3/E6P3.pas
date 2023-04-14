program E6P3;
type
    prenda = record
        cod_prenda, stock: integer;
        descripcion: string[50];
        colores, tipo_prenda: string[20];
        precio_unitario: real;
    end;

    archivo_prendas = file of prenda;
    archivo_detalle = file of integer;
//_______________________________________________________________________________________________

procedure leer_prenda(var a: prenda);
BEGIN
    with a do begin
        write('Ingresar codigo de la prenda: ');
        readln(cod_prenda);
        if(cod_prenda <> 0)then begin
            write('Ingresar descripcion de la prenda: ');
            readln(descripcion);
            write('Ingresar colores de la prenda: ');
            readln(colores);
            write('Ingresar tipo de prenda: ');
            readln(tipo_prenda);
            write('Ingresar stock: ');
            readln(stock);
            write('Ingresar precio unitario: ');
            readln(precio_unitario);          
        end;
    end;
END;
//_______________________________________________________________________________________________

procedure crear_maestro(var master:archivo_prendas);
var
    rec: prenda;
BEGIN
    rewrite(master);
    leer_prenda(rec);
    while(rec.cod_prenda <> 0)do begin
        write(master, rec);
        leer_prenda(rec);
    end;
    close(master);
END;
//_______________________________________________________________________________________________

procedure crear_detalle(var d:archivo_detalle);
var
    cod:integer;
BEGIN
    rewrite(d);
    writeln('Ingresar el codigo de las prendas que seran obsoletas: (finaliza con 0)');
    write('Ingresar Codigo de prenda: ');
    readln(cod);
    while(cod <> 0)do begin
        write(d, cod);
        write('Ingresar Codigo de prenda: ');
        readln(cod);
    end;
    close(d);
END;
//_______________________________________________________________________________________________

procedure actualizar_maestro(var m: archivo_prendas; var d: archivo_detalle);
var
    cod: integer;
    reg_m: prenda;
BEGIN
    reset(m);
    reset(d);

    while not(EOF(d)) do begin
        read(d, cod);
        read(m, reg_m);
        while (reg_m.cod_prenda <> cod) do begin
            read(m, reg_m);
        end;
        seek(m, filePos(m) - 1);
        reg_m.cod_prenda:= -1;
        write(m, reg_m);
        seek(m, 0);
    end;

    close(m);
    close(d);
END;
//_______________________________________________________________________________________________

procedure compactacion(var nuevo: archivo_prendas; var m: archivo_prendas);
var
    regm: prenda;
BEGIN
    reset(m);
    rewrite(nuevo);

    while not(EOF(m)) do begin
        read(m, regm);
        if (regm.cod_prenda <> -1) then write(nuevo, regm);
    end;

    close(m);
    close(nuevo);
    erase(m);
END;
//_______________________________________________________________________________________________

procedure imprimir(var archivo: archivo_prendas);
var
    regm: prenda;
BEGIN
    reset(archivo);
    while(not eof(archivo))do begin
        read(archivo, regm);
        writeln('codigo ', regm.cod_prenda, ' stock ', regm.stock);
    end;
    close(archivo);
END;
//_______________________________________________________________________________________________

var
    maestro, nuevo: archivo_prendas;
    detalle: archivo_detalle;
BEGIN
    assign(maestro, 'maestro');
    assign(detalle, 'detalle');

    //  CREACION DE ARCHIVOS
    crear_maestro(maestro);
    crear_detalle(detalle);

    // PRUEBA 1
    //writeln('ARCHIVO MAESTRO: ');
    //imprimir(maestro);

    //COMPACTACION
    actualizar_maestro(maestro, detalle);
    assign(nuevo, 'maestro_actualizado');
    compactacion(nuevo, maestro);

    // PRUEBA 2
    writeln('ARCHIVO COMPACTADO: ');
    imprimir(nuevo);
END.