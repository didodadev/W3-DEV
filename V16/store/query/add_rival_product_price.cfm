<!---  Birim Kontrolu --->
<cfquery name="GET_PRODUCT_UNIT" datasource="#dsn3#">
	SELECT 
		* 
	FROM 
		PRODUCT_UNIT
	WHERE 
		PRODUCT_ID = #attributes.PID#
		AND MAIN_UNIT_ID=#attributes.UNIT_ID#	
</cfquery> 
<cfif GET_PRODUCT_UNIT.RECORDCOUNT>
	<cfif len(startdate)>
		<CF_DATE tarih="attributes.startdate">
	</cfif>
	<cfif len(attributes.finishdate)>
		<CF_DATE tarih="attributes.finishdate">
	</cfif>

	<cfquery name="ADD_rival_prices" datasource="#dsn3#">
		INSERT INTO
			PRICE_RIVAL
			(
			R_ID,
			PRODUCT_ID,
			STARTDATE,
			<cfif len(attributes.FINISHDATE)>
			FINISHDATE,
			</cfif>
			PRICE,
			MONEY,
			UNIT_ID,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP
<!--- 			,STOCK_ID --->
			)
		VALUES
			(
			#R_ID#,
			#PID#,
			#attributes.STARTDATE#,
			<cfif len(attributes.FINISHDATE)>
			#attributes.FINISHDATE#,
			</cfif>
			#PRICE#,
			'#MONEY#',
			#GET_PRODUCT_UNIT.PRODUCT_UNIT_ID#, 
			#now()#,
			#session.ep.userid#,
			'#cgi.REMOTE_ADDR#'
<!--- 			,#attributes.STOCK_ID# --->
			)
	</cfquery>
 <cfelse>
	<script type="text/javascript">
	alert("<cf_get_lang no='48.Seçitiginiz Ürünün Birimi Uygun Değil'>!");	
	history.back();
	</script>
</cfif> 
<script type="text/javascript">
wrk_opener_reload();
window.close();	
</script>
