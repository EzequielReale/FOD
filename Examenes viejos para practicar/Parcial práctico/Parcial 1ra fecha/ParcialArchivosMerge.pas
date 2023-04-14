Program parcial;

const
    VALOR_ALTO = 9999;
    CANT_ARCHIVOS = 2;
type
    producto = record
        cod, precio, s_act, s_min: integer;
    end;

    pedido = record
        cod, cant_pedida: integer;
        fecha: longint;
    end;

    maestro = file of producto;
    detalle = file of pedido;

    v_detalles = array [1..CANT_ARCHIVOS] of detalle;
    v_pedidos = array [1..CANT_ARCHIVOS] of pedido;

procedure leer(var d: detalle; var p: pedido);
BEGIN
    if not(EOF(d)) then read(d, p);
    else p.cod:= VALOR_ALTO;
END;

procedure minimo(var detalles: v_detalles; var minimos: v_pedidos; var min: pedido; var posMin: integer);
var
    i: integer;
BEGIN
    min.cod:= VALOR_ALTO;
    for i:= 1 to CANT_ARCHIVOS do begin
        if (minimos[i].cod < min.cod) then begin
            min.cod:= minimos[i];
            posMin:= i;
        end;
    end;
    if (min.cod <> VALOR_ALTO) then leer(detalles[posMin], minimos[posMin]);
END;

procedure actualizar_maestro(var m: maestro; var detalles: v_detalles);
var
    min: pedido;
    regm: producto;
    minimos: v_pedidos;
    i, posMin, diferencia: integer;
BEGIN
    reset(m);
    for i:= 1 to CANT_ARCHIVOS do begin
        reset(detalles[i]);
        leer(detalles[i], minimos[i]);
    end;

    minimo(detalles, minimos, min, posMin);
    while (min.cod <> VALOR_ALTO) do begin
        read(m, regm);
        diferencia:= 0;
        while (min.cod <> regm.cod) do read(m, regm);
        while(regm.cod = min.cod) do begin
            regm.s_act:= regm.s_act - min.cant_pedida;
            if (regm.s_act < 0) then begin
                diferencia:= diferencia + regm.s_act * (-1);
                regm.s_act:= 0;
                writeln('Al pedido nro ',posMin,' no se le han podido enviar ',diferencia, 'unidades del producto', min.cod);
            end;    
            if (regm.s_act < regm.s_min) then writeln('Producto ',regm.cod,' por debajo del stock minimo por ',regm.s_min - regm.s_act,' unidades.');
            minimo(detalles, minimos, min, posMin);
        end;
        seek(m, filePos(m) - 1);
        write(m, regm);
    end;

    close(m);
    for i:= 1 to CANT_ARCHIVOS do close(detalles[i]);
END;

var
    maestro: maestro;
    v_detalles: v_detalles;
    i: integer;
    str_i: string[2];
BEGIN
    assign(maestro, 'maestro');
    for i:= 1 to CANT_ARCHIVOS do begin
        str(i, str_i);
        assign(v_detalles[i], 'detalle '+str_i);
    end;

    actualizar_maestro(maestro, v_detalles);
END;