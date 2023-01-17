<cfparam name="attributes.module_id_control" default="6">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.eventcat_id" default="">
<cfparam name="attributes.event_stage" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.is_excel" default="">
<cfif isdefined("attributes.form_varmi")>
	<cfif isdefined("attributes.dept_id") and len(attributes.dept_id)>
        <cfquery name="get_pos_codes" datasource="#dsn#">
            SELECT POSITION_CODE,EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE DEPARTMENT_ID = #attributes.dept_id# AND EMPLOYEE_ID<>0
        </cfquery>
        <cfif get_pos_codes.recordcount>
            <cfset empid_list = valuelist(get_pos_codes.EMPLOYEE_ID)>
        </cfif>
    </cfif>
	<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
    	<cf_date tarih="attributes.startdate">
    </cfif>
	<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
		<cf_date tarih="attributes.finishdate">
	</cfif>
	<cfquery name="GET_EVENT_SEARCH" datasource="#dsn#">
		SELECT 
			EVENT.EVENT_ID,
			EVENT.STARTDATE,
			EVENT.FINISHDATE,
			EVENT_CAT.EVENTCAT,
			EVENT.EVENT_HEAD,
			EVENT.RECORD_DATE,
			EVENT.RECORD_EMP,
			EVENT.RECORD_PAR,
			EVENT.PROJECT_ID,
            PROCESS_TYPE_ROWS.STAGE,
			EVENT_TO_BRANCH
		FROM 
			EVENT,
			EVENT_CAT,
            PROCESS_TYPE_ROWS
		WHERE
		    EVENT.EVENTCAT_ID = EVENT_CAT.EVENTCAT_ID AND
            PROCESS_TYPE_ROWS.PROCESS_ROW_ID = EVENT.EVENT_STAGE
			<cfif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>
				AND EVENT.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
			</cfif>
			<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
				AND EVENT.EVENT_HEAD LIKE '%#attributes.keyword#%'
			</cfif>
			<!---KATILIMCI--->
			<cfif isdefined("attributes.member_name") and len(attributes.member_name)>
				<cfif isdefined('attributes.emp_id') and len(attributes.emp_id) and attributes.member_type eq 'employee'>
					<cfif database_type is "MSSQL">
						AND ','+EVENT.EVENT_TO_POS+',' LIKE '%,#attributes.emp_id#,%'
					<cfelseif database_type is "DB2">
						AND ',' || EVENT.EVENT_TO_POS || ',' LIKE '%,#attributes.emp_id#,%'
					</cfif>	
				</cfif>
				<cfif isdefined('attributes.par_id') and len(attributes.par_id) and attributes.member_type eq 'partner'>
					AND EVENT.EVENT_TO_PAR LIKE '%,#attributes.par_id#,%'
				</cfif>
				<cfif isdefined('attributes.cons_id') and len(attributes.cons_id) and attributes.member_type eq 'consumer'>
					AND EVENT.EVENT_TO_CON LIKE '%,#attributes.cons_id#,%'
				</cfif>
			</cfif>
			<cfif len(attributes.eventcat_id)>
				AND EVENT.EVENTCAT_ID IN (#ListSort(ListDeleteDuplicates(attributes.eventcat_id),"numeric","asc",",")#)
			</cfif> 
			<cfif Len(attributes.event_stage)>
				AND EVENT.EVENT_STAGE IN (#ListSort(ListDeleteDuplicates(attributes.event_stage),"numeric","asc",",")#)
			</cfif>
			<cfif isdefined('attributes.startdate') and len(attributes.startdate) and isdefined ('attributes.finishdate') and len(attributes.finishdate)>
				AND EVENT.STARTDATE <= #attributes.finishdate# AND EVENT.FINISHDATE >= #attributes.startdate#
			<cfelseif isdefined ('attributes.finishdate') and len(attributes.finishdate)>
				AND EVENT.STARTDATE <= #attributes.finishdate#
			<cfelseif isdefined('attributes.startdate') and len(attributes.startdate)>
				AND EVENT.FINISHDATE >= #attributes.startdate#
			</cfif>
			<!---KAYDEDEN--->
			<cfif isdefined("attributes.record_member_name") and len(attributes.record_member_name)>
				<cfif isdefined('attributes.record_emp_id') and len(attributes.record_emp_id) and attributes.record_member_type eq 'employee'>
					AND EVENT.RECORD_EMP = #attributes.record_emp_id#
				<cfelseif isdefined('attributes.record_par_id') and len(attributes.record_par_id) and attributes.record_member_type eq 'partner'>
					AND EVENT.RECORD_PAR = #attributes.record_par_id#
				</cfif>
			</cfif>
			<!---ŞUBEDEKİ ÇALIŞALARA GÖRE--->
			<cfif isdefined("empid_list") and len(empid_list)>
				AND (
					<cfif database_type is "MSSQL">
						<cfloop from="1" to="#listlen(empid_list,',')#" index="i">
							<cfif i neq 1>OR</cfif> ',#listgetat(empid_list,i)#,' IN  (EVENT.EVENT_TO_POS)
							OR EVENT.EVENT_CC_POS LIKE '%,#listgetat(empid_list,i)#,%'
						</cfloop>
					<cfelseif database_type is "DB2">
						<cfloop from="1" to="#listlen(empid_list,',')#" index="i">
							<cfif i neq 1>OR</cfif> ',' || EVENT.EVENT_TO_POS || ',' LIKE '%,#listgetat(empid_list,i)#,%'
							OR EVENT.EVENT_CC_POS LIKE '%,#listgetat(empid_list,i)#,%'
						</cfloop>
					</cfif>
					)
			<cfelseif isdefined("attributes.dept_id") and len(attributes.dept_id) and not isdefined("empid_list")>
				<!---şubede çalışan yoksa kayıt gelmemesi için--->
				AND 1=2
			</cfif>
			<cfif isDefined('attributes.is_event_result') and attributes.is_event_result eq 1>
				AND EVENT.EVENT_ID IN (SELECT EVENT_ID FROM EVENT_RESULT)
			<cfelseif isDefined('attributes.is_event_result') and attributes.is_event_result eq 0>
				AND EVENT.EVENT_ID NOT IN (SELECT EVENT_ID FROM EVENT_RESULT)
			</cfif>            
		ORDER BY
			EVENT.FINISHDATE DESC
         <!---  </pre></cfoutput>--->
   </cfquery>
<cfelse>
	<cfset get_event_search.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_event_search.recordcount#'>  
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="GET_EVENT_CATS" datasource="#dsn#">
    SELECT * FROM EVENT_CAT ORDER BY EVENTCAT
</cfquery>
<cfquery name="get_event_stage" datasource="#dsn#">
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
        PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%agenda.form_add_event%">
    ORDER BY
        PTR.STAGE
</cfquery>
<cfparam name="attributes.emp_id" default="">
<cfparam name="attributes.par_id" default="">
<cfparam name="attributes.cons_id" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.record_emp_id" default="">
<cfparam name="attributes.record_par_id" default="">
<cfparam name="attributes.record_member_name" default="">
<cfparam name="attributes.record_member_type" default="">
<cfparam name="attributes.event_id" default="">
<cfparam name="attributes.event_result_id" default="">
<cfquery name="get_branches_dept" datasource="#dsn#">
    SELECT 
        B.BRANCH_ID,
        B.BRANCH_NAME,
        D.DEPARTMENT_ID,
        D.DEPARTMENT_HEAD 
    FROM 
        BRANCH B,
        DEPARTMENT D 
    WHERE 
        B.COMPANY_ID = #SESSION.EP.COMPANY_ID# AND
        D.BRANCH_ID = B.BRANCH_ID AND
        B.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# ) ORDER BY BRANCH_NAME
</cfquery>
<cfparam name="attributes.keyword" default="">
<cfsavecontent variable="head"><cf_get_lang dictionary_id='39071.Olay Analiz Raporu'></cfsavecontent>
	<cf_report_list_search title="#head#">
		<cf_report_list_search_area>
			<cfform name="search" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
				<div class="row">
        			<div class="col col-12 col-xs-12">
           				 <div class="row formContent">
			   				<div class="row" type="row">
			      				<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
									<div class="col col-12 col-xs-12">
										<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>	
											<div class="col col-12 col-xs-12">
												<select name="eventcat_id" id="eventcat_id" multiple>
													<cfoutput query="get_event_cats">
														<option value="#eventcat_id#" <cfif ListFind(attributes.eventcat_id,eventcat_id,',')>selected</cfif>>#eventcat#</option>
													</cfoutput>
												</select>	
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58054.Süreç-Aşama'></label>
											<div class="col col-12 col-xs-12">
												<select name="event_stage" id="event_stage" multiple>
													<cfoutput query="get_event_stage">
														<option value="#process_row_id#" <cfif ListFind(attributes.event_stage,process_row_id,',')>selected</cfif>>#stage#</option>
													</cfoutput>
												</select>				
											</div>	
										</div>
									</div>
     							</div>
								<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
									<div class="col col-12 col-xs-12">					
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
											<div class="col col-12 col-xs-12">
												<div class="input-group">
													<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined("attributes.project_id") and len(attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
													<input type="text" name="project_head" id="project_head" value="<cfif isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_head")><cfoutput>#attributes.project_head#</cfoutput></cfif>" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','100');" autocomplete="off">
													<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>"<a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=form.project_id&project_head=form.project_head');"></span>
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='29780.Katılımcı'></label>
											<div class="col col-12 col-xs-12">
												<div class="input-group">
													<input type="hidden" name="emp_id" id="emp_id" value="<cfif isdefined("attributes.emp_id")><cfoutput>#attributes.emp_id#</cfoutput></cfif>">
													<input type="hidden" name="par_id" id="par_id" value="<cfif isdefined("attributes.par_id")><cfoutput>#attributes.par_id#</cfoutput></cfif>">
													<input type="hidden" name="cons_id" id="cons_id" value="<cfif isdefined("attributes.cons_id")><cfoutput>#attributes.cons_id#</cfoutput></cfif>">
													<input type="hidden" name="member_type" id="member_type"  value="<cfif isdefined("attributes.member_type")><cfoutput>#attributes.member_type#</cfoutput></cfif>">
													<input name="member_name" type="text" id="member_name" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3,9\'','CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE,PARTNER_ID','cons_id,emp_id,member_type,par_id','','3','250');" value="<cfif isdefined("attributes.member_name") and len(attributes.member_name)><cfoutput>#attributes.member_name#</cfoutput></cfif>" autocomplete="off">
													<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>"<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=search.emp_id&field_name=search.member_name&field_type=search.member_type&field_partner=search.par_id&field_consumer=search.cons_id&select_list=1,2,3,5,6</cfoutput>','list');"></span>				
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57899.Kaydeden'></label>
											<div class="col col-12 col-xs-12"> 
												<div class="input-group">	
													<input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfif isdefined("attributes.record_emp_id")><cfoutput>#attributes.record_emp_id#</cfoutput></cfif>">
													<input type="hidden" name="record_par_id" id="record_par_id" value="<cfif isdefined("attributes.record_par_id")><cfoutput>#attributes.record_par_id#</cfoutput></cfif>">									
													<input type="hidden" name="record_member_type" id="record_member_type" value="<cfif isdefined("attributes.record_member_type")><cfoutput>#attributes.record_member_type#</cfoutput></cfif>"> 
													<input type="text" name="record_member_name" id="record_member_name" onfocus="AutoComplete_Create('record_member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,3,9\'','EMPLOYEE_ID,MEMBER_TYPE,PARTNER_ID','record_emp_id,record_member_type,record_par_id','','3','250');" value="<cfif isdefined("attributes.record_member_name") and len(attributes.record_member_name)><cfoutput>#attributes.record_member_name#</cfoutput></cfif>" autocomplete="off">
													<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>"<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=search.record_emp_id&field_name=search.record_member_name&field_type=search.record_member_type&field_partner=search.record_par_id&select_list=1,2,6</cfoutput>','list');"></span>
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='55434.Başvuru Tarihi'>*</label>
											<div class="col col-6">
												<div class="input-group">
													<cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
													<cfif isdefined("attributes.startdate")>
														<cfinput type="text" name="startdate" value="#dateformat(attributes.startdate,dateformat_style)#" maxlength="10" required="yes" message="#message#" validate="#validate_style#" style="width:65px;">
													<cfelse>
														<cfinput type="text" name="startdate" value="" style="width:65px;" validate="#validate_style#" maxlength="10" required="yes" message="#message#">
													</cfif>
													<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span> 
												</div>
											</div>
											<div class="col col-6">
												<div class="input-group">
													<cfsavecontent variable="message1"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
													<cfif isdefined("attributes.finishdate")>
														<cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate,dateformat_style)#" maxlength="10" required="yes" message="#message1#" validate="#validate_style#" style="width:65px;">
													<cfelse>
														<cfinput type="text" name="finishdate" value="" style="width:65px;" validate="#validate_style#" maxlength="10" required="yes" message="#message1#">
													</cfif>
													<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
												</div>
											</div>
										</div>
									</div>
								</div>
								<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
									<div class="col col-12 col-xs-12">
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57460.Filtre'></label>
											<div class="col col-12 col-xs-12">
												<cfinput type="text" name="keyword" maxlength="90" value="#attributes.keyword#">			
											</div>
										</div>
										<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
											<div class="col col-12 col-xs-12">
												<select name="dept_id" id="dept_id"> 
													<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>									
													<cfoutput query="get_branches_dept">
														<option value="#DEPARTMENT_ID#" <cfif isdefined("attributes.dept_id") and attributes.dept_id eq DEPARTMENT_ID>selected</cfif>>#BRANCH_NAME#-#DEPARTMENT_HEAD#</option>
													</cfoutput>
												</select>
											</div>
										</div>
										<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="57756.Durum"></label>
											<div class="col col-12 col-xs-12">
												<select name="is_event_result" id="is_event_result">                            	
													<option selected value=""><cf_get_lang dictionary_id ='57708.Tümü'></option>
													<option value="1" <cfif isDefined('attributes.is_event_result') and attributes.is_event_result eq 1> selected</cfif>><cf_get_lang dictionary_id='40650.Tutanak Girilmiş'></option>
													<option value="0" <cfif isdefined('attributes.is_event_result') and attributes.is_event_result eq 0>selected</cfif>><cf_get_lang dictionary_id='40651.Tutanak Girilmemiş'></option>
												</select>
											</div>
										</div>
									</div>
								</div>
			   				</div>
						</div>
						<div class="row ReportContentBorder">
                			<div class="ReportContentFooter">
							  	<label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
								<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
									<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3" style="width:25px;">
								<cfelse>
									<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" onKeyUp="isNumber(this)" message="#message#" maxlength="3" style="width:25px;">
								</cfif>
								<input name="form_varmi" id="form_varmi" value="1" type="hidden">
								<cf_wrk_report_search_button button_type='1' is_excel='1' search_function='control()'>
						    </div>
						</div>
					</div>
				</div> 
			</cfform>     
		</cf_report_list_search_area>
	</cf_report_list_search>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-8">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</cfif>
