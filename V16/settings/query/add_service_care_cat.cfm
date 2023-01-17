<cfquery NAME="ADD_SERVICE_CARE_CAT" DATASOURCE="#DSN3#">
	INSERT INTO
		SERVICE_CARE_CAT
		(
			SERVICE_CARE,
			DETAIL,
			RECORD_IP,
			RECORD_DATE,
			RECORD_EMP
		)
			VALUES
		(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.SERVICE_CAT#">,
			<cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.DETAIL#"><cfelse>NULL</cfif>,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
			#now()#,
			#session.ep.userid#
		)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_service_care_cat" addtoken="no">

