<cf_popup_box title="#lang_array.item[651]#">
    <cfform name="add_notes" method="post" action="#request.self#?fuseaction=crm.emptypopup_add_company_period_note">
    <input type="hidden" name="related_id" id="related_id" value="<cfoutput>#attributes.related_id#</cfoutput>">
    <input type="hidden" name="cpid" id="cpid" value="<cfoutput>#attributes.cpid#</cfoutput>">
    <table>
        <tr>
            <td valign="top"><cf_get_lang_main no='217.Açıklama'> *</td>
            <td><textarea style="width:220;height:70px;" name="detail" id="detail"></textarea></td>
        </tr>
        <tr>
            <td><cf_get_lang no="12.Period"></td>
            <td>
                <select name="period_month" id="period_month">
                    <cfloop from="1" to="12" index="i">
                    <cfoutput><option value="#i#" <cfif month(now()) eq i>selected</cfif>>#listgetat('Ocak,Şubat,Mart,Nisan,Mayıs,Haziran,Temmuz,Ağustos,Eylül,Ekim,Kasım,Aralık',i,',')#</option></cfoutput>
                    </cfloop>
                </select>
                <select name="period_year" id="period_year">
                    <cfloop from="2005" to="#year(now())#" index="i">
                    <cfoutput><option value="#i#" <cfif i eq year(now())>selected</cfif>>#i#</option></cfoutput>
                    </cfloop>
                </select>
            </td>
        </tr>
    </table>
    <cf_popup_box_footer><cf_workcube_buttons is_upd='0' add_function='kontrol()'></cf_popup_box_footer>
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
		alert ("<cf_get_lang dictionary_id='36199.Açıklama'>" + ((-1) * x) + "<cf_get_lang dictionary_id='29538.Karakter Uzun'>!");
		return false;
	}
	return true;
}
</script>
