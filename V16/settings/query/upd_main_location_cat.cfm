<cflock timeout="60">
	<cftransaction>
		<cfquery name="UPD_MAIN_LOCATION_CAT" datasource="#DSN#">
			UPDATE 
				SETUP_MAIN_LOCATION_CAT
			SET 
				MAIN_LOCATION_CAT = '#attributes.main_location_cat#',
				DETAIL = '#attributes.detail#',
				UPDATE_IP = '#cgi.remote_addr#',
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#
			WHERE 
				MAIN_LOCATION_CAT_ID = #attributes.main_location_cat_id#
		</cfquery>
		<cfif (attributes.main_location_cat is not attributes.old_main_location_cat) or (attributes.detail is not attributes.old_detail)>
			<cfquery name="add_main_location_cat_history" datasource="#dsn#">
				INSERT INTO
					SETUP_MAIN_LOCATION_CAT_HISTORY
				(
					MAIN_LOCATION_CAT_ID,
					MAIN_LOCATION_CAT,
					DETAIL,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
				)
				VALUES
				(
					#attributes.main_location_cat_id#,
					'#attributes.old_main_location_cat#',
					'#attributes.old_detail#',
					#now()#,
					#session.ep.userid#,
					'#cgi.remote_addr#'
				)
			</cfquery>
		</cfif>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.add_main_location_cat" addtoken="no">
