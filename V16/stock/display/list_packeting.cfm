<cfparam name="attributes.barcode" default="">
<cfparam name="attributes.ship_method" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.PACKAGE_STAGE" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department_name" default="">
<cfparam name="attributes.transport_comp_id" default="">
<cfparam name="attributes.transport_comp_name" default="">
<cfparam name="attributes.process_stage_type" default="">
<cfparam name="attributes.package_type_id" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.paper_no" default="">

<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
<cfelse>
	<cfset attributes.start_date=''>
</cfif>	
<cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
<cfelse>
	<cfset attributes.finish_date=''>
</cfif>

<cfset packeting = createObject("component", "V16.stock.cfc.packeting")>
<cfset get_packet_stage = packeting.GET_PACKET_STAGE(faction: "#listfirst(attributes.fuseaction,'.')#.packeting")>
<cfset get_package_type = packeting.GET_PACKAGE_TYPE()>


<cfif isdefined("attributes.form_submitted")>
	<cfset get_packeting_result = packeting.GET_PACKETING(
            barcode : '#IIf(IsDefined("attributes.barcode"),"attributes.barcode",DE(""))#',
			paper_no : '#IIf(IsDefined("attributes.paper_no"),"attributes.paper_no",DE(""))#',
			process_stage_type : '#IIf(IsDefined("attributes.process_stage_type"),"attributes.process_stage_type",DE(""))#',
			start_date : '#IIf(IsDefined("attributes.start_date"),"attributes.start_date",DE(""))#',
			finish_date : '#IIf(IsDefined("attributes.finish_date"),"attributes.finish_date",DE(""))#',
			department_id : '#IIf(IsDefined("attributes.department_id"),"attributes.department_id",DE(""))#',
			department_name : '#IIf(IsDefined("attributes.department_name"),"attributes.department_name",DE(""))#',
			transport_comp_id : '#IIf(IsDefined("attributes.transport_comp_id"),"attributes.transport_comp_id",DE(""))#',
			transport_comp_name : '#IIf(IsDefined("attributes.transport_comp_name"),"attributes.transport_comp_name",DE(""))#',
			company_id : '#IIf(IsDefined("attributes.company_id"),"attributes.company_id",DE(""))#',
			company : '#IIf(IsDefined("attributes.company"),"attributes.company",DE(""))#',
			consumer_id : '#IIf(IsDefined("attributes.consumer_id"),"attributes.consumer_id",DE(""))#',
		 	project_id : '#IIf(IsDefined("attributes.project_id"),"attributes.project_id",DE(""))#',
			project_head : '#IIf(IsDefined("attributes.project_head"),"attributes.project_head",DE(""))#',
			package_type_id : '#IIf(IsDefined("attributes.package_type_id"),"attributes.package_type_id",DE(""))#'
	)>
<cfelse>
	<cfset get_packeting_result.recordCount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default='#get_packeting_result.recordcount#'>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="form" method="post" action="#request.self#?fuseaction=stock.packeting">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" placeholder="#getLang('','Barkod',57633)#" name="barcode" id="barcode" value="#attributes.barcode#" maxlength="50">
				</div>
                <div class="form-group">
					<cfinput type="text" placeholder="#getLang('','Paket No',400)#" name="paper_no" id="paper_no" value="#attributes.paper_no#" maxlength="50">
				</div>
                <div class="form-group">
					<select name="package_type_id" id="package_type_id">
						<option value=""><cf_get_lang dictionary_id='34799.Paket Tipi'></option>
						<cfoutput query="get_package_type">
							<option value="#PACKAGE_TYPE_ID#" <cfif (attributes.package_type_id eq PACKAGE_TYPE_ID)> selected</cfif>>#PACKAGE_TYPE#</option>
						</cfoutput>
					</select>  
				</div>
				<div class="form-group">
					<select name="process_stage_type" id="process_stage_type">
						<option value=""><cf_get_lang dictionary_id='57482.Aşama'></option>
						<cfoutput query="get_packet_stage">
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
					<div class="form-group" id="item-transport_comp_id">
						<label class="col col-12"><cf_get_lang dictionary_id='57899.Kaydeden'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="transport_comp_id" id="transport_comp_id" value="<cfoutput>#attributes.transport_comp_id#</cfoutput>">
								<input type="text" name="transport_comp_name" id="transport_comp_name" value="<cfoutput>#attributes.transport_comp_name#</cfoutput>">
								<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=form.transport_comp_id&field_comp_name=form.transport_comp_name&select_list=1');"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-project_id">
                        <label class="col col-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined("attributes.project_id") and len (attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
                                <input type="text" name="project_head"  id="project_head" value="<cfif isdefined('attributes.project_head') and  len(attributes.project_head)><cfoutput>#attributes.project_head#</cfoutput></cfif>" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=order_form.project_id&project_head=order_form.project_head');"></span>
                            </div>
                        </div>
                    </div>
					<div class="form-group" id="item-date">
						<label class="col col-12"><cfoutput>#getLang('','Kayıt Tarihi',57627)#</cfoutput></label>
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
	<cf_box title="#getLang('','Paketler',60)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='400.Paket No'></th>
					<th><cf_get_lang dictionary_id='34799.Paket Tipi'></th>
					<th><cf_get_lang dictionary_id='57482.Aşama'></th>
					<th><cf_get_lang dictionary_id='58763.Depo'></th>
					<th><cf_get_lang dictionary_id='57633.Barkod'></th>
					<th>Max <cf_get_lang dictionary_id='30114.Hacim'></th>
					<th>Max <cf_get_lang dictionary_id='29784.Ağırlık'></th>
					<th><cf_get_lang dictionary_id='36199.Açıklama'></th>
					<th><cf_get_lang dictionary_id='57416.Proje'></th>
					<!-- sil --><th width="20" class="header_icn_none"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=stock.packeting&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th><!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_packeting_result.recordcount>
				<cfset process_list=''>
					<cfoutput query="get_packeting_result" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(get_packeting_result.PACKAGE_STAGE) and not listfind(process_list,get_packeting_result.PACKAGE_STAGE)>
							<cfset process_list = listappend(process_list,get_packeting_result.PACKAGE_STAGE)>
						</cfif>
					</cfoutput>
				<cfif len(process_list)>
					<cfset process_list=listsort(process_list,"numeric","ASC",",")>
					<cfquery name="get_process_type" datasource="#dsn#">
						SELECT STAGE,PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#process_list#)
					</cfquery>
					<cfset main_process_list = listsort(listdeleteduplicates(valuelist(get_process_type.process_row_id,',')),'numeric','ASC',',')>
				</cfif> 	
				<cfoutput query="get_packeting_result" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>#currentrow#</td>
						<td><a href="#request.self#?fuseaction=stock.packeting&event=upd&packet_id=#packet_id#" class="tableyazi">#package_no#</a></td>
						<td>#PACKAGE_TYPE#</td>
						<td>#get_process_type.stage[listfind(main_process_list,PACKAGE_STAGE,',')]#</td>
						<td>#D_HEAD#</td>
						<td></td>
						<td>#MAX_VOLUME#</td>
						<td>#MAX_WIDTH#</td>
						<td>#left(description,30)#</td>
						<td>#PROJECT_HEAD#</td>
						<!-- sil --><td class="header_icn_none"><a href="#request.self#?fuseaction=stock.packeting&event=upd&packet_id=#packet_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td><!-- sil -->
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
		<cfif len(attributes.barcode)>
			<cfset url_str = "#url_str#&barcode=#attributes.barcode#">
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