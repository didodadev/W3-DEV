<cf_xml_page_edit fuseact="account.list_account_card_rows">
<cfsetting showdebugoutput="no">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.acc_code1_1" default="">
<cfparam name="attributes.acc_code2_1" default="">
<cfparam name="attributes.acc_code1_2" default="">
<cfparam name="attributes.acc_code2_2" default="">
<cfparam name="attributes.acc_code1_3" default="">
<cfparam name="attributes.acc_code2_3" default="">
<cfparam name="attributes.acc_code1_4" default="">
<cfparam name="attributes.acc_code2_4" default="">
<cfparam name="attributes.acc_code1_5" default="">
<cfparam name="attributes.acc_code2_5" default="">
<cfparam name="attributes.is_system_money_2" default="0">
<cfparam name="attributes.other_money_based" default="0">
<cfparam name="attributes.form_is_submitted" default="0">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.acc_card_type" default="">
<cfparam name="attributes.acc_code_type" default="0">
<cfparam name="attributes.is_excel" default="0">
<cfparam name="attributes.is_quantity" default="0">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.is_acc_with_action" default="0">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.is_sub_project" default="">
<cfparam name="attributes.date1" default="01#dateformat(now(),'/mm/yyyy')#">
<cfparam name="attributes.date2" default="#daysinmonth(now())##dateformat(now(),'/mm/yyyy')#">
<cfif not (isDefined("attributes.form_is_submitted") and attributes.form_is_submitted eq 1)>
	<cfparam name="attributes.is_carryforward" default="1">
