function ephemeris = ephemeris()
    fclose('all');
    gpsfile = fileread('ephem.txt');
    gpsfile = strrep(gpsfile,'D','E');
    fclose('all');
    fileID = fopen('ephem.txt','w+');
    fprintf(fileID,gpsfile);
    fclose('all');
    fileID = fopen('ephem.txt','r');
    gps_data_raw = fscanf(fileID,'%E',Inf);
    gps_data = zeros(8,10,5);
    i = 1;
	for l = 0:1:4
        for n = 1:1:8
            if rem((l*8)+n-1,8) == 0
                for m = 1:1:10
                    gps_data(n,m,(l+1)) = gps_data_raw(i);
                    i = i+1;
                end
            elseif rem((l*8)+n-1,8) ~= 0
                for m = 1:1:4
                    if i <= length(gps_data_raw)
                        gps_data(n,m,(l+1)) = gps_data_raw(i);
                        i = i+1;
                    end
                end
            end
        end
    end
    solutions = zeros(5,4);
    for i = 1:1:5
        a =(gps_data(3,4,i))^2;
        e = gps_data(3,2,i);
        Io = gps_data(5,1,i);
        Ip = gps_data(6,1,i);
        Oo = gps_data(4,3,i);
        Op = gps_data(5,4,i);
        wo = gps_data(5,3,i);
        Mo = gps_data(2,4,i);
        toe = gps_data(4,1,i);
        Crs = gps_data(2,2,i);
        Crc = gps_data(5,2,i);
        Cis = gps_data(4,4,i);
        Cic = gps_data(4,2,i);
        Cws = gps_data(3,3,i);
        Cwc = gps_data(3,1,i);
        tdata = toe + (5*60*60);
        t = tdata - toe;
        Eo  = Mo;
        Eos = Eo - (Eo-e*sin(Eo)- Mo)/(1 - e*cos(Eo));
        while ( abs(Eos-Eo) > eps )
            Eo = Eos;
            Eos = Eo - (Eo - e*sin(Eo) - Mo)/(1 - e*cos(Eo));
        end
        E = Eos;
        v = atan(((sqrt(1-(e^2)))*sin(E))/cos(E)-e);
        Rscalar = a*(1-e*cos(E))+Crc*cos(2*(wo+v))+Crs*sin(2*(wo+v));
        I = Io+Ip*t++Cic*cos(2*(wo+v))+Cis*sin(2*(wo+v));
        w = wo+Cwc*cos(2*(wo+v))+Cws*sin(2*(wo+v));
        we = 7.2921151467*10^(-5);
        O = Oo+(Op-we)*t-(we*toe);
        Rperifocal=[Rscalar*cos(v); Rscalar*sin(v);0;];
        T = [(cos(O)*cos(w) - sin(O)*sin(w)*cos(I)), (-1*cos(O)*sin(w) - sin(O)*cos(w)*cos(I)), (sin(O)*sin(I)); 
        (sin(O)*cos(w) + cos(O)*sin(w)*cos(I)), (-1*sin(O)*sin(w) + cos(O)*cos(w)*cos(I)), (-1*cos(O)*sin(I));
        (sin(w)*sin(I)), (cos(w)*sin(I)), cos(I)];
        solutions(i,1) = gps_data(1,1,i);
        solutions(i,2:end) = transpose(T * Rperifocal) / 1000;
    end
    fprintf('\n\tGPS Satellite Coordinates (Geocentric-Equatorial Coordinate System)\n\n');
    fprintf('PRN #\t\t\tx coord (km)\t\t\ty coord (km)\t\t\tz coord (km)\n-----\t\t\t------------\t\t\t------------\t\t\t------------\n');
    for n = 1:1:5
        fprintf('%g\t\t\t\t%f8\t\t\t%f8\t\t\t%f8\t\t\t\n',solutions(n,1),solutions(n,2),solutions(n,3),solutions(n,4));
    end
    fprintf('\n');
    return