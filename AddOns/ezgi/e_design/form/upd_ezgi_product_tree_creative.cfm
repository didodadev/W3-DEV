<cfparam name="attributes.sort_id" default="5">
<cfquery name="get_colors" datasource="#dsn3#">
	SELECT * FROM EZGI_COLORS ORDER BY COLOR_NAME
</cfquery>
<cfoutput query="get_colors">
	<cfset 'COLOR_NAME_#COLOR_ID#' = COLOR_NAME>
</cfoutput>
<cfquery name="get_design" datasource="#dsn3#">
	SELECT  * FROM EZGI_DESIGN WHERE DESIGN_ID = #attributes.design_id#
</cfquery>
<cfparam name="attributes.product_quantity" default="#get_design.product_quantity#">
<cfset iid = ''>
<cfif isdefined('attributes.design_id') and len(attributes.design_id)>
 	<cfset iid = '#iid#1-#attributes.design_id#,'>
</cfif>
<cfif isdefined('attributes.design_main_row_id') and len(attributes.design_main_row_id)>
 	<cfset iid = '#iid#2-#attributes.design_main_row_id#,'>
</cfif>
<cfif isdefined('attributes.design_package_row_id') and len(attributes.design_package_row_id)>
 	<cfset iid = '#iid#3-#attributes.design_package_row_id#,'>
</cfif>
<cfif isdefined('attributes.design_piece_row_id') and len(attributes.design_piece_row_id)>
 	<cfset iid = '#iid#4-#attributes.design_piece_row_id#,'>
</cfif>
<cfif right(iid,1) eq ','>
	<cfset iid = left(iid,len(iid)-1)>
</cfif>
<table class="dph">
    <tr>
        <td class="dpht">&nbsp;<cfoutput>#getLang('main',2837)#</cfoutput></td>
        <td class="dphb">
        	<cfoutput>
            <a href="javascript://" onClick="gizle_goster(creative_detail);connectAjax();gizle_goster_nested('tasarim_goster','tasarim_gizle');">
            	<img id="tasarim_goster" style="cursor:pointer;" src="/images/arrow_down.png" title="#getLang('main',2850)# <cf_get_lang_main no ='1184.Göster'>">
             	<img id="tasarim_gizle" style="cursor:pointer;display:none;" src="/images/arrow_up.png" title="#getLang('main',2850)# <cf_get_lang_main no ='1216.Gizle'>">
            	<!---<img src="/images/speedmeter.gif" border="0" title="Malzeme ve İşçilik Bilgileri">--->
            </a>
            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_add_ezgi_product_tree_import&design_id=#attributes.design_id#','list');"><img src="/images/tree_bt.gif" border="0" title="#getLang('main',2851)#"></a>
             <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_cnt_ezgi_product_tree_import&design_id=#attributes.design_id#<cfif isdefined("attributes.design_main_row_id") and len(attributes.design_main_row_id)>&design_main_row_id=#attributes.design_main_row_id#</cfif>','wide');"><img src="/images/oriantation.gif" border="0" title="#getLang('main',2852)#"></a>
            <a href="#request.self#?fuseaction=prod.add_ezgi_product_tree_creative" ><img src="/images/plus1.gif" border="0" title="<cf_get_lang_main no='170.Ekle'>" ></a>
            <a href="#request.self#?fuseaction=prod.cpy_ezgi_product_tree_creative&design_id=#attributes.design_id#"><img src="/images/plus.gif" border="0" title="<cf_get_lang_main no='64.Kopyala'>" ></a>
            <a href="#request.self#?fuseaction=prod.list_ezgi_product_tree_creative"><img src="/images/refer.gif" border="0" title="#getLang('main',2853)#" ></a>
        	<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#iid#&print_type=288','page');"><img src="/images/print.gif" border="0" title="<cf_get_lang_main no='62.Print'>" alt="<cf_get_lang_main no='62.Print'>"></a>
            </cfoutput>
            &nbsp;&nbsp;
        </td>
	</tr>
