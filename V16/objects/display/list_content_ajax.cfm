<cfset getComponent= createObject("component","V16.objects.cfc.get_list_content_relation")>
<cfset get_language =getComponent.GetLanguage()> 
<cfif attributes.come_project eq 1>
	<cfsetting showdebugoutput="no">
	<cf_get_lang_set module_name="objects">
	<cfset get_content = getComponent.GetContent(action_type : attributes.action_type, action_type_id : attributes.action_type_id, company_id : attributes.company_id)>
	<cf_flat_list>
		<thead>
			<tr>
				<th width="25%;"><cf_get_lang dictionary_id='57480.Konu'></th>
				<th width="25%;"><cf_get_lang dictionary_id='57482.Aşama'></th>
				<th width="25%;"><cf_get_lang dictionary_id='57899.Kaydeden'></th>
				<th width="25%;"><cf_get_lang dictionary_id='58050.son güncelleme'></th>
				<th><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></th>	
			</tr>
		</thead>
		<tbody>
			<cfoutput query="get_content">
				<tr>
					<td  width="25%;">		
						<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_dsp_content&cntid=#encodeForURL(content_id)#','','ui-draggable-box-medium');">#cont_head#</a>
					</td>
					<td  width="25%;">
						<label>#STAGE#</label>
					</td>
					<td  width="25%;">
							<cfset employee = getComponent.EMPLOYEE_PHOTO(employee_id:RECORD_EMP)>
						<!--- <cfif len(employee_photo.photo)>
							<cfset emp_photo ="../../documents/hr/#employee_photo.PHOTO#">
						<cfelseif employee_photo.sex eq 1>
							<cfset emp_photo ="images/male.jpg">
						<cfelse>
							<cfset emp_photo ="images/female.jpg">
						</cfif>
						<img class='img-circle' style='width : 30px; height:30px;margin-left: auto;margin-right: auto; 'src='#emp_photo#' />  --->
						#employee.EMPLOYEE_NAME# #employee.EMPLOYEE_SURNAME#
					</td>
					<td  width="25%;">
						<label><cfif len(update_date)>#DateFormat(update_date,dateformat_style)#<cfelse>#DateFormat(record_date,dateformat_style)#</cfif></label>
					</td>
					<td><a href="#request.self#?fuseaction=content.list_content&event=det&cntid=#encodeForURL(content_id)#" target="_blank"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>	
				</tr>			
			</cfoutput>
		</tbody>
	</cf_flat_list>
<cfelse>
	<cfsetting showdebugoutput="no">
	<cf_get_lang_set module_name="objects">
		<cfset get_content = getComponent.GetContent(action_type : attributes.action_type, action_type_id : attributes.action_type_id, company_id : attributes.company_id)>
	<cf_flat_list>
		<thead>
			<tr>
				<cfif attributes.design eq 1>
					<th width="20"><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='57480.Konu'></th>
					<th width="100"><cf_get_lang dictionary_id='57899.Kaydeden'></th>
					<th width="100"><cf_get_lang dictionary_id='57891.Güncelleyen'></th>
					<th width="70"><cf_get_lang dictionary_id='57482.Aşama'></th>
					<th width="55"><cf_get_lang dictionary_id='32484.Versiyon'></th>
					<th width="45"><cf_get_lang dictionary_id='57483.Kayıt'></th>
					<cfif attributes.is_add_upd neq 0>
						<th width="20"><a href="javascript://"><i class="fa fa-minus"></i></a></th>
					</cfif>
					<!--- custom tag de ekle ve sil oldugu icin bu bolum kapatıldı butonlar sayfada 2 kere geliyor SG 20130225--->
					<!---  <cfif attributes.is_add_upd neq 0>
						<th width="15"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_content_relation&action_type_id=#attributes.action_type_id#&action_type=#attributes.action_type#</cfoutput>','list');"><img src="/images/report_square2.gif" align="absmiddle" border="0" title="<cf_get_lang_main no ='497.İliskilendir'>"></a></th>
						</cfif>  --->
				</cfif>
			<!--- custom tag de ekle ve sil oldugu icin bu bolum kapatıldı butonlar sayfada 2 kere geliyor SG 20130225--->
			<!---  <cfif attributes.is_add_upd neq 0>
					<th style="text-align:right;" width="15">
						<a href="<cfoutput>#request.self#?fuseaction=content.add_form_content&action_type_id=#attributes.action_type_id#&action_type=#attributes.action_type#</cfoutput>"><img src="/images/plus_list.gif" border="0" align="absmiddle" title="<cf_get_lang_main no ='170.Ekle'>"></a>
					</th>
				</cfif> --->
			</tr>
		</thead>
		<tbody>
			<cfif get_content.recordcount>
				<cfoutput query="get_content">
					<tr>
						<cfif attributes.design eq 1><td>#currentrow#</td>
							<td><a href="#request.self#?fuseaction=rule.dsp_rule&cntid=#content_id#" target="_blank">#cont_head#</a></td>
							<td><cfif len(get_content.record_emp)>#get_emp_info(get_content.record_emp,0,0)#</cfif></td>
							<td><cfif len(get_content.update_member)>#get_emp_info(get_content.update_member,0,0)#</cfif></td> 
							<td>#STAGE#</td>
							<td>#write_version#&nbsp;</td>
							<td width="60">#dateformat(record_date,dateformat_style)#</td>
						<cfelse>
							<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_content&cntid=#EncodeForURL(content_id)#','medium');" class="tableyazi">#cont_head#</a></td>
						</cfif>
						<cfif attributes.is_add_upd neq 0>
						<cfsavecontent variable="message2"><cf_get_lang dictionary_id ='32396.İçerik Bağlantısını Siliyorsunuz Emin misiniz'></cfsavecontent>
						<td width="20"><a href="javascript://"  onClick="if(confirm('#message2#')) windowopen('#request.self#?fuseaction=objects.emptypopup_del_content_relation&action_type=#encodeForURL(attributes.action_type)#&action_type_id=#EncodeForURL(attributes.action_type_id)#&content_id=#EncodeForURL(content_id)#','content_list',1); else return false;"><i class="fa fa-minus" title="<cf_get_lang dictionary_id ='34244.Bağlantı Sil'>"></i></a></td> 
						</cfif>
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="9"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
				</tr>		
			</cfif>	
		</tbody>
	</cf_flat_list>
</cfif>