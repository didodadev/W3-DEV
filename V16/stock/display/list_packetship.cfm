<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.ship_number" default="">
<cfparam name="attributes.ship_method" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.ship_method_id" default="">
<cfparam name="attributes.ship_method_name" default="">
<cfparam name="attributes.ship_stage" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department_name" default="">
<cfparam name="attributes.transport_comp_id" default="">
<cfparam name="attributes.transport_comp_name" default="">
<cfparam name="attributes.city_id" default="">
<cfparam name="attributes.city" default="">
<cfparam name="attributes.county" default="">
<cfparam name="attributes.county_id" default="">
<cfparam name="attributes.process_stage_type" default="">
<cfparam name="attributes.project_id" default=""><!--- #67836 numaraları iş gereği MCP tarafından EKLENDİ. --->
<cfparam name="attributes.project_head" default=""><!--- #67836 numaraları iş gereği MCP tarafından EKLENDİ. --->
<cf_xml_page_edit fuseact="stock.list_packetship">
<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
<cfelse>
	<cfif session.ep.our_company_info.unconditional_list>
		<cfset attributes.start_date=''>
	<cfelse>
		<cfset attributes.start_date=wrk_get_today()>
	</cfif>
</cfif>	
<cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
<cfelse>
	<cfif session.ep.our_company_info.unconditional_list>
		<cfset attributes.finish_date=''>
	<cfelse>
	<cfset attributes.finish_date = date_add('d',1,now())>
	</cfif>
</cfif>
<cfquery name="GET_SHIP_STAGE" datasource="#DSN#">
	SELECT
		#dsn#.Get_Dynamic_Language(PTR.PROCESS_ROW_ID,'#session.ep.language#','PROCESS_TYPE_ROWS','STAGE',NULL,NULL,PTR.STAGE) AS STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listfirst(attributes.fuseaction,'.')#.list_packetship%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfif isdefined("attributes.form_submitted")>
	<cfscript>
 		get_ship_result_action = createObject("component", "V16.stock.cfc.get_ship_result");
        get_ship_result_action.dsn2 = dsn2;
        get_ship_result_action.dsn_alias = dsn_alias;
        GET_SHIP_RESULT = get_ship_result_action.get_ship_result_fnc(
			 ship_number : '#IIf(IsDefined("attributes.ship_number"),"attributes.ship_number",DE(""))#',
			 keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(""))#',
			 process_stage_type : '#IIf(IsDefined("attributes.process_stage_type"),"attributes.process_stage_type",DE(""))#',
			 start_date : '#IIf(IsDefined("attributes.start_date"),"attributes.start_date",DE(""))#',
			 finish_date : '#IIf(IsDefined("attributes.finish_date"),"attributes.finish_date",DE(""))#',
			 ship_method_name : '#IIf(IsDefined("attributes.ship_method_name"),"attributes.ship_method_name",DE(""))#',
			 ship_method_id : '#IIf(IsDefined("attributes.ship_method_id"),"attributes.ship_method_id",DE(""))#',
			 department_id : '#IIf(IsDefined("attributes.department_id"),"attributes.department_id",DE(""))#',
			 department_name : '#IIf(IsDefined("attributes.department_name"),"attributes.department_name",DE(""))#',
			 transport_comp_id : '#IIf(IsDefined("attributes.transport_comp_id"),"attributes.transport_comp_id",DE(""))#',
			 transport_comp_name : '#IIf(IsDefined("attributes.transport_comp_name"),"attributes.transport_comp_name",DE(""))#',
			 company_id : '#IIf(IsDefined("attributes.company_id"),"attributes.company_id",DE(""))#',
			 company : '#IIf(IsDefined("attributes.company"),"attributes.company",DE(""))#',
			 consumer_id : '#IIf(IsDefined("attributes.consumer_id"),"attributes.consumer_id",DE(""))#',
			 county_id : '#IIf(IsDefined("attributes.county_id"),"attributes.county_id",DE(""))#',
			 county : '#IIf(IsDefined("attributes.county"),"attributes.county",DE(""))#',
			 city_id : '#IIf(IsDefined("attributes.city_id"),"attributes.city_id",DE(""))#',
			 city : '#IIf(IsDefined("attributes.city"),"attributes.city",DE(""))#',
		 	 project_id : '#IIf(IsDefined("attributes.project_id"),"attributes.project_id",DE(""))#',
			 project_head : '#IIf(IsDefined("attributes.project_head"),"attributes.project_head",DE(""))#'
		);
	</cfscript>
