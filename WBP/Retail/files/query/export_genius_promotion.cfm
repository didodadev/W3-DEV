<!--- Genuis Export  --->
Promosyon Belgesi Oluşturma İşlemi Başladı, Lütfen Bekleyiniz...<br/>
<cfsetting showdebugoutput="no">
<cfquery name="get_dept" datasource="#dsn#" maxrows="1">
	SELECT
		DEPARTMENT.DEPARTMENT_ID,
		SETUP_BRANCH_PRICE_CHANGE_NO.SON_BELGE_NO
	FROM
		DEPARTMENT,
		SETUP_BRANCH_PRICE_CHANGE_NO
	WHERE
		DEPARTMENT.BRANCH_ID = #attributes.branch_id# AND 
		SETUP_BRANCH_PRICE_CHANGE_NO.BRANCH_ID = DEPARTMENT.BRANCH_ID
</cfquery>
<cfif not get_dept.recordcount>
	<script type="text/javascript">
		alert("Seçtiğiniz Şubeye kayıtlı depo yok !");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfset attributes.belge_no = get_dept.son_belge_no>

<cfif isdefined("attributes.recorddate") and len(attributes.recorddate)>
	<cf_date tarih="attributes.recorddate">
	<cfset attributes.recorddate = date_add('h', attributes.record_hour, attributes.recorddate)>
	<cfset attributes.recorddate = date_add('n', attributes.record_min, attributes.recorddate)>
</cfif>

<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
	<cf_date tarih="attributes.startdate">
	<cfset attributes.startdate = date_add('h', attributes.start_hour, attributes.startdate)>
	<cfset attributes.startdate = date_add('n', attributes.start_min, attributes.startdate)>
</cfif>
<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
	<cfset attributes.finishdate = date_add('h', attributes.finish_hour, attributes.finishdate)>
	<cfset attributes.finishdate = date_add('n', attributes.finish_min, attributes.finishdate)>
</cfif>

<cfscript>
	upload_folder = "#upload_folder#store#dir_seperator#";
	file_name = "#CreateUUID()#.GTF";
	// satır atlama karakteri
	CRLF = Chr(13) & Chr(10);
	dosya = ArrayNew(1);
	barcodes = ArrayNew(1);
</cfscript>

<!--- Ürünler Alınır --->
<cfquery name="get_products" datasource="#dsn3#">
	SELECT DISTINCT
		S.PRODUCT_ID,
		S.STOCK_ID,
		S.BARCOD,
		ST.TAX_ID,
		ST.TAX,
		PR.PRICE,
		PR.PRICE_KDV,
		PR.IS_KDV,
		PR.STARTDATE,
		PR.FINISHDATE
	FROM
		STOCKS S, 
		PRODUCT_UNIT PU,
		#dsn2_alias#.SETUP_TAX ST,
		PRICE_CAT PC, 
		PRICE PR
	WHERE  
		S.IS_INVENTORY = 1 
		AND S.PRODUCT_STATUS = 1 
		AND PC.PRICE_CAT_STATUS = 1 
		AND PR.PRICE > 0 
		AND S.PRODUCT_ID = PU.PRODUCT_ID 
		AND S.PRODUCT_ID = PR.PRODUCT_ID 
		AND ISNULL(PR.STOCK_ID,0)=0
		AND ISNULL(PR.SPECT_VAR_ID,0)=0
		AND PR.PRICE_CATID = PC.PRICE_CATID 
		AND PR.UNIT = PU.PRODUCT_UNIT_ID 
		AND ST.TAX = S.TAX 
		AND PC.PRICE_CATID = #attributes.price_catid#
		AND PC.BRANCH LIKE '%,#attributes.branch_id#,%'
		<cfif isdefined("attributes.startdate") and len(attributes.startdate) and isdefined("attributes.finishdate") and len(attributes.finishdate)>
			AND
			(
				(
				PR.STARTDATE <= #attributes.finishdate# AND 
				PR.FINISHDATE >= #attributes.startdate#
				)
				OR
				(
				PR.STARTDATE <= #attributes.finishdate# AND 
				PR.FINISHDATE IS NULL
				)
			)
		<cfelseif isdefined("attributes.startdate") and len(attributes.startdate)>
			<cfset finishdate = date_add("d",1,attributes.startdate)>
			AND PR.STARTDATE BETWEEN #attributes.startdate# AND #finishdate#
		</cfif>
	
	<cfif isdefined("attributes.recorddate") and len(attributes.recorddate)>
		AND PR.RECORD_DATE >= #attributes.recorddate#
	</cfif>	
	ORDER BY 
		S.PRODUCT_ID,
		S.STOCK_ID		
