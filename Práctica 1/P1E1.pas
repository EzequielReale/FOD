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
    rewrite(archivo);

    write('Ingrese un numero: ');
    readln(num);
    while (num <> 30000) do begin
        write(archivo, num);
        write('Ingrese un numero: ');
        readln(num);
    end;

    close(archivo);
end.