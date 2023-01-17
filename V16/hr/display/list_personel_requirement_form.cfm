<cf_xml_page_edit>
<cfset cmp_org_step = createObject("component","V16.hr.cfc.get_organization_steps")>
<cfset cmp_org_step.dsn = dsn>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.requirement_emp_id" default="">
<cfparam name="attributes.requirement_name" default="">
<cfparam name="attributes.our_company_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.position_cat_id" default="">
<cfparam name="attributes.position_cat" default="">
<cfparam name="attributes.process_status" default="">
<cfparam name="attributes.process_stage" default="">
<cfset NewDate = createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')>
<cfparam name="attributes.startdate" default="#DateFormat(DateAdd('d',-7,NewDate),dateformat_style)#">
<cfparam name="attributes.finishdate" default="#DateFormat(DateAdd('d',1,NewDate),dateformat_style)#">
<cfif isDate(attributes.startdate)><cf_date tarih="attributes.startdate"></cfif>
<cfif isDate(attributes.finishdate)><cf_date tarih="attributes.finishdate"></cfif>
<cfquery name="get_process_stage" datasource="#dsn#">
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
        PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ListFirst(attributes.fuseaction,'.')#.from_add_personel_requirement_form%">
    ORDER BY
        PTR.LINE_NUMBER
</cfquery>
<cfquery name="get_our_company" datasource="#dsn#">
    SELECT COMP_ID,COMPANY_NAME FROM OUR_COMPANY ORDER BY COMPANY_NAME
</cfquery>
<cfquery name="get_our_branch" datasource="#dsn#">
    SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE <cfif Len(attributes.our_company_id)>COMPANY_ID = #attributes.our_company_id# AND</cfif> BRANCH_STATUS =1 ORDER BY BRANCH_NAME
</cfquery>
<cfif Len(attributes.branch_id)>
    <cfquery name="get_our_department" datasource="#dsn#">
        SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> AND DEPARTMENT_STATUS =1 AND IS_STORE <> 1 ORDER BY DEPARTMENT_HEAD
    </cfquery>
</cfif>
<cfquery name="get_my_branches" datasource="#dsn#">
    SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# 
