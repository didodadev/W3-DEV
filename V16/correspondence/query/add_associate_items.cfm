<cfsetting showdebugoutput="no">
<cfif len(attributes.project_id)>
	<cfquery name="add_associate" datasource="#DSN#">
		INSERT INTO
			MAILS_RELATION
			(
				MAIL_ID,
				RELATION_TYPE,
				RELATION_TYPE_ID
			)
			VALUES
			(
				#attributes.mail_id#,
				'PROJECT_ID',
				'#attributes.project_id#'
			)
	</cfquery>
</cfif>
<cfif len(attributes.company_id)>
	<cfquery name="add_associate" datasource="#DSN#">
		INSERT INTO
			MAILS_RELATION
			(
				MAIL_ID,
				RELATION_TYPE,
				RELATION_TYPE_ID
			)
			VALUES
			(
				#attributes.mail_id#,
				'COMPANY_ID',
				'#attributes.company_id#'
			)
	</cfquery>
</cfif>
<cfif len(attributes.consumer_id2)>
	<cfquery name="add_associate" datasource="#DSN#">
		INSERT INTO
			MAILS_RELATION
			(
				MAIL_ID,
				RELATION_TYPE,
				RELATION_TYPE_ID
			)
			VALUES
			(
				#attributes.mail_id#,
				'CONSUMER_ID',
				'#attributes.consumer_id2#'
			)
	</cfquery>
</cfif>
<cfif len(attributes.offer_id)>
	<cfquery name="add_associate" datasource="#DSN#">
		INSERT INTO
			MAILS_RELATION
			(
				MAIL_ID,
				RELATION_TYPE,
				RELATION_TYPE_ID,
                OUR_COMPANY_ID
			)
			VALUES
			(
				#attributes.mail_id#,
				'OFFER_ID',
				'#attributes.offer_id#',
                #session.ep.company_id#
			)
	</cfquery>
</cfif>
<cflocation url="#request.self#?fuseaction=correspondence.cubemail" addtoken="No">