<cfif IsDefined("attributes.form_varmi")>
<cf_report_list>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='57487.No'></th>
				<th><cf_get_lang dictionary_id='57480.Başlık'></th>
				<th><cf_get_lang dictionary_id='39074.Olay Kategorisi'></th>
				<th><cf_get_lang dictionary_id="57416.Proje"></th>
				<th><cf_get_lang dictionary_id="57482.Aşama"></th>
				<th><cf_get_lang dictionary_id='58053.Başlama Tarihi'></th>
				<th><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
				<th><cf_get_lang dictionary_id='57684.Sonuç'></th>
			</tr>
		</thead>
			<cfset project_name_list = ''>
			<cfif get_event_search.recordcount>
				<cfoutput query="get_event_search" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfif len(project_id) and not listfind(project_name_list,project_id)>
						<cfset project_name_list = Listappend(project_name_list,project_id)>
					</cfif>
				</cfoutput>
				<cfif len(project_name_list)>
					<cfquery name="get_project_name" datasource="#dsn#">
						SELECT PROJECT_HEAD, PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_name_list#) ORDER BY PROJECT_ID
					</cfquery>
					<cfset project_name_list = listsort(listdeleteduplicates(valuelist(get_project_name.project_id,',')),'numeric','ASC',',')>
				</cfif>
				<cfquery name="get_eventcat_id" datasource="#dsn#">
					SELECT EVENTCAT,EVENTCAT_ID FROM EVENT_CAT ORDER BY EVENTCAT_ID
				</cfquery>
				<cfset eventcat_id_list=ValueList(GET_EVENTCAT_ID.EVENTCAT_ID,',')>
			</cfif>
			<cfif isdefined("attributes.form_varmi") and get_event_search.recordcount>
				<cfset get_result_row_list = ''>
				<cfoutput query="get_event_search" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfset get_result_row_list = listappend(get_result_row_list,event_id,',')>
				</cfoutput>
				<cfquery name="GET_RESULT_ROW" datasource="#dsn#">
					SELECT EVENT_ID,EVENT_RESULT_ID FROM EVENT_RESULT WHERE EVENT_ID IN (#get_result_row_list#)
				</cfquery>
				<cfset get_result_row_list = listsort(ValueList(GET_RESULT_ROW.EVENT_ID,','),'numeric','ASC',',')>
				<tbody>
					<cfoutput query="get_event_search" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td style="text-align:center;">#event_id#</td>
							<td style="text-align:center;">
								<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
									#event_head#
								<cfelse>
									<a href="#request.self#?fuseaction=agenda.view_daily&event=upd&event_id=#event_id#">#event_head#</a>
								</cfif>
							</td>
							<td style="text-align:center;">#eventcat#</td>
							<td style="text-align:center;">
							<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
								<cfif len(project_id) and project_id neq 0>
									#get_project_name.project_head[listfind(project_name_list,project_id,',')]#
								<cfelse>
									<cf_get_lang dictionary_id='58459.projesiz'>
								</cfif>
							
							<cfelse>
								<cfif len(project_id) and project_id neq 0>
									<a href="#request.self#?fuseaction=project.projects&event=det&id=#get_project_name.project_id[listfind(project_name_list,project_id,',')]#" >#get_project_name.project_head[listfind(project_name_list,project_id,',')]#</a>
								<cfelse>
									<cf_get_lang dictionary_id='58459.projesiz'>
								</cfif>
							</cfif>
							</td>	
							<td style="text-align:center;">#stage#</td>
							<td widtth="100" style="text-align:center;">#dateformat(date_add('h',session.ep.time_zone,startdate),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,startdate),timeformat_style)#</td>
							<td width="100" style="text-align:center;">#dateformat(date_add('h',session.ep.time_zone,finishdate),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,finishdate),timeformat_style)#</td>
							<td>
								

								<cfif listfind(get_result_row_list,event_id,',')>				
										<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=agenda.popup_event_result&event_id=#event_id#','page');"><cf_get_lang dictionary_id='39486.Tutanak'> <cf_get_lang dictionary_id='58596.Göster'></a>
								</cfif>
							</td>
						</tr>
					</cfoutput>
				</tbody>
			<cfelse>
				<tbody>
					<tr>
						<td colspan="8"><cfif isdefined("attributes.form_varmi")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
					</tr>
				</tbody>
			</cfif>
</cf_report_list>
<cfset url_str = "">
<cfif isdefined("attributes.record_emp_id") and len(attributes.record_emp_id)>
	<cfset url_str= "#url_str#&record_emp_id=#attributes.record_emp_id#">
</cfif>
<cfif isdefined("attributes.record_par_id") and len(attributes.record_par_id)>
	<cfset url_str= "#url_str#&record_par_id=#attributes.record_par_id#">
</cfif>
<cfif isdefined("attributes.record_member_type") and len(attributes.record_member_type)>
	<cfset url_str= "#url_str#&record_member_type=#attributes.record_member_type#">
</cfif>
<cfif isdefined("attributes.record_member_name") and len(attributes.record_member_name)>
	<cfset url_str= "#url_str#&record_member_name=#attributes.record_member_name#">
</cfif>
<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
	<cfset url_str = "#url_str#&startdate=#dateformat(attributes.startdate,dateformat_style)#">
</cfif>
<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
	<cfset url_str = "#url_str#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#">
</cfif>
<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<!---sfsFS--->
<cfif isdefined("attributes.project_id")>
	<cfset url_str = "#url_str#&project_id=#attributes.project_id#">
</cfif>
<cfif isdefined("attributes.project_head")>
	<cfset url_str = "#url_str#&project_head=#URLDecode(attributes.project_head)#">
</cfif>
<!---fbsdgs--->
<cfif isdefined("attributes.eventcat_id") and len(attributes.eventcat_id)>
	<cfset url_str = "#url_str#&eventcat_id=#attributes.eventcat_id#">
</cfif>
<cfif isdefined("attributes.event_stage") and len(attributes.event_stage)>
	<cfset url_str = "#url_str#&event_stage=#attributes.event_stage#">
</cfif>
<cfif isdefined("attributes.form_varmi") and len(attributes.form_varmi)>
	<cfset url_str = "#url_str#&form_varmi=#attributes.form_varmi#" >
</cfif>
<cfif isdefined("attributes.event_id") and len(attributes.event_id)>
	<cfset url_str = "#url_str#&event_id=#attributes.event_id#">
</cfif>
<cfif isdefined("attributes.event_result_id") and len(attributes.event_result_id)>
	<cfset url_str = "#url_str#&event_result_id=#attributes.event_result_id#">
</cfif>
<cfif isdefined("attributes.dept_id") and len(attributes.dept_id)>
	<cfset url_str = "#url_str#&dept_id=#attributes.dept_id#">
</cfif>
<cfif isdefined("attributes.emp_id") and len(attributes.emp_id)>
	<cfset url_str= "#url_str#&emp_id=#attributes.emp_id#">
</cfif>
<cfif isdefined("attributes.par_id") and len(attributes.par_id)>
	<cfset url_str= "#url_str#&par_id=#attributes.par_id#">
</cfif>
<cfif isdefined("attributes.cons_id") and len(attributes.cons_id)>
	<cfset url_str= "#url_str#&cons_id=#attributes.cons_id#">
</cfif>
<cfif isdefined("attributes.member_type") and len(attributes.member_type)>
	<cfset url_str= "#url_str#&member_type=#attributes.member_type#">
</cfif>
<cfif isdefined("attributes.member_name") and len(attributes.member_name)>
	<cfset url_str= "#url_str#&member_name=#attributes.member_name#">
</cfif>
<cfif isdefined("attributes.is_event_result") and len(attributes.is_event_result)>
	<cfset url_str= "#url_str#&is_event_result=#attributes.is_event_result#">
</cfif>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cf_paging page="#attributes.page#"
	maxrows="#attributes.maxrows#"
	totalrecords="#attributes.totalrecords#"
	startrow="#attributes.startrow#"
	adres="#attributes.fuseaction#&#url_str#"> 
</cfif>
</cfif>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	 function control(){
		 if ((document.search.startdate.value != '') && (document.search.finishdate.value != '') &&
	    !date_check(search.startdate,search.finishdate,"<cf_get_lang dictionary_id ='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
	         return false;
		if(document.search.is_excel.checked==false)
			{
				document.search.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.agenda_rapor"
				return true;
			}
			else
				document.search.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_agenda_rapor</cfoutput>"
	}
</script>
