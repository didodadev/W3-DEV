<cfscript>
	attributes.customer_sale_start= filterNum(attributes.customer_sale_start);
	attributes.customer_sale_finish= filterNum(attributes.customer_sale_finish);
</cfscript>
<cfquery name="ADD_CUSTOMER_VALUE" datasource="#dsn#">
	INSERT INTO 
		SETUP_CUSTOMER_VALUE
		(
			CUSTOMER_VALUE,
			DETAIL,
			CUSTOMER_SALE_START,
			CUSTOMER_SALE_FINISH,
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP
		) 
		VALUES 
		(
			'#customer_value#',
			<cfif isDefined("attributes.detail") and len(attributes.detail)>'#DETAIL#',<cfelse>NULL,</cfif>
			<cfif isdefined("attributes.customer_sale_start") and len(attributes.customer_sale_start)>#attributes.customer_sale_start#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.customer_sale_finish") and len(attributes.customer_sale_finish)>#attributes.customer_sale_finish#<cfelse>NULL</cfif>,
			#SESSION.EP.USERID#,
			#NOW()#,
			'#CGI.REMOTE_ADDR#'
		)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_customer_value" addtoken="no">
