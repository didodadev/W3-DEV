<cfsetting showdebugoutput="no">
<cfquery name="get_rows" datasource="#dsn3#">
	SELECT 
		'0' AS TYPE,
		OPR.*,
		S.STOCK_CODE,
		S.STOCK_CODE_2,
		PU.DIMENTION,
  		P.IS_INVENTORY
	FROM
		ORDER_PRE_ROWS OPR,
		#dsn1_alias#.STOCKS S,
		#dsn1_alias#.PRODUCT_UNIT PU,
     	#dsn1_alias#.PRODUCT P
	WHERE
		OPR.STOCK_ID = S.STOCK_ID AND
		S.PRODUCT_UNIT_ID=PU.PRODUCT_UNIT_ID AND
		S.PRODUCT_ID=PU.PRODUCT_ID AND
     	S.PRODUCT_ID=P.PRODUCT_ID AND
		OPR.ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.row_id#"> AND
		OPR.PRODUCT_ID IS NOT NULL
</cfquery>
<cfif fusebox.use_stock_speed_reserve> <!--- sipariste anında urun rezerve calısıyorsa, sepetteki urunlerin rezerveleri de siliniyor --->
	<!---<cfquery name="del_reserve_rows" datasource="#dsn3#">
		DELETE FROM ORDER_ROW_RESERVED WHERE PRE_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cftoken#">
	</cfquery>--->
    <cfstoredproc procedure="DEL_ORDER_ROW_RESERVED" datasource="#DSN3#">
    	<cfprocparam cfsqltype="cf_sql_varchar" value="#cftoken#">
    </cfstoredproc>
</cfif>
<cfoutput query="get_rows">
	<cfset new_value_ = attributes.row_deger>
	<cfquery name="upd_" datasource="#dsn3#">
		UPDATE ORDER_PRE_ROWS SET QUANTITY = #new_value_# WHERE ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_row_id#">
	</cfquery>
	<cfif fusebox.use_stock_speed_reserve> <!--- sipariste anında urun rezerve calısıyorsa, sepetteki urunlerin rezerveleri de siliniyor --->
		<cfif (len(get_rows.STOCK_ACTION_TYPE) and not listfind('1,2,3',get_rows.STOCK_ACTION_TYPE,',')) or not len(get_rows.STOCK_ACTION_TYPE)>
			<cfquery name="add_reserve_" datasource="#dsn3#">
				INSERT INTO 
					ORDER_ROW_RESERVED
					(
						STOCK_ID,
						PRODUCT_ID,
						RESERVE_STOCK_OUT,
						ORDER_ROW_ID,
						PRE_ORDER_ID,
						IS_BASKET
					) 
					VALUES
					(
						#get_rows.STOCK_ID#,
						#get_rows.PRODUCT_ID#,
						#new_value_#,
						#ORDER_ROW_ID#,
						'#CFTOKEN#',
						1				
					)
			</cfquery>
		</cfif>
	</cfif>
</cfoutput>
