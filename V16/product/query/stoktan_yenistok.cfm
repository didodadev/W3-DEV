<cfif len(attributes.product_id) and len(attributes.product_name)>
	<cfquery name="get_punit_old" datasource="#dsn1#">
		SELECT 
			PRODUCT_UNIT.* 
		FROM 
			STOCKS,
			PRODUCT_UNIT 
		WHERE 
			STOCKS.PRODUCT_UNIT_ID=PRODUCT_UNIT.PRODUCT_UNIT_ID AND 
			STOCK_ID = #attributes.stock_id#
	</cfquery> 
	<cfquery name="get_punit_varmi" datasource="#dsn1#">
		SELECT PRODUCT_UNIT_ID FROM PRODUCT_UNIT WHERE PRODUCT_ID = #attributes.product_id# AND ADD_UNIT = (
			SELECT ADD_UNIT FROM PRODUCT_UNIT WHERE PRODUCT_UNIT_ID = (#get_punit_old.PRODUCT_UNIT_ID#)
		)
	</cfquery>
	<cfif not get_punit_varmi.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='894.Birimleri aynı olmadığı için bu çeşit, seçilen ürünün altına kaydedilemez'> !");
			history.back(-1);
		</script>
		<cfabort>
		<!--- <cfset punit = get_punit_varmi.PRODUCT_UNIT_ID>
	<cfelse> --->
		<!--- <cfif get_punit_old.ADD_UNIT is 'Adet'>
			<cfset UNIT_ID = "1,Adet">
		<cfelseif get_punit_old.ADD_UNIT is 'Kg'>
			<cfset UNIT_ID = "2,Kg">
		</cfif>
		<cfquery name="ADD_MAIN_UNIT" datasource="#dsn3#">
			INSERT INTO
			#dsn1_alias#.PRODUCT_UNIT 
				(
					PRODUCT_ID, 
					PRODUCT_UNIT_STATUS, 
					MAIN_UNIT_ID, 
					MAIN_UNIT, 
					UNIT_ID, 
					ADD_UNIT,
					DIMENTION,
					WEIGHT,
					IS_MAIN
				)
			VALUES 
				(
					#attributes.product_id#,
					1,
					#LISTGETAT(UNIT_ID,1)#,
					'#LISTGETAT(UNIT_ID,2)#',
					#LISTGETAT(UNIT_ID,1)#,
					'#LISTGETAT(UNIT_ID,2)#',
					'',
					'',
					1
				)					
		</cfquery>
		<cfquery name="GET_MAX_UNIT" datasource="#dsn3#">
			SELECT MAX(PRODUCT_UNIT_ID) AS MAX_UNIT FROM #dsn1_alias#.PRODUCT_UNIT
		</cfquery>
		<cfset punit = GET_MAX_UNIT.MAX_UNIT> --->
	</cfif>

	<cfquery name="get_pcode" datasource="#dsn1#">
		SELECT PRODUCT_CODE FROM PRODUCT WHERE PRODUCT_ID = #attributes.product_id#
	</cfquery>
	<cfquery name="stock_count" datasource="#dsn1#">
		SELECT STOCK_ID FROM STOCKS WHERE PRODUCT_ID = #attributes.product_id#
	</cfquery>
	<cfset FORM.NEW_STOCK_CODE = '#get_pcode.PRODUCT_CODE#.#stock_count.recordcount+1#'>
	<cfquery name="stok" datasource="#dsn1#">
		UPDATE 
			STOCKS SET PRODUCT_ID = #attributes.product_id#, 
			STOCK_CODE = '#FORM.NEW_STOCK_CODE#' 
		WHERE 
			STOCK_ID = #attributes.stock_id#
	</cfquery>
	
	<cfquery name="get_my_periods" datasource="#dsn#">
		SELECT * FROM SETUP_PERIOD
		WHERE OUR_COMPANY_ID IN (SELECT OUR_COMPANY_ID FROM #dsn1_alias#.PRODUCT_OUR_COMPANY WHERE PRODUCT_ID = #FORM.PRODUCT_ID#)
	</cfquery>
	<cfloop query="get_my_periods">
		<cfif database_type is "MSSQL">
			<cfset temp_dsn = "#DSN#_#PERIOD_YEAR#_#OUR_COMPANY_ID#">
		<cfelseif database_type is "DB2">
			<cfset temp_dsn = "#dsn#_#OUR_COMPANY_ID#_#right(period_year,2)#">
		</cfif>
		<cfquery name="INSRT_STK_ROW" datasource="#temp_dsn#">
			UPDATE STOCKS_ROW SET PRODUCT_ID = #attributes.product_id# WHERE STOCK_ID = #attributes.stock_id#
		</cfquery>
	</cfloop>
	<script language="JavaScript" type="text/javascript">
		window.close();
		wrk_opener_reload();
	</script>
</cfif>
