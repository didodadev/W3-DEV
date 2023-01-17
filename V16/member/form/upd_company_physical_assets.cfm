<cfsetting showdebugoutput="no">
<cfquery name="get_assetp" datasource="#dsn#">
	SELECT * FROM ASSET_P WHERE ASSETP_ID = #assetp_id#
</cfquery>
<cfquery name="GET_ASSET_STATE" datasource="#DSN#">
	SELECT ASSET_STATE_ID, ASSET_STATE FROM ASSET_STATE ORDER BY ASSET_STATE
</cfquery>
<cfquery name="get_company_partner" datasource="#dsn#">
	SELECT * FROM COMPANY_PARTNER WHERE COMPANY_ID = #attributes.cpid#
</cfquery>
<cfquery name="get_country_flag" datasource="#dsn#">
	SELECT COUNTRY_ID,COUNTRY_CODE FROM SETUP_COUNTRY WHERE COUNTRY_CODE IS NOT NULL
</cfquery>
<!--- Fiziki Varlık Ekle--->
<cf_get_lang_set module_name="assetcare">
<table>
    <cfform name="form_upd_physical_assets" method="post" action="#request.self#?fuseaction=member.emptypopup_upd_company_physical">
      <input name="cpid" id="cpid" type="hidden" value="<cfoutput>#attributes.cpid#</cfoutput>">
      <input name="property" id="property" type="hidden" value="4"><!--- Sözleşmeli olması için default 4--->
      <input id="date_now" type="hidden" name="date_now" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">
        <tr>
            <td><cf_get_lang dictionary_id="59909.Tekne Adı"> *</td>
            <td colspan="3"><cfinput type="text" name="assetp" style="width:270px;" value="#get_assetp.assetp#" maxlength="100"></td>									
            <td><cf_get_lang no='25.Durum'> *</td>
            <td width="160">
                <select name="status" id="status" style="width:150px">
                    <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                    <cfoutput query="get_asset_state">
                    	<option value="#asset_state_id#" <cfif get_assetp.assetp_status eq asset_state_id>selected</cfif>>#asset_state#</option>
                    </cfoutput>
                </select>
            </td>
            <td><cf_get_lang dictionary_id='57629.Açıklama'></td>
         </tr>
            <tr>
                <td><cf_get_lang dictionary_id="30187.Loa"></td>
                <td><input type="text" name="physical_assets_height" id="physical_assets_height" value="<cfoutput>#TLFormat(get_assetp.physical_assets_height)#</cfoutput>" style="width:50px;" onkeyup="FormatCurrency(this,event);"></td>
                <td><cf_get_lang dictionary_id="30331.Tekne Tipi"> *</td>
                <td><cf_wrk_select table_name="ASSET_P_CAT" name="assetp_catid" value="ASSETP_CATID" field="ASSETP_CAT" datasource="#dsn#" width="150"></td>
                <td><cf_get_lang dictionary_id="48007.Charter"></td>
                <td>
                    <input type="hidden" name="company_relation_id" id="company_id" value="<cfoutput>#get_assetp.COMPANY_RELATION_ID#</cfoutput>">
					<input type="text" name="company_relation" id="company_relation" style="width:135px;" value="<cfoutput>#get_par_info(get_assetp.COMPANY_RELATION_ID,1,0,0)#</cfoutput>" onFocus="AutoComplete_Create('company_relation','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','1,0,0','COMPANY_ID','company_relation_id','','3','250');" autocomplete="off">
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2&field_comp_name=form_upd_physical_assets.company_relation&field_comp_id=form_upd_physical_assets.company_relation_id</cfoutput>','list','popup_list_pars')"><img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='57734.seçiniz'>" border="0" align="absmiddle"></a>
                </td>
                <td rowspan="4" valign="top"><textarea name="assetp_detail" id="assetp_detail" style="width:150px;height:95px;"><cfoutput>#get_assetp.assetp_detail#</cfoutput></textarea></td>
            </tr>
            <tr>
            	<td><cf_get_lang dictionary_id="48017.Draught"></td>
                <td><input type="text" name="physical_assets_size" id="physical_assets_size" value="<cfoutput>#TLFormat(get_assetp.physical_assets_size)#</cfoutput>" style="width:50px;" onkeyup="FormatCurrency(this,event);"></td>
                <td><cf_get_lang dictionary_id="48019.Bayrak"></td>
                <td><select name="physical_assets_flag" id="physical_assets_flag" style="width:150px;">
                      <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                      <cfoutput query="get_country_flag">
                      	<option value="#country_id#"<cfif get_assetp.country_id eq get_country_flag.country_id>selected</cfif>>#country_code#</option>
                      </cfoutput>
                    </select>
               </td>
               <td><cf_get_lang dictionary_id="49224.Geldiği Liman"></td>
                <td><cfinput type="text" name="serial_number" maxlength="50" value="#get_assetp.SERIAL_NO#" style="width:150px;"></td>
            </tr>
            <tr>
            	<td><cf_get_lang dictionary_id="49228.Beam"></td>
                <td><input type="text" name="physical_assets_width" id="physical_assets_width" value="<cfoutput>#TLFormat(get_assetp.physical_assets_width)#</cfoutput>" style="width:50px;" onkeyup="FormatCurrency(this,event);"></td>
                <td><cf_get_lang dictionary_id="58847.Marka"></td>
            	<td><cfinput type="text" name="special_code" value="#get_assetp.PRIMARY_CODE#" maxlength="50" style="width:150"></td>
                <td><cf_get_lang dictionary_id="48058.Bağlandığı Liman"></td>
                <td><input type="text" name="inventory_number" id="inventory_number" maxlength="50" value="<cfoutput>#get_assetp.inventory_number#</cfoutput>" style="width:150px;"></td>
            </tr>
            <tr>
            	<td><cf_get_lang dictionary_id="44829.Net Ton"></td>
                <td><input type="text" name="physical_assets_weight" id="physical_assets_weight" value="<cfoutput>#TLFormat(get_assetp.physical_assets_weight)#</cfoutput>" style="width:50px;" onkeyup="FormatCurrency(this,event);"></td>
                <td><cf_get_lang dictionary_id='58225.Model'> *</td>
                <td><select name="make_year" id="make_year" style="width:150px;">
                      <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                      	<cfset yil = dateformat(date_add("yyyy",1,now()),"yyyy")>
                        <cfoutput>
                            <cfloop from="#yil#" to="1970" index="i" step="-1">
                              <option value="#i#"<cfif get_assetp.make_year eq i>selected</cfif>>#i#</option>
                            </cfloop>
                        </cfoutput>
                    </select>
                </td>
             <td><cf_get_lang dictionary_id="57628.Giriş Tarihi"> *</td>
            <td><cfsavecontent variable="message"><cf_get_lang dictionary_id="57628.Giriş Tarihi">!</cfsavecontent>
                <cfinput type="text" name="start_date" value="#dateformat(get_assetp.SUP_COMPANY_DATE,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#" style="width:65px">
                <cf_wrk_date_image date_field="start_date" date_form="form_upd_physical_assets">
            </td>
        </tr>
        <tr>
            <td colspan="2"><div id="show_physical_info"></div></td>
            <td colspan="5"  style="text-align:right;">
            	<cfsavecontent variable="message"><cf_get_lang dictionary_id="57464.güncelle"></cfsavecontent>
                <input type="button" onclick="control_();" value="<cfoutput>#message#</cfoutput>" />
            </td>
        </tr>
    </cfform>
