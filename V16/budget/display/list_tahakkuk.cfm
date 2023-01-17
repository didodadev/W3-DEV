<cfsetting showdebugoutput="NO">
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
<cfparam name="attributes.ch_member_type" default="">
<cfparam name="attributes.ch_company_id" default="">
<cfparam name="attributes.ch_consumer_id" default="">
<cfparam name="attributes.ch_employee_id" default="">
<cfparam name="attributes.ch_company" default="">
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
	<cfquery name="GET_THK_PLAN" datasource="#dsn3#">
		SELECT 
			BP.PAPER_NO,
			BP.RECORD_EMP,
			BP.PROCESS_CAT,
			BP.TAHAKKUK_PLAN_ID,
			<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
				BPR.TAHAKKUK_PLAN_ID,
				BPR.ROW_PLAN_DATE DATE,
				BP.DETAIL,
				BPR.ROW_EXPENSE_CENTER_ID EXP_INC_CENTER_ID,
				BPR.ROW_EXPENSE_ITEM_ID EXPENSE_ITEM_ID,
				BPR.ROW_TOTAL_EXPENSE INCOME,
				BPR.ROW_TOTAL_EXPENSE EXPENSE,
				BPR.ROW_OTHER_TOTAL_EXPENSE OTHER_INCOME,
				BPR.ROW_OTHER_TOTAL_EXPENSE OTHER_EXPENSE,
				--BPR.ROW_ACCOUNT_CODE,
				BP.MONTH_ACCOUNT_CODE ROW_ACCOUNT_CODE,
				BPR.ROW_OTHER_MONEY,
			<cfelse>
				BP.EXPENSE_TOTAL INCOME,
				BP.EXPENSE_TOTAL EXPENSE,
				BP.OTHER_EXPENSE_TOTAL OTHER_INCOME,
				BP.OTHER_EXPENSE_TOTAL OTHER_EXPENSE,
				BP.START_DATE DATE,
				BP.START_DATE,
				BP.FINISH_DATE,
				BP.DETAIL,
				BP.ACCOUNT_CODE,
			</cfif>
			BP.OTHER_MONEY
		FROM
			TAHAKKUK_PLAN BP
			<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
				,TAHAKKUK_PLAN_ROW BPR
			</cfif>
		WHERE
			<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
				BP.TAHAKKUK_PLAN_ID = BPR.TAHAKKUK_PLAN_ID AND 
			</cfif>
			BP.PROCESS_CAT IN (SELECT PROCESS_CAT_ID FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN(160,161))
			AND BP.PERIOD_ID = #session.ep.period_id#
			<cfif len(attributes.keyword)>
				<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
					AND (BP.DETAIL LIKE #sql_unicode()#'%#attributes.keyword#%'
					OR BPR.ROW_EXPENSE_ITEM_ID IN (SELECT EXPENSE_ITEM_ID FROM #dsn2_alias#.EXPENSE_ITEMS WHERE EXPENSE_ITEM_NAME LIKE #sql_unicode()#'%#attributes.keyword#%')
					OR BPR.ROW_EXPENSE_CENTER_ID IN (SELECT EXPENSE_ID FROM #dsn2_alias#.EXPENSE_CENTER WHERE EXPENSE LIKE #sql_unicode()#'%#attributes.keyword#%'))
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
					AND BPR.ROW_PLAN_DATE >= #attributes.search_date1#
				<cfelse>
					AND BP.START_DATE >= #attributes.search_date1#
				</cfif>
			</cfif>
			<cfif len(attributes.search_date2)>
				<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
					AND BPR.ROW_PLAN_DATE <= #attributes.search_date2#
				<cfelse>
					AND BP.FINISH_DATE <= #attributes.search_date2#
				</cfif>
			</cfif>
			<cfif len(attributes.employee_id)  and len(attributes.employee_name)>
				AND BP.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
			</cfif>
			<cfif attributes.ch_member_type is 'partner' and len(attributes.ch_company_id) and len(attributes.ch_company)>
				AND BP.COMPANY_ID = #attributes.ch_company_id#
			<cfelseif attributes.ch_member_type is 'consumer' and len(attributes.ch_consumer_id) and len(attributes.ch_company)>
				AND BP.CONSUMER_ID = #attributes.ch_consumer_id#
			<cfelseif attributes.ch_member_type is 'employee' and len(attributes.ch_employee_id) and len(attributes.ch_company)>
				AND BP.EMPLOYEE_ID = #attributes.ch_employee_id#
			</cfif>
		ORDER BY 
			BP.PAPER_NO
	</cfquery>
<cfelse>
	<cfset GET_THK_PLAN.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >
<cfparam name="attributes.totalrecords" default="#get_thk_plan.recordcount#">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="list_rows" method="post" action="#request.self#?fuseaction=budget.list_tahakkuk">
			<cf_box_search>
				<div class="form-group">
					<input type="hidden" name="form_submitted" id="form_submitted" value="1">
					<cfinput type="text" name="keyword" maxlength="50" placeholder="#getLang(48,'Filtre',57460)#" value="#attributes.keyword#">
				</div>
				<div class="form-group">
					<cfinput type="text" maxlength="50" name="paper_no" placeholder="#getLang(468,'Belge No',57880)#" value="#attributes.paper_no#">
				</div>
				<div class="form-group">
						<div class="input-group">
							<input type="hidden" name="ch_member_type" id="ch_member_type" value="<cfoutput>#attributes.ch_member_type#</cfoutput>">
							<input type="hidden" name="ch_company_id" id="ch_company_id" value="<cfif isdefined("attributes.ch_company_id") and len(attributes.ch_company_id) and isdefined("attributes.ch_member_type") and len(attributes.ch_member_type) and attributes.ch_member_type is 'partner'><cfoutput>#attributes.ch_company_id#</cfoutput></cfif>">
							<input type="hidden" name="ch_consumer_id" id="ch_consumer_id" value="<cfif isdefined("attributes.ch_consumer_id") and len(attributes.ch_consumer_id) and isdefined("attributes.ch_member_type") and len(attributes.ch_member_type) and attributes.ch_member_type is 'consumer'><cfoutput>#attributes.ch_consumer_id#</cfoutput></cfif>">
							<input type="hidden" name="ch_employee_id"  id="ch_employee_id"value="<cfif isdefined("attributes.ch_employee_id") and len(attributes.ch_employee_id) and isdefined("attributes.ch_member_type") and len(attributes.ch_member_type) and attributes.ch_member_type is 'employee'><cfoutput>#attributes.ch_employee_id#</cfoutput></cfif>">
							<input type="text" placeholder="<cfoutput>#getLang(107,'Cari Hesap',57519)#</cfoutput>" name="ch_company" id="ch_company" onFocus="AutoComplete_Create('ch_company','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'1\',\'0\',\'0\',\'2\',\'0\',\'0\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','ch_company_id,ch_consumer_id,ch_employee_id,ch_member_type','','3','225');" value="<cfif  isdefined("attributes.ch_company") and len(attributes.ch_company)><cfoutput>#attributes.ch_company#</cfoutput></cfif>" autocomplete="off">
							<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_name=list_rows.ch_company&is_cari_action=1&field_type=list_rows.ch_member_type&field_comp_name=list_rows.ch_company&field_consumer=list_rows.ch_consumer_id&field_emp_id=list_rows.ch_employee_id&field_comp_id=list_rows.ch_company_id&select_list=2,3,1,9</cfoutput>');" title="<cfoutput>#getLang(107,'Cari Hesap',57519)#</cfoutput>"></span>
						</div>
				</div>
				<div class="form-group">
					<select name="listing_type" id="listing_type">
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
					<div class="form-group" id="item-employee_id">
						<label class="col col-12"><cfoutput>#getLang(487,'Kaydeden',57899)#</cfoutput></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="employee_id" id="employee_id" value="<cfif len(attributes.employee_name)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
								<input type="text" name="employee_name" id="employee_name" onFocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','135');" value="<cfif len(attributes.employee_id) and len(attributes.employee_name)><cfoutput>#get_emp_info(attributes.employee_id,0,0)#</cfoutput></cfif>" autocomplete="off">
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=list_rows.employee_id&field_name=list_rows.employee_name&select_list=1&keyword='+encodeURIComponent(document.list_rows.employee_name.value));return false" title="<cfoutput>#getLang(487,'Kaydeden',57899)#</cfoutput>"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-budget_name">
						<label class="col col-12"><cfoutput>#getLang(467,'İşlem Tarihi',57879)#</cfoutput></label>
						<div class="col col-12">
							<div class="col col-6">
								<div class="input-group">
									<cfinput type="text" name="search_date1" value="#dateformat(attributes.search_date1,dateformat_style)#" maxlength="10" validate="#validate_style#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="search_date1"></span>
								</div>
							</div>
							<div class="col col-6">
								<div class="input-group">
									<cfinput type="text" name="search_date2" value="#dateformat(attributes.search_date2,dateformat_style)#" maxlength="10" validate="#validate_style#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="search_date2"></span>
								</div>
							</div>
						</div>
					</div>
				</div>  
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true" style="display:none;">
					<div class="form-group" id="item-budget_action_type">
						<label class="col col-12"><cfoutput>#getLang(388,'İşlem Tipi',57800)#</cfoutput></label>
						<div class="col col-12">
							<select name="budget_action_type" id="budget_action_type">
								<option value=""><cfoutput>#getLang(322,'Seçiniz',57734)#</cfoutput></option>
								<cfoutput query="get_process_cat">
									<option value="#process_cat_id#" <cfif attributes.budget_action_type eq process_cat_id>selected</cfif>>#process_cat#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform> 
	</cf_box>   
	<cfsavecontent variable="title"><cf_get_lang dictionary_id="36205.Tahakkuk Planlama"></cfsavecontent>
	<cf_box title="#title#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>             
				<tr>
					<th width="30" rowspan="2"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th rowspan="2"><cf_get_lang dictionary_id='57880.Belge No'></th>
					<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 1)>
						<th rowspan="2"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></th>
						<th rowspan="2"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
					</cfif>
					<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)>
						<th rowspan="2"><cf_get_lang dictionary_id='57742.Tarih'></th>
					</cfif>
					<th rowspan="2"><cf_get_lang dictionary_id='57629.Aciklama'></th>
					<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
						<!--- <th rowspan="2" nowrap="nowrap"><cf_get_lang dictionary_id='823.Masraf/Gelir Merkezi'></th> --->
						<th rowspan="2" nowrap="nowrap"><cf_get_lang dictionary_id='58234.Butce Kalemi'></th>
						<th rowspan="2" nowrap="nowrap"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></th>
					</cfif>
					<th rowspan="2"><cf_get_lang dictionary_id='57800.İşlem Tipi'></th>
					<th rowspan="2"><cf_get_lang dictionary_id='57899.Kaydeden'></th>
					<th class="text-center"><cf_get_lang dictionary_id='58905.Sistem Dövizi'></th>
					<th class="text-center"><cf_get_lang dictionary_id='58121.İşlem Dövizi'></th>
					<th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
					<!-- sil -->
					<th width="20" class="header_icn_none text-center" nowrap="nowrap" rowspan="2">
						<a href="<cfoutput>#request.self#?fuseaction=budget.list_tahakkuk&event=add</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
					</th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_thk_plan.recordcount>
					<cfset record_emp_list = "">
					<cfset budget_id_list = "">
					<cfset process_cat_list = "">
					<cfset budget_item_id_list = "">
					<cfset exp_inc_center_id_list = "">
					<cfoutput query="get_thk_plan" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(record_emp) and not listfind(record_emp_list,record_emp)>
							<cfset record_emp_list=listappend(record_emp_list,record_emp)>
						</cfif>
						<cfif len(process_cat) and not listfind(process_cat_list,process_cat)>
							<cfset process_cat_list=listappend(process_cat_list,process_cat)>
						</cfif>
						<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
							<cfif len(exp_inc_center_id) and not listfind(exp_inc_center_id_list,exp_inc_center_id)>
								<cfset exp_inc_center_id_list=listappend(exp_inc_center_id_list,exp_inc_center_id)>
							</cfif>
							<cfif len(EXPENSE_ITEM_ID) and not listfind(budget_item_id_list,EXPENSE_ITEM_ID)>
								<cfset budget_item_id_list=listappend(budget_item_id_list,EXPENSE_ITEM_ID)>
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
					<cfoutput query="get_thk_plan" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td><a href="#request.self#?fuseaction=budget.list_tahakkuk&event=upd&tplan_id=#tahakkuk_plan_id#">#PAPER_NO#</a></td>
							<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 1)>
								<td>#dateformat(start_date,dateformat_style)#</td>
								<td>#dateformat(finish_date,dateformat_style)#</td>
							</cfif>
							<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)>
								<td>#dateformat(date,dateformat_style)#</td>
							</cfif>
							<td>#detail#</td>					
							<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
								<!--- <td>#get_exp_inc_center_name.expense[listfind(exp_inc_center_id_list,exp_inc_center_id,',')]#</td> --->
								<td>#get_exp_detail.expense_item_name[listfind(budget_item_id_list,EXPENSE_ITEM_ID,',')]#</td>
								<td>#ROW_ACCOUNT_CODE#</td>
							</cfif>
							<td>
								<cfif len(process_cat)>
									#get_process.process_cat[listfind(process_cat_list,process_cat,',')]#
								</cfif>
							</td>
							<td>
								<cfif len(record_emp)>
									<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');">
										#get_emp.employee_name[listfind(record_emp_list,record_emp,',')]#&nbsp;#get_emp.employee_surname[listfind(record_emp_list,record_emp,',')]#
									</a>
								</cfif>
							</td>
							<td class="text-right">#TLFormat(EXPENSE)#</td>
							<td class="text-right">#TLFormat(OTHER_EXPENSE)#</td>
							<td>#other_money#</td>
							<!-- sil --><td><a href="#request.self#?fuseaction=budget.list_tahakkuk&event=upd&tplan_id=#tahakkuk_plan_id#"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td><!-- sil -->
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
		<cfif len(attributes.ch_member_type)>
			<cfset url_str = "#url_str#&ch_member_type=#attributes.ch_member_type#">
		</cfif>
		<cfif len(attributes.ch_company_id)>
			<cfset url_str = "#url_str#&ch_company_id=#attributes.ch_company_id#">
		</cfif>
		<cfif len(attributes.ch_consumer_id)>
			<cfset url_str = "#url_str#&ch_consumer_id=#attributes.ch_consumer_id#">
		</cfif>
		<cfif len(attributes.ch_company)>
			<cfset url_str = "#url_str#&ch_company=#attributes.ch_company#">
		</cfif>
		<cfif len(attributes.ch_employee_id)>
			<cfset url_str = "#url_str#&ch_employee_id=#attributes.ch_employee_id#">
		</cfif>
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="budget.list_tahakkuk#url_str#">
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>