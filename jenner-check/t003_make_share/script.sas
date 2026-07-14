
/* Sample stand-in for WORK.IMPORT.
   The upstream script builds WORK.IMPORT via PROC IMPORT from a local
   SAS Studio path (Electric_Vehicle_Population_Data.csv). We seed a small,
   representative sample here with the same spaced column names so the
   author's PROC SQL runs verbatim. Real WA EV column headers preserved so
   the name literals ("Model Year"n, "County"n, ...) resolve identically. */
data WORK.IMPORT;
    infile datalines dsd truncover;
    length "County"n "City"n "Make"n $20
           "Electric Vehicle Type"n $40
           "Clean Alternative Fuel Vehicle ("n $60;
    input "County"n "City"n "Model Year"n "Make"n
          "Electric Vehicle Type"n "Clean Alternative Fuel Vehicle ("n "Electric Range"n;
    datalines;
King,Seattle,2018,TESLA,Battery Electric Vehicle (BEV),Clean Alternative Fuel Vehicle Eligible,215
King,Bellevue,2021,TESLA,Battery Electric Vehicle (BEV),Eligibility unknown as battery range has not been researched,0
King,Seattle,2013,NISSAN,Battery Electric Vehicle (BEV),Clean Alternative Fuel Vehicle Eligible,75
Snohomish,Everett,2018,BMW,Battery Electric Vehicle (BEV),Clean Alternative Fuel Vehicle Eligible,97
King,Redmond,2020,CHEVROLET,Battery Electric Vehicle (BEV),Clean Alternative Fuel Vehicle Eligible,259
King,Kirkland,2017,TESLA,Battery Electric Vehicle (BEV),Clean Alternative Fuel Vehicle Eligible,210
Pierce,Tacoma,2020,KIA,Plug-in Hybrid Electric Vehicle (PHEV),Clean Alternative Fuel Vehicle Eligible,26
Clark,Vancouver,2022,TOYOTA,Plug-in Hybrid Electric Vehicle (PHEV),Clean Alternative Fuel Vehicle Eligible,42
Clark,Vancouver,2014,FORD,Plug-in Hybrid Electric Vehicle (PHEV),Not eligible due to low battery range,19
Thurston,Olympia,2019,TESLA,Battery Electric Vehicle (BEV),Clean Alternative Fuel Vehicle Eligible,220
Snohomish,Lynnwood,2019,NISSAN,Battery Electric Vehicle (BEV),Clean Alternative Fuel Vehicle Eligible,150
King,Seattle,2016,TESLA,Battery Electric Vehicle (BEV),Clean Alternative Fuel Vehicle Eligible,200
King,Bellevue,2019,VOLKSWAGEN,Battery Electric Vehicle (BEV),Clean Alternative Fuel Vehicle Eligible,125
Pierce,Puyallup,2017,FORD,Plug-in Hybrid Electric Vehicle (PHEV),Not eligible due to low battery range,21
King,Seattle,2019,TESLA,Battery Electric Vehicle (BEV),Clean Alternative Fuel Vehicle Eligible,220
Snohomish,Everett,2013,CHEVROLET,Plug-in Hybrid Electric Vehicle (PHEV),Clean Alternative Fuel Vehicle Eligible,38
Clark,Camas,2017,KIA,Battery Electric Vehicle (BEV),Clean Alternative Fuel Vehicle Eligible,93
King,Sammamish,2020,TESLA,Battery Electric Vehicle (BEV),Eligibility unknown as battery range has not been researched,0
Pierce,Tacoma,2022,FORD,Battery Electric Vehicle (BEV),Eligibility unknown as battery range has not been researched,0
Thurston,Lacey,2012,NISSAN,Battery Electric Vehicle (BEV),Clean Alternative Fuel Vehicle Eligible,73
King,Seattle,2020,TESLA,Battery Electric Vehicle (BEV),Clean Alternative Fuel Vehicle Eligible,373
Snohomish,Marysville,2022,JEEP,Plug-in Hybrid Electric Vehicle (PHEV),Not eligible due to low battery range,21
King,Renton,2021,AUDI,Battery Electric Vehicle (BEV),Eligibility unknown as battery range has not been researched,0
Clark,Vancouver,2020,TESLA,Battery Electric Vehicle (BEV),Clean Alternative Fuel Vehicle Eligible,322
Pierce,Lakewood,2019,CHEVROLET,Battery Electric Vehicle (BEV),Clean Alternative Fuel Vehicle Eligible,238
King,Seattle,2022,BMW,Plug-in Hybrid Electric Vehicle (PHEV),Not eligible due to low battery range,30
Snohomish,Bothell,2022,TESLA,Battery Electric Vehicle (BEV),Eligibility unknown as battery range has not been researched,0
King,Federal Way,2021,HONDA,Plug-in Hybrid Electric Vehicle (PHEV),Clean Alternative Fuel Vehicle Eligible,47
Thurston,Tumwater,2020,TESLA,Battery Electric Vehicle (BEV),Clean Alternative Fuel Vehicle Eligible,266
Kittitas,Ellensburg,2018,NISSAN,Battery Electric Vehicle (BEV),Clean Alternative Fuel Vehicle Eligible,151
;
run;


/* Q3, PART 1: manufacturers hold the largest share of registered electric vehicles */

PROC SQL;
    CREATE TABLE WORK.make_counts AS
    SELECT
        "Make"n AS make,
        COUNT(*) AS ev_count
    FROM WORK.IMPORT
    GROUP BY "Make"n
    ORDER BY ev_count DESC;
QUIT;

PROC SQL;
    CREATE TABLE WORK.make_share AS
    SELECT
        a.make,
        a.ev_count,
        (a.ev_count / b.total)*100 AS share_pct FORMAT=6.2
    FROM WORK.make_counts a,
         (SELECT COUNT(*) AS total FROM WORK.IMPORT) b
    ORDER BY share_pct DESC;
QUIT;

PROC PRINT DATA=WORK.make_share (OBS=20);
RUN;
