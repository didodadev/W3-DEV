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
<cfparam name="attributes.product_quantity" default="1">
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
        <td class="dpht">&nbsp;<cf_get_lang_main no='3049.Özel Tasarım'> <cf_get_lang_main no='52.Güncelle'> </td>
        <td class="dphb">
        	<cfoutput>
            <a href="javascript://" onClick="design_delete_row()"><img src="/images/delete.gif" border="0" title="<cf_get_lang_main no ='51.Sil'>" ></a>&nbsp;
            <a href="javascript://" onClick="gizle_goster(creative_detail);connectAjax();gizle_goster_nested('tasarim_goster','tasarim_gizle');">
            	<img id="tasarim_goster" style="cursor:pointer;" src="/images/arrow_down.png" title="<cf_get_lang_main no ='2850.Malzeme ve İşçilik Bilgileri'> <cf_get_lang_main no ='1184.Göster'>">
             	<img id="tasarim_gizle" style="cursor:pointer;display:none;" src="/images/arrow_up.png" title="<cf_get_lang_main no ='2850.Malzeme ve İşçilik Bilgileri'> <cf_get_lang_main no ='1216.Gizle'>">
            </a>&nbsp;
            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_cnt_ezgi_private_product_tree_import&design_id=#attributes.design_id#<cfif isdefined("attributes.design_main_row_id") and len(attributes.design_main_row_id)>&design_main_row_id=#attributes.design_main_row_id#</cfif>','wide');"><img src="/images/oriantation.gif" border="0" title="#getLang('main',2852)#"></a>
            <a href="#request.self#?fuseaction=prod.add_ezgi_private_product_tree_creative" ><img src="/images/plus1.gif" border="0" title="<cf_get_lang_main no='170.Ekle'>" ></a>&nbsp;
            <a href="#request.self#?fuseaction=prod.list_ezgi_private_product_tree_creative"><img src="/images/refer.gif" border="0" title="<cf_get_lang_main no ='2853.Listeye Git'>" ></a>&nbsp;
        	<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#iid#&print_type=288','page');"><img src="/images/print.gif" border="0" title="<cf_get_lang_main no='62.Print'>" alt="<cf_get_lang_main no='62.Print'>"></a>
            </cfoutput>
            &nbsp;&nbsp;
        </td>
	</tr>
