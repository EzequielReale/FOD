program E2P2;

const
    VALOR_ALTO = 9999;
type
    str20 = string[20];

    alumno = record
        cod, conFinal, sinFinal: integer;
        nombre, apellido: str20;
    end;
    materia = record
        cod: integer;
        nombre: str20;
        nota: char;
    end;

    archivo_al = file of alumno;
    archivo_mat = file of materia;


procedure crearArchivoMaestro(var archivo:archivo_al);
var
	carga: text;
	a: alumno;
BEGIN
	assign(archivo,'maestro');
	assign(carga, 'alumnos.txt');
	rewrite(archivo);
	reset(carga);

	while(not  EOF(carga)) do 
    begin
		readln(carga, a.cod);
        readln(carga, a.apellido);
        readln(carga, a.nombre);
        readln(carga, a.conFinal);
        ReadLn(carga, a.sinFinal);
		write(archivo, a);
	end;
	writeln('Archivo cargado.');

	close(archivo); 
    close(carga);
END;

procedure crearArchivoDetalle(var archivo:archivo_mat);
var
	carga: text;
	m: materia;
BEGIN
	assign(archivo,'detalle');
	assign(carga, 'detalle.txt');
	rewrite(archivo);
	reset(carga);

	while(not  EOF(carga)) do 
    begin
		readln(carga, m.cod);
        readln(carga, m.nombre);
        readln(carga, m.nota);
		write(archivo, m);
	end;
	writeln('Archivo cargado.');

	close(archivo); 
    close(carga);
END;

procedure exportarMaestro(var carga:archivo_al);
var
    archivo: text;
    a: alumno;
BEGIN
	assign(archivo,'reporteAlumnos.txt');
	assign(carga, 'maestro');
	rewrite(archivo);
	reset(carga);

	while(not  EOF(carga)) do 
    begin
		read(carga, a);
		writeln(archivo, a.cod);
        writeln(archivo, a.apellido);
        writeln(archivo, a.nombre);
        writeln(archivo, a.conFinal);
        writeln(archivo, a.sinFinal);
	end;
	writeln('Archivo exportado.');

	close(archivo); 
    close(carga);
END;

procedure exportarDetalle(var carga:archivo_mat);
var
    archivo: text;
    m: materia;
BEGIN
	assign(archivo,'reporteDetalle.txt');
	assign(carga, 'detalle');
	rewrite(archivo);
	reset(carga);

	while(not  EOF(carga)) do 
    begin
		read(carga, m);
		writeln(archivo, m.cod);
        writeln(archivo, m.nombre);
        writeln(archivo, m.nota);
	end;
	writeln('Archivo exportado.');

	close(archivo); 
    close(carga);
END;


procedure compactar(var alumnos:archivo_al; var materias:archivo_mat);
    
    procedure leer(var archivo:archivo_mat; var m:materia);
    BEGIN
        if not(EOF(archivo)) then
            read(archivo, m)
        else
            m.cod:= VALOR_ALTO;
    END;

var
    a: alumno;
    m: materia;
BEGIN
    assign(alumnos, 'maestro'); assign(materias, 'detalle');
    reset(alumnos); reset(materias);
    
    leer(materias, m);
    while (m.cod <> VALOR_ALTO) do begin    
        read(alumnos, a);
        while (m.cod = a.cod) do begin
            if (m.nota = 'A') then
                a.conFinal:= a.conFinal + 1
            else if (m.nota = 'D') then
                a.sinFinal:= a.sinFinal + 1
            else
                writeln('Nota mal escrita en la materia ',m.nombre,' para el alumno con codigo ',m.cod);
            
            leer(materias, m);
        end;
        seek(alumnos, filePos(alumnos)-1);
        write(alumnos, a);

    end;

    close(alumnos); close(materias);
END;


var
    maestro: archivo_al;
    detalle: archivo_mat;
BEGIN
    crearArchivoMaestro(maestro);
    crearArchivoDetalle(detalle);
    compactar(maestro, detalle);
    exportarMaestro(maestro);
    exportarDetalle(detalle);
END.