</table>
<table class="dpm" align="center">
    <tr>
    	<td valign="top" class="dpml">
        	<cfform name="add_design" method="post" action="#request.self#?fuseaction=prod.emptypopup_upd_ezgi_product_tree_creative">
            	<cf_form_box>
                    <cfinput name="design_id" id="design_id" value="#attributes.design_id#" type="hidden">
                    <table>
                        <tr>
                            <td>&nbsp;</td>
                            <td style="vertical-align:middle"><input type="checkbox" name="is_active" id="is_active" value="1" <cfif get_design.status eq 1>checked</cfif>>&nbsp;<cf_get_lang_main no='81.Aktif'></td>
                            <td>&nbsp;</td>
                            <td><input type="checkbox" name="is_prototip" id="is_prototip" value="1" <cfif get_design.is_prototip eq 1>checked</cfif>>&nbsp;<cfoutput>#getLang('main',2854)#</cfoutput></td>
                            <td colspan="5">&nbsp;</td>
                        </tr>
                        <tr>
                            
                           <td width="80"><cf_get_lang_main no ='74.Kategori'> *</td>
                            <td width="200"><cfsavecontent variable="message"><cf_get_lang_main no='782.Girilmesi Zorunlu Alan'>!</cfsavecontent>
                                <input type="hidden" name="product_cat_code" id="product_cat_code" value="<cfif len(get_design.product_cat)><cfoutput>#get_design.product_cat_code#</cfoutput></cfif>">
                                <input type="hidden" name="product_catid" id="product_catid" value="<cfoutput>#get_design.product_catid#</cfoutput>">
                                <cfinput type="text" name="product_cat" id="product_cat" style="width:150px; height:20px" value="#get_design.product_cat#" onFocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID','product_catid','','3','200');">
                                        <a href="javascript://"onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&field_code=add_design.product_cat_code&is_sub_category=1&field_id=add_design.product_catid&field_name=add_design.product_cat','list');"><img src="/images/plus_thin.gif" title="<cf_get_lang_main no='1684.Kategori Ekle'>" style="vertical-align:bottom"></a>
                            </td>
                            <td width="80"><cf_get_lang_main no ='107.Cari Hesap'></td>
                            <td width="150">
                                <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("get_design.consumer_id")><cfoutput>#get_design.consumer_id#</cfoutput></cfif>">
                                <input type="hidden" name="company_id"  id="company_id" value="<cfif isdefined("get_design.company_id")><cfoutput>#get_design.company_id#</cfoutput></cfif>">
                                <input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("get_design.member_type")><cfoutput>#get_design.member_type#</cfoutput></cfif>">
                                <input type="text" name="member_name"   id="member_name" style="width:130px; height:20px"  value="<cfif isdefined("get_design.member_name") and len(get_design.member_name)><cfoutput>#get_design.member_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','consumer_id,company_id,member_type','','3','250');" autocomplete="off">
                                <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_consumer=add_design.consumer_id&field_comp_id=add_design.company_id&field_member_name=add_design.member_name&field_type=add_design.member_type&select_list=7,8&keyword='+encodeURIComponent(document.add_design.member_name.value),'list');"><img src="/images/plus_thin.gif" title="<cf_get_lang_main no='107.Cari Hesap'>" style="vertical-align:bottom"></a>
                            </td>
                            <td width="80"><cf_get_lang_main no ='1239.Türü'> *</td>
                            <td width="170">
                                <select name="design_type" id="design_type" style="width:160px; height:20px">
                                    <option value="0"><cfoutput>#getLang('main',322)#</cfoutput></option>
                                    <option value="1" <cfif get_design.PROCESS_ID eq 1>selected</cfif>><cfoutput>#getLang('prod',429)#+#getLang('stock',371)#+#getLang('main',2848)#</cfoutput></option>
                                    <option value="2" <cfif get_design.PROCESS_ID eq 2>selected</cfif>><cfoutput>#getLang('prod',429)#+#getLang('stock',371)#</cfoutput></option>
                                    <option value="3" <cfif get_design.PROCESS_ID eq 3>selected</cfif>><cfoutput>#getLang('prod',429)#</cfoutput></option>
                                </select>
                            </td>
                            <td width="90"><cf_get_lang_main no="1447.Süreç">*</td>
                            <td width="110">
                                <cf_workcube_process is_upd='0' select_value='#get_design.process_stage#' process_cat_width='100' is_detail='1'>
                            </td>
                            <td width="50" rowspan="2" valign="top"><cf_get_lang_main no='217.Açıklama'></td>
                            <td width="170" rowspan="2"><textarea name="detail" id="detail" style="width:150px;height:50px;"><cfoutput>#get_design.detail#</cfoutput></textarea></td>
                        </tr>
                        <tr>
                            <td valign="top"><cf_get_lang_main no ='1995.Tasarım'> <cf_get_lang_main no ='485.Adı'>*</td>
                            <td valign="top">
                                <cfsavecontent variable="message"><cf_get_lang_main no='782.Girilmesi Zorunlu Alan'>!</cfsavecontent>
                                <cfinput type="text" name="design_name" value="#get_design.design_name#" maxlength="200" required="Yes" message="#message#" style="width:150px; height:20px">
                                <cf_language_info 
                                    table_name="EZGI_DESIGN" 
                                    column_name="DESIGN_NAME" 
                                    column_id_value="#attributes.design_id#" 
                                    maxlength="500" 
                                    datasource="#dsn3#" 
                                    column_id="DESIGN_ID" 
                                    control_type="0">
                            </td>
                            <td valign="top"><cf_get_lang_main no='4.Proje'></td>
                            <td valign="top">
                                <cfif isdefined('get_design.project_head') and len(get_design.project_head)>
                                    <cfset project_id_ = #get_design.project_id#>
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
                                        <option value="#COLOR_ID#" <cfif get_design.color_id eq COLOR_ID>selected</cfif>>#COLOR_NAME#</option>
                                    </cfoutput>
                                </select>
                            </td>
                            <td valign="top"><cfoutput>#getLang('prod',185)#</cfoutput></td>
                            <td valign="top">
                            	<cfsavecontent variable="message1"><cf_get_lang_main no='782.Girilmesi Zorunlu Alan'>!</cfsavecontent>
                                <cfinput type="text" name="product_quantity" value="#get_design.product_quantity#" maxlength="5" required="Yes" message="#message1#" style="width:100px; text-align:right">
                            </td>
                        </tr>
                    </table>
                    <cf_form_box_footer>
                        <cf_record_info 
                            query_name="get_design"
                            record_emp="RECORD_EMP" 
                            record_date="record_date"
                            update_emp="UPDATE_EMP"
                            update_date="update_date">
                        <cf_workcube_buttons 
                            is_upd='1' 
                            add_function='kontrol()'
                            delete_page_url='#request.self#?fuseaction=prod.emptypopup_del_ezgi_product_tree_creative&design_id=#attributes.design_id#'>
                    </cf_form_box_footer>
                </cf_form_box>
                <table style="width:100%; height:400px" cellpadding="0" cellspacing="0" border="1" bordercolor="silver">
                	<tr>
                    	<td style="width:25%; height:400px; vertical-align:top">
                        	<table style="width:100%;">
                        		<tr valign="top">
                                	<td width="100%" valign="top"><cfinclude template="../display/dsp_ezgi_design_main_row.cfm"></td>
                                </tr>
                                <tr valign="top">
                                	<td width="100%" valign="top"><cfinclude template="../display/dsp_ezgi_design_package_row.cfm"></td>
                                </tr>
                        	</table>
                        </td>
                        <td width="52%" height="100%" valign="top">
                        	<table style="width:100%; height:400px">
                        		<tr valign="top">
                                	<td width="100%" valign="top"><cfinclude template="../display/dsp_ezgi_design_piece_row.cfm"></td>
                                </tr>
                        	</table>
                        </td>
                        <td id="creative_detail" class="nohover" style="display:none; height:100%; width:25%; vertical-align:top" >
                        	<div align="left" id="DISPLAY_CREATIVE_DETAIL" style="border:none;"></div>
                   		</td>
                    </tr>
                </table>
         	</cfform>
     	</td>
 	</tr>
