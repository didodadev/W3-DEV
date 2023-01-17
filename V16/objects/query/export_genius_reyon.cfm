<!--- Bu dosyanın gercek hali objects/query klasoru altindadir. BK 20070418 --->
<cfsetting showdebugoutput="no">
<cfscript>
	upload_folder = "#upload_folder#store#dir_seperator#";
	file_name = "#CreateUUID()#.GTF";
	CRLF=chr(13)&chr(10);
	
	file_content = ArrayNew(1);
	index_array = 1;
</cfscript>

<cfquery name="get_reyons" datasource="#dsn3#">
	SELECT
		HIERARCHY,
		PRODUCT_CAT
	FROM
		PRODUCT_CAT
	WHERE
		HIERARCHY LIKE '%.%.%' AND
		HIERARCHY NOT LIKE '%.%.%.%'
	ORDER BY
		HIERARCHY
</cfquery>

<cfloop query="get_reyons">
	<cfscript>
	satir1 = "01 " & repeatString(" ",59);	
	satir1 = yerles(satir1, 0, 5, 1, " ");										// şimdilik yeni kayıt olarak export ediyoruz
	satir1 = yerles(satir1, ListLast(hierarchy, "."), 6, 8, " ");				// bölüm kodu
	satir1 = yerles(satir1, ListLast(hierarchy, "."), 14, 8, " ");				// bölüm eski kodu
	satir1 = yerles(satir1, 0, 22, 1, " ");										// kullanılıyor
	satir1 = yerles(satir1, Left(product_cat, 20), 23, 20, " ");				// açıklama
	satir1 = yerles(satir1, 0, 43, 1, " ");										// indirim yok
	satir1 = yerles(satir1, " ", 44, 8, " ");									// indirim grubu
	satir1 = yerles(satir1, 0, 52, 6, " ");										// bagli kdv grubu
	file_content[index_array] = satir1;
	index_array = index_array+1;
	</cfscript>
</cfloop>

<cfheader name="Expires" value="#Now()#">
<cfcontent type="text/vnd.plain;charset=ISO-8859-9">
<cfheader name="Content-Disposition" value="attachment; filename=#file_name#"> 
<cfoutput>
<SIGNATURE=GNDRYN.GDF><VERSION=22000>
#ArraytoList(file_content,CRLF)#
</cfoutput>
