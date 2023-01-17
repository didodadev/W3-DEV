<cfsetting requesttimeout="1000">

<cfif IsDefined("attributes.location_id")>
	<cfset location_id = attributes.location_id>
</cfif>
<cfset store_id =  attributes.store_id>
<cfset file_name =  attributes.file_name>
<cfset upload_folder = "#upload_folder#store#dir_seperator#">
<cffile action="write" file="#upload_folder##file_name#" output="#dosya_content#">
<CFFILE action="read" file="#upload_folder##file_name#" variable="dosya">
<cfscript>
	CRLF = "$";
	dosya = ListToArray(dosya,CRLF);
	line_count = ArrayLen(dosya);
	TOTAL_PRODUCTS = 0;
	file_size = attributes.file_size;
</cfscript>
	
<cf_papers paper_type="STOCK_FIS">
<cfset system_paper_no=paper_code & '-' & paper_number>
<cfset system_paper_no_add=paper_number>
<cfset attributes.FIS_NO=system_paper_no>
<cfset FIS_NO=system_paper_no>

<CF_DATE TARIH='attributes.processdate'>

<cfquery name="get_product_main" datasource="#dsn3#">
	SELECT
		S.STOCK_ID,
		S.PRODUCT_ID,
		PU.ADD_UNIT,
		GSB.BARCODE
	FROM
		STOCKS AS S,
		PRODUCT_UNIT AS PU,
		GET_STOCK_BARCODES AS GSB
	WHERE
		S.STOCK_ID=GSB.STOCK_ID AND
		S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
		S.PRODUCT_ID = PU.PRODUCT_ID
</cfquery>

<CFLOCK name="#CREATEUUID()#" timeout="1000">
	<CFTRANSACTION>

		<cfquery name="ADD_STOCK_FIS" datasource="#dsn2#" result="MAX_ID">
			INSERT INTO 
				STOCK_FIS
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
				<cfif isdefined('location_id') and len(location_id)>#location_id#,<cfelse>NULL,</cfif>
				#NOW()#,
				#attributes.processdate#,
				#NOW()#,
				#SESSION.EP.POSITION_CODE#
			)
		</cfquery>
	<table border="1" bordercolor="CCCCCC">
		<tr><td colspan="4"><br/>Bulunamayan Ürünler</td></tr>
		<tr>
		<td>No</td>
		<td height="20" width="100">Barkod</td>
		<td width="350">Ürün</td>
		<td width="50">Miktar</td>
		</tr>
	<cfset counter=0>
	<cfloop from="1" to="#line_count#" index="i">
		<cfset amount = listgetat(dosya[i], 2, ",")>
		<cfquery name="get_product" dbtype="query">
			SELECT
				*
			FROM
				get_product_main
			WHERE
				BARCODE = '#listfirst(dosya[i], ",")#'
		</cfquery>
		
		<cfif (get_product.ADD_UNIT is "Kg")>
			<cfset amount = amount / 1000>
		</cfif>
	
		<cfif get_product.recordcount>
			<cfset TOTAL_PRODUCTS = TOTAL_PRODUCTS+1>
			<cfquery name="add_STOCK_FIS_ROW" datasource="#DSN2#">
				INSERT INTO 
					STOCK_FIS_ROW
				(
					FIS_NUMBER,
					STOCK_ID,
					AMOUNT,
					UNIT
				)
				VALUES
				(
					'#attributes.FIS_NO#',							
					#get_product.STOCK_ID#,
					#amount#, 
					'#get_product.ADD_UNIT#'
				)
			</cfquery>
	
			<cfquery name="ADD_STOCK_ROW" datasource="#dsn2#">
				INSERT INTO 
					STOCKS_ROW
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
			<cfset counter=counter+1>
			<cfoutput>
			<tr>
			<td>#counter#</td>
			<td width="100" height="20">#listfirst(dosya[i], ",")# </td>
			<td width="350"><cfif listlen(dosya[i],",") gt 2>#listgetat(dosya[i], 3, ",")#<cfelse> Satır : #i# de isim yok...</cfif></td>
			<td width="50">#amount#</td>
			</tr>
			</cfoutput>
		</cfif>
	</cfloop>
	<cfif TOTAL_PRODUCTS eq 0>
		<cfquery name="del_" datasource="#dsn2#">
			DELETE FROM STOCK_FIS WHERE FIS_ID = #MAX_ID.IDENTITYCOL#
		</cfquery>
			<tr>
				<td colspan="3"><br/><strong>Hiç Bir Ürün Alınamadığından Fiş Kaydı Yapılmadı!</strong><br/></td>
			</tr>
	</cfif>
	</table>
	</CFTRANSACTION>
</CFLOCK>

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
	INSERT INTO	
		FILE_IMPORTS
	(
		SOURCE_SYSTEM,
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
		FIS_NUMBE
	)
	VALUES
	(
		#target_pos#,
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
		'#attributes.FIS_NO#'
	)
</cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	alert('İşlem yapıldı!');
</script>
