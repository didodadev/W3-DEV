<cfset to_day =  CreateDateTime(year(now()),month(now()), day(now()),00,00,00)>
<cfquery name="get_mails" datasource="#dsn#">
	SELECT
		MAILS.RECORD_DATE,
        MAILS.UID,
		CUBE_MAIL.TEMP_PRESENT_ISACTIVE,
        CUBE_MAIL.POP,
        CUBE_MAIL.POP_PORT,
        CUBE_MAIL.PASSWORD,
        CUBE_MAIL.EMPLOYEE_ID,
        CUBE_MAIL.ACCOUNT
	FROM	   
		MAILS LEFT JOIN CUBE_MAIL
		ON CUBE_MAIL.MAILBOX_ID = MAILS.MAILBOX_ID
	WHERE
        CUBE_MAIL.ISACTIVE = 1
        AND CUBE_MAIL.TEMP_PRESENT_ISACTIVE = 1
</cfquery>
<cfoutput query="get_mails">
	<cfset date_ = datediff('d',to_day,RECORD_DATE)>
    <cfif date_ eq 7>
		<cfset password_ = Decrypt(PASSWORD,EMPLOYEE_ID)>
        <cfif len(POP_PORT)>
            <cfset this_port_ = POP_PORT>
        <cfelse>
            <cfset this_port_ = 110>
        </cfif>
        <cfset pop3 = POP>
    	<cftry>
            <cfpop name="inbox_3" 
               action="delete"
               server="#pop3#" 
               username="#account#" 
               password="#password_#"
               port="#this_port_#"
               uid="#uid#"> 
           <cfcatch>
           </cfcatch>
        </cftry>
    </cfif>
</cfoutput>
