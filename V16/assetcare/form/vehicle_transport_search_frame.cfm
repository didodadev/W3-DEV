<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfquery name="GET_SHIP" datasource="#DSN#">
	SELECT SHIP_METHOD, SHIP_METHOD_ID FROM SHIP_METHOD ORDER BY SHIP_METHOD_ID 
</cfquery>
<cfform method="post" name="search_transport" target="transport_list" action="#request.self#?fuseaction=assetcare.popup_list_vehicle_transport_search&is_submitted=1&iframe=1" onsubmit="return(kontrol());">
     <table>
        <tr>
            <td width="100"><cf_get_lang no='408.Alıcı Şube'></td>
            <td width="200">
                <input type="hidden" name="receiver_depot_id" id="receiver_depot_id" value=""> 
                <cfinput type="Text" name="receiver_depot" value="" style="width:155px;" readonly> 
                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_name=search_transport.receiver_depot&field_branch_id=search_transport.receiver_depot_id&is_get_all=1','list','popup_list_branches')"><img src="/images/plus_thin.gif" alt="<cf_get_lang no='408.Alıcı Şube'>" align="absbottom" border="0"></a>
            </td>
            <td width="100"><cf_get_lang no='407.Taşıyan Firma'> </td>
            <td width="213">
                <input type="hidden" name="transporter_id" id="transporter_id" value=""> 
                <cfinput type="Text" name="transporter" value="" style="width:155px;" readonly> 
                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=search_transport.transporter_id&field_comp_name=search_transport.transporter&is_buyer_seller=1','list','popup_list_pars')"><img src="/images/plus_thin.gif" alt="<cf_get_lang no='407.Taşıyan Firma'>" align="absbottom" border="0"></a>
            </td>
            <td><cf_get_lang_main no='243.Sevk Baş Tarihi'></td>
            <td>
                <cfsavecontent variable="message1"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='641.Başlangıç Tarihi !'></cfsavecontent>
                <cfinput type="text" name="shipping_date1" maxlength="10" validate="#validate_style#" message="#message1#" style="width:155px"> 
                <cf_wrk_date_image date_field="shipping_date1" date_form="search_transport">
            </td>
        </tr>
        <tr> 
            <td><cf_get_lang no='410.Gönderen Şube'></td>
            <td>
                <input type="hidden" name="sender_depot_id" id="sender_depot_id" value=""><cfinput type="Text" name="sender_depot" value="" style="width:155px;" readonly> 
                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_name=search_transport.sender_depot&field_branch_id=search_transport.sender_depot_id&is_get_all=1','list','popup_list_branches')"><img src="/images/plus_thin.gif" alt="<cf_get_lang no='410.Gönderen Şube'>" align="absbottom" border="0"></a>
            </td>
            <td><cf_get_lang_main no='70.Aşama'></td>
            <td>
                <select name="shipping_status" id="shipping_status" style="width:155px;">
                    <option value=""><cf_get_lang_main no='669.Hepsi'></option>
                    <option value="0"><cf_get_lang no='435.Gönderildi'></option>
                    <option value="1"><cf_get_lang no ='659.Alındı'></option>
                </select>
            </td>
            <td><cf_get_lang_main no='288.Sevk Bit tarihi'></td>
            <td>
                <cfsavecontent variable="message2"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='288.Bitiş Tarihi !'></cfsavecontent>
                <cfinput type="text" name="shipping_date2" maxlength="10" validate="#validate_style#" style="width:155px" message="#message2#"> 
                <cf_wrk_date_image date_field="shipping_date2" date_form="search_transport"> 
            </td>
        </tr>
        <tr> 
            <td><cf_get_lang no='258.Taşıma Tipi'> </td>
            <td>
                <select name="shipping_type" id="shipping_type" style="width:155px;">
                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                <cfoutput query="get_ship"> 
                    <option value="#ship_method_id#">#ship_method#</option>
                </cfoutput>
                </select>
            </td>
            <td><cf_get_lang no='319.Sevk No'> </td>
            <td><cfinput type="text" name="shipping_num" style="width:155px;"  value="" maxlength="50"></td>
            <td colspan="2">&nbsp;</td>
        </tr>
	</table>
    <div class="sepetim_total_form_button" style="text-align:right;">
        <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
        <input type="submit" name="Ara" value="<cf_get_lang_main no='153.Ara'>">
        <input type="reset" name="Temizle" value="<cf_get_lang_main no='522.Temizle'>">
   </div>
</cfform>
<script type="text/javascript">
function kontrol()
{	
	if(document.search_transport.maxrows.value>200)
	{
		alert("<cf_get_lang no ='729.Maxrows Değerini Kontrol Ediniz'> !");
		return false;
	}
	return true;
}
</script>
