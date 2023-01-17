<!--- Burda icin olusan hali Kategoride ikinci kirilimlar geliyor.
Bu dosyanın gercek hali objects/query klasoru altindadir. BK 20070724--->
<cfsetting showdebugoutput="no">
<cfscript>
	upload_folder = "#upload_folder#store#dir_seperator#";
	file_name = "#CreateUUID()#.GTF";
	CRLF = chr(13)&chr(10);

	file_content = ArrayNew(1);
	index_array = 1;
</cfscript>

<cfquery name="GET_REYONS" datasource="#DSN3#">
	SELECT
		HIERARCHY,
		PRODUCT_CAT
	FROM
		PRODUCT_CAT
	WHERE
		HIERARCHY NOT LIKE '%.%.%' AND
		HIERARCHY LIKE '%.%'
	ORDER BY
		HIERARCHY
</cfquery>
<cfif get_reyons.recordcount>
	<cfloop query="get_reyons">
		<cfscript>
			satir1 = "01  1" & repeatString(" ",59);
			reyon1 = ListFirst(hierarchy,".");
			reyon2 = ListLast(hierarchy,".");
			satir1 = yerles(satir1, left(reyon1&reyon2,8), 6, 8, " ");					// bölüm kodu
			satir1 = yerles(satir1, left(reyon1&reyon2,8), 14, 8, " ");					// bölüm eski kodu
			satir1 = yerles(satir1, 0, 22, 1, " ");										// kullanılıyor
			satir1 = yerles(satir1, UCASE(Left(product_cat, 20)), 23, 20, " ");			// açıklama
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
	<SIGNATURE=GNDRYN.GDF><VERSION=0226004>
	#ArraytoList(file_content,CRLF)#
	</cfoutput>
</cfif>

