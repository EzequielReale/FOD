program E9P2;
const
    VALOR_ALTO = 9999; 
type
    mesa = record
        cod_provincia, cod_localidad, numero_mesa, cant_votos: integer;
    end;

    maestro = file of mesa;
//_____________________________________________________________

procedure crear_maestro(var m: maestro);
    procedure leer_mesa(var m: mesa);
    BEGIN
        with m do begin
            write('Ingresar codigo de provincia: ');
            readln(cod_provincia);
            if(cod_provincia <> -1)then begin
                write('Ingresar codigo de localidad: ');
                readln(cod_localidad);
                write('Ingresar numero de mesa: ');
                readln(numero_mesa);
                write('Ingresar cantidad de votos: ');
                readln(cant_votos);                
            end;
        end;
    END;
var
    reg: mesa;
BEGIN
    rewrite(m);
    leer_mesa(reg);
    while(reg.cod_provincia <> -1)do begin
        write(m, reg);
        leer_mesa(reg);
    end;
    close(m);
END;
//_____________________________________________________________

procedure listar_votos(var m: maestro);
    procedure leer_mesa_archivo(var m: maestro; var reg: mesa);
    BEGIN
        if(not eof(m))then
            read(m, reg)
        else
            reg.cod_provincia := VALOR_ALTO;
    END;

var
    reg: mesa;
    total_votos_provincia, total_votos_localidad, total_votos, prov_act, local_act: integer;    
BEGIN
    reset(m);
    total_votos:= 0;
    leer_mesa_archivo(m, reg);

    while(reg.cod_provincia <> VALOR_ALTO) do begin
        total_votos_provincia:= 0;
        prov_act:= reg.cod_provincia;
        writeln('.....................................');
        writeln('Código de Provincia: ', prov_act);
        writeln('Código de Localidad       Total de Votos');
        while(reg.cod_provincia = prov_act) do begin
            total_votos_localidad:= 0;
            local_act:= reg.cod_localidad;
            while((reg.cod_provincia = prov_act) and (reg.cod_localidad = local_act)) do begin
                total_votos_localidad:= total_votos_localidad + reg.cant_votos;
                leer_mesa_archivo(m, reg);
            end;
            total_votos_provincia:= total_votos_provincia + total_votos_localidad;
            writeln('        ',local_act, '                        ', total_votos_localidad);
        end;
        total_votos:= total_votos + total_votos_provincia;
        writeln();
        writeln('Total de Votos Provincia: ', total_votos_provincia);
    end;
    writeln('.....................................');
    writeln('Total General de Votos: ', total_votos);
    writeln('.....................................');

    close(m);
END;
//_____________________________________________________________

var
    m:maestro;
BEGIN
    assign(m, 'maestro');
    //crear_maestro(m);
    listar_votos(m);
END.