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
<cfif GET_PRODUCT_UNIT.RECORDCOUNT >
	
	<cfif len(startdate)>
		<CF_DATE tarih="attributes.startdate">
	</cfif>
	<cfif len(attributes.FINISHDATE)>
		<CF_DATE tarih="attributes.finishdate">
	</cfif>
	
	<cfquery name="upD_rival_prices" datasource="#DSN3#">
		UPDATE
			PRICE_RIVAL
		SET
			PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PID#">,
			R_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#R_ID#">,
			STARTDATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.STARTDATE#">,
			FINISHDATE = <cfif len(attributes.FINISHDATE)>#attributes.FINISHDATE#<cfelse>NULL</cfif>,
			PRICE = <cfqueryparam cfsqltype="cf_sql_float" value="#PRICE#">,
			MONEY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#MONEY#">,
			UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PRODUCT_UNIT.PRODUCT_UNIT_ID#">,
			RIVAL_DETAIL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.rival_detail#">,
			UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ep.userid#">,
			UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">,
			PRICE_TYPE = <cfif len(attributes.TYPE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.TYPE_ID#"><cfelse>NULL</cfif>
		WHERE
			PR_ID = #attributes.PR_ID#
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
	<cfabort>
</cfif>	 
