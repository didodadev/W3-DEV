<cffunction name="f_date" output="false" returntype="string">
	<cfargument name="tarih" type="string" required="yes">
	<cf_date tarih="arguments.tarih">
	<cfreturn arguments.tarih>
</cffunction>

<!--- f_add_invoice_row_problem fonksiyonundaki ROW_TYPE argumanı 0 --> Iade, 1 --> Iptal anlamı tasır 
	  IS_PROM parametresi sadece hediye urunlerde 1,diger durumlarda 0 olmali
--->
<cffunction name="f_add_invoice_row_problem" output="false" returntype="numeric">
	<cfargument name="STOCK_CODE" type="string" required="yes">
	<cfargument name="BARCODE" type="string" required="yes">
	<cfargument name="INVOICE_ID" type="string" required="yes">
	<cfargument name="INVOICE_DATE" type="string" required="yes">
	<cfargument name="BILL_NO" type="string" required="yes">
	<cfargument name="AMOUNT" type="string" required="yes">
	<cfargument name="PRICE" type="string" required="yes">
	<cfargument name="DISCOUNTTOTAL" type="string" required="yes">
	<cfargument name="GROSSTOTAL" type="string" required="yes">
	<cfargument name="TAXTOTAL" type="string" required="yes">
	<cfargument name="NETTOTAL" type="string" required="yes">
	<cfargument name="TAX" type="string" required="yes">
	<cfargument name="CUSTOMER_NO" type="string" required="yes">
	<cfargument name="CREDITCARD_NO" type="string" required="yes">
	<cfargument name="ROW_TYPE" type="string" required="yes">
	<cfargument name="IS_PROM" type="string" required="yes">
	<cfquery name="ADD_INVOICE_ROW_PROBLEM" datasource="#DSN2#">
		INSERT INTO
			INVOICE_ROW_POS_PROBLEM
		(
			INVOICE_ID,
			STOCK_CODE,
			BARCODE,
			INVOICE_DATE,
			AMOUNT,
			PRICE,
			DISCOUNTTOTAL,
			GROSSTOTAL,
			NETTOTAL,
			TAXTOTAL,
			TAX,
			CREDITCARD_NO,
			BRANCH_FIS_NO,
			BRANCH_CON_ID,
			ROW_TYPE,
			IS_PROM
		)
		VALUES
		(
			#arguments.invoice_id#,
			'#arguments.stock_code#',
			'#arguments.barcode#',
			#arguments.invoice_date#,
			#arguments.amount#,
			#arguments.price#,
			#arguments.discounttotal#,
			#arguments.grosstotal#,
			#arguments.nettotal#,
			#arguments.taxtotal#,			
			#arguments.tax#,
			<cfif len(arguments.creditcard_no)>'#arguments.creditcard_no#'<cfelse>NULL</cfif>,
			<cfif len(arguments.bill_no)>'#arguments.bill_no#'<cfelse>NULL</cfif>,
			<cfif len(arguments.customer_no)>'#arguments.customer_no#'<cfelse>NULL</cfif>,
			#arguments.row_type#,
			#arguments.is_prom#
		)
	</cfquery>
	<cfreturn 1>
</cffunction>



<cffunction name="f_get_stock" output="false" returntype="query">
	<cfargument name="STOCK_ID" type="string">
	<cfargument name="BARCODE" type="string">
	<cfargument name="TERMINAL_TYPE" type="string">
	<cfif isdefined("arguments.stock_id") and not isnumeric(arguments.stock_id)><cfset arguments.stock_id = 0></cfif>
	<cfif isdefined("arguments.barcode") and not isnumeric(arguments.barcode)><cfset arguments.barcode = 0></cfif>
	<cfquery name="Q_GET_STOCK" dbtype="query">
		SELECT
			STOCK_ID,
			TAX,
			MULTIPLIER,
			PRODUCT_ID,
			ADD_UNIT,
			BARCOD,
			IS_KARMA
		FROM
		<cfif listfind('-3,-8', arguments.terminal_type,',')><!--- NCR ve Wincor ise --->
			GET_STOCK_ALL_NCR
		<cfelse>
			GET_STOCK_ALL
		</cfif>
		WHERE 
		<cfif listfind('-3,-8', arguments.terminal_type)><!--- NCR ve Wincor ise --->
			BARCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.barcode#">
		<cfelse>
			STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">
		</cfif>
	</cfquery>
	<cfreturn Q_GET_STOCK>
</cffunction>
