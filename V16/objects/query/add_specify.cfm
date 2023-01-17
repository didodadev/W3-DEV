
<cfquery name="ADD_SPECIFY" datasource="#dsn3#">
	INSERT INTO
 		SERVICE_GUARANTY_NEW
	(
		STOCK_ID,
		SERIAL_NO,
		PROCESS_CAT,
		<cfif attributes.type eq 1191>PURCHASE_COMPANY_ID<cfelse>SALE_COMPANY_ID</cfif>,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP
	)
	VALUES
	(
		#attributes.stock_id#,
		'#attributes.serial_no#',
		#attributes.type#,
		<cfif len(attributes.company_id_1)>#attributes.company_id_1#<cfelse>NULL</cfif>,
		#NOW()#,
		#SESSION.EP.USERID#,
		'#CGI.REMOTE_ADDR#'	
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=objects.serial_no&event=det&product_serial_no=#attributes.serial_no#&seri_stock_id=#attributes.stock_id#&rma_no=" addtoken="no">
