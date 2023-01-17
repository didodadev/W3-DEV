<cfprocessingdirective suppresswhitespace="yes">
<cfsetting enablecfoutputonly="yes">
<cf_date tarih="attributes.startdate">
<cf_date tarih="attributes.finishdate">
<cfscript>
start_time = now();

CRLF = Chr(13) & Chr(10); // satır atlama karakteri

</cfscript>

<cfquery name="get_invoice_row_pos" datasource="#dsn2#">
	SELECT
		P.PRODUCT_NAME,
		INVOICE_ROW_POS.BARCODE,
		INVOICE_ROW_POS.UNIT,
	<cfif database_type is "MSSQL">
		ROUND(SUM(INVOICE_ROW_POS.AMOUNT)*100,2)/100 AS TOPLAM_MIKTAR,
	<cfelseif database_type is "DB2">
		SUM(INVOICE_ROW_POS.AMOUNT) AS TOPLAM_MIKTAR,
	</cfif>
		SUM(INVOICE_ROW_POS.GROSSTOTAL) AS TOPLAM_TUTAR
	FROM
		INVOICE,
		INVOICE_ROW_POS,
		#dsn_alias#.DEPARTMENT,
		#dsn3_alias#.PRODUCT P
	WHERE
		INVOICE.DEPARTMENT_ID = #dsn_alias#.DEPARTMENT.DEPARTMENT_ID
		AND INVOICE.INVOICE_ID = INVOICE_ROW_POS.INVOICE_ID
		AND INVOICE_ROW_POS.PRODUCT_ID = P.PRODUCT_ID
		AND #dsn_alias#.DEPARTMENT.BRANCH_ID = #attributes.branch_index#
		AND INVOICE.INVOICE_CAT = 67
		AND INVOICE.INVOICE_DATE >= #attributes.startdate#
		AND INVOICE.INVOICE_DATE <= #attributes.finishdate#
	<cfif len(attributes.product_cat) and len(attributes.product_catid) and len(attributes.hierarchy_code)>
		AND P.PRODUCT_CODE LIKE '#attributes.hierarchy_code#.%'
	</cfif>
	<cfif isdefined("attributes.is_terazi")>
		AND (P.IS_TERAZI = 0 OR P.IS_TERAZI IS NULL)
	</cfif>
	GROUP BY
		INVOICE_ROW_POS.BARCODE, INVOICE_ROW_POS.UNIT, P.PRODUCT_NAME
