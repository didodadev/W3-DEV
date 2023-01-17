<cfparam name="attributes.page" default=1>
<cfparam name="attributes.startrow" default='1'>
<cfparam name="attributes.maxrows" default=''>
<cfparam name="attributes.totalrecords" default=''>
<cfparam name="attributes.table_code_type" default="0">
<cfparam name="attributes.acc_card_type" default="">
<cfparam name="attributes.sal_year" default="">
<cfparam name="attributes.TABLE_TYPE" default="">
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.start_date" default="">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
</cfif>
<cfparam name="attributes.finish_date" default="">
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
</cfif>
<cfset adres='finance.audit_tables'>
<cfset attributes.record_id = session.ep.userid>
<cfset attributes.record_name = get_emp_info(session.ep.userid,0,0)>
<cfparam name="attributes.is_submitted" default="">
<cfinclude template="../../account/query/get_branch_list.cfm">
<cfscript>
	get_defs = createObject("component", "V16.account.cfc.get_financial_audits");
	get_defs.dsn2 = dsn2;
	get_defs.dsn_alias = dsn_alias;
    get_period_list = get_defs.get_period_list_fnc();
	get_definitions = get_defs.get_definitions_fnc(
	table_name : '#iif(isdefined("attributes.table_name"),"attributes.table_name",DE(""))#',
	table_type : '#iif(isdefined("attributes.table_type"),"attributes.table_type",DE(""))#',
	PROCESS_STAGE : '#iif(isdefined("attributes.PROCESS_STAGE"),"attributes.PROCESS_STAGE",DE(""))#',
	startrow : '#IIf(len(attributes.startrow) and len("attributes.startrow"),"attributes.startrow",DE(""))#',
	maxrows :  '#IIf(len(attributes.maxrows) and len("attributes.maxrows"),"attributes.maxrows",DE(""))#',
	record_date : '#iif(isdefined("attributes.record_date"),"attributes.record_date",DE(""))#'
	);
    get_table_def = get_defs.get_table_def_fnc(
	table_name : '#iif(isdefined("attributes.table_name"),"attributes.table_name",DE(""))#',
	table_type : '#iif(isdefined("attributes.table_type"),"attributes.table_type",DE(""))#',
	PROCESS_STAGE : '#iif(isdefined("attributes.PROCESS_STAGE"),"attributes.PROCESS_STAGE",DE(""))#',
	startrow : '#IIf(len(attributes.startrow) and len("attributes.startrow"),"attributes.startrow",DE(""))#',
	maxrows :  '#IIf(len(attributes.maxrows) and len("attributes.maxrows"),"attributes.maxrows",DE(""))#',
	record_date : '#iif(isdefined("attributes.record_date"),"attributes.record_date",DE(""))#'
	);
     get_table_def_selected = get_defs.get_table_def_fnc(
	table_name : '#iif(isdefined("attributes.table_name"),"attributes.table_name",DE(""))#',
	table_type : '#iif(isdefined("attributes.table_type"),"attributes.table_type",DE(""))#',
	PROCESS_STAGE : '#iif(isdefined("attributes.PROCESS_STAGE"),"attributes.PROCESS_STAGE",DE(""))#',
    is_show :1 
	);
    get_copies = get_defs.get_table_copies_fnc();
