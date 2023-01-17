<cfquery name="GET_MAX_CAMP_CAT_ID" datasource="#dsn3#">
	SELECT MAX(CAMP_CAT_ID) as MAX_CAMP_CAT_ID FROM CAMPAIGN_CATS
</cfquery>
<cfif IsNumeric(GET_MAX_CAMP_CAT_ID.MAX_CAMP_CAT_ID) AND GET_MAX_CAMP_CAT_ID.MAX_CAMP_CAT_ID GTE 0>
	<cfset camp_sayi = GET_MAX_CAMP_CAT_ID.MAX_CAMP_CAT_ID + 1>
<cfelse>
	<cfset camp_sayi = 1>
</cfif>
<cfquery name="ADD_CAMP_CAT" datasource="#dsn3#">
	INSERT 
	INTO 
		CAMPAIGN_CATS
	(
		CAMP_CAT_ID,
		CAMP_CAT_NAME,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP,
		CAMP_TYPE
	) 
	VALUES 
	(
		#camp_sayi#, 
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.camp_cat_name#">,
		#now()#,
		#session.ep.userid#,
		'#cgi.remote_addr#',
		#attributes.camp_type#
	)
</cfquery>
<script>
	location.href= document.referrer;
</script>
