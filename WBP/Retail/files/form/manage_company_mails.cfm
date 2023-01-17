<cfquery name="get_comp_partners" datasource="#dsn#">
	SELECT
    	*
    FROM
    	COMPANY_PARTNER
    WHERE
    	COMPANY_ID = #attributes.COMPANY_ID# AND
        COMPANY_PARTNER_STATUS = 1
</cfquery>

<cf_popup_box title="Şirket Maillerini Düzenle : #get_par_info(attributes.company_id,1,1,0)#">
<cfform action="#request.self#?fuseaction=retail.emptypopup_manage_company_mails" method="post" name="add_fis_form">
	<cfinput type="hidden" name="company_id" value="#attributes.company_id#">
    <cfinput type="hidden" name="set_id" value="#attributes.set_id#">
    <cfinput type="hidden" name="partner_count" value="#get_comp_partners.recordcount#">
    <table>
    	<tr>
        	<td class="formbold">Ad</td>
            <td class="formbold">Soyad</td>
            <td class="formbold">Mail</td>
            <td class="formbold">Sil</td>
        </tr>
        <cfoutput query="get_comp_partners">
        <cfinput type="hidden" name="parnter_id_#currentrow#" value="#partner_id#" style="width:175px;">
        <tr>
        	<td><cfinput type="text" name="name_#currentrow#" value="#company_partner_name#" style="width:175px;"></td>
            <td><cfinput type="text" name="surname_#currentrow#" value="#company_partner_surname#" style="width:175px;"></td>
            <td><cfinput type="text" name="email_#currentrow#" value="#COMPANY_PARTNER_EMAIL#" style="width:250px;" validate="email" message="Hatalı Mail Girdiniz!"></td>
        	<td><cfinput type="checkbox" name="status_#currentrow#" value="1"></td>
        </tr>
        </cfoutput>
        <cfloop from="1" to="3" index="ccc">
        <tr>
        	<td><cfinput type="text" name="add_name_#ccc#" value="" style="width:175px;"></td>
            <td><cfinput type="text" name="add_surname_#ccc#" value="" style="width:175px;"></td>
            <td><cfinput type="text" name="add_email_#ccc#" value="" style="width:250px;" validate="email" message="Hatalı Mail Girdiniz!"></td>
        </tr>
        </cfloop>
    </table>
    <cf_popup_box_footer>
    	<cf_workcube_buttons>
    </cf_popup_box_footer>
</cfform>
</cf_popup_box>