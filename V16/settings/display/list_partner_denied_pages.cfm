<cfquery name="get_faction" datasource="#dsn#">
	SELECT 
    	DENIED_PAGE_ID, 
        PARTNER_ID, 
        DENIED_PAGE 
    FROM 
	    COMPANY_PARTNER_DENIED
</cfquery>
<table cellpadding="0" cellspacing="0" border="0" width="98%" align="center">
    <tr>
        <td class="headbold" height="35"><cf_get_lang no='212.Partner Kısıtlı Sayfalar'></td>
    </tr>
</table>
<table cellspacing="1" cellpadding="2" width="98%" border="0" class="color-border" align="center">
    <tr height="22" class="color-header">
        <td class="form-title"><cf_get_lang_main no='169.Sayfa'></td>
        <td class="form-title"><cf_get_lang no='42.Partnerlar'></td>
    </tr>
	<cfif get_faction.recordcount>
		<cfoutput query="get_faction" group="DENIED_PAGE">
            <tr class="color-row" height="20">
                <td>
                	<a href="#request.self#?fuseaction=settings.upd_partner_user_denied&FACTION=#DENIED_PAGE#&ID=#DENIED_PAGE_ID#&PARTNER_ID=#PARTNER_ID#" class="tableyazi">#DENIED_PAGE#</a>
                </td> 
                <td>
                    <cfquery name="get_name" datasource="#dsn#">
                        SELECT DISTINCT
                            COMPANY_PARTNER.COMPANY_PARTNER_NAME,
                            COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
                            COMPANY_PARTNER.PARTNER_ID,
                            COMPANY_PARTNER_DENIED.PARTNER_ID
                        FROM
                            COMPANY_PARTNER,
                            COMPANY_PARTNER_DENIED
                        WHERE 
                        	COMPANY_PARTNER.PARTNER_ID = COMPANY_PARTNER_DENIED.PARTNER_ID
                        AND 
                        	COMPANY_PARTNER_DENIED.DENIED_PAGE_ID = #DENIED_PAGE_ID#
                    </cfquery>
                    <cfloop query="get_name">
                        #company_partner_name# #company_partner_surname# ,
                    </cfloop>
                </td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr class="color-row" height="20">
            <td colspan="2"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
        </tr>
    </cfif>
</table>
