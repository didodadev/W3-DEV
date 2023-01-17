<cfquery name="INS_TARGET_CAT" datasource="#dsn#">
	INSERT INTO 
		TARGET_CAT
	(
		TARGETCAT_NAME,
		DETAIL,
		TARGETCAT_WEIGHT,
		RECORD_IP,
		RECORD_DATE,
		RECORD_EMP
	) 
	VALUES 
	(
		'#attributes.targetcat_name#',
		'#attributes.targetcat_detail#',
		<cfif isdefined("attributes.targetcat_weight") and len(attributes.targetcat_weight)>#attributes.targetcat_weight#<cfelse>NULL</cfif>,
		'#cgi.remote_addr#',
		#now()#,
		#session.ep.userid#
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_target_cat" addtoken="no">