</cfquery>
<cfset my_branch_id_list = valuelist(get_my_branches.BRANCH_ID)>
<cfif isDefined("attributes.is_filtered")>
    <cfif fusebox.circuit eq 'myhome'>
        <cfquery name="get_form" datasource="#dsn#">
            SELECT
                PRF.*,
                PTR.STAGE
            FROM
                PERSONEL_REQUIREMENT_FORM PRF,
                PROCESS_TYPE_ROWS PTR
            WHERE
                PRF.PER_REQ_STAGE = PTR.PROCESS_ROW_ID AND
                PRF.PERSONEL_REQUIREMENT_ID IS NOT NULL
                AND PRF.REQUIREMENT_EMP =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                <cfif Len(attributes.process_status)>
                    AND ISNULL(PRF.IS_FINISHED,-1) = #attributes.process_status#
                </cfif>
                <cfif Len(attributes.process_stage)>
                    AND PTR.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
                </cfif>
                <cfif Len(attributes.keyword)>
                    AND 
                    (
                        <cfif isNumeric(attributes.keyword)>
                            PRF.PERSONEL_REQUIREMENT_ID = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.keyword#"> OR
                        </cfif>
                        PRF.PERSONEL_REQUIREMENT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
                        PRF.OLD_PERSONEL_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
                        PRF.OLD_PERSONEL_POSITION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
                        PRF.CHANGE_PERSONEL_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
                        PRF.CHANGE_PERSONEL_POSITION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
                        PRF.TRANSFER_PERSONEL_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
                        PRF.TRANSFER_PERSONEL_POSITION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
                    )
                </cfif>
                <cfif Len(attributes.startdate) and Len(attributes.finishdate)>
                    AND ISNULL(PRF.UPDATE_DATE,PRF.RECORD_DATE) BETWEEN #attributes.startdate# AND #attributes.finishdate#
                </cfif>
                <cfif not session.ep.ehesap and len(my_branch_id_list)>
                    AND BRANCH_ID IN (#my_branch_id_list#)
                </cfif>
            ORDER BY
                PRF.PERSONEL_REQUIREMENT_ID DESC
        </cfquery>
    <cfelse>
        <cfquery name="get_form" datasource="#dsn#">
            SELECT
                PRF.*,
                PTR.STAGE
            FROM
                PERSONEL_REQUIREMENT_FORM PRF,
                PROCESS_TYPE_ROWS PTR
            WHERE
                PRF.PER_REQ_STAGE = PTR.PROCESS_ROW_ID AND
                PRF.PERSONEL_REQUIREMENT_ID IS NOT NULL
                <cfif Len(attributes.process_status)>
                    AND ISNULL(PRF.IS_FINISHED,-1) = #attributes.process_status#
                </cfif>
                <cfif Len(attributes.process_stage)>
                    AND PTR.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
                </cfif>
                <cfif len(attributes.our_company_id)>
                    AND PRF.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
                </cfif>
                <cfif len(attributes.branch_id)>
                    AND PRF.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
                </cfif>
                <cfif len(attributes.department_id)>
                    AND PRF.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
                </cfif>
                <cfif len(attributes.position_cat) and len(attributes.position_cat_id)>
                    AND PRF.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">
                </cfif>
                <cfif len(attributes.requirement_name) and len(attributes.requirement_emp_id)>
                    AND PRF.REQUIREMENT_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.requirement_emp_id#">
                </cfif>
                <cfif Len(attributes.keyword)>
                    AND 
                    (
                        <cfif isNumeric(attributes.keyword)>
                            PRF.PERSONEL_REQUIREMENT_ID = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.keyword#"> OR
                        </cfif>
                        PRF.PERSONEL_REQUIREMENT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
                        PRF.OLD_PERSONEL_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
                        PRF.OLD_PERSONEL_POSITION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
                        PRF.CHANGE_PERSONEL_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
                        PRF.CHANGE_PERSONEL_POSITION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
                        PRF.TRANSFER_PERSONEL_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
                        PRF.TRANSFER_PERSONEL_POSITION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
                    )
                </cfif>
                <cfif not ListFirst(attributes.fuseaction,'.') contains 'hr'>
                    AND 
                    (
                        <!---ISNULL(PRF.UPDATE_EMP,PRF.RECORD_EMP) = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">--->
                        PRF.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> OR
                        PRF.UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> OR
                        PRF.PERSONEL_REQUIREMENT_ID IN(SELECT ACTION_ID FROM  PAGE_WARNINGS WHERE ACTION_COLUMN = 'PERSONEL_REQUIREMENT_ID' AND POSITION_CODE = #session.ep.position_code#)<!---onay ve uyarılacaklar --->
                        OR
                        PRF.PERSONEL_REQUIREMENT_ID IN(SELECT PER_REQ_FORM_ID FROM EMPLOYEES_APP_AUTHORITY WHERE POS_CODE = #session.ep.position_code#) <!--- yetkililer--->
                    )
                </cfif>
                <cfif Len(attributes.startdate) and Len(attributes.finishdate)>
                    AND ISNULL(PRF.UPDATE_DATE,PRF.RECORD_DATE) BETWEEN #attributes.startdate# AND #attributes.finishdate#
                </cfif>
                <cfif not session.ep.ehesap and len(my_branch_id_list)>
                    AND BRANCH_ID IN (#my_branch_id_list#)
                </cfif>
            ORDER BY
                PRF.PERSONEL_REQUIREMENT_ID DESC
        </cfquery>
    </cfif>
<cfelse>
    <cfset get_form.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.totalrecords" default="#get_form.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_get_lang_set module_name="hr"><!--- sayfanin alt kisminda kapanisi var, yerini degistirmeyin,treeden dolayi buraya eklendi fbs --->

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>  
        <cfform name="search_form" action="#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.list_personel_requirement_form" method="post">
            <input type="hidden" name="is_filtered" id="is_filtered" value="1">
            <cf_box_search>
                <cfoutput>
                    <div class="form-group">
                        <input type="text" name="keyword" id="keyword" placeholder="#getLang('main',48)#" maxlength="50" value="<cfif Len(attributes.keyword)>#attributes.keyword#</cfif>">
                    </div>
                    <div class="form-group" id="item-process_stage">
                        <select name="process_stage" id="process_stage" >
                            <option value=""><cf_get_lang dictionary_id='57482.Aşamaz'></option>
                            <cfloop query="get_process_stage">
                                <option value="#process_row_id#" <cfif attributes.process_stage eq process_row_id>selected</cfif>>#stage#</option>
                            </cfloop>
                        </select>
                    </div>
                    <div class="form-group">
                        <cf_wrk_search_button button_type="4">
                        <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                    </div>
                </cfoutput>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box title="#getLang('hr',1029,'Personel Talepleri')#" collapsable="1" uidrop="1" hide_table_column="1">
        <form name="form_print_all" id="form_print_all">
            <cf_grid_list>
                <thead>
                    <tr>
                        <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
                        <th><cf_get_lang dictionary_id='57480.Başlık'></th>
                        <th><cf_get_lang dictionary_id='57574.Şirket'></th>
                        <th><cf_get_lang dictionary_id='57453.Şube'></th>
                        <th><cf_get_lang dictionary_id='57572.Departman'></th>
                        <th><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th>
                        <th><cf_get_lang dictionary_id="55372.İhtiyaç Gerekçesi"></th>
                        <th><cf_get_lang dictionary_id="57570.Ad Soyad"></th>
                        <th><cf_get_lang dictionary_id='56205.Kadro Sayısı'></th>
                        <th><cf_get_lang dictionary_id='56219.İstekte Bulunan'></th>
                        <th><cf_get_lang dictionary_id='57482.Aşama'></th>
                        <th><cf_get_lang dictionary_id="55285.Talep Tarihi"></th>
                        <cfif isDefined("x_show_level") and x_show_level eq 1><th><cf_get_lang dictionary_id='62040.Kademeli Departman'></th></cfif>
                        <th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.list_personel_requirement_form&event=add</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                        <cfoutput>
                        <cfif get_form.recordcount>
                            <th width="20" class="text-center">
                                <input type="checkbox" name="all_choice" id="all_choice" value="1" onclick="send_check_all();">
                            </th>
                        </cfif>
                        </cfoutput>
                    </tr>
                </thead>
                <tbody>
                    <cfif get_form.recordcount>
                        <cfset position_cat_list = "">
                        <cfset requirement_emp_list = "">
                        <cfset requirement_par_list = "">
                        <cfset requirement_cons_list = "">
                        <cfset our_company_id_list = "">
                        <cfset branch_id_list = "">
                        <cfset department_id_list = "">
                        <cfset relation_assign_list = "">
                        <cfoutput query="get_form" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <cfif Len(position_cat_id) and not ListFind(position_cat_list,position_cat_id,",")>
                                <cfset position_cat_list = ListAppend(position_cat_list,position_cat_id,",")>
                            </cfif>
                            <cfif Len(requirement_emp) and not ListFind(requirement_emp_list,requirement_emp,",")>
                                <cfset requirement_emp_list = ListAppend(requirement_emp_list,requirement_emp,",")>
                            </cfif>
                            <cfif Len(requirement_par_id) and not ListFind(requirement_par_list,requirement_par_id,",")>
                                <cfset requirement_par_list = ListAppend(requirement_par_list,requirement_par_id,",")>
                            </cfif>
                            <cfif Len(requirement_cons_id) and not ListFind(requirement_cons_list,requirement_cons_id,",")>
                                <cfset requirement_cons_list = ListAppend(requirement_cons_list,requirement_cons_id,",")>
                            </cfif>
                            <cfif Len(our_company_id) and not ListFind(our_company_id_list,our_company_id,",")>
                                <cfset our_company_id_list = ListAppend(our_company_id_list,our_company_id,",")>
                            </cfif>
                            <cfif Len(branch_id) and not ListFind(branch_id_list,branch_id,",")>
                                <cfset branch_id_list = ListAppend(branch_id_list,branch_id,",")>
                            </cfif>
                            <cfif Len(department_id) and not ListFind(department_id_list,department_id,",")>
                                <cfset department_id_list = ListAppend(department_id_list,department_id,",")>
                            </cfif>
                            <cfif Len(personel_requirement_id) and not ListFind(relation_assign_list,personel_requirement_id,",")>
                                <cfset relation_assign_list = ListAppend(relation_assign_list,personel_requirement_id,",")>
                            </cfif>
                        </cfoutput>
                        <cfif ListLen(position_cat_list)>
                            <cfquery name="get_position_cat" datasource="#dsn#">
                                SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT WHERE POSITION_CAT_ID IN (#position_cat_list#) ORDER BY POSITION_CAT_ID
                            </cfquery>
                            <cfset position_cat_list = ListSort(ListDeleteDuplicates(ValueList(get_position_cat.position_cat_id,",")),"numeric","asc",",")>
                        </cfif>
                        <cfif ListLen(requirement_emp_list)>
                            <cfquery name="get_requirement_emp" datasource="#dsn#">
                                SELECT
                                    EMPLOYEE_ID,
                                    EMPLOYEE_NAME,
                                    EMPLOYEE_SURNAME,
                                    DEPARTMENT.HIERARCHY_DEP_ID AS HIERARCHY_DEP_ID1,
                                    CASE 
                                        WHEN EMPLOYEES.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE START_DATE <= GETDATE() AND (FINISH_DATE >= GETDATE() OR FINISH_DATE IS NULL))
                                    THEN	
                                        DEPARTMENT.HIERARCHY_DEP_ID
                                    ELSE 
                                        CASE WHEN 
                                            DEPARTMENT.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM DEPARTMENT_HISTORY WHERE CHANGE_DATE IS NOT NULL AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID))
                                        THEN
                                            (SELECT TOP 1 HIERARCHY_DEP_ID FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID) ORDER BY CHANGE_DATE DESC, DEPT_HIST_ID DESC)
                                        ELSE
                                            DEPARTMENT.HIERARCHY_DEP_ID
                                        END
                                    END AS HIERARCHY_DEP_ID
                                FROM
                                    EMPLOYEES,
                                    DEPARTMENT
                                WHERE
                                    EMPLOYEE_ID IN (#requirement_emp_list#)
                                ORDER BY
                                    EMPLOYEE_ID
                            </cfquery>
                            <cfset requirement_emp_list = ListSort(ListDeleteDuplicates(ValueList(get_requirement_emp.employee_id,",")),"numeric","asc",",")>
                        </cfif>
                        <cfif ListLen(requirement_par_list)>
                            <cfquery name="get_requirement_par" datasource="#dsn#">
                                SELECT PARTNER_ID,COMPANY_PARTNER_NAME, COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID IN (#requirement_par_list#) ORDER BY PARTNER_ID
                            </cfquery>
                            <cfset requirement_par_list = ListSort(ListDeleteDuplicates(ValueList(get_requirement_par.partner_id,",")),"numeric","asc",",")>
                        </cfif>
                        <cfif ListLen(requirement_cons_list)>
                            <cfquery name="get_requirement_cons" datasource="#dsn#">
                                SELECT CONSUMER_ID,CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#requirement_cons_list#) ORDER BY CONSUMER_ID
                            </cfquery>
                            <cfset requirement_cons_list = ListSort(ListDeleteDuplicates(ValueList(get_requirement_cons.consumer_id,",")),"numeric","asc",",")>
                        </cfif>
                        <cfif ListLen(our_company_id_list)>
                            <cfquery name="get_our_company_name" datasource="#dsn#">
                                SELECT COMP_ID,NICK_NAME FROM OUR_COMPANY WHERE COMP_ID IN (#our_company_id_list#) ORDER BY COMP_ID
                            </cfquery>
                            <cfset our_company_id_list = ListSort(ListDeleteDuplicates(ValueList(get_our_company_name.comp_id,",")),"numeric","asc",",")>
                        </cfif>
                        <cfif ListLen(branch_id_list)>
                            <cfquery name="get_branch_name" datasource="#dsn#">
                                SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE BRANCH_ID IN (#branch_id_list#) ORDER BY BRANCH_ID
                            </cfquery>
                            <cfset branch_id_list = ListSort(ListDeleteDuplicates(ValueList(get_branch_name.branch_id,",")),"numeric","asc",",")>
                        </cfif>
                        <cfif ListLen(department_id_list)>
                            <cfquery name="get_department_name" datasource="#dsn#">
                                SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID IN (#department_id_list#) ORDER BY DEPARTMENT_ID
                            </cfquery>
                            <cfset department_id_list = ListSort(ListDeleteDuplicates(ValueList(get_department_name.department_id,",")),"numeric","asc",",")>
                        </cfif>
                        <cfif ListLen(relation_assign_list)>
                            <cfquery name="get_relation_assign" datasource="#dsn#">
                                SELECT PERSONEL_REQ_ID,PERSONEL_NAME,PERSONEL_SURNAME FROM PERSONEL_ASSIGN_FORM WHERE PERSONEL_REQ_ID IN (#relation_assign_list#) ORDER BY PERSONEL_REQ_ID
                            </cfquery>
                            <cfset relation_assign_list = ListSort(ListDeleteDuplicates(ValueList(get_relation_assign.personel_req_id,",")),"numeric","asc",",")>
                        </cfif>
                        <cfoutput query="get_form" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <tr>
                                <cfif fusebox.circuit eq 'myhome'>
                                    <cfset personel_requirement_id_ = contentEncryptingandDecodingAES(isEncode:1,content:personel_requirement_id,accountKey:'wrk')>
                                <cfelse>
                                    <cfset personel_requirement_id_ = personel_requirement_id>
                                </cfif>
                                <td width="35">#currentrow#</td>
                                <td><a href="#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.list_personel_requirement_form&event=upd&per_req_id=#personel_requirement_id_#" class="tableyazi">#personel_requirement_id# - #personel_requirement_head#</a></td>
                                <td><cfif Len(our_company_id)>#get_our_company_name.nick_name[ListFind(our_company_id_list,our_company_id,',')]#</cfif></td>
                                <td><cfif Len(branch_id)>#get_branch_name.branch_name[ListFind(branch_id_list,branch_id,',')]#</cfif></td>
                                <td><cfif Len(department_id)>#get_department_name.department_head[ListFind(department_id_list,department_id,',')]#</cfif></td>
                                <td><cfif Len(position_cat_id)>#get_position_cat.position_cat[ListFind(position_cat_list,position_cat_id,',')]#</cfif></td>
                                <td><cfif form_type eq 1><cf_get_lang dictionary_id="55433.Ayrılan Kişinin Yerine">
                                    <cfelseif form_type eq 2><cf_get_lang dictionary_id="55574.Ek Kadro">
                                    <cfelseif form_type eq 3><cf_get_lang dictionary_id="55451.Pozisyon Değişikliği Yapan Personelin Yerine">
                                    <cfelseif form_type eq 4><cf_get_lang dictionary_id="55481.Nakil Olan Personelin Yerine">
                                    <cfelseif form_type eq 5><cf_get_lang dictionary_id="55579.Emeklilik Nedeniyle  Çıkış / Giriş Yapan Personelin Yerine">
                                    <cfelseif form_type eq 6><cf_get_lang dictionary_id="55449.Ek Kadro Süreli"></cfif>
                                    <cfif len(old_personel_name)> - <b>#old_personel_name# (#old_personel_position#)</b></cfif>
                                    <cfif len(change_personel_name)> - <b>#change_personel_name# (#change_personel_position#)</b></cfif>
                                    <cfif len(transfer_personel_name)> - <b>#transfer_personel_name# (#transfer_personel_position#)</b></cfif>
                                </td>
                                <td><cfif Len(relation_assign_list)>#get_relation_assign.personel_name[ListFind(relation_assign_list,personel_requirement_id,",")]# #get_relation_assign.personel_surname[ListFind(relation_assign_list,personel_requirement_id,",")]#</cfif></td>
                                <td>#get_form.personel_count#</td>
                                <td><cfif Len(requirement_emp)>
                                        #get_emp_info(requirement_emp,0,0)#
                                    <cfelseif Len(requirement_par_id)>
                                        #get_requirement_par.company_partner_name[ListFind(requirement_par_list,requirement_par_id,',')]# #get_requirement_par.company_partner_surname[ListFind(requirement_par_list,requirement_par_id,',')]#
                                    <cfelseif Len(requirement_cons_id)>
                                        #get_requirement_cons.consumer_name[ListFind(requirement_cons_list,requirement_cons_id,',')]# #get_requirement_cons.consumer_name[ListFind(requirement_cons_list,requirement_cons_id,',')]#
                                    </cfif>
                                </td>
                                <td>#stage#</td>
                                <td>#DateFormat(REQUIREMENT_DATE, dateformat_style)#</td>
                                <cfif isDefined("x_show_level") and x_show_level eq 1>
                                    <td>                            
                                        <cfset up_dep_len = listlen(get_requirement_emp.HIERARCHY_DEP_ID1,'.')>
                                        <cfif up_dep_len gt 0>
                                            <cfset temp = up_dep_len> 
                                            <cfloop from="1" to="#up_dep_len#" index="i" step="1">
                                                <cfif isdefined("get_requirement_emp.HIERARCHY_DEP_ID1") and listlen(get_requirement_emp.HIERARCHY_DEP_ID1,'.') gt temp>
                                                    <cfset up_dep_id = ListGetAt(get_requirement_emp.HIERARCHY_DEP_ID1, listlen(get_requirement_emp.HIERARCHY_DEP_ID1,'.')-temp,".")>
                                                    <cfquery name="get_upper_departments" datasource="#dsn#">
                                                        SELECT DEPARTMENT_HEAD, LEVEL_NO FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#up_dep_id#">
                                                    </cfquery>
                                                    <cfset up_dep_head = get_upper_departments.department_head>
                                                    #up_dep_head# 
                                                        <cfset get_org_level = cmp_org_step.get_organization_step(level_no : get_upper_departments.LEVEL_NO)>
                                                        <cfif get_org_level.recordcount>
                                                            (#get_org_level.ORGANIZATION_STEP_NAME#)
                                                        </cfif>
                                                    <cfif up_dep_len neq i>
                                                        >
                                                    </cfif>
                                                <cfelse>
                                                    <cfset up_dep_head = ''>
                                                </cfif>
                                                <cfset temp = temp - 1>
                                            </cfloop>
                                        </cfif>​
                                    </td>
                                </cfif>
                                <td align="center"><a href="#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.list_personel_requirement_form&event=upd&per_req_id=#personel_requirement_id_#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                                <td class="text-center"><input type="checkbox" name="print_form_choice" id="print_form_choice" value="#personel_requirement_id#"></td>
                            </tr>
                        </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="14"><cfif isDefined("attributes.is_filtered")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
                            </tr>
                    </cfif>
                </tbody>
            </cf_grid_list>  
        </form>
        
        <cfset url_str = "&is_filtered=1">
        <cfif Len(attributes.keyword)><cfset url_str = "#url_str#&keyword=#attributes.keyword#"></cfif>
        <cfif Len(attributes.requirement_name) and Len(attributes.requirement_emp_id)>
            <cfset url_str = "#url_str#&requirement_name=#attributes.requirement_name#&requirement_emp_id=#attributes.requirement_emp_id#">
        </cfif>
        <cfset url_str = "#url_str#&our_company_id=#attributes.our_company_id#">
        <cfif Len(attributes.branch_id)><cfset url_str = "#url_str#&branch_id=#attributes.branch_id#"></cfif>
        <cfif Len(attributes.department_id)><cfset url_str = "#url_str#&department_id=#attributes.department_id#"></cfif>
        <cfif Len(attributes.position_cat) and Len(attributes.position_cat_id)>
            <cfset url_str = "#url_str#&position_cat=#attributes.position_cat#&position_cat_id=#attributes.position_cat_id#">
        </cfif>
        <cfif Len(attributes.process_stage)><cfset url_str = "#url_str#&process_stage=#attributes.process_stage#"></cfif>
        <cfif Len(attributes.startdate)><cfset url_str = "#url_str#&startdate=#DateFormat(attributes.startdate,dateformat_style)#"></cfif>
        <cfif Len(attributes.finishdate)><cfset url_str = "#url_str#&finishdate=#DateFormat(attributes.finishdate,dateformat_style)#"></cfif>

        <cf_paging 
            page="#attributes.page#" 
            startrow="#attributes.startrow#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            adres="#attributes.fuseaction##url_str#">
    </cf_box>
</div>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin ust kisminda acilisi var, yerini degistirmeyin,treeden dolayi buraya eklendi fbs --->
<script type="text/javascript">
document.getElementById('keyword').focus();
//Sirket- Sube- Departman Filtresine Gore Sonuc Doner
function showRelation(field_id,relation_name,relation_name2,type)	
{
    
    field_length = eval('document.getElementById("' + relation_name + '")').options.length;
    if(field_length > 0)
        for(jj=field_length;jj>=0;jj--)
            eval('document.getElementById("' + relation_name + '")').options[jj+1]=null;
            
    if(relation_name2 != "")
    {
        field_length = eval('document.getElementById("' + relation_name2 + '")').options.length;
        if(field_length > 0)
            for(jj=field_length;jj>=0;jj--)
                eval('document.getElementById("' + relation_name2 + '")').options[jj+1]=null;
    }

    if(field_id != "")
    {
        if (type == 1)
            var get_relation_table = wrk_query("SELECT BRANCH_ID RELATED_ID,BRANCH_NAME RELATED_NAME FROM BRANCH WHERE BRANCH_STATUS =1 AND COMPANY_ID = "+ field_id +" ORDER BY BRANCH_NAME","dsn");
        else
            var get_relation_table = wrk_query("SELECT DEPARTMENT_ID RELATED_ID,DEPARTMENT_HEAD RELATED_NAME FROM DEPARTMENT WHERE DEPARTMENT_STATUS = 1 AND BRANCH_ID = "+ field_id +" ORDER BY DEPARTMENT_HEAD","dsn");
        
        if(get_relation_table.recordcount > 0)
            for(xx=0;xx<get_relation_table.recordcount;xx++)
                eval('document.getElementById("' + relation_name + '")').options[xx+1]=new Option(get_relation_table.RELATED_NAME[xx],get_relation_table.RELATED_ID[xx]);
    }
}

function send_print_choice()
{
    print_form_list = "";
    <cfif get_form.recordcount eq 1>
        if(document.form_print_all.print_form_choice.checked == false)
        {
            alert(<cf_get_lang dictionary_id='35382.Yazdırılacak İşlem Bulunamadı! Toplu Print Yapamazsınız!'>);
            return false;
        }
        else
        {
            print_form_list = document.form_print_all.print_form_choice.value;
        }
    <cfelseif get_form.recordcount gt 1>
        for (i=0; i < document.form_print_all.print_form_choice.length; i++)
        {
            if(document.form_print_all.print_form_choice[i].checked == true)
            {
                print_form_list = print_form_list + document.form_print_all.print_form_choice[i].value + ',';
            }
        }
    </cfif>
    if(print_form_list.length == 0)
    {
        alert("<cf_get_lang dictionary_id='35384.En Az Bir Seçim Yapmalısınız'>!");
        return false;
    }
    else
    {
        windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_operate_page&operation=emptypopup_print_personel_requirement&action=print&id='+print_form_list+'&module=<cfoutput>#ListFirst(attributes.fuseaction,'.')#</cfoutput>&iframe=1&trail=0','page');
        return false;
    }
}
function send_check_all()
{
        
    all_count = "<cfoutput><cfif get_form.recordcount lte attributes.maxrows>#get_form.recordcount#<cfelse>#attributes.maxrows#</cfif></cfoutput>";
    if(all_count > 1)
        for(cc=0;cc<all_count;cc++)
            document.form_print_all.print_form_choice[cc].checked = document.getElementById("all_choice").checked;
    else if(all_count == 1)
        document.form_print_all.print_form_choice.checked = document.getElementById("all_choice").checked;
}
</script>
