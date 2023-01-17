<cfquery name="GET_COMPANY_NAME" datasource="#DSN#">
	SELECT
		COMPANY.FULLNAME,
		COMPANY.COMPANY_EMAIL,
		COMPANY.ISPOTANTIAL
	FROM
		COMPANY,
		COMPANY_PARTNER
	WHERE
		COMPANY.COMPANY_ID = #attributes.cpid# AND
		COMPANY.MANAGER_PARTNER_ID = COMPANY_PARTNER.PARTNER_ID
</cfquery>

<cfif not get_company_name.recordcount>
	<br/><br/>
	<font color="FF0000"><b>&nbsp;&nbsp;&nbsp;<cf_get_lang dictionary_id='58943.Böyle Bir Kayıt Bulunmamaktadır'>!</b></font>
	<cfexit method="exittemplate">
</cfif>
<!--- 20050221 uye ile ilgili bilgiler guncellenebilir mi? is_company_upd degiskeni bu dosyada set edilip asagida kullaniliyor--->
<cfinclude template="../query/get_company_is_updatable.cfm">
<cfset module = 'member'>
<cfset module_id = 4>
<cfset action = 'COMPANY_ID'>
<cfform name="my_form" method="post" action="">
	<cfsavecontent variable="title">
		<cfoutput><cf_get_lang_main no='45.Müşteri'> : #get_company_name.fullname#<cfif get_company_name.ispotantial eq 1> - <cf_get_lang_main no='165.Potansiyel'></cfif></cfoutput>
	</cfsavecontent>
	<cf_box id='dphp' title="#title#">
		<cf_box_search>
			<cfoutput>
				<div class="form-group">
					<input type="text" name="cpid" id="cpid" value="#attributes.cpid#" style="width:100px; vertical-align:top;" onKeyUp="isNumber(this);" onKeyPress="if(event.keyCode==13)send_action();">
				</div>
				<div class="form-group">
					<cf_wrk_search_button search_function='send_action()' button_type="4">
				</div>
				<cfif get_module_user(14)>
					<div class="form-group">
						<a class="ui-btn ui-btn-gray" href="#request.self#?fuseaction=call.list_service&event=add&company_id=#attributes.cpid#" target="blank"><i class="catalyst-support" alt="<cf_get_lang dictionary_id='55064.Sorun Bildir'>" title="<cf_get_lang dictionary_id='55064.Sorun Bildir'>"></i></a>
					</div>
				</cfif>
				<div class="form-group">
					<a href="javascript://" class="ui-btn ui-btn-gray" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_add_note&module=#module#&module_id=#module_id#&action=#action#&action_id=#attributes.cpid#&action_type=0','small')"><i class="catalyst-note" alt="<cf_get_lang dictionary_id='57465.Not Ekle'>" title="<cf_get_lang dictionary_id='57465.Not Ekle'>" ></i></a>
				</div>
				<cfif not listfindnocase(denied_pages,'crm.popup_add_visit')>
					<div class="form-group">
						<a href="javascript://" class="ui-btn ui-btn-gray2" onClick="windowopen('#request.self#?fuseaction=crm.popup_add_visit&company_id=#attributes.cpid#','medium');"><i class="fa fa-calendar-times-o" alt="<cf_get_lang dictionary_id='51645.Ziyaret Ekle'>" title="<cf_get_lang dictionary_id='51645.Ziyaret Ekle'>"></i></a>
					</div>
				</cfif>
				<cfif not listfindnocase(denied_pages,'crm.popup_activity_info')>
					<div class="form-group">
						<a href="javascript://" class="ui-btn ui-btn-gray" onClick="windowopen('#request.self#?fuseaction=crm.popup_activity_info&company_id=#attributes.cpid#','medium');"><i class="fa fa-paper-plane-o" alt="<cf_get_lang dictionary_id='51528.Etkinlik Ekle'>" title="<cf_get_lang dictionary_id='51528.Etkinlik Ekle'>"></i></a>
					</div>
				</cfif>				
				<div class="form-group">
					<cfif len(get_company_name.company_email)><a href="javascript://" class="ui-btn ui-btn-gray2" onClick="windowopen('#request.self#?fuseaction=objects.popup_send_mail&special_mail=#get_company_name.company_email#','medium')"><i class="fa fa-envelope" alt="<cf_get_lang dictionary_id='57475.Mail Gönder'>" title="<cf_get_lang dictionary_id='57475.Mail Gönder'>"></i></a><cfelse><a href="javascript://" class="ui-btn ui-btn-gray2" onclick="alert('<cf_get_lang dictionary_id='60853.Tanımlı bir mail adresi bulunamadı'>!');"><i class="fa fa-envelope" title="<cf_get_lang dictionary_id='57475.Mail Gönder'>"></i></a></cfif>
				</div>
				<cfif not listfindnocase(denied_pages,'crm.popup_add_new_ims_code')>
					<div class="form-group">
						<a href="javascript://" class="ui-btn ui-btn-gray" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=crm.popup_add_new_ims_code&cpid=#attributes.cpid#','small');"><i class="fa fa-exchange" alt="<cf_get_lang dictionary_id='65406.IMS Değişikliği'>" title="<cf_get_lang dictionary_id='65406.IMS Değişikliği'>"></i></a>
					</div>
				</cfif>
			</cfoutput>
		</cf_box_search>
	</cf_box>
</cfform>
<cfif is_company_upd>
	<div class="col col-2 col-md-2 col-sm-2 col-xs-12">
		<cf_box>
			<div id="tree_part"></div>	
		</cf_box>
	</div>
</cfif>
<div class="col <cfif is_company_upd>col-10 col-md-10 col-sm-10<cfelse>col-12 col-md-12 col-sm-12</cfif> col-xs-12">
	<cf_box>
		<div id="head_part"></div>	
	</cf_box>
</div>
<script type="text/javascript">
	<cfif is_company_upd>
		tree_part_div = 'tree_part';
		var send_address_tree = '<cfoutput>#request.self#?fuseaction=crm.emptypopupajax_detail_company_tree</cfoutput>&is_search=1&is_company_upd=#is_company_upd#&frame_fuseaction=popup_company_summary&cpid='+document.getElementById('cpid').value;
		AjaxPageLoad(send_address_tree,tree_part_div ,1);
	</cfif>
	
	head_part_div = 'head_part';
	var send_address_head = '<cfoutput>#request.self#?fuseaction=crm.emptypopupajax_detail_company_head</cfoutput>&is_search=1&is_company_upd=#is_company_upd#&frame_fuseaction=popup_company_summary&cpid='+document.getElementById('cpid').value;
	AjaxPageLoad(send_address_head,head_part_div ,1);

	function send_action()
	{
		if(document.getElementById('cpid').value == '')
		{
			alert("<cf_get_lang dictionary_id='56062.Lütfen Gitmek İstediğiniz Hedef Kodunu Giriniz'>");
			return false;
		}
		else
		{
			<cfoutput>	
				my_form.action='#request.self#?fuseaction=crm.detail_company&cpid='+document.getElementById('cpid').value+'&is_search=1';
			</cfoutput>
			return true;
		}
		
	
	}
</script>