</table>
<script type="text/javascript">
	function connectAjax()
	{
		
		var bb = '<cfoutput>#request.self#?fuseaction=prod.emptypopup_ajax_ezgi_product_tree_creative_info&PRODUCT_QUANTITY=#attributes.PRODUCT_QUANTITY#&design_id=#attributes.design_id#<cfif isdefined('attributes.design_main_row_id')>&design_main_row_id=#attributes.design_main_row_id#</cfif><cfif isdefined('attributes.design_package_row_id')>&design_package_row_id=#attributes.design_package_row_id#</cfif><cfif isdefined('attributes.design_piece_row_id')>&design_piece_row_id=#attributes.design_piece_row_id#</cfif></cfoutput>';
		AjaxPageLoad(bb,'DISPLAY_CREATIVE_DETAIL',1);
	}
	function kontrol()
	{
		if(document.add_design.design_type.value == 0)
		{
			alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang_main no='218.Tip'>  !");
			document.getElementById('design_type').focus();
			return false;
		}
		if(document.add_design.color_type.value == 0)
		{
			alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang_main no='3002.Renk'>  !");
			document.getElementById('color_type').focus();
			return false;
		}
		if(document.add_design.product_catid.value <= 0 || document.add_design.product_cat.value == '')
		{
			alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang_main no='74.Kategori'>!");
			document.getElementById('product_cat').focus();
			return false;
		}
	}
	function imp_main_row(main_row_id)
	{
		if(main_row_id==undefined)
			window.location ='<cfoutput>#request.self#?fuseaction=prod.upd_ezgi_product_tree_creative&piece_type_select=#attributes.piece_type_select#&sort_id=#attributes.sort_id#&design_id=#attributes.design_id#</cfoutput>';
		else
			window.location ='<cfoutput>#request.self#?fuseaction=prod.upd_ezgi_product_tree_creative&piece_type_select=#attributes.piece_type_select#&sort_id=#attributes.sort_id#&design_id=#attributes.design_id#</cfoutput>&design_main_row_id='+main_row_id;
	}
	function imp_package_row(package_row_id)
	{
		if(package_row_id==undefined)
			window.location ="<cfoutput>#request.self#?fuseaction=prod.upd_ezgi_product_tree_creative&piece_type_select=#attributes.piece_type_select#&sort_id=#attributes.sort_id#&design_id=#attributes.design_id#<cfif isdefined('attributes.design_main_row_id')>&design_main_row_id=#attributes.design_main_row_id#</cfif></cfoutput>";
		else
			window.location ="<cfoutput>#request.self#?fuseaction=prod.upd_ezgi_product_tree_creative&piece_type_select=#attributes.piece_type_select#&sort_id=#attributes.sort_id#&design_id=#attributes.design_id#<cfif isdefined('attributes.design_main_row_id')>&design_main_row_id=#attributes.design_main_row_id#</cfif></cfoutput>&design_package_row_id="+package_row_id;
	}
	function imp_piece_row(piece_row_id)
	{
		if(piece_row_id==undefined)
			window.location ="<cfoutput>#request.self#?fuseaction=prod.upd_ezgi_product_tree_creative&piece_type_select=#attributes.piece_type_select#&sort_id=#attributes.sort_id#&design_id=#attributes.design_id#<cfif isdefined('attributes.design_main_row_id')>&design_main_row_id=#attributes.design_main_row_id#</cfif><cfif isdefined('attributes.design_package_row_id')>&design_package_row_id=#attributes.design_package_row_id#</cfif></cfoutput>";
		else
			window.location ="<cfoutput>#request.self#?fuseaction=prod.upd_ezgi_product_tree_creative&piece_type_select=#attributes.piece_type_select#&sort_id=#attributes.sort_id#&design_id=#attributes.design_id#<cfif isdefined('attributes.design_main_row_id')>&design_main_row_id=#attributes.design_main_row_id#</cfif><cfif isdefined('attributes.design_package_row_id')>&design_package_row_id=#attributes.design_package_row_id#</cfif></cfoutput>&design_piece_row_id="+piece_row_id;
	}
	function sort_piece_row(sort_id)
	{
		window.location ="<cfoutput>#request.self#?fuseaction=prod.upd_ezgi_product_tree_creative&piece_type_select=#attributes.piece_type_select#&sort_id="+sort_id+"&design_id=#attributes.design_id#<cfif isdefined('attributes.design_main_row_id')>&design_main_row_id=#attributes.design_main_row_id#</cfif><cfif isdefined('attributes.design_package_row_id')>&design_package_row_id=#attributes.design_package_row_id#</cfif></cfoutput>";
	}
	function relation_product_row(type,satir_no)
	{
		if(type == 3) /*Parça İlişkilendirme*/
		{
		windowopen("<cfoutput>#request.self#</cfoutput>?fuseaction=prod.popup_add_ezgi_product_tree_creative_piece_relation&piece_id="+satir_no,'wide');
		}
		if(type == 2) /*Paket İlişkilendirme*/
		{
		windowopen("<cfoutput>#request.self#</cfoutput>?fuseaction=prod.popup_add_ezgi_product_tree_creative_piece_relation&package_id="+satir_no,'wide');
		}
	}
	function piece_type_select_(selected_value)
	{
		window.location ="<cfoutput>#request.self#?fuseaction=prod.upd_ezgi_product_tree_creative&sort_id=#attributes.sort_id#&piece_type_select="+selected_value+"&design_id=#attributes.design_id#<cfif isdefined('attributes.design_main_row_id')>&design_main_row_id=#attributes.design_main_row_id#</cfif><cfif isdefined('attributes.design_package_row_id')>&design_package_row_id=#attributes.design_package_row_id#</cfif></cfoutput>";
	}
</script>