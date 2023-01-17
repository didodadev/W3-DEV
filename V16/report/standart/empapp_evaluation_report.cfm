<cfparam name="attributes.module_id_control" default="3,48">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.notice_id" default="">
<cfparam name="attributes.notice_head" default="">
<cfparam name="attributes.list_id" default="">
<cfparam name="attributes.is_excel" default="0">
<cfparam name="attributes.row_status" default="">
<cfparam name="attributes.list_name" default="">
<cfparam name="attributes.start_date" default="#date_add('d',-8,createodbcdatetime(createdate(year(now()),month(now()),day(now()))))#">
<cfparam name="attributes.finish_date" default="#CreateDate(year(now()),month(now()),day(now()))#">
<cfif isdefined('attributes.is_submitted')>
	<cfif isdate(attributes.start_date)><cf_date tarih = "attributes.start_date"></cfif>
	<cfif isdate(attributes.finish_date)><cf_date tarih = "attributes.finish_date"></cfif>
	<cfquery name="get_evaluation" datasource="#dsn#">
	<cfif not (isdefined("attributes.list_id") and len(attributes.list_id) and len(attributes.list_name))>
		SELECT
			EMPLOYEES_APP.NAME,
			EMPLOYEES_APP.SURNAME,
			EMPLOYEES_APP.EMPAPP_ID,
			EMPLOYEES_APP_POS.APP_POS_ID,
			EMPLOYEES_APP_POS.NOTICE_ID,
			EMPLOYEES_APP_POS.APP_DATE,
			EMPLOYEES_APP.APP_COLOR_STATUS,
			NTCS.NOTICE_HEAD,
			0 AS LIST_ID,
			'' AS LIST_NAME,
			0 AS LIST_ROW_ID,
			ELR.ROW_STATUS
		FROM
			EMPLOYEES_APP,
			EMPLOYEES_APP_POS,
			NOTICES NTCS,
			EMPLOYEES_APP_SEL_LIST EL,
			EMPLOYEES_APP_SEL_LIST_ROWS ELR
		WHERE
			EMPLOYEES_APP.EMPAPP_ID IS NOT NULL
			AND EL.LIST_ID = ELR.LIST_ID
			AND EMPLOYEES_APP.EMPAPP_ID=EMPLOYEES_APP_POS.EMPAPP_ID
			AND EMPLOYEES_APP_POS.NOTICE_ID = NTCS.NOTICE_ID
			AND NTCS.NOTICE_ID NOT IN (SELECT NOTICE_ID FROM EMPLOYEES_APP_SEL_LIST WHERE NOTICE_ID IS NOT NULL)
		<cfif isdefined("attributes.notice_id") and len(attributes.notice_id) and len(attributes.notice_head)>
			AND EMPLOYEES_APP_POS.NOTICE_ID = #attributes.notice_id#
		</cfif>
		<cfif len(attributes.start_date) and len(attributes.finish_date)> 
			AND EMPLOYEES_APP_POS.APP_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
		</cfif>
		<cfif IsDefined('attributes.row_status') and len(attributes.row_status)>
			AND ROW_STATUS = #attributes.row_status#
		</cfif>
	UNION
	</cfif>
		SELECT
			EMPLOYEES_APP.NAME,
			EMPLOYEES_APP.SURNAME,
			EMPLOYEES_APP.EMPAPP_ID,
			EMPLOYEES_APP_POS.APP_POS_ID,
			EMPLOYEES_APP_POS.NOTICE_ID,
			EMPLOYEES_APP_POS.APP_DATE,
			EMPLOYEES_APP.APP_COLOR_STATUS,
			NTCS.NOTICE_HEAD,
			EL.LIST_ID AS LIST_ID,
			EL.LIST_NAME AS LIST_NAME,
			ELR.LIST_ROW_ID AS LIST_ROW_ID,
			ELR.ROW_STATUS
		FROM
			EMPLOYEES_APP,
			EMPLOYEES_APP_POS,
			NOTICES NTCS,
			EMPLOYEES_APP_SEL_LIST EL,
			EMPLOYEES_APP_SEL_LIST_ROWS ELR
		WHERE
			EMPLOYEES_APP.EMPAPP_ID IS NOT NULL
			AND EMPLOYEES_APP.EMPAPP_ID=EMPLOYEES_APP_POS.EMPAPP_ID
			AND EMPLOYEES_APP_POS.NOTICE_ID = NTCS.NOTICE_ID
			AND NTCS.NOTICE_ID = EL.NOTICE_ID
			AND EL.LIST_ID = ELR.LIST_ID
			AND EMPLOYEES_APP.EMPAPP_ID=ELR.EMPAPP_ID
		<cfif isdefined("attributes.notice_id") and len(attributes.notice_id) and len(attributes.notice_head)>
			AND EMPLOYEES_APP_POS.NOTICE_ID = #attributes.notice_id#
		</cfif>
		<cfif isdefined("attributes.list_id") and len(attributes.list_id) and len(attributes.list_name)>
			AND EL.LIST_ID = #attributes.list_id#
		</cfif>
		<cfif len(attributes.start_date) and len(attributes.finish_date)> 
			AND EMPLOYEES_APP_POS.APP_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
		</cfif>
		<cfif IsDefined('attributes.row_status') and len(attributes.row_status)>
			AND ROW_STATUS = #attributes.row_status#
		</cfif>
	UNION

	SELECT
		EMPLOYEES_APP.NAME,
		EMPLOYEES_APP.SURNAME,
		EMPLOYEES_APP.EMPAPP_ID AS EMPAPP_ID,
		0 AS APP_POS_ID,
		0 AS NOTICE_ID,
		EL.RECORD_DATE AS APP_DATE,
		EMPLOYEES_APP.APP_COLOR_STATUS,
		'' AS NOTICE_HEAD,
		EL.LIST_ID AS LIST_ID,
		EL.LIST_NAME AS LIST_NAME,
		ELR.LIST_ROW_ID AS LIST_ROW_ID,
		ELR.ROW_STATUS
	FROM
		EMPLOYEES_APP,
		EMPLOYEES_APP_SEL_LIST EL,
		EMPLOYEES_APP_SEL_LIST_ROWS ELR
	WHERE
		EMPLOYEES_APP.EMPAPP_ID IS NOT NULL
		AND EL.LIST_ID = ELR.LIST_ID
		AND EMPLOYEES_APP.EMPAPP_ID=ELR.EMPAPP_ID
		AND EL.LIST_ID NOT IN (SELECT LIST_ID FROM EMPLOYEES_APP_SEL_LIST WHERE NOTICE_ID IS NOT NULL)
		<cfif isdefined("attributes.list_id") and len(attributes.list_id) and len(attributes.list_name)>
			AND EL.LIST_ID = #attributes.list_id#
		</cfif>
		<cfif len(attributes.start_date) and len(attributes.finish_date)>
			AND EL.RECORD_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
		</cfif>
		<cfif IsDefined('attributes.row_status') and len(attributes.row_status)>
			AND ROW_STATUS = #attributes.row_status#
		</cfif>
	ORDER BY NAME,SURNAME ASC
	</cfquery>
