<!--- Kart Numaralari Ekleme / Guncelleme; Bireysel Uye ve Kurumsal Uye Calisani Ekranlarinda Kullanilmaktadir FBS 20110226 --->
<cfquery name="Get_Card_Type" datasource="#dsn#">
	SELECT * FROM SETUP_CARD_CHANGE_TYPES ORDER BY CHANGE_TYPE_NAME
</cfquery>
<cfif isDefined("attributes.card_id") and Len(attributes.card_id)>
	<cfquery name="Get_Customer_Cards" datasource="#dsn#">
		SELECT * FROM CUSTOMER_CARDS WHERE CARD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.card_id#">
	</cfquery>
<cfelse>
	<cfset Get_Customer_Cards.RecordCount = 0>
	<cfset Get_Customer_Cards.Card_Status = 1>
	<cfset Get_Customer_Cards.Card_No = "">
	<cfset Get_Customer_Cards.Card_Startdate = "">
	<cfset Get_Customer_Cards.Card_FinishDate = "">
	<cfset Get_Customer_Cards.Change_Type_Id = "">
	<cfset Get_Customer_Cards.Card_Detail = "">
</cfif>
<cf_popup_box title="#lang_array.item[95]#"><!---Kart No'--->
<cfform name="customer_cards" action="#request.self#?fuseaction=member.emptypopup_detail_customer_cards">
    <table>
        <cfoutput>
        <input type="hidden" name="Card_Id" id="Card_Id" value="<cfif isDefined('attributes.Card_Id') and Len(attributes.Card_Id)>#attributes.Card_Id#</cfif>">
        <input type="hidden" name="Action_Id" id="Action_Id" value="<cfif isDefined('attributes.Action_Id') and Len(attributes.action_id)>#attributes.Action_Id#</cfif>">
        <input type="hidden" name="Action_Type_Id" id="Action_Type_Id" value="<cfif isDefined('attributes.Action_Type_Id') and Len(attributes.Action_Type_Id)>#attributes.Action_Type_Id#</cfif>">
        </cfoutput>
        <cfsavecontent variable="Date_Message"><cf_get_lang_main no='370.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
        <cfsavecontent variable="Card_Message"> Lütfen Geçerli Bir Kart No Giriniz !</cfsavecontent>
        <tr>
            <td style="width:110px;">&nbsp;</td>
            <td><cf_get_lang_main no='81.Aktif'><input type="checkbox" name="Card_Status" id="Card_Status" value="1" <cfif Get_Customer_Cards.Card_Status eq 1>checked</cfif>></td>
        </tr>
        <tr>
            <td><cf_get_lang no='95.Kart No'>*</td>
            <td><cfinput type="text" name="Card_No" value="#Get_Customer_Cards.Card_No#" style="width:150px;" maxlength="16" required="yes" onKeyUp="isNumber(this);" message="#Card_Message#"></td>
        </tr>
        <tr>
            <td nowrap="nowrap"><cf_get_lang no='143.Verilme Nedeni'> *</td>
            <td><select name="Change_Type_Id" id="Change_Type_Id" style="width:150px;">
                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                    <cfoutput query="Get_Card_Type">
                        <option value="#Change_Type_Id#" <cfif Get_Customer_Cards.Change_Type_Id eq Get_Card_Type.Change_Type_Id>selected</cfif>>#Change_Type_Name#</option>
                    </cfoutput>
                </select>
            </td>
        </tr>
        <tr>
            <td><cf_get_lang no='142.Verilme Tarihi'> *</td>
            <td><cfinput type="text" name="Card_Startdate" value="#DateFormat(Get_Customer_Cards.Card_Startdate,'dd/mm/yyyy')#" validate="eurodate" style="width:150px;" maxlength="10" required="yes" message="#Date_Message#">
                <cf_wrk_date_image date_field='Card_Startdate'>
            </td>
        </tr>
        <tr>
            <td><cf_get_lang no='227.Son Kullanma Tarihi'> *</td>
            <td><cfinput type="text" name="Card_Finishdate" value="#DateFormat(Get_Customer_Cards.Card_Finishdate,'dd/mm/yyyy')#" validate="eurodate" style="width:150px;" maxlength="10" required="yes" message="#Date_Message#">
                <cf_wrk_date_image date_field='Card_Finishdate'>
            </td>
        </tr>
        <tr>
            <td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
            <td><textarea name="Card_Detail" id="Card_Detail" style="width:150px;height:50px;" maxlength="250" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="250 <cf_get_lang_main no='1585.Karakterden Fazla Yazmayınız'>!"><cfoutput>#Get_Customer_Cards.Card_Detail#</cfoutput></textarea></td>
        </tr>
	</table>
    <cf_popup_box_footer>
		<cfif Get_Customer_Cards.RecordCount>
            <cf_record_info query_name="Get_Customer_Cards" record_emp="Record_Emp" update_emp="Update_Emp">
        </cfif>
        <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
    </cf_popup_box_footer>
</cfform>
</cf_popup_box>
<script type="text/javascript">
	function kontrol()
	{
		if(document.getElementById('Card_No').value != "")
		{
			if(document.getElementById('Card_No').value.length != 16)
			{
				alert("<cfoutput>#Card_Message#</cfoutput> (<cf_get_lang no='144.Eksik Karakter Sayısı'> : " + (16-document.getElementById('Card_No').value.length) + ")");
				return false;
			}
			if(document.getElementById('Card_Id').value == "") var Card_Id_ = 0; else var Card_Id_ = document.getElementById('Card_Id').value;
			var listParam = document.getElementById('Card_No').value + "*" + Card_Id_;
			var get_same_card_control = wrk_safe_query("same_customer_card_control","dsn",0,listParam);
			if(get_same_card_control.recordcount > 0)
			{
				alert("<cf_get_lang no='150.Aynı Kart Numarası Daha Önce Kullanılmıştır.\n Lütfen Girdiğiniz Bilgileri Kontrol Ediniz !'>");
				return false;
			}
		}
		if(document.getElementById('Change_Type_Id').value == "")
		{
			alert("<cf_get_lang no='148.Lütfen Verilme Nedenlerinden Birini Seçiniz'> !");
			return false;
		}
		return true;
	}
</script>