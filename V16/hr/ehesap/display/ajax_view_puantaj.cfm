<!---
    File: V16\hr\ehesap\display\ajax_view_puantaj.cfm
    Edit: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2020-11-13
    Description: Puantaj Listeleme
        
    History:
        
    To Do:

--->
<cfsetting showdebugoutput="no">
<cfset payroll_cmp = createObject("component","V16.hr.ehesap.cfc.payroll_job") />
<cfparam name="attributes.puantaj_type" default="-1">
<cfparam name="attributes.ssk_statue" default="1">
<cfparam name="attributes.statue_type" default="0">
<cfparam name="attributes.statue_type_individual" default="0">

<cfif attributes.statue_type eq 5 or attributes.statue_type eq 1 or attributes.statue_type eq 11>
	<cfinclude template="../query/get_program_parameter.cfm">
	<cfif (isdefined("get_program_parameters.FIRST_DAY_MONTH") and len(get_program_parameters.FIRST_DAY_MONTH) and not(get_program_parameters.FIRST_DAY_MONTH eq 1 and get_program_parameters.LAST_DAY_MONTH eq 0))>
		<cfset start_date_new = CreateDateTime(attributes.sal_year,attributes.sal_mon,get_program_parameters.FIRST_DAY_MONTH,0,0,0)>
		<cfset finish_date_new = CreateDateTime(attributes.sal_year,attributes.sal_mon,get_program_parameters.LAST_DAY_MONTH,0,0,0)>
		<cfset finish_date_new = dateadd("m",1,finish_date_new)>
	</cfif>
</cfif>
<cfif isdefined("attributes.puantaj_id")>
    <cfinclude template="../query/get_puantaj.cfm">
	<cfif get_puantaj.recordcount>
		<cfset attributes.puantaj_id = get_puantaj.puantaj_id>
		<cfset attributes.sal_mon = get_puantaj.sal_mon>
		<cfset attributes.sal_year = get_puantaj.sal_year>
		<cfset attributes.puantaj_type = get_puantaj.puantaj_type>
		<cfset attributes.ssk_office = "#get_puantaj.ssk_office#-#get_puantaj.ssk_office_no#-#get_puantaj.ssk_branch_id#">
		<cfinclude template="../query/get_puantaj_rows.cfm">
		<cfset attributes.SSK_OFFICE = attributes.BRANCH_ID>
		<cfset from_ajax_view_puantaj = 1>
		<cfinclude template="../query/get_ssk_employees.cfm">
		
		<cfset employee_ids = ValueList(get_ssk_employees.employee_id,",")>
		<cfset in_out_ids = ValueList(get_ssk_employees.in_out_id,",")>
		<cfset payroll_control = payroll_cmp.PAYROLL_JOB_CONTROL(
			branch_id : attributes.branch_id,
			month : attributes.sal_mon,
			year : attributes.sal_year,
			payroll_type : attributes.puantaj_type,
			statue : attributes.ssk_statue,
			statue_type : attributes.statue_type,
			jury_membership : attributes.statue_type eq 6 ? 1 : 0,
			land_compensation_score :  attributes.statue_type eq 7 ? 1 : 0,
			start_date_new : isdefined("start_date_new") ? start_date_new : '',
			finish_date_new : isdefined("finish_date_new") ? finish_date_new : '',
			statue_type_individual : isDefined("attributes.statue_type_individual") ? attributes.statue_type_individual : 0
		)>
	
		<cfif payroll_control.recordcount eq 0><!--- Eğer kayıt yoksa --->
		 	<cfset set_emp = payroll_cmp.ADD_PAYROLL_JOB(
					branch_id : attributes.branch_id,
					month : attributes.sal_mon,
					year : attributes.sal_year,
					employee_ids : employee_ids,
					in_out_ids : in_out_ids,
					payroll_type : attributes.puantaj_type,
					statue : attributes.ssk_statue,
					statue_type : attributes.statue_type,
					jury_membership : attributes.statue_type eq 6 ? 1 : 0,
					land_compensation_score :  attributes.statue_type eq 7 ? 1 : 0,
					statue_type_individual : isDefined("attributes.statue_type_individual") ? attributes.statue_type_individual : 0
			)>  
		<cfelseif payroll_control.recordcount lt get_ssk_employees.recordcount> <!--- Eğer şubeye sonradan birisi eklendiyse--->
			<cfset payroll_employee_ids = ValueList(payroll_control.employee_id,",")>
			<cfset payroll_in_out_ids =  ValueList(payroll_control.in_out_id,",")>
			<cfset theArray1 = listToArray(payroll_employee_ids)>
			<cfset theArray2= listToArray(employee_ids)>
			<cfset cmp_employee_id =  listCompare(employee_ids,payroll_employee_ids)>
			<cfset cmp_in_out_ids = listCompare(in_out_ids,payroll_in_out_ids)>
			<cfset set_emp = payroll_cmp.ADD_PAYROLL_JOB(
					branch_id : attributes.branch_id,
					month : attributes.sal_mon,
					year : attributes.sal_year,
					employee_ids : cmp_employee_id,
					puantaj_id : attributes.puantaj_id,
					payroll_type : attributes.puantaj_type,
					in_out_ids : cmp_in_out_ids,
					statue : attributes.ssk_statue,
					statue_type : attributes.statue_type,
					jury_membership : attributes.statue_type eq 6 ? 1 : 0,
					land_compensation_score :  attributes.statue_type eq 7 ? 1 : 0,
					statue_type_individual : isDefined("attributes.statue_type_individual") ? attributes.statue_type_individual : 0
			)>  
		</cfif>
		<cfset get_payroll = payroll_cmp.PAYROLL_JOB_CONTROL(
			branch_id : attributes.branch_id,
			month : attributes.sal_mon,
			year : attributes.sal_year,
			payroll_type : attributes.puantaj_type,
			statue : attributes.ssk_statue,
			statue_type : attributes.statue_type,
			jury_membership : attributes.statue_type eq 6 ? 1 : 0,
			land_compensation_score :  attributes.statue_type eq 7 ? 1 : 0,
			start_date_new : isdefined("start_date_new") ? start_date_new : '',
			finish_date_new : isdefined("finish_date_new") ? finish_date_new : '',
			statue_type_individual : isDefined("attributes.statue_type_individual") ? attributes.statue_type_individual : 0
		)>
	<cfelse>
		<cfset get_puantaj_rows.recordcount =0>
	</cfif>
	<cfif fusebox.use_period>
		<cfif isdefined("attributes.puantaj_id")>
			<cfquery name="get_dekont" datasource="#dsn#">
				SELECT PUANTAJ_ID FROM EMPLOYEES_PUANTAJ_CARI_ACTIONS WHERE PUANTAJ_ID = #attributes.puantaj_id#
			</cfquery>
		<cfelse>
			<cfset get_dekont.recordcount = 0>
		</cfif>
	</cfif>
