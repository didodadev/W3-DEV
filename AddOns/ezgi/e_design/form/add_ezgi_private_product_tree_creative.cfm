<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.product_quantity" default="1">
<cf_form_box title="#getLang('main',3053)#">
	<cfform name="add_design" method="post" action="#request.self#?fuseaction=prod.emptypopup_add_ezgi_private_product_tree_creative">
		<table>
            <tr>
				<td>&nbsp;</td>
                <td style="width:80px"><input type="checkbox" name="is_active" id="is_active" value="1" checked><cf_get_lang_main no='81.Aktif'></td>
                <td width="70px"><cf_get_lang_main no ='107.Cari Hesap'> *</td>
                <td width="150px">
                   	<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id")><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
                 	<input type="hidden" name="company_id"  id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">
                 	<input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type")><cfoutput>#attributes.member_type#</cfoutput></cfif>">
                  	<input type="text" name="member_name"   id="member_name" style="width:130px; height:20px"  value="<cfif isdefined("attributes.member_name") and len(attributes.member_name)><cfoutput>#attributes.member_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','consumer_id,company_id,member_type','','3','250');" autocomplete="off">
                 	<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_consumer=add_design.consumer_id&field_comp_id=add_design.company_id&field_member_name=add_design.member_name&field_type=add_design.member_type&select_list=7,8&keyword='+encodeURIComponent(document.add_design.member_name.value),'list');"><img src="/images/plus_thin.gif" style="vertical-align:bottom"></a>
                </td>
                <td width="50px"><cf_get_lang_main no="1447.Süreç">*</td>
				<td width="120px"><cf_workcube_process is_upd='0' process_cat_width='100' is_detail='0'></td>
                <td width="50px"><cf_get_lang_main no='217.Açıklama'></td>
                <td width="170px"><textarea name="detail" id="detail" style="width:150px;height:30px;"></textarea></td>
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

		if(document.member_type.value == '')
		{
			alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : Üye!");
			document.getElementById('member_type').focus();
			return false;
		}

	}
</script>