</cfquery>
<cfif get_invoice_row_pos.recordcount>
	<cfset folder_name = "#upload_folder#report#dir_seperator#acnielsen#dir_seperator##dateformat(attributes.startdate,'ddmmyyyy')#_#dateformat(attributes.finishdate,'ddmmyyyy')#">
	<cfif not DirectoryExists(folder_name)>
		<cfdirectory action="create" directory="#folder_name#" mode="777">
	</cfif>
	<cfquery name="get_gun_say" datasource="#dsn2#">
		SELECT 
			COUNT(INVOICE.INVOICE_DATE) TOPLAM_GUN
		FROM
			INVOICE, #dsn_alias#.DEPARTMENT
		WHERE
			INVOICE.DEPARTMENT_ID = #dsn_alias#.DEPARTMENT.DEPARTMENT_ID
			AND #dsn_alias#.DEPARTMENT.BRANCH_ID = #attributes.branch_index#
			AND INVOICE.INVOICE_CAT = 67
			AND INVOICE.INVOICE_DATE >= #attributes.startdate#
			AND INVOICE.INVOICE_DATE <= #attributes.finishdate#
	</cfquery>
	<cfscript>
		dosya_adi = "#attributes.acnielsen_code#_#dateformat(attributes.startdate,'ddmmyyyy')#_#dateformat(attributes.finishdate,'ddmmyyyy')#.wrk";
		file_content = ArrayNew(1);
		satir1 = "1#dateformat(attributes.startdate,'ddmmyyyy')##dateformat(attributes.finishdate,'ddmmyyyy')#" & repeatString(" ",59);
		satir1 = yerles(satir1,attributes.acnielsen_code,18,15," ");
		satir1 = yerles(satir1, Left(attributes.branch_name,40),33,40," ");
		satir1 = yerles_saga(satir1, get_gun_say.toplam_gun,73,3," ");
		ArrayAppend(file_content, satir1);
	</cfscript>
	<cffile action="write" output="" addnewline="no" file="#folder_name##dir_seperator##dosya_adi#" charset="ISO-8859-9">
	<cfloop query="get_invoice_row_pos">
		<cftry> 
		<cfscript>
			satir2="2" & repeatString(" ",123);
			satir2=yerles(satir2,BARCODE,2,15," ");							// barkod {sola dayalı}
			satir2=yerles(satir2,Left(PRODUCT_NAME,50),17,50," ");			// ürün adı
			satir2=yerles(satir2,iif(unit is 'Kg',1,0),67,1," ");			// birim {adet : 0, KG : 1} {Kg olmayanlar 0 olabilirmiş}
			if ((len(TOPLAM_MIKTAR) gt 7) or (TOPLAM_MIKTAR lt 0))
				satir2=yerles_saga(satir2,0,68,9," ");						// satış miktarı {noktasız, iki ondalıklı}
			else
				satir2=yerles_saga(satir2, TOPLAM_MIKTAR * 100,68,9," ");	// satış miktarı {noktasız, iki ondalıklı}
			if ((len(TOPLAM_TUTAR) gt 13) or (TOPLAM_TUTAR lt 0))
				satir2=yerles_saga(satir2,0,77,14," ");						// satış tutarı {kdv dahil}
			else
				satir2=yerles_saga(satir2, TOPLAM_TUTAR,77,14," ");			// satış tutarı {kdv dahil}
			ArrayAppend(file_content, satir2); 
		</cfscript>
		<cfcatch type="any">
			<cfoutput>
			<br/>Satış Belgesi Hatası : BARCODE:#BARCODE#_satir:#currentrow#_birim:#UNIT#<hr>
			</cfoutput>
			<cfabort>
		</cfcatch>
		</cftry>  
		<cfif (get_invoice_row_pos.currentrow mod 1000) eq 0><!--- 20041210 performans icin --->
			<!--- daha once yukarida eklenmis dosyanin icerigi doluyor --->
			<cffile action="append" output="#ArraytoList(file_content,CRLF)#" file="#folder_name##dir_seperator##dosya_adi#" charset="ISO-8859-9">
			<cfset file_content = ArrayNew(1)>
		</cfif>
	</cfloop>
	<cfif (get_invoice_row_pos.recordcount mod 1000) eq 0>
		<cfset yeni_satir = 0>
	<cfelse>
		<cfset yeni_satir = 1>
	</cfif>
	<cffile action="append" output="#ArraytoList(file_content,CRLF)#" addnewline="#yeni_satir#" file="#folder_name##dir_seperator##dosya_adi#" charset="ISO-8859-9">
	<cfquery name="add_report" datasource="#dsn3#">
		INSERT INTO ACNIELSEN_REPORTS ( STARTDATE, FINISHDATE, TOTAL_DAYS, BRANCH_ID, ACN_CODE, RECORD_EMP, RECORD_DATE, RECORD_IP ) VALUES ( #attributes.startdate#, #attributes.finishdate#, #get_gun_say.toplam_gun#, #attributes.branch_index#, '#attributes.acnielsen_code#', #session.ep.userid#, #now()#, '#CGI.REMOTE_ADDR#' )
	</cfquery>
</cfif>

<cfsetting enablecfoutputonly="no"></cfprocessingdirective>
<script type="text/javascript">
	<cfif get_invoice_row_pos.recordcount>
		alert("<cf_get_lang no ='148.Raporlar Oluşturuldu'>!");
	<cfelse>
		alert("<cf_get_lang no ='149.Girdiğiniz Koşullara Uygun Kayıt Bulunamadı'>!");
	</cfif>
	wrk_opener_reload();
	window.close();
</script>
