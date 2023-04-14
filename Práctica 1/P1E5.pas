program P1E5;

type
    celular = record
        cod, stock_min, stock_disp: integer;
        nombre, marca: String[15];
        descripcion: String[50];
        precio: real;
    end;

    archivo_cel = file of celular;


procedure imprimir(c:celular);
BEGIN
    with c do 
        writeln(#10,'Codigo: ',cod,'; Marca: ',marca,'; Nombre: ',nombre,'; Descripcion: ',descripcion,'; Precio: ',precio:1:2,'; Stock minimo: ',stock_min,'; Stock disponible: ',stock_disp);
END;


procedure crearArchivo(var archivo:archivo_cel);
var
    txt: text;
    c: celular;
BEGIN
    assign(txt, 'celulares.txt');
    reset(txt);
    rewrite(archivo);

    while not(EOF(txt)) do BEGIN
        with c do begin
            readln(txt, cod, precio, marca);
            readln(txt, stock_disp, stock_min, descripcion);
            readln(txt, nombre);
        end;
        write(archivo, c);
        
    end;

    close(txt);
    close(archivo);

    writeln(#10'Creado con exito');
END;


procedure listarSinStock(var archivo:archivo_cel);
var
    c: celular;
BEGIN
    reset(archivo);

    while not(EOF(archivo)) do begin
        read(archivo, c);
        if (c.stock_disp < c.stock_min) then
            imprimir(c);
    end;
    
    close(archivo);
END;


procedure listarPorDescripcion(var archivo:archivo_cel);
var
    c: celular;
    cadena: string[50];
    encontro: boolean;
begin
    reset(archivo);
    
    encontro:= false;
    write(#10,'Ingrese cadena de texto: ');
    readln(cadena);
    writeln('Resultados que coinciden: ');
    
    while(not EOF(archivo))do begin
        read(archivo,c);
        if (pos(cadena, c.descripcion) <> 0) then begin
            imprimir(c);
            encontro:= true;
        end;
    end;
    if(not encontro)then
        writeln('La cadena que ingreso no coincide con ninguna descripcion');
    
    close(archivo);
end;


procedure exportarAtxt(var archivo:archivo_cel);
var
    txt: text;
    c: celular;
BEGIN
    assign(txt, 'celulares.txt');
    rewrite(txt);
    reset(archivo);

    while not(EOF(archivo)) do BEGIN
        read(archivo, c);
        with c do begin
            writeln(txt, cod,' ', precio:1:2, marca);
            writeln(txt, stock_disp,' ', stock_min, descripcion);
            writeln(txt, nombre);
        end;
    end;

    close(txt);
    close(archivo);

    writeln(#10,'Creado con exito');
END;


var
    archivo: archivo_cel;
    eleccion: char;
BEGIN
    assign(archivo, 'celulares');
    eleccion:= 'a';

    while ((eleccion >= 'a') and (eleccion <= 'd')) do begin
        writeln(#10,'Que desea hacer estimado?');
        writeln('a-Crear archivo binario a partir de un archivo texto   b-Listar celulares con stock por debajo del minimo   c-Listar celulares por descripcion   d-Crear archivo texto a partir de un archivo binario   otra tecla-salir');
        readln(eleccion);
        case eleccion of
            'a': crearArchivo(archivo);
            'b': listarSinStock(archivo);
            'c': listarPorDescripcion(archivo);
            'd': exportarAtxt(archivo);
        end;
    end;

    writeln('Gracias, vuelva prontos!');
END.