<CFLOCK name="#CREATEUUID()#" timeout="20">
	<CFTRANSACTION>
		<cfquery name="ADD_PROBABILITY_RATE" datasource="#dsn3#">
			INSERT INTO 
				SETUP_PROBABILITY_RATE
				(
				PROBABILITY_RATE,
				PROBABILITY_NAME,
				RECORD_DATE,
				RECORD_EMP
				) 
			VALUES 
				(
				'#PROBABILITY_RATE#',
				'#PROBABILITY_NAME#',
				#now()#,
				#session.ep.userid#
				)
		</cfquery>
	</CFTRANSACTION>
</CFLOCK>
<cflocation url="#request.self#?fuseaction=settings.form_add_probability_rate" addtoken="no">
