<cfsetting showdebugoutput="no">
<cfquery name="GET_ASSET_STATE" datasource="#DSN#">
	SELECT ASSET_STATE_ID, ASSET_STATE FROM ASSET_STATE ORDER BY ASSET_STATE
</cfquery>
<cfquery name="get_company_partner" datasource="#dsn#">
	SELECT 
        PARTNER_ID, 
        COMPANY_PARTNER_STATUS, 
        COMPANY_ID, 
        _PARTNER_CARD_NO, 
        COUNTY, 
        COUNTRY, 
        SEMT, 
        START_DATE, 
        DISTRICT_ID 
    FROM 
	    COMPANY_PARTNER 
    WHERE 
    	COMPANY_ID = #attributes.cpid#
</cfquery>
<cfquery name="get_country_flag" datasource="#dsn#">
	SELECT COUNTRY_ID,COUNTRY_CODE FROM SETUP_COUNTRY WHERE COUNTRY_CODE IS NOT NULL
</cfquery>
<!--- Fiziki Varlık Ekle--->
<cf_get_lang_set module_name="assetcare">
<table border="0">
    <cfform name="form_add_physical_assets" method="post" action="#request.self#?fuseaction=member.emptypopup_add_company_physical">
      <input name="property" id="property" type="hidden" value="4"><!--- Sözleşmeli olması için default 4--->
      <input name="cpid" id="cpid" type="hidden" value="<cfoutput>#attributes.cpid#</cfoutput>">
      <input  name="date_now" id="date_now" type="hidden" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">
        <tr height="20">
            <td><cf_get_lang dictionary_id="29910.Tekne"> <cf_get_lang dictionary_id='57897.Adı'> *</td>
            <td colspan="3"><cfinput type="text" name="assetp" style="width:270px;" value="" maxlength="100"></td>									
            <td><cf_get_lang dictionary_id='57756.Durum'> *</td>
            <td width="160">
                <select name="status" id="status" style="width:150">
                    <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                    <cfoutput query="get_asset_state">
                    	<option value="#asset_state_id#">#asset_state#</option>
                    </cfoutput>
                </select>
            </td>
            <td><cf_get_lang dictionary_id='57629.Açıklama'></td>
         </tr>
            <tr>
                <td><cf_get_lang dictionary_id="48006.Loa"></td>
                <td><input type="text" name="brand_type_cat_height" id="brand_type_cat_height" value="" style="width:50px;" onkeyup="FormatCurrency(this,event);"></td>
                <td><cf_get_lang dictionary_id="29910.Tekne"> <cf_get_lang dictionary_id="48127.Tipi"> *</td>
                <td><cf_wrk_select table_name="ASSET_P_CAT" name="assetp_catid" value="ASSETP_CATID" field="ASSETP_CAT" datasource="#dsn#" width="150"></td>
                <td><cf_get_lang dictionary_id="48007.Charter"></td>
                <td><input type="hidden" name="company_relation_id" id="company_id" value="">
					<input type="text" name="company_relation" id="company_relation" style="width:150px;" value="" onFocus="AutoComplete_Create('company_relation','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','1,0,0','COMPANY_ID','company_relation_id','','3','250');" autocomplete="off">
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2&field_comp_name=form_add_physical_assets.company_relation&field_comp_id=form_add_physical_assets.company_relation_id</cfoutput>','list','popup_list_pars')"><img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='57734.seçiniz'>" border="0" align="absmiddle"></a>
                </td>
                <td rowspan="4" valign="top"><textarea name="assetp_detail" id="assetp_detail" style="width:150px;height:95px;"></textarea></td>
            </tr>
            <tr>
            	<td><cf_get_lang dictionary_id="48017.Draught"></td>
                <td><input type="text" name="brand_type_cat_depth" id="brand_type_cat_depth" value="" style="width:50px;" onkeyup="FormatCurrency(this,event);"></td>
                <td><cf_get_lang dictionary_id="48019.Bayrak"></td>
                <td><select name="physical_assets_flag" id="physical_assets_flag" style="width:150px;">
                      <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                      <cfoutput query="get_country_flag">
                      	<option value="#country_id#">#country_code#</option>
                      </cfoutput>
                    </select>
               </td>
               <td><cf_get_lang dictionary_id="48038.Geldiği Liman"></td>
                <td><input type="text" name="first_port" id="first_port" maxlength="50" value="" style="width:150px;"></td>
            </tr>
            <tr>
            	<td><cf_get_lang dictionary_id="48040.Beam"></td>
                <td><input type="text" name="brand_type_cat_width" id="brand_type_cat_width" value="" style="width:50px;" onkeyup="FormatCurrency(this,event);"></td>
                <td><cf_get_lang dictionary_id="58847.Marka"></td>
            	<!---<td><cfinput type="text" name="special_code" value="" maxlength="50" style="width:150"></td>--->
                <td><input type="hidden" name="brand_id" id="brand_id" value="">
                    <input type="hidden" name="brand_type_id" id="brand_type_id" value="">
                    <input type="hidden" name="brand_type_cat_id" id="brand_type_cat_id" value="">
                    <cf_wrkBrandTypeCat
                    width="150"
                    compenent_name="getBrandTypeCat1"
                    returnInputValue="brand_name,brand_type_cat_id,brand_id,brand_type_id,brand_type_cat_width,brand_type_cat_height,brand_type_cat_weight,brand_type_cat_depth"
                    returnQueryValue="BRAND_TYPE_CAT_HEAD,BRAND_TYPE_CAT_ID,BRAND_ID,BRAND_TYPE_ID,BRAND_TYPE_CAT_WIDTH,BRAND_TYPE_CAT_HEIGHT,BRAND_TYPE_CAT_WEIGHT,BRAND_TYPE_CAT_DEPTH"
                    BRAND_TYPE_CAT_NAME="1"          
                    boxwidth="240"
                    boxheight="150">
                </td>
                <td><cf_get_lang dictionary_id="48058.Bağlandığı Liman"></td>
                <td><input type="text" name="last_port" id="last_port" value="" maxlength="50" style="width:150px;"></td>
            </tr>
            <tr>
            	<td><cf_get_lang dictionary_id="48061.Net Ton"></td>
                <td><input type="text" name="brand_type_cat_weight" id="brand_type_cat_weight" value="" style="width:50px;" onkeyup="FormatCurrency(this,event);"></td>
                <td><cf_get_lang dictionary_id='58225.Model'> *</td>
                <td><select name="make_year" id="make_year" style="width:150px;">
                      <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                      	<cfset yil = dateformat(date_add("yyyy",1,now()),"yyyy")>
                        <cfoutput>
                            <cfloop from="#yil#" to="1970" index="i" step="-1">
                              <option value="#i#">#i#</option>
                            </cfloop>
                        </cfoutput>
                    </select>
                </td>
             <td><cf_get_lang dictionary_id="57628.Giriş Tarihi">*</td>
            <td><cfsavecontent variable="message"><cf_get_lang dictionary_id="57782.Tarih Değerini kontrol ediniz">!</cfsavecontent>
                <cfinput type="text" name="start_date" id="start_date" value="" maxlength="10" validate="#validate_style#" message="#message#" style="width:65px">
                <cf_wrk_date_image date_field="start_date" date_form="form_add_physical_assets">
            </td>
        </tr>
        <tr>
            <td colspan="2"><div id="show_physical_info"></div></td>
            <td colspan="5"  style="text-align:right;">
            	<cfsavecontent variable="message"><cf_get_lang dictionary_id="57461.Kaydet"></cfsavecontent>
                <input type="button" onclick="control_();" value="<cfoutput>#message#</cfoutput>" />
               <!--- <cf_workcube_buttons is_upd='0'>--->
            </td>
        </tr>
    </cfform>
