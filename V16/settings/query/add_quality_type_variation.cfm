<cfquery name="ADD_QUALITY_TYPE_VARIATION" datasource="#DSN3#">
INSERT 
INTO
	QUALITY_CONTROL_ROW
	(
		QUALITY_CONTROL_ROW,
		QUALITY_CONTROL_TYPE_ID,
		TOLERANCE,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP
	)
	VALUES
	(
		'#ATTRIBUTES.QUALITY_CONTROL_ROW#',
		 #ATTRIBUTES.QUALITY_CONTROL_TYPE_ID#,
		 <cfif len(ATTRIBUTES.TOLERANCE)>'#ATTRIBUTES.TOLERANCE#',<cfelse>NULL,</cfif>
		 #NOW()#,
		 #SESSION.EP.USERID#,
		 '#CGI.REMOTE_ADDR#'
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_quality_type_variation" addtoken="no">
