<cfquery name="ADD_SERVICE_DEFECT_CODE" datasource="#dsn3#">
	INSERT INTO
		SETUP_SERVICE_CODE
	(
		SERVICE_CODE,
		SERVICE_CODE_DETAIL,
		RECORD_IP,
		RECORD_DATE,
		RECORD_EMP,
        PRODUCT_CAT
	)
	VALUES
	(
		'#attributes.service_code#',
		<cfif len(detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
		'#cgi.remote_addr#',
		#now()#,
		#session.ep.userid#,
        <cfif isdefined("attributes.cat_id") and len(attributes.cat_id)>#attributes.cat_id#<cfelse>NULL</cfif>
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_service_defect_code" addtoken="no">

