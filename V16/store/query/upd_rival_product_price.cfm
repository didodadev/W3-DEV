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
			PRODUCT_ID=#attributes.PID#,
			R_ID = #R_ID#,
			STARTDATE = #attributes.STARTDATE#,
			<cfif len(attributes.FINISHDATE)>
			FINISHDATE = #attributes.FINISHDATE#,
			</cfif>
			PRICE = #PRICE#,
			MONEY = '#MONEY#',
			UNIT_ID = #GET_PRODUCT_UNIT.PRODUCT_UNIT_ID#,
			UPDATE_DATE = #now()#,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = '#cgi.REMOTE_ADDR#'
		WHERE
			PR_ID = #attributes.PR_ID#
	</cfquery>
<cfelse>
	<script type="text/javascript">
	alert("<cf_get_lang no ='120.Seçtiginiz Ürünün Birimi Uygun Değil'>!");	
	history.back();
	</script>
	<cfabort>
</cfif>	 

<script type="text/javascript">
wrk_opener_reload();
window.close();
</script>
