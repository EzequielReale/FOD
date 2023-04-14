program E5P2;

const
    CANT_DELEGACIONES = 50;
    VALOR_ALTO = 9999;
//_______________________________________________________________________________________________

type
    str20 = string[20];

    direccion = record
        calle, nro, piso, depto, ciudad: str20;
    end;
    persona = record
        nombre, apellido: str20;
        nro_partida: integer;
    end;
    padres = record
        nombre, apellido: str20;
        dni: longint;
    end;
    deceso = record
        matricula_medico: integer;
        fecha_y_hora, lugar: str20;
    end;

    nacimiento = record
        datos_persona: persona;
        dir: direccion;
        matricula_medico: integer;
        madre, padre: padres;
    end;
    fallecimiento = record
        datos_persona: persona;
        dni: longint;
        madre, padre: padres;
        datos_deceso: deceso;
    end;

    info_maestro = record
        info_nacimientos: nacimiento;
        info_fallecimientos: fallecimiento;
    end;

    nacimientos = file of nacimiento;
    fallecimientos = file of fallecimiento;
    maestro = file of info_maestro;

    v_nacimientos = array [1..CANT_DELEGACIONES] of nacimiento;
    v_fallecimientos = array [1..CANT_DELEGACIONES] of fallecimiento;

    detalles_nacimientos = array [1..CANT_DELEGACIONES] of nacimientos;
    detalles_fallecimientos = array [1..CANT_DELEGACIONES] of fallecimientos;
//_______________________________________________________________________________________________

procedure leer_datos_persona(var datos:persona);
BEGIN
    with datos do begin
        write('Ingresar nro de partida de nacimiento: '); readln(nro_partida);
        if(nro_partida <> -1)then begin
            write('Ingresar nombre de persona: '); readln(nombre);
            write('Ingresar apellido de persona: '); readln(apellido);
        end;        
    end;
END;
//_______________________________________________________________________________________________

procedure crear_detalle_fallecimientos(var d:detalles_fallecimientos);
    procedure leer_fallecimiento(var f: fallecimiento);
        procedure leer_deceso(var d:deceso);
        BEGIN
            with d do begin
                write('Ingresar numero de matricula del medico que firmo el deceso: '); readln(matricula_medico);
                write('Ingresar fecha y hora del deceso: '); readln(fecha_y_hora);
                write('Ingresar lugar de deceso: '); readln(lugar);
            end;
        END;
    BEGIN
        with f do begin
            leer_datos_persona(datos_persona);
            if(datos_persona.nro_partida <> -1)then begin
                write('Ingresar DNI: '); readln(dni);
                leer_deceso(datos_deceso);
            end;
        end;
    END;
var
    i: integer;
    f: fallecimiento;
    str_i: string[1];
BEGIN
    for i:= 1 to CANT_DELEGACIONES do begin
        Str(i, str_i);
        assign(d[i], 'detalle fallecimientos ' + str_i);
        rewrite (d[i]);

        leer_fallecimiento(f);
        while(f.datos_persona.nro_partida <> -1) do begin
            write(d[i], f);
            leer_fallecimiento(f);
        end;

        close(d[i]);
    end;
END;
//_______________________________________________________________________________________________

procedure crear_detalle_nacimientos(var d:detalles_nacimientos);
    procedure leer_nacimiento(var n: nacimiento);
        procedure leer_direccion(var d:direccion);
        BEGIN
            with d do begin
                write('Ingresar calle: '); readln(calle);
                write('Ingresar numero: '); readln(nro); write('Ingresar piso: '); readln(piso);
                write('Ingresar depto: '); readln(depto);
                write('Ingresar ciudad: '); readln(ciudad);
            end;
        END;
    BEGIN
        with n do begin
            leer_datos_persona(datos_persona);
            if(datos_persona.nro_partida <> -1)then begin
                write('Ingresar numero de matricula del medico: ');
                readln(n.matricula_medico);

                write('Ingresar nombre de la madre: ');
                readln(n.madre.nombre);
                write('Ingresar apellido de la madre: ');
                readln(n.madre.apellido);
                write('Ingresar DNI de la madre: ');
                readln(n.madre.DNI);
                
                write('Ingresar nombre del padre: ');
                readln(n.padre.nombre);
                write('Ingresar apellido del padre: ');
                readln(n.padre.apellido);
                write('Ingresar DNI del padre: ');
                readln(n.padre.DNI);

                leer_direccion(dir);
            end;
        end;
    END;
var
    i: integer;
    n: nacimiento;
    str_i: string[1];
BEGIN
    for i:= 1 to CANT_DELEGACIONES do begin
        Str(i, str_i);
        assign(d[i], 'detalle nacimientos ' + str_i);
        rewrite (d[i]);

        leer_nacimiento(n);
        while(n.datos_persona.nro_partida <> -1) do begin
            write(d[i], n);
            leer_nacimiento(n);
        end;

        close(d[i]);
    end;
END;
//_______________________________________________________________________________________________

