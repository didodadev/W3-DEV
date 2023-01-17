<cfquery name="UPD_STOCK_AMOUNT" datasource="#DSN#">
	UPDATE
		SETUP_STOCK_AMOUNT
	SET
		STOCK_NAME = '#attributes.stock_name#',
		DETAIL = <cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#	 
	WHERE
		STOCK_ID = #attributes.stock_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_stock_amount" addtoken="no">
