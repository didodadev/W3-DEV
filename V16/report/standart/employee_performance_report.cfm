<!---<cfsetting showdebugoutput="yes">--->
<cfparam name="attributes.comp_id" default="">
<cfparam name="attributes.func_id" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.title_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.pos_cat_id" default="">
<cfparam name="attributes.report_data" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.is_excel" default="0">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="0">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfparam name="attributes.period_year" default="#year(now())#">
<cfquery name="get_title" datasource="#dsn#">
	SELECT TITLE_ID,TITLE FROM SETUP_TITLE WHERE IS_ACTIVE = 1 ORDER BY TITLE
</cfquery>
<cfquery name="get_company" datasource="#dsn#">
	SELECT COMP_ID, NICK_NAME FROM OUR_COMPANY
    <cfif not session.ep.ehesap>
        WHERE COMP_ID IN (SELECT DISTINCT B.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH B ON B.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
    </cfif>
    ORDER BY NICK_NAME
</cfquery>
<cfquery name="get_func" datasource="#dsn#">
	SELECT UNIT_ID,UNIT_NAME FROM SETUP_CV_UNIT ORDER BY UNIT_NAME
</cfquery>
<cfquery name="get_pos_cat" datasource="#dsn#">
	SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT
</cfquery>
<cfquery name="get_branchs" datasource="#dsn#">
    SELECT
        BRANCH_ID,
        BRANCH_NAME 
    FROM
        BRANCH 
    WHERE
        <cfif isdefined('attributes.comp_id') and len(attributes.comp_id)>
            COMPANY_ID IN(#attributes.comp_id#)
            <cfif not session.ep.ehesap>
                AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
            </cfif>
        <cfelse>
            1=0
        </cfif>
    ORDER BY
        BRANCH_NAME
</cfquery>
<cfquery name="get_department" datasource="#dsn#">
	SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>BRANCH_ID IN(#attributes.branch_id#)<cfelse>1=0</cfif> AND DEPARTMENT_STATUS = 1 ORDER BY DEPARTMENT_HEAD
</cfquery>
<cfif isdefined('attributes.is_submitted')>
    <cfquery name="get_performance" datasource="#dsn#">
    SELECT
        EI.TC_IDENTY_NO,
        E.EMPLOYEE_ID,
        E.EMPLOYEE_NAME,
        E.EMPLOYEE_SURNAME,
        OC.COMPANY_NAME,
        B.BRANCH_NAME,
        D.DEPARTMENT_HEAD,
        SPC.POSITION_CAT,
        EPERF.TITLE_ID,
        ST.TITLE,
        CU.UNIT_NAME,
        EPERF.PER_ID,
        EPERF.IS_CLOSED,
        EPERF.TARGET_SCORE,
        EPERF.REQ_TYPE_SCORE,
        EPERF.EMP_REQ_TYPE_RESULT,
        EPERF.PERF_RESULT,
        EPERF.RESULT_ID,
        EPERF.START_DATE,
        EPERF.FINISH_DATE,
        EPT.REQ_TYPE_LIST,
        EPT.DEP_MANAGER_REQ_TYPE,
        EPT.COACH_REQ_TYPE,
        EPT.STD_REQ_TYPE,
        PTR.STAGE
    FROM
        EMPLOYEES E INNER JOIN EMPLOYEE_PERFORMANCE EPERF ON E.EMPLOYEE_ID = EPERF.EMP_ID
        LEFT JOIN EMPLOYEES_IDENTY EI ON E.EMPLOYEE_ID = EI.EMPLOYEE_ID
        LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = EPERF.DEPARTMENT_ID
        LEFT JOIN BRANCH B ON B.BRANCH_ID = EPERF.BRANCH_ID
        LEFT JOIN OUR_COMPANY OC ON OC.COMP_ID = EPERF.COMP_ID
        LEFT JOIN SETUP_POSITION_CAT SPC ON EPERF.POSITION_CAT_ID = SPC.POSITION_CAT_ID
        LEFT JOIN SETUP_TITLE ST ON EPERF.TITLE_ID = ST.TITLE_ID
        LEFT JOIN SETUP_CV_UNIT CU ON CU.UNIT_ID = EPERF.FUNC_ID
        LEFT JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = EPERF.STAGE,
        EMPLOYEE_PERFORMANCE_TARGET EPT
    WHERE
    	EPERF.UPDATE_DATE IS NOT NULL AND
        EPT.PER_ID = EPERF.PER_ID
        <cfif IsDefined('attributes.func_id') and len(attributes.func_id)>
        	AND EPERF.FUNC_ID IN (#attributes.func_id#)
		</cfif>
        <cfif IsDefined('attributes.comp_id') and len(attributes.comp_id)>
        	AND EPERF.COMP_ID IN (#attributes.comp_id#)
		</cfif>
        <cfif IsDefined('attributes.keyword') and len(attributes.keyword)>
        	AND E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
		</cfif>
        <cfif IsDefined('attributes.title_id') and len(attributes.title_id)>
        	AND EPERF.TITLE_ID IN (#attributes.title_id#)
		</cfif>
        <cfif IsDefined('attributes.branch_id') and len(attributes.branch_id)>
        	AND EPERF.BRANCH_ID IN (#attributes.branch_id#)
		</cfif>
        <cfif not session.ep.ehesap>
            AND EPERF.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
            AND EPERF.COMP_ID IN (SELECT DISTINCT BR.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH BR ON BR.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
        </cfif>
        <cfif IsDefined('attributes.department') and len(attributes.department)>
        	AND EPERF.DEPARTMENT_ID IN (#attributes.department#)
		</cfif>
        <cfif IsDefined('attributes.pos_cat_id') and len(attributes.pos_cat_id)>
        	AND EPERF.POSITION_CAT_ID IN (#attributes.pos_cat_id#)
		</cfif>
        <cfif IsDefined('attributes.period_year') and len(attributes.period_year)>
        	AND YEAR(EPERF.START_DATE) = #attributes.period_year#
            AND YEAR(EPERF.FINISH_DATE) = #attributes.period_year#
		</cfif>
    UNION
    	SELECT
        EI.TC_IDENTY_NO,
        E.EMPLOYEE_ID,
        E.EMPLOYEE_NAME,
        E.EMPLOYEE_SURNAME,
        OC.COMPANY_NAME,
        B.BRANCH_NAME,
        D.DEPARTMENT_HEAD,
        SPC.POSITION_CAT,
        EP.TITLE_ID,
        ST.TITLE,
        CU.UNIT_NAME,
        EPERF.PER_ID,
        EPERF.IS_CLOSED,
        EPERF.TARGET_SCORE,
        EPERF.REQ_TYPE_SCORE,
        EPERF.EMP_REQ_TYPE_RESULT,
        EPERF.PERF_RESULT,
        EPERF.RESULT_ID,
        EPERF.START_DATE,
        EPERF.FINISH_DATE,
        EPT.REQ_TYPE_LIST,
        EPT.DEP_MANAGER_REQ_TYPE,
        EPT.COACH_REQ_TYPE,
        EPT.STD_REQ_TYPE,
        PTR.STAGE
    FROM
        EMPLOYEES E INNER JOIN EMPLOYEE_PERFORMANCE EPERF ON E.EMPLOYEE_ID = EPERF.EMP_ID
        LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = EPERF.EMP_ID
        LEFT JOIN EMPLOYEES_IDENTY EI ON E.EMPLOYEE_ID = EI.EMPLOYEE_ID
        LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = EP.DEPARTMENT_ID
        LEFT JOIN BRANCH B ON B.BRANCH_ID = D.BRANCH_ID
        LEFT JOIN OUR_COMPANY OC ON OC.COMP_ID = B.COMPANY_ID
        LEFT JOIN SETUP_POSITION_CAT SPC ON EP.POSITION_CAT_ID = SPC.POSITION_CAT_ID
        LEFT JOIN SETUP_TITLE ST ON EP.TITLE_ID = ST.TITLE_ID
        LEFT JOIN SETUP_CV_UNIT CU ON CU.UNIT_ID = EP.FUNC_ID
        LEFT JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = EPERF.STAGE,
        EMPLOYEE_PERFORMANCE_TARGET EPT
    WHERE
    	EPERF.UPDATE_DATE IS NULL AND
        EP.IS_MASTER = 1 AND
        EPT.PER_ID = EPERF.PER_ID
        <cfif IsDefined('attributes.func_id') and len(attributes.func_id)>
        	AND EP.FUNC_ID IN (#attributes.func_id#)
		</cfif>
        <cfif IsDefined('attributes.comp_id') and len(attributes.comp_id)>
        	AND OC.COMP_ID IN (#attributes.comp_id#)
		</cfif>
        <cfif IsDefined('attributes.keyword') and len(attributes.keyword)>
        	AND E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
		</cfif>
        <cfif IsDefined('attributes.title_id') and len(attributes.title_id)>
        	AND EP.TITLE_ID IN (#attributes.title_id#)
		</cfif>
        <cfif IsDefined('attributes.branch_id') and len(attributes.branch_id)>
        	AND B.BRANCH_ID IN (#attributes.branch_id#)
		</cfif>
        <cfif not session.ep.ehesap>
            AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
            AND OC.COMP_ID IN (SELECT DISTINCT BR.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH BR ON BR.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
        </cfif>
        <cfif IsDefined('attributes.department') and len(attributes.department)>
        	AND EP.DEPARTMENT_ID IN (#attributes.department#)
		</cfif>
        <cfif IsDefined('attributes.pos_cat_id') and len(attributes.pos_cat_id)>
        	AND EP.POSITION_CAT_ID IN (#attributes.pos_cat_id#)
		</cfif>
        <cfif IsDefined('attributes.period_year') and len(attributes.period_year)>
        	AND YEAR(EPERF.START_DATE) = #attributes.period_year#
            AND YEAR(EPERF.FINISH_DATE) = #attributes.period_year#
		</cfif>
    ORDER BY
        E.EMPLOYEE_NAME, E.EMPLOYEE_SURNAME 
    </cfquery>
    	<cfset attributes.totalrecords = get_performance.recordcount>
    <cfif listlen(get_performance.REQ_TYPE_LIST,',')>
    	<cfset yetkinlik_list_all=get_performance.REQ_TYPE_LIST&','&get_performance.DEP_MANAGER_REQ_TYPE&','&get_performance.COACH_REQ_TYPE&','&get_performance.STD_REQ_TYPE>
    </cfif>
<cfelse>
	<cfset get_performance.recordcount = 0>
</cfif>

<cfscript>
	report_data = QueryNew("report_data_id, report_data_name");
	QueryAddRow(report_data,8);
	QuerySetCell(report_data,"report_data_id",1,1);
	QuerySetCell(report_data,"report_data_name","Bireysel Hedefler Puanı",1);
	QuerySetCell(report_data,"report_data_id",2,2);
	QuerySetCell(report_data,"report_data_name",'Yetkinlik Değerlendirme Puanı',2);
	QuerySetCell(report_data,"report_data_id",3,3);
	QuerySetCell(report_data,"report_data_name",'Yetkinlik Notu',3);
	QuerySetCell(report_data,"report_data_id",4,4);
	QuerySetCell(report_data,"report_data_name",'Genel Performans Sonucu',4);
	QuerySetCell(report_data,"report_data_id",5,5);
	QuerySetCell(report_data,"report_data_name",'Hedef Detayları',5);
	QuerySetCell(report_data,"report_data_id",6,6);
	QuerySetCell(report_data,"report_data_name",'Kilit Durumu',6);
	QuerySetCell(report_data,"report_data_id",7,7);
	QuerySetCell(report_data,"report_data_name",'Dönem',7);
	QuerySetCell(report_data,"report_data_id",8,8);
	QuerySetCell(report_data,"report_data_name",'Aşama',8);
</cfscript>
<cfsavecontent variable="head"><cf_get_lang dictionary_id='47813.Çalışan Performans Raporu'></cfsavecontent>
<cfform name="theform" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
	<cf_report_list_search title="#head#">
		<cf_report_list_search_area>
			<div class="row">
                <div class="row formContent">
                    <div class="row" type="row">
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                            <div class="col col-12 col-md-12 col-xs-12">
								<div class="col col-12 col-md-12 col-xs-12">
                                    <div class="form-group">
                                        <label class="col col-12"><cf_get_lang dictionary_id='57460.Filtre'></label>
                                        <div class="col col-12">
                                            <input type="text" id="keyword" name="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>"
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
                                        <div class="col col-12 col-md-12">
                                            <div class="multiselect-z2">
                                                <cf_multiselect_check 
                                                query_name="get_company"  
                                                name="comp_id"
                                                width="140" 
                                                option_value="COMP_ID"
                                                option_name="NICK_NAME"
                                                option_text="#getLang('main',322)#"
                                                value="#attributes.comp_id#"
                                                onchange="get_branch_list(this.value)">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                                        <div class="col col-12 col-md-12">
                                            <div id="BRANCH_PLACE" class="multiselect-z2">
                                                <cf_multiselect_check 
                                                query_name="get_branchs"  
                                                name="branch_id"
                                                width="140" 
                                                option_value="BRANCH_ID"
                                                option_name="BRANCH_NAME"
                                                option_text="#getLang('main',322)#"
                                                value="#attributes.branch_id#">
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
                                        <label class="col col-12"><cf_get_lang dictionary_id='57572.Dep'></label>
                                        <div class="col col-12">
                                            <div class="multiselect-z2" id="DEPARTMENT_PLACE">
                                                <cf_multiselect_check 
                                                query_name="get_department"  
                                                name="department"
                                                width="140" 
                                                option_text="#getLang('main',322)#" 
                                                option_value="department_id"
                                                option_name="department_head"
                                                value="#iif(isdefined("attributes.department"),"attributes.department",DE(""))#">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12"><cf_get_lang dictionary_id='48859.Veriler'></label>
                                        <div class="col col-12">
                                            <cfsavecontent variable="option_text"><cf_get_lang dictionary_id='57734.Seçiniz'></cfsavecontent>
                                            <div class="multiselect-z2">
                                                <cf_multiselect_check 
                                                query_name="report_data"  
                                                name="report_data"
                                                width="140" 
                                                option_value="report_data_id"
                                                option_name="report_data_name"
                                                option_text="#option_text#"
                                                value="#attributes.report_data#">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12"><cf_get_lang dictionary_id='59004.PTipi'></label>
                                        <div class="col col-12">
                                            <div class="multiselect-z1">
                                                <cf_multiselect_check 
                                                query_name="get_pos_cat"  
                                                name="pos_cat_id"
                                                width="170" 
                                                option_text="#getLang('main',322)#" 
                                                option_value="POSITION_CAT_ID"
                                                option_name="POSITION_CAT"
                                                value="#attributes.pos_cat_id#">
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
                                        <label class="col col-12"><cf_get_lang dictionary_id='57571.Ünvan'></label>
                                        <div class="col col-12">
                                            <div class="multiselect-z1">
                                                <cf_multiselect_check 
                                                query_name="get_title"  
                                                name="title_id"
                                                width="140" 
                                                option_text="#getLang('main',322)#" 
                                                option_value="TITLE_ID"
                                                option_name="TITLE"
                                                value="#attributes.title_id#">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12"><cf_get_lang dictionary_id='58701.Fonksiyon'></label>
                                        <div class="col col-12">
                                            <div class="multiselect-z1">
                                                <cf_multiselect_check 
                                                query_name="get_func"  
                                                name="func_id"
                                                width="140" 
                                                option_text="#getLang('main',322)#" 
                                                option_value="UNIT_ID"
                                                option_name="UNIT_NAME"
                                                value="#attributes.func_id#">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12"><cf_get_lang dictionary_id='58455.Yıl'></label>
                                        <div class="col col-12">
                                            <select name="period_year" id="period_year" style="width:50px;">
                                                <option value=""><cf_get_lang dictionary_id='58472.Dönem'></option>
                                                <cfloop from="#year(now())+2#" to="#year(now())-3#" index="yr" step="-1">
                                                    <option value="<cfoutput>#yr#</cfoutput>" <cfif isdefined('attributes.period_year') and (yr eq attributes.period_year)>selected</cfif>><cfoutput>#yr#</cfoutput></option>
                                                </cfloop>
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
                        <div class="multiselect-z2">
                            <label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
                                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" message="#message#" maxlength="3" style="width:25px;">
                            <cfelse>
                                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
                            </cfif>
                            <input name="is_submitted" id="is_submitted" type="hidden" value="1">
                            <cf_wrk_report_search_button  button_type='1' is_excel='1' search_function="control()">
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
<!-- sil -->
<cfif isdefined("attributes.is_submitted")>
    <cfif attributes.is_excel eq 1>
		<cfset attributes.startrow=1>
		<cfset attributes.maxrows = get_performance.recordcount>
	</cfif>
    <cf_report_list>
        <thead>
            <th class="form-title"><cf_get_lang dictionary_id='58025.TC Kimlik No'></th>
            <th class="form-title"><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
            <th class="form-title"><cf_get_lang dictionary_id='57574.Şirket'></th>
            <th class="form-title"><cf_get_lang dictionary_id='57453.Şube'></th>
            <th class="form-title"><cf_get_lang dictionary_id='57572.Departman'></th>
            <th class="form-title"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th>
            <th class="form-title"><cf_get_lang dictionary_id='57571.Ünvan'></th>
            <th class="form-title"><cf_get_lang dictionary_id='58701.Fonksiyon'></th>
            <cfif listFind(attributes.report_data,6)>
                <th class="form-title"><cf_get_lang dictionary_id='55616.Kilit Durumu'></th>
            </cfif>
            <cfif listFind(attributes.report_data,7)>
                <th class="form-title"><cf_get_lang dictionary_id='58472.Dönem'></th>
            </cfif>
            <cfif listFind(attributes.report_data,1)>
                <th class="form-title"><cf_get_lang dictionary_id='41632.Bireysel Hedefler Puanı'></th>
            </cfif>
            <cfif listFind(attributes.report_data,2)>
                <th class="form-title"><cf_get_lang dictionary_id='41605.Yetkinlik Değerlendirme Puanı'></th>
            </cfif>
            <cfif listFind(attributes.report_data,3)>
                <th class="form-title"><cf_get_lang dictionary_id='57907.Yetkinlik'> <cf_get_lang dictionary_id='57467.Notu'></th>
            </cfif>
            <cfif listFind(attributes.report_data,4)>
                <th class="form-title"><cf_get_lang dictionary_id='41591.Genel Performans Sonucu'></th>
            </cfif>
            <cfif listFind(attributes.report_data,8)>
                <th class="form-title"><cf_get_lang dictionary_id='57482.Aşama'></th>
            </cfif>
            <cfif listFind(attributes.report_data,5) and get_performance.recordcount>
                <cfquery name="get_target_count" datasource="#dsn#">
                    SELECT 
                        MAX(T1.HEDEFSY) as HEDEFSY
                    FROM
                        (SELECT COUNT(TARGET_ID) AS HEDEFSY, EMP_ID FROM TARGET WHERE EMP_ID IN (#ValueList(get_performance.EMPLOYEE_ID,",")#) 
                            <cfif IsDefined('attributes.period_year') and len(attributes.period_year)>
                                AND YEAR(FINISHDATE) = #attributes.period_year# AND YEAR(STARTDATE) = #attributes.period_year#
                            </cfif> GROUP BY EMP_ID) T1
                </cfquery>
                <cfif get_target_count.HEDEFSY gt 0>
                    <cfloop from="1" to="#get_target_count.HEDEFSY#" index="i">
                        <cfoutput>
                        <th class="form-title">Hedef-#i# Detayı</th>
                        <th class="form-title">Hedef-#i# Ağırlığı</th>
                        <th class="form-title">Hedef-#i# Puanı</th>
                        </cfoutput>
                    </cfloop>
                </cfif>
            </cfif>
        </thead>
        <cfif get_performance.recordcount>
            <tbody>
                <cfoutput query="get_performance" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td><cf_duxi name='identity_no' class="tableyazi" type="label" value="#TC_IDENTY_NO#" gdpr="2"></td>
                        <td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
                        <td>#COMPANY_NAME#</td>
                        <td>#BRANCH_NAME#</td>
                        <td>#DEPARTMENT_HEAD#</td>
                        <td>#POSITION_CAT#</td>
                        <td>#TITLE#</td>
                        <td>#UNIT_NAME#</td>
                        <cfif listFind(attributes.report_data,6)>
                            <td><cfif IS_CLOSED eq 1><cf_get_lang dictionary_id='58860.Kilitli'><cfelse><cf_get_lang dictionary_id='58717.Açık'></cfif></td>
                        </cfif>
                        <cfif listFind(attributes.report_data,7)>
                            <td>#DateFormat(START_DATE,dateformat_style)# - #DateFormat(FINISH_DATE,dateformat_style)#</td>
                        </cfif>
                        <cfif listFind(attributes.report_data,1)>
                            <td>#TLFormat(target_score,2)#</td>
                        </cfif>
                        <cfif listFind(attributes.report_data,2)>
                            <td>#TLFormat(req_type_score,2)#</td>
                        </cfif>
                        <cfif listFind(attributes.report_data,3)>
                            <cfquery name="GET_EMP_QUIZ_ANSWERS" datasource="#dsn#">
                                SELECT 
                                    QRD.QUESTION_USER_ANSWERS,
                                    QC.CHAPTER_ID
                                FROM 
                                    EMPLOYEE_QUIZ_RESULTS_DETAILS QRD,
                                    EMPLOYEE_QUIZ_QUESTION EQ,
                                    EMPLOYEE_QUIZ_CHAPTER QC
                                WHERE
                                    QRD.RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#RESULT_ID#">
                                    AND EQ.QUESTION_ID = QRD.QUESTION_ID
                                    AND EQ.CHAPTER_ID = QC.CHAPTER_ID
                                    AND QC.CHAPTER_WEIGHT = 100
                            </cfquery>
                            <cfif len(GET_EMP_QUIZ_ANSWERS.CHAPTER_ID) and len(GET_EMP_QUIZ_ANSWERS.QUESTION_USER_ANSWERS) and GET_EMP_QUIZ_ANSWERS.QUESTION_USER_ANSWERS neq 0>
                                <cfquery name="get_text" datasource="#dsn#">
                                    SELECT 
                                        *
                                    FROM 
                                        EMPLOYEE_QUIZ_CHAPTER
                                    WHERE
                                        CHAPTER_ID = #GET_EMP_QUIZ_ANSWERS.CHAPTER_ID#
                                </cfquery>
                                
                                <td>#EVALUATE('get_text.ANSWER'&GET_EMP_QUIZ_ANSWERS.QUESTION_USER_ANSWERS&'_TEXT')#</td>
                            <cfelse>
                                <td></td>
                            </cfif>
                        </cfif>
                        <cfif listFind(attributes.report_data,4)>
                            <td>#TLFormat(PERF_RESULT,2)#</td>
                        </cfif>
                        <cfif listFind(attributes.report_data,8)>
                            <td>#stage#</td>
                        </cfif>
                        <cfif listFind(attributes.report_data,5)>
                            <cfquery name="get_target" datasource="#dsn#">
                                SELECT 
                                    TARGET_HEAD,
                                    TARGET_WEIGHT,
                                    TARGET_RESULT
                                FROM 
                                    TARGET 
                                WHERE
                                    EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#EMPLOYEE_ID#"> AND
                                    YEAR(FINISHDATE) = #DateFormat(FINISH_DATE,'yyyy')# AND
                                    YEAR(STARTDATE) = #DateFormat(START_DATE,'yyyy')#
                            </cfquery>
                            <cfif get_target_count.HEDEFSY gt 0>
                                <cfloop query="get_target">
                                    <td>#TARGET_HEAD#</td>
                                    <td>#TARGET_WEIGHT#</td>
                                    <td>#TARGET_RESULT#</td>
                                </cfloop>
                                <cfif get_target.recordcount lt get_target_count.HEDEFSY>
                                    <cfset kalan = get_target_count.HEDEFSY - get_target.recordcount>
                                    <cfloop from="1" to="#kalan#" index="k">
                                        <td></td><td></td><td></td>
                                    </cfloop>
                                </cfif>
                            </cfif>
                        </cfif>
                    </tr>
                </cfoutput>
            </tbody>
        <cfelse>
            <tbody>
                <tr>
                    <td colspan="15"><cfif isdefined('attributes.is_submitted') and len(attributes.is_submitted)><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
                </tr>
            </tbody>
        </cfif>
    </cf_report_list>
    	<cfif attributes.totalrecords gt attributes.maxrows>
            <cfscript>
                url_str = "report.employee_performance_report";
                if(isdefined('attributes.is_submitted'))
                    url_str = '#url_str#&is_submitted=1';
                if(len('attributes.keyword'))
                    url_str = '#url_str#&keyword=#attributes.keyword#';
                if(len('attributes.comp_id'))
                    url_str = '#url_str#&comp_id=#attributes.comp_id#';
                if(len('attributes.branch_id'))
                    url_str = '#url_str#&branch_id=#attributes.branch_id#';
                if(len('attributes.department'))
                    url_str = '#url_str#&department=#attributes.department#';
                if(len('attributes.report_data'))
                    url_str = '#url_str#&report_data=#attributes.report_data#';
                if(len('attributes.pos_cat_id'))
                    url_str = '#url_str#&pos_cat_id=#attributes.pos_cat_id#';
                if(len('attributes.title_id'))
                    url_str = '#url_str#&title_id=#attributes.title_id#';
                if(len('attributes.func_id'))
                    url_str = '#url_str#&func_id=#attributes.func_id#';
                if(len('attributes.period_year'))
                    url_str = '#url_str#&period_year=#attributes.period_year#';
            </cfscript>
            <cf_paging page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="#url_str#">
        </cfif>
</cfif>
<!-- sil -->
<script type="text/javascript">
    function control()	
	{
            if(document.theform.is_excel.checked==false)
            {
                document.theform.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
                return true;
            }
            else
                document.theform.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_employee_performance_report</cfoutput>"
    }
	function get_branch_list(gelen)
	{
		checkedValues_b = $("#comp_id").multiselect("getChecked");
		var comp_id_list='';
		for(kk=0;kk<checkedValues_b.length; kk++)
		{
			if(comp_id_list == '')
				comp_id_list = checkedValues_b[kk].value;
			else
				comp_id_list = comp_id_list + ',' + checkedValues_b[kk].value;
		}
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=branch_id&comp_id="+comp_id_list;
		AjaxPageLoad(send_address,'BRANCH_PLACE',1,'İlişkili Şubeler');
	}
	function get_department_list(gelen)
	{
		checkedValues_b = $("#branch_id").multiselect("getChecked");
		var branch_id_list='';
		for(kk=0;kk<checkedValues_b.length; kk++)
		{
			if(branch_id_list == '')
				branch_id_list = checkedValues_b[kk].value;
			else
				branch_id_list = branch_id_list + ',' + checkedValues_b[kk].value;
		}
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=department&branch_id="+branch_id_list;
		AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
	}
</script>
