<cfparam name="attributes.module_id_control" default="20,11">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.ims_code_id" default="">
<cfparam name="attributes.visit_emps" default="">
<cfparam name="attributes.visit_type" default="">
<cfparam name="attributes.company_type" default="">
<cfparam name="attributes.visit_stage" default="">
<cfparam name="attributes.is_plan" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.expense_item" default="">
<cfparam name="attributes.visit_expense_start" default="">
<cfparam name="attributes.visit_expense_finish" default="">
<cfparam name="attributes.city_id" default="">
<cfparam name="attributes.city_name" default="">
<cfparam name="attributes.county_id" default="">
<cfparam name="attributes.county_name" default="">
<cfparam name="attributes.money" default="">
<cfparam name="attributes.is_excel" default="">

<cfif len(attributes.start_date)><cf_date tarih='attributes.start_date'></cfif>
<cfif len(attributes.finish_date)><cf_date tarih='attributes.finish_date'></cfif>
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT
		BRANCH_NAME,
		BRANCH_ID
	FROM 
		BRANCH
	WHERE
		BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# )
	ORDER BY 
		BRANCH_NAME
</cfquery>
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1
</cfquery>
<cfif fusebox.use_period eq true>
	<cfset dsn_2 = dsn2>
<cfelse>
	<cfset dsn_2 = dsn>
</cfif>

<cfquery name="GET_EXPENSE" datasource="#dsn2#">
	SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS ORDER BY EXPENSE_ITEM_NAME
</cfquery>
<cfquery name="GET_COMPANYCAT" datasource="#DSN#">
<!--- 	SELECT COMPANYCAT_ID, COMPANYCAT FROM COMPANY_CAT WHERE COMPANYCAT_TYPE = 0 ORDER BY COMPANYCAT
 --->	SELECT DISTINCT	
		COMPANYCAT_ID,
		COMPANYCAT,
		COMPANYCAT_TYPE
	FROM
		GET_MY_COMPANYCAT
	WHERE
		EMPLOYEE_ID = #session.ep.userid# AND
		OUR_COMPANY_ID = #session.ep.company_id#
	ORDER BY
		COMPANYCAT
</cfquery>
<cfquery name="GET_CONSCAT" datasource="#DSN#">
	<!--- SELECT CONSCAT_ID,CONSCAT FROM CONSUMER_CAT ORDER BY HIERARCHY --->
	SELECT DISTINCT	
		CONSCAT_ID,
		CONSCAT,
		HIERARCHY
	FROM
		GET_MY_CONSUMERCAT
	WHERE
		EMPLOYEE_ID = #session.ep.userid# AND
		OUR_COMPANY_ID = #session.ep.company_id#
	ORDER BY
		HIERARCHY		
</cfquery>

