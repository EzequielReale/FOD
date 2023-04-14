program E4P2;
const
	PC = 5;
	VALOR_ALTO = 9999;
type
	data = record
        cod, tiempo: integer;
        fecha: string;
	end;
    log = file of data;
    v_log = array [1..PC] of log;
    v_data = array [1..PC] of data;
//_______________________________________________________________________________________________

procedure crearDetalles(var v:v_log);    
    procedure leer(var d:data);
    BEGIN
        with d do begin
            write('Codigo de usuario: '); readln(cod);
            if (cod > -1) then begin
                write('Fecha: '); readln(fecha);
                write('Tiempo de la sesion: '); readln(tiempo);
            end;
        end;
    END;
var
    i: integer;
    d: data;
    num_string: string;
BEGIN
    for i:= 1 to PC do begin
        str(i, num_string);
        assign(v[i], 'Det '+num_string);
        rewrite(v[i]);

        writeln(#10,'Detalle ',i);
        leer(d);
        while(d.cod > -1) do begin
            write(v[i], d);
            leer(d);
        end;

        close(v[i]);
    end;
END;
//_______________________________________________________________________________________________

procedure crearMaestro(var maestro:log; var vl:v_log);
    procedure leer_dato(var d:data; var detalle:log);
    BEGIN
        if not(EOF(detalle)) then
            read(detalle, d)
        else
            d.cod:= VALOR_ALTO;
    END;

    procedure resetear(var vl:v_log; var vd:v_data);
    var 
        i: integer;
    BEGIN
        for i:= 1 to PC do begin
            reset(vl[i]);
            leer_dato(vd[i],vl[i]); //se llena el vector de registros
        end;
    END;

    procedure minimo(var vl:v_log; var vd:v_data; var min:data);
    var
        i, PosMin: integer;
    BEGIN
        min.cod:= VALOR_ALTO; posMin:= -9999;
        for i:= 1 to PC do begin
            if (vd[i].cod <> VALOR_ALTO) then begin //si no está vacío
                if (vd[i].cod < min.cod) or ((vd[i].cod = min.cod) and (vd[i].fecha < min.fecha)) then begin
                    posMin:= i;
                    min:= vd[i];
                end;
            end;
        end;
        if (min.cod <> VALOR_ALTO) then
            leer_dato(vd[posMin],vl[posMin]);
    END;

var
    vd: v_data;
    min, datMae: data;
BEGIN
    rewrite(maestro);
    resetear(vl,vd);
    
    minimo(vl,vd,min);
    while (min.cod <> VALOR_ALTO) do begin
        datMae.cod:= min.cod;
        datMae.tiempo:= 0;
        while (datMae.cod = min.cod) do begin
            datMae.tiempo:= datMae.tiempo + min.tiempo;
            datMae.fecha:= min.fecha;
            minimo(vl,vd,min);
        end;
        write(maestro, datMae);
    end;

    close(maestro);
END;
//_______________________________________________________________________________________________

procedure imprimir(var maestro:log);
var
    d: data;
BEGIN
    reset(maestro);

    while not(EOF(maestro))do begin
        read(maestro,d);
        writeln('Usuario: ',d.cod,'; Tiempo total: ',d.tiempo,'; Ultima sesion: ',d.fecha);
    end;

    close(maestro);
END;
//_______________________________________________________________________________________________
//Programa Principal

var
    maestro: log;
    detalles: v_log;
BEGIN
    assign(maestro, 'Maestro');
    crearDetalles(detalles);
    crearMaestro(maestro,detalles);
    imprimir(maestro);
END.