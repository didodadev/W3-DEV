<cfparam name="attributes.module_id_control" default="1">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.report_type" default="1">
<cfparam name="attributes.graph_type" default="pie">
<cfparam name="attributes.work_cat_view" default="">
<cfparam name="attributes.work_stage_view" default="">
<cfparam name="attributes.work_priority_view" default="">
<cfparam name="attributes.is_excel" default="0">
<cfparam name="attributes.pro_employee" default="">
<cfparam name="attributes.pro_employee_id" default="">
<cfparam name="attributes.work_status" default="2">
<script src="JS/Chart.min.js"></script>
<cfif isdefined("attributes.form_varmi")>
	<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
		<cf_date tarih="attributes.startdate">
	</cfif>
	<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
		<cf_date tarih="attributes.finishdate">
	</cfif>
	<cfquery name="get_works" datasource="#dsn#">
		<cfif attributes.report_type neq 3>
			SELECT
				PW.*,
				DATEDIFF(MINUTE,TARGET_FINISH,TERMINATE_DATE) TERMIN,
				'1' AS TYPE,
				E.EMPLOYEE_ID,
				E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS MEMBER_NAME
			FROM
				PRO_WORKS PW,
				EMPLOYEES E,
				PRO_WORK_CAT,
				SETUP_PRIORITY
			WHERE
				PRO_WORK_CAT.WORK_CAT_ID = PW.WORK_CAT_ID	AND
				PW.WORK_PRIORITY_ID = SETUP_PRIORITY.PRIORITY_ID AND
				PW.WORK_CURRENCY_ID <> -3 AND
				PW.TERMINATE_DATE IS NOT NULL AND
				PW.PROJECT_EMP_ID = E.EMPLOYEE_ID
				<cfif attributes.work_status eq 1>
					AND PW.WORK_STATUS = 1
				<cfelseif attributes.work_status eq 0>
					AND PW.WORK_STATUS = 0
				</cfif>
				<cfif len(attributes.pro_employee) and len(attributes.pro_employee_id)>
					AND E.EMPLOYEE_ID = #attributes.pro_employee_id#
				</cfif>
				<cfif len(attributes.project_head) and len(attributes.project_id)>
					AND PW.PROJECT_ID = #attributes.project_id#
				</cfif>
				<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
					AND PW.TARGET_START >= #attributes.startdate#
				</cfif>
				<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
					AND PW.TARGET_FINISH <= #attributes.finishdate#
				</cfif>
				<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
					AND E.EMPLOYEE_ID IN (	
										SELECT EMPLOYEE_ID 
										FROM EMPLOYEE_POSITIONS,DEPARTMENT
										WHERE EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND DEPARTMENT.BRANCH_ID = #attributes.branch_id#
										)
				</cfif>
				<cfif isdefined("attributes.department") and len(attributes.department)>
					AND E.EMPLOYEE_ID IN (	
										SELECT EMPLOYEE_ID 
										FROM EMPLOYEE_POSITIONS
										WHERE EMPLOYEE_POSITIONS.DEPARTMENT_ID = #attributes.department#
										)
				</cfif>
			UNION ALL
			SELECT
				PW.*,
				'0' AS TERMIN,
				'1' AS TYPE,
				E.EMPLOYEE_ID,
				E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS MEMBER_NAME
			FROM
				PRO_WORKS PW,
				EMPLOYEES E,
				PRO_WORK_CAT,
				SETUP_PRIORITY
			WHERE
				PRO_WORK_CAT.WORK_CAT_ID = PW.WORK_CAT_ID	AND
				PW.WORK_PRIORITY_ID = SETUP_PRIORITY.PRIORITY_ID AND
				PW.WORK_CURRENCY_ID <> -3 AND
				PW.TERMINATE_DATE IS NULL AND
				PW.PROJECT_EMP_ID = E.EMPLOYEE_ID
				<cfif attributes.work_status eq 1>
					AND PW.WORK_STATUS = 1
				<cfelseif attributes.work_status eq 0>
					AND PW.WORK_STATUS = 0
				</cfif>
				<cfif len(attributes.pro_employee) and len(attributes.pro_employee_id)>
					AND E.EMPLOYEE_ID = #attributes.pro_employee_id#
				</cfif>
				<cfif len(attributes.project_head) and len(attributes.project_id)>
					AND PW.PROJECT_ID = #attributes.project_id#
				</cfif>
				<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
					AND PW.TARGET_START >= #attributes.startdate#
				</cfif>
				<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
					AND PW.TARGET_FINISH <= #attributes.finishdate#
				</cfif>
				<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
					AND E.EMPLOYEE_ID IN (	
										SELECT EMPLOYEE_ID 
										FROM EMPLOYEE_POSITIONS,DEPARTMENT
										WHERE EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND DEPARTMENT.BRANCH_ID = #attributes.branch_id#
										)
				</cfif>
				<cfif isdefined("attributes.department") and len(attributes.department)>
					AND E.EMPLOYEE_ID IN (	
										SELECT EMPLOYEE_ID 
										FROM EMPLOYEE_POSITIONS
										WHERE EMPLOYEE_POSITIONS.DEPARTMENT_ID = #attributes.department#
										)
				</cfif>
		</cfif>
		<cfif attributes.report_type eq 3 or attributes.report_type eq 1 or attributes.report_type eq 0>
		<!---<cfif attributes.report_type neq 3> UNION ALL</cfif>--->
			SELECT
				PW.*,
				DATEDIFF(MINUTE,TARGET_FINISH,TERMINATE_DATE) TERMIN,
				'2' AS TYPE,
				'' EMPLOYEE_ID,
				CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME AS MEMBER_NAME
			FROM
				PRO_WORKS PW,
				COMPANY_PARTNER CP,
				PRO_WORK_CAT,
				SETUP_PRIORITY
			WHERE
				PRO_WORK_CAT.WORK_CAT_ID = PW.WORK_CAT_ID	AND
				PW.WORK_PRIORITY_ID = SETUP_PRIORITY.PRIORITY_ID AND
				PW.WORK_CURRENCY_ID <> -3 AND
				PW.TERMINATE_DATE IS NOT NULL AND
				PW.OUTSRC_PARTNER_ID = CP.PARTNER_ID
				<cfif attributes.work_status eq 1>
					AND PW.WORK_STATUS = 1
				<cfelseif attributes.work_status eq 0>
					AND PW.WORK_STATUS = 0
				</cfif>
				<cfif len(attributes.pro_employee) and len(attributes.pro_employee_id)>
					AND PW.PROJECT_EMP_ID = #attributes.pro_employee_id#
				</cfif>
				<cfif len(attributes.project_head) and len(attributes.project_id)>
					AND PW.PROJECT_ID = #attributes.project_id#
				</cfif>
				<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
					AND PW.TARGET_START >= #attributes.startdate#
				</cfif>
				<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
					AND PW.TARGET_FINISH <= #attributes.finishdate#
				</cfif>
				<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
					AND CP.COMPANY_ID IN (	
										SELECT COMPANY.COMPANY_ID 
										FROM COMPANY,COMPANY_BRANCH_RELATED
										WHERE COMPANY.COMPANY_ID = COMPANY_BRANCH_RELATED.COMPANY_ID AND COMPANY_BRANCH_RELATED.BRANCH_ID = #attributes.branch_id#
										)
				</cfif>
			UNION ALL
			SELECT
				PW.*,
				'0' AS TERMIN,
				'2' AS TYPE,
				'' EMPLOYEE_ID,
				CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME AS MEMBER_NAME
			FROM
				PRO_WORKS PW,
				COMPANY_PARTNER CP,
				PRO_WORK_CAT,
				SETUP_PRIORITY
			WHERE
				PRO_WORK_CAT.WORK_CAT_ID = PW.WORK_CAT_ID	AND
				PW.WORK_PRIORITY_ID = SETUP_PRIORITY.PRIORITY_ID AND
				PW.WORK_CURRENCY_ID <> -3 AND
				PW.TERMINATE_DATE IS NULL AND
				PW.OUTSRC_PARTNER_ID = CP.PARTNER_ID
				<cfif attributes.work_status eq 1>
					AND PW.WORK_STATUS = 1
				<cfelseif attributes.work_status eq 0>
					AND PW.WORK_STATUS = 0
				</cfif>
				<cfif len(attributes.pro_employee) and len(attributes.pro_employee_id)>
					AND PW.PROJECT_EMP_ID = #attributes.pro_employee_id#
				</cfif>
				<cfif len(attributes.project_head) and len(attributes.project_id)>
					AND PW.PROJECT_ID = #attributes.project_id#
				</cfif>
				<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
					AND PW.TARGET_START >= #attributes.startdate#
				</cfif>
				<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
					AND PW.TARGET_FINISH <= #attributes.finishdate#
				</cfif>
				<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
					AND CP.COMPANY_ID IN (	
										SELECT COMPANY.COMPANY_ID 
										FROM COMPANY,COMPANY_BRANCH_RELATED
										WHERE COMPANY.COMPANY_ID = COMPANY_BRANCH_RELATED.COMPANY_ID AND COMPANY_BRANCH_RELATED.BRANCH_ID = #attributes.branch_id#
										)
				</cfif>
			</cfif>
	</cfquery>
	<cfquery name="get_work_stages" datasource="#dsn#">
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
			PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%project.popup_add_work,%">
		ORDER BY
			PTR.LINE_NUMBER
	</cfquery>
	<cfquery name="get_projects" datasource="#dsn#">
		SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_STATUS = 1 ORDER BY PROJECT_ID
	</cfquery>
	<cfquery name="get_work_cats" datasource="#dsn#">
		SELECT WORK_CAT_ID,WORK_CAT FROM PRO_WORK_CAT ORDER BY WORK_CAT_ID
	</cfquery>
	<cfquery name="get_work_proirity" datasource="#dsn#">
		SELECT PRIORITY_ID,PRIORITY FROM SETUP_PRIORITY ORDER BY PRIORITY_ID
	</cfquery>
	<cfquery name="get_members" dbtype="query">
		SELECT DISTINCT
			PROJECT_EMP_ID,
			MEMBER_NAME,
			TYPE,
			OUTSRC_PARTNER_ID
		FROM
			get_works
		ORDER BY
			MEMBER_NAME
	</cfquery>
