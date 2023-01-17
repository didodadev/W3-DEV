<cfquery name="UPDEVENTCAT" datasource="#DSN#">
	UPDATE 
		EVENT_CAT 
	SET 
		EVENTCAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.eventcat#">,
		COLOUR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.colour#">,
		IS_VIP= <cfif isDefined("attributes.is_vip")>1<cfelse>0</cfif>,
		IS_RD_SSK = <cfif isDefined("attributes.is_rd_ssk") and len(attributes.is_rd_ssk)>1<cfelse>0</cfif>,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#	 
	WHERE 
		EVENTCAT_ID = #attributes.eventcat_id#
</cfquery>
<script>
	location.href=document.referrer;
</script>
