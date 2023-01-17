<cfif isdefined("form.help_head")>
	<cfif isdefined("session.ep.userid")>
		<cfset user_type = listgetat(session.ep.userkey,1,'-')>
		<cfquery name="ADD_HELP" datasource="#dsn#">
			INSERT INTO 
				HELP_DESK
			(
				HELP_CIRCUIT,
				HELP_FUSEACTION,
				HELP_HEAD,
				HELP_TOPIC,
				IS_INTERNET,
                IS_FAQ,
				RECORD_DATE,
				RECORD_MEMBER,
				RECORD_IP,
				RECORD_ID,
				RELATION_HELP_ID,
				HELP_LANGUAGE
			)
			VALUES
			(
				<cfif isdefined('attributes.modul_name') and len(attributes.modul_name)>'#attributes.modul_name#'</cfif>,
				<cfif isdefined('attributes.faction') and len(attributes.faction)>'#attributes.faction#'</cfif>,
				'#form.HELP_HEAD#',
				'#form.HELP_TOPIC#',
				<cfif isdefined('form.is_internet')>1<cfelse>0</cfif>,
                <cfif isdefined('form.is_faq')>1<cfelse>0</cfif>,
				#NOW()#,
				'#USER_TYPE#',
				'#CGI.REMOTE_ADDR#',
				#SESSION.EP.USERID#,
				<cfif isDefined("attributes.relation_help_id") and Len(attributes.relation_help_id)>#attributes.relation_help_id#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.help_language") and Len(attributes.help_language)>'#attributes.help_language#'<cfelse>'#session.ep.language#'</cfif>
			)			
		</cfquery>
	<cfelse>
		<cfset user_type = listgetat(session.pp.userkey,1,'-')>
		<cfquery name="ADD_HELP" datasource="#dsn#">
			INSERT INTO 
				HELP_DESK
			(
				HELP_CIRCUIT,
				HELP_FUSEACTION,
				HELP_HEAD,
				HELP_TOPIC,
				IS_INTERNET,
				IS_FAQ,
				RECORD_DATE,
				RECORD_MEMBER,
				RECORD_IP,
				RECORD_ID,
				RELATION_HELP_ID,
				HELP_LANGUAGE
			)
			VALUES
			(
				'#FORM.CIRCUIT_#',
				'#FORM.FUSEACTION_#',
				'#FORM.HELP_HEAD#',
				'#FORM.HELP_TOPIC#',
				<cfif isdefined('form.is_internet')>1<cfelse>0</cfif>,
				<cfif isdefined('form.is_faq')>1<cfelse>0</cfif>,
				#NOW()#,
				'#USER_TYPE#',
				'#CGI.REMOTE_ADDR#',
				#SESSION.PP.USERID#,
				<cfif isDefined("attributes.relation_help_id") and Len(attributes.relation_help_id)>#attributes.relation_help_id#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.help_language") and Len(attributes.help_language)>'#attributes.help_language#'<cfelse>'#session.pp.language#'</cfif>
				)			
		</cfquery>
	</cfif>
</cfif>
<cflocation addtoken="No" url="#request.self#?fuseaction=help.popup_list_helpdesk">
