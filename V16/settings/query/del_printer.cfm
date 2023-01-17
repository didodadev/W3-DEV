<cfquery name="DELPRINTER" datasource="#dsn#">
	DELETE FROM
	     SETUP_PRINTER
	WHERE 
	     PRINTER_ID=#attributes.PRINTER_ID#
</cfquery>
<cfquery name="DELPRINTER_USERS" datasource="#dsn#">
	DELETE FROM
	     SETUP_PRINTER_USERS
	WHERE 
	     PRINTER_ID=#attributes.PRINTER_ID#
</cfquery>
<cfquery name="get_company" datasource="#dsn#">
	SELECT COMPANY_NAME,COMP_ID FROM OUR_COMPANY
</cfquery>
<cfoutput query="get_company">
	<cfset new_dsn3 = '#dsn#_#comp_id#'>
	<cfquery name="delete_paper" datasource="#dsn#">
		DELETE FROM #new_dsn3#.PAPERS_NO WHERE PRINTER_ID = #attributes.PRINTER_ID#
	</cfquery>		
</cfoutput>
<cflocation url="#request.self#?fuseaction=settings.form_add_printer" addtoken="no">
