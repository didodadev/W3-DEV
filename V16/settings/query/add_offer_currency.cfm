<CFLOCK name="#CREATEUUID()#" timeout="20">
	<CFTRANSACTION>
		<cfquery name="get_max" datasource="#dsn3#">
			SELECT
				MAX(OFFER_CURRENCY_ID) AS MAX_ID
			FROM
				OFFER_CURRENCY
		</cfquery>
		<cfquery name="INSOFFER_CURRENCY" datasource="#dsn3#">
			INSERT INTO 
				OFFER_CURRENCY
				(
				OFFER_CURRENCY_ID,
				OFFER_CURRENCY,
				RECORD_DATE,
				RECORD_EMP
				) 
			VALUES 
				(
				#get_max.MAX_ID+1#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#OFFER_CURRENCY#">,
				#now()#,
				#session.ep.userid#
				)
		</cfquery>
	</CFTRANSACTION>
</CFLOCK>
<cflocation url="#request.self#?fuseaction=settings.form_add_offer_currency" addtoken="no">
