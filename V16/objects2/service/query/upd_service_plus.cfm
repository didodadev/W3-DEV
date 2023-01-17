<cfif len(form.plus_date)>
	<cf_date tarih="attributes.plus_date">
</cfif>

<cfquery name="UPD_SERVICE_PLUS" datasource="#DSN3#">
	UPDATE 
		SERVICE_PLUS 
	SET 
		<cfif isdefined("header")>
            SUBJECT = '#header#',
        </cfif>
        <cfif len(form.plus_date)>
            PLUS_DATE = #attributes.plus_date#,
        <cfelse>
            PLUS_DATE = NULL,
        </cfif>
		COMMETHOD_ID = <cfif len(form.commethod_id)>#form.commethod_id#<cfelse>NULL</cfif>,	
		PLUS_CONTENT = '#form.plus_content#',
		UPDATE_DATE = #now()#,
		UPDATE_PAR = #session.pp.userid#,
		UPDATE_IP = '#cgi.REMOTE_ADDR#'
	WHERE 
		SERVICE_PLUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.service_plus_id#">
</cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
