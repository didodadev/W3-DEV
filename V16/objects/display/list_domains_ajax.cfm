<cfsetting showdebugoutput="no">
<cfquery name="GET_DOMAINS" datasource="#DSN#">
    SELECT
        ISNULL(PS.DOMAIN, CCD.SITE_DOMAIN) AS DOMAIN
    FROM 
        COMPANY_CONSUMER_DOMAINS CCD
        LEFT JOIN PROTEIN_SITES PS ON CCD.MENU_ID = PS.SITE_ID
    WHERE 
        <cfif attributes.action_type eq 'CONSUMER'>
            CCD.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
        <cfelseif attributes.action_type eq 'PARTNER'>
            CCD.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
        </cfif>
</cfquery>

<div id="domains" style="z-index:1;overflow:auto;">
    <table class="ajax_list">
        <tbody>
            <cfif get_domains.recordcount>
                <cfoutput query="get_domains">
                    <tr id="domain" style="height:13px;">
                        <td colspan="2">#DOMAIN#</td>
                    </tr>
                </cfoutput>
            <cfelse>
                <tr id="domain">
                    <td colspan="2"><cf_get_lang dictionary_id ='58486.Kayıt Bulunamadı'> !</td>
                </tr>
            </cfif>
        </tbody>
    </table>
</div>
