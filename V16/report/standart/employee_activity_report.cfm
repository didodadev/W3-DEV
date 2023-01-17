<cfparam name="attributes.module_id_control" default="3,48">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.start_date2" default="">
<cfparam name="attributes.finish_date2" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.is_active" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department_name" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.is_excel" default="">


<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif len(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
</cfif>
<cfif len(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
</cfif>
<cfif len(attributes.start_date2)>
	<cf_date tarih='attributes.start_date2'>
</cfif>
<cfif len(attributes.finish_date2)>
	<cf_date tarih='attributes.finish_date2'>
</cfif>

<cfquery name="GET_BRANCH" datasource="#dsn#">
	SELECT BRANCH_ID, BRANCH_NAME FROM BRANCH WHERE BRANCH_STATUS = 1 <cfif not session.ep.ehesap>AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)</cfif>
</cfquery>

<cfquery name="GET_SALES_ZONES_TEAM" datasource="#dsn#">
	SELECT 
		SALES_ZONES_TEAM.TEAM_ID,
		SALES_ZONES.SZ_ID,
		SALES_ZONES_TEAM.TEAM_NAME,
		SALES_ZONES.SZ_NAME
	FROM 
		SALES_ZONES_TEAM,
		SALES_ZONES
	WHERE 
		SALES_ZONES.SZ_ID = SALES_ZONES_TEAM.SALES_ZONES
	ORDER BY 
		SALES_ZONES_TEAM.TEAM_NAME
</cfquery>

<cfsavecontent variable="head"><cf_get_lang dictionary_id="39574.Çalışan Faaliyet Raporu"></cfsavecontent>
<cfform name="searchreport" action="#request.self#?fuseaction=report.employee_activity_report" method="post">
	<cf_report_list_search title="#head#">
		<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<input type="hidden" name="is_submitted" id="is_submitted" value="1"/>
							<div class="col col-4 col-md-6 col-xs-12">	
								<div class="col col-12 col-md-12 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='29434.Şubeler'>*</label>
											<div class="col col-12 col-md-12 col-xs-12">	
												<select name="branch_id" id="branch_id" onchange="hesaplawindow();">
													<option value=""><b><cf_get_lang dictionary_id='57734.Seçiniz'></b></option>
													<cfoutput query="get_branch">
														<option value="0,#branch_id#" <cfif (listfirst(attributes.branch_id,',') eq 0) and (listlast(attributes.branch_id,',') eq branch_id)>selected</cfif>>&nbsp;&nbsp;&nbsp;#branch_name#</option>
													</cfoutput>
													<option value=""><b><cf_get_lang dictionary_id='57803.Satış Takımları'></b></option>
													<cfoutput query="get_sales_zones_team">
														<option value="1,#team_id#" <cfif (listfirst(attributes.branch_id,',') eq 1) and (listlast(attributes.branch_id,',') eq team_id)>selected</cfif>>&nbsp;&nbsp;&nbsp;#team_name#</option>
													</cfoutput>
												</select>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='57572.Departman'></label>
											<div class="col col-12 col-md-12 col-xs-12">
												<div class="input-group">
													<input type="hidden" name="department_id" id="department_id" value="<cfoutput>#attributes.department_id#</cfoutput>">
													<input type="text" name="department_name" id="department_name" value="<cfoutput>#attributes.department_name#</cfoutput>" onFocus="AutoComplete_Create('department_name','DEPARTMENT_HEAD,COMMENT','DEPARTMENT_NAME','get_department_location','','DEPARTMENT_ID,LOCATION_ID,BRANCH_ID','department_id,location_id,branch_id','','3','200');">
													<span class="input-group-addon btnPointer icon-ellipsis"  onclick="gonderdeger();"></span>
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='49901.Kayıt Başlangıç Tarihi'></label>
											<div class="col col-12 col-md-12 col-xs-12">
												<div class="input-group">
													<cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz!'></cfsavecontent>
													<cfinput type="text" name="start_date" id="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" style="width:70px;">
													<span class="input-group-addon">
														<cf_wrk_date_image date_field="start_date">
													</span>
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='49902.Kayıt Bitiş Tarihi'></label>
											<div class="col col-12 col-md-12 col-xs-12">
												<div class="input-group">
													<cfinput type="text" name="finish_date" id="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" style="width:70px;">
													<span class="input-group-addon">
														<cf_wrk_date_image date_field="finish_date">
													</span>
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
											<div class="col col-12 col-md-12 col-xs-12">
												<div class="input-group">
													<cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz!'></cfsavecontent>
													<cfinput type="text" name="start_date2" id="start_date2" value="#dateformat(attributes.start_date2,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" style="width:70px;">
													<span class="input-group-addon">
														<cf_wrk_date_image date_field="start_date2">
													</span>
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
											<div class="col col-12 col-md-12 col-xs-12">
												<div class="input-group">
													<cfinput type="text" name="finish_date2" id="finish_date2" value="#dateformat(attributes.finish_date2,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" style="width:70px;">
													<span class="input-group-addon">
														<cf_wrk_date_image date_field="finish_date2">
													</span>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
							<input type="hidden" name="is_active" id="is_active" value="1">
							<div class="col col-2 col-md-3 col-xs-12 paddingNone">
								<div class="col col-12 col-md-12 col-xs-12 paddingNone">
									<div class="col col-12 col-md-12 col-xs-12 paddingNone">
										<div class="form-group">
											<label><input type="checkbox" name="is_company" id="is_company" <cfif isdefined("attributes.is_company")>checked</cfif>>&nbsp;<cf_get_lang dictionary_id ='39927.Kurumsal Üye Bilgisi'></label>
										</div>
										<div class="form-group">	
											<label><input type="checkbox" name="is_partner" id="is_partner" <cfif isdefined("attributes.is_partner")>checked</cfif>>&nbsp;<cf_get_lang dictionary_id ='29828.Kurumsal Üye Çalışanı'></label>
										</div>
										<div class="form-group">	
											<label><input type="checkbox" name="is_consumer" id="is_consumer" <cfif isdefined("attributes.is_consumer")>checked</cfif>>&nbsp;<cf_get_lang dictionary_id ='39929.Bireysel Üye Bilgisi'></label>
										</div>
										<div class="form-group">	
											<label><input type="checkbox" name="is_sales" id="is_sales" <cfif isdefined("attributes.is_sales")>checked</cfif>>&nbsp;<cf_get_lang dictionary_id ='30096.Satış Fatura'></label>
										</div>
										<div class="form-group">	
											<label><input type="checkbox" name="is_work" id="is_work" <cfif isdefined("attributes.is_work")>checked</cfif>>&nbsp;<cf_get_lang dictionary_id ='39931.Görev'></label>
										</div>
										<div class="form-group">	
											<label><input type="checkbox" name="is_offer" id="is_offer" <cfif isdefined("attributes.is_offer")>checked</cfif>>&nbsp;<cf_get_lang dictionary_id ='57545.Teklif'>(<cf_get_lang dictionary_id ='39932.Satış Çalışan'>)</label>
										</div>
										<div class="form-group">
											<label><input type="checkbox" name="is_agenda" id="is_agenda" <cfif isdefined("attributes.is_agenda")>checked</cfif>>&nbsp;<cf_get_lang dictionary_id ='57415.Ajanda'></label>
										</div>
										<div class="form-group">
											<label><input type="checkbox" name="is_minutes" id="is_minutes" <cfif isdefined("attributes.is_minutes")>checked</cfif>>&nbsp;<cf_get_lang dictionary_id ='39486.Tutanak'></label>
										</div>
										<div class="form-group">
											<label><input type="checkbox" name="is_offer_plus" id="is_offer_plus" <cfif isdefined("attributes.is_offer_plus")>checked</cfif>>&nbsp;<cf_get_lang dictionary_id ='39933.Teklif Takibi'></label>
										</div>
										<div class="form-group">
											<label><input type="checkbox" name="is_visit_plan" id="is_visit_plan" <cfif isdefined("attributes.is_visit_plan")>checked</cfif>>&nbsp;<cf_get_lang dictionary_id ='58422.Ziyaret Planı'></label>
										</div>
										<div class="form-group">
											<label><input type="checkbox" name="is_order" id="is_order" <cfif isdefined("attributes.is_order")>checked</cfif>>&nbsp;<cf_get_lang dictionary_id ='57611.Sipariş'></label>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-2 col-md-3 col-xs-12">
								<div class="col col-12 col-md-12 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">
										<div class="form-group">
											<label><input type="checkbox" name="is_visit_part" id="is_visit_part" <cfif isdefined("attributes.is_visit_part")>checked</cfif>>&nbsp;<cf_get_lang dictionary_id ='58422.Ziyaret Planı'><cf_get_lang dictionary_id ='29780.Katılımcı'></label>
										</div>
										<div class="form-group">
											<label><input type="checkbox" name="is_visit_result" id="is_visit_result" <cfif isdefined("attributes.is_visit_result")>checked</cfif>>&nbsp;<cf_get_lang dictionary_id ='39934.Ziyaret Planı Sonucu'></label>
										</div>
										<div class="form-group">
											<label><input type="checkbox" name="is_purchase" id="is_purchase" <cfif isdefined("attributes.is_purchase")>checked</cfif>>&nbsp;<cf_get_lang dictionary_id ='39503.Alış Fatura'></label>
										</div>
										<div class="form-group">
											<label><input type="checkbox" name="is_system" id="is_system" <cfif isdefined("attributes.is_system")>checked</cfif>>&nbsp;<cf_get_lang dictionary_id='58832.Abone'></label>
										</div>
										<div class="form-group">
											<label><input type="checkbox" name="is_opportunity_plus" id="is_opportunity_plus" <cfif isdefined("attributes.is_opportunity_plus")>checked</cfif>>&nbsp;<cf_get_lang dictionary_id ='39935.Fırsat Takibi'></label>
										</div>
										<div class="form-group">
											<label><input type="checkbox" name="is_agenda_participation" id="is_agenda_participation" <cfif isdefined("attributes.is_agenda_participation")>checked</cfif>>&nbsp;<cf_get_lang dictionary_id ='39936.Ajanda Katılımcısı'></label>				
										</div>
										<div class="form-group">
											<label><input type="checkbox" name="is_interaction" id="is_interaction" <cfif isdefined("attributes.is_interaction")>checked</cfif>>&nbsp;<cf_get_lang dictionary_id='58729.Etkileşimler'></label>
										</div>
										<div class="form-group">
											<label><input type="checkbox" name="is_campaing_email" id="is_campaing_email" <cfif isdefined("attributes.is_campaing_email")>checked</cfif>>&nbsp;<cf_get_lang dictionary_id ='57446.Kampanya'><cf_get_lang dictionary_id ='40572.Emailleşme'></label>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
							<label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
							<input name="is_submitted" id="is_submitted" value="1" type="hidden">
							<cf_wrk_report_search_button button_type="1" is_excel='1' search_function="searchcontrol()">
						</div>
					</div>
				</div>
			</div> 
		</cf_report_list_search_area>
	</cf_report_list_search>
</cfform>
<cfif attributes.is_excel eq 1>
	<cfset type_ = 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-8">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cfelse>
	<cfset type_ = 0>
</cfif>
<cfif len(attributes.is_active)>

<cf_report_list>
		<cfif listfirst(attributes.branch_id) eq 0>
			<cfquery name="GET_LOCATION" datasource="#DSN#">
				SELECT 
					DEPARTMENT.DEPARTMENT_ID,
					DEPARTMENT.DEPARTMENT_HEAD,
					BRANCH.BRANCH_NAME,
					OUR_COMPANY.COMPANY_NAME 
				FROM 
					DEPARTMENT,
					BRANCH,
					OUR_COMPANY 
				WHERE 
					DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND 
					OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID  
					<cfif len(attributes.branch_id)>AND BRANCH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.branch_id,',')#"></cfif>
					<cfif len(attributes.department_id) and len(attributes.department_name)>AND DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#"></cfif>
					<cfif not session.ep.ehesap>
						AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
						AND OUR_COMPANY.COMP_ID IN (SELECT DISTINCT BR.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH BR ON BR.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
					</cfif>
				ORDER BY 
					OUR_COMPANY.COMPANY_NAME,
					BRANCH.BRANCH_NAME,
					DEPARTMENT.DEPARTMENT_HEAD
			</cfquery>
			
			<cfquery name="GET_EMPLOYEE" datasource="#DSN#">
				SELECT 
					POSITION_CODE,
					EMPLOYEE_ID, 
					POSITION_ID, 
					EMPLOYEE_NAME, 
					EMPLOYEE_SURNAME, 
					DEPARTMENT_ID 
				FROM 
					EMPLOYEE_POSITIONS 
				WHERE 
					EMPLOYEE_ID IS NOT NULL AND 
					<cfif get_location.recordcount>
						DEPARTMENT_ID IN (#valuelist(get_location.department_id,',')#) AND 
					<cfelse>
						DEPARTMENT_ID = 0 AND
					</cfif>
					IS_MASTER = 1 AND
					EMPLOYEE_ID <> 0 
			</cfquery>
		<cfelseif listfirst(attributes.branch_id) eq 1>
			<cfquery name="GET_EMPLOYEE" datasource="#DSN#">
				SELECT 
					EMPLOYEE_POSITIONS.POSITION_CODE,
					EMPLOYEE_POSITIONS.EMPLOYEE_ID, 
					EMPLOYEE_POSITIONS.POSITION_ID, 
					EMPLOYEE_POSITIONS.EMPLOYEE_NAME, 
					EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME, 
					EMPLOYEE_POSITIONS.DEPARTMENT_ID  
				FROM 
					EMPLOYEE_POSITIONS,
					SALES_ZONES_TEAM_ROLES 
				WHERE 
					EMPLOYEE_POSITIONS.IS_MASTER = 1 AND
					EMPLOYEE_POSITIONS.EMPLOYEE_ID <> 0  AND 
					EMPLOYEE_POSITIONS.POSITION_CODE = SALES_ZONES_TEAM_ROLES.POSITION_CODE AND 
					SALES_ZONES_TEAM_ROLES.TEAM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.branch_id,',')#"> 
				ORDER BY 
					EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
					EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME
			</cfquery>
			<cfquery name="GET_LOCATION" datasource="#DSN#">
				SELECT 
					DEPARTMENT.DEPARTMENT_ID,
					DEPARTMENT.DEPARTMENT_HEAD,

					BRANCH.BRANCH_NAME,
					OUR_COMPANY.COMPANY_NAME 
				FROM 
					DEPARTMENT,
					BRANCH,
					OUR_COMPANY 
				WHERE 
					DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
					OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID
					<cfif Len(get_employee.department_id)>AND DEPARTMENT.DEPARTMENT_ID IN (#valuelist(get_employee.department_id,',')#)</cfif>
					<cfif not session.ep.ehesap>
						AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
						AND OUR_COMPANY.COMP_ID IN (SELECT DISTINCT BR.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH BR ON BR.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
					</cfif>
				ORDER BY
					OUR_COMPANY.COMPANY_NAME,
					BRANCH.BRANCH_NAME,
					DEPARTMENT.DEPARTMENT_HEAD
			</cfquery>
		</cfif>
		<cfif isdefined("attributes.is_company")>
			<cfquery name="GET_MEMBER_RECORD" datasource="#DSN#">
				SELECT 
					RECORD_EMP,
					COUNT(COMPANY_ID) AS TOTAL
				FROM 
					COMPANY  
				WHERE 
					RECORD_EMP IS NOT NULL 
					<cfif len(attributes.start_date)>AND RECORD_DATE >= #attributes.start_date#</cfif>
					<cfif len(attributes.finish_date)>AND RECORD_DATE < #date_add("d",1,attributes.finish_date)#</cfif>
				GROUP BY 
					RECORD_EMP
			</cfquery>
			<cfset record_companyid = valuelist(get_member_record.record_emp,',')>
		</cfif>
		<cfif isdefined("attributes.is_partner")>
			<cfquery name="GET_PARTNER_RECORD" datasource="#DSN#">
				SELECT 
					RECORD_MEMBER,
					COUNT(PARTNER_ID) AS TOTAL
				FROM 
					COMPANY_PARTNER  
				WHERE 
					RECORD_MEMBER IS NOT NULL
					<cfif len(attributes.start_date)>AND RECORD_DATE >= #attributes.start_date#</cfif>
					<cfif len(attributes.finish_date)>AND RECORD_DATE < #date_add("d",1,attributes.finish_date)#</cfif>
				GROUP BY 
					RECORD_MEMBER
			</cfquery>
			<cfset record_partnerid = valuelist(get_partner_record.record_member,',')>
		</cfif>
		<cfif isdefined("attributes.is_consumer")>
			<cfquery name="GET_CONSUMER_RECORD" datasource="#DSN#">
				SELECT 
					RECORD_MEMBER,
					COUNT(CONSUMER_ID) AS TOTAL
				FROM 
					CONSUMER  
				WHERE 
					RECORD_MEMBER IS NOT NULL
					<cfif len(attributes.start_date)>AND RECORD_DATE >= #attributes.start_date#</cfif>
					<cfif len(attributes.finish_date)>AND RECORD_DATE < #date_add("d",1,attributes.finish_date)#</cfif>
				GROUP BY 
					RECORD_MEMBER
			</cfquery>
			<cfset record_consumerid = valuelist(get_consumer_record.record_member,',')>
		</cfif>
		<cfif isdefined("attributes.is_work")>
			<cfquery name="GET_PROJECT_WORK" datasource="#DSN#">
				SELECT 
					PROJECT_EMP_ID,
					COUNT(WORK_ID) AS TOTAL
				FROM 
					PRO_WORKS
				WHERE 
					PROJECT_EMP_ID IS NOT NULL 
					<cfif len(attributes.start_date)>AND RECORD_DATE >= #attributes.start_date#</cfif>
					<cfif len(attributes.finish_date)>AND RECORD_DATE < #date_add("d",1,attributes.finish_date)#</cfif>
				GROUP BY 
					PROJECT_EMP_ID
			</cfquery>
			<cfset record_projectwork = valuelist(get_project_work.project_emp_id,',')>
		</cfif>
		<cfif isdefined("attributes.is_agenda")>
			<cfquery name="GET_EVENT_RECORD" datasource="#DSN#">
				SELECT 
					RECORD_EMP,
					COUNT(EVENT_ID) AS TOTAL
				FROM 
					EVENT
				WHERE 
					RECORD_EMP IS NOT NULL
					<cfif len(attributes.start_date)>AND RECORD_DATE >= #attributes.start_date#</cfif>
					<cfif len(attributes.finish_date)>AND RECORD_DATE < #date_add("d",1,attributes.finish_date)#</cfif>
				GROUP BY 
					RECORD_EMP
			</cfquery>
			<cfset record_eventid = valuelist(get_event_record.record_emp,',')>
		</cfif>
		<cfif isdefined("attributes.is_minutes")>
			<cfquery name="GET_EVENT_RESULT" datasource="#DSN#">
				SELECT 
					RECORD_EMP,
					COUNT(EVENT_RESULT_ID) AS TOTAL
				FROM 
					EVENT_RESULT 
				WHERE 
					RECORD_EMP IS NOT NULL
					<cfif len(attributes.start_date)>AND RECORD_DATE >= #attributes.start_date#</cfif>
					<cfif len(attributes.finish_date)>AND RECORD_DATE < #date_add("d",1,attributes.finish_date)#</cfif>
				GROUP BY 
					RECORD_EMP
			</cfquery>
			<cfset record_resultid = valuelist(get_event_result.record_emp,',')>
		</cfif>
		<cfif isdefined("attributes.is_visit_plan")>
			<cfquery name="GET_EVENT_PLAN" datasource="#DSN#">
				SELECT 
					RECORD_EMP,
					COUNT(EVENT_PLAN_ID) AS TOTAL
				FROM 
					EVENT_PLAN
				WHERE 
					RECORD_EMP IS NOT NULL
					<cfif len(attributes.start_date)>AND RECORD_DATE >= #attributes.start_date#</cfif>
					<cfif len(attributes.finish_date)>AND RECORD_DATE < #date_add("d",1,attributes.finish_date)#</cfif>
				GROUP BY 
					RECORD_EMP
			</cfquery>
			<cfset record_eventplanid = valuelist(get_event_plan.record_emp,',')>
		</cfif>
		<cfif isdefined("attributes.is_visit_part")>
			<cfquery name="GET_EVENT_POS" datasource="#DSN#">
				SELECT 
					EVENT_PLAN_ROW_PARTICIPATION_POS.EVENT_POS_ID,
					COUNT(EVENT_PLAN_ROW_PARTICIPATION_POS.EVENT_ROW_PART_POS_ID) AS TOTAL
				FROM 
					EVENT_PLAN_ROW_PARTICIPATION_POS,
					EVENT_PLAN_ROW,
					EVENT_PLAN
				WHERE 
					EVENT_PLAN_ROW_PARTICIPATION_POS.EVENT_POS_ID IS NOT NULL AND 
					EVENT_PLAN.EVENT_PLAN_ID = 	EVENT_PLAN_ROW.EVENT_PLAN_ID AND 
					EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID = EVENT_PLAN_ROW_PARTICIPATION_POS.EVENT_ROW_ID
					<cfif len(attributes.start_date)>AND EVENT_PLAN_ROW.RECORD_DATE >= #attributes.start_date#</cfif>
					<cfif len(attributes.finish_date)>AND EVENT_PLAN_ROW.RECORD_DATE < #date_add("d",1,attributes.finish_date)#</cfif>
				GROUP BY 
					EVENT_POS_ID
			</cfquery>
			<cfset record_eventpos = valuelist(get_event_pos.event_pos_id,',')>
		</cfif>
		<cfif isdefined("attributes.is_visit_result")>
			<cfquery name="GET_RESULT_ROW" datasource="#DSN#">
				SELECT 
					RESULT_RECORD_EMP,
					COUNT(EVENT_PLAN_ROW_ID) AS TOTAL
				FROM 
					EVENT_PLAN_ROW
				WHERE 
					RESULT_RECORD_EMP IS NOT NULL
					<cfif len(attributes.start_date)>AND RESULT_RECORD_DATE >= #attributes.start_date#</cfif>
					<cfif len(attributes.finish_date)>AND RESULT_RECORD_DATE < #date_add("d",1,attributes.finish_date)#</cfif>
				GROUP BY 
					RESULT_RECORD_EMP
			</cfquery>
			<cfset record_result = valuelist(get_result_row.result_record_emp,',')>
		</cfif>
		<cfif isdefined("attributes.is_opportunity")>
			<cfquery name="GET_OPPORTUNITIES_RECORD" datasource="#DSN3#">
				SELECT 
					SALES_EMP_ID,
					COUNT(OPP_ID) AS TOTAL
				FROM 
					OPPORTUNITIES
				WHERE 
					SALES_EMP_ID IS NOT NULL
					<cfif len(attributes.start_date)>AND RECORD_DATE >= #attributes.start_date#</cfif>
					<cfif len(attributes.finish_date)>AND RECORD_DATE < #date_add("d",1,attributes.finish_date)#</cfif>
				GROUP BY 
					SALES_EMP_ID
			</cfquery>
			<cfset record_offerid = valuelist(get_opportunities_record.sales_emp_id,',')>
		</cfif>
		<cfif isdefined("attributes.is_opportunity_plus")>
			<cfquery name="GET_OPPORTUNITIES_PLUS" datasource="#DSN3#">
				SELECT 
					RECORD_EMP,
					COUNT(OPP_ID) AS TOTAL
				FROM 
					OPPORTUNITIES_PLUS
				WHERE 
					RECORD_EMP IS NOT NULL
					<cfif len(attributes.start_date)>AND RECORD_DATE >= #attributes.start_date#</cfif>
					<cfif len(attributes.finish_date)>AND RECORD_DATE < #date_add("d",1,attributes.finish_date)#</cfif>
				GROUP BY 
					RECORD_EMP
			</cfquery>
			<cfset record_oppplusid = valuelist(get_opportunities_plus.record_emp,',')>
		</cfif>
		<cfif isdefined("attributes.is_offer")>
			<cfquery name="GET_OFFER_RECORD" datasource="#DSN3#">
				SELECT 
					SALES_EMP_ID,
					COUNT(OFFER_ID) AS TOTAL,
					SUM(PRICE) AS TOPLAM_PRICE
				FROM 
					OFFER
				WHERE 
					SALES_EMP_ID IS NOT NULL
					<cfif len(attributes.start_date)>AND RECORD_DATE >= #attributes.start_date#</cfif>
					<cfif len(attributes.finish_date)>AND RECORD_DATE < #date_add("d",1,attributes.finish_date)#</cfif>
					<cfif len(attributes.start_date2)>AND OFFER_DATE >= #attributes.start_date2#</cfif>
					<cfif len(attributes.finish_date2)>AND OFFER_DATE < #date_add("d",1,attributes.finish_date2)#</cfif>
				GROUP BY 
					SALES_EMP_ID
			</cfquery>
			<cfset record_offerid = valuelist(get_offer_record.sales_emp_id,',')>
		</cfif>
		<cfif isdefined("attributes.is_offer_plus")>
			<cfquery name="GET_OFFER_PLUS" datasource="#DSN3#">
				SELECT 
					RECORD_EMP,
					COUNT(OFFER_PLUS_ID) AS TOTAL
				FROM 
					OFFER_PLUS
				WHERE 
					RECORD_EMP IS NOT NULL
					<cfif len(attributes.start_date)>AND RECORD_DATE >= #attributes.start_date#</cfif>
					<cfif len(attributes.finish_date)>AND RECORD_DATE < #date_add("d",1,attributes.finish_date)#</cfif>
				GROUP BY 
					RECORD_EMP
			</cfquery>
			<cfset record_offerplusid = valuelist(get_offer_plus.record_emp,',')>
		</cfif>
		<cfif isdefined("attributes.is_order")>
			<cfquery name="GET_ORDERS" datasource="#DSN3#">
				SELECT 
					RECORD_EMP,
					COUNT(ORDER_ID) AS TOTAL,
					SUM(GROSSTOTAL) AS TOPLAM_PRICE
				FROM 
					ORDERS
				WHERE 
                	((PURCHASE_SALES = 1 AND ORDER_ZONE = 0) OR (PURCHASE_SALES = 0 AND ORDER_ZONE = 1) ) AND
					RECORD_EMP IS NOT NULL
					<cfif len(attributes.start_date)>AND RECORD_DATE >= #attributes.start_date#</cfif>
					<cfif len(attributes.finish_date)>AND RECORD_DATE < #date_add("d",1,attributes.finish_date)#</cfif>
					<cfif len(attributes.start_date2)>AND ORDER_DATE >= #attributes.start_date2#</cfif>
					<cfif len(attributes.finish_date2)>AND ORDER_DATE <= #attributes.finish_date2#</cfif>
				GROUP BY 
					RECORD_EMP
			</cfquery>
			<cfset record_orders = valuelist(get_orders.record_emp,',')>
		</cfif>
		<cfif isdefined("attributes.is_purchase")>
			<cfquery name="GET_INVOICE_PURCHASE" datasource="#DSN2#">
				SELECT 
					<!---RECORD_EMP,--->
					SALE_EMP,
					COUNT(INVOICE_ID) AS TOTAL,
					SUM(GROSSTOTAL) AS TOPLAM_PRICE
				FROM 
					INVOICE
				WHERE 
					<!---RECORD_EMP IS NOT NULL AND --->
					SALE_EMP IS NOT NULL AND 
					PURCHASE_SALES = 0
					<cfif len(attributes.start_date)>AND RECORD_DATE >= #attributes.start_date#</cfif>
					<cfif len(attributes.finish_date)>AND RECORD_DATE < #date_add("d",1,attributes.finish_date)#</cfif>
				GROUP BY 
					<!---RECORD_EMP--->
					SALE_EMP
			</cfquery>
			<!---<cfset record_invoice = valuelist(get_invoice_purchase.record_emp,',')>--->
			<cfset record_invoice = valuelist(get_invoice_purchase.sale_emp,',')>
		</cfif>
		<cfif isdefined("attributes.is_sales")>
			<cfquery name="GET_INVOICE_SALES" datasource="#DSN2#">
				SELECT 
					<!---RECORD_EMP,--->
					SALE_EMP,
					COUNT(INVOICE_ID) AS TOTAL,
					SUM(GROSSTOTAL) AS TOPLAM_PRICE
				FROM 
					INVOICE
				WHERE 
					<!---RECORD_EMP IS NOT NULL AND --->
					SALE_EMP IS NOT NULL AND
					PURCHASE_SALES = 1
					<cfif len(attributes.start_date2)>AND INVOICE_DATE >= #attributes.start_date2#</cfif>
					<cfif len(attributes.finish_date2)>AND INVOICE_DATE < #date_add("d",1,attributes.finish_date2)#</cfif>
				GROUP BY 
					<!---RECORD_EMP--->
					SALE_EMP
			</cfquery>
			<!---<cfset record_invoice_sales = valuelist(get_invoice_sales.record_emp,',')>--->
			<cfset record_invoice_sales = valuelist(get_invoice_sales.sale_emp,',')>
		</cfif>
		<cfif isdefined("attributes.is_system")>
			<cfquery name="GET_SYSTEM" datasource="#DSN3#">
				SELECT 
					SALES_EMP_ID,
					COUNT(SUBSCRIPTION_ID) AS TOTAL,
					SUM(NETTOTAL) AS TOPLAM_PRICE
				FROM 
					SUBSCRIPTION_CONTRACT
				WHERE 
					SALES_EMP_ID IS NOT NULL
					<cfif len(attributes.start_date)>AND RECORD_DATE >= #attributes.start_date#</cfif>
					<cfif len(attributes.finish_date)>AND RECORD_DATE < #date_add("d",1,attributes.finish_date)#</cfif>
				GROUP BY 
					SALES_EMP_ID
			</cfquery>
			<cfset record_systemid = valuelist(get_system.sales_emp_id,',')>
		</cfif>
		<cfif isdefined("attributes.is_agenda_participation")>
			<cfquery name="GET_PARTICIPATION_AGENDA" datasource="#DSN#">
				SELECT 	
					COUNT(EVENT_ID) AS TOTAL,
					EVENT_TO_POS 
				FROM 
					EVENT 
				WHERE 
					EVENT_TO_POS IS NOT NULL
					<cfif len(attributes.start_date)>AND RECORD_DATE >= #attributes.start_date#</cfif>
					<cfif len(attributes.finish_date)>AND RECORD_DATE < #date_add("d",1,attributes.finish_date)#</cfif> 
				GROUP BY 
					EVENT_TO_POS
			</cfquery>
		</cfif>
		<cfif isdefined("attributes.is_interaction")>
			<cfquery name="GET_INTERACTION" datasource="#DSN#">
				SELECT 
					RECORD_EMP,
					COUNT(CUS_HELP_ID) AS TOTAL 
				FROM
					CUSTOMER_HELP 
				WHERE
					RECORD_EMP IS NOT NULL
					<cfif len(attributes.start_date)>AND RECORD_DATE >= #attributes.start_date#</cfif>
					<cfif len(attributes.finish_date)>AND RECORD_DATE < #date_add("d",1,attributes.finish_date)#</cfif> 
				GROUP BY 
					RECORD_EMP
			</cfquery>
			<cfset record_interactionid = valuelist(get_interaction.record_emp,',')>
		</cfif>
		<cfif isdefined("attributes.is_campaing_email")>
			<cfquery name="GET_SEND_CONTENT" datasource="#DSN#">
				SELECT 
					SENDER_EMP,
					SEND_PAR,
					SEND_EMP,
					SEND_CON
				FROM
					SEND_CONTENTS 
				WHERE
					SENDER_EMP IS NOT NULL
					<cfif len(attributes.start_date)>AND SEND_DATE >= #attributes.start_date#</cfif>
					<cfif len(attributes.finish_date)>AND SEND_DATE < #date_add("d",1,attributes.finish_date)#</cfif> 
			</cfquery>
			<cfset record_sendcontent = valuelist(get_send_content.sender_emp,',')>
		</cfif>
		<cfif listfirst(attributes.branch_id) eq 0>
		
			<cfoutput query="get_location">
                <cfquery name="GET_INFO" dbtype="query">
                    SELECT * FROM GET_EMPLOYEE WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#department_id#">
                </cfquery>
				
                    <thead> 
						<tr height="25">
							<th colspan="22">#company_name#/#branch_name#/#department_head#</th>
						</tr>
						<tr height="25">
							<th ><cf_get_lang dictionary_id ='58577.Sıra'></th>
							<th ><cf_get_lang dictionary_id ='57576.Çalışan'></th>
							<cfif isdefined("attributes.is_company")>
								<th style="text-align:right;"><cf_get_lang dictionary_id ='57585.Kurumsal Üye'></th>
							</cfif>
							<cfif isdefined("attributes.is_partner")>
								<th style="text-align:right;"><cf_get_lang dictionary_id ='29828.Kurumsal Üye Çalışanı'></th>
							</cfif>
							<cfif isdefined("attributes.is_consumer")>
								<th style="text-align:right;"><cf_get_lang dictionary_id ='57586.Bireysel Üye'></th>
							</cfif>
							<cfif isdefined("attributes.is_work")>
								<th style="text-align:right;"><cf_get_lang dictionary_id ='39931.Görev'></th>
							</cfif>
							<cfif isdefined("attributes.is_agenda")>
								<th style="text-align:right;"><cf_get_lang dictionary_id ='57415.Ajanda'></th>
							</cfif>
							<cfif isdefined("attributes.is_agenda_participation")>
								<th style="text-align:right;"><cf_get_lang dictionary_id ='57415.Ajanda'><cf_get_lang dictionary_id ='29780.Katılımcı'></th>
							</cfif>
							<cfif isdefined("attributes.is_minutes")>
								<th style="text-align:right;"><cf_get_lang dictionary_id ='39486.Tutanak'></th>
							</cfif>
							<cfif isdefined("attributes.is_visit_plan")>
								<th style="text-align:right;"><cf_get_lang dictionary_id ='58422.Ziyaret Planı'></th>
							</cfif>
							<cfif isdefined("attributes.is_visit_part")>
								<th style="text-align:right;"><cf_get_lang dictionary_id ='29780.Katılımcı'></th>
							</cfif>
							<cfif isdefined("attributes.is_visit_result")>
								<th style="text-align:right;"><cf_get_lang dictionary_id ='58437.Ziyaret Sonucu'></th>
							</cfif>
							<cfif isdefined("attributes.is_interaction")>
								<th style="text-align:right;"><cf_get_lang dictionary_id='58729.Etkileşim'></th>
							</cfif>
							<cfif isdefined("attributes.is_campaing_email")>
								<th style="text-align:right;"><cf_get_lang dictionary_id ='57446.Kampanya'><cf_get_lang dictionary_id ='40572.Emailleşme'></th>
							</cfif>
							<cfif isdefined("attributes.is_opportunity")>
								<th style="text-align:right;"><cf_get_lang dictionary_id ='57612.Fırsat'></th>
							</cfif>
							<cfif isdefined("attributes.is_opportunity_plus")>
								<th style="text-align:right;"><cf_get_lang dictionary_id ='39935.Fırsat Takibi'></th>
							</cfif>
							<cfif isdefined("attributes.is_offer")>
								<th style="text-align:right;"><cf_get_lang dictionary_id ='57545.Teklif'></th>
							</cfif>
							<cfif isdefined("attributes.is_offer_plus")>
								<th style="text-align:right;"><cf_get_lang dictionary_id ='39933.Teklif Takibi'></th>
							</cfif>
							<cfif isdefined("attributes.is_order")>
								<th style="text-align:right;"><cf_get_lang dictionary_id ='57611.Sipariş'></th>
							</cfif>
							<cfif isdefined("attributes.is_purchase")>
								<th style="text-align:right;"><cf_get_lang dictionary_id ='57107.Alış Fatura'></th>
							</cfif>
							<cfif isdefined("attributes.is_sales")>
								<th style="text-align:right;"><cf_get_lang dictionary_id ='57118.Satış Fatura'></th>
							</cfif>
							<cfif isdefined("attributes.is_system")>
								<th style="text-align:right;"><cf_get_lang dictionary_id='58832.Abone'></th>
							</cfif>
						</tr>
                	</thead>
                <cfif get_info.recordcount>
					<tbody>
							<cfloop query="get_info">
							<tr>
								<td>#currentrow#</td>
								<td>#employee_name# #employee_surname#</td>
								<cfif isdefined("attributes.is_company")>
									<td style="text-align:right;">#get_member_record.total[listfind(record_companyid,employee_id,',')]#</td>
								</cfif>
								<cfif isdefined("attributes.is_partner")>
									<td style="text-align:right;">#get_partner_record.total[listfind(record_partnerid,employee_id,',')]#</td>
								</cfif>
								<cfif isdefined("attributes.is_consumer")>
									<td style="text-align:right;">#get_consumer_record.total[listfind(record_consumerid,employee_id,',')]#</td>
								</cfif>
								<cfif isdefined("attributes.is_work")>
									<td style="text-align:right;">#get_project_work.total[listfind(record_projectwork,employee_id,',')]#</td>
								</cfif>
								<cfif isdefined("attributes.is_agenda")>
									<td style="text-align:right;">#get_event_record.total[listfind(record_eventid,employee_id,',')]#</td>
								</cfif>
								<cfif isdefined("attributes.is_agenda_participation")>
									<cfquery name="GET_PAR_" dbtype="query">
										SELECT TOTAL FROM GET_PARTICIPATION_AGENDA WHERE EVENT_TO_POS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#employee_id#,%">
									</cfquery>
									<cfset total_11 = 0>
									<cfloop query="GET_PAR_">
										<cfset total_11 = total_11 + GET_PAR_.total>
									</cfloop>
									<td style="text-align:right;">#total_11#</td>
								</cfif>
								<cfif isdefined("attributes.is_minutes")>
									<td style="text-align:right;">#get_event_result.total[listfind(record_resultid,employee_id,',')]#</td>
								</cfif>
								<cfif isdefined("attributes.is_visit_plan")>
									<td style="text-align:right;">#get_event_plan.total[listfind(record_eventplanid,employee_id,',')]#</td>
								</cfif>
								<cfif isdefined("attributes.is_visit_part")>
									<td style="text-align:right;">#get_event_pos.total[listfind(record_eventpos,position_code,',')]#</td>
								</cfif>
								<cfif isdefined("attributes.is_visit_result")>
									<td style="text-align:right;">#get_result_row.total[listfind(record_result,employee_id,',')]#</td>
								</cfif>
								<cfif isdefined("attributes.is_interaction")>
									<td style="text-align:right;">#get_interaction.total[listfind(record_interactionid,employee_id,',')]#</td>
								</cfif>
								<cfif isdefined("attributes.is_campaing_email")>
									<td style="text-align:right;">
									<cfset total_send = 0>
									<cfquery name="GET_CONT_" dbtype="query">
										SELECT * FROM GET_SEND_CONTENT WHERE SENDER_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#employee_id#">
									</cfquery>
									<cfloop query="GET_CONT_">
										<cfloop from="1" to="#listlen(get_cont_.send_par,',')#" index="i">
											<cfif len(listgetat(get_cont_.send_par,i,','))>
												<cfset total_send = total_send + 1>
											</cfif>
										</cfloop>
										<cfloop from="1" to="#listlen(get_cont_.send_emp,',')#" index="i">
											<cfif len(listgetat(get_cont_.send_emp,i,','))>
												<cfset total_send = total_send + 1>
											</cfif>
										</cfloop>
										<cfloop from="1" to="#listlen(get_cont_.send_con,',')#" index="i">
											<cfif len(listgetat(get_cont_.send_con,i,','))>
												<cfset total_send = total_send + 1>
											</cfif>
										</cfloop>
									</cfloop>
									#get_cont_.recordcount# Gönderi - #total_send# Kişi
									</td>
								</cfif>
								<cfif isdefined("attributes.is_opportunity")>
									<td style="text-align:right;">#get_opportunities_record.total[listfind(record_offerid,employee_id,',')]#</td>
								</cfif>
								<cfif isdefined("attributes.is_opportunity_plus")>
									<td style="text-align:right;">#get_opportunities_plus.total[listfind(record_oppplusid,employee_id,',')]#</td>
								</cfif>
								<cfif isdefined("attributes.is_offer")>
									<td  style="text-align:right;">#get_offer_record.total[listfind(record_offerid,employee_id,',')]# - <cfif len(get_offer_record.toplam_price[listfind(record_offerid,employee_id,',')])>#tlformat(get_offer_record.toplam_price[listfind(record_offerid,employee_id,',')])# #session.ep.money#</cfif></td>
								</cfif>
								<cfif isdefined("attributes.is_offer_plus")>
									<td style="text-align:right;">#get_offer_plus.total[listfind(record_offerplusid,employee_id,',')]#</td>
								</cfif>
								<cfif isdefined("attributes.is_order")>
									<td  style="text-align:right;">#get_orders.total[listfind(record_orders,employee_id,',')]# - <cfif len(get_orders.toplam_price[listfind(record_orders,employee_id,',')])>#tlformat(get_orders.toplam_price[listfind(record_orders,employee_id,',')])# #session.ep.money#</cfif></td>
								</cfif>
								<cfif isdefined("attributes.is_purchase")>
									<td  style="text-align:right;">#get_invoice_purchase.total[listfind(record_invoice,employee_id,',')]# - <cfif len(get_invoice_purchase.toplam_price[listfind(record_invoice,employee_id,',')])>#tlformat(get_invoice_purchase.toplam_price[listfind(record_invoice,employee_id,',')])# #session.ep.money#</cfif></td>
								</cfif>
								<cfif isdefined("attributes.is_sales")>
									<td  style="text-align:right;">#get_invoice_sales.total[listfind(record_invoice_sales,employee_id,',')]# - <cfif len(get_invoice_sales.toplam_price[listfind(record_invoice_sales,employee_id,',')])>#tlformat(get_invoice_sales.toplam_price[listfind(record_invoice_sales,employee_id,',')])# #session.ep.money#</cfif></td>
								</cfif>
								<cfif isdefined("attributes.is_system")>
									<td  style="text-align:right;">#get_system.total[listfind(record_systemid,employee_id,',')]# - <cfif len(get_system.toplam_price[listfind(record_systemid,employee_id,',')])>#tlformat(get_system.toplam_price[listfind(record_systemid,employee_id,',')])# #session.ep.money#</cfif></td>
								</cfif>
							</tr>
						</cfloop>
            		</tbody>
					<cfelse>
					<tbody>
						<tr class="color-row">
							<td colspan="21"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
						</tr>
					</tbody>
			
                </cfif>
            </cfoutput>
			
        <cfelseif listfirst(attributes.branch_id) eq 1 >
			<cfoutput query="get_location" maxrows=#attributes.maxrows# startrow=#attributes.startrow#>
				<cfquery name="GET_INFO" dbtype="query">
                    SELECT * FROM GET_EMPLOYEE WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#department_id#">
                </cfquery>          
					<thead>
						<tr height="25">
							<th colspan="22">#company_name#/#branch_name#/#department_head#</th>
						</tr>
						<tr height="25">
							<th ><cf_get_lang dictionary_id ='58577.Sıra'></th>
							<th ><cf_get_lang dictionary_id ='57576.Çalışan'></th>
							<cfif isdefined("attributes.is_company")>
								<th style="text-align:right;"><cf_get_lang dictionary_id ='57585.Kurumsal Üye'></th>
							</cfif>
							<cfif isdefined("attributes.is_partner")>
								<th style="text-align:right;"><cf_get_lang dictionary_id ='29828.Kurumsal Üye Çalışanı'></th>
							</cfif>
							<cfif isdefined("attributes.is_consumer")>
								<th style="text-align:right;"><cf_get_lang dictionary_id ='57586.Bireysel Üye'></th>
							</cfif>
							<cfif isdefined("attributes.is_work")>
								<th style="text-align:right;"><cf_get_lang dictionary_id ='39931.Görev'></th>
							</cfif>
							<cfif isdefined("attributes.is_agenda")>
								<th style="text-align:right;"><cf_get_lang dictionary_id ='57415.Ajanda'></th>
							</cfif>
							<cfif isdefined("attributes.is_agenda_participation")>
								<th style="text-align:right;"><cf_get_lang dictionary_id ='57415.Ajanda'><cf_get_lang dictionary_id ='29780.Katılımcı'></th>
							</cfif>
							<cfif isdefined("attributes.is_minutes")>
								<th style="text-align:right;"><cf_get_lang dictionary_id ='39486.Tutanak'></th>
							</cfif>
							<cfif isdefined("attributes.is_visit_plan")>
								<th style="text-align:right;"><cf_get_lang dictionary_id ='58422.Ziyaret Planı'></th>
							</cfif>
							<cfif isdefined("attributes.is_visit_part")>
								<th style="text-align:right;"><cf_get_lang dictionary_id ='29780.Katılımcı'></th>
							</cfif>
							<cfif isdefined("attributes.is_visit_result")>
								<th style="text-align:right;"><cf_get_lang dictionary_id ='58437.Ziyaret Sonucu'></th>
							</cfif>
							<cfif isdefined("attributes.is_interaction")>
								<th style="text-align:right;"><cf_get_lang dictionary_id='58729.Etkileşim'></th>
							</cfif>
							<cfif isdefined("attributes.is_campaing_email")>
								<th style="text-align:right;"><cf_get_lang dictionary_id ='57446.Kampanya'><cf_get_lang dictionary_id ='40572.Emailleşme'></th>
							</cfif>
							<cfif isdefined("attributes.is_opportunity")>
								<th style="text-align:right;"><cf_get_lang dictionary_id ='57612.Fırsat'></th>
							</cfif>
							<cfif isdefined("attributes.is_opportunity_plus")>
								<th style="text-align:right;"><cf_get_lang dictionary_id ='39935.Fırsat Takibi'></th>
							</cfif>
							<cfif isdefined("attributes.is_offer")>
								<th style="text-align:right;"><cf_get_lang dictionary_id ='57545.Teklif'></th>
							</cfif>
							<cfif isdefined("attributes.is_offer_plus")>
								<th style="text-align:right;"><cf_get_lang dictionary_id ='39933.Teklif Takibi'></th>
							</cfif>
							<cfif isdefined("attributes.is_order")>
								<th style="text-align:right;"><cf_get_lang dictionary_id ='57611.Sipariş'></th>
							</cfif>
							<cfif isdefined("attributes.is_purchase")>
								<th style="text-align:right;"><cf_get_lang dictionary_id ='57107.Alış Fatura'></th>
							</cfif>
							<cfif isdefined("attributes.is_sales")>
								<th style="text-align:right;"><cf_get_lang dictionary_id ='57118.Satış Fatura'></th>
							</cfif>
							<cfif isdefined("attributes.is_system")>
								<th style="text-align:right;"><cf_get_lang dictionary_id='58832.Abone'></th>
							</cfif>
						</tr>
					</thead>
				<cfif get_info.recordcount>
					<tbody>
						<cfloop query="get_info" >
							<tr>
								<td>#currentrow#</td>
								<td>#employee_name# #employee_surname#</td>
								<cfif isdefined("attributes.is_company")>
									<td style="text-align:right;">#get_member_record.total[listfind(record_companyid,employee_id,',')]#</td>
								</cfif>
								<cfif isdefined("attributes.is_partner")>
									<td style="text-align:right;">#get_partner_record.total[listfind(record_partnerid,employee_id,',')]#</td>
								</cfif>
								<cfif isdefined("attributes.is_consumer")>
									<td style="text-align:right;">#get_consumer_record.total[listfind(record_consumerid,employee_id,',')]#</td>
								</cfif>
								<cfif isdefined("attributes.is_work")>
									<td style="text-align:right;">#get_project_work.total[listfind(record_projectwork,employee_id,',')]#</td>
								</cfif>
								<cfif isdefined("attributes.is_agenda")>
									<td style="text-align:right;">#get_event_record.total[listfind(record_eventid,employee_id,',')]#</td>
								</cfif>
								<cfif isdefined("attributes.is_agenda_participation")>
									<cfquery name="GET_PAR_" dbtype="query">
										SELECT TOTAL FROM GET_PARTICIPATION_AGENDA WHERE EVENT_TO_POS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#employee_id#,%">
									</cfquery>
									<cfset total_11 = 0>
									<cfloop query="GET_PAR_">
										<cfset total_11 = total_11 + GET_PAR_.total>
									</cfloop>
									<td style="text-align:right;">#total_11#</td>
								</cfif>
								<cfif isdefined("attributes.is_minutes")>
									<td style="text-align:right;">#get_event_result.total[listfind(record_resultid,employee_id,',')]#</td>
								</cfif>
								<cfif isdefined("attributes.is_visit_plan")>
									<td style="text-align:right;">#get_event_plan.total[listfind(record_eventplanid,employee_id,',')]#</td>
								</cfif>
								<cfif isdefined("attributes.is_visit_part")>
									<td style="text-align:right;">#get_event_pos.total[listfind(record_eventpos,position_code,',')]#</td>
								</cfif>
								<cfif isdefined("attributes.is_visit_result")>
									<td style="text-align:right;">#get_result_row.total[listfind(record_result,employee_id,',')]#</td>
								</cfif>
								<cfif isdefined("attributes.is_interaction")>
									<td style="text-align:right;">#get_interaction.total[listfind(record_interactionid,employee_id,',')]#</td>
								</cfif>
								<cfif isdefined("attributes.is_campaing_email")>
									<td style="text-align:right;">
									<cfset total_send = 0>
									<cfquery name="GET_CONT_" dbtype="query">
										SELECT * FROM GET_SEND_CONTENT WHERE SENDER_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#employee_id#">
									</cfquery>
									<cfloop query="GET_CONT_">
										<cfloop from="1" to="#listlen(get_cont_.send_par,',')#" index="i">
											<cfif len(listgetat(get_cont_.send_par,i,','))>
												<cfset total_send = total_send + 1>
											</cfif>
										</cfloop>
										<cfloop from="1" to="#listlen(get_cont_.send_emp,',')#" index="i">
											<cfif len(listgetat(get_cont_.send_emp,i,','))>
												<cfset total_send = total_send + 1>
											</cfif>
										</cfloop>
										<cfloop from="1" to="#listlen(get_cont_.send_con,',')#" index="i">
											<cfif len(listgetat(get_cont_.send_con,i,','))>
												<cfset total_send = total_send + 1>
											</cfif>
										</cfloop>
									</cfloop>
									#get_cont_.recordcount# Gönderi - #total_send# Kişi
									</td>
								</cfif>
								<cfif isdefined("attributes.is_opportunity")>
									<td style="text-align:right;">#get_opportunities_record.total[listfind(record_offerid,employee_id,',')]#</td>
								</cfif>
								<cfif isdefined("attributes.is_opportunity_plus")>
									<td style="text-align:right;">#get_opportunities_plus.total[listfind(record_oppplusid,employee_id,',')]#</td>
								</cfif>
								<cfif isdefined("attributes.is_offer")>
									<td  style="text-align:right;">#get_offer_record.total[listfind(record_offerid,employee_id,',')]# - <cfif len(get_offer_record.toplam_price[listfind(record_offerid,employee_id,',')])>#tlformat(get_offer_record.toplam_price[listfind(record_offerid,employee_id,',')])# #session.ep.money#</cfif></td>
								</cfif>
								<cfif isdefined("attributes.is_offer_plus")>
									<td style="text-align:right;">#get_offer_plus.total[listfind(record_offerplusid,employee_id,',')]#</td>
								</cfif>
								<cfif isdefined("attributes.is_order")>
									<td  style="text-align:right;">#get_orders.total[listfind(record_orders,employee_id,',')]# - <cfif len(get_orders.toplam_price[listfind(record_orders,employee_id,',')])>#tlformat(get_orders.toplam_price[listfind(record_orders,employee_id,',')])# #session.ep.money#</cfif></td>
								</cfif>
								<cfif isdefined("attributes.is_purchase")>
									<td  style="text-align:right;">#get_invoice_purchase.total[listfind(record_invoice,employee_id,',')]# - <cfif len(get_invoice_purchase.toplam_price[listfind(record_invoice,employee_id,',')])>#tlformat(get_invoice_purchase.toplam_price[listfind(record_invoice,employee_id,',')])# #session.ep.money#</cfif></td>
								</cfif>
								<cfif isdefined("attributes.is_sales")>
									<td  style="text-align:right;">#get_invoice_sales.total[listfind(record_invoice_sales,employee_id,',')]# - <cfif len(get_invoice_sales.toplam_price[listfind(record_invoice_sales,employee_id,',')])>#tlformat(get_invoice_sales.toplam_price[listfind(record_invoice_sales,employee_id,',')])# #session.ep.money#</cfif></td>
								</cfif>
								<cfif isdefined("attributes.is_system")>
									<td  style="text-align:right;">#get_system.total[listfind(record_systemid,employee_id,',')]# - <cfif len(get_system.toplam_price[listfind(record_systemid,employee_id,',')])>#tlformat(get_system.toplam_price[listfind(record_systemid,employee_id,',')])# #session.ep.money#</cfif></td>
								</cfif>
							</tr>
						</cfloop>
					</tbody>
					<cfelse>
					<tbody>
						<tr class="color-row">
							<td colspan="21"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
						</tr>
					</tbody>	
            	</cfif>	
            </cfoutput>	
        </cfif>	
</cf_report_list>
</cfif>
	


<script type="text/javascript">
	function searchcontrol()
	{
		if(!date_check(searchreport.start_date,searchreport.finish_date,"<cf_get_lang dictionary_id ='40310.Başlama Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!")){
			return false;
		}
		if(!date_check(searchreport.start_date2,searchreport.finish_date2,"<cf_get_lang dictionary_id ='40310.Başlama Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!")){
			return false;
		}
		if(document.searchreport.branch_id.value == '')
		{
			alert("<cf_get_lang dictionary_id='57453.Şube'><cf_get_lang dictionary_id='57734.Seçiniz'>");
			return false;
		}
		if(document.searchreport.is_excel.checked==false)
            {
                document.searchreport.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
                return true;
            }
            else
                document.searchreport.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_employee_activity_report</cfoutput>"		
	}
	function gonderdeger()
	{
		if(document.getElementById('branch_id').value == "")
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id ='57453.Şube'>");
		}
		else
		{
			deger1 = searchreport.branch_id.value.split(',');
			deger11 = deger1[0];
			deger12 = deger1[1]; 
			if(deger11 == 0)
			{
				windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_departments&field_id=searchreport.department_id&field_name=searchreport.department_name&search_branch_id=</cfoutput>' + deger12,'list');
			}
			else
			{
				alert("<cf_get_lang dictionary_id ='39941.Seçiminiz Bir Satış Takımı Değil'>!")
			}
		}
	}
	function hesaplawindow()
	{
		document.getElementById('department_id').value = "";
		document.getElementById('department_name').value 	= "";
	}
</script>
