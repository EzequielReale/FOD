program P1E1;

type
    archivo_int = file of integer;
    str12 = String[12];

var
    archivo: archivo_int;
    nombre_arch: str12;
    num: integer;

begin
    write('Ingrese el nombre del archivo: ');
    readln(nombre_arch);

    assign(archivo, nombre_arch);
    reset(archivo);

    while (not EOF(archivo)) do begin
        read(archivo, num);
        writeln(num);
    end;

    close(archivo);
end.