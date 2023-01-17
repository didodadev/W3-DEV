<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.service_care" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.task_par_id" default="">
<cfparam name="attributes.task_cmp_id" default="">
<cfparam name="attributes.task_par_id2" default="">
<cfparam name="attributes.task_cmp_id2" default="">
<cfparam name="attributes.task_employee_id" default="">
<cfparam name="attributes.task_person_name" default="">
<cfparam name="attributes.task_employee_id2" default="">
<cfparam name="attributes.task_person_name2" default="">
<cfparam name="attributes.service_substatus_id" default="">
<cfif isdefined("attributes.form_submitted")>
<cfinclude template="../query/get_service_report.cfm">
<cfelse>
	<cfset get_service_report.recordcount = 0>
</cfif>
<cfquery name="GET_SERVICE_SUBSTATUS" datasource="#DSN3#">
	SELECT SERVICE_SUBSTATUS_ID,SERVICE_SUBSTATUS FROM SERVICE_SUBSTATUS 
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_service_report.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="list_care" method="post" action="#request.self#?fuseaction=service.list_service_report">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
				<div class="form-group"> 
					<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" placeholder="#getLang(48,'Filtre',57460)#">
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfinput type="text" name="start_date" id="start_date" placeholder="#getLang("",'Başlangıç Tarihi',58053)#" maxlength="10" validate="#validate_style#" value="#dateformat(attributes.start_date,dateformat_style)#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfinput type="text" name="finish_date" id="finish_date" placeholder="#getLang("",'Bitiş Tarihi',57700)#" maxlength="10" value="#dateformat(attributes.finish_date,dateformat_style)#"  validate="#validate_style#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="text"><cf_get_lang dictionary_id='41720.Bakım Tipi'></cfsavecontent>
							<cf_wrk_combo
							name="service_care"
							query_name="GET_SERVICE_CARE_CAT"
							option_name="service_care"
							option_value="service_carecat_id"
							option_text="#text#"
							value="#attributes.service_care#"
							width="125">
					</div>
				</div>
				<div class="form-group small" id="item-maxrows">
					<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="date_check(list_care.start_date,list_care.finish_date)">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-stock_id">
						<label class="col col-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="stock_id" id="stock_id" value="<cfif isdefined("attributes.stock_id")><cfoutput>#attributes.stock_id#</cfoutput></cfif>">
								<input type="text" name="product" id="product" style="width:130px;" onFocus="AutoComplete_Create('product','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID,STOCK_ID','product_id,stock_id','','3','200');" value="<cfif isdefined("attributes.product")><cfoutput>#attributes.product#</cfoutput></cfif>" autocomplete="off">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=list_care.task_employee_id&field_name=list_care.task_person_name&select_list=1','list','popup_list_positions');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-service_substatus_id">
						<label class="col col-12"><cf_get_lang dictionary_id='58973.Alt Aşama'></label>
						<div class="col col-12">
						<select name="service_substatus_id" id="service_substatus_id" style="width:130px;">
								<option value=""><cfoutput>#getLang(322,'Seçiniz',57734)#</cfoutput></option>
								<cfoutput query="get_service_substatus">
									<option value="#service_substatus_id#" <cfif isdefined("attributes.service_substatus_id") and attributes.service_substatus_id eq service_substatus_id> selected</cfif>>#service_substatus#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-task_employee_id">
						<label class="col col-12"><cf_get_lang dictionary_id ='41756.Servis Çalışanı'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="task_employee_id" id="task_employee_id" value="<cfif isdefined("attributes.task_employee_id") and len(attributes.task_employee_id)><cfoutput>#attributes.task_employee_id#</cfoutput></cfif>">
								<input type="text" name="task_person_name" id="task_person_name"  style="width:130px;"  onFocus="AutoComplete_Create('task_person_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','task_employee_id','','3','135');" value="<cfif len(attributes.task_person_name) and (len(attributes.task_employee_id) or len(attributes.task_cmp_id))><cfoutput>#attributes.task_person_name#</cfoutput></cfif>" autocomplete="off">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=list_care.task_employee_id2&field_name=list_care.task_person_name2&select_list=1','list','popup_list_positions');"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-task_employee_id2">
						<label class="col col-12"><cf_get_lang dictionary_id ='41756.Servis Çalışanı'> 2</label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="task_employee_id2" id="task_employee_id2" value="<cfif isdefined("attributes.task_employee_id2") and len(attributes.task_employee_id2)><cfoutput>#attributes.task_employee_id2#</cfoutput></cfif>">
								<input type="text" name="task_person_name2" id="task_person_name2"  style="width:130px;"  onFocus="AutoComplete_Create('task_person_name2','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','task_employee_id2','','3','135');" value="<cfif len(attributes.task_person_name2) and (len(attributes.task_employee_id2) or len(attributes.task_cmp_id2))><cfoutput>#attributes.task_person_name2#</cfoutput></cfif>" autocomplete="off">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=list_care.task_employee_id2&field_name=list_care.task_person_name2&select_list=1','list','popup_list_positions');"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
					<div class="form-group" id="item-consumer_id">
						<label class="col col-12"><cf_get_lang dictionary_id ='41958.Servis Firması'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id")><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">	
								<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">
								<input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type")><cfoutput>#attributes.member_type#</cfoutput></cfif>">
								<input name="member_name" type="text" id="member_name"  style="width:130px;" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','CONSUMER_ID,PARTNER_ID,MEMBER_TYPE','consumer_id,company_id,member_type','','3','250');" value="<cfif isdefined("attributes.member_name") and len(attributes.member_name)><cfoutput>#attributes.member_name#</cfoutput></cfif>" autocomplete="off">
								<cfset str_linke_ait="&field_consumer=list_care.consumer_id&field_id=list_care.company_id&field_member_name=list_care.member_name&field_type=list_care.member_type">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars<cfoutput>#str_linke_ait#</cfoutput>&select_list=7,8&keyword='+encodeURIComponent(document.list_care.member_name.value),'list');"></span>
							</div>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(35,'Servis Bakım Sonuçları',41677)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>        
				<tr>
					<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='57480.Başlık'></th>
					<th><cf_get_lang dictionary_id='57657.Ürün'></th>
					<th><cf_get_lang dictionary_id='41958.Servis Firması'></th>
					<th><cf_get_lang dictionary_id='57637.Seri No'></th>
					<th><cf_get_lang dictionary_id='41720.Bakım Tipi'></th>
					<th><cf_get_lang dictionary_id='41753.Bakım Başlangıç Tarihi'></th>
					<th><cf_get_lang dictionary_id='41982.Bakım Bitiş Tarihi'></th>
					<th><cf_get_lang dictionary_id='41690.Periyod(Bakım Periyodu)'></th>
					<th><cf_get_lang dictionary_id='58973.Alt Aşama'></th>
					<!-- sil -->
					<th width="20" class="header_icn_none text-center">
						<cfif not listfindnocase(denied_pages,'service.popup_add_service_care_contract')>
							<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=service.list_service_report&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
						</cfif>
					</th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_service_report.recordcount>
					<cfset company_list =''>
					<cfset consumer_list =''>
					<cfset service_carecat_id_list =''>
					<cfset service_substatus_id_list =''>
					<cfoutput query="get_service_report" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif company_partner_type is "partner" and len(company_partner_id) and not listfind(company_list,company_partner_id)>
						<cfset company_list = listappend(company_list,company_partner_id)>
						</cfif>
						<cfif company_partner_type is "consumer" and len(company_partner_id) and not listfind(consumer_list,company_partner_id)>
						<cfset consumer_list = listappend(consumer_list,company_partner_id)>
						</cfif>
						<cfif len(care_cat) and not listfind(service_carecat_id_list,care_cat)>
							<cfset service_carecat_id_list =listappend(service_carecat_id_list,care_cat)>
						</cfif>
						<cfif len(service_substatus) and not listfind(service_substatus_id_list,service_substatus)>
							<cfset service_substatus_id_list =listappend(service_substatus_id_list,service_substatus)>
						</cfif>
					</cfoutput>
					<cfif len(company_list)>
						<cfset company_list = listsort(company_list,"numeric","ASC",",")>
						<cfquery name="GET_COMPANY_NAME" datasource="#DSN#">
							SELECT
								CP.PARTNER_ID,
								C.COMPANY_ID,
								C.FULLNAME
							FROM
								COMPANY_PARTNER AS CP,
								COMPANY AS C
							WHERE
								CP.PARTNER_ID IN (#company_list#) AND
								C.COMPANY_ID = CP.COMPANY_ID
							ORDER BY
								CP.PARTNER_ID
						</cfquery>
						<cfset company_list= listsort(listdeleteduplicates(valuelist(get_company_name.partner_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(consumer_list)>
						<cfset consumer_list = listsort(consumer_list,"numeric","ASC",",")>
						<cfquery name="GET_CONSUMER_NAME" datasource="#DSN#">
							SELECT
								CONSUMER_ID,
								CONSUMER_NAME,
								CONSUMER_SURNAME
							FROM
								CONSUMER
							WHERE
								CONSUMER_ID IN (#consumer_list#)
							ORDER BY
								CONSUMER_ID
						</cfquery>
						<cfset consumer_list= listsort(listdeleteduplicates(valuelist(get_consumer_name.consumer_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(service_substatus_id_list)>
						<cfset service_substatus_id_list = listsort(service_substatus_id_list,"numeric","ASC",",")>
						<cfquery name="GET_SERVICE_SUBSTATUS" datasource="#DSN3#">
							SELECT
								SERVICE_SUBSTATUS,
								SERVICE_SUBSTATUS_ID
							FROM
								SERVICE_SUBSTATUS
							WHERE
								SERVICE_SUBSTATUS_ID IN (#service_substatus_id_list#) 
							ORDER BY
								SERVICE_SUBSTATUS_ID
						</cfquery>
						<cfset service_substatus_id_list= listsort(listdeleteduplicates(valuelist(get_service_substatus.service_substatus_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(service_carecat_id_list)>
						<cfset service_carecat_id_list = listsort(service_carecat_id_list,"numeric","ASC",",")>
						<cfquery name="GET_SERVICE_CARE" datasource="#DSN3#">
							SELECT
								SERVICE_CARE,
								SERVICE_CARECAT_ID
								
							FROM
								SERVICE_CARE_CAT
							WHERE
								SERVICE_CARECAT_ID IN (#service_carecat_id_list#) 
							ORDER BY
								SERVICE_CARECAT_ID
						</cfquery>
						<cfset service_carecat_id_list= listsort(listdeleteduplicates(valuelist(get_service_care.service_carecat_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfoutput query="get_service_report" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td width="35">#currentrow#</td>
							<td>#contract_head#</td>
							<td>#product_name#</td>
							<td>
								<cfif company_partner_type is "partner">
									<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_company_name.company_id[listfind(company_list,company_partner_id)]#','medium');">#get_company_name.fullname[listfind(company_list,company_partner_id)]#</a>
								<cfelseif company_partner_type is "consumer">
									<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#company_partner_id#','medium');">#get_consumer_name.consumer_name[listfind(consumer_list,company_partner_id)]# #get_consumer_name.consumer_surname[listfind(consumer_list,company_partner_id)]#</a>
								</cfif>
							</td>
							<td>#serial_no#</td>
							<td>
								<cfif len(service_carecat_id_list)>
									#get_service_care.service_care[listfind(service_carecat_id_list,care_cat)]#
								</cfif>
							</td>
							<td>#dateformat(care_date,dateformat_style)#</td>
							<td>#dateformat(care_finish_date,dateformat_style)#</td>
							<td>
								<cfif care_cat eq 1>
									<cf_get_lang dictionary_id='41692.Periyodik Bakım'>
								<cfelseif  care_cat eq 2>
									<cf_get_lang dictionary_id='41694.Mecburi Bakım'>
								<cfelseif  care_cat eq 3>
									<cf_get_lang dictionary_id='41696.Yıllık Bakım'>
								</cfif>
							</td>
							<td>#get_service_substatus.service_substatus[listfind(service_substatus_id_list,service_substatus)]#</td>
							<!-- sil -->
							<td style="width:15px;">
								<cfif not listfindnocase(denied_pages,'service.form_upd_service_care_report')> 
									<a href="#request.self#?fuseaction=service.list_service_report&event=upd&id=#get_service_report.care_report_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
								</cfif>	 
							</td>
							<!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="11"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id="57701.Filtre Ediniz">!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>

		<cfset url_str = "">
		<cfif isdefined("attributes.form_submitted")>
			<cfset url_str = "form_submitted=#attributes.form_submitted#">
			</cfif>
			<cfif len(attributes.keyword)>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>
			<cfif len(attributes.task_person_name)>
				<cfset url_str="#url_str#&task_person_name=#attributes.task_person_name#">
				<cfif len(attributes.task_par_id)>
					<cfset url_str="#url_str#&task_par_id=#attributes.task_par_id#">
				</cfif>
				<cfif len(attributes.task_cmp_id)>
					<cfset url_str="#url_str#&task_cmp_id=#attributes.task_cmp_id#">
				</cfif>
				<cfif len(attributes.task_employee_id)>
					<cfset url_str="#url_str#&task_employee_id=#attributes.task_employee_id#">
				</cfif>
			</cfif>
			<cfif len(attributes.task_person_name2)>
				<cfset url_str="#url_str#&task_person_nam2e=#attributes.task_person_name2#">
				<cfif len(attributes.task_par_id2)>
					<cfset url_str="#url_str#&task_par_id2=#attributes.task_par_id2#">
				</cfif>
				<cfif len(attributes.task_cmp_id2)>
					<cfset url_str="#url_str#&task_cmp_id2=#attributes.task_cmp_id2#">
				</cfif>
				<cfif len(attributes.task_employee_id2)>
					<cfset url_str="#url_str#&task_employee_id2=#attributes.task_employee_id2#">
				</cfif>
			</cfif>
			<cfif isdefined("attributes.service_substatus_id") and len(attributes.service_substatus_id)>
				<cfset url_str="#url_str#&service_substatus_id=#attributes.service_substatus_id#">
			</cfif>
			<cfif len(attributes.start_date)>
				<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
			</cfif>
			<cfif len(attributes.finish_date)>
				<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
			</cfif>
			<cf_paging 
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="service.list_service_report&#url_str#"> 
	</cf_box>
</div>
	<script type="text/javascript">
		document.list_care.keyword.focus();
	</script>