</table>
<table class="dpm" align="center">
    <tr>
    	<td valign="top" class="dpml">
        	<cfform name="add_design" method="post" action="#request.self#?fuseaction=prod.emptypopup_upd_ezgi_private_product_tree_creative">
            	<cf_form_box>
                    <cfinput name="design_id" id="design_id" value="#attributes.design_id#" type="hidden">
                    <table>
                        <tr>
                            <td>&nbsp;</td>
                            <td style="vertical-align:middle; width:80px"><input type="checkbox" name="is_active" id="is_active" value="1" <cfif get_design.status eq 1>checked</cfif>>&nbsp;<cf_get_lang_main no='81.Aktif'></td>
                            <td width="70px"><cf_get_lang_main no ='107.Cari Hesap'> *</td>
                            <td width="150">
                                <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("get_design.consumer_id")><cfoutput>#get_design.consumer_id#</cfoutput></cfif>">
                                <input type="hidden" name="company_id"  id="company_id" value="<cfif isdefined("get_design.company_id")><cfoutput>#get_design.company_id#</cfoutput></cfif>">
                                <input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("get_design.member_type")><cfoutput>#get_design.member_type#</cfoutput></cfif>">
                                <input type="text" name="member_name"   id="member_name" style="width:130px; height:20px"  value="<cfif isdefined("get_design.member_name") and len(get_design.member_name)><cfoutput>#get_design.member_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','consumer_id,company_id,member_type','','3','250');" autocomplete="off">
                                <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_consumer=add_design.consumer_id&field_comp_id=add_design.company_id&field_member_name=add_design.member_name&field_type=add_design.member_type&select_list=7,8&keyword='+encodeURIComponent(document.add_design.member_name.value),'list');"><img src="/images/plus_thin.gif" style="vertical-align:bottom"></a>
                            </td>
                            <td width="50"><cf_get_lang_main no="1447.Süreç">*</td>
                            <td width="120">
                                <cf_workcube_process is_upd='0' select_value='#get_design.process_stage#' process_cat_width='100' is_detail='1'>
                            </td>
                            <td width="50"><cf_get_lang_main no='217.Açıklama'></td>
                            <td width="170"><textarea name="detail" id="detail" style="width:150px;height:30px;"><cfoutput>#get_design.detail#</cfoutput></textarea></td>
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
                            delete_page_url='#request.self#?fuseaction=prod.emptypopup_del_ezgi_product_tree_creative&is_private=1&design_id=#attributes.design_id#'>
                    </cf_form_box_footer>
                </cf_form_box>
                <table style="width:100%; height:400px" cellpadding="0" cellspacing="0" border="1" bordercolor="silver">
                	<tr>
                    	<td style="width:25%; height:400px; vertical-align:top">
                        	<table style="width:100%;">
                        		<tr valign="top">
                                	<td width="100%" valign="top"><cfinclude template="../display/dsp_ezgi_private_design_main_row.cfm"></td>
                                </tr>
                                <tr valign="top">
                                	<td width="100%" valign="top"><cfinclude template="../display/dsp_ezgi_private_design_package_row.cfm"></td>
                                </tr>
                        	</table>
                        </td>
                        <td width="52%" height="100%" valign="top">
                        	<table style="width:100%; height:400px">
                        		<tr valign="top">
                                	<td width="100%" valign="top"><cfinclude template="../display/dsp_ezgi_private_design_piece_row.cfm"></td>
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
		if(document.member_type.value == '')
		{
			alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang_main no='246.Üye'>!");
			document.getElementById('member_name').focus();
			return false;
		}
	}
	function imp_main_row(main_row_id)
	{
		if(main_row_id==undefined)
			window.location ='<cfoutput>#request.self#?fuseaction=prod.upd_ezgi_private_product_tree_creative&piece_type_select=#attributes.piece_type_select#&sort_id=#attributes.sort_id#&design_id=#attributes.design_id#</cfoutput>';
		else
			window.location ='<cfoutput>#request.self#?fuseaction=prod.upd_ezgi_private_product_tree_creative&piece_type_select=#attributes.piece_type_select#&sort_id=#attributes.sort_id#&design_id=#attributes.design_id#</cfoutput>&design_main_row_id='+main_row_id;
	}
	function imp_package_row(package_row_id)
	{
		if(package_row_id==undefined)
			window.location ="<cfoutput>#request.self#?fuseaction=prod.upd_ezgi_private_product_tree_creative&piece_type_select=#attributes.piece_type_select#&sort_id=#attributes.sort_id#&design_id=#attributes.design_id#<cfif isdefined('attributes.design_main_row_id')>&design_main_row_id=#attributes.design_main_row_id#</cfif></cfoutput>";
		else
			window.location ="<cfoutput>#request.self#?fuseaction=prod.upd_ezgi_private_product_tree_creative&piece_type_select=#attributes.piece_type_select#&sort_id=#attributes.sort_id#&design_id=#attributes.design_id#<cfif isdefined('attributes.design_main_row_id')>&design_main_row_id=#attributes.design_main_row_id#</cfif></cfoutput>&design_package_row_id="+package_row_id;
	}
	function imp_piece_row(piece_row_id)
	{
		if(piece_row_id==undefined)
			window.location ="<cfoutput>#request.self#?fuseaction=prod.upd_ezgi_private_product_tree_creative&piece_type_select=#attributes.piece_type_select#&sort_id=#attributes.sort_id#&design_id=#attributes.design_id#<cfif isdefined('attributes.design_main_row_id')>&design_main_row_id=#attributes.design_main_row_id#</cfif><cfif isdefined('attributes.design_package_row_id')>&design_package_row_id=#attributes.design_package_row_id#</cfif></cfoutput>";
		else
			window.location ="<cfoutput>#request.self#?fuseaction=prod.upd_ezgi_private_product_tree_creative&piece_type_select=#attributes.piece_type_select#&sort_id=#attributes.sort_id#&design_id=#attributes.design_id#<cfif isdefined('attributes.design_main_row_id')>&design_main_row_id=#attributes.design_main_row_id#</cfif><cfif isdefined('attributes.design_package_row_id')>&design_package_row_id=#attributes.design_package_row_id#</cfif></cfoutput>&design_piece_row_id="+piece_row_id;
	}
	function sort_piece_row(sort_id)
	{
		window.location ="<cfoutput>#request.self#?fuseaction=prod.upd_ezgi_private_product_tree_creative&piece_type_select=#attributes.piece_type_select#&sort_id="+sort_id+"&design_id=#attributes.design_id#<cfif isdefined('attributes.design_main_row_id')>&design_main_row_id=#attributes.design_main_row_id#</cfif><cfif isdefined('attributes.design_package_row_id')>&design_package_row_id=#attributes.design_package_row_id#</cfif></cfoutput>";
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
		window.location ="<cfoutput>#request.self#?fuseaction=prod.upd_ezgi_private_product_tree_creative&sort_id=#attributes.sort_id#&piece_type_select="+selected_value+"&design_id=#attributes.design_id#<cfif isdefined('attributes.design_main_row_id')>&design_main_row_id=#attributes.design_main_row_id#</cfif><cfif isdefined('attributes.design_package_row_id')>&design_package_row_id=#attributes.design_package_row_id#</cfif></cfoutput>";
	}
	function design_delete_row()
	{
			
		<cfoutput>pic_number =#get_piece_row.recordcount#;</cfoutput>
		pic_row_list = '';
		for(var pic_rws=1; pic_rws <= pic_number; pic_rws++)
		{
			if(document.getElementById('select_piece_row'+pic_rws)==undefined)
			{
		
			}
			else
			{
				if(document.getElementById('select_piece_row'+pic_rws).checked == true)
				{
					pic_row_list += document.getElementById('select_piece_row'+pic_rws).value+',';
				}
			}
		}
		if(list_len(pic_row_list))
		{
			delete_question = confirm('<cf_get_lang_main no='3571.Silmek İstediğiniz Satır Kalıcı Olarak Silinecektir'>')
			if(delete_question == true)
			{
				pic_row_list = pic_row_list.substr(0,pic_row_list.length-1);//sondaki virgülden kurtariyoruz.
				window.location ="<cfoutput>#request.self#?fuseaction=prod.emptypopup_del_ezgi_private_product_tree_creative_rows&iid=#iid#&sort_id=#attributes.sort_id#</cfoutput>&type=3&pic_row_list="+pic_row_list;
			}
			else
				return false;
		}
		else
			return false;
	}
</script>