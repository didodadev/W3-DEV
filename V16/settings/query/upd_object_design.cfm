<cfquery name="upd_object_design" datasource="#dsn#">
	UPDATE
		MAIN_SITE_OBJECT_DESIGN
	SET
		DESIGN_NAME = '#attributes.design_name#',
		DESIGN_DETAIL = <cfif len(attributes.design_detail)>'#attributes.design_detail#'<cfelse>NULL</cfif>,
		DESIGN_PATH = '#attributes.design_path#',
		RECORD_EMP = #session.ep.userid#,
		RECORD_DATE = #now()#,
		RECORD_IP = '#CGI.REMOTE_ADDR#'
	WHERE
		DESIGN_ID = #attributes.design_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_upd_object_design&id=#attributes.design_id#" addtoken="no">
