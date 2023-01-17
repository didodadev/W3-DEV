<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
        <cfquery name="ADD_CAMPAIGN_MAIL" datasource="#DSN#">
            INSERT INTO
                MAILLIST
                (
                    CAMPAIGN_ID,
                    MAILLIST_EMAIL,
                    PAPER_NO,
                    MAILLIST_CONTENT,
                    MAILLIST_NAME,
                    MAILLIST_SURNAME,
                    MAILLIST_MOBILCODE,
                    MAILLIST_MOBIL,
                    RECORD_DATE
                )
                VALUES
                (
                    #attributes.camp_id#,
                    '#attributes.email#',
                    '#attributes.paper_no#',
                    <cfif len(attributes.detail)>'#attributes.detail#',<cfelse>NULL,</cfif>
                    '#attributes.name#',
                    '#attributes.surname#',
                    <cfif len(attributes.tel_code)>#attributes.tel_code#,<cfelse>NULL,</cfif>
                    <cfif len(attributes.tel)>#attributes.tel#,<cfelse>NULL,</cfif>
                    #now()#
                )
        </cfquery>
    </cftransaction>
</cflock>
<script type="text/javascript">
	alert("<cf_get_lang no='1425.E-posta Kaydınız Başarıyla Alınmıştır!'>");
	history.back();
</script>
<cfabort>
<cflocation url="#request.self#?fuseaction=objects2.welcome" addtoken="no">
