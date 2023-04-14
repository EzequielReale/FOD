program E1P3;
const
    VALOR_ALTO = 9999;
type
    str12 = String[12];
    empleado = record
        numero, edad: integer;
        nombre, apellido: str12;
        dni: longint;
    end;
    archivo_emp = file of empleado; 
//__________________________________________________________________________________________

procedure saltosLinea;
BEGIN
    writeln; writeln;
END;
//__________________________________________________________________________________________

procedure leer(var e:empleado);
BEGIN
    with e do begin
        write('Apellido del empleado: ');
        readln(apellido);
        if (apellido <> 'fin') then begin
            write('Nombre del empleado: ');
            readln(nombre);
            write('Edad del empleado: ');
            readln(edad);
            write('DNI del empleado: ');
            readln(dni);
            write('Numero de empleado: ');
            readln(numero);
        end;
    end;
    writeln;
END;
//__________________________________________________________________________________________

procedure armarArchivo(var archivo:archivo_emp);
var
    e:empleado;
BEGIN
    rewrite(archivo);
    
    leer(e);
    while (e.apellido <> 'fin') do begin
        write(archivo, e);
        leer(e);
    end;
    
    close(archivo);
END;
//__________________________________________________________________________________________

procedure agregar(var archivo:archivo_emp);
var
    e:empleado;
BEGIN
    reset(archivo);
    
    leer(e);
    if (e.apellido <> 'fin') then begin
        seek(archivo, filesize(archivo));
        write(archivo, e);
    end
    else
        writeln('Operacion no permitida');

    close(archivo);
END;
//__________________________________________________________________________________________

procedure modificarEdad(var archivo:archivo_emp);
var
    e:empleado;
    eleccion: char;
    edad: integer;
BEGIN
    reset(archivo);
    
    while not(EOF(archivo)) do begin
        read(archivo, e);
        writeln('Empleado nro: ',e.numero,'; DNI: ',e.dni,'; nombre: ',e.nombre,'; apellido: ',e.apellido,'; edad: ',e.edad);
        writeln('Modificar edad? (s/n)');
        readln(eleccion);
        if (eleccion = 's') then begin
            write('Nueva edad: ');
            readln(edad);
            e.edad:= edad;
            seek(archivo, filepos(archivo)-1);
            write(archivo, e);
        end;
    end;

    close(archivo);
END;
//__________________________________________________________________________________________

procedure exportarTexto(var archivo:archivo_emp);
var
    txt:text;
    e:empleado;
