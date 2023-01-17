<!--- kurumsal-bireysel-sistem ilişki üye tipleri için ortak sayfadır--->
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfif attributes.relation_type_info eq 1><!--- kurumsal üyeler --->
			<cfquery name="UPD_REL" datasource="#dsn#">
				UPDATE
					SETUP_PARTNER_RELATION
				SET
					PARTNER_RELATION = '#attributes.partner_relation#',
					DETAIL = '#attributes.detail#',
					UPDATE_DATE = #now()#,
					UPDATE_IP = '#cgi.remote_addr#',
					UPDATE_EMP = #session.ep.userid#
				WHERE
					PARTNER_RELATION_ID = #attributes.partner_relation_id#
			</cfquery>
		<cfelseif attributes.relation_type_info eq 2><!--- bireysel üyeler --->
			<cfquery name="UPD_REL" datasource="#dsn#">
				UPDATE
					SETUP_CONSUMER_RELATION
				SET
					CONSUMER_RELATION = '#attributes.partner_relation#',
					CONSUMER_RELATION_DETAIL = '#attributes.detail#',
					UPDATE_DATE = #now()#,
					UPDATE_IP = '#cgi.remote_addr#',
					UPDATE_EMP = #session.ep.userid#
				WHERE
					CONSUMER_RELATION_ID = #attributes.partner_relation_id#
			</cfquery>
		<cfelseif attributes.relation_type_info eq 3><!--- sistemler --->
			<cfquery name="UPD_REL" datasource="#dsn#">
				UPDATE
					SETUP_SUBSCRIPTION_RELATION
				SET
					SUBSCRIPTION_RELATION = '#attributes.partner_relation#',
					DETAIL = '#attributes.detail#',
					UPDATE_DATE = #now()#,
					UPDATE_IP = '#cgi.remote_addr#',
					UPDATE_EMP = #session.ep.userid#
				WHERE
					SUBSCRIPTION_RELATION_ID = #attributes.partner_relation_id#
			</cfquery>
		</cfif>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.form_add_partner_relation&relation_type_info=#attributes.relation_type_info#" addtoken="no">