</table>
<script type="text/javascript">
function control_()
{
	if (document.form_upd_physical_assets.assetp.value == "")
	{
		alert("<cf_get_lang dictionary_id='47935.Varlık Adını Girmediniz !'>");
		document.form_upd_physical_assets.assetp.focus();
		return false;
	}
	x = document.form_upd_physical_assets.assetp_catid.selectedIndex;
	if (document.form_upd_physical_assets.assetp_catid[x].value == "")
	{ 
		alert ("<cf_get_lang dictionary_id='48419.Lütfen Varlık Tipi Seçiniz'> !");
		document.form_upd_physical_assets.assetp_catid.focus();
		return false;
	}
	if(document.form_upd_physical_assets.start_date.value == "")
	{
		alert("<cf_get_lang dictionary_id='47957.Alış Tarihi Girmelisiniz'>!");
		document.form_upd_physical_assets.start_date.focus();
		return false;
	}		
	if(document.form_upd_physical_assets.status.value == "")
	{
		alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57756.Durum'>");
		document.form_upd_physical_assets.status.focus();
		return false;
	}		
	if(!CheckEurodate(document.form_upd_physical_assets.start_date.value,"<cf_get_lang dictionary_id='47893.Alış tarihi'>"))
	{
		return false;
	}
	if(!date_check(document.form_upd_physical_assets.start_date,document.form_upd_physical_assets.date_now,"<cf_get_lang dictionary_id='48423.Alış Tarihini Kontrol Ediniz'>!"))
	{
		return false;
	}
	t = document.form_upd_physical_assets.make_year.selectedIndex;
	if (document.form_upd_physical_assets.make_year[t].value == "")
	{ 
		alert ("<cf_get_lang dictionary_id='48424.Lütfen Model Seçiniz'> !");
		return false;
	}
	x = (250 - form_upd_physical_assets.assetp_detail.value.length);
	if(x < 0)
	{ 
		alert ("<cf_get_lang dictionary_id='57629.Açıklama'> "+ ((-1) * x) +" <cf_get_lang dictionary_id='29538.Karakter Uzun'>");
		return false;
	}
	AjaxFormSubmit('form_upd_physical_assets','show_physical_info','1',"Güncelleniyor..","Güncellendi",'<cfoutput>#request.self#?fuseaction=member.popupajax_my_company_assets&cpid=#attributes.cpid#</cfoutput>','LIST_MY_COMPANY_ASSETS');
	gizle_goster(upd_assetp<cfoutput>#assetp_id#</cfoutput>);
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
<cfabort>
