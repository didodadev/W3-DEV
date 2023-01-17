<!---
    File: received_einvoices.cfm
    Folder: V16\e_government\display\
	Controller: 
    Author:
    Date:
    Description:
        
    History:
        Gramoni-Mahmut Çifçi mahmut.cifci@gramoni.com 2019-12-23 18:06:36
        Gelen efatura listeleme sayfası, sağlık harcama ekranlarından popup olarak çağırılır.

        Gramoni-Mahmut Çifçi mahmut.cifci@gramoni.com 2020-03-27 23:55:34
        E-government standart modüle taşındı
    To Do:

--->

<cf_xml_page_edit fuseact="invoice.received_einvoices">
<cfquery name="GET_EFATURA_CONTROL" datasource="#DSN#">
	SELECT
    	IS_EFATURA,
        EINVOICE_TYPE
	FROM
    	OUR_COMPANY_INFO
    WHERE
    	COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">        
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfif len(get_efatura_control.is_efatura) and len(get_efatura_control.einvoice_type)>
        <cfif isdefined("attributes.record_date_start") and isdate(attributes.record_date_start)>
            <cf_date tarih = "attributes.record_date_start">
        <cfelseif not isdefined("attributes.record_date_start") and not isdefined("attributes.form_submitted")>
            <cfset attributes.record_date_start = date_add('d',-7,now())>
        <cfelse>
            <cfparam name="attributes.record_date_start" default="">
        </cfif>
        <cfif isdefined("attributes.record_date_finish") and isdate(attributes.record_date_finish)>
            <cf_date tarih = "attributes.record_date_finish">
        <cfelseif not isdefined("attributes.record_date_finish") and not isdefined("attributes.form_submitted")>
            <cfset attributes.record_date_finish = now()>
        <cfelse>
            <cfparam name="attributes.record_date_finish" default="">
        </cfif>
        <cfif isdefined("attributes.process_date_start") and isdate(attributes.process_date_start)>
            <cf_date tarih = "attributes.process_date_start">
        <cfelse>
            <cfparam name="attributes.process_date_start" default="">
        </cfif>
        <cfif isdefined("attributes.process_date_finish") and isdate(attributes.process_date_finish)>
            <cf_date tarih = "attributes.process_date_finish">
        <cfelse>
            <cfparam name="attributes.process_date_finish" default="">
        </cfif>
        
        <cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
            <cf_date tarih = "attributes.start_date">
        <cfelse>
            <cfparam name="attributes.start_date" default="">
        </cfif>
        <cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
            <cf_date tarih = "attributes.finish_date">
        <cfelse>
            <cfparam name="attributes.finish_date" default="">
        </cfif>
        <cfparam name="attributes.process_stage" default="">
        <cfparam name="attributes.invoice_status" default="">
        <cfparam name="attributes.invoiceType" default="">
        <cfparam name="attributes.keyword" default="">
        <cfparam name="attributes.is_process" default="">
        <cfparam name="attributes.page" default="1">
        <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
        <cfparam name="attributes.profile" default="">
        <cfparam name="attributes.order_type" default="1">
        <cfparam name="attributes.company" default="">
        <cfparam name="attributes.branch_id" default="" />
        <cfparam name="attributes.department_id" default="" />
        <cfparam name="attributes.project_id" default="">
        <cfparam name="attributes.project_head" default="">
        <cfparam name="attributes.from_page" default="" />
        <cfparam name="attributes.field_invoice_id" default="" />
        <cfparam name="attributes.field_invoice_number" default="" />
        <cfparam name="attributes.field_comp_id" default="" />
        <cfparam name="attributes.field_comp_name" default="" />
        <cfparam name="attributes.field_last_total" default="" />
        <cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
        <cfquery name="get_process_type" datasource="#DSN#">
            SELECT
                PTR.STAGE,
                PTR.PROCESS_ROW_ID,
                PT.PROCESS_NAME,
                PT.PROCESS_ID
            FROM
                PROCESS_TYPE_ROWS PTR,
                PROCESS_TYPE_OUR_COMPANY PTO,
                PROCESS_TYPE PT
            WHERE
                PT.IS_ACTIVE = 1 AND
                PT.PROCESS_ID = PTR.PROCESS_ID AND
                PT.PROCESS_ID = PTO.PROCESS_ID AND
                PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%objects.popup_dsp_efatura_detail%">
            ORDER BY
                PT.PROCESS_NAME,
                PTR.LINE_NUMBER
        </cfquery>
        <cfif isdefined("attributes.form_submitted")>
            <cfset up_dep = 0>
            <cfif x_department_authority>
                <cfquery name="get_hierarcy" datasource="#dsn2#">
                    SELECT 
                        D.HIERARCHY_DEP_ID 
                    FROM 
                        #dsn_alias#.DEPARTMENT D,
                        #dsn_alias#.EMPLOYEE_POSITIONS EP 
                    WHERE 
                        EP.DEPARTMENT_ID = D.DEPARTMENT_ID
                        AND POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
                </cfquery>
                <cfif get_hierarcy.recordcount and listlen(get_hierarcy.HIERARCHY_DEP_ID,'.') gt 1>
                    <cfset hierarcy_id_list = valuelist(get_hierarcy.HIERARCHY_DEP_ID,',')>
                    <cfset up_dep=ListGetAt(hierarcy_id_list,evaluate("#listlen(hierarcy_id_list,".")#-1"),".") >		
                </cfif>
                <cfif not len(up_dep)>
                    <cfset up_dep = 0>
                </cfif>
            </cfif>

            <cfquery name="get_efatura_det" datasource="#dsn2#">
                WITH CTE1 AS (
                    SELECT 
                        ERD.RECEIVING_DETAIL_ID,
                        ERD.EINVOICE_ID, 
                        ERD.INVOICE_TYPE_CODE, 
                        ERD.SENDER_TAX_ID, 
                        ERD.PROFILE_ID, 
                        ERD.PAYABLE_AMOUNT, 
                        ERD.PAYABLE_AMOUNT_CURRENCY, 
                        ERD.ISSUE_DATE, 
                        ERD.PARTY_NAME, 
                        ERD.CREATE_DATE,
                        ERD.RECORD_DATE,
                        ERD.UPDATE_DATE,
                        ERD.STATUS,
                        ERD.ORDER_NUMBER, 
                        ISNULL(ERD.PRINT_COUNT,0) AS PRINT_COUNT,
                        ERD.PATH,           
                        ISNULL(ERD.IS_MANUEL,0) IS_MANUEL,                
                        ISNULL(ERD.IS_PROCESS,0) IS_PROCESS,
                        I.INVOICE_ID,
                        I.INVOICE_NUMBER,
                        <cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
                            I.CONSUMER_ID,
                        </cfif>
                        <cfif isdefined("attributes.company_id") and len(attributes.company_id)>
                            I.COMPANY_ID,
                        <cfelse>
                            '' COMPANY_ID,
                        </cfif>
                        I.PROJECT_ID,
                        I.INVOICE_CAT,
                        EIP.EXPENSE_ID,
                        EIP.PAPER_NO,
                        PTR.STAGE,
                        O.ORDER_ID ,
                        EIP.ACTION_TYPE               
                    FROM 
                        EINVOICE_RECEIVING_DETAIL ERD
                        LEFT JOIN INVOICE I ON ERD.INVOICE_ID = I.INVOICE_ID
                        LEFT JOIN EXPENSE_ITEM_PLANS EIP ON ERD.EXPENSE_ID = EIP.EXPENSE_ID
                        LEFT JOIN #dsn_alias#.PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = ERD.PROCESS_STAGE
                        LEFT JOIN #dsn3_alias#.ORDERS O ON O.ORDER_NUMBER = ERD.ORDER_NUMBER AND O.PURCHASE_SALES = 0 AND O.ORDER_ZONE = 0
                        <cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
                            LEFT JOIN #dsn_alias#.CONSUMER CONS ON CONS.CONSUMER_ID = I.CONSUMER_ID
                        </cfif>
                    WHERE
                        1=1
                        <cfif len(attributes.start_date)>
                            AND	ERD.ISSUE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> 
                        </cfif>
                        <cfif len(attributes.finish_date)>
                            AND	ERD.ISSUE_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,attributes.finish_date)#"> 
                        </cfif>
                        <cfif len(attributes.process_date_start)>
                            AND	ERD.UPDATE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.process_date_start#"> 
                        </cfif>
                        <cfif len(attributes.process_date_finish)>
                            AND	ERD.UPDATE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.process_date_finish#"> 
                        </cfif>
                        <cfif len(attributes.record_date_start)>
                            AND	ERD.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.record_date_start#"> 
                        </cfif>
                        <cfif len(attributes.record_date_finish)>
                            AND	ERD.RECORD_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,attributes.record_date_finish)#"> 
                        </cfif>
                        <cfif len(attributes.is_process)>
                            AND ISNULL(ERD.IS_PROCESS,0) = #attributes.is_process#
                        </cfif>
                        <cfif len(attributes.profile)>
                            AND ERD.PROFILE_ID = '#attributes.profile#'
                        </cfif>
                        <cfif len(attributes.invoice_status)>
                            AND STATUS = #attributes.invoice_status#
                        </cfif>
                        <cfif Len(attributes.process_stage)>
                            AND ERD.PROCESS_STAGE = #attributes.process_stage#
                        </cfif>
                        <cfif isDefined('attributes.invoiceType') and len(attributes.invoiceType)>
                            AND ERD.INVOICE_TYPE_CODE = '#attributes.invoiceType#'
                        </cfif>
                        <cfif x_branch_authority And x_department_authority And Not listFind(x_show_all_invoice_positions,session.ep.position_code)>
                            AND (
                                    (
                                        (ERD.DEPARTMENT_ID = (SELECT ISNULL(DEPARTMENT_ID,0) FROM #dsn#.EMPLOYEE_POSITIONS WHERE POSITION_CODE = #session.ep.position_code# AND IS_MASTER = 1) OR ERD.DEPARTMENT_ID = #up_dep#)
                                        AND ERD.POSITION_IDS IS NULL
                                    )
                                    OR
                                    (
                                        ERD.POSITION_IDS LIKE CASE WHEN ERD.POSITION_IDS IS NOT NULL THEN '%,#session.ep.POSITION_CODE#,%' END
                                        AND ERD.DEPARTMENT_ID IS NULL
                                    )
                                )
                        <cfelseif isDefined('attributes.DEPARTMENT_ID') and len(attributes.DEPARTMENT_ID)>
                            AND  ERD.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.DEPARTMENT_ID#">
                        </cfif>
                        <cfif isDefined('attributes.BRANCH_ID') and len(attributes.BRANCH_ID)>
                            AND  ERD.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.BRANCH_ID#">
                        </cfif>
                        <cfif len(attributes.company) and len(attributes.company_id) and attributes.company_id neq 0 and attributes.member_type is 'partner'>
                            AND (I.COMPANY_ID=	<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
                            OR EIP.CH_COMPANY_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">)
                        </cfif>
                        <cfif len(attributes.company) and len(attributes.consumer_id) and attributes.consumer_id neq 0 and attributes.member_type is 'consumer'>
                            AND I.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
                        </cfif>
                        <cfif len(attributes.company) and len(attributes.employee_id) and attributes.employee_id neq 0 and attributes.member_type is 'employee'>
                            AND I.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.employee_id,'_')#">
                        </cfif>
                        <cfif isDefined('attributes.project_id') and len(attributes.project_id) and isdefined('attributes.project_head') and len(attributes.project_head)>
                            AND  I.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                        </cfif>
                        <cfif len(attributes.keyword)>
                            <cfif len(trim(attributes.keyword)) lte 3>
                            AND (
                                    ERD.SENDER_TAX_ID = '#trim(attributes.keyword)#' OR 
                                    ERD.EINVOICE_ID LIKE '#trim(attributes.keyword)#%' OR 
                                    ERD.PARTY_NAME LIKE '#trim(attributes.keyword)#%' OR
                                    (I.INVOICE_NUMBER = '#trim(attributes.keyword)#' AND ERD.INVOICE_ID IS NOT NULL) OR
                                    ERD.ORDER_NUMBER = '#trim(attributes.keyword)#%'
                                                            
                                )
                            <cfelseif len(trim(attributes.keyword)) gt 3>
                            AND (
                                    ERD.PARTY_NAME LIKE '%#trim(attributes.keyword)#%' OR
                                    ERD.SENDER_TAX_ID = '#trim(attributes.keyword)#'  OR 
                                    ERD.EINVOICE_ID LIKE '%#trim(attributes.keyword)#%' OR
                                    (I.INVOICE_NUMBER = '#trim(attributes.keyword)#' AND ERD.INVOICE_ID IS NOT NULL) OR 
                                    ERD.ORDER_NUMBER = '%#trim(attributes.keyword)#%'  
                                                        
                                )
                            </cfif>
                        </cfif>
                    ),
                    CTE2 AS (
                    SELECT
                        CTE1.*,
                        ROW_NUMBER() OVER ( ORDER BY <cfif attributes.order_type eq 1>ISSUE_DATE DESC<cfelseif attributes.order_type eq 2>RECORD_DATE DESC<cfelseif attributes.order_type eq 3>UPDATE_DATE DESC<cfelseif attributes.order_type eq 4>EINVOICE_ID<cfelseif attributes.order_type eq 5>PARTY_NAME</cfif>) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                    FROM
                        CTE1
                )
                SELECT
                    CTE2.*
                FROM
                    CTE2
                WHERE
                    RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
            </cfquery>
            <cfif get_efatura_det.recordcount>
                <cfparam name="attributes.totalrecords" default="#get_efatura_det.query_count#">
            <cfelse>
                <cfparam name="attributes.totalrecords" default="0">
            </cfif>
        <cfelse>
            <cfparam name="attributes.totalrecords" default="0">	
            <cfset get_efatura_det.recordcount = 0>
        </cfif>
        <cf_box>
            <cfform name="received_invoice" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.received_einvoices">
                <input type="hidden" name="form_submitted" id="form_submitted" value="1">
                <cf_box_search>
                    <div class="form-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="57460.Filtre"></cfsavecontent>
                        <input type="text" name="keyword" id="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>" placeholder="<cfoutput>#message#</cfoutput>" title="<cf_get_lang dictionary_id='59822.Gönderen Firma'>,<cf_get_lang dictionary_id='59823.Gönderici Vergi No'>,<cf_get_lang dictionary_id='58133.Fatura No'>,<cf_get_lang dictionary_id='58211.Sipariş No'>"/>  
                    </div>
                    <div class="form-group">
                        <select name="order_type" id="order_type">
                            <option value="1" <cfif attributes.order_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57069.Fatura Tarihine Göre Azalan'></option>
                            <option value="2" <cfif attributes.order_type eq 2>selected</cfif>><cf_get_lang dictionary_id='57070.Kayıt Tarihine Göre Azalan'></option>
                            <option value="3" <cfif attributes.order_type eq 3>selected</cfif>><cf_get_lang dictionary_id='57071.İşlem Tarihine Göre Azalan'></option>
                            <option value="4" <cfif attributes.order_type eq 4>selected</cfif>><cf_get_lang dictionary_id='57072.Fatura Noya Göre Artan'></option>
                            <option value="5" <cfif attributes.order_type eq 5>selected</cfif>><cf_get_lang dictionary_id='57085.Firmaya Göre Artan'></option>
                        </select>
                    </div>
                    <div class="form-group">
                        <select name="invoiceType" id="invoiceType" style="width:100px;">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <option value="SATIS" <cfif attributes.invoiceType eq "SATIS">selected</cfif>><cf_get_lang dictionary_id="57448.Satış"></option>
                            <option value="IADE" <cfif attributes.invoiceType eq "IADE">selected</cfif>><cf_get_lang dictionary_id="29418.İade"></option>
                            <option value="TEVKIFAT" <cfif attributes.invoiceType eq "TEVKIFAT">selected</cfif>><cf_get_lang dictionary_id="58022.Tevkifat"></option>
                            <option value="ISTISNA" <cfif attributes.invoiceType eq "ISTISNA">selected</cfif>><cf_get_lang dictionary_id="59028.İstisna"></option>
                            <option value="ARACTESCIL" <cfif attributes.invoiceType eq "ARACTESCIL">selected</cfif>><cf_get_lang dictionary_id="59026.Araç Tescil"></option>
                            <option value="OZELMATRAH" <cfif attributes.invoiceType eq "OZELMATRAH">selected</cfif>><cf_get_lang dictionary_id="59027.Özel Matrah"></option>
                        </select> 
                    </div>
                    <div class="form-group" id="item-record_date">
                        <div class="input-group">
                            <cfinput type="text" name="record_date_start" value="#dateformat(attributes.record_date_start, dateformat_style)#" validate="#validate_style#" maxlength="10">
                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="record_date_start"></span>
                        </div>
                    </div>
                    <div class="form-group" id="item-record_date2">
                        <div class="input-group">
                            <cfinput type="text" name="record_date_finish" value="#dateformat(attributes.record_date_finish, dateformat_style)#" validate="#validate_style#" maxlength="10">                    
                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="record_date_finish"></span>
                        </div>
                    </div>
                    <div class="form-group small">
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,1250">
                    </div>
                    <div class="form-group">
                        <cf_wrk_search_button button_type="4">
                    </div>
                </cf_box_search>
                <cf_box_search_detail>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-is_process">
                            <label class="col col-12"><cf_get_lang dictionary_id="57061.İşlenmiş"> / <cf_get_lang dictionary_id="57063.İşlenmemişler"></label>
                            <div class="col col-12">
                                <select name="is_process" id="is_process" style="width:100px;">
                                    <option value=""><cf_get_lang dictionary_id ='57708.Tümü'></option>
                                    <option value="1" <cfif attributes.is_process eq 1>selected</cfif>><cf_get_lang dictionary_id ='57061.İşlenmiş'></option>
                                    <option value="0" <cfif attributes.is_process eq 0>selected</cfif>><cf_get_lang dictionary_id ='57063.İşlenmemişler'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-invoice_status">
                            <label class="col col-12"><cf_get_lang dictionary_id='57064.Kabul'>/<cf_get_lang dictionary_id='29537.Red'></label>
                            <div class="col col-12">
                                <select name="invoice_status" id="invoice_status" style="width:90px">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <option value="1" <cfif attributes.invoice_status eq 1>selected</cfif>><cf_get_lang dictionary_id='57064.Kabul'></option>
                                    <option value="0" <cfif attributes.invoice_status eq 0>selected</cfif>><cf_get_lang dictionary_id='29537.Red'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="form_ul_company">
                            <label class="col col-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <input type="hidden" name="consumer_id" id="consumer_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.consumer_id#</cfoutput>"</cfif>>
                                    <input type="hidden" name="company_id" id="company_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.company_id#</cfoutput>"</cfif>>
                                    <input type="hidden" name="employee_id" id="employee_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.employee_id#</cfoutput>"</cfif>>
                                    <input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type") and len(attributes.member_type)><cfoutput>#attributes.member_type#</cfoutput></cfif>">
                                    <input name="company" type="text" id="company" style="width:100px;" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'<cfif fusebox.circuit is 'store'>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\',\'0\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','company_id,consumer_id,employee_id,member_type','received_invoice','3','250');" value="<cfif len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&field_comp_name=received_invoice.company&field_comp_id=received_invoice.company_id&field_consumer=received_invoice.consumer_id&field_member_name=received_invoice.company&field_emp_id=received_invoice.employee_id&field_name=received_invoice.company&field_type=received_invoice.member_type<cfif fusebox.circuit is 'store'>&is_store_module=1</cfif>&select_list=2,3,1,9</cfoutput>&keyword='+encodeURIComponent(document.received_invoice.company.value),'list')"></span>
                                    </div>
                                </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-profile">
                            <label class="col col-12"><cf_get_lang dictionary_id="57059.Senaryo"></label>
                            <div class="col col-12">
                                <select name="profile" id="profile" style="width:100px">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <option value="TEMELFATURA" <cfif attributes.profile eq "TEMELFATURA">selected</cfif>><cf_get_lang dictionary_id='57067.Temel Fatura'></option>
                                    <option value="TICARIFATURA" <cfif attributes.profile eq "TICARIFATURA">selected</cfif>><cf_get_lang dictionary_id='29446.Ticari'><cf_get_lang dictionary_id='57441.Fatura'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-process_stage">
                            <label class="col col-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                            <div class="col col-12">
                                <select name="process_stage" id="process_stage" style="width:125px;">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_process_type">
                                        <option value="#get_process_type.process_row_id#" <cfif Len(attributes.process_stage) and attributes.process_stage eq get_process_type.process_row_id>selected</cfif>>#get_process_type.stage#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="form_ul_project_id">
                            <label class="col col-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                <cfif isdefined ("url.pro_id") and  len(url.pro_id)><cfset attributes.project_id=url.pro_id></cfif><!--- Proje icmal raporundan baska bir yerde kullanilmiyorsa pro_id kontrolu kaldirilabilir FBS 20110607 --->
                                <cfif Len(attributes.project_id) and Len(attributes.project_head)><cfset attributes.project_head = get_project_name(attributes.project_id)></cfif><!--- Buraya baska sayfalardan da erisiliyor, kaldirmayin FBS 20110607 --->
                                <input type="hidden" name="project_id" id="project_id" value="<cfif len (attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
                                <input type="text" name="project_head" id="project_head" value="<cfoutput>#attributes.project_head#</cfoutput>" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','150');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=received_invoice.project_id&project_head=received_invoice.project_head&allproject=1');"></span>
                            </div>
                                </div>
                        </div> 
                    </div>
                    <cfscript>
                        branch_deny_control     = 0;
                        department_deny_control = 0;
                        if (x_branch_authority Eq 1 Or session.ep.isBranchAuthorization Eq 1) {
                            branch_deny_control = 1;
                        }
                        if (x_department_authority Eq 1) {
                            department_deny_control = 1;
                        }
                    </cfscript>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group" id="item-branch_id">
                            <label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                            <div class="col col-12">
                                <cf_wrkdepartmentbranch fieldid='branch_id' is_branch='1' width='135' is_deny_control='#branch_deny_control#' selected_value='#attributes.branch_id#'>
                            </div>
                        </div>
                        <div class="form-group" id="item-department_id">
                            <label class="col col-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                            <div class="col col-12">
                                <cf_wrkdepartmentbranch fieldid='department_id' is_department='1' width='135' is_deny_control='#department_deny_control#' selected_value='#attributes.department_id#'>
                            </div>
                        </div> 
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                        <div class="form-group" id="item-invoice_date">
                            <label class="col col-12"><cf_get_lang dictionary_id='58759.Fatura Tarihi'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date, dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10">
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="start_date"></span>
                                    <span class="input-group-addon no-bg"></span>
                                    <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date, dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10">                    
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finish_date"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-process_date">
                            <label class="col col-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <cfinput type="text" name="process_date_start" value="#dateformat(attributes.process_date_start, dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10">
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="process_date_start"></span>
                                    <span class="input-group-addon no-bg"></span>
                                    <cfinput type="text" name="process_date_finish" value="#dateformat(attributes.process_date_finish, dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10">                    
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="process_date_finish"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </cf_box_search_detail>
            </cfform>
        </cf_box>
        <cfsavecontent variable="message"><cf_get_lang dictionary_id="47112.Gelen E-Fatura"></cfsavecontent>
        <cf_box title="#message#" uidrop="1" hide_table_column="1" woc_setting = "#{ checkbox_name : 'row_check', print_type : 1 }#">
            <cf_grid_list>    
                <thead>
                    <tr>
                        <th width="30"><cf_get_lang dictionary_id='57487.No'></th>
                        <th><cf_get_lang dictionary_id='57066.Gönderen'></th>
                        <th><cf_get_lang dictionary_id='57066.Gönderen'><br /><cf_get_lang dictionary_id='57068.Vergi No / TCKN'></th>
                        <th><cf_get_lang dictionary_id='58133.Fatura No'></th>
                        <th><cf_get_lang dictionary_id='58211.Sipariş No'></th>
                        <th><cf_get_lang dictionary_id='58783.Workcube'><cf_get_lang dictionary_id='57880.Belge No'></th>
                        <th><cf_get_lang dictionary_id='57673.Tutar'></th>
                        <th><cf_get_lang dictionary_id='57059.Senaryo'></th>
                        <th><cf_get_lang dictionary_id='57630.Tip'></th>
                        <th><cf_get_lang dictionary_id='58759.Fatura Tarihi'></th>
                        <th title="<cf_get_lang dictionary_id='60966.Entegratöre Geliş Tarihi'>"><cf_get_lang dictionary_id='60965.EG Tarihi'></th>
                        <th title="<cf_get_lang dictionary_id='60968.Entegratörden Alış Tarihi'>"><cf_get_lang dictionary_id='60967.EA Tarihi'></th>
                        <th><cf_get_lang dictionary_id='57879.İşlem Tarihi'></th>
                        <th><cf_get_lang dictionary_id='57482.Aşama'></th>
                        <th><cf_get_lang dictionary_id='57756.Durum'></th>
                        <!-- sil -->
                        <th width="20" class="header_icn_none text-center"><i class="fa fa-table" title="Detay"></i></th>
                        <th class="text-center"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></i></th>
                        <th width="20" class="header_icn_none text-center"><i class="fa fa-thumb-tack" title="<cf_get_lang dictionary_id='57909.İlişkilendir'>"></i></th>
                        <th width="20" class="header_icn_none text-center"><i class="fa fa-trash" alt="<cf_get_lang dictionary_id='57463.Sil'>" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></th>
                        <th>
                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=invoice.received_einvoices&event=add','small');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
                        </th>
                        <!-- sil -->
                        <th width="20" class="header_icn_none text-center">(P)</th>
                        <th width="20" class="header_icn_none text-center">
                            <input type="checkbox" name="row_all_check" id="row_all_check" onClick="all_check($(this))">
                            <a href="javascript://" class="mt-1"  onClick="printAll();"><i class="fa fa-print"></i></a>
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <cfif get_efatura_det.recordcount>
                        <cfoutput query="get_efatura_det">
                            <tr>
                                <td>#rownum#</td>
                                <td><cfif len(company_id)><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_efatura_det.company_id#','medium');"></cfif>#party_name#</a></td>
                                <td>#sender_tax_id#</td>
                                <td>
                                    <cfif isDefined('attributes.from_page') And attributes.from_page is 'health_expense_approve'>
                                        <a href="javascript:void(0);" onclick="load_opener_values('#RECEIVING_DETAIL_ID#','#einvoice_id#',<cfif Len(get_efatura_det.company_id)>#get_efatura_det.company_id#<cfelse>0</cfif>,'#party_name#','#TLFormat(payable_amount)#');" class="tableyazi">#einvoice_id#</a>
                                        <cfelse>
                                        <a href="#request.self#?fuseaction=objects.popup_download_file&file_name=/documents/#get_efatura_det.path#" class="tableyazi">#einvoice_id#</a>
                                    </cfif>
                                </td>
                                <td><cfif len(order_id)><a href="#request.self#?fuseaction=purchase.list_order&event=upd&order_id=#order_id#" class="tableyazi">#order_number#</a><cfelse>#order_number#</cfif></td>
                                <td>
                                    <cfif len(invoice_id)>
                                        <cfif listfind("50,51,52,53,54,55,56,561,57,58,59,60,601,61,62,63,66,67,531,591,592,48,49,532",invoice_cat,",")>
                                            <a href="#request.self#?fuseaction=invoice.form_add_bill_purchase&event=upd&iid=#invoice_id#" target="_blank" class="tableyazi">#invoice_number#</a>
                                        <cfelseif listfind("65",invoice_cat,",")>
                                            <a href="#request.self#?fuseaction=invent.add_invent_purchase&event=upd&invoice_id=#invoice_id#" target="_blank" class="tableyazi">#invoice_number#</a>
                                        <cfelse>
                                            <a href="#request.self#?fuseaction=invoice.form_add_bill_other&event=upd&iid=#invoice_id#" target="_blank" class="tableyazi">#invoice_number#</a>
                                        </cfif>
                                    <cfelseif len(expense_id)>
                                        <cfif action_type eq 1201>
                                            <a href="#request.self#?fuseaction=health.expenses&event=upd&expense_id=#expense_id#" class="tableyazi">#paper_no#</a>
                                        <cfelse>
                                            <a href="#request.self#?fuseaction=cost.form_add_expense_cost&event=upd&expense_id=#expense_id#" class="tableyazi">#paper_no#</a>
                                        </cfif>
                                    </cfif>
                                </td>
                                <td style="text-align:right" nowrap="nowrap">#tlformat(payable_amount)# #payable_amount_currency#</td>
                                <td>#profile_id#</td>
                                <td>#invoice_type_code#</td>
                                <td nowrap="nowrap">#dateformat(issue_date,dateformat_style)# #timeformat(issue_date,timeformat_style)#</td>
                                <td nowrap="nowrap"><cfif Len(create_date)>#dateformat(dateadd('h',session.ep.time_zone,create_date),dateformat_style)# #timeformat(dateadd('h',session.ep.time_zone,create_date),timeformat_style)#</cfif></td>
                                <td nowrap="nowrap">#dateformat(dateadd('h',session.ep.time_zone,record_date),dateformat_style)# #timeformat(dateadd('h',session.ep.time_zone,record_date),timeformat_style)#</td>
                                <cfif len(status)>
                                    <cfif status eq 1>
                                        <td nowrap="nowrap" title="<cf_get_lang dictionary_id='57064.Kabul'>"><font color="009933">#dateformat(dateadd('h',session.ep.time_zone,update_date),dateformat_style)# #timeformat(dateadd('h',session.ep.time_zone,update_date),timeformat_style)#</font></td>
                                        <td style="text-align:center"><font color="009933"><cf_get_lang dictionary_id='57064.Kabul'></font></td>
                                    <cfelse>
                                        <td nowrap="nowrap" title="Red Edildi"><font color="FF0000"><cfif len(update_date)>#dateformat(dateadd('h',session.ep.time_zone,update_date),dateformat_style)# #TIMEFORMAT(dateadd('h',session.ep.time_zone,update_date),timeformat_style)#</font></cfif></td>
                                        <td style="text-align:center"><font color="FF0000"><cf_get_lang dictionary_id='29537.Red'></font></td>
                                    </cfif>
                                <cfelse>
                                    <td></td>
                                    <td style="text-align:center"><cf_get_lang dictionary_id='57058.Bekliyor'></td>
                                </cfif>
                                <td>#stage#</td>
                                <td><a target="_blank" href="#request.self#?fuseaction=invoice.received_einvoices&event=det&receiving_detail_id=#receiving_detail_id#&type=1" style="text-align:left"><i class="fa fa-lg fa-table" title="<cf_get_lang dictionary_id='57771.Detay'>"></i></a></td>
                                <td>
                                    <cfif len(invoice_id)>
                                        <cfif listfind("50,51,52,53,54,55,56,561,57,58,59,60,601,61,62,63,66,67,531,591,592,48,49,532",invoice_cat,",")>
                                            <a href="#request.self#?fuseaction=invoice.form_add_bill_purchase&event=upd&iid=#invoice_id#" target="_blank"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                                        <cfelseif listfind("65",invoice_cat,",")>
                                            <a href="#request.self#?fuseaction=invent.add_invent_purchase&event=upd&invoice_id=#invoice_id#" target="_blank"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                                        <cfelse>
                                            <a href="#request.self#?fuseaction=invoice.form_add_bill_other&event=upd&iid=#invoice_id#" target="_blank"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                                        </cfif>
                                    </cfif>
                                    <cfif len(expense_id)>
                                        <cfif action_type eq 1201>
                                            <a href="#request.self#?fuseaction=health.expenses&event=upd&expense_id=#expense_id#" target="_blank"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                                        <cfelse>
                                            <a href="#request.self#?fuseaction=cost.form_add_expense_cost&event=upd&expense_id=#expense_id#" target="_blank"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                                        </cfif>
                                    </cfif>
                                </td>
                                <td>
                                    <cfif not len(expense_id)>
                                        <a href="#request.self#?fuseaction=invoice.received_einvoices&event=det&receiving_detail_id=#receiving_detail_id#&associate=1" target="_blank">
                                        <i class="fa fa-lg fa-thumb-tack" title="İlişkilendir"></i>
                                        </a>
                                    </cfif>
                                </td>
                                <td>
                                    <cfif is_manuel eq 1 and is_process eq 0>
                                        <cfsavecontent variable="mesaj"><cf_get_lang dictionary_id='57533.Silmek İstediginizden Emin Misiniz ?'></cfsavecontent>
                                        <a href="javascript://" onClick="if (confirm('#mesaj#')) windowopen('#request.self#?fuseaction=invoice.emptypopup_del_efatura_xml&receiving_detail_id=#receiving_detail_id#','small');"><i class="fa fa-lg fa-trash" alt="<cf_get_lang dictionary_id='57463.Sil'>" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>
                                    </cfif>
                                </td>
                                <td></td>
                                <td class="text-center">#print_count#</td>
                                <!-- sil -->
                                <td class="text-center">
                                    <input type="checkbox" name="row_#rownum#" id="row_check" data-receiving_detail_id="#receiving_detail_id#">
                                </td>
                                <!-- sil -->
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <td colspan="23"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
                    </cfif>
                </tbody>
            </cf_grid_list>
            <cfif attributes.totalrecords gt attributes.maxrows>    
                <cfset adres="#listgetat(attributes.fuseaction,1,'.')#.received_einvoices&form_submitted=1">
                <cfif len(attributes.keyword)>
                    <cfset adres = "#adres#&keyword=#attributes.keyword#">
                </cfif>
                <cfif len(attributes.is_process)>
                    <cfset adres = "#adres#&is_process=#attributes.is_process#">
                </cfif>
                <cfif isDefined('attributes.invoice_status') and len(attributes.invoice_status)>
                    <cfset adres = "#adres#&invoice_status=#attributes.invoice_status#">
                </cfif>
                <cfif isDefined('attributes.profile') and len(attributes.profile)>
                    <cfset adres = "#adres#&profile=#attributes.profile#">
                </cfif>
                <cfif isDefined('attributes.process_stage') and len(attributes.process_stage)>
                    <cfset adres = "#adres#&process_stage=#attributes.process_stage#">
                </cfif>
                <cfif isDefined('attributes.invoiceType') and len(attributes.invoiceType)>
                    <cfset adres = "#adres#&process_type=#attributes.invoiceType#">
                </cfif>
                <cfif isdate(attributes.record_date_start)>
                    <cfset adres = "#adres#&record_date_start=#dateformat(attributes.record_date_start,dateformat_style)#">
                </cfif>
                <cfif isdate(attributes.record_date_finish)>
                    <cfset adres = "#adres#&record_date_finish=#dateformat(attributes.record_date_finish,dateformat_style)#">
                </cfif>
                <cfif isdate(attributes.process_date_start)>
                    <cfset adres = "#adres#&process_date_start=#dateformat(attributes.process_date_start,dateformat_style)#">
                </cfif>
                <cfif isdate(attributes.process_date_finish)>
                    <cfset adres = "#adres#&process_date_finish=#dateformat(attributes.process_date_finish,dateformat_style)#">
                </cfif>
                <cfif isdate(attributes.start_date)>
                    <cfset adres = "#adres#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
                </cfif>
                <cfif isdate(attributes.finish_date)>
                    <cfset adres = "#adres#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
                </cfif>
                <cfif isDefined('attributes.order_type') and len(attributes.order_type)>
                    <cfset adres = "#adres#&order_type=#attributes.order_type#">
                </cfif>
                <cfif isDefined('attributes.from_page') and len(attributes.from_page)>
                    <cfset adres = "#adres#&from_page=#attributes.from_page#" />
                </cfif>
                <cfif isDefined('attributes.field_invoice_id') and len(attributes.field_invoice_id)>
                    <cfset adres = "#adres#&field_invoice_id=#attributes.field_invoice_id#" />
                </cfif>
                <cfif isDefined('attributes.field_invoice_number') and len(attributes.field_invoice_number)>
                    <cfset adres = "#adres#&field_invoice_number=#attributes.field_invoice_number#" />
                </cfif>
                <cfif isDefined('attributes.field_comp_id') and len(attributes.field_comp_id)>
                    <cfset adres = "#adres#&field_comp_id=#attributes.field_comp_id#" />
                </cfif>
                <cfif isDefined('attributes.field_comp_name') and len(attributes.field_comp_name)>
                    <cfset adres = "#adres#&field_comp_name=#attributes.field_comp_name#" />
                </cfif>
                <cfif isDefined('attributes.field_last_total') and len(attributes.field_last_total)>
                    <cfset adres = "#adres#&field_last_total=#attributes.field_last_total#" />
                </cfif>
                <cf_paging page="#attributes.page#"
                    maxrows="#attributes.maxrows#"
                    totalrecords="#attributes.totalrecords#"
                    startrow="#attributes.startrow#"
                    adres="#adres#">
            </cfif>
        </cf_box>
    <cfelse>
        <cf_get_lang dictionary_id='57539.Modülünde yetki seviyeniz işlem yapmaya uygun değil!'>
    </cfif>
