<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
        <cfquery name="ADD_CAMP_COMMENT" datasource="#DSN3#">
            INSERT INTO 
                CAMPAIGN_COMMENT
                (
                    CAMPAIGN_ID,
                    CAMPAIGN_COMMENT,
                    PARTNER_ID,
                    CONSUMER_ID,
                    GUEST,
                    RECORD_DATE,
                    RECORD_IP,
                    NAME,
                    SURNAME,
                    MAIL_ADDRESS
                )
                VALUES
                (
                    #attributes.camp_id#,
                    '#attributes.camp_comment#',
                    <cfif isdefined('attributes.member_type') and attributes.member_type eq 1>#attributes.member_id#,<cfelse>NULL,</cfif>
                    <cfif isdefined('attributes.member_type') and attributes.member_type eq 2>#attributes.member_id#,<cfelse>NULL,</cfif>
                    <cfif not isdefined('member_type')>1,<cfelse>0,</cfif>
                    #now()#,
                    '#CGI.REMOTE_ADDR#',
                    '#attributes.name#',
                    '#attributes.surname#',
                    '#attributes.mail_address#'
                )
        </cfquery>
    </cftransaction>
</cflock>
<script type="text/javascript">
	alert("<cf_get_lang no='199.Yorumunuz Başarıyla Kaydedilmiştir.'>");
	history.back();
</script>
<cfabort>
<cfif isdefined('attributes.member_type') and len(attributes.member_type)>
	<cflocation url="#request.self#?fuseaction=objects2.dsp_campaign&camp_id=#attributes.camp_id#&member_type=#attributes.member_type#&member_id=#attributes.member_id#" addtoken="no">
<cfelse>
	<cflocation url="#request.self#?fuseaction=objects2.dsp_campaign&camp_id=#attributes.camp_id#" addtoken="no">
</cfif>