BEGIN
    reset(archivo);
    assign(txt, 'todos_empleados.txt');
    rewrite(txt);

    while not(EOF(archivo)) do begin
        read(archivo, e);
        with e do
            write(txt, 'Empleado nro: ',numero,'; DNI: ',dni,'; nombre: ',nombre,'; apellido: ',apellido,'; edad: ',edad, #10)
    end;
    writeln('Exportado con exito');
    
    close(archivo);
    close(txt);
END;
//__________________________________________________________________________________________

procedure exportarSinDNI(var archivo:archivo_emp);
var
    txt:text;
    e:empleado;
BEGIN
    reset(archivo);
    assign(txt, 'falta_DNI_empleado.txt');
    rewrite(txt);

    while not(EOF(archivo)) do begin
        read(archivo, e);
        with e do
            if (dni = 0) then
                write(txt, 'Empleado nro: ',numero,'; DNI: ',dni,'; nombre: ',nombre,'; apellido: ',apellido,'; edad: ',edad, #10)
    end;

    close(archivo);
    close(txt);
END;
//__________________________________________________________________________________________

procedure eliminar(var archivo:archivo_emp);
    procedure leer_empleado_archivo(var archivo:archivo_emp; var reg:empleado);
    BEGIN
        if(not EOF(archivo))then
            read(archivo, reg)
        else
            reg.numero := VALOR_ALTO;
    END;
var
    reg_act, reg_ult: empleado;
    num_elim: integer;
BEGIN
    write('Cual numero de empleado quiere eliminar?: '); readln(num_elim);
    reset(archivo);
    seek(archivo, fileSize(archivo)-1);
    read(archivo, reg_ult);
    if (reg_ult.numero = num_elim) then begin
        seek(archivo, fileSize(archivo)-1);
        truncate(archivo);
        writeln('Se elimino con exito');
    end
    else begin
        seek(archivo, 0);
        leer_empleado_archivo(archivo, reg_act);
        while ((reg_act.numero <> VALOR_ALTO) and (reg_act.numero <> num_elim)) do begin
            leer_empleado_archivo(archivo, reg_act);
        end;
        if (reg_act.numero <> VALOR_ALTO) then begin
            seek(archivo, filePos(archivo)-1);
            write(archivo, reg_ult);
            seek(archivo, fileSize(archivo)-1);
            truncate(archivo);
            writeln('Se elimino con exito y se movio el ultimo empleado a la posicion del eliminado')
        end
        else writeln('Empleado inexistente como las copas de Gimnasia');
    end;

    close(archivo);
END;
//__________________________________________________________________________________________

procedure escribirArchivo(var archivo:archivo_emp);
var
    eleccion: char;
BEGIN
    eleccion:= 'a';
    
    while ((eleccion >= 'a') and (eleccion <= 'f')) do begin
        saltosLinea;
        writeln('Que desea escribirle a este archivo?   a-Crear   b-Agregar empleado   c-Modificar edad de los empleados   d-Exportar a texto   e-Exportar a texto los empleados sin DNI   f-Eliminar empleado   otra tecla-volver al menu principal');
        readln(eleccion);
        saltosLinea;

        case eleccion of
            'a': armarArchivo(archivo);
            'b': agregar(archivo);
            'c': modificarEdad(archivo);
            'd': exportarTexto(archivo);
            'e': exportarSinDNI(archivo);
            'f': eliminar(archivo);
        end;
    end;
END;
//__________________________________________________________________________________________

procedure listarTodos(var archivo:archivo_emp);
var
    e:empleado;
BEGIN
    reset(archivo);

    while not(EOF(archivo)) do begin
        read(archivo, e);
        writeln('Empleado nro: ',e.numero,'; DNI: ',e.dni,'; nombre: ',e.nombre,'; apellido: ',e.apellido,'; edad: ',e.edad);
    end;

    close(archivo);
END;
//__________________________________________________________________________________________

procedure listarPorNombreApellido(var archivo:archivo_emp);
var
    e:empleado;
    busqueda: str12;
BEGIN
    reset(archivo);

    write('Cuales empleados con x nombre u apellido le gustaria filtrar?: ');
    readln(busqueda);
    writeln;

    while not(EOF(archivo)) do begin
        read(archivo, e);
        if ((e.nombre = busqueda) or (e.apellido = busqueda)) then   
            writeln('Empleado nro: ',e.numero,'; DNI: ',e.dni,'; nombre: ',e.nombre,'; apellido: ',e.apellido,'; edad: ',e.edad);
    end;

    close(archivo);
END;
//__________________________________________________________________________________________

procedure listarJubilados(var archivo:archivo_emp);
var
    e:empleado;
BEGIN
    reset(archivo);
    
    while not(EOF(archivo)) do begin
        read(archivo, e);
        if (e.edad > 70) then   
            writeln('Empleado nro: ',e.numero,'; DNI: ',e.dni,'; nombre: ',e.nombre,'; apellido: ',e.apellido,'; edad: ',e.edad);
    end;

    close(archivo);
END;
//__________________________________________________________________________________________

procedure leerArchivo(var archivo:archivo_emp);
var
    eleccion: char;
BEGIN
    eleccion:= 'a';
    
    while ((eleccion = 'a') or (eleccion = 'b') or (eleccion = 'c')) do begin
        saltosLinea;
        writeln('Que desea leer de este archivo?   a-Todos los empleados   b-Filtrar por nombre/apellido   c-Ver empleados proximos a jubilarse   otra tecla-volver al menu principal');
        readln(eleccion);
        saltosLinea;

        case eleccion of
            'a': listarTodos(archivo);
            'b': listarPorNombreApellido(archivo);
            'c': listarJubilados(archivo);
        end;
    end;
END;
//__________________________________________________________________________________________

var
    archivo: archivo_emp;
    nombre_arch: str12;
    eleccion: char;
BEGIN
    eleccion:= 'a';
    write('Ingrese el nombre del archivo: ');
    readln(nombre_arch);
    assign(archivo, nombre_arch);
    saltosLinea;
    
    while ((eleccion = 'a') or (eleccion = 'b')) do begin
        writeln('Que desea hacer con este archivo?   a-escribir   b-leer   otra tecla-salir');
        readln(eleccion);
        saltosLinea;

        case eleccion of
            'a': escribirArchivo(archivo);
            'b': leerArchivo(archivo);
            else writeln('Gracias, vuelva prontos')
        end;
    end;
END.