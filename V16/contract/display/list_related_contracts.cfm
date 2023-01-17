<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.our_company_id" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.parts_partner_id" default="">
<cfparam name="attributes.parts_position_code" default="">
<cfparam name="attributes.parts_name" default="">
<cfparam name="attributes.contract_cat" default="">
<cfparam name="attributes.is_status" default="1">
<cfparam name="attributes.contract_type" default="">
<cfparam name="attributes.contract_calculation" default="">
<cfparam name="attributes.process_stage_type" default="">
<cfparam name="attributes.process_cat" default="">
<cfset get_fuseaction_property = createobject('component','V16.objects.cfc.fuseaction_properties')>
<cfset get_fuseaction_property = get_fuseaction_property.get_fuseaction_property(session.ep.company_id,'contract.popup_add_contract','x_process_cat')>
<cfif get_fuseaction_property.recordcount and get_fuseaction_property.property_value eq 1>
	<cfset x_process_cat = 1>
	<cfset Cmp = createObject("component","CustomTags.cfc.get_workcube_process_cat") />
	<cfset Cmp.action_db_type = dsn3 />
	<cfset Cmp.process_db = dsn&"." />
	<cfset Cmp.process_db3 = dsn3&"." />
	<cfset get_User_Process_Cat = Cmp.get_User_Process_Cat(
		position_code: #session.ep.position_code#,
		module_id: 17,
		process_type_info: '',
		fuseaction: attributes.fuseaction,
		is_check_all_control : 0,
		pathinfo : iif(isdefined("attributes.pathinfo") and len(attributes.pathinfo),"attributes.pathinfo",DE(""))
		) />
