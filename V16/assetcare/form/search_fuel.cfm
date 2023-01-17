<cfinclude template="../query/get_fuel_type.cfm">
<cfinclude template="../query/get_document_type.cfm">
<cfinclude template="../query/get_branch.cfm">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.document_type_id" default="">
<cfparam name="attributes.record_num" default="">
<cfparam name="attributes.document_num" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.assetp_name" default="">
<cfparam name="attributes.assetp_id" default="">
<cfparam name="attributes.fuel_comp_name" default="">
<cfparam name="attributes.fuel_comp_id" default="">
<cfparam name="attributes.fuel_type_id" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.is_submitted" default="">
<cfparam name="attributes.branch" default="">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfform name="search_fuel" id="search_fuel" target="frame_fuel_search" method="post" action="#request.self#?fuseaction=assetcare.popup_list_fuel_search&is_submitted=1&iframe=1" onSubmit="return(kontrol());">																																										
    <table>
        <tr>
            <td width="80"><cf_get_lang_main no='1656.Plaka'></td>
            <td width="180">
              <input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#attributes.assetp_id#</cfoutput>">
              <input type="text" name="assetp_name" id="assetp_name" style="width:130px;" value="<cfoutput>#attributes.assetp_name#</cfoutput>">
              <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=search_fuel.assetp_id&field_name=search_fuel.assetp_name&list_select=2','list','popup_list_ship_vehicles');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a></td>
            <td width="80"><cf_get_lang_main no='2320.Yakıt Şirketi'></td>
            <td width="180">
              <input type="hidden" name="fuel_comp_id" id="fuel_comp_id" value="<cfoutput>#attributes.fuel_comp_id#</cfoutput>">
              <input type="text" name="fuel_comp_name" id="fuel_comp_name" value="<cfoutput>#attributes.fuel_comp_name#</cfoutput>" style="width:130px;">
              <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=search_fuel.fuel_comp_id&field_comp_name=search_fuel.fuel_comp_name&is_buyer_seller=1&select_list=2</cfoutput>','list','popup_list_pars')"><img src="/images/plus_thin.gif" alt="<cf_get_lang no='387.Yakıt Şirketi'>" align="absmiddle" border="0" ></a></td>
            <td width="80"><cf_get_lang_main no='468.Belge No'></td>
            <td><input name="document_num" id="document_num" type="text" style="width:120px;" value="<cfoutput>#attributes.document_num#</cfoutput>"></td>
        </tr>
        <tr>
            <td><cf_get_lang_main no='132.Sorumlu'></td>
            <td><input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
              <input type="text" name="employee_name" id="employee_name" value="<cfoutput>#attributes.employee_name#</cfoutput>" style="width:130px;">
              <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=search_fuel.employee_id&field_name=search_fuel.employee_name&select_list=1</cfoutput>','list','popup_list_positions')"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='132.Sorumlu'>" align="absmiddle" border="0"></a> </td>
            <td><cf_get_lang_main no='2316.Yakıt Tipi'></td>
            <td><select name="fuel_type_id" id="fuel_type_id" style="width:130px;">
              <option value=""></option>
              <cfoutput query="get_fuel_type">
                <option value="#fuel_id#" <cfif attributes.fuel_type_id eq fuel_id>selected</cfif>>#fuel_name#</option>
              </cfoutput>
              </select></td>
            <td><cf_get_lang_main no='243.Başlangıç Tarihi'></td>
            <td><cfsavecontent variable="message1"><cf_get_lang_main no ='2325.Başlangıç Tarihini Kontrol Ediniz '>!</cfsavecontent>
              <cfinput type="text" name="start_date" value="#attributes.start_date#" validate="#validate_style#" maxlength="10" message="#message1#" style="width:120px">
              <cf_wrk_date_image date_field="start_date">
             </td>
        </tr>
        <tr>
            <td><cf_get_lang_main no='41.Şube'></td>
            <td><input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>">
              <input type="text" name="branch" id="branch" value="<cfoutput>#attributes.branch#</cfoutput>" style="width:130px;">
              <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_id=search_fuel.branch_id&field_branch_name=search_fuel.branch','list','popup_list_branches');"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='41.Şube'>" align="absmiddle" border="0"></a></td>
            <td><cf_get_lang_main no='1121.Belge Tipi'></td>
            <td><select name="document_type_id" id="document_type_id" style="width:130px">
              <option value=""></option>
              <cfoutput query="get_document_type">
                <option value="#document_type_id#" <cfif attributes.document_type_id eq document_type_id>selected</cfif>>#document_type_name#</option>
              </cfoutput>
              </select></td>
            <td><cf_get_lang_main no='288.Bitiş Tarihi'></td>
            <td><cfsavecontent variable="message2"><cf_get_lang_main no ='2326.Bitiş Tarihini Kontrol Ediniz'> !</cfsavecontent>
              <cfinput type="text" name="finish_date" value="#attributes.finish_date#" validate="#validate_style#" maxlength="10" message="#message2#" style="width:120px">
              <cf_wrk_date_image date_field="finish_date"></td>
        </tr>
        <tr>
            <td></td>
            <td><input name="record_num" id="record_num" type="hidden" style="width:130px;"></td>
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
	if(document.search_fuel.maxrows.value>200)
	{
		alert("<cf_get_lang no ='729.Maxrows Değerini Kontrol Ediniz'>");
		return false;
	}
	return true;
	if(!CheckEurodate(document.search_fuel.start_date.value,'<cf_get_lang_main no="641.Başlangıç Tarihi">'))
	{
		return false;
	}
	
	if(!CheckEurodate(document.search_fuel.finish_date.value,'<cf_get_lang_main no ="288.Bitiş Tarihi">'))
	{
		return false;
	}
	
	if ((document.search_fuel.start_date.value.length>0) && (document.search_fuel.finish_date.value.length>0) && (!date_check(document.search_fuel.start_date,document.search_fuel.finish_date,"<cf_get_lang_main no='394.Tarih Aralığını Kontrol Ediniz'>!")) )
	{
		return false;
	}
	
	return true;
}
</script>
