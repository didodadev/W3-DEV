<!--- 
Bütçe transfer Talebi
Onay Red lerde çalışması için action file
--->

<cfset demand = createObject("component", "V16.budget.cfc.BudgetTransferDemand" )>
<cfset det_demand = demand.det_demand(
                                        demand_id : attributes.action_id
                                     )>
<cfset demand_val = deserializeJSON(det_demand)>
<CFSET STAGE_ID_ = 345> <!--- 345	6 Fin. Rap. Direktör Onayında--->
<CFSET STAGE_ID1_ = 328> <!--- Talep eden gmy onayında --->
<CFSET STAGE_ID2_1 = 329> <!---Talep Edilen gmy onayında --->
<CFSET STAGE_ID2_ = 342> <!---	Talep Eden Direktör Onayında --->
<CFSET STAGE_ID3_1 = 330> <!--- cfoonayında --->
<CFSET STAGE_ID4 = 332> <!--- 	GM Onayında --->
<CFSET STAGE_ID4_1 = 337> <!--- Bütçe Aktarım Onaylandı --->

<cfset pozisyon_id_list = "30,11,3,9">
<cfset pozisyon_id_amir = 583>
<cfset pozisyon_id_sy = 30>

<cfset get_fuseaction_property = createObject("component","V16.objects.cfc.fuseaction_properties")>
<cfset GET_XMLPRO_CAT = get_fuseaction_property.get_fuseaction_property(
company_id : session.ep.company_id,
fuseaction_name : 'budget.budget_transfer_demand',
property_name : 'xml_proje_cat_id',
datasource_name : '#caller.dsn2#'
)>
<CFSET project_cat_id_list= "1,6">
<cfif GET_XMLPRO_CAT.recordCount and len( GET_XMLPRO_CAT.PROPERTY_VALUE )>
    <CFSET project_cat_id_list= valueList(GET_XMLPRO_CAT.PROPERTY_VALUE)>
</cfif>

<cfsavecontent variable="aa">
<CFDUMP VAR="#ATTRIBUTES#">
</cfsavecontent>
<cfif demand_val[1]["TRA_DEPARTMENT_ID"] eq -1>
    <cfquery name="Get_TalepEden_DP" datasource="#caller.dsn2#"><!--- TALEP EDEN MASRAF MERKEZI YETKILILERI --->
        SELECT DEPARTMENT_ID  FROM #CALLER.DSN_ALIAS#.EMPLOYEE_POSITIONS WHERE POSITION_CODE = #demand_val[1]["DEMAND_EMP_ID"]#
    </cfquery>
    <cfset tra_department_id = Get_TalepEden_DP.DEPARTMENT_ID>
<cfelse>
    <cfset tra_department_id = demand_val[1]["TRA_DEPARTMENT_ID"]>
</cfif>
<cfquery name="Get_Employee_Info1" datasource="#caller.dsn2#">
    select D2.DEPARTMENT_ID
    ,d2.ADMIN1_POSITION_CODE as POSITION_CODE
    ,EP.EMPLOYEE_EMAIL
    ,EP.EMPLOYEE_NAME
    ,EP.EMPLOYEE_SURNAME
    from 
        #CALLER.DSN#.DEPARTMENT D 
            LEFT JOIN #CALLER.DSN#.DEPARTMENT as D2 
            ON D.HIERARCHY_DEP_ID  = CONCAT(D2.HIERARCHY_DEP_ID,'.',D.DEPARTMENT_ID) 
            and D2.LEVEL_NO = 4
            JOIN #CALLER.DSN#.EMPLOYEE_POSITIONS EP ON EP.POSITION_CODE = D2.ADMIN1_POSITION_CODE 
            where d.DEPARTMENT_ID = #tra_department_id#
    UNION
        select D3.DEPARTMENT_ID
    ,d3.ADMIN1_POSITION_CODE as POSITION_CODE
    ,EP.EMPLOYEE_EMAIL
    ,EP.EMPLOYEE_NAME
    ,EP.EMPLOYEE_SURNAME
    from 
        #CALLER.DSN#.DEPARTMENT D 
            LEFT JOIN #CALLER.DSN#.DEPARTMENT as D2 
            ON D.HIERARCHY_DEP_ID  = CONCAT(D2.HIERARCHY_DEP_ID,'.',D.DEPARTMENT_ID) 
                LEFT JOIN #CALLER.DSN#.DEPARTMENT as D3 
                ON D2.HIERARCHY_DEP_ID  = CONCAT(D3.HIERARCHY_DEP_ID,'.',D2.DEPARTMENT_ID) 
                and D3.LEVEL_NO = 4
            JOIN #CALLER.DSN#.EMPLOYEE_POSITIONS EP ON EP.POSITION_CODE = D3.ADMIN1_POSITION_CODE 
            where d.DEPARTMENT_ID = #tra_department_id#
</cfquery>
<cfif demand_val[1]["DEPARTMENT_ID"] eq -1>
    <cfquery name="Get_TalepEdilen_DP" datasource="#caller.dsn2#"><!--- TALEP EDİLEN MASRAF MERKEZI YETKILILERI --->
        SELECT DEPARTMENT_ID  FROM #CALLER.DSN_ALIAS#.EMPLOYEE_POSITIONS WHERE POSITION_CODE IN (#demand_val[1]["RESPONSIBLE1"]#,#demand_val[1]["RESPONSIBLE2"]#,#demand_val[1]["RESPONSIBLE3"]#)
    </cfquery>
    <cfset department_id = Get_TalepEdilen_DP.DEPARTMENT_ID>
<cfelse>
    <cfset department_id = demand_val[1]["DEPARTMENT_ID"]>
</cfif>
<cfquery name="Get_Employee_Info2" datasource="#caller.dsn2#">/* TALEP EDİLEN */
    select D2.DEPARTMENT_ID
    ,d2.ADMIN1_POSITION_CODE as POSITION_CODE
    ,EP.EMPLOYEE_EMAIL
    ,EP.EMPLOYEE_NAME
    ,EP.EMPLOYEE_SURNAME
    from 
        #CALLER.DSN#.DEPARTMENT D 
            LEFT JOIN #CALLER.DSN#.DEPARTMENT as D2 
            ON D.HIERARCHY_DEP_ID  = CONCAT(D2.HIERARCHY_DEP_ID,'.',D.DEPARTMENT_ID) 
            and D2.LEVEL_NO = 4
            JOIN #CALLER.DSN#.EMPLOYEE_POSITIONS EP ON EP.POSITION_CODE = D2.ADMIN1_POSITION_CODE 
            where d.DEPARTMENT_ID = #department_id#
        UNION
        select D3.DEPARTMENT_ID
    ,d3.ADMIN1_POSITION_CODE as POSITION_CODE
    ,EP.EMPLOYEE_EMAIL
    ,EP.EMPLOYEE_NAME
    ,EP.EMPLOYEE_SURNAME
    from 
        #CALLER.DSN#.DEPARTMENT D 
            LEFT JOIN #CALLER.DSN#.DEPARTMENT as D2 
            ON D.HIERARCHY_DEP_ID  = CONCAT(D2.HIERARCHY_DEP_ID,'.',D.DEPARTMENT_ID) 
                LEFT JOIN #CALLER.DSN#.DEPARTMENT as D3
                ON D2.HIERARCHY_DEP_ID  = CONCAT(D3.HIERARCHY_DEP_ID,'.',D2.DEPARTMENT_ID) 
                and D3.LEVEL_NO = 4
            JOIN #CALLER.DSN#.EMPLOYEE_POSITIONS EP ON EP.POSITION_CODE = D3.ADMIN1_POSITION_CODE 
            where d.DEPARTMENT_ID = #department_id#
</cfquery>