<cfelse>
	<cfset get_evaluation.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_evaluation.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="head"><cf_get_lang dictionary_id='39921.Aday Değerlendirme Raporu' ></cfsavecontent>
<cfform name="evaluation_report" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#" >
    <cf_report_list_search title="#head#">
        <cf_report_list_search_area>
            <div class="row">
				<div class="col col-12 col-xs-12">
                    <div class="row formContent">
                        <div class="row" type="row">
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
							    <div class="col col-12 col-md-12 col-xs-12">
                                    <div class="col col-12 col-md-12 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id ='40088.İlan'></label>
                                            <div class="col col-12 col-md-12 col-xs-12">
                                                <div class="input-group">
                                                    <input type="hidden" name="notice_id" id="notice_id" value="<cfif IsDefined('attributes.notice_head') and len(attributes.notice_head) and len(attributes.notice_id)><cfoutput>#attributes.notice_id#</cfoutput></cfif>">
                                                    <input type="text" name="notice_head" id="notice_head" value="<cfif IsDefined('attributes.notice_head') and len(attributes.notice_head)><cfoutput>#attributes.notice_head#</cfoutput></cfif>" style="width:150px;">
                                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_notices&field_id=evaluation_report.notice_id&field_name=evaluation_report.notice_head','list');"></span> 
                                                </div>
                                            </div>	
                                        </div>
                                        <div class="form-group">
                                            <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id ='40090.Seçim Listesi'></label>
                                            <div class="col col-12 col-md-12 col-xs-12">
                                                <div class="input-group">
                                                    <input type="hidden" name="list_id" id="list_id" value="<cfif IsDefined('attributes.list_name') and len(attributes.list_name) and len(attributes.list_id)><cfoutput>#attributes.list_id#</cfoutput></cfif>">
                                                    <input type="text" name="list_name" id="list_name" value="<cfif IsDefined('attributes.list_name') and len(attributes.list_name)><cfoutput>#attributes.list_name#</cfoutput></cfif>" style="width:150px;">
                                                    <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id ='40089.Seçim Listesi Seç'>" onclick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_select_list&field_id=evaluation_report.list_id&field_name=evaluation_report.list_name</cfoutput>','list');"></span>
                                                </div>
                                            </div>	
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                                <div class="col col-12 col-md-12 col-xs-12">
                                    <div class="col col-12 col-md-12 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'> *</label>
                                            <div class="col col-6 col-md-6">
                                                <div class="input-group">
                                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id ='57782.Tarih Değerinizi Kontrol Ediniz'>!</cfsavecontent>
                                                    <cfinput type="text" name="start_date" maxlength="10" value="#dateformat(attributes.start_date,dateformat_style)#" required="yes" validate="#validate_style#" message="#message#" style="width:65px;">
                                                    <span class="input-group-addon">
                                                    <cf_wrk_date_image date_field="start_date">
                                                    </span>
                                                </div>
                                            </div>
                                            <div class="col col-6 col-md-6">
                                                <div class="input-group">
                                                    <cfinput type="text" name="finish_date" maxlength="10" value="#dateformat(attributes.finish_date,dateformat_style)#" required="yes" validate="#validate_style#" message="#message#" style="width:65px;">
                                                    <span class="input-group-addon">
                                                    <cf_wrk_date_image date_field="finish_date">										
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'></label>
                                            <div class="col col-12 col-md-12 col-xs-12">
                                                <select name="row_status" id="row_status">
                                                    <option value="" <cfif not len(attributes.row_status)>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'>
                                                    <option value="1" <cfif attributes.row_status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'>
                                                    <option value="0" <cfif attributes.row_status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'>
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
                                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" message="#message#" maxlength="3" style="width:25px;">
                            <cfelse>
                                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
                            </cfif>
                            <input name="is_submitted" id="is_submitted" type="hidden" value="1">
                            <cf_wrk_report_search_button button_type="1" search_function="control()" insert_info="#message#" is_excel="1">
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
<cfif isdefined("attributes.is_submitted")>
    <cf_report_list>    
        <thead>	
            <tr> 
                <th width="150"><cf_get_lang dictionary_id ='40091.Aday'></th>
                <th width="150"><cf_get_lang dictionary_id ='40092.Başvurduğu İlan'></th>
                <th><cf_get_lang dictionary_id ='40093.Başv Tarihi'></th>
                <th><cf_get_lang dictionary_id ='40094.Cv Renk Durumu'></th>
                <th><cf_get_lang dictionary_id ='40095.Bulunduğu Seçim Listesi'></th>
                <th><cf_get_lang dictionary_id ='30111.Durumu'></th>
                <th><cf_get_lang dictionary_id ='40096.Değerlendirme Tar.'></th>
                <th><cf_get_lang dictionary_id ='40097.Değerlendiren'></th>
                <th><cf_get_lang dictionary_id ='40098.MDF Adı'></th>
                <th><cf_get_lang dictionary_id ='40100.MDF Puanı'></th>
                <th><cf_get_lang dictionary_id ='57428.Mail'></th>
                
            </tr>
        </thead>
        <tbody>
            <cfif get_evaluation.recordcount>
                <cfset app_color_status_list="">
                <cfset notice_id_list="">
                <cfset app_pos_id_list="">
                <cfset emp_app_id_list="">
                <cfoutput query="get_evaluation" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                    <cfif len(NOTICE_ID) and NOTICE_ID gt 0 and not listfind(notice_id_list,NOTICE_ID)>
                        <cfset notice_id_list=listappend(notice_id_list,NOTICE_ID)>
                    </cfif>
                    <cfif len(APP_COLOR_STATUS) and APP_COLOR_STATUS gt 0 and not listfind(app_color_status_list,APP_COLOR_STATUS)>
                        <cfset app_color_status_list=listappend(app_color_status_list,APP_COLOR_STATUS)>
                    </cfif>
                    <cfif APP_POS_ID gt 0 and not listfind(app_pos_id_list,APP_POS_ID)>
                        <cfset app_pos_id_list=listappend(app_pos_id_list,APP_POS_ID)>
                    </cfif>
                    <cfif EMPAPP_ID gt 0 and not listfind(emp_app_id_list,EMPAPP_ID)>
                        <cfset emp_app_id_list=listappend(emp_app_id_list,EMPAPP_ID)>
                    </cfif>
                </cfoutput>
                <cfset notice_id_list=listsort(notice_id_list,"numeric")>
                <cfset app_color_status_list=listsort(app_color_status_list,"numeric")>
                <cfset app_pos_id_list=listsort(app_pos_id_list,"numeric")>
                <cfset emp_app_id_list=listsort(emp_app_id_list,"numeric")>
                <cfif len(app_color_status_list)>
                    <cfquery name="get_cv_status" datasource="#DSN#">
                        SELECT STATUS_ID,STATUS,ICON_NAME FROM SETUP_CV_STATUS WHERE STATUS_ID IN (#app_color_status_list#) ORDER BY STATUS_ID
                    </cfquery>
                </cfif>
                <cfif len(emp_app_id_list)>
                    <cfquery name="GET_QUIZ" datasource="#dsn#">
                        SELECT
                            EMPLOYEES_APP_QUIZ.APP_POS_ID,
                            EMPLOYEES_APP_QUIZ.EMP_APP_QUIZ_ID,
                            EMPLOYEES_APP_QUIZ.QUIZ_ID,
                            EMPLOYEE_QUIZ.QUIZ_HEAD,
                            EMPLOYEES_APP_QUIZ.EMPAPP_ID,
                            EMPLOYEES_APP_QUIZ.SELECT_LIST_ID
                        FROM 
                            EMPLOYEE_QUIZ,
                            EMPLOYEES_APP_QUIZ
                        WHERE 
                            EMPLOYEE_QUIZ.QUIZ_ID = EMPLOYEES_APP_QUIZ.QUIZ_ID
                            AND EMPLOYEES_APP_QUIZ.EMPAPP_ID IN (#emp_app_id_list#)
                        ORDER BY EMPLOYEES_APP_QUIZ.EMPAPP_ID
                    </cfquery>
                    <cfquery name="GET_EMPAPP_MAIL" datasource="#DSN#">
                        SELECT 
                            * 
                        FROM 
                            EMPLOYEES_APP_MAILS
                        WHERE
                            EMPAPP_ID IN (#emp_app_id_list#)
                        ORDER BY EMPAPP_ID	
                    </cfquery>
                </cfif>
                <cfoutput query="get_evaluation" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                    <cfif isdefined("GET_QUIZ") and GET_QUIZ.recordcount>
                        <cfset GET_QUIZ_APP.recordcount = 0>
                        <cfset GET_QUIZ_LIST.recordcount = 0>
                        <cfset GET_QUIZ_CV.recordcount = 0>
                        <cfif APP_POS_ID neq 0>
                            <cfquery name="GET_QUIZ_APP" dbtype="query">
                                SELECT * FROM GET_QUIZ WHERE EMPAPP_ID = #EMPAPP_ID# AND APP_POS_ID = #APP_POS_ID#
                            </cfquery>
                        <cfelseif LIST_ID neq 0>
                            <cfquery name="GET_QUIZ_LIST" dbtype="query">
                                SELECT * FROM GET_QUIZ WHERE EMPAPP_ID = #EMPAPP_ID# AND SELECT_LIST_ID = #LIST_ID#
                            </cfquery>
                        <cfelse>
                            <cfquery name="GET_QUIZ_CV" dbtype="query">
                                SELECT * FROM GET_QUIZ WHERE EMPAPP_ID = #EMPAPP_ID# AND APP_POS_ID IS NULL AND SELECT_LIST_ID IS NULL
                            </cfquery>
                        </cfif>
                    <cfelse>
                        <cfset GET_QUIZ_APP.recordcount = 0>
                        <cfset GET_QUIZ_LIST.recordcount = 0>
                        <cfset GET_QUIZ_CV.recordcount = 0>
                    </cfif>		
                    <tr>
                        <td>#NAME# #SURNAME#</td>
                        <td><cfif len(NOTICE_HEAD)>#NOTICE_HEAD#</cfif></td>
                        <td>#dateformat(APP_DATE,dateformat_style)#</td>
                        <td align="center">
                            <cfif len(app_color_status)>
                                <cfif attributes.is_excel eq 0>    
                                    <img title="#get_cv_status.status[listfind(app_color_status_list,app_color_status,',')]#" src="#file_web_path#hr/cv_image/#get_cv_status.icon_name[listfind(app_color_status_list,app_color_status,',')]#">
                                <cfelse>#get_cv_status.status[listfind(app_color_status_list,app_color_status,',')]#
                                </cfif>
                            </cfif>
                        </td>
                        <td>
                            <cfif len(LIST_NAME)>#LIST_NAME#</cfif>
                        </td>
                        <td>
                        <cfif len(LIST_ID) and LIST_ID gt 0>
                            <cfquery name="GET_SEL_LIST" datasource="#dsn#">
                                SELECT
                                    ER.STAGE
                                FROM
                                    EMPLOYEES_APP_SEL_LIST_ROWS ER
                                WHERE
                                    ER.LIST_ID = #LIST_ID#
                                    AND ER.EMPAPP_ID = #EMPAPP_ID#
                            </cfquery>
                            <cfif len(GET_SEL_LIST.STAGE)>
                                <cfquery name="get_stage" datasource="#dsn#">
                                    SELECT 
                                        PROCESS_TYPE_ROWS.STAGE
                                    FROM
                                        PROCESS_TYPE_ROWS
                                    WHERE
                                        PROCESS_ROW_ID=#GET_SEL_LIST.STAGE#
                                </cfquery>
                            #get_stage.STAGE#
                            </cfif>
                        </cfif>
                        </td>
                        <td>
                            <cfif APP_POS_ID neq 0 and GET_QUIZ_APP.recordcount>
                                <cfloop query="GET_QUIZ_APP">
                                    <cfquery name="get_employees_app_perf" datasource="#dsn#">
                                        SELECT INTERVIEW_DATE FROM EMPLOYEE_PERFORMANCE_APP WHERE EMP_APP_QUIZ_ID = #GET_QUIZ_APP.EMP_APP_QUIZ_ID#
                                    </cfquery>
                                    <cfif get_employees_app_perf.recordcount>#dateformat(get_employees_app_perf.interview_date,dateformat_style)#</cfif><br/>
                                </cfloop>
                            <cfelseif LIST_ID neq 0 and GET_QUIZ_LIST.recordcount>
                                <cfloop query="GET_QUIZ_LIST">
                                    <cfquery name="get_employees_app_perf" datasource="#dsn#">
                                        SELECT INTERVIEW_DATE FROM EMPLOYEE_PERFORMANCE_APP WHERE EMP_APP_QUIZ_ID = #GET_QUIZ_LIST.EMP_APP_QUIZ_ID#
                                    </cfquery>
                                    <cfif get_employees_app_perf.recordcount>#dateformat(get_employees_app_perf.interview_date,dateformat_style)#</cfif><br/>
                                </cfloop>
                            <cfelseif APP_POS_ID eq 0 and LIST_ID eq 0 and GET_QUIZ_CV.recordcount>
                                <cfloop query="GET_QUIZ_CV">
                                    <cfquery name="get_employees_app_perf" datasource="#dsn#">
                                        SELECT INTERVIEW_DATE FROM EMPLOYEE_PERFORMANCE_APP WHERE EMP_APP_QUIZ_ID = #GET_QUIZ_CV.EMP_APP_QUIZ_ID#
                                    </cfquery>
                                    <cfif get_employees_app_perf.recordcount>#dateformat(get_employees_app_perf.interview_date,dateformat_style)#</cfif><br/>
                                </cfloop>
                            </cfif>
                        </td>
                        <td>
                            <cfif APP_POS_ID neq 0 and GET_QUIZ_APP.recordcount>
                                <cfloop query="GET_QUIZ_APP">
                                    <cfquery name="get_employees_app_perf" datasource="#dsn#">
                                        SELECT ENTRY_EMP_ID FROM EMPLOYEE_PERFORMANCE_APP WHERE EMP_APP_QUIZ_ID = #GET_QUIZ_APP.EMP_APP_QUIZ_ID#
                                    </cfquery>
                                    <cfif get_employees_app_perf.recordcount>#get_emp_info(get_employees_app_perf.entry_emp_id,0,0)#</cfif><br/>
                                </cfloop>
                            <cfelseif LIST_ID neq 0 and GET_QUIZ_LIST.recordcount>
                                <cfloop query="GET_QUIZ_LIST">
                                    <cfquery name="get_employees_app_perf" datasource="#dsn#">
                                        SELECT ENTRY_EMP_ID FROM EMPLOYEE_PERFORMANCE_APP WHERE EMP_APP_QUIZ_ID = #GET_QUIZ_LIST.EMP_APP_QUIZ_ID#
                                    </cfquery>
                                    <cfif get_employees_app_perf.recordcount>#get_emp_info(get_employees_app_perf.entry_emp_id,0,0)#</cfif><br/>
                                </cfloop>
                            <cfelseif APP_POS_ID eq 0 and LIST_ID eq 0 and GET_QUIZ_CV.recordcount>
                                <cfloop query="GET_QUIZ_CV">
                                    <cfquery name="get_employees_app_perf" datasource="#dsn#">
                                        SELECT ENTRY_EMP_ID FROM EMPLOYEE_PERFORMANCE_APP WHERE EMP_APP_QUIZ_ID = #GET_QUIZ_CV.EMP_APP_QUIZ_ID#
                                    </cfquery>
                                    <cfif get_employees_app_perf.recordcount>#get_emp_info(get_employees_app_perf.entry_emp_id,0,0)#</cfif><br/>
                                </cfloop>
                            </cfif>
                        </td>
                        <td width="125">
                            <cfif APP_POS_ID neq 0 and GET_QUIZ_APP.recordcount>
                                <cfloop query="GET_QUIZ_APP">
                                    #GET_QUIZ_APP.QUIZ_HEAD#<br/>
                                </cfloop>
                            <cfelseif LIST_ID neq 0 and GET_QUIZ_LIST.recordcount>
                                <cfloop query="GET_QUIZ_LIST">
                                    #GET_QUIZ_LIST.QUIZ_HEAD#<br/>
                                </cfloop>
                            <cfelseif APP_POS_ID eq 0 and LIST_ID eq 0 and GET_QUIZ_CV.recordcount>
                                <cfloop query="GET_QUIZ_CV">
                                    #GET_QUIZ_CV.QUIZ_HEAD#<br/>
                                </cfloop>
                            </cfif>
                        </td>
                        <td>
                            <cfif APP_POS_ID neq 0 and GET_QUIZ_APP.recordcount>
                                <cfloop query="GET_QUIZ_APP">
                                    <cfquery name="get_employees_app_perf" datasource="#dsn#">
                                        SELECT USER_POINT,PERFORM_POINT FROM EMPLOYEE_PERFORMANCE_APP WHERE EMP_APP_QUIZ_ID = #GET_QUIZ_APP.EMP_APP_QUIZ_ID#
                                    </cfquery>
                                    <cfif get_employees_app_perf.recordcount>
                                        <cfif not get_employees_app_perf.perform_point gt 0>
                                            <cfset last_point=0>
                                        <cfelse>
                                            <cfset last_point = ((get_employees_app_perf.USER_POINT / get_employees_app_perf.PERFORM_POINT) * 100)>
                                        </cfif>
                                                #Round(last_point)#&nbsp;/&nbsp;100
                                    </cfif><br/>
                                </cfloop>
                            <cfelseif LIST_ID neq 0 and GET_QUIZ_LIST.recordcount>
                                <cfloop query="GET_QUIZ_LIST">
                                    <cfquery name="get_employees_app_perf" datasource="#dsn#">
                                        SELECT USER_POINT,PERFORM_POINT FROM EMPLOYEE_PERFORMANCE_APP WHERE EMP_APP_QUIZ_ID = #GET_QUIZ_LIST.EMP_APP_QUIZ_ID#
                                    </cfquery>
                                    <cfif get_employees_app_perf.recordcount>
                                        <cfif not get_employees_app_perf.perform_point gt 0>
                                            <cfset last_point=0>
                                        <cfelse>
                                            <cfset last_point = ((get_employees_app_perf.USER_POINT / get_employees_app_perf.PERFORM_POINT) * 100)>
                                        </cfif>
                                            #Round(last_point)#&nbsp;/&nbsp;100
                                    </cfif><br/>
                                </cfloop>
                            <cfelseif APP_POS_ID eq 0 and LIST_ID eq 0 and GET_QUIZ_CV.recordcount>
                                <cfloop query="GET_QUIZ_CV">
                                    <cfquery name="get_employees_app_perf" datasource="#dsn#">
                                        SELECT USER_POINT,PERFORM_POINT FROM EMPLOYEE_PERFORMANCE_APP WHERE EMP_APP_QUIZ_ID = #GET_QUIZ_CV.EMP_APP_QUIZ_ID#
                                    </cfquery>
                                    <cfif get_employees_app_perf.recordcount>
                                        <cfif not get_employees_app_perf.perform_point gt 0>
                                            <cfset last_point=0>
                                        <cfelse>
                                            <cfset last_point = ((get_employees_app_perf.USER_POINT / get_employees_app_perf.PERFORM_POINT) * 100)>
                                        </cfif>
                                            #Round(last_point)#&nbsp;/&nbsp;100
                                    </cfif><br/>
                                </cfloop>
                            </cfif>
                        </td>
                        <td>
                            <cfif LIST_ROW_ID gt 0 and APP_POS_ID eq 0>
                                <cfquery name="get_empapp_mail_" dbtype="query">
                                    SELECT * FROM GET_EMPAPP_MAIL WHERE EMPAPP_ID = #EMPAPP_ID# AND LIST_ID=#LIST_ID# AND LIST_ROW_ID=#LIST_ROW_ID# AND APP_POS_ID IS NULL
                                </cfquery>
                                <cfif get_empapp_mail_.recordcount><cf_get_lang dictionary_id ='40102.gönderildi'><cfelse><cf_get_lang dictionary_id ='40103.gönderilmedi'></cfif>
                            <cfelseif APP_POS_ID gt 0 and LIST_ROW_ID eq 0>
                                <cfquery name="get_empapp_mail2_" dbtype="query">
                                    SELECT * FROM GET_EMPAPP_MAIL WHERE EMPAPP_ID = #EMPAPP_ID# AND APP_POS_ID=#APP_POS_ID# AND LIST_ID IS NULL AND LIST_ROW_ID IS NULL
                                </cfquery>
                            <cfif get_empapp_mail2_.recordcount><cf_get_lang dictionary_id ='40102.gönderildi'><cfelse><cf_get_lang dictionary_id ='40103.gönderilmedi'></cfif>
                            <cfelseif APP_POS_ID gt 0 and LIST_ROW_ID gt 0>
                                <cfquery name="get_empapp_mail3_" dbtype="query">
                                    SELECT * FROM GET_EMPAPP_MAIL WHERE EMPAPP_ID = #EMPAPP_ID# AND LIST_ID=#LIST_ID# AND LIST_ROW_ID=#LIST_ROW_ID#
                                </cfquery>
                                <cfquery name="get_empapp_mail4_" dbtype="query">
                                    SELECT * FROM GET_EMPAPP_MAIL WHERE EMPAPP_ID = #EMPAPP_ID# AND APP_POS_ID=#APP_POS_ID# 
                                </cfquery>
                                <cfif get_empapp_mail3_.recordcount or get_empapp_mail4_.recordcount><cf_get_lang dictionary_id ='40102.gönderildi'><cfelse><cf_get_lang dictionary_id ='40103.gönderilmedi'></cfif>
                            </cfif>
                        </td>
                    </tr>
                </cfoutput>
            <cfelse>
            <tr>
                <td colspan="11">
                    <cfif isdefined('attributes.is_submitted') and len(attributes.is_submitted)><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!
                </td>
            </tr>
            </cfif>
        </tbody>
    </cf_report_list>
</cfif>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfset url_str = attributes.fuseaction>
	<cfif isdefined("attributes.is_submitted") and len(attributes.is_submitted)> 
		<cfset url_str = "#url_str#&is_submitted=#attributes.is_submitted#">
	</cfif>
	<cfif isDefined("attributes.notice_head") and len(attributes.notice_head) and IsDefined("attributes.notice_id") and len(attributes.notice_head)>
   		<cfset url_str = "#url_str#&notice_id=#attributes.notice_id#&notice_head=#attributes.notice_head#">
	</cfif>
	<cfif isDefined("attributes.list_name") and len(attributes.list_name) and IsDefined("attributes.list_id") and len(attributes.list_id)>
   		<cfset url_str = "#url_str#&list_id=#attributes.list_id#&list_name=#attributes.list_name#">
	</cfif>
	<cfset url_str="#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
	<cfset url_str="#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
    <cfif type_ eq 0>
        <!-- sil -->
            <cf_paging page="#attributes.page#" 
                    maxrows="#attributes.maxrows#"
                    totalrecords="#attributes.totalrecords#"
                    startrow="#attributes.startrow#"
                    adres="#url_str#">

        <!-- sil -->
    </cfif>
</cfif>
<script type="text/javascript">
    function control()
    {
        if(evaluation_report.start_date.value == "" || evaluation_report.finish_date.value == "")
		{
			alert("<cf_get_lang dictionary_id ='58492.Tarih Filtesini Kontrol Ediniz'>!");
			return false;
		}
		evaluation_report.start_date.value = fix_date_value(evaluation_report.start_date.value);
		evaluation_report.finish_date.value = fix_date_value(evaluation_report.finish_date.value);
		if(!date_check(evaluation_report.start_date,evaluation_report.finish_date,"<cf_get_lang dictionary_id ='40310.Başlama Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!")){
			return false;
		}
        if(document.evaluation_report.is_excel.checked==false)
        {
            document.evaluation_report.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
            return true;
        }
        else
            document.evaluation_report.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_empapp_evaluation_report</cfoutput>"
    }
</script>
