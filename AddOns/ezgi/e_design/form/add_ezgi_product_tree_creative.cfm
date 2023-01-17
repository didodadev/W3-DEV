<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.product_catid" default="">
<cfquery name="get_default" datasource="#dsn3#">
	SELECT ISNULL(DEFAULT_PRODUCTION_AMOUNT,1) AS DEFAULT_PRODUCTION_AMOUNT, DEFAULT_IS_STATION_OR_IS_OPERATION FROM EZGI_DESIGN_DEFAULTS
</cfquery>
<cfparam name="attributes.product_quantity" default="#get_default.DEFAULT_PRODUCTION_AMOUNT#">
<cfquery name="get_colors" datasource="#dsn3#">
	SELECT * FROM EZGI_COLORS ORDER BY COLOR_NAME
</cfquery>
<cf_form_box title="#getLang('settings',1929)#">
	<cfform name="add_design" method="post" action="#request.self#?fuseaction=prod.emptypopup_add_ezgi_product_tree_creative">
		<table>
            <tr>
				<td>&nbsp;</td>
				<td><input type="checkbox" name="is_active" id="is_active" value="1" checked><cf_get_lang_main no='81.Aktif'></td>
				<td colspan="7">&nbsp;</td>
            </tr>
            <tr>
                
                <td width="80"><cf_get_lang_main no ='74.Kategori'> *</td>
                <td width="170"><cfsavecontent variable="message"><cf_get_lang_main no='782.Girilmesi Zorunlu Alan'>!</cfsavecontent>
                    <input type="hidden" name="product_cat_code" id="product_cat_code" value="<cfif len(attributes.product_cat)><cfoutput>#attributes.product_cat_code#</cfoutput></cfif>">
                  	<input type="hidden" name="product_catid" id="product_catid" value="<cfoutput>#attributes.product_catid#</cfoutput>">
                  	<cfinput type="text" name="product_cat" id="product_cat" style="width:150px; height:20px" value="#attributes.product_cat#" onFocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID','product_catid','','3','200');">
                            <a href="javascript://"onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&field_code=add_design.product_cat_code&is_sub_category=1&field_id=add_design.product_catid&field_name=add_design.product_cat','list');"><img src="/images/plus_thin.gif" title="<cf_get_lang_main no='1684.Kategori Ekle'>" style="vertical-align:bottom"></a>
              	</td>
                <td width="80"><cf_get_lang_main no ='107.Cari Hesap'></td>
                <td width="150">
                   	<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id")><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
                 	<input type="hidden" name="company_id"  id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">
                 	<input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type")><cfoutput>#attributes.member_type#</cfoutput></cfif>">
                  	<input type="text" name="member_name"   id="member_name" style="width:130px; height:20px"  value="<cfif isdefined("attributes.member_name") and len(attributes.member_name)><cfoutput>#attributes.member_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','consumer_id,company_id,member_type','','3','250');" autocomplete="off">
                 	<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_consumer=add_design.consumer_id&field_comp_id=add_design.company_id&field_member_name=add_design.member_name&field_type=add_design.member_type&select_list=7,8&keyword='+encodeURIComponent(document.add_design.member_name.value),'list');"><img src="/images/plus_thin.gif" title="<cf_get_lang_main no='107.Cari Hesap'>" style="vertical-align:bottom"></a>
                </td>
                <td width="80"><cf_get_lang_main no ='1239.Türü'> *</td>
                <td width="170">
                	<select name="design_type" id="design_type" style="width:160px;height:20px">
                    	<option value="0"><cf_get_lang_main no='322.Seçiniz'></option>
                    	<option value="1"><cfoutput>#getLang('prod',429)#+#getLang('stock',371)#+#getLang('main',2848)#</cfoutput></option>
                        <option value="2"><cfoutput>#getLang('prod',429)#+#getLang('stock',371)#</cfoutput></option>
                        <option value="3"><cfoutput>#getLang('prod',429)#</cfoutput></option>
                    </select>
                </td>
                <td width="90"><cf_get_lang_main no="1447.Süreç">*</td>
				<td width="110"><cf_workcube_process is_upd='0' process_cat_width='100' is_detail='0'></td>
                <td width="50" rowspan="2" valign="top"><cf_get_lang_main no='217.Açıklama'></td>
                <td width="170" rowspan="2"><textarea name="detail" id="detail" style="width:150px;height:50px;"></textarea></td>
            </tr>
            <tr>
                <td valign="top"><cf_get_lang_main no ='1995.Tasarım'> <cf_get_lang_main no ='485.Adı'>*</td>
                <td valign="top">
                    <cfsavecontent variable="message"><cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang_main no ='1995.Tasarım'> <cf_get_lang_main no ='485.Adı'>!</cfsavecontent>
                    <cfinput type="text" name="design_name" value="" maxlength="200" required="Yes" message="#message#" style="width:150px;">
                </td>
                <td valign="top"><cf_get_lang_main no='4.Proje'></td>
                <td valign="top">
                	<cfif isdefined('attributes.project_head') and len(attributes.project_head)>
                     	<cfset project_id_ = #attributes.project_id#>
                 	<cfelse>
                     	<cfset project_id_ = ''>
                  	</cfif>
                	<cf_wrkproject
                     	project_id="#project_id_#"
                     	width="130"
                    	agreementno="1" customer="2" employee="3" priority="4" stage="5"
                      	boxwidth="600"
                     	boxheight="400">
                
                </td>
                <td valign="top"><cf_get_lang_main no ='1968.Renk Düzenle'> *</td>
                <td valign="top">
                	<select name="color_type" id="color_type" style="width:130px; height:20px">
                    	<option value="0"><cfoutput>#getLang('main',322)#</cfoutput></option>
                        <cfoutput query="get_colors">
                        	<option value="#COLOR_ID#">#COLOR_NAME#</option>
                        </cfoutput>
                    </select>
                </td>
                <td valign="top"><cfoutput>#getLang('prod',185)#</cfoutput></td>
                <td valign="top"><cfsavecontent variable="message1"><cf_get_lang_main no='782.Girilmesi Zorunlu Alan'>!</cfsavecontent>
                                <cfinput type="text" name="product_quantity" value="#attributes.product_quantity#" maxlength="5" required="Yes" message="#message1#" style="width:100px; height:20px; text-align:right"></td>
            </tr>
        </table>
	    <cf_form_box_footer>
		    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
	    </cf_form_box_footer>
	</cfform>
</cf_form_box>
<script type="text/javascript">
	function kontrol()
	{
		if(document.add_design.design_type.value == 0)
		{
			alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang_main no='1239.Türü'> !");
			document.getElementById('design_type').focus();
			return false;
		}
		if(document.add_design.color_type.value == 0)
		{
			alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang_main no='3002.Renk'> !");
			document.getElementById('color_type').focus();
			return false;
		}
		if(document.add_design.product_catid.value <= 0)
		{
			alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang_main no='74.Kategori'>!");
			document.getElementById('product_cat').focus();
			return false;
		}
	}
</script>