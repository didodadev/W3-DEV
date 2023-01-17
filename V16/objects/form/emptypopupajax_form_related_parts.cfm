<cfsetting showdebugoutput="no">
<cfset cfc=createObject("component","V16.training_management.cfc.training_survey")> 
<cfset get_related_parts=cfc.GetRelatedParts(survey_id:attributes.survey_id)>
<div id="relation_parts1"></div><!--- AjaxFormSubmit icin kullaniliyor --->
<cfform name="form_related_parts" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_ajax_related_parts">
	<input type="hidden" name="survey_id" id="survey_id" value="<cfoutput>#attributes.survey_id#</cfoutput>">
	<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_related_parts.recordCount#</cfoutput>">
	<cf_box_elements>
		<div class="col col-12 form-inline">
			<div class="form-group">
				<label>
					<input type="hidden" name="type_id" id="type_id" value="<cfoutput>#attributes.type#</cfoutput>">
						<cfif attributes.type eq 1><cf_get_lang dictionary_id='57612.Fırsat'>
						<cfelseif attributes.type eq 2><cf_get_lang dictionary_id='57653.İçerik'>
						<cfelseif attributes.type eq 3><cf_get_lang dictionary_id='57446.Kampanya'>
						<cfelseif attributes.type eq 4><cf_get_lang dictionary_id='57657.Ürün'>
						<cfelseif attributes.type eq 5><cf_get_lang dictionary_id='57416.Proje'>
						<cfelseif attributes.type eq 6><cf_get_lang dictionary_id='29776.Deneme Süresi'>
						<cfelseif attributes.type eq 7><cf_get_lang dictionary_id='57996.İşe Alım'>
						<cfelseif attributes.type eq 8><cf_get_lang dictionary_id='58003.Performans'>
						<cfelseif attributes.type eq 9><cf_get_lang dictionary_id='57419.Eğitim'>
						<cfelseif attributes.type eq 10><cf_get_lang dictionary_id='29832.İşten Çıkış'>  
						<cfelseif attributes.type eq 11><cf_get_lang dictionary_id='58445.İş'> 
						<cfelseif attributes.type eq 12><cf_get_lang dictionary_id='30007.Satış Teklifleri'>
						<cfelseif attributes.type eq 13><cf_get_lang dictionary_id='57611.Sipariş'>
						<cfelseif attributes.type eq 14><cf_get_lang dictionary_id='58662.Anket'>
						<cfelseif attributes.type eq 15><cf_get_lang dictionary_id='30048.Satınalma Teklifleri'>
						<cfelseif attributes.type eq 16><cf_get_lang dictionary_id='29465.Etkinlik'>
						<cfelseif attributes.type eq 17><cf_get_lang dictionary_id='60095.Mal Kabul'>
						<cfelseif attributes.type eq 18><cf_get_lang dictionary_id='45452.Sevkiyat'>
						<cfelseif attributes.type eq 19><cf_get_lang dictionary_id='57438.Call Center'>
						</cfif>
				</label>
			</div>
			<div class="form-group">	
				<div class="input-group">
					<input type="hidden" name="related_id" id="related_id" value="" readonly>
					<input type="text" name="related_head" id="related_head" value="" style="width:200px" readonly>
					<span class="input-group-addon btnPointer icon-ellipsis" onclick="open_related_popup(<cfoutput>#attributes.type#</cfoutput>);"></span><!--- document.getElementById('type_id').value--->
				</div>
			</div>
			<div class="form-group">
				<label><cf_get_lang dictionary_id='57708.Tümü'> <input type="checkbox" name="related_all_" id="related_all_" value="0"></label>
			</div>
			<div class="form-group">
				<div class="input-group">
					<cf_workcube_buttons is_upd='0'  add_function='rel_kontrol1()'  is_cancel='0' type_format='1'>
				</div>
			</div>
		</div>
	</cf_box_elements>
   <div class="col col-8">
	<cf_grid_list>
			<thead>
				<tr> 
					<th><cf_get_lang dictionary_id='57630.Tip'></th>
					<th><cf_get_lang dictionary_id='29787.İlişkili Alan'></th>
					<th width="15">&nbsp;</th>
				</tr>
			</thead>
			<tbody>
				<cfoutput query="get_related_parts">
					<cfif relation_type eq 1 and isdefined('relation_cat') and len(relation_cat)>
						<cfset get_opp=cfc.GetOpp(relation_cat:get_related_parts.relation_cat)> 
					<cfelseif relation_type eq 2 and isdefined('relation_cat') and len(relation_cat)>
						<cfset get_content=cfc.GetContent(relation_cat:get_related_parts.relation_cat)> 
					<cfelseif relation_type eq 3 and isdefined('relation_cat') and len(relation_cat)>
						<cfset get_campaign=cfc.GetCampaign(relation_cat:get_related_parts.relation_cat)> 
					<cfelseif relation_type eq 4 and isdefined('relation_cat') and len(relation_cat)>
						<cfset get_product=cfc.GetProduct(relation_cat:get_related_parts.relation_cat)> 
					<cfelseif relation_type eq 5 and isdefined('relation_cat') and len(relation_cat)>
						<cfset get_project=cfc.GetProject(relation_cat:get_related_parts.relation_cat)> 
					<cfelseif relation_type eq 11 and isdefined('relation_cat') and len(relation_cat)>
						<cfset get_work=cfc.GetWork(relation_cat:get_related_parts.relation_cat)> 
					<cfelseif relation_type eq 7 and isdefined('relation_cat') and len(relation_cat)>
						<cfset get_app=cfc.GetApp(relation_cat:get_related_parts.relation_cat)> 
					<cfelseif relation_type eq 9 and isdefined('relation_cat') and len(relation_cat)>
						<cfset get_class=cfc.GetClass(relation_cat:get_related_parts.relation_cat)>
					<cfelseif relation_type eq 16 and isdefined('relation_cat') and len(relation_cat)>
						<cfset get_organization=cfc.GetOrganization(relation_cat:get_related_parts.relation_cat)>
					</cfif>
					<tr name="related_row_#currentrow#" id="related_row_#currentrow#" style="display:">
						<td class="color-row">
							<input type="hidden" name="related_row_kontrol#currentrow#" id="related_row_kontrol#currentrow#" value="1">
							<input type="hidden" name="related_id#currentrow#" id="related_id#currentrow#" value="#get_related_parts.relation_cat#">
							<input type="hidden" name="related_type#currentrow#" id="related_type#currentrow#" value="#relation_type#">
							<cfif relation_type eq 1>
								<cf_get_lang dictionary_id='57612.Fırsat'>
							<cfelseif relation_type eq 2>
								<cf_get_lang dictionary_id='57653.İçerik'>
							<cfelseif relation_type eq 3>
								<cf_get_lang dictionary_id='57446.Kampanya'>
							<cfelseif relation_type eq 4>
								<cf_get_lang dictionary_id='57657.Ürün'>
							<cfelseif relation_type eq 5>
								<cf_get_lang dictionary_id='57416.Proje'>
							<cfelseif relation_type eq 6>
								<cf_get_lang dictionary_id='29776.Deneme Süresi'>
							<cfelseif relation_type eq 7>
								<cf_get_lang dictionary_id='57996.İşe Alım'>
							<cfelseif relation_type eq 8>
								<cf_get_lang dictionary_id='58003.Performans'>
							<cfelseif relation_type eq 9>
								<cf_get_lang dictionary_id='57419.Eğitim'>
							<cfelseif relation_type eq 10>
								<cf_get_lang dictionary_id='29832.İşten Çıkış'>
							<cfelseif relation_type eq 11>
								<cf_get_lang dictionary_id='58445.İş'>
							<cfelseif relation_type eq 12><cf_get_lang dictionary_id='30007.Satış Teklifleri'>
							<cfelseif relation_type eq 13><cf_get_lang dictionary_id='57611.Sipariş'>
							<cfelseif relation_type eq 14><cf_get_lang dictionary_id='58662.Anket'>
							<cfelseif relation_type eq 15><cf_get_lang dictionary_id='30048.Satınalma Teklifleri'>
							<cfelseif relation_type eq 16><cf_get_lang dictionary_id='29465.Etkinlik'>
							<cfelseif relation_type eq 17><cf_get_lang dictionary_id='60095.Mal Kabul'>
							<cfelseif relation_type eq 18><cf_get_lang dictionary_id='45452.Sevkiyat'>
							<cfelseif relation_type eq 19><cf_get_lang dictionary_id='57438.Call Center'>
							</cfif>
						</td>
						<td class="color-row">
							<cfif relation_type eq 1 and isdefined('get_related_parts.relation_cat') and len(get_related_parts.relation_cat)>
								#get_opp.RELATION_HEAD#
							<cfelseif relation_type eq 2 and isdefined('get_related_parts.relation_cat') and len(get_related_parts.relation_cat)>
								#get_content.RELATION_HEAD#
							<cfelseif relation_type eq 3 and isdefined('get_related_parts.relation_cat') and len(get_related_parts.relation_cat)>
								#get_campaign.RELATION_HEAD#
							<cfelseif relation_type eq 4 and isdefined('get_related_parts.relation_cat') and len(get_related_parts.relation_cat)>
								#get_product.RELATION_HEAD#
							<cfelseif relation_type eq 5 and isdefined('get_related_parts.relation_cat') and len(get_related_parts.relation_cat)>
								#get_project.RELATION_HEAD#
							<cfelseif relation_type eq 11 and isdefined('get_related_parts.relation_cat') and len(get_related_parts.relation_cat)>
								#get_work.RELATION_HEAD#
							<cfelseif listfind('6,8,10',relation_type,',') and isdefined('get_related_parts.relation_cat') and len(get_related_parts.relation_cat)>
								#get_emp_info(relation_cat,0,0)#
							<cfelseif relation_type eq 7 and isdefined('get_related_parts.relation_cat') and len(get_related_parts.relation_cat)>
								#get_app.RELATION_HEAD#
							<cfelseif relation_type eq 9 and isdefined('get_related_parts.relation_cat') and len(get_related_parts.relation_cat)>
								#get_class.RELATION_HEAD#
							<cfelseif relation_type eq 16 and isdefined('get_related_parts.relation_cat') and len(get_related_parts.relation_cat)>
								#get_organization.RELATION_HEAD#
							<cfelse>
								<cf_get_lang dictionary_id='57708.Tümü'>
							</cfif>
						</td>
						<td><a style="cursor:pointer" onclick="related_sil(#currentrow#);"><img  src="images/delete_list.gif" alt="<cf_get_lang dictionary_id='57463.Sil'>" border="0"></a></td>
					</tr>
					</cfoutput>
			</tbody>
		</cf_grid_list>
	</div>
