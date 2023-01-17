<!--- Genuis İmport  --->
<!--- Stok Açılış Belgesi --->
<cfif listlen(attributes.store_id,"-") eq 2>
	<cfset location_id = listlast(attributes.store_id,"-")>
	<cfset store_id =  listfirst(attributes.store_id,"-")>
<cfelse>
	<cfset store_id = attributes.store_id>
</cfif>

<!--- stok açılış kontrol et --->
<cfquery name="GET_RECORD_OPEN_FIS" datasource="#DSN2#">
	SELECT 
		* 
	FROM 
		STOCK_FIS
	WHERE 
		DEPARTMENT_IN=#store_id# AND 
		FIS_TYPE = 114
	<cfif isdefined('location_id')>
		AND LOCATION_IN=#location_id#
	</cfif>
</cfquery>

<cfif GET_RECORD_OPEN_FIS.RECORDCOUNT>
	<script type="text/javascript">
		alert("Seçtiğiniz Depoya ait Açılış Fişi Bulunmaktadır.");
	</script>	
	<CFABORT>
</cfif>

<!--- <cfquery name="GET_FIS_NO" datasource="#dsn2#">
	SELECT 
		FIS_NUMBER 
	FROM 
		STOCK_FIS
	WHERE 
		FIS_NUMBER = '#FIS_NO#'
</cfquery>

<cfif get_fis_no.recordcount>
	<script type="text/javascript">
		alert("Fiş Numaranızı Kontrol Ediniz.");
		history.back();
	</script>	
	<CFABORT>
</cfif> --->
<cf_papers paper_type="STOCK_FIS">
<cfset system_paper_no=paper_code & '-' & paper_number>
<cfset system_paper_no_add=paper_number>
<cfset attributes.FIS_NO=system_paper_no>
<cfset FIS_NO=system_paper_no>
<CF_DATE TARIH='attributes.processdate'>
<cfset upload_folder = "#upload_folder#store#dir_seperator#">
<cftry>
	<cffile   action = "upload" 
			  fileField = "uploaded_file" 
			  destination = "#upload_folder#"
			  nameConflict = "MakeUnique"  
			  mode="777">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#">	
	<!---Script dosyalarını engelle  02092010 FA-ND --->
	<cfset assetTypeName = listlast(cffile.serverfile,'.')>
	<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
	<cfif listfind(blackList,assetTypeName,',')>
		<cffile action="delete" file="#upload_folder##file_name#">
		<script type="text/javascript">
			alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
			history.back();
		</script>
		<cfabort>
	</cfif>
	<cfset file_size = cffile.filesize>
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz!");
			history.back();
		</script>
		<cfabort>
	</cfcatch>  
</cftry>
<CFFILE action="read" file="#upload_folder##file_name#" variable="dosya">
<cfscript>
	CRLF = Chr(13) & Chr(10);// satır atlama karakteri
	dosya = ListToArray(dosya,CRLF);
	line_count = ArrayLen(dosya);
	i = 1; //  başlangıç satırı, ilk satırda imza var
	TOTAL_PRODUCTS = 0;
</cfscript>
<CFLOCK name="#CREATEUUID()#" timeout="20">
	<CFTRANSACTION>
		<cfquery name="ADD_STOCK_FIS" datasource="#dsn2#" result="MAX_ID">
			INSERT INTO STOCK_FIS
				(
				FIS_NUMBER,
				FIS_TYPE,
				DEPARTMENT_IN,
				LOCATION_IN,
				FIS_DATE,
				DELIVER_DATE,
				RECORD_DATE,
				EMPLOYEE_ID
				)
			VALUES
				(
				'#attributes.FIS_NO#',
				114,
				#store_id#,
				<cfif isDefined("location_id")>
				#location_id#,
				<cfelse>
				NULL,
				</cfif>
				#NOW()#,
				#attributes.processdate#,
				#NOW()#,
				#SESSION.EP.POSITION_CODE#
				)
		</cfquery>
	</CFTRANSACTION>
