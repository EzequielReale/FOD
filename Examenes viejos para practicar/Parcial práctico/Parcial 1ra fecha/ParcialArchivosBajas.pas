program parcial;

const
        valorAlto=9999;
Type
    tJugador = Record
        dni: longInt;
        nombre: String;
        apellido: String;
        pais nacimiento: String;
    end;
    tArchivo = File of tJugador;

Procedure leer(var arch: tArchivo; jugador: tJugador);
BEGIN
    if not(EOF(arch)) then read(arch, jugador);
    else jugador.dni:= valorAlto;
END;

Procedure agregarJugador (var arch: tArchivo; jugador: tJugador);
var
    cabecera: tJugador;
BEGIN
    reset(arch);

    read(arch, cabecera);
    if (cabecera.dni < 0) then begin
        seek(arch, cabecera.dni * -1);
        read(arch, cabecera);
        seek(arch, filePos(arch) - 1);
        write(arch, jugador);
        seek(arch, 0);
        write(arch, cabecera);
    end;
    else begin
        seek(arch, fileSize(arch));
        write(arch, jugador);
    end;

    close(arch);
END;

Procedure eliminarJugador(var arch: tArchivo; dniJugador: longInt);
var
    jugador, cabecera: tJugador;
BEGIN
    reset(arch);

    read(arch, cabecera);
    leer(arch, jugador);
    while ((jugador.dni <> valorAlto) and (jugador.dni <> dniJugador)) do leer(arch, jugador);

    if(jugador.dni = dniJugador) then begin
        seek(arch, filePos(arch) - 1);
        jugador.dni:= (filePos(arch) * (-1));
        write(arch, cabecera); 
        seek(arch, 0);
        write(arch, jugador);
    end;
    else writeln('Jugador inexistente');

    close(arch);
END;