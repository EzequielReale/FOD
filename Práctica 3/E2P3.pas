program E2P3;
const
    ELIMINAR_DEBAJO = 1000;
type
    asistentes = record
        nro: integer;
        apellido: string[25];
        nombre: string[25];
        email: string[25];
        telefono: string[15];
        dni: string[8];
    end;

    maestro = file of asistentes;
//__________________________________________________________________________________________

procedure crear_archivo_maestro (var arch: maestro);
    procedure leer_asistente(var reg_m: asistentes);
    BEGIN
        write ('Ingrese numero de asistente: '); readln(reg_m.nro);
        if reg_m.nro <> -1 then begin
            write ('Ingrese apellido del asistente: '); readln(reg_m.apellido);
            write ('Ingrese nombre del asistente: '); readln(reg_m.nombre);
            write ('Ingrese email del asistente: '); readln(reg_m.email);
            write ('Ingrese telefono del asistente: '); readln(reg_m.telefono);
            write ('Ingrese dni del asistente: '); readln(reg_m.dni);
        end;
    END;
var
    reg_m: asistentes;
BEGIN
    rewrite(arch);
    leer_asistente(reg_m);
    while(reg_m.nro <> -1)do begin
        write(arch, reg_m);        
        leer_asistente(reg_m);
    end;
    close(arch);        
END;
//__________________________________________________________________________________________

procedure eliminar(var m:maestro);
var
    reg_m: asistentes;
BEGIN
    reset(m);
    while(not EOF(m))do begin
        read(m, reg_m);
        if(reg_m.nro < ELIMINAR_DEBAJO)the
            reg_m.dni := '@'+reg_m.dni;
        seek(m, filepos(m)-1);
        write(m, reg_m);
    end;
    close(m);
END;
//__________________________________________________________________________________________

procedure imprimir_asistente(reg_m: asistentes);
BEGIN
    writeln('');
    writeln('Numero de asistente: ', reg_m.nro);
    writeln('Apellido de asistente: ', reg_m.apellido);
    writeln('Nombre de asistente: ', reg_m.nombre);
    writeln('Dni de asistente: ', reg_m.dni);
    writeln('Telefono del asistente: ', reg_m.telefono);
    writeln('Email del asistente: ', reg_m.email);
    writeln('');
END;
//__________________________________________________________________________________________

procedure imprimir_maestro(var m:maestro);
var
    reg_m: asistentes;
BEGIN
    reset(m);
    while not eof(m) do begin
        read(m,reg_m);
        imprimir_asistente(reg_m);
    end;
    close(m);
END;
//__________________________________________________________________________________________

procedure imprimir_maestro_sin_eliminados(var m:maestro);
var
    reg_m: asistentes;
BEGIN
    reset(m);
    while not EOF(m) do begin
        read(m,reg_m);
        if (pos('@',reg_m.dni) = 0) then //El pos devuelve 0 si 
            imprimir_asistente(reg_m);
    end;
    close(m);
END;
//__________________________________________________________________________________________

var    
    m:maestro;
BEGIN
    assign(m, 'maestro');
    //crear_archivo_maestro(m);
    eliminar(m);
    writeln('Con eliminados: ');
    imprimir_maestro(m);
    writeln('Sin eliminados: ');
    imprimir_maestro_sin_eliminados(m);
END.