</div>
<script type="text/javascript">
	function kontrol_et(yol)
	{
		document.getElementById('keyword').value = yol;
		document.execCommand('SaveAs','false',yol);
	}
    function all_check(e){
        var status = $(e).prop('checked');
        $('input#row_check').each(function() {
            $( this ).prop('checked',status);
        });
    }
    function printAll(){
        select_receiving_detail_id = '0';
        $('input#row_check').each(function() {
            var status = $(this).prop('checked');
            if(status){
                var receiving_detail_id = $( this ).data('receiving_detail_id');
                console.log(receiving_detail_id);
                select_receiving_detail_id += ',' + receiving_detail_id;
            }
        });
        console.log(select_receiving_detail_id);
        if (select_receiving_detail_id !='0'){
            windowopen('/index.cfm?fuseaction=objects.popup_dsp_efatura_detail&type=1&print=1&print_id='+select_receiving_detail_id,'wwide');
        }
    }
    <cfif isDefined('attributes.from_page') And attributes.from_page is 'health_expense_approve'>
    function load_opener_values(invoice_id,invoice_number,company_id,company_name,last_total) {
        window.opener.document.<cfoutput>#field_invoice_id#</cfoutput>.value = invoice_id;
        window.opener.document.<cfoutput>#field_invoice_number#</cfoutput>.value = invoice_number;
        window.opener.document.<cfoutput>#field_comp_id#</cfoutput>.value = company_id;
        window.opener.document.<cfoutput>#field_comp_name#</cfoutput>.value = company_name;
        window.opener.document.<cfoutput>#field_last_total#</cfoutput>.value = last_total;
        window.close();
    }
    </cfif>
</script>