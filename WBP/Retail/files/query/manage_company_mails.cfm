<cfif attributes.partner_count gt 0>
	<cfloop from="1" to="#attributes.partner_count#" index="ccc">
		<cfset partner_id_ = evaluate("attributes.parnter_id_#ccc#")>
        <cfset name_ = evaluate("attributes.name_#ccc#")>
        <cfset surname_ = evaluate("attributes.surname_#ccc#")>
        <cfset email_ = evaluate("attributes.email_#ccc#")>
        
        <cfquery name="upd_" datasource="#dsn#">
        	UPDATE
            	COMPANY_PARTNER
            SET
            	<cfif isdefined("attributes.status_#ccc#")>
                	COMPANY_PARTNER_STATUS = 0,
                </cfif>
                COMPANY_PARTNER_NAME = '#name_#',
                COMPANY_PARTNER_SURNAME = '#surname_#',
                COMPANY_PARTNER_EMAIL = '#email_#'
            WHERE
            	PARTNER_ID = #partner_id_#
        </cfquery>
    </cfloop>
    
    <cfloop from="1" to="3" index="ccc">
    	<cfset name_ = evaluate("attributes.add_name_#ccc#")>
        <cfset surname_ = evaluate("attributes.add_surname_#ccc#")>
        <cfset email_ = evaluate("attributes.add_email_#ccc#")>
        <cfif len(name_) and len(surname_) and len(email_)>
            <cfquery name="add_" datasource="#dsn#">
                INSERT INTO
                    COMPANY_PARTNER
                    (
                    COMPANY_ID,
                    COMPANY_PARTNER_STATUS,
                    COMPANY_PARTNER_NAME,
                    COMPANY_PARTNER_SURNAME,
                    COMPANY_PARTNER_EMAIL
                    )
                    VALUES
                    (
                    #attributes.company_id#,
                    1,
                    '#name_#',
                    '#surname_#',
                    '#email_#'
                    )
            </cfquery>
        </cfif>
    </cfloop>
</cfif>

<script>
	<cfoutput>
	window.opener.refresh_mails('#attributes.company_id#','#attributes.set_id#');
	window.close();
	</cfoutput>
</script>