</table>

<script type="text/javascript">
function control_()
{
	if (document.form_add_physical_assets.assetp.value == "")
	{
		alert("<cf_get_lang dictionary_id='47935.Varlık Adını Girmediniz !'>");
		document.form_add_physical_assets.assetp.focus();
		return false;
	}
	x = document.form_add_physical_assets.assetp_catid.selectedIndex;
	if (document.form_add_physical_assets.assetp_catid[x].value == "")
	{ 
		alert ("<cf_get_lang dictionary_id='48419.Lütfen Varlık Tipi Seçiniz'> !");
		document.form_add_physical_assets.assetp_catid.focus();
		return false;
	}
	if(document.form_add_physical_assets.start_date.value == "")
	{
		alert("<cf_get_lang dictionary_id='47957.Alış Tarihi Girmelisiniz'>!");
		document.form_add_physical_assets.start_date.focus();
		return false;
	}		
	if(document.form_add_physical_assets.status.value == "")
	{
		alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id ='57756.Durum'>");
		document.form_add_physical_assets.status.focus();
		return false;
	}		
	if(!CheckEurodate(document.form_add_physical_assets.start_date.value,"<cf_get_lang dictionary_id='47893.Alış tarihi'>"))
	{
		return false;
	}
	if(!date_check(document.form_add_physical_assets.start_date,document.form_add_physical_assets.date_now,"<cf_get_lang dictionary_id='48423.Alış Tarihini Kontrol Ediniz'>!"))
	{
		return false;
	}
	t = document.form_add_physical_assets.make_year.selectedIndex;
	if (document.form_add_physical_assets.make_year[t].value == "")
	{ 
		alert ("<cf_get_lang dictionary_id='48424.Lütfen Model Seçiniz'> !");
		return false;
	}
	x = (250 - form_add_physical_assets.assetp_detail.value.length);
	if(x < 0)
	{ 
		alert ("<cf_get_lang dictionary_id='57629.Açıklama'> "+ ((-1) * x) +" <cf_get_lang dictionary_id='29538.Karakter Uzun'>");
		return false;
	}
	AjaxFormSubmit('form_add_physical_assets','show_physical_info','1',"Kaydediliyor..","Kaydedildi",'<cfoutput>#request.self#?fuseaction=member.popupajax_my_company_assets&cpid=#attributes.cpid#</cfoutput>','LIST_MY_COMPANY_ASSETS');
	gizle_goster(add_assetp);
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
<cfabort>