</cfform>
<script type="text/javascript">
	function rel_kontrol1()
	{
		/*if(document.getElementById('related_head').value == '' && document.getElementById('related_id').value == '' && document.getElementById('related_all_').checked == false)
		{
			alert("<cf_get_lang_main no='1989.Lütfen İlişkili Alan Seçiniz'>!");
			return false;
		}*/
		AjaxFormSubmit('form_related_parts','relation_parts1',1,'','','<cfoutput>#request.self#?fuseaction=objects.emptypopupajax_form_related_parts&type=#attributes.type#</cfoutput>','body_div_related_parts');
		return false;
	}
	function empty_related_id()
	{
		document.getElementById('related_id').value ='';
		document.getElementById('related_head').value ='';
	}
	function related_sil(sy)
	{
		var my_element=eval("document.all.related_row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("related_row_"+sy);
		my_element.style.display="none";
	}	
	function open_related_popup(op)
	{
		if(op =='')
		{
			alert("<cf_get_lang dictionary_id='29785.Lütfen Tip Seçiniz'>!");
			return false;
		}
		var y = "";
		if (op == 1)//Fırsat
		{
			y='popup_list_opportunities&field_opp_id=form_related_parts.related_id&field_opp_head=form_related_parts.related_head';
		}
		else if (op == 2)//İçerik
		//http://ep.workcube/index.cfm?fuseaction=objects.popup_list_content_relation&action_type_id=143&action_type=CAMPAIGN_ID
		{ 
			y='objects.popup_list_content_relation&no_function=1&action_type_id=<cfoutput>#attributes.survey_id#</cfoutput>&action_type=SURVEY_ID&content=form_related_parts.related_id&content_name=form_related_parts.related_head';
		}
		else if (op==3)//kampanya
		{
			y='objects.popup_list_campaigns&field_id=form_related_parts.related_id&field_name=form_related_parts.related_head';
		}
		else if (op == 4)//Ürün
		{ 
			y='objects.popup_product_names&field_id=form_related_parts.related_id&field_name=form_related_parts.related_head';
		}
		else if(op == 5)//Proje
		{
			 y='objects.popup_list_projects&project_id=form_related_parts.related_id&project_head=form_related_parts.related_head';
		}
		else if(op == 11)//İŞ
		{
			 y='objects.popup_add_work&field_id=form_related_parts.related_id&field_name=form_related_parts.related_head';
		}
		else if(op == 6 || op == 8 || op == 10)//deneme süresi,performans,işten çıkış
		{
			 y='objects.popup_list_positions&field_emp_id=form_related_parts.related_id&field_name=form_related_parts.related_head&select_list=1';
		}
		else if(op ==7)//işe alım
		{
			 y='objects.popup_list_employees_app&field_id=form_related_parts.related_id&field_name=form_related_parts.related_head';
		}
		else if(op == 9)//Eğitim
		{
			 y='objects.popup_list_classes&field_id=form_related_parts.related_id&field_name=form_related_parts.related_head';
		}
/* 		else if(op == 16)//Eğitim
		{
			 y='objects.popup_list_organizations&field_id=form_related_parts.related_id&field_name=form_related_parts.related_head';
		}
		else if(op == 17)//Mal Kabul
		{
			 y='objects.popup_list_offers&order_id=form_related_parts.related_id&order_name=form_related_parts.related_head';
		}
		else if(op == 18)//Sevkiyat
		{
			 y='objects.popup_list_packetship_product&ship_id=form_related_parts.related_id&order_name=form_related_parts.related_head';
		}
		else if(op == 19)//Call Center
		{
			 y='objects.popup_list_packetship_product&ship_id=form_related_parts.related_id&order_name=form_related_parts.related_head';
		} */
		else{
			alert("İşlem Tipi Sayfası Tanımlanmamış.");
			return false;
		}
		if(op == 5 || op == 6 || op == 8 || op == 10 || op == 4 || op == 11)
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction='+y);
		else
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction='+y,'list');
	}
</script>