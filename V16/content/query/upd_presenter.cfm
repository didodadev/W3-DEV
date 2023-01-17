<cfquery name="upd_presenter" datasource="#dsn#">
	UPDATE
		PRESENTATION
	SET
		PRESENTATION_TITLE = '#attributes.prisentation_title#',
		PRESENTER_EMP = <cfif isdefined('attributes.presenter_emp') and len(attributes.presenter_emp) and len(attributes.presenter_name)>#attributes.presenter_emp#,<cfelse>NULL,</cfif>
		PRESENTER_PAR = <cfif isdefined('attributes.presenter_par') and len(attributes.presenter_par) and len(attributes.presenter_name)>#attributes.presenter_par#,<cfelse>NULL,</cfif>
		PRESENTER_CONS = <cfif isdefined('attributes.presenter_cons') and len(attributes.presenter_cons) and len(attributes.presenter_name)>#attributes.presenter_cons#,<cfelse>NULL,</cfif>
		PRESENTER_BIOGRAPHI = <cfif isdefined('attributes.presenter_bio') and len(attributes.presenter_bio)>'#attributes.presenter_bio#',<cfelse>NULL,</cfif>
		BACKGROUND_COLOR = <cfif isdefined('attributes.background_color') and len(attributes.background_color)>'#attributes.background_color#',<cfelse>NULL,</cfif>
		UPDATE_DATE = #now()#,
		UPDATE_IP = '#CGI.remote_addr#'
	WHERE
		PRESENTATION_ID = #attributes.presentation_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=content.form_upd_presenter&presentation_id=#attributes.presentation_id#" addtoken="no">
