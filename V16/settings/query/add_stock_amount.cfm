<cfquery name="ADD_STOCK_AMOUNT" datasource="#DSN#">
	INSERT INTO
		SETUP_STOCK_AMOUNT
	(
		STOCK_NAME,
		DETAIL,
		RECORD_IP,
		RECORD_DATE,
		RECORD_EMP
	)
	VALUES
	(
		'#attributes.stock_name#',
		<cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
		'#cgi.remote_addr#',
		#now()#,
		#session.ep.userid#
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_stock_amount" addtoken="no">
