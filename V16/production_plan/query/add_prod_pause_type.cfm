<cfquery name="add_prod_pause_type" datasource="#dsn3#" result="MAX_ID">
	INSERT INTO
		SETUP_PROD_PAUSE_TYPE
	(
		PROD_PAUSE_CAT_ID,
		PROD_PAUSE_TYPE_CODE,
		PROD_PAUSE_TYPE,
		PAUSE_DETAIL,
		IS_ACTIVE,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP
	)
	VALUES
	(
		<cfif isdefined("attributes.pauseCat") and len(attributes.pauseCat)>#attributes.pauseCat#<cfelse>NULL</cfif>,
		'#attributes.pauseType_code#',
		'#attributes.pauseType#',
		<cfif isdefined("attributes.detail") and len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.is_active") and len(attributes.is_active)>1<cfelse>0</cfif>,
		#now()#,
		#session.ep.userid#,
		'#cgi.remote_addr#'	
	)
</cfquery>
<cfif isDefined("attributes.productCat") and len(attributes.productCat)>
	<!--- Iliskili Urun Kategorileri --->
	<cfloop list="#attributes.productCat#" index="CAT">
		<cfquery name="Add_Product_catid" datasource="#dsn3#">
			INSERT INTO
				SETUP_PROD_PAUSE_TYPE_ROW
			(
				PROD_PAUSE_PRODUCTCAT_ID,
				PROD_PAUSE_TYPE_ID
			)
			VALUES
			(
				#cat#,
				#MAX_ID.generatedkey#
			)
		</cfquery>
	</cfloop>
</cfif>
<!---<script type="text/javascript">
	wrk_opener_reload();
	window.close();	
</script>--->
<script type="text/javascript">	
	window.location.href='<cfoutput>#request.self#?fuseaction=prod.list_prod_pause_type</cfoutput>';
</script>
