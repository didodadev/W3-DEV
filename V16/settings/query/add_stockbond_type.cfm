<cflock name="#createUUID()#" timeout="60">			
	<cftransaction>
		<cfquery name="ADD_STOCKBOND_TYPE" datasource="#dsn#">
			INSERT INTO 
				SETUP_STOCKBOND_TYPE
				(
					STOCKBOND_TYPE,
					DETAIL,
					RECORD_IP,
					RECORD_DATE,
					RECORD_EMP
				) 
			VALUES 
				(
					'#attributes.stockbond_type#',
					'#left(attributes.detail,150)#',
					'#CGI.REMOTE_ADDR#',
					#NOW()#,
					#SESSION.EP.USERID#
				)
		</cfquery>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.form_add_stockbond_type" addtoken="no">
