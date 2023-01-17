<!--- kurumsal-bireysel-sistem ilişki üye tipleri için ortak sayfadır--->
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfif attributes.relation_type_info eq 1><!--- kurumsal üyeler --->
			<cfquery name="del_PARTNER_REL" datasource="#dsn#">
				DELETE FROM
					SETUP_PARTNER_RELATION
				WHERE
					PARTNER_RELATION_ID = #attributes.partner_relation_id#
			</cfquery>
		<cfelseif attributes.relation_type_info eq 2><!--- bireysel üyeler --->
			<cfquery name="del_PARTNER_REL" datasource="#dsn#">
				DELETE FROM
					SETUP_CONSUMER_RELATION
				WHERE
					CONSUMER_RELATION_ID = #attributes.partner_relation_id#
			</cfquery>
		<cfelseif attributes.relation_type_info eq 3><!--- sistemler --->
			<cfquery name="del_PARTNER_REL" datasource="#dsn#">
				DELETE FROM
					SETUP_SUBSCRIPTION_RELATION
				WHERE
					SUBSCRIPTION_RELATION_ID = #attributes.partner_relation_id#
			</cfquery>
		</cfif>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.form_add_partner_relation&relation_type_info=#attributes.relation_type_info#" addtoken="no">
