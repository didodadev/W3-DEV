<cfsetting showdebugoutput="no">
<cfquery name="get_row" datasource="#dsn3#">
	SELECT * FROM ORDER_PRE_ROWS WHERE ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.row_id#">
</cfquery>

<cfscript>
	sid = get_row.PROM_MAIN_STOCK_ID;
	is_prom_asil_hediye_ = get_row.IS_PROM_ASIL_HEDIYE;
	main_row_id_ = get_row.MAIN_ORDER_ROW_ID;
	if(not(len(get_row.IS_PROM_ASIL_HEDIYE) and get_row.IS_PROM_ASIL_HEDIYE eq 1))//promosyon hediyesi olmayan satır silindiginde promosyon bilgisi alınıp buna baglı hediye satırlar siliniyor. detaylı promosyon için kullanılıyor
		row_prom_id = get_row.PROM_ID;
</cfscript>

<cfquery name="upd_row_checked" datasource="#dsn3#">
	UPDATE ORDER_PRE_ROWS SET IS_CHECKED = #attributes.row_deger#,ROW_PRE_STATUS=NULL WHERE ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.row_id#">
</cfquery>

<cfquery name="upd_row_checked" datasource="#dsn3#">
	UPDATE ORDER_PRE_ROWS SET IS_CHECKED = #attributes.row_deger#,ROW_PRE_STATUS=NULL WHERE MAIN_ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.row_id#">
</cfquery>

<cfif len(main_row_id_)>
	<cfquery name="upd_row_checked" datasource="#dsn3#">
        UPDATE ORDER_PRE_ROWS SET IS_CHECKED = #attributes.row_deger#,ROW_PRE_STATUS=NULL WHERE ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#main_row_id_#">
    </cfquery>

	<cfquery name="upd_row_checked" datasource="#dsn3#">
        UPDATE ORDER_PRE_ROWS SET IS_CHECKED = #attributes.row_deger#,ROW_PRE_STATUS=NULL WHERE MAIN_ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#main_row_id_#">
    </cfquery>
</cfif>

