<!--- Siparişler / İç Talepler -- toplu sipariş verme sayfasından xml ile bağlı olarak geliyor. --->
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.order_stage" default="">
<cfparam name="attributes.internaldemand_stage" default="">
<cfparam name="attributes.order_row_currency" default="">
<cfparam name="attributes.order_internaldemand" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.order_employee_id" default="">
<cfparam name="attributes.order_employee" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.company_" default="">
<cfparam name="attributes.company_id_" default="">
<cfparam name="attributes.department_out_id" default="">
<cfparam name="attributes.department_in_id" default="">
<cfparam name="attributes.status" default="1">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.prod_cat" default="">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.short_code_id" default="">
<cfparam name="attributes.short_code_name" default="">
<cfparam name="attributes.from_employee_id" default="">
<cfparam name="attributes.from_employee_name" default="">
<cfparam name="attributes.to_position_code" default="">
<cfparam name="attributes.to_position_name" default= "">
<cfparam name="attributes.sale_add_option" default= "">
<cfparam name="attributes.priority" default= "">
<cfparam name="attributes.start_date" default= "">
<cfparam name="attributes.finish_date" default= "">
<cfparam name="attributes.start_date1" default= "">
<cfparam name="attributes.finish_date1" default= "">
<cfparam name="attributes.start_date2" default= "">
<cfparam name="attributes.finish_date2" default= "">
<cfparam name="attributes.order_deliver_date" default= "">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfinclude template="../../sales/query/get_sale_add_option.cfm">
<cfinclude template="../../sales/query/get_product_cats.cfm">
<cfinclude template="../../sales/query/get_priority.cfm">
<cfinclude template="../query/get_stores2.cfm">
<cfquery name="get_process_type" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID,
		PT.PROCESS_NAME,
		PT.PROCESS_ID
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%sales.list_order%">
	ORDER BY
		PT.PROCESS_NAME,
		PTR.LINE_NUMBER
