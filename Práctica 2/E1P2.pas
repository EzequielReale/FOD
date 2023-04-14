program E1P2;

const
    VALOR_ALTO = 9999;
type
    empleado = record
        cod: integer;
        nombre: String[15];
        monto: real;
    end;

    archivo_emp = file of empleado;

procedure crearArchivoComisiones(var archivo: archivo_emp);
    procedure leerComision(var e: empleado);
    begin
        write('Ingresar codigo de empleado: ');
        readln(e.cod);
        if(e.cod <> -1)then begin
            write('Ingresar nombre del empleado: ');
            readln(e.nombre);
            write('Ingresar monto de la comision: ');
            readln(e.monto);
        end;
    END;
var
    e: empleado;
BEGIN
    rewrite(archivo);
    leerComision(e);
    while(e.cod <> -1)do begin
        write(archivo, e);
        leerComision(e);
    end;
    close(archivo);
end;


procedure compactar(var archivo:archivo_emp; var archivo_comp:archivo_emp);
    procedure leer(var archivo:archivo_emp; var e:empleado);
    BEGIN
        if not(EOF(archivo)) then
            read(archivo, e)
        else
            e.cod:= VALOR_ALTO;
    END;
var
    e, e2: empleado;
BEGIN
    rewrite(archivo_comp); reset(archivo);
    
    leer(archivo, e);
    while (e.cod <> VALOR_ALTO) do begin    
        e2.cod:= e.cod;
        e2.nombre:= e.nombre;
        e2.monto:= 0;
        while (e.cod = e2.cod) do begin
            e2.monto:= e2.monto + e.monto;
            leer(archivo, e);
        end;
        write(archivo_comp, e2);
    end;

    close(archivo_comp); close(archivo);
END;


procedure verArchivo(var archivo: archivo_emp);
var
    e: empleado;
BEGIN
    reset(archivo);

    while(not eof(archivo))do begin
        read(archivo, e);
        writeln('Codigo: ',e.cod, '; Nombre: ', e.nombre, '; Monto: $', e.monto:2:2);
    end;

    close(archivo);
END;

var
    archivo, archivo_comp: archivo_emp;
BEGIN
    assign(archivo, 'archivo_comisiones'); assign(archivo_comp, 'archivo_comisiones_compacto');
    crearArchivoComisiones(archivo);
    compactar(archivo,archivo_comp);
    writeln(#10,'Archivo comun:');
    verArchivo(archivo);
    writeln(#10,'Archivo WinRar:');
    verArchivo(archivo_comp);
END.