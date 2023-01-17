<!---  Birim Kontrolu --->
<cfquery name="GET_PRODUCT_UNIT" datasource="#dsn3#">
	SELECT 
		* 
	FROM 
		PRODUCT_UNIT
	WHERE 
		PRODUCT_ID = #attributes.PID#
	AND 
		MAIN_UNIT_ID=#attributes.UNIT_ID#	
</cfquery> 
<cfif GET_PRODUCT_UNIT.RECORDCOUNT>
	<cfif len(startdate)>
		<CF_DATE tarih="attributes.startdate">
	</cfif>
	<cfif len(attributes.finishdate)>
		<CF_DATE tarih="attributes.finishdate">
	</cfif>
	<cfdump var="#attributes#">
	<cfquery name="ADD_rival_prices" datasource="#dsn3#">
		INSERT INTO
			PRICE_RIVAL
			(
			R_ID,
			PRODUCT_ID,
			STARTDATE,
			FINISHDATE,
			PRICE,
			MONEY,
			UNIT_ID,
			RIVAL_DETAIL,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP,
			PRICE_TYPE
			)
		VALUES
			(
			<cfqueryparam cfsqltype="cf_sql_integer" value="#R_ID#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#PID#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.STARTDATE#">,
			<cfif len(attributes.FINISHDATE)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.FINISHDATE#"><cfelse>NULL</cfif>,
			<cfqueryparam cfsqltype="cf_sql_float" value="#PRICE#">,
			<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#MONEY#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PRODUCT_UNIT.PRODUCT_UNIT_ID#">,
			<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.rival_detail#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ep.userid#">,
			<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">,
			<cfif len(attributes.type_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.type_id#"><cfelse>NULL</cfif>
			)
	</cfquery>
	<script type="text/javascript">
	    location.href = document.referrer;
		wrk_opener_reload();
		window.close();	
	</script>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='37908.Seçtiğiniz Ürünün Birimi Uygun Değil'>!");	
		history.back();
	</script>
</cfif> 

