<cflock name="#createUUID()#" timeout="60">			
	<cftransaction>
		<cfquery name="UPD_STOCKBOND_TYPES" datasource="#dsn#">
			UPDATE 
				SETUP_STOCKBOND_TYPE
			SET 
				STOCKBOND_TYPE = '#attributes.stockbond_type#' ,
				DETAIL = <cfif len(attributes.detail)>'#attributes.detail#',<cfelse>NULL,</cfif>
				UPDATE_IP = '#CGI.REMOTE_ADDR#',
				UPDATE_DATE = #NOW()#,
				UPDATE_EMP = #SESSION.EP.USERID#
			WHERE 
				STOCKBOND_TYPE_ID = #stockbond_type_id#
		</cfquery>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.form_add_stockbond_type" addtoken="no">
