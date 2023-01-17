<!--- Bu dosyanın gercek hali objects/query klasoru altindadir. BK 20070418 --->
<cfsetting showdebugoutput="no">
<cfscript>
	file_name = "GNDREY.GTF";
	CRLF=chr(13)&chr(10);
	
	file_content = ArrayNew(1);
	index_array = 1;
</cfscript>


<cfquery name="get_all_reyons" datasource="#dsn3#">
	SELECT
		HIERARCHY,
		PRODUCT_CAT
	FROM
		PRODUCT_CAT
	ORDER BY
		HIERARCHY
</cfquery>


<cfquery name="get_reyons" datasource="#dsn3#">
	SELECT
		HIERARCHY,
		PRODUCT_CAT
	FROM
		PRODUCT_CAT
	WHERE
        HIERARCHY NOT LIKE '%.%'
        <cfif attributes.is_all eq 0>
        AND
        (
        RECORD_DATE BETWEEN #attributes.product_startdate# AND #dateadd('d',1,attributes.product_finishdate)#
        OR
        UPDATE_DATE BETWEEN #attributes.product_startdate# AND #dateadd('d',1,attributes.product_finishdate)#
        )
        </cfif>
	ORDER BY
		HIERARCHY
</cfquery>

<cfloop query="get_reyons">
	<cfquery name="get_p_cat" dbtype="query">
    	SELECT PRODUCT_CAT FROM get_all_reyons WHERE HIERARCHY = '#Listfirst(hierarchy, ".")#'
    </cfquery>
	<cfscript>
	satir1 = "01 " & repeatString(" ",59);	
	satir1 = yerles(satir1, 0, 5, 1, " ");										// şimdilik yeni kayıt olarak export ediyoruz
	satir1 = yerles(satir1, ListLast(hierarchy, "."), 6, 8, " ");				// bölüm kodu
	satir1 = yerles(satir1, ListLast(hierarchy, "."), 14, 8, " ");				// bölüm eski kodu
	satir1 = yerles(satir1, 0, 22, 1, " ");										// kullanılıyor
	satir1 = yerles(satir1, Left(get_p_cat.product_cat, 20), 23, 20, " ");		// açıklama
	satir1 = yerles(satir1, 0, 43, 1, " ");										// indirim yok
	satir1 = yerles(satir1, " ", 44, 8, " ");									// indirim grubu
	satir1 = yerles(satir1, 0, 52, 6, " ");										// bagli kdv grubu
	file_content[index_array] = satir1;
	index_array = index_array+1;
	</cfscript>
</cfloop>

<cfif get_reyons.recordcount>
    <cffile action="write" nameconflict="overwrite" output="<SIGNATURE=GNDRYN.GDF><VERSION=22000>" addnewline="yes" file="#upload_folder##file_name#" charset="ISO-8859-9">
    <cffile action="append" output="#ArraytoList(file_content,CRLF)#" file="#upload_folder##file_name#" charset="ISO-8859-9">
</cfif>