<cfelseif isdefined("attributes.employee_id") and len(attributes.employee_id)>
	<cfquery name="get_puantaj_rows" datasource="#dsn#">
		SELECT
			EMPLOYEES_PUANTAJ_ROWS.*,
			ISNULL((SELECT SUM(VERGI_ISTISNA_AMOUNT) FROM EMPLOYEES_PUANTAJ_ROWS_EXT EEP WHERE EEP.EMPLOYEE_PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID AND EEP.EXT_TYPE = 2),0) VERGI_ISTISNA_AMOUNT,
			EMPLOYEES_PUANTAJ.*,
			EMPLOYEES_IDENTY.TC_IDENTY_NO,
			EMPLOYEES.EMPLOYEE_NAME,
			EMPLOYEES.EMPLOYEE_SURNAME,
	        ISNULL((SELECT SUM(VERGI_ISTISNA_AMOUNT) AS VERGI_ISTISNA_AMOUNT FROM EMPLOYEES_PUANTAJ_ROWS_EXT RE WHERE RE.EXT_TYPE = 2 AND RE.EMPLOYEE_PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID AND RE.VERGI_ISTISNA_AMOUNT IS NOT NULL),0) AS VERGI_ISTISNA_AMOUNT_                    
		FROM
		<cfif not session.ep.ehesap>
			BRANCH,
		</cfif>
			EMPLOYEES,
			EMPLOYEES_PUANTAJ,
			EMPLOYEES_IDENTY,
			EMPLOYEES_PUANTAJ_ROWS
		WHERE
			EMPLOYEES_IDENTY.EMPLOYEE_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID AND
			EMPLOYEES_PUANTAJ.PUANTAJ_TYPE = #attributes.puantaj_type# AND
			EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID AND
			EMPLOYEES.EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND
			EMPLOYEES_PUANTAJ.PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID AND
			EMPLOYEES_PUANTAJ.SAL_YEAR = #attributes.SAL_YEAR# AND
			EMPLOYEES_PUANTAJ.SAL_MON = #attributes.SAL_MON#
		<cfif not session.ep.ehesap>
			<!---AND BRANCH.SSK_OFFICE = EMPLOYEES_PUANTAJ.SSK_OFFICE
			AND BRANCH.SSK_NO = EMPLOYEES_PUANTAJ.SSK_OFFICE_NO--->
			AND BRANCH.BRANCH_ID = EMPLOYEES_PUANTAJ.SSK_BRANCH_ID
            AND BRANCH.BRANCH_ID IN (
								SELECT
									BRANCH_ID
								FROM
									EMPLOYEE_POSITION_BRANCHES
								WHERE
									POSITION_CODE = #session.ep.position_code#
								)
		</cfif>
		<cfif isdefined("attributes.ssk_statue") and len(attributes.ssk_statue)>
			AND EMPLOYEES_PUANTAJ.STATUE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ssk_statue#">
			<cfif attributes.ssk_statue eq 2>
				AND EMPLOYEES_PUANTAJ.STATUE_TYPE = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.statue_type#">
			</cfif>
        </cfif>
		ORDER BY
			EMPLOYEES.EMPLOYEE_NAME,
			EMPLOYEES.EMPLOYEE_SURNAME
	</cfquery>
	<cfif not get_puantaj_rows.recordcount>
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
			<cf_box title="#getLang('','Bordro ve Puantaj','47073')#" uidrop="1" module="puantaj_list_layer">
				<cf_get_lang dictionary_id='57484.Kayıt Yok'>!
			</cf_box>
		</div>
	</cfif>
