program ejer8;
const
    VALOR_ALTO = 9999;
    ANIO_FIN = 2050;
type
    cliente = record
        cod: integer;
        nombre: string[20];
        apellido: string[20];
    end;

    venta = record
        c: cliente;
        anio: 2000..ANIO_FIN;
        mes: 1..12;
        dia: 1..31;
        monto_venta: real;
    end;

    archivo_maestro = file of venta;
//_______________________________________________________________________________________________

procedure crear_maestro(var m: archivo_maestro);
    procedure leer_venta(var v: venta);
    BEGIN
        with v do begin
            write('Ingresar codigo de cliente: ');
            readln(c.cod);
            if(c.cod <> -1)then begin
                write('Ingresar nombre del cliente: ');
                readln(c.nombre);
                write('Ingresar apellido del cliente: ');
                readln(c.apellido);

                write('Ingresar anio de la venta: ');
                readln(anio);
                write('Ingresar mes de la venta: ');
                readln(mes);             
                write('Ingresar dia de la venta: ');
                readln(dia);
                write('Ingresar monto de la venta: ');
                readln(monto_venta);             
             
            end;
        end;
    END;

var
    v: venta;
BEGIN
    rewrite(m);
    writeln('Creacion de archivo maestro: ');
    leer_venta(v);
    while(v.c.cod <> -1)do begin
        write(m, v);
        leer_venta(v);
    end;
    close(m);
END;
//_______________________________________________________________________________________________

procedure reporte_maestro(var m: archivo_maestro);
    procedure leer_venta_archivo(var m: archivo_maestro; var v: venta);
    BEGIN
        if(not eof(m))then read(m, v)
        else v.c.cod := VALOR_ALTO;
    END;

    procedure imprimir_cliente(c:cliente);
    BEGIN
        with c do writeln('Cliente codigo: ', cod,' Nombre ', nombre, ' Apellido ', apellido);
    END;

var
    v: venta;
    c: cliente;
    total_cliente, total_empresa, total_mes, total_anio: real;
    mes_act : 1..12;
    anio_act : 2000..ANIO_FIN;
BEGIN
    reset(m);
    total_empresa:= 0;
    leer_venta_archivo(m, v);
    
    while (v.c.cod <> VALOR_ALTO) do begin
        c:= v.c;
        writeln('=================================================');
        imprimir_cliente(c);
        writeln('=================================================');
        total_cliente := 0;
        while (v.c.cod = c.cod) do begin
            total_anio:= 0;
            anio_act:= v.anio;
            while ((v.c.cod = c.cod) and (v.anio = anio_act)) do begin
                total_mes:= 0;
                mes_act:= v.mes;
                while ((v.c.cod = c.cod) and (v.anio = anio_act) and (v.mes = mes_act)) do begin
                    total_mes:= total_mes + v.monto_venta;
                    leer_venta_archivo(m, v);
                end;
                writeln('Total del mes ',mes_act,': $',total_mes:1:2);
                total_anio:= total_anio + total_mes; 
            end;    
            writeln('Total del anio ',anio_act,': $',total_anio:1:2);
            writeln('=================================================');
            total_cliente:= total_cliente + total_anio;
        end;
        writeln('=================================================');
        writeln('Total del cliente: $',total_cliente:1:2);
        total_empresa:= total_empresa + total_cliente;
    end;
    writeln(#10,'=================================================',#10,'=================================================');
    writeln('Total de la empresa: $',total_empresa:1:2);

    close(m);
END;
//_______________________________________________________________________________________________

var
    maestro : archivo_maestro;
BEGIN
    assign(maestro, 'maestro');
    //crear_maestro(maestro);
    reporte_maestro(maestro);
END.