<cf_xml_page_edit fuseact="account.list_cards">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.company" default="">
    <cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.consumer_id" default="">
    <cfparam name="attributes.belge_no" default="">
    <cfparam name="attributes.fis_type" default="">
    <cfparam name="attributes.page_action_type" default="">
    <cfparam name="attributes.acc_branch_id" default="">
    <cfparam name="attributes.list_type_form" default="1">
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
    <cfparam name="attributes.action_process_cat" default="">
    <cfparam name="attributes.project_id" default="">
    <cfparam name="attributes.project_head" default="">
    <cfparam name="attributes.show_type" default="">
    <cfparam name="attributes.doc_type" default="">
    <cfif xml_get_today eq 1 and not isdefined("attributes.start_date")>
        <cfparam name="attributes.start_date" default="#wrk_get_today()#">
    <cfelseif session.ep.our_company_info.UNCONDITIONAL_LIST>
        <cfparam name="attributes.start_date" default="">
    <cfelse>
        <cfparam name="attributes.start_date" default="#wrk_get_today()#">
    </cfif>
    <cfif xml_get_today eq 1 and not isdefined("attributes.finish_date")>
        <cfparam name="attributes.finish_date" default="#wrk_get_today()#">
    <cfelseif session.ep.our_company_info.UNCONDITIONAL_LIST>
        <cfparam name="attributes.finish_date" default="">
    <cfelse>
        <cfparam name="attributes.finish_date" default="#wrk_get_today()#">
    </cfif>
    <cfif xml_get_today eq 1 and not isdefined("attributes.record_date")>
        <cfparam name="attributes.record_date" default="#wrk_get_today()#">
    <cfelse>
        <cfparam name="attributes.record_date" default="">
    </cfif>
    <cfif xml_get_today eq 1 and not isdefined("attributes.finish_record_date")>
        <cfparam name="attributes.finish_record_date" default="#wrk_get_today()#">
    <cfelse>
        <cfparam name="attributes.finish_record_date" default="">
    </cfif>
    
    <cfparam name="attributes.page" default="1" >
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfif isdefined("attributes.maxrows") and attributes.maxrows gt 250>
        <cfset attributes.maxrows = 250>
    </cfif>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfparam name="attributes.employee_name" default="">
    <cfparam name="attributes.employee_id" default="">
    <cfparam name="attributes.totalrecords" default='0'>
    <cfif isdefined("attributes.form_varmi")>
        <cfif isdate(attributes.start_date)>
            <cf_date tarih = "attributes.start_date">
        </cfif>
        <cfif isdate(attributes.finish_date)>
            <cf_date tarih = "attributes.finish_date">
        </cfif>
        <cfif isdate(attributes.record_date)>
            <cf_date tarih="attributes.record_date">
        </cfif>
        <cfif isdate(attributes.finish_record_date)>
            <cf_date tarih = "attributes.finish_record_date">
        </cfif>
        <cfscript>
            get_denied_pages = createObject("component", "V16.project.cfc.get_project_detail");
            get_denied_page = get_denied_pages.GET_EMP_DEL_BUTTONS(22,session.ep.userid,session.ep.position_code,'account.list_cards');
            get_cards_action = createObject("component", "V16.account.cfc.get_cards");
            get_cards_action.dsn2 = dsn2;
            get_cards_action.dsn_alias = dsn_alias;
        </cfscript>
        <cfif isdefined('attributes.fis_type') and (attributes.fis_type eq 3 or attributes.fis_type eq 5)>
            <cfscript>
                get_cards = get_cards_action.get_cards_fnc
                    (
                        fis_type : '#IIf(IsDefined("attributes.fis_type"),"attributes.fis_type",DE(""))#',
                        start_date : '#IIf(IsDefined("attributes.start_date"),"attributes.start_date",DE(""))#',
                        finish_date : '#IIf(IsDefined("attributes.finish_date"),"attributes.finish_date",DE(""))#',
                        employee_id : '#IIf(IsDefined("attributes.employee_id"),"attributes.employee_id",DE(""))#',
                        employee_name : '#IIf(IsDefined("attributes.employee_name"),"attributes.employee_name",DE(""))#',
                        record_date : '#IIf(IsDefined("attributes.record_date"),"attributes.record_date",DE(""))#',
                        finish_record_date : '#IIf(IsDefined("attributes.finish_record_date"),"attributes.finish_record_date",DE(""))#',
                        keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(""))#',
                        oby : '#IIf(IsDefined("attributes.oby"),"attributes.oby",DE(""))#',
                        acc_branch_id : '#IIf(IsDefined("attributes.acc_branch_id"),"attributes.acc_branch_id",DE(""))#',
                        project_id : '#IIf(IsDefined("attributes.project_id"),"attributes.project_id",DE(""))#',
                        project_head : '#IIf(IsDefined("attributes.project_head"),"attributes.project_head",DE(""))#',
                        startrow : '#IIf(IsDefined("attributes.startrow"),"attributes.startrow",DE(""))#',
                        action_process_cat : '#IIf(IsDefined("attributes.action_process_cat"),"attributes.action_process_cat",DE(""))#',
                        show_type : '#IIf(IsDefined("attributes.show_type") and len(attributes.show_type),"attributes.show_type",DE(""))#',
                        maxrows : '#IIf(IsDefined("attributes.maxrows"),"attributes.maxrows",DE(""))#'
                    );
            </cfscript>
        <cfelseif isdefined('attributes.fis_type') and attributes.fis_type eq 6>
            <cfscript>
                get_cards = get_cards_action.get_cards_fnc2
                    (
                        main_card_id : '#IIf(IsDefined("attributes.main_card_id"),"attributes.main_card_id",DE(""))#',
                        start_date : '#IIf(IsDefined("attributes.start_date"),"attributes.start_date",DE(""))#',
                        finish_date : '#IIf(IsDefined("attributes.finish_date"),"attributes.finish_date",DE(""))#',
                        employee_id : '#IIf(IsDefined("attributes.employee_id"),"attributes.employee_id",DE(""))#',
                        employee_name : '#IIf(IsDefined("attributes.employee_name"),"attributes.employee_name",DE(""))#',
                        record_date : '#IIf(IsDefined("attributes.record_date"),"attributes.record_date",DE(""))#',
                        finish_record_date : '#IIf(IsDefined("attributes.finish_record_date"),"attributes.finish_record_date",DE(""))#',
                        keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(""))#',
                        oby : '#IIf(IsDefined("attributes.oby"),"attributes.oby",DE(""))#',
                        acc_branch_id : '#IIf(IsDefined("attributes.acc_branch_id"),"attributes.acc_branch_id",DE(""))#',
                        project_id : '#IIf(IsDefined("attributes.project_id"),"attributes.project_id",DE(""))#',
                        project_head : '#IIf(IsDefined("attributes.project_head"),"attributes.project_head",DE(""))#',
                        startrow : '#IIf(IsDefined("attributes.startrow"),"attributes.startrow",DE(""))#',
                        action_process_cat : '#IIf(IsDefined("attributes.action_process_cat"),"attributes.action_process_cat",DE(""))#',
                        show_type : '#IIf(IsDefined("attributes.show_type") and len(attributes.show_type),"attributes.show_type",DE(""))#',
                        maxrows : '#IIf(IsDefined("attributes.maxrows"),"attributes.maxrows",DE(""))#'
                    );
            </cfscript>
        <cfelse>
            <cfscript>
                get_cards = get_cards_action.get_cards_fnc3
                    (
                        fis_type : '#IIf(IsDefined("attributes.fis_type"),"attributes.fis_type",DE(""))#',
                        list_type_form : '#IIf(IsDefined("attributes.list_type_form"),"attributes.list_type_form",DE(""))#',
                        start_date : '#IIf(IsDefined("attributes.start_date"),"attributes.start_date",DE(""))#',
                        finish_date : '#IIf(IsDefined("attributes.finish_date"),"attributes.finish_date",DE(""))#',
                        employee_id : '#IIf(IsDefined("attributes.employee_id"),"attributes.employee_id",DE(""))#',
                        employee_name : '#IIf(IsDefined("attributes.employee_name"),"attributes.employee_name",DE(""))#',
                        record_date : '#IIf(IsDefined("attributes.record_date"),"attributes.record_date",DE(""))#',
                        finish_record_date : '#IIf(IsDefined("attributes.finish_record_date"),"attributes.finish_record_date",DE(""))#',
                        keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(""))#',
                        oby : '#IIf(IsDefined("attributes.oby"),"attributes.oby",DE(""))#',
                        acc_branch_id : '#IIf(IsDefined("attributes.acc_branch_id"),"attributes.acc_branch_id",DE(""))#',
                        action_process_cat : '#IIf(IsDefined("attributes.action_process_cat"),"attributes.action_process_cat",DE(""))#',
                        page_action_type : '#IIf(IsDefined("attributes.page_action_type"),"attributes.page_action_type",DE(""))#',
                        belge_no : '#IIf(IsDefined("attributes.belge_no"),"attributes.belge_no",DE(""))#',
                        card_id : '#IIf(IsDefined("attributes.card_id"),"attributes.card_id",DE(""))#',
                        company_id : '#IIf(IsDefined("attributes.company_id"),"attributes.company_id",DE(""))#',
                        company : '#IIf(IsDefined("attributes.company"),"attributes.company",DE(""))#',
                        consumer_id : '#IIf(IsDefined("attributes.consumer_id"),"attributes.consumer_id",DE(""))#',
                        acc_code1_1 : '#IIf(IsDefined("attributes.acc_code1_1"),"attributes.acc_code1_1",DE(""))#',
                        acc_code1_2 : '#IIf(IsDefined("attributes.acc_code1_2"),"attributes.acc_code1_2",DE(""))#',
                        acc_code1_3 : '#IIf(IsDefined("attributes.acc_code1_3"),"attributes.acc_code1_3",DE(""))#',
                        acc_code1_4 : '#IIf(IsDefined("attributes.acc_code1_4"),"attributes.acc_code1_4",DE(""))#',
                        acc_code1_5 : '#IIf(IsDefined("attributes.acc_code1_5"),"attributes.acc_code1_5",DE(""))#',
                        acc_code2_1 : '#IIf(IsDefined("attributes.acc_code2_1"),"attributes.acc_code2_1",DE(""))#',
                        acc_code2_2 : '#IIf(IsDefined("attributes.acc_code2_2"),"attributes.acc_code2_2",DE(""))#',
                        acc_code2_3 : '#IIf(IsDefined("attributes.acc_code2_3"),"attributes.acc_code2_3",DE(""))#',
                        acc_code2_4 : '#IIf(IsDefined("attributes.acc_code2_4"),"attributes.acc_code2_4",DE(""))#',
                        acc_code2_5 : '#IIf(IsDefined("attributes.acc_code2_5"),"attributes.acc_code2_5",DE(""))#',
                        project_id : '#IIf(IsDefined("attributes.project_id"),"attributes.project_id",DE(""))#',
                        project_head : '#IIf(IsDefined("attributes.project_head"),"attributes.project_head",DE(""))#',
                        is_add_main_page : '#IIf(IsDefined("attributes.is_add_main_page"),"attributes.is_add_main_page",DE(""))#',
                        show_type : '#IIf(IsDefined("attributes.show_type") and len(attributes.show_type),"attributes.show_type",DE(""))#',
                        startrow : '#IIf(IsDefined("attributes.startrow"),"attributes.startrow",DE(""))#',
                        maxrows : '#IIf(IsDefined("attributes.maxrows"),"attributes.maxrows",DE(""))#',
                        doc_type : '#IIf(IsDefined("attributes.doc_type"),"attributes.doc_type",DE(""))#'
                    );
            </cfscript>
        </cfif>
        <cfset attributes.totalrecords=get_cards.query_count>
    </cfif>
    <cfquery name="CONTROL_ACC_UPDATE" datasource="#DSN#">
        SELECT ISNULL(IS_ACCOUNT_CARD_UPDATE,0) AS IS_ACCOUNT_CARD_UPDATE FROM OUR_COMPANY_INFO WHERE COMP_ID = #session.ep.COMPANY_ID#
    </cfquery>
    <cfquery name="get_branchs" datasource="#dsn#">
        SELECT
            BRANCH_ID,BRANCH_NAME
        FROM
            BRANCH
        WHERE
            BRANCH_STATUS = 1
            AND COMPANY_ID = #session.ep.company_id#
        <cfif session.ep.isBranchAuthorization>
            AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
        </cfif>
        ORDER BY BRANCH_NAME
    </cfquery>
    <cfquery name="get_doc_type" datasource="#dsn#">
        SELECT
            DOCUMENT_TYPE_ID, DOCUMENT_TYPE, DETAIL
        FROM
            ACCOUNT_CARD_DOCUMENT_TYPES
        WHERE
            IS_ACTIVE = 1
    </cfquery>
    <cfquery name="GET_ALL_PROCESS_CAT" datasource="#DSN3#">
        SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT,IS_ACCOUNT FROM SETUP_PROCESS_CAT
    </cfquery>
    <cfset list_card_type_ = '10,11,12,13,14,19'>
    <cfquery name="GET_PROCESS_CAT_" dbtype="query">
        SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM GET_ALL_PROCESS_CAT WHERE PROCESS_TYPE IN (#list_card_type_#) ORDER BY PROCESS_TYPE
    </cfquery>
    <cfquery name="get_process_cat" dbtype="query">
        SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM GET_ALL_PROCESS_CAT WHERE IS_ACCOUNT = 1 ORDER BY PROCESS_TYPE
    </cfquery>
    <cfquery name="get_process_cat_process_type" dbtype="query">
        SELECT DISTINCT PROCESS_TYPE FROM GET_ALL_PROCESS_CAT WHERE IS_ACCOUNT = 1 ORDER BY PROCESS_TYPE
    </cfquery>
    
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box>
            <cfform name="form" action="#request.self#?fuseaction=account.#listlast(attributes.fuseaction,'.')#" method="post">
            <input type="hidden" name="form_varmi" id="form_varmi" value="1">
            <cfif isdefined("attributes.is_add_page")>
                <input type="hidden" name="is_add_page" id="is_add_page" value="1">
                <input type="hidden" name="main_card_id" id="main_card_id" value="<cfoutput>#attributes.main_card_id#</cfoutput>">
            </cfif>
            <cfif isdefined("attributes.is_add_main_page")>
                <cfset attributes.fis_type = 1>
                <input type="hidden" name="is_add_main_page" id="is_add_main_page" value="1">
                <input type="hidden" name="is_add_page" id="is_add_page" value="1">
                <input type="hidden" name="main_card_id" id="main_card_id" value="">
                <input type="hidden" name="card_id" id="card_id" value="<cfoutput>#attributes.card_id#</cfoutput>">
            </cfif>
            <cfif isdefined("attributes.is_delete_page")>
                <cfset attributes.fis_type = 6>
                <input type="hidden" name="is_delete_page" id="is_delete_page" value="1">
                <input type="hidden" name="main_card_id" id="main_card_id" value="<cfoutput>#attributes.main_card_id#</cfoutput>">
            </cfif>
                <cf_box_search>
                    <div class="form-group">
                        <cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang(48,'Filtre',57460)#">
                    </div>
                    <div class="form-group">
                        <cfinput type="text" name="belge_no" id="belge_no" value="#attributes.belge_no#" maxlength="50" placeholder="#getLang(468,'Belge No',57880)#">
                    </div>
                    <div class="form-group">
                        <select name="oby" id="oby">
                            <option value="1" <cfif isDefined('attributes.oby') and attributes.oby eq 1>selected</cfif>><cf_get_lang dictionary_id='57926.Azalan Tarih'></option>
                            <option value="2" <cfif isDefined('attributes.oby') and attributes.oby eq 2>selected</cfif>><cf_get_lang dictionary_id='57925.Artan Tarih'></option>
                            <option value="3" <cfif isDefined('attributes.oby') and attributes.oby eq 3>selected</cfif>><cf_get_lang dictionary_id='29459.Artan No'></option>
                            <option value="4" <cfif isDefined('attributes.oby') and attributes.oby eq 4>selected</cfif>><cf_get_lang dictionary_id='29458.Azalan No'></option>
                        </select>
                    </div>
                    <div class="form-group">
                        <select name="list_type_form" id="list_type_form" style="width:130px;">
                            <option value="1" <cfif attributes.list_type_form eq 1>selected</cfif>><cf_get_lang dictionary_id='57660.Belge Bazında'></option>
                            <cfif not isdefined("attributes.is_add_page") and not isdefined("attributes.is_delete_page") and not isdefined("attributes.is_add_main_page")>
                                <option value="2" <cfif attributes.list_type_form eq 2>selected</cfif>><cf_get_lang dictionary_id='29539.Satır Bazında'></option>
                            </cfif>
                        </select>
                    </div>
                    <div class="form-group small">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" id="maxrows" style="width:25px;" maxlength="3" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" onKeyUp="isNumber(this)" message="#message#">
                    </div>
                    <div class="form-group">
                        <cf_wrk_search_button button_type="4" search_function='input_control()'>
                        <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                    </div>
                </cf_box_search>
                <cf_box_search_detail>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-process_cat">
                            <label class="col col-12"><cf_get_lang dictionary_id ='57800.İşlem Tipi'></label>
                            <div class="col col-12">
                                <select name="action_process_cat" id="action_process_cat" style="width:227px;">
                                    <option value=""></option>
                                    <cfoutput query="get_process_cat_process_type">
                                        <option value="#process_type#-0" <cfif '#process_type#-0' is attributes.action_process_cat>selected</cfif>>#get_process_name(process_type)#</option>
                                        <cfquery name="get_pro_cat" dbtype="query">
                                            SELECT * FROM get_process_cat WHERE PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_process_cat_process_type.process_type#">
                                        </cfquery>
                                        <cfloop query="get_pro_cat">
                                            <option value="#get_pro_cat.process_type#-#get_pro_cat.process_cat_id#" <cfif attributes.action_process_cat is '#process_type#-#process_cat_id#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#get_pro_cat.process_cat#</option>
                                        </cfloop>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-acc_code_1">
                            <label class="col col-12"><cf_get_lang dictionary_id ='58811.Muhasebe Kodu'></label>
                            <div class="col col-12">
                                <cf_wrk_multi_account_code acc_code1_1='#attributes.acc_code1_1#' acc_code2_1='#attributes.acc_code2_1#' acc_code1_2='#attributes.acc_code1_2#' acc_code2_2='#attributes.acc_code2_2#' acc_code1_3='#attributes.acc_code1_3#' acc_code2_3='#attributes.acc_code2_3#' acc_code1_4='#attributes.acc_code1_4#' acc_code2_4='#attributes.acc_code2_4#' acc_code1_5='#attributes.acc_code1_5#' acc_code2_5='#attributes.acc_code2_5#' is_multi='#is_select_multi_acc_code#'>
                            </div>
                        </div>
                        <div class="form-group" id="item-company">
                            <label class="col col-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <input type="hidden" name="consumer_id" id="consumer_id" <cfif len(attributes.company) and len(attributes.consumer_id)> value="<cfoutput>#attributes.consumer_id#</cfoutput>"</cfif>>
                                    <input type="hidden" name="company_id" id="company_id" <cfif len(attributes.company) and len(attributes.company_id)> value="<cfoutput>#attributes.company_id#</cfoutput>"</cfif>>
                                    <input type="text" name="company" id="company" style="width:100px;" onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\'','COMPANY_ID,CONSUMER_ID','company_id,consumer_id','form','3','250');" value="<cfif len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_name=form.company&field_comp_id=form.company_id&field_consumer=form.consumer_id&field_member_name=form.company<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2,3</cfoutput>&keyword='+encodeURIComponent(document.form.company.value),'list')"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                            <div class="form-group" id="item-employee_name">
                            <label class="col col-12"><cf_get_lang dictionary_id='57899.Kaydeden'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <input type="hidden" name="employee_id" id="employee_id" value="<cfif len(attributes.employee_name)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
                                    <input type="text" name="employee_name" id="employee_name"  style="width:100px;" onFocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','135');" value="<cfif len(attributes.employee_id) and len(attributes.employee_name)><cfoutput>#get_emp_info(attributes.employee_id,0,0)#</cfoutput></cfif>" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57899.Kaydeden'>" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form.employee_id&field_name=form.employee_name&select_list=1&keyword='+encodeURIComponent(document.form.employee_name.value),'list');return false"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-BRANCH_ID">
                            <label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                            <div class="col col-12">
                                <select name="acc_branch_id" id="acc_branch_id" style="width:100px;">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_branchs">
                                        <option value="#BRANCH_ID#" <cfif isdefined('attributes.acc_branch_id') and attributes.acc_branch_id eq BRANCH_ID>selected</cfif>>#BRANCH_NAME#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-project">
                            <label class="col col-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                            <div class="col col-12">
                                <cfif isdefined('attributes.project_head') and len(attributes.project_head)>
                                    <cfset project_id_ = attributes.project_id>
                                <cfelse>
                                    <cfset project_id_ = ''>
                                </cfif>
                                <cf_wrkProject
                                    project_Id="#project_id_#"
                                    width="100"
                                    AgreementNo="1" Customer="2" Employee="3" Priority="4" Stage="5"
                                    boxwidth="600"
                                    boxheight="400">
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                            <div class="form-group" id="item-fis_type">
                            <label class="col col-12"><cf_get_lang dictionary_id='47304.Fişler'></label>
                            <div class="col col-12">
                                <select name="fis_type" id="fis_type">
                                    <cfif isdefined("attributes.is_add_main_page")>
                                        <option value="1" <cfif len(attributes.fis_type) and attributes.fis_type eq 1>selected</cfif>><cf_get_lang dictionary_id='47377.Bir Fişler'></option>
                                    <cfelseif not isdefined("attributes.is_delete_page")>
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfif not isdefined("attributes.is_add_page")>
                                        <option value="1" <cfif len(attributes.fis_type) and attributes.fis_type eq 1>selected</cfif>><cf_get_lang dictionary_id='47377.Birleştirilmiş Fişler'></option>
                                    </cfif>
                                        <option value="2" <cfif len(attributes.fis_type) and attributes.fis_type eq 2>selected</cfif>><cf_get_lang dictionary_id='47378.Birleştirilmemiş Fişler'></option>
                                    <cfif not isdefined("attributes.is_add_page")>
                                        <option value="3" <cfif len(attributes.fis_type) and attributes.fis_type eq 3>selected</cfif>><cf_get_lang dictionary_id ='47412.Geçiçi Açık Fişler'></option>
                                    </cfif>
                                        <option value="4" <cfif len(attributes.fis_type) and attributes.fis_type eq 4>selected</cfif>><cf_get_lang dictionary_id='47336.Manuel Fişler'></option>
                                    <cfif not isdefined("attributes.is_add_page")>
                                        <option value="5" <cfif len(attributes.fis_type) and attributes.fis_type eq 5>selected</cfif>><cf_get_lang dictionary_id='47565.Birleştirilmiş'> <cf_get_lang dictionary_id='47336.Manuel Fişler'></option>
                                    </cfif>
                                    <cfelse>
                                        <option value="6" <cfif len(attributes.fis_type) and attributes.fis_type eq 6>selected</cfif>><cf_get_lang dictionary_id='47304.Fişler'></option>
                                    </cfif>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-page_action_type">
                            <label class="col col-12"><cf_get_lang dictionary_id='57777.İşlem'></label>
                            <div class="col col-12">
                                <select name="page_action_type" id="page_action_type" style="width:125px;">
                                    <option value="" selected><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_process_cat_" group="process_type">
                                        <option value="#process_type#-0" <cfif '#process_type#-0' is attributes.page_action_type> selected</cfif>>#get_process_name(process_type)#</option>
                                        <cfoutput>
                                            <option value="#process_type#-#process_cat_id#" <cfif attributes.page_action_type is '#process_type#-#process_cat_id#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#process_cat#</option>
                                        </cfoutput>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-page_action_type">
                            <label class="col col-12"><cf_get_lang dictionary_id ='60776.Muhasebe seçeneği'></label>
                            <div class="col col-12">
                                <select name="show_type" id="show_type">
                                    <option value="" selected><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <option value="1" <cfif attributes.show_type eq 1>selected="selected"</cfif>><cf_get_lang dictionary_id="58793.Tek düzen"></option>
                                    <option value="2" <cfif attributes.show_type eq 2>selected="selected"</cfif>><cf_get_lang dictionary_id="58308.ufrs"></option>
                                    <option value="3" <cfif attributes.show_type eq 3>selected="selected"</cfif>><cf_get_lang dictionary_id="58793.Tek düzen"> + <cf_get_lang dictionary_id="58308.ufrs"></option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                        <div class="form-group" id="item-record_date">
                            <label class="col col-12"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='57627.Kayıt Tarihi'></cfsavecontent>
                                    <cfinput type="text" name="record_date" maxlength="10" value="#dateFormat(attributes.record_date,dateformat_style)#" style="width:65px" validate="#validate_style#" message="#message#">
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="record_date"></span>
                                    <span class="input-group-addon no-bg"></span>
                                    <cfinput type="text" name="finish_record_date" maxlength="10" value="#dateFormat(attributes.finish_record_date,dateformat_style)#" style="width:65px" validate="#validate_style#" message="#message#">
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finish_record_date"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-record_date">
                            <label class="col col-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id ='57782.Tarih Değerlerini Kontrol Ediniz'></cfsavecontent>
                                    <cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
                                        <cfinput type="text" name="start_date" id="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message#">
                                    <cfelse>
                                        <cfinput type="text" name="start_date" id="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message#">
                                    </cfif>
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="start_date"></span>
                                    <span class="input-group-addon no-bg"></span>
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id ='57782.Tarih Değerlerini Kontrol Ediniz'></cfsavecontent>
                                    <cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
                                        <cfinput type="text" name="finish_date" id="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message#">
                                    <cfelse>
                                        <cfinput type="text" name="finish_date" id="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message#">
                                    </cfif>
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finish_date"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-document_type">
                            <label class="col col-12"><cf_get_lang dictionary_id='58533.Belge Tipi'></label>
                            <div class="col col-12">
                                <select name="doc_type" id="doc_type" >
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <option value="999" <cfif isdefined('attributes.doc_type') and attributes.doc_type eq 999>selected</cfif> ><cf_get_lang dictionary_id='65408.Belge Tipi Olmayanlar'></option>
                                    <cfoutput query="get_doc_type">
                                        <option value="#DOCUMENT_TYPE_ID#" <cfif isdefined('attributes.doc_type') and attributes.doc_type eq DOCUMENT_TYPE_ID>selected</cfif>>#DETAIL# (#DOCUMENT_TYPE#)</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                    </div>
                </cf_box_search_detail>
            </cfform>
        </cf_box>
        <cfsavecontent  variable="head"><cf_get_lang dictionary_id='59038.Muhasebe Fişleri'></cfsavecontent>
        
        <cf_box title="#head#" uidrop="1" hide_table_column="1" woc_setting = "#{ checkbox_name : 'print_cards_id', print_type : 290 }#">
            <cf_grid_list>
                <thead>
                <cfif isdefined('attributes.fis_type') and (attributes.fis_type eq 3 or attributes.fis_type eq 5)><!--- geçici çözülmüş birleştirilmiş fişler --->
                    <tr>
                        <th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
                        <th><cf_get_lang dictionary_id='57946.Fiş No'></th>
                        <th><cf_get_lang dictionary_id='39373.Yevmiye No'></th>
                        <th><cf_get_lang dictionary_id='47348.Fiş Türü'></th>
                        <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                        <th><cf_get_lang dictionary_id='57879.İşlem Tarihi'></th>
                        <th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
                        <cfif attributes.fis_type eq 3>
                        <th width="20" class="text-center"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></th>
                        </cfif>
                    </tr>
                <cfelse>
                    <tr>
                        <th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
                        <th><cf_get_lang dictionary_id='57880.Belge No'></th>
                        <cfif isdefined('is_dsp_cari_member') and is_dsp_cari_member eq 1>
                            <th><cf_get_lang dictionary_id='57519.cari hesap'></th>
                        </cfif>
                        <th><cf_get_lang dictionary_id='57946.Fiş No'></th>
                        <th><cf_get_lang dictionary_id='39373.Yevmiye No'></th>
                        <th><cf_get_lang dictionary_id='47348.Fiş Türü'></th>
                        <cfif isDefined('session.ep.our_company_info.is_edefter') and session.ep.our_company_info.is_edefter eq 1 and isDefined('xml_payment_method') and xml_payment_method eq 1>
                            <th><cf_get_lang dictionary_id='30057.Ödeme Şekli'></th>
                        </cfif>
                        <cfif isDefined('session.ep.our_company_info.is_edefter') and session.ep.our_company_info.is_edefter eq 1 and isDefined('xml_document_type') and xml_document_type eq 1>
                            <th><cf_get_lang dictionary_id='58533.Belge Tipi'></th>
                        </cfif>
                        <cfif attributes.list_type_form eq 2>
                            <th><cf_get_lang dictionary_id ='47299.Hesap Kodu'></th>
                            <cfif is_acc_branch><th><cf_get_lang dictionary_id='57453.Sube'></th></cfif>
                            <cfif is_acc_department><th><cf_get_lang dictionary_id='57572.Departman'></th></cfif>
                            <cfif is_acc_project><th><cf_get_lang dictionary_id='57416.Proje'></th></cfif>
                            <th><cf_get_lang dictionary_id ='47300.Hesap Adı'></th>
                            <cfif session.ep.our_company_info.is_ifrs eq 1>
                                <th><cf_get_lang dictionary_id ='58308.UFRS'></th>
                            </cfif>
                        </cfif>
                            <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                        <cfif attributes.list_type_form eq 2>
                            <th><cf_get_lang dictionary_id ='57587.Borç'></th>
                            <th><cf_get_lang dictionary_id ='57489.Para Br'></th>
                            <th><cf_get_lang dictionary_id ='57588.Alacak'></th>
                            <th><cf_get_lang dictionary_id ='57489.Para Br'></th>
                        <cfelse>
                            <th><cf_get_lang dictionary_id='57673.Tutar'></th>
                        </cfif>
                        <th><cf_get_lang dictionary_id='57879.İşlem Tarihi'></th>
                        <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
                        <th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
                        <!-- sil -->
                        <th width="20" class="text-center"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></th>
                        <th width="20" class="text-center"><a href="javascript://" onclick="window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=account.account_collected_print','_blank');"><i class="fa fa-print" alt="<cf_get_lang dictionary_id='57474.Yazdır'>" title="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></a></th> 
                            <cfif isdefined("attributes.form_varmi") and get_cards.recordcount>
                            <th width="20" nowrap="nowrap" class="text-center header_icn_none">
                               
                                    <cfif get_cards.recordcount eq 1><a href="javascript://" onclick="send_print_reset();"><i class="fa fa-print" alt="<cf_get_lang dictionary_id='57389.Print Sayisi Sifirla'>" title="<cf_get_lang dictionary_id='57389.Print Sayisi Sifirla'>"></i></a></cfif>
                                    <input type="checkbox" name="allSelectDemand" id="allSelectDemand" onclick="wrk_select_all('allSelectDemand','print_cards_id');">
                                
                            </th></cfif>
                        <!-- sil -->
                    </tr>
                </cfif>
                </thead>
                <tbody>
                    <cfif isdefined("attributes.form_varmi") and get_cards.recordcount>
                        <cfset company_id_list=''>
                        <cfset card_id_list = ''>
                        <cfset record_emp_list=''>
                        <cfset partner_id_list=''>
                        <cfset consumer_id_list=''>
                        <cfset employee_id_list=''>
                        <cfset process_cat_id_list=''>
                        <cfset dep_id_list=''>
                        <cfset branch_id_list=''>
                        <cfset project_id_list = ''>
                        <cfoutput query="get_cards">
                            <cfset card_id_list = ListAppend(card_id_list,CARD_ID,',')>
                            <cfif len(RECORD_EMP) and not listfind(record_emp_list,RECORD_EMP)>
                                <cfset record_emp_list = ListAppend(record_emp_list,RECORD_EMP)>
                            </cfif>
                            <cfif len(RECORD_PAR) and not listfind(partner_id_list,RECORD_PAR)>
                                <cfset partner_id_list=listappend(partner_id_list,RECORD_PAR)>
                            </cfif>
                            <cfif isdefined('is_dsp_cari_member') and is_dsp_cari_member eq 1>
                                <cfif isdefined("ACC_COMPANY_ID") and len(ACC_COMPANY_ID) and not listfind(company_id_list,ACC_COMPANY_ID)>
                                    <cfset company_id_list=listappend(company_id_list,ACC_COMPANY_ID)>
                                </cfif>
                                <cfif isdefined("ACC_CONSUMER_ID") and len(ACC_CONSUMER_ID) and not listfind(consumer_id_list,ACC_CONSUMER_ID)>
                                    <cfset consumer_id_list=listappend(consumer_id_list,ACC_CONSUMER_ID)>
                                </cfif>
                                <cfif isdefined("ACC_EMPLOYEE_ID") and len(ACC_EMPLOYEE_ID) and not listfind(employee_id_list,ACC_EMPLOYEE_ID)>
                                    <cfset employee_id_list=listappend(employee_id_list,ACC_EMPLOYEE_ID)>
                                </cfif>
                            </cfif>
                            <cfif len(RECORD_CONS) and not listfind(consumer_id_list,RECORD_CONS)>
                                <cfset consumer_id_list=listappend(consumer_id_list,RECORD_CONS)>
                            </cfif>
                            <cfif len(CARD_CAT_ID) and CARD_CAT_ID neq 0 and not listfind(process_cat_id_list,CARD_CAT_ID)>
                                <cfset process_cat_id_list=listappend(process_cat_id_list,CARD_CAT_ID)>
                            </cfif>
                            <cfif isdefined("acc_department_id") and len(acc_department_id) and not listfind(dep_id_list,acc_department_id)>
                            <cfset dep_id_list=listappend(dep_id_list,acc_department_id)>
                            </cfif>
                            <cfif isdefined("acc_branch_id") and len(acc_branch_id) and not listfind(branch_id_list,acc_branch_id)>
                                <cfset branch_id_list=listappend(branch_id_list,acc_branch_id)>
                            </cfif>
                            <cfif isdefined("acc_project_id") and len(acc_project_id) and not listfind(project_id_list,acc_project_id)>
                                <cfset project_id_list=listappend(project_id_list,acc_project_id)>
                            </cfif>
                        </cfoutput>
                        <cfif len(process_cat_id_list)><!--- işlem kategorileri alınıyor --->
                            <cfset process_cat_id_list = listsort(process_cat_id_list,'numeric','ASC',',')>
                            <cfquery name="GET_PROCESS_CAT_ROW" dbtype="query">
                                SELECT PROCESS_CAT_ID,PROCESS_CAT FROM GET_ALL_PROCESS_CAT WHERE PROCESS_CAT_ID IN (#process_cat_id_list#) ORDER BY	PROCESS_CAT_ID
                            </cfquery>
                            <cfset process_cat_id_list = listsort(listdeleteduplicates(valuelist(get_process_cat_row.process_cat_id,',')),'numeric','ASC',',')>
                        </cfif>
                        <cfif len(record_emp_list)>
                            <cfset record_emp_list = listsort(record_emp_list,'numeric','ASC',',')>
                                <cfquery name="get_emp" datasource="#dsn#">
                                    SELECT
                                        EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID
                                    FROM
                                        EMPLOYEES
                                    WHERE
                                        EMPLOYEE_ID IN(#record_emp_list#)
                                    ORDER BY
                                        EMPLOYEE_ID
                                </cfquery>
                            <cfset record_emp_list = listsort(valuelist(get_emp.EMPLOYEE_ID),'numeric','ASC',',')>
                        </cfif>
                        <cfif len(partner_id_list)>
                            <cfset partner_id_list=listsort(partner_id_list,"numeric","ASC",",")>
                            <cfquery name="get_par_detail" datasource="#dsn#">
                                SELECT PARTNER_ID,COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID IN (#partner_id_list#) ORDER BY PARTNER_ID
                            </cfquery>
                            <cfset partner_id_list=listsort(valuelist(get_par_detail.PARTNER_ID),"numeric","ASC",",")>
                        </cfif>
                        <cfif isdefined('is_dsp_cari_member') and is_dsp_cari_member eq 1>
                            <cfif len(company_id_list)>
                                <cfset company_id_list=listsort(company_id_list,"numeric","ASC",",")>
                                <cfquery name="get_company_detail" datasource="#DSN#">
                                    SELECT NICKNAME,COMPANY_ID FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#) ORDER BY COMPANY_ID
                                </cfquery>
                                <cfset company_id_list=listsort(valuelist(get_company_detail.COMPANY_ID),"numeric","ASC",",")>
                            </cfif>
                        </cfif>
                        <cfif len(consumer_id_list)>
                            <cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
                            <cfquery name="get_cons_detail" datasource="#dsn#">
                                SELECT CONSUMER_NAME,CONSUMER_SURNAME,CONSUMER_ID FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
                            </cfquery>
                            <cfset consumer_id_list=listsort(valuelist(get_cons_detail.CONSUMER_ID),"numeric","ASC",",")>
                        </cfif>
                        <cfif len(employee_id_list)>
                            <cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
                            <cfquery name="get_emp_detail" datasource="#dsn#">
                                SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN(#employee_id_list#) ORDER BY EMPLOYEE_ID
                            </cfquery>
                            <cfset employee_id_list=listsort(valuelist(get_emp_detail.EMPLOYEE_ID),"numeric","ASC",",")>
                        </cfif>
                        <cfif listlen(dep_id_list)>
                            <cfset dep_id_list=listsort(dep_id_list,"numeric","ASC",",")>
                            <cfquery name="get_dep_detail" datasource="#dsn#">
                                SELECT D.DEPARTMENT_HEAD, B.BRANCH_NAME FROM DEPARTMENT D, BRANCH B WHERE D.BRANCH_ID=B.BRANCH_ID AND D.DEPARTMENT_ID IN (#dep_id_list#) ORDER BY D.DEPARTMENT_ID
                            </cfquery>
                        </cfif>
                        <cfif listlen(branch_id_list)>
                            <cfset branch_id_list=listsort(branch_id_list,"numeric","ASC",",")>
                            <cfquery name="GET_BRANCH" datasource="#dsn#">
                                SELECT BRANCH_ID, BRANCH_NAME FROM BRANCH WHERE BRANCH_ID IN (#branch_id_list#) ORDER BY BRANCH_ID
                            </cfquery>
                        </cfif>
                        <cfif listlen(project_id_list)>
                            <cfset project_id_list=listsort(project_id_list,"numeric","ASC",",")>
                            <cfquery name="get_pro_detail" datasource="#dsn#">
                                SELECT PROJECT_ID, PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_id_list#) ORDER BY PROJECT_ID
                            </cfquery>
                        </cfif>
                        <cfif isdefined('attributes.fis_type') and (attributes.fis_type eq 3 or attributes.fis_type eq 5)><!--- geçici çözülmüş birleştirilmiş fişler --->
                            <cfoutput query="get_cards">
                                <tr>
                                    <td>#get_cards.rownum#</td>
                                    <td>#get_cards.card_type_no#</td>
                                    <td>#bill_no#</td>
                                    <td>
                                        <a href="javascript://" class="tableyazi" onClick="gizle_goster(card_detail_#rownum#);AjaxPageLoad('#request.self#?fuseaction=account.popup_list_card_rows&card_id=#get_cards.CARD_ID#&form_crntrow=#rownum#&is_temporary_solve=1','card_detail_#rownum#_',1);">
                                            <cfif len(get_cards.CARD_CAT_ID) and get_cards.CARD_CAT_ID neq 0>#get_process_cat_row.process_cat[listfind(process_cat_id_list,get_cards.CARD_CAT_ID,',')]#<cfelse>#get_process_name(get_cards.CARD_TYPE)#</cfif>
                                        </a>
                                    </td>
                                    <td>#dateformat(get_cards.process_date,dateformat_style)# <cf_get_lang dictionary_id ='47488.Tarihli Fiş Birleştirme İşlemi'></td>
                                    <td>#dateformat(get_cards.process_date,dateformat_style)#</td>
                                    <td>
                                        <cfif len(RECORD_EMP)>
                                            #get_emp.EMPLOYEE_NAME[listfind(record_emp_list,RECORD_EMP,',')]#&nbsp;
                                            #get_emp.EMPLOYEE_SURNAME[listfind(record_emp_list,RECORD_EMP,',')]#
                                        <cfelseif len(RECORD_PAR)>
                                            #get_par_detail.COMPANY_PARTNER_NAME[listfind(partner_id_list,RECORD_PAR,',')]# #get_par_detail.COMPANY_PARTNER_SURNAME[listfind(partner_id_list,RECORD_PAR,',')]#
                                        <cfelseif len(RECORD_CONS)>
                                            #get_cons_detail.CONSUMER_NAME[listfind(consumer_id_list,RECORD_CONS,',')]# #get_cons_detail.CONSUMER_SURNAME[listfind(consumer_id_list,RECORD_CONS,',')]#
                                        </cfif>
                                    </td>
                                    <cfif attributes.fis_type eq 3>
                                        <td>
                                            <a href="javascript://" onClick="sum_bills(#get_cards.CARD_ID#);"><img src="/images/lock.gif" align="absmiddle" alt="<cf_get_lang dictionary_id ='47487.Birleştirilmiş Fişi Yeniden Oluştur'>" title="<cf_get_lang dictionary_id ='47487.Birleştirilmiş Fişi Yeniden Oluştur'>"></a>
                                        </td>
                                    </cfif>
                                </tr>
                                <tr id="card_detail_#rownum#" style="display:none;" class="color-row">
                                    <td colspan="9">
                                        <div id="card_detail_#rownum#_"></div>
                                    </td>
                                </tr>
                            </cfoutput>
                        <cfelse>
                            <cfif len(card_id_list)>
                                <cfset card_id_list = listsort(card_id_list,'numeric','ASC',',')>
                                <cfif isdefined("attributes.is_delete_page")>
                                    <cfquery name="get_card_amounts" datasource="#dsn2#">
                                        SELECT
                                            SUM(AMOUNT) AS AMOUNT,
                                            CARD_ID
                                        FROM
                                            ACCOUNT_CARD_SAVE_ROWS
                                            WHERE
                                            BA=1
                                            AND CARD_ID IN (#card_id_list#)
                                        GROUP BY
                                            CARD_ID
                                        ORDER BY
                                            CARD_ID
                                    </cfquery>
                                <cfelse>
                                    <cfquery name="get_card_amounts" datasource="#dsn2#">
                                        SELECT
                                            SUM(AMOUNT) AS AMOUNT,
                                            CARD_ID
                                        FROM
                                            ACCOUNT_CARD_ROWS
                                            WHERE
                                            BA=1
                                            AND CARD_ID IN (#card_id_list#)
                                        GROUP BY
                                            CARD_ID
                                        UNION 
                                         SELECT
                                            SUM(AMOUNT) AS AMOUNT,
                                            CARD_ID
                                        FROM
                                            ACCOUNT_ROWS_IFRS
                                            WHERE
                                            BA=1
                                            AND CARD_ID IN (#card_id_list#)
                                        GROUP BY
                                            CARD_ID
                                        ORDER BY
                                            CARD_ID
                                    </cfquery>
                                </cfif>
                                <cfset get_card_amounts_card_ids = valuelist(get_card_amounts.CARD_ID,',')>
                            </cfif>
                            <cfif isdefined("get_card_amounts_card_ids") and listlen(card_id_list) neq listlen(get_card_amounts_card_ids)>
                                <cfloop list="#card_id_list#" index="card_idx">
                                    <cfif not listfind(get_card_amounts_card_ids,card_idx,',')>
                                        <cfset card_id_list = ListDeleteAt(card_id_list,listfind(card_id_list,card_idx,','),',')>
                                    </cfif>
                                </cfloop>
                            </cfif>
                            <cfsavecontent variable="message_new"><cf_get_lang dictionary_id='61016.Seçilen Fiş Birleştirilmiş Fişe Eklenecektir ! Emin misiniz?'></cfsavecontent>
                            <cfsavecontent variable="message_new2"><cf_get_lang dictionary_id='61017.Seçilen Fiş Birleştirilmiş Fişten Çıkarılacaktır ! Emin misiniz?'></cfsavecontent>
                            <cfsavecontent variable="message_new3"><cf_get_lang dictionary_id='61018.Bu Fişi Birleştirilmiş Fişten Çıkarabilmek İçin Fişi Çözmelisiniz !'></cfsavecontent>
                            <cfoutput query="get_cards" >
                                <cfif is_show_action_detail eq 1>
                                    <cfset acc_process_type= get_cards.action_type>
                                    <cfinclude template="../query/get_acc_process_type_info.cfm">
                                </cfif>
                                <tr>
                                    <td>#get_cards.rownum#</td>
                                    <td>
                                        <cfif isdefined('link_str') and len(link_str) and len(get_cards.process_cat)>
                                            <a href="#link_str##get_cards.action_id#" target="invoice_window" class="tableyazi">#get_cards.paper_no#</a>
                                        <cfelse>
                                            #get_cards.paper_no#
                                        </cfif>
                                    </td>
                                    <cfif isdefined('is_dsp_cari_member') and is_dsp_cari_member eq 1> <!--- xmle baglı olarak cari hesap bilgisi geliyor --->
                                        <td>
                                            <cfif isdefined("ACC_COMPANY_ID") and len(GET_CARDS.ACC_COMPANY_ID)>
                                                <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#GET_CARDS.ACC_COMPANY_ID#','medium');">#get_company_detail.NICKNAME[listfind(company_id_list,GET_CARDS.ACC_COMPANY_ID,',')]#</a>
                                            <cfelseif isdefined("ACC_CONSUMER_ID") and len(GET_CARDS.ACC_CONSUMER_ID)>
                                                <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#GET_CARDS.ACC_CONSUMER_ID#','medium');">#get_cons_detail.CONSUMER_NAME[listfind(consumer_id_list,GET_CARDS.ACC_CONSUMER_ID,',')]# #get_cons_detail.CONSUMER_SURNAME[listfind(consumer_id_list,ACC_CONSUMER_ID,',')]#</a>
                                            <cfelseif isdefined("ACC_EMPLOYEE_ID") and len(GET_CARDS.ACC_EMPLOYEE_ID)>
                                                <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#GET_CARDS.ACC_EMPLOYEE_ID#','medium');">#get_emp_detail.EMPLOYEE_NAME[listfind(employee_id_list,GET_CARDS.ACC_EMPLOYEE_ID,',')]# #get_emp_detail.EMPLOYEE_SURNAME[listfind(employee_id_list,ACC_EMPLOYEE_ID,',')]#</a>
                                            </cfif>
                                        </td>
                                    </cfif>
                                    <td>#get_cards.card_type_no#</td>
                                    <td>#bill_no#</td>
                                    <td>
                                        <cfif not isdefined("attributes.is_delete_page")>
                                            <a class="tableyazi" href="javascript://" onClick="windowopen('#request.self#?fuseaction=account.popup_list_card_rows&card_id=#get_cards.CARD_ID#','page_horizantal');">
                                                <cfif len(get_cards.CARD_CAT_ID) and get_cards.CARD_CAT_ID neq 0>#get_process_cat_row.process_cat[listfind(process_cat_id_list,get_cards.CARD_CAT_ID,',')]#<cfelse>#get_process_name(get_cards.CARD_TYPE)#</cfif>
                                            </a>
                                        <cfelse>
                                            <cfif len(get_cards.CARD_CAT_ID) and get_cards.CARD_CAT_ID neq 0>#get_process_cat_row.process_cat[listfind(process_cat_id_list,get_cards.CARD_CAT_ID,',')]#<cfelse>#get_process_name(get_cards.CARD_TYPE)#</cfif>
                                        </cfif>
                                    </td>
                                    <cfif isDefined('session.ep.our_company_info.is_edefter') and session.ep.our_company_info.is_edefter eq 1 and isDefined('xml_payment_method') and xml_payment_method eq 1>
                                        <td>#get_cards.payment_type#</td>
                                    </cfif>
                                    <cfif isDefined('session.ep.our_company_info.is_edefter') and session.ep.our_company_info.is_edefter eq 1 and isDefined('xml_document_type') and xml_document_type eq 1>
                                        <td>#get_cards.document_type#</td>
                                    </cfif>
                                    <cfif attributes.list_type_form eq 2>
                                        <td nowrap="nowrap">
                                            <cfif ListLen(ACCOUNT_ID,'.') gt 0>
                                                <cfloop index="i" from="1" to="#ListLen(ACCOUNT_ID,'.')#">&nbsp;</cfloop>
                                            </cfif>
                                            #ACCOUNT_ID#
                                        </td>
                                        <cfif is_acc_branch>
                                            <td>
                                                <cfif isdefined("ACC_BRANCH_ID") and  len(ACC_BRANCH_ID)>#get_branch.branch_name[listfind(branch_id_list,acc_branch_id,',')]#</cfif>
                                            </td>
                                        </cfif>
                                        <cfif is_acc_department>
                                            <td>
                                                <cfif isdefined("ACC_DEPARTMENT_ID") and len(ACC_DEPARTMENT_ID)>#get_dep_detail.BRANCH_NAME[listfind(dep_id_list,ACC_DEPARTMENT_ID,',')]# - #get_dep_detail.DEPARTMENT_HEAD[listfind(dep_id_list,ACC_DEPARTMENT_ID,',')]#</cfif>
                                            </td>
                                        </cfif>
                                        <cfif is_acc_project>
                                            <td>
                                                <cfif isdefined("ACC_PROJECT_ID") and len(ACC_PROJECT_ID)>#get_pro_detail.PROJECT_HEAD[listfind(project_id_list,ACC_PROJECT_ID,',')]#</cfif>
                                            </td>
                                        </cfif>
                                        <td nowrap="nowrap">#ACCOUNT_NAME#</td>
                                        <cfif session.ep.our_company_info.is_ifrs eq 1>
                                            <td nowrap="nowrap">#IFRS_CODE#</td>
                                        </cfif>
                                    </cfif>
                                    <td><cfif attributes.list_type_form eq 2>#get_cards.row_detail#<cfelse>#get_cards.card_detail#</cfif></td>
                                    <cfset card_id = get_cards.CARD_ID>
                                    <cfset card_type = get_cards.CARD_TYPE>
                                    <cfif card_type eq 10>
                                        <cfset send='form_upd_bill_opening&var_=opening_card'>
                                    <cfelseif card_type eq 11>
                                        <cfset send='form_add_bill_collecting&event=upd&bill_type=2&var_=collecting_card'>
                                    <cfelseif card_type eq 12>
                                        <cfset send='form_add_bill_payment&event=upd&var_=payment_card'>
                                    <cfelseif listfind('13,14,19',card_type)>
                                        <cfset send='form_add_bill_cash2cash&event=upd'>
                                    <cfelseif card_type eq 40>
                                        <cfset send='popup_upd_bill_ch_opening&var_=ch_opening_card'>
                                    </cfif>
                                    <cfif attributes.list_type_form eq 2>
                                        <td nowrap="nowrap" style="text-align:right;"><cfif BA eq 0>#TLFormat(AMOUNT)#</cfif></td>
                                        <td><cfif BA eq 0>#AMOUNT_CURRENCY#</cfif></td>
                                        <td nowrap="nowrap" style="text-align:right;"><cfif BA eq 1>#TLFormat(AMOUNT)#</cfif></td>
                                        <td><cfif BA eq 1>#AMOUNT_CURRENCY#</cfif></td>
                                    <cfelse>
                                        <td style="text-align:right;">
                                            #TLFormat(get_card_amounts.AMOUNT[listfind(get_card_amounts_card_ids,CARD_ID,',')])#
                                        </td>
                                    </cfif>
                                    <td>#dateformat(get_cards.action_date,dateformat_style)#</td>
                                    <td><cfif len(get_cards.record_date)>#dateformat(get_cards.record_date,dateformat_style)#</cfif></td>
                                    <td>
                                        <cfif len(RECORD_EMP)>
                                            #get_emp.EMPLOYEE_NAME[listfind(record_emp_list,RECORD_EMP,',')]#&nbsp;
                                            #get_emp.EMPLOYEE_SURNAME[listfind(record_emp_list,RECORD_EMP,',')]#
                                        <cfelseif len(RECORD_PAR)>
                                            #get_par_detail.COMPANY_PARTNER_NAME[listfind(partner_id_list,RECORD_PAR,',')]# #get_par_detail.COMPANY_PARTNER_SURNAME[listfind(partner_id_list,RECORD_PAR,',')]#
                                        <cfelseif len(RECORD_CONS)>
                                            #get_cons_detail.CONSUMER_NAME[listfind(consumer_id_list,RECORD_CONS,',')]# #get_cons_detail.CONSUMER_SURNAME[listfind(consumer_id_list,RECORD_CONS,',')]#
                                        </cfif>
                                    </td>
                                    <!-- sil -->
                                    <td><cfif get_cards.IS_COMPOUND neq 1>
                                            <a href="#request.self#?fuseaction=account.#send#&card_id=#get_cards.card_id#"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'> (#get_cards.BILL_NO#)" title="<cf_get_lang dictionary_id='57464.Güncelle'> (#get_cards.BILL_NO#)"></i></a>  
                                        </cfif>
                                    </td>
                                    <td>
                                    <cfif  not (len(get_cards.action_id) and CONTROL_ACC_UPDATE.IS_ACCOUNT_CARD_UPDATE eq 0) or get_cards.ACTION_TYPE eq 17>
                                        <cfif not get_denied_page.recordcount and get_cards.IS_COMPOUND neq 1 and not listfindnocase(denied_pages,'account.del_card') and not isdefined("attributes.is_add_page") and not isdefined("attributes.is_delete_page") and not isdefined("attributes.is_add_main_page")>
                                            <a href="javascript://" onClick="go_to_sil(<cfif get_cards.ACTION_ID gt 0>1<cfelse>0</cfif>,#get_cards.CARD_ID#,'#dateformat(get_cards.ACTION_DATE,dateformat_style)#');"><i class="icon-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>
                                        <cfelse>
                                            <cfif isdefined("attributes.is_add_main_page")>
                                                <a class="tableyazi" href="##" onClick="javascript:if(confirm('#message_new#')) window.location.href='#request.self#?fuseaction=account.emptypopup_add_sum_bills&main_card_id=#get_cards.CARD_ID#&card_id=#attributes.card_id#'; else return false;">
                                                    <img src="/images/plus1.gif" style="vertical-align:middle" alt="Ekle" title="Ekle">
                                                </a>
                                            <cfelseif isdefined("attributes.is_add_page")>
                                                <a class="tableyazi" href="##" onClick="javascript:if(confirm('#message_new#')) window.location.href='#request.self#?fuseaction=account.emptypopup_add_sum_bills&card_id=#get_cards.CARD_ID#&main_card_id=#attributes.main_card_id#'; else return false;">
                                                    <img src="/images/plus1.gif" style="vertical-align:middle" alt="Ekle" title="Ekle">
                                                </a>
                                            <cfelseif isdefined("attributes.is_delete_page")>
                                                <cfif get_cards.query_count eq 1>
                                                    <a class="tableyazi" href="##" onClick="<cfif not len(get_cards.action_id)>return check_manuel();</cfif> javascript:alert('#message_new3#');">
                                                        <img src="/images/minus1.gif" style="vertical-align:middle" alt="Çıkar" title="Çıkar">
                                                    </a>
                                                <cfelse>
                                                    <a class="tableyazi" href="##" onClick="<cfif not len(get_cards.action_id)>return check_manuel();</cfif> javascript:if(confirm('#message_new2#')) window.location.href='#request.self#?fuseaction=account.emptypopup_solve_card&old_card_id=#get_cards.CARD_ID#&main_card_id=#attributes.main_card_id#'; else return false;">
                                                        <img src="/images/minus1.gif" style="vertical-align:middle" alt="Çıkar" title="Çıkar">
                                                    </a>
                                                </cfif>
                                            </cfif>
                                        </cfif>
                                        </cfif>
                                    </td>
                                    <td style="text-align:center"><input type="checkbox" name="print_cards_id" id="print_cards_id" value="#card_id#"></td>
                                    <!-- sil -->
                                </tr>
                            </cfoutput>
                        </cfif>
                    <cfelse>
                        <tr>
                            <cfset colspan = 13>
                            <cfif isDefined('session.ep.our_company_info.is_edefter') and session.ep.our_company_info.is_edefter eq 1 and isDefined('xml_payment_method') and xml_payment_method eq 1>
                                <cfset colspan = colspan + 1>
                            </cfif>
                            <cfif isDefined('session.ep.our_company_info.is_edefter') and session.ep.our_company_info.is_edefter eq 1 and isDefined('xml_document_type') and xml_document_type eq 1>
                                <cfset colspan = colspan + 1>
                            </cfif>
                            <td colspan="<cfoutput>#colspan#</cfoutput>"><cfif isdefined("attributes.form_varmi")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></td>
                        </tr>
                    </cfif>
                </tbody>
            </cf_grid_list>
            <cfset adres="account.#listlast(attributes.fuseaction,'.')#">
            <cfif isDefined('attributes.page_action_type') and len(attributes.page_action_type)>
                <cfset adres = "#adres#&page_action_type=#attributes.page_action_type#">
            </cfif>
            <cfif isDefined('attributes.fis_type') and len(attributes.fis_type)>
                <cfset adres = "#adres#&fis_type=#attributes.fis_type#">
            </cfif>
            <cfif isDefined('attributes.main_card_id') and len(attributes.main_card_id)>
                <cfset adres = "#adres#&main_card_id=#attributes.main_card_id#">
            </cfif>
            <cfif isDefined('attributes.card_id') and len(attributes.card_id)>
                <cfset adres = "#adres#&card_id=#attributes.card_id#">
            </cfif>
            <cfif isDefined('attributes.is_add_page') and len(attributes.is_add_page)>
                <cfset adres = "#adres#&is_add_page=#attributes.is_add_page#">
            </cfif>
            <cfif isDefined('attributes.is_delete_page') and len(attributes.is_delete_page)>
                <cfset adres = "#adres#&is_delete_page=#attributes.is_delete_page#">
            </cfif>
            <cfif isDefined('attributes.is_add_main_page') and len(attributes.is_add_main_page)>
                <cfset adres = "#adres#&is_add_main_page=#attributes.is_add_main_page#">
            </cfif>
            <cfif isDefined('attributes.oby') and len(attributes.oby)>
                <cfset adres = "#adres#&oby=#attributes.oby#">
            </cfif>
            <cfif isdefined("attributes.record_date")>
                <cfset adres = "#adres#&record_date=#dateFormat(attributes.record_date,dateformat_style)#">
            </cfif>
            <cfif isdefined("attributes.start_date")>
                <cfset adres = "#adres#&start_date=#dateFormat(attributes.start_date,dateformat_style)#">
            </cfif>
            <cfif isdefined ("attributes.employee_id") and len(attributes.employee_id)>
                <cfset adres = "#adres#&employee_id=#attributes.employee_id#&employee_name=#attributes.employee_name#">
            </cfif>
            <cfif isdefined ("attributes.company_id") and len(attributes.company_id)>
                <cfset adres = "#adres#&company_id=#attributes.company_id#&company=#attributes.company#">
            </cfif>
            <cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
                <cfset adres = "#adres#&consumer_id=#attributes.consumer_id#&company=#attributes.company#">
            </cfif>
            <cfif isdefined('attributes.action_process_cat') and len(attributes.action_process_cat)>
                <cfset adres = "#adres#&action_process_cat=#attributes.action_process_cat#">
            </cfif>
            <cfif isdefined("attributes.finish_date")>
                <cfset adres = "#adres#&finish_date=#dateFormat(attributes.finish_date,dateformat_style)#">
            </cfif>
            <cfif len(attributes.keyword)>
                <cfset adres = "#adres#&keyword=#attributes.keyword#">
            </cfif>
            <cfif len(attributes.belge_no)>
                <cfset adres = "#adres#&belge_no=#attributes.belge_no#">
            </cfif>
            <cfif isdefined("attributes.form_varmi")>
                <cfset adres = "#adres#&form_varmi=#attributes.form_varmi#" >
            </cfif>
            <cfif isdefined("attributes.acc_branch_id")>
                <cfset adres = '#adres#&acc_branch_id=#attributes.acc_branch_id#'>
            </cfif>
            <cfif len(attributes.list_type_form)>
                <cfset adres = "#adres#&list_type_form=#attributes.list_type_form#" >
            </cfif>
            <cfif isdefined("attributes.finish_record_date")>
                <cfset adres = "#adres#&finish_record_date=#dateFormat(attributes.finish_record_date,dateformat_style)#">
            </cfif>
            <cfif IsDefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>
                <cfset adres = "#adres#&project_id=#attributes.project_id#&project_head=#attributes.project_head#">
            </cfif>
            <cfif len(attributes.acc_code1_1)>
                <cfset adres = "#adres#&acc_code1_1=#attributes.acc_code1_1#">
            </cfif>
            <cfif len(attributes.acc_code2_1)>
                <cfset adres = "#adres#&acc_code2_1=#attributes.acc_code2_1#">
            </cfif>
            <cfif len(attributes.acc_code1_2)>
                <cfset adres = "#adres#&acc_code1_2=#attributes.acc_code1_2#">
            </cfif>
            <cfif len(attributes.acc_code2_2)>
                <cfset adres = "#adres#&acc_code2_2=#attributes.acc_code2_2#">
            </cfif>
            <cfif len(attributes.acc_code1_3)>
                <cfset adres = "#adres#&acc_code1_3=#attributes.acc_code1_3#">
            </cfif>
            <cfif len(attributes.acc_code2_3)>
                <cfset adres = "#adres#&acc_code2_3=#attributes.acc_code2_3#">
            </cfif>
            <cfif len(attributes.acc_code1_4)>
                <cfset adres = "#adres#&acc_code1_4=#attributes.acc_code1_4#">
            </cfif>
            <cfif len(attributes.acc_code2_4)>
                <cfset adres = "#adres#&acc_code2_4=#attributes.acc_code2_4#">
            </cfif>
            <cfif len(attributes.acc_code1_5)>
                <cfset adres = "#adres#&acc_code1_5=#attributes.acc_code1_5#">
            </cfif>
            <cfif len(attributes.acc_code2_5)>
                <cfset adres = "#adres#&acc_code2_5=#attributes.acc_code2_5#">
            </cfif>
            <cf_paging page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="#adres#">
            <cfsavecontent variable="message1"><cf_get_lang dictionary_id ='47417.Bu Fiş Entegreden Oluşturulmuş'><cf_get_lang dictionary_id ='58587.Devam etmek istiyor musunuz'></cfsavecontent>
            <cfsavecontent variable="message2"><cf_get_lang dictionary_id='47337.Kayıtlı Muhasebe Fişini Siliyorsunuz  Emin misiniz'></cfsavecontent>
            <cfsavecontent variable="message3"><cf_get_lang dictionary_id='47337.Kayıtlı Muhasebe Fişini Siliyorsunuz  Emin misiniz'></cfsavecontent>
            <cfsavecontent variable="message4"><cf_get_lang dictionary_id ='47418.Birleştirilmiş Fiş Yeniden Oluşturulacaktır'>.<cf_get_lang dictionary_id ='58588.Emin Misiniz'></cfsavecontent>
        </cf_box>
    </div>
    <script type="text/javascript">
        document.getElementById('keyword').focus();
        function input_control()
        {
            <cfif not session.ep.our_company_info.UNCONDITIONAL_LIST>
                if (form.keyword.value.length == 0 && form.belge_no.value.length == 0
                    && (form.finish_date.value.length == 0 || form.start_date.value.length == 0 )
                    && (form.employee_id.value.length == 0 || form.employee_name.value.length == 0)
                    && (form.action.value.length == 0 && form.fis_type.value.length==0)
                    <cfif isdefined('is_dsp_cari_member') and is_dsp_cari_member eq 1>
                    && (form.company_id.value.length == 0 || form.company.value.length == 0)
                    </cfif>
                    )
                    {
                        alert("<cf_get_lang dictionary_id='58950.En Az Bir Alanda Filtre Etmelisiniz'> !");
                        return false;
                    }
            <cfelse>
                return true;
            </cfif>
            if(form.list_type_form.options[form.list_type_form.selectedIndex].value== 2 && form.fis_type.options[form.fis_type.selectedIndex].value==3)
            {
                alert("<cf_get_lang dictionary_id ='47416.Geçiçi Açık Fişler Satır Bazında Listelenemez'>!");
                return false;
            }
            return true;
        }
        function go_to_sil(int_tip,int_card,card_date)
        {
            /* ilgili donemde e-defter olup olmadiginin kontrolu, aynı zamanda query icerisinde de kontrol edilir (javascript hatalarina karsin) */
            get_netbooks = wrk_query("SELECT TOP 1 NETBOOK_ID FROM NETBOOKS WHERE STATUS = 1 AND "+  js_date(card_date) + " BETWEEN START_DATE AND FINISH_DATE","dsn2");
            if(get_netbooks.recordcount)
            {
                alert("<cf_get_lang dictionary_id="51859.İşlem Tarihine Ait E-defter Bulunmaktadır!">");
                return false;
            }
            /* ilgili donemde e-defter olup olmadiginin kontrolu, aynı zamanda query icerisinde de kontrol edilir (javascript hatalarina karsin) */
            if (!global_date_check_value("<cfoutput>#dateformat(SESSION.EP.PERIOD_DATE,dateformat_style)#</cfoutput>",card_date, '<cf_get_lang dictionary_id="58951.Tarih Kısıtı Nedeniyle Muhasebe Fişini Silemezsiniz">!'))
                return false;
            else if(int_tip==1){
                 if (confirm("<cfoutput>#message1#</cfoutput>")){
                    if (confirm("<cfoutput>#message2#</cfoutput>")) windowopen('<cfoutput>#request.self#?fuseaction=account.del_card&card_id=</cfoutput>'+int_card+'&actionDate='+card_date,'small'); else return false;
                 }else{
                    return false;
                 }
            }else{
                if (confirm("<cfoutput>#message3#</cfoutput>")) windowopen('<cfoutput>#request.self#?fuseaction=account.del_card&card_id=</cfoutput>'+int_card+'&actionDate='+card_date,'small'); else return false;
            }
        }
        function sum_bills(new_card_id)
        {
            if (confirm("<cfoutput>#message4#</cfoutput>")) windowopen('<cfoutput>#request.self#?fuseaction=account.emptypopup_add_sum_bills&is_temporary_solve=1&card_id=</cfoutput>'+new_card_id,'small'); else return false;
        }
        function check_manuel()
        {
            alert("<cf_get_lang dictionary_id="51860.Manuel Olarak Oluşan Fişler, Fiş Çözülerek Çıkarılabilir!">");
            return false;
        }
    </script>
<cfsetting showdebugoutput="yes">