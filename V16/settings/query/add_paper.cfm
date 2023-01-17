<cfquery name="del_paper" datasource="#dsn3#">
	DELETE FROM PAPERS_NO WHERE EMPLOYEE_ID = #attributes.form_emp_id#
</cfquery>
<cfquery name="ADD_PAPER" datasource="#dsn3#">
INSERT INTO 
	PAPERS_NO 
	(
	   REVENUE_RECEIPT_NO,
	   REVENUE_RECEIPT_NUMBER,
	   INVOICE_NO,
	   INVOICE_NUMBER,
	   SHIP_NO,
	   SHIP_NUMBER,					   
	   EMPLOYEE_ID
	)
	VALUES     
	(
		'#FORM.REVENUE_RECEIPT_NO#',
		<cfif len(FORM.REVENUE_RECEIPT_NUMBER)>#FORM.REVENUE_RECEIPT_NUMBER#<cfelse>NULL</cfif>,
		'#FORM.INVOICE_NO#',
		<cfif len(FORM.INVOICE_NUMBER)>#FORM.INVOICE_NUMBER#<cfelse>NULL</cfif>,
		'#FORM.SHIP_NO#',
		<cfif len(FORM.SHIP_NUMBER)>#FORM.SHIP_NUMBER#<cfelse>NULL</cfif>,
		#attributes.form_emp_id#
	)
</cfquery>
<cflocation url="#cgi.referer#" addtoken="no">
