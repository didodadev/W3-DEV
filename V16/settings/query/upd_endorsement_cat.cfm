<cflock timeout="60">
	<cftransaction>
		<cfquery name="UPD_SETUP_ENDORSEMENT_CAT" datasource="#DSN#">
			UPDATE 
				SETUP_ENDORSEMENT_CAT 
			SET 
				ENDORSEMENT_CAT = '#attributes.endorsement_cat#',
				DETAIL = '#attributes.detail#',
				UPDATE_IP = '#cgi.remote_addr#',
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#
			WHERE 
				ENDORSEMENT_CAT_ID = #attributes.endorsement_cat_id#
		</cfquery>
		<cfif (attributes.old_endorsement_cat is not attributes.endorsement_cat) or (attributes.detail is not attributes.old_detail)>
			<cfquery name="add_setup_endorsement_cat" datasource="#dsn#">
				INSERT INTO
					SETUP_ENDORSEMENT_CAT_HISTORY
				(
					ENDORSEMENT_CAT_ID,
					ENDORSEMENT_CAT,
					DETAIL,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
				)
				VALUES
				(
					#attributes.endorsement_cat_id#,
					'#attributes.old_endorsement_cat#',
					'#attributes.old_detail#',
					#now()#,
					#session.ep.userid#,
					'#cgi.remote_addr#'
				)
			</cfquery>
		</cfif>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.add_endorsement_cat" addtoken="no">
