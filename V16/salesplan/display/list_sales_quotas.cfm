<cf_xml_page_edit>
<cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.ch_company_id" default="">
<cfparam name="attributes.ch_consumer_id" default="">
<cfparam name="attributes.ch_company" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.team_id" default="">
<cfparam name="attributes.team_name" default="">
<cfparam name="attributes.is_active" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.process_stage_type" default="">
<cfparam name="attributes.quota_type" default="">
<cfparam name="attributes.period_type" default="">
<cfparam name="attributes.result_info" default="">
<cfparam name="attributes.listing_type" default="0">
<cfif isDefined("attributes.is_form_submitted")>
	<cfif isDate(attributes.start_date)><cf_date tarih="attributes.start_date"></cfif>
	<cfif isDate(attributes.finish_date)><cf_date tarih="attributes.finish_date"></cfif>
	<cfquery name="get_sales_quota" datasource="#dsn3#">
		SELECT
			*
		FROM
			<cfif Len(attributes.listing_type) and attributes.listing_type eq 1><!--- Satir Bazinda --->
				SALES_QUOTAS_ROW SW,
			</cfif>
			SALES_QUOTAS S
		WHERE
			S.SALES_QUOTA_ID IS NOT NULL
			<cfif Len(attributes.listing_type) and attributes.listing_type eq 1>
				AND S.SALES_QUOTA_ID = SW.SALES_QUOTA_ID
			</cfif>
			<cfif len(attributes.keyword)>
				AND S.PAPER_NO LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
			</cfif>
			<cfif len(attributes.process_stage_type)>
				AND S.PROCESS_STAGE = #attributes.process_stage_type#
			</cfif>
			<cfif len(attributes.is_active)>
				AND S.IS_ACTIVE = #attributes.is_active#
			</cfif>
			<cfif len(attributes.ch_company_id) and len(attributes.ch_company)>
				AND S.COMPANY_ID = #attributes.ch_company_id#
			</cfif>
			<cfif len(attributes.ch_consumer_id)  and len(attributes.ch_company)>
				AND S.CONSUMER_ID = #attributes.ch_consumer_id#
			</cfif>
			<cfif len(attributes.employee_id) and len(attributes.employee_name)>
				AND S.EMPLOYEE_ID = #attributes.employee_id#
			</cfif>
			<cfif len(attributes.team_id) and len(attributes.team_name)>
				AND S.TEAM_ID = #attributes.team_id#
			</cfif>
			<cfif len(attributes.quota_type)>
				AND S.IS_SALES_PURCHASE = #attributes.quota_type#
			</cfif>
			<cfif Len(attributes.listing_type) and attributes.listing_type eq 1>
				<cfif len(attributes.period_type)>
					AND SW.PERIOD_TYPE = #attributes.period_type#
				</cfif>
				<cfif len(attributes.result_info)>
					<cfif attributes.result_info eq 0>
						AND (SELECT COUNT(SQRR.RELATION_ID) FROM SALES_QUOTAS_ROW_RELATION SQRR WHERE SQRR.SALES_QUOTAS_ROW_ID = SW.SALES_QUOTA_ROW_ID AND TYPE = 1) < SW.PERIOD_COUNT
					<cfelse>
						AND (SELECT COUNT(SQRR.RELATION_ID) FROM SALES_QUOTAS_ROW_RELATION SQRR WHERE SQRR.SALES_QUOTAS_ROW_ID = SW.SALES_QUOTA_ROW_ID AND TYPE = 1) = SW.PERIOD_COUNT
					</cfif>
				</cfif>
			<cfelse>
				<cfif len(attributes.period_type)>
					AND S.SALES_QUOTA_ID IN(SELECT SWW.SALES_QUOTA_ID FROM SALES_QUOTAS_ROW SWW WHERE SWW.PERIOD_TYPE = #attributes.period_type#)
				</cfif>
			</cfif>
			<cfif isDate(attributes.start_date)>
				AND S.PLAN_DATE >= #attributes.start_date#
			</cfif>
			<cfif isDate(attributes.finish_date)>
				AND S.FINISH_DATE <= #attributes.finish_date#
			</cfif>
		ORDER BY
			S.PLAN_DATE
	</cfquery>
<cfelse>
	<cfset Get_Sales_Quota.recordcount = 0>
</cfif>
<cfquery name="GET_STAGE" datasource="#DSN#">
	SELECT
		PTR.STAGE,
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
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%salesplan.list_sales_quotas%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.is_form_submitted" default="">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.totalrecords" default="#GET_SALES_QUOTA.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="list_quota" action="#request.self#?fuseaction=#fusebox.circuit#.list_sales_quotas" method="post">
			<cf_box_search>
				<div class="form-group">
					<div class="input-group">
						<cfinput type="hidden" name="is_form_submitted" value="1">
						<cfsavecontent variable="place"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
						<cfinput type="text" name="keyword" id="keyword" maxlength="50" value="#attributes.keyword#" placeholder="#place#">
					</div>
				</div>
				<div class="form-group">
					<select name="process_stage_type" id="process_stage_type">
						<option value=""><cf_get_lang dictionary_id='57482.Aşama'></option>
						<cfoutput query="get_stage">
							<option value="#process_row_id#" <cfif attributes.process_stage_type eq process_row_id>selected</cfif>>#stage#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="is_active" id="is_active">
						<option value=""><cf_get_lang dictionary_id='58081.Hepsi'></option>
						<option value="1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="0" <cfif attributes.is_active eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="kontrol()">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-ch_company">
						<label class="col col-12"><cf_get_lang dictionary_id='57457.Müşteri'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="ch_company_id" id="ch_company_id"  value="<cfif len(attributes.ch_company_id)><cfoutput>#attributes.ch_company_id#</cfoutput></cfif>">
								<input type="hidden" name="ch_consumer_id" id="ch_consumer_id"  value="<cfif len(attributes.ch_consumer_id)><cfoutput>#attributes.ch_consumer_id#</cfoutput></cfif>">
								<cfinput type="text" name="ch_company" id="ch_company" value="#attributes.ch_company#" onFocus="AutoComplete_Create('ch_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',0,0,0','COMPANY_ID,CONSUMER_ID','ch_company_id,ch_consumer_id','','3','250');" placeholder="#getLang('main',45)#">
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_period_kontrol=0&select_list=2,3&field_comp_id=list_quota.ch_company_id&field_consumer=list_quota.ch_consumer_id&field_member_name=list_quota.ch_company</cfoutput>&keyword='+encodeURIComponent(document.list_quota.ch_company.value))" title="<cf_get_lang dictionary_id='57734.seçiniz'>"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-listing_type">
						<label class="col col-12"><cf_get_lang dictionary_id='57660.Belge Bazında'> / <cf_get_lang dictionary_id='29539.Satır Bazında'></label>
						<div class="col col-12">
							<select name="listing_type" id="listing_type">
								<option value="0" <cfif attributes.listing_type eq 0>selected</cfif>><cf_get_lang dictionary_id='57660.Belge Bazında'></option>
								<option value="1" <cfif attributes.listing_type eq 1>selected</cfif>><cf_get_lang dictionary_id='29539.Satır Bazında'></option>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="2">
					<div class="form-group" id="item-employee_name">
						<label class="col col-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined('attributes.employee_id') and len(attributes.employee_id) and isdefined('attributes.employee_name') and len(attributes.employee_name)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
								<input name="employee_name" type="text" id="employee_name" placeholder="<cfoutput>#getLang('main','Çalışan',57576)#"</cfoutput> onFocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','150');" value="<cfif isdefined('attributes.employee_id') and len(attributes.employee_id) and isdefined('attributes.employee_name') and len(attributes.employee_name)><cfoutput>#attributes.employee_name#</cfoutput></cfif>" autocomplete="off">
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=list_quota.employee_id&field_name=list_quota.employee_name&select_list=1');" title="<cf_get_lang dictionary_id='57734.seçiniz'>"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-period_type">
						<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58472.Dönem'></label>
						<div class="col col-12">
							<select name="period_type" id="period_type">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<option value="0" <cfif attributes.period_type eq 0>selected</cfif>><cf_get_lang dictionary_id ='58724.Ay'></option>
								<option value="1" <cfif attributes.period_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='58879.3 Ay'></option>
								<option value="2" <cfif attributes.period_type eq 2>selected</cfif>><cf_get_lang dictionary_id ='58455.Yıl'></option>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="3">
					<div class="form-group" id="item-team_name">
						<label class="col col-12"><cf_get_lang dictionary_id='58511.Takım'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="team_id" id="team_id" value="<cfif isdefined('attributes.team_id') and len(attributes.team_id) and isdefined('attributes.team_name') and len(attributes.team_name)><cfoutput>#attributes.team_id#</cfoutput></cfif>">
								<input name="team_name" type="text" id="team_name" onFocus="AutoComplete_Create('team_name','TEAM_NAME','TEAM_NAME,SZ_NAME','get_team','','TEAM_ID','team_id','','3','150');" value="<cfif isdefined('attributes.team_id') and len(attributes.team_id) and isdefined('attributes.team_name') and len(attributes.team_name)><cfoutput>#attributes.team_name#</cfoutput></cfif>" autocomplete="off" placeholder="<cfoutput>#getLang('','Takım',58511)#</cfoutput>">
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_sales_zones_team&field_sz_team_id=list_quota.team_id&field_sz_team_name=list_quota.team_name','','ui-draggable-box-small');" title="<cf_get_lang dictionary_id='57734.seçiniz'>"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-result_info">
						<label class="col col-12"><cfoutput><cf_get_lang dictionary_id='41576.Hesaplanmış'> / <cf_get_lang dictionary_id='41577.Hesaplanmamış'></cfoutput></label>
						<div class="col col-12">
							<select name="result_info" id="result_info">
								<option value=""><cf_get_lang dictionary_id='58081.Hepsi'></option>
								<option value="0" <cfif attributes.result_info eq 0>selected</cfif>><cf_get_lang dictionary_id='41577.Hesaplanmamış'></option>
								<option value="1" <cfif attributes.result_info eq 1>selected</cfif>><cf_get_lang dictionary_id='41576.Hesaplanmış'></option>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="4">
					<div class="form-group" id="item-start_date">
						<label class="col col-12"><cf_get_lang dictionary_id='57501.başlangıç'> <cf_get_lang dictionary_id='58593.tarihi'></label>
						<div class="col col-12">
							<div class="col col-6">
								<div class="input-group">
									<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
									<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
								</div>
							</div>
							<div class="col col-6">
								<div class="input-group">
									<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" validate="#validate_style#" maxlength="10" >
									<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
								</div>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-quota_type">
						<label class="col col-12"><cf_get_lang dictionary_id ='41609.Satış/Satınalma'></label>
						<div class="col col-12">
							<select name="quota_type" id="quota_type">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<option value="1" <cfif attributes.quota_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57448.Satış'></option>
								<option value="0" <cfif attributes.quota_type eq 0>selected</cfif>><cf_get_lang dictionary_id='49752.Satınalma'></option>
							</select>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','Satış Kotaları',58189)#" uidrop="1" hide_table_column="1" woc_setting = "#{ checkbox_name : 'print_quota_id',  print_type : 340 }#">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id="58577.Sıra"></th>
					<cfset cols= "7">
					<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 1)><th></th><cfset cols = cols +1></cfif>
					<th><cf_get_lang dictionary_id='57880.Belge No'></th>
					<th><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></th>
					<th><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
					<th><cf_get_lang dictionary_id='57482.Aşama'></th>
					<th><cf_get_lang dictionary_id='57457.Müşteri'></th>
					<cfif Len(attributes.listing_type) and attributes.listing_type eq 1><!--- Satir Bazinda --->
						<cfset cols = cols +12>
						<th><cf_get_lang dictionary_id='57658.Üye'></th>
						<th><cf_get_lang dictionary_id='58847.Marka'></th>
						<th><cf_get_lang dictionary_id='57486.Kategori'></th>
						<th><cf_get_lang dictionary_id='57657.Ürün'></th>
						<th><cf_get_lang dictionary_id='58472.Dönem'></th>
						<th><cf_get_lang dictionary_id='57635.Miktar'></th>
						<th><cf_get_lang dictionary_id='41588.Prim'> %</th>
						<th><cf_get_lang dictionary_id='41588.Prim'><cf_get_lang dictionary_id='57673.Tutar'></th>
						<th><cf_get_lang dictionary_id='41594.Mal Fazlası'></th>
						<th><cf_get_lang dictionary_id='41516.Kar'> %</th>
						<th><cf_get_lang dictionary_id='41516.Kar'> <cf_get_lang dictionary_id='57673.Tutar'></th>
						<th><cf_get_lang dictionary_id='57673.Tutar'></th>
						<cfelse>
						<cfset cols = cols +5>
						<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
						<th><cf_get_lang dictionary_id='57673.Tutar'></th>
						<th><cf_get_lang dictionary_id='41579.Döviz Tutar'></th>
					</cfif>
					<th><cf_get_lang dictionary_id='41560.Planlayan'></th>
					<!-- sil -->
					<th width="20" class="header_icn_none text-center">
						<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=salesplan.list_sales_quotas&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
					</th>
					<th width="20" class="text-center header_icn_none">
						<cfif isdefined("attributes.is_form_submitted") and Get_Sales_Quota.recordcount>
						<input type="checkbox" name="allSelectDemand" id="allSelectDemand" onclick="wrk_select_all('allSelectDemand','print_quota_id');"></th>	</cfif>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif isDefined("attributes.is_form_submitted") and Get_Sales_Quota.recordcount and form_varmi eq 1>
					<cfset emp_id_list=''>
					<cfset process_list=''>
					<cfset supplier_list = "">
					<cfset product_list= "">
					<cfset category_list = "">
					<cfset brand_list = "">
					<cfset company_list = "">
					<cfset consumer_list = "">
					<cfoutput query="get_sales_quota" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(planner_emp_id) and not listfind(emp_id_list,planner_emp_id)>
							<cfset emp_id_list=listappend(emp_id_list,planner_emp_id)>
						</cfif>
						<cfif len(process_stage) and not listfind(process_list,process_stage)>
							<cfset process_list = listappend(process_list,process_stage)>
						</cfif>
						<cfif Len(attributes.listing_type) and attributes.listing_type eq 1><!--- Satir Bazinda --->
							<cfif len(supplier_id) and not listfind(supplier_list,supplier_id)>
								<cfset supplier_list = listappend(supplier_list,supplier_id)>
							</cfif>
							<cfif len(product_id) and not listfind(product_list,product_id)>
								<cfset product_list = listappend(product_list,product_id)>
							</cfif>
							<cfif len(category_id) and not listfind(category_list,category_id)>
								<cfset category_list = listappend(category_list,category_id)>
							<cfelseif len(multi_category_id) and not listfind(category_list,multi_category_id)>
								<cfset category_list = listappend(category_list,multi_category_id)>
							</cfif>
							<cfif len(brand_id) and not listfind(brand_list,brand_id)>
								<cfset brand_list = listappend(brand_list,brand_id)>
							</cfif>
						</cfif>
						<cfif len(company_id) and not listfind(company_list,company_id)>
							<cfset company_list = listappend(company_list,company_id)>
						</cfif>
						<cfif len(consumer_id) and not listfind(consumer_list,consumer_id)>
							<cfset consumer_list = listappend(consumer_list,consumer_id)>
						</cfif>
					</cfoutput>
					<cfif listlen(emp_id_list)>
						<cfset emp_id_list=listsort(emp_id_list,"numeric","ASC",",")>
						<cfquery name="GET_EMP" datasource="#DSN#">
							SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#emp_id_list#) ORDER BY EMPLOYEE_ID
						</cfquery>
					</cfif>
					<cfif listlen(process_list)>
						<cfset process_list=listsort(process_list,"numeric","ASC",",")>
						<cfquery name="GET_PROCESS_TYPE" datasource="#DSN#">
							SELECT STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#process_list#)
						</cfquery>
					</cfif>
					<cfif Len(attributes.listing_type) and attributes.listing_type eq 1><!--- Satir Bazinda --->
						<cfif Listlen(supplier_list)>
							<cfset supplier_list = ListSort(supplier_list,"numeric","ASC",",")>
							<cfquery name="get_supplier_name" datasource="#dsn#">
								SELECT COMPANY_ID,NICKNAME FROM COMPANY WHERE COMPANY_ID IN (#supplier_list#) ORDER BY COMPANY_ID
							</cfquery>
							<cfset supplier_list = ListSort(ListDeleteDuplicates(ValueList(get_supplier_name.company_id,',')),'numeric','asc',',')>
						</cfif>
						<cfif Listlen(product_list)>
							<cfset product_list = ListSort(product_list,"numeric","ASC",",")>
							<cfquery name="get_product_name" datasource="#dsn1#">
								SELECT PRODUCT_ID,PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID IN (#product_list#) ORDER BY PRODUCT_ID
							</cfquery>
							<cfset product_list = ListSort(ListDeleteDuplicates(ValueList(get_product_name.product_id,',')),'numeric','asc',',')>
						</cfif>
						<cfif Listlen(category_list)>
							<cfset category_list = ListSort(category_list,"numeric","ASC",",")>
							<cfquery name="get_category_name" datasource="#dsn1#">
								SELECT PRODUCT_CATID,PRODUCT_CAT FROM PRODUCT_CAT WHERE PRODUCT_CATID IN (#category_list#) ORDER BY PRODUCT_CATID
							</cfquery>
							<cfset category_list = ListSort(ListDeleteDuplicates(ValueList(get_category_name.product_catid,',')),'numeric','asc',',')>
						</cfif>
						<cfif Listlen(brand_list)>
							<cfset brand_list = ListSort(brand_list,"numeric","ASC",",")>
							<cfquery name="get_brand_name" datasource="#dsn1#">
								SELECT BRAND_ID, BRAND_NAME FROM PRODUCT_BRANDS WHERE BRAND_ID IN (#brand_list#) ORDER BY BRAND_ID
							</cfquery>
							<cfset brand_list = ListSort(ListDeleteDuplicates(ValueList(get_brand_name.brand_id,',')),'numeric','asc',',')>
						</cfif>
					</cfif>
					<cfif listlen(company_list)>
						<cfset company_list = ListSort(company_list,"numeric","ASC",",")>
						<cfquery name="get_member_name" datasource="#dsn#">
							SELECT COMPANY_ID MEMBER_ID, NICKNAME NICKNAME FROM COMPANY WHERE COMPANY_ID IN (#company_list#) ORDER BY COMPANY_ID
						</cfquery>
						<cfset company_list = ListSort(ListDeleteDuplicates(ValueList(get_member_name.member_id,',')),'numeric','asc',',')>
					</cfif>
					<cfif listlen(consumer_list)>
						<cfset consumer_list = ListSort(consumer_list,"numeric","ASC",",")>
						<cfquery name="get_member_name" datasource="#dsn#">
							SELECT CONSUMER_ID MEMBER_ID, CONSUMER_NAME + ' '  + CONSUMER_SURNAME NICKNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_list#) ORDER BY CONSUMER_ID
						</cfquery>
						<cfset consumer_list = ListSort(ListDeleteDuplicates(ValueList(get_member_name.member_id,',')),'numeric','asc',',')>
					</cfif>
					<cfoutput query="Get_Sales_Quota" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 1)>
								<td align="center" id="order_row#currentrow#" class="color-row" onClick="gizle_goster(sales_quota_detail#currentrow#);connectAjax('#currentrow#','#SALES_QUOTA_ROW_ID#');gizle_goster(show_detail#currentrow#);gizle_goster(hidden_detail#currentrow#);">
									<img id="show_detail#currentrow#" src="/images/listele.gif" title="<cf_get_lang dictionary_id ='58596.Göster'>">
									<img id="hidden_detail#currentrow#" src="/images/listele_down.gif" style="display:none;" title="<cf_get_lang dictionary_id ='58628.Gizle'>">
								</td>
							</cfif>
							<td nowrap>#PAPER_NO#</td>
							<td>#dateformat(PLAN_DATE,dateformat_style)#</td>
							<td>#dateformat(finish_date,dateformat_style)#</td>
							<td>#get_process_type.stage[listfind(process_list,process_stage,',')]#</td>
							<td><cfif len(company_id)>
									#get_member_name.nickname[listfind(company_list,company_id,',')]#
								<cfelseif len(consumer_id)>
									#get_member_name.nickname[listfind(consumer_list,consumer_id,',')]#
								</cfif>
							</td>
							<cfif Len(attributes.listing_type) and attributes.listing_type eq 1><!--- Satir Bazinda --->
								<td><cfif Len(supplier_id)>#get_supplier_name.nickname[listfind(supplier_list,supplier_id,',')]#</cfif></td>
								<td><cfif Len(brand_id)>#get_brand_name.brand_name[listfind(brand_list,brand_id,',')]#</cfif></td>
								<td><cfif Len(category_id)>
										#get_category_name.product_cat[listfind(category_list,category_id,',')]#
									<cfelseif Len(multi_category_id)>
										<cfloop list="#multi_category_id#" index="m">
											#get_category_name.product_cat[listfind(category_list,m,',')]#<cfif ListLast(multi_category_id) neq m>,<br /></cfif>
										</cfloop>
									</cfif>
								</td>
								<td>#product_name#</td>
								<td>
									<cfif period_type eq 0>
										<cf_get_lang dictionary_id ='58724.Ay'>
									<cfelseif period_type eq 1>
										<cf_get_lang dictionary_id ='58879.3 Ay'>
									<cfelse>
										<cf_get_lang dictionary_id ='58455.Yıl'>
									</cfif>
								</td>
								<td class="text-right">#quantity#</td>
								<td class="text-right">#row_premium_percent#</td>
								<td class="text-right">#TLFormat(row_premium_total)#</td>
								<td class="text-right">#row_extra_stock#</td>
								<td class="text-right">#row_profit_percent#</td>
								<td class="text-right">#TLFormat(row_profit_total)#</td>
								<td class="text-right">#TLFormat(row_total)#</td>
							<cfelse>
								<td>#DETAIL#</td>
								<td class="text-right">#TLformat(TOTAL_AMOUNT)#&nbsp;&nbsp;#session.ep.money#</td>
								<td class="text-right">#TLformat(OTHER_TOTAL_AMOUNT)#&nbsp;&nbsp;#OTHER_MONEY#</td>
							</cfif>
							<td><cfif len(planner_emp_id)>#get_emp.EMPLOYEE_NAME[listfind(emp_id_list,planner_emp_id,',')]# #get_emp.EMPLOYEE_SURNAME[listfind(emp_id_list,planner_emp_id,',')]#</cfif></td>
							<!-- sil -->
							<td align="center">
							<a href="#request.self#?fuseaction=salesplan.list_sales_quotas&event=upd&q_id=#SALES_QUOTA_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
							</td>
							<!-- sil -->
							<td class="text-center"><input type="checkbox" name="print_quota_id" id="print_quota_id"  value="#SALES_QUOTA_ID#"></td>
						</tr>
						<tr id="sales_quota_detail#currentrow#" style="display:none" class="nohover">
							<td colspan="25">
								<div align="left" id="DISPLAY_QUOTA_DETAIL#currentrow#"></div>
							</td>
							
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="<cfoutput>#cols#</cfoutput>">
						<cfif form_varmi eq 0><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>

		<cfset url_str = "salesplan.list_sales_quotas">
			<cfif len(attributes.is_form_submitted)>
				<cfset url_str = "#url_str#&is_form_submitted=#attributes.is_form_submitted#">
			</cfif>
			<cfif len(attributes.keyword)>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>
			<cfif len(attributes.process_stage_type)>
				<cfset url_str = "#url_str#&process_stage_type=#attributes.process_stage_type#">
			</cfif>
			<cfif len(attributes.ch_company_id) and len(attributes.ch_company)>
				<cfset url_str = "#url_str#&ch_company_id=#attributes.ch_company_id#&ch_company=#attributes.ch_company#">
			</cfif>
			<cfif len(attributes.ch_consumer_id) and len(attributes.ch_company)>
				<cfset url_str = "#url_str#&ch_consumer_id=#attributes.ch_consumer_id#&ch_company=#attributes.ch_company#">
			</cfif>
			<cfif len(attributes.employee_id) and len(attributes.employee_name)>
				<cfset url_str = "#url_str#&employee_id=#attributes.employee_id#&employee_name=#attributes.employee_name#">
			</cfif>
			<cfif len(attributes.team_id) and len(attributes.team_name)>
				<cfset url_str = "#url_str#&team_id=#attributes.team_id#&team_name=#attributes.team_name#">
			</cfif>
			<cfif len(attributes.is_active)>
				<cfset url_str = "#url_str#&is_active=#attributes.is_active#">
			</cfif>
			<cfif len(attributes.quota_type)>
				<cfset url_str = "#url_str#&quota_type=#attributes.quota_type#">
			</cfif>
			<cfif len(attributes.period_type)>
				<cfset url_str = "#url_str#&period_type=#attributes.period_type#">
			</cfif>
			<cfif len(attributes.result_info)>
				<cfset url_str = "#url_str#&result_info=#attributes.result_info#">
			</cfif>
			<cfif len(attributes.listing_type)>
				<cfset url_str = "#url_str#&listing_type=#attributes.listing_type#">
			</cfif>
			<cfif isDate(attributes.start_date)>
				<cfset url_str = "#url_str#&start_date=#DateFormat(attributes.start_date,dateformat_style)#">
			</cfif>
			<cfif isDate(attributes.finish_date)>
				<cfset url_str = "#url_str#&finish_date=#DateFormat(attributes.finish_date,dateformat_style)#">
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
	function kontrol()
	{
		if ( (document.list_quota.start_date.value.length>0) && (document.list_quota.finish_date.value.length>0) && !date_check (document.getElementById('start_date'),document.getElementById('finish_date'),"<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyün Olamaz'>!"))
			return false;
		else
			return true;
	}
	function connectAjax(crtrow,q_id)
	{
		var bb = '<cfoutput>#request.self#?fuseaction=salesplan.emptypopup_dsp_detail_quota_result&quota_row_id='+q_id+'&premium_stock_id=#premium_stock_id#</cfoutput>';
		AjaxPageLoad(bb,'DISPLAY_QUOTA_DETAIL'+crtrow,1);
	}
	document.list_quota.keyword.focus();
</script>
