<cfquery name="GET_MAILS" datasource="#DSN#">
	SELECT 
		*
	FROM
		MAILS   
	WHERE
		IS_DEATH = #attributes.death#  			   
	<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
		AND 
		SENDER = #session.ep.USERID#
	<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
		AND 
		SENDER = #session.pp.USERID#
	</cfif>
	<cfif isDefined("attributes.keyword")>		   
		AND 
		(
		SUBJECT LIKE '%#attributes.keyword#%'
		<cfif Len(mails)>	   
			OR MAIL_ID IN (#mails#)
		</cfif>
		)
	</cfif>
	<cfif isDefined("attributes.order_subject")>
	ORDER BY 
		SUBJECT
	<cfelseif isDefined("attributes.order_to")>
	ORDER BY 
		TO_MAILS
	<cfelseif isDefined("attributes.order_from")>
	ORDER BY 
		SENDER
	<cfelseif isDefined("attributes.order_date")>
	ORDER BY 
		RECORD_DATE DESC
	<cfelseif isDefined("attributes.order_module")>
	ORDER BY 
		MAIL_MODULE
	</cfif>		   
</cfquery>
