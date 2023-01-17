<cfscript>
	attributes.customer_sale_start= filterNum(attributes.customer_sale_start);
	attributes.customer_sale_finish= filterNum(attributes.customer_sale_finish);
</cfscript>
<cfquery name="UPD_CUSTOMER_VALUE" datasource="#dsn#">
	UPDATE 
		SETUP_CUSTOMER_VALUE
	SET 
		CUSTOMER_VALUE='#customer_value#',	
		DETAIL=<cfif isDefined("attributes.detail") and len(attributes.detail)>'#detail#',<cfelse>null,</cfif>
		CUSTOMER_SALE_START=<cfif isDefined("attributes.customer_sale_start") and len(attributes.customer_sale_start)>#attributes.customer_sale_start#<cfelse>NULL</cfif>,
		CUSTOMER_SALE_FINISH=<cfif isDefined("attributes.customer_sale_finish") and len(attributes.customer_sale_finish)>#attributes.customer_sale_finish#<cfelse>NULL</cfif>,
		UPDATE_DATE = #NOW()#,
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#'
	WHERE 
		CUSTOMER_VALUE_ID=#TYPE_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_customer_value" addtoken="no">
