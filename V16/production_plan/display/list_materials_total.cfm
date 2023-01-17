<cfsetting showdebugoutput="no">
<cfparam name="deep_level_max" default="1">
<cf_xml_page_edit default_value="1" fuseact='prod.list_materials_total'>
<cfset stock_id_list_info1 = ''>
<cfset stock_id_list_info2 = ''>
<cfset department_id_list = ''>
<cfset location_id_list = ''>
<cfif isdefined("attributes.row_demand_all") and len(attributes.row_demand_all)>
	<cfif attributes.row_demand_all neq 0>
		<cfset gun_ = now()>
		<cfset wrk_id = 'WRK' & dateformat(now(),'YYYYMMDD')& timeformat(now(),'HHmmssL') & '_#session.ep.userid#_' &round(rand()*100)>
		<cfset row_demand_array = listtoarray(attributes.row_demand_all)>
        <cfquery name="del_olds" datasource="#dsn#">
			DELETE FROM TEMP_BLOCK_VALUES WHERE RECORD_DATE < #createodbcdatetime(createdate(year(gun_),month(gun_),day(gun_)))# OR RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
		</cfquery>
		<cfloop from="1" to="#arraylen(row_demand_array)#" index="ccc">
			<cfquery name="add_" datasource="#dsn#">
				INSERT INTO 
					TEMP_BLOCK_VALUES
				(
					WRK_ROW_ID,
					TEMP_COLUMN,
					TEMP_VALUE,
					RECORD_DATE,
					RECORD_EMP
				)
				VALUES
				(
					'#wrk_id#',
					'P_ORDER_ID_FROM_ROW_DEMAND',
					'#row_demand_array[ccc]#',
					#now()#,
					#session.ep.userid#
				)
			</cfquery>
		</cfloop>
	</cfif>
	<cfquery name="get_demand_min_max_date" datasource="#dsn3#">
		SELECT 
			MIN(START_DATE) AS START_DATE,
			MAX(FINISH_DATE) AS FINISH_DATE 
		FROM 
			PRODUCTION_ORDERS
		WHERE 
			P_ORDER_ID IN (SELECT TEMP_VALUE FROM #dsn_alias#.TEMP_BLOCK_VALUES WHERE TEMP_COLUMN = 'P_ORDER_ID_FROM_ROW_DEMAND' AND RECORD_EMP = #session.ep.userid#)
	</cfquery>
	<cfquery name="get_demand_no" datasource="#dsn3#">
		SELECT 
			P_ORDER_NO
		FROM 
			PRODUCTION_ORDERS
		WHERE 
			P_ORDER_ID IN (SELECT TEMP_VALUE FROM #dsn_alias#.TEMP_BLOCK_VALUES WHERE TEMP_COLUMN = 'P_ORDER_ID_FROM_ROW_DEMAND' AND RECORD_EMP = #session.ep.userid#)
	</cfquery>
	<cfset attributes.production_order_no = valuelist(get_demand_no.p_order_no)>
	<cfset attributes.start_date = DateFormat(date_add("d",-1,get_demand_min_max_date.START_DATE),dateformat_style)>
	<cfset attributes.finish_date = DateFormat(date_add("d",1,get_demand_min_max_date.FINISH_DATE),dateformat_style)>
<cfelseif isdefined("attributes.production_order_no") and len(attributes.production_order_no)>
	 <cfset production_order_no_list=''>
	 <cfloop list="#attributes.production_order_no#" index="kk">
		 <cfif len(kk) and not listfind(production_order_no_list,kk)>
			 <cfset production_order_no_list=listappend(production_order_no_list,"'#kk#'")>
		 </cfif>
	 </cfloop>
	<cfquery name="get_demand_min_max_date" datasource="#dsn3#">
		SELECT 
			MIN(START_DATE) AS START_DATE,
			MAX(FINISH_DATE) AS FINISH_DATE 
		FROM 
			PRODUCTION_ORDERS
		WHERE 
			P_ORDER_NO IN (#PreserveSingleQuotes(production_order_no_list)#)
	</cfquery>
	<cfif len(get_demand_min_max_date.START_DATE)>
		<cfset attributes.start_date = DateFormat(date_add("d",-1,get_demand_min_max_date.START_DATE),dateformat_style)>
	</cfif>
	<cfif len(get_demand_min_max_date.FINISH_DATE)>
		<cfset attributes.finish_date = DateFormat(date_add("d",1,get_demand_min_max_date.FINISH_DATE),dateformat_style)>
	</cfif>
</cfif>
<cfparam name="attributes.production_order_no" default="">
<cfparam name="attributes.station_id" default="">
<cfparam name="attributes.demand_no" default="">
<cfparam name="attributes.is_bring_needed" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.product_code" default="">
<cfparam name="attributes.COMPANY" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.PRODUCT_NAME" default="">
<cfparam name="attributes.PRODUCT_ID" default="">
<cfparam name="attributes.price_cat" default="">
<cfparam name="attributes.product_code" default="">
<cfparam name="attributes.sort_type" default="">
<cfparam name="attributes.list_type" default="">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelse>
	<cfset attributes.start_date = createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#')>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
  <cf_date tarih = "attributes.finish_date">
<cfelse>
  <cfset attributes.finish_date = date_add('d',1,attributes.start_date)>
</cfif>
<cfquery name="GET_DEPARTMENT" datasource="#DSN#">
	SELECT
		DEPARTMENT_ID,
		DEPARTMENT_HEAD
	FROM
		BRANCH B,
		DEPARTMENT D 
	WHERE
		B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		B.BRANCH_ID = D.BRANCH_ID AND
		D.IS_STORE <> 2 AND
		D.DEPARTMENT_STATUS = 1 AND
		B.BRANCH_ID IN(SELECT BRANCH_ID FROM  EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
</cfquery>
<cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
    SELECT DEPARTMENT_ID,LOCATION_ID,COMMENT FROM STOCKS_LOCATION <cfif x_is_dept_location eq 0>WHERE STATUS = 1</cfif>
</cfquery>						
<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
    SELECT 
        PRODUCT_CAT.PRODUCT_CATID, 
        PRODUCT_CAT.HIERARCHY,
        PRODUCT_CAT.PRODUCT_CAT
    FROM 
        PRODUCT_CAT,
        PRODUCT_CAT_OUR_COMPANY PCO
    WHERE 
        PRODUCT_CAT.PRODUCT_CATID = PCO.PRODUCT_CATID AND
        PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
    ORDER BY 
        HIERARCHY
</cfquery>
<cfquery name="GET_W" datasource="#dsn#">
    SELECT 
        STATION_ID,
        STATION_NAME,
        '' UP_STATION
    FROM 
        #dsn3_alias#.WORKSTATIONS 
    WHERE 
        ACTIVE = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
        DEPARTMENT IN (SELECT DEPARTMENT.DEPARTMENT_ID FROM DEPARTMENT,EMPLOYEE_POSITION_BRANCHES WHERE DEPARTMENT.BRANCH_ID = EMPLOYEE_POSITION_BRANCHES.BRANCH_ID AND EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) 
    ORDER BY STATION_NAME ASC
</cfquery>
<cfif not len(attributes.price_cat)><cfset attributes.price_cat = -1></cfif>
<cfif isdefined("attributes.is_submitted")>
	<cfif isdefined("attributes.list_type") and len(attributes.list_type) and attributes.list_type eq 2>
		<cfinclude template="../query/get_order_detail_for_material_from_file.cfm">
	<cfelse>
		<cfinclude template="../query/get_order_detail_for_material.cfm">
	</cfif>
	<cfparam name="attributes.totalrecords" default="#get_metarials.recordcount#">
<cfelse>
	<cfset get_metarials.recordcount = 0>
	<cfparam name="attributes.totalrecords" default="0">	
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-8">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</cfif>
<cfoutput query="get_department">
	<cfset 'department_name_#DEPARTMENT_ID#'='#DEPARTMENT_HEAD#'>
</cfoutput>
<cfoutput query="GET_ALL_LOCATION">
	<cfset 'location_name_#DEPARTMENT_ID#_#LOCATION_ID#' = COMMENT>
</cfoutput>
<cfif x_is_alternative_stock eq 1>
	<cfset colspan_ =ListLen(attributes.department_id,',')*4+19>
<cfelse>
	<cfset colspan_ =ListLen(attributes.department_id,',')*3+19>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
		<cf_box>
			<cfform name="list_meterials" method="post" action="#request.self#?fuseaction=prod.list_materials_total" enctype="multipart/form-data">
				<input type="hidden" name="is_submitted" id="is_submitted" value="1">
				<input type="hidden" name="is_excel" id="is_excel" value="0">
				<cf_box_search>
					<div class="form-group" id="material_file" style="margin-left:580px;position:absolute;display:none;"></div>
					<cfif isdefined("attributes.row_demand_all") and len(attributes.row_demand_all)>
						<div class="form-group">
							<label><cf_get_lang dictionary_id='36596.Tüm Gelen İhtiyaçlar'></label> 
							<input type="checkbox" value="0" name="row_demand_all" id="row_demand_all" checked>
						</div>
					</cfif>
					<div class="form-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='48035.Talep No'></cfsavecontent>
						<cfinput type="text" name="demand_no" id="demand_no" value="#attributes.demand_no#" maxlength="250" style="width:180px;" placeholder="#message#">
					</div>
					<div class="form-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='36346.Üretim Emir No'></cfsavecontent>
						<cfinput type="text" name="production_order_no" id="production_order_no" value="#attributes.production_order_no#" maxlength="250" style="width:180px;" placeholder="#message#">
					</div>
					<div class="form-group">
						<div class="input-group">
							<cfinput type="text" name="start_date" id="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" maxlength="10"  required="yes"  style="width:65px;">
							<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
						</div>
					</div>
					<div class="form-group">
						<div class="input-group">
							<cfinput type="text" name="finish_date" id="finish_date" value="#dateformat(attributes.finish_date, dateformat_style)#" validate="#validate_style#" maxlength="10" required="yes" style="width:65px;">
							<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
						</div>
					</div>
					<div class="form-group small">
						<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" maxlength="3" onKeyUp="isNumber(this)" validate="integer" range="1,250" required="yes" style="width:25px;">
					</div>
					<div class="form-group">
						<cf_wrk_search_button button_type="4" search_function='kontrol()'>
					</div>
					<div class="form-group">
						<cfif isdefined("x_is_import_file") and x_is_import_file eq 1>
							<a class="ui-btn ui-btn-gray" href="javascript://" onclick="open_file();"><i class="fa fa-file" title="CSV İmport"></i></a>
							<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
						</cfif>
					</div>
				</cf_box_search>
				<cf_box_search_detail>
					<cfset is_purchase = 1>
					<cfinclude template="../query/get_price_cat.cfm">
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-list_type">
							<label class="col col-12"><cf_get_lang dictionary_id ='36591.Listeleme'></label>
							<div class="col col-12">
							<select name="list_type" id="list_type">
								<option value="1" <cfif attributes.list_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='36593.Üretim Emirlerinden'>(<cf_get_lang dictionary_id ='57647.Spec'>)</option>
								<option value="3" <cfif attributes.list_type eq 3>selected</cfif>><cf_get_lang dictionary_id ='36593.Üretim Emirlerinden'>(<cf_get_lang dictionary_id ='36365.Ürün Ağacı'>)</option>
								<option value="4" <cfif attributes.list_type eq 4>selected</cfif>><cf_get_lang dictionary_id ='36593.Üretim Emirlerinden'>(<cf_get_lang dictionary_id ='36477.Alternatifli'>)</option>
								<cfif isdefined("x_is_import_file") and x_is_import_file eq 1>
									<option value="2" <cfif attributes.list_type eq 2>selected</cfif>><cf_get_lang dictionary_id ='36594.Dosyadan'></option>
								</cfif>
							</select>
							</div>
						</div>
						<cfif isdefined("x_is_price") and x_is_price eq 1>
						<div class="form-group" id="item-price_cat">
							<label class="col col-12"><cf_get_lang dictionary_id='58722.Standart Alış'></label>
							<div class="col col-12">
								<select name="price_cat" id="price_cat" style="width:130px;">
									<option value="-1" <cfif (-1 is attributes.price_cat)> selected</cfif>><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_price_cat"> 
										<option value="#price_catid#" <cfif (price_catid is attributes.price_cat)> selected</cfif>>#price_cat#</option>
									</cfoutput>
								</select>
							</div>
						</div>
						</cfif>
						<div class="form-group" id="item-sort_type">
							<label class="col col-12"><cf_get_lang dictionary_id='57982.Tür'></label>
							<div class="col col-12">
								<select name="sort_type" id="sort_type" <cfif attributes.sort_type eq 1></cfif>style="width:130px;">
									<option value=""><cf_get_lang dictionary_id='58081.Hepsi'></option>
									<option value="1" <cfif attributes.sort_type eq 1>selected</cfif>><cf_get_lang dictionary_id='36608.Üretilen'></option>
									<option value="0" <cfif attributes.sort_type eq 0>selected</cfif>><cf_get_lang dictionary_id='36598.Üretilmeyen'></option>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-station_id">
							<label class="col col-12"><cf_get_lang dictionary_id='58834.İstasyon'></label>
							<div class="col col-12">
								<select name="station_id" id="station_id" style="width:170px;">
								<option value=""><cf_get_lang dictionary_id='58081.Hepsi'></option>
								<cfoutput query="get_w">
									<option value="#station_id#"<cfif attributes.station_id eq station_id>selected</cfif>><cfif len(up_station)>&nbsp;&nbsp;</cfif>#station_name#</option>
								</cfoutput>
							</select>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-pos_code">
							<label class="col col-12"><cf_get_lang dictionary_id='57544.Sorumlu'></label>
							<div class="col col-12">
								<div class="input-group">
									<input type="hidden" name="pos_code" id="pos_code" value="<cfif isdefined("attributes.pos_code")><cfoutput>#attributes.pos_code#</cfoutput></cfif>">
									<input type="text" name="pos_manager" id="pos_manager" value="<cfif isdefined("attributes.pos_code") and len(attributes.pos_code) and isdefined('attributes.pos_manager')><cfoutput>#attributes.pos_manager#</cfoutput></cfif>"  maxlength="50" style="width:120px;" onFocus="AutoComplete_Create('pos_manager','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','PARTNER_CODE','pos_code','','3','135');" autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=list_meterials.pos_code&field_name=list_meterials.pos_manager&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.list_meterials.pos_manager.value),'list');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-company_id">
							<label class="col col-12"><cf_get_lang dictionary_id='29533.Tedarikçi'></label>
							<div class="col col-12">
								<div class="input-group">
									<input type="hidden" name="company_id" id="company_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.company_id#</cfoutput>"</cfif>>
									<input type="text" name="company" id="company"  value="<cfif len(attributes.company) ><cfoutput>#attributes.company#</cfoutput></cfif>"  style="width:120px;" onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','company_id','','3','250');" autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=list_meterials.company&field_comp_id=list_meterials.company_id&select_list=2&keyword='+encodeURIComponent(document.list_meterials.company.value),'list');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-product_id">
							<label class="col col-12"><cf_get_lang dictionary_id ='57657.Ürün'></label>
							<div class="col col-12">
								<div class="input-group">
									<input type="hidden" name="product_id" id="product_id" <cfif len(attributes.product_name)>value="<cfoutput>#attributes.product_id#</cfoutput>"</cfif>>
									<input type="text" name="product_name" id="product_name"  style="width:120px;"  value="<cfif len(attributes.product_id) and len(attributes.product_name)><cfoutput>#attributes.product_name#</cfoutput></cfif>" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','product_id','list_meterials','3','200');" autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=list_meterials.product_id&field_name=list_meterials.product_name&keyword='+encodeURIComponent(document.list_meterials.product_name.value),'list');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-need">
							<label><cf_get_lang dictionary_id="54849.İhtiyaç Olanları Getir"> <input type="checkbox" name="is_bring_needed" id="is_bring_needed" value="1" <cfif attributes.is_bring_needed eq 1>checked</cfif>></label>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
						<div class="form-group" id="item-department_id">
							<label class="col col-12"><cf_get_lang dictionary_id='58763.Depo'></label>
							<div class="col col-12">
								<cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>
									<select name="department_id" multiple style="width:170px; height:105px;">
										<cfoutput query="get_department">
											<optgroup label="#department_head#">
												<cfquery name="GET_LOCATION" dbtype="query">
													SELECT * FROM GET_ALL_LOCATION WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_department.department_id[currentrow]#">
												</cfquery>
												<cfif get_location.recordcount>
													<cfloop from="1" to="#get_location.recordcount#" index="s">
														<option value="#department_id#-#get_location.location_id[s]#" <cfif listfind(attributes.department_id,'#department_id#-#get_location.location_id[s]#',',')>selected</cfif>>&nbsp;&nbsp;#get_location.comment[s]#</option>
													</cfloop>
												</cfif>
											</optgroup>	  
										</cfoutput>
									</select>
								<cfelse>	
									<select name="department_id" id="department_id" multiple style="width:170px; height:105px;">
										<cfoutput query="get_department">
											<option value="#department_id#"<cfif ListFind(attributes.department_id,DEPARTMENT_ID,',')>selected<cfset 'department_name_#DEPARTMENT_ID#'='#DEPARTMENT_HEAD#'></cfif>>#department_head#</option>
										</cfoutput>
									</select>
								</cfif>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
						<div class="form-group" id="item-product_code">
							<label class="col col-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
							<div class="col col-12">
								<select name="product_code" id="product_code" multiple style="width:170px; height:105px;">
									<cfoutput query="get_product_cat">
										<cfif listlen(HIERARCHY,".") lte 3>
											<option value="#HIERARCHY#" <cfif listfind(attributes.product_code,HIERARCHY)>selected</cfif>>#HIERARCHY#-#product_cat#</option>
										</cfif>
									</cfoutput>
								</select>
							</div>
						</div>
					</div>
				</cf_box_search_detail>
			</cfform>
		</cf_box>
	</cfif>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='36563.Üretim Malzeme İhtiyaçları'></cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1">
		<cf_basket>
			<cf_grid_list>
				<thead>
					<cfif get_metarials.recordcount>
						<cfif ListLen(attributes.DEPARTMENT_ID,',')>
							<cfloop list="#attributes.DEPARTMENT_ID#" index="_depID_" delimiters=",">
								<cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1 and _depID_ contains '-'>
									<cfset department_id_list = listappend(department_id_list,listfirst(_depID_,'-'),',')>
									<cfset department_id_list_ = listdeleteduplicates(department_id_list)>
									<cfset location_id_list = listdeleteduplicates(listappend(location_id_list,_depID_,','))>
								<cfelse>
									<cfset department_id_list = listappend(department_id_list,_depID_,',')>
									<cfset department_id_list_ = listdeleteduplicates(department_id_list)>
								</cfif>
							</cfloop>
						</cfif>
						<tr>
							<cfif isdefined("attributes.list_type") and attributes.list_type eq 4>
								<th colspan="5"></th>
							<cfelse>
								<th colspan="6"></th>
							</cfif>
							<cfset var_class = 'txtbold'>
							<cfset cols_ = 3>
							<cfif x_is_alternative_stock eq 1>
								<cfset cols_ = cols_ + 1>
							</cfif>
							<cfloop list="#department_id_list#" index="_depID_" delimiters=",">
								<cfif isdefined('colspan_#_depID_#')>
									<cfset 'colspan_#_depID_#' = evaluate('colspan_#_depID_#') + cols_>
								<cfelse>
									<cfset 'colspan_#_depID_#' = cols_>
								</cfif>
							</cfloop>
							<cfif ListLen(attributes.DEPARTMENT_ID,',')>
								<cfloop list="#department_id_list_#" index="_depID_" delimiters=",">
									<cfif var_class is 'form-title'><cfset var_class = 'txtbold'><cfelse><cfset var_class = 'form-title'></cfif>
									<cfoutput>
										<th style="text-align:center" class="#var_class#" colspan="#evaluate('colspan_#_depID_#')#">#Evaluate('department_name_#_depID_#')#</th>
									</cfoutput>	
								</cfloop>
							<cfelse>
								<cfif var_class is 'form-title'><cfset var_class = 'txtbold'><cfelse><cfset var_class = 'form-title'></cfif>
								<th class="<cfoutput>#var_class#</cfoutput>" colspan="#cols_#"></th>
							</cfif>
							<cfif isdefined("attributes.list_type") and attributes.list_type eq 4>
								<th colspan="9"></th>
							<cfelse>
								<th colspan="<cfoutput>#colspan_#</cfoutput>"></th>
							</cfif>
						</tr>
						<cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1 and ListLen(attributes.DEPARTMENT_ID,',') and attributes.DEPARTMENT_ID contains '-'>
							<tr>
								<cfif isdefined("attributes.list_type") and attributes.list_type eq 4>
									<th colspan="5"></th>
								<cfelse>
									<th colspan="6"></th>
								</cfif>
								<cfset var_class = 'txtbold'>
								<cfif ListLen(attributes.DEPARTMENT_ID,',')>
									<cfloop list="#location_id_list#" index="_locID_" delimiters=",">
										<cfif var_class is 'form-title'><cfset var_class = 'txtbold'><cfelse><cfset var_class = 'form-title'></cfif>
										<cfoutput>
											<th style="text-align:center" class="#var_class#" colspan="#cols_#">
													#Evaluate('location_name_#replace(_locID_,'-','_','')#')#
											</th>
										</cfoutput>
									</cfloop>
								<cfelse>
									<cfif var_class is 'form-title'><cfset var_class = 'txtbold'><cfelse><cfset var_class = 'form-title'></cfif>
									<th class="<cfoutput>#var_class#</cfoutput>" colspan="#cols_#"></th>
								</cfif>
								<cfif isdefined("attributes.list_type") and attributes.list_type eq 4>
									<th colspan="9"></th>
								<cfelse>
									<th colspan="<cfoutput>#colspan_#</cfoutput>"></th>
								</cfif>
							</tr>
						</cfif>
					</cfif>
					<tr>
						<cfif isdefined("attributes.list_type") and attributes.list_type eq 4><!-- sil --><th></th><!-- sil --></cfif>
						<th width="30"><cf_get_lang dictionary_id ='58577.Sıra'></th>
						<th><cf_get_lang dictionary_id ='57518.Stok Kodu'></th>
						<th><cf_get_lang dictionary_id ='57657.Ürün'></th>
						<th><cf_get_lang dictionary_id ="54850.Spec Id"></th>
						<th><cf_get_lang dictionary_id ="54851.Spec Adı"></th>
						<th><cf_get_lang dictionary_id='36437.İhtiyaç'></th>
						<cfset var_class = 'txtbold'>
						<cfif ListLen(attributes.DEPARTMENT_ID,',')>
							<cfloop list="#attributes.DEPARTMENT_ID#" index="_depID_" delimiters=",">
								<cfif var_class is 'form-title'><cfset var_class = 'txtbold'><cfelse><cfset var_class = 'form-title'></cfif> 
								<cfoutput>
									<th class="#var_class#" style="text-align:right;" title="<cf_get_lang dictionary_id ='58120.Gerçek Stok'>" ><cf_get_lang dictionary_id="54858.G"></th>
									<th class="#var_class#" style="text-align:right;" title="<cf_get_lang dictionary_id ='36600.Aktif Stok=Gerçek Stok - Üretim Emirleri Rezerve'> (<cf_get_lang dictionary_id='36384.Kendi Dışındaki Üretim Emirleri'>)" ><cf_get_lang dictionary_id="29684.A"></th>
									<cfif x_is_alternative_stock eq 1>
										<th class="#var_class#" style="text-align:right;" title="Alternatif Ürünlerin Satılabilir Stok Toplamı"><cf_get_lang dictionary_id="54866.A.S."></th>
									</cfif>
									<th class="#var_class#" style="text-align:right;" title="<cf_get_lang dictionary_id ='36601.Min Stok'>"><cf_get_lang dictionary_id="42499.M"></th>
								</cfoutput>
							</cfloop>
						<cfelse>
							<cfif var_class is 'form-title'><cfset var_class = 'txtbold'><cfelse><cfset var_class = 'form-title'></cfif> 
							<cfoutput>
								<th class="#var_class#" style="text-align:right;" title="<cf_get_lang dictionary_id ='58120.Gerçek Stok'>" ><cf_get_lang dictionary_id="34287.G"></th>
								<th class="#var_class#" style="text-align:right;" title="<cf_get_lang dictionary_id ='36600.Aktif Stok=Gerçek Stok - Üretim Emirleri Rezerve'>  (<cf_get_lang dictionary_id='36384.Kendi Dışındaki Üretim Emirleri'>)" ><cf_get_lang dictionary_id="29684.A"></th>
								<cfif x_is_alternative_stock eq 1>
									<th class="#var_class#" style="text-align:right;" title="Alternatif Ürünlerin Satılabilir Stok Toplamı"><cf_get_lang dictionary_id="54866.A.S."></th>
								</cfif>
								<th class="#var_class#" style="text-align:right;" title="<cf_get_lang dictionary_id ='36601.Min Stok'>"><cf_get_lang dictionary_id="34285.M"></th>
							</cfoutput>
						</cfif>
						<cfif isdefined("x_is_price") and x_is_price eq 1><th style="text-align:right;"><cf_get_lang dictionary_id='58084.Fiyat'></th></cfif>
						<th title="<cf_get_lang dictionary_id ='36603.Satın Alma Siparişleri Rezerve'>" style="text-align:right;"><cf_get_lang dictionary_id ='36602.Sip Rez'></th>
						<th title="Üretim Emirleri Beklenen" style="text-align:right;"><cf_get_lang dictionary_id="34284.Ü.E."> <cf_get_lang dictionary_id="58119.Beklenen"></th>
						<th title="<cf_get_lang dictionary_id ='36607.Toplam İhtiyaç'>" style="text-align:right;"><cf_get_lang dictionary_id ='58444.Kalan'></th>
						<th title="<cf_get_lang dictionary_id ='57636.Birim'>"><cf_get_lang dictionary_id ='57636.Birim'></th>
						<th><cf_get_lang dictionary_id ='57635.Miktar'></th>
						<cfif isdefined("x_is_price") and x_is_price eq 1>
							<th><cf_get_lang dictionary_id ='33932.Toplam Fiyat'></th>
							<th><cf_get_lang dictionary_id ='58864.Para Br'></th>
						</cfif>
						<!-- sil -->
							<th style="text-align:center;"><cfif not(isdefined('attributes.is_excel') and attributes.is_excel eq 1) and not (isdefined("attributes.list_type") and attributes.list_type eq 4) and (isdefined("attributes.is_submitted") eq 1)><input type="checkbox" name="all_conv_product" id="all_conv_product" onClick="javascript: wrk_select_all2('all_conv_product','conversion_product',<cfoutput>#get_metarials.recordcount#,#attributes.startrow#</cfoutput>);"></cfif></th>
						<!-- sil -->
					</tr>
				</thead>
				<tbody>
				<cfif isdefined("attributes.is_submitted")>
						<cfquery name="GET_MONEY" datasource="#DSN2#">
							SELECT * FROM SETUP_MONEY
						</cfquery>
					<cfif get_metarials.recordcount>
							<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
								<cfset attributes.startrow=1>
								<cfset attributes.maxrows=get_metarials.recordcount>
							</cfif>
							<cfset stock_id_list = ''>
							<cfset spec_main_id_list = ''>
							<cfoutput query="get_metarials" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
								<cfset stock_id_list = ListAppend(stock_id_list,STOCK_ID,',')>
								<cfset spec_main_id_list = ListAppend(spec_main_id_list,SPECT_MAIN_ID,',')>
							</cfoutput>
							<cfif ListLen(attributes.DEPARTMENT_ID,',')><!--- DEPO SEÇİLİ İSE --->
								<cfset stock_id_list = listdeleteduplicates(stock_id_list)>
								<cfset spec_main_id_list = listdeleteduplicates(spec_main_id_list)>
								<cfquery name="GET_STOCKS_ALL" datasource="#DSN2#">
									SELECT 
										SUM(SR.STOCK_IN-SR.STOCK_OUT) PRODUCT_STOCK,
										SR.STOCK_ID,
										SR.STORE AS DEPARTMENT_ID
										<cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>,SR.STORE_LOCATION AS LOCATION_ID</cfif>
									FROM 
										STOCKS_ROW SR
									WHERE
										<cfif not((isdefined('attributes.is_excel') and attributes.is_excel eq 1) and get_metarials.recordcount gt 5000)>
											SR.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#) AND 
										</cfif>
										SR.STORE_LOCATION NOT IN (SELECT SL.LOCATION_ID FROM #dsn_alias#.STOCKS_LOCATION SL WHERE SL.IS_SCRAP = 1 AND SL.DEPARTMENT_ID =SR.STORE) AND
										<cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>
										( <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
												(SR.STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND SR.STORE_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
												<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
											</cfloop>  )
										<cfelse>
											SR.STORE IN (#attributes.DEPARTMENT_ID#)
										</cfif>
									GROUP BY
										SR.STOCK_ID,
										SR.STORE
										<cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>,SR.STORE_LOCATION</cfif>
									<cfif len(spec_main_id_list)>
										UNION ALL
										SELECT 
											SUM(SR.STOCK_IN-SR.STOCK_OUT) PRODUCT_STOCK,
											SR.STOCK_ID,
											SR.STORE AS DEPARTMENT_ID
											<cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>,SR.STORE_LOCATION AS LOCATION_ID</cfif>
										FROM 
											STOCKS_ROW SR
										WHERE
											<cfif not((isdefined('attributes.is_excel') and attributes.is_excel eq 1) and get_metarials.recordcount gt 5000)>
												SR.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#) AND 
											</cfif>
											SR.STORE_LOCATION NOT IN (SELECT SL.LOCATION_ID FROM #dsn_alias#.STOCKS_LOCATION SL WHERE SL.IS_SCRAP = 1 AND SL.DEPARTMENT_ID =SR.STORE) AND
											SR.SPECT_VAR_ID IN (#spec_main_id_list#) AND
											<cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>
											( <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
													(SR.STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND SR.STORE_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
													<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
												</cfloop>  )
											<cfelse>
												SR.STORE IN (#attributes.DEPARTMENT_ID#)
											</cfif>
										GROUP BY
											SR.STOCK_ID,
											SR.STORE
											<cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>,SR.STORE_LOCATION</cfif>
									</cfif>
								</cfquery>
								<cfif GET_STOCKS_ALL.recordcount>
									<cfscript>
										for(s_ind=1;s_ind lte GET_STOCKS_ALL.recordcount;s_ind=s_ind+1)
										{
											if(isdefined("x_is_dept_location") and x_is_dept_location eq 1)
												'dep_stock_status_#GET_STOCKS_ALL.DEPARTMENT_ID[s_ind]#_#GET_STOCKS_ALL.LOCATION_ID[s_ind]#_#GET_STOCKS_ALL.STOCK_ID[s_ind]#' = GET_STOCKS_ALL.PRODUCT_STOCK[s_ind];
											else
												'dep_stock_status_#GET_STOCKS_ALL.DEPARTMENT_ID[s_ind]#_#GET_STOCKS_ALL.STOCK_ID[s_ind]#' = GET_STOCKS_ALL.PRODUCT_STOCK[s_ind];
										}
									</cfscript>
								</cfif>
								<!--- DEPOLAR BAZINDA GERÇEK STOKLAR BİTTİ--->
								
								<!--- DEPOLARA GÖRE ÜRETİM EMİRLERİ REZERVELER --->
								<cfquery name="get_product_rezerv_dep" datasource="#dsn3#">
									SELECT
										SUM(STOCK_ARTIR) STOCK_ARTIR,
										SUM(STOCK_AZALT) STOCK_AZALT,
										S.STOCK_ID,
										ISNULL((SELECT TOP 1 SPECT_MAIN_NAME FROM SPECT_MAIN SM WHERE SM.STOCK_ID = S.STOCK_ID),''),
										S.PRODUCT_ID,
										T1.SPECT_MAIN_ID,
										EXIT_DEP_ID AS DEPARTMENT_ID
										<cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>,EXIT_LOC_ID AS LOCATION_ID</cfif>
									FROM
										(
									SELECT
											(QUANTITY) AS STOCK_ARTIR,
											0 AS STOCK_AZALT,
											PRODUCTION_ORDERS.STOCK_ID,
											ISNULL(PRODUCTION_ORDERS.SPEC_MAIN_ID,0) SPECT_MAIN_ID,
											PRODUCTION_ORDERS.EXIT_DEP_ID
											<cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>,PRODUCTION_ORDERS.EXIT_LOC_ID</cfif>
										FROM
											PRODUCTION_ORDERS
										WHERE
											PRODUCTION_ORDERS.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#) AND 
											IS_STOCK_RESERVED = 1 AND
											IS_DEMONTAJ=0 AND
											SPEC_MAIN_ID IS NOT NULL
											AND STATUS=1
											<cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>
												AND
												(
												<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
													(EXIT_DEP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND EXIT_LOC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
													<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
												</cfloop>  
												)
											<cfelse>
												AND EXIT_DEP_ID IN (#attributes.DEPARTMENT_ID#)
											</cfif>
											<!--- <cfif len(spec_main_id_list)>AND SPEC_MAIN_ID IN (SELECT SPECT_MAIN_ID FROM SPECT_MAIN_ROW WHERE RELATED_MAIN_SPECT_ID IN (#spec_main_id_list#))</cfif> --->
											<cfif ListLen(attributes.production_order_no,',')>
												AND
												(
													PRODUCTION_ORDERS.P_ORDER_NO NOT IN (SELECT ORDER_NO FROM ####attrordernotmp_#session.ep.userid#) 
												)
											</cfif>
											<cfif isdefined("attributes.row_demand_all") and len(attributes.row_demand_all)>
												AND P_ORDER_ID NOT IN (SELECT TEMP_VALUE FROM #dsn_alias#.TEMP_BLOCK_VALUES WHERE TEMP_COLUMN = 'P_ORDER_ID_FROM_ROW_DEMAND' AND RECORD_EMP = #session.ep.userid#)
											</cfif>
										UNION ALL
											SELECT
												0 AS STOCK_ARTIR,
												(QUANTITY) AS STOCK_AZALT,
												PRODUCTION_ORDERS.STOCK_ID,
												ISNULL(PRODUCTION_ORDERS.SPEC_MAIN_ID,0) SPECT_MAIN_ID,
												PRODUCTION_ORDERS.EXIT_DEP_ID
												<cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>,PRODUCTION_ORDERS.EXIT_LOC_ID</cfif>
											FROM
												PRODUCTION_ORDERS
											WHERE
												PRODUCTION_ORDERS.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#) AND 
												IS_STOCK_RESERVED = 1 AND
												IS_DEMONTAJ=1 AND
												SPEC_MAIN_ID IS NOT NULL
												AND STATUS=1
												<cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>
													AND
													(
													<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
														(EXIT_DEP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND EXIT_LOC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
														<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
													</cfloop>  
													)
												<cfelse>
													AND EXIT_DEP_ID IN (#attributes.DEPARTMENT_ID#)
												</cfif>
												<!--- <cfif len(spec_main_id_list)>AND SPEC_MAIN_ID IN (SELECT SPECT_MAIN_ID FROM SPECT_MAIN_ROW WHERE RELATED_MAIN_SPECT_ID IN (#spec_main_id_list#))</cfif> --->
												<cfif ListLen(attributes.production_order_no,',')>
													AND
													(
														PRODUCTION_ORDERS.P_ORDER_NO NOT IN (SELECT ORDER_NO FROM ####attrordernotmp_#session.ep.userid#) 
													)
												</cfif>
												<cfif isdefined("attributes.row_demand_all") and len(attributes.row_demand_all)>
													AND P_ORDER_ID NOT IN (SELECT TEMP_VALUE FROM #dsn_alias#.TEMP_BLOCK_VALUES WHERE TEMP_COLUMN = 'P_ORDER_ID_FROM_ROW_DEMAND' AND RECORD_EMP = #session.ep.userid#)
												</cfif>
										UNION ALL
											SELECT
												0 AS STOCK_ARTIR,
												CASE WHEN ISNULL((SELECT
															SUM(POR_.AMOUNT)
														FROM
															PRODUCTION_ORDER_RESULTS_ROW POR_,
															PRODUCTION_ORDER_RESULTS POO
														WHERE
															POR_.PR_ORDER_ID = POO.PR_ORDER_ID
															AND POO.P_ORDER_ID = PO.P_ORDER_ID
															AND POR_.STOCK_ID = POS.STOCK_ID
															AND POO.IS_STOCK_FIS = 1
														),0) > (ISNULL(PO.RESULT_AMOUNT,0))
														--- ISNULL(PO.RESULT_AMOUNT,0)) 
										THEN
										(
															(
																SELECT 
																		SUM(AMOUNT) AMOUNT
																	FROM
																		PRODUCTION_ORDERS_STOCKS
																	WHERE
																	P_ORDER_ID = PO.P_ORDER_ID AND STOCK_ID = POS.STOCK_ID
															)
															/
															(
																SELECT 
																	QUANTITY 
																FROM 
																	PRODUCTION_ORDERS
																WHERE
																	P_ORDER_ID = PO.P_ORDER_ID
																	AND STATUS = 1
															)										
														)*(ISNULL(PO.QUANTITY,0) - ISNULL(PO.RESULT_AMOUNT,0))
										ELSE 									
										(((POS.AMOUNT*(ISNULL(PO.QUANTITY,0) - ISNULL(PO.RESULT_AMOUNT,0)))/(ISNULL(NULLIF(PO.QUANTITY,0),1)))) END AS STOCK_AZALT,
												POS.STOCK_ID,
												ISNULL(POS.SPECT_MAIN_ID,0) SPECT_MAIN_ID,
												EXIT_DEP_ID
												<cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>,EXIT_LOC_ID</cfif>
											FROM
												PRODUCTION_ORDERS PO,
												PRODUCTION_ORDERS_STOCKS POS
											WHERE
												POS.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#) AND 
												PO.IS_STOCK_RESERVED = 1 AND
												PO.P_ORDER_ID = POS.P_ORDER_ID AND
												PO.IS_DEMONTAJ=0 AND
												ISNULL(POS.STOCK_ID,0)>0 AND
												POS.IS_SEVK <> 1 AND
												ISNULL(IS_FREE_AMOUNT,0) = 0
												AND PO.STATUS=1
											<cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>
													AND
													(
													<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
														(EXIT_DEP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND EXIT_LOC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
														<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
													</cfloop>  
													)
												<cfelse>
													AND EXIT_DEP_ID IN (#attributes.DEPARTMENT_ID#)
												</cfif>
												<!--- <cfif len(spec_main_id_list)>AND POS.SPECT_MAIN_ID IN (#spec_main_id_list#)</cfif> --->
												<cfif ListLen(attributes.production_order_no,',')>
													AND
													(
														PO.P_ORDER_NO NOT IN (SELECT ORDER_NO FROM ####attrordernotmp_#session.ep.userid#) 
													)
												</cfif>
												<cfif isdefined("attributes.row_demand_all") and len(attributes.row_demand_all)>
													AND PO.P_ORDER_ID NOT IN (SELECT TEMP_VALUE FROM #dsn_alias#.TEMP_BLOCK_VALUES WHERE TEMP_COLUMN = 'P_ORDER_ID_FROM_ROW_DEMAND' AND RECORD_EMP = #session.ep.userid#)
												</cfif>
										UNION ALL
											SELECT
												POS.AMOUNT AS STOCK_ARTIR,
												0 AS STOCK_AZALT,
												POS.STOCK_ID,
												ISNULL(POS.SPECT_MAIN_ID,0) SPECT_MAIN_ID,
												EXIT_DEP_ID
												<cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>,EXIT_LOC_ID</cfif>
											FROM
												PRODUCTION_ORDERS PO,
												PRODUCTION_ORDERS_STOCKS POS
											WHERE
												POS.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#) AND 
												PO.IS_STOCK_RESERVED = 1 AND
												PO.P_ORDER_ID = POS.P_ORDER_ID AND
												PO.IS_DEMONTAJ=1 AND
												ISNULL(POS.STOCK_ID,0)>0 AND
												POS.IS_SEVK <> 1 AND
												ISNULL(IS_FREE_AMOUNT,0) = 0
												AND PO.STATUS=1
												<cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>
													AND
													(
													<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
														(EXIT_DEP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND EXIT_LOC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
														<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
													</cfloop>  
													)
												<cfelse>
													AND EXIT_DEP_ID IN (#attributes.DEPARTMENT_ID#)
												</cfif>
												<!--- <cfif len(spec_main_id_list)>AND POS.SPECT_MAIN_ID IN (#spec_main_id_list#)</cfif> --->
												<cfif ListLen(attributes.production_order_no,',')>
													AND
													(
														PO.P_ORDER_NO NOT IN (SELECT ORDER_NO FROM ####attrordernotmp_#session.ep.userid#) 
													)
												</cfif>
												<cfif isdefined("attributes.row_demand_all") and len(attributes.row_demand_all)>
													AND PO.P_ORDER_ID NOT IN (SELECT TEMP_VALUE FROM #dsn_alias#.TEMP_BLOCK_VALUES WHERE TEMP_COLUMN = 'P_ORDER_ID_FROM_ROW_DEMAND' AND RECORD_EMP = #session.ep.userid#)
												</cfif>
										UNION ALL
											SELECT
												(P_ORD_R_R.AMOUNT)*-1 AS  STOCK_ARTIR,
												0 AS STOCK_AZALT,
												P_ORD.STOCK_ID,
												ISNULL(P_ORD_R_R.SPEC_MAIN_ID,0) SPECT_MAIN_ID,
												P_ORD_R.EXIT_DEP_ID
												<cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>,P_ORD_R.EXIT_LOC_ID</cfif>
											FROM
												PRODUCTION_ORDER_RESULTS P_ORD_R,
												PRODUCTION_ORDER_RESULTS_ROW P_ORD_R_R,
												PRODUCTION_ORDERS P_ORD
											WHERE
												P_ORD_R_R.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#) AND 
												P_ORD.IS_STOCK_RESERVED=1 AND
												P_ORD.SPEC_MAIN_ID IS NOT NULL AND
												P_ORD.P_ORDER_ID = P_ORD_R.P_ORDER_ID AND
												P_ORD_R_R.PR_ORDER_ID=P_ORD_R.PR_ORDER_ID AND
												P_ORD_R_R.TYPE=1 AND
												P_ORD_R.IS_STOCK_FIS=1 AND
												P_ORD_R_R.IS_SEVKIYAT IS NULL
												AND P_ORD.STATUS=1
												<cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>
													AND
													(
													<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
														(P_ORD_R.EXIT_DEP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND P_ORD_R.EXIT_LOC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
														<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
													</cfloop>  
													)
												<cfelse>
													AND P_ORD_R.EXIT_DEP_ID IN (#attributes.DEPARTMENT_ID#)
												</cfif>
												<!--- <cfif len(spec_main_id_list)>AND P_ORD.SPEC_MAIN_ID IN (SELECT SPECT_MAIN_ID FROM SPECT_MAIN_ROW WHERE RELATED_MAIN_SPECT_ID IN (#spec_main_id_list#))</cfif> --->
									) T1,
									#dsn1_alias#.STOCKS S
									WHERE
										S.STOCK_ID=T1.STOCK_ID AND
										T1.EXIT_DEP_ID IS NOT NULL
									GROUP BY 
										S.STOCK_ID,
										S.PRODUCT_ID,
										T1.SPECT_MAIN_ID,
										T1.EXIT_DEP_ID
										<cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>,T1.EXIT_LOC_ID</cfif>
								</cfquery>
								<cfif get_product_rezerv_dep.RECORDCOUNT>
									<cfscript>
										for(prod_jj=1;prod_jj lte get_product_rezerv_dep.recordcount; prod_jj=prod_jj+1)
										{
											if(isdefined("x_is_dept_location") and x_is_dept_location eq 1)
												'stock_prod_rezerve_#get_product_rezerv_dep.DEPARTMENT_ID[prod_jj]#_#GET_STOCKS_ALL.LOCATION_ID[prod_jj]#_#get_product_rezerv_dep.STOCK_ID[prod_jj]#' = get_product_rezerv_dep.STOCK_AZALT[prod_jj];
											else	
												'stock_prod_rezerve_#get_product_rezerv_dep.DEPARTMENT_ID[prod_jj]#_#get_product_rezerv_dep.STOCK_ID[prod_jj]#' = get_product_rezerv_dep.STOCK_AZALT[prod_jj];
										}
									</cfscript>
								</cfif>
								<!--- DEPOLARA GÖRE ÜRETİM EMİRLERİ REZERVELER BİTTİ--->
								
								<!--- DEPOLARA GÖRE STRATEJİLERDEN MIN STOCK --->
								<cfquery name="GET_STOCT_STR_DEP" datasource="#DSN3#">
									SELECT 
										DEPARTMENT_ID,
										MINIMUM_STOCK,
										STOCK_STRATEGY.STOCK_ID 
									FROM 
										STOCK_STRATEGY 
									WHERE 
										STOCK_STRATEGY.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#) AND
										DEPARTMENT_ID IN (#attributes.DEPARTMENT_ID#)
								</cfquery>
								<cfif GET_STOCT_STR_DEP.RECORDCOUNT>
									<cfscript>
										for(prod_yy=1;prod_yy lte GET_STOCT_STR_DEP.recordcount; prod_yy=prod_yy+1)
											'dep_min_stock_#GET_STOCT_STR_DEP.DEPARTMENT_ID[prod_yy]#_#GET_STOCT_STR_DEP.STOCK_ID[prod_yy]#' = GET_STOCT_STR_DEP.MINIMUM_STOCK[prod_yy];
									</cfscript>
								</cfif>
								<cfif isdefined("demand_department_id") and len(demand_department_id)>
									<cfquery name="GET_STOCK_DEMAND" datasource="#DSN3#">
										SELECT
											SUM(AMOUNT) AS TOTAL_AMOUNT,
											STOCK_ID
										FROM
											(
												SELECT
													SUM(QUANTITY) AS AMOUNT,
													IR.STOCK_ID
												FROM
													INTERNALDEMAND_ROW IR ,
													INTERNALDEMAND I
												WHERE
													IR.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#) AND
													I.INTERNAL_ID= IR.I_ID
													AND I.IS_ACTIVE=1
													AND I.DEPARTMENT_OUT = #demand_department_id#
												GROUP BY
													IR.STOCK_ID
												UNION ALL
												SELECT
													-1*SUM(PR.AMOUNT)  AMOUNT,
													PR.STOCK_ID
												FROM
													INTERNALDEMAND_ROW IR,
													INTERNALDEMAND_RELATION_ROW PR,
													INTERNALDEMAND I
												WHERE
													PR.INTERNALDEMAND_ID = I.INTERNAL_ID
													AND PR.STOCK_ID = IR.STOCK_ID
													AND PR.STOCK_ID IN(#stock_id_list#)
													AND IR.STOCK_ID IN(#stock_id_list#)
													AND I.INTERNAL_ID= IR.I_ID
													AND I.IS_ACTIVE=1
													AND I.DEPARTMENT_OUT = #demand_department_id#
													AND PR.TO_SHIP_ID IS NOT NULL
												GROUP BY
													PR.STOCK_ID
											) AS A1
										GROUP BY
											STOCK_ID
									</cfquery>
									<cfif GET_STOCK_DEMAND.RECORDCOUNT>
										<cfscript>
											for(prod_yy=1;prod_yy lte GET_STOCK_DEMAND.recordcount; prod_yy=prod_yy+1)
												'dept_demand_stock_#GET_STOCK_DEMAND.STOCK_ID[prod_yy]#' = GET_STOCK_DEMAND.TOTAL_AMOUNT[prod_yy];
										</cfscript>
									</cfif>
								</cfif>
								<cfquery name="get_alternative_stocks" datasource="#dsn3#">
									SELECT 
										SUM(GS.SALEABLE_STOCK) STOCK_AMOUNT,
										S2.STOCK_ID,
										GS.DEPARTMENT_ID
										<cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>,GS.LOCATION_ID</cfif>
									FROM
										ALTERNATIVE_PRODUCTS AP,
										STOCKS S,
										STOCKS S2
										LEFT JOIN ####get_metarials_get_order_#session.ep.userid# XXX ON S2.STOCK_ID = XXX.STOCK_ID,
										#dsn2_alias#.GET_STOCK_LAST_LOCATION GS
									WHERE 
										S.PRODUCT_ID = AP.ALTERNATIVE_PRODUCT_ID AND
										AP.STOCK_ID IS NOT NULL AND
										S.STOCK_ID = GS.STOCK_ID AND
										S2.PRODUCT_ID = AP.PRODUCT_ID AND
										GS.DEPARTMENT_ID > 0
									GROUP BY
										S2.STOCK_ID,
										GS.DEPARTMENT_ID
										<cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>,GS.LOCATION_ID</cfif>
								</cfquery>
								<cfif get_alternative_stocks.RECORDCOUNT>
									<cfscript>
										for(prod_yy=1;prod_yy lte get_alternative_stocks.recordcount; prod_yy=prod_yy+1)
										{
											if(isdefined("x_is_dept_location") and x_is_dept_location eq 1)
												'alternative_amount_#get_alternative_stocks.DEPARTMENT_ID[prod_yy]#_#get_alternative_stocks.LOCATION_ID[prod_yy]#_#get_alternative_stocks.STOCK_ID[prod_yy]#' = get_alternative_stocks.STOCK_AMOUNT[prod_yy];
											else
												'alternative_amount_#get_alternative_stocks.DEPARTMENT_ID[prod_yy]#_#get_alternative_stocks.STOCK_ID[prod_yy]#' = get_alternative_stocks.STOCK_AMOUNT[prod_yy];
										}
									</cfscript>
								</cfif>
							<cfelse><!---       depo seçili değilse        --->
								<cfset stock_id_list = listdeleteduplicates(stock_id_list)>
								<cfset spec_main_id_list = listdeleteduplicates(spec_main_id_list)>
								<cfquery name="GET_STOCKS_ALL" datasource="#DSN2#">
									SELECT 
										SUM(SR.STOCK_IN-SR.STOCK_OUT) PRODUCT_STOCK,
										SR.STOCK_ID
									FROM 
										STOCKS_ROW SR
									WHERE
									<cfif not((isdefined('attributes.is_excel') and attributes.is_excel eq 1) and get_metarials.recordcount gt 5000)>
										SR.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#) AND
									</cfif>   
										SR.STORE_LOCATION NOT IN (SELECT SL.LOCATION_ID FROM #dsn_alias#.STOCKS_LOCATION SL WHERE SL.IS_SCRAP = 1 AND SL.DEPARTMENT_ID =SR.STORE)
									GROUP BY
										SR.STOCK_ID
									<cfif len(spec_main_id_list)>
										UNION ALL
										SELECT 
											SUM(SR.STOCK_IN-SR.STOCK_OUT) PRODUCT_STOCK,
											SR.STOCK_ID
										FROM 
											STOCKS_ROW SR
											
										WHERE
											<cfif not((isdefined('attributes.is_excel') and attributes.is_excel eq 1) and get_metarials.recordcount gt 5000)>
												SR.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#) AND
											</cfif>
											SR.SPECT_VAR_ID IN (#spec_main_id_list#) AND
											SR.STORE_LOCATION NOT IN (SELECT SL.LOCATION_ID FROM #dsn_alias#.STOCKS_LOCATION SL WHERE SL.IS_SCRAP = 1 AND SL.DEPARTMENT_ID =SR.STORE)
										GROUP BY
											SR.STOCK_ID
									</cfif>
								</cfquery>
								<cfif GET_STOCKS_ALL.recordcount>
									<cfscript>
										for(s_ind=1;s_ind lte GET_STOCKS_ALL.recordcount;s_ind=s_ind+1)
											'dep_stock_status_#GET_STOCKS_ALL.STOCK_ID[s_ind]#' = GET_STOCKS_ALL.PRODUCT_STOCK[s_ind];
									</cfscript>
								</cfif>
								<!--- GERÇEK STOKLAR BİTTİ--->
								<!--- ÜRETİM EMİRLERİ REZERVELER --->
								<cfquery name="get_product_rezerv_dep" datasource="#dsn3#">
									SELECT
										SUM(STOCK_ARTIR) STOCK_ARTIR,
										SUM(STOCK_AZALT) STOCK_AZALT,
										S.STOCK_ID,
										ISNULL((SELECT TOP 1 SPECT_MAIN_NAME FROM SPECT_MAIN SM WHERE SM.STOCK_ID = S.STOCK_ID),''),
										S.PRODUCT_ID,
										T1.SPECT_MAIN_ID
									FROM
										(
									SELECT
											(QUANTITY) AS STOCK_ARTIR,
											0 AS STOCK_AZALT,
											PRODUCTION_ORDERS.STOCK_ID,
											ISNULL(PRODUCTION_ORDERS.SPEC_MAIN_ID,0) SPECT_MAIN_ID
										FROM
											PRODUCTION_ORDERS
										WHERE
											PRODUCTION_ORDERS.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#) AND
											IS_STOCK_RESERVED = 1 AND
											IS_DEMONTAJ=0 AND
											SPEC_MAIN_ID IS NOT NULL
											--AND EXIT_DEP_ID IS NOT NULL
											AND EXIT_LOC_ID NOT IN (SELECT SL.LOCATION_ID FROM #dsn_alias#.STOCKS_LOCATION SL WHERE SL.IS_SCRAP = 1 AND SL.DEPARTMENT_ID =EXIT_DEP_ID)
											AND STATUS=1
											<!--- <cfif len(spec_main_id_list)>AND SPEC_MAIN_ID IN (SELECT SPECT_MAIN_ID FROM SPECT_MAIN_ROW WHERE RELATED_MAIN_SPECT_ID IN (#spec_main_id_list#))</cfif> --->
											<cfif ListLen(attributes.production_order_no,',')>
												AND
												(
													PRODUCTION_ORDERS.P_ORDER_NO NOT IN (SELECT ORDER_NO FROM ####attrordernotmp_#session.ep.userid#) 
												)
											</cfif>
											<cfif isdefined("attributes.row_demand_all") and len(attributes.row_demand_all)>
												AND P_ORDER_ID NOT IN (SELECT TEMP_VALUE FROM #dsn_alias#.TEMP_BLOCK_VALUES WHERE TEMP_COLUMN = 'P_ORDER_ID_FROM_ROW_DEMAND' AND RECORD_EMP = #session.ep.userid#)
											</cfif>
										UNION ALL
											SELECT
												0 AS STOCK_ARTIR,
												(QUANTITY) AS STOCK_AZALT,
												PRODUCTION_ORDERS.STOCK_ID,
												ISNULL(PRODUCTION_ORDERS.SPEC_MAIN_ID,0) SPECT_MAIN_ID
											FROM
												PRODUCTION_ORDERS
											WHERE
												PRODUCTION_ORDERS.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#) AND
												IS_STOCK_RESERVED = 1 AND
												IS_DEMONTAJ=1 AND
												SPEC_MAIN_ID IS NOT NULL
												--AND EXIT_DEP_ID IS NOT NULL
												AND EXIT_LOC_ID NOT IN (SELECT SL.LOCATION_ID FROM #dsn_alias#.STOCKS_LOCATION SL WHERE SL.IS_SCRAP = 1 AND SL.DEPARTMENT_ID =EXIT_DEP_ID)
												AND STATUS=1
												<!--- <cfif len(spec_main_id_list)>AND SPEC_MAIN_ID IN (SELECT SPECT_MAIN_ID FROM SPECT_MAIN_ROW WHERE RELATED_MAIN_SPECT_ID IN (#spec_main_id_list#))</cfif> --->
												<cfif ListLen(attributes.production_order_no,',')>
													AND
													(
														PRODUCTION_ORDERS.P_ORDER_NO NOT IN (SELECT ORDER_NO FROM ####attrordernotmp_#session.ep.userid#) 
													)
												</cfif>
												<cfif isdefined("attributes.row_demand_all") and len(attributes.row_demand_all)>
													AND P_ORDER_ID NOT IN (SELECT TEMP_VALUE FROM #dsn_alias#.TEMP_BLOCK_VALUES WHERE TEMP_COLUMN = 'P_ORDER_ID_FROM_ROW_DEMAND' AND RECORD_EMP = #session.ep.userid#)
												</cfif>
										UNION ALL
											SELECT
												0 AS STOCK_ARTIR,
												CASE WHEN ISNULL((SELECT
															SUM(POR_.AMOUNT)
														FROM
															PRODUCTION_ORDER_RESULTS_ROW POR_,
															PRODUCTION_ORDER_RESULTS POO
														WHERE
															POR_.PR_ORDER_ID = POO.PR_ORDER_ID
															AND POO.P_ORDER_ID = PO.P_ORDER_ID
															AND POR_.STOCK_ID = POS.STOCK_ID
															AND POO.IS_STOCK_FIS = 1
														),0) > (ISNULL(PO.RESULT_AMOUNT,0))
														--- ISNULL(PO.RESULT_AMOUNT,0)) 
										THEN
										(
															(
																SELECT 
																		SUM(AMOUNT) AMOUNT
																	FROM
																		PRODUCTION_ORDERS_STOCKS
																	WHERE
																	P_ORDER_ID = PO.P_ORDER_ID AND STOCK_ID = POS.STOCK_ID
															)
															/
															(
																SELECT 
																	QUANTITY 
																FROM 
																	PRODUCTION_ORDERS
																WHERE
																	P_ORDER_ID = PO.P_ORDER_ID
																	AND STATUS=1
															)										
														)*(ISNULL(PO.QUANTITY,0) - ISNULL(PO.RESULT_AMOUNT,0))
										ELSE 									
										(((POS.AMOUNT*(ISNULL(PO.QUANTITY,0) - ISNULL(PO.RESULT_AMOUNT,0)))/(ISNULL(NULLIF(PO.QUANTITY,0),1)))) END AS STOCK_AZALT,
												POS.STOCK_ID,
												ISNULL(POS.SPECT_MAIN_ID,0) SPECT_MAIN_ID
											FROM
												PRODUCTION_ORDERS PO,
												PRODUCTION_ORDERS_STOCKS POS
											WHERE
												POS.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#) AND
												PO.IS_STOCK_RESERVED = 1 AND
												PO.P_ORDER_ID = POS.P_ORDER_ID AND
												PO.IS_DEMONTAJ=0 AND
												ISNULL(POS.STOCK_ID,0)>0 AND
												POS.IS_SEVK <> 1
											-- AND EXIT_DEP_ID IS NOT NULL
												AND EXIT_LOC_ID NOT IN (SELECT SL.LOCATION_ID FROM #dsn_alias#.STOCKS_LOCATION SL WHERE SL.IS_SCRAP = 1 AND SL.DEPARTMENT_ID = EXIT_DEP_ID)
												AND PO.STATUS=1
												<!--- <cfif len(spec_main_id_list)>AND POS.SPECT_MAIN_ID IN (#spec_main_id_list#)</cfif> --->
												<cfif ListLen(attributes.production_order_no,',')>
													AND
													(
														PO.P_ORDER_NO NOT IN (SELECT ORDER_NO FROM ####attrordernotmp_#session.ep.userid#) 
													)
												</cfif>
												<cfif isdefined("attributes.row_demand_all") and len(attributes.row_demand_all)>
													AND PO.P_ORDER_ID NOT IN (SELECT TEMP_VALUE FROM #dsn_alias#.TEMP_BLOCK_VALUES WHERE TEMP_COLUMN = 'P_ORDER_ID_FROM_ROW_DEMAND' AND RECORD_EMP = #session.ep.userid#)
												</cfif>
										UNION ALL
											SELECT
												POS.AMOUNT AS STOCK_ARTIR,
												0 AS STOCK_AZALT,
												POS.STOCK_ID,
												ISNULL(POS.SPECT_MAIN_ID,0) SPECT_MAIN_ID
											FROM
												PRODUCTION_ORDERS PO,
												PRODUCTION_ORDERS_STOCKS POS
											WHERE
												POS.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#) AND
												PO.IS_STOCK_RESERVED = 1 AND
												PO.P_ORDER_ID = POS.P_ORDER_ID AND
												PO.IS_DEMONTAJ=1 AND
												ISNULL(POS.STOCK_ID,0)>0 AND
												POS.IS_SEVK <> 1
												--AND EXIT_DEP_ID IS NOT NULL
												AND EXIT_LOC_ID NOT IN (SELECT SL.LOCATION_ID FROM #dsn_alias#.STOCKS_LOCATION SL WHERE SL.IS_SCRAP = 1 AND SL.DEPARTMENT_ID = EXIT_DEP_ID)
												AND PO.STATUS=1
												<!--- <cfif len(spec_main_id_list)>AND POS.SPECT_MAIN_ID IN (#spec_main_id_list#)</cfif> --->
												<cfif ListLen(attributes.production_order_no,',')>
													AND
													(
														PO.P_ORDER_NO NOT IN (SELECT ORDER_NO FROM ####attrordernotmp_#session.ep.userid#) 
													)
												</cfif>
												<cfif isdefined("attributes.row_demand_all") and len(attributes.row_demand_all)>
													AND PO.P_ORDER_ID NOT IN (SELECT TEMP_VALUE FROM #dsn_alias#.TEMP_BLOCK_VALUES WHERE TEMP_COLUMN = 'P_ORDER_ID_FROM_ROW_DEMAND' AND RECORD_EMP = #session.ep.userid#)
												</cfif>
										UNION ALL
											SELECT
												(P_ORD_R_R.AMOUNT)*-1 AS  STOCK_ARTIR,
												0 AS STOCK_AZALT,
												P_ORD_R_R.STOCK_ID,
												ISNULL(P_ORD_R_R.SPEC_MAIN_ID,0) SPECT_MAIN_ID
											FROM
												PRODUCTION_ORDER_RESULTS P_ORD_R,
												PRODUCTION_ORDER_RESULTS_ROW P_ORD_R_R,
												PRODUCTION_ORDERS P_ORD
											WHERE
												P_ORD_R_R.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#) AND
												P_ORD.IS_STOCK_RESERVED=1 AND
												P_ORD.SPEC_MAIN_ID IS NOT NULL AND
												P_ORD.P_ORDER_ID = P_ORD_R.P_ORDER_ID AND
												P_ORD_R_R.PR_ORDER_ID=P_ORD_R.PR_ORDER_ID AND
												P_ORD_R_R.TYPE=1 AND
												P_ORD_R.IS_STOCK_FIS=1 AND
												P_ORD_R_R.IS_SEVKIYAT IS NULL
												AND P_ORD_R.EXIT_DEP_ID IS NOT NULL
												AND P_ORD_R.EXIT_LOC_ID NOT IN (SELECT SL.LOCATION_ID FROM #dsn_alias#.STOCKS_LOCATION SL WHERE SL.IS_SCRAP = 1 AND SL.DEPARTMENT_ID = P_ORD_R.EXIT_DEP_ID)
												AND P_ORD.STATUS=1
												<!--- <cfif len(spec_main_id_list)>AND P_ORD.SPEC_MAIN_ID IN (SELECT SPECT_MAIN_ID FROM SPECT_MAIN_ROW WHERE RELATED_MAIN_SPECT_ID IN (#spec_main_id_list#))</cfif> --->
									) T1,
									#dsn1_alias#.STOCKS S
									WHERE
										S.STOCK_ID=T1.STOCK_ID
									
									GROUP BY 
										S.STOCK_ID,
										S.PRODUCT_ID,
										T1.SPECT_MAIN_ID
								</cfquery>
								<cfif get_product_rezerv_dep.RECORDCOUNT>
									<cfscript>
										for(prod_jj=1;prod_jj lte get_product_rezerv_dep.recordcount; prod_jj=prod_jj+1)
											'stock_prod_rezerve_#get_product_rezerv_dep.STOCK_ID[prod_jj]#' = get_product_rezerv_dep.STOCK_AZALT[prod_jj];
									</cfscript>
								</cfif>
								<!--- ÜRETİM EMİRLERİ REZERVELER BİTTİ--->
								<!--- STRATEJİLERDEN MIN STOCK --->
								<cfquery name="GET_STOCT_STR_DEP" datasource="#DSN3#">
									SELECT 
										SUM(ISNULL(MINIMUM_STOCK,0)) MINIMUM_STOCK,
										STOCK_ID 
									FROM 
										STOCK_STRATEGY 
									WHERE 
										STOCK_ID IN (#stock_id_list#)
									GROUP BY
										STOCK_ID
								</cfquery>
								<cfif GET_STOCT_STR_DEP.RECORDCOUNT>
									<cfscript>
										for(prod_yy=1;prod_yy lte GET_STOCT_STR_DEP.recordcount; prod_yy=prod_yy+1)
											'dep_min_stock_#GET_STOCT_STR_DEP.STOCK_ID[prod_yy]#' = GET_STOCT_STR_DEP.MINIMUM_STOCK[prod_yy];
									</cfscript>
								</cfif>
								<!--- STRATEJİLERDEN MIN STOCK BİTTİ--->
								<cfquery name="get_alternative_stocks" datasource="#dsn3#">
									SELECT 
										SUM(GS.SALEABLE_STOCK) STOCK_AMOUNT,
										S2.STOCK_ID
									FROM
										ALTERNATIVE_PRODUCTS AP,
										STOCKS S,
										STOCKS S2  
										LEFT JOIN ####get_metarials_get_order_#session.ep.userid# XXX ON S2.STOCK_ID = XXX.STOCK_ID,
										#dsn2_alias#.GET_STOCK_LAST GS
									WHERE 
										S.PRODUCT_ID = AP.ALTERNATIVE_PRODUCT_ID AND
										AP.STOCK_ID IS NOT NULL AND
										S.STOCK_ID = GS.STOCK_ID AND
										S2.PRODUCT_ID = AP.PRODUCT_ID
									GROUP BY
										S2.STOCK_ID
								</cfquery>
								<cfif get_alternative_stocks.RECORDCOUNT>
									<cfscript>
										for(prod_yy=1;prod_yy lte get_alternative_stocks.recordcount; prod_yy=prod_yy+1)
											'alternative_amount_#get_alternative_stocks.STOCK_ID[prod_yy]#' = get_alternative_stocks.STOCK_AMOUNT[prod_yy];
									</cfscript>
								</cfif>
							</cfif>
							<cfif len(stock_id_list)>
								<!--- ÜRETİM BEKLENEN --->
								<cfquery name="GET_STOCK_PROD_BEKLENEN" datasource="#dsn3#">
									SELECT
										SUM(STOCK_ARTIR) AS ARTAN,
										GET_PRODUCTION_RESERVED.STOCK_ID
									FROM
										GET_PRODUCTION_RESERVED
									WHERE 
										GET_PRODUCTION_RESERVED.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#) 
									GROUP BY 
										GET_PRODUCTION_RESERVED.STOCK_ID
									<cfif len(spec_main_id_list)>
										UNION ALL
										SELECT
											SUM(STOCK_ARTIR) AS ARTAN,
											GET_PRODUCTION_RESERVED_SPECT.STOCK_ID
										FROM
											GET_PRODUCTION_RESERVED_SPECT
										WHERE						
											GET_PRODUCTION_RESERVED_SPECT.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#)  AND 
											GET_PRODUCTION_RESERVED_SPECT.SPECT_MAIN_ID IN (SELECT SPECT_MAIN_ID FROM SPECT_MAIN_ROW WHERE RELATED_MAIN_SPECT_ID IN (#spec_main_id_list#))
										GROUP BY 
											GET_PRODUCTION_RESERVED_SPECT.STOCK_ID
									</cfif>
								</cfquery>  
								<cfif GET_STOCK_PROD_BEKLENEN.RECORDCOUNT>
									<cfscript>
										for(prod_rr=1;prod_rr lte GET_STOCK_PROD_BEKLENEN.recordcount; prod_rr=prod_rr+1){
											'prod_bekleyen_#GET_STOCK_PROD_BEKLENEN.STOCK_ID[prod_rr]#' = GET_STOCK_PROD_BEKLENEN.ARTAN[prod_rr];
										}
									</cfscript>
								</cfif>              
								<!--- ÜRÜN FİYATLAR --->
								<cfquery name="GET_PRICE" datasource="#DSN3#">
									SELECT
										P.MONEY,
										P.PRICE,
										S.STOCK_ID
									FROM
										<cfif attributes.price_cat eq -1>
											PRICE_STANDART P,
										<cfelse>
											PRICE P,
										</cfif>
										STOCKS S 
									WHERE
										S.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#)  AND 
										S.PRODUCT_ID = P.PRODUCT_ID AND
										<cfif attributes.price_cat eq -1>
											P.PRICESTANDART_STATUS = 1 AND
											P.PURCHASESALES = 0
										<cfelse>
											ISNULL(P.STOCK_ID,0)=0 AND
											ISNULL(P.SPECT_VAR_ID,0)=0 AND
											P.STARTDATE <= #now()# AND
											(P.FINISHDATE >= #now()# OR P.FINISHDATE IS NULL) AND
											P.PRICE_CATID = #attributes.price_cat#
										</cfif>
								</cfquery>
								<cfif GET_PRICE.RECORDCOUNT>
									<cfscript>
										for(prod_xx=1;prod_xx lte GET_PRICE.recordcount; prod_xx=prod_xx+1){
											'product_price_#GET_PRICE.STOCK_ID[prod_xx]#' = GET_PRICE.PRICE[prod_xx];
											'product_money_#GET_PRICE.STOCK_ID[prod_xx]#' = GET_PRICE.MONEY[prod_xx];
										}
									</cfscript>
								</cfif>
								<!--- ÜRÜN FİYATLAR BİTTİ --->
								<!--- SATIALMA SİPARİŞ REZERVELER --->
								<cfquery name="GET_STOCK_RESERVED" datasource="#DSN3#"><!--- siparisler stoktan dusulecek veya eklenecekse toplamını alalım--->
										SELECT
											*
										FROM
										(
											SELECT
												SUM(OR_R.QUANTITY-ORR.STOCK_IN) ARTAN,
												OR_R.STOCK_ID
											FROM
											STOCKS S 
												INNER JOIN GET_ORDER_ROWS_RESERVED ORR ON S.STOCK_ID = ORR.STOCK_ID 
												INNER JOIN ORDERS O ON ORR.ORDER_ID = O.ORDER_ID
												INNER JOIN ORDER_ROW OR_R ON OR_R.ORDER_ID = O.ORDER_ID AND ORR.STOCK_ID = OR_R.STOCK_ID
												INNER JOIN PRODUCT_UNIT PU ON S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID
											WHERE
												OR_R.WRK_ROW_ID = ORR.ORDER_WRK_ROW_ID AND
												O.RESERVED = 1 AND
												O.ORDER_STATUS = 1 AND
												O.PURCHASE_SALES = 0 AND
												O.ORDER_ZONE = 0 AND
												OR_R.RESERVE_TYPE <> -3 AND
												OR_R.ORDER_ROW_CURRENCY NOT IN(-9,-10,-8,-3) AND
												(ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) > 0
												<cfif not((isdefined('attributes.is_excel') and attributes.is_excel eq 1) and get_metarials.recordcount gt 5000)>
													AND OR_R.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#)   
												</cfif>
												<cfif len(attributes.department_id)>
													<cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>
														AND
														(
														<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
															(ISNULL(OR_R.DELIVER_DEPT,O.DELIVER_DEPT_ID) = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND ISNULL(OR_R.DELIVER_LOCATION,O.LOCATION_ID) = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
															<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
														</cfloop>  
														)
													<cfelse>
														AND ISNULL(OR_R.DELIVER_DEPT,O.DELIVER_DEPT_ID) IN (#attributes.DEPARTMENT_ID#)
													</cfif>
												</cfif>
												GROUP BY            	
												or_r.stock_Id	
											<cfif len(spec_main_id_list)>
												UNION ALL
												SELECT
													SUM(OR_R.QUANTITY-ORR.STOCK_IN) ARTAN,
													OR_R.STOCK_ID
												FROM
													STOCKS S 
													INNER JOIN SPECTS_ROW SR ON SR.STOCK_ID = S.STOCK_ID
													INNER JOIN GET_ORDER_ROWS_RESERVED ORR ON SR.SPECT_ID = ORR.SPECT_VAR_ID
													INNER JOIN ORDERS O ON ORR.ORDER_ID = O.ORDER_ID 
													INNER JOIN ORDER_ROW OR_R ON O.ORDER_ID = OR_R.ORDER_ID AND ORR.STOCK_ID = OR_R.STOCK_ID 
													INNER JOIN PRODUCT_UNIT PU ON S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID    
												WHERE
													OR_R.WRK_ROW_ID = ORR.ORDER_WRK_ROW_ID AND
													SR.IS_SEVK = 1 AND
													O.RESERVED = 1 AND
													O.ORDER_STATUS = 1 AND
													O.PURCHASE_SALES = 0 AND
													O.ORDER_ZONE = 0 AND
													OR_R.RESERVE_TYPE <> -3 AND
													OR_R.ORDER_ROW_CURRENCY NOT IN(-9,-10,-8,-3) AND
													(ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) > 0 
													<cfif not((isdefined('attributes.is_excel') and attributes.is_excel eq 1) and get_metarials.recordcount gt 5000)>
														AND OR_R.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#)   
														AND ORR.SPECT_VAR_ID IN
														(
															SELECT 
																SPECTS.SPECT_VAR_ID
															FROM
																SPECTS
															WHERE
																SPECTS.SPECT_MAIN_ID IN  (#spec_main_id_list#)
														) 
													</cfif>
													<cfif len(attributes.department_id)>
														<cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>
															AND
															(
															<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
																(ISNULL(OR_R.DELIVER_DEPT,O.DELIVER_DEPT_ID) = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND ISNULL(OR_R.DELIVER_LOCATION,O.LOCATION_ID) = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
																<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
															</cfloop>  
															)
														<cfelse>
															AND ISNULL(OR_R.DELIVER_DEPT,O.DELIVER_DEPT_ID) IN (#attributes.DEPARTMENT_ID#)
														</cfif>
													</cfif>
												GROUP BY
													or_r.stock_Id
											</cfif>
										)T1
								</cfquery>
								<cfif GET_STOCK_RESERVED.RECORDCOUNT>
									<cfscript>
										for(prod_rr=1;prod_rr lte GET_STOCK_RESERVED.recordcount; prod_rr=prod_rr+1){
											'stock_order_res_#GET_STOCK_RESERVED.STOCK_ID[prod_rr]#' = GET_STOCK_RESERVED.ARTAN[prod_rr];
										}
									</cfscript>
								</cfif>
								<!--- SATIALMA SİPARİŞ REZERVELER BİTTİ--->
							</cfif>
							<cfoutput query="get_metarials" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
								<tr id="row-#currentrow#">
									<cfif isdefined("attributes.list_type") and attributes.list_type eq 4>
										<!-- sil -->
											<td align="center" id="material_row#currentrow#" onClick="gizle_goster(material_stocks_detail#currentrow#);connectAjax2('#currentrow#','#STOCK_ID#');gizle_goster(siparis_goster#currentrow#);gizle_goster(siparis_gizle#currentrow#);">
												<img id="siparis_goster#currentrow#" style="cursor:pointer;" src="/images/listele.gif" title="<cf_get_lang dictionary_id ='58596.Göster'>">
												<img id="siparis_gizle#currentrow#" style="cursor:pointer;display:none;" src="/images/listele_down.gif" title="<cf_get_lang dictionary_id ='58628.Gizle'>">
											</td>
										<!-- sil -->
									</cfif>
									<td width="25">#currentrow#</td>
									<td width="100" style="mso-number-format:'\@'">
										<cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1>
											#STOCK_CODE#
										<cfelse>
											<a href="#request.self#?fuseaction=stock.list_stock&event=det&pid=#product_id#" class="tableyazi">#STOCK_CODE#</a>
										</cfif>
									</td>
									<td>#PRODUCT_NAME#</td>
									<cfif SPECT_MAIN_ID eq 0 > 
									<td> </td>
									<cfelse>
									<td>#SPECT_MAIN_ID#</td>
									</cfif>
								
									<td>#SPECT_MAIN_NAME#</td>
								
									<td style="text-align:right;">#TLFORMAT(AMOUNT,real_stock_round_number)#</td>
									<cfset row_all_active_stocks = 0>
									<cfset row_all_min_stocks = 0>
									<cfif ListLen(attributes.DEPARTMENT_ID,',')>
										<cfloop list="#attributes.DEPARTMENT_ID#" index="_depID_" delimiters=",">
											<td nowrap style="text-align:right;">
												<cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>
													<cfif isdefined('dep_stock_status_#replace(_depID_,'-','_')#_#STOCK_ID#')>
														<cfset real_stock = Evaluate('dep_stock_status_#replace(_depID_,'-','_')#_#STOCK_ID#')>
														<cfif real_stock lt 0><font color="red">#tlformat(real_stock)#</font><cfelse>#tlformat(real_stock)#</cfif>
													<cfelse>
														<cfset real_stock = 0>
														#tlformat(0)#
													</cfif>
												<cfelse>
													<cfif isdefined('dep_stock_status_#_depID_#_#STOCK_ID#')>
														<cfset real_stock = Evaluate('dep_stock_status_#_depID_#_#STOCK_ID#')>
														<cfif real_stock lt 0><font color="red">#tlformat(real_stock)#</font><cfelse>#tlformat(real_stock)#</cfif>
													<cfelse>
														<cfset real_stock = 0>
														#tlformat(0)#
													</cfif>
												</cfif>
											</td>
											<td nowrap style="text-align:right;">
												<cfif isdefined("demand_department_id") and len(demand_department_id) and demand_department_id eq _depID_><!--- xml den iç talep düşülecek depo girilmişse bu depoya eşitse --->
													<cfif isdefined('dept_demand_stock_#STOCK_ID#')>
														<cfset demand_amount = Evaluate('dept_demand_stock_#STOCK_ID#')>
													<cfelse>
														<cfset demand_amount = 0>
													</cfif>
												<cfelse>
													<cfset demand_amount = 0>
												</cfif>
												<cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>
													<cfif isdefined('stock_prod_rezerve_#replace(_depID_,'-','_')#_#STOCK_ID#')>
														<cfset prod_rezerv = Evaluate('stock_prod_rezerve_#replace(_depID_,'-','_')#_#STOCK_ID#')>
													</cfif>
												<cfelse>
													<cfif isdefined('stock_prod_rezerve_#_depID_#_#STOCK_ID#')>
														<cfset prod_rezerv = Evaluate('stock_prod_rezerve_#_depID_#_#STOCK_ID#')>
													</cfif>
												</cfif>
												<cfif isdefined('prod_rezerv')>
													<cfset active_stock = real_stock-prod_rezerv-demand_amount>
													<cfif active_stock lt 0><font color="red">#tlformat(active_stock)#</font><cfelse>#tlformat(active_stock)#</cfif>
												<cfelse>
													<cfset active_stock = real_stock-demand_amount>
													<cfif active_stock lt 0><font color="red">#tlformat(active_stock)#</font><cfelse>#tlformat(active_stock)#</cfif>
												</cfif>
												<cfif (isdefined("demand_department_id") and len(demand_department_id) and demand_department_id eq _depID_) or not (isdefined("demand_department_id") and len(demand_department_id))>
													<cfset row_all_active_stocks = row_all_active_stocks +active_stock>
												</cfif>
											</td>
											<cfif x_is_alternative_stock eq 1>
												<cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>
													<cfif isdefined('alternative_amount_#replace(_depID_,'-','_')#_#STOCK_ID#')>
														<cfset alternative_amount_ = Evaluate('alternative_amount_#replace(_depID_,'-','_')#_#STOCK_ID#')>
													<cfelse>
														<cfset alternative_amount_ = 0>
													</cfif>
												<cfelse>
													<cfif isdefined('alternative_amount_#_depID_#_#STOCK_ID#')>
														<cfset alternative_amount_ = Evaluate('alternative_amount_#_depID_#_#STOCK_ID#')>
													<cfelse>
														<cfset alternative_amount_ = 0>
													</cfif>
												</cfif>
												<td nowrap style="text-align:right;">
													<div class="nohover_div" style="margin-left:-300px;height:auto;position:absolute;" id="stock_detail#currentrow#"></div>
													<a style="cursor:pointer;" class="tableyazi" onClick="show_stock_detail(#currentrow#,#STOCK_ID#,#_depID_#);">
														#tlformat(alternative_amount_)#
													</a>
												</td>
											</cfif>
											<td style="text-align:right;">
												<cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>
													<cfset __depID = listfirst(_depID_,'-')>
												<cfelse>
													<cfset __depID = _depID_>
												</cfif>
												<cfif isdefined('dep_min_stock_#__depID#_#STOCK_ID#')>
													<cfset min_stock = Evaluate('dep_min_stock_#__depID#_#STOCK_ID#')>
													#tlformat(min_stock)#
												<cfelse>
													<cfset min_stock = 0 >
													#tlformat(0)#
												</cfif>
												<cfif (isdefined("demand_department_id") and len(demand_department_id) and demand_department_id eq _depID_) or not (isdefined("demand_department_id") and len(demand_department_id))>
													<cfset row_all_min_stocks = row_all_min_stocks+min_stock>
												</cfif>
											</td>
										</cfloop>
									<cfelse><!--- depo seçili değilse --->
										<td nowrap style="text-align:right;">
											<cfif isdefined('dep_stock_status_#STOCK_ID#')>
												<cfset real_stock = Evaluate('dep_stock_status_#STOCK_ID#')>
												<cfif real_stock lt 0><font color="red">#tlformat(real_stock)#</font><cfelse>#tlformat(real_stock)#</cfif>
											<cfelse>
												<cfset real_stock = 0>
												#tlformat(0)#
											</cfif>
										</td>
										<td nowrap style="text-align:right;">
											<cfset demand_amount = 0>
											<cfif isdefined('stock_prod_rezerve_#STOCK_ID#')>
												<cfset prod_rezerv = Evaluate('stock_prod_rezerve_#STOCK_ID#')>
												<cfset active_stock = real_stock-prod_rezerv-demand_amount>
												<cfif active_stock lt 0><font color="red">#tlformat(active_stock)#</font><cfelse>#tlformat(active_stock)#</cfif>
											<cfelse>
												<cfset active_stock = real_stock-demand_amount>
												<cfif active_stock lt 0><font color="red">#tlformat(active_stock)#</font><cfelse>#tlformat(active_stock)#</cfif>
											</cfif>
											<cfset row_all_active_stocks = row_all_active_stocks +active_stock>
										</td>
										<cfif x_is_alternative_stock eq 1>
											<cfif isdefined('alternative_amount_#STOCK_ID#')>
												<cfset alternative_amount_ = Evaluate('alternative_amount_#STOCK_ID#')>
											<cfelse>
												<cfset alternative_amount_ = 0>
											</cfif>
											<td nowrap style="text-align:right;">
												<div class="nohover_div" style="margin-left:-300px;height:auto;position:absolute;" id="stock_detail#currentrow#"></div>
												<a style="cursor:pointer;"  class="tableyazi" onClick="show_stock_detail(#currentrow#,#STOCK_ID#,0);">
													#tlformat(alternative_amount_)#
												</a>
											</td>
										</cfif>
										<td style="text-align:right;">
											<cfif isdefined('dep_min_stock_#STOCK_ID#')>
												<cfset min_stock = Evaluate('dep_min_stock_#STOCK_ID#')>
												#tlformat(min_stock)#
											<cfelse>
												<cfset min_stock = 0 >
												#tlformat(0)#
											</cfif>
											<cfset row_all_min_stocks = row_all_min_stocks+min_stock>
										</td>
									</cfif>
									<cfif isdefined("x_is_price") and x_is_price eq 1>
										<td nowrap style="text-align:right;">
											<cfif isdefined('product_price_#STOCK_ID#')>
												<cfset row_price =  Evaluate('product_price_#STOCK_ID#')>
												#tlformat(row_price)# &nbsp; #Evaluate('product_money_#STOCK_ID#')#
											<cfelse>
												<cfset row_price = 0 >
											</cfif>
										</td>
									<cfelse>
										<cfif isdefined('product_price_#STOCK_ID#')>
											<cfset row_price =  Evaluate('product_price_#STOCK_ID#')>
										<cfelse>
											<cfset row_price = 0 >
										</cfif>
									</cfif>
									<td nowrap style="text-align:right;">
										<div class="nohover_div" style="margin-left:-400px;height:auto;position:absolute;" id="show_rezerved_orders_detail#currentrow#"></div>
										<a style="cursor:pointer;" class="tableyazi" onClick="show_rezerved_orders_detail(#currentrow#,#STOCK_ID#,#attributes.department_id#);">
											<cfif isdefined('stock_order_res_#STOCK_ID#')>
												<cfset purchase_orders_amount = Evaluate('stock_order_res_#STOCK_ID#')>
												#tlformat(purchase_orders_amount)#
											<cfelse>
												<cfset purchase_orders_amount = 0>
												#tlformat(0)#
											</cfif>
										</a>
									</td>
									<td nowrap style="text-align:right;">
										<cfif isdefined('prod_bekleyen_#STOCK_ID#')>
											<cfset prod_beklenen = Evaluate('prod_bekleyen_#STOCK_ID#')>
											#tlformat(Evaluate('prod_bekleyen_#STOCK_ID#'))#
										<cfelse>
											<cfset prod_beklenen = 0>
											#tlformat(0)#
										</cfif>
									</td>
									<td nowrap style="text-align:right;">
										<cfif not len(attributes.production_order_no)>
											<cfset total_need = (purchase_orders_amount+row_all_active_stocks+prod_beklenen)-(row_all_min_stocks)>
										<cfelse>
											<cfset total_need = (purchase_orders_amount+row_all_active_stocks+prod_beklenen)-AMOUNT-(row_all_min_stocks)>
										</cfif>
											#tlformat(total_need)#
									</td>
									<td nowrap>
										#unit#
									</td>
									<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
										<td nowrap style="text-align:right;">
											<cfif total_need lt 0><cfset row_total_need = -1*total_need><cfelse><cfset row_total_need = 0></cfif>
											#tlformat(row_total_need)#
										</td>
										<cfif isdefined("x_is_price") and x_is_price eq 1>
											<td nowrap>#tlformat(row_total_need*row_price)#</td>
											<cfif not (isdefined("attributes.list_type") and attributes.list_type eq 4)>
												<td style="text-align:right;">
													<cfif isdefined('product_money_#get_metarials.STOCK_ID#') and len(Evaluate('product_money_#get_metarials.STOCK_ID#'))>
														#Evaluate('product_money_#get_metarials.STOCK_ID#')#
													</cfif>
												</td>
											</cfif>
										</cfif>
									<cfelse>
										<cfif total_need lt 0><cfset row_total_need = -1*total_need><cfelse><cfset row_total_need = 0></cfif>	
										<cfif attributes.is_bring_needed eq 1>
											<cfif row_total_need eq 0>
												<script> $("##row-"+#currentrow#).remove();</script>
												<cfset attributes.totalrecords = attributes.totalrecords - 1>
											</cfif>
										</cfif>
										<td nowrap style="text-align:right;">
											<cfif attributes.fuseaction contains 'autoexcelpopup'>
												#tlformat(row_total_need,real_stock_round_number)#
											<cfelse>
												<input type="text" name="row_total_need_" id="row_total_need_#currentrow#" value="#tlformat(row_total_need,real_stock_round_number)#" class="box" style="width:80px;" onKeyup="return(FormatCurrency(this,event));" onBlur="hesapla(#currentrow#);">
											</cfif>
										</td>
										<cfif isdefined("x_is_price") and x_is_price eq 1>
											<input type="hidden" name="row_price_unit_" id="row_price_unit_#currentrow#" value="#tlformat(row_price)#">
											<cfif attributes.fuseaction contains 'autoexcelpopup'>
												<td nowrap>#tlformat(row_total_need*row_price)#</td>
											<cfelse>
												<td nowrap style="text-align:right;">
													#tlformat(row_total_need*row_price)#
													<input type="hidden" name="row_price_" id="row_price_#currentrow#" value="#tlformat(row_total_need*row_price)#" class="box" style="width:80px;" onKeyup="return(FormatCurrency(this,event));">
												</td>
											</cfif>
											<td>
												<cfif isdefined('product_price_#STOCK_ID#')>
													<input type="hidden" name="row_stock_money_" id="row_stock_money_#currentrow#" value="#Evaluate('product_money_#STOCK_ID#')#" />
													#Evaluate('product_money_#STOCK_ID#')#
												</cfif>
											</td>
										<cfelse>
											<!-- sil -->
											<input type="hidden" name="row_price_unit_" id="row_price_unit_#currentrow#" value="#tlformat(row_price)#">
											<input type="hidden" name="row_price_#currentrow#" id="row_price_#currentrow#" value="#tlformat(row_total_need*row_price)#" onKeyup="return(FormatCurrency(this,event));">
											<select name="row_stock_money_" id="row_stock_money_#currentrow#" style="width:45px;display:none;">
												<cfloop query="get_money">
													<option value="#money#,#RATE2#"<cfif isdefined('product_money_#get_metarials.STOCK_ID#') and Evaluate('product_money_#get_metarials.STOCK_ID#') is money>selected</cfif>>#money#</option>
												</cfloop>
											</select>
											<!-- sil -->
										</cfif>
										<!-- sil -->
											<cfif not (isdefined("attributes.list_type") and attributes.list_type eq 4) and (isdefined("attributes.is_submitted") eq 1)>
												<td style="text-align:center;">
													<input type="hidden" name="quantity" id="quantity#currentrow#" value="#row_total_need#">
													<input type="checkbox" name="conversion_product" value="#stock_id#" id="conversion_product#currentrow#" onclick="control_quantity(#row_total_need#,#currentrow#)"><!--- onClick="aktif_yap();" --->													
												</td>
											</cfif>											
										<!-- sil -->
									</cfif>
								</tr>
								<!-- sil -->
									<cfif (isdefined("attributes.list_type") and attributes.list_type eq 4) and not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
										<tr id="material_stocks_detail#currentrow#" style="display:none">
											<td colspan="#colspan_#">
												<div align="left" id="DISPLAY_MATERIAL_STOCK_INFO#currentrow#"></div>
											</td>
										</tr>
									</cfif>
								<!-- sil -->
							</cfoutput>							
						</tbody> 
						<cfelse>
							<tr>
								<td colspan="<cfoutput>#colspan_#</cfoutput>" class="color-row" height="20">
									<cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id ='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id ='57701.Filtre Ediniz'></cfif>!
								</td>
							</tr>
						</cfif>
					<cfelse>
						<tr>
							<td colspan="<cfoutput>#colspan_#</cfoutput>" class="color-row" height="20">
								<cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id ='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id ='57701.Filtre Ediniz'></cfif>!
							</td>
						</tr>
					</cfif>
			</cf_grid_list>
		</cf_basket>
		<cfset adres = ''>
		<cfif isDefined("attributes.demand_no") and len(attributes.demand_no)>
			<cfset adres = "#adres#&demand_no=#attributes.demand_no#">
		</cfif>
		<cfif isDefined("attributes.production_order_no") and len(attributes.production_order_no)>
			<cfset adres = "#adres#&production_order_no=#attributes.production_order_no#">
		</cfif>
		<cfif isdate(attributes.start_date)>
			<cfset adres = "#adres#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
		</cfif>
		<cfif isdate(attributes.finish_date)>
			<cfset adres = "#adres#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
		</cfif>
		<cfif isdefined ("attributes.price_cat") and len(attributes.price_cat)>
			<cfset adres = "#adres#&price_cat=#attributes.price_cat#" >
		</cfif>
		<cfif isdefined ("attributes.company_id") and len(attributes.company_id)>
			<cfset adres = "#adres#&company_id=#attributes.company_id#&company=#attributes.company#" >
		</cfif>
		<cfif isdefined("attributes.is_submitted") and len (attributes.is_submitted)>
			<cfset adres = "#adres#&is_submitted=#attributes.is_submitted#" >
		</cfif>
		<cfif isdefined("attributes.product_id") and len(attributes.product_id)>
			<cfset adres = "#adres#&product_id=#attributes.product_id#">
		</cfif>
		<cfif isdefined("attributes.product_name") and len(attributes.product_name)>
			<cfset adres = "#adres#&product_name=#attributes.product_name#">
		</cfif>
		<cfif isdefined("attributes.product_code") and len(attributes.product_code)>
			<cfset adres = "#adres#&product_code=#attributes.product_code#">
		</cfif>
		<cfif isdefined("attributes.pos_code") and len(attributes.pos_code)>
			<cfset adres = "#adres#&pos_code=#attributes.pos_code#">
		</cfif>
		<cfif isdefined("attributes.pos_manager") and len(attributes.pos_manager)>
			<cfset adres = "#adres#&pos_manager=#attributes.pos_manager#">
		</cfif>
		<cfif isdefined("attributes.row_demand_all") and len(attributes.row_demand_all)>
			<cfset adres = "#adres#&row_demand_all=#attributes.row_demand_all#">
		</cfif>
		<cfif isdefined("attributes.list_type") and len(attributes.list_type)>
			<cfset adres = "#adres#&list_type=#attributes.list_type#">
		</cfif>
		<cfif isdefined("attributes.department_id") and len(attributes.department_id)>
			<cfset adres = "#adres#&department_id=#attributes.department_id#">
		</cfif>
		<cfif isdefined("attributes.product_code") and len(attributes.product_code)>
			<cfset adres = "#adres#&product_code=#attributes.product_code#">
		</cfif>
		<cfif isdefined("attributes.is_bring_needed") and len(attributes.is_bring_needed)>
			<cfset adres = "#adres#&is_bring_needed=#attributes.is_bring_needed#">
		</cfif>
		<cf_paging page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="prod.list_materials_total#adres#">
		<cfif attributes.page eq 1 and ((isdefined("stock_id_list_info1") and len(stock_id_list_info1)) or (isdefined("stock_id_list_info2") and len(stock_id_list_info2)))>
			<br/><table width="99%" border="0" cellspacing="1" cellpadding="2" align="center">
				<tr>
					<td class="headbold">
						<a href="javascript:connectAjax();">&raquo;<cf_get_lang dictionary_id ='36614.Bulunamayan Kayıtlar'></a>
					</td>
				</tr>
				<tr>
					<td>
						<div align="left" id="DISPLAY_ORDER_STOCK_INFO" style="display:none;"></div>
					</td>
				</tr>
			</table>	
		</cfif>
		<form name="aktar_form" method="post">
			<input type="hidden" name="list_price" id="list_price" value="0">
			<input type="hidden" name="price_cat" id="price_cat" value="">
			<input type="hidden" name="CATALOG_ID" id="CATALOG_ID" value="">
			<input type="hidden" name="NUMBER_OF_INSTALLMENT" id="NUMBER_OF_INSTALLMENT" value="">
			<input type="hidden" name="convert_stocks_id" id="convert_stocks_id" value="">
			<input type="hidden" name="convert_amount_stocks_id" id="convert_amount_stocks_id" value="">
			<input type="hidden" name="convert_price" id="convert_price" value="">
			<input type="hidden" name="convert_price_other" id="convert_price_other" value="">
			<input type="hidden" name="convert_money" id="convert_money" value="">
		</form>
	</cf_box>
	<cfif (not(isdefined('attributes.is_excel') and attributes.is_excel eq 1) and not (isdefined("attributes.list_type") and attributes.list_type eq 4)) and isdefined("attributes.is_submitted") and get_metarials.recordcount>
		<cf_box>
			<div class="ui-form-list-btn ui-info-bottom flex-end" style="border-top:none;">
				<div class="form-group">
					<a  href="javascript://" class="ui-wrk-btn ui-wrk-btn-extra" name="excelll" id="excelll" onClick="convert_to_excel();" ><cfoutput><i class="fa fa-file-excel-o"></i> <cf_get_lang dictionary_id ='57858.Excel Getir'></cfoutput></a>
						</div>
						<div class="form-group">
							<a  href="javascript://" class="ui-btn ui-btn-update" name="sevk_irsaliyesi" id="sevk_irsaliyesi" onClick="kota_kontrol(1);"  ><cfoutput><i class="fa fa-refresh"></i> <cf_get_lang dictionary_id ='36897.Sevk İrsaliyesine Dönüştür'></cfoutput></a>
							</div>
							<div class="form-group">
							<a  href="javascript://" class="ui-wrk-btn ui-wrk-btn-red" name="ambar_fisi" id="ambar_fisi" onClick="kota_kontrol(2);"  ><cfoutput><i class="icon-pencil-square-o"></i> <cf_get_lang dictionary_id ='36881.Stok Fişi Oluştur'></cfoutput></a>
							</div>
							<div class="form-group">
						<a  href="javascript://" class="ui-wrk-btn ui-wrk-btn-success" name="satin_alma_talebi" id="satin_alma_talebi" onClick="kota_kontrol(3);"  ><i class="fa fa-mail-forward"></i> <cfoutput>#getLang('correspondence','73')#</cfoutput></a>
					</div>
				</div>	
		</cf_box>
	</cfif>
</div>

<script type="text/javascript">
	function kontrol()
	{
		if(!$("#start_date").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id ='57655.Başlama Tarihi'></cfoutput>"})    
			return false;
		}
		if(!$("#finish_date").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id ='57700.Bitiş Tarihi'></cfoutput>"})    
			return false;
		}
		if(!$("#maxrows").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfoutput>"})    
			return false;
		}
		return true;
	}
	
	document.getElementById('demand_no').focus();
	function connectAjax()
	{
		if(DISPLAY_ORDER_STOCK_INFO.style.display == 'none')
		{
			DISPLAY_ORDER_STOCK_INFO.style.display = '';
			<cfif (isdefined("stock_id_list_info1") and len(stock_id_list_info1)) or (isdefined("stock_id_list_info2") and len(stock_id_list_info2))>
				AjaxPageLoad('<cfoutput>#request.self#?fuseaction=prod.emptypopup_list_materials_stock_info&stock_id_list_info1=#stock_id_list_info1#&stock_id_list_info2=#stock_id_list_info2#</cfoutput>','DISPLAY_ORDER_STOCK_INFO',1);
			</cfif>
		}
		else
		{
			DISPLAY_ORDER_STOCK_INFO.style.display = 'none'
		}
	}
	function connectAjax2(crtrow,stock_id)
	{
		var bb = '<cfoutput>#request.self#?fuseaction=prod.emptypopup_ajax_alternative_stock_info&deep_level_max=1&tree_stock_status=1</cfoutput>&crtrow='+crtrow+'&sid='+ stock_id;
		AjaxPageLoad(bb,'DISPLAY_MATERIAL_STOCK_INFO'+crtrow,1);
	}
	function open_file()
	{
		document.getElementById('material_file').style.display='';
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=prod.popup_add_material_file');
		return false;
	}
	function hesapla(stock_id)
	{
		document.getElementById('row_price_'+stock_id+'').value = commaSplit(parseFloat(document.getElementById('row_price_unit_'+stock_id+'').value*filterNum(document.getElementById('row_total_need_'+stock_id+'').value)));
	}
	function convert_to_excel()
	{
		document.list_meterials.is_excel.value = 1;
		list_meterials.action='<cfoutput>#request.self#?fuseaction=prod.emptypopup_list_materials_total</cfoutput>';
		list_meterials.submit();
		document.list_meterials.is_excel.value = 0;
		list_meterials.action='<cfoutput>#request.self#?fuseaction=prod.list_materials_total</cfoutput>';
		return true;
	}
	function show_rezerved_orders_detail(row_id,stock_id,department_id)
	{
		if(department_id==undefined)
		department_id='';
		document.getElementById('show_rezerved_orders_detail'+row_id+'').style.display='';
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_reserved_orders&listing_type=2&taken=0&dept_id='+department_id+'&sid='+stock_id+'&row_id='+row_id+'','show_rezerved_orders_detail'+row_id+'',1);
	}
	function show_stock_detail(row_id,stock_id,department_id)
	{
		document.getElementById('stock_detail'+row_id+'').style.display='';
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_stock_detail&taken=0&sid='+stock_id+'&row_id='+row_id+'&department_id='+department_id+'','stock_detail'+row_id+'',1);
	}
	function kota_kontrol(type)
		/*
		___Type__
		1:Sevk İrsaliyesi
		2:Ambar Fişi
		3:Satın Alma Talebi
		*/
	{
		 var convert_list ="";
		 var convert_list_amount ="";
		 var convert_list_price ="";
		 var convert_list_price_other="";
		 var convert_list_money ="";
		 /*<cfif isdefined("attributes.is_submitted")>
			 <cfoutput query="get_metarials" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				 if(document.all.conversion_product_#stock_id#.checked && filterNum(document.getElementById('row_total_need_#stock_id#').value) > 0)
				 {
					convert_list += "#stock_id#,";
					convert_list_amount += filterNum(document.getElementById('row_total_need_#stock_id#').value,3)+',';
					convert_list_price_other += filterNum(document.getElementById('row_price_unit_#stock_id#').value,3)+',';
					convert_list_price += list_getat(document.getElementById('row_stock_money_#stock_id#').value,2,',')*filterNum(document.getElementById('row_price_unit_#stock_id#').value,8)+',';
					convert_list_money += list_getat(document.getElementById('row_stock_money_#stock_id#').value,1,',')+',';
				 }
			 </cfoutput>
		</cfif>
		document.getElementById('convert_stocks_id').value=convert_list;
		document.getElementById('convert_amount_stocks_id').value=convert_list_amount;
		document.getElementById('convert_price').value=convert_list_price;
		document.getElementById('convert_price_other').value=convert_list_price_other;
		document.getElementById('convert_money').value=convert_list_money;*/
		
			for (var i=0; i < document.getElementsByName("conversion_product").length; i++)
			{
				if((document.getElementsByName("conversion_product")[i].checked==true)){
					convert_list = convert_list + document.getElementsByName("conversion_product")[i].value + "," ;
					convert_list_amount += filterNum(document.getElementsByName('row_total_need_')[i].value,3)+',';
					convert_list_price_other += filterNum(document.getElementsByName('row_price_unit_')[i].value,3)+',';
					convert_list_price += list_getat(document.getElementsByName('row_stock_money_')[i].value,2,',')*filterNum(document.getElementsByName('row_price_unit_')[i].value,8)+',';
					convert_list_money += list_getat(document.getElementsByName('row_stock_money_')[i].value,1,',')+',';
				
				}
			}
			document.getElementById('convert_stocks_id').value=convert_list;
			document.getElementById('convert_amount_stocks_id').value=convert_list_amount;
			document.getElementById('convert_price').value=convert_list_price;
			document.getElementById('convert_price_other').value=convert_list_price_other;
			document.getElementById('convert_money').value=convert_list_money;
			if(convert_list)//Ürün Seçili ise
			{
				if(type==1)
				{
					aktar_form.action="<cfoutput>#request.self#</cfoutput>?fuseaction=stock.add_ship_dispatch&type=convert";
					document.getElementById('sevk_irsaliyesi').disabled=true;
					aktar_form.target='_blank';
				}
				if(type==2)
				{
					aktar_form.action="<cfoutput>#request.self#</cfoutput>?fuseaction=stock.form_add_fis&type=convert";
					document.getElementById('ambar_fisi').disabled=true;
					aktar_form.target='_blank';
				}
				if(type==3)
				{
					aktar_form.action="<cfoutput>#request.self#</cfoutput>?fuseaction=purchase.list_internaldemand&event=add&type=convert&ref_no="+encodeURIComponent(document.getElementById('production_order_no').value);
					document.getElementById('satin_alma_talebi').disabled=true;
					aktar_form.target='_blank';
				}
				aktar_form.submit();
			}
			else
				alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id ='57657.Ürün'>.");
	}
function wrk_select_all2(all_conv_product,conversion_product,number,strttw)
{
	for(var cl_ind=strttw; cl_ind <= number; cl_ind++)
	{
		if(document.getElementById(all_conv_product).checked == true)
		{
			if($("#quantity"+cl_ind).val() != 0)
				{
					if(document.getElementById('conversion_product'+cl_ind) != undefined && document.getElementById('conversion_product'+cl_ind).checked == false)
					document.getElementById('conversion_product'+cl_ind).checked = true;
				}			
		}
		else
		{
			if(document.getElementById('conversion_product'+cl_ind) != undefined && document.getElementById('conversion_product'+cl_ind).checked == true)
				document.getElementById('conversion_product'+cl_ind).checked = false;
		}
	}
}
function control_quantity(quantity,id){
	if(quantity == 0){
		alert("<cf_get_lang dictionary_id='62447.Yeterli stok var! Yine de almak istiyorsanız bu üretim emrinden bağımsız olarak ilgili modülde talep açınız'>.");
		$('#conversion_product'+id).prop("checked",false);
	}
		
}
</script>