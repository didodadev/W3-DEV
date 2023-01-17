<cfscript>
	attributes.forward_sale_limit= filterNum(attributes.forward_sale_limit);
</cfscript>
<cfquery name="UPD_VOCATION_TYPE" datasource="#dsn#">
	UPDATE 
		SETUP_VOCATION_TYPE
	SET 
		VOCATION_TYPE='#vocation_type#',	
		DETAIL=<cfif isDefined("attributes.detail") and len(attributes.detail)>'#detail#'<cfelse>NULL</cfif>,
		FORWARD_SALE_LIMIT=<cfif isDefined("attributes.forward_sale_limit") and len(attributes.forward_sale_limit)>#attributes.forward_sale_limit#<cfelse>NULL</cfif>,
		UPDATE_DATE = #NOW()#,
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#'
	WHERE 
		VOCATION_TYPE_ID=#TYPE_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_vocation_type" addtoken="no">