</cfif>
<cfquery name="GET_BRANCHES" datasource="#DSN#">
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
        AND COMP_ID = #session.ep.company_id#
    ORDER BY
        OUR_COMPANY.NICK_NAME,
        BRANCH.BRANCH_NAME
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box> 
        <cfform name="form" action="" method="post">
            <input type="hidden" name="form_is_submitted" id="form_is_submitted" value="1">
            <cf_box_search>
                <div class="form-group">
                    <label class="col col-3 col-md-3 col-sm-12 col-xs-12"><cf_get_lang dictionary_id ='58811.Muhasebe Kodu'>*</label>
                    <cf_wrk_multi_account_code acc_code1_1='#attributes.acc_code1_1#' acc_code2_1='#attributes.acc_code2_1#' acc_code1_2='#attributes.acc_code1_2#' acc_code2_2='#attributes.acc_code2_2#' acc_code1_3='#attributes.acc_code1_3#' acc_code2_3='#attributes.acc_code2_3#' acc_code1_4='#attributes.acc_code1_4#' acc_code2_4='#attributes.acc_code2_4#' acc_code1_5='#attributes.acc_code1_5#' acc_code2_5='#attributes.acc_code2_5#' is_multi='#is_select_multi_acc_code#' is_name='#is_select_name#'>
                    <!--- is_multi='#is_select_multi_acc_code#' is_name='#is_select_name#' --->					
                </div>
                <div class="form-group">
                    <div class="input-group large">
                        <cfinput type="text" name="date1" maxlength="10" value="#attributes.date1#" required="yes" validate="#validate_style#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
                    </div>
                </div>
                <div class="form-group large">
                    <div class="input-group">
                        <cfinput type="text" name="date2" maxlength="10" value="#attributes.date2#" required="yes" validate="#validate_style#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span>
                    </div>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" style="width:20px;" message="#message#" value="#attributes.maxrows#" validate="integer" range="1,250" onKeyUp="isNumber(this)" required="yes">
                </div>
                <div class="form-group">
                    <label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button search_function='input_control()' button_type="4">
                </div>
            </cf_box_search>
            <cf_box_search_detail>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-acc_card_type">
                        <label class="col col-12"><cfoutput>#getLang(86,'Fiş Türü',47348)#​</cfoutput></label>
                        <div class="col col-12">
                            <cfquery name="get_acc_card_type" datasource="#dsn3#">
                                SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (10,11,12,13,14,19) ORDER BY PROCESS_TYPE
                            </cfquery>
                            <cf_multiselect_check
                                name="acc_card_type"
                                option_name="process_cat"
                                option_value="process_type-process_cat_id"
                                value="#attributes.acc_card_type#"
                                query_name="get_acc_card_type">
                        </div>                 
                    </div>
                    <div class="form-group" id="item-branch_id">
                        <label class="col col-12"><cfoutput>#getLang(41,'Şube',57453)#​</cfoutput></label>
                        <div class="col col-12">
                            <select name="branch_id" id="branch_id" onChange="showDepartment(this.value)" style="width:120px;">
                                <option value=""><cfoutput>#getLang(322,'Seçiniz',57734)#​</cfoutput></option>
                                <cfoutput query="get_branches" group="NICK_NAME">
                                    <optgroup label="#NICK_NAME#"></optgroup>
                                    <cfoutput>
                                        <option value="#BRANCH_ID#"<cfif isdefined("attributes.branch_id") and (attributes.branch_id eq branch_id)> selected</cfif>>#BRANCH_NAME#</option>
                                    </cfoutput>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-department">
                        <label class="col col-12"><cfoutput>#getLang(160,'Departman',57572)#​</cfoutput></label>
                        <div class="col col-12">
                            <select name="department" id="department" style="width:120px;">
                                <option value=""><cfoutput>#getLang(322,'Seçiniz',57734)#​</cfoutput></option>
                                <cfif isdefined('attributes.branch_id') and isnumeric(attributes.branch_id)>
                                    <cfquery name="GET_DEPARTMANT" datasource="#DSN#">
                                        SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_STATUS = 1 AND BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> ORDER BY DEPARTMENT_HEAD
                                    </cfquery>
                                    <cfoutput query="get_departmant">
                                        <option value="#department_id#"<cfif isdefined('attributes.department') and (attributes.department eq get_departmant.department_id)>selected</cfif>>#department_head#</option>
                                    </cfoutput>
                                </cfif>
                            </select>
                        </div>
                    </div>                
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-project_id">
                        <label class="col col-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                        <div class="col col-12">
                            <cfif isdefined('attributes.project_head') and len(attributes.project_head)>
                                <cfset project_id_ = attributes.project_id>
                            <cfelse>
                                <cfset project_id_ = ''>
                            </cfif>
                            <cf_wrkProject
                                project_Id="#project_id_#"
                                width="120"
                                AgreementNo="1" Customer="2" Employee="3" Priority="4" Stage="5" allproject="1" formname="form"
                                boxwidth="600"
                                boxheight="400">
                        </div>
                    </div>
                    <div class="form-group" id="item-acc_code_type">
                        <label class="col col-12"><cfoutput>#getLang(647,'Düzenleme Tipi',37658)#</cfoutput></label>
                        <div class="col col-12">
                                <select name="acc_code_type" id="acc_code_type">
                                <option value="0" <cfif attributes.acc_code_type eq 0>selected</cfif>><cf_get_lang dictionary_id='58793.Tek Düzen'></option>
                                <option value="1" <cfif attributes.acc_code_type eq 1>selected</cfif>><cf_get_lang dictionary_id='58308.UFRS'></option>
                            </select>
                        </div>
                    </div>        
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-is_system_money_2">
                        <label><input type="checkbox" name="is_system_money_2" id="is_system_money_2" value="1" <cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>checked</cfif>><cfoutput>#session.ep.money2#</cfoutput><cf_get_lang dictionary_id ='58601.Bazında'></label>
                    </div>
                    <div class="form-group" id="item-is_acc_with_action">
                        <label><input type="checkbox" name="is_acc_with_action" id="is_acc_with_action" value="1" <cfif attributes.is_acc_with_action eq 1>checked</cfif>><cf_get_lang dictionary_id ='47457.Hareketi Olmayan Hesapları Getirme'></label>
                    </div>
                    <div class="form-group" id="item-is_carryforward">
                        <label><input type="checkbox" name="is_carryforward" id="is_carryforward" value="1" <cfif isDefined('attributes.is_carryforward') and attributes.is_carryforward eq 1>checked</cfif>><cf_get_lang dictionary_id ='59200.Devreden Bakiyeli'></label>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                    <div class="form-group" id="item-other_money_based">
                        <label><input type="checkbox" name="other_money_based" id="other_money_based" value="1" <cfif isdefined('attributes.other_money_based') and attributes.other_money_based eq 1>checked</cfif>><cf_get_lang dictionary_id ='58121.İşlem Dövizi'><cf_get_lang dictionary_id ='58601.Bazında'></label>
                    </div>
                    <div class="form-group" id="item-is_quantity">
                        <label><input type="checkbox" name="is_quantity" id="is_quantity" value="1" <cfif attributes.is_quantity eq 1>checked</cfif>><cf_get_lang dictionary_id='47527.Miktar Goster'></label>
                    </div>
                    <div class="form-group" id="item-is_sub_project">
                        <label><input type="checkbox" name="is_sub_project" id="is_sub_project" value="1" <cfif attributes.is_sub_project eq 1>checked</cfif>><cf_get_lang dictionary_id="47564.Alt Projeleri Getir"></label>
                    </div>
                </div>
            </cf_box_search_detail>
        </cfform>
    </cf_box>
    <cfif isDefined("attributes.form_is_submitted") and attributes.form_is_submitted eq 1>
        <cf_date tarih="attributes.date1">
        <cf_date tarih="attributes.date2">
        
        <cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
        <cfset endrow = attributes.maxrows+attributes.startrow - 1 >
        <cfquery name="getMuavin" datasource="#dsn2#">
            WITH CTE1 AS (
                SELECT
                    ACCOUNT_CODE,
                    ACCOUNT_NAME,
                    IFRS_CODE,
                    IFRS_NAME,
                    ROW_NUMBER() OVER (ORDER BY ACCOUNT_CODE) AS ACC_ROWNUM
                FROM
                    ACCOUNT_PLAN
                WHERE
                    1 = 1
                    AND SUB_ACCOUNT = 0
                    <cfif (isDefined("attributes.acc_code1_1") and len(evaluate("attributes.acc_code1_1"))) or (isDefined("attributes.acc_code1_2") and len(evaluate("attributes.acc_code1_2"))) or (isDefined("attributes.acc_code1_3") and len(evaluate("attributes.acc_code1_3"))) or (isDefined("attributes.acc_code1_4") and len(evaluate("attributes.acc_code1_4"))) or (isDefined("attributes.acc_code1_5") and len(evaluate("attributes.acc_code1_5")))>
                    AND 
                    (
                        <cfloop from="1" to="5" index="kk">
                            <cfif kk neq 1>OR</cfif>
                            (
                                1 = 0
                                <cfif (isDefined("attributes.acc_code1_#kk#") and len(evaluate("attributes.acc_code1_#kk#"))) or (isDefined("attributes.acc_code2_#kk#") and len(evaluate("attributes.acc_code2_#kk#")))>
                                    OR
                                    (
                                        1 = 1
                                        <cfif isDefined("attributes.acc_code1_#kk#") and len(evaluate("attributes.acc_code1_#kk#"))>
                                            <cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
                                                AND ACCOUNT_CODE >= '#evaluate("attributes.acc_code1_#kk#")#'
                                            <cfelse>
                                                AND ACCOUNT_CODE >= '#evaluate("attributes.acc_code1_#kk#")#'
                                            </cfif>
                                        </cfif>
                                        <cfif isDefined("attributes.acc_code2_#kk#") and len(evaluate("attributes.acc_code2_#kk#"))>
                                            <cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
                                                AND ACCOUNT_CODE <= '#evaluate("attributes.acc_code2_#kk#")#'
                                            <cfelse>
                                                AND ACCOUNT_CODE <= '#evaluate("attributes.acc_code2_#kk#")#'
                                            </cfif>
                                        </cfif>
                                    )
                                </cfif>
                            )
                        </cfloop>
                        )
                    </cfif>
            ),
            CTE2 AS (
                SELECT
                    ACR.CARD_ROW_ID,
                    ACR.ACCOUNT_ID ACCOUNT_CODE,
                    AC.CARD_ID,
                    ACR.AMOUNT,
                    ACR.AMOUNT_2,
                    ACR.OTHER_AMOUNT,
                    ACR.OTHER_CURRENCY,
                    ACR.QUANTITY,
                    ACR.BA,
                    AC.ACTION_DATE,
                    AC.BILL_NO,
                    AC.CARD_TYPE_NO,
                    AC.CARD_TYPE,
                    AC.PAPER_NO,
                    AC.ACTION_TYPE,
                    AC.ACTION_ID,
                    ACR.DETAIL,
                    ACR.ACC_PROJECT_ID,
                    ACR.ACC_BRANCH_ID,
                    ACR.ACC_DEPARTMENT_ID,
                    AC.ACC_COMPANY_ID,
                    AC.ACC_CONSUMER_ID,
                    AC.ACC_EMPLOYEE_ID
                FROM
                    <cfif attributes.acc_code_type eq 1>
                        ACCOUNT_ROWS_IFRS ACR
                    <cfelse>
                        ACCOUNT_CARD_ROWS ACR
                    </cfif>
                        LEFT JOIN ACCOUNT_CARD AC ON AC.CARD_ID = ACR.CARD_ID
                        LEFT JOIN #dsn_alias#.PRO_PROJECTS PP ON PP.PROJECT_ID = ACR.ACC_PROJECT_ID
                WHERE
                    <cfif not (isDefined('attributes.is_carryforward') and attributes.is_carryforward eq 1)>AC.ACTION_DATE >= #attributes.date1# AND </cfif>
                    AC.ACTION_DATE <= #attributes.date2# 
                <cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)>
                    AND
                    (
                        1 = 0
                        <cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
                            OR (AC.CARD_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(type_ii,'-')#"> AND AC.CARD_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(type_ii,'-')#">)
                        </cfloop>
                    )
                </cfif>
                <cfif isdefined('attributes.project_head') and len(attributes.project_head) and len(attributes.project_id)>
                    <cfif attributes.is_sub_project eq 1>
                        AND ACR.ACC_PROJECT_ID = #attributes.project_id# OR PP.RELATED_PROJECT_ID = #attributes.project_id#
                    <cfelse>
                        <cfif len(attributes.project_head) and attributes.project_id eq -1>
                            AND ACR.ACC_PROJECT_ID IS NULL
                        <cfelseif len(attributes.project_head) and attributes.project_id eq -2>
                            AND ACR.ACC_PROJECT_ID IS NOT NULL AND ACR.ACC_PROJECT_ID <> -1
                        <cfelse>
                            AND ACR.ACC_PROJECT_ID = #attributes.project_id#
                        </cfif>
                    </cfif>
                </cfif>
                <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
                    AND ACR.ACC_BRANCH_ID = #attributes.branch_id#
                </cfif>
                <cfif isdefined("attributes.department") and len(attributes.department)>
                    AND ACR.ACC_DEPARTMENT_ID = #attributes.department#
                </cfif>
            ),
            CTE3 AS (
                SELECT
                    SUM(CTE2.AMOUNT * (1 - CTE2.BA) * (CASE WHEN ACTION_DATE < #attributes.date1# THEN 1 ELSE 0 END)) DEV_BORC,
                    SUM(CTE2.AMOUNT * CTE2.BA * (CASE WHEN ACTION_DATE < #attributes.date1# THEN 1 ELSE 0 END)) DEV_ALACAK,
                    SUM(CTE2.AMOUNT * (1 - (2 * CTE2.BA)) * (CASE WHEN ACTION_DATE < #attributes.date1# THEN 1 ELSE 0 END)) DEV_BAKIYE,
                    SUM(CTE2.AMOUNT_2 * (1 - CTE2.BA) * (CASE WHEN ACTION_DATE < #attributes.date1# THEN 1 ELSE 0 END)) DEV_BORC2,
                    SUM(CTE2.AMOUNT_2 * CTE2.BA * (CASE WHEN ACTION_DATE < #attributes.date1# THEN 1 ELSE 0 END)) DEV_ALACAK2,
                    SUM(CTE2.AMOUNT_2 * (1 - (2 * CTE2.BA)) * (CASE WHEN ACTION_DATE < #attributes.date1# THEN 1 ELSE 0 END)) DEV_BAKIYE2,
                    SUM(CTE2.AMOUNT * (1 - CTE2.BA)) TOTAL_BORC,
                    SUM(CTE2.AMOUNT * CTE2.BA) TOTAL_ALACAK,
                    SUM(CTE2.AMOUNT * (1 - (2 * CTE2.BA))) TOTAL_BAKIYE,
                    SUM(CTE2.AMOUNT_2 * (1 - CTE2.BA)) TOTAL_BORC2,
                    SUM(CTE2.AMOUNT_2 * CTE2.BA) TOTAL_ALACAK2,
                    SUM(CTE2.AMOUNT_2 * (1 - (2 * CTE2.BA))) TOTAL_BAKIYE2,
                    SUM(CASE WHEN ACTION_DATE BETWEEN  #attributes.date1# AND #attributes.date2# THEN CTE2.QUANTITY ELSE 0 END) MIKTAR,
                    CTE2.ACCOUNT_CODE
                FROM
                    CTE2
                GROUP BY
                    CTE2.ACCOUNT_CODE
            ),
            CTE5 AS (
                SELECT
                    SUM(OTHER_AMOUNT * (1 - CTE2.BA) * (CASE WHEN ACTION_DATE < #attributes.date1# THEN 1 ELSE 0 END)) DEV_OTHER_BORC,
                    SUM(OTHER_AMOUNT * CTE2.BA * (CASE WHEN ACTION_DATE < #attributes.date1# THEN 1 ELSE 0 END)) DEV_OTHER_ALACAK,
                    SUM(OTHER_AMOUNT * (1 - 2 * CTE2.BA) * (CASE WHEN ACTION_DATE < #attributes.date1# THEN 1 ELSE 0 END)) DEV_OTHER_BAKIYE,
                    SUM(OTHER_AMOUNT * (1 - CTE2.BA)) TOTAL_OTHER_BORC,
                    SUM(OTHER_AMOUNT * CTE2.BA) TOTAL_OTHER_ALACAK,
                    SUM(OTHER_AMOUNT * (1 - 2 * CTE2.BA)) TOTAL_OTHER_BAKIYE,
                    ACCOUNT_CODE,
                    OTHER_CURRENCY
                FROM
                    CTE2
                GROUP BY
                    ACCOUNT_CODE,
                    OTHER_CURRENCY
            ),
            CTE4 AS (
                SELECT
                    CTE2.CARD_ROW_ID,
                    <cfif attributes.acc_code_type eq 1>
                        CTE1.IFRS_CODE ACCOUNT_CODE,
                        CTE1.IFRS_NAME ACCOUNT_NAME,
                    <cfelse>
                        CTE1.ACCOUNT_CODE,
                        CTE1.ACCOUNT_NAME,                
                    </cfif>
                    ISNULL(CTE3.DEV_BORC,0) DEV_BORC,
                    ISNULL(CTE3.DEV_ALACAK,0) DEV_ALACAK,
                    ISNULL(CTE3.DEV_BAKIYE,0) DEV_BAKIYE,
                    ISNULL(CTE3.TOTAL_BORC,0) TOTAL_BORC,
                    ISNULL(CTE3.TOTAL_ALACAK,0) TOTAL_ALACAK,
                    ISNULL(CTE3.TOTAL_BAKIYE,0) TOTAL_BAKIYE,
                    ISNULL(CTE3.DEV_BORC2,0) DEV_BORC2,
                    ISNULL(CTE3.DEV_ALACAK2,0) DEV_ALACAK2,
                    ISNULL(CTE3.DEV_BAKIYE2,0) DEV_BAKIYE2,
                    ISNULL(CTE3.TOTAL_BORC2,0) TOTAL_BORC2,
                    ISNULL(CTE3.TOTAL_ALACAK2,0) TOTAL_ALACAK2,
                    ISNULL(CTE3.TOTAL_BAKIYE2,0) TOTAL_BAKIYE2,
                    ISNULL(CTE3.MIKTAR,0) TOTAL_MIKTAR,
                    STUFF((SELECT '!' + CONVERT(VARCHAR(100), CAST(DEV_OTHER_BORC AS DECIMAL(38,2))) FROM CTE5 WHERE CTE5.ACCOUNT_CODE = CTE2.ACCOUNT_CODE FOR XML PATH ('')),1,1,'') DEV_OTHER_BORC,
                    STUFF((SELECT '!' + CONVERT(VARCHAR(100), CAST(DEV_OTHER_ALACAK AS DECIMAL(38,2))) FROM CTE5 WHERE CTE5.ACCOUNT_CODE = CTE2.ACCOUNT_CODE FOR XML PATH ('')),1,1,'') DEV_OTHER_ALACAK,
                    STUFF((SELECT '!' + CONVERT(VARCHAR(100), CAST(DEV_OTHER_BAKIYE AS DECIMAL(38,2))) FROM CTE5 WHERE CTE5.ACCOUNT_CODE = CTE2.ACCOUNT_CODE FOR XML PATH ('')),1,1,'') DEV_OTHER_BAKIYE,
                    STUFF((SELECT '!' + CONVERT(VARCHAR(100), CAST(TOTAL_OTHER_BORC AS DECIMAL(38,2))) FROM CTE5 WHERE CTE5.ACCOUNT_CODE = CTE2.ACCOUNT_CODE FOR XML PATH ('')),1,1,'') TOTAL_OTHER_BORC,
                    STUFF((SELECT '!' + CONVERT(VARCHAR(100), CAST(TOTAL_OTHER_ALACAK AS DECIMAL(38,2))) FROM CTE5 WHERE CTE5.ACCOUNT_CODE = CTE2.ACCOUNT_CODE FOR XML PATH ('')),1,1,'') TOTAL_OTHER_ALACAK,
                    STUFF((SELECT '!' + CONVERT(VARCHAR(100), CAST(TOTAL_OTHER_BAKIYE AS DECIMAL(38,2))) FROM CTE5 WHERE CTE5.ACCOUNT_CODE = CTE2.ACCOUNT_CODE FOR XML PATH ('')),1,1,'') TOTAL_OTHER_BAKIYE,
                    STUFF((SELECT '!' + OTHER_CURRENCY FROM CTE5 WHERE CTE5.ACCOUNT_CODE = CTE2.ACCOUNT_CODE FOR XML PATH ('')),1,1,'') ALL_OTHER_CURRENCY,
                    CTE2.ACTION_DATE,
                    CTE2.BILL_NO,
                    CTE2.CARD_TYPE_NO,
                    (CASE CTE2.CARD_TYPE WHEN 10 THEN 'AÇILIŞ' WHEN 11 THEN 'TAHSİL' WHEN 12 THEN 'TEDİYE' WHEN 13 THEN 'MAHSUP' WHEN 14 THEN 'ÖZEL FİŞ' WHEN 19 THEN 'KAPANIŞ' ELSE '' END) CARD_TYPE_NAME,
                    CTE2.PAPER_NO,
                    CTE2.DETAIL,
                    CTE2.BA,
                    CTE2.ACTION_TYPE,
                    CTE2.ACTION_ID,
                    CTE2.ACC_COMPANY_ID,
                    CTE2.ACC_CONSUMER_ID,
                    ISNULL(CTE2.AMOUNT,0) AMOUNT,
                    ISNULL(CTE2.AMOUNT_2,0) AMOUNT_2,
                    OTHER_AMOUNT,
                    CTE2.OTHER_CURRENCY,
                    QUANTITY,
                    CTE2.CARD_ID,
                    DENSE_RANK() OVER (ORDER BY CTE1.ACC_ROWNUM) ACC_ROWNUM,
                    PP.PROJECT_HEAD,
                    B.BRANCH_NAME,
                    D.DEPARTMENT_HEAD,
                    CASE WHEN CTE2.ACC_COMPANY_ID IS NOT NULL THEN 'comp' WHEN CTE2.ACC_CONSUMER_ID IS NOT NULL THEN 'cons' WHEN CTE2.ACC_EMPLOYEE_ID IS NOT NULL THEN 'emp' ELSE '' END AS MEMBER_TYPE,
                    ISNULL(CTE2.ACC_COMPANY_ID,ISNULL(CTE2.ACC_CONSUMER_ID,CTE2.ACC_EMPLOYEE_ID)) AS MEMBER_ID,
                    ISNULL(COMP.FULLNAME,ISNULL(CONS.CONSUMER_NAME + ' ' + CONS.CONSUMER_SURNAME,EMP.EMPLOYEE_NAME + ' ' + EMP.EMPLOYEE_SURNAME)) AS MEMBER_FULLNAME,
                    ROW_NUMBER() OVER (PARTITION BY CTE2.ACCOUNT_CODE ORDER BY CTE2.ACCOUNT_CODE, CTE2.ACTION_DATE, CTE2.BILL_NO) AS ROWNUM
                FROM
                    CTE1
                        LEFT JOIN CTE2 ON CTE2.ACCOUNT_CODE = CTE1.ACCOUNT_CODE AND (CTE2.ACTION_DATE >=  #attributes.date1# OR CTE2.CARD_ROW_ID IS NULL)
                        LEFT JOIN CTE3 ON CTE3.ACCOUNT_CODE = CTE1.ACCOUNT_CODE
                        LEFT JOIN #dsn_alias#.PRO_PROJECTS PP ON PP.PROJECT_ID = CTE2.ACC_PROJECT_ID
                        LEFT JOIN #dsn_alias#.BRANCH B ON B.BRANCH_ID = CTE2.ACC_BRANCH_ID
                        LEFT JOIN #dsn_alias#.DEPARTMENT D ON D.DEPARTMENT_ID = CTE2.ACC_DEPARTMENT_ID
                        LEFT JOIN #dsn_alias#.COMPANY COMP ON COMP.COMPANY_ID = CTE2.ACC_COMPANY_ID
                        LEFT JOIN #dsn_alias#.CONSUMER CONS ON CONS.CONSUMER_ID = CTE2.ACC_CONSUMER_ID
                        LEFT JOIN #dsn_alias#.EMPLOYEES EMP ON EMP.EMPLOYEE_ID = CTE2.ACC_EMPLOYEE_ID
                WHERE
                    1 = 1
                    <cfif attributes.is_acc_with_action eq 1>
                        AND CTE2.CARD_ID IS NOT NULL
                    </cfif>
            )
            SELECT
                *,
                (SELECT COUNT(DISTINCT ACCOUNT_CODE) FROM CTE4) AS QUERY_COUNT
            FROM
                CTE4
            WHERE
                1 = 1
                <cfif attributes.is_excel neq 1>
                    AND ACC_ROWNUM BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
                </cfif>
            ORDER BY
                ACCOUNT_CODE
        </cfquery>  
        <cfset attributes.totalrecords = getMuavin.QUERY_COUNT>
        <cfif endrow gt getMuavin.QUERY_COUNT>
            <cfset endrow = getMuavin.QUERY_COUNT>
        </cfif>
        <cfset colspan_numb = 10>
        <cfset colspan_numb2 = 6>
        <cfif attributes.is_quantity eq 1>
            <cfset colspan_numb = colspan_numb + 1>
            <cfset colspan_numb2 = colspan_numb2 + 1>
        </cfif>
        <cfif isdefined('is_show_paper_no') and is_show_paper_no eq 1>
            <cfset colspan_numb = colspan_numb + 1>
            <cfset colspan_numb2 = colspan_numb2 + 1>
        </cfif>
        <cfif isdefined('is_show_department') and is_show_department eq 1>
            <cfset colspan_numb = colspan_numb + 1>
            <cfset colspan_numb2 = colspan_numb2 + 1>
        </cfif>
        <cfif isdefined('is_acc_branch') and is_acc_branch eq 1>
            <cfset colspan_numb = colspan_numb + 1>
            <cfset colspan_numb2 = colspan_numb2 + 1>
        </cfif>
        <cfif isdefined('is_acc_project') and is_acc_project eq 1>
            <cfset colspan_numb = colspan_numb + 1>
            <cfset colspan_numb2 = colspan_numb2 + 1>
        </cfif>
        <cfif isdefined("is_show_cari") and is_show_cari eq 1>
            <cfset colspan_numb = colspan_numb + 1>
            <cfset colspan_numb2 = colspan_numb2 + 1>
        </cfif>
        <cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
            <cfset colspan_numb = colspan_numb +4>
        </cfif>
        <cfif isdefined('attributes.other_money_based') and attributes.other_money_based eq 1>
            <cfset colspan_numb = colspan_numb +5>
        </cfif>
        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
            <cfset filename="muavin#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
            <cfheader name="Expires" value="#Now()#">
            <cfcontent type="application/vnd.msexcel;charset=utf-16">
            <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
            <meta http-equiv="Content-Type" content="text/plain; charset=utf-16">
            <cfset attributes.startrow=1>
            <cfset attributes.maxrows=getMuavin.recordcount>
        </cfif>
        <cf_box title="#getLang(20,'Muavin',47282)#" uidrop="#IIf((isdefined('attributes.is_excel') and attributes.is_excel eq 1),Evaluate(DE("")),DE("1"))#" hide_table_column="1">
            <cfif getMuavin.recordcount>
                <cfoutput query = "getMuavin" group = "account_code"> 
                    <cf_grid_list sort="1">             
                        
                        <thead>
                            <!--- Basliklar --->
                            <tr>
                                <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                                <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                                <th><cf_get_lang dictionary_id='57487.No'></th>
                                <th><cf_get_lang dictionary_id='47348.Fiş Türü'></th>
                                <th><cf_get_lang dictionary_id='57946.Fiş No'></th>
                                <cfif isdefined('is_show_paper_no') and is_show_paper_no eq 1>
                                    <th><cf_get_lang dictionary_id='57880.Belge No'></th>
                                </cfif>
                                <cfif isdefined('is_acc_branch') and is_acc_branch eq 1>
                                    <th><cf_get_lang dictionary_id='57453.Sube'></th>
                                </cfif>
                                <cfif isdefined('is_show_department') and is_show_department eq 1>
                                    <th><cf_get_lang dictionary_id='57572.Departman'></th>
                                </cfif>
                                <cfif isdefined("is_show_cari") and is_show_cari eq 1>
                                    <th><cf_get_lang dictionary_id='57519.Cari'></th>
                                </cfif>
                                <cfif isdefined('is_acc_project') and is_acc_project eq 1>
                                    <th><cf_get_lang dictionary_id='57416.Proje'></th>
                                </cfif>
                                <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                                <cfif isdefined("attributes.is_quantity") and attributes.is_quantity eq 1>
                                    <th><cf_get_lang dictionary_id='57635.Miktar'></th>
                                </cfif>
                                <th><cf_get_lang dictionary_id='57587.Borç'></th>
                                <th><cf_get_lang dictionary_id='57588.Alacak'></th>
                                <th><cf_get_lang dictionary_id='57589.Bakiye'></th>
                                <cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
                                    <th>#session.ep.money2# <cf_get_lang dictionary_id='57587.Borç'></th>
                                    <th>#session.ep.money2# <cf_get_lang dictionary_id='57588.Alacak'></th>
                                    <th>#session.ep.money2# <cf_get_lang dictionary_id='57589.Bakiye'></th>
                                </cfif>
                                <cfif (attributes.is_system_money_2 eq 1 and attributes.other_money_based neq 1) or (attributes.is_system_money_2 neq 1 and attributes.other_money_based neq 1)><th></th></cfif>
                                <cfif isdefined('attributes.other_money_based') and attributes.other_money_based eq 1>
                                    <th><cf_get_lang dictionary_id="58121.İşlem Dövizi"><cf_get_lang dictionary_id='57587.Borç'></th>
                                    <th><cf_get_lang dictionary_id="58121.İşlem Dövizi"><cf_get_lang dictionary_id='57588.Alacak'></th>
                                    <th><cf_get_lang dictionary_id="58121.İşlem Dövizi"><cf_get_lang dictionary_id='57589.Bakiye'></th>
                                    <th colspan="2"></th>
                                </cfif>
                            </tr>
                            <tr>
                                <!--- Hesap Adi Bilgisi --->
                                <th colspan = "#colspan_numb#">#ACCOUNT_CODE# / #ACCOUNT_NAME#</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfif dev_borc gt 0 or dev_alacak gt 0>
                                <!--- Devreden Bilgisi --->
                                <tr class="nohover">
                                    <td align="left" class="txtboldblue" colspan="#colspan_numb2#"><cf_get_lang dictionary_id='58034.Devreden'></td>
                                    <td style="text-align:right;" class="txtboldblue" format="numeric" nowrap>#TLFormat(dev_borc)#</td>
                                    <td style="text-align:right;" class="txtboldblue" format="numeric" nowrap>#TLFormat(dev_alacak)#</td>
                                    <td style="text-align:right;" class="txtboldblue" format="numeric" nowrap>#TLFormat(abs(dev_bakiye))#<cfif dev_bakiye lt 0>(A)<cfelse>(B)</cfif></td>
                                    <cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
                                        <td style="text-align:right;" format="numeric" class="txtboldblue" nowrap>#TLFormat(dev_borc2)#</td>
                                        <td style="text-align:right;" format="numeric" class="txtboldblue" nowrap>#TLFormat(dev_alacak2)#</td>
                                        <td style="text-align:right;" format="numeric" class="txtboldblue" nowrap>#TLFormat(abs(dev_bakiye2))#<cfif dev_bakiye2 lt 0>(A)<cfelse>(B)</cfif></td>
                                    </cfif>
                                    <cfif isdefined('attributes.other_money_based') and attributes.other_money_based eq 1>
                                        <td style="text-align:right;" class="txtboldblue" nowrap><cfloop list="#dev_other_borc#" index="i" delimiters="!">#TlFormat(i)#<br /></cfloop>
                                        </td>
                                        <td style="text-align:right;" class="txtboldblue" nowrap><cfloop list="#dev_other_alacak#" index="i" delimiters="!">#TlFormat(i)#<br /></cfloop>
                                        </td>
                                        <td style="text-align:right;" class="txtboldblue" nowrap><cfloop list="#dev_other_bakiye#" index="i" delimiters="!">#TlFormat(abs(i))# <cfif i gt 0>(B)<cfelse>(A)</cfif><br /></cfloop>
                                        </td>
                                        <td style="text-align:right;" class="txtboldblue" nowrap><cfloop list="#all_other_currency#" index="i" delimiters="!">#i#<br /></cfloop>
                                        </td>
                                        <cfloop from="1" to="#ListLen(all_other_currency,'!')#" index="i">
                                            <cfif len(trim(ListGetAt(all_other_currency,i,'!')))>
                                                <cfset evaluate("other_amount_total_#ListGetAt(all_other_currency,i,'!')# = #ListGetAt(dev_other_bakiye,i,'!')#")>
                                            </cfif>
                                        </cfloop>
                                    </cfif>
                                    <td colspan="2"></td>
                                </tr>
                            </cfif>
                            <cfset bakiye = dev_bakiye>
                            <cfset bakiye2 = dev_bakiye2>
                            <cfoutput>
                                <cfif ba neq ''>
                                    <!--- Satirlar --->
                                    <tr>
                                        <td>#rownum#</td>
                                        <td align="center">#dateformat(ACTION_DATE,dateformat_style)#</td>
                                        <td align="center">#BILL_NO#</td>
                                        <td align="center">
                                            <cfif attributes.is_excel eq 1>
                                                #CARD_TYPE_NAME#
                                            <cfelse>
                                                <a href="javascript:windowopen('#request.self#?fuseaction=account.popup_list_card_rows&card_id=#CARD_ID#','list');" class="tableyazi">#CARD_TYPE_NAME#</a>
                                            </cfif>
                                        </td>
                                        <td align="center">#CARD_TYPE_NO#</td>
                                        <cfif ACTION_TYPE eq 250> <!--- toplu giden havale ise --->
                                            <cfquery name="GET_PAPER_NO" datasource="#dsn2#">
                                                SELECT BA.PAPER_NO,
                                                <cfif len(getMuavin.ACC_COMPANY_ID)>
                                                 C.FULLNAME AS FULLNAME
                                                <cfelseif len(ACC_CONSUMER_ID)>
                                                 C.CONSUMER_NAME + ' ' + C.CONSUMER_SURNAME AS FULLNAME
                                                <cfelse>
                                                 E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS FULLNAME
                                                </cfif>
                                                 FROM BANK_ACTIONS AS BA
                                                <cfif len(getMuavin.ACC_COMPANY_ID)>
                                                    JOIN #dsn#.COMPANY AS C ON C.COMPANY_ID = BA.ACTION_TO_COMPANY_ID
                                                    JOIN #dsn#.COMPANY_PERIOD AS CP ON C.COMPANY_ID = CP.COMPANY_ID
                                                <cfelseif len(ACC_CONSUMER_ID)>
                                                    JOIN #dsn#.CONSUMER AS C ON C.CONSUMER_ID = BA.ACTION_TO_CONSUMER_ID
                                                    JOIN #dsn#.CONSUMER_PERIOD AS CP ON C.CONSUMER_ID = CP.CONSUMER_ID
                                                <cfelse>
                                                    JOIN #dsn#.EMPLOYEES AS E ON E.EMPLOYEE_ID = BA.ACTION_TO_EMPLOYEE_ID
                                                </cfif>
                                                WHERE MULTI_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ACTION_ID#">
                                                    <cfif len(getMuavin.ACC_COMPANY_ID) or len(ACC_CONSUMER_ID)>
                                                      AND CP.PERIOD_ID = #session.ep.period_id#
                                                      AND CP.ACCOUNT_CODE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#ACCOUNT_CODE#">
                                                    </cfif>
                                            </cfquery>
                                        </cfif>
                                        <cfif isdefined('is_show_paper_no') and is_show_paper_no eq 1>
                                            <cfif isdefined("get_paper_no") and GET_PAPER_NO.recordCount>
                                                <td align="center">#GET_PAPER_NO.PAPER_NO#</td>
                                            <cfelse>
                                                <td align="center">#PAPER_NO#</td>
                                            </cfif>
                                        </cfif>
                                        <cfif isdefined('is_acc_branch') and is_acc_branch eq 1>
                                            <td>#BRANCH_NAME#</td>
                                        </cfif>
                                        <cfif isdefined('is_show_department') and is_show_department eq 1>
                                            <td>#DEPARTMENT_HEAD#</td>
                                        </cfif>
                                        <cfif isdefined("is_show_cari") and is_show_cari eq 1>
                                            <td>
                                                <cfif attributes.is_excel eq 1>
                                                    #MEMBER_FULLNAME#
                                                <cfelse>
                                                    <cfif member_type eq 'comp'>
                                                        <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#member_id#','medium');">
                                                            <cfif isdefined("get_paper_no") and GET_PAPER_NO.recordCount>
                                                                #GET_PAPER_NO.FULLNAME#
                                                            <cfelse>
                                                                #member_fullname#
                                                            </cfif>
                                                        </a>
                                                    <cfelseif member_type eq 'cons'>
                                                        <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#member_id#','medium');">
                                                            <cfif isdefined("get_paper_no") and GET_PAPER_NO.recordCount>
                                                                #GET_PAPER_NO.FULLNAME#
                                                            <cfelse>
                                                                #member_fullname#
                                                            </cfif>
                                                    <cfelseif member_type eq 'emp'>
                                                        <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#member_id#','medium');">#member_fullname#</a>
                                                    </cfif>
                                                </cfif>
                                            </td>
                                        </cfif>
                                        <cfif isdefined('is_acc_project') and is_acc_project eq 1>
                                            <td>#PROJECT_HEAD#</td>
                                        </cfif>
                                        <cfset Replace_List = "',#Chr(10)#,#Chr(13)#,amp;"><!--- Satir Kirma Sorun Oluyor --->
                                        <cfset Replace_List_New = ",,,">
                                        <cfset Detail_ = ReplaceList(Detail,Replace_List,Replace_List_New)>
                                        <td align="left">#Detail_#</td>
                                        <cfif isdefined("attributes.is_quantity") and attributes.is_quantity eq 1>
                                            <td style="text-align:right;" format="numeric">#TLFormat(QUANTITY)#</td>
                                        </cfif>
                                        <td style="text-align:right;" format="numeric"><cfif BA eq 0>#TLFormat(amount)#</cfif></td>
                                        <td style="text-align:right;" format="numeric"><cfif BA eq 1>#TLFormat(amount)#</cfif></td>
                                        <cfset bakiye = bakiye + (1 - 2 * ba) * amount>
                                        <cfset bakiye2 = bakiye2 + (1 - 2 * ba) * amount_2>
                                        <td style="text-align:right;">#TLFormat(abs(bakiye))# <cfif bakiye gte 0>(B)<cfelse>(A)</cfif></td>
                                        <cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
                                            <td style="text-align:right;" format="numeric"><cfif BA eq 0>#TLFormat(amount_2)#</cfif></td>
                                            <td style="text-align:right;" format="numeric"><cfif BA eq 1>#TLFormat(amount_2)#</cfif></td>
                                            <td style="text-align:right;">#TLFormat(abs(bakiye2))# <cfif bakiye2 gte 0>(B)<cfelse>(A)</cfif></td>
                                        </cfif>
                                        <cfif isdefined('attributes.other_money_based') and attributes.other_money_based eq 1>          
                                            <cfif not isDefined("other_amount_total_#other_currency#")>
                                                <cfset evaluate("other_amount_total_#other_currency# = 0")>
                                            </cfif>
                                            <cfif len(trim(other_currency)) and len(other_amount) and isDefined("other_amount_total_#other_currency#")>
                                                <cfset evaluate("other_amount_total_#other_currency# = other_amount_total_#other_currency# + other_amount * (1 - 2 * ba)")>
                                            </cfif>
                                            <td style="text-align:right;" format="numeric"><cfif BA eq 0>#TLFormat(other_amount)#</cfif></td>
                                            <td style="text-align:right;" format="numeric"><cfif BA eq 1>#TLFormat(other_amount)#</cfif></td>
                                            <td style="text-align:right;"><cfif len(trim(other_currency)) and len(other_amount)>#evaluate("TLFormat(abs(other_amount_total_#other_currency#))")#<cfif evaluate("other_amount_total_#other_currency#") gte 0>(B)<cfelse>(A)</cfif></cfif> </td>
                                            <td style="text-align:right;">#other_currency#</td>
                                        </cfif>
                                        <cfif not(isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                                            <td width="18" align="center"><!-- sil --><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#card_id#&print_type=290','print_page');"><img src="/images/print2.gif" alt="<cf_get_lang dictionary_id='57474.Yazdır'>" title="<cf_get_lang dictionary_id='57474.Yazdır'>"></a><!-- sil --></td>
                                        </cfif>
                                    </tr>
                                <cfelse>
                                    <tr>
                                        <td colspan="#colspan_numb#"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
                                    </tr>
                                </cfif>
                            </cfoutput>
                            <!--- Alt Toplamlar --->
                            <tr>
                                <td class="txtbold" style="text-align:right;" colspan="#colspan_numb2#"><cf_get_lang dictionary_id='57492.Toplam'></td>
                                <cfif isdefined("attributes.is_quantity") and attributes.is_quantity eq 1>
                                    <td style="text-align:right;" format="numeric">#TLFormat(TOTAL_MIKTAR)#</td>
                                </cfif>
                                <td style="text-align:right;" class="txtbold" nowrap>#TLFormat(Evaluate(total_borc))# #session.ep.money#</td>
                                <td style="text-align:right;" class="txtbold" nowrap>#TLFormat(Evaluate(total_alacak))# #session.ep.money#</td>
                                <td style="text-align:right;" class="txtbold" nowrap>#TLFormat(abs(evaluate(total_bakiye)))# #session.ep.money#<cfif bakiye gte 0>(B)<cfelse>(A)</cfif></td>
                                <cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
                                    <td style="text-align:right;" class="txtbold" nowrap>#TLFormat(Evaluate(total_borc2))# #session.ep.money2#</td>
                                    <td style="text-align:right;" class="txtbold" nowrap>#TLFormat(Evaluate(total_alacak2))# #session.ep.money2#</td>
                                    <td style="text-align:right;" class="txtbold" nowrap>#TLFormat(abs(evaluate(total_bakiye2)))# #session.ep.money2#<cfif total_bakiye2 gte 0>(B)<cfelse>(A)</cfif></td>
                                </cfif>
                                <cfif isdefined('attributes.other_money_based') and attributes.other_money_based eq 1>
                                    <td style="text-align:right;" class="txtbold" nowrap><cfloop list="#total_other_borc#" index="i" delimiters="!">#TlFormat(i)#<br /></cfloop>
                                    </td>
                                    <td style="text-align:right;" class="txtbold" nowrap><cfloop list="#total_other_alacak#" index="i" delimiters="!">#TlFormat(i)#<br /></cfloop>
                                    </td>
                                    <td style="text-align:right;" class="txtbold" nowrap><cfloop list="#total_other_bakiye#" index="i" delimiters="!">#TlFormat(abs(i))# <cfif i gt 0>(B)<cfelse>(A)</cfif><br /></cfloop>
                                    </td>
                                    <td style="text-align:right;" class="txtbold" nowrap><cfloop list="#all_other_currency#" index="i" delimiters="!">#i#<br /></cfloop>
                                    </td>
                                </cfif>
                                <td colspan="2"></td>
                                <cfloop from="1" to="#ListLen(all_other_currency,'!')#" index="i">
                                    <cfif len(trim(ListGetAt(all_other_currency,i,'!')))>
                                        <cfset evaluate("other_amount_total_#ListGetAt(all_other_currency,i,'!')# = 0")>
                                    </cfif>
                                </cfloop>
                            </tr>
                        </tbody>                   
              
                    </cf_grid_list>
                </cfoutput>
            <cfelse>
                <cf_grid_list>
                    <tbody>
                        <tr>
                            <td colspan="<cfoutput>#colspan_numb#</cfoutput>"><cfif isdefined("attributes.form_varmi")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
                        </tr>
                    </tbody>
                </cf_grid_list>
            </cfif>
            <cfif attributes.is_excel eq 0>
                <cfset adres="#attributes.fuseaction#">
                <cfset adres=adres&'&form_is_submitted=#attributes.form_is_submitted#'>
                <cfset adres='#adres#&is_quantity=#attributes.is_quantity#'>
                <cfif isdefined("attributes.date1") and len (attributes.date1)>
                    <cfset adres="#adres#&date1=#dateformat(attributes.date1,dateformat_style)#">
                    <cfset adres="#adres#&date2=#dateformat(attributes.date2,dateformat_style)#">
                </cfif>
                <cfif isdefined("attributes.code1") and isdefined("attributes.code2")>
                    <cfset adres=adres&'&code1=#attributes.code1#&code2=#attributes.code2#'>
                </cfif>
                <cfif isdefined('attributes.is_acc_with_action') and len (attributes.is_acc_with_action)>
                    <cfset adres=adres&'&is_acc_with_action=#attributes.is_acc_with_action#'>
                </cfif>
                <cfif isdefined('attributes.is_carryforward') and len (attributes.is_carryforward)>
                    <cfset adres=adres&'&is_carryforward=#attributes.is_carryforward#'>
                </cfif>
                <cfif isdefined('attributes.is_system_money_2') and len (attributes.is_system_money_2)>
                    <cfset adres=adres&'&is_system_money_2=#attributes.is_system_money_2#'>
                </cfif>
                <cfif isdefined('attributes.other_money_based') and len (attributes.other_money_based)>
                    <cfset adres=adres&'&other_money_based=#attributes.other_money_based#'>
                </cfif>
                <cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)>
                    <cfset adres=adres&'&acc_card_type=#attributes.acc_card_type#'>
                </cfif>
                <cfif isdefined("attributes.acc_code_type") and len(attributes.acc_code_type)>
                    <cfset adres='#adres#&acc_code_type=#attributes.acc_code_type#'>
                </cfif>
                <cfif isdefined ("attributes.acc_code1_1") and len(attributes.acc_code1_1)>
                    <cfset adres = "#adres#&acc_code1_1=#attributes.acc_code1_1#">
                </cfif>
                <cfif isdefined ("attributes.acc_code2_1") and len(attributes.acc_code2_1)>
                    <cfset adres = "#adres#&acc_code2_1=#attributes.acc_code2_1#">
                </cfif>
                <cfif isdefined ("attributes.acc_code1_2") and len(attributes.acc_code1_2)>
                    <cfset adres = "#adres#&acc_code1_2=#attributes.acc_code1_2#">
                </cfif>
                <cfif isdefined ("attributes.acc_code2_2") and len(attributes.acc_code2_2)>
                    <cfset adres = "#adres#&acc_code2_2=#attributes.acc_code2_2#">
                </cfif>
                <cfif isdefined ("attributes.acc_code1_3") and len(attributes.acc_code1_3)>
                    <cfset adres = "#adres#&acc_code1_3=#attributes.acc_code1_3#">
                </cfif>
                <cfif isdefined ("attributes.acc_code2_3") and len(attributes.acc_code2_3)>
                    <cfset adres = "#adres#&acc_code2_3=#attributes.acc_code2_3#">
                </cfif>
                <cfif isdefined ("attributes.acc_code1_4") and len(attributes.acc_code1_4)>
                    <cfset adres = "#adres#&acc_code1_4=#attributes.acc_code1_4#">
                </cfif>
                <cfif isdefined ("attributes.acc_code2_4") and len(attributes.acc_code2_4)>
                    <cfset adres = "#adres#&acc_code2_4=#attributes.acc_code2_4#">
                </cfif>
                <cfif isdefined ("attributes.acc_code1_5") and len(attributes.acc_code1_5)>
                    <cfset adres = "#adres#&acc_code1_5=#attributes.acc_code1_5#">
                </cfif>
                <cfif isdefined ("attributes.acc_code2_5") and len(attributes.acc_code2_5)>
                    <cfset adres = "#adres#&acc_code2_5=#attributes.acc_code2_5#">
                </cfif>
                <cfif isdefined("attributes.project_id") and len(attributes.project_id)>
                    <cfset adres='#adres#&project_id=#attributes.project_id#'>
                </cfif>
                <cfif isdefined("attributes.project_head") and len(attributes.project_head)>
                    <cfset adres='#adres#&project_head=#attributes.project_head#'>
                </cfif>
                <cfif isdefined("attributes.is_sub_project") and len(attributes.is_sub_project)>
                    <cfset adres='#adres#&is_sub_project=#attributes.is_sub_project#'>
                </cfif>
                <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
                    <cfset adres='#adres#&branch_id=#attributes.branch_id#'>
                </cfif>
                <cfif isdefined("attributes.department") and len(attributes.department)>
                    <cfset adres='#adres#&department=#attributes.department#'>
                </cfif>
                <cf_paging page="#attributes.page#"
                    maxrows="#attributes.maxrows#"
                    totalrecords="#attributes.totalrecords#"
                    startrow="#attributes.startrow#"
                    adres="#adres#">
            </cfif>
        </cf_box>
    </cfif>
</div>
<script type="text/javascript">
    function showDepartment(branch_id)	
    {
        var branch_id = document.getElementById("branch_id").value;
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
    function tarih_kontrolu()
    {
        if( !date_check(document.form.date1, document.form.date2, "<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )return false;
        document.form.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>";
        return true;
    }
    function muavin_pdf_ac()
    {
        if((document.form.acc_code1_1.value=='') || (document.form.acc_code2_1.value==''))
        {
            alert("<cf_get_lang dictionary_id ='47458.Önce Hesap Kodlarını Seçiniz'>!");
            return false;
        }
        
        if((document.form.date1.value=='') || (document.form.date2.value==''))
        {
            alert("<cf_get_lang dictionary_id ='47459.Önce Tarihleri Seçiniz'>!");
            return false;
        }
        
        if (!tarih_kontrolu())
        return false;
        
        if(document.form.is_acc_with_action.checked)
            is_acc_with_action_=1;
        else
            is_acc_with_action_=0;
        
        windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=report.popup_rapor_muavin&is_acc_with_action='+is_acc_with_action_+'&date1='+document.form.date1.value+'&date2='+document.form.date2.value+'&code1_='+document.form.acc_code1_1.value+'&code2_='+document.form.acc_code2_1.value,'large');
    }
    function input_control() {
        if((document.form.acc_code1_1.value=='') || (document.form.acc_code2_1.value==''))
        {
            alert("<cf_get_lang dictionary_id ='47458.Önce Hesap Kodlarını Seçiniz'>!");
            return false;
        }
        
        if(document.form.is_excel.checked==false)
			{
				document.form.action="<cfoutput>#request.self#</cfoutput>?fuseaction=account.list_account_card_rows"
				return true;
			}
            else
            {
                document.form.action="<cfoutput>#request.self#?fuseaction=account.emptypopup_list_account_card_rows</cfoutput>"
                document.form.submit();
            }
				
    }
</script>