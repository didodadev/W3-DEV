<cflock timeout="60">
	<cftransaction>
		<cfquery name="UPD_RISK_CAT" datasource="#DSN#">
			UPDATE 
				SETUP_RISK_CAT 
			SET 
				RISK_CAT = '#attributes.risk_cat#',
				DETAIL = '#attributes.detail#',
				UPDATE_IP = '#cgi.remote_addr#', 
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#	 
			WHERE 
				RISK_CAT_ID = #attributes.risk_cat_id#
		</cfquery>
		<cfif (attributes.old_risk_cat is not attributes.risk_cat) or (attributes.old_detail is not attributes.detail)>
			<cfquery name="add_risk_cat_history" datasource="#dsn#">
				INSERT INTO
					SETUP_RISK_CAT_HISTORY
				(
					RISK_CAT_ID,
					RISK_CAT,
					DETAIL,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
				)
				VALUES
				(
					#attributes.risk_cat_id#,
					'#attributes.old_risk_cat#',
					'#attributes.old_detail#',
					#now()#,
					#session.ep.userid#,
					'#cgi.remote_addr#'
				)
			</cfquery>
		</cfif>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.add_risk_cat" addtoken="no">
