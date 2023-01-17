<cf_get_lang_set module_name="budget"><!--- sayfanin en altinda kapanisi var--->
<cfparam name="attributes.module_id_control" default="46">
<cfinclude template="../../report/standart/report_authority_control.cfm">
<cf_xml_page_edit fuseact="budget.detail_budget_report,report.detail_budget_report">
<cfif not isdefined("attributes.is_income") and not isDefined('attributes.is_submitted')><cfset attributes.is_income = 1></cfif>
<cfif not isdefined("attributes.is_expense") and not isDefined('attributes.is_submitted')><cfset attributes.is_expense = 1></cfif>
<cfif not isdefined("attributes.is_diff") and not isDefined('attributes.is_submitted')><cfset attributes.is_diff = 1></cfif>
<cfparam name="attributes.is_submitted" default="">
<cfparam name="attributes.search_date1" default="">
<cfparam name="attributes.search_date2" default="">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfparam name="attributes.is_type" default="1">
<cfparam name="attributes.is_kdv" default="">
<cfparam name="attributes.is_activity_type" default="">
<cfparam name="attributes.process_cat" default="">
<cfparam name="attributes.plan_process_cat" default="">
<cfparam name="attributes.is_all_exp_center" default="1">
<cfparam name="attributes.expense_cat" default="">
<cfparam name="attributes.project_name" default="">
<cfparam name="attributes.expense_center_id" default="">
<cfparam name="attributes.expense_item_id" default="">
<cfparam name="attributes.budget_name" default="">
<cfparam name="attributes.general_budget_id" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.search_year" default="#session.ep.period_year#">
<cfsavecontent variable="ay1"><cf_get_lang dictionary_id='57592.Ocak'></cfsavecontent>
<cfsavecontent variable="ay2"><cf_get_lang dictionary_id='57593.Subat'></cfsavecontent>
<cfsavecontent variable="ay3"><cf_get_lang dictionary_id='57594.Mart'></cfsavecontent>
<cfsavecontent variable="ay4"><cf_get_lang dictionary_id='57595.Nisan'></cfsavecontent>
<cfsavecontent variable="ay5"><cf_get_lang dictionary_id='57596.Mayis'></cfsavecontent>
<cfsavecontent variable="ay6"><cf_get_lang dictionary_id='57597.Haziran'></cfsavecontent>
<cfsavecontent variable="ay7"><cf_get_lang dictionary_id='57598.Temmuz'></cfsavecontent>
<cfsavecontent variable="ay8"><cf_get_lang dictionary_id='57599.Agustos'></cfsavecontent>
<cfsavecontent variable="ay9"><cf_get_lang dictionary_id='57600.Eylül'></cfsavecontent>
<cfsavecontent variable="ay10"><cf_get_lang dictionary_id='57601.Ekim'></cfsavecontent>
<cfsavecontent variable="ay11"><cf_get_lang dictionary_id='57602.Kasim'></cfsavecontent>
<cfsavecontent variable="ay12"><cf_get_lang dictionary_id='57603.Aralik'></cfsavecontent>
<cfset aylar = "#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#">
<cfif len(attributes.search_date1)><cf_date tarih='attributes.search_date1'></cfif>
<cfif len(attributes.search_date2)><cf_date tarih='attributes.search_date2'></cfif>
<cfquery name="get_expense_item_" datasource="#dsn2#">
	SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE IS_ACTIVE = 1 ORDER BY EXPENSE_ITEM_NAME
</cfquery>
<cfquery name="get_process_cat" datasource="#dsn3#">
	SELECT PROCESS_CAT,PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (160)
</cfquery>
<cfif isdefined("attributes.general_budget_id") and len(attributes.general_budget_id)>
	<cfquery name="GET_BUDGET" datasource="#DSN#">
		SELECT BUDGET_NAME,PROJECT_ID FROM BUDGET WHERE BUDGET_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.general_budget_id#" list="yes">)
	</cfquery>
	<cfset exp_inc_center_list = "">
	<cfset exp_inc_center_list2 = "">
	<cfif isDefined("attributes.is_all_exp_center") and attributes.is_all_exp_center eq 2 and isdefined("attributes.is_submitted") and attributes.is_submitted eq 1>
		<cfquery name="GET_EXP_CENTER_INFO" datasource="#dsn#">
			SELECT
				BUDGET_PLAN_ROW.EXP_INC_CENTER_ID,
				BUDGET_PLAN_ROW.BUDGET_ITEM_ID,
				BUDGET_PLAN_ROW.ACTIVITY_TYPE_ID,
				BUDGET_PLAN_ROW.WORKGROUP_ID,
				BUDGET_PLAN_ROW.RELATED_EMP_ID,
				BUDGET_PLAN_ROW.ASSETP_ID
			FROM
				BUDGET_PLAN,
				BUDGET_PLAN_ROW
			WHERE
				BUDGET_PLAN.BUDGET_PLAN_ID = BUDGET_PLAN_ROW.BUDGET_PLAN_ID AND
				BUDGET_PLAN.PROCESS_TYPE <> 161 AND 
				BUDGET_PLAN.BUDGET_ID = #attributes.general_budget_id#
				<cfif len(attributes.search_date1)>
					AND BUDGET_PLAN_ROW.PLAN_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.search_date1#">
				</cfif>
				<cfif len(attributes.search_date2)>
					AND BUDGET_PLAN_ROW.PLAN_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.search_date2#">
				</cfif>
		</cfquery>
		<cfif ListFind("1,2",attributes.is_type)>
			<cfset exp_inc_center_list = ListDeleteDuplicates(ValueList(GET_EXP_CENTER_INFO.EXP_INC_CENTER_ID))>
		<cfelseif ListFind("11,3",attributes.is_type)><!--- attributes.is_type eq 3 --->
			<cfset exp_inc_center_list = ListDeleteDuplicates(ValueList(GET_EXP_CENTER_INFO.BUDGET_ITEM_ID))>
		<cfelseif attributes.is_type eq 4>
			<cfset exp_inc_center_list = ListDeleteDuplicates(ValueList(GET_EXP_CENTER_INFO.ACTIVITY_TYPE_ID))>
		<cfelseif attributes.is_type eq 5>
			<cfset exp_inc_center_list = ListDeleteDuplicates(ValueList(GET_EXP_CENTER_INFO.RELATED_EMP_ID))>
		<cfelseif attributes.is_type eq 12>
			<cfset exp_inc_center_list = ListDeleteDuplicates(ValueList(GET_EXP_CENTER_INFO.WORKGROUP_ID))>
		<cfelseif attributes.is_type eq 18>
			<cfset exp_inc_center_list = ListDeleteDuplicates(ValueList(GET_EXP_CENTER_INFO.ASSETP_ID))>
		<cfelseif attributes.is_type eq 16 or attributes.is_type eq 17 >
			<cfset exp_inc_center_list = ListDeleteDuplicates(ValueList(GET_EXP_CENTER_INFO.EXP_INC_CENTER_ID))>
			<cfset exp_inc_center_list2 = ListDeleteDuplicates(ValueList(GET_EXP_CENTER_INFO.BUDGET_ITEM_ID))>
		<cfelseif ListFind("20,21",attributes.is_type)>
			<cfset exp_inc_center_list = ListDeleteDuplicates(ValueList(GET_EXP_CENTER_INFO.EXP_INC_CENTER_ID))>
			<cfset exp_inc_center_list2 = ListDeleteDuplicates(ValueList(GET_EXP_CENTER_INFO.BUDGET_ITEM_ID))>
		</cfif>
		<cfif not len(exp_inc_center_list)><cfset exp_inc_center_list = 0></cfif>
		<cfif not len(exp_inc_center_list2)><cfset exp_inc_center_list2 = 0></cfif>
	</cfif>
