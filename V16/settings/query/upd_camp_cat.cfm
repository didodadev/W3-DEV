<cfquery name="UPD_CAMP_CAT" datasource="#dsn3#">
	UPDATE 
		CAMPAIGN_CATS 
	SET 
		CAMP_CAT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#camp_cat_name#">,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_DATE = #now()#,
		UPDATE_IP = '#cgi.rempte_addr#',
		CAMP_TYPE = #attributes.camp_type#
	WHERE 
		CAMP_CAT_ID = #attributes.camp_cat_id#
</cfquery>
<script>
	location.href= document.referrer;
</script>
