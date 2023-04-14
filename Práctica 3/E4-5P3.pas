program E4P3;
type
    str30 = String[30];
    reg_flor = record
        nombre: str30;
        codigo:integer;
    end;

    t_arch_flores = file of reg_flor;
//_______________________________________________________________________________________________

procedure crear_archivo(var a: t_arch_flores);
    procedure leer_flor(var flor:reg_flor);
    BEGIN
        with flor do begin
            write('Ingresar codigo de flor: ');
            readln(codigo);
            if(codigo <> -1)then begin
                write('Ingresar nombre de la flor: ');
                readln(nombre);
            end;
        end;
    END;
var 
    regm: reg_flor;
BEGIN
    rewrite(a);

    writeln('~~~~~Creacion del archivo:~~~~~'#10);
    regm.codigo := 0;
    write(a, regm);
    leer_flor(regm);
    while(regm.codigo <> -1) do begin
        write(a, regm);
        leer_flor(regm);
    end;
    writeln(#10,'~~~~~Archivo creado con exito~~~~~',#10);

    close(a);
END;
//_______________________________________________________________________________________________

procedure agregarFlor(var a: t_arch_flores; nombre: str30; codigo: integer);
var
    flor, aux: reg_flor;
BEGIN
    reset(a);
    flor.nombre:= nombre;
    flor.codigo:= codigo;

    read(a, aux);
    if (aux.codigo < 0) then begin
        seek(a, abs(aux.codigo));
        read(a, aux);
        seek(a, filePos(a) - 1);
        write(a, flor);
        seek(a, 0);
        write(a, aux);
    end
    else begin
        seek(a, fileSize(a));
        write(a, flor);
    end;
    writeln('Agegada con exito');
    
    close(a);
END;
//_______________________________________________________________________________________________

procedure listar_archivo(var a: t_arch_flores);
var
    flor: reg_flor;
BEGIN
    reset(a);

    while not(EOF(a)) do begin
        read(a, flor);
        if (flor.codigo > 0) then writeln('Flor: ', flor.nombre, '; Codigo: ', flor.codigo);
    end;

    close(a);
END;
//_______________________________________________________________________________________________

procedure eliminarFlor (var a: t_arch_flores; flor:reg_flor);
var
    regm, aux: reg_flor;
BEGIN
    reset(a);

    read(a, aux);
    regm.codigo:= aux.codigo;
    while (not(EOF(a)) and (regm.codigo <> flor.codigo)) do read(a, regm);
    if not(EOF(a)) then begin
        regm.codigo:= aux.codigo;
        seek(a, filePos(a) - 1);
        aux.codigo:= (filePos(a) * -1);
        write(a, regm);
        seek(a, 0);
        write(a, aux);
        writeln(#10,'Eliminada con exito');
    end
    else writeln(#10,'Esa flor no existia en el archivo'); 

    close(a);
END;
//_______________________________________________________________________________________________

var
    a: t_arch_flores;
    flor: reg_flor;
BEGIN
    assign(a, 'maestro');
    crear_archivo(a);
    
    agregarFlor(a, 'Rosa', 1);
    agregarFlor(a, 'Hortensia', 3);
    agregarFlor(a, 'Azucena ', 2);
    agregarFlor(a, 'Margarita', 4);
    writeln(#10,'~~~~~Archivo completo:~~~~~');
    listar_archivo(a);

    flor.codigo:= 2; flor.nombre:= 'Azucena';
    eliminarFlor(a, flor);
    writeln(#10, '~~~~~Archivo sin ',flor.nombre,':~~~~~');
    listar_archivo(a);
END.