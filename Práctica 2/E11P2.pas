program E11P2;
const
    VALOR_ALTO = '9999';
    CANT_ARCHIVOS = 2;
type
    datos = record
        provincia: string[20];
        cant_alfa: integer;
        cant_encuestados: integer;
    end;

    datos_detalle = record
        info: datos;
        cod_localidad: integer;
    end;

    archivo_maestro = file of datos;
    archivo_detalle = file of datos_detalle;

    archivos = array[1..CANT_ARCHIVOS] of archivo_detalle;
    minimos = array[1..CANT_ARCHIVOS] of datos_detalle;
//_________________________________________________________________________

procedure leer_datos(var d:datos);
BEGIN
    with d do begin
        write('Ingresar nombre de la provincia: ');
        readln(provincia);
        if(provincia <> '')then begin
            write('Ingresar cantidad de alfabetizados: ');
            readln(cant_alfa);
            write('Ingresar cantidad de encuestados: ');
            readln(cant_encuestados);
            
        end;        
    end;
END;
//_________________________________________________________________________

procedure leer_datos_detalle(var d: datos_detalle);
BEGIN
    with d do begin
        leer_datos(info);
        if(info.provincia <> '')then begin
            write('Ingresar codigo de localidad: ');
            readln(cod_localidad);
        end;
    end;
END;
//_________________________________________________________________________

procedure crear_maestro(var m: archivo_maestro);
var
    d: datos;
BEGIN
    writeln('Creacion de archivo maestro: ');
    rewrite(m);
    leer_datos(d);
    while(d.provincia <> '')do begin
        write(m, d);
        leer_datos(d);
    end;
    close(m);
END;
//_________________________________________________________________________

procedure crear_detalles(var v:archivos);
var
    i: integer;
    d: datos_detalle;
    str_i: string;
BEGIN
    writeln('Creacion de archivo detalle: ');
    for i:=1 to CANT_ARCHIVOS do begin
        Str(i, str_i);
        assign(v[i], 'd'+str_i);
        rewrite(v[i]);
        leer_datos_detalle(d);
        while(d.info.provincia <> '')do begin
            write(v[i], d);
            leer_datos_detalle(d);
        end;
        close(v[i]);    
    end;
END;
//_________________________________________________________________________

procedure actualizar_maestro(var m: archivo_maestro; var v:archivos);
    procedure leer_datos_detalle_archivo(var a: archivo_detalle; var v: datos_detalle);
    BEGIN
        if(not eof(a))then
            read(a, v)
        else
            v.info.provincia := VALOR_ALTO;
    END;
    procedure minimo(var v:archivos; var vm:minimos; var min:datos_detalle);
    var
        i, posMin: integer;
    BEGIN
        min.info.provincia:= VALOR_ALTO;
        for i:= 1 to CANT_ARCHIVOS do begin
            if (vm[i].info.provincia < min.info.provincia) then begin
                min:= vm[i];
                posMin:= i;
            end;
        end;
        if (min.info.provincia <> VALOR_ALTO) then leer_datos_detalle_archivo(v[posMin], vm[posMin]);
    END;
var
    i: integer;
    v_min: minimos;
    min: datos_detalle;
    regm: datos;
BEGIN
    reset(m);
    for i:= 1 to CANT_ARCHIVOS do begin
        reset(v[i]);
        leer_datos_detalle_archivo(v[i], v_min[i]);
    end;

    minimo(v, v_min, min);
    while (min.info.provincia <> VALOR_ALTO) do begin
        read(m, regm);
        while (min.info.provincia <> regm.provincia) do read(m, regm);
        
        while (min.info.provincia = regm.provincia) do begin
            regm.cant_alfa:= regm.cant_alfa + min.info.cant_alfa;
            regm.cant_encuestados:= regm.cant_encuestados + min.info.cant_encuestados;
            minimo(v, v_min, min);
        end;
        seek(m, filePos(m)-1);
        write(m, regm);
    end;

    close(m);
    for i:= 1 to CANT_ARCHIVOS do close(v[i])
END;
//_________________________________________________________________________

var 
    d:datos;
    maestro: archivo_maestro;
    vector: archivos;
BEGIN
    assign(maestro, 'maestro');
    //crear_maestro(maestro);
    //crear_detalles(vector);
    actualizar_maestro(maestro, vector);
    
    //print de maestro para ver si funciona:
    {reset(maestro);
    while(not eof(maestro))do begin
        read(maestro, d);
        writeln(d.provincia, ' ', d.cant_alfa, ' ', d.cant_encuestados);  
    end;
    close(maestro);}
END.