<cfquery name="UPD_RISK_SEGMANTATION" datasource="#DSN#">
	UPDATE
		SETUP_RISK_SEGMANTATION
	SET
		SEGMANTATION = '#attributes.segmentation#',
		MIN_LIMIT =  #attributes.min_limit#,
		MAX_LIMIT = #attributes.max_limit#,
		UPDATE_EMP =  #session.ep.userid#,
		UPDATE_DATE = #now()#,
		UPDATE_IP = '#cgi.remote_addr#'
	WHERE
		SEGMANTATION_ID = #attributes.id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_risk_segmantation" addtoken="no">
