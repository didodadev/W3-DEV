<cfif isdefined("session.ep.userid")>
	<cfset attributes.temp_user_id = session.ep.userid>
<cfelse>
	<cfset attributes.temp_user_id = 0>
</cfif>

<cfscript>
	start_time = now();
	CRLF = Chr(13)&Chr(10); // satır atlama karakteri
</cfscript>

<cfquery name="GET_IMPORT" datasource="#DSN2#">
	SELECT
		FI.SOURCE_SYSTEM,
		FI.STARTDATE,
		FI.DEPARTMENT_ID,
		FI.DEPARTMENT_LOCATION,
		FI.IMPORT_DETAIL,
		FI.FILE_NAME,
		FI.FILE_SERVER_ID,		
		D.BRANCH_ID
	FROM
		FILE_IMPORTS FI,
		#dsn_alias#.DEPARTMENT D
	WHERE
		FI.I_ID = #attributes.i_id# AND
		FI.DEPARTMENT_ID = D.DEPARTMENT_ID
</cfquery>

<cfif listfind('-3,-1,-8', get_import.source_system,',')><!--- NCR ve Wincor icin satislar barkod bilgisi ile, Genius da ise Hediye urunler barkod bilgisi ile donmekte --->
	<cfif not isDefined('GET_STOCK_ALL_NCR')><!--- 20041028 schedule da calisan loop yuzunden surekli cagrilmasin diye kondu --->
		<cfquery name="GET_STOCK_ALL_NCR" datasource="#DSN1#">
			SELECT
				STOCKS.STOCK_ID,
				STOCKS.PRODUCT_ID,
				SB.BARCODE AS BARCOD,
				PRODUCT.TAX,
				PRODUCT.IS_KARMA,
				PRODUCT_UNIT.MULTIPLIER,
				PRODUCT_UNIT.ADD_UNIT
			FROM
				STOCKS,
				STOCKS_BARCODES SB,
				PRODUCT_UNIT,
				PRODUCT
			WHERE
				PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
				PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
				PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
				SB.STOCK_ID = STOCKS.STOCK_ID
		</cfquery>
	</cfif>
</cfif>
<cfif get_import.source_system neq -3><!--- Inter ve Genius icin satislar STOCK_ID bilgisi ile donmekte --->
	<cfif not isDefined('GET_STOCK_ALL')>
		<cfquery name="GET_STOCK_ALL" datasource="#DSN1#">
			SELECT
				STOCKS.STOCK_ID,
				STOCKS.PRODUCT_ID,
				STOCKS.BARCOD,
				PRODUCT.TAX,
				PRODUCT.IS_KARMA,
				PRODUCT_UNIT.MULTIPLIER,
				PRODUCT_UNIT.ADD_UNIT
			FROM
				STOCKS,
				PRODUCT_UNIT,
				PRODUCT
			WHERE
				PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
				PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
				PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID		
		</cfquery>
	</cfif>
</cfif>