</CFLOCK>
'#Listgetat(dosya[i], 56, ";")#'
<!--- Loop ile dosya veritabanına yazılır --->
<cfloop from="1" to="#line_count#" index="i">
	<cfset BARCOD = listfirst(dosya[i],",")>
	<cfset AMOUNT = listlast(dosya[i],",")>
	<cfquery name="get_product" datasource="#dsn3#">
		SELECT
			STOCKS.STOCK_ID,
			STOCKS.PRODUCT_ID,
			PRODUCT_UNIT.ADD_UNIT
		FROM
			STOCKS,
			PRODUCT_UNIT
		WHERE
			STOCKS.PRODUCT_ID IN (SELECT PRODUCT_ID FROM GET_STOCK_BARCODES WHERE BARCODE = '#barcod#')
			AND
			STOCKS.PRODUCT_UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID
			AND
			STOCKS.PRODUCT_ID = PRODUCT_UNIT.PRODUCT_ID
	</cfquery>
	<cfif get_product.recordcount>
		<cfset TOTAL_PRODUCTS = TOTAL_PRODUCTS+1>
		<cfquery name="add_STOCK_FIS_ROW" datasource="#DSN2#">
			INSERT INTO STOCK_FIS_ROW
				(
				FIS_NUMBER,
				STOCK_ID,
				AMOUNT,
				UNIT
				<!--- PRICE,
				TAX,
				TOTAL,
				DISCOUNT,
				TOTAL_TAX,
				NET_TOTAL --->
				)
			VALUES
				(
				'#attributes.FIS_NO#',							
				#get_product.STOCK_ID#,
				#amount#, <!--- AMOUNT --->
				'#get_product.ADD_UNIT#' <!--- UNIT --->
				<!--- #session[var_][i][6]#,
				#session[var_][i][7]#,
				#ship_fis_total_#,
				#ship_fis_discount_#,
				#ship_fis_total_tax_#,
				#ship_fis_net_total_# --->
				)
		</cfquery>
		<cfquery name="ADD_STOCK_ROW" datasource="#dsn2#">
			INSERT INTO STOCKS_ROW
				(
				UPD_ID,
				PRODUCT_ID,
				STOCK_ID,
				PROCESS_TYPE,
				STOCK_IN,
				STORE,
				STORE_LOCATION,
				PROCESS_DATE
				)
			VALUES
				(
				#MAX_ID.IDENTITYCOL#,
				#get_product.PRODUCT_ID#,
				#get_product.STOCK_ID#,
				114,
				#amount#,
				#STORE_ID#,
				<cfif isDefined("LOCATION_ID") and LEN(LOCATION_ID) and LOCATION_ID gt 0>
				#LOCATION_ID#,
				<cfelse>
				NULL,
				</cfif>
				#attributes.processdate#
				)
		</cfquery>
	
	<cfelse>
		<cfoutput>_#barcod#_  barkodlu ürün KAYITLI DEĞİL yok !<br/></cfoutput>
	</cfif>
</cfloop>
<cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
	UPDATE 
		GENERAL_PAPERS
	SET
		STOCK_FIS_NUMBER=#system_paper_no_add#
	WHERE
		STOCK_FIS_NUMBER IS NOT NULL
</cfquery>
<!--- dosya loglanır --->
<cfquery name="add_file" datasource="#dsn2#">
	INSERT INTO	FILE_IMPORTS
		(SOURCE_SYSTEM,
		PROCESS_TYPE,
		PRODUCT_COUNT,
		FILE_NAME,
		FILE_SERVER_ID,
		FILE_SIZE,
		DEPARTMENT_ID,
		STARTDATE,
		RECORD_DATE,
		RECORD_IP,
		RECORD_EMP,
		FIS_NUMBER)
	VALUES
		(#target_pos#,
		-4,
		#TOTAL_PRODUCTS#,
		'#FILE_NAME#',
		#fusebox.server_machine#,
		#file_size#,
		#store_id#,
		#attributes.processdate#,
		#NOW()#,
		'#CGI.REMOTE_ADDR#',
		#SESSION.EP.USERID#,
		'#attributes.FIS_NO#')
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
