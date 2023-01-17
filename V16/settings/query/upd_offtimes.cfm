<cf_date tarih="attributes.startdate">
<cf_date tarih="attributes.finishdate">

<cfquery name="UPD_OFFTIMES" datasource="#DSN#">
	UPDATE 
		<cfif fusebox.circuit eq 'settings'>SETUP_GENERAL_OFFTIMES<cfelse>SETUP_GENERAL_OFFTIMES_SATURDAY</cfif>
	SET
		OFFTIME_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.offtime_name#">,
		START_DATE = #attributes.startdate#,
		FINISH_DATE = #attributes.finishdate#,
		IS_HALFOFFTIME = <cfif isdefined('attributes.is_halfofftime')>1<cfelse>0</cfif>,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#	 
	WHERE
		OFFTIME_ID   = #attributes.offtime_id#
</cfquery>
<script>
	location.href = document.referrer;
</script>