<cffile action="write" output="#attributes.process_stage#-#demand_val[1]["DEMAND_EXP_CENTER"]#-#demand_val[1]["TRANSFER_EXP_CENTER"]#" file="c://pp.cfm">
<cfif attributes.process_stage eq STAGE_ID_><!---süreç Fin. Rap. Direktör Onayında  --->
    <cffile action="write" output="#attributes.process_stage#-1-#demand_val[1]["DEMAND_EXP_CENTER"]#-#demand_val[1]["TRANSFER_EXP_CENTER"]#" file="c://p1.cfm">
    <cfquery name="get_act" datasource="#caller.dsn2#">
        SELECT TOP 1 * FROM #caller.dsn_alias#.PAGE_WARNINGS 
        WHERE 
            ACTION_TABLE = 'BUDGET_TRANSFER_DEMAND' 
            AND ACTION_COLUMN = 'DEMAND_ID' 
            AND ACTION_ID = #attributes.action_id# 
            AND OUR_COMPANY_ID = #session.ep.company_id#
            and PERIOD_ID = #session.ep.period_id#
            
        ORDER BY W_ID DESC
    </cfquery>
    <cfif get_act.recordcount>
        <cfquery name="get_action" datasource="#caller.dsn2#">
            SELECT * FROM #caller.dsn_alias#.PAGE_WARNINGS_ACTIONS WHERE WARNING_ID = #get_act.W_ID#
        </cfquery>
        <cfquery name="Get_Employee_Demand" datasource="#caller.dsn2#">
            SELECT POSITION_ID,UPPER_POSITION_CODE2,UPPER_POSITION_CODE FROM #CALLER.DSN#.EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #demand_val[1]["DEMAND_EMP_ID"]# 
        </cfquery>
        <cfif listfind(pozisyon_id_list,Get_Employee_Demand.POSITION_ID,',') eq 0><!--- ÇALIŞAN İSE --->
            <cfquery name="Get_Employee_Talep_Eden" datasource="#caller.dsn2#">
                SELECT POSITION_ID FROM #CALLER.DSN#.EMPLOYEE_POSITIONS WHERE POSITION_CODE = #Get_Employee_Demand.UPPER_POSITION_CODE2#
            </cfquery>
        <cfelseif listfind(pozisyon_id_sy, Get_Employee_Demand.POSITION_ID,',')>
            <cfquery name="Get_Employee_Talep_Eden" datasource="#caller.dsn2#">
                SELECT POSITION_ID FROM #CALLER.DSN#.EMPLOYEE_POSITIONS WHERE POSITION_CODE = #Get_Employee_Demand.UPPER_POSITION_CODE#
            </cfquery>
        </cfif>
        <cfquery name="Get_Employee_Info" datasource="#caller.dsn2#"><!--- TALEP EDİLEN MASRAF MERKEZI YETKILILERI --->
            SELECT EMPLOYEE_EMAIL,POSITION_ID ,EMPLOYEE_NAME,EMPLOYEE_SURNAME,POSITION_CODE,UPPER_POSITION_CODE2,UPPER_POSITION_CODE FROM #CALLER.DSN_ALIAS#.EMPLOYEE_POSITIONS WHERE 
            POSITION_CODE IN (#demand_val[1]["RESPONSIBLE1"]#,#demand_val[1]["RESPONSIBLE2"]#,#demand_val[1]["RESPONSIBLE3"]#)
            AND EMPLOYEE_EMAIL IS NOT NULL
        </cfquery>
        <cfif listfind(pozisyon_id_list,Get_Employee_Info.POSITION_ID,',') eq 0><!--- ÇALIŞAN İSE --->
            <cfquery name="Get_Employee_Talep_Edilen" datasource="#caller.dsn2#">
                SELECT POSITION_ID FROM #CALLER.DSN#.EMPLOYEE_POSITIONS WHERE POSITION_CODE = #Get_Employee_Info.UPPER_POSITION_CODE2#
            </cfquery>
        <cfelseif listfind(pozisyon_id_sy, Get_Employee_Info.POSITION_ID,',')>
            <cfquery name="Get_Employee_Talep_Edilen" datasource="#caller.dsn2#">
                SELECT POSITION_ID FROM #CALLER.DSN#.EMPLOYEE_POSITIONS WHERE POSITION_CODE = #Get_Employee_Info.UPPER_POSITION_CODE#
            </cfquery>
        </cfif>
        <cfif get_action.recordcount and get_action.is_confirm eq 1>
            <cfsavecontent variable="aa">
                <CFDUMP VAR="#Get_Employee_Info1#">
                <CFDUMP VAR="#Get_Employee_Info2#">
            </cfsavecontent>
            <cffile action="write" output="#aa#" file="c://ppD.cfm">
                    <!--- iki masraf merkezi eşit DEĞILSE  --->
            <cfif demand_val[1]["TRANSFER_EXP_CENTER"] Neq demand_val[1]["DEMAND_EXP_CENTER"]>
                <!--- Workflow --->
                    <cfif not isdefined('request.self')>
                        <cfset request.self = caller.request.self>
                    </cfif> 
                    <cfif isdefined("session.ep") and  isdefined("attributes.process_stage") and isdefined("attributes.action_id")>
                        <cfset paper_no = demand_val[1]["DEMAND_NO"]>
                        <cfset url_link_ = '#request.self#?fuseaction=budget.budget_transfer_demand&event=upd&demand_id=#attributes.action_id#&wrkflow=1'>
                        <cfset url_link_wf = '#request.self#?fuseaction=budget.budget_transfer_demand&event=upd&demand_id=#attributes.action_id#'>
                        <cfif Get_Employee_Talep_Eden.POSITION_ID neq pozisyon_id_amir><!--- Talep Eden birim direktörü amiri GM değil ise --->
                            <cfset attributes.stage_id = STAGE_ID1_><!--- Talep eden gmy onayında ---> 
                            <cfset updateStage = demand.UPD_DEMAND_STAGE(action_id:attributes.action_id,stage_id : attributes.stage_id)>
                            <cfset attributes.process_stage = attributes.stage_id>
                            <cfif Get_Employee_Info1.Recordcount>
                                <cfoutput query="Get_Employee_Info1">
                                    <cfif len(Get_Employee_Info1.employee_email)>
                                        <cfsavecontent variable="message">
                                            <type="html">
                                                    Sayın #Get_Employee_Info1.employee_name# #Get_Employee_Info1.employee_surname#, <br />
                                                    Bütçe aktarım talebini kontrol ediniz<br/><br/>
                                                        <cfoutput>
                                                        <table>
                                                            <tr>
                                                                <td>
                                                                </td>
                                                                <td><b>Talep Edilen Bütçe</b>
                                                                </td>
                                                                <td><b>Aktarılan Bütçe</b>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>Masraf Merkezi
                                                                </td>
                                                                <td>#demand_val[1]["EXPENSE"]#</td>
                                                                <td>#demand_val[1]["TRA_EXPENSE"]#</td>
                                                            </tr>
                                                            <tr>
                                                                <td>Bütçe Kalemi
                                                                </td>
                                                                <td>#demand_val[1]["EXPENSE_ITEM_NAME"]#</td>
                                                                <td>#demand_val[1]["TRA_EXPENSE_ITEM_NAME"]#</td>
                                                            </tr>
                                                            <tr>
                                                                <td>Proje
                                                                </td>
                                                                <td>#demand_val[1]["PROJECT_HEAD"]#</td>
                                                                <td>#demand_val[1]["TRA_PROJECT_HEAD"]#</td>
                                                            </tr>
                                                            <tr>
                                                                <td>Tutar
                                                                </td>
                                                                <td>#caller.tlformat(demand_val[1]["AMOUNT"])#</td>
                                                                <td></td>
                                                            </tr>
                                                        </cfoutput>
                                                        </table>
                                                        <a href="#caller.fusebox.server_machine_list#/#request.self#?fuseaction=budget.budget_transfer_demand&event=upd&demand_id==#attributes.action_id#" target="_blank">
                                                        Bütçe Aktarım Talebi Detay Sayfası</a> <br/><br/>
                                                        
                                                        <cf_get_lang dictionary_id='32344.Lütfen İşlemi Kontrol Ediniz!...'>
                                                    <br />
                                                
                                        </cfsavecontent>
                                        <cfscript>
                                            attributes.mail_content_to = Get_Employee_Info1.employee_email;
                                            attributes.mail_content_from = session.ep.company_email;
                                            attributes.mail_content_subject = '#paper_no# Numaralı Bütçe Aktarım Talebi Bilgilendirme';
                                            attributes.mail_content_additor = '#Get_Employee_Info1.employee_name# #Get_Employee_Info1.employee_surname#';
                                            attributes.mail_content_link = '#caller.user_domain##url_link_#';
                                            attributes.process_stage_info = attributes.process_stage;
                                            attributes.remainder = '#paper_no# Bütçe Aktarım Talebi';
                                            attributes.mail_content_info2 = message;
                                        </cfscript>
                                        <cfinclude template = "../../design/template/info_mail/mail_content.cfm">
                                        <cfset max_warning_date = attributes.record_date>
                                        <cfquery name="get_process_type" datasource="#attributes.data_source#">
                                            SELECT
                                                P.PROCESS_ID,
                                                P.PROCESS_NAME,
                                                PR.PROCESS_ROW_ID,
                                                PR.STAGE,
                                                PR.DETAIL,
                                                PR.ANSWER_HOUR,
                                                PR.ANSWER_MINUTE
                                            FROM
                                                #caller.dsn_alias#.PROCESS_TYPE P,
                                                #caller.dsn_alias#.PROCESS_TYPE_ROWS PR
                                            WHERE
                                                P.PROCESS_ID = PR.PROCESS_ID AND
                                                PR.PROCESS_ROW_ID = #attributes.process_stage#
                                        </cfquery>
                                        <cfif len(get_process_type.answer_hour)>
                                            <cfset max_warning_date = caller.date_add("h", get_process_type.answer_hour, attributes.record_date)>
                                        </cfif>
                                        <cfif len(get_process_type.answer_minute)>
                                            <cfset max_warning_date = caller.date_add("n", get_process_type.answer_minute, attributes.record_date)>
                                        </cfif>
                                        <!--- Önceki aşamaları Pasif yap --->
                                    <!---  <cfquery name="UPD_WARNINGS_2" datasource="#attributes.data_source#">
                                            UPDATE #process_db#PAGE_WARNINGS SET IS_ACTIVE = 0 
                                            WHERE ACTION_TABLE = 'BUDGET_TRANSFER_DEMAND' AND ACTION_COLUMN = 'DEMAND_ID' AND ACTION_ID = #attributes.action_id# 
                                            AND OUR_COMPANY_ID = #session.ep.company_id# and PERIOD_ID = #session.ep.period_id#
                                        </cfquery> --->
                                        <!---------------------------------->
                                        <cfquery name="ADD_WARNING" datasource="#attributes.data_source#" result="GET_WARNINGS">
                                            INSERT INTO
                                                #caller.dsn_alias#.PAGE_WARNINGS
                                                (
                                                    URL_LINK,
                                                    WARNING_HEAD,
                                                    SETUP_WARNING_ID,
                                                    WARNING_DESCRIPTION,
                                                    SMS_WARNING_DATE,
                                                    EMAIL_WARNING_DATE,
                                                    LAST_RESPONSE_DATE,
                                                    RECORD_DATE,
                                                    IS_ACTIVE,
                                                    IS_PARENT,
                                                    RESPONSE_ID,
                                                    RECORD_IP,
                                                    RECORD_EMP,
                                                    POSITION_CODE,
                                                    WARNING_PROCESS,
                                                    OUR_COMPANY_ID,
                                                    PERIOD_ID,
                                                    ACTION_TABLE,
                                                    ACTION_COLUMN,
                                                    ACTION_ID,
                                                    ACTION_STAGE_ID,
                                                    SENDER_POSITION_CODE,
                                                    IS_CONFIRM ,
                                                    IS_REFUSE
                                                )
                                            VALUES
                                                (
                                                    '#url_link_wf#',
                                                    '#get_process_type.process_name# - #get_process_type.stage#',
                                                    #get_process_type.process_row_id#,
                                                    '<cfif len(get_process_type.detail)>#get_process_type.detail# - </cfif>#attributes.warning_description#',
                                                    #max_warning_date#,
                                                    #max_warning_date#,
                                                    #max_warning_date#,
                                                    #attributes.record_date#,
                                                    1,
                                                    1,
                                                    0,
                                                    '#cgi.remote_addr#',
                                                    #session.ep.userid#,
                                                    #Get_Employee_Info1.POSITION_CODE#,
                                                    1,
                                                    #session.ep.company_id#,
                                                    #session.ep.period_id#,
                                                    'BUDGET_TRANSFER_DEMAND',
                                                    'DEMAND_ID',
                                                    #attributes.action_id#,
                                                    #get_process_type.process_row_id#,
                                                    #session.ep.POSITION_CODE#,
                                                    1,
                                                    1
                                                )
                                        </cfquery>
                                        <cfquery name="UPD_WARNINGS" datasource="#attributes.data_source#">
                                            UPDATE #process_db#PAGE_WARNINGS SET PARENT_ID = #get_warnings.IDENTITYCOL# WHERE W_ID = #get_warnings.IDENTITYCOL#			
                                        </cfquery>
                                        <cfset attributes.old_process_line = get_Process_Type_1.Line_Number><!--- süreç uyarıyı pasife çekmesin diye eklendi --->
                                    </cfif>
                                </cfoutput>
                            </cfif>
                        <cfelse><!--- Talep Eden birim direktörü amiri GM  ise --->
                            <cfif Get_Employee_Talep_Edilen.POSITION_ID neq pozisyon_id_amir><!--- Talep Edilen birim direktörü amiri GM değil ise --->
                                <cfset attributes.stage_id = STAGE_ID2_1><!--- Talep edilen gmy onayında ---> 
                                <cfset updateStage = demand.UPD_DEMAND_STAGE(action_id:attributes.action_id,stage_id : attributes.stage_id)>
                                <cfset attributes.process_stage = attributes.stage_id>
                                <cfif Get_Employee_Info2.Recordcount>
                                    <cfoutput query="Get_Employee_Info2">
                                        <cfif len(Get_Employee_Info2.employee_email)>
                                            <cfsavecontent variable="message">
                                                <type="html">
                                                        Sayın #Get_Employee_Info2.employee_name# #Get_Employee_Info2.employee_surname#, <br />
                                                        Bütçe aktarım talebini kontrol ediniz<br/><br/>
                                                            <cfoutput>
                                                            <table>
                                                                <tr>
                                                                    <td>
                                                                    </td>
                                                                    <td><b>Talep Edilen Bütçe</b>
                                                                    </td>
                                                                    <td><b>Aktarılan Bütçe</b>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>Masraf Merkezi
                                                                    </td>
                                                                    <td>#demand_val[1]["EXPENSE"]#</td>
                                                                    <td>#demand_val[1]["TRA_EXPENSE"]#</td>
                                                                </tr>
                                                                <tr>
                                                                    <td>Bütçe Kalemi
                                                                    </td>
                                                                    <td>#demand_val[1]["EXPENSE_ITEM_NAME"]#</td>
                                                                    <td>#demand_val[1]["TRA_EXPENSE_ITEM_NAME"]#</td>
                                                                </tr>
                                                                <tr>
                                                                    <td>Proje
                                                                    </td>
                                                                    <td>#demand_val[1]["PROJECT_HEAD"]#</td>
                                                                    <td>#demand_val[1]["TRA_PROJECT_HEAD"]#</td>
                                                                </tr>
                                                                <tr>
                                                                    <td>Tutar
                                                                    </td>
                                                                    <td>#caller.tlformat(demand_val[1]["AMOUNT"])#</td>
                                                                    <td></td>
                                                                </tr>
                                                            </cfoutput>
                                                            </table>
                                                            <a href="#caller.fusebox.server_machine_list#/#request.self#?fuseaction=budget.budget_transfer_demand&event=upd&demand_id==#attributes.action_id#" target="_blank">
                                                            Bütçe Aktarım Talebi Detay Sayfası</a> <br/><br/>
                                                            
                                                            <cf_get_lang dictionary_id='32344.Lütfen İşlemi Kontrol Ediniz!...'>
                                                        <br />
                                                    
                                            </cfsavecontent>
                                            <cfscript>
                                                attributes.mail_content_to = Get_Employee_Info2.employee_email;
                                                attributes.mail_content_from = session.ep.company_email;
                                                attributes.mail_content_subject = '#paper_no# Numaralı Bütçe Aktarım Talebi Bilgilendirme';
                                                attributes.mail_content_additor = '#Get_Employee_Info2.employee_name# #Get_Employee_Info2.employee_surname#';
                                                attributes.mail_content_link = '#caller.user_domain##url_link_#';
                                                attributes.process_stage_info = attributes.process_stage;
                                                attributes.remainder = '#paper_no# Bütçe Aktarım Talebi';
                                                attributes.mail_content_info2 = message;
                                            </cfscript>
                                            <cfinclude template = "../../design/template/info_mail/mail_content.cfm">
                                            <cfset max_warning_date = attributes.record_date>
                                            <cfquery name="get_process_type" datasource="#attributes.data_source#">
                                                SELECT
                                                    P.PROCESS_ID,
                                                    P.PROCESS_NAME,
                                                    PR.PROCESS_ROW_ID,
                                                    PR.STAGE,
                                                    PR.DETAIL,
                                                    PR.ANSWER_HOUR,
                                                    PR.ANSWER_MINUTE
                                                FROM
                                                    #caller.dsn_alias#.PROCESS_TYPE P,
                                                    #caller.dsn_alias#.PROCESS_TYPE_ROWS PR
                                                WHERE
                                                    P.PROCESS_ID = PR.PROCESS_ID AND
                                                    PR.PROCESS_ROW_ID = #attributes.process_stage#
                                            </cfquery>
                                            <cfif len(get_process_type.answer_hour)>
                                                <cfset max_warning_date = caller.date_add("h", get_process_type.answer_hour, attributes.record_date)>
                                            </cfif>
                                            <cfif len(get_process_type.answer_minute)>
                                                <cfset max_warning_date = caller.date_add("n", get_process_type.answer_minute, attributes.record_date)>
                                            </cfif>
                                            <!--- Önceki aşamaları Pasif yap --->
                                        <!---  <cfquery name="UPD_WARNINGS_2" datasource="#attributes.data_source#">
                                                UPDATE #process_db#PAGE_WARNINGS SET IS_ACTIVE = 0 
                                                WHERE ACTION_TABLE = 'BUDGET_TRANSFER_DEMAND' AND ACTION_COLUMN = 'DEMAND_ID' AND ACTION_ID = #attributes.action_id# 
                                                AND OUR_COMPANY_ID = #session.ep.company_id# and PERIOD_ID = #session.ep.period_id#
                                            </cfquery> --->
                                            <!---------------------------------->
                                            <cfquery name="ADD_WARNING" datasource="#attributes.data_source#" result="GET_WARNINGS">
                                                INSERT INTO
                                                    #caller.dsn_alias#.PAGE_WARNINGS
                                                    (
                                                        URL_LINK,
                                                        WARNING_HEAD,
                                                        SETUP_WARNING_ID,
                                                        WARNING_DESCRIPTION,
                                                        SMS_WARNING_DATE,
                                                        EMAIL_WARNING_DATE,
                                                        LAST_RESPONSE_DATE,
                                                        RECORD_DATE,
                                                        IS_ACTIVE,
                                                        IS_PARENT,
                                                        RESPONSE_ID,
                                                        RECORD_IP,
                                                        RECORD_EMP,
                                                        POSITION_CODE,
                                                        WARNING_PROCESS,
                                                        OUR_COMPANY_ID,
                                                        PERIOD_ID,
                                                        ACTION_TABLE,
                                                        ACTION_COLUMN,
                                                        ACTION_ID,
                                                        ACTION_STAGE_ID,
                                                        SENDER_POSITION_CODE,
                                                        IS_CONFIRM ,
                                                        IS_REFUSE
                                                    )
                                                VALUES
                                                    (
                                                        '#url_link_wf#',
                                                        '#get_process_type.process_name# - #get_process_type.stage#',
                                                        #get_process_type.process_row_id#,
                                                        '<cfif len(get_process_type.detail)>#get_process_type.detail# - </cfif>#attributes.warning_description#',
                                                        #max_warning_date#,
                                                        #max_warning_date#,
                                                        #max_warning_date#,
                                                        #attributes.record_date#,
                                                        1,
                                                        1,
                                                        0,
                                                        '#cgi.remote_addr#',
                                                        #session.ep.userid#,
                                                        #Get_Employee_Info2.POSITION_CODE#,
                                                        1,
                                                        #session.ep.company_id#,
                                                        #session.ep.period_id#,
                                                        'BUDGET_TRANSFER_DEMAND',
                                                        'DEMAND_ID',
                                                        #attributes.action_id#,
                                                        #get_process_type.process_row_id#,
                                                        #session.ep.POSITION_CODE#,
                                                        1,
                                                        1
                                                    )
                                            </cfquery>
                                            <cfquery name="UPD_WARNINGS" datasource="#attributes.data_source#">
                                                UPDATE #process_db#PAGE_WARNINGS SET PARENT_ID = #get_warnings.IDENTITYCOL# WHERE W_ID = #get_warnings.IDENTITYCOL#			
                                            </cfquery>
                                            <cfset attributes.old_process_line = get_Process_Type_1.Line_Number><!--- süreç uyarıyı pasife çekmesin diye eklendi --->
                                        </cfif>
                                    </cfoutput>
                                </cfif>
                            <cfelse><!--- Talep Edilen birim direktörü amiri GM ise --->
                                <cfset attributes.stage_id = STAGE_ID3_1><!--- cfo sürecine al ve cfo workflow kaydı at ---> 
                                <cfset updateStage = demand.UPD_DEMAND_STAGE(action_id:attributes.action_id,stage_id : attributes.stage_id)>
                                <cffile action="write" output="#attributes.process_stage#-3-#demand_val[1]["DEMAND_EXP_CENTER"]#-#demand_val[1]["TRANSFER_EXP_CENTER"]#" file="c://p3.cfm">
                                <cfquery name="get_act" datasource="#caller.dsn2#">
                                    SELECT TOP 1 * FROM #caller.dsn_alias#.PAGE_WARNINGS 
                                    WHERE 
                                        ACTION_TABLE = 'BUDGET_TRANSFER_DEMAND' 
                                        AND ACTION_COLUMN = 'DEMAND_ID' 
                                        AND ACTION_ID = #attributes.action_id# 
                                        AND OUR_COMPANY_ID = #session.ep.company_id#
                                        and PERIOD_ID = #session.ep.period_id#
                                    ORDER BY W_ID DESC
                                </cfquery>
                                <cfif get_act.recordcount>
                                    <cfquery name="get_action" datasource="#caller.dsn2#">
                                        SELECT * FROM #caller.dsn_alias#.PAGE_WARNINGS_ACTIONS WHERE WARNING_ID = #get_act.W_ID#
                                    </cfquery>    
                                    <cfif get_action.recordcount and get_action.is_confirm eq 1>
                                        <cfset POS_CODE_butce = 625>  <!--- TEST ORTAMI admin cfo--->
                                        <cfquery name="Get_Employee_Info_cfo" datasource="#caller.dsn2#">
                                                select 
                                                ep.POSITION_CODE
                                                ,EP.EMPLOYEE_EMAIL
                                                ,EP.EMPLOYEE_NAME
                                                ,EP.EMPLOYEE_SURNAME
                                                from 
                                                    #CALLER.DSN#.EMPLOYEE_POSITIONS EP 
                                                where POSITION_CODE = #POS_CODE_butce#
                                            </cfquery>
                                            <!--- Workflow --->
                                                <cfif not isdefined('request.self')>
                                                    <cfset request.self = caller.request.self>
                                                </cfif> 
                                                <cfif isdefined("session.ep") and  isdefined("attributes.process_stage") and isdefined("attributes.action_id")>
                                                    <cfset paper_no = demand_val[1]["DEMAND_NO"]>
                                                    <cfset url_link_ = '#request.self#?fuseaction=budget.budget_transfer_demand&event=upd&demand_id=#attributes.action_id#&wrkflow=1'>
                                                    <cfset url_link_wf = '#request.self#?fuseaction=budget.budget_transfer_demand&event=upd&demand_id=#attributes.action_id#'>
                                                    <cfset attributes.process_stage = attributes.stage_id>
                                                        <cfif Get_Employee_Info_cfo.Recordcount>
                                                            <cfoutput query="Get_Employee_Info_cfo">
                                                                <cfif len(Get_Employee_Info_cfo.employee_email)>
                                                                    <cfsavecontent variable="message">
                                                                        <type="html">
                                                                                Sayın #Get_Employee_Info_cfo.employee_name# #Get_Employee_Info_cfo.employee_surname#, <br />
                                                                                Bütçe aktarım talebini kontrol ediniz<br/><br/>
                                                                                    <cfoutput>
                                                                                    <table>
                                                                                        <tr>
                                                                                            <td>
                                                                                            </td>
                                                                                            <td><b>Talep Edilen Bütçe</b>
                                                                                            </td>
                                                                                            <td><b>Aktarılan Bütçe</b>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>Masraf Merkezi
                                                                                            </td>
                                                                                            <td>#demand_val[1]["EXPENSE"]#</td>
                                                                                            <td>#demand_val[1]["TRA_EXPENSE"]#</td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>Bütçe Kalemi
                                                                                            </td>
                                                                                            <td>#demand_val[1]["EXPENSE_ITEM_NAME"]#</td>
                                                                                            <td>#demand_val[1]["TRA_EXPENSE_ITEM_NAME"]#</td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>Proje
                                                                                            </td>
                                                                                            <td>#demand_val[1]["PROJECT_HEAD"]#</td>
                                                                                            <td>#demand_val[1]["TRA_PROJECT_HEAD"]#</td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>Tutar
                                                                                            </td>
                                                                                            <td>#caller.tlformat(demand_val[1]["AMOUNT"])#</td>
                                                                                            <td></td>
                                                                                        </tr>
                                                                                    </cfoutput>
                                                                                    </table>
                                                                                    <a href="#caller.fusebox.server_machine_list#/#request.self#?fuseaction=budget.budget_transfer_demand&event=upd&demand_id==#attributes.action_id#" target="_blank">
                                                                                    Bütçe Aktarım Talebi Detay Sayfası</a> <br/><br/>
                                                                                    
                                                                                    <cf_get_lang dictionary_id='32344.Lütfen İşlemi Kontrol Ediniz!...'>
                                                                                <br />
                                                                            
                                                                    </cfsavecontent>
                                                                    <cfscript>
                                                                        attributes.mail_content_to = Get_Employee_Info_cfo.employee_email;
                                                                        attributes.mail_content_from = session.ep.company_email;
                                                                        attributes.mail_content_subject = '#paper_no# Numaralı Bütçe Aktarım Talebi Bilgilendirme';
                                                                        attributes.mail_content_additor = '#Get_Employee_Info_cfo.employee_name# #Get_Employee_Info_cfo.employee_surname#';
                                                                        attributes.mail_content_link = '#caller.user_domain##url_link_#';
                                                                        attributes.process_stage_info = attributes.process_stage;
                                                                        attributes.remainder = '#paper_no# Bütçe Aktarım Talebi';
                                                                        attributes.mail_content_info2 = message;
                                                                    </cfscript>
                                                                    <cfinclude template = "../../design/template/info_mail/mail_content.cfm">
                                                                    <cfset max_warning_date = attributes.record_date>
                                                                    <cfquery name="get_process_type" datasource="#attributes.data_source#">
                                                                        SELECT
                                                                            P.PROCESS_ID,
                                                                            P.PROCESS_NAME,
                                                                            PR.PROCESS_ROW_ID,
                                                                            PR.STAGE,
                                                                            PR.DETAIL,
                                                                            PR.ANSWER_HOUR,
                                                                            PR.ANSWER_MINUTE
                                                                        FROM
                                                                            #caller.dsn_alias#.PROCESS_TYPE P,
                                                                            #caller.dsn_alias#.PROCESS_TYPE_ROWS PR
                                                                        WHERE
                                                                            P.PROCESS_ID = PR.PROCESS_ID AND
                                                                            PR.PROCESS_ROW_ID = #attributes.process_stage#
                                                                    </cfquery>
                                                                    <cfif len(get_process_type.answer_hour)>
                                                                        <cfset max_warning_date = caller.date_add("h", get_process_type.answer_hour, attributes.record_date)>
                                                                    </cfif>
                                                                    <cfif len(get_process_type.answer_minute)>
                                                                        <cfset max_warning_date = caller.date_add("n", get_process_type.answer_minute, attributes.record_date)>
                                                                    </cfif>
                                                                    <!--- Önceki aşamaları Pasif yap --->
                                                                <!---  <cfquery name="UPD_WARNINGS_2" datasource="#attributes.data_source#">
                                                                        UPDATE #process_db#PAGE_WARNINGS SET IS_ACTIVE = 0 
                                                                        WHERE ACTION_TABLE = 'BUDGET_TRANSFER_DEMAND' AND ACTION_COLUMN = 'DEMAND_ID' AND ACTION_ID = #attributes.action_id# 
                                                                        AND OUR_COMPANY_ID = #session.ep.company_id# and PERIOD_ID = #session.ep.period_id#
                                                                    </cfquery> --->
                                                                    <!---------------------------------->
                                                                    <cfquery name="ADD_WARNING" datasource="#attributes.data_source#" result="GET_WARNINGS">
                                                                        INSERT INTO
                                                                            #caller.dsn_alias#.PAGE_WARNINGS
                                                                            (
                                                                                URL_LINK,
                                                                                WARNING_HEAD,
                                                                                SETUP_WARNING_ID,
                                                                                WARNING_DESCRIPTION,
                                                                                SMS_WARNING_DATE,
                                                                                EMAIL_WARNING_DATE,
                                                                                LAST_RESPONSE_DATE,
                                                                                RECORD_DATE,
                                                                                IS_ACTIVE,
                                                                                IS_PARENT,
                                                                                RESPONSE_ID,
                                                                                RECORD_IP,
                                                                                RECORD_EMP,
                                                                                POSITION_CODE,
                                                                                WARNING_PROCESS,
                                                                                OUR_COMPANY_ID,
                                                                                PERIOD_ID,
                                                                                ACTION_TABLE,
                                                                                ACTION_COLUMN,
                                                                                ACTION_ID,
                                                                                ACTION_STAGE_ID,
                                                                                SENDER_POSITION_CODE,
                                                                                IS_CONFIRM ,
                                                                                IS_REFUSE
                                                                            )
                                                                        VALUES
                                                                            (
                                                                                '#url_link_wf#',
                                                                                '#get_process_type.process_name# - #get_process_type.stage#',
                                                                                #get_process_type.process_row_id#,
                                                                                '<cfif len(get_process_type.detail)>#get_process_type.detail# - </cfif>#attributes.warning_description#',
                                                                                #max_warning_date#,
                                                                                #max_warning_date#,
                                                                                #max_warning_date#,
                                                                                #attributes.record_date#,
                                                                                1,
                                                                                1,
                                                                                0,
                                                                                '#cgi.remote_addr#',
                                                                                #session.ep.userid#,
                                                                                #Get_Employee_Info_cfo.POSITION_CODE#,
                                                                                1,
                                                                                #session.ep.company_id#,
                                                                                #session.ep.period_id#,
                                                                                'BUDGET_TRANSFER_DEMAND',
                                                                                'DEMAND_ID',
                                                                                #attributes.action_id#,
                                                                                #get_process_type.process_row_id#,
                                                                                #session.ep.POSITION_CODE#,
                                                                                1,
                                                                                1
                                                                            )
                                                                    </cfquery>
                                                                    <cfquery name="UPD_WARNINGS" datasource="#attributes.data_source#">
                                                                        UPDATE #process_db#PAGE_WARNINGS SET PARENT_ID = #get_warnings.IDENTITYCOL# WHERE W_ID = #get_warnings.IDENTITYCOL#			
                                                                    </cfquery>
                                                                    <cfset attributes.old_process_line = get_Process_Type_1.Line_Number><!--- süreç uyarıyı pasife çekmesin diye eklendi --->
                                                                </cfif>
                                                            </cfoutput>
                                                        </cfif>
                                        
                                                </cfif>
                                            <!--- Workflow --->   
                                    </cfif>    
                                </cfif>
                            </cfif>
                        </cfif>  
                    </cfif>
                <!--- Workflow --->
            <cfelse>
                <!--- iki masraf merkezi eşitSE  --->
                <cfset attributes.stage_id = STAGE_ID3_1><!--- cfo onayında ---> 
                <cfset updateStage = demand.UPD_DEMAND_STAGE(action_id:attributes.action_id,stage_id : attributes.stage_id)>
                <!--- Workflow --->
                    <cfif not isdefined('request.self')>
                        <cfset request.self = caller.request.self>
                    </cfif> 
                    <cfif isdefined("session.ep") and  isdefined("attributes.process_stage") and isdefined("attributes.action_id")>
                        <cfset paper_no = demand_val[1]["DEMAND_NO"]>
                        <cfset url_link_ = '#request.self#?fuseaction=budget.budget_transfer_demand&event=upd&demand_id=#attributes.action_id#&wrkflow=1'>
                        <cfset url_link_wf = '#request.self#?fuseaction=budget.budget_transfer_demand&event=upd&demand_id=#attributes.action_id#'>
                        <cffile action="write" output="#attributes.process_stage#-3-#demand_val[1]["DEMAND_EXP_CENTER"]#-#demand_val[1]["TRANSFER_EXP_CENTER"]#" file="c://p3.cfm">
                        <cfquery name="get_act" datasource="#caller.dsn2#">
                            SELECT TOP 1 * FROM #caller.dsn_alias#.PAGE_WARNINGS 
                            WHERE 
                                ACTION_TABLE = 'BUDGET_TRANSFER_DEMAND' 
                                AND ACTION_COLUMN = 'DEMAND_ID' 
                                AND ACTION_ID = #attributes.action_id# 
                                AND OUR_COMPANY_ID = #session.ep.company_id#
                                and PERIOD_ID = #session.ep.period_id#
                            ORDER BY W_ID DESC
                        </cfquery>
                        <cfif get_act.recordcount>
                            <cfquery name="get_action" datasource="#caller.dsn2#">
                                SELECT * FROM #caller.dsn_alias#.PAGE_WARNINGS_ACTIONS WHERE WARNING_ID = #get_act.W_ID#
                            </cfquery>    
                            <cfif get_action.recordcount and get_action.is_confirm eq 1>
                                <cfset POS_CODE_butce = 625>  <!--- TEST ORTAMI cfo--->
                                <cfquery name="Get_Employee_Info_cfo" datasource="#caller.dsn2#">
                                        select 
                                        ep.POSITION_CODE
                                        ,EP.EMPLOYEE_EMAIL
                                        ,EP.EMPLOYEE_NAME
                                        ,EP.EMPLOYEE_SURNAME
                                        from 
                                            #CALLER.DSN#.EMPLOYEE_POSITIONS EP 
                                        where POSITION_CODE = #POS_CODE_butce#
                                    </cfquery>
                                    <!--- Workflow --->
                                        <cfif not isdefined('request.self')>
                                            <cfset request.self = caller.request.self>
                                        </cfif> 
                                        <cfif isdefined("session.ep") and  isdefined("attributes.process_stage") and isdefined("attributes.action_id")>
                                            <cfset paper_no = demand_val[1]["DEMAND_NO"]>
                                            <cfset url_link_ = '#request.self#?fuseaction=budget.budget_transfer_demand&event=upd&demand_id=#attributes.action_id#&wrkflow=1'>
                                            <cfset url_link_wf = '#request.self#?fuseaction=budget.budget_transfer_demand&event=upd&demand_id=#attributes.action_id#'>
                                            <cfset attributes.process_stage = attributes.stage_id>
                                                <cfif Get_Employee_Info_cfo.Recordcount>
                                                    <cfoutput query="Get_Employee_Info_cfo">
                                                        <cfif len(Get_Employee_Info_cfo.employee_email)>
                                                            <cfsavecontent variable="message">
                                                                <type="html">
                                                                        Sayın #Get_Employee_Info_cfo.employee_name# #Get_Employee_Info_cfo.employee_surname#, <br />
                                                                        Bütçe aktarım talebini kontrol ediniz<br/><br/>
                                                                            <cfoutput>
                                                                            <table>
                                                                                <tr>
                                                                                    <td>
                                                                                    </td>
                                                                                    <td><b>Talep Edilen Bütçe</b>
                                                                                    </td>
                                                                                    <td><b>Aktarılan Bütçe</b>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>Masraf Merkezi
                                                                                    </td>
                                                                                    <td>#demand_val[1]["EXPENSE"]#</td>
                                                                                    <td>#demand_val[1]["TRA_EXPENSE"]#</td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>Bütçe Kalemi
                                                                                    </td>
                                                                                    <td>#demand_val[1]["EXPENSE_ITEM_NAME"]#</td>
                                                                                    <td>#demand_val[1]["TRA_EXPENSE_ITEM_NAME"]#</td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>Proje
                                                                                    </td>
                                                                                    <td>#demand_val[1]["PROJECT_HEAD"]#</td>
                                                                                    <td>#demand_val[1]["TRA_PROJECT_HEAD"]#</td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>Tutar
                                                                                    </td>
                                                                                    <td>#caller.tlformat(demand_val[1]["AMOUNT"])#</td>
                                                                                    <td></td>
                                                                                </tr>
                                                                            </cfoutput>
                                                                            </table>
                                                                            <a href="#caller.fusebox.server_machine_list#/#request.self#?fuseaction=budget.budget_transfer_demand&event=upd&demand_id==#attributes.action_id#" target="_blank">
                                                                            Bütçe Aktarım Talebi Detay Sayfası</a> <br/><br/>
                                                                            
                                                                            <cf_get_lang dictionary_id='32344.Lütfen İşlemi Kontrol Ediniz!...'>
                                                                        <br />
                                                                    
                                                            </cfsavecontent>
                                                            <cfscript>
                                                                attributes.mail_content_to = Get_Employee_Info_cfo.employee_email;
                                                                attributes.mail_content_from = session.ep.company_email;
                                                                attributes.mail_content_subject = '#paper_no# Numaralı Bütçe Aktarım Talebi Bilgilendirme';
                                                                attributes.mail_content_additor = '#Get_Employee_Info_cfo.employee_name# #Get_Employee_Info_cfo.employee_surname#';
                                                                attributes.mail_content_link = '#caller.user_domain##url_link_#';
                                                                attributes.process_stage_info = attributes.process_stage;
                                                                attributes.remainder = '#paper_no# Bütçe Aktarım Talebi';
                                                                attributes.mail_content_info2 = message;
                                                            </cfscript>
                                                            <cfinclude template = "../../design/template/info_mail/mail_content.cfm">
                                                            <cfset max_warning_date = attributes.record_date>
                                                            <cfquery name="get_process_type" datasource="#attributes.data_source#">
                                                                SELECT
                                                                    P.PROCESS_ID,
                                                                    P.PROCESS_NAME,
                                                                    PR.PROCESS_ROW_ID,
                                                                    PR.STAGE,
                                                                    PR.DETAIL,
                                                                    PR.ANSWER_HOUR,
                                                                    PR.ANSWER_MINUTE
                                                                FROM
                                                                    #caller.dsn_alias#.PROCESS_TYPE P,
                                                                    #caller.dsn_alias#.PROCESS_TYPE_ROWS PR
                                                                WHERE
                                                                    P.PROCESS_ID = PR.PROCESS_ID AND
                                                                    PR.PROCESS_ROW_ID = #attributes.process_stage#
                                                            </cfquery>
                                                            <cfif len(get_process_type.answer_hour)>
                                                                <cfset max_warning_date = caller.date_add("h", get_process_type.answer_hour, attributes.record_date)>
                                                            </cfif>
                                                            <cfif len(get_process_type.answer_minute)>
                                                                <cfset max_warning_date = caller.date_add("n", get_process_type.answer_minute, attributes.record_date)>
                                                            </cfif>
                                                            <!--- Önceki aşamaları Pasif yap --->
                                                        <!---  <cfquery name="UPD_WARNINGS_2" datasource="#attributes.data_source#">
                                                                UPDATE #process_db#PAGE_WARNINGS SET IS_ACTIVE = 0 
                                                                WHERE ACTION_TABLE = 'BUDGET_TRANSFER_DEMAND' AND ACTION_COLUMN = 'DEMAND_ID' AND ACTION_ID = #attributes.action_id# 
                                                                AND OUR_COMPANY_ID = #session.ep.company_id# and PERIOD_ID = #session.ep.period_id#
                                                            </cfquery> --->
                                                            <!---------------------------------->
                                                            <cfquery name="ADD_WARNING" datasource="#attributes.data_source#" result="GET_WARNINGS">
                                                                INSERT INTO
                                                                    #caller.dsn_alias#.PAGE_WARNINGS
                                                                    (
                                                                        URL_LINK,
                                                                        WARNING_HEAD,
                                                                        SETUP_WARNING_ID,
                                                                        WARNING_DESCRIPTION,
                                                                        SMS_WARNING_DATE,
                                                                        EMAIL_WARNING_DATE,
                                                                        LAST_RESPONSE_DATE,
                                                                        RECORD_DATE,
                                                                        IS_ACTIVE,
                                                                        IS_PARENT,
                                                                        RESPONSE_ID,
                                                                        RECORD_IP,
                                                                        RECORD_EMP,
                                                                        POSITION_CODE,
                                                                        WARNING_PROCESS,
                                                                        OUR_COMPANY_ID,
                                                                        PERIOD_ID,
                                                                        ACTION_TABLE,
                                                                        ACTION_COLUMN,
                                                                        ACTION_ID,
                                                                        ACTION_STAGE_ID,
                                                                        SENDER_POSITION_CODE,
                                                                        IS_CONFIRM ,
                                                                        IS_REFUSE
                                                                    )
                                                                VALUES
                                                                    (
                                                                        '#url_link_wf#',
                                                                        '#get_process_type.process_name# - #get_process_type.stage#',
                                                                        #get_process_type.process_row_id#,
                                                                        '<cfif len(get_process_type.detail)>#get_process_type.detail# - </cfif>#attributes.warning_description#',
                                                                        #max_warning_date#,
                                                                        #max_warning_date#,
                                                                        #max_warning_date#,
                                                                        #attributes.record_date#,
                                                                        1,
                                                                        1,
                                                                        0,
                                                                        '#cgi.remote_addr#',
                                                                        #session.ep.userid#,
                                                                        #Get_Employee_Info_cfo.POSITION_CODE#,
                                                                        1,
                                                                        #session.ep.company_id#,
                                                                        #session.ep.period_id#,
                                                                        'BUDGET_TRANSFER_DEMAND',
                                                                        'DEMAND_ID',
                                                                        #attributes.action_id#,
                                                                        #get_process_type.process_row_id#,
                                                                        #session.ep.POSITION_CODE#,
                                                                        1,
                                                                        1
                                                                    )
                                                            </cfquery>
                                                            <cfquery name="UPD_WARNINGS" datasource="#attributes.data_source#">
                                                                UPDATE #process_db#PAGE_WARNINGS SET PARENT_ID = #get_warnings.IDENTITYCOL# WHERE W_ID = #get_warnings.IDENTITYCOL#			
                                                            </cfquery>
                                                            <cfset attributes.old_process_line = get_Process_Type_1.Line_Number><!--- süreç uyarıyı pasife çekmesin diye eklendi --->
                                                        </cfif>
                                                    </cfoutput>
                                                </cfif>
                                
                                        </cfif>
                                    <!--- Workflow ---> 
                            </cfif>    
                        </cfif>               
                    </cfif>
                <!--- Workflow --->
            </cfif>
        </cfif>    
    </cfif>
<cfelseif attributes.process_stage eq STAGE_ID3_1> <!--- cfo onayında --->
    <cfif len(demand_val[1]["TRANSFER_PROJECT_ID"]) and listfind(project_cat_id_list,demand_val[1]["TRA_PROCESS_CAT"])>
        <cfset attributes.stage_id = STAGE_ID4><!--- süreci GM onayına getir wrkflow kaydı at--->
        <cfset updateStage = demand.UPD_DEMAND_STAGE(action_id:attributes.action_id,stage_id : attributes.stage_id)>
        <cffile action="write" output="#attributes.process_stage#-2-#demand_val[1]["DEMAND_EXP_CENTER"]#-#demand_val[1]["TRANSFER_EXP_CENTER"]#" file="c://p2.cfm">
        <cfquery name="get_act" datasource="#caller.dsn2#">
            SELECT TOP 1 * FROM #caller.dsn_alias#.PAGE_WARNINGS 
            WHERE 
                ACTION_TABLE = 'BUDGET_TRANSFER_DEMAND' 
                AND ACTION_COLUMN = 'DEMAND_ID' 
                AND ACTION_ID = #attributes.action_id# 
                AND OUR_COMPANY_ID = #session.ep.company_id#
                and PERIOD_ID = #session.ep.period_id#
            ORDER BY W_ID DESC
        </cfquery>
        <cfif get_act.recordcount>
            <cfquery name="get_action" datasource="#caller.dsn2#">
                SELECT * FROM #caller.dsn_alias#.PAGE_WARNINGS_ACTIONS WHERE WARNING_ID = #get_act.W_ID#
            </cfquery>
        
            <cfif get_action.recordcount and get_action.is_confirm eq 1>
                <cfset POS_CODE_CFO = 626>  <!--- TEST ORTAMI gm--->
                <cfquery name="Get_Employee_Info" datasource="#caller.dsn2#">
                        select 
                        ep.POSITION_CODE
                        ,EP.EMPLOYEE_EMAIL
                        ,EP.EMPLOYEE_NAME
                        ,EP.EMPLOYEE_SURNAME
                        from 
                            #CALLER.DSN#.EMPLOYEE_POSITIONS EP 
                        where POSITION_CODE = #POS_CODE_CFO#
                    </cfquery>
                    <!--- Workflow --->
                        <cfif not isdefined('request.self')>
                            <cfset request.self = caller.request.self>
                        </cfif> 
                        <cfif isdefined("session.ep") and  isdefined("attributes.process_stage") and isdefined("attributes.action_id")>
                            <cfset paper_no = demand_val[1]["DEMAND_NO"]>
                            <cfset url_link_ = '#request.self#?fuseaction=budget.budget_transfer_demand&event=upd&demand_id=#attributes.action_id#&wrkflow=1'>
                            <cfset url_link_wf = '#request.self#?fuseaction=budget.budget_transfer_demand&event=upd&demand_id=#attributes.action_id#'>
                            <cfset attributes.process_stage = attributes.stage_id>
                                <cfif Get_Employee_Info.Recordcount>
                                    <cfoutput query="Get_Employee_Info">
                                        <cfif len(Get_Employee_Info.employee_email)>
                                            <cfsavecontent variable="message">
                                                <type="html">
                                                        Sayın #Get_Employee_Info.employee_name# #Get_Employee_Info.employee_surname#, <br />
                                                        Bütçe aktarım talebini kontrol ediniz<br/><br/>
                                                            <cfoutput>
                                                            <table>
                                                                <tr>
                                                                    <td>
                                                                    </td>
                                                                    <td><b>Talep Edilen Bütçe</b>
                                                                    </td>
                                                                    <td><b>Aktarılan Bütçe</b>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>Masraf Merkezi
                                                                    </td>
                                                                    <td>#demand_val[1]["EXPENSE"]#</td>
                                                                    <td>#demand_val[1]["TRA_EXPENSE"]#</td>
                                                                </tr>
                                                                <tr>
                                                                    <td>Bütçe Kalemi
                                                                    </td>
                                                                    <td>#demand_val[1]["EXPENSE_ITEM_NAME"]#</td>
                                                                    <td>#demand_val[1]["TRA_EXPENSE_ITEM_NAME"]#</td>
                                                                </tr>
                                                                <tr>
                                                                    <td>Proje
                                                                    </td>
                                                                    <td>#demand_val[1]["PROJECT_HEAD"]#</td>
                                                                    <td>#demand_val[1]["TRA_PROJECT_HEAD"]#</td>
                                                                </tr>
                                                                <tr>
                                                                    <td>Tutar
                                                                    </td>
                                                                    <td>#caller.tlformat(demand_val[1]["AMOUNT"])#</td>
                                                                    <td></td>
                                                                </tr>
                                                            </cfoutput>
                                                            </table>
                                                            <a href="#caller.fusebox.server_machine_list#/#request.self#?fuseaction=budget.budget_transfer_demand&event=upd&demand_id==#attributes.action_id#" target="_blank">
                                                            Bütçe Aktarım Talebi Detay Sayfası</a> <br/><br/>
                                                            
                                                            <cf_get_lang dictionary_id='32344.Lütfen İşlemi Kontrol Ediniz!...'>
                                                        <br />
                                                    
                                            </cfsavecontent>
                                            <cfscript>
                                                attributes.mail_content_to = get_employee_info.employee_email;
                                                attributes.mail_content_from = session.ep.company_email;
                                                attributes.mail_content_subject = '#paper_no# Numaralı Bütçe Aktarım Talebi Bilgilendirme';
                                                attributes.mail_content_additor = '#Get_Employee_Info.employee_name# #Get_Employee_Info.employee_surname#';
                                                attributes.mail_content_link = '#caller.user_domain##url_link_#';
                                                attributes.process_stage_info = attributes.process_stage;
                                                attributes.remainder = '#paper_no# Bütçe Aktarım Talebi';
                                                attributes.mail_content_info2 = message;
                                            </cfscript>
                                            <cfinclude template = "../../design/template/info_mail/mail_content.cfm">
                                            <cfset max_warning_date = attributes.record_date>
                                            <cfquery name="get_process_type" datasource="#attributes.data_source#">
                                                SELECT
                                                    P.PROCESS_ID,
                                                    P.PROCESS_NAME,
                                                    PR.PROCESS_ROW_ID,
                                                    PR.STAGE,
                                                    PR.DETAIL,
                                                    PR.ANSWER_HOUR,
                                                    PR.ANSWER_MINUTE
                                                FROM
                                                    #caller.dsn_alias#.PROCESS_TYPE P,
                                                    #caller.dsn_alias#.PROCESS_TYPE_ROWS PR
                                                WHERE
                                                    P.PROCESS_ID = PR.PROCESS_ID AND
                                                    PR.PROCESS_ROW_ID = #attributes.process_stage#
                                            </cfquery>
                                            <cfif len(get_process_type.answer_hour)>
                                                <cfset max_warning_date = caller.date_add("h", get_process_type.answer_hour, attributes.record_date)>
                                            </cfif>
                                            <cfif len(get_process_type.answer_minute)>
                                                <cfset max_warning_date = caller.date_add("n", get_process_type.answer_minute, attributes.record_date)>
                                            </cfif>
                                            <!--- Önceki aşamaları Pasif yap --->
                                        <!---  <cfquery name="UPD_WARNINGS_2" datasource="#attributes.data_source#">
                                                UPDATE #process_db#PAGE_WARNINGS SET IS_ACTIVE = 0 
                                                WHERE ACTION_TABLE = 'BUDGET_TRANSFER_DEMAND' AND ACTION_COLUMN = 'DEMAND_ID' AND ACTION_ID = #attributes.action_id# 
                                                AND OUR_COMPANY_ID = #session.ep.company_id# and PERIOD_ID = #session.ep.period_id#
                                            </cfquery> --->
                                            <!---------------------------------->
                                            <cfquery name="ADD_WARNING" datasource="#attributes.data_source#" result="GET_WARNINGS">
                                                INSERT INTO
                                                    #caller.dsn_alias#.PAGE_WARNINGS
                                                    (
                                                        URL_LINK,
                                                        WARNING_HEAD,
                                                        SETUP_WARNING_ID,
                                                        WARNING_DESCRIPTION,
                                                        SMS_WARNING_DATE,
                                                        EMAIL_WARNING_DATE,
                                                        LAST_RESPONSE_DATE,
                                                        RECORD_DATE,
                                                        IS_ACTIVE,
                                                        IS_PARENT,
                                                        RESPONSE_ID,
                                                        RECORD_IP,
                                                        RECORD_EMP,
                                                        POSITION_CODE,
                                                        WARNING_PROCESS,
                                                        OUR_COMPANY_ID,
                                                        PERIOD_ID,
                                                        ACTION_TABLE,
                                                        ACTION_COLUMN,
                                                        ACTION_ID,
                                                        ACTION_STAGE_ID,
                                                        SENDER_POSITION_CODE,
                                                        IS_CONFIRM ,
                                                        IS_REFUSE
                                                    )
                                                VALUES
                                                    (
                                                        '#url_link_wf#',
                                                        '#get_process_type.process_name# - #get_process_type.stage#',
                                                        #get_process_type.process_row_id#,
                                                        '<cfif len(get_process_type.detail)>#get_process_type.detail# - </cfif>#attributes.warning_description#',
                                                        #max_warning_date#,
                                                        #max_warning_date#,
                                                        #max_warning_date#,
                                                        #attributes.record_date#,
                                                        1,
                                                        1,
                                                        0,
                                                        '#cgi.remote_addr#',
                                                        #session.ep.userid#,
                                                        #Get_Employee_Info.POSITION_CODE#,
                                                        1,
                                                        #session.ep.company_id#,
                                                        #session.ep.period_id#,
                                                        'BUDGET_TRANSFER_DEMAND',
                                                        'DEMAND_ID',
                                                        #attributes.action_id#,
                                                        #get_process_type.process_row_id#,
                                                        #session.ep.POSITION_CODE#,
                                                        1,
                                                        1
                                                    )
                                            </cfquery>
                                            <cfquery name="UPD_WARNINGS" datasource="#attributes.data_source#">
                                                UPDATE #process_db#PAGE_WARNINGS SET PARENT_ID = #get_warnings.IDENTITYCOL# WHERE W_ID = #get_warnings.IDENTITYCOL#			
                                            </cfquery>
                                            <cfset attributes.old_process_line = get_Process_Type_1.Line_Number><!--- süreç uyarıyı pasife çekmesin diye eklendi --->
                                        </cfif>
                                    </cfoutput>
                                </cfif>
                
                        </cfif>
                    <!--- Workflow --->              
            </cfif>            
        </cfif>
    <cfelse>
        <!--- iki masraf merkezi eşit DEĞILSE  --->
        <cfif demand_val[1]["TRANSFER_EXP_CENTER"] Neq demand_val[1]["DEMAND_EXP_CENTER"]>
            <!--- mail bilgilendirme --->
                <cfif not isdefined('request.self')>
                    <cfset request.self = caller.request.self>
                </cfif>                
                <cfquery name="get_act" datasource="#caller.dsn2#">
                    SELECT TOP 1 * FROM #caller.dsn_alias#.PAGE_WARNINGS 
                    WHERE 
                        ACTION_TABLE = 'BUDGET_TRANSFER_DEMAND' 
                        AND ACTION_COLUMN = 'DEMAND_ID' 
                        AND ACTION_ID = #attributes.action_id# 
                        AND OUR_COMPANY_ID = #session.ep.company_id#
                        and PERIOD_ID = #session.ep.period_id#
                    ORDER BY W_ID DESC
                </cfquery>
                <cfif get_act.recordcount>
                    <cfquery name="get_action" datasource="#caller.dsn2#">
                        SELECT * FROM #caller.dsn_alias#.PAGE_WARNINGS_ACTIONS WHERE WARNING_ID = #get_act.W_ID#
                    </cfquery>    
                    <cfif get_action.recordcount and get_action.is_confirm eq 1>
                        <cfif isdefined("session.ep") and  isdefined("attributes.process_stage") and isdefined("attributes.action_id")>
                            <cfquery name="Get_Employee_Info" datasource="#caller.dsn2#"><!--- TALEP EDİLEN MASRAF MERKEZI YETKILILERI --->
                                SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,EMPLOYEE_SURNAME,POSITION_CODE FROM #CALLER.DSN_ALIAS#.EMPLOYEE_POSITIONS WHERE 
                                POSITION_CODE IN (#demand_val[1]["RESPONSIBLE1"]#,#demand_val[1]["RESPONSIBLE2"]#,#demand_val[1]["RESPONSIBLE3"]#)
                                AND EMPLOYEE_EMAIL IS NOT NULL
                            </cfquery>
                            <cfset paper_no = demand_val[1]["DEMAND_NO"]>
                            <cfset url_link_ = '#request.self#?fuseaction=budget.budget_transfer_demand&event=upd&demand_id=#attributes.action_id#&wrkflow=1'>
                            <cfset url_link_wf = '#request.self#?fuseaction=budget.budget_transfer_demand&event=upd&demand_id=#attributes.action_id#'>
                            <cfset attributes.stage_id = STAGE_ID4_1><!---aktarım onaylandı--->
                            <cfset updateStage = demand.UPD_DEMAND_STAGE(action_id:attributes.action_id,stage_id : attributes.stage_id)>
                                <cfif Get_Employee_Info.Recordcount>
                                    <cfoutput query="Get_Employee_Info">
                                        <cfif len(Get_Employee_Info.employee_email)>
                                            <cfsavecontent variable="message">
                                                <type="html">
                                                        Sayın #Get_Employee_Info.employee_name# #Get_Employee_Info.employee_surname#, <br />
                                                        Bütçe aktarım talebini kontrol ediniz<br/><br/>
                                                            <cfoutput>
                                                            <table>
                                                                <tr>
                                                                    <td>
                                                                    </td>
                                                                    <td><b>Talep Edilen Bütçe</b>
                                                                    </td>
                                                                    <td><b>Aktarılan Bütçe</b>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>Masraf Merkezi
                                                                    </td>
                                                                    <td>#demand_val[1]["EXPENSE"]#</td>
                                                                    <td>#demand_val[1]["TRA_EXPENSE"]#</td>
                                                                </tr>
                                                                <tr>
                                                                    <td>Bütçe Kalemi
                                                                    </td>
                                                                    <td>#demand_val[1]["EXPENSE_ITEM_NAME"]#</td>
                                                                    <td>#demand_val[1]["TRA_EXPENSE_ITEM_NAME"]#</td>
                                                                </tr>
                                                                <tr>
                                                                    <td>Proje
                                                                    </td>
                                                                    <td>#demand_val[1]["PROJECT_HEAD"]#</td>
                                                                    <td>#demand_val[1]["TRA_PROJECT_HEAD"]#</td>
                                                                </tr>
                                                                <tr>
                                                                    <td>Tutar
                                                                    </td>
                                                                    <td>#caller.tlformat(demand_val[1]["AMOUNT"])#</td>
                                                                    <td></td>
                                                                </tr>
                                                            </cfoutput>
                                                            </table>
                                                            <a href="#caller.fusebox.server_machine_list#/#request.self#?fuseaction=budget.budget_transfer_demand&event=upd&demand_id==#attributes.action_id#" target="_blank">
                                                            Bütçe Aktarım Talebi Detay Sayfası</a> <br/><br/>
                                                            
                                                            <cf_get_lang dictionary_id='32344.Lütfen İşlemi Kontrol Ediniz!...'>
                                                        <br />
                                                    
                                            </cfsavecontent>
                                            <cfscript>
                                                attributes.mail_content_to = get_employee_info.employee_email;
                                                attributes.mail_content_from = session.ep.company_email;
                                                attributes.mail_content_subject = '#paper_no# Numaralı Bütçe Aktarım Talebi Bilgilendirme buradannn';
                                                attributes.mail_content_additor = '#Get_Employee_Info.employee_name# #Get_Employee_Info.employee_surname#';
                                                attributes.mail_content_link = '#caller.user_domain##url_link_#';
                                                attributes.process_stage_info = attributes.process_stage;
                                                attributes.remainder = '#paper_no# Bütçe Aktarım Talebi';
                                                attributes.mail_content_info2 = message;
                                            </cfscript>
                                            <cfinclude template = "../../design/template/info_mail/mail_content.cfm">
                                        </cfif>
                                    </cfoutput>
                                </cfif>
                        </cfif>
                    </cfif>
                </cfif>
            <!--- mail bilgilendirme --->
        <cfelse>
            <!--- iki masraf merkezi eşitSE  --->
            <cfset attributes.stage_id = STAGE_ID4_1><!---aktarım onaylandı--->
            <cfset updateStage = demand.UPD_DEMAND_STAGE(action_id:attributes.action_id,stage_id : attributes.stage_id)>
            <cfset attributes.process_stage = attributes.stage_id>
        </cfif>
    </cfif>
<cfelseif attributes.process_stage eq STAGE_ID1_> <!--- talep eden gmy onayında --->
        <cfquery name="Get_Employee_Info" datasource="#caller.dsn2#"><!--- TALEP EDİLEN MASRAF MERKEZI YETKILILERI --->
            SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,POSITION_ID ,EMPLOYEE_SURNAME,POSITION_CODE,UPPER_POSITION_CODE2,UPPER_POSITION_CODE FROM #CALLER.DSN_ALIAS#.EMPLOYEE_POSITIONS WHERE 
            POSITION_CODE IN (#demand_val[1]["RESPONSIBLE1"]#,#demand_val[1]["RESPONSIBLE2"]#,#demand_val[1]["RESPONSIBLE3"]#)
            AND EMPLOYEE_EMAIL IS NOT NULL
        </cfquery>
        <cfif listfind(pozisyon_id_list,Get_Employee_Info.POSITION_ID,',') eq 0><!--- ÇALIŞAN İSE --->
            <cfquery name="Get_Employee_Talep_Edilen" datasource="#caller.dsn2#">
                SELECT POSITION_ID FROM #CALLER.DSN#.EMPLOYEE_POSITIONS WHERE POSITION_CODE = #Get_Employee_Info.UPPER_POSITION_CODE2#
            </cfquery>
        <cfelseif listfind(pozisyon_id_sy, Get_Employee_Info.POSITION_ID,',')>
            <cfquery name="Get_Employee_Talep_Edilen" datasource="#caller.dsn2#">
                SELECT POSITION_ID FROM #CALLER.DSN#.EMPLOYEE_POSITIONS WHERE POSITION_CODE = #Get_Employee_Info.UPPER_POSITION_CODE#
            </cfquery>
        </cfif>
    <cffile action="write" output="#attributes.process_stage#-3-#demand_val[1]["DEMAND_EXP_CENTER"]#-#demand_val[1]["TRANSFER_EXP_CENTER"]#" file="c://p3.cfm">
    <cfquery name="get_act" datasource="#caller.dsn2#">
        SELECT TOP 1 * FROM #caller.dsn_alias#.PAGE_WARNINGS 
        WHERE 
            ACTION_TABLE = 'BUDGET_TRANSFER_DEMAND' 
            AND ACTION_COLUMN = 'DEMAND_ID' 
            AND ACTION_ID = #attributes.action_id# 
            AND OUR_COMPANY_ID = #session.ep.company_id#
            and PERIOD_ID = #session.ep.period_id#
        ORDER BY W_ID DESC
    </cfquery>
    <cfif get_act.recordcount>
        <cfquery name="get_action" datasource="#caller.dsn2#">
            SELECT * FROM #caller.dsn_alias#.PAGE_WARNINGS_ACTIONS WHERE WARNING_ID = #get_act.W_ID#
        </cfquery>    
        <cfif get_action.recordcount and get_action.is_confirm eq 1>
            <cfif Get_Employee_Talep_Edilen.POSITION_ID neq pozisyon_id_amir><!--- Talep Edilen birim direktörü amiri GM değil ise --->
                <cfset attributes.stage_id = STAGE_ID2_1><!--- Talep edilen gmy onayında ---> 
                <cfset updateStage = demand.UPD_DEMAND_STAGE(action_id:attributes.action_id,stage_id : attributes.stage_id)>
 		        <cfset paper_no = demand_val[1]["DEMAND_NO"]>
                <cfset url_link_ = '#request.self#?fuseaction=budget.budget_transfer_demand&event=upd&demand_id=#attributes.action_id#&wrkflow=1'>
                <cfset url_link_wf = '#request.self#?fuseaction=budget.budget_transfer_demand&event=upd&demand_id=#attributes.action_id#'>
                <cfset attributes.process_stage = attributes.stage_id>
                <cfif Get_Employee_Info2.Recordcount>
                    <cfoutput query="Get_Employee_Info2">
                        <cfif len(Get_Employee_Info2.employee_email)>
                            <cfsavecontent variable="message">
                                <type="html">
                                        Sayın #Get_Employee_Info2.employee_name# #Get_Employee_Info2.employee_surname#, <br />
                                        Bütçe aktarım talebini kontrol ediniz<br/><br/>
                                            <cfoutput>
                                            <table>
                                                <tr>
                                                    <td>
                                                    </td>
                                                    <td><b>Talep Edilen Bütçe</b>
                                                    </td>
                                                    <td><b>Aktarılan Bütçe</b>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>Masraf Merkezi
                                                    </td>
                                                    <td>#demand_val[1]["EXPENSE"]#</td>
                                                    <td>#demand_val[1]["TRA_EXPENSE"]#</td>
                                                </tr>
                                                <tr>
                                                    <td>Bütçe Kalemi
                                                    </td>
                                                    <td>#demand_val[1]["EXPENSE_ITEM_NAME"]#</td>
                                                    <td>#demand_val[1]["TRA_EXPENSE_ITEM_NAME"]#</td>
                                                </tr>
                                                <tr>
                                                    <td>Proje
                                                    </td>
                                                    <td>#demand_val[1]["PROJECT_HEAD"]#</td>
                                                    <td>#demand_val[1]["TRA_PROJECT_HEAD"]#</td>
                                                </tr>
                                                <tr>
                                                    <td>Tutar
                                                    </td>
                                                    <td>#caller.tlformat(demand_val[1]["AMOUNT"])#</td>
                                                    <td></td>
                                                </tr>
                                            </cfoutput>
                                            </table>
                                            <a href="#caller.fusebox.server_machine_list#/#request.self#?fuseaction=budget.budget_transfer_demand&event=upd&demand_id==#attributes.action_id#" target="_blank">
                                            Bütçe Aktarım Talebi Detay Sayfası</a> <br/><br/>
                                            
                                            <cf_get_lang dictionary_id='32344.Lütfen İşlemi Kontrol Ediniz!...'>
                                        <br />
                                    
                            </cfsavecontent>
                            <cfscript>
                                attributes.mail_content_to = Get_Employee_Info2.employee_email;
                                attributes.mail_content_from = session.ep.company_email;
                                attributes.mail_content_subject = '#paper_no# Numaralı Bütçe Aktarım Talebi Bilgilendirme';
                                attributes.mail_content_additor = '#Get_Employee_Info2.employee_name# #Get_Employee_Info2.employee_surname#';
                                attributes.mail_content_link = '#caller.user_domain##url_link_#';
                                attributes.process_stage_info = attributes.process_stage;
                                attributes.remainder = '#paper_no# Bütçe Aktarım Talebi';
                                attributes.mail_content_info2 = message;
                            </cfscript>
                            <cfinclude template = "../../design/template/info_mail/mail_content.cfm">
                            <cfset max_warning_date = attributes.record_date>
                            <cfquery name="get_process_type" datasource="#attributes.data_source#">
                                SELECT
                                    P.PROCESS_ID,
                                    P.PROCESS_NAME,
                                    PR.PROCESS_ROW_ID,
                                    PR.STAGE,
                                    PR.DETAIL,
                                    PR.ANSWER_HOUR,
                                    PR.ANSWER_MINUTE
                                FROM
                                    #caller.dsn_alias#.PROCESS_TYPE P,
                                    #caller.dsn_alias#.PROCESS_TYPE_ROWS PR
                                WHERE
                                    P.PROCESS_ID = PR.PROCESS_ID AND
                                    PR.PROCESS_ROW_ID = #attributes.process_stage#
                            </cfquery>
                            <cfif len(get_process_type.answer_hour)>
                                <cfset max_warning_date = caller.date_add("h", get_process_type.answer_hour, attributes.record_date)>
                            </cfif>
                            <cfif len(get_process_type.answer_minute)>
                                <cfset max_warning_date = caller.date_add("n", get_process_type.answer_minute, attributes.record_date)>
                            </cfif>
                            <!--- Önceki aşamaları Pasif yap --->
                        <!---  <cfquery name="UPD_WARNINGS_2" datasource="#attributes.data_source#">
                                UPDATE #process_db#PAGE_WARNINGS SET IS_ACTIVE = 0 
                                WHERE ACTION_TABLE = 'BUDGET_TRANSFER_DEMAND' AND ACTION_COLUMN = 'DEMAND_ID' AND ACTION_ID = #attributes.action_id# 
                                AND OUR_COMPANY_ID = #session.ep.company_id# and PERIOD_ID = #session.ep.period_id#
                            </cfquery> --->
                            <!---------------------------------->
                            <cfquery name="ADD_WARNING" datasource="#attributes.data_source#" result="GET_WARNINGS">
                                INSERT INTO
                                    #caller.dsn_alias#.PAGE_WARNINGS
                                    (
                                        URL_LINK,
                                        WARNING_HEAD,
                                        SETUP_WARNING_ID,
                                        WARNING_DESCRIPTION,
                                        SMS_WARNING_DATE,
                                        EMAIL_WARNING_DATE,
                                        LAST_RESPONSE_DATE,
                                        RECORD_DATE,
                                        IS_ACTIVE,
                                        IS_PARENT,
                                        RESPONSE_ID,
                                        RECORD_IP,
                                        RECORD_EMP,
                                        POSITION_CODE,
                                        WARNING_PROCESS,
                                        OUR_COMPANY_ID,
                                        PERIOD_ID,
                                        ACTION_TABLE,
                                        ACTION_COLUMN,
                                        ACTION_ID,
                                        ACTION_STAGE_ID,
                                        SENDER_POSITION_CODE,
                                        IS_CONFIRM ,
                                        IS_REFUSE
                                    )
                                VALUES
                                    (
                                        '#url_link_wf#',
                                        '#get_process_type.process_name# - #get_process_type.stage#',
                                        #get_process_type.process_row_id#,
                                        '<cfif len(get_process_type.detail)>#get_process_type.detail# - </cfif>#attributes.warning_description#',
                                        #max_warning_date#,
                                        #max_warning_date#,
                                        #max_warning_date#,
                                        #attributes.record_date#,
                                        1,
                                        1,
                                        0,
                                        '#cgi.remote_addr#',
                                        #session.ep.userid#,
                                        #Get_Employee_Info2.POSITION_CODE#,
                                        1,
                                        #session.ep.company_id#,
                                        #session.ep.period_id#,
                                        'BUDGET_TRANSFER_DEMAND',
                                        'DEMAND_ID',
                                        #attributes.action_id#,
                                        #get_process_type.process_row_id#,
                                        #session.ep.POSITION_CODE#,
                                        1,
                                        1
                                    )
                            </cfquery>
                            <cfquery name="UPD_WARNINGS" datasource="#attributes.data_source#">
                                UPDATE #process_db#PAGE_WARNINGS SET PARENT_ID = #get_warnings.IDENTITYCOL# WHERE W_ID = #get_warnings.IDENTITYCOL#			
                            </cfquery>
                            <cfset attributes.old_process_line = get_Process_Type_1.Line_Number><!--- süreç uyarıyı pasife çekmesin diye eklendi --->
                        </cfif>
                    </cfoutput>
                </cfif>
            <cfelse><!--- Talep Edilen birim direktörü amiri GM ise --->
                <cfset attributes.stage_id = STAGE_ID3_1><!--- cfo sürecine al ve cfo workflow kaydı at ---> 
                <cfset updateStage = demand.UPD_DEMAND_STAGE(action_id:attributes.action_id,stage_id : attributes.stage_id)>
                <cffile action="write" output="#attributes.process_stage#-3-#demand_val[1]["DEMAND_EXP_CENTER"]#-#demand_val[1]["TRANSFER_EXP_CENTER"]#" file="c://p3.cfm">
                <cfquery name="get_act" datasource="#caller.dsn2#">
                    SELECT TOP 1 * FROM #caller.dsn_alias#.PAGE_WARNINGS 
                    WHERE 
                        ACTION_TABLE = 'BUDGET_TRANSFER_DEMAND' 
                        AND ACTION_COLUMN = 'DEMAND_ID' 
                        AND ACTION_ID = #attributes.action_id# 
                        AND OUR_COMPANY_ID = #session.ep.company_id#
                        and PERIOD_ID = #session.ep.period_id#
                    ORDER BY W_ID DESC
                </cfquery>
                <cfif get_act.recordcount>
                    <cfquery name="get_action" datasource="#caller.dsn2#">
                        SELECT * FROM #caller.dsn_alias#.PAGE_WARNINGS_ACTIONS WHERE WARNING_ID = #get_act.W_ID#
                    </cfquery>    
                    <cfif get_action.recordcount and get_action.is_confirm eq 1>
                        <cfset POS_CODE_butce = 625>  <!--- TEST ORTAMI admin cfo--->
                        <cfquery name="Get_Employee_Info_cfo" datasource="#caller.dsn2#">
                            select 
                            ep.POSITION_CODE
                            ,EP.EMPLOYEE_EMAIL
                            ,EP.EMPLOYEE_NAME
                            ,EP.EMPLOYEE_SURNAME
                            from 
                                #CALLER.DSN#.EMPLOYEE_POSITIONS EP 
                            where POSITION_CODE = #POS_CODE_butce#
                        </cfquery>
                        <!--- Workflow --->
                            <cfif not isdefined('request.self')>
                                <cfset request.self = caller.request.self>
                            </cfif> 
                            <cfif isdefined("session.ep") and  isdefined("attributes.process_stage") and isdefined("attributes.action_id")>
                                <cfset paper_no = demand_val[1]["DEMAND_NO"]>
                                <cfset url_link_ = '#request.self#?fuseaction=budget.budget_transfer_demand&event=upd&demand_id=#attributes.action_id#&wrkflow=1'>
                                <cfset url_link_wf = '#request.self#?fuseaction=budget.budget_transfer_demand&event=upd&demand_id=#attributes.action_id#'>
                                <cfset attributes.process_stage = attributes.stage_id>
                                <cfif Get_Employee_Info_cfo.Recordcount>
                                    <cfoutput query="Get_Employee_Info_cfo">
                                        <cfif len(Get_Employee_Info_cfo.employee_email)>
                                            <cfsavecontent variable="message">
                                                <type="html">
                                                        Sayın #Get_Employee_Info_cfo.employee_name# #Get_Employee_Info_cfo.employee_surname#, <br />
                                                        Bütçe aktarım talebini kontrol ediniz<br/><br/>
                                                            <cfoutput>
                                                            <table>
                                                                <tr>
                                                                    <td>
                                                                    </td>
                                                                    <td><b>Talep Edilen Bütçe</b>
                                                                    </td>
                                                                    <td><b>Aktarılan Bütçe</b>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>Masraf Merkezi
                                                                    </td>
                                                                    <td>#demand_val[1]["EXPENSE"]#</td>
                                                                    <td>#demand_val[1]["TRA_EXPENSE"]#</td>
                                                                </tr>
                                                                <tr>
                                                                    <td>Bütçe Kalemi
                                                                    </td>
                                                                    <td>#demand_val[1]["EXPENSE_ITEM_NAME"]#</td>
                                                                    <td>#demand_val[1]["TRA_EXPENSE_ITEM_NAME"]#</td>
                                                                </tr>
                                                                <tr>
                                                                    <td>Proje
                                                                    </td>
                                                                    <td>#demand_val[1]["PROJECT_HEAD"]#</td>
                                                                    <td>#demand_val[1]["TRA_PROJECT_HEAD"]#</td>
                                                                </tr>
                                                                <tr>
                                                                    <td>Tutar
                                                                    </td>
                                                                    <td>#caller.tlformat(demand_val[1]["AMOUNT"])#</td>
                                                                    <td></td>
                                                                </tr>
                                                            </cfoutput>
                                                            </table>
                                                            <a href="#caller.fusebox.server_machine_list#/#request.self#?fuseaction=budget.budget_transfer_demand&event=upd&demand_id==#attributes.action_id#" target="_blank">
                                                            Bütçe Aktarım Talebi Detay Sayfası</a> <br/><br/>
                                                            
                                                            <cf_get_lang dictionary_id='32344.Lütfen İşlemi Kontrol Ediniz!...'>
                                                        <br />
                                                    
                                            </cfsavecontent>
                                            <cfscript>
                                                attributes.mail_content_to = Get_Employee_Info_cfo.employee_email;
                                                attributes.mail_content_from = session.ep.company_email;
                                                attributes.mail_content_subject = '#paper_no# Numaralı Bütçe Aktarım Talebi Bilgilendirme';
                                                attributes.mail_content_additor = '#Get_Employee_Info_cfo.employee_name# #Get_Employee_Info_cfo.employee_surname#';
                                                attributes.mail_content_link = '#caller.user_domain##url_link_#';
                                                attributes.process_stage_info = attributes.process_stage;
                                                attributes.remainder = '#paper_no# Bütçe Aktarım Talebi';
                                                attributes.mail_content_info2 = message;
                                            </cfscript>
                                            <cfinclude template = "../../design/template/info_mail/mail_content.cfm">
                                            <cfset max_warning_date = attributes.record_date>
                                            <cfquery name="get_process_type" datasource="#attributes.data_source#">
                                                SELECT
                                                    P.PROCESS_ID,
                                                    P.PROCESS_NAME,
                                                    PR.PROCESS_ROW_ID,
                                                    PR.STAGE,
                                                    PR.DETAIL,
                                                    PR.ANSWER_HOUR,
                                                    PR.ANSWER_MINUTE
                                                FROM
                                                    #caller.dsn_alias#.PROCESS_TYPE P,
                                                    #caller.dsn_alias#.PROCESS_TYPE_ROWS PR
                                                WHERE
                                                    P.PROCESS_ID = PR.PROCESS_ID AND
                                                    PR.PROCESS_ROW_ID = #attributes.process_stage#
                                            </cfquery>
                                            <cfif len(get_process_type.answer_hour)>
                                                <cfset max_warning_date = caller.date_add("h", get_process_type.answer_hour, attributes.record_date)>
                                            </cfif>
                                            <cfif len(get_process_type.answer_minute)>
                                                <cfset max_warning_date = caller.date_add("n", get_process_type.answer_minute, attributes.record_date)>
                                            </cfif>
                                            <!--- Önceki aşamaları Pasif yap --->
                                        <!---  <cfquery name="UPD_WARNINGS_2" datasource="#attributes.data_source#">
                                                UPDATE #process_db#PAGE_WARNINGS SET IS_ACTIVE = 0 
                                                WHERE ACTION_TABLE = 'BUDGET_TRANSFER_DEMAND' AND ACTION_COLUMN = 'DEMAND_ID' AND ACTION_ID = #attributes.action_id# 
                                                AND OUR_COMPANY_ID = #session.ep.company_id# and PERIOD_ID = #session.ep.period_id#
                                            </cfquery> --->
                                            <!---------------------------------->
                                            <cfquery name="ADD_WARNING" datasource="#attributes.data_source#" result="GET_WARNINGS">
                                                INSERT INTO
                                                    #caller.dsn_alias#.PAGE_WARNINGS
                                                    (
                                                        URL_LINK,
                                                        WARNING_HEAD,
                                                        SETUP_WARNING_ID,
                                                        WARNING_DESCRIPTION,
                                                        SMS_WARNING_DATE,
                                                        EMAIL_WARNING_DATE,
                                                        LAST_RESPONSE_DATE,
                                                        RECORD_DATE,
                                                        IS_ACTIVE,
                                                        IS_PARENT,
                                                        RESPONSE_ID,
                                                        RECORD_IP,
                                                        RECORD_EMP,
                                                        POSITION_CODE,
                                                        WARNING_PROCESS,
                                                        OUR_COMPANY_ID,
                                                        PERIOD_ID,
                                                        ACTION_TABLE,
                                                        ACTION_COLUMN,
                                                        ACTION_ID,
                                                        ACTION_STAGE_ID,
                                                        SENDER_POSITION_CODE,
                                                        IS_CONFIRM ,
                                                        IS_REFUSE
                                                    )
                                                VALUES
                                                    (
                                                        '#url_link_wf#',
                                                        '#get_process_type.process_name# - #get_process_type.stage#',
                                                        #get_process_type.process_row_id#,
                                                        '<cfif len(get_process_type.detail)>#get_process_type.detail# - </cfif>#attributes.warning_description#',
                                                        #max_warning_date#,
                                                        #max_warning_date#,
                                                        #max_warning_date#,
                                                        #attributes.record_date#,
                                                        1,
                                                        1,
                                                        0,
                                                        '#cgi.remote_addr#',
                                                        #session.ep.userid#,
                                                        #Get_Employee_Info_cfo.POSITION_CODE#,
                                                        1,
                                                        #session.ep.company_id#,
                                                        #session.ep.period_id#,
                                                        'BUDGET_TRANSFER_DEMAND',
                                                        'DEMAND_ID',
                                                        #attributes.action_id#,
                                                        #get_process_type.process_row_id#,
                                                        #session.ep.POSITION_CODE#,
                                                        1,
                                                        1
                                                    )
                                            </cfquery>
                                            <cfquery name="UPD_WARNINGS" datasource="#attributes.data_source#">
                                                UPDATE #process_db#PAGE_WARNINGS SET PARENT_ID = #get_warnings.IDENTITYCOL# WHERE W_ID = #get_warnings.IDENTITYCOL#			
                                            </cfquery>
                                            <cfset attributes.old_process_line = get_Process_Type_1.Line_Number><!--- süreç uyarıyı pasife çekmesin diye eklendi --->
                                        </cfif>
                                    </cfoutput>
                                </cfif>                                        
                            </cfif>
                        <!--- Workflow --->   
                    </cfif>    
                </cfif>
            </cfif>
        </cfif>    
    </cfif>
<cfelseif attributes.process_stage eq STAGE_ID2_1> <!--- talep edilen gmy onayında --->
    <cfset attributes.stage_id = STAGE_ID3_1><!--- cfo sürecine al ve cfo workflow kaydı at ---> 
    <cfset updateStage = demand.UPD_DEMAND_STAGE(action_id:attributes.action_id,stage_id : attributes.stage_id)>
    <cffile action="write" output="#attributes.process_stage#-3-#demand_val[1]["DEMAND_EXP_CENTER"]#-#demand_val[1]["TRANSFER_EXP_CENTER"]#" file="c://p8.cfm">
    <cfquery name="get_act" datasource="#caller.dsn2#">
        SELECT TOP 1 * FROM #caller.dsn_alias#.PAGE_WARNINGS 
        WHERE 
            ACTION_TABLE = 'BUDGET_TRANSFER_DEMAND' 
            AND ACTION_COLUMN = 'DEMAND_ID' 
            AND ACTION_ID = #attributes.action_id# 
            AND OUR_COMPANY_ID = #session.ep.company_id#
            and PERIOD_ID = #session.ep.period_id#
        ORDER BY W_ID DESC
    </cfquery>
    <cfif get_act.recordcount>
        <cfquery name="get_action" datasource="#caller.dsn2#">
            SELECT * FROM #caller.dsn_alias#.PAGE_WARNINGS_ACTIONS WHERE WARNING_ID = #get_act.W_ID#
        </cfquery>    
        <cfif get_action.recordcount and get_action.is_confirm eq 1>
            <cfset POS_CODE_butce = 625>  <!--- TEST ORTAMI admin cfo--->
            <cfquery name="Get_Employee_Info_cfo" datasource="#caller.dsn2#">
                select 
                ep.POSITION_CODE
                ,EP.EMPLOYEE_EMAIL
                ,EP.EMPLOYEE_NAME
                ,EP.EMPLOYEE_SURNAME
                from 
                    #CALLER.DSN#.EMPLOYEE_POSITIONS EP 
                where POSITION_CODE = #POS_CODE_butce#
            </cfquery>
            <!--- Workflow --->
                <cfif not isdefined('request.self')>
                    <cfset request.self = caller.request.self>
                </cfif> 
                <cfif isdefined("session.ep") and  isdefined("attributes.process_stage") and isdefined("attributes.action_id")>
                    <cfset paper_no = demand_val[1]["DEMAND_NO"]>
                    <cfset url_link_ = '#request.self#?fuseaction=budget.budget_transfer_demand&event=upd&demand_id=#attributes.action_id#&wrkflow=1'>
                    <cfset url_link_wf = '#request.self#?fuseaction=budget.budget_transfer_demand&event=upd&demand_id=#attributes.action_id#'>
                    <cfset attributes.process_stage = attributes.stage_id>
                    <cfif Get_Employee_Info_cfo.Recordcount>
                        <cfoutput query="Get_Employee_Info_cfo">
                                <cfset max_warning_date = attributes.record_date>
                                <cfquery name="get_process_type" datasource="#attributes.data_source#">
                                    SELECT
                                        P.PROCESS_ID,
                                        P.PROCESS_NAME,
                                        PR.PROCESS_ROW_ID,
                                        PR.STAGE,
                                        PR.DETAIL,
                                        PR.ANSWER_HOUR,
                                        PR.ANSWER_MINUTE
                                    FROM
                                        #caller.dsn_alias#.PROCESS_TYPE P,
                                        #caller.dsn_alias#.PROCESS_TYPE_ROWS PR
                                    WHERE
                                        P.PROCESS_ID = PR.PROCESS_ID AND
                                        PR.PROCESS_ROW_ID = #attributes.process_stage#
                                </cfquery>
                                <cfif len(get_process_type.answer_hour)>
                                    <cfset max_warning_date = caller.date_add("h", get_process_type.answer_hour, attributes.record_date)>
                                </cfif>
                                <cfif len(get_process_type.answer_minute)>
                                    <cfset max_warning_date = caller.date_add("n", get_process_type.answer_minute, attributes.record_date)>
                                </cfif>
                                <cfquery name="ADD_WARNING" datasource="#attributes.data_source#" result="GET_WARNINGS">
                                    INSERT INTO
                                        #caller.dsn_alias#.PAGE_WARNINGS
                                        (
                                            URL_LINK,
                                            WARNING_HEAD,
                                            SETUP_WARNING_ID,
                                            WARNING_DESCRIPTION,
                                            SMS_WARNING_DATE,
                                            EMAIL_WARNING_DATE,
                                            LAST_RESPONSE_DATE,
                                            RECORD_DATE,
                                            IS_ACTIVE,
                                            IS_PARENT,
                                            RESPONSE_ID,
                                            RECORD_IP,
                                            RECORD_EMP,
                                            POSITION_CODE,
                                            WARNING_PROCESS,
                                            OUR_COMPANY_ID,
                                            PERIOD_ID,
                                            ACTION_TABLE,
                                            ACTION_COLUMN,
                                            ACTION_ID,
                                            ACTION_STAGE_ID,
                                            SENDER_POSITION_CODE,
                                            IS_CONFIRM ,
                                            IS_REFUSE
                                        )
                                    VALUES
                                        (
                                            '#url_link_wf#',
                                            '#get_process_type.process_name# - #get_process_type.stage#',
                                            #get_process_type.process_row_id#,
                                            '<cfif len(get_process_type.detail)>#get_process_type.detail# - </cfif>#attributes.warning_description#',
                                            #max_warning_date#,
                                            #max_warning_date#,
                                            #max_warning_date#,
                                            #attributes.record_date#,
                                            1,
                                            1,
                                            0,
                                            '#cgi.remote_addr#',
                                            #session.ep.userid#,
                                            #Get_Employee_Info_cfo.POSITION_CODE#,
                                            1,
                                            #session.ep.company_id#,
                                            #session.ep.period_id#,
                                            'BUDGET_TRANSFER_DEMAND',
                                            'DEMAND_ID',
                                            #attributes.action_id#,
                                            #get_process_type.process_row_id#,
                                            #session.ep.POSITION_CODE#,
                                            1,
                                            1
                                        )
                                </cfquery>
                                <cfquery name="UPD_WARNINGS" datasource="#attributes.data_source#">
                                    UPDATE #process_db#PAGE_WARNINGS SET PARENT_ID = #get_warnings.IDENTITYCOL# WHERE W_ID = #get_warnings.IDENTITYCOL#			
                                </cfquery>
                                <cfset attributes.old_process_line = get_Process_Type_1.Line_Number><!--- süreç uyarıyı pasife çekmesin diye eklendi --->
                        </cfoutput>
                    </cfif>                                        
                </cfif>
            <!--- Workflow --->   
        </cfif>    
    </cfif>
</cfif>