</cfscript>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search_form">
            <cfswitch expression="#attributes.TABLE_TYPE#">
                <cfcase value="7">
                    <cfset fintab_type = "INCOME_TABLE">
                </cfcase>
                <cfcase value="8">
                    <cfset fintab_type = "BALANCE_TABLE">
                </cfcase>
                <cfcase value="9">
                    <cfset fintab_type = "COST_TABLE">
                </cfcase>
                <cfcase value="10">
                    <cfset fintab_type = "CASH_FLOW_TABLE">
                </cfcase>
                <cfcase value="11">
                    <cfset fintab_type = "FUND_FLOW_TABLE">
                </cfcase>
                <cfdefaultcase>
                    <cfset fintab_type = "INCOME_TABLE">
                </cfdefaultcase>
            </cfswitch>
            <cfinput type="hidden" name="fintab_type" id="fintab_type" value="#fintab_type#">
            <input name="is_submitted" id="is_submitted" type="hidden" value="1">
            <cf_box_search>
                <div class="form-group">
                    <select name="sal_year" id="sal_year">
                        <option value="" selected><cf_get_lang dictionary_id ='58455.Yıl'></option>
                        <cfoutput query="GET_PERIOD_LIST">
                            <option value="#PERIOD_ID#;#PERIOD_YEAR#" <cfif listfirst(attributes.sal_year,';') eq PERIOD_ID>selected</cfif>>#PERIOD_YEAR#</option>
                        </cfoutput>
                    </select> 
                </div>
                <div class="form-group">
                    <select name="TABLE_TYPE" id="TABLE_TYPE">
                        <option value="7" <cfif attributes.TABLE_TYPE eq 7>selected</cfif>><cf_get_lang dictionary_id='31810.GELIR TABLOSU TANIMLARI'></option>
                        <option value="8" <cfif attributes.TABLE_TYPE eq 8>selected</cfif>><cf_get_lang dictionary_id='31811.BILANÇO TABLOSU TANIMLARI'></option>
                        <option value="9" <cfif attributes.TABLE_TYPE eq 9>selected</cfif>><cf_get_lang dictionary_id='47395.SATIŞLARIN MALİYETİ TABLOSU TANIMLARI'></option>
                        <option value="10" <cfif attributes.TABLE_TYPE eq 10>selected</cfif>><cf_get_lang dictionary_id='47376.NAKİT AKIM TABLOSU TANIMLARI'></option>
                        <option value="11" <cfif attributes.TABLE_TYPE eq 11>selected</cfif>><cf_get_lang dictionary_id='47325.FON AKIM TABLOSU TANIMLARI'></option>
                    </select>
                </div>
                <div class="form-group">
                    <select ame="table_code_type" id="table_code_type">
                        <option value="0" <cfif attributes.table_code_type eq 0>selected</cfif>><cf_get_lang dictionary_id ='58793.Tek Düzen'></option>
                        <option value="1" <cfif attributes.table_code_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='58308.IFRS'></option>
                        <cfif get_copies.recordcount>
                            <cfoutput query="get_copies">
                                 <option value="#table_path#" <cfif attributes.table_code_type eq table_path>selected</cfif>>#table_name#</option>
                            </cfoutput>
                        </cfif>
                    </select>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="58053.Başlangıç"></cfsavecontent>
                        <cfinput type="text" name="start_date" maxlength="10" value="#dateformat(attributes.start_date,dateformat_style)#" placeholder="#message#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="57700.Bitiş"></cfsavecontent>
                        <cfinput type="text" name="finish_date" maxlength="10" value="#dateformat(attributes.finish_date,dateformat_style)#" placeholder="#message#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                    </div>
                </div>
                <div class="form-group">
                    <cfinclude template="../../account/query/get_money_list.cfm">                      	
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows"  onKeyUp="isNumber(this)" maxlength="3" value="#attributes.maxrows#" validate="integer" range="1," required="yes" message="#message#">
                </div> 
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
            <cf_box_search_detail>
                <div class="form-group col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-acc_branch_id">
                        <label><cf_get_lang dictionary_id='60128.Organizasyon Birimi'></label>
                        <select multiple="multiple" name="acc_branch_id" id="acc_branch_id">
                            <optgroup label="<cf_get_lang dictionary_id='57453.Şube'>"></optgroup>
                            <cfoutput query="get_branchs">
                                <option value="#BRANCH_ID#" <cfif isdefined('attributes.acc_branch_id') and listfind(attributes.acc_branch_id,BRANCH_ID)>selected</cfif>>#BRANCH_NAME#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-acc_card_type_id">
                        <label><cf_get_lang dictionary_id='57800.İşlem Tipi'></label>
                        <cfquery name="get_acc_card_type" datasource="#dsn3#">
                            SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (10,11,12,13,14,19) ORDER BY PROCESS_TYPE
                        </cfquery>
                        <select multiple="multiple" name="acc_card_type" id="acc_card_type">
                            <cfoutput query="get_acc_card_type" group="process_type">
                                <cfoutput>
                                    <option value="#process_type#-#process_cat_id#" <cfif listfind(attributes.acc_card_type,'#process_type#-#process_cat_id#',',')>selected</cfif>>#process_cat#</option>
                                </cfoutput>
                            </cfoutput>
                        </select>
                    </div>
                </div>
            </cf_box_search_detail>
        </cfform>
    </cf_box>
    <cfsavecontent variable="header"><cf_get_lang dictionary_id="57530.Mali Tablolar"></cfsavecontent>
    <cf_box title="#header#" uidrop="1" hide_table_column="1">
        <cfif len(attributes.is_submitted)>
            <cfif get_table_def.recordcount>
                <cfset acc_list_=listdeleteduplicates(Valuelist(get_table_def.ACCOUNT_CODE))>
                <cfset def_selected_rows=Valuelist(get_table_def_Selected.FINANCIAL_AUDIT_ROW_ID)>
                <cfquery name="GET_BAKIYE_ALL" datasource="#DSN2#">
                    SELECT 
                        SUM(BAKIYE) BAKIYE,
                        SUM(BORC) BORC,
                        SUM(ALACAK) ALACAK,
                        <cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
                        SUM(BAKIYE_2) BAKIYE_2,
                        SUM(BORC_2) BORC_2,
                        SUM(ALACAK_2) ALACAK_2,
                        </cfif>
                        <cfif attributes.table_code_type eq 0>
                        ACCOUNT_CODE
                        <cfelse>
                        IFRS_CODE AS ACCOUNT_CODE
                        </cfif>
                    FROM 
                    (
                        SELECT
                            SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC - ACCOUNT_ACCOUNT_REMAINDER.ALACAK) AS BAKIYE, 
                            SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC) AS BORC,
                            SUM(ACCOUNT_ACCOUNT_REMAINDER.ALACAK) AS ALACAK, 
                            SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC_2 - ACCOUNT_ACCOUNT_REMAINDER.ALACAK_2) AS BAKIYE_2, 
                            SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC_2) AS BORC_2,
                            SUM(ACCOUNT_ACCOUNT_REMAINDER.ALACAK_2) AS ALACAK_2, 
                            ACCOUNT_PLAN.ACCOUNT_CODE, 
                            ACCOUNT_PLAN.ACCOUNT_NAME,
                            ACCOUNT_PLAN.ACCOUNT_ID,
                            ACCOUNT_PLAN.IFRS_CODE, 
                            ACCOUNT_PLAN.IFRS_NAME,
                            ACCOUNT_ACCOUNT_REMAINDER.ACTION_DATE,
                            ACCOUNT_ACCOUNT_REMAINDER.CARD_TYPE,
                            ACCOUNT_ACCOUNT_REMAINDER.CARD_CAT_ID	
                        FROM
                            ACCOUNT_PLAN,
                            (
                                SELECT
                                    0 AS ALACAK,
                                    0 AS ALACAK_2,
                                    SUM(ACCOUNT_CARD_ROWS.AMOUNT) AS BORC,			
                                    SUM(ISNULL(ACCOUNT_CARD_ROWS.AMOUNT_2,0)) AS BORC_2,
                                    ACCOUNT_CARD_ROWS.ACCOUNT_ID,
                                    ACCOUNT_CARD.ACTION_DATE,
                                    ACCOUNT_CARD.CARD_TYPE,
                                    ACCOUNT_CARD.CARD_CAT_ID
                                FROM
                                    <cfif attributes.table_code_type eq 0>
                                        ACCOUNT_CARD_ROWS
                                    <cfelseif attributes.table_code_type eq 1>
                                        ACCOUNT_ROWS_IFRS
                                    <cfelse>
                                        #attributes.table_code_type#
                                    </cfif>
                                    AS ACCOUNT_CARD_ROWS
                                    ,ACCOUNT_CARD
                                WHERE
                                    BA = 0 AND ACCOUNT_CARD.CARD_ID=ACCOUNT_CARD_ROWS.CARD_ID
                                    <cfif isdefined('attributes.acc_branch_id') and len(attributes.acc_branch_id)>
                                        AND ACCOUNT_CARD_ROWS.ACC_BRANCH_ID IN(#attributes.acc_branch_id#)
                                    </cfif>
                                    <cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)><!---muhasebe işlem kategorilerine gore arama --->
                                        AND (
                                        <cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
                                            (ACCOUNT_CARD.CARD_TYPE = #listfirst(type_ii,'-')# AND ACCOUNT_CARD.CARD_CAT_ID = #listlast(type_ii,'-')#)
                                            <cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
                                        </cfloop>  
                                            )
                                    </cfif>	
                                GROUP BY
                                    ACCOUNT_CARD_ROWS.ACCOUNT_ID,
                                    ACCOUNT_CARD.ACTION_DATE,
                                    ACCOUNT_CARD.CARD_TYPE,
                                    ACCOUNT_CARD.CARD_CAT_ID
                                
                                UNION
                                
                                SELECT
                                    SUM(ACCOUNT_CARD_ROWS.AMOUNT) AS ALACAK, 
                                    SUM(ISNULL(ACCOUNT_CARD_ROWS.AMOUNT_2,0)) AS ALACAK_2,
                                    0 AS BORC,
                                    0 AS BORC_2,
                                    ACCOUNT_CARD_ROWS.ACCOUNT_ID,
                                    ACCOUNT_CARD.ACTION_DATE,
                                    ACCOUNT_CARD.CARD_TYPE,
                                    ACCOUNT_CARD.CARD_CAT_ID
                                FROM
                                    <cfif attributes.table_code_type eq 0>
                                        ACCOUNT_CARD_ROWS
                                    <cfelseif attributes.table_code_type eq 1>
                                        ACCOUNT_ROWS_IFRS
                                    <cfelse>
                                        #attributes.table_code_type#
                                    </cfif>
                                    AS ACCOUNT_CARD_ROWS
                                    ,ACCOUNT_CARD
                                WHERE
                                    BA = 1 AND ACCOUNT_CARD.CARD_ID=ACCOUNT_CARD_ROWS.CARD_ID
                                    <cfif isdefined('attributes.acc_branch_id') and len(attributes.acc_branch_id)>
                                        AND ACCOUNT_CARD_ROWS.ACC_BRANCH_ID IN(#attributes.acc_branch_id#)
                                    </cfif>
                                    <cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)><!---muhasebe işlem kategorilerine gore arama --->
                                        AND (
                                        <cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
                                            (ACCOUNT_CARD.CARD_TYPE = #listfirst(type_ii,'-')# AND ACCOUNT_CARD.CARD_CAT_ID = #listlast(type_ii,'-')#)
                                            <cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
                                        </cfloop>  
                                            )
                                    </cfif>	
                                GROUP BY
                                    ACCOUNT_CARD_ROWS.ACCOUNT_ID,
                                    ACCOUNT_CARD.ACTION_DATE,
                                    ACCOUNT_CARD.CARD_TYPE,
                                    ACCOUNT_CARD.CARD_CAT_ID
                            )ACCOUNT_ACCOUNT_REMAINDER
                        WHERE
                            (
                                (ACCOUNT_PLAN.SUB_ACCOUNT=1 AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID LIKE ACCOUNT_PLAN.ACCOUNT_CODE +'%')
                                OR
                                (ACCOUNT_PLAN.SUB_ACCOUNT=0 AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID = ACCOUNT_PLAN.ACCOUNT_CODE)
                            )
                            AND CARD_TYPE <> 19
                        GROUP BY
                            ACCOUNT_PLAN.ACCOUNT_CODE, 
                            ACCOUNT_PLAN.ACCOUNT_NAME,
                            ACCOUNT_PLAN.IFRS_CODE, 
                            ACCOUNT_PLAN.IFRS_NAME,
                            ACCOUNT_PLAN.ACCOUNT_ID, 
                            ACCOUNT_ACCOUNT_REMAINDER.ACTION_DATE,
                            ACCOUNT_ACCOUNT_REMAINDER.CARD_TYPE,
                            ACCOUNT_ACCOUNT_REMAINDER.CARD_CAT_ID
                        <cfif isdefined('attributes.is_bakiye')>
                            HAVING round(SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC - ACCOUNT_ACCOUNT_REMAINDER.ALACAK),2) <> 0
                        </cfif>
                    )T1
                    WHERE
                    <cfif len(acc_list_)>
                        ACCOUNT_CODE IN (#ListQualify(acc_list_,"'",",")#)
                    <cfelse>
                        ACCOUNT_CODE IS NULL
                    </cfif>
                    <cfif len(attributes.finish_date)>
                        AND ACTION_DATE <= #attributes.finish_date#
                    </cfif>	
                    <cfif len(attributes.start_date)>
                        AND ACTION_DATE >= #attributes.start_date#
                    </cfif>
                    GROUP BY
                        <cfif attributes.table_code_type eq 0>
                        ACCOUNT_CODE
                        <cfelse>
                        IFRS_CODE
                        </cfif>
                </cfquery>
                <cfquery name="GET_BAKIYE_ALL_OPEN" datasource="#DSN2#">
                    SELECT 
                        SUM(BAKIYE) BAKIYE,
                        SUM(BORC) BORC,
                        SUM(ALACAK) ALACAK,
                        <cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
                        SUM(BAKIYE_2) BAKIYE_2,
                        SUM(BORC_2) BORC_2,
                        SUM(ALACAK_2) ALACAK_2,
                        </cfif>
                        <cfif attributes.table_code_type eq 0>
                        ACCOUNT_CODE
                        <cfelse>
                        IFRS_CODE AS ACCOUNT_CODE
                        </cfif>
                    FROM 
                    (
                        SELECT
                            SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC - ACCOUNT_ACCOUNT_REMAINDER.ALACAK) AS BAKIYE, 
                            SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC) AS BORC,
                            SUM(ACCOUNT_ACCOUNT_REMAINDER.ALACAK) AS ALACAK, 
                            SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC_2 - ACCOUNT_ACCOUNT_REMAINDER.ALACAK_2) AS BAKIYE_2, 
                            SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC_2) AS BORC_2,
                            SUM(ACCOUNT_ACCOUNT_REMAINDER.ALACAK_2) AS ALACAK_2, 
                            ACCOUNT_PLAN.ACCOUNT_CODE, 
                            ACCOUNT_PLAN.ACCOUNT_NAME,
                            ACCOUNT_PLAN.ACCOUNT_ID,
                            ACCOUNT_PLAN.IFRS_CODE, 
                            ACCOUNT_PLAN.IFRS_NAME,
                            ACCOUNT_ACCOUNT_REMAINDER.ACTION_DATE,
                            ACCOUNT_ACCOUNT_REMAINDER.CARD_TYPE,
                            ACCOUNT_ACCOUNT_REMAINDER.CARD_CAT_ID	
                        FROM
                            ACCOUNT_PLAN,
                            (
                                SELECT
                                    0 AS ALACAK,
                                    0 AS ALACAK_2,
                                    SUM(ACCOUNT_CARD_ROWS.AMOUNT) AS BORC,			
                                    SUM(ISNULL(ACCOUNT_CARD_ROWS.AMOUNT_2,0)) AS BORC_2,
                                    ACCOUNT_CARD_ROWS.ACCOUNT_ID,
                                    ACCOUNT_CARD.ACTION_DATE,
                                    ACCOUNT_CARD.CARD_TYPE,
                                    ACCOUNT_CARD.CARD_CAT_ID
                                FROM
                                    <cfif attributes.table_code_type eq 0>
                                        ACCOUNT_CARD_ROWS
                                    <cfelseif attributes.table_code_type eq 1>
                                        ACCOUNT_ROWS_IFRS
                                   <cfelse>
                                        #attributes.table_code_type#
                                    </cfif>
                                    AS ACCOUNT_CARD_ROWS
                                    ,ACCOUNT_CARD
                                WHERE
                                    ACCOUNT_CARD.CARD_TYPE = 10 AND
                                    BA = 0 AND ACCOUNT_CARD.CARD_ID=ACCOUNT_CARD_ROWS.CARD_ID
                                    <cfif isdefined('attributes.acc_branch_id') and len(attributes.acc_branch_id)>
                                        AND ACCOUNT_CARD_ROWS.ACC_BRANCH_ID IN(#attributes.acc_branch_id#)
                                    </cfif>
                                    <cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)><!---muhasebe işlem kategorilerine gore arama --->
                                        AND (
                                        <cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
                                            (ACCOUNT_CARD.CARD_TYPE = #listfirst(type_ii,'-')# AND ACCOUNT_CARD.CARD_CAT_ID = #listlast(type_ii,'-')#)
                                            <cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
                                        </cfloop>  
                                            )
                                    </cfif>	
                                GROUP BY
                                    ACCOUNT_CARD_ROWS.ACCOUNT_ID,
                                    ACCOUNT_CARD.ACTION_DATE,
                                    ACCOUNT_CARD.CARD_TYPE,
                                    ACCOUNT_CARD.CARD_CAT_ID
                                
                                UNION
                                
                                SELECT
                                    SUM(ACCOUNT_CARD_ROWS.AMOUNT) AS ALACAK, 
                                    SUM(ISNULL(ACCOUNT_CARD_ROWS.AMOUNT_2,0)) AS ALACAK_2,
                                    0 AS BORC,
                                    0 AS BORC_2,
                                    ACCOUNT_CARD_ROWS.ACCOUNT_ID,
                                    ACCOUNT_CARD.ACTION_DATE,
                                    ACCOUNT_CARD.CARD_TYPE,
                                    ACCOUNT_CARD.CARD_CAT_ID
                                FROM
                                    <cfif attributes.table_code_type eq 0>
                                        ACCOUNT_CARD_ROWS
                                    <cfelseif attributes.table_code_type eq 1>
                                        ACCOUNT_ROWS_IFRS
                                    <cfelse>
                                        #attributes.table_code_type#
                                    </cfif>
                                    AS ACCOUNT_CARD_ROWS
                                    ,ACCOUNT_CARD
                                WHERE
                                    ACCOUNT_CARD.CARD_TYPE = 10 AND
                                    BA = 1 AND ACCOUNT_CARD.CARD_ID=ACCOUNT_CARD_ROWS.CARD_ID
                                    <cfif isdefined('attributes.acc_branch_id') and len(attributes.acc_branch_id)>
                                        AND ACCOUNT_CARD_ROWS.ACC_BRANCH_ID IN(#attributes.acc_branch_id#)
                                    </cfif>
                                    <cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)><!---muhasebe işlem kategorilerine gore arama --->
                                        AND (
                                        <cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
                                            (ACCOUNT_CARD.CARD_TYPE = #listfirst(type_ii,'-')# AND ACCOUNT_CARD.CARD_CAT_ID = #listlast(type_ii,'-')#)
                                            <cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
                                        </cfloop>  
                                            )
                                    </cfif>	
                                GROUP BY
                                    ACCOUNT_CARD_ROWS.ACCOUNT_ID,
                                    ACCOUNT_CARD.ACTION_DATE,
                                    ACCOUNT_CARD.CARD_TYPE,
                                    ACCOUNT_CARD.CARD_CAT_ID
                            )ACCOUNT_ACCOUNT_REMAINDER
                        WHERE
                            (
                                (ACCOUNT_PLAN.SUB_ACCOUNT=1 AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID LIKE ACCOUNT_PLAN.ACCOUNT_CODE +'%')
                                OR
                                (ACCOUNT_PLAN.SUB_ACCOUNT=0 AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID = ACCOUNT_PLAN.ACCOUNT_CODE)
                            )
                            AND CARD_TYPE <> 19
                        GROUP BY
                            ACCOUNT_PLAN.ACCOUNT_CODE, 
                            ACCOUNT_PLAN.ACCOUNT_NAME,
                            ACCOUNT_PLAN.IFRS_CODE, 
                            ACCOUNT_PLAN.IFRS_NAME,
                            ACCOUNT_PLAN.ACCOUNT_ID, 
                            ACCOUNT_ACCOUNT_REMAINDER.ACTION_DATE,
                            ACCOUNT_ACCOUNT_REMAINDER.CARD_TYPE,
                            ACCOUNT_ACCOUNT_REMAINDER.CARD_CAT_ID
                        <cfif isdefined('attributes.is_bakiye')>
                            HAVING round(SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC - ACCOUNT_ACCOUNT_REMAINDER.ALACAK),2) <> 0
                        </cfif>
                    )T1
                    WHERE
                    <cfif len(acc_list_)>
                        ACCOUNT_CODE IN (#ListQualify(acc_list_,"'",",")#)
                    <cfelse>
                        ACCOUNT_CODE IS NULL
                    </cfif>
                    <cfif len(attributes.finish_date)>
                        AND ACTION_DATE <= #attributes.finish_date#
                    </cfif>	
                    <cfif len(attributes.start_date)>
                        AND ACTION_DATE >= #attributes.start_date#
                    </cfif>
                    GROUP BY
                        <cfif attributes.table_code_type eq 0>
                        ACCOUNT_CODE
                        <cfelse>
                        IFRS_CODE
                        </cfif>
                </cfquery>
                <cfquery name="GET_OPEN_VALUES" datasource="#dsn2#">
                    SELECT 
                        ACR.AMOUNT,
                        <cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
                            ACR.AMOUNT_2,
                        </cfif>
                        ACR.ACCOUNT_ID,
                        LEFT(ACR.ACCOUNT_ID,3) ACCOUNT_ID_3,
                        ACR.CARD_ID,
                        ACR.BA
                    FROM 
                        <cfif attributes.table_code_type eq 0>
                            ACCOUNT_CARD_ROWS
                        <cfelseif attributes.table_code_type eq 1>
                            ACCOUNT_ROWS_IFRS
                        <cfelse>
                            #attributes.table_code_type#
                        </cfif>
                        AS ACR
                        ,ACCOUNT_CARD AC
                    WHERE
                        AC.CARD_TYPE = 10 AND
                        AC.CARD_ID = ACR.CARD_ID
                        <cfif isdefined('attributes.acc_branch_id') and len(attributes.acc_branch_id)>
                            AND ACR.ACC_BRANCH_ID IN(#attributes.acc_branch_id#)
                        </cfif>
                        <cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)><!---muhasebe işlem kategorilerine gore arama --->
                            AND (
                            <cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
                                (AC.CARD_TYPE = #listfirst(type_ii,'-')# AND AC.CARD_CAT_ID = #listlast(type_ii,'-')#)
                                <cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
                            </cfloop>  
                                )
                        </cfif>	
                </cfquery>
            </cfif>
            <cfform action="#request.self#?fuseaction=account.popup_add_financial_table" method="post" name="sheet_table">
                <input type="hidden" name="fintab_type" id="fintab_type" value="BALANCE_TABLE">
                
                <cfsavecontent variable="cont">
                    <cf_grid_list>
                        <thead>
                            <tr>
                                <cfset colspan_ = 4>
                                <cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1><cfset colspan_ = colspan_ + 2></cfif>
                                <th colspan="<cfoutput>#colspan_-1#</cfoutput>"><cfoutput>#dateFormat(attributes.start_date,dateformat_style)# - #dateFormat(attributes.finish_date,dateformat_style)#&nbsp;&nbsp;#session.ep.company_nick#-#session.ep.period_year#</cfoutput></th>
                                <th><cf_get_lang dictionary_id='47270.Bilanço'></th>
                                <th style="text-align:right"><cfoutput>#dateformat(now(),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,now()),timeformat_style)#</cfoutput></th>
                            </tr>
                            <tr>
                                <th></th>
                                <th nowrap><cfif attributes.table_code_type eq 1><cf_get_lang dictionary_id='58308.UFRS'><cfelse><cf_get_lang dictionary_id='47299.Hesap Kodu'></cfif></th>
                                <th nowrap><cfif attributes.table_code_type eq 1><cf_get_lang dictionary_id='58308.UFRS'><cfelse><cf_get_lang dictionary_id='47299.Hesap Kodu'></cfif></th>
                                <th align="center" nowrap><cfoutput>#Evaluate(session.ep.period_year-1)#</cfoutput></th> 
                                <cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
                                    <th align="center" nowrap><cfoutput>#Evaluate(session.ep.period_year-1)# #session.ep.money2#</cfoutput></th> 
                                </cfif>
                                <th align="center" nowrap><cf_get_lang dictionary_id ='47330.Cari Dönem'></th>
                                <cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
                                    <th align="center" nowrap><cf_get_lang dictionary_id ='47330.Cari Dönem'><cfoutput>#session.ep.money2#</cfoutput></th> 
                                </cfif>
                            </tr>
                        </thead>
                        <tbody>
                            <cfif get_table_def.recordcount>
                                <cfset temp_rate_=filterNum(attributes.rate,#session.ep.our_company_info.rate_round_num#)>
                                <cfquery name="get_table_def_acc" dbtype="query">
                                    SELECT * FROM get_table_def WHERE ACCOUNT_CODE IS NOT NULL
                                </cfquery>
                                <cfscript>
                                    for(ind_a=1;ind_a lte GET_BAKIYE_ALL.recordcount;ind_a=ind_a+1 )
                                    {
                                        temp_acc_=replace(GET_BAKIYE_ALL.ACCOUNT_CODE[ind_a],".","_","all");
                                        'borc_#temp_acc_#' = GET_BAKIYE_ALL.BORC[ind_a]/temp_rate_;
                                        'alacak_#temp_acc_#' = GET_BAKIYE_ALL.ALACAK[ind_a]/temp_rate_;
                                        'acc_bakiye_#temp_acc_#' = abs(GET_BAKIYE_ALL.BAKIYE[ind_a])/temp_rate_;
                                        'bakiye_#temp_acc_#' = GET_BAKIYE_ALL.BAKIYE[ind_a]/temp_rate_;
                                        if(isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1)
                                        {
                                            'borc2_#temp_acc_#' = GET_BAKIYE_ALL.ALACAK_2[ind_a];
                                            'alacak2_#temp_acc_#' = GET_BAKIYE_ALL.BORC_2[ind_a];
                                            'acc_bakiye2_#temp_acc_#' = abs(GET_BAKIYE_ALL.BAKIYE_2[ind_a]);
                                        }
                                    }
                                    bakiye_total3 = 0;
                                    say = true;
                                    non_display_acc_list_active_ ='';
                                    non_display_acc_list_passive_='';
                                    for(kk_=1;kk_ lte get_table_def_acc.recordcount;kk_=kk_+1 )
                                    {
                                        control_temp_acc_ =replace(get_table_def_acc.ACCOUNT_CODE[kk_],".","_","all");
                                        'hesap_tersmi_#control_temp_acc_#' = false;
                                        // hesap ters default true mu olmalı ? PY 
                                        'hesap_tersmi_#control_temp_acc_#' = true;
                                      /*  if(isdefined('bakiye_#control_temp_acc_#') and len(evaluate('bakiye_#control_temp_acc_#')) and evaluate('bakiye_#control_temp_acc_#') neq 0)
                                            {
                                            if ((evaluate('bakiye_#control_temp_acc_#') lt 0 and get_table_def_acc.ba[kk_] eq 0) or (evaluate('bakiye_#control_temp_acc_#') gt 0 and get_table_def_acc.ba[kk_] eq 1))
                                                if (Len(GET_BALANCE_DEF.INVERSE_REMAINDER) and GET_BALANCE_DEF.INVERSE_REMAINDER)
                                                    'hesap_tersmi_#control_temp_acc_#' = true;//yani hesap tersmis ters olduguna dikkat cekilecek
                                                else
                                                {
                                                    if(find("A",get_table_def_acc.code[kk_],1) eq 1) //aktif hesaplar ve pasif hesapların listeleri ayrı takip ediliyor
                                                        non_display_acc_list_active_= listappend(non_display_acc_list_active_,get_table_def_acc.code[kk_]);//  hesap ters bakiye verdigi ve ters hesaplar secilmedigi icin hesap gosterilmeyecek, ayrıca bu liste icindeki hesap kodları ust hesap bakiye hesaplamasına katılmaz
                                                    else
                                                        non_display_acc_list_passive_ = listappend(non_display_acc_list_passive_,get_table_def_acc.code[kk_]);
                                                }
                                            }
                                            */
                                    }
                                </cfscript>
                               
                                <cfquery name="get_table_defs" dbtype="query">
                                    SELECT * FROM get_table_def WHERE CODE NOT LIKE '%.%'
                                </cfquery>
                                <cfset defs_list =  listdeleteduplicates(valuelist(get_table_defs.code))>
                                <cfloop index="xx" list="#defs_list#">
                                <cfquery name="get_table_def_A" dbtype="query">
                                    SELECT * FROM get_table_def WHERE CODE LIKE '#xx#%'
                                </cfquery>
                                    <cfset ters_hesap_code =''> <!--- ters bakiye vermis hesapların kodunu tutar ve bu liste icindeki kodlar ust hesapların bakiye toplamlarına dahil edilmez --->
                                    <cfoutput query="get_table_def_A">
                                        <cfif len(account_code)>
                                            <cfscript>
                                                new_temp_acc_ =replace(ACCOUNT_CODE,".","_","all");
                                                if(isdefined('borc_#new_temp_acc_#') and len(evaluate('borc_#new_temp_acc_#')) ) borc=evaluate('borc_#new_temp_acc_#'); else borc=0;
                                                if(isdefined('alacak_#new_temp_acc_#') and len(evaluate('alacak_#new_temp_acc_#')) ) alacak=evaluate('alacak_#new_temp_acc_#'); else alacak=0;
                                                if(isdefined('acc_bakiye_#new_temp_acc_#') and len(evaluate('acc_bakiye_#new_temp_acc_#')) ) acc_bakiye=evaluate('acc_bakiye_#new_temp_acc_#'); else acc_bakiye=0;
                                                if(isdefined('bakiye_#new_temp_acc_#') and len(evaluate('bakiye_#new_temp_acc_#')) ) bakiye=evaluate('bakiye_#new_temp_acc_#'); else bakiye=0;
                                                if (sign eq "-")
                                                    acc_bakiye = -1*acc_bakiye;
                                                if(isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1)
                                                {
                                                    if(isdefined('borc2_#new_temp_acc_#') and len(evaluate('borc2_#new_temp_acc_#')) ) borc_2=evaluate('borc2_#new_temp_acc_#'); else borc_2=0;
                                                    if(isdefined('alacak2_#new_temp_acc_#') and len(evaluate('alacak2_#new_temp_acc_#')) ) alacak_2=evaluate('alacak2_#new_temp_acc_#'); else alacak_2=0;
                                                    if(isdefined('acc_bakiye2_#new_temp_acc_#') and len(evaluate('acc_bakiye2_#new_temp_acc_#')) ) acc_bakiye_2=evaluate('acc_bakiye2_#new_temp_acc_#'); else acc_bakiye_2=0;
                                                    if (sign eq "-")
                                                        acc_bakiye_2 = -1*acc_bakiye_2;
                                                }
                                            </cfscript>
                                            <!--- onceki donem acilis fisinden --->
                                            <cfquery dbtype="query" name="GET_VALUE_A">
                                                SELECT 
                                                    SUM(AMOUNT) AMOUNT,
                                                    <cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
                                                        SUM(AMOUNT_2) AMOUNT_2,
                                                    </cfif>
                                                    BA
                                                FROM 
                                                    GET_OPEN_VALUES 
                                                WHERE 
                                                    ACCOUNT_ID LIKE '#ACCOUNT_CODE#%' 
                                                    GROUP BY BA
                                            </cfquery>
                                            <cfscript>
                                                val_of_rem=0;
                                                val_of_rem_2=0;
                                                for(ii_=1;ii_ lte GET_VALUE_A.recordcount;ii_=ii_+1 )
                                                    {
                                                    if(GET_VALUE_A.BA[ii_] eq 0 and len(GET_VALUE_A.AMOUNT[ii_]))
                                                        val_of_rem = GET_VALUE_A.AMOUNT[ii_];
                                                    else if(GET_VALUE_A.BA[ii_] eq 0 and len(GET_VALUE_A.AMOUNT[ii_]))
                                                        val_of_rem = val_of_rem-GET_VALUE_A.AMOUNT[ii_];
                                                    if(isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1)
                                                        {
                                                            if(GET_VALUE_A.BA[ii_] eq 0 and len(GET_VALUE_A.AMOUNT_2[ii_]))
                                                                val_of_rem_2 = GET_VALUE_A.AMOUNT_2[ii_];
                                                            else if(GET_VALUE_A.BA[ii_] eq 0 and len(GET_VALUE_A.AMOUNT_2[ii_]))
                                                                val_of_rem_2 = val_of_rem_2-GET_VALUE_A.AMOUNT_2[ii_];
                                                        }
                                                    }
                                                val_of_rem=abs(val_of_rem);
                                                if (sign eq "-")
                                                    val_of_rem = -1*val_of_rem;
                                                if(isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1)
                                                {
                                                    val_of_rem_2=abs(val_of_rem_2);
                                                    if (sign eq "-")
                                                    val_of_rem_2 = -1*val_of_rem_2;
                                                }
                                            </cfscript>
                                            <!--- onceki donem  --->
                                        </cfif>
                                        <cfif find(".",code) eq 0 or (not len(account_code) and find(".",code) neq 0)>
                                            <cfquery name="GET_TOTAL_ARTI_OPEN" dbtype="query">
                                                SELECT 
                                                    SUM(GET_BAKIYE_ALL_OPEN.BAKIYE) BAKIYE, 
                                                    SUM(GET_BAKIYE_ALL_OPEN.BORC) BORC,
                                                    SUM(GET_BAKIYE_ALL_OPEN.ALACAK) ALACAK 
                                                    <cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
                                                        ,SUM(BAKIYE_2) BAKIYE_2
                                                        ,SUM(BORC_2) BORC_2
                                                        ,SUM(ALACAK_2) ALACAK_2
                                                    </cfif>
                                                FROM 
                                                    GET_BAKIYE_ALL_OPEN,
                                                    get_table_def
                                                WHERE 
                                                    GET_BAKIYE_ALL_OPEN.ACCOUNT_CODE = get_table_def.ACCOUNT_CODE AND 
                                                    get_table_def.CODE LIKE '#CODE#%' AND 	
                                                    (get_table_def.SIGN IS NULL OR get_table_def.SIGN = '+') AND 
                                                    <cfif len(non_display_acc_list_active_)>
                                                        get_table_def.CODE NOT IN (#ListQualify(non_display_acc_list_active_,"'",',')#) AND 	
                                                    </cfif>
                                                    get_table_def.FINANCIAL_AUDIT_ROW_ID IN (#def_selected_rows#)
                                            </cfquery>
                                            <cfquery name="GET_TOTAL_EKSI_OPEN"  dbtype="query">
                                                SELECT 
                                                    SUM(GET_BAKIYE_ALL_OPEN.BAKIYE) BAKIYE, 
                                                    SUM(GET_BAKIYE_ALL_OPEN.BORC) BORC,
                                                    SUM(GET_BAKIYE_ALL_OPEN.ALACAK) ALACAK 
                                                    <cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
                                                        ,SUM(BAKIYE_2) BAKIYE_2
                                                        ,SUM(BORC_2) BORC_2
                                                        ,SUM(ALACAK_2) ALACAK_2
                                                    </cfif>
                                                FROM 
                                                    GET_BAKIYE_ALL_OPEN,
                                                    get_table_def
                                                WHERE 
                                                    GET_BAKIYE_ALL_OPEN.ACCOUNT_CODE=get_table_def.ACCOUNT_CODE AND 
                                                    get_table_def.CODE LIKE '#CODE#%' AND 
                                                    get_table_def.SIGN = '-' AND 
                                                    <cfif len(non_display_acc_list_active_)>
                                                        get_table_def.CODE NOT IN (#ListQualify(non_display_acc_list_active_,"'",',')#) AND 	
                                                    </cfif>
                                                    get_table_def.FINANCIAL_AUDIT_ROW_ID IN (#def_selected_rows#)
                                            </cfquery>
                                            <cfscript>
                                                borc_open=0; alacak_open=0; bakiye_total1_open=0;
                                                borc_2_open=0; alacak_2_open=0; bakiye_total1_2_open=0;
                                                if (GET_TOTAL_ARTI_OPEN.recordcount) 
                                                {
                                                    bakiye_total1_open = bakiye_total1_open + abs(GET_TOTAL_ARTI_OPEN.BAKIYE/temp_rate_);
                                                    borc_open = borc_open + (GET_TOTAL_ARTI_OPEN.BORC/temp_rate_);
                                                    alacak_open = alacak_open + (GET_TOTAL_ARTI_OPEN.ALACAK/temp_rate_);
                                                    if(isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1)
                                                    {
                                                        bakiye_total1_2_open = bakiye_total1_2_open + abs(GET_TOTAL_ARTI_OPEN.BAKIYE_2);
                                                        borc_2_open = borc_2_open + (GET_TOTAL_ARTI_OPEN.BORC_2);
                                                        alacak_2_open = alacak_2_open + (GET_TOTAL_ARTI_OPEN.ALACAK_2);
                                                    }
                                                }
                                                if (GET_TOTAL_EKSI_OPEN.recordcount)
                                                {
                                                    bakiye_total1_open = bakiye_total1_open - abs(GET_TOTAL_EKSI_OPEN.BAKIYE/temp_rate_);
                                                    borc_open = borc_open + (GET_TOTAL_EKSI_OPEN.BORC/temp_rate_);
                                                    alacak_open = alacak_open + (GET_TOTAL_EKSI_OPEN.ALACAK/temp_rate_);
                                                    if(isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1)
                                                        {
                                                            bakiye_total1_2_open = bakiye_total1_2_open - abs(GET_TOTAL_EKSI_OPEN.BAKIYE_2);
                                                            borc_2_open = borc_2_open + (GET_TOTAL_EKSI_OPEN.BORC_2);
                                                            alacak_2_open = alacak_2_open + (GET_TOTAL_EKSI_OPEN.ALACAK_2);
                                                        }
                                                }
                                            </cfscript> 
                                            <cfquery name="GET_TOTAL_ARTI" dbtype="query">
                                                SELECT 
                                                    SUM(GET_BAKIYE_ALL.BAKIYE) BAKIYE, 
                                                    SUM(GET_BAKIYE_ALL.BORC) BORC,
                                                    SUM(GET_BAKIYE_ALL.ALACAK) ALACAK 
                                                    <cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
                                                        ,SUM(BAKIYE_2) BAKIYE_2
                                                        ,SUM(BORC_2) BORC_2
                                                        ,SUM(ALACAK_2) ALACAK_2
                                                    </cfif>
                                                FROM 
                                                    GET_BAKIYE_ALL,
                                                    get_table_def
                                                WHERE 
                                                    GET_BAKIYE_ALL.ACCOUNT_CODE = get_table_def.ACCOUNT_CODE AND 
                                                    get_table_def.CODE LIKE '#CODE#%' AND 	
                                                    (get_table_def.SIGN IS NULL OR get_table_def.SIGN = '+') AND 
                                                    <cfif len(non_display_acc_list_active_)>
                                                        get_table_def.CODE NOT IN (#ListQualify(non_display_acc_list_active_,"'",',')#) AND 	
                                                    </cfif>
                                                    get_table_def.FINANCIAL_AUDIT_ROW_ID IN (#def_selected_rows#)
                                            </cfquery>
                                            <cfquery name="GET_TOTAL_EKSI"  dbtype="query">
                                                SELECT 
                                                    SUM(GET_BAKIYE_ALL.BAKIYE) BAKIYE, 
                                                    SUM(GET_BAKIYE_ALL.BORC) BORC,
                                                    SUM(GET_BAKIYE_ALL.ALACAK) ALACAK 
                                                    <cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
                                                        ,SUM(BAKIYE_2) BAKIYE_2
                                                        ,SUM(BORC_2) BORC_2
                                                        ,SUM(ALACAK_2) ALACAK_2
                                                    </cfif>
                                                FROM 
                                                    GET_BAKIYE_ALL,
                                                    get_table_def
                                                WHERE 
                                                    GET_BAKIYE_ALL.ACCOUNT_CODE=get_table_def.ACCOUNT_CODE AND 
                                                    get_table_def.CODE LIKE '#CODE#%' AND 
                                                    get_table_def.SIGN = '-' AND 
                                                    <cfif len(non_display_acc_list_active_)>
                                                        get_table_def.CODE NOT IN (#ListQualify(non_display_acc_list_active_,"'",',')#) AND 	
                                                    </cfif>
                                                    get_table_def.FINANCIAL_AUDIT_ROW_ID IN (#def_selected_rows#)
                                            </cfquery>
                                            <cfscript>
                                                borc=0; alacak=0; bakiye_total1=0;
                                                borc_2=0; alacak_2=0; bakiye_total1_2=0;
                                                if (GET_TOTAL_ARTI.recordcount) 
                                                {
                                                    bakiye_total1 = bakiye_total1 + abs(GET_TOTAL_ARTI.BAKIYE/temp_rate_);
                                                    borc = borc + (GET_TOTAL_ARTI.BORC/temp_rate_);
                                                    alacak = alacak + (GET_TOTAL_ARTI.ALACAK/temp_rate_);
                                                    if(isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1)
                                                    {
                                                        bakiye_total1_2 = bakiye_total1_2 + abs(GET_TOTAL_ARTI.BAKIYE_2);
                                                        borc_2 = borc_2 + (GET_TOTAL_ARTI.BORC_2);
                                                        alacak_2 = alacak_2 + (GET_TOTAL_ARTI.ALACAK_2);
                                                    }
                                                }
                                                if (GET_TOTAL_EKSI.recordcount)
                                                {
                                                    bakiye_total1 = bakiye_total1 - abs(GET_TOTAL_EKSI.BAKIYE/temp_rate_);
                                                    borc = borc + (GET_TOTAL_EKSI.BORC/temp_rate_);
                                                    alacak = alacak + (GET_TOTAL_EKSI.ALACAK/temp_rate_);
                                                    if(isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1)
                                                        {
                                                            bakiye_total1_2 = bakiye_total1_2 - abs(GET_TOTAL_EKSI.BAKIYE_2);
                                                            borc_2 = borc_2 + (GET_TOTAL_EKSI.BORC_2);
                                                            alacak_2 = alacak_2 + (GET_TOTAL_EKSI.ALACAK_2);
                                                        }
                                                }
                                            </cfscript> 
                                        </cfif>
                                        <cfset x=0>
                                        <cfif find(".",code) eq 0 or (not len(account_code) and find(".",code) neq 0)>
                                            <cfif isdefined('attributes.is_bakiye') and bakiye_total1 neq 0>
                                                <cfset x=1>
                                            </cfif>
                                        <cfelseif len(account_code)>
                                            <cfif isdefined('attributes.is_bakiye') and acc_bakiye neq 0>
                                                <cfset x=1>
                                            </cfif>
                                        </cfif>
                                        <cfif (x eq 1 or not isdefined('attributes.is_bakiye')) and not listfind(non_display_acc_list_active_,code,',')> <!--- gosterilmeyecek hesap kodları arasında degilse --->
                                            <tr>
                                                <td>#code#</td>
                                                <td width="15">
                                                    <cfif ListLen(account_code,".") neq 1>
                                                        <cfloop from="1" to="#ListLen(account_code,".")#" index="i">&nbsp;</cfloop>
                                                    </cfif>
                                                    #account_code# 
                                                </td>
                                                <td height="20" nowrap>
                                                    <cfif ListLen(code,".") neq 1>
                                                        <cfloop from="1" to="#ListLen(code,".")#" index="i">&nbsp;&nbsp;</cfloop>
                                                    </cfif>
                                                    <cfif find(".",code) eq 0><font color="ff0000"></cfif>
                                                    <cfif len(NAME_LANG_NO)>#getLang('main',NAME_LANG_NO)#<cfelse>#name#</cfif><!--- hesap tanımlarının dil seti yapılmıssa, mainden dil alınıyor yoksa standart tanım yazdırılıyor--->
                                                    <cfif find(".",code) eq 0></font></cfif>
                                                </td>
                                                <cfif find(".",code) eq 0 or (not len(account_code) and find(".",code) neq 0)>
                                                    <td nowrap="nowrap" style="text-align:right;"><cfif not len(account_code)><font color="ff0000"></cfif>#TLFormat(bakiye_total1_open)#<cfif find(".",code) eq 0></font></cfif></td>
                                                    <cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
                                                        <td nowrap="nowrap" style="text-align:right;"><cfif not len(account_code)><font color="ff0000"></cfif>#TLFormat(bakiye_total1_2_open)#<cfif find(".",code) eq 0></font></cfif></td>
                                                    </cfif>
                                                    <td nowrap="nowrap" style="text-align:right;"><cfif find(".",code) eq 0><font color="ff0000"></cfif>#TLFormat(bakiye_total1)# #attributes.money#<cfif find(".",code) eq 0></font></cfif></td>
                                                    <cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
                                                        <td nowrap="nowrap" style="text-align:right;"><cfif find(".",code) eq 0><font color="ff0000"></cfif>#TLFormat(bakiye_total1_2)# #session.ep.money2#<cfif find(".",code) eq 0></font></cfif></td>
                                                    </cfif>
                                                <cfelseif len(account_code)>
                                                    <td nowrap="nowrap" style="text-align:right;">#TLFormat(val_of_rem)#</td><!--- onceki donem --->
                                                    <cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
                                                        <td nowrap="nowrap" style="text-align:right;">#TLFormat(val_of_rem_2)#</td><!--- onceki donem --->
                                                    </cfif>
                                                    <td nowrap="nowrap" style="text-align:right;">
                                                        <cfif evaluate('hesap_tersmi_#new_temp_acc_#')><font color="ff0000"></cfif>
                                                        <cfswitch expression="#get_table_def.VIEW_AMOUNT_TYPE#">
                                                            <cfcase value="0">#TLFormat(borc)# #attributes.money#</cfcase>
                                                            <cfcase value="1">#TLFormat(alacak)# #attributes.money#</cfcase>
                                                            <cfcase value="2">#TLFormat(acc_bakiye)# #attributes.money#</cfcase>
                                                        </cfswitch>
                                                        <cfif evaluate('hesap_tersmi_#new_temp_acc_#')></font></cfif>
                                                    </td>
                                                    <cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
                                                        <td nowrap="nowrap" style="text-align:right;">
                                                            <cfif evaluate('hesap_tersmi_#new_temp_acc_#')><font color="ff0000"></cfif>
                                                            <cfswitch expression="#get_table_def.VIEW_AMOUNT_TYPE#">
                                                                <cfcase value="0">#TLFormat(borc_2)# #session.ep.money2#</cfcase>
                                                                <cfcase value="1">#TLFormat(alacak_2)# #session.ep.money2#</cfcase>
                                                                <cfcase value="2">#TLFormat(acc_bakiye_2)# #session.ep.money2#</cfcase>
                                                            </cfswitch>
                                                            <cfif evaluate('hesap_tersmi_#new_temp_acc_#')></font></cfif>
                                                        </td>
                                                    </cfif>
                                                </cfif>
                                                <cfif code eq 'A.01'><cfinput type="hidden" name="donen_varliklar" value="#TLFormat(bakiye_total1)#"></cfif>
                                                <cfif code eq 'A.02'><cfinput type="hidden" name="duran_varliklar" value="#TLFormat(bakiye_total1)#"></cfif>
                                                <cfif code eq 'A.01.E'><cfinput type="hidden" name="stoklar" value="#TLFormat(bakiye_total1)#"></cfif>
                                            </tr>
                                        </cfif>
                                    </cfoutput>
                                </cfloop>
                            <cfelse>
                                <tr>
                                    <td colspan="6"><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'>!</td>
                                </tr>
                            </cfif>
                        </tbody>
                    </cf_grid_list>

                   <!--- </cf_medium_list>--->
                </cfsavecontent>
                <cfoutput>#cont#</cfoutput>
                <!-- sil -->
                <textarea name="cons_last" id="cons_last" style="display:none;"><cfoutput>#cont#</cfoutput></textarea>
                <!-- sil -->
            </cfform>
           <cfif isDefined('attributes.copy_name') and len(attributes.copy_name)>
                <cfset adres = "#adres#&copy_name=#attributes.copy_name#">
            </cfif>
            <cfif isDefined('attributes.PROCESS_STAGE') and len(attributes.PROCESS_STAGE)>
                <cfset adres = "#adres#&PROCESS_STAGE=#attributes.PROCESS_STAGE#">
            </cfif>
            <cfif isDefined('attributes.table_code_type') and len(attributes.table_code_type)>
                <cfset adres = "#adres#&table_code_type=#attributes.table_code_type#">
            </cfif>
            <cfif isDefined('attributes.sal_year') and len(attributes.sal_year)>
                <cfset adres = "#adres#&sal_year=#attributes.sal_year#">
            </cfif>
            <cfif isDefined('attributes.sal_year') and len(attributes.sal_year)>
                <cfset adres = "#adres#&sal_year=#attributes.sal_year#">
            </cfif>
            <cfif isDefined('attributes.acc_branch_id') and len(attributes.acc_branch_id)>
                <cfset adres = "#adres#&acc_branch_id=#attributes.acc_branch_id#">
            </cfif>
            <cfif isDefined('attributes.acc_card_type') and len(attributes.acc_card_type)>
                <cfset adres = "#adres#&acc_card_type=#attributes.acc_card_type#">
            </cfif>
            <cfif isDefined('attributes.start_date') and len(attributes.start_date)>
                <cfset adres = "#adres#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
            </cfif>
            <cfif isDefined('attributes.finish_date') and len(attributes.finish_date)>
                <cfset adres = "#adres#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
            </cfif>
                <cf_paging 
                    page="#attributes.page#"
                    maxrows="#attributes.maxrows#"
                    totalrecords="#attributes.totalrecords#"
                    startrow="#attributes.startrow#"
                    adres="#adres#">
        </cfif>
    </cf_box>
</div>
<cfif len(attributes.is_submitted) and  get_table_def.recordcount>
<div class="col col-12">
    <cf_box>
        <div class="row ui-form-list ui-form-block" type="row">
            <div class="form-group col col-2 col-md-3 col-sm-6 col-xs-12">
                <label><cf_get_lang dictionary_id="59295.Arşivle"></label>
                <input type="text" name="user_given_name" id="user_given_name">
            </div>
            <div class="form-group col col-2 col-md-3 col-sm-6 col-xs-12">
                <label><cf_get_lang dictionary_id="58859.Süreç"></label>
                <cf_workcube_process is_upd='0' select_value='#attributes.process_stage#' is_select_text='1' process_cat_width='150' is_detail='0'>
            </div>
            <div class="form-group col col-2 col-md-3 col-sm-6 col-xs-12">
                <label><cf_get_lang dictionary_id="57899.Kaydeden"></label>
                <div class="input-group">
                    <input type="hidden" name="record_id" id="record_id" value="<cfif len(attributes.record_name) and len(attributes.record_id)><cfoutput>#attributes.record_id#</cfoutput></cfif>" >					
                    <input type="text" name="record_name" id="record_name" placeholder="<cfoutput>#getLang('main',487)#</cfoutput>" value="<cfif len(attributes.record_name) and len(attributes.record_id)><cfoutput>#attributes.record_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('record_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','MEMBER_ID','record_id','','3','125');"  autocomplete="off" >                    
                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=search.record_name&field_emp_id=search.record_id&select_list=1','list');return false"></span>
                </div>
            </div>
            <div class="form-group col col-2 col-md-3 col-sm-6 col-xs-12">
                <label><cf_get_lang dictionary_id="57627.Kayıt Tarihi"></label>
                <div class="input-group">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"><cf_get_lang dictionary_id="57627.Kayıt Tarihi"></cfsavecontent>
                    <input value="" type="text" name="record_date" id="record_date">
                    <span class="input-group-addon"><cf_wrk_date_image date_field="record_date"></span>
                </div>
            </div>
          
        </div>
        <div class="ui-form-list-btn">
            <cf_workcube_buttons add_function="save_balance()">
        </div>
    </cf_box>
</div>
</cfif>
<script>
    function save_balance()
	{
		if (document.getElementById("finish_date").value=='')
		{
			alert("<cf_get_lang dictionary_id ='47459.Önce Tarihleri Seçiniz'>!");
			return false;
		}
		date2 = document.getElementById("finish_date").value;
		fintab_type_ = document.getElementById("fintab_type").value;
        user_given_name = document.getElementById("user_given_name").value;
		windowopen('<cfoutput>#request.self#?fuseaction=account.popup_add_financial_table&module=#fusebox.circuit#&faction=#fusebox.fuseaction#</cfoutput>&fintab_type='+fintab_type_+'&date2='+date2+'&user_given_name='+user_given_name,'small');
	}
</script>
<cfsetting showdebugoutput="yes">