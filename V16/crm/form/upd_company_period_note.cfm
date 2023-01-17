<cfquery name="GET_NOTE" datasource="#dsn#">
	SELECT 
    	NOTE_ID, 
        COMPANY_ID, 
        BRANCH_ID, 
        NOTE_DETAIL, 
        NOTE_YEAR, 
        NOTE_MONTH, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	COMPANY_BRANCH_NOTES 
    WHERE 
    	NOTE_ID = #attributes.note_id#
</cfquery>
<cf_popup_box title="#lang_array.item[651]#">
    <cfform name="add_notes" method="post" action="#request.self#?fuseaction=crm.emptypopup_upd_company_period_note">
    <input type="hidden" name="note_id" id="note_id" value="<cfoutput>#attributes.note_id#</cfoutput>">
    <table> 
        <tr>
            <td valign="top"><cf_get_lang_main no='217.Açıklama'> *</td>
            <td><textarea style="width:220;height:70px;" name="detail" id="detail"><cfoutput>#get_note.note_detail#</cfoutput></textarea></td>
        </tr>
        <tr>
            <td><cf_get_lang no="12.Period"></td>
            <td>
                <select name="period_month" id="period_month">
                    <cfloop from="1" to="12" index="i">
                    <cfoutput><option value="#i#" <cfif get_note.note_month eq i>selected</cfif>>#listgetat('Ocak,Şubat,Mart,Nisan,Mayıs,Haziran,Temmuz,Ağustos,Eylül,Ekim,Kasım,Aralık',i,',')#</option></cfoutput>
                    </cfloop>
                </select>
                <select name="period_year" id="period_year">
                    <cfloop from="2005" to="#year(now())#" index="i">
                    <cfoutput><option value="#i#" <cfif i eq get_note.note_year>selected</cfif>>#i#</option></cfoutput>
                    </cfloop>
                </select>
            </td>
        </tr>
    </table>
    <cf_popup_box_footer>
        <cf_record_info query_name="get_note">
        <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=crm.emptypopup_upd_company_period_note&is_delete=1&note_id=#note_id#' add_function='kontrol()'>
    </cf_popup_box_footer>
    </cfform>
</cf_popup_box>
<script type="text/javascript">
function kontrol()
{
	if(document.add_notes.detail.value=="")
	{
		alert("<cf_get_lang no='14.Açıklama Girmelisiniz'>!");
		return false;
	}

	x=(1000 - document.add_notes.detail.value.length);
	if(x<0)
	{ 
		alert ("<cf_get_lang dictionary_id='36199.Açıklama'>" + ((-1) * x) + "<cf_get_lang dictionary_id='29538.Karakter Uzun'>");
		return false;
	}
	return true;
}
</script>
