<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT 
		PROCESS_TYPE,
		PROCESS_CAT_ID,
        DOCUMENT_TYPE,
        PAYMENT_TYPE
	FROM 
	 	SETUP_PROCESS_CAT 
	WHERE 
    	1=1
        <cfif len(form.process_cat)>
        	AND PROCESS_CAT_ID = #form.process_cat#
        </cfif>
		
</cfquery>
<cfscript>
	acc_process_cat = form.PROCESS_CAT;
	acc_process_type = get_process_type.PROCESS_TYPE;
</cfscript>

