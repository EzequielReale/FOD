program P1E2;

type
    archivo_int = file of integer;
    str12 = String[12];

var
    archivo: archivo_int;
    nombre_arch: str12;
    num, cant_tot, cant1500: integer;
    prom: real;

begin
    cant_tot:= 0; cant1500:= 0; prom:= 0;

    write('Ingrese el nombre del archivo: ');
    readln(nombre_arch);

    assign(archivo, nombre_arch);
    reset(archivo);

    write('Contenido del archivo: ');

    while (not EOF(archivo)) do begin
        read(archivo, num);
        
        
        write(num,' - ');

        if (num > 1500) then
            cant1500:= cant1500 + 1;

        cant_tot:= cant_tot + 1;
        prom:= prom + num;
    end;

    writeln();
    writeln('Cantidad de numeros mayores a 1500: ',cant1500);
    writeln('Promedio de numeros: ',prom/cant_tot:1:2);

    close(archivo);
end.