</cfquery>
<cfquery name="get_process_type2" datasource="#dsn#">
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
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listfirst(attributes.fuseaction,'.')#.list_internaldemand%">
</cfquery>
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_order_demand_list.cfm">
<cfelse>
	<cfset get_order_demand.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_order_demand.recordcount#'>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="order_internaldemandForm" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
			<input name="form_submitted" id="form_submitted" value="1" type="hidden">
			<cf_box_search> 
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" id="keyword" placeholder="#message#" value="#attributes.keyword#" maxlength="255" style="width:110px;">
				</div>
				<div class="form-group">
					<select name="order_stage" id="order_stage" style="width:150px;">
						<option value=""><cf_get_lang dictionary_id="38546.Sipariş Süreci"></option>
						<cfoutput query="get_process_type" group="process_id">
							<optgroup label="#process_name#"></optgroup>
							<cfoutput>
							<option value="#get_process_type.process_row_id#" <cfif Len(attributes.order_stage) and attributes.order_stage eq get_process_type.process_row_id>selected</cfif>>&nbsp;&nbsp;&nbsp;#get_process_type.stage#</option>
							</cfoutput>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="internaldemand_stage" id="internaldemand_stage" style="width:100px;">
						<option value=""><cf_get_lang dictionary_id="38547.İç Talep Süreci"></option>
						<cfoutput query="get_process_type2">
							<option value="#process_row_id#"<cfif attributes.internaldemand_stage eq process_row_id>selected</cfif>>#stage#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="order_row_currency" id="order_row_currency" style="width:100px;">
						<option value=""><cf_get_lang dictionary_id="38548.Satır Aşaması"></option>
						<option value="-1" <cfif attributes.order_row_currency eq -1>selected</cfif>><cf_get_lang dictionary_id="58717.Açık"></option>
						<option value="-2" <cfif attributes.order_row_currency eq -2>selected</cfif>><cf_get_lang dictionary_id="29745.Tedarik"></option>
						<option value="-3" <cfif attributes.order_row_currency eq -3>selected</cfif>><cf_get_lang dictionary_id="29746.Kapatıldı"></option>
						<option value="-4" <cfif attributes.order_row_currency eq -4>selected</cfif>><cf_get_lang dictionary_id="29747.Kısmi Üretim"></option>
						<option value="-5" <cfif attributes.order_row_currency eq -5>selected</cfif>><cf_get_lang dictionary_id="57456.Üretim"></option>
						<option value="-6" <cfif attributes.order_row_currency eq -6>selected</cfif>><cf_get_lang dictionary_id="58761.Sevk"></option>
						<option value="-7" <cfif attributes.order_row_currency eq -7>selected</cfif>><cf_get_lang dictionary_id="29748.Eksik Teslimat"></option>
						<option value="-8" <cfif attributes.order_row_currency eq -8>selected</cfif>><cf_get_lang dictionary_id="29749.Fazla Teslimat"></option>
						<option value="-9" <cfif attributes.order_row_currency eq -9>selected</cfif>><cf_get_lang dictionary_id="58506.İptal"></option>
						<option value="-10" <cfif attributes.order_row_currency eq -10>selected</cfif>><cf_get_lang dictionary_id="29746.Kapatıldı">(<cf_get_lang dictionary_id="58500.Manuel">)</option>
					</select>
				</div>
				<div class="form-group">
					<select name="order_internaldemand" id="order_internaldemand" style="width:100px;">
						<option value=""><cf_get_lang dictionary_id="57611.Sipariş">/<cf_get_lang dictionary_id="58798.İç Talep"></option>
						<option value="1" <cfif attributes.order_internaldemand eq 1>selected</cfif>><cf_get_lang dictionary_id="57611.Sipariş"></option>
						<option value="2" <cfif attributes.order_internaldemand eq 2>selected</cfif>><cf_get_lang dictionary_id="58798.İç Talep"></option>
					</select>
				</div>
				<div class="form-group">
					<select name="status" id="status" style="width:50px;">
						<option value="1" <cfif attributes.status eq 1>selected</cfif>><cf_get_lang dictionary_id="57493.Aktif"></option>
						<option value="2" <cfif attributes.status eq 2>selected</cfif>><cf_get_lang dictionary_id="57494.Pasif"></option>
						<option value="3" <cfif attributes.status eq 3>selected</cfif>><cf_get_lang dictionary_id="57708.Tümü"></option>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
				<div class="form-group">
                    <a class="ui-btn ui-btn-gray" href="<cfoutput>#request.self#</cfoutput>?fuseaction=purchase.add_order_product_all_criteria&select_order_demand=0"><cf_get_lang dictionary_id='64134.Tedarikçi ve Stok Durumuna Göre Sipariş'></a>
                </div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-project_head">
						<label class="col col-12"><cf_get_lang dictionary_id ='57416.proje'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined("attributes.project_id") and len (attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
								<input type="text" name="project_head"  id="project_head" style="width:110px;"value="<cfif isdefined('attributes.project_head') and  len(attributes.project_head)><cfoutput>#UrlDecode(attributes.project_head)#</cfoutput></cfif>" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','110');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=order_internaldemandForm.project_id&project_head=order_internaldemandForm.project_head');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-product_name">
						<label class="col col-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="product_id" id="product_id" <cfif len(attributes.product_name)>value="<cfoutput>#attributes.product_id#</cfoutput>"</cfif>>
								<input type="text" name="product_name" id="product_name" style="width:110px;" value="<cfoutput>#attributes.product_name#</cfoutput>" passthrough="readonly=yes" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID','product_id','','3','110');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=order_internaldemandForm.product_id&field_name=order_internaldemandForm.product_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&keyword='+encodeURIComponent(document.order_internaldemandForm.product_name.value),'list');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-brand_id">
						<label class="col col-12"><cf_get_lang dictionary_id="58847.Marka"></label>
						<div class="col col-12">
							<cf_wrkproductbrand
							width="110"
							compenent_name="getProductBrand"               
							boxwidth="240"
							boxheight="150"
							brand_id="#attributes.brand_id#">
						</div>
					</div>
					<div class="form-group" id="item-short_code_id">
						<label class="col col-12"><cf_get_lang dictionary_id='58225.Model'></label>
						<div class="col col-12">
							<cf_wrkproductmodel
							returninputvalue="short_code_id,short_code_name"
							returnqueryvalue="MODEL_ID,MODEL_NAME"
							width="110"
							fieldname="short_code_name"
							fieldid="short_code_id"
							compenent_name="getProductModel"            
							boxwidth="300"
							boxheight="150"                        
							model_id="#attributes.short_code_id#">
						</div>
					</div>
					<div class="form-group" id="item-prod_cat">
						<label class="col col-12"><cf_get_lang dictionary_id='57567.Ürün Kategorileri'></label>
						<div class="col col-12">
							<select name="prod_cat" id="prod_cat" style="width:170px;">
								<option value="" selected><cf_get_lang dictionary_id='57567.Ürün Kategorileri'></option>
								<cfoutput query="get_product_cats">
									<cfif listlen(HIERARCHY,".") lte 3>
										<option value="#HIERARCHY#"<cfif (attributes.prod_cat eq HIERARCHY) and len(attributes.prod_cat) eq len(HIERARCHY)> selected</cfif>>#HIERARCHY#-#product_cat#</option>
									</cfif>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-order_employee">
						<label class="col col-12"><cf_get_lang dictionary_id="38549.Satış Yapan"></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="order_employee_id" id="order_employee_id" value="<cfif isdefined('attributes.order_employee_id') and len(attributes.order_employee_id) and isdefined('attributes.order_employee') and len(attributes.order_employee)><cfoutput>#attributes.order_employee_id#</cfoutput></cfif>">
								<input name="order_employee" type="text" id="order_employee" style="width:110px;" onfocus="AutoComplete_Create('order_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','order_employee_id','','3','110');" value="<cfif isdefined('attributes.order_employee_id') and len(attributes.order_employee_id) and isdefined('attributes.order_employee') and len(attributes.order_employee)><cfoutput>#attributes.order_employee#</cfoutput></cfif>" autocomplete="off">	
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=order_internaldemandForm.order_employee_id&field_name=order_internaldemandForm.order_employee&is_form_submitted=1&select_list=1','list');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-member_name">
						<label class="col col-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="list_consumer_id" id="list_consumer_id" value="<cfif isdefined("attributes.list_consumer_id")><cfoutput>#attributes.list_consumer_id#</cfoutput></cfif>">
								<input type="hidden" name="list_company_id" id="list_company_id" value="<cfif isdefined("attributes.list_company_id")><cfoutput>#attributes.list_company_id#</cfoutput></cfif>">
								<input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type")><cfoutput>#attributes.member_type#</cfoutput></cfif>">
								<input type="text" name="member_name" id="member_name" style="width:110px;" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','list_consumer_id,list_company_id,member_type','','3','110');" value="<cfif isdefined("attributes.member_name") and len(attributes.member_name)><cfoutput>#attributes.member_name#</cfoutput></cfif>" autocomplete="off">
								<cfset str_linke_ait="&field_consumer=order_internaldemandForm.list_consumer_id&field_comp_id=order_internaldemandForm.list_company_id&field_member_name=order_internaldemandForm.member_name&field_type=order_internaldemandForm.member_type">
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars<cfoutput>#str_linke_ait#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>&select_list=7,8&keyword='+encodeURIComponent(document.order_internaldemandForm.member_name.value),'list');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-company_">
						<label class="col col-12"><cf_get_lang dictionary_id='29533.Tedarikçi'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="company_id_" id="company_id_" value="<cfif isdefined("attributes.company_id_") and len(attributes.company_id_) and isDefined("attributes.company_") and len(attributes.company_)><cfoutput>#attributes.company_id_#</cfoutput></cfif>">
								<input type="text" name="company_" id="company_" style="width:110px;"  value="<cfif isdefined("attributes.company_id_") and isDefined("attributes.company_") and len(attributes.company_id_) and len(attributes.company_)><cfoutput>#attributes.company_#</cfoutput></cfif>" onfocus="AutoComplete_Create('company_','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','company_id_','','3','110');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=order_internaldemandForm.company_&field_comp_id=order_internaldemandForm.company_id_<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2&keyword='+encodeURIComponent(document.order_internaldemandForm.company_.value),'list');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-priority">
						<label class="col col-12"><cf_get_lang dictionary_id='57485.Öncelik'></label>
						<div class="col col-12">
							<select name="priority" id="priority" style="width:80px;">
								<option value=""><cf_get_lang dictionary_id='57485.Öncelik'></option>
								<cfoutput query="get_priority">
									<option value="#get_priority.priority_id#"<cfif attributes.priority eq get_priority.priority_id>selected</cfif>>#priority# 
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-sale_add_option">
						<label class="col col-12"><cf_get_lang dictionary_id="38502.Özel Tanım"></label>
						<div class="col col-12">
							<select name="sale_add_option" style="width:150px;">
								<option value=""><cf_get_lang dictionary_id="38502.Özel Tanım"></option>
								<cfoutput query="get_sale_add_option">
									<option value="#sales_add_option_id#" <cfif attributes.sale_add_option eq sales_add_option_id>selected</cfif>>#sales_add_option_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-from_employee_name">
						<label class="col col-12"><cf_get_lang dictionary_id="38555.Talep Eden"></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="from_employee_id" id="from_employee_id" value="<cfif len(attributes.from_employee_id) and len(attributes.from_employee_name)><cfoutput>#attributes.from_employee_id#</cfoutput></cfif>">
								<input type="text" name="from_employee_name" id="from_employee_name" value="<cfif len(attributes.from_employee_id) and len(attributes.from_employee_name)><cfoutput>#attributes.from_employee_name#</cfoutput></cfif>" style="width:110px;" onfocus="AutoComplete_Create('from_employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','from_employee_id','','3','110');" autocomplete="off">	
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=order_internaldemandForm.from_employee_id&field_name=order_internaldemandForm.from_employee_name&is_form_submitted=1&select_list=1','list');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-to_position_name">
						<label class="col col-12"><cf_get_lang dictionary_id="38557.Talep Edilen"></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="to_position_code" id="to_position_code" value="<cfif len(attributes.to_position_code)><cfoutput>#attributes.to_position_code#</cfoutput></cfif>">
								<input type="text" name="to_position_name" id="to_position_name" value="<cfif len(attributes.to_position_code) and len(attributes.to_position_name)><cfoutput>#attributes.to_position_name#</cfoutput></cfif>"  style="width:110px;" onfocus="AutoComplete_Create('to_position_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','to_position_code','','3','110');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=order_internaldemandForm.to_position_code&field_name=order_internaldemandForm.to_position_name&select_list=1','list','popup_list_positions');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-department_in_id">
						<label class="col col-12"><cf_get_lang dictionary_id="57554.Giriş"> <cf_get_lang dictionary_id="58763.Depo"></label>
						<div class="col col-12">
							<select name="department_in_id" id="department_in_id" style="width:130px;">
								<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
								<cfoutput query="stores" group="department_id">
									<option value="#department_id#"<cfif attributes.department_in_id eq stores.department_id> selected</cfif>>#department_head#</option>
									<cfoutput>
										<option <cfif not status>style="color:##FF0000"</cfif> value="#department_id#-#location_id#" <cfif attributes.department_in_id eq '#department_id#-#location_id#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#comment#<cfif not status> - <cf_get_lang dictionary_id='57494.Pasif'></cfif></option>
									</cfoutput>
								</cfoutput>
							</select>	
							<!---<select name="department_in_id" id="department_in_id" style="width:130px;">
								<option value=""><cf_get_lang dictionary_id="142.Giriş"> <cf_get_lang dictionary_id="1351.Depo"></option>
								<cfoutput query="stores">
									<option value="#department_id#"<cfif attributes.department_in_id eq stores.department_id> selected</cfif>>#department_head#</option>
								</cfoutput>
							</select>  --->
						</div>
					</div>
					<div class="form-group" id="item-department_out_id">
						<label class="col col-12"><cf_get_lang dictionary_id="29428.Çıkış Depo"></label>
						<div class="col col-12">
							<select name="department_out_id" id="department_out_id" style="width:130px;">
								<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
								<cfoutput query="stores" group="department_id">
									<option value="#department_id#"<cfif attributes.department_out_id eq stores.department_id> selected</cfif>>#department_head#</option>
									<cfoutput>
										<option <cfif not status>style="color:##FF0000"</cfif> value="#department_id#-#location_id#" <cfif attributes.department_out_id eq '#department_id#-#location_id#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#comment#<cfif not status> - <cf_get_lang dictionary_id='57494.Pasif'></cfif></option>
									</cfoutput>
								</cfoutput>
							</select>	 
							<!---<select name="department_out_id" id="department_out_id" style="width:130px;">
								<option value=""><cf_get_lang dictionary_id="1631.Çıkış Depo"></option>
								<cfoutput query="stores">
								<option value="#department_id#"<cfif attributes.department_out_id eq stores.department_id> selected</cfif>>#department_head#</option>
								</cfoutput>
							</select> --->
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
					<div class="form-group" id="item-order_deliver_date">
						<label class="col col-12"><cf_get_lang dictionary_id="38558.Sipariş Verme Tarihi"></label>
						<div class="col col-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id ='57742.Tarih'>!</cfsavecontent>
								<cfinput type="text" name="order_deliver_date" id="order_deliver_date" maxlength="10" style="width:65px;" value="#dateformat(attributes.order_deliver_date,dateformat_style)#" validate="#validate_style#" message="#message#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="order_deliver_date"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-start_date2">
						<label class="col col-12"><cf_get_lang dictionary_id="57627.Kayıt Tarihi"></label>
						<div class="col col-12">
							<div class="col col-6">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id ='57742.Tarih'>!</cfsavecontent>
									<cfinput type="text" name="start_date2" id="start_date2" maxlength="10" style="width:65px;" value="#dateformat(attributes.start_date2,dateformat_style)#" validate="#validate_style#" message="#message#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="start_date2"></span>
								</div>
							</div>
							<div class="col col-6">
								<div class="input-group">
									<cfinput type="text" name="finish_date2" id="finish_date2" maxlength="10" style="width:65px;" value="#dateformat(attributes.finish_date2,dateformat_style)#" validate="#validate_style#" message="#message#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date2"></span>
								</div>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-start_date">
						<label class="col col-12"><cf_get_lang dictionary_id="29501.Sipariş Tarihi"></label>
						<div class="col col-12">
							<div class="col col-6">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id ='57742.Tarih'>!</cfsavecontent>
									<cfinput type="text" name="start_date" id="start_date" maxlength="10" style="width:65px;" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" message="#message#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
								</div>
							</div>
							<div class="col col-6">
								<div class="input-group">
									<cfinput type="text" name="finish_date" id="finish_date" maxlength="10" style="width:65px;" value="#dateformat(attributes.finish_date,dateformat_style)#" validate="#validate_style#" message="#message#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
								</div>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-start_date1">
						<label class="col col-12"><cf_get_lang dictionary_id="57645.Teslim Tarihi"></label>
						<div class="col col-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id ='57742.Tarih'>!</cfsavecontent>
							<div class="col col-6">
								<div class="input-group">
									<cfinput type="text" name="start_date1" id="start_date1" maxlength="10" style="width:65px;" value="#dateformat(attributes.start_date1,dateformat_style)#" validate="#validate_style#" message="#message#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="start_date1"></span>
								</div>
							</div>
							<div class="col col-6">
								<div class="input-group">
									<cfinput type="text" name="finish_date1" id="finish_date1" maxlength="10" style="width:65px;" value="#dateformat(attributes.finish_date1,dateformat_style)#" validate="#validate_style#" message="#message#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date1"></span>
								</div>
							</div>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cfform name="formBasket2" id="formBasket2" action="" method="post">
		<input type="hidden" name="date_new" id="date_new" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">
		<input type="hidden" name="convert_spect_id" id="convert_spect_id" value="">
		<input type="hidden" name="convert_stocks_id" id="convert_stocks_id" value="">
		<input type="hidden" name="convert_order_row_id" id="convert_order_row_id" value="">
		<input type="hidden" name="convert_wrk_row_id" id="convert_wrk_row_id" value="">
		<input type="hidden" name="convert_demand_row_id" id="convert_demand_row_id" value="">
		<input type="hidden" name="convert_amount_stocks_id" id="convert_amount_stocks_id" value="">
		<input type="hidden" name="convert_project_id" id="convert_project_id" value="">
		<input type="hidden" name="convert_project_head" id="convert_project_head" value="">
		<cfsavecontent variable="title"><cf_get_lang dictionary_id='38491.Siparişler'> / <cf_get_lang dictionary_id='38494.İç Talepler'></cfsavecontent>
		<cf_box title="#title#" uidrop="1" hide_table_column="1">
			<cf_grid_list>
				<thead>
					<tr>
						<th width="30"><cf_get_lang dictionary_id="57487.No"></th>
						<th><cf_get_lang dictionary_id="57630.Tip"></th>
						<th><cf_get_lang dictionary_id="58211.Sipariş No"></th>
						<th><cf_get_lang dictionary_id="29501.Sipariş Tarihi"></th>
						<th><cf_get_lang dictionary_id="57645.Teslim Tarihi"></th>
						<th><cf_get_lang dictionary_id="58859.Süreç"></th>
						<th><cf_get_lang dictionary_id="57482.Aşama"></th>
						<th><cf_get_lang dictionary_id="57416.Proje"></th>
						<th><cf_get_lang dictionary_id="57480.Konu"></th>
						<th><cf_get_lang dictionary_id="29428.Çıkış Depo"></th>
						<th><cf_get_lang dictionary_id="57554.Giriş"> <cf_get_lang dictionary_id="58763.Depo"></th>
						<th><cf_get_lang dictionary_id="57519.Cari Hesap"></th>
						<th><cf_get_lang dictionary_id="57518.Stok Kodu"></th>
						<th><cf_get_lang dictionary_id="58221.Ürün Adı"></th>
						<th><cf_get_lang dictionary_id="54851.Spec Adı"></th>
						<th><cf_get_lang dictionary_id="38563.KDV'siz Tutar"></th>
						<th><cf_get_lang dictionary_id="57673.Tutar"></th>
						<th><cf_get_lang dictionary_id="57489.Para Birimi"></th>
						<th><cf_get_lang dictionary_id="58444.Kalan"></th>
						<th><cf_get_lang dictionary_id="58506.İptal"></th>
						<th><cf_get_lang dictionary_id="57636.Birim"></th>
						<cfif x_show_stock_amount eq 1>
							<th><cf_get_lang dictionary_id="38565.Depo Stok Miktarı"></th>
						</cfif>
						<cfif x_show_sale_amount eq 1>
							<th><cf_get_lang dictionary_id="38564.Sipariş Miktarı"></th>
						</cfif>
						<th><a href="javascript://"><i class="icon-question"  style="font-size:13px !important;color:red !important;" title="<cf_get_lang dictionary_id='29718.İlişkiler'>"></i></a></th>
						<th style="width:30px;"><cf_get_lang dictionary_id="57684.Sonuç"></th>
						<th width="32" class="header_icn_none text-center"><cfif get_order_demand.recordcount><input type="checkbox" name="chck_all_rows" id="chck_all_rows" value="1" onclick="javascript: wrk_select_all('chck_all_rows','report_row_stock_id_');"></cfif></th>
					</tr>
				</thead>
					<cfset colspan_info = 24>
					<cfif x_show_stock_amount eq 1>
						<cfset colspan_info = colspan_info+1>
					</cfif>
					<cfif x_show_sale_amount eq 1>
						<cfset colspan_info = colspan_info+1>
					</cfif>
					<cfif get_order_demand.recordcount>
						<cfscript>
							company_id_list='';
							consumer_id_list='';
							project_name_list='';
							order_stage_list='';
							department_list_1='';
							department_list_2='';
							stock_id_list='';
						</cfscript>
						<cfoutput query="get_order_demand" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<cfif len(stock_id) and not listfind(stock_id_list,stock_id)>
								<cfset stock_id_list=listappend(stock_id_list,stock_id)>
							</cfif>
							<cfif len(company_id) and not listfind(company_id_list,company_id)>
								<cfset company_id_list=listappend(company_id_list,company_id)>
							</cfif>
							<cfif len(consumer_id) and not listfind(consumer_id_list,consumer_id)>
								<cfset consumer_id_list=listappend(consumer_id_list,consumer_id)>
							</cfif>
							<cfif len(project_id) and not listfind(project_name_list,project_id)>
								<cfset project_name_list = Listappend(project_name_list,project_id)>
							</cfif>
							<cfif len(order_stage) and not listfind(order_stage_list,order_stage)>
								<cfset order_stage_list=listappend(order_stage_list,order_stage)>
							</cfif>
							<cfif len(department_out) and not listfind(department_list_1,department_out)>
								<cfset department_list_1=listappend(department_list_1,department_out)>
							</cfif>
							<cfif len(department_in) and not listfind(department_list_1,department_in)>
								<cfset department_list_1=listappend(department_list_1,department_in)>
							</cfif>
						</cfoutput>
						<cfif len(company_id_list)>
							<cfset company_id_list = listsort(company_id_list,"numeric","ASC",",")>
							<cfquery name="get_company_detail" datasource="#dsn#">
								SELECT COMPANY_ID, NICKNAME, FULLNAME FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#) ORDER BY COMPANY_ID
							</cfquery>
							<cfset company_id_list = listsort(listdeleteduplicates(valuelist(get_company_detail.COMPANY_ID,',')),'numeric','ASC',',')>
						</cfif>
						<cfif len(consumer_id_list)>
							<cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
							<cfquery name="get_consumer_detail" datasource="#dsn#">
								SELECT CONSUMER_ID, CONSUMER_NAME, CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
							</cfquery>
							<cfset consumer_id_list = listsort(listdeleteduplicates(valuelist(get_consumer_detail.CONSUMER_ID,',')),'numeric','ASC',',')>
						</cfif>
						<cfif len(project_name_list)>
							<cfquery name="order_project" datasource="#dsn#">
								SELECT PROJECT_HEAD, PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_name_list#) ORDER BY PROJECT_ID
							</cfquery>
							<cfset project_name_list = listsort(listdeleteduplicates(valuelist(order_project.project_id,',')),"numeric","ASC",",")>
						</cfif>
						<cfif len(order_stage_list)>
							<cfset order_stage_list=listsort(order_stage_list,"numeric","ASC",",")>
							<cfquery name="process_type" datasource="#dsn#">
								SELECT STAGE, PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN(#order_stage_list#) ORDER BY PROCESS_ROW_ID
							</cfquery>
						</cfif>
						<cfif len(department_list_1)>
							<cfset department_list_1=listsort(department_list_1,"numeric","ASC",",")>
							<cfquery name="get_dep_detail" datasource="#dsn#">
								SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID IN (#department_list_1#) ORDER BY DEPARTMENT_ID
							</cfquery>
							<cfset department_list_1 = listsort(listdeleteduplicates(valuelist(get_dep_detail.department_id,',')),'numeric','ASC',',')>
						</cfif>
						<cfquery name="get_stock_last" datasource="#DSN2#">
							SELECT
								SUM(GSL.REAL_STOCK) LAST_STOCK,
								GSL.STOCK_ID,
								GSL.DEPARTMENT_ID,
								GSL.LOCATION_ID
							FROM
								GET_STOCK_LAST_LOCATION GSL						
							WHERE
								GSL.STOCK_ID IN(#stock_id_list#)
							GROUP BY
								GSL.STOCK_ID,
								GSL.DEPARTMENT_ID,
								GSL.LOCATION_ID
							ORDER BY
								GSL.STOCK_ID
						</cfquery>
						<cfquery name="get_order_amounts" datasource="#DSN3#">
							SELECT
								SUM(LAST_STOCK) LAST_STOCK,
								STOCK_ID,
								DEPARTMENT_ID,
								LOCATION_ID
							FROM
							(
								SELECT
									(ORR.QUANTITY - ISNULL(ORR.DELIVER_AMOUNT,0)) AS LAST_STOCK,
									ORR.STOCK_ID,
									ISNULL(ISNULL(ORR.DELIVER_DEPT,DELIVER_DEPT_ID),0) DEPARTMENT_ID,
									ISNULL(ISNULL(ORR.DELIVER_LOCATION,LOCATION_ID),0) LOCATION_ID
								FROM
									ORDER_ROW ORR,
									ORDERS O			
								WHERE
									((O.PURCHASE_SALES = 1 AND O.ORDER_ZONE = 0) OR (O.PURCHASE_SALES = 0 AND O.ORDER_ZONE = 1)) 
									AND O.ORDER_ID = ORR.ORDER_ID
									AND O.ORDER_STATUS = 1
									AND ORR.STOCK_ID IN(#stock_id_list#)
									AND (ORR.QUANTITY - ISNULL(ORR.DELIVER_AMOUNT,0))>0
									AND ORR.ORDER_ROW_CURRENCY NOT IN(-3,-10,-9,-8)
							)T1
							GROUP BY
								STOCK_ID,
								DEPARTMENT_ID,
								LOCATION_ID
						</cfquery>
						<cfquery name="get_demand_amounts" datasource="#DSN3#">
							SELECT
								SUM(LAST_STOCK) LAST_STOCK,
								STOCK_ID,
								DEPARTMENT_ID,
								LOCATION_ID
							FROM
							(
								SELECT
									(ORR.QUANTITY - ISNULL((SELECT SUM(IR.AMOUNT) FROM #dsn2_alias#.SHIP_ROW IR WHERE IR.WRK_ROW_RELATION_ID = ORR.WRK_ROW_ID),0)- ISNULL((SELECT SUM(ORR2.QUANTITY) FROM ORDER_ROW ORR2 WHERE ORR2.WRK_ROW_RELATION_ID = ORR.WRK_ROW_ID),0)) AS LAST_STOCK, 
									ORR.STOCK_ID,
									ISNULL(DEPARTMENT_OUT,0) DEPARTMENT_ID,
									ISNULL(LOCATION_OUT,0) LOCATION_ID
								FROM
									INTERNALDEMAND_ROW ORR,
									INTERNALDEMAND O			
								WHERE
									O.INTERNAL_ID = ORR.I_ID
									AND O.IS_ACTIVE = 1
									AND ORR.STOCK_ID IN(#stock_id_list#)
									AND (ORR.QUANTITY - ISNULL((SELECT SUM(IR.AMOUNT) FROM #dsn2_alias#.SHIP_ROW IR WHERE IR.WRK_ROW_RELATION_ID = ORR.WRK_ROW_ID),0)- ISNULL((SELECT SUM(ORR2.QUANTITY) FROM ORDER_ROW ORR2 WHERE ORR2.WRK_ROW_RELATION_ID = ORR.WRK_ROW_ID),0))>0
							)T1
							GROUP BY
								STOCK_ID,
								DEPARTMENT_ID,
								LOCATION_ID
						</cfquery>
						<cfoutput query="get_order_demand" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<cfscript>
								if(get_stock_last.recordcount neq 0)
								{
									for(stock_ind=1; stock_ind lte get_stock_last.recordcount; stock_ind=stock_ind+1)
									{
										if(get_order_demand.STOCK_ID eq get_stock_last.STOCK_ID[stock_ind]) 
										{
											if(get_stock_last.department_id[stock_ind] eq -1) dept_id = 0; else dept_id = get_stock_last.department_id[stock_ind];
											if(get_stock_last.location_id[stock_ind] eq -1) loc_id = 0; else loc_id = get_stock_last.location_id[stock_ind];
											'depo_stok_durumu_#get_order_demand.STOCK_ID#_#dept_id#_#loc_id#'=get_stock_last.last_stock[stock_ind];
											if(isdefined("stok_durumu_#get_order_demand.STOCK_ID#"))
												'stok_durumu_#get_order_demand.STOCK_ID#'=evaluate('stok_durumu_#get_order_demand.STOCK_ID#')+get_stock_last.last_stock[stock_ind];
											else
												'stok_durumu_#get_order_demand.STOCK_ID#'=get_stock_last.last_stock[stock_ind];
										}
									}
								}
								if(get_order_amounts.recordcount neq 0)
								{
									for(stock_ind=1; stock_ind lte get_order_amounts.recordcount; stock_ind=stock_ind+1)
									{
										if(get_order_demand.STOCK_ID eq get_order_amounts.STOCK_ID[stock_ind]) 
										{
											if(get_order_amounts.department_id eq -1) dept_id = 0; else dept_id = get_order_amounts.department_id;
											if(get_order_amounts.location_id eq -1) loc_id = 0; else loc_id = get_order_amounts.location_id;
											'depo_sip_durumu_#get_order_demand.STOCK_ID#_#dept_id#_#loc_id#'=get_order_amounts.last_stock[stock_ind];
											if(isdefined("sip_durumu_#get_order_demand.STOCK_ID#"))
												'sip_durumu_#get_order_demand.STOCK_ID#'=evaluate('sip_durumu_#get_order_demand.STOCK_ID#')+get_order_amounts.last_stock[stock_ind];
											else
												'sip_durumu_#get_order_demand.STOCK_ID#'=get_order_amounts.last_stock[stock_ind];
										}
									}
								}
								if(get_demand_amounts.recordcount neq 0)
								{
									for(stock_ind=1; stock_ind lte get_demand_amounts.recordcount; stock_ind=stock_ind+1)
									{
										if(get_order_demand.STOCK_ID eq get_demand_amounts.STOCK_ID[stock_ind]) 
										{
											if(get_order_amounts.department_id eq -1) dept_id = 0; else dept_id = get_demand_amounts.department_id;
											if(get_order_amounts.location_id eq -1) loc_id = 0; else loc_id = get_demand_amounts.location_id;
											'depo_talep_durumu_#get_order_demand.STOCK_ID#_#dept_id#_#loc_id#'=get_demand_amounts.last_stock[stock_ind];
											if(isdefined("talep_durumu_#get_order_demand.STOCK_ID#"))
												'talep_durumu_#get_order_demand.STOCK_ID#'=evaluate('talep_durumu_#get_order_demand.STOCK_ID#')+get_demand_amounts.last_stock[stock_ind];
											else
												'talep_durumu_#get_order_demand.STOCK_ID#'=get_demand_amounts.last_stock[stock_ind];
										}
									}
								}
							</cfscript>
						</cfoutput>
						<tbody>
							<cfoutput query="get_order_demand" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
								<input type="hidden" name="product_name_#wrk_row_id#" id="product_name_#wrk_row_id#" value="#product_name#">
								<tr>
									<td>#currentrow#</td>
									<td nowrap><cfif type eq 1><cf_get_lang dictionary_id="57611.Sipariş"><cfelse><cf_get_lang dictionary_id="38566.Talep"></cfif></td>
									<td nowrap>
										<cfif type eq 1>
											<cfif is_instalment eq 1>
												<a href="#request.self#?fuseaction=sales.upd_fast_sale&order_id=#action_id#" class="tableyazi">#order_number#</a></td>
											<cfelse>	
												<a href="#request.self#?fuseaction=sales.list_order&event=upd&order_id=#action_id#" class="tableyazi">#order_number#</a></td>
											</cfif>
										<cfelse>
											<cfif demand_type eq 1> 
												<a href="#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.list_purchasedemand&event=upd&id=#action_id#" class="tableyazi">#order_number#</a>
											<cfelse>
												<a href="#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.list_internaldemand&event=upd&id=#action_id#" class="tableyazi">#order_number#</a>
											</cfif>
										</cfif>
									</td>
									<td>#dateformat(action_date,dateformat_style)#</td>
									<td>#dateformat(deliverdate,dateformat_style)#</td>
									<td nowrap><cfif len(order_stage)>#process_type.stage[listfind(order_stage_list,order_stage,',')]#</cfif></td>
									<td>
										<cfswitch expression = "#ORDER_ROW_CURRENCY#">
											<cfcase value="-7"><cf_get_lang dictionary_id='29748.Eksik Teslimat'> </cfcase>
											<cfcase value="-8"><cf_get_lang dictionary_id='29749.Fazla Teslimat'> </cfcase>
											<cfcase value="-6"><cf_get_lang dictionary_id='58761.Sevk'> </cfcase>
											<cfcase value="-5"><cf_get_lang dictionary_id='57456.Üretim'> </cfcase>
											<cfcase value="-4"><cf_get_lang dictionary_id='29747.Kısmi Üretim'> </cfcase>
											<cfcase value="-3"><cf_get_lang dictionary_id='29746.Kapatıldı'> </cfcase>
											<cfcase value="-2"><cf_get_lang dictionary_id='29745.Tedarik'> </cfcase>
											<cfcase value="-1"><cf_get_lang dictionary_id='58717.Açık'> </cfcase>
										</cfswitch>
									</td>
									<td> 
										<cfif len(project_id)> 
											<a href="#request.self#?fuseaction=project.projects&event=det&id=#order_project.project_id[listfind(project_name_list,project_id,',')]#" class="tableyazi">#order_project.project_head[listfind(project_name_list,project_id,',')]#</a></td>
										</cfif>
									</td>
									<td>#order_head#</td>
									<td><cfif len(department_out)>#get_dep_detail.department_head[listfind(department_list_1,department_out,',')]#</cfif></td>
									<td><cfif len(department_in)>#get_dep_detail.department_head[listfind(department_list_1,department_in,',')]#</cfif></td>
									<td>
										<cfif len(COMPANY_ID)>
											<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#COMPANY_ID#','medium');">#get_company_detail.nickname[listfind(company_id_list,company_id,',')]#</a>
										<cfelseif len(CONSUMER_ID)>
											<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#CONSUMER_ID#','medium');">#get_consumer_detail.consumer_name[listfind(consumer_id_list,consumer_id,',')]# #get_consumer_detail.consumer_surname[listfind(consumer_id_list,consumer_id,',')]#</a>
										</cfif>
									</td>
									<td>
										<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#');">
											#product_code#
										</a>
									</td>
									<td>
										<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#');">
											#product_name#
										</a>
									</td>
									<td>#spect_var_name#</td>
									<td align="right" style="text-align:right;"><cfif len(NETTOTAL)>#TlFormat(NETTOTAL)#</cfif></td>
									<td align="right" style="text-align:right;"><cfif len(NETTOTAL)>#TLFormat(NETTOTAL+(NETTOTAL*TAX/100))#</cfif></td>
									<td><cfif len(NETTOTAL)>#session.ep.money#</cfif></td>
									<td align="right" style="text-align:right;">#last_amount#</td>
									<td align="right" style="text-align:right;">#cancel_amount#</td>
									<td>#unit#</td>
									<cfif x_show_stock_amount eq 1>
										<td align="right" style="text-align:right;">
											<cfif type eq 1>
												<cfif len(deliver_dept) and len(deliver_location) and deliver_dept neq 0>
													<cfif isdefined('depo_stok_durumu_#stock_id#_#deliver_dept#_#deliver_location#')>
														<cfset stock_amount = evaluate('depo_stok_durumu_#stock_id#_#deliver_dept#_#deliver_location#')>
													<cfelse>
														<cfset stock_amount = 0>
													</cfif>
												<cfelseif len(department_out) and len(location_out) and department_out neq 0>
													<cfif isdefined('depo_stok_durumu_#stock_id#_#department_out#_#location_out#')>
														<cfset stock_amount = evaluate('depo_stok_durumu_#stock_id#_#department_out#_#location_out#')>
													<cfelse>
														<cfset stock_amount = 0>
													</cfif>
												<cfelse>
													<cfif isdefined('stok_durumu_#stock_id#')>
														<cfset stock_amount = evaluate('stok_durumu_#stock_id#')>
													<cfelse>
														<cfset stock_amount = 0>
													</cfif>
												</cfif>
											<cfelse>
												<cfif len(department_out) and len(location_out) and department_out neq 0>
													<cfif isdefined('depo_stok_durumu_#stock_id#_#department_out#_#location_out#')>
														<cfset stock_amount = evaluate('depo_stok_durumu_#stock_id#_#department_out#_#location_out#')>
													<cfelse>
														<cfset stock_amount = 0>
													</cfif>
												<cfelse>
													<cfset stock_amount = 0>
												</cfif>
											</cfif>
											#stock_amount#
										</td>
									</cfif>
									<cfif x_show_sale_amount eq 1>
										<td align="right" style="text-align:right;">
											<cfif type eq 1>
												<cfif len(deliver_dept) and len(deliver_location) and deliver_dept neq 0>
													<cfif isdefined('depo_sip_durumu_#stock_id#_#deliver_dept#_#deliver_location#')>
														<cfset sip_amount = evaluate('depo_sip_durumu_#stock_id#_#deliver_dept#_#deliver_location#')>
													<cfelse>
														<cfset sip_amount = 0>
													</cfif>
												<cfelseif len(department_out) and len(location_out) and department_out neq 0>
													<cfif isdefined('depo_sip_durumu_#stock_id#_#department_out#_#location_out#')>
														<cfset sip_amount = evaluate('depo_sip_durumu_#stock_id#_#department_out#_#location_out#')>
													<cfelse>
														<cfset sip_amount = 0>
													</cfif>
												<cfelse>
													<cfif isdefined('sip_durumu_#stock_id#')>
														<cfset sip_amount = evaluate('sip_durumu_#stock_id#')>
													<cfelse>
														<cfset sip_amount = 0>
													</cfif>
												</cfif>
											<cfelse>
												<cfif len(department_out) and len(location_out) and department_out neq 0>
													<cfif isdefined('depo_talep_durumu_#stock_id#_#department_out#_#location_out#')>
														<cfset sip_amount = evaluate('depo_talep_durumu_#stock_id#_#department_out#_#location_out#')>
													<cfelse>
														<cfset sip_amount = 0>
													</cfif>
												<cfelse>
													<cfset sip_amount = 0>
												</cfif>
											</cfif>
											#sip_amount#
										</td>
									</cfif>
									<td align="center">
										<!-- sil -->
											<cfif type eq 1>
												<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_order_receive_rate&order_id=#action_id#&is_sale=1','wide');"><img src="/images/stockstrategy.gif"></a>
											<cfelse>
												<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_internaldemand_relation&internaldemand_id=#action_id#','list');"><i class="icon-question"  style="font-size:13px !important;color:##FF0000 !important;" title="<cf_get_lang dictionary_id='29718.İlişkiler'>"></i></a>
											</cfif>
										<!-- sil -->
									</td>
									<td><cfinput type="text" name="demand_amount_#wrk_row_id#" id="demand_amount_#wrk_row_id#" value="#last_amount-cancel_amount#" class="moneybox" style="width:40px;" validate="integer" onKeyUp="return(FormatCurrency(this,event));"></td>
									<td style="text-align:center;"><!-- sil --><input type="checkbox" name="report_row_stock_id_" id="report_row_stock_id_" value="#type#;#action_row_id#;#stock_id#;#spect_main_id#;#wrk_row_id#;#product_id#;#last_amount-cancel_amount#"><!-- sil --></td>
								</tr>
							</cfoutput>
						</tbody>
					<cfelse>
						<tr>
							<td colspan="<cfoutput>#colspan_info#</cfoutput>">
								<cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif> 
							</td>
						</tr>
					</cfif>
			</cf_grid_list>
			<cfset url_str = attributes.fuseaction&"&form_submitted=1">
			<cfif len(attributes.keyword)>
				<cfset url_str = url_str & "&keyword=#attributes.keyword#">
			</cfif>
			<cfif len(attributes.order_stage)>
				<cfset url_str = url_str & "&order_stage=#attributes.order_stage#">
			</cfif>
			<cfif len(attributes.internaldemand_stage)>
				<cfset url_str = url_str & "&internaldemand_stage=#attributes.internaldemand_stage#">
			</cfif>
			<cfif len(attributes.order_row_currency)>
				<cfset url_str = url_str & "&order_row_currency=#attributes.order_row_currency#">
			</cfif>
			<cfif len(attributes.order_internaldemand)>
				<cfset url_str = url_str & "&order_internaldemand=#attributes.order_internaldemand#">
			</cfif>
			<cfif len(attributes.status)>
				<cfset url_str = url_str & "&status=#attributes.status#">
			</cfif>
			<cfif isdefined('attributes.project_id') and len(attributes.project_id) and isdefined('attributes.project_head') and len(attributes.project_head)>
				<cfset url_str = url_str & "&project_id=#attributes.project_id#&project_head=#URLEncodedFormat(attributes.project_head)#">
			</cfif>
			<cfif len(attributes.product_id) and len(attributes.product_name)>
				<cfset url_str = url_str & "&product_id=#attributes.product_id#&product_name=#attributes.product_name#">
			</cfif>
			<cfif len(attributes.brand_id)>
				<cfset url_str = url_str & "&brand_id=#attributes.brand_id#">
			</cfif>
			<cfif len(attributes.order_employee_id) and len(attributes.order_employee)>
				<cfset url_str = url_str & "&order_employee_id=#attributes.order_employee_id#&order_employee=#attributes.order_employee#">
			</cfif>
			<cfif len(attributes.from_employee_id) and len(attributes.from_employee_name)>
				<cfset url_str = url_str & "&from_employee_id=#attributes.from_employee_id#&from_employee_name=#attributes.from_employee_name#">
			</cfif>
			<cfif len(attributes.to_position_code) and len(attributes.to_position_name)>
				<cfset url_str = url_str & "&to_position_code=#attributes.to_position_code#&to_position_name=#attributes.to_position_name#">
			</cfif>
			<cfif len(attributes.company_id_) and len(attributes.company_)>
				<cfset url_str = url_str & "&company_id_=#attributes.company_id_#&company_=#attributes.company_#">
			</cfif>
			<cfif len(attributes.short_code_id) and len(attributes.short_code_name)>
				<cfset url_str = url_str & "&short_code_id=#attributes.short_code_id#&short_code_name=#attributes.short_code_name#">
			</cfif>
			<cfif isdefined("attributes.member_type") and len(attributes.member_type)>
				<cfset url_str = url_str & "&member_type=#attributes.member_type#&member_name=#attributes.member_name#">
			</cfif>
			<cfif isdefined("attributes.list_company_id") and len(attributes.list_company_id)>
				<cfset url_str = url_str & "&list_company_id=#attributes.list_company_id#">
			</cfif>
			<cfif isdefined("attributes.list_consumer_id") and len(attributes.list_consumer_id)>
				<cfset url_str = url_str & "&list_consumer_id=#attributes.list_consumer_id#">
			</cfif>
			<cfif isdefined("attributes.department_out_id") and len(attributes.department_out_id)>
				<cfset url_str = url_str & "&department_out_id=#attributes.department_out_id#">
			</cfif>
			<cfif isdefined("attributes.department_in_id") and len(attributes.department_in_id)>
				<cfset url_str = url_str & "&department_in_id=#attributes.department_in_id#">
			</cfif>
			<cfif isdefined("attributes.prod_cat") and len(attributes.prod_cat)>
				<cfset url_str = url_str & "&prod_cat=#attributes.prod_cat#">
			</cfif>
			<cfif isdefined("attributes.priority") and len(attributes.priority)>
				<cfset url_str = url_str & "&priority=#attributes.priority#">
			</cfif>
			<cfif isdefined("attributes.sale_add_option") and len(attributes.sale_add_option)>
				<cfset url_str = url_str & "&sale_add_option=#attributes.sale_add_option#">
			</cfif>
			<cfif isdate(attributes.start_date)>
				<cfset url_str = url_str & "&start_date=#dateformat(attributes.start_date,dateformat_style)#">
			</cfif>
			<cfif isdate(attributes.finish_date)>
				<cfset url_str = url_str & "&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
			</cfif>
			<cfif isdate(attributes.start_date1)>
				<cfset url_str = url_str & "&start_date1=#dateformat(attributes.start_date1,dateformat_style)#">
			</cfif>
			<cfif isdate(attributes.finish_date1)>
				<cfset url_str = url_str & "&finish_date1=#dateformat(attributes.finish_date1,dateformat_style)#">
			</cfif>
			<cfif isdate(attributes.start_date2)>
				<cfset url_str = url_str & "&start_date2=#dateformat(attributes.start_date2,dateformat_style)#">
			</cfif>
			<cfif isdate(attributes.finish_date2)>
				<cfset url_str = url_str & "&finish_date2=#dateformat(attributes.finish_date2,dateformat_style)#">
			</cfif>
			<cfif isdate(attributes.order_deliver_date)>
				<cfset url_str = url_str & "&order_deliver_date=#dateformat(attributes.order_deliver_date,dateformat_style)#">
			</cfif>
			<cf_paging 
				name="formBasket2"
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#url_str#"
				is_form="1">
		</cf_box>
		<cfif isdefined("attributes.form_submitted") and get_order_demand.recordcount>
			<cf_box>
				<cf_box_elements vertical="1">
					<!-- sil -->   
						<cfoutput>
							<div class="form-group col col-3">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57519.cari hesap'>*</cfsavecontent>
								<label>#message#</label>
								<div class="input-group">
									<input type="hidden" name="consumer_id" id="consumer_id" value="">
									<input type="hidden" name="partner_id" id="partner_id" value="">
									<input type="hidden" name="company_id" id="company_id" value="">
									<input type="text" name="company" id="company" style="width:140px;"  value="" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE','get_member_autocomplete','\'1\',0,0,0','COMPANY_ID,PARTNER_ID,CONSUMER_ID','company_id,partner_id,consumer_id','','3','250','get_comp_cat()');">
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_all_pars&field_comp_id=formBasket2.company_id&field_comp_name=formBasket2.company&field_partner=formBasket2.partner_id&select_list=7&field_consumer=formBasket2.consumer_id&call_function=get_comp_cat();','list')"></span>
								</div>
							</div>
							<div class="form-group col col-3">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58763.Depo'>*</cfsavecontent>
								<label>#message#</label>
								<cfsavecontent variable="alertmessage"><cf_get_lang dictionary_id='36061.Depo seçiniz'>*</cfsavecontent>
								<div class="input-group">
									<input type="hidden" name="branch_id" id="branch_id" value="<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)><cfoutput>#attributes.branch_id#</cfoutput></cfif>">
									<input type="hidden" name="deliver_dept_id" id="deliver_dept_id" value="<cfif isdefined('attributes.deliver_dept_id') and len(attributes.deliver_dept_id)><cfoutput>#attributes.deliver_dept_id#</cfoutput></cfif>">
									<input type="hidden" name="deliver_loc_id" id="deliver_loc_id" value="<cfif isdefined('attributes.deliver_loc_id') and len(attributes.deliver_loc_id)><cfoutput>#attributes.deliver_loc_id#</cfoutput></cfif>">
									<cfinput type="text" name="deliver_dept_name" id="deliver_dept_name" required="yes"   style="width:150px;" message="#alertmessage#" value="">
									<cfset str_link_dep = "objects.popup_list_stores_locations&form_name=formBasket2&field_location_id=deliver_loc_id&field_name=deliver_dept_name&field_id=deliver_dept_id&branch_id=branch_id" >
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=#str_link_dep#</cfoutput>','list');"></span>
								</div>
							</div>
							<div class="form-group col col-2">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57645.Teslim Tarihi'>*</cfsavecontent>
								<label>#message#</label>
								<div class="input-group">
									<cfinput type="text" name="deliverdate" id="deliverdate" style="width:68px;" value=""  validate="#validate_style#" maxlength="10">
									<span class="input-group-addon"><cf_wrk_date_image date_field="deliverdate"></span>
								</div>
							</div>
							<div class="form-group col col-3">
								<label><cf_get_lang dictionary_id="58964.Fiyat Listesi"></label>
								<select name="price_catid" id="price_catid" style="width:150px;">
									<option value=""><cf_get_lang dictionary_id="58964.Fiyat Listesi"></option>
								</select>
							</div>
						</cfoutput>
					<!-- sil -->
				</cf_box_elements>
				<cf_box_footer>
					<input type="button" class="ui-wrk-btn ui-wrk-btn-success" name="pur_order" id="pur_order" value="<cf_get_lang dictionary_id='38567.Satınalma Siparişi Oluştur'>" onclick="add_order();">
				</cf_box_footer>
			</cf_box>
		</cfif>
	</cfform>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function get_comp_cat()
	{
		var get_comp_cat=wrk_query("SELECT COMPANYCAT_ID FROM COMPANY WHERE COMPANY_ID ="+document.formBasket2.company_id.value,"dsn");
		var get_price_cat=wrk_query("SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT WHERE PRICE_CAT_STATUS=1 AND IS_PURCHASE=1 AND COMPANY_CAT LIKE '%,"+get_comp_cat.COMPANYCAT_ID+",%' ORDER BY PRICE_CAT ASC","dsn3");
		var price_len = eval('document.getElementById("price_catid")').options.length;
		for(kk=price_len;kk>=0;kk--)
			eval('document.getElementById("price_catid")').options[kk] = null;	
			
		eval('document.getElementById("price_catid")').options[0] = new Option('Fiyat Listesi','');

		for(var jj=0;jj < get_price_cat.recordcount;jj++)
			eval('document.getElementById("price_catid")').options[jj+1]=new Option(get_price_cat.PRICE_CAT[jj],get_price_cat.PRICE_CATID[jj]);

	}
	function add_order()
	{
		if((document.formBasket2.company_id.value == '' && document.formBasket2.consumer_id.value == '') ||  document.formBasket2.company.value == '')
		{
			alert("<cf_get_lang dictionary_id='57183.Cari Hesap Seçmelisiniz'> !");
			return false;
		}
		if(document.formBasket2.deliver_dept_name.value == '' && document.formBasket2.deliver_dept_id.value == '')
		{
			alert("<cf_get_lang dictionary_id='36061.Depo seç'> !");
			return false;
		}
		if(document.formBasket2.deliverdate.value == '')
		{
			alert("<cf_get_lang dictionary_id='46856.Teslim Tarihi Girmelisiniz'> !");
			return false;
		}
		<cfif x_show_price_list eq 1>
		if(document.formBasket2.price_catid.value == '')
		{
			alert("<cf_get_lang dictionary_id='45954.Fiyat Listesi Seçmelisiniz'> !");
			return false;
		}
		</cfif>
		var convert_stocks_id ='';
		var convert_spect_id ='';
		var convert_amount_stocks_id ='';
		var convert_wrk_row_id ='';
		var convert_order_row_id ='';
		var convert_demand_row_id ='';
		var convert_product_id ='';
		zero_list = '';
		if(document.all.report_row_stock_id_.length != undefined)
		{
			var checked_item_ = document.all.report_row_stock_id_;
			var convert_stocks_id ='';
			var convert_amount_stocks_id ='';
			var convert_spect_id ='';
			var convert_wrk_row_id ='';
			var convert_order_row_id ='';
			var convert_demand_row_id ='';
			var convert_product_id ='';
			for(var xx=0; xx < document.all.report_row_stock_id_.length; xx++)
			{
				if(checked_item_[xx].checked)
				{
					var type=list_getat(checked_item_[xx].value,1,';');
					var action_row_id=list_getat(checked_item_[xx].value,2,';');
					var stock_id_=list_getat(checked_item_[xx].value,3,';');
					var spect_id_=list_getat(checked_item_[xx].value,4,';');
					var wrk_row_id_=list_getat(checked_item_[xx].value,5,';');
					var product_id_=list_getat(checked_item_[xx].value,6,';');
					var amount_old_=list_getat(checked_item_[xx].value,7,';');
					var amount=eval("document.formBasket2.demand_amount_"+wrk_row_id_).value;
					var product_name=eval("document.formBasket2.product_name_"+wrk_row_id_).value;
					if(amount > 0)
					{
						var is_selected_row = 1;
						if(list_len(convert_stocks_id,',') == 0)
						{
							if(type == 1)
								convert_order_row_id+=action_row_id;
							else
								convert_demand_row_id+=action_row_id;
							convert_wrk_row_id+=wrk_row_id_;
							convert_stocks_id+=stock_id_;
							convert_product_id+=product_id_;
							convert_amount_stocks_id+=amount;
							convert_spect_id+=spect_id_;
						}
						else
						{
							if(type == 1)
							{
								if(list_len(convert_order_row_id,',') == 0)
									convert_order_row_id+=action_row_id;
								else
									convert_order_row_id+=","+action_row_id;
							}
							else
							{
								if(list_len(convert_demand_row_id,',') == 0)
									convert_demand_row_id+=action_row_id;
								else
									convert_demand_row_id+=","+action_row_id;
							}
							convert_wrk_row_id+=","+wrk_row_id_;
							convert_product_id+=","+product_id_;
							convert_amount_stocks_id+=","+amount;
							convert_spect_id+=","+spect_id_;
						}
					}
					else
					{
						
						if(list_len(zero_list,',') == 0)
							zero_list+=product_name;
						else
							zero_list+=","+product_name;
					}
				}
			}
		}
		else if(document.all.report_row_stock_id_)
		{
			var type=list_getat(document.all.report_row_stock_id_.value,1,';');
			var action_row_id=list_getat(document.all.report_row_stock_id_.value,2,';');
			var stock_id_=list_getat(document.all.report_row_stock_id_.value,3,';');
			var spect_id_=list_getat(document.all.report_row_stock_id_.value,4,';');
			var wrk_row_id_=list_getat(document.all.report_row_stock_id_.value,5,';');
			var product_id_=list_getat(document.all.report_row_stock_id_.value,6,';');
			var amount_old_=list_getat(document.all.report_row_stock_id_.value,7,';');
			var amount=eval("document.formBasket2.demand_amount_"+wrk_row_id_).value;
			var product_name=eval("document.formBasket2.product_name_"+wrk_row_id_).value;
			if(amount > 0)
			{
				var is_selected_row = 1;
				if(list_len(convert_stocks_id,',') == 0)
				{
					if(type == 1)
						convert_order_row_id+=action_row_id;
					else
						convert_demand_row_id+=action_row_id;
					convert_wrk_row_id+=wrk_row_id_;
					convert_stocks_id+=stock_id_;
					convert_product_id+=product_id_;
					convert_amount_stocks_id+=amount;
					convert_spect_id+=spect_id_;
				}
				else
				{
					if(type == 1)
					{
						if(list_len(convert_order_row_id,',') == 0)
							convert_order_row_id+=action_row_id;
						else
							convert_order_row_id+=","+action_row_id;
					}
					else
					{
						if(list_len(convert_demand_row_id,',') == 0)
							convert_demand_row_id+=action_row_id;
						else
							convert_demand_row_id+=","+action_row_id;
					}
					convert_wrk_row_id+=","+wrk_row_id_;
					convert_stocks_id+=","+stock_id;
					convert_product_id+=","+product_id_;
					convert_amount_stocks_id+=","+amount;
					convert_spect_id+=","+spect_id_;
				}
			}
			else
			{
				if(list_len(zero_list,',') == 0)
					zero_list+=product_name;
				else
					zero_list+=","+product_name;
			}
		}
		if(is_selected_row == undefined)
		{
			alert("<cf_get_lang dictionary_id='57725.Ürün Seçiniz'>!");
			return false;
		}
		else if(list_len(zero_list,',') != 0)
		{
			alert("<cf_get_lang dictionary_id='60631.Aşağıdaki Ürünler İçin Sipariş Miktarı Sıfır Olduğu İçin Baskete Atılmayacaktır'> !\n\n\n"+product_name);
		}
		if(list_len(convert_stocks_id,',') > 0)
		{
			convert_stocks_id+=0;
			var paper_date_ = js_date(formBasket2.date_new.value.toString() );
			var str_price_row="SELECT PRODUCT_ID,PRODUCT_NAME FROM PRODUCT PP WHERE PRODUCT_ID IN("+convert_product_id+") AND PRODUCT_ID NOT IN(SELECT P.PRODUCT_ID FROM PRICE P WHERE P.PRODUCT_ID = PP.PRODUCT_ID AND P.PRICE_CATID="+document.formBasket2.price_catid.value+" AND (FINISHDATE >="+paper_date_+" OR FINISHDATE IS NULL))";
			var get_price_row=wrk_query(str_price_row,"dsn3");
			if(get_price_row.recordcount)
			{
				fiyatsiz_urunler = '';
				for(kk=0;kk<get_price_row.recordcount;kk++)
					fiyatsiz_urunler = fiyatsiz_urunler + get_price_row.PRODUCT_NAME[kk] + '\n';
					
					$('.ui-cfmodal__alert .required_list li').remove();

						$('.ui-cfmodal__alert .required_list').append('<li class="required"><i class="fa fa-terminal"></i><cf_get_lang dictionary_id='65464.Aşağıdaki Ürünler İçin Seçilen Fiyat Listesinde, Fiyat Bulunmamaktadır. Devam Etmek İstiyor musunuz ?'>  \n\n'+fiyatsiz_urunler+'</li>');

						$('.ui-cfmodal__alert').fadeIn();
					return false;
			}
			document.all.convert_wrk_row_id.value=convert_wrk_row_id;
			document.all.convert_stocks_id.value=convert_stocks_id;
			document.all.convert_spect_id.value=convert_spect_id;
			document.all.convert_amount_stocks_id.value=convert_amount_stocks_id;
			document.all.convert_demand_row_id.value=convert_demand_row_id;
			document.all.convert_order_row_id.value=convert_order_row_id;
			if(document.getElementById('project_id') != undefined && document.getElementById('project_id').value != '' && document.getElementById('project_head') != undefined && document.getElementById('project_head').value != '')
			{
				document.all.convert_project_id.value = document.getElementById('project_id').value;
				document.all.convert_project_head.value = document.getElementById('project_head').value;
			}
			else
			{
				document.all.convert_project_id.value = '';
				document.all.convert_project_head.value = '';
			}
			document.formBasket2.action='<cfoutput>#request.self#?fuseaction=purchase.list_order&event=add&type=convert&is_from_report=1&is_wrk_row_id=1</cfoutput>';
			document.formBasket2.submit();
			return true;
		}
	}
</script>
<div style="display:none" class="ui-cfmodal ui-cfmodal__alert">
              
	<div class="boxRow uniqueBox " id="unique_box_3357723">
	<div id="action_box_3357723" style="display:none; width:1px;"></div>
		<div id="box_3357723" class="portBox portBottom" style="box-shadow:0px 1px 15px 1px rgba(39, 39, 39, 0.08)" data-reload="reload_box_3357723" data-basket="0">
			<div class="portBoxBodyStandart  scrollContent  ">
					<div id="body_box_3357723" style=";width:100%;">
					<div class="ui-cfmodal-close">×</div>
					<ul class="required_list"></ul>
					</div>
			</div>
		</div>
	</div>
		<script type="text/javascript">
			$( ".draggable_cf_box" ).draggable({
				handle: ".portHeadLight"
			});
			if(($(".pageMainLayout .boxRow").length > 2) || 0 == 1){
				$('.catalystClose').click(function(){
					$(this).closest(".boxRow").hide();
				});
				$('.portHeadLightMenu').delegate('> ul > li > a','click',function(){
					$('.portHeadLightMenu > ul > li > ul').stop().fadeOut();
					$(this).parent().find("> ul").stop().fadeToggle();
				});
			}       
		</script>
	<script>
		
		function copyToClipboard() {
			var copyText = document.getElementById("copyToClipboardInput");
			copyText.select();
			copyText.setSelectionRange(0, 99999); /* For mobile devices */
			navigator.clipboard.writeText(copyText.value);
			alert("Kopyalandı : " + copyText.value);
		}
		
	</script>
	
</div>