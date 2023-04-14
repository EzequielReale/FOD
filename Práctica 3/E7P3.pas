program E7P3;
const
    valor_fin = 500000;
type
    str30 = string[30];
    ave = record
        cod: LongInt;
        nombre,familia_ave ,zona_geografica : str30;
        descripcion: string;
    end;

    archivo_aves = file of ave;
//_______________________________________________________________________________________________

procedure crear_archivo_aves(var a: archivo_aves);
    procedure leer_ave(var a: ave);
    BEGIN
        with a do begin
            write('Ingresar codigo de especie: ');
            readln(cod);
            if(cod <> -1)then begin
                write('Ingresar nombre de especie: ');
                readln(nombre);
                write('Ingresar familia de ave: ');
                readln(familia_ave);
                write('Ingresar descripcion del ave: ');
                readln(descripcion);
                write('Ingresar zona geografica de la especie: ');
                readln(zona_geografica);
            end;
        end;
    END;
var
    r: ave;
BEGIN
    rewrite(a);

    leer_ave(r);
    while(r.cod <> -1)do begin
        write(a, r);    
        leer_ave(r);
    end;

    close(a);
END;
//_______________________________________________________________________________________________

procedure eliminar_aves(var a: archivo_aves);
var
    r: ave;
    cod: LongInt;
BEGIN
    reset(a);

        writeln('Ingrese codigo de ave a eliminar: '); readln(cod);
        while(cod <> valor_fin) do begin
            ok:= false;
            read(a, r);
            while (not(EOF(a)) and (r.cod <> cod)) do begin
                read(a, r);
            end;
            if not(EOF(a)) then begin
                seek(a, filePos(a) - 1);
                r.nombre:= '@' + r.nombre;
                write(a, r);
                writeln('Eliminado con exito');
            end
            else writeln('Codigo de ave inexistente');
            writeln('Ingrese codigo de ave a eliminar: '); readln(cod);
        end;

    close(a);
END;


procedure compactar_archivo(var a:archivo_aves);
    procedure compactar(var a: archivo_aves; pos: integer; var cont: integer);
    var
        regm : ave;
        ult_pos: integer;
    BEGIN
        ult_pos:= fileSize(a) - 1;
        seek(a, ult_pos - cont);
        read(a, regm);
        seek(a, pos);
        write(a, regm);
        cont:= cont + 1;
    END;
var
    cont: integer;
    regm: ave;
BEGIN
    reset(a);

    cont:= 0;
    while (filePos(a) <> fileSize(a) - cont) do begin
        read(a, regm);
        if (pos('@', regm.nombre) <> 0) then begin
            compactar(a, filePos(a) - 1, cont); // lo compacto, mandando el contador que se va a aumentar en 1, y la posicion donde lei ese dato. Una vez que el compactar reemplazo el ultimo dato con el borrado y aumento el contador
            seek(a, filePos(a) - 1); // es decir nos traemos el ultimo registro pero no sabemos si esta borrado asi que volvemos a procesar esa posicion. Si se borra de nuevo el contador va aumentando y nos vamos trayendo datos mas lejanos al filesize fisico al hacer truncate del filesize - los borrados, se hace correctamente las bajas sin perder datos no borrados
        end;
    end;
    seek(a, fileSize(a) - cont);
    truncate(a);

    close(a);
END;
//_______________________________________________________________________________________________
{
procedure compactar_archivo(var a:archivo_aves);
var
    pos_act: integer;
    regm: ave;
BEGIN
    reset(a);

    while not(EOF(a)) do begin
        read(a, regm);
        while (not(EOF(a)) and (pos('@', regm.nombre) = 0)) do read(a, regm);
        if not(EOF(a)) then begin
            pos_act:= filePos(a) - 1;
            seek(a, fileSize(a) - 1);
            read(a, regm);
            seek(a, filePos(a) - 1);
            truncate(a);
            seek(a, pos_act);
            write(a, regm);
        end;
    end;

    close(a);
END;}
//_______________________________________________________________________________________________

procedure imprimir(var archivo: archivo_aves);
var
    regm: ave;
BEGIN
    reset(archivo);

    while(not eof(archivo))do begin
        read(archivo, regm);
        writeln('Codigo: ', regm.cod, '; Nombre: ', regm.nombre);
    end;

    close(archivo);
END;

var
    m : archivo_aves;
BEGIN
    assign(m, 'archivo_aves');
    crear_archivo_aves(m);

    eliminar_aves(m);
    compactar_archivo(m);

    imprimir(m);
END.