<cfelse>
	<cfset get_ship_result.recordCount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default='#get_ship_result.recordcount#'>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="form" method="post" action="#request.self#?fuseaction=stock.list_packetship">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" placeholder="#getLang(48,'Filtre',57460)#" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group">
					<cfinput type="text" placeholder="#getLang(726,'İrsaliye No',58138)#" name="ship_number" value="#attributes.ship_number#" maxlength="255">
				</div>
				<div class="form-group">
					<cf_wrkdepartmentlocation 
						returnInputValue="department_name,department_id"
						returnQueryValue="LOCATION_NAME,DEPARTMENT_ID"
						fieldName="department_name"
						fieldid="location_id"
						department_fldId="department_id"
						department_id="#attributes.department_id#"
						location_name="#attributes.department_name#"
						user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
						width="100">
				</div>
				<div class="form-group">
					<div class="input-group">
						<input type="hidden" name="ship_method_id" id="ship_method_id" value="<cfoutput>#attributes.ship_method_id#</cfoutput>">
						<input type="text" name="ship_method_name" placeholder="<cf_get_lang dictionary_id='29500.Sevk Yöntemi'>" id="ship_method_name" value="<cfoutput>#attributes.ship_method_name#</cfoutput>">
						<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=form.ship_method_name&field_id=form.ship_method_id','','ui-draggable-box-small');"></span>
					</div>
				</div>
				<div class="form-group">
					<select name="process_stage_type" id="process_stage_type">
						<option value=""><cf_get_lang dictionary_id='57482.Aşama'></option>
						<cfoutput query="get_ship_stage">
							<option value="#process_row_id#" <cfif (attributes.process_stage_type eq process_row_id)> selected</cfif>>#stage#</option>
						</cfoutput>
					</select>  
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
				</div>
				<div class="form-group">
					<cfsavecontent variable="message_date"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
					<cf_wrk_search_button button_type="4" search_function="date_check(form.start_date,form.finish_date,'#message_date#')">
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-company">
						<label class="col col-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
								<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
								<input type="text" name="company" id="company" value="<cfoutput>#attributes.company#</cfoutput>">
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_comp_id=form.company_id&field_comp_name=form.company&field_consumer=form.consumer_id&field_member_name=form.company&select_list=2,3');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-transport_comp_id">
						<label class="col col-12"><cf_get_lang dictionary_id='57716.Taşıyıcı'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="transport_comp_id" id="transport_comp_id" value="<cfoutput>#attributes.transport_comp_id#</cfoutput>">
								<input type="text" name="transport_comp_name" id="transport_comp_name" value="<cfoutput>#attributes.transport_comp_name#</cfoutput>">
								<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=form.transport_comp_id&field_comp_name=form.transport_comp_name&select_list=2');"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-city_id">
						<label class="col col-12"><cf_get_lang dictionary_id='58608.İl'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="city_id" id="city_id" value="<cfoutput>#attributes.city_id#</cfoutput>">
								<input type="text" name="city" id="city" value="<cfoutput>#attributes.city#</cfoutput>">
								<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_city&field_id=form.city_id&field_name=form.city','','ui-draggable-box-small');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-transport_comp_id">
						<label class="col col-12"><cf_get_lang dictionary_id='58638.İlçe'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="county_id" id="county_id" value="<cfoutput>#attributes.county_id#</cfoutput>">
								<input type="text" name="county" id="county" value="<cfoutput>#attributes.county#</cfoutput>">
								<span class="input-group-addon btnPointer icon-ellipsis" onClick="pencere_ac();"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<cfif is_show_project eq 1>
						<div class="form-group" id="item-project_id"><!--- #67836 numaraları iş gereği MCP tarafından EKLENDİ. --->
							<label class="col col-12"><cf_get_lang dictionary_id='57416.Proje'></label>
							<div class="col col-12">
								<div class="input-group">
									<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined("attributes.project_id") and len (attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
									<input type="text" name="project_head"  id="project_head" value="<cfif isdefined('attributes.project_head') and  len(attributes.project_head)><cfoutput>#attributes.project_head#</cfoutput></cfif>" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
									<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=order_form.project_id&project_head=order_form.project_head');"></span>
								</div>
							</div>
						</div>
					</cfif>
					<div class="form-group" id="item-date">
						<label class="col col-12"><cfoutput>#getLang(286,'Depo Çıkış Tarihi',45463)#</cfoutput></label>
						<div class="col col-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57782.Tarih Değerinizi Kontrol Ediniz'></cfsavecontent>
								<cfinput value="#dateformat(attributes.start_date,dateformat_style)#" type="text" name="start_date" validate="#validate_style#" maxlength="10" message="#message#">
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="start_date"></span>
								<span class="input-group-addon no-bg"></span>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57782.Tarih Değerinizi Kontrol Ediniz'></cfsavecontent>
								<cfinput value="#dateformat(attributes.finish_date,dateformat_style)#" type="text" name="finish_date" validate="#validate_style#" maxlength="10" message="#message#">
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finish_date"></span>
							</div>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(313,'Sevkiyatlar',45490)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='45458.Sevk No'></th>
					<th><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></th>
					<th><cf_get_lang dictionary_id='57482.Aşama'></th>
					<th><cf_get_lang dictionary_id='45463.Depo Çıkış'></th>
					<th><cf_get_lang dictionary_id='45475.Teslim'></th>
					<th><cf_get_lang dictionary_id='57629.Aciklama'></th>
					<cfif is_show_project eq 1>
						<th><cf_get_lang dictionary_id='57416.Proje'></th>
					</cfif>
					<!-- sil --><th width="20" class="header_icn_none"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=stock.list_packetship&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th><!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_ship_result.recordcount>
				<cfset process_list=''>
					<cfoutput query="get_ship_result" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(get_ship_result.ship_stage) and not listfind(process_list,get_ship_result.ship_stage)>
							<cfset process_list = listappend(process_list,get_ship_result.ship_stage)>
						</cfif>
					</cfoutput>
				<cfif len(process_list)>
					<cfset process_list=listsort(process_list,"numeric","ASC",",")>
					<cfquery name="get_process_type" datasource="#dsn#">
						SELECT STAGE,PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#process_list#)
					</cfquery>
					<cfset main_process_list = listsort(listdeleteduplicates(valuelist(get_process_type.process_row_id,',')),'numeric','ASC',',')>
				</cfif> 	
				<cfoutput query="get_ship_result" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>#currentrow#</td>
						<td><a href="#request.self#?fuseaction=stock.list_packetship&event=upd&ship_result_id=#ship_result_id#" class="tableyazi">#ship_fis_no#</a></td>
						<td>#ship_method#</td>
						<td>#get_process_type.stage[listfind(main_process_list,ship_stage,',')]#</td>
						<td>#dateformat(out_date,dateformat_style)#</td>
						<td>#dateformat(delivery_date,dateformat_style)#</td>
						<td>#left(note,30)#</td>
						<cfif is_show_project eq 1>
							<td>#project_head#</td>
						</cfif>
						<!-- sil --><td class="header_icn_none"><a href="#request.self#?fuseaction=stock.list_packetship&event=upd&ship_result_id=#ship_result_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td><!-- sil -->
					</tr>
				</cfoutput>
				<cfelse>
					<tr>
						<td colspan="9"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfset url_str="stock.list_packetship">
		<cfif len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif len(attributes.ship_number)>
			<cfset url_str = "#url_str#&ship_number=#attributes.ship_number#">
		</cfif>
		<cfif len(attributes.ship_method)>
			<cfset url_str = "#url_str#&ship_method=#attributes.ship_method#">
		</cfif>
		<cfif len(attributes.start_date)>
			<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
		</cfif>
		<cfif len(attributes.finish_date)>
			<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
		</cfif>
		<cfif len(attributes.company_id)>
			<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
		</cfif>
		<cfif len(attributes.consumer_id)>
			<cfset url_str = "#url_str#&consumer_id=#attributes.consumer_id#">
		</cfif>
		<cfif len(attributes.company)>
			<cfset url_str = "#url_str#&company=#attributes.company#">
		</cfif>
		<cfif len(attributes.ship_method_id)>
			<cfset url_str = "#url_str#&ship_method_id=#attributes.ship_method_id#">
		</cfif>
		<cfif len(attributes.ship_method_name)>
			<cfset url_str = "#url_str#&ship_method_name=#attributes.ship_method_name#">
		</cfif>
		<cfif isdefined("attributes.process_stage_type") and len(attributes.process_stage_type)>
			<cfset url_str = "#url_str#&process_stage_type=#attributes.process_stage_type#" >
		</cfif>
		<cfif len(attributes.department_id)>
			<cfset url_str = "#url_str#&department_id=#attributes.department_id#">
		</cfif>
		<cfif len(attributes.department_name)>
			<cfset url_str = "#url_str#&department_name=#attributes.department_name#">
		</cfif>
		<cfif len(attributes.transport_comp_id)>
			<cfset url_str = "#url_str#&transport_comp_id=#attributes.transport_comp_id#">
		</cfif>
		<cfif len(attributes.transport_comp_name)>
			<cfset url_str = "#url_str#&transport_comp_name=#attributes.transport_comp_name#">
		</cfif>
		<cfif len(attributes.city_id)>
			<cfset url_str = "#url_str#&city_id=#attributes.city_id#">
		</cfif>
		<cfif len(attributes.city)>
			<cfset url_str = "#url_str#&city=#attributes.city#">
		</cfif>
		<cfif len(attributes.county)>
			<cfset url_str = "#url_str#&county=#attributes.county#">
		</cfif>
		<cfif len(attributes.county_id)>
			<cfset url_str = "#url_str#&county_id=#attributes.county_id#">
		</cfif>
		<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
			<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
		</cfif>
		<cfif isdefined("attributes.project_id") and len(attributes.project_id)><!--- #67836 numaraları iş gereği readonly özelliği MCP tarafından eklendi. --->
			<cfset url_str = "#url_str#&project_id=#attributes.project_id#">
		</cfif>
		<cfif isdefined("attributes.project_head") and len(attributes.project_head)><!--- #67836 numaraları iş gereği readonly özelliği MCP tarafından eklendi. --->
			<cfset url_str = "#url_str#&project_head=#attributes.project_head#">
		</cfif>
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="#url_str#">
	</cf_box>
</div>
<script type="text/javascript">
document.getElementById('keyword').focus();
function pencere_ac()
{
	if((form.city_id.value != "") && (form.city.value != ""))
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=form.county_id&field_name=form.county&city_id=' + document.form.city_id.value,'','ui-draggable-box-small');
	else
		alert("<cf_get_lang dictionary_id='45491.Lütfen İl Seçiniz'> !");
}
</script>

