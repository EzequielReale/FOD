program E6P2;
const
    VALOR_ALTO = 9999;
    CANT_DETALLES = 10;
//_______________________________________________________________________________________________
type
    datos_ciudad = record
        cod_localidad, cod_cepa, casos_activos, casos_nuevos, recuperados, fallecidos: integer;
    end;

    datos_provincia = record
        datos_c: datos_ciudad;
        nombre_localidad, nombre_cepa: String[20];
    end;

    maestro = file of datos_provincia;
    detalle = file of datos_ciudad;

    v_datos = array [1..CANT_DETALLES] of datos_ciudad;
    v_detalles = array [1..CANT_DETALLES] of detalle;
//_______________________________________________________________________________________________

procedure crear_detalles(var vd:v_detalles);
    procedure leer_detalle(var datos:datos_ciudad);
    BEGIN
        with datos do begin
            write('Ingresar codigo de localidad: '); readln(cod_localidad);
            if(cod_localidad <> -1)then begin
                write('Ingresar codigo de cepa: '); readln(cod_cepa);
                write('Ingresar cantidad de casos activos: '); readln(casos_activos);
                write('Ingresar cantidad de casos nuevos: '); readln(casos_nuevos);
                write('Ingresar cantidad de recuperados: '); readln(recuperados);
                write('Ingresar cantidad de fallecidos: '); readln(fallecidos);
            end;
        end;
    END;
var
    i:integer;
    str_i: string;
    datos: datos_ciudad;
BEGIN
    for i:= 1 to CANT_DETALLES do begin
        Str(i, str_i);
        assign(vd[i], 'detalle ' + str_i);
        rewrite(vd[i]);
        writeln('Creacion de archivo detalle ', i, ': ');
        leer_detalle(datos);
        while(datos.cod_localidad <> -1)do begin
            write(vd[i], datos);
            leer_detalle(datos);
        end;
        close(vd[i]);
    end;
END;
//_______________________________________________________________________________________________

procedure crear_maestro(var m:maestro);
    procedure leer_informacion_maestro(var datos: datos_provincia);
    BEGIN
        with datos do begin
            write('Ingresar codigo de localidad: '); readln(datos_c.cod_localidad);
            if(datos_c.cod_localidad <> -1)then begin
                write('Ingresar nombre de la localidad: '); readln(nombre_localidad);
                write('Ingresar codigo de cepa: '); readln(datos_c.cod_cepa);
                write('Ingresar nombre de la cepa: '); readln(nombre_cepa);
                write('Ingresar cantidad de casos activos: '); readln(datos_c.casos_activos);
                write('Ingresar cantidad de casos nuevos: '); readln(datos_c.casos_nuevos);
                write('Ingresar cantidad de recuperados: '); readln(datos_c.recuperados);
                write('Ingresar cantidad de fallecidos: '); readln(datos_c.fallecidos);
            end;
        end;
    END;
var
    datos: datos_provincia;
BEGIN  
    writeln('Creacion de archivo maestro: ');
    rewrite(m);
    leer_informacion_maestro(datos);
    while(datos.datos_c.cod_localidad <> -1)do begin
        write(m, datos);    
        leer_informacion_maestro(datos);
    end;
    close(m);
END;
//_______________________________________________________________________________________________

procedure actualizar_maestro(var m:maestro; var v_det:v_detalles);
    procedure leer(var det:detalle; var d:datos_ciudad);
    BEGIN
        if not(EOF(det)) then read(det, d)
        else d.cod_localidad:= VALOR_ALTO;
    END;
    procedure minimo(var v_det:v_detalles; var v_dat:v_datos; var min:datos_ciudad);
    var
        i, posMin: integer;
    BEGIN
        min.cod_localidad:= VALOR_ALTO; min.cod_cepa:= VALOR_ALTO;
        for i:= 1 to CANT_DETALLES do begin
            if (v_dat[i].cod_localidad < min.cod_localidad) then begin
                if (v_dat[i].cod_cepa < min.cod_cepa) then begin
                    min:= v_dat[i];
                    posMin:= i;
                end;
            end;
        end;
        if (min.cod_localidad <> VALOR_ALTO) then leer(v_det[posMin], v_dat[posMin])
    END;
    procedure resetear(var v_det:v_detalles; var v_dat:v_datos);
    var
        i: integer;
    BEGIN
        for i:= 1 to CANT_DETALLES do begin
            reset(v_det[i]);
            leer(v_det[i], v_dat[i]);
        end;
    END;
var
    i: integer;
    v_dat: v_datos;
    min: datos_ciudad;
    reg_mae, reg_mae_aux: datos_provincia;
BEGIN
    reset(m);
    resetear(v_det, v_dat);

    minimo(v_det, v_dat, min);
    while (min.cod_localidad <> VALOR_ALTO) do begin
        reg_mae_aux.datos_c.cod_localidad:= min.cod_localidad;
        reg_mae_aux.datos_c.cod_cepa:= min.cod_cepa;
        while ((reg_mae_aux.datos_c.cod_localidad = min.cod_localidad) and (reg_mae_aux.datos_c.cod_cepa = min.cod_cepa)) do begin
            reg_mae_aux.datos_c.casos_activos:= reg_mae_aux.datos_c.casos_activos + min.casos_activos;
            reg_mae_aux.datos_c.casos_nuevos:= reg_mae_aux.datos_c.casos_nuevos + min.casos_nuevos;
            reg_mae_aux.datos_c.recuperados:= reg_mae_aux.datos_c.recuperados + min.recuperados;
            reg_mae_aux.datos_c.fallecidos:= reg_mae_aux.datos_c.fallecidos + min.fallecidos;
            minimo(v_det, v_dat, min);
        end;

        read(m, reg_mae);
        while ((not EOF(m)) and (reg_mae.datos_c.cod_localidad <> reg_mae_aux.datos_c.cod_localidad) and (reg_mae.datos_c.cod_cepa <> reg_mae_aux.datos_c.cod_cepa)) do begin
            read(m, reg_mae);
        end;

        reg_mae.datos_c.casos_activos:= reg_mae.datos_c.casos_activos + reg_mae_aux.datos_c.casos_activos;
        reg_mae.datos_c.casos_nuevos:= reg_mae.datos_c.casos_nuevos + reg_mae_aux.datos_c.casos_nuevos;
        reg_mae.datos_c.recuperados:= reg_mae.datos_c.recuperados + reg_mae_aux.datos_c.recuperados;
        reg_mae.datos_c.fallecidos:= reg_mae.datos_c.fallecidos + reg_mae_aux.datos_c.fallecidos;
        seek(m, filePos(m)-1);
        write(m, reg_mae);
    end;

    for i:= 1 to CANT_DETALLES do close(v_det[i]);
    close(m);
END;
//_______________________________________________________________________________________________

procedure informar_mas_50_casos(var m:maestro);
var
    reg_mae: datos_provincia;
BEGIN
    reset(m);

    while not(EOF(m)) do begin
        read(m, reg_mae);
        if (reg_mae.datos_c.casos_activos > 50) then writeln('Localidad con mas de 50 casos activos: ',reg_mae.datos_c.cod_localidad, ' de la cepa de codigo: ',reg_mae.datos_c.cod_cepa)
    end;

    close(m);
END;
var
    m: maestro;
    vd: v_detalles;
    i:integer;
BEGIN
    assign(m, 'maestro');
    crear_maestro(m);
    crear_detalles(vd);
    actualizar_maestro(m,vd);
    informar_mas_50_casos(m);
END.