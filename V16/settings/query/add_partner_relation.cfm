<!--- kurumsal-bireysel-sistem ilişki üye tipleri için ortak sayfadır--->
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfif attributes.relation_type_info eq 1><!--- kurumsal üyeler --->
			<cfquery name="ADD_RELATION" datasource="#dsn#">
				INSERT INTO
					SETUP_PARTNER_RELATION
					(
						PARTNER_RELATION,
						DETAIL,
						RECORD_DATE,
						RECORD_IP,
						RECORD_EMP
					)
				VALUES
					(
						'#attributes.partner_relation#',
						<cfif len(attributes.detail)>'#attributes.detail#',<cfelse>NULL,</cfif>
						#now()#,
						'#cgi.remote_addr#',
						#session.ep.userid#
					)
			</cfquery>
		<cfelseif attributes.relation_type_info eq 2><!--- bireysel üyeler --->
			<cfquery name="ADD_RELATION" datasource="#dsn#">
				INSERT INTO
					SETUP_CONSUMER_RELATION
					(
						CONSUMER_RELATION,
						CONSUMER_RELATION_DETAIL,
						RECORD_DATE,
						RECORD_IP,
						RECORD_EMP
					)
				VALUES
					(
						'#attributes.partner_relation#',
						<cfif len(attributes.detail)>'#attributes.detail#',<cfelse>NULL,</cfif>
						#now()#,
						'#cgi.remote_addr#',
						#session.ep.userid#
					)
			</cfquery>
		<cfelseif attributes.relation_type_info eq 3><!--- sistemler --->
			<cfquery name="ADD_RELATION" datasource="#dsn#">
				INSERT INTO
					SETUP_SUBSCRIPTION_RELATION
					(
						SUBSCRIPTION_RELATION,
						DETAIL,
						RECORD_DATE,
						RECORD_IP,
						RECORD_EMP
					)
				VALUES
					(
						'#attributes.partner_relation#',
						<cfif len(attributes.detail)>'#attributes.detail#',<cfelse>NULL,</cfif>
						#now()#,
						'#cgi.remote_addr#',
						#session.ep.userid#
					)
			</cfquery>
		</cfif>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.form_add_partner_relation&relation_type_info=#attributes.relation_type_info#" addtoken="no">