procedure crear_maestro(var m:maestro; var dn:detalles_nacimientos; var df:detalles_fallecimientos);
    procedure leerNacimiento(var fn:nacimientos; var n:nacimiento);
    BEGIN
        if not(EOF(fn)) then read(fn, n)
        else n.datos_persona.nro_partida:= VALOR_ALTO;
    END;
    procedure leerFallecimiento(var ff:fallecimientos; var f:fallecimiento);
    BEGIN
        if not(EOF(ff)) then read(ff, f)
        else f.datos_persona.nro_partida:= VALOR_ALTO;
    END;
    procedure minimoNacimiento(var dn:detalles_nacimientos; var vn:v_nacimientos; var min:nacimiento);
    var
        i, posMin: integer;
    BEGIN
        min.datos_persona.nro_partida:= VALOR_ALTO;
        for i:= 1 to CANT_DELEGACIONES do begin
            if (vn[i].datos_persona.nro_partida < min.datos_persona.nro_partida) then begin
                min:= vn[i];
                posMin:= i;
            end;
        end;
        if(min.datos_persona.nro_partida <> VALOR_ALTO) then leerNacimiento(dn[posMin],vn[posMin]);
    END;
    procedure minimoFallecimiento(var df:detalles_fallecimientos; var vf:v_fallecimientos; var min:fallecimiento);
    var
        i, posMin: integer;
    BEGIN
        min.datos_persona.nro_partida:= VALOR_ALTO;
        for i:= 1 to CANT_DELEGACIONES do begin
            if (vf[i].datos_persona.nro_partida < min.datos_persona.nro_partida) then begin
                min:= vf[i];
                posMin:= i;
            end;
        end;
        if(min.datos_persona.nro_partida <> VALOR_ALTO) then leerFallecimiento(df[posMin],vf[posMin]);
    END;
    procedure resetear(var dn:detalles_nacimientos; var df:detalles_fallecimientos; var vn:v_nacimientos; var vf:v_fallecimientos);
    var 
        i: integer;
    BEGIN
        for i:= 1 to CANT_DELEGACIONES do begin
            reset(dn[i]);
            reset(df[i]);
            leerNacimiento(dn[i], vn[i]);
            leerFallecimiento(df[i], vf[i]);
        end;
    END;
var
    i: integer;
    reg_maestro: info_maestro;
    min_f: fallecimiento;
    min_n: nacimiento;
    vf: v_fallecimientos;
    vn: v_nacimientos;
    fallecio: boolean;
    txt: text;
BEGIN
    rewrite(m);
    assign(txt, 'maestro_texto.txt');
    rewrite(txt);
    resetear(dn,df,vn,vf);
    minimoNacimiento(dn,vn,min_n);
    minimoFallecimiento(df,vf,min_f);

    while(min_n.datos_persona.nro_partida <> VALOR_ALTO) do begin
        fallecio:= false;
        reg_maestro.info_nacimientos:= min_n;
        if (min_n.datos_persona.nro_partida = min_f.datos_persona.nro_partida) then begin
            fallecio:= true;
            reg_maestro.info_fallecimientos:= min_f;
            minimoFallecimiento(df,vf,min_f);
        end;
        write(m, reg_maestro);
        with reg_maestro do begin
            with info_nacimientos do begin
                writeln(txt, 'Nombre: ',datos_persona.nombre,'; Apellido: ',datos_persona.apellido,'; Partida de nacimiento nro: ',datos_persona.nro_partida,'; Matricula del medico que firma el nacimiento: ',matricula_medico);
                writeln(txt, 'Direccion-> Calle: ',dir.calle,'; Numero: ',dir.nro,'; Piso: ',dir.piso,'; Departamento: ',dir.depto,'; Ciudad: ',dir.ciudad);
                writeln(txt, 'Madre-> Nombre: ',madre.nombre,'; Apellido: ',madre.apellido,'; DNI: ',madre.dni);
                writeln(txt, 'Padre-> Nombre: ',padre.nombre,'; Apellido: ',padre.apellido,'; DNI: ',padre.dni); 
            end;
            if fallecio then writeln(txt, 'Datos del difunto-> DNI: ',info_fallecimientos.dni,'; Matricula del medico que firma el deceso: ',info_fallecimientos.datos_deceso.matricula_medico,'; Fecha y hora del deceso: ',info_fallecimientos.datos_deceso.fecha_y_hora,'; Lugar del deceso: ',info_fallecimientos.datos_deceso.lugar);
            writeln(txt, '');
        end;
        minimoNacimiento(dn,vn,min_n);
    end;

    for i:= 1 to CANT_DELEGACIONES do begin
        close(dn[i]);
        close(df[i]);
    end;
    close(m);
    close(txt);
END;
//_______________________________________________________________________________________________

var
    d_n: detalles_nacimientos;
    d_f: detalles_fallecimientos;
    m: maestro;
BEGIN
    assign(m, 'maestro');
    crear_detalle_nacimientos(d_n);
    crear_detalle_fallecimientos(d_f);
    crear_maestro(m,d_n,d_f);
END.