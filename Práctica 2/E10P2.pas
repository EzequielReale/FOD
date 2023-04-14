program ejer10;
const
    VALOR_ALTO = 9999;
    CATEGORIAS = 15;
type
    empleado = record
        departamento: integer;
        division: integer;
        numero_empleado: integer;
        categoria: 1..CATEGORIAS;
        cant_horas_extra: integer;
    end;

    maestro = file of empleado;
    valores = array[1..CATEGORIAS] of real;



procedure crear_archivo_maestro(var m: maestro);
    procedure leer_empleado(var e: empleado);
    BEGIN
        with e do begin
            write('Ingresar departamento al que pertenece el empleado: ');
            readln(departamento);
            if(departamento <> -1)then begin
                write('Ingresar division a la que pertenece el empleado: ');
                readln(division);
                write('Ingresar numero de empleado: ');
                readln(numero_empleado);
                write('Ingresar categoria del empleado: ');
                readln(categoria);            
                write('Ingresar cantidad de horas extras realizadas por el empleado: ');
                readln(cant_horas_extra);
            end;
        end;
    END;
var
    e:empleado;
BEGIN
    rewrite(m);
    leer_empleado(e);
    while(e.departamento <> -1)do begin
        write(m, e);
        leer_empleado(e);
    end;
    close(m);
END;

procedure cargar_valores_por_hora(var a: Text; var monto_hora: valores);
var
    i: integer;
    monto: real;
BEGIN
    reset(a);
    while(not eof(a))do begin
        readln(a, i, monto);
        monto_hora[i] := monto;
    end;
    close(a);
END;

procedure leer_empleado_archivo(var a: maestro; var e:empleado);
BEGIN
    if(not eof(a))then
        read(a, e)
    else
        e.departamento := VALOR_ALTO;
END;

procedure listar_en_pantalla(var m: maestro; monto_hora: valores);
var
    act_dep: integer;
    total_horas_dep: integer;
    total_monto_dep: real;

    act_div: integer;
    total_horas_div: integer;
    total_monto_div: real;

    num_e_act: integer;
    cat_act: integer;
    total_horas_e_act: integer;
    total_monto_e_act: real;
    e: empleado;
BEGIN
    reset(m);
    leer_empleado_archivo(m, e);

    while (e.departamento <> VALOR_ALTO) do begin
        act_dep:= e.departamento;
        total_horas_dep:= 0; total_monto_dep:= 0;
        while (e.departamento = act_dep) do begin
            act_div:= e.division;
            total_horas_div:= 0; total_monto_div:= 0;
            while ((e.departamento = act_dep) and (e.division = act_div)) do begin
                num_e_act:= e.numero_empleado;
                total_horas_e_act:= 0; total_monto_e_act:= 0;
                cat_act:= e.categoria;
                while ((e.departamento = act_dep) and (e.division = act_div) and (e.numero = num_e_act)) do begin
                    total_horas_e_act:= total_horas_e_act + e.cant_horas_extra;
                    leer_empleado_archivo(m, e);
                end;
                total_monto_e_act := total_monto_e_act + (total_horas_e_act*monto_hora[cat_act]);
                writeln('       ',num_e_act,'                   ',total_horas_e_act,'             ', total_monto_e_act:2:2);
                total_horas_div := total_horas_div + total_horas_e_act;
                total_monto_div := total_monto_div + total_monto_e_act;
            end;
            writeln('Total de horas division: ', total_horas_div);
            writeln('Monto total por division: ', total_monto_div:2:2);            
            total_horas_dep := total_horas_dep + total_horas_div;
            total_monto_dep := total_monto_dep + total_monto_div;
        end;
        writeln('Total horas departamento: ', total_horas_dep);
        writeln('Monto total departamento: ', total_monto_dep:2:2);
    end;

    close(m);
END;

var
    m: maestro;
    archivo_texto: text;
    monto_hora: valores;
BEGIN
    assign(m, 'maestro');
    assign(archivo_texto, 'valor_hora.txt');
    //crear_archivo_maestro(m);
    cargar_valores_por_hora(archivo_texto, monto_hora);
    listar_en_pantalla(m, monto_hora);
END.