<cfsetting showdebugoutput="no">
<cfif not isdefined("session.pp") and not isdefined("session.ww.userid") and not IsDefined("Cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")>
	<cfset cookie_name_ = createUUID()>
	<cfcookie name="wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#" value="#cookie_name_#" expires="1">
</cfif>

<cfquery name="GET_ROW" datasource="#DSN3#">
	SELECT 
    	STOCK_ID,
        PROM_ID,
        PROM_MAIN_STOCK_ID,
        IS_PROM_ASIL_HEDIYE,
        MAIN_ORDER_ROW_ID 
    FROM 
    	ORDER_PRE_ROWS 
    WHERE 
    	ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.row_id#">
</cfquery>

<cfif get_row.recordcount>
	<!---İlgili satırdaki ürüne bağlı stok mesajı veren ürün varsa o da siliniyor --->
	<cfquery name="GET_OTHER_ROWS" datasource="#DSN3#">
		SELECT 
			ORDER_ROW_ID 
		FROM 
			ORDER_PRE_ROWS 
		WHERE 
			STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_row.stock_id#"> AND
			STOCK_ACTION_TYPE IS NOT NULL AND
			STOCK_ACTION_TYPE IN (1,2,3)
		<cfif isdefined("session.pp")>
			AND RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
		<cfelseif isdefined("session.ww.userid")>
			AND RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
		<cfelseif isdefined("session.ep")>
			AND RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
		<cfelseif not isdefined("session_base.userid")>
			AND RECORD_GUEST = 1
			AND RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
			AND COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#">
		</cfif>
	</cfquery>
	
	<cfif get_other_rows.recordcount>
		<cfquery name="DEL_ORDER_ROWS" datasource="#DSN3#">
			DELETE FROM ORDER_PRE_ROWS WHERE ORDER_ROW_ID IN (#valuelist(get_other_rows.order_row_id)#)
		</cfquery>
	</cfif>

	<!--- sipariste anında urun rezerve calısıyorsa, sepetteki urunlerin rezerveleri de siliniyor --->
	<cfif fusebox.use_stock_speed_reserve> 
		<cfquery name="DEL_RESERVE_ROWS" datasource="#DSN3#">
			DELETE FROM ORDER_ROW_RESERVED WHERE PRE_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cftoken#"> AND STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_row.stock_id#">
		</cfquery>
	</cfif>
	
	<cfscript>
		sid = get_row.prom_main_stock_id;
		is_prom_asil_hediye_ = get_row.is_prom_asil_hediye;
		main_row_id_ = get_row.main_order_row_id;
		if(not(len(get_row.is_prom_asil_hediye) and get_row.is_prom_asil_hediye eq 1))//promosyon hediyesi olmayan satır silindiginde promosyon bilgisi alınıp buna baglı hediye satırlar siliniyor. detaylı promosyon için kullanılıyor
			row_prom_id = get_row.prom_id;
	</cfscript>
</cfif>

<cfquery name="DEL_ROW" datasource="#DSN3#">
	DELETE FROM ORDER_PRE_ROWS WHERE ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.row_id#">
</cfquery>

<cfquery name="DEL_ROW" datasource="#DSN3#">
	DELETE FROM ORDER_PRE_ROWS WHERE MAIN_ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.row_id#">
</cfquery>

<cfquery name="DEL_ROW" datasource="#DSN3#">
	DELETE FROM ORDER_PRE_ROWS_SPECS WHERE MAIN_ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.row_id#">
</cfquery>

<cfif isdefined('main_row_id_') and len(main_row_id_)>
	<cfquery name="DEL_ROW" datasource="#DSN3#">
		DELETE FROM ORDER_PRE_ROWS WHERE ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#main_row_id_#">
	</cfquery>
	<cfquery name="DEL_ROW" datasource="#DSN3#">
		DELETE FROM ORDER_PRE_ROWS WHERE MAIN_ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#main_row_id_#">
	</cfquery>
</cfif>
<cfif isdefined('row_prom_id') and len(row_prom_id)> <!--- detaylı promosyonda satır silinince kazanılan tüm urunler siliniyor--->
	<cfquery name="DEL_ROW" datasource="#DSN3#">
		DELETE FROM 
			ORDER_PRE_ROWS
		WHERE 
			PROM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#row_prom_id#">
			AND IS_PROM_ASIL_HEDIYE=1
		<cfif isdefined("session.pp")>
			AND RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
		<cfelseif isdefined("session.ww.userid")>
			AND RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
		<cfelseif isdefined("session.ep")>
			AND RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
		<cfelseif not isdefined("session_base.userid")>
			AND RECORD_GUEST = 1
			AND RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
			AND COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#">
		</cfif>
	</cfquery>
</cfif>
<cfquery name="DEL_ROW" datasource="#DSN3#"> <!--- detaylı promda genele uygulanan promosyon kazanc satırları siliniyor --->
	DELETE FROM 
		ORDER_PRE_ROWS 
	WHERE 
		IS_GENERAL_PROM=1 
		AND IS_PROM_ASIL_HEDIYE=1
		AND (ISNULL(PROD_PROM_ACTION_TYPE,0)=0) 
	<cfif isdefined("session.pp")>
		AND RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
	<cfelseif isdefined("session.ww.userid")>
		AND RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
	<cfelseif isdefined("session.ep")>
		AND RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
	<cfelseif not isdefined("session_base.userid")>
		AND RECORD_GUEST = 1
		AND RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
		AND COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#">
	</cfif>
</cfquery>
<cfif isdefined("attributes.demand_id") and len(attributes.demand_id)>
	<cfquery name="UPD_DEMAND" datasource="#DSN3#">
		UPDATE ORDER_DEMANDS SET DEMAND_STATUS = 0 WHERE DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.demand_id#">
	</cfquery>
</cfif>

<cfif not isDefined('attributes.fuseact')>
	<cfset attributes.fuseact = 'objects2.list_basket'>
</cfif>

<cfif isDefined('attributes.consumer_id') and len(attributes.consumer_id)>
	<cflocation url="#request.self#?fuseaction=#attributes.fuseact#&consumer_id=#attributes.consumer_id#" addtoken="no">
<cfelse>
	<cflocation url="#request.self#?fuseaction=#attributes.fuseact#" addtoken="no">
</cfif>

