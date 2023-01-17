<cfif isdefined("form.help_id")>
	<cf_wrk_get_history datasource="#dsn#" source_table="HELP_DESK" target_table="HELP_DESK_HISTORY" record_id="#attributes.help_id#" record_name="HELP_ID">
	<cfif isdefined("session.ep.userid")>
		<cfset user_type = listgetat(session.ep.userkey,1,'-')>
		<cfquery name="UPD_HELP" datasource="#dsn#">
			UPDATE
				HELP_DESK
			SET
				HELP_HEAD = '#FORM.HELP_HEAD#',
				HELP_TOPIC = '#FORM.HELP_TOPIC#',
				HELP_CIRCUIT = '#attributes.modul_name#',
				HELP_FUSEACTION = '#attributes.faction#',
				IS_INTERNET = <cfif isdefined('form.is_internet')>1<cfelse>0</cfif>,
                IS_FAQ = <cfif isdefined('form.is_faq')>1<cfelse>0</cfif>,
				UPDATE_DATE = #NOW()#,
				UPDATE_MEMBER = '#USER_TYPE#',
				UPDATE_IP = '#CGI.REMOTE_ADDR#',
				UPDATE_ID = #SESSION.EP.USERID#,
				HELP_LANGUAGE = <cfif isDefined("attributes.help_language") and Len(attributes.help_language)>'#attributes.help_language#'<cfelse>'#session.ep.language#'</cfif>
			WHERE
				HELP_ID = #FORM.HELP_ID#
		</cfquery>
	<cfelse>
		<cfset user_type = listgetat(session.pp.userkey,1,'-')>
		<cfquery name="UPD_HELP" datasource="#dsn#">
			UPDATE
				HELP_DESK
			SET
				HELP_HEAD = '#FORM.HELP_HEAD#',
				HELP_TOPIC = '#FORM.HELP_TOPIC#',
				HELP_CIRCUIT = '#attributes.modul_name#',
				HELP_FUSEACTION = '#attributes.faction#',
				IS_INTERNET = <cfif isdefined('form.is_internet')>1<cfelse>0</cfif>,
				IS_FAQ = <cfif isdefined('form.is_faq')>1<cfelse>0</cfif>,
                UPDATE_DATE = #NOW()#,
				UPDATE_MEMBER = '#USER_TYPE#',
				UPDATE_IP = '#CGI.REMOTE_ADDR#',
				UPDATE_ID = #SESSION.PP.USERID#,
				HELP_LANGUAGE = <cfif isDefined("attributes.help_language") and Len(attributes.help_language)>'#attributes.help_language#'<cfelse>'#session.pp.language#'</cfif>
			WHERE 
				HELP_ID = #FORM.HELP_ID#
		</cfquery>
	</cfif>	
</cfif>
<cflocation addtoken="No" url="#request.self#?fuseaction=help.popup_view_help&help_id=#form.help_id#">
