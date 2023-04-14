program E8P3;
type
    distro = record
        nombre: string;
        anio: integer;
        version: string;
        cant_desarrolladores: integer;
        descripcion: string;
    end;

    archivo = file of distro;
//_______________________________________________________________________________________________

procedure leer_distro(var d:distro);
BEGIN
    with d do begin
        write('Ingresar nombre de la distribucion: ');
        readln(nombre);
        if(nombre <> 'fin')then begin
            write('Ingresar anio de lanzamiento: ');
            readln(anio);
            write('Ingresar version de kernel: ');
            readln(version);
            write('Ingresar cantidad de desarrolladores: ');
            readln(cant_desarrolladores);
            write('Ingresar descripcion: ');
            readln(descripcion);
        end;
    end;
END;
//_______________________________________________________________________________________________

procedure crear_archivo(var m: archivo);  
var
    d: distro;
BEGIN
    rewrite(m);
    d.cant_desarrolladores := 0;
    write(m, d);
    leer_distro(d);
    while(d.nombre <> 'fin')do begin
        write(m, d);
        leer_distro(d);
    end;
    close(m);
END;
//_______________________________________________________________________________________________

function existe_distribucion(var m:archivo; nombre:string):boolean;
var
    regm: distro;
    ok: boolean;
BEGIN
    reset(m);

    ok:= false;
    read(m, regm);
    while (not(EOF(m)) and not(ok)) do begin
        read(m, regm);
        if ((regm.nombre = nombre) and (regm.cant_desarrolladores > 0)) then ok:= true; 
    end;
    
    existe_distribucion:= ok;

    close(m);
END;
//_______________________________________________________________________________________________

procedure alta_distribucion(var m:archivo);
var
    d, aux: distro;
BEGIN
    leer_distro(d);
    if not(existe_distribucion(m, d.nombre)) then begin
        reset(m);

        read(m, aux);
        if (aux.cant_desarrolladores < 0) then begin
            seek(m, abs(aux.cant_desarrolladores));
            read(m, aux);
            seek(m, filePos(m) - 1);
            write(m, d);
            seek(m, 0);
            write(m, aux); //No se pasa a negativo porque, como se recupera espacio de una baja, ya estaba en negativo el indice
        end
        else begin
            seek(m, fileSize(m));
            write(m, d);
        end;
        writeln('***Se agrego la distribucion con exito***');
        
        close(m);
    end
    else writeln('Ya existe la distribucion');
END;
//_______________________________________________________________________________________________

procedure baja_distribucion(var m: archivo);
var
    nombre: string;
    cabecera: integer;
    aux: distro;
BEGIN
    writeln('Ingresar el nombre de la distribucion a eliminar: '); readln(nombre);
    if (existe_distribucion(m,nombre)) then begin
        reset(m);

        read(m, aux);
        cabecera:= aux.cant_desarrolladores;
        while (aux.nombre <> nombre) do read(m, aux);
        aux.cant_desarrolladores:= cabecera;
        seek(m, filePos(m) - 1);
        cabecera:= filePos(m) * -1; //Guardo la posicion actual en negativo para guardarla despues en la cabecera
        write(m, aux);
        
        seek(m, 0);
        aux.cant_desarrolladores:= cabecera;
        write(m, aux); //Actualizo la cabecera

        writeln('***La distribucion se elimino con exito***');

        close(m);
    end
    else writeln('Distribucion inexistente');
END;
//_______________________________________________________________________________________________

procedure imprimir(var archivo: archivo);
var
    regm: distro;
BEGIN
    reset(archivo);

    while(not eof(archivo))do begin
        read(archivo, regm);
        if(regm.cant_desarrolladores > 0)then
            writeln('Nombre: Linux ', regm.nombre, '; Cantidad de desarrolladores: ', regm.cant_desarrolladores);
    end;

    close(archivo);
END;
//_______________________________________________________________________________________________

var
    m: archivo;
BEGIN
    assign(m, 'maestro');
    writeln(#10,'~~~~~Creacion del archivo:~~~~~');
    //crear_archivo(m);

    writeln(#10,'~~~~~Alta:~~~~~');
    alta_distribucion(m);
    writeln(#10,'~~~~~Baja:~~~~~');
    baja_distribucion(m);
    
    writeln(#10,'~~~~~Contenido del arhivo:~~~~~');
    imprimir(m);
END.