<cflock timeout="60">
	<cftransaction>
		<cfquery name="UPD_PROFITABILITY_CAT" datasource="#DSN#">
			UPDATE 
				SETUP_PROFITABILITY_CAT 
			SET 
				PROFITABILITY_CAT = '#attributes.profitability_cat#',
				DETAIL = '#attributes.detail#',
				UPDATE_IP = '#cgi.remote_addr#',
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#	 
			WHERE 
				PROFITABILITY_CAT_ID = #attributes.profitability_cat_id#
		</cfquery>
		<cfif (attributes.profitability_cat is not attributes.old_profitability_cat) or (attributes.detail is not attributes.old_detail)>
			<cfquery name="add_setup_profitabillity_cat" datasource="#dsn#">
				INSERT INTO
					SETUP_PROFITABILITY_CAT_HISTORY
				(
					PROFITABILITY_CAT_ID,
					PROFITABILITY_CAT,
					DETAIL,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
				)
				VALUES
				(
					#attributes.profitability_cat_id#,
					'#attributes.old_profitability_cat#',
					'#attributes.old_detail#',
					#now()#,
					#session.ep.userid#,
					'#cgi.remote_addr#'
				)
			</cfquery>
		</cfif>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.add_profitability_cat" addtoken="no">
