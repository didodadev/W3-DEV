<cflock timeout="60">
	<cftransaction>
		<cfquery name="UPD_SPECIAL_STATE_CAT" datasource="#DSN#">
			UPDATE 
				SETUP_SPECIAL_STATE_CAT 
			SET 
				SPECIAL_STATE_CAT = '#attributes.special_state_cat#',
				DETAIL = '#attributes.detail#',
				UPDATE_IP = '#cgi.remote_addr#',
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#	 
			WHERE 
				SPECIAL_STATE_CAT_ID = #attributes.special_state_cat_id#
		</cfquery>
		<cfif (attributes.special_state_cat is not attributes.old_special_state_cat) or (attributes.detail is not attributes.old_detail)>
			<cfquery name="add_setup_sepecial_state_cat" datasource="#DSN#">
				INSERT INTO
					SETUP_SPECIAL_STATE_CAT_HISTORY
				(
					SPECIAL_STATE_CAT_ID,
					SPECIAL_STATE_CAT,
					DETAIL,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
				)
				VALUES
				(
					#attributes.special_state_cat_id#,
					'#attributes.old_special_state_cat#',
					'#attributes.old_detail#',
					#now()#,
					#session.ep.userid#,
					'#cgi.remote_addr#'
				)
			</cfquery>
		</cfif>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.add_special_state_cat" addtoken="no">