<!--- dosya okunur ve invoice acilir --->
<cftry>
	<cflock name="#CREATEUUID()#" timeout="20">
		<cftransaction>
			<cfquery name="ADD_INVOICE" datasource="#DSN2#" result="MAX_ID">
				INSERT INTO 
					INVOICE
				(
					PURCHASE_SALES,
					INVOICE_CAT,
					INVOICE_DATE,
					DEPARTMENT_ID,
					DEPARTMENT_LOCATION,
					INVOICE_NUMBER,
					NOTE,
					RECORD_DATE,
					RECORD_EMP,
					IS_PROCESSED,
					IS_CASH,
					IS_ACCOUNTED,
					UPD_STATUS,
					PROCESS_CAT
				)
				VALUES
				(	
					1,
					67,
					#CreateOdbcDateTime(get_import.startdate)#,
					#get_import.department_id#,
					<cfif len(get_import.department_location)>#get_import.department_location#<cfelse>NULL</cfif>,
					<cfif get_import.source_system eq -1><!--- Genius --->
					'GNDSALES_#get_import.department_id#_#dateformat(now(),'yyyymmdd')##timeformat(now(),'HHMMSSS')#',
					<cfelseif get_import.source_system eq -2><!--- Inter --->
					'MPOSSALES_#get_import.department_id#_#dateformat(now(),'yyyymmdd')##timeformat(now(),'HHMMSSS')#_#get_import.import_detail#',
					<cfelseif get_import.source_system eq -3><!--- Ncr --->
					'NCRSALES_#get_import.department_id#_#dateformat(now(),'yyyymmdd')##timeformat(now(),'HHMMSSS')#',
					<cfelseif get_import.source_system eq -6><!--- Espos --->
					'ESPOS_#get_import.department_id#_#dateformat(now(),'yyyymmdd')##timeformat(now(),'HHMMSSS')#',
					<cfelseif get_import.source_system eq -8><!--- Wincor --->
					'WINCOR_#get_import.department_id#_#dateformat(now(),'yyyymmdd')##timeformat(now(),'HHMMSSS')#',
					</cfif>				
					'#get_import.department_id# - #dateformat(get_import.startdate,"dd/mm/yyyy")# Satış İmportları',
					#now()#,
					#attributes.temp_user_id#,
					1,
					1,
					0,
					0,
					0
				)
			</cfquery>
			<!--- transaction kalkarsa alttaki query bu hale gelmeli 20041012 --->
			<!--- SELECT MAX(INVOICE_ID) AS MAX_ID FROM INVOICE WHERE DEPARTMENT_ID=#get_import.department_id# AND INVOICE_DATE=#CreateOdbcDateTime(get_import.startdate)# --->
            <cfquery name="UPD_FILE" datasource="#DSN2#">
				UPDATE
					FILE_IMPORTS 
				SET
					INVOICE_ID = #MAX_ID.IDENTITYCOL#,
					IMPORTED = 1
				WHERE
					I_ID = #attributes.i_id#
			</cfquery>
		</cftransaction>
	</cflock>
	<cfset attributes.invoice_id = MAX_ID.IDENTITYCOL><!--- dosya okurken hata olursa catch de dogru calismasi icin sirasi burada olmali 20041223--->
	<cfset dosya = ''>
	<cf_get_server_file output_file="store#dir_seperator##get_import.file_name#" output_server="#get_import.file_server_id#" output_type="3" read_name="dosya">

	<cfif get_import.source_system eq -1>
		<cfinclude template="sales_import_genius.cfm">
	<cfelseif get_import.source_system eq -2>
		<cfinclude template="sales_import_inter.cfm">
	<cfelseif get_import.source_system eq -3>
		<cfset ext_code = -1>
		<cfinclude template="../functions/barcode.cfm">
		<cfinclude template="sales_import_ncr.cfm">
	<cfelseif get_import.source_system eq -6>
		<cfinclude template="sales_import_espos.cfm">
	<cfelseif get_import.source_system eq -8>
		<cfinclude template="sales_import_wincor.cfm">
	</cfif>	
	<cfset dosya = ''>
	
	<cfif not isDefined('GET_KARMA_PRODUCTS')><!--- 20041028 schedule da calisan loop yuzunden surekli cagrilmasin diye kondu --->
		<cfquery name="GET_KARMA_PRODUCTS" datasource="#DSN1#">
			SELECT 
				S.STOCK_ID,
				KP.PRODUCT_ID,
				KP.PRODUCT_AMOUNT,
				KP.KARMA_PRODUCT_ID
			FROM 
				KARMA_PRODUCTS KP,
				PRODUCT P,
				STOCKS S
			WHERE  
				P.PRODUCT_ID = KP.PRODUCT_ID AND
				S.PRODUCT_ID = KP.PRODUCT_ID AND
				S.STOCK_ID = KP.STOCK_ID
		</cfquery>
	</cfif>

	<cfquery name="GET_INVOICE_KARMA" datasource="#DSN2#">
		SELECT
			IRP.STOCK_ID,
			IRP.PRODUCT_ID,
			SUM(IRP.AMOUNT) AS TOPLAM_MIKTAR
		FROM
			INVOICE_ROW_POS IRP
		WHERE
			IRP.INVOICE_ID = #attributes.invoice_id# AND
			IRP.IS_KARMA = 1
		GROUP BY
			IRP.STOCK_ID,
			IRP.PRODUCT_ID
	</cfquery>
	<cfquery name="GET_INVOICE_NORMAL" datasource="#DSN2#">
		SELECT
			IRP.STOCK_ID,
			IRP.PRODUCT_ID,
			SUM(IRP.AMOUNT) AS TOPLAM_MIKTAR
		FROM
			INVOICE_ROW_POS IRP
		WHERE
			IRP.INVOICE_ID = #attributes.invoice_id# AND
			IRP.IS_KARMA <> 1
		GROUP BY
			IRP.STOCK_ID,
			IRP.PRODUCT_ID
	</cfquery>

	<!--- Karmalı urunler --->
	<cfloop query="get_invoice_karma">
		<!--- <cftry> --->
				<cfquery name="GET_KARMA_PRODUCT" dbtype="query">
					SELECT 
						STOCK_ID,
						PRODUCT_ID,
						PRODUCT_AMOUNT
					FROM
						GET_KARMA_PRODUCTS
					WHERE  
						KARMA_PRODUCT_ID = #get_invoice_karma.product_id#
				</cfquery>
				<cfif get_karma_product.recordcount and database_type is 'MSSQL'>
					<cfloop index="page_stock" from="0" to="#(get_karma_product.recordcount\row_block)#">
						<cfset start_row=(page_stock*row_block)+1>	
						<cfset end_row=start_row+(row_block-1)>
						<cfif (end_row) gte get_karma_product.recordcount>
							<cfset end_row=get_karma_product.recordcount>
						</cfif>
						<cfquery name="ADD_STOCKS_ROW_KARMA" datasource="#DSN2#">
							<cfloop index="add_stock" from="#start_row#" to="#end_row#">
								INSERT INTO STOCKS_ROW ( STOCK_ID,PRODUCT_ID,STORE,STORE_LOCATION,PROCESS_TYPE,STOCK_IN,STOCK_OUT,PROCESS_DATE,UPD_ID)
								VALUES ( #get_karma_product.stock_id[add_stock]#,#get_karma_product.product_id[add_stock]#,#get_import.department_id#,<cfif len(get_import.department_location)>#get_import.department_location#<cfelse>NULL</cfif>,67,<cfif get_invoice_karma.toplam_miktar lt 0>#get_invoice_karma.toplam_miktar*(-1)*get_karma_product.product_amount[add_stock]#,0,<cfelse>0,#get_invoice_karma.toplam_miktar*get_karma_product.product_amount[add_stock]#,</cfif>#CreateOdbcDateTime(get_import.startdate)#,#attributes.invoice_id# )
							</cfloop>
						</cfquery>
					</cfloop>
				<cfelseif get_karma_product.recordcount>
					<cfloop query="get_karma_product">
						<cfquery name="ADD_STOCKS_ROW_KARMA" datasource="#DSN2#">
							INSERT INTO STOCKS_ROW ( STOCK_ID,PRODUCT_ID,STORE,STORE_LOCATION,PROCESS_TYPE,STOCK_IN,STOCK_OUT,PROCESS_DATE,UPD_ID)
							VALUES ( #get_karma_product.stock_id#,#get_karma_product.product_id#,#get_import.department_id#,<cfif len(get_import.department_location)>#get_import.department_location#<cfelse>NULL</cfif>,67,<cfif get_invoice_karma.toplam_miktar lt 0>#get_invoice_karma.toplam_miktar*(-1)*get_karma_product.product_amount#,0,<cfelse>0,#get_invoice_karma.toplam_miktar*get_karma_product.product_amount#,</cfif>#CreateOdbcDateTime(get_import.startdate)#,#attributes.invoice_id# )
						</cfquery>
					</cfloop>			
				</cfif>
		<!--- <cfcatch type="any">Karma Ürün Eklemelerde Hata Baslangıc:#start_row# Bitis#end_row#</cfcatch>
		</cftry> --->
	</cfloop>
	
	<!--- Normal Urunler --->
	<!--- <cftry> --->
		<cfif get_invoice_normal.recordcount and database_type is 'MSSQL'>
			<cfloop index="page_stock" from="0" to="#(ceiling(get_invoice_normal.recordcount/row_block))-1#">
				<cfset start_row=(page_stock*row_block)+1>	
				<cfset end_row=start_row+(row_block-1)>
				<cfif (end_row) gte get_invoice_normal.recordcount>
					<cfset end_row=get_invoice_normal.recordcount>
				</cfif>
				<cfquery name="ADD_STOCKS_ROW_NORMAL" datasource="#DSN2#">
					<cfloop index="add_stock" from="#start_row#" to="#end_row#">
						INSERT INTO STOCKS_ROW( STOCK_ID,PRODUCT_ID,STORE,STORE_LOCATION,PROCESS_TYPE,STOCK_IN,STOCK_OUT,PROCESS_DATE,UPD_ID)
						VALUES( #get_invoice_normal.stock_id[add_stock]#,#get_invoice_normal.product_id[add_stock]#,#get_import.department_id#,<cfif len(get_import.department_location)>#get_import.department_location#<cfelse>NULL</cfif>,67,<cfif get_invoice_normal.TOPLAM_MIKTAR[add_stock] lt 0>#get_invoice_normal.TOPLAM_MIKTAR[add_stock]*(-1)#, 0,<cfelse>0,#get_invoice_normal.TOPLAM_MIKTAR[add_stock]#,</cfif>#CreateOdbcDateTime(get_import.startdate)#,#attributes.invoice_id# )
					</cfloop>
				</cfquery>
			</cfloop>
		<cfelseif get_invoice_normal.recordcount>
			<cfloop query="get_invoice_normal">
				<cfquery name="ADD_STOCKS_ROW_NORMAL" datasource="#DSN2#">
					INSERT INTO STOCKS_ROW ( STOCK_ID,PRODUCT_ID, STORE, STORE_LOCATION,PROCESS_TYPE,STOCK_IN,STOCK_OUT,PROCESS_DATE,UPD_ID)
					VALUES ( #get_invoice_normal.stock_id#,#get_invoice_normal.product_id#,#get_import.department_id#,<cfif len(get_import.department_location)>#get_import.department_location#<cfelse>NULL</cfif>,67,<cfif get_invoice_normal.TOPLAM_MIKTAR lt 0>#get_invoice_normal.TOPLAM_MIKTAR*(-1)#,0,<cfelse>0,#get_invoice_normal.TOPLAM_MIKTAR#,</cfif>#CreateOdbcDateTime(get_import.startdate)#,#attributes.invoice_id# )
				</cfquery>
			</cfloop>
		</cfif>
	<!--- <cfcatch type="any">Normal Ürün Eklemelerde Hata Baslangıc:#start_row# Bitis#end_row#</cfcatch>
	</cftry> --->
	
	
	<!--- invoice toplamları yazılır --->
	<cfquery name="UPD_INVOICE" datasource="#DSN2#">
		UPDATE 
			INVOICE
		SET
			GROSSTOTAL = #GROSS_TOTAL#,
			NETTOTAL = #NET_TOTAL#,
			TAXTOTAL = #TAX_TOTAL#,
			UPDATE_DATE = #now()#
		WHERE
			INVOICE_ID = #attributes.invoice_id#
	</cfquery>
	
	<!--- dosya loglanır --->
	<cfquery name="UPD_FILE" datasource="#DSN2#">
		UPDATE
			FILE_IMPORTS
		SET
			PROBLEMS_COUNT = #PROBLEMS_COUNT#,
			PRODUCT_COUNT = #TOTAL_PRODUCTS#
		WHERE
			I_ID = #attributes.i_id#
	</cfquery>
	
	<cfcatch type="any">
        <cflock name="#CREATEUUID()#" timeout="20">
			<cftransaction>
				<cfquery name="DEL_INVOICE_ROW_POS_PROBLEM" datasource="#DSN2#">
					DELETE FROM INVOICE_ROW_POS_PROBLEM WHERE INVOICE_ID = #attributes.invoice_id#
				</cfquery>
				<cfquery name="DEL_INVOICE_ROW_POS" datasource="#DSN2#">
					DELETE FROM INVOICE_ROW_POS	WHERE INVOICE_ID = #attributes.invoice_id#
				</cfquery>
				<cfquery name="DEL_INVOICE" datasource="#DSN2#">
					DELETE FROM INVOICE	WHERE INVOICE_ID = #attributes.invoice_id#
				</cfquery>
				<cfquery name="DEL_STOCKS_ROW" datasource="#DSN2#">
					DELETE FROM STOCKS_ROW WHERE UPD_ID = #attributes.invoice_id# AND PROCESS_TYPE = 67
				</cfquery>
				<cfquery name="UPD_FILE2" datasource="#DSN2#">
					UPDATE 
						FILE_IMPORTS
					SET
						INVOICE_ID = NULL,
						PRODUCT_COUNT = NULL,
						PROBLEMS_COUNT = NULL,
						IMPORTED = 0
					WHERE
						I_ID = #attributes.i_id#
				</cfquery>
			</cftransaction>
		</cflock>
		<cfset hata_flag = 1><!--- 20041028 schedules loop satis isleme icin kullaniliyor --->
		<cfif fusebox.circuit neq 'schedules'>
			<script type="text/javascript">
				alert("Hata Oluştu !");
			</script>
			<cfrethrow>
			<cfabort>
		</cfif>
	</cfcatch>
</cftry>