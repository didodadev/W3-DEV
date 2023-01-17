<cfif isDefined("attributes.keyword")>
	<cfquery name="GET_MAILS1" datasource="#DSN#">
		SELECT 
			*
		FROM
			MAILS   
		WHERE
		<cfif attributes.death eq 0>	 
			TYPE	= #attributes.type#
			AND 
			IS_DEATH = #attributes.death#
		<cfelse>
			IS_DEATH = #attributes.death#  			   
		</cfif> 
		<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
			AND	
			SENDER = #session.ep.USERID#
		<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
			AND	
			SENDER = #session.pp.USERID#
		</cfif>				      		  	   
	</cfquery>
	<cfset mails = ''>
	<cfoutput query="GET_MAILS1">
	    <cfif attributes.type eq 0> 
			<cffile action="read" file="#upload_folder#mails#dir_seperator#out#dir_seperator##GET_MAILS1.CONTENT_FILE#" variable="body">
		<cfelseif attributes.type eq 1>
		    <cffile action="read" file="#upload_folder#mails#dir_seperator#in#dir_seperator##GET_MAILS1.CONTENT_FILE#" variable="body">	
		<cfelseif attributes.type eq 2>
			<cfif fileexists("#upload_folder#mails#dir_seperator#in#dir_seperator##GET_MAILS1.CONTENT_FILE#")>
				 <cffile action="read" file="#upload_folder#mails#dir_seperator#in#dir_seperator##GET_MAILS1.CONTENT_FILE#" variable="body">
			<cfelseif fileexists("#upload_folder#mails#dir_seperator#out#dir_seperator##GET_MAILS1.CONTENT_FILE#")>
				 <cffile action="read" file="#upload_folder#mails#dir_seperator#out#dir_seperator##GET_MAILS1.CONTENT_FILE#" variable="body">      
			</cfif>			
		</cfif>		
		<cfif body contains attributes.keyword>
		     <cfset mails = "#mails##MAIL_ID#,">
		</cfif>
	</cfoutput>
	<cfif Len(mails)><cfset mails = Left(mails,Len(mails)-1)></cfif>
</cfif>
<cfif not isDefined("attributes.click_count")>
	<cfset attributes.click_count = 0>
<cfelse>
    <cfif attributes.click_count neq 0>
	    <cfset attributes.click_count = 0>
	<cfelse>	  
		<cfset attributes.click_count = 1>
	</cfif>
</cfif>

<cfquery name="GET_MAILS" datasource="#DSN#">
	SELECT 
		*
	FROM
		MAILS   
	WHERE
	<cfif attributes.death eq 0>	 
		TYPE = #attributes.type#
		AND 
		IS_DEATH = #attributes.death#
	<cfelse>
		IS_DEATH = #attributes.death#  			   
	</cfif>
	<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
		AND	
		SENDER = #session.ep.USERID#
	<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
		AND	
		SENDER = #session.pp.USERID#
	</cfif>
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>		   
		AND 
		(SUBJECT LIKE '%#attributes.keyword#%'
		<cfif Len(mails)>	   
		OR
		MAIL_ID IN (#mails#))
		<cfelse>
		)
		</cfif>		
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
	<cfelseif isDefined("attributes.order_module")>
	ORDER BY
		MAIL_MODULE
	<cfelseif isDefined("attributes.order_attach") and (attributes.click_count eq 0)>
	ORDER BY
		ATTACHMENT_FILE
	<cfelseif isDefined("attributes.order_attach")>			  
	ORDER BY
		ATTACHMENT_FILE DESC	
	<cfelse>
	ORDER BY
		RECORD_DATE DESC		
	</cfif>
</cfquery>	