</cfif>
<cfparam name="attributes.activity_id" default="">
<cfquery name="getActivity" datasource="#dsn#">
	SELECT ACTIVITY_ID, ACTIVITY_NAME FROM SETUP_ACTIVITY
</cfquery>
 <cfform name="budget_report" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
 	<input type="hidden" name="is_submitted" id="is_submitted" value="1">	
 	<input type="hidden" name="maxrows_" id="maxrows_" value="<cfoutput>#session.ep.maxrows#</cfoutput>">
 	<cf_report_list_search title="#getLang('','Bütçe Raporu','29445')#">
		<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="col col-4 col-md-6 col-xs-12">							
							<div class="form-group ui-form-list ui-form-block" id="item-plan_process_cat">
								<label class="col col-12 "><cf_get_lang dictionary_id="57559.Bütçe">*</label>
								<div class="col col-11 col-xs-12">
									<cfquery name="GET_BUDGET" datasource="#dsn#">
										SELECT BUDGET_ID,BUDGET_NAME FROM BUDGET WHERE BUDGET_ID IS NOT NULL AND OUR_COMPANY_ID = #session.ep.company_id#<cfif len(attributes.search_year)> AND PERIOD_YEAR = #attributes.search_year#</cfif><cfif xml_authorized_budget eq 1>AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)</cfif>ORDER BY BUDGET_NAME
									</cfquery>
									<cf_multiselect_check 
										query_name="GET_BUDGET"  
										name="general_budget_id"
										width="135" 
										option_value="budget_id"
										option_name="budget_name"
										value="#attributes.general_budget_id#">	
								</div>
							</div>
							<div class="form-group ui-form-list ui-form-block">
								<label class="col col-12 "><cf_get_lang dictionary_id='57416.Proje'></label>
								<div class="col col-11 col-xs-12">
									<cfquery name="get_project" datasource="#dsn#">
										SELECT PROJECT_HEAD, PROJECT_ID FROM PRO_PROJECTS
									</cfquery>
									<cf_multiselect_check 
										query_name="get_project"  
										name="project_id"
										width="135" 
										option_value="project_id"
										option_name="project_head"
										value="#attributes.project_id#">
								</div>
							</div>
							<div class="form-group">
								<label class="col col-12 col-xs-12" id="activity_type"<cfif ListFind("1,2,3,5,6,7,9,10,11,12,13,14,15,16,17,18,19,20,21,22",attributes.is_type)>style="display:none !important;"</cfif>><cf_get_lang dictionary_id ="49184.Aktivite tipi"></label>
								<div class="col col-11 col-xs-12" id="activity_type1" <cfif ListFind("1,2,3,5,6,7,9,10,11,12,13,14,15,16,17,18,19,20,21,22",attributes.is_type)>style="display:none;"</cfif>>
									<select name="activity_id" id="activity_id" multiple>
										<cfoutput  query="getActivity">
											<option value="#activity_id#" <cfif listfind(attributes.activity_id,activity_id,',')>selected</cfif>>#activity_name#</option>
										</cfoutput>
									</select>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-12 "  id="exp_center1" <cfif not listfind("1,2,3,6,7,11,14,15,16,17,18,19,20,21,22,25,26",attributes.is_type)>style="display:none !important;"</cfif>><cf_get_lang dictionary_id='58235.Masraf/Gelir Merkezi'></label>
								<div class="col col-11 col-xs-12" id="exp_center2" <cfif not listfind("1,2,3,6,7,11,14,15,16,17,18,19,20,21,22,25,26",attributes.is_type)>style="display:none"</cfif>>
									<cfquery name="get_expense_center_" datasource="#dsn2#">
										SELECT 
											EXPENSE_ID,
											EXPENSE,
											EXPENSE_CODE
										FROM 
											EXPENSE_CENTER 
										WHERE 
											EXPENSE_ACTIVE = 1
											<cfif x_authorized_branch eq 1 and isdefined("x_authorized_branch_positions") and not listfind(x_authorized_branch_positions,session.ep.position_code)>
												AND 
													(
													EXPENSE_BRANCH_ID IN(SELECT EP.BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES EP WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) 
													<cfif isdefined("x_authorized_branch_all") and x_authorized_branch_all neq 1>
														OR (EXPENSE_BRANCH_ID = -1)
													</cfif>
													)
												AND 
												(
												(
													(EXPENSE_DEPARTMENT_ID IN(SELECT EP.DEPARTMENT_ID FROM #dsn_alias#.EMPLOYEE_POSITIONS EP WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) 
													or
													(EXPENSE_DEPARTMENT_ID IN(select D2.DEPARTMENT_ID from #dsn_alias#.DEPARTMENT D LEFT JOIN #dsn_alias#.DEPARTMENT as D2 ON D.HIERARCHY_DEP_ID  = CONCAT(D2.HIERARCHY_DEP_ID,'.',D.DEPARTMENT_ID) where d.DEPARTMENT_ID = (SELECT EP.DEPARTMENT_ID FROM #dsn_alias#.EMPLOYEE_POSITIONS EP WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)))
												)
												)
												  OR
													EXPENSE_DEPARTMENT_ID IN (
														SELECT EP.DEPARTMENT_ID
														FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES EP
														WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
														)
												   OR
													(EXPENSE_DEPARTMENT_ID = - 1)
												 )	 
											</cfif>
											<!---
											<cfif isdefined("x_authorized_branch_all") and x_authorized_branch_all eq 1>
												AND EXPENSE_BRANCH_ID NOT IN (-1)
											</cfif>--->
										ORDER BY
											EXPENSE_CODE
									</cfquery>
									<select name="expense_center_id" id="expense_center_id" multiple style="width:220px;height:60px;">
										<cfoutput query="get_expense_center_">
											<option value="#EXPENSE_ID#" <cfif listfind(attributes.expense_center_id,EXPENSE_ID,',')>selected</cfif>>
												<cfloop from="2" to="#ListLen(EXPENSE_CODE,".")#" index="i">
													&nbsp;&nbsp;
												</cfloop>
												<cfif is_show_exp_center_code eq 1>#expense_code#</cfif> #expense#
											</option>
										</cfoutput>
									</select>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-12 " valign="top" id="exp_cat2" <cfif not listfind("11,15,16,17,20,21",attributes.is_type)>style="display:none !important;"</cfif>>
								<cf_get_lang dictionary_id="58234.Bütçe Kalemi"></label>
								<div class="col col-11 col-xs-12 " valign="top" id="exp_cat1" <cfif not listfind("11,15,16,17,20,21,25,26",attributes.is_type)>style="display:none"</cfif>>
									<select name="expense_item_id" id="expense_item_id" multiple="multiple" style="width:220px;height:100px;">
										<cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
											SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME,EXPENSE_ITEM_CODE FROM EXPENSE_ITEMS,EXPENSE_CATEGORY WHERE  EXPENSE_ITEMS.EXPENSE_CATEGORY_ID=EXPENSE_CATEGORY.EXPENSE_CAT_ID ORDER BY EXPENSE_ITEM_NAME
										</cfquery>
										<cfoutput query="GET_EXPENSE_ITEM">
											<option value="#expense_item_id#"<cfif isdefined("attributes.expense_item_id") and listfind(attributes.expense_item_id,expense_item_id)>selected</cfif>>&nbsp;&nbsp;<cfif is_show_account_code eq 1>#EXPENSE_ITEM_CODE#</cfif> #EXPENSE_ITEM_NAME#</option>
										</cfoutput>
									</select>
								</div>
							</div>
						</div>
						<div class="col col-4 col-md-6 col-xs-12">	
							<div class="form-group">
								<label class="col col-12 "><cf_get_lang dictionary_id='58960.Rapor Tipi'></label>
								<div class="col col-11 col-xs-12">
									<select name="is_type" id="is_type" onChange="change_month();change_exp();">
										<optgroup label="<cf_get_lang dictionary_id='29674.Tarih Aralığına Göre'>" class="txtold"></optgroup>
										<option value="1" <cfif attributes.is_type eq 1>selected</cfif>><cf_get_lang dictionary_id='49108.Masraf Merkezi Bazında'></option>
										<option value="16" <cfif attributes.is_type eq 16>selected</cfif>><cf_get_lang dictionary_id='49107.Bütçe Kalemi ve Masraf Merkezi Bazında'></option>
										<option value="20" <cfif attributes.is_type eq 20>selected</cfif>><cf_get_lang dictionary_id='59206.Masraf Merkezi ve Bütçe Kategorisi Bazında'></option>
										<option value="2" <cfif attributes.is_type eq 2>selected</cfif>><cf_get_lang dictionary_id='49106.Üst Masraf Merkezi Bazında'></option>
										<option value="3" <cfif attributes.is_type eq 3>selected</cfif>><cf_get_lang dictionary_id='49105.Bütçe Kalemi Bazında'></option>
										<option value="11" <cfif attributes.is_type eq 11>selected</cfif>><cf_get_lang dictionary_id='36184.Bütçe Kategorisi Bazında'></option>
										<option value="4" <cfif attributes.is_type eq 4>selected</cfif>><cf_get_lang dictionary_id='49104.Aktivite Bazında'></option>
										<option value="12" <cfif attributes.is_type eq 12>selected</cfif>><cf_get_lang dictionary_id='49103.İş Grubu Bazında'></option>
										<option value="5" <cfif attributes.is_type eq 5>selected</cfif>><cf_get_lang dictionary_id='49102.İlgili Bazında'></option>
										<option value="18" <cfif attributes.is_type eq 18>selected</cfif>><cf_get_lang dictionary_id='49188.Fiziki Varlık Bazında'></option>
										<option value="22" <cfif attributes.is_type eq 22>selected</cfif>><cf_get_lang dictionary_id='60653.Aktivite Tipi ve Masraf Merkezi Bazında'></option>
										<option value="23" <cfif attributes.is_type eq 23>selected</cfif>><cf_get_lang dictionary_id='60654.Aktivite Tipi ve Bütçe Kalemi Bazında'></option>
										<option value="24" <cfif attributes.is_type eq 24>selected</cfif>><cf_get_lang dictionary_id='60655.Aktivite Tipi ve Proje Bazında'></option>
										<option value="25" <cfif attributes.is_type eq 25>selected</cfif>><cf_get_lang dictionary_id='60656.Aktivite Tipi ve Masraf Merkezi Bazında'></option>
										<option value="26" <cfif attributes.is_type eq 26>selected</cfif>><cf_get_lang dictionary_id='60657.Aktivite Tipi ve Masraf Merkezi Bazında'></option>
										<optgroup label="<cf_get_lang_main no='1878.Aylara Göre'>" class="txtold"></optgroup>
										<option value="6" <cfif attributes.is_type eq 6>selected</cfif>><cf_get_lang dictionary_id='49108.Masraf Merkezi Bazında'></option>
										<option value="17" <cfif attributes.is_type eq 17>selected</cfif>><cf_get_lang dictionary_id='49107.Bütçe Kalemi ve Masraf Merkezi Bazında'></option>
										<option value="21" <cfif attributes.is_type eq 21>selected</cfif>><cf_get_lang dictionary_id='59206.Masraf Merkezi ve Bütçe Kategorisi Bazında'></option>
										<option value="14" <cfif attributes.is_type eq 14>selected</cfif>><cf_get_lang dictionary_id='49106.Üst Masraf Merkezi Bazında'></option>
										<option value="7" <cfif attributes.is_type eq 7>selected</cfif>><cf_get_lang dictionary_id='49105.Bütçe Kalemi Bazında'></option>
										<option value="15" <cfif attributes.is_type eq 15>selected</cfif>><cf_get_lang dictionary_id='36184.Bütçe Kategorisi Bazında'></option>
										<option value="8" <cfif attributes.is_type eq 8>selected</cfif>><cf_get_lang dictionary_id='49100.Aktivite Tipi Bazında'></option>
										<option value="13" <cfif attributes.is_type eq 13>selected</cfif>><cf_get_lang dictionary_id='49103.İş Grubu Bazında'></option>
										<option value="9" <cfif attributes.is_type eq 9>selected</cfif>><cf_get_lang dictionary_id='49102.İlgili Bazında'></option>
										<option value="19" <cfif attributes.is_type eq 19>selected</cfif>><cf_get_lang dictionary_id='49188.Fiziki Varlık Bazında'></option>
										<option value="10" <cfif attributes.is_type eq 10>selected</cfif>><cf_get_lang dictionary_id='49129.Planlanan Gelir Gidere Göre Nakit Akımı'></option>
									</select>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-12 " valign="top" id="exp_cat3" <cfif not listfind("11,15,16,17,20,21",attributes.is_type)>style="display:none !important;"</cfif>>
								<cf_get_lang dictionary_id='32999.Bütçe Kategorisi'></label>
								<div class="col col-11 col-xs-12 " valign="top" id="exp_cat4" <cfif not listfind("11,15,16,17,20,21",attributes.is_type)>style="display:none"</cfif>>
									<cfscript>
										cfc = createObject("component", "V16.budget.cfc.budget_expense_cat");
										BudgetCats = cfc.GetBudgetCats();
									</cfscript>
									<select name="expense_cat" id="expense_cat">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfloop query="BudgetCats"> 
                                          <cfoutput>
											<option value="#EXPENSE_CAT_ID#" <cfif listfind(attributes.expense_cat,	 BudgetCats.EXPENSE_CAT_ID,',')>selected</cfif>>
												<cfif ListLen(expense_cat_code,".") neq 1>
													<cfloop from="1" to="#ListLen(expense_cat_code,".")#" index="i">&nbsp;</cfloop>
												</cfif>
											    #expense_cat_code# #expense_cat_name#
											</option>
										   </cfoutput>
                                        </cfloop> 
									</select>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-12 "><cf_get_lang dictionary_id='57756.Durum'></label>
								<div class="col col-11 col-xs-12">
									<select name="is_all_exp_center" id="is_all_exp_center">
									    <option value="0"><cf_get_lang dictionary_id="57734.Seçiniz"></option>
										<option value="1" <cfif attributes.is_all_exp_center eq 1>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
										<option value="2" <cfif attributes.is_all_exp_center eq 2>selected</cfif>><cf_get_lang dictionary_id='58869.Planlanan'></option>
										<option value="3" <cfif attributes.is_all_exp_center eq 3>selected</cfif>><cf_get_lang dictionary_id='49176.Gerçekleşen'></option>
									</select>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-12 " id="date_filter2" <cfif listfind('6,7,8,9,13,14,15,17,19,21',attributes.is_type)>style="display:none !important;"</cfif>><cf_get_lang dictionary_id='58690.Tarih Aralığı'></label>
								<div class="col col-11 col-xs-12">
									<div class="input-group" id="date_filter" <cfif listfind('6,7,8,9,13,14,15,17,19,21',attributes.is_type)>style="display:none;"</cfif> nowrap><!--- 
									 	<cfsavecontent variable="message"><cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='641.Başlangıç Tarihi'></cfsavecontent> --->
										<cfinput type="text" name="search_date1" value="#dateformat(attributes.search_date1,dateformat_style)#" maxlength="25" validate="#validate_style#">
										<span class="input-group-addon"><cf_wrk_date_image date_field="search_date1"></span>
										<span class="input-group-addon no-bg"></span>
										<!--- <cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no='288.Bitiş Tarihi'></cfsavecontent> --->
										<cfinput type="text" name="search_date2" value="#dateformat(attributes.search_date2,dateformat_style)#" maxlength="25" validate="#validate_style#">
										<span class="input-group-addon"><cf_wrk_date_image date_field="search_date2"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<div class="col col-6">                                           
									<label><cf_get_lang dictionary_id="33780.2."><cf_get_lang dictionary_id='57677.Döviz'><input type="checkbox" name="is_money" id="is_money" <cfif isdefined("attributes.is_money")>checked</cfif>></label>
									<label><cf_get_lang dictionary_id='58961.Fark Göster'><input type="checkbox" name="is_diff" id="is_diff" <cfif isdefined("attributes.is_diff")>checked</cfif>></label>
								</div>
								<div class="col col-6">  
									<label><cf_get_lang dictionary_id='58677.Gelir'><input type="checkbox" name="is_income" id="is_income" <cfif isdefined("attributes.is_income")>checked</cfif>></label>
									<label><cf_get_lang dictionary_id='58678.Gider'><input type="checkbox" name="is_expense" id="is_expense" <cfif isdefined("attributes.is_expense")>checked</cfif>></label>
								</div>
								<div class="col col-6">  
									<label><cf_get_lang dictionary_id='49095.Durum Göster'><input type="checkbox" name="durum" id="durum" value="1" <cfif isdefined("attributes.durum")>checked</cfif>></label>
									<label><cf_get_lang dictionary_id="60912.Gelir-Gider Farkı"><input type="checkbox" name="ei_diff" id="ei_diff" value="1" <cfif isdefined("attributes.ei_diff")>checked</cfif>></label>
								</div>
								<div class="col col-6">
									<label><cf_get_lang dictionary_id='49184.Aktivite Tipi'><cf_get_lang dictionary_id='58596.Göster'><input type="checkbox" name="is_activity_type" id="is_activity_type" value="1" <cfif attributes.is_activity_type eq 1 >checked</cfif>></label>
								</div>  
								<div class="col col-6">                                           
									<label><cf_get_lang dictionary_id='36012.Aktarım'><input type="checkbox" name="transfer" id="transfer" <cfif isdefined("attributes.transfer")>checked</cfif>></label>
								</div>
								<div class="col col-12">
									<label><cf_get_lang dictionary_id='61220.0 değerli kayıtlar gelmesin'><input type="checkbox" name="zero_data" id="zero_data" <cfif isdefined("attributes.zero_data")>checked</cfif>></label>
								</div>
								<div class="col col-12">  
									<label><cf_get_lang dictionary_id='49128.KDV / OTV Dahil'><input type="checkbox" name="is_kdv" id="is_kdv" value="1" <cfif attributes.is_kdv eq 1 >checked</cfif>></label>
								</div>
							</div>
						</div>
						<div class="col col-4 col-md-6 col-xs-12">
								<div class="form-group ui-form-list ui-form-block" id="item-plan_process_cat">
									<label class="col col-12 "><cf_get_lang dictionary_id="49952.İşlem Tipi"></label>
									<div class="col col-11 col-xs-12">
										<cfquery name="get_plan_process_cat" datasource="#dsn3#">
											SELECT PROCESS_CAT,PROCESS_CAT_ID,PROCESS_TYPE FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (160)
										</cfquery>
										<cf_multiselect_check 
											query_name="get_plan_process_cat"  
											name="plan_process_cat"
											width="135" 
											option_value="process_cat_id"
											option_name="process_cat"
											value="#attributes.plan_process_cat#"
											form_submit="#attributes.is_submitted#">	
									</div>
								</div>
								<div class="form-group ui-form-list ui-form-block" id="item-process_cat">
									<label class="col col-12 "><cf_get_lang dictionary_id="57800.İşlem Tipi"></label>
									<div class="col col-11 col-xs-12">
										<cfquery name="get_process_cat" datasource="#dsn3#">
											SELECT PROCESS_CAT,PROCESS_TYPE FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (18,302,21,22,23,2311,2313,24,25,30,31,32,33,34,35,44,45,46,48,49,50,51,52,53,54,55,56,58,59,60,62,63,64,65,66,67,68,120,161,1201,1202,1203,121,122,130,131,311,254,592,531,533,534,5312,5313,555,561,591,601,690,691,241,2410,243,291,292,293,294,2931,2932,296,318)
										</cfquery>
										<cf_multiselect_check 
											query_name="get_process_cat"  
											name="process_cat"
											width="135" 
											option_value="process_type"
											option_name="process_cat"
											value="#attributes.process_cat#"
											form_submit="#attributes.is_submitted#">									
									</div>
								</div>							
							<div class="form-group">
								<label class="col col-12 " id="month_filter2" <cfif not listfind('6,7,8,9,13,14,15,17,19,21',attributes.is_type)>style="display:none !important;"</cfif>><cf_get_lang_main no ='1278.Tarih Aralığı'></label>
								<div class="col col-11 col-xs-12">											
									<div class="input-group" id="month_filter" <cfif not listfind('6,7,8,9,13,14,15,17,19,21',attributes.is_type)>style="display:none;"</cfif>>
										<cfoutput>
										<select name="startdate" id="startdate">
											<cfloop from="1" to="#ListLen(aylar)#" index="m1">
												<option value="#m1#" <cfif attributes.startdate eq m1>selected</cfif>>#ListGetAt(aylar,m1,",")#</option>
											</cfloop>
										</select>
										<span class="input-group-addon no-bg"></span>
										<select name="finishdate" id="finishdate">
											<cfloop from="1" to="#ListLen(aylar)#" index="m2">
												<option value="#m2#" <cfif attributes.finishdate eq m2>selected</cfif>>#ListGetAt(aylar,m2,",")#</option>
											</cfloop>
										</select>
										</cfoutput>
									</div>
								</div>
							</div>						
						</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">							
							<label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>	
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
							<cfoutput><input type="text" <cfif ListFind("6,17,14,7,15,8,13,9,21",attributes.is_type)>style="display:none;"</cfif> name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" onKeyUp="isNumber(this)" maxlength="3"></cfoutput>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57911.Çalıştır'></cfsavecontent>
							<cf_wrk_report_search_button   search_function='kontrol()' insert_info='#message#' button_type='1' is_excel='1'>							
						</div>
					</div>
				</div>
			</div>
		</cf_report_list_search_area>
	</cf_report_list_search>
</cfform>
<cfif isdefined("attributes.is_excel") and attributes.is_excel eq 2>
		<cfset type_ = 2>
		<cfset attributes.startrow=1>
		<cfset attributes.maxrows=999999999>
	<cfelseif isdefined("attributes.is_excel") and attributes.is_excel eq 1>
		<cfset filename = "#createuuid()#">
        <cfheader name="Expires" value="#Now()#">
        <cfcontent type="application/vnd.msexcel;charset=utf-8">
        <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<cfset type_ = 1>
		<cfset attributes.startrow=1>
		<cfset attributes.maxrows=999999999>
	<cfelse>
		<cfset type_ = 0>
</cfif>   
<cf_report_list>   
	<cfset url_str = ''>
	<cfif isDefined('attributes.is_submitted') and len(attributes.is_submitted)>
		<cfset url_str = '#url_str#&is_submitted=1'>
	</cfif>
	<cfif isDefined('attributes.general_budget_id') and len(attributes.general_budget_id)>
		<cfset url_str = '#url_str#&general_budget_id=#attributes.general_budget_id#'>
	</cfif>
	<cfif isdate(attributes.search_date1)>
		<cfset url_str = '#url_str#&search_date1=#dateformat(attributes.search_date1,dateformat_style)#'>
	</cfif>
	<cfif isdate(attributes.search_date2)>
		<cfset url_str = '#url_str#&search_date2=#dateformat(attributes.search_date2,dateformat_style)#'>
	</cfif>
	<cfif len(attributes.startdate)>
		<cfset url_str = '#url_str#&startdate=#attributes.startdate#'>
	</cfif>
	<cfif len(attributes.finishdate)>
		<cfset url_str = '#url_str#&finishdate=#attributes.finishdate#'>
	</cfif>
	<cfif isDefined('attributes.is_all_exp_center') and len(attributes.is_all_exp_center)>
		<cfset url_str = '#url_str#&is_all_exp_center=#attributes.is_all_exp_center#'>
	</cfif>
	<cfif isDefined('attributes.is_income') and len(attributes.is_income)>
		<cfset url_str = '#url_str#&is_income=#attributes.is_income#'>
	</cfif>
	<cfif isDefined('attributes.is_expense') and len(attributes.is_expense)>
		<cfset url_str = '#url_str#&is_expense=#attributes.is_expense#'>
	</cfif>
	<cfif len(attributes.process_cat)>
		<cfset url_str = "#url_str#&process_cat=#attributes.process_cat#">
	</cfif>
	<cfif len(attributes.plan_process_cat)>
		<cfset url_str = "#url_str#&plan_process_cat=#attributes.plan_process_cat#">
	</cfif>
	<cfif isDefined('attributes.is_kdv') and len(attributes.is_kdv)>
		<cfset url_str = '#url_str#&is_kdv=#attributes.is_kdv#'>
	</cfif>
	<cfif isDefined('attributes.is_money') and len(attributes.is_money)>
		<cfset url_str = '#url_str#&is_money=#attributes.is_money#'>
	</cfif>
	<cfif isDefined('attributes.is_diff') and len(attributes.is_diff)>
		<cfset url_str = '#url_str#&is_diff=#attributes.is_diff#'>
	</cfif>
	<cfif isDefined('attributes.is_type') and len(attributes.is_type)>
		<cfset url_str = '#url_str#&is_type=#attributes.is_type#'>
	</cfif>
	<cfif isDefined('attributes.project_id') and len(attributes.project_id)>
		<cfset url_str = '#url_str#&project_id=#attributes.project_id#'>
	</cfif>
	<cfif isDefined('attributes.project_name') and len(attributes.project_name)>
		<cfset url_str = '#url_str#&project_name=#attributes.project_name#'>
	</cfif> 
	<cfif isDefined('attributes.expense_center_id') and len(attributes.expense_center_id)>
		<cfset url_str = '#url_str#&expense_center_id=#attributes.expense_center_id#'>
	</cfif>
	<cfif isDefined('attributes.expense_cat') and len(attributes.expense_cat)>
		<cfset url_str = '#url_str#&expense_cat=#attributes.expense_cat#'>
	</cfif>
	<cfif isDefined('attributes.expense_item_id') and len(attributes.expense_item_id)>
		<cfset url_str = '#url_str#&expense_item_id=#attributes.expense_item_id#'>
	</cfif>
	<cfif isDefined('attributes.durum') and len(attributes.durum)>
		<cfset url_str = '#url_str#&durum=#attributes.durum#'>
	</cfif>
	<cfif isDefined('attributes.ei_diff') and len(attributes.ei_diff)>
		<cfset url_str = '#url_str#&ei_diff=#attributes.ei_diff#'>
	</cfif>
	<cfif isDefined('attributes.is_activity_type') and len(attributes.is_activity_type)>
		<cfset url_str = '#url_str#&is_activity_type=#attributes.is_activity_type#'>
	</cfif>
	<cfif isDefined('attributes.zero_data') and len(attributes.zero_data)>
		<cfset url_str = '#url_str#&zero_data=#attributes.zero_data#'>
	</cfif>
	<cfset month_list=''>
	<cfif len(attributes.is_submitted)>
		<cfif len(attributes.finishdate) or len(attributes.startdate)>
			<cfset tarih_farki = (attributes.finishdate-attributes.startdate)>
			<cfloop from="#attributes.startdate#" to="#attributes.startdate+tarih_farki#" index="i">
				<cfset month_list=listappend(month_list,i)>
			</cfloop>
		</cfif>
		<cfset toplam1 = 0>
		<cfset toplam2 = 0>			
		<cfset toplam3 = 0>
		<cfset toplam4 = 0>
		<cfset toplam1_2 = 0>
		<cfset toplam2_2 = 0>			
		<cfset toplam3_2 = 0>
		<cfset toplam4_2 = 0>			
		<cfset toplam_rez_3 = 0>
		<cfset toplam_rez_4 = 0>		
		<cfset toplam_rez_3_2 = 0>
		<cfset toplam_rez_4_2 = 0>
		<cfif attributes.is_type eq 1><!--- Tarih Aralığına Göre Masraf Merkezi Bazında (sube ve departman yetkisi eklendi) --->
			<cfinclude template="detail_budget_report_type1.cfm">
		<cfelseif attributes.is_type eq 2><!--- Tarih Aralığına Göre Üst Masraf Merkezi Bazında (sube ve departman yetkisi eklendi) --->
			<cfinclude template="detail_budget_report_type2.cfm">
		<cfelseif attributes.is_type eq 3><!--- Tarih Aralığına Göre Bütçe Kalemi Bazında (sube ve departman yetkisi eklendi) --->	
			<cfinclude template="detail_budget_report_type3.cfm">
		<cfelseif attributes.is_type eq 4><!--- Tarih Aralığına Göre Aktivite Bazında (sube ve departman yetkisi eklendi) --->		
			<cfinclude template="detail_budget_report_type4.cfm">
		<cfelseif attributes.is_type eq 5><!--- Tarih Aralığına Göre İlgili Bazında (sube ve departman yetkisi eklendi) --->		
			<cfinclude template="detail_budget_report_type5.cfm">
		<cfelseif attributes.is_type eq 6><!--- Aylara Göre Masraf Merkezi Bazında (sube ve departman yetkisi eklendi) --->
			<cfinclude template="detail_budget_report_type6.cfm">
		<cfelseif attributes.is_type eq 7><!--- Aylara Göre Bütçe Kalemi Bazında (sube ve departman yetkisi eklendi)--->
			<cfinclude template="detail_budget_report_type7.cfm">
		<cfelseif attributes.is_type eq 8><!--- Aylara Göre Aktivite Tipi Bazında (sube ve departman yetkisi eklendi)--->
			<cfinclude template="detail_budget_report_type8.cfm">
		<cfelseif attributes.is_type eq 9><!--- Aylara Göre İlgili Bazında (sube ve departman yetkisi eklendi)--->
			<cfinclude template="detail_budget_report_type9.cfm">
		<cfelseif attributes.is_type eq 10><!--- Planlanan gelir gidere göre nakit akımı(sube ve departman yetkisi eklendi) --->
			<cfinclude template="detail_budget_report_type10.cfm">
		<cfelseif attributes.is_type eq 11><!--- Tarih Aralığına Göre Bütçe Kategorisi Bazında (sube ve departman yetkisi eklendi)--->
			<cfinclude template="detail_budget_report_type11.cfm">
		<cfelseif attributes.is_type eq 12><!--- Tarih Aralığına Göre İşGrubu Bazında (sube ve departman yetkisi eklendi) --->
			<cfinclude template="detail_budget_report_type12.cfm">
		<cfelseif attributes.is_type eq 13><!--- Aylara Göre İşGrubu Bazında (sube ve departman yetkisi eklendi)--->
			<cfinclude template="detail_budget_report_type13.cfm">
		<cfelseif attributes.is_type eq 14><!--- Aylara Göre Üst Masraf Merkezi Bazında (sube ve departman yetkisi eklendi) --->
			<cfinclude template="detail_budget_report_type14.cfm">
		<cfelseif attributes.is_type eq 15><!--- Aylara Göre Bütçe Kategorisi Bazında (sube ve departman yetkisi eklendi)--->
			<cfinclude template="detail_budget_report_type15.cfm">
		<cfelseif attributes.is_type eq 16><!--- Tarih aralığına göre masraf merkezi ve bütçe kalemi Bazında (sube ve departman yetkisi eklendi)--->
			<cfinclude template="detail_budget_report_type16.cfm">				
		<cfelseif attributes.is_type eq 17><!---aylara göre masraf merkezi ve bütçe kalemi Bazında (sube ve departman yetkisi eklendi)--->
			<cfinclude template="detail_budget_report_type17.cfm">
		<cfelseif attributes.is_type eq 18><!--- Tarih aralığına göre Fiziki Varlik Bazında (sube ve departman yetkisi eklendi)--->
			<cfinclude template="detail_budget_report_type18.cfm">				
		<cfelseif attributes.is_type eq 19><!---aylara göre Fiziki Varlik Bazında --->
			<cfinclude template="detail_budget_report_type19.cfm">
		<cfelseif attributes.is_type eq 20><!--- Tarih aralığına göre Masraf Merkezi ve Bütçe Kategorisi Bazında (sube ve departman yetkisi eklendi)--->
			<cfinclude template="detail_budget_report_type20.cfm">				
		<cfelseif attributes.is_type eq 21><!---aylara göre Masraf Merkezi ve Bütçe Kategorisi Bazında (sube ve departman yetkisi eklendi)--->
			<cfinclude template="detail_budget_report_type21.cfm">
		<cfelseif attributes.is_type eq 22><!--- Tarih aralığına göre Masraf Merkezi ve Aktivite Tipi Bazında --->
			<cfinclude template="detail_budget_report_type22.cfm">
		<cfelseif attributes.is_type eq 23><!--- Tarih aralığına göre Bütçe Kalemi ve Aktivite Tipi Bazında --->
			<cfinclude template="detail_budget_report_type23.cfm">
		<cfelseif attributes.is_type eq 24><!--- Tarih aralığına göre Proje ve Aktivite Tipi Bazında --->
			<cfinclude template="detail_budget_report_type24.cfm">
		<cfelseif attributes.is_type eq 25><!--- Tarih aralığına göre Bütçe Kalemi ve Proje Bazında --->
			<cfinclude template="detail_budget_report_type25.cfm">
		<cfelseif attributes.is_type eq 26><!--- Tarih aralığına göre Masraf Merkezi ve Proje Bazında --->
			<cfinclude template="detail_budget_report_type26.cfm">
		</cfif>
	</cfif>
</cf_report_list>
	<cfif isdefined("attributes.totalrecords") and attributes.totalrecords gt attributes.maxrows>
		<cf_paging page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="#attributes.fuseaction##url_str#">
	</cfif>

<script language="javascript">
	function kontrol()
	{	
		if(parseFloat(document.getElementById("startdate").value)>parseFloat(document.getElementById("finishdate").value) )
		{
			alert("<cf_get_lang dictionary_id='58949.Başlangıç Ayı Bitiş Ayından Büyük Olamaz'>!");
			return false;
		}
		if((document.getElementById('search_date1').value != '') && (document.getElementById('search_date2').value != '') &&
			!date_check(document.getElementById('search_date1'), document.getElementById('search_date2'),'<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>'))
			return false;
		if(document.getElementById("general_budget_id").value == "")
		{
			alert("<cf_get_lang dictionary_id="51809.Bütçe Seçiniz!">");
			return false;
		}
		if((document.getElementById("is_expense").checked == false) && (document.getElementById("is_income").checked == false))
		{
			alert("<cf_get_lang dictionary_id='49162.Lütfen Gelir veya Gider Kutucuklarından En Az Birisini Seçiniz'>!");
			return false;
		}
		
		if(document.budget_report.is_excel.checked==false)
			{
				document.budget_report.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.detail_budget_report"
				return true;
			}
			else
			{
				document.budget_report.action="<cfoutput>#request.self#?fuseaction=budget.emptypopup_detail_budget_report</cfoutput>"
			}
	}
	function change_month()
	{
		if(list_find('6;7;8;9;13;14;15;17;19;21',document.getElementById("is_type").value,';'))
		{
			document.getElementById("month_filter").style.display = "";
			document.getElementById("month_filter2").style.display = "";
			document.getElementById("date_filter").style.display = 'none';
			document.getElementById("date_filter2").style.display = 'none';
		}
		else
		{
			document.getElementById("month_filter").style.display = 'none';
			document.getElementById("month_filter2").style.display = 'none';
			document.getElementById("date_filter").style.display = "";
			document.getElementById("date_filter2").style.display = "";
		}
	}
	function change_exp()
	{
		//Ay Bazinda Alinan Tipler Icin Ayri Bloklar Oldugundan Sayfalama Yapilmiyor FBS
		//butce kalemi ve masraf merkezi bazında eklendi (tarih aralıgina gore)
		if(list_find("6,17,14,7,15,8,13,9,10,19,21,22",document.getElementById("is_type").value))
			document.getElementById("maxrows").style.display = "none";
		else
			document.getElementById("maxrows").style.display = "";

		if(list_find('4;8',document.getElementById("is_type").value,';'))
			{
				document.getElementById("activity_type").style.display = "";
				document.getElementById("activity_type1").style.display = "";
			}			
		else
			{
				document.getElementById("activity_type").style.display = "none";
				document.getElementById("activity_type1").style.display = "none";
			}
		if(list_find('1;2;6;14;22',document.getElementById("is_type").value,';'))
		{
			document.getElementById("exp_center1").style.display = "";
			document.getElementById("exp_center2").style.display = "";
			document.getElementById("exp_cat1").style.display = "none";
			document.getElementById("exp_cat2").style.display = "none";
			document.getElementById("exp_cat3").style.display = "none";
			document.getElementById("exp_cat4").style.display = "none";
		}
		/* butce kalemi bazinda */
		else if(list_find('3;7',document.getElementById("is_type").value,';'))
		{
			document.getElementById("exp_center1").style.display = "";
			document.getElementById("exp_center2").style.display = "";
			document.getElementById("exp_cat1").style.display = "none";
			document.getElementById("exp_cat2").style.display = "none";
			document.getElementById("exp_cat3").style.display = "none";
			document.getElementById("exp_cat4").style.display = "none";
		}
		/* butce kategorisi bazinda */
		else if(list_find('11;15',document.getElementById("is_type").value,';'))
		{
			document.getElementById("exp_center1").style.display = "";
			document.getElementById("exp_center2").style.display = "";
			document.getElementById("exp_cat1").style.display = "";
			document.getElementById("exp_cat2").style.display = "";
			document.getElementById("exp_cat3").style.display = "";
			document.getElementById("exp_cat4").style.display = "";
		}
		else if(list_find('20;21',document.getElementById("is_type").value,';'))
		{
			document.getElementById("exp_center1").style.display = "";
			document.getElementById("exp_center2").style.display = "";
			document.getElementById("exp_cat1").style.display = "";
			document.getElementById("exp_cat2").style.display = "";
			document.getElementById("exp_cat3").style.display = "";
			document.getElementById("exp_cat4").style.display = "";
		}
		else if(list_find('17',document.getElementById("is_type").value,';'))
		{
			document.getElementById("exp_center1").style.display = "";
			document.getElementById("exp_center2").style.display = "";
			document.getElementById("exp_cat1").style.display = "";
			document.getElementById("exp_cat2").style.display = "";
			document.getElementById("exp_cat3").style.display = "";
			document.getElementById("exp_cat4").style.display = "";
		}
		else if(list_find('16;25;26',document.getElementById("is_type").value,';'))
		{
			document.getElementById("exp_center1").style.display = "";
			document.getElementById("exp_center2").style.display = "";
			document.getElementById("exp_cat1").style.display = "";
			document.getElementById("exp_cat2").style.display = "";
			document.getElementById("exp_cat3").style.display = "";
			document.getElementById("exp_cat4").style.display = "";
		}
		/* fiziki varlik bazinda */
		else if(list_find('18;19',document.getElementById("is_type").value,';'))
		{
			document.getElementById("exp_center1").style.display = "";
			document.getElementById("exp_center2").style.display = "";
		}
		else
		{			
			document.getElementById("exp_center1").style.display = "none";
			document.getElementById("exp_center2").style.display = "none";
			document.getElementById("exp_cat1").style.display = "none";
			document.getElementById("exp_cat2").style.display = "none";
			document.getElementById("exp_cat3").style.display = "none";
			document.getElementById("exp_cat4").style.display = "none";
		}
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