</cfif>
<cfif isdefined("attributes.form_submitted")>
	<cfif isdefined("x_process_cat")>
		<cfset processTypes = valuelist(get_User_Process_Cat.process_cat_id)>
	</cfif>
	<cfif Len(attributes.startdate)><cf_date tarih="attributes.startdate"></cfif>
	<cfif Len(attributes.finishdate)><cf_date tarih="attributes.finishdate"></cfif>
	<cfquery name="get_related_contract" datasource="#dsn3#">
		SELECT
			COMPANY_ID,
			CONSUMER_ID,
			COMPANY,
			CONSUMERS,
			EMPLOYEE,
			STARTDATE,
			FINISHDATE,
			PROJECT_ID,
			CONTRACT_ID,
			CONTRACT_HEAD,
			CONTRACT_NO,
			STAMP_TAX,
			COPY_NUMBER,
			CONTRACT_MONEY,
			CONTRACT_AMOUNT,
			ORDER_ID
			<cfif isdefined("x_process_cat")>
			,SP.PROCESS_CAT
			</cfif>
		FROM 
			RELATED_CONTRACT
			<cfif isdefined("x_process_cat")>
			LEFT JOIN SETUP_PROCESS_CAT SP ON RELATED_CONTRACT.PROCESS_CAT = SP.PROCESS_CAT_ID
			</cfif>
		WHERE 
			OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#iif(len(attributes.our_company_id),attributes.our_company_id,DE(session.ep.company_id))#">
			<cfif attributes.is_status eq 1>AND STATUS = 1<cfelseif attributes.is_status eq 0>AND STATUS = 0</cfif>
			<cfif len(attributes.contract_type)>
				AND CONTRACT_TYPE = #attributes.contract_type#
			</cfif>
			<cfif len(attributes.contract_calculation)>
				AND CONTRACT_CALCULATION = #attributes.contract_calculation#
			</cfif>
			<cfif len(attributes.process_stage_type)>
				AND STAGE_ID = #attributes.process_stage_type#
			</cfif>
			<cfif len(attributes.company_id) and len(attributes.company)>
				AND COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> 
			</cfif>
			<cfif len(attributes.consumer_id) and len(attributes.company)>
				AND CONSUMER_ID LIKE <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> 
			</cfif>
			<cfif len(attributes.keyword)>
				AND (
					CONTRACT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
					CONTRACT_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
					)
			</cfif>
			<cfif Len(attributes.project_id) and Len(attributes.project_head)>
				AND PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
			</cfif>
			<cfif Len(attributes.parts_name) and Len(attributes.parts_partner_id)>
				AND COMPANY_PARTNER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#attributes.parts_partner_id#,%">
			</cfif>
			<cfif Len(attributes.parts_name) and Len(attributes.parts_position_code)>
				 AND EMPLOYEE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#attributes.parts_position_code#,%">
			</cfif>
			<cfif Len(attributes.startdate)>
				AND STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
			</cfif>
			<cfif Len(attributes.finishdate)>
				AND FINISHDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
			</cfif>
			<cfif Len(attributes.contract_cat)>
				AND CONTRACT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.contract_cat#">
			</cfif>
			<cfif isDefined("attributes.not_contracts") and attributes.not_contracts eq 1>
				AND (COMPANY_ID IS NULL AND CONSUMER_ID IS NULL)
				<cfelseif isDefined("attributes.not_contracts") and attributes.not_contracts eq 2>
					AND (COMPANY_ID IS not NULL or CONSUMER_ID IS not NULL)
			</cfif>
			<cfif isdefined("x_process_cat")>
				<cfif isdefined("attributes.process_cat") and len(attributes.process_cat)>
					AND RELATED_CONTRACT.PROCESS_CAT IN (#attributes.process_cat#)
				<cfelseif isdefined("attributes.process_cat") and not len(attributes.process_cat)>
					AND
					( 
						<cfif isdefined("processTypes") and len(processTypes)>
							RELATED_CONTRACT.PROCESS_CAT IN (#processTypes#) OR 
						</cfif>
						RELATED_CONTRACT.PROCESS_CAT IS NULL
					)
				</cfif>
			</cfif>
         ORDER BY
         	CONTRACT_ID DESC
	</cfquery>
<cfelse>
	<cfset get_related_contract.recordcount = 0>
</cfif>
<cfquery name="get_contract_stage" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PTR.PROCESS_ID = PT.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%contract.list_related_contracts%">
</cfquery> 
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default="#get_related_contract.recordcount#">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="related_contract" action="#request.self#?fuseaction=contract.list_related_contracts" method="post">
			<input name="form_submitted" id="form_submitted" type="hidden" value="">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang(48,'Filtre',57460)#">
				</div>
				<div class="form-group">
					<select name="process_stage_type" id="process_stage_type">
						<option value=""><cf_get_lang dictionary_id='57756.Durum'></option>
						<cfoutput query="get_contract_stage">
							<option value="#process_row_id#" <cfif attributes.process_stage_type eq process_row_id>selected</cfif>>#stage#</option>
						</cfoutput>
					</select>
				</div>
				<cfif isdefined("x_process_cat")>
					<div class="form-group">
						<cf_workcube_process_cat slct_width="150" process_cat="#attributes.process_cat#" is_default="0">
					</div>
				</cfif>
				<div class="form-group">
					<select name="contract_type" id="contract_type">
						<option value=""><cf_get_lang dictionary_id='51040.Sözleşme Tipi'></option>
						<option value="1" <cfif attributes.contract_type eq 1>selected</cfif>><cf_get_lang dictionary_id='58176.Alış'></option>
						<option value="2" <cfif attributes.contract_type eq 2>selected</cfif>><cf_get_lang dictionary_id='57448.Satış'></option>
					</select>
				</div>
				<div class="form-group">
					<select name="contract_calculation" id="contract_calculation">
						<option value=""><cf_get_lang dictionary_id='51043.Hesaplama Yöntemi'></option>
						<option value="1" <cfif attributes.contract_calculation eq 1>selected</cfif>>%</option>
						<option value="2" <cfif attributes.contract_calculation eq 2>selected</cfif>><cf_get_lang dictionary_id='29513.Süre'></option>
						<option value="3" <cfif attributes.contract_calculation eq 3>selected</cfif>><cf_get_lang dictionary_id='57635.Miktar'></option>
					</select>
				</div>
				<div class="form-group">
						<cfsavecontent variable="text"><cf_get_lang dictionary_id='57486.Kategori'></cfsavecontent>
						<cf_wrk_combo
						name="contract_cat"
						query_name="GET_CONTRACT_CAT"
						option_name="contract_cat"
						option_text="#text#"
						value="#attributes.contract_cat#"
						option_value="contract_cat_id"
						width="175">
				</div>
				<div class="form-group">
						<select name="is_status" id="is_status" style="width:50px;">
							<option value="1" <cfif attributes.is_status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
							<option value="0" <cfif attributes.is_status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
							<option value="" <cfif attributes.is_status eq ''>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
						</select>
				</div>
				<div class="form-group small">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<cfoutput>
					
					<div class="col col-2 col-md-4 col-sm-6 col xs-12" type="column" index="2" sort="true">    
						<div class="form-group" id="item_project_head">
							<label class="col col-12"><cf_get_lang dictionary_id='57416.Proje'></label>
							<div class="col col-12">
								<div class="input-group">
									<input type="hidden" name="project_id" id="project_id" value="<cfif len(attributes.project_head)>#attributes.project_id#</cfif>">
									<input type="text" name="project_head"  id="project_head" value="<cfif len(attributes.project_head)>#UrlDecode(attributes.project_head)#</cfif>" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
									<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=order_form.project_id&project_head=order_form.project_head');"></span>
								</div>
							</div>
						</div>
					</div>    
					<div class="col col-2 col-md-4 col-sm-6 col xs-12" type="column" index="3" sort="true">
						<div class="form-group">
							<label class="col col-12"><cf_get_lang dictionary_id='50706.Taraflar'></label>
							<div class="col col-12">
								<div class="input-group">
									<input type="hidden" name="parts_partner_id" id="parts_partner_id" <cfif len(attributes.parts_name)> value="#attributes.parts_partner_id#"</cfif>>			
									<input type="hidden" name="parts_position_code" id="parts_position_code" <cfif len(attributes.parts_name)> value="#attributes.parts_position_code#"</cfif>>
									<input type="text" name="parts_name" id="parts_name" value="<cfif len(attributes.parts_name)>#attributes.parts_name#</cfif>" style="width:140px;" onFocus="AutoComplete_Create('parts_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,3\',\'<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'1\'','PARTNER_ID,POSITION_CODE','parts_partner_id,parts_position_code','related_contract','3','150');" autocomplete="off">
									<span class="input-group-addon icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_code=related_contract.parts_position_code&field_name=related_contract.parts_name&field_partner=related_contract.parts_partner_id&select_list=1,7&keyword='+encodeURIComponent(document.related_contract.parts_name.value),'list');"></span>
								</div>
							</div>
						</div>
					</div>    
					<div class="col col-2 col-md-4 col-sm-6 col xs-12" type="column" index="1" sort="true">
						<div class="form-group">
							<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58061.Cari'><cf_get_lang dictionary_id='30111.Durumu'></label>
							<div class="col col-12 col-xs-12">
								<select name="not_contracts" id="not_contracts">
									<option value=""><cf_get_lang dictionary_id='58061.Cari'><cf_get_lang dictionary_id='30111.Durumu'></option>
									<option value="1"<cfif isDefined("attributes.not_contracts") and (attributes.not_contracts eq 1)> selected</cfif>><cf_get_lang dictionary_id='50708.Carisi Olmayan'></option>
									<option value="2"<cfif isDefined("attributes.not_contracts") and (attributes.not_contracts eq 2)> selected</cfif>><cf_get_lang dictionary_id='65413.Carisi Olan'></option>
								</select>
							</div>                
						</div>
					</div>
					<div class="col col-2 col-md-4 col-sm-6 col xs-12" type="column" index="4" sort="true">    
						<div class="form-group">
							<label class="col col-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
							<div class="col col-12">
								<div class="input-group">
									<input type="hidden" name="consumer_id" id="consumer_id" <cfif len(attributes.company)> value="#attributes.consumer_id#"</cfif>>			
									<input type="hidden" name="company_id" id="company_id" <cfif len(attributes.company)> value="#attributes.company_id#"</cfif>>
									<input type="text" name="company" id="company" value="<cfif len(attributes.company)>#attributes.company#</cfif>" style="width:140px;" onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'1\'','COMPANY_ID,CONSUMER_ID','company_id,consumer_id','related_contract','3','150');" autocomplete="off">
									<span class="input-group-addon icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&field_comp_name=related_contract.company&field_comp_id=related_contract.company_id&field_consumer=related_contract.consumer_id&field_member_name=related_contract.company&select_list=2,3&keyword='+encodeURIComponent(document.related_contract.company.value),'list')"></span>
								</div>
							</div>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-6 col xs-12" type="column" index="5" sort="true">
						<div class="form-group">	
							<div class="col col-6">
								<label class="col col-12">&nbsp;<cf_get_lang dictionary_id="57655.Başlama Tarihi">
									<cfsavecontent variable="message_date"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent></label>
								<div class="input-group">
									<cfinput type="text" name="startdate" value="#dateformat(attributes.startdate,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message_date#" style="width:65px;">
									<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
								</div>
							</div>
							<div class="col col-6">
								<label class="col col-12">&nbsp;<cf_get_lang dictionary_id="57700.Bitiş Tarihi">
									<cfsavecontent variable="message_date"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent></label>
								<div class="input-group">
									<cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message_date#" style="width:65px;">
									<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
								</div>
							</div>
						</div>
					</div>
				</cfoutput>				
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cfsavecontent variable="header"><cf_get_lang dictionary_id="57437.Anlaşmalar"></cfsavecontent>
	<cf_box title="#header#" uidrop="1" hide_table_column="1" woc_setting = "#{ checkbox_name : 'print_invoice_id', print_type : 480}#">
		<cf_grid_list>
			<thead>
				<tr> 
					<th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='30044.Sözleşme No'></th>
					<th><cf_get_lang dictionary_id='29522.Sözleşme'></th>
					<cfif isdefined("x_process_cat")>
					<th><cf_get_lang dictionary_id='57800.İşlem Tipi'></th>
					</cfif>
					<th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
					<th><cf_get_lang dictionary_id='58211.Sipariş No'></th>
					<th><cf_get_lang dictionary_id='50985.Sözleşme Tutarı'>(<cf_get_lang dictionary_id='48656.KDV hariç'>)</th>
					<th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
					<th><cf_get_lang dictionary_id='53252.Damga Vergisi'> <cf_get_lang dictionary_id='54452.Tutar'></th>
					<th><cf_get_lang dictionary_id='39010.Kopya'><cf_get_lang dictionary_id='39852.Sayısı'></th>
					<th><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='53252.Damga Vergisi'> <cf_get_lang dictionary_id='54452.Tutar'></th>
					<th><cf_get_lang dictionary_id='57655.Başlama Tarihi'><!--- <cf_get_lang dictionary_id='1212.Geçerlilik Tarihi'> ---></th>
					<th><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
					<th><cf_get_lang dictionary_id='50706.Taraflar'><cf_get_lang dictionary_id='58885.Partner'></th>
					<th><cf_get_lang dictionary_id='50706.Taraflar'><cf_get_lang dictionary_id='57576.Çalışan'></th>
					<th><cf_get_lang dictionary_id='57416.Proje'></th>
					<!-- sil -->
					<th width="20" class="header_icn_none"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=contract.list_related_contracts&event=add" class="tableyazi"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					<cfif get_related_contract.recordcount>
						<th width="20" nowrap="nowrap" class="text-center header_icn_none">
							<cfif get_related_contract.recordcount eq 1> <a href="javascript://" onclick="send_print_reset();"><i class="fa fa-print" alt="<cf_get_lang dictionary_id='57389.Print Sayisi Sifirla'>" title="<cf_get_lang dictionary_id='57389.Print Sayisi Sifirla'>"></i></a></cfif>
							<input type="checkbox" name="allSelectDemand" id="allSelectDemand" onclick="wrk_select_all('allSelectDemand','print_invoice_id');">
						</th>  
					</cfif>
                       
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif GET_RELATED_CONTRACT.recordcount>
					<cfset company_list = "">
					<cfset consumer_list = "">
					<cfset employee_list = "">
					<cfset order_list = "" />
					<cfset project_list = "">
					<cfset contract_company_list = "">
					<cfset contract_consumer_list = "">
					
					<cfoutput query="GET_RELATED_CONTRACT" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfset order_id_ = listdeleteduplicates(order_id)>
					
						<cfloop from="1" to="#listlen(company)#" index="sayac">
							<cfif len(ListGetAt(COMPANY,sayac,',')) and not listfind(company_list,ListGetAt(COMPANY,sayac,','))>
								<cfset company_list = ListAppend(company_list,ListGetAt(COMPANY,sayac,','))>
							</cfif>
						</cfloop>
						<cfloop from="1" to="#listlen(consumers)#" index="sayac">
							<cfif len(ListGetAt(CONSUMERS,sayac,',')) and not listfind(consumer_list,ListGetAt(CONSUMERS,sayac,','))>
								<cfset consumer_list = ListAppend(consumer_list,ListGetAt(CONSUMERS,sayac,','))>
							</cfif>	
						</cfloop>
						<cfloop from="1" to="#listlen(employee)#" index="sayac">
							<cfif len(ListGetAt(employee,sayac,',')) and not listfind(employee_list,ListGetAt(employee,sayac,','))>
								<cfset employee_list = ListAppend(employee_list,ListGetAt(employee,sayac,','))>
							</cfif>	
						</cfloop>
						<cfloop from="1" to="#listlen(order_id_)#" index="sayac">
							<cfif len(ListGetAt(order_id_,sayac,',')) and not listfind(order_list,ListGetAt(order_id_,sayac,','),',')>
								<cfset order_list = Listappend(order_list,ListGetAt(order_id_,sayac,','),',') />
							</cfif>
						</cfloop>
						<cfloop from="1" to="#listlen(project_id)#" index="sayac">
							<cfif len(ListGetAt(project_id,sayac,',')) and not listfind(project_list,ListGetAt(project_id,sayac,','),',')>
								<cfset project_list = Listappend(project_list,ListGetAt(project_id,sayac,','),',')>
							</cfif>
						</cfloop>
						<cfif Len(company_id) and not ListFind(contract_company_list,company_id,',')>
							<cfset contract_company_list = ListAppend(contract_company_list,company_id,',')>
						</cfif>
						<cfif Len(consumer_id) and not ListFind(contract_consumer_list,consumer_id,',')>
							<cfset contract_consumer_list = ListAppend(contract_consumer_list,consumer_id,',')>
						</cfif>
					</cfoutput>
					<cfif len(company_list)>
						<cfset company_list=listsort(company_list,"numeric","ASC",",")>
						<cfquery name="GET_PARTNER" datasource="#dsn#">
							SELECT FULLNAME, COMPANY_ID FROM COMPANY WHERE COMPANY_ID IN (#company_list#) ORDER BY COMPANY_ID
						</cfquery>
						<cfset company_list = listsort(listdeleteduplicates(valuelist(GET_PARTNER.COMPANY_ID,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(consumer_list)>
						<cfset consumer_list=listsort(consumer_list,"numeric","ASC",",")>
						<cfquery name="get_consumer" datasource="#dsn#">
							SELECT CONSUMER_ID, CONSUMER_NAME + ' ' + CONSUMER_SURNAME AS FULLNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_list#) ORDER BY CONSUMER_ID
						</cfquery>
						<cfset consumer_list = listsort(listdeleteduplicates(valuelist(get_consumer.consumer_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(employee_list)>
						<cfset employee_list=listsort(employee_list,"numeric","ASC",",")>
						<cfquery name="get_employee" datasource="#dsn#">
							SELECT POSITION_ID, EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS FULLNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_ID IN (#employee_list#) ORDER BY POSITION_ID
						</cfquery>
						<cfset employee_list = listsort(listdeleteduplicates(valuelist(get_employee.position_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif Len(order_list)>
						<cfquery name="get_orders" datasource="#dsn3#">
							SELECT ORDER_ID, ORDER_NUMBER FROM ORDERS WHERE ORDER_ID IN (#order_list#) ORDER BY ORDER_ID
						</cfquery>
						<cfset order_list = ListSort(ListDeleteDuplicates(ValueList(get_orders.ORDER_ID,',')),"numeric","asc",",") />
					</cfif>
					<cfif Len(project_list)>
						<cfquery name="get_projects" datasource="#dsn#">
							SELECT PROJECT_ID,PROJECT_HEAD,PROJECT_NUMBER FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_list#) ORDER BY PROJECT_ID
						</cfquery>
						<cfset project_list = ListSort(ListDeleteDuplicates(ValueList(get_projects.project_id,',')),"numeric","asc",",")>
					</cfif>
					<cfif ListLen(contract_company_list)>
						<cfquery name="get_contract_company" datasource="#dsn#">
							SELECT COMPANY_ID, FULLNAME FROM COMPANY WHERE COMPANY_ID IN (#contract_company_list#) ORDER BY COMPANY_ID
						</cfquery>
						<cfset contract_company_list = ListSort(ListDeleteDuplicates(ValueList(get_contract_company.company_id,',')),"numeric","asc",",")>
					</cfif>
					<cfif ListLen(contract_consumer_list)>
						<cfquery name="get_contract_consumer" datasource="#dsn#">
							SELECT CONSUMER_ID, CONSUMER_NAME + ' ' + CONSUMER_SURNAME FULLNAME FROM CONSUMER WHERE CONSUMER_ID IN (#contract_consumer_list#) ORDER BY CONSUMER_ID
						</cfquery>
						<cfset contract_consumer_list = ListSort(ListDeleteDuplicates(ValueList(get_contract_consumer.consumer_id,',')),"numeric","asc",",")>
					</cfif>
					<cfoutput query="GET_RELATED_CONTRACT" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">  
						<tr><cfset order_id_ = listdeleteduplicates(order_id)>
							<td>#currentrow#</td>
							<td>#contract_no#</td>
							<td>
								<a href="#request.self#?fuseaction=contract.list_related_contracts&event=upd&contract_id=#CONTRACT_ID#" class="tableyazi">#Left(CONTRACT_HEAD,75)#</a>
							</td>
							<cfif isdefined("x_process_cat")>
								<td>#PROCESS_CAT#</td>
							</cfif>
							<td><cfif Len(company_id)>
									#get_contract_company.fullname[ListFind(contract_company_list,company_id,',')]#
								<cfelseif Len(consumer_id)>
									#get_contract_consumer.fullname[ListFind(contract_consumer_list,consumer_id,',')]#
								</cfif>
							</td>
							<td>
								<cfloop from="1" to="#listlen(order_id_)#" index="sayac">
									#get_orders.ORDER_NUMBER[listfind(order_list,ListGetAt(order_id_,sayac,','),',')]#<br/>
								</cfloop>
							</td>	
							<td class="moneybox">#TLFormat(contract_amount)#</td>	
							<td class="moneybox">#contract_money#</td>
							<td class="moneybox">#TLformat(stamp_tax)#</td>
							<td class="moneybox">#copy_number#</td>
							<td class="moneybox">
								<cfif len(copy_number)>
									#TLFormat(stamp_tax*copy_number)#
								<cfelse>
									#TLFormat(stamp_tax)#
								</cfif>
							</td>
							<td>#DateFormat(STARTDATE,dateformat_style)#</td>
							<td>#DateFormat(FINISHDATE,dateformat_style)#</td>
							
							<td><cfloop from="1" to="#listlen(COMPANY)#" index="sayac">
								#GET_PARTNER.FULLNAME[listfind(company_list,ListGetAt(COMPANY,sayac,','),',')]#<br/>
							</cfloop>
							<cfloop from="1" to="#listlen(consumers)#" index="sayac">
								#get_consumer.FULLNAME[listfind(consumer_list,ListGetAt(consumers,sayac,','),',')]#<br/>
							</cfloop>
						</td>
						<td><cfloop from="1" to="#listlen(employee)#" index="sayac">
								#get_employee.FULLNAME[listfind(employee_list,ListGetAt(employee,sayac,','),',')]#<br/>
							</cfloop>
						</td>
						<td><cfloop from="1" to="#listlen(project_id)#" index="sayac">
							<cf_get_lang dictionary_id="57487.No">:#get_projects.project_number[listfind(project_list,ListGetAt(project_id,sayac,','),',')]# - #get_projects.project_head[listfind(project_list,ListGetAt(project_id,sayac,','),',')]#<br/>
						</cfloop>
					</td>
							<!-- sil -->
							<td><a href="#request.self#?fuseaction=contract.list_related_contracts&event=upd&contract_id=#CONTRACT_ID#" class="tableyazi"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
							
					
						
						<td style="text-align:center"><input type="checkbox" name="print_invoice_id" id="print_invoice_id" value="#CONTRACT_ID#"></td>	</tr><!-- sil -->
					</cfoutput> 
				<cfelse>
					<tr>
						<cfset cols_ = 16>
						<cfif isdefined("x_process_cat")>
							<cfset cols_ = cols_ +1>
						</cfif>
						<td colspan="<cfoutput>#cols_#</cfoutput>"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		
		<cfset url_str = "&form_submitted=1">
		<cfif Len(attributes.keyword)><cfset url_str = "#url_str#&keyword=#attributes.keyword#"></cfif>
		<cfif Len(attributes.startdate)><cfset url_str = "#url_str#&startdate=#attributes.startdate#"></cfif>
		<cfif Len(attributes.finishdate)><cfset url_str = "#url_str#&finishdate=#attributes.finishdate#"></cfif>
		<cfif Len(attributes.our_company_id)><cfset url_str = "#url_str#&our_company_id=#attributes.our_company_id#"></cfif>
		<cfif Len(attributes.contract_cat)><cfset url_str = "#url_str#&contract_cat=#attributes.contract_cat#"></cfif>
		<cfif isDefined("attributes.not_contracts")><cfset url_str = "#url_str#&not_contracts=#attributes.not_contracts#"></cfif>
		<cfif Len(attributes.company_id) and Len(attributes.company)><cfset url_str = "#url_str#&company=#attributes.company#&company_id=#attributes.company_id#"></cfif>
		<cfif Len(attributes.consumer_id) and Len(attributes.company)><cfset url_str = "#url_str#&company=#attributes.company#&consumer_id=#attributes.consumer_id#"></cfif>
		<cfif Len(attributes.project_id) and Len(attributes.project_head)><cfset url_str = "#url_str#&project_head=#attributes.project_head#&project_id=#attributes.project_id#"></cfif>
		<cfif Len(attributes.parts_partner_id) and Len(attributes.parts_name)><cfset url_str = "#url_str#&parts_name=#attributes.parts_name#&parts_partner_id=#attributes.parts_partner_id#"></cfif>
		<cfif Len(attributes.parts_position_code) and Len(attributes.parts_name)><cfset url_str = "#url_str#&parts_name=#attributes.parts_name#&parts_position_code=#attributes.parts_position_code#"></cfif>
		<cfif Len(attributes.process_cat)><cfset url_str = "#url_str#&process_cat=#attributes.process_cat#"></cfif>
		<cf_paging 
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#attributes.fuseaction##url_str#"> 
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function uyar()
	{
		alert("<cf_get_lang dictionary_id ='51012.Anlasmayı Görebilmek İçin Lütfen Şirketinizi Değiştiriniz'>");
	}
</script>