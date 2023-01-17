<cf_xml_page_edit fuseact="budget.add_budget_plan">
<cfsetting showdebugoutput="yes">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.budget_name" default="">
<cfparam name="attributes.budget_id" default="">
<cfparam name="attributes.paper_no" default="">
<cfparam name="attributes.budget_action_type" default="">
<cfparam name="attributes.search_date1" default="">
<cfparam name="attributes.search_date2" default="">
<cfparam name="attributes.listing_type" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfif len(attributes.search_date1)>
	<cf_date tarih='attributes.search_date1'>
</cfif>
<cfif len(attributes.search_date2)>
	<cf_date tarih='attributes.search_date2'>
</cfif>
<cfquery name="get_process_cat" datasource="#dsn3#">
	SELECT PROCESS_CAT,PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (160,161)
</cfquery>
<cfif isDefined("attributes.form_submitted")>
	<cfquery name="GET_BUDGET_PLAN" datasource="#dsn#">
		SELECT 
			BP.PAPER_NO,
			BP.RECORD_EMP,
			BP.PROCESS_CAT,
			BP.BUDGET_ID,
			BP.BUDGET_PLAN_ID,
			<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
				BPR.BUDGET_PLAN_ID,
				BPR.PLAN_DATE DATE,
				BPR.DETAIL,
				BPR.EXP_INC_CENTER_ID,
				BPR.BUDGET_ITEM_ID,
				BPR.ROW_TOTAL_INCOME INCOME,
				BPR.ROW_TOTAL_EXPENSE EXPENSE,
				BPR.OTHER_ROW_TOTAL_INCOME OTHER_INCOME,
				BPR.OTHER_ROW_TOTAL_EXPENSE OTHER_EXPENSE,
				EI.ACCOUNT_CODE,
				BPR.BUDGET_ACCOUNT_CODE,
			<cfelse>
				BP.INCOME_TOTAL INCOME,
				BP.EXPENSE_TOTAL EXPENSE,
				BP.OTHER_INCOME_TOTAL OTHER_INCOME,
				BP.OTHER_EXPENSE_TOTAL OTHER_EXPENSE,
				BP.BUDGET_PLAN_DATE DATE,
				BP.DETAIL,
			</cfif>
			BP.OTHER_MONEY
		FROM
			BUDGET_PLAN BP
			<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
				,BUDGET_PLAN_ROW BPR
				 LEFT JOIN #dsn2_alias#.EXPENSE_ITEMS EI ON BPR.BUDGET_ITEM_ID = EI.EXPENSE_ITEM_ID
			</cfif>
		WHERE
			<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
				BP.BUDGET_PLAN_ID = BPR.BUDGET_PLAN_ID AND 
			</cfif>
			BP.PROCESS_CAT IN (SELECT PROCESS_CAT_ID FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN(160,161))
			AND BP.PERIOD_ID = #session.ep.period_id#
			AND BP.OUR_COMPANY_ID = #session.ep.company_id#
			<cfif len(attributes.keyword)>
				<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
					AND (BPR.DETAIL LIKE #sql_unicode()#'%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
					OR BPR.BUDGET_ITEM_ID IN (SELECT EXPENSE_ITEM_ID FROM #dsn2_alias#.EXPENSE_ITEMS WHERE EXPENSE_ITEM_NAME LIKE #sql_unicode()#'%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI)
					OR BPR.EXP_INC_CENTER_ID IN (SELECT EXPENSE_ID FROM #dsn2_alias#.EXPENSE_CENTER WHERE EXPENSE LIKE #sql_unicode()#'%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI))
				</cfif>
			</cfif>
			<cfif len(attributes.paper_no)>
				AND BP.PAPER_NO LIKE '%#attributes.paper_no#%'
			</cfif>
			<cfif len(attributes.budget_action_type)>
				AND BP.PROCESS_CAT = #attributes.budget_action_type#
			</cfif>
			<cfif len(attributes.search_date1)>
				<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
					AND BPR.PLAN_DATE >= #attributes.search_date1#
				<cfelse>
					AND BP.BUDGET_PLAN_DATE >= #attributes.search_date1#
				</cfif>
			</cfif>
			<cfif len(attributes.search_date2)>
				<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
					AND BPR.PLAN_DATE <= #attributes.search_date2#
				<cfelse>
					AND BP.BUDGET_PLAN_DATE <= #attributes.search_date2#
				</cfif>
			</cfif>
			<cfif len(attributes.budget_name) and len(attributes.budget_id)>
				AND BP.BUDGET_ID = #attributes.budget_id#
			</cfif>
			<cfif len(attributes.employee_id)  and len(attributes.employee_name)>
				AND RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
			</cfif>
		ORDER BY 
			BP.PAPER_NO
	</cfquery>
<cfelse>
	<cfset GET_BUDGET_PLAN.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >
<cfparam name="attributes.totalrecords" default="#get_budget_plan.recordcount#">

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="list_rows" method="post" action="#request.self#?fuseaction=budget.list_plan_rows&form_submitted=1">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="keyword" maxlength="50" placeholder="#getLang(48,'Filtre',57460)#" value="#attributes.keyword#">
				</div>
				<div class="form-group">
					<cfinput type="text" maxlength="50" name="paper_no" placeholder="#getLang(468,'Belge No',57880)#" value="#attributes.paper_no#">
				</div>
				<div class="form-group">
					<select name="listing_type" id="listing_type" style="width:100px;">
						<option value="1" <cfif attributes.listing_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57660.Belge Bazında'></option>
						<option value="2" <cfif attributes.listing_type eq 2>selected</cfif>><cf_get_lang dictionary_id='29539.Satır Bazında'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" onKeyUp="isNumber(this)" required="yes" validate="integer" range="1,999" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-budget_name">
						<label class="col col-12 col-xs-12"><cfoutput>#getLang(147,'Bütçe',57559)#</cfoutput></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="text" name="budget_name" id="budget_name" style="width:110px;" value="<cfoutput>#attributes.budget_name#</cfoutput>">
								<input type="hidden" name="budget_id" id="budget_id" value="<cfoutput>#attributes.budget_id#</cfoutput>">
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_budget&field_id=list_rows.budget_id&field_name=list_rows.budget_name','list');return false" title="<cfoutput>#getLang(147,'Bütçe',57559)#</cfoutput>"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-budget_action_type">
						<label class="col col-12 col-xs-12"><cfoutput>#getLang(388,'İşlem Tipi',57800)#</cfoutput></label>
						<div class="col col-12">
							<select name="budget_action_type" id="budget_action_type" style="width:100px;">
								<option value=""><cfoutput>#getLang(322,'Seçiniz',57734)#</cfoutput></option>
								<cfoutput query="get_process_cat">
									<option value="#process_cat_id#" <cfif attributes.budget_action_type eq process_cat_id>selected</cfif>>#process_cat#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-employee_id">
						<label class="col col-12 col-xs-12"><cfoutput>#getLang(487,'Kaydeden',57899)#</cfoutput></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="employee_id" id="employee_id" value="<cfif len(attributes.employee_name)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
								<input type="text" name="employee_name" id="employee_name" onFocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','135');" value="<cfif len(attributes.employee_id) and len(attributes.employee_name)><cfoutput>#get_emp_info(attributes.employee_id,0,0)#</cfoutput></cfif>" autocomplete="off">
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=list_rows.employee_id&field_name=list_rows.employee_name&select_list=1&keyword='+encodeURIComponent(document.list_rows.employee_name.value),'list');return false" title="<cfoutput>#getLang(487,'Kaydeden',57899)#</cfoutput>"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
					<div class="form-group" id="item-budget_name">
						<label class="col col-12 col-xs-12"><cfoutput>#getLang(467,'İşlem Tarihi',57879)#</cfoutput></label>
						<div class="col col-12">
							<div class="input-group">
								<cfinput type="text" name="search_date1" value="#dateformat(attributes.search_date1,dateformat_style)#" maxlength="10" validate="#validate_style#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="search_date1"></span>
								<cfinput type="text" name="search_date2" value="#dateformat(attributes.search_date2,dateformat_style)#" maxlength="10" validate="#validate_style#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="search_date2"></span>
							</div>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>     
	</cf_box>
	<cfsavecontent variable = "message"><cf_get_lang dictionary_id='49111.Planlama/Tahakkuk Fişleri'></cfsavecontent>  
	<cf_box title="#message#" uidrop="1"  hide_table_column="1" woc_setting = "#{ checkbox_name : 'print_plan_id', print_type : 331 }#">
		<cf_grid_list>
			<thead>             
				<tr>
					<th width="20" rowspan="2"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th rowspan="2"><cf_get_lang dictionary_id='57880.Belge No'></th>
					<th rowspan="2"><cf_get_lang dictionary_id='57742.Tarih'></th>
					<th rowspan="2"><cf_get_lang dictionary_id='57629.Aciklama'></th>
					<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
						<th rowspan="2" nowrap="nowrap"><cf_get_lang dictionary_id='58235.Masraf/Gelir Merkezi'></th>
						<th rowspan="2" nowrap="nowrap"><cf_get_lang dictionary_id='58234.Butce Kalemi'></th>
						<th rowspan="2" nowrap="nowrap"><cf_get_lang dictionary_id='60661.Bütçe Kalemi Muhasebe Kodu'></th>
						<th rowspan="2" nowrap="nowrap"><cf_get_lang dictionary_id='60662.Satır Muhasebe Kodu'></th>
					</cfif>
					<th rowspan="2"><cf_get_lang dictionary_id='57800.İşlem Tipi'></th>
					<th rowspan="2"><cf_get_lang dictionary_id='57559.Bütçe'></th>
					<th rowspan="2"><cf_get_lang dictionary_id='57899.Kaydeden'></th>
					<th colspan="2" style="text-align:center"><cf_get_lang dictionary_id='58905.Sistem Dövizi'></th>
					<th colspan="3" style="text-align:center"><cf_get_lang dictionary_id='58121.İşlem Dövizi'></th>
					<!-- sil -->
					<th class="header_icn_none" width="20" nowrap="nowrap" rowspan="2">
						<a href="<cfoutput>#request.self#?fuseaction=budget.list_plan_rows&event=add</cfoutput>"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id="49172.Gelir/Gider Planı Ekle">" title="<cf_get_lang dictionary_id="49172.Gelir/Gider Planı Ekle">"></i></a>
					</th>
					<cfif get_budget_plan.recordcount>
						<th width="20" nowrap="nowrap" class="text-center header_icn_none"  rowspan="2">
							<cfif get_budget_plan.recordcount eq 1><a href="javascript://" onclick="send_print_reset();"><i class="fa fa-print" alt="<cf_get_lang dictionary_id='57389.Print Sayisi Sifirla'>" title="<cf_get_lang dictionary_id='57389.Print Sayisi Sifirla'>"></i></a></cfif>
							<input type="checkbox" name="allSelectDemand" id="allSelectDemand" onclick="wrk_select_all('allSelectDemand','print_plan_id');">
						</th>
					</cfif>	
					<!-- sil -->
				</tr>
				<tr>
					<th width="80" style="text-align:right;"><cf_get_lang dictionary_id='58677.Gelir'></th>
					<th width="80" style="text-align:right;"><cf_get_lang dictionary_id='58678.Gider'></th>
					<th width="80" style="text-align:right;"><cf_get_lang dictionary_id='58677.Gelir'></th>
					<th width="80" style="text-align:right;"><cf_get_lang dictionary_id='58678.Gider'></th>
					<th width="80"><cf_get_lang dictionary_id='58121.İşlem Dövizi'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_budget_plan.recordcount>
					<cfset record_emp_list = "">
					<cfset budget_id_list = "">
					<cfset process_cat_list = "">
					<cfset budget_item_id_list = "">
					<cfset exp_inc_center_id_list = "">
					<cfoutput query="get_budget_plan" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(record_emp) and not listfind(record_emp_list,record_emp)>
							<cfset record_emp_list=listappend(record_emp_list,record_emp)>
						</cfif>
						<cfif len(budget_id) and not listfind(budget_id_list,budget_id)>
							<cfset budget_id_list=listappend(budget_id_list,budget_id)>
						</cfif>
						<cfif len(process_cat) and not listfind(process_cat_list,process_cat)>
							<cfset process_cat_list=listappend(process_cat_list,process_cat)>
						</cfif>
						<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
							<cfif len(exp_inc_center_id) and not listfind(exp_inc_center_id_list,exp_inc_center_id)>
								<cfset exp_inc_center_id_list=listappend(exp_inc_center_id_list,exp_inc_center_id)>
							</cfif>
							<cfif len(budget_item_id) and not listfind(budget_item_id_list,budget_item_id)>
								<cfset budget_item_id_list=listappend(budget_item_id_list,budget_item_id)>
							</cfif>
						</cfif>
					</cfoutput>
					<cfif len(record_emp_list)>
						<cfset record_emp_list=listsort(record_emp_list,"numeric","ASC",",")>
						<cfquery name="get_emp" datasource="#dsn#">
							SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#record_emp_list#) ORDER BY EMPLOYEE_ID
						</cfquery>
						<cfset record_emp_list = listsort(listdeleteduplicates(valuelist(get_emp.employee_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(budget_id_list)>
						<cfset budget_id_list=listsort(budget_id_list,"numeric","ASC",",")>
						<cfquery name="get_budget" datasource="#dsn#">
							SELECT BUDGET_NAME,BUDGET_ID,DETAIL FROM BUDGET WHERE BUDGET_ID IN (#budget_id_list#) ORDER BY BUDGET_ID
						</cfquery>
						<cfset budget_id_list = listsort(listdeleteduplicates(valuelist(get_budget.budget_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(process_cat_list)>
						<cfset process_cat_list=listsort(process_cat_list,"numeric","ASC",",")>
						<cfquery name="get_process" datasource="#dsn3#">
							SELECT PROCESS_CAT,PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID IN (#process_cat_list#) ORDER BY PROCESS_CAT_ID
						</cfquery>
						<cfset process_cat_list = listsort(listdeleteduplicates(valuelist(get_process.process_cat_id,',')),'numeric','ASC',',')>
					</cfif>
					<!--- masraf/gelir merkezleri --->
					<cfif len(exp_inc_center_id_list)>
						<cfset exp_inc_center_id_list=listsort(exp_inc_center_id_list,"numeric","ASC",",")>
						<cfquery name="get_exp_inc_center_name" datasource="#dsn2#">
							SELECT 
								EXPENSE,
								EXPENSE_ID
							FROM 
								EXPENSE_CENTER
							WHERE 
								EXPENSE_ID IN (#exp_inc_center_id_list#) 
							ORDER BY 
								EXPENSE_ID
						</cfquery>
						<cfset exp_inc_center_id_list = listsort(listdeleteduplicates(valuelist(get_exp_inc_center_name.expense_id,',')),'numeric','ASC',',')>
					</cfif>
					<!--- butce kalemleri --->
					<cfif len(budget_item_id_list)>
						<cfset budget_item_id_list=listsort(budget_item_id_list,"numeric","ASC",",")>
						<cfquery name="get_exp_detail" datasource="#dsn2#">
							SELECT 
								EXPENSE_ITEM_NAME,
								EXPENSE_ITEM_ID
							FROM 
								EXPENSE_ITEMS
							WHERE 
								EXPENSE_ITEM_ID IN (#budget_item_id_list#) 
							ORDER BY 
								EXPENSE_ITEM_ID
						</cfquery>
						<cfset budget_item_id_list = listsort(listdeleteduplicates(valuelist(get_exp_detail.expense_item_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfoutput query="get_budget_plan" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td><a href="#request.self#?fuseaction=budget.list_plan_rows&event=upd&budget_plan_id=#budget_plan_id#" class="tableyazi">#PAPER_NO#</a></td>
							<td>#dateformat(date,dateformat_style)#</td>
							<td>#detail#</td>					
							<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
								<td>#get_exp_inc_center_name.expense[listfind(exp_inc_center_id_list,exp_inc_center_id,',')]#</td>
								<td>#get_exp_detail.expense_item_name[listfind(budget_item_id_list,budget_item_id,',')]#</td>
								<td>#ACCOUNT_CODE#</td>
								<td>#BUDGET_ACCOUNT_CODE#</td>
							</cfif>
							<td>
								<cfif len(process_cat)>
									#get_process.process_cat[listfind(process_cat_list,process_cat,',')]#
								</cfif>
							</td>
							<td>
								<cfif len(budget_id)>
									#get_budget.budget_name[listfind(budget_id_list,budget_id,',')]#
								</cfif>
							</td>
							<td>
								<cfif len(record_emp)>
									<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');" class="tableyazi">
										#get_emp.employee_name[listfind(record_emp_list,record_emp,',')]#&nbsp;#get_emp.employee_surname[listfind(record_emp_list,record_emp,',')]#
									</a>
								</cfif>
							</td>
							<td style="text-align:right;">#TLFormat(INCOME)#</td>
							<td style="text-align:right;">#TLFormat(EXPENSE)#</td>
							<td style="text-align:right;">#TLFormat(OTHER_INCOME)#</td>
							<td style="text-align:right;">#TLFormat(OTHER_EXPENSE)#</td>
							<td>#other_money#</td>
							<!-- sil --><td><a href="#request.self#?fuseaction=budget.list_plan_rows&event=upd&budget_plan_id=#budget_plan_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
								<td style="text-align:center"><input type="checkbox" name="print_plan_id" id="print_plan_id"  value="#budget_plan_id#"></td>
								<!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="15"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>

		<cfset url_str = "">
		<cfif isDefined("attributes.form_submitted")>
			<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
		</cfif>
		<cfif len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif len(attributes.paper_no)>
			<cfset url_str = "#url_str#&paper_no=#attributes.paper_no#">
		</cfif>
		<cfif len(attributes.budget_action_type)>
			<cfset url_str = "#url_str#&budget_action_type=#attributes.budget_action_type#">
		</cfif>
		<cfif len(attributes.budget_id)>
			<cfset url_str = "#url_str#&budget_id=#attributes.budget_id#">
		</cfif>
		<cfif len(attributes.budget_name)>
			<cfset url_str = "#url_str#&budget_name=#attributes.budget_name#">
		</cfif>
		<cfif len(attributes.search_date1)>
			<cfset url_str = "#url_str#&search_date1=#dateformat(attributes.search_date1,dateformat_style)#">
		</cfif>
		<cfif len(attributes.search_date2)>
			<cfset url_str = "#url_str#&search_date2=#dateformat(attributes.search_date2,dateformat_style)#">
		</cfif>
		<cfif len(attributes.employee_id)>
			<cfset url_str = "#url_str#&employee_id=#attributes.employee_id#">
		</cfif>
		<cfif len(attributes.employee_name)>
			<cfset url_str = "#url_str#&employee_name=#attributes.employee_name#">
		</cfif>
		<cfif len(attributes.listing_type)>
			<cfset url_str = "#url_str#&listing_type=#attributes.listing_type#">
		</cfif>
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="budget.list_plan_rows#url_str#">
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
