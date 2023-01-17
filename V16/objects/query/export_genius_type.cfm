<!--- COMPANYCAT_ID degerinin where kosulunda 1 olmasinin nedeni ERSAN da Uye Kategorisi 1 olan firmalar Urun Tedarikcileri --->
<cfsetting showdebugoutput="no">
<cfscript>
	upload_folder = "#upload_folder#store#dir_seperator#";
	file_name = "#CreateUUID()#.GTF";
	CRLF=chr(13)&chr(10);
	file_content = ArrayNew(1);
	index_array = 1;
</cfscript>
<cfquery name="GET_COMPANY" datasource="#DSN#">
	SELECT 
		COMPANY_ID,
		FULLNAME
	FROM 
		COMPANY
	WHERE		
		COMPANYCAT_ID=1
	ORDER BY
		COMPANY_ID
</cfquery>
<cfloop query="get_company">
	<cfscript>
		satir1 = "01  1" & repeatString(" ",36);
		satir1 = yerles(satir1, company_id, 6, 8, " ");									// bölüm kodu
		satir1 = yerles(satir1, company_id, 14, 8, " ");								// bölüm eski kodu
		satir1 = yerles(satir1, UCASE(Left(fullname, 20)), 22, 20, " ");				// açıklama
		file_content[index_array] = satir1;
		index_array = index_array+1;
	</cfscript>
</cfloop>
<cfheader name="Expires" value="#Now()#">
<cfcontent type="text/vnd.plain;charset=ISO-8859-9">
<cfheader name="Content-Disposition" value="attachment; filename=#file_name#"> 
<cfoutput><SIGNATURE=GNDPLUTYP.GDF><VERSION=0226004>
#ArraytoList(file_content,CRLF)#</cfoutput>