<cfelse>
	<cfset get_members.recordcount = 0>
</cfif>
<cfquery name="get_branches" datasource="#dsn#">
	SELECT
		BRANCH.BRANCH_STATUS,
		BRANCH.HIERARCHY,
		BRANCH.HIERARCHY2,
		BRANCH.BRANCH_ID,
		BRANCH.BRANCH_NAME,
		OUR_COMPANY.COMP_ID,
		OUR_COMPANY.COMPANY_NAME,
		OUR_COMPANY.NICK_NAME
	FROM
		BRANCH,
		OUR_COMPANY
	WHERE
		BRANCH.BRANCH_ID IS NOT NULL
		AND BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
		AND BRANCH.BRANCH_STATUS = 1
	ORDER BY
		OUR_COMPANY.NICK_NAME,
		BRANCH.BRANCH_NAME
</cfquery>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_members.recordcount#'>  
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfsavecontent variable="head"><cf_get_lang dictionary_id='39925.Proje Is Raporu' ></cfsavecontent>
<cfform name="project_work" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
<input name="form_varmi" id="form_varmi" value="1" type="hidden">
<cf_report_list_search title="#head#">
    <cf_report_list_search_area>
    <div class="row">
            <div class="col col-12 col-xs-12">
                <div class="row formContent">
                    <div class="row" type="row">
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                            <div class="col col-12 col-md-12 col-xs-12">
                                <div class="col col-12 col-md-12 col-xs-12">
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                                        <div class="col col-12 col-md-12 col-xs-12">
                                            <div class="input-group">
                                                <cfoutput>
                                                    <input type="hidden" name="project_id" id="project_id" value="#attributes.project_id#">
                                                    <input name="project_head" type="text" id="project_head" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','project_work','3','250');" value="#attributes.project_head#" autocomplete="off">
                                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_head=project_work.project_head&project_id=project_work.project_id');"></span>
                                                </cfoutput>     
                                            </div>  
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57569.Görevli'></label>
                                        <div class="col col-12 col-md-12 col-xs-12">
                                            <div class="input-group">
                                                <input type="hidden" name="pro_employee_id" id="pro_employee_id" value="<cfif isdefined('attributes.pro_employee_id') and len(attributes.pro_employee)><cfoutput>#attributes.pro_employee_id#</cfoutput></cfif>">
                                                <input type="text" name="pro_employee" id="pro_employee" value="<cfif isdefined('attributes.pro_employee') and len(attributes.pro_employee)><cfoutput>#attributes.pro_employee#</cfoutput></cfif>" style="width:135px;" onfocus="AutoComplete_Create('pro_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','pro_employee_id','','3','135');" autocomplete="off">
                                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=project_work.pro_employee_id&field_name=project_work.pro_employee&select_list=1','list');"></span>                                     
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                            <div class="col col-12 col-md-12 col-xs-12">
                                <div class="col col-12 col-md-12 col-xs-12">
                                    <div class="form-group">
                                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                                        <div class="col col-12">
                                            <select name="branch_id" id="branch_id" onchange="showDepartment(this.value)" style="width:150px;">
                                                <option value=""><cf_get_lang dictionary_id='57453.Şube'></option>
                                                <cfoutput query="get_branches" group="NICK_NAME">
                                                <optgroup label="#NICK_NAME#"></optgroup>
                                                    <cfoutput>
                                                        <option value="#BRANCH_ID#"<cfif isdefined("attributes.branch_id") and (attributes.branch_id eq branch_id)> selected</cfif>>#BRANCH_NAME#</option>
                                                    </cfoutput>
                                                </cfoutput>
                                            </select>
                                        </div>					
                                    </div>
                                    <div class="form-group">
                                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                                        <div class="col col-12" id="DEPARTMENT_PLACE">
                                            <select name="department" id="department" style="width:150px;">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfif isdefined('attributes.branch_id') and isnumeric(attributes.branch_id)>
                                                <cfquery name="get_departmant" datasource="#dsn#">
                                                    SELECT * FROM DEPARTMENT WHERE DEPARTMENT_STATUS = 1 AND BRANCH_ID = #attributes.branch_id# ORDER BY DEPARTMENT_HEAD
                                                </cfquery>
                                                <cfoutput query="get_departmant">
                                                    <option value="#DEPARTMENT_ID#"<cfif isdefined('attributes.department') and (attributes.department eq get_departmant.DEPARTMENT_ID)>selected</cfif>>#DEPARTMENT_HEAD#</option>
                                                </cfoutput>
                                            </cfif>
                                            </select>
                                        </div>					
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12">&nbsp</label>
                                        <div class="col col-4">
                                        <label><input type="checkbox" name="work_cat_view" id="work_cat_view" value="1" <cfif attributes.work_cat_view eq 1>checked</cfif> /><cf_get_lang dictionary_id='57486.Kategori'></label>&nbsp;
                                        </div>
                                        <div class="col col-4">
                                        <label><input type="checkbox" name="work_stage_view" id="work_stage_view" value="1" <cfif attributes.work_stage_view eq 1>checked</cfif>/><cf_get_lang dictionary_id='57482.Aşama'></label>&nbsp;
                                        </div>
                                        <div class="col col-4">
                                        <label><input type="checkbox" name="work_priority_view" id="work_priority_view"  value="1" <cfif attributes.work_priority_view eq 1>checked</cfif>/><cf_get_lang dictionary_id='57485.Öncelik'></label>&nbsp;
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                            <div class="col col-12 col-md-12 col-xs-12">
                                <div class="col col-12 col-md-12 col-xs-12">
                                    <div class="form-group">		
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58960.Rapor Tipi'></label>		
                                        <div class="col col-6">
                                                <select name="report_type" id="report_type" onchange="tip_gizle()">
                                                    <option value="1" <cfif isdefined("attributes.report_type") and attributes.report_type eq 1>selected</cfif>><cf_get_lang dictionary_id="40020.Grafikler"></option>
                                                    <option value="2" <cfif isdefined("attributes.report_type") and attributes.report_type eq 2>selected</cfif>><cf_get_lang dictionary_id="58875.Çalisanlar"></option>
                                                    <option value="3" <cfif isdefined("attributes.report_type") and attributes.report_type eq 3>selected</cfif>><cf_get_lang dictionary_id="39769.İş Ortakları"></option>
                                                    <option value="0" <cfif isdefined("attributes.report_type") and attributes.report_type eq 0>selected</cfif>><cf_get_lang dictionary_id="58081.Hepsi"></option>
                                                </select>
                                        </div>
                                        
                                            <div class="col col-6">
                                                <select name="graph_type" id="graph_type" <cfif isdefined("attributes.report_type") and attributes.report_type neq 1>style="display:none;"</cfif>>
                                                    <option value="pie" <cfif attributes.graph_type is 'pie'>selected</cfif>><cf_get_lang dictionary_id='58728.Pasta'></option>
                                                    <option value="bar" <cfif attributes.graph_type is 'bar'>selected</cfif>><cf_get_lang dictionary_id='57663.Bar'></option>
                                                </select>		
                                            </div>
                                        			
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'></label>				
                                        <div class="col col-6 col-md-6">
                                            <div class="input-group">
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id ='57738.Baslangiç tarihini yaziniz'> !</cfsavecontent>
                                                <cfif isdefined("attributes.startdate")>
                                                    <cfinput type="text" name="startdate" value="#dateformat(attributes.startdate,dateformat_style)#" maxlength="10" message="#message#" validate="#validate_style#">
                                                <cfelse>
                                                    <cfinput type="text" name="startdate" value="" validate="#validate_style#" maxlength="10" message="#message#">
                                                </cfif>
                                                <span class="input-group-addon">
                                                <cf_wrk_date_image date_field="startdate">
                                                </span> 
                                            </div>
                                        </div>
                                        <div class="col col-6 col-md-6">
                                            <div class="input-group">
                                                <cfsavecontent variable="message1"><cf_get_lang dictionary_id ='39357.Bitis tarihini yaziniz'> !</cfsavecontent>
                                                <cfif isdefined("attributes.finishdate")>
                                                    <cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate,dateformat_style)#" maxlength="10" message="#message1#" validate="#validate_style#">
                                                <cfelse>
                                                    <cfinput type="text" name="finishdate" value="" validate="#validate_style#" maxlength="10" message="#message1#">
                                                </cfif>
                                                <span class="input-group-addon">
                                                <cf_wrk_date_image date_field="finishdate">	
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='33134.Geçerlilik'></label>
                                        <div class="col col-12">
                                            <select name="work_status" id="work_status">
                                                <option value="2"><cf_get_lang dictionary_id='57708.Tümü'></option>
                                                <option value="1" <cfif attributes.work_status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                                                <option value="0" <cfif attributes.work_status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                    </div>
                </div>
                <div class="row ReportContentBorder">
                    <div class="ReportContentFooter">
                        <label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
                                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3" style="width:25px;">
                            <cfelse>
                                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
                            </cfif>
                        <cf_wrk_report_search_button button_type='1' is_excel="1" search_function="control()">
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
<cfif isdefined("attributes.form_varmi") and len(attributes.form_varmi)>
	<cfif attributes.report_type eq 1>
		<cfif not len(attributes.project_id) or not len(attributes.project_head)>
			<cfquery name="get_pro_work" dbtype="query">
				SELECT
					get_works.PROJECT_ID, 
					COUNT(get_works.PROJECT_ID) AS TOPLAM,
					get_projects.PROJECT_HEAD AS DURUM
				FROM
					get_works,
					get_projects
				WHERE
					get_projects.PROJECT_ID = get_works.PROJECT_ID
				GROUP BY
					get_works.PROJECT_ID,
					get_projects.PROJECT_HEAD
				ORDER BY
					TOPLAM DESC
			</cfquery>
            <cf_report_list height="250">
                <thead>
                    <tr>
                        <th style="text-align:left; width:50px;"><cf_get_lang dictionary_id ='40416.Projelere Göre'></th>
                        <cfif attributes.work_status eq 1 or attributes.work_status eq 2>
                            <th style="text-align:left; width:50px;"><cf_get_lang dictionary_id='57493.Aktif'></th>
                        </cfif>
                        <cfif attributes.work_status eq 0 or attributes.work_status eq 2>
                            <th style="text-align:left; width:50px;"><cf_get_lang dictionary_id='57494.Pasif'></th>
                        </cfif>
                        <cfif attributes.work_status eq 2>
                            <th style="text-align:left; width:50px;"><cf_get_lang dictionary_id='57492.Toplam'></th>
                        </cfif>
                    </tr>
                </thead>
                <cfif get_works.recordcount>
                    <tbody>
                        <cfoutput query="get_pro_work">
                            <cfquery name="get_pro_work_active" dbtype="query">
                                SELECT COUNT(PROJECT_ID) AS TOPLAM_ACTIVE FROM get_works WHERE WORK_STATUS = 1 AND PROJECT_ID = #project_id#
                            </cfquery>
                            <cfif len(get_pro_work_active.toplam_active)>
                                <cfset toplam_active = #get_pro_work_active.toplam_active#>
                            <cfelse>
                                    <cfset toplam_active = 0>
                            </cfif>
                            <tr>
                                <td width="200">#durum#</td>
                                <cfif attributes.work_status eq 1 or attributes.work_status eq 2>
                                    <td align="right" style="text-align:left;">#toplam_active#</td>
                                </cfif>
                                <cfif attributes.work_status eq 0 or attributes.work_status eq 2>
                                    <td align="right" style="text-align:left;">
                                        <cfset toplam_passive = (toplam-toplam_active)>#toplam_passive#
                                    </td>
                                </cfif>
                                <cfif attributes.work_status eq 2>
                                    <td align="right" style="text-align:left;"><b>#toplam#</b></td>
                                </cfif>
                            </tr>
                        </cfoutput>
                    </tbody>
                <cfelse>
                    <tbody>
                        <tr>
                        <cfif attributes.report_type eq 1>
                            <td colspan="11"><!-- sil --><cfif isdefined('attributes.form_varmi') and len(attributes.form_varmi)><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!<!-- sil --></td>
                        <cfelse><td colspan="33"><!-- sil --><cfif isdefined('attributes.form_varmi') and len(attributes.form_varmi)><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!<!-- sil --></td>
                        </cfif>
                        </tr>
                    </tbody>
                </cfif>
            </cf_report_list>
            <cfoutput query="get_pro_work">
                <cfset value = #toplam#>
                <cfset item = #durum#>
                <cfset 'item_#currentrow#'="#value#">
                <cfset 'value_#currentrow#'="#item#"> 
			</cfoutput>

            <canvas id="ProjeChart" style="float:left;max-height:450px;max-width:350px;"></canvas>
            <script>
                var ctx = document.getElementById('ProjeChart');
                    var myChart = new Chart(ctx, {
                        type: '<cfoutput>#attributes.graph_type#</cfoutput>',
                        data: {
                            labels: [<cfloop from="1" to="#get_pro_work.recordcount#" index="jj">
                                                <cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
                            datasets: [{
                                label: "rapor",
                                backgroundColor: [<cfloop from="1" to="#get_pro_work.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                data: [<cfloop from="1" to="#get_pro_work.recordcount#" index="jj"><cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
                            }]
                        },
                        options: {}
                });
            </script>		       
		</cfif>
		<cfif isdefined('attributes.work_cat_view') and attributes.work_cat_view eq 1>
            <cfquery name="get_cat_work" dbtype="query">
                SELECT
                    get_works.WORK_CAT_ID, 
                    COUNT(get_works.WORK_CAT_ID) AS TOPLAM,
                    get_work_cats.WORK_CAT AS DURUM
                FROM
                    get_works,
                    get_work_cats
                WHERE
                    get_work_cats.WORK_CAT_ID = get_works.WORK_CAT_ID AND
                    get_works.WORK_CAT_ID IS NOT NULL
                GROUP BY
                    get_works.WORK_CAT_ID,
                    get_work_cats.WORK_CAT
                ORDER BY
                    TOPLAM DESC
            </cfquery>
            
            <cf_report_list height="250">
                <thead>
                    <tr>
                        <th style="text-align:left; width:50px;"><cf_get_lang dictionary_id ='40177.Kategorilere Göre'></th>
                        <cfif attributes.work_status eq 1 or attributes.work_status eq 2>
                            <th style="text-align:left; width:50px;"><cf_get_lang dictionary_id='57493.Aktif'></th>
                        </cfif>
                        <cfif attributes.work_status eq 0 or attributes.work_status eq 2>
                            <th style="text-align:left; width:50px;"><cf_get_lang dictionary_id='57494.Pasif'></th>
                        </cfif>
                        <cfif attributes.work_status eq 2>
                            <th style="text-align:left; width:50px;"><cf_get_lang dictionary_id='57492.Toplam'></th>
                        </cfif>
                    </tr>
                </thead>
                <cfif get_cat_work.recordcount>    
                    <tbody>
                        <cfoutput query="get_cat_work">
                            <cfquery name="get_work_cat_active" dbtype="query">
                                SELECT COUNT(PROJECT_ID) AS TOPLAM_ACTIVE FROM get_works WHERE WORK_STATUS = 1 AND WORK_CAT_ID = #work_cat_id#
                            </cfquery>
                            <cfif len(get_work_cat_active.toplam_active)>
                                <cfset toplam_active = #get_work_cat_active.toplam_active#>
                            <cfelse>
                                <cfset toplam_active = 0>
                            </cfif>
                            <tr>
                                <td width="200">#durum#</td>
                                <cfif attributes.work_status eq 1 or attributes.work_status eq 2>
                                    <td align="right" style="text-align:left;">#toplam_active#</td>
                                </cfif>
                                <cfif attributes.work_status eq 0 or attributes.work_status eq 2>
                                    <td align="right" style="text-align:left;">
                                        <cfset toplam_passive = (toplam-toplam_active)>#toplam_passive#
                                    </td>
                                </cfif>
                                <cfif attributes.work_status eq 2>
                                    <td align="right" style="text-align:left;"><b>#toplam#</b></td>
                                </cfif>
                            </tr>
                        </cfoutput>
                    </tbody>
                    <cfelse>
                    <tbody>
                        <tr>
                            <cfif attributes.report_type eq 1>
                                <td colspan="11"><!-- sil --><cfif isdefined('attributes.form_varmi') and len(attributes.form_varmi)><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!<!-- sil --></td>
                            <cfelse><td colspan="33"><!-- sil --><cfif isdefined('attributes.form_varmi') and len(attributes.form_varmi)><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!<!-- sil --></td>
                            </cfif>
                        </tr>
                    </tbody>
                </cfif>
            </cf_report_list>
                		  
            <cfoutput query="get_cat_work">
                <cfset value = #toplam#>
                <cfset item = #durum#>
                <cfset 'item_#currentrow#'="#value#">
                <cfset 'value_#currentrow#'="#item#"> 
            </cfoutput>
            <div>
                <canvas id="CatChart" style="float:left;max-height:350px;max-width:350px;"></canvas>
                <script>
                    var ctx = document.getElementById('CatChart');
                        var myChart = new Chart(ctx, {
                            type: '<cfoutput>#attributes.graph_type#</cfoutput>',
                            data: {
                                labels: [<cfloop from="1" to="#get_cat_work.recordcount#" index="jj">
                                                <cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
                                datasets: [{
                                    label: "rapor",
                                    backgroundColor: [<cfloop from="1" to="#get_cat_work.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                    data: [<cfloop from="1" to="#get_cat_work.recordcount#" index="jj"><cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
                                }]
                            },
                            options: {}
                    });
                </script>
            </div>

		</cfif>
		<cfif isdefined('attributes.work_stage_view') and attributes.work_stage_view eq 1>
            <cfquery name="get_stage_work" dbtype="query">
                SELECT
                    get_works.WORK_CURRENCY_ID, 
                    COUNT(get_works.WORK_CURRENCY_ID) AS TOPLAM,
                    get_work_stages.STAGE AS DURUM
                FROM
                    get_works,
                    get_work_stages
                WHERE
                    get_work_stages.PROCESS_ROW_ID = get_works.WORK_CURRENCY_ID AND
                    get_works.WORK_CURRENCY_ID IS NOT NULL
                GROUP BY
                    get_works.WORK_CURRENCY_ID,
                    get_work_stages.STAGE
                ORDER BY
                    TOPLAM DESC
            </cfquery>

                        <cf_report_list height="250">
                                <thead>
                                    <tr>
                                        <th style="text-align:left; width:50px;"><cf_get_lang dictionary_id ='40176.Aşamalara Göre'></th>
                                        <cfif attributes.work_status eq 1 or attributes.work_status eq 2>
                                            <th  style="text-align:left; width:50px;"><cf_get_lang dictionary_id='57493.Aktif'></th>
                                        </cfif>
                                        <cfif attributes.work_status eq 0 or attributes.work_status eq 2>
                                            <th  style="text-align:left; width:50px;"><cf_get_lang dictionary_id='57494.Pasif'></th>
                                        </cfif>
                                        <cfif attributes.work_status eq 2>
                                            <th  style="text-align:left; width:50px;"><cf_get_lang dictionary_id='57492.Toplam'></th>
                                        </cfif>
                                    </tr>
                                    
                                </thead>
                            <cfif get_stage_work.recordcount>
                                <tbody>
                                    <cfoutput query="get_stage_work">
                                        <cfquery name="get_work_stage_active" dbtype="query">
                                            SELECT COUNT(PROJECT_ID) AS TOPLAM_ACTIVE FROM get_works WHERE WORK_STATUS = 1 AND WORK_CURRENCY_ID = #work_currency_id#
                                        </cfquery>
                                        <cfif len(get_work_stage_active.toplam_active)>
                                            <cfset toplam_active = #get_work_stage_active.toplam_active#>
                                        <cfelse>
                                            <cfset toplam_active = 0>
                                        </cfif>
                                        <tr>
                                            <td width="200">#durum# </td>
                                            <cfif attributes.work_status eq 1 or attributes.work_status eq 2>
                                                <td align="right" style="text-align:left;">#toplam_active#</td>
                                            </cfif>
                                            <cfif attributes.work_status eq 0 or attributes.work_status eq 2>
                                                <td align="right" style="text-align:left;">
                                                    <cfset toplam_passive = (toplam-toplam_active)>#toplam_passive#
                                                </td>
                                            </cfif>
                                            <cfif attributes.work_status eq 1 or attributes.work_status eq 2>
                                                <td align="right" style="text-align:left;"><b>#toplam#</b></td>
                                            </cfif>
                                        </tr>
                                    </cfoutput>
                                </tbody>
                                <cfelse>
                                    <tbody>
                                        <tr>
                                            <cfif attributes.report_type eq 1>
                                                    <td colspan="11"><!-- sil --><cfif isdefined('attributes.form_varmi') and len(attributes.form_varmi)><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!<!-- sil --></td>
                                            <cfelse><td colspan="33"><!-- sil --><cfif isdefined('attributes.form_varmi') and len(attributes.form_varmi)><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!<!-- sil --></td>
                                            </cfif>
                                        </tr>
                                    </tbody>
                            </cfif>
                        </cf_report_list>

            <cfoutput query="get_stage_work">
                        <cfset value = #toplam#>
                        <cfset item = #durum#>
                        <cfset 'item_#currentrow#'="#value#">
                        <cfset 'value_#currentrow#'="#item#"> 
            </cfoutput>
                        
                            <canvas id="AsamaChart" style="float:left;max-height:350px;max-width:350px;"></canvas>
                            <script>
                                var ctx = document.getElementById('AsamaChart');
                                    var myChart = new Chart(ctx, {
                                        type: '<cfoutput>#attributes.graph_type#</cfoutput>',
                                        data: {
                                            labels: [<cfloop from="1" to="#get_stage_work.recordcount#" index="jj">
                                                            <cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
                                            datasets: [{
                                                label: "rapor",
                                                backgroundColor: [<cfloop from="1" to="#get_stage_work.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                                data: [<cfloop from="1" to="#get_stage_work.recordcount#" index="jj"><cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
                                            }]
                                        },
                                        options: {}
                                });
                            </script>		        
		</cfif>
		<cfif isdefined('attributes.work_priority_view') and attributes.work_priority_view eq 1>
				<cfquery name="get_priority_work" dbtype="query">
					SELECT
						get_works.WORK_PRIORITY_ID, 
						COUNT(get_works.WORK_PRIORITY_ID) AS TOPLAM,
						get_work_proirity.PRIORITY AS DURUM
					FROM
						get_works,
						get_work_proirity
					WHERE
						get_work_proirity.PRIORITY_ID = get_works.WORK_PRIORITY_ID AND
						get_works.WORK_PRIORITY_ID IS NOT NULL
					GROUP BY
						get_works.WORK_PRIORITY_ID,
						get_work_proirity.PRIORITY
					ORDER BY
						TOPLAM DESC
				</cfquery>

                    <cf_report_list height="250">
                            <thead>
                                <tr>
                                    <th style="text-align:left; width:50px;"><cf_get_lang dictionary_id ='40175.Önceliklere Göre'></th>
                                    <cfif attributes.work_status eq 1 or attributes.work_status eq 2>
                                        <th style="text-align:left; width:50px;"><cf_get_lang dictionary_id='57493.Aktif'></th>
                                    </cfif>
                                    <cfif attributes.work_status eq 0 or attributes.work_status eq 2>
                                        <th style="text-align:left; width:50px;"><cf_get_lang dictionary_id='57494.Pasif'></th>
                                    </cfif>
                                    <cfif attributes.work_status eq 2>
                                        <th style="text-align:left; width:50px;"><cf_get_lang dictionary_id='57492.Toplam'></th>
                                    </cfif>
                                </tr>
                            </thead>
                        <cfif get_priority_work.recordcount>
                            <tbody>
                            <cfoutput query="get_priority_work">
                                <cfquery name="get_work_priority_active" dbtype="query">
                                    SELECT COUNT(PROJECT_ID) AS TOPLAM_ACTIVE FROM get_works WHERE WORK_STATUS = 1 AND WORK_PRIORITY_ID = #work_priority_id#
                                </cfquery>
                                <cfif len(get_work_priority_active.toplam_active)>
                                    <cfset toplam_active = #get_work_priority_active.toplam_active#>
                                <cfelse>
                                        <cfset toplam_active = 0>
                                </cfif>
                                <tr>
                                    <td width="200">#durum#</td>
                                    <cfif attributes.work_status eq 1 or attributes.work_status eq 2>
                                        <td align="right" style="text-align:left;">#toplam_active#</td>
                                    </cfif>
                                    <cfif attributes.work_status eq 0 or attributes.work_status eq 2>
                                        <td align="right" style="text-align:left;">
                                            <cfset toplam_passive = (toplam-toplam_active)>#toplam_passive#
                                        </td>
                                    </cfif>
                                    <cfif attributes.work_status eq 2>
                                        <td align="right" style="text-align:left;"><b>#toplam#</b></td>
                                    </cfif>
                                </tr>
                            </cfoutput>
                            </tbody>
                        <cfelse>
                            <tbody>
                                <tr>
                                    <cfif attributes.report_type eq 1>
                                        <td colspan="11"><!-- sil --><cfif isdefined('attributes.form_varmi') and len(attributes.form_varmi)><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!<!-- sil --></td>
                                    <cfelse><td colspan="33"><!-- sil --><cfif isdefined('attributes.form_varmi') and len(attributes.form_varmi)><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!<!-- sil --></td>
                                    </cfif>
                                </tr>
                            </tbody>
                        </cfif>
                    </cf_report_list>

                   <cfoutput query="get_priority_work">
                        <cfset value = #toplam#>
                        <cfset item = #durum#>
                        <cfset 'item_#currentrow#'="#value#">
                        <cfset 'value_#currentrow#'="#item#"> 
                    </cfoutput>    
                    <div>
                        <canvas id="OncelikChart" style="float:left;max-height:350px;max-width:350px;"></canvas>
                        <script>
                            var ctx = document.getElementById('OncelikChart');
                                var myChart = new Chart(ctx, {
                                    type: '<cfoutput>#attributes.graph_type#</cfoutput>',
                                    data: {
                                        labels: [<cfloop from="1" to="#get_priority_work.recordcount#" index="jj">
                                                        <cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
                                        datasets: [{
                                            label: "rapor",
                                            backgroundColor: [<cfloop from="1" to="#get_priority_work.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                            data: [<cfloop from="1" to="#get_priority_work.recordcount#" index="jj"><cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
                                        }]
                                    },
                                    options: {}
                            });
                        </script>
                    </div>
		</cfif>
	<cfelse>
    
    	<cf_report_list height="250">
                <thead>
                    <tr>
                        <th width="25"><cf_get_lang dictionary_id='57487.No'></th>
                        <th><cf_get_lang dictionary_id='57576.Çalışan'></th>
                        <th width="2">&nbsp;</th>
                        <cfif attributes.work_status eq 2>
                            <cfset status_cols = 3>
                        <cfelse>
                            <cfset status_cols = 1>
                        </cfif>
                        <th colspan="<cfoutput>#status_cols#</cfoutput>"><cf_get_lang dictionary_id='40547.İş Sayısı'></th>
                        <th width="2">&nbsp;</th>
                        <th colspan="4"><cf_get_lang dictionary_id='39321.Zaman Yönetimi'>/<cf_get_lang dictionary_id='29513.Süre'></th>
                        <cfif isdefined('attributes.work_cat_view') and attributes.work_cat_view eq 1>
                            <th width="2">&nbsp;</th>
                            <th colspan="<cfoutput>#get_work_cats.recordcount#</cfoutput>"><cf_get_lang dictionary_id='58137.Kategoriler'></th>
                        </cfif>
                        <cfif isdefined('attributes.work_stage_view') and attributes.work_stage_view eq 1>
                            <th width="2">&nbsp;</th>
                            <th colspan="<cfoutput>#get_work_stages.recordcount#</cfoutput>"><cf_get_lang dictionary_id='40548.Aşamalar'></th>
                        </cfif>
                        <cfif isdefined('attributes.work_priority_view') and attributes.work_priority_view eq 1>
                            <th width="2">&nbsp;</th>
                            <th colspan="<cfoutput>#get_work_proirity.recordcount#</cfoutput>"><cf_get_lang dictionary_id='40549.Öncelikler'></th>
                        </cfif>
                    </tr>
                    <tr class="color-header" height="30">
                        <th></th>
                        <th width="200">&nbsp;</th>
                        <th width="2">&nbsp;</th>
                        <cfif attributes.work_status eq 1 or attributes.work_status eq 2>
                            <th finish_date align="center"><cf_get_lang dictionary_id='57493.Aktif'></th>
                        </cfif>
                        <cfif attributes.work_status eq 0 or attributes.work_status eq 2>
                            <th  align="center"><cf_get_lang dictionary_id='57494.Pasif'></th>
                        </cfif>
                        <cfif attributes.work_status eq 2>
                            <th  align="center"><cf_get_lang dictionary_id='57492.Toplam'></th>
                        </cfif>
                        <th width="2">&nbsp;</th>
                        <th align="center"><cf_get_lang dictionary_id='58869.Planlanan'></th>
                        <th align="center"><cf_get_lang dictionary_id='39725.Gerçekleşen'></th>
                        <th align="center"><cf_get_lang dictionary_id='40550.Tamamlanan'> %</th>
                        <th align="center"><cf_get_lang dictionary_id='40551.Termin'></th>
                        <cfif isdefined('attributes.work_cat_view') and attributes.work_cat_view eq 1>
                            <th width="2">&nbsp;</th>
                            <cfoutput query="get_work_cats">
                                <th  align="center">#work_cat#</th>
                            </cfoutput>
                        </cfif>
                        <cfif isdefined('attributes.work_stage_view') and attributes.work_stage_view eq 1>
                            <th width="2">&nbsp;</th>
                            <cfoutput query="get_work_stages">
                                <th  align="center">#stage#</th>
                            </cfoutput>
                        </cfif>
                        <cfif isdefined('attributes.work_priority_view') and attributes.work_priority_view eq 1>
                            <th width="2">&nbsp;</th>
                            <cfoutput query="get_work_proirity">
                                <th  align="center">#priority#</th>
                            </cfoutput>
                        </cfif>
                    </tr>
                </thead>
                <cfif get_members.recordcount>
                <tbody>
                 <cfoutput query="get_members" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td width="25">#currentrow#</td>
                        <td width="200" >
                            <cfif attributes.is_excel eq 1>
                                <cfif type eq 1>
                                   #member_name#
                                <cfelse>
                                   #member_name# (Partner)
                                </cfif>  
                            <cfelse>
                                <cfif type eq 1>
                                    <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#project_emp_id#','medium');">#member_name#</a>
                                <cfelse>
                                    <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#outsrc_partner_id#','medium');">#member_name# (<cf_get_lang dictionary_id='58885.Partner'>)</a>
                                </cfif>  
                            </cfif>						
                        </td>
                        <td width="2" class="color-header">&nbsp;</td>
                        <cfif attributes.work_status eq 1 or attributes.work_status eq 2>
                            <cfquery name="get_active" dbtype="query">
                                SELECT 
                                    WORK_STATUS
                                FROM 
                                    get_works 
                                WHERE 
                                    WORK_STATUS = 1 AND 
                                    <cfif get_members.type eq 1>
                                        PROJECT_EMP_ID = #get_members.PROJECT_EMP_ID#
                                    <cfelse>
                                        OUTSRC_PARTNER_ID = #get_members.OUTSRC_PARTNER_ID#
                                    </cfif>
                            </cfquery>
                            <td align="center">#get_active.recordcount#</td>
                        </cfif>
                        <cfif attributes.work_status eq 0 or attributes.work_status eq 2>
                            <cfquery name="get_passive" dbtype="query">
                                SELECT 
                                    WORK_STATUS 
                                FROM 
                                    get_works 
                                WHERE 
                                    WORK_STATUS = 0 AND 
                                    <cfif get_members.type eq 1>
                                    PROJECT_EMP_ID = #get_members.PROJECT_EMP_ID#
                                    <cfelse>
                                    OUTSRC_PARTNER_ID = #get_members.OUTSRC_PARTNER_ID#
                                    </cfif>
                            </cfquery>
                            <td align="center">#get_passive.recordcount#</td>
                        </cfif>
                        <cfif attributes.work_status eq 2>
                        <cfset total_works_ = (get_active.recordcount+get_passive.recordcount)>
                        <td align="center">#total_works_#</td>
                        </cfif>
                        <td width="2" class="color-header">&nbsp;</td>
                        <cfquery name="get_planning_time" dbtype="query">
                        SELECT 
                            SUM(ESTIMATED_TIME) PLANNING_TIME,
                            SUM(TO_COMPLETE) COMPLETE,
                            COUNT(WORK_ID) RECORD_COUNT
                        FROM 
                            get_works 
                        WHERE 
                            <cfif get_members.type eq 1>
                                PROJECT_EMP_ID = #get_members.PROJECT_EMP_ID#
                            <cfelse>
                                OUTSRC_PARTNER_ID = #get_members.OUTSRC_PARTNER_ID#
                            </cfif>
                        </cfquery>
                        <!---<cfdump var="#get_planning_time#"><cfabort>--->
                        <cfquery name="get_termin" dbtype="query">
                        SELECT 	
                            SUM(TERMIN/60) AS ORT_TERMIN,
                            COUNT(WORK_ID) RECORD_COUNT
                        FROM 
                            get_works 
                        WHERE 
                            TERMIN <> 0 AND
                            <cfif get_members.type eq 1>
                                PROJECT_EMP_ID = #get_members.PROJECT_EMP_ID#
                            <cfelse>
                                OUTSRC_PARTNER_ID = #get_members.OUTSRC_PARTNER_ID#
                            </cfif>
                        </cfquery>
                        <cfquery name="get_gerceklesen_history" datasource="#dsn#">
                        SELECT
                            SUM(TOTAL_TIME_HOUR) REAL_HOUR,
                            SUM(TOTAL_TIME_MINUTE) REAL_MINUTE
                        FROM 
                            PRO_WORKS_HISTORY
                        WHERE
                            <cfif get_members.type eq 1>
                                PROJECT_EMP_ID = #get_members.PROJECT_EMP_ID#
                            <cfelse>
                                OUTSRC_PARTNER_ID = #get_members.OUTSRC_PARTNER_ID#
                            </cfif>
                        </cfquery>
                        <cfif len(get_planning_time.planning_time)>
                        	<cfset totalminute = get_planning_time.planning_time mod 60>
                        <cfelse>
                        	<cfset totalminute = 0>
                        </cfif>
                        <cfif len(get_planning_time.planning_time)>
                        	<cfset totalhour = (get_planning_time.planning_time-totalminute)/60>
                        <cfelse>
                        	<cfset totalhour = 0>
                        </cfif>
                        <cfif len(get_gerceklesen_history.real_hour)>
                        	<cfset real_hour = get_gerceklesen_history.real_hour>
                        <cfelse>
                        	<cfset real_hour = 0>
                        </cfif>
                        <cfif len(get_gerceklesen_history.real_minute)>
                        	<cfset real_minute = get_gerceklesen_history.real_minute>
                        <cfelse>
                        	<cfset real_minute = 0>
                        </cfif>
                        <cfset gerceklesen_minute = (real_hour*60)+real_minute>
                        <cfset my_real_minute = gerceklesen_minute mod 60>
                        <cfset my_real_hour = (gerceklesen_minute-my_real_minute)/60>
                        <td align="center">#totalhour#:#totalminute# </td>
                        <td align="center">#my_real_hour#:#my_real_minute#</td>
                        <td align="center">% <cfif get_planning_time.complete gt 0 >#TLFormat(get_planning_time.complete/get_planning_time.record_count)#<cfelse>0</cfif></td>
                        <td align="center">
                        <cfif len(get_termin.ort_termin)>#TLFormat((get_termin.ort_termin/get_termin.record_count),0)# <cf_get_lang dictionary_id="57491.saat"><cfelse>0 <cf_get_lang dictionary_id="57491.saat"></cfif>
                        </td>
                        <cfif isdefined('attributes.work_cat_view') and attributes.work_cat_view eq 1>
                        <td width="2" class="color-header">&nbsp;</td>
                        <cfloop query="get_work_cats">
                            <cfset cat_id_ = get_work_cats.work_cat_id>
                            <cfquery name="get_1" dbtype="query">
                                SELECT 
                                    WORK_CAT_ID
                                FROM
                                    get_works
                                WHERE
                                    WORK_CAT_ID = #cat_id_# AND
                                    <cfif get_members.type eq 1>
                                    PROJECT_EMP_ID = #get_members.PROJECT_EMP_ID#
                                    <cfelse>
                                    OUTSRC_PARTNER_ID = #get_members.OUTSRC_PARTNER_ID#
                                    </cfif>
                            </cfquery>
                            <td align="center">#get_1.RECORDCOUNT#</td>
                        </cfloop>
                        </cfif>
                        <cfif isdefined('attributes.work_stage_view') and attributes.work_stage_view eq 1>
                        <td width="2" class="color-header">&nbsp;</td>
                        <cfloop query="get_work_stages">
                            <cfset stage_id_ = get_work_stages.process_row_id>
                            <cfquery name="get_2" dbtype="query">
                                SELECT 
                                    WORK_CURRENCY_ID
                                FROM
                                    get_works
                                WHERE
                                    WORK_CURRENCY_ID = #stage_id_# AND
                                    <cfif get_members.type eq 1>
                                    PROJECT_EMP_ID = #get_members.PROJECT_EMP_ID#
                                    <cfelse>
                                    OUTSRC_PARTNER_ID = #get_members.OUTSRC_PARTNER_ID#
                                    </cfif>
                            </cfquery>
                            <td align="center">#get_2.RECORDCOUNT#</td>
                        </cfloop>
                        </cfif>
                        <cfif isdefined('attributes.work_priority_view') and attributes.work_priority_view eq 1>
                        <td width="2" class="color-header">&nbsp;</td>
                            <cfloop query="get_work_proirity">
                                <cfset priority_id = get_work_proirity.priority_id>
                                <cfquery name="get_3" dbtype="query">
                                    SELECT 
                                        WORK_PRIORITY_ID
                                    FROM
                                        get_works
                                    WHERE
                                        WORK_PRIORITY_ID = #priority_id# AND
                                        <cfif get_members.type eq 1>
                                        PROJECT_EMP_ID = #get_members.PROJECT_EMP_ID#
                                        <cfelse>
                                        OUTSRC_PARTNER_ID = #get_members.OUTSRC_PARTNER_ID#
                                        </cfif>
                                </cfquery>
                                <td align="center">#get_3.recordcount#</td>
                            </cfloop>
                        </cfif>
                    </tr>
                 </cfoutput>
                </tbody>
                <cfelse>
                    <tbody>
                        <tr>
                            <cfif attributes.report_type eq 1>
                                <td colspan="11"><!-- sil --><cfif isdefined('attributes.form_varmi') and len(attributes.form_varmi)><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!<!-- sil --></td>
                                <cfelse><td colspan="33"><!-- sil --><cfif isdefined('attributes.form_varmi') and len(attributes.form_varmi)><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!<!-- sil --></td>
                            </cfif>
                        </tr>
                    </tbody>
                </cfif>
        </cf_report_list>
       
		<cfif attributes.totalrecords gt attributes.maxrows>
            <cfset url_str = "">
            <cfif isdefined("attributes.form_varmi") and len(attributes.form_varmi)>
                <cfset url_str = "#url_str#&form_varmi=#attributes.form_varmi#">
            </cfif>
            <cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
                <cfset url_str = '#url_str#&startdate=#dateformat(attributes.startdate,dateformat_style)#'>
            </cfif>
            <cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
                <cfset url_str = '#url_str#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#'>
            </cfif>
            <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
                <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
            </cfif>
            <cfif isdefined("attributes.project_id") and len(attributes.project_id) and isdefined('attributes.project_head') and len(attributes.project_head)>
                <cfset url_str = "#url_str#&project_id=#attributes.project_id#&project_head=#attributes.project_head#">
            </cfif>
            <cfif len(attributes.pro_employee_id) and len(attributes.pro_employee)>
                <cfset url_str = "#url_str#&pro_employee_id=#attributes.pro_employee_id#&pro_employee=#attributes.pro_employee#">
            </cfif>
            <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
                <cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
            </cfif>
            <cfif isdefined("attributes.department") and len(attributes.department)>
                <cfset url_str = "#url_str#&department=#attributes.department#">
            </cfif>
            <cfif Len(attributes.work_status)>
                <cfset url_str = "#url_str#&work_status=#attributes.work_status#">
            </cfif>
            <cfif len(attributes.report_type)>
                <cfset url_str = "#url_str#&report_type=#attributes.report_type#">
            </cfif>
            <cfif len(attributes.graph_type)>
                <cfset url_str = "#url_str#&graph_type=#attributes.graph_type#">
            </cfif>
            <cfif len(attributes.work_cat_view)>
                <cfset url_str = "#url_str#&work_cat_view=#attributes.work_cat_view#">
            </cfif>
            <cfif len(attributes.work_stage_view)>
                <cfset url_str = "#url_str#&work_stage_view=#attributes.work_stage_view#">
            </cfif>
            <cfif len(attributes.work_priority_view)>
                <cfset url_str = "#url_str#&work_priority_view=#attributes.work_priority_view#">
            </cfif>

                <cf_paging page="#attributes.page#"
                    maxrows="#attributes.maxrows#"
                    totalrecords="#attributes.totalrecords#"
                    startrow="#attributes.startrow#"
                    adres="#attributes.fuseaction#&#url_str#"> 

        </cfif>
	</cfif>
</cfif>
<script type="text/javascript">
$(document).ready(function(e){
    tip_gizle();
});
    function control()	{
        if(document.getElementById('report_type').value == 1 && document.getElementById("project_head").value != "" && document.getElementById("project_id").value != "")
        {
            if(document.getElementById("work_cat_view").checked == false && document.getElementById("work_stage_view").checked == false && document.getElementById("work_priority_view").checked == false)
            {  
                alert("<cf_get_lang dictionary_id='48965.Seçim Yapmadınız'>(<cf_get_lang dictionary_id='57486.Kategori'>/<cf_get_lang dictionary_id='57482.Aşama'>/<cf_get_lang dictionary_id='57485.Öncelik'>)");
                return false;
            }
        }
        if(!date_check(project_work.startdate,project_work.finishdate,"<cf_get_lang dictionary_id ='40310.Başlama Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!")){
			return false;
		}
		if(document.project_work.is_excel.checked==false)
		{
			document.project_work.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
			return true;
		}
		else{document.project_work.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_project_works_report</cfoutput>"}
			
	}
	function showDepartment(branch_id)	
		{
			var branch_id = document.project_work.branch_id.value;
			if (branch_id != "")
			{
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popupajax_list_departments&branch_id="+branch_id;
				AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
			}
			else
			{
				var myList = document.getElementById("department");
				myList.options.length = 0;
				var txtFld = document.createElement("option");
				txtFld.value='';
				txtFld.appendChild(document.createTextNode('<cf_get_lang dictionary_id="57572.Departman">'));
				myList.appendChild(txtFld);
			}
		}
    function tip_gizle()
	{   
        if(document.getElementById('report_type').value == 1)
		{
			document.getElementById('maxrows').style.display = "none";
			document.getElementById('graph_type').style.display = "block";
		}
        else
        {
            document.getElementById('maxrows').style.display = "inline";
            document.getElementById('graph_type').style.display = "none"; 
        }
	}
</script> 
<!-- sil -->
