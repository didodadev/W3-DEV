<cfset FORM.BARCOD = barcode_no>
<cfset FORM.PRODUCT_ID = attributes.pid>

<cfquery name="stock_count" datasource="#dsn1#">
	SELECT STOCK_ID FROM STOCKS WHERE PRODUCT_ID = #ATTRIBUTES.PID#
</cfquery>
<cfif isdefined("stok_kodu_ozel_") and stok_kodu_ozel_ is not '0'>
	<cfset FORM.NEW_STOCK_CODE = '#stok_kodu_ozel_#'>
<cfelse>
	<cfset FORM.NEW_STOCK_CODE = '#attributes.pcode#.#stock_count.recordcount+1#'>
</cfif>

<cfquery name="GET_UNIT" datasource="#dsn1#">
	SELECT PRODUCT_UNIT_ID FROM PRODUCT_UNIT WHERE ADD_UNIT = '#birim#' AND PRODUCT_ID = #FORM.PRODUCT_ID# 
</cfquery>
<cfif GET_UNIT.RecordCount>
	<cfset FORM.UNIT = GET_UNIT.PRODUCT_UNIT_ID>		
	<cfquery name="ADD_STOCK_CODE" datasource="#dsn1#">
		INSERT INTO 
			STOCKS 
			(
				STOCK_CODE,
				PRODUCT_ID,
				PROPERTY,
				BARCOD,
				PRODUCT_UNIT_ID,
				MANUFACT_CODE,
				STOCK_STATUS,
				STOCK_CODE_2,
				RECORD_EMP, 
                RECORD_IP, 
                RECORD_DATE
			)
		VALUES 
			(
				'#trim(FORM.NEW_STOCK_CODE)#',
				#FORM.PRODUCT_ID#,
				'#cesit_adi#',
				'#FORM.BARCOD#',
				#FORM.UNIT#,
				'',
				1,
				<cfif len(product_code_2)>'#product_code_2#'<cfelse>NULL</cfif>,
				#session.ep.userid#, '#REMOTE_ADDR#', #now()#
			)
	</cfquery>
	
	<cfquery name="GET_MAX_STOCK" datasource="#dsn1#">
		SELECT MAX(STOCK_ID) AS MAX_STOCK FROM STOCKS
	</cfquery>
	<cfquery name="get_my_periods" datasource="#dsn#">
		SELECT 
            PERIOD, 
            PERIOD_YEAR, 
            OUR_COMPANY_ID, 
            RECORD_DATE, 
            RECORD_IP, 
            RECORD_EMP, 
            UPDATE_DATE, 
            UPDATE_IP, 
            UPDATE_EMP
        FROM 
            SETUP_PERIOD 
        WHERE 
            OUR_COMPANY_ID 
        IN 
            (SELECT OUR_COMPANY_ID FROM #dsn1_alias#.PRODUCT_OUR_COMPANY WHERE PRODUCT_ID = #FORM.PRODUCT_ID#)
	</cfquery>
	<cfloop query="get_my_periods">
		<cfif database_type is "MSSQL">
			<cfset temp_dsn = "#DSN#_#PERIOD_YEAR#_#OUR_COMPANY_ID#">
		<cfelseif database_type is "DB2">
			<cfset temp_dsn = "#dsn#_#OUR_COMPANY_ID#_#right(period_year,2)#">
		</cfif>
		<cfquery name="INSRT_STK_ROW" datasource="#temp_dsn#">
			INSERT INTO STOCKS_ROW 
				(
				STOCK_ID, 
				PRODUCT_ID
				)
			VALUES 
				(
				#GET_MAX_STOCK.MAX_STOCK#, 
				#FORM.PRODUCT_ID#
				)
		</cfquery>
	</cfloop> 
<cfelse>
	SORUNLU KAYIT !!!<br/>	
</cfif>
