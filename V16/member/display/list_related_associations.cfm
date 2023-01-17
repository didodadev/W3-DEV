<!--- Iliskili Kurumlar --->
<cfsetting showdebugoutput="no">
<cfparam name="attributes.partner_status" default="">
<cfquery name="Get_Related_Associations" datasource="#dsn#">
	SELECT
		C.NICKNAME,
		CP.PARTNER_ID,
		CP.COMPANY_PARTNER_STATUS,
		CP.COMPANY_PARTNER_NAME,
		CP.COMPANY_PARTNER_SURNAME
	FROM
		COMPANY C,
		COMPANY_PARTNER CP
	WHERE
		C.COMPANY_ID = CP.COMPANY_ID AND
		<cfif Len(attributes.partner_status)>
			CP.COMPANY_PARTNER_STATUS = #attributes.partner_status# AND
		</cfif>
		CP.RELATED_CONSUMER_ID = #attributes.cid#
	ORDER BY
		C.NICKNAME,
		CP.COMPANY_PARTNER_NAME
</cfquery>
	<cfform name="form_related_partner" method="post" action="#request.self#?fuseaction=member.popupajax_related_associations&cid=#attributes.cid#">
	<cf_ajax_list_search>
        <cf_ajax_list_search_area>
            <select name="partner_status" id="partner_status" style="width:60px;">
                <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                <option value="1" <cfif attributes.partner_status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                <option value="0" <cfif attributes.partner_status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
            </select>
            <input type="button" value="<cf_get_lang dictionary_id='57565.Ara'>" onClick="connectAjax_association();">
        </cf_ajax_list_search_area>
    </cf_ajax_list_search>
	</cfform>
	<cf_ajax_list>
        <tbody>
        <cfif Get_Related_Associations.RecordCount>
            <cfoutput query="Get_Related_Associations" group="NickName">
            <tr>
                <td><b>#NickName#</b><br/>
                    <cfoutput>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <cfif company_partner_status eq 0><font color="999999"></cfif>
                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#Partner_Id#','medium','popup_par_det');" <cfif company_partner_status eq 1>class="tableyazi"</cfif>><cfif company_partner_status eq 0><font color="999999"></cfif>#Company_Partner_Name# #Company_Partner_Surname#<cfif company_partner_status eq 0></font></cfif></a>
                    <cfif company_partner_status eq 0></font></cfif>
                    <br/>
                    </cfoutput>
                </td>
            </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
            </tr>
        </cfif>
        </tbody>
	<div style="width:300px;display:none;" id="show_related_associations"></div>
	</cf_ajax_list>
<script type="text/javascript">
	function connectAjax_association()
	{	
		AjaxFormSubmit(form_related_partner,'show_related_associations',0,' ',' ','<cfoutput>#request.self#?fuseaction=member.popupajax_related_associations&cid=#attributes.cid#</cfoutput>','body_get_related');return false;
	}
</script>
