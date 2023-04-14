program P1E3;

type
    str12 = String[12];
    empleado = record
        numero, edad: integer;
        nombre, apellido: str12;
        dni: longint;
    end;
    archivo_emp = file of empleado; 

procedure saltosLinea;
BEGIN
    writeln; writeln;
END;

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


procedure listarTodos(var archivo:archivo_emp);
var
    e:empleado;
BEGIN
    while not(EOF(archivo)) do begin
        read(archivo, e);
        writeln('Empleado nro: ',e.numero,'; DNI: ',e.dni,'; nombre: ',e.nombre,'; apellido: ',e.apellido,'; edad: ',e.edad);
    end;
END;


procedure listarPorNombreApellido(var archivo:archivo_emp);
var
    e:empleado;
    busqueda: str12;
BEGIN
    write('Cuales empleados con x nombre u apellido le gustaria filtrar?: ');
    readln(busqueda);
    writeln;

    while not(EOF(archivo)) do begin
        read(archivo, e);
        if ((e.nombre = busqueda) or (e.apellido = busqueda)) then   
            writeln('Empleado nro: ',e.numero,'; DNI: ',e.dni,'; nombre: ',e.nombre,'; apellido: ',e.apellido,'; edad: ',e.edad);
    end;
END;


procedure listarJubilados(var archivo:archivo_emp);
var
    e:empleado;
BEGIN
    while not(EOF(archivo)) do begin
        read(archivo, e);
        if (e.edad > 70) then   
            writeln('Empleado nro: ',e.numero,'; DNI: ',e.dni,'; nombre: ',e.nombre,'; apellido: ',e.apellido,'; edad: ',e.edad);
    end;
END;


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

        reset(archivo);
        if (eleccion = 'a') then
            listarTodos(archivo)
        else if (eleccion = 'b') then
            listarPorNombreApellido(archivo)
        else if (eleccion = 'c') then
            listarJubilados(archivo)
        else
            close(archivo)  
    end;
END;

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
        writeln('Que desea hacer con este archivo?   a-crear   b-leerlo   otra tecla-salir');
        readln(eleccion);
        saltosLinea;

        if (eleccion = 'a') then
            armarArchivo(archivo)
        else if (eleccion = 'b') then
            leerArchivo(archivo)
        else
            writeln('Gracias, vuelva prontos')
    end;
END.