<cfif isdefined("attributes.form_submitted") and attributes.form_submitted eq 1>
	<cfset Company_Member = "">
	<cfset Consumer_Member = "">
	<cfif ListLen(attributes.company_type)>
		<cfset Number_=ListLen(attributes.company_type)>
		<cfloop from="1" to="#Number_#" index="n">
			<cfset CatList = listgetat(attributes.company_type,n,',')>
			<cfif listlen(CatList) and listfirst(CatList,'-') eq 1>
				<cfset Company_Member = listappend(Company_Member,ListLast(CatList,'-'))>
			<cfelseif listlen(CatList) and listfirst(CatList,'-') eq 2>
				<cfset Consumer_Member = listappend(Consumer_Member,ListLast(CatList,'-'))>
			</cfif>
		</cfloop>
		<cfset Company_Member = ListSort(Company_Member,'numeric','asc',',')>
		<cfset Consumer_Member = ListSort(Consumer_Member,'numeric','asc',',')>
	</cfif>

	<cfquery name="GET_VISIT_MAIN" datasource="#DSN#">
		<cfif not Len(attributes.company_type) or Len(Company_Member)>
			SELECT DISTINCT
				1 TYPE,
				EVENT_PLAN_ROW_PARTICIPATION_POS.EVENT_POS_ID,
				EVENT_PLAN_ROW.EVENT_PLAN_ID,
				EVENT_PLAN_ROW.WARNING_ID,
				EVENT_PLAN_ROW.START_DATE,
				EVENT_PLAN_ROW.FINISH_DATE,
				EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID,
				EVENT_PLAN_ROW.EXECUTE_STARTDATE,
				EVENT_PLAN_ROW.EXECUTE_FINISHDATE,
				EVENT_PLAN_ROW.VISIT_STAGE,
				EVENT_PLAN_ROW.RESULT_RECORD_EMP,
				COMPANY.FULLNAME FULLNAME,
				COMPANY.COMPANY_ID C_ID,
				COMPANY.CITY CITY,
				COMPANY.COUNTY COUNTY,
				COMPANY_PARTNER.COMPANY_PARTNER_NAME MEMBER_NAME,
				COMPANY_PARTNER.COMPANY_PARTNER_SURNAME MEMBER_SURNAME,
				COMPANY_PARTNER.PARTNER_ID MEMBER_ID,
				<!--- EVENT_CAT.EVENTCAT, --->
				SETUP_VISIT_TYPES.VISIT_TYPE,
				EVENT_PLAN_ROW.EXPENSE_ITEM,
				EVENT_PLAN_ROW.EXPENSE,
				EVENT_PLAN_ROW.MONEY_CURRENCY
			FROM
				EVENT_PLAN_ROW,
				COMPANY,
				COMPANY_PARTNER,
				SETUP_VISIT_TYPES,
				EVENT_PLAN_ROW_PARTICIPATION_POS
			WHERE 
				EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID IS NOT NULL
				<cfif len(attributes.branch_id)>AND EVENT_PLAN_ROW.EVENT_PLAN_ID IN ( SELECT EVENT_PLAN_ID FROM EVENT_PLAN WHERE SALES_ZONES IN (#attributes.branch_id#))</cfif>
				<cfif len(attributes.ims_code_id)>AND COMPANY.IMS_CODE_ID IN (#attributes.ims_code_id#)</cfif>
				<cfif len(Company_Member)>AND COMPANY.COMPANYCAT_ID IN (#Company_Member#)</cfif>
				<cfif len(attributes.is_plan) and (attributes.is_plan eq 1)>AND EVENT_PLAN_ROW.EVENT_PLAN_ID IS NOT NULL<cfelseif len(attributes.is_plan) and (attributes.is_plan eq 2)>AND EVENT_PLAN_ROW.EVENT_PLAN_ID IS NULL</cfif>
				<cfif len(attributes.expense_item)>AND EVENT_PLAN_ROW.EXPENSE_ITEM = #attributes.expense_item#</cfif>
				<cfif len(attributes.start_date) and attributes.start_date neq 'NULL'>AND EVENT_PLAN_ROW.START_DATE >= #attributes.start_date#</cfif>
				<cfif len(attributes.finish_date) and attributes.finish_date neq 'NULL'>AND EVENT_PLAN_ROW.FINISH_DATE < #date_add("d", 1, attributes.finish_date)#</cfif>
				<cfif len(attributes.visit_emps)>AND EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID IN ( SELECT EVENT_ROW_ID FROM EVENT_PLAN_ROW_PARTICIPATION_POS WHERE EVENT_POS_ID IN (#attributes.visit_emps#) )</cfif>
				<cfif len(attributes.visit_type)>AND EVENT_PLAN_ROW.WARNING_ID IN (#attributes.visit_type#)</cfif>
				<cfif len(attributes.visit_stage)>AND EVENT_PLAN_ROW.VISIT_STAGE IN (#attributes.visit_stage#)</cfif>
				<cfif len(attributes.visit_expense_start)>AND EVENT_PLAN_ROW.EXPENSE >= #attributes.visit_expense_start#</cfif>
				<cfif len(attributes.visit_expense_finish)>AND EVENT_PLAN_ROW.EXPENSE <= #attributes.visit_expense_finish#</cfif>
				<cfif len(attributes.money)>AND EVENT_PLAN_ROW.MONEY_CURRENCY = '#attributes.money#'</cfif>
				<cfif Len(attributes.city_name) and Len(attributes.city_id)>AND COMPANY.CITY = #attributes.city_id#</cfif>
				<cfif Len(attributes.county_name) and Len(attributes.county_id)>AND COMPANY.COUNTY = #attributes.county_id#</cfif>
				AND EVENT_PLAN_ROW.PARTNER_ID = COMPANY_PARTNER.PARTNER_ID
				AND COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID
				AND SETUP_VISIT_TYPES.VISIT_TYPE_ID = EVENT_PLAN_ROW.WARNING_ID
				<!--- AND EVENT_CAT.EVENTCAT_ID = EVENT_PLAN_ROW.WARNING_ID --->
				AND EVENT_PLAN_ROW.PARTNER_ID = COMPANY_PARTNER.PARTNER_ID
				AND EVENT_PLAN_ROW_PARTICIPATION_POS.EVENT_ROW_ID=EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID
				<cfif len(attributes.visit_emps)>AND EVENT_PLAN_ROW_PARTICIPATION_POS.EVENT_POS_ID IN (#attributes.visit_emps#)</cfif>
		</cfif>
		<cfif not Len(attributes.company_type) or (Len(Company_Member) and Len(Consumer_Member))>
			UNION ALL
		</cfif>
		<cfif not Len(attributes.company_type) or Len(Consumer_Member)>
			SELECT DISTINCT
				2 TYPE,
				EVENT_PLAN_ROW_PARTICIPATION_POS.EVENT_POS_ID,
				EVENT_PLAN_ROW.EVENT_PLAN_ID,
				EVENT_PLAN_ROW.WARNING_ID,
				EVENT_PLAN_ROW.START_DATE,
				EVENT_PLAN_ROW.FINISH_DATE,
				EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID,
				EVENT_PLAN_ROW.EXECUTE_STARTDATE,
				EVENT_PLAN_ROW.EXECUTE_FINISHDATE,
				EVENT_PLAN_ROW.VISIT_STAGE,
				EVENT_PLAN_ROW.RESULT_RECORD_EMP,
				CONSUMER.CONSUMER_NAME + ' ' + CONSUMER.CONSUMER_SURNAME FULLNAME,
				CONSUMER.CONSUMER_ID C_ID,
				CONSUMER.TAX_CITY_ID CITY,
				CONSUMER.TAX_COUNTY_ID COUNTY,
				CONSUMER.CONSUMER_NAME MEMBER_NAME,
				CONSUMER.CONSUMER_SURNAME MEMBER_SURNAME,
				CONSUMER.CONSUMER_ID MEMBER_ID,
				SETUP_VISIT_TYPES.VISIT_TYPE,
				EVENT_PLAN_ROW.EXPENSE_ITEM,
				EVENT_PLAN_ROW.EXPENSE,
				EVENT_PLAN_ROW.MONEY_CURRENCY
			FROM
				EVENT_PLAN_ROW,
				CONSUMER,
				SETUP_VISIT_TYPES,
				EVENT_PLAN_ROW_PARTICIPATION_POS
			WHERE 
				EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID IS NOT NULL
				<cfif len(attributes.branch_id)>AND EVENT_PLAN_ROW.EVENT_PLAN_ID IN ( SELECT EVENT_PLAN_ID FROM EVENT_PLAN WHERE SALES_ZONES IN (#attributes.branch_id#))</cfif>
				<cfif len(attributes.ims_code_id)>AND CONSUMER.IMS_CODE_ID IN (#attributes.ims_code_id#)</cfif>
				<cfif len(Consumer_Member)>AND CONSUMER.CONSUMER_CAT_ID IN (#Consumer_Member#)</cfif>
				<cfif len(attributes.is_plan) and (attributes.is_plan eq 1)>AND EVENT_PLAN_ROW.EVENT_PLAN_ID IS NOT NULL<cfelseif len(attributes.is_plan) and (attributes.is_plan eq 2)>AND EVENT_PLAN_ROW.EVENT_PLAN_ID IS NULL</cfif>
				<cfif len(attributes.expense_item)>AND EVENT_PLAN_ROW.EXPENSE_ITEM = #attributes.expense_item#</cfif>
				<cfif len(attributes.start_date) and attributes.start_date neq 'NULL'>AND EVENT_PLAN_ROW.START_DATE >= #attributes.start_date#</cfif>
				<cfif len(attributes.finish_date) and attributes.finish_date neq 'NULL'>AND EVENT_PLAN_ROW.FINISH_DATE < #date_add("d", 1, attributes.finish_date)#</cfif>
				<cfif len(attributes.visit_emps)>AND EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID IN ( SELECT EVENT_ROW_ID FROM EVENT_PLAN_ROW_PARTICIPATION_POS WHERE EVENT_POS_ID IN (#attributes.visit_emps#) )</cfif>
				<cfif len(attributes.visit_type)>AND EVENT_PLAN_ROW.WARNING_ID IN (#attributes.visit_type#)</cfif>
				<cfif len(attributes.visit_stage)>AND EVENT_PLAN_ROW.VISIT_STAGE IN (#attributes.visit_stage#)</cfif>
				<cfif len(attributes.visit_expense_start)>AND EVENT_PLAN_ROW.EXPENSE >= #attributes.visit_expense_start#</cfif>
				<cfif len(attributes.visit_expense_finish)>AND EVENT_PLAN_ROW.EXPENSE <= #attributes.visit_expense_finish#</cfif>
				<cfif len(attributes.money)>AND EVENT_PLAN_ROW.MONEY_CURRENCY = '#attributes.money#'</cfif>
				<cfif Len(attributes.city_name) and Len(attributes.city_id)>AND CONSUMER.TAX_CITY_ID = #attributes.city_id#</cfif>
				<cfif Len(attributes.county_name) and Len(attributes.county_id)>AND CONSUMER.TAX_COUNTY_ID = #attributes.county_id#</cfif>
				AND EVENT_PLAN_ROW.CONSUMER_ID = CONSUMER.CONSUMER_ID
				AND SETUP_VISIT_TYPES.VISIT_TYPE_ID = EVENT_PLAN_ROW.WARNING_ID
				AND EVENT_PLAN_ROW_PARTICIPATION_POS.EVENT_ROW_ID=EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID
				<cfif len(attributes.visit_emps)>AND EVENT_PLAN_ROW_PARTICIPATION_POS.EVENT_POS_ID IN (#attributes.visit_emps#)</cfif>
		</cfif>
		<cfif not Len(attributes.company_type) or (Len(Company_Member) and Len(Consumer_Member))>
			ORDER BY 
				EVENT_PLAN_ROW.START_DATE DESC
		</cfif>
	</cfquery>
	<cfquery name="GET_PLAN" datasource="#DSN#">
		SELECT EVENT_PLAN_HEAD,EVENT_PLAN_ID FROM EVENT_PLAN
	</cfquery>

		<cfquery name="GET_VISIT" dbtype="query">
			SELECT
				GET_VISIT_MAIN.*,
				GET_PLAN.EVENT_PLAN_HEAD AS EVENT_PLAN_HEAD
			FROM
				GET_VISIT_MAIN,
				GET_PLAN
			WHERE
				GET_PLAN.EVENT_PLAN_ID = GET_VISIT_MAIN.EVENT_PLAN_ID
			UNION
			SELECT
				GET_VISIT_MAIN.*,
				'Plansız' AS EVENT_PLAN_HEAD
			FROM
				GET_VISIT_MAIN
			WHERE
				GET_VISIT_MAIN.EVENT_PLAN_ID IS NULL
		</cfquery>
	
	<cfif GET_VISIT_MAIN.recordcount>
		<cfset city_list=''>
		<cfset county_list=''>
		<cfset visit_stage_list=''>
		<cfset expense_item_list=''>
		<cfoutput query="GET_VISIT_MAIN">
			<cfif isdefined('VISIT_STAGE') and len(VISIT_STAGE) and not listfind(visit_stage_list,VISIT_STAGE)>
				<cfset visit_stage_list=listappend(visit_stage_list,VISIT_STAGE)>
			</cfif>
			<cfif isdefined('EXPENSE_ITEM') and len(EXPENSE_ITEM) and not listfind(expense_item_list,EXPENSE_ITEM)>
				<cfset expense_item_list=listappend(expense_item_list,EXPENSE_ITEM)>
			</cfif>
			<cfif isdefined('CITY') and len(CITY) and not listfind(city_list,CITY)>
				<cfset city_list=listappend(city_list,CITY)>
			</cfif>
			<cfif isdefined('COUNTY') and len(COUNTY) and not listfind(county_list,COUNTY)>
				<cfset county_list=listappend(county_list,COUNTY)>
			</cfif>
		</cfoutput>
		<cfif listlen(visit_stage_list)>
			<cfset visit_stage_list=listsort(visit_stage_list,"numeric","ASC",",")>
			<cfquery name="get_visit_stage" datasource="#DSN#">
				SELECT VISIT_STAGE, VISIT_STAGE_ID FROM SETUP_VISIT_STAGES WHERE VISIT_STAGE_ID IN (#visit_stage_list#) ORDER BY VISIT_STAGE_ID
			</cfquery>
			<cfset visit_stage_list = listsort(listdeleteduplicates(valuelist(get_visit_stage.VISIT_STAGE_ID,',')),'numeric','ASC',',')>
		</cfif>
		<cfif listlen(expense_item_list)>
			<cfset expense_item_list=listsort(expense_item_list,"numeric","ASC",",")>
			<cfquery name="GET_EXPENSE" datasource="#dsn2#">
				SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID IN (#expense_item_list#) ORDER BY EXPENSE_ITEM_ID
			</cfquery>
			<cfset expense_item_list = listsort(listdeleteduplicates(valuelist(GET_EXPENSE.EXPENSE_ITEM_ID,',')),'numeric','ASC',',')>
		</cfif>
		<cfif listlen(city_list)>
			<cfset city_list=listsort(city_list,"numeric","ASC",",")>
			<cfquery name="get_city" datasource="#DSN#">
				SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE CITY_ID IN (#city_list#) ORDER BY CITY_ID
			</cfquery>
			<cfset city_list = listsort(listdeleteduplicates(valuelist(get_city.CITY_ID,',')),'numeric','ASC',',')>
		</cfif>
		<cfif listlen(county_list)>
			<cfset county_list=listsort(county_list,"numeric","ASC",",")>
			<cfquery name="get_county" datasource="#DSN#">
				SELECT COUNTY_NAME,COUNTY_ID,CITY FROM SETUP_COUNTY WHERE COUNTY_ID IN (#county_list#) ORDER BY COUNTY_ID
			</cfquery>
			<cfset county_list = listsort(listdeleteduplicates(valuelist(get_county.COUNTY_ID,',')),'numeric','ASC',',')>
		</cfif>
	</cfif>
<cfelse>
	<cfset GET_VISIT.recordcount = 0>
</cfif>

<cfform method="post" name="add_visit" action="#request.self#?fuseaction=report.detail_visit_report">
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='39587.Detaylı Ziyaret Raporu'></cfsavecontent>
	<cf_report_list_search id="member_report_" title="#title#">
		<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<input type="hidden" name="form_submitted" id="form_submitted" value="1">
							<div class="col col-3 col-md-6 col-xs-12">
								<div class="form-group">
									<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
									<div class="col col-9 col-xs-12">
										<select name="branch_id" id="branch_id" multiple>
											<cfoutput query="get_branch">
												<option value="#branch_id#" <cfif listfind(attributes.branch_id, branch_id,',')> selected</cfif>>#branch_name#</option>
											</cfoutput>
										</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='39404.Müşteri Tipi'></label>
									<div class="col col-9 col-xs-12">	
										<select name="company_type" id="company_type" multiple>
											<optgroup label="<cf_get_lang dictionary_id='58039.Kurumsal Üye Kategorileri'>">
												<cfoutput query="get_companycat">
													<option value="1-#companycat_id#" <cfif listfind(attributes.company_type,'1-#companycat_id#',',')>selected</cfif>>&nbsp;&nbsp;#companycat#</option>
												</cfoutput>
											</optgroup>
											<optgroup label="Bireysel Üye Kategorileri">
												<cfoutput query="get_conscat">
													<option value="2-#conscat_id#" <cfif listfind(attributes.company_type,'2-#conscat_id#',',')>selected</cfif>>&nbsp;&nbsp;#conscat#</option>
												</cfoutput>
											</optgroup>
										</select>
									</div>
								</div>
							</div>
							
							<div class="col col-3 col-md-6 col-xs-12">
								<div class="form-group">
									<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58134.Micro Bölge Kodu'></label>
									<div class="col col-9 col-xs-12">	
										<select name="ims_code_id" id="ims_code_id" multiple>
											<cfif len(attributes.ims_code_id)>
												<cfquery name="GET_IMS_NAME" datasource="#dsn#">
													SELECT IMS_CODE_ID, IMS_CODE, IMS_CODE_NAME FROM SETUP_IMS_CODE WHERE IMS_CODE_ID IN (#attributes.ims_code_id#)
												</cfquery>
												<cfoutput query="get_ims_name">
													<option value="#ims_code_id#">#ims_code# #ims_code_name#</option>
												</cfoutput>
											</cfif>
										</select>
										<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ims_codes&field_name=add_visit.ims_code_id','medium');"><img src="/images/plus_list.gif" border="0" align="top" title="<cf_get_lang dictionary_id ='57582.Ekle'>"></a>
										<a href="javascript://" onClick="remove_field('ims_code_id');"><img src="/images/delete_list.gif" border="0" title="<cf_get_lang dictionary_id='57463.Sil'>" style="cursor=hand" align="top"></a>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='39774.Ziyaret Nedeni'></label>
									<div class="col col-9 col-xs-12">
										<select name="visit_type" id="visit_type" multiple>
											<cfif len(attributes.visit_type)>
												<cfquery name="GET_VISIT_TYPE" datasource="#DSN#">
													SELECT VISIT_TYPE,VISIT_TYPE_ID FROM SETUP_VISIT_TYPES WHERE VISIT_TYPE_ID IN (#attributes.visit_type#)
												</cfquery>
												<cfoutput query="get_visit_type">
													<option value="#visit_type_id#">#visit_type#</option>
												</cfoutput>
											</cfif>
										</select>
										<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_visit_types&field_name=add_visit.visit_type&select_list=1&is_upd=0','small');"><img src="/images/plus_list.gif" border="0" align="top" title="<cf_get_lang dictionary_id ='57582.Ekle'>"></a>
										<a href="javascript://" onClick="remove_field('visit_type');"><img src="/images/delete_list.gif" border="0" title="<cf_get_lang dictionary_id='57463.Sil'>" style="cursor=hand" align="top"></a>
									</div>	
								</div>
							</div>
							
							<div class="col col-3 col-md-6 col-xs-12">
								<div class="form-group">
									<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='39773.Ziyaret Eden'></label>
									<div class="col col-9 col-xs-12">
										<select name="visit_emps" id="visit_emps" multiple>
											<cfif len(attributes.visit_emps)>
												<cfloop from="1" to="#listlen(attributes.visit_emps)#" index="i">
												<cfoutput>
													<option value="#listgetat(attributes.visit_emps, i, ',')#">#get_emp_info(listgetat(attributes.visit_emps, i, ','),1,0)#</option>
												</cfoutput>
												</cfloop>
											</cfif>
										</select>
										<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_multi_pars&field_name=add_visit.visit_emps&select_list=1&is_upd=0&is_multiple=1','list');"><img src="/images/plus_list.gif" border="0" align="top" title="<cf_get_lang dictionary_id ='57582.Ekle'>"></a>
										<a href="javascript://" onClick="remove_field('visit_emps');"><img src="/images/delete_list.gif" border="0" title="<cf_get_lang dictionary_id='57463.Sil'>" style="cursor=hand" align="top"></a>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='58437.Ziyaret Sonucu'></label>
									<div class="col col-9 col-xs-12">	
										<select name="visit_stage" id="visit_stage" style="width:200px;height:80px" multiple>
											<cfif len(attributes.visit_stage)>
												<cfquery name="GET_STAGE" datasource="#DSN#">
													SELECT VISIT_STAGE_ID, VISIT_STAGE FROM SETUP_VISIT_STAGES WHERE VISIT_STAGE_ID IN (#attributes.visit_stage#)
												</cfquery>
												<cfoutput query="get_stage">
													<option value="#visit_stage_id#">#visit_stage#</option>
												</cfoutput>
											</cfif>
										</select>
										<a href="javascript://" onClick="windowopen('windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_visit_stages&field_name=add_visit.visit_stage&select_list=1&is_upd=0','small');"><img src="/images/plus_list.gif" border="0" align="top" title="<cf_get_lang dictionary_id ='57582.Ekle'>"></a>
										<a href="javascript://" onClick="remove_field('visit_stage');"><img src="/images/delete_list.gif" border="0" title="<cf_get_lang dictionary_id='57463.Sil'>" style="cursor=hand" align="top"></a>
									</div>
								</div>
							</div>
								
							<div class="col col-3 col-md-6 col-xs-12">
								<div class="form-group">
									<div class="col col-9 col-xs-12">
										<div class="col col-6 col-xs-12">
										<select name="is_plan" id="is_plan">
											<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
											<option value="1" <cfif attributes.is_plan eq 1> selected</cfif>><cf_get_lang dictionary_id ='39771.Planlı'></option>
											<option value="2" <cfif attributes.is_plan eq 2> selected</cfif>><cf_get_lang dictionary_id ='39770.Plansız'></option>
										</select>
										</div>
										<span class="input-group-addon no-bg"></span>
										<div class="col col-6 col-xs-12">
										<select name="money" id="money">
											<option value=""><cf_get_lang dictionary_id ='57489.Para Br'></option>
											<cfoutput query="get_money">
												<option value="#money#" <cfif attributes.money eq money> selected</cfif>>#money#</option>
											</cfoutput>
										</select>
										</div>
									</div>
								</div>
								<div class="form-group">
									<div class="col col-9 col-xs-12">
										<div class="col col-12 col-xs-12">
											<select name="expense_item" id="expense_item">
												<option value=""><cf_get_lang dictionary_id ='39772.Harcama Kalemi'></option>
												<cfoutput query="get_expense">
													<option value="#expense_item_id#" <cfif expense_item_id eq attributes.expense_item> selected</cfif>>#expense_item_name#</option>
												</cfoutput>
											</select>
										</div>
									</div>
								</div>
								<div class="form-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'></cfsavecontent>
										<cfif len(attributes.start_date) and attributes.start_date neq 'NULL'>
											<cfset deger= dateformat(attributes.start_date,dateformat_style)>
										<cfelse>
											<cfset deger = "">
										</cfif>
										<cfif len(attributes.finish_date) and attributes.finish_date neq 'NULL'>
											<cfset deger2= dateformat(attributes.finish_date,dateformat_style)>
										<cfelse>
											<cfset deger2 = "">
										</cfif>
									<div class="col col-9 col-xs-12">
										<div class="col col-12 col-xs-12">
											<div class="input-group">
											<cfinput validate="#validate_style#" message="#message#" type="text" maxlength="10" name="start_date" id="start_date" value="#deger#">  
											<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>            
											<span class="input-group-addon no-bg"></span>
											<cfinput validate="#validate_style#" message="#message#" type="text" maxlength="10" name="finish_date" id="finish_date" value="#deger2#">
											<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>  
											</div>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="40029.harcama aralığı"></label>
									<div class="col col-6 col-xs-12">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id ='40298.Sayısal Değer Giriniz'></cfsavecontent>
										<div class="input-group">
											<cfinput type="text" name="visit_expense_start" validate="float" message="#message#" passthrough = "onKeyup='return(FormatCurrency(this,event));'" value="#tlformat(attributes.visit_expense_start)#" class="moneybox">
											<span class="input-group-addon no-bg"></span>
											<cfinput type="text" name="visit_expense_finish" validate="float" message="#message#" passthrough = "onKeyup='return(FormatCurrency(this,event));'" value="#tlformat(attributes.visit_expense_finish)#" class="moneybox">
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58608.İl'></label>
										<div class="col col-9 col-xs-12">
										<div class="input-group">
										<input type="hidden" name="city_id" id="city_id" value="<cfif Len(attributes.city_name)><cfoutput>#attributes.city_id#</cfoutput></cfif>">
                        				<input type="text" name="city_name" id="city_name" value="<cfoutput>#attributes.city_name#</cfoutput>" onFocus="AutoComplete_Create('city_name','CITY_NAME','CITY_NAME','get_city','0','CITY_ID,CITY_NAME','city_id,city_name','','3','170');" autocomplete="off">
										<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id ='57582.Ekle'>" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_city&field_id=add_visit.city_id&field_name=add_visit.city_name','small');"></span>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58638.İlçe'></label>
										<div class="col col-9 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="county_id" id="county_id" value="<cfif Len(attributes.county_name)><cfoutput>#attributes.county_id#</cfoutput></cfif>">
												  <input type="text" name="county_name" id="county_name" value="<cfoutput>#attributes.county_name#</cfoutput>" onkeyup="get_county()">
												  <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id ='57582.Ekle'>" onclick="pencere_ac_county();"></span>
											</div>
										</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57911.Çalıştır'></cfsavecontent>
							<label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked="checked"</cfif>></label>
							<cf_wrk_report_search_button search_function='control()' insert_info='#message#' button_type='1' is_excel="1">   
						</div>
					</div>
				</div>
			</div>
		</cf_report_list_search_area>
	</cf_report_list_search>
	
</cfform>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
	<!--- <cfset filename = "#createuuid()#"> --->
	<cfset filename = "detayli_ziyaret_raporu#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
    <cfheader name="Expires" value="#Now()#">
    <cfcontent type="application/vnd.msexcel;charset=utf-8">
    <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</cfif>

		<cf_report_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id ='57487.No'></th>
					<th><cf_get_lang dictionary_id ='39775.Ziyaret No'></th>
					<th><cf_get_lang dictionary_id ='39773.Ziyaret Eden'></th>
					<th><cf_get_lang dictionary_id ='39776.Plan'></th>
					<th><cf_get_lang dictionary_id ='57457.Müşteri'></th>
					<th><cf_get_lang dictionary_id ='57576.Çalışan'></th>
					<th><cf_get_lang dictionary_id ='58608.İl'></th>
					<th><cf_get_lang dictionary_id ='58638.İlçe'></th>
					<th><cf_get_lang dictionary_id ='57742.Tarih'></th>
					<th><cf_get_lang dictionary_id ='39774.Ziyaret Nedeni'></th>
					<th><cf_get_lang dictionary_id ='57684.Sonuç'></th>
					<th><cf_get_lang dictionary_id ='39772.Harcama Kalemi'></th>
					<th style="text-align:right;"><cf_get_lang dictionary_id ='40300.Harcama'></th>
					<!-- sil --><th width="20" nodraw="1">&nbsp;</th><!-- sil -->
				</tr>
			</thead>
			<tbody>
			<cfif GET_VISIT.recordcount gt 0>
				<cfoutput query="get_visit">
					<tr>
                        <td nwrap>#currentrow#</td>
                        <td>#event_plan_row_id#</td>
                        <td>#get_emp_info(event_pos_id,1,0)#</td>
                        <td nowrap valign="top">#event_plan_head#</td>
                        <td nowrap valign="top">#fullname#</td>
                        <td nowrap valign="top">#member_name# #member_surname#</td>
                        <td nowrap valign="top"><cfif len(city[currentrow]) and listfind(city_list,city[currentrow],',')>#get_city.city_name[listfind(city_list,city[currentrow],',')]#</cfif></td>
                        <td nowrap valign="top"><cfif len(county[currentrow]) and listfind(county_list,county[currentrow],',')>#get_county.county_name[listfind(county_list,county[currentrow],',')]#</cfif></td>
                        <td nowrap valign="top">#dateformat(start_date,dateformat_style)# #timeformat(start_date,timeformat_style)# - #dateformat(finish_date,dateformat_style)# #timeformat(finish_date, timeformat_style)#</td>
                        <td nowrap valign="top">#visit_type#</td>
                        <td nowrap valign="top"><cfif len(visit_stage[currentrow]) and listfind(visit_stage_list,visit_stage[currentrow],',')>#get_visit_stage.visit_stage[listfind(visit_stage_list,visit_stage[currentrow],',')]#</cfif></td>
                        <td nowrap valign="top"><cfif len(expense_item[currentrow]) and listfind(expense_item_list,expense_item[currentrow],',')>#get_expense.expense_item_name[listfind(expense_item_list,expense_item[currentrow],',')]#</cfif></td>
                        <td valign="top" nowrap style="text-align:right;">#tlformat(expense)# #money_currency#</td>
                        <!-- sil -->
                        <td width="20" nodraw="1">
                            <cfif type eq 1>
                                <cfset member_link = "partner_id=#member_id#">
                            <cfelse>
                                <cfset member_link = "consmuer_id=#member_id#">
                            </cfif>
                            <cfif event_plan_id eq "">
                                <cfif len(result_record_emp)>
                                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.popup_form_upd_visit&eventid=#event_plan_id#&event_plan_row_id=#event_plan_row_id#&#member_link#&is_report=1','print_page');"><img src="/images/time.gif" border="0"></a>									
                                <cfelse>
                                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.popup_form_upd_visit&eventid=#event_plan_id#&event_plan_row_id=#event_plan_row_id#&#member_link#&is_report=1','print_page');"><img src="/images/time.gif" border="0"></a>																		
                                </cfif>
                            <cfelse>
                                <cfif len(result_record_emp)>
                                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_upd_event_plan_result&eventid=#event_plan_id#&event_plan_row_id=#event_plan_row_id#&#member_link#&is_report=1','print_page');"><img src="/images/time.gif" border="0"></a>																	
                                <cfelse>
                                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_add_event_plan_result&eventid=#event_plan_id#&event_plan_row_id=#event_plan_row_id#&#member_link#&is_report=1','print_page');"><img src="/images/time.gif" border="0"></a>								
                                </cfif>
                            </cfif>
                        </td>
						<!-- sil -->
					</tr>
               <!---     </cf_wrk_html_tr> --->
				</cfoutput>
			<cfelse>
				<tr> 
					<td colspan="14"><cfif isdefined("attributes.form_submitted") and attributes.form_submitted eq 1><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
				</tr>
			</cfif>
			</tbody>
		</cf_report_list>
      
    

<script type="text/javascript">
	function get_county()
	{
		city_id = document.getElementById('city_id').value;
		if(document.add_visit.city_id.value != "" || document.add_visit.city_name.value != "")
		AutoComplete_Create('county_name','COUNTY_NAME,CITY_NAME','COUNTY_NAME,CITY_NAME','get_county',city_id,'county_name,COUNTY_ID','county_name,county_id');
		else
		alert("<cf_get_lang dictionary_id ='40637.Önce İl Seçmelisiniz'>!");
	}
	function pencere_ac_county(no)
	{
		if (document.add_visit.city_id.value == "" || document.add_visit.city_name.value == "")
			alert("<cf_get_lang dictionary_id ='40637.Önce İl Seçmelisiniz'>!");
		else
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=add_visit.county_id&field_name=add_visit.county_name&city_id=' + document.add_visit.city_id.value,'small');
	}
	
	function remove_field(field_option_name)
	{
		field_option_name_value = eval('document.add_visit.' + field_option_name);
		for (i=field_option_name_value.options.length-1;i>-1;i--)
		{
			if (field_option_name_value.options[i].selected==true)
			{
				field_option_name_value.options.remove(i);
			}	
		}
	}
	function select_all(selected_field)
	{
		var m = eval("document.add_visit." + selected_field + ".length");
		for(i=0;i<m;i++)
		{
			eval("document.add_visit."+selected_field+"["+i+"].selected=true")
		}
	}
	function control()
	{
		select_all('visit_emps');
		select_all('ims_code_id');
		select_all('visit_type');
		select_all('visit_stage'); 
		document.add_visit.visit_expense_start.value = filterNum(document.add_visit.visit_expense_start.value);
		document.add_visit.visit_expense_finish.value = filterNum(document.add_visit.visit_expense_finish.value);

		if((add_visit.visit_emps.value == "") && (add_visit.ims_code_id.value == "") && (add_visit.visit_type.value == "") && (add_visit.company_type.value == "") && (add_visit.visit_stage.value == "") && (add_visit.branch_id.value == "") && ((add_visit.start_date.value == "") || (add_visit.start_date.value == "")) && (add_visit.expense_item.value == "") && ((add_visit.visit_expense_start.value == "") && (add_visit.visit_expense_finish.value == "")))
		{
			alert("<cf_get_lang dictionary_id ='40299.Diğer Arama Kriterlerinden En Az Bir Tanesini Seçmelisiniz'> !");
			return false;
		}
		else 
		{
			if(document.add_visit.is_excel.checked==false)
			{
				document.add_visit.action="<cfoutput>#request.self#?fuseaction=report.detail_visit_report</cfoutput>"
				return true;
			}
			else
				document.add_visit.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_detail_visit_report</cfoutput>"
		}
	}
</script>