</cfquery>
<br/>
<strong>Ürün Sayısı : <cfoutput>#get_products.recordcount#</cfoutput> <br/></strong>

<cfquery name="get_genius_promotion" datasource="#dsn3#">
	SELECT * FROM PROMOTIONS WHERE PRICE_CATID = #ATTRIBUTES.price_catid# AND STARTDATE >= #ATTRIBUTES.STARTDATE# AND FINISHDATE <= #ATTRIBUTES.FINISHDATE#
</cfquery>

<strong>Promosyon Sayısı : <cfoutput>#get_genius_promotion.recordcount#</cfoutput><br/></strong>

<cffile action="write" output="SIGNATURE=GNDPROMOTION.GDF" addnewline="yes" file="#UPLOAD_FOLDER##file_name#">
<cfset anlik_satir = 0>
<cfoutput query="get_genius_promotion">
	<cfset anlik_satir = anlik_satir + 1>
	<cfloop query="get_products">
		<cftry>
			<cfscript>		
			///////////////////////////////////////////   1. SATIR   ////////////////////////////////////////
			satir1 = "01 " & repeatString(" ", 500);										// satir no 
			satir1 = yerles(satir1, "0", 3, 1, " ");										//işlem türü
			satir1 = yerles(satir1, "#left('#PRODUCT_ID#.#STOCK_ID#',24)#", 4, 24, " ");					//ürün kodu
			satir1 = yerles(satir1, "2", 28, 12, " ");										//promosyon tipi (standart şu an için 2- buda iki kesin tarih arası demektir...)			
			satir1 = yerles(satir1, "0", 40, 1, " ");
			satir1 = yerles(satir1, "#dateformat(get_genius_promotion.startdate,'yyyymmdd')##timeformat(get_genius_promotion.startdate,'HHMM')#00", 41, 14, " ");
			satir1 = yerles(satir1, "#dateformat(get_genius_promotion.finishdate,'yyyymmdd')##timeformat(get_genius_promotion.finishdate,'HHMM')#00", 55, 14, " ");
			satir1 = yerles(satir1, "", 69, 3, "0");
			satir1 = yerles(satir1, "", 72, 2, "0");
			satir1 = yerles(satir1, "#get_genius_promotion.discount#", 74, 15, "0");
			satir1 = yerles(satir1, "", 89, 15, "0");
			satir1 = yerles(satir1, "", 104, 15, "0");
			satir1 = yerles(satir1, "0", 119, 1, "0");
			ArrayAppend(dosya,satir1);
			</cfscript>
			 #PRODUCT_ID#.#STOCK_ID#<br/> 
			<cfcatch type="any">
				#currentrow#. Satırda hata !<br/>
			</cfcatch>
		</cftry>		
	</cfloop>	
</cfoutput>

<cffile action="append" output="#ArrayToList(dosya,CRLF)#" addnewline="yes" file="#UPLOAD_FOLDER##file_name#" charset="ISO-8859-9">

<!--- dosya loglanır --->
<cfquery name="add_file" datasource="#dsn2#">
	INSERT INTO
		FILE_EXPORTS
	(
		TARGET_SYSTEM,
		PROCESS_TYPE,
		PRODUCT_COUNT,
		FILE_NAME,
		FILE_SERVER_ID,
		STARTDATE,
		FINISHDATE,
		RECORD_DATE,
		RECORD_IP,
		DEPARTMENT_ID,
		RECORD_EMP
	)
	VALUES
	(
		#target_pos#,
		-4,
		#get_products.RECORDCOUNT#,
		'#FILE_NAME#',
		#fusebox.server_machine#,
	<cfif isdefined("attributes.startdate") and len(attributes.startdate) and isdate(attributes.startdate)>
		#attributes.startdate#,
	<cfelse>
		NULL,
	</cfif>
	<cfif isdefined("attributes.finishdate") and len(attributes.finishdate) and isdate(attributes.finishdate)>
		#attributes.finishdate#,
	<cfelse>
		NULL,
	</cfif>
		#NOW()#,
		'#CGI.REMOTE_ADDR#',
		#get_dept.department_id#,
		#SESSION.EP.USERID#)
</cfquery>

Promosyon Belgesi Oluşturuldu.<br/>
<input type="button" value=" Kapat " onClick="window.close();">