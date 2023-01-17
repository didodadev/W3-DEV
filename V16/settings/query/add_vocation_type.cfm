<cfscript>
	attributes.forward_sale_limit= filterNum(attributes.forward_sale_limit);
</cfscript>
<cfquery name="ADD_VOCATION_TYPE" datasource="#dsn#">
	INSERT INTO 
		SETUP_VOCATION_TYPE
		(
			VOCATION_TYPE,
			DETAIL,
			FORWARD_SALE_LIMIT,
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP
		) 
		VALUES 
		(
			'#vocation_type#',
			<cfif isDefined("attributes.detail") and len(attributes.detail)>'#DETAIL#',<cfelse>NULL,</cfif>
			<cfif isdefined("attributes.forward_sale_limit") and len(attributes.forward_sale_limit)>#attributes.forward_sale_limit#<cfelse>NULL</cfif>,
			#SESSION.EP.USERID#,
			#NOW()#,
			'#CGI.REMOTE_ADDR#'
		)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_vocation_type" addtoken="no">
