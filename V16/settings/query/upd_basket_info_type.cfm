<cfquery name="UPD_PUNISHMENT_TYPE" datasource="#DSN3#">
	UPDATE 
		SETUP_BASKET_INFO_TYPES
	SET 
		BASKET_INFO_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.extra_info_type#">,
		OPTION_NUMBER = <cfif isDefined("attributes.option_number") and Len(attributes.option_number)>#attributes.option_number#<cfelse></cfif>,
        BASKET_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_detail#">,
		BASKET_ID = <cfif len(attributes.basket_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_id#"><cfelse>NULL</cfif>,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
	WHERE 
		BASKET_INFO_TYPE_ID = #attributes.basket_info_type_id#
</cfquery>
<script>
	location.href = document.referrer;
</script>