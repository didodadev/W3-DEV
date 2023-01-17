<cfquery name="GET_PARTNER" datasource="#dsn#">
	SELECT 
		COMPANY_PARTNER_NAME,
		COMPANY_PARTNER_SURNAME,
		TITLE,
		PARTNER_ID 
	FROM 
		COMPANY_PARTNER 
	WHERE 
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
		COMPANY_PARTNER_STATUS = 1 <!--- Pasif calisanlar displayda gosterilmiyor Ömer Bey'in istegi 20070619 FB --->
	ORDER BY
		COMPANY_PARTNER_NAME,
		COMPANY_PARTNER_SURNAME,
		TITLE
</cfquery>
<cfif get_partner.recordcount>
    <cf_flat_list>
        <cfoutput query="get_partner">
            <tr>
                <td width="160"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#partner_id#','medium');" class="tableyazi">#company_partner_name# #company_partner_surname#</a></td>
                <td>#title#</td>
                <td width="15"><cfif session.ep.our_company_info.sms eq 1><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_form_send_sms&member_type=partner&member_id=#partner_id#&sms_action=#fuseaction#','small');"><img src="/images/mobil.gif" border="0" title="<cf_get_lang dictionary_id ='58590.SMS Gönder'>"></a></cfif></td>
            </tr>
        </cfoutput>
    </cf_flat_list>
</cfif>
