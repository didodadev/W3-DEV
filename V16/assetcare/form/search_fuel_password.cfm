<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.company_name" default="">
<cfparam name="attributes.status" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.is_submitted" default="">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfform name="search_fuel_password" target="frame_search_fuel_password" method="post" action="#request.self#?fuseaction=assetcare.popup_list_fuel_password_search&is_submitted=1&iframe=1" onSubmit="return(kontrol());">
 <table>
      <tr>
        <td width="100"><cf_get_lang_main no='41.Şube'></td>
        <td width="190"><input type="hidden" name="branch_id" id="branch_id" value="">
            <cfinput type="text" name="branch" value="" style="width:150px;" readonly>
        <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_id=search_fuel_password.branch_id&field_branch_name=search_fuel_password.branch','list','popup_list_branches');"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='41.Şube'>" align="absmiddle" border="0"></a></td>
        <td><cf_get_lang_main no='243.Başlangıç Tarihi'></td>
        <td><cfsavecontent variable="message2"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no ='330.Tarih'> !</cfsavecontent>
            <cfinput type="text" name="start_date" validate="#validate_style#" message="#message2#" maxlength="10" style="width:150px">
            <cf_wrk_date_image date_field="start_date" date_form="search_fuel_password"></td>			
      </tr>
      <tr>
        <td><cf_get_lang no='470.Akaryakıt Şirketi'></td>
        <td><input type="hidden" name="company_id" id="company_id">
            <cfinput type="text" name="company_name" value="" style="width:150px" readonly>
            <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=search_fuel_password.company_name&field_comp_id=search_fuel_password.company_id&select_list=2,3','list','popup_list_pars');"><img src="/images/plus_thin.gif" alt="<cf_get_lang no='470.Akaryakıt Şirketi'>" border="0" align="absmiddle"></a></td>
        <td><cf_get_lang_main no='288.Bitiş Tarihi'></td>
        <td><cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no ='330.Tarih'> !</cfsavecontent>
            <cfinput type="text" name="finish_date" validate="#validate_style#" message="#message#" maxlength="10" style="width:150px">
            <cf_wrk_date_image date_field="finish_date" date_form="search_fuel_password"></td>
      </tr>
      <tr>
        <td><cf_get_lang_main no='70.Asama'></td>
        <td><select name="status" id="status" style="width:150px">
            <option value=""></option>
            <option value="1"><cf_get_lang_main no='81.Aktif'></option>
            <option value="0"><cf_get_lang_main no='82.Pasif'></option>
            </select>
        </td>
        <td>&nbsp;</td>
      </tr>
  </table>
  <cf_basket_form_button>
  	    <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
        <input type="submit" value="<cf_get_lang_main no='153.Ara'>">&nbsp;<input type="reset" value="<cf_get_lang_main no='522.Temizle'>">
 </cf_basket_form_button>
</cfform>
<script type="text/javascript">
	function kontrol()
	{
		if(document.search_fuel_password.maxrows.value>200)
		{
			alert("<cf_get_lang no ='729.Maxrows Değerini Kontrol Ediniz'>");
			return false;
		}
		return true;
		if ( (document.search_fuel_password.start_date.value.length>0) && (document.search_fuel_password.finish_date.value.length>0) && (!date_check(document.search_fuel_password.start_date,document.search_fuel_password.finish_date,"<cf_get_lang_main no='394.Tarih Aralığını Kontrol Ediniz'>!")) )
		{
			return false;
		}
		return true;
	}
</script>