<cfelse>
	<!--- Kayıt yoksa şubedeki kişiler bulunup payroll_job tablosuna kayıt kayıt atılır Esma R. Uysal--->
	<cftry>
		<cfset factor_diff = 0>
		<cfif attributes.statue_type eq 5>
			<cfset start_month = CreateDateTime(attributes.sal_year,attributes.sal_mon,1,0,0,0)>
			<cfset end_month = CreateDateTime(attributes.sal_year,attributes.sal_mon,daysinmonth(createdate(attributes.sal_year,attributes.sal_mon,1)),0,0,0)>

			<!--- Önceki ay --->
			<cfset start_month_past = dateadd("m",1,start_month)>
			<cfset end_month_past = dateadd("m",1,end_month)>

			<cfset get_factor_cmp = createObject('component','V16.hr.ehesap.cfc.payroll_job')>

			<cfset get_factor_past = get_factor_cmp.get_factor_definition(
				start_month : start_month_past,
				end_month : end_month_past
			)>

			<cfset get_factor = get_factor_cmp.get_factor_definition(
				start_month : start_month,
				end_month : end_month
			)>		
			<cfif get_factor.salary_factor eq get_factor_past.salary_factor>
				<cfset factor_diff = 1>
			</cfif>
		</cfif>

		<cfset get_puantaj_rows.recordcount = 0>
		<cfset attributes.SSK_OFFICE = attributes.BRANCH_ID>
		<cfinclude template="../query/get_ssk_employees.cfm">
		<cfset employee_ids = ValueList(get_ssk_employees.employee_id,",")>
		<cfset in_out_ids = ValueList(get_ssk_employees.in_out_id,",")>

		<cfset payroll_control = payroll_cmp.PAYROLL_JOB_CONTROL(
			branch_id : attributes.branch_id,
			month : attributes.sal_mon,
			year : attributes.sal_year,
			payroll_type : attributes.puantaj_type,
			statue : attributes.ssk_statue,
			statue_type : attributes.statue_type,
			jury_membership : attributes.statue_type eq 6 ? 1 : 0,
			land_compensation_score :  attributes.statue_type eq 7 ? 1 : 0,
			start_date_new : isdefined("start_date_new") ? start_date_new : '',
			finish_date_new : isdefined("finish_date_new") ? finish_date_new : '',
			statue_type_individual : isDefined("attributes.statue_type_individual") ? attributes.statue_type_individual : 0
		)>
		<cfif payroll_control.recordcount eq 0><!--- Eğer kayıt yoksa --->
		 	<cfset set_emp = payroll_cmp.ADD_PAYROLL_JOB(
					branch_id : attributes.branch_id,
					month : attributes.sal_mon,
					year : attributes.sal_year,
					employee_ids : employee_ids,
					in_out_ids : in_out_ids,
					payroll_type : attributes.puantaj_type,
					statue : attributes.ssk_statue,
					statue_type : attributes.statue_type,
					jury_membership : attributes.statue_type eq 6 ? 1 : 0,
					land_compensation_score :  attributes.statue_type eq 7 ? 1 : 0,
					statue_type_individual : isDefined("attributes.statue_type_individual") ? attributes.statue_type_individual : 0
			)>  
		<cfelseif payroll_control.recordcount lt get_ssk_employees.recordcount> <!--- Eğer şubeye sonradan birisi eklendiyse--->
			<cfset payroll_employee_ids = ValueList(payroll_control.employee_id,",")>
			<cfset payroll_in_out_ids =  ValueList(payroll_control.in_out_id,",")>
			<cfset theArray1 = listToArray(payroll_employee_ids)>
			<cfset theArray2= listToArray(employee_ids)>
			<cfset cmp_employee_id =  listCompare(employee_ids,payroll_employee_ids)>
			<cfset cmp_in_out_ids = listCompare(in_out_ids,payroll_in_out_ids)>
			<cfset set_emp = payroll_cmp.ADD_PAYROLL_JOB(
					branch_id : attributes.branch_id,
					month : attributes.sal_mon,
					year : attributes.sal_year,
					employee_ids : cmp_employee_id,
					payroll_type : attributes.puantaj_type,
					in_out_ids : cmp_in_out_ids,
					statue : attributes.ssk_statue,
					statue_type : attributes.statue_type,
					jury_membership : attributes.statue_type eq 6 ? 1 : 0,
					land_compensation_score :  attributes.statue_type eq 7 ? 1 : 0,
					statue_type_individual : isDefined("attributes.statue_type_individual") ? attributes.statue_type_individual : 0
			)>  
		</cfif>
		<cfset get_payroll = payroll_cmp.PAYROLL_JOB_CONTROL(
			branch_id : attributes.branch_id,
			month : attributes.sal_mon,
			year : attributes.sal_year,
			payroll_type : attributes.puantaj_type,
			statue : attributes.ssk_statue,
			statue_type : attributes.statue_type,
			jury_membership : attributes.statue_type eq 6 ? 1 : 0,
			land_compensation_score :  attributes.statue_type eq 7 ? 1 : 0,
			start_date_new : isdefined("start_date_new") ? start_date_new : '',
			finish_date_new : isdefined("finish_date_new") ? finish_date_new : '',
			statue_type_individual : isDefined("attributes.statue_type_individual") ? attributes.statue_type_individual : 0
		)>
		
		<input type="hidden" name="record_count" id="record_count" value="<cfoutput><cfif get_payroll.recordCount>#get_payroll.recordCount#<cfelse>0</cfif></cfoutput>" >
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
			<cfsavecontent  variable="title">
				<cf_get_lang dictionary_id='47073.Payroll and Timekeeping'>
			</cfsavecontent>
			<cf_box title="#title#" uidrop="1" module="puantaj_list_layer">
				<div class="col col-12 release_info">
					<div class="before-release col col-12">
						<div class="col-md-12 mt-3">
							<p><i class="fa fa-2x fa-bookmark-o"></i> : <cf_get_lang dictionary_id = "52128.Çalıştırmaya hazır"></p> 
							<p><i class="fa fa-2x fa-bookmark flagTrue"></i> : <cf_get_lang dictionary_id = "52131.Başarılı bir şekilde çalıştırıldı"></p> 
							<p><i class="fa fa-2x fa-bookmark flagFalse"></i> : <cf_get_lang dictionary_id = "52151.Çalıştırılamadı">(<cf_get_lang dictionary_id='65098.Hata çıktısı için üzerine basınız'>)</p>
						</div>
					</div>
				</div>
				<div class="col col-12 col-md-12 mt-3">
					<cf_flat_list>
						<cfoutput>
							<thead>
								<tr>
									<th><cf_get_lang no='163.Sıra No'></th>
									<th><cf_get_lang_main no='158.Adı Soyadı'></th>
									<th><cf_get_lang no='1319.TC No'></th>
									<th width="50">
										<cfsavecontent variable = "payroll_title"><cf_get_lang dictionary_id='31444.Payroll'></cfsavecontent> 
										<label title="#payroll_title#">#left(payroll_title,1)#</label>
									</th>
									<th width="50">
										<cfsavecontent variable = "acoount_title"><cf_get_lang dictionary_id='57447.Account'></cfsavecontent> 
										<label title="#acoount_title#">#left(acoount_title,1)#</label>
									</th>
									<th width="50">
										<cfsavecontent variable = "budget_title"><cf_get_lang dictionary_id='57559.Budget'></cfsavecontent> 
										<label title="#budget_title#">#left(budget_title,1)#</label>
									</th>
									<th></th>
									<th></th>
								</tr>
							</thead>
						</cfoutput>
						<tbody>
							<cfif factor_diff eq 0>
								<cfif get_payroll.recordCount>
									<cfoutput query="get_payroll">
										<tr>
											<td>#currentrow#</td>
											<td> <cfset emp_info =  get_emp_info(employee_id,0,0) >
												<a href="#request.self#?fuseaction=ehesap.list_salary&event=upd&employee_id=#employee_id#&in_out_id=#in_out_id#&empName=#UrlEncodedFormat('#emp_info#')#" target="_blank">#get_emp_info(employee_id,0,0)#</a>
											</td>
											<td>#TC_IDENTY_NO#</td>
											<td>
												<i class="fa fa-2x fa-bookmark-o"></i>
												<input type="checkbox" data-type="fileids" name="fileids_#in_out_id#" id="fileids_#in_out_id#" data-id="fileids_#currentrow#" value="#in_out_id#" checked style="display:none;">
												<input type="checkbox" data-type="inoutid_" name="inoutid_#in_out_id#" id="inoutid_#in_out_id#" data-id="inoutid_#currentrow#" value="#in_out_id#" checked style="display:none;">
											</td>
											<td>
												<i class="fa fa-2x fa-bookmark-o"></i>
												<input type="checkbox" data-type="account" name="account_#in_out_id#" id="account_#in_out_id#" data-id="account_#currentrow#" value="#in_out_id#" checked style="display:none;">
											</td>
											<td>
												<i class="fa fa-2x fa-bookmark-o"></i>
												<input type="checkbox" data-type="budget" name="budget_#in_out_id#" id="budget_#in_out_id#" data-id="budget_#currentrow#" value="#in_out_id#" checked style="display:none;">
											</td>
											<td width="20px"><i class="fa fa-lg fa-print" id="print_#in_out_id#" style="display:none"></i></td>
											<td width="20px"><i class="fa fa-lg fa-refresh" id="refresh_#in_out_id#" style="display:none"></i></td>
										</tr>
										<tr>
											<td style="display:none;" id="tr_#in_out_id#" colspan="9"></td>
										</tr>
									</cfoutput>
								<cfelse>
									<tr><td colspan="9"><cf_get_lang dictionary_id='64299.Şubede çalışan kaydı bulunamadı'>!</td></tr>
								</cfif>
							<cfelse>
								<tr><td colspan="9"><cf_get_lang dictionary_id='64324.Seçilen ay için fark bordrosu oluşturulamamaktadır!'></td></tr>
							</cfif>
						</tbody>
					</cf_flat_list>
				</div>
			</cf_box>
		</div>
		<cfcatch type="any">
			<cfdump var="#cfcatch#">
		</cfcatch>
	</cftry>
</cfif>
<cfif isdefined("get_puantaj_rows.recordcount") and get_puantaj_rows.recordcount>
	<cfset aydaki_gun = daysinmonth(CREATEDATE(attributes.sal_year,attributes.SAL_MON,1))>
	<cfif isdefined("attributes.puantaj_id")>
		<!--- şube puantaj --->
		<cfinclude template="view_puantaj_sube.cfm">
	<cfelseif isdefined("attributes.employee_id") and len(attributes.employee_id)>
		<!--- kişi puantaj ---> 
		<cfinclude template="view_puantaj_kisi.cfm">
	</cfif>
</cfif>