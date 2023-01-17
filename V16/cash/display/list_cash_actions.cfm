
<cfsetting showdebugoutput="no">
<cf_get_lang_set module_name="cash"><!--- sayfanin en altinda kapanisi var --->
<cfparam name="attributes.oby" default="1">
<cfparam name="toplam_bakiye" default="0">
<cfparam name="toplam_bakiye_" default="0">
<cfparam name="attributes.action_cash" default="2">
<cfparam name="attributes.special_definition_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.record_emp_id" default="">
<cfparam name="attributes.record_emp_name" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.record_date" default="">
<cfparam name="attributes.record_date2" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.paper_number" default="">
<cfparam name="attributes.cash_status" default="">
<cfparam name="attributes.action" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.total_val" default=0>
<cfparam name="attributes.cash" default="">
<cfparam name="attributes.page_action_type" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.employee_id")>
	<cfscript>
		attributes.acc_type_id = '';
		if(listlen(attributes.employee_id,'_') eq 2)
		{
			attributes.acc_type_id = listlast(attributes.employee_id,'_');
			attributes.emp_id = listfirst(attributes.employee_id,'_');
		}
		else
			attributes.emp_id = attributes.employee_id;
	</cfscript>
</cfif>
<cfif not isdefined("attributes.start_date")>
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.start_date=''>
	<cfelse>
		<cfset attributes.start_date = '#date_add('d',-7,wrk_get_today())#'>
	</cfif>
</cfif>
<cfif not isdefined("attributes.finish_date")>
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.finish_date=''>
	<cfelse>
		<cfset  attributes.finish_date= '#date_add('d',7,attributes.start_date)#'>
	</cfif>
</cfif>
<cfif not isdefined("attributes.record_date")>
	<cfset attributes.record_date=''>
</cfif>
<cfif not isdefined("attributes.record_date2")>
	<cfset attributes.record_date2=''>
</cfif>
<cfscript>
	cashActions = createobject("component","V16.cash.cfc.cash");
	totalValue = createObject("component","V16.cash.cfc.cash");
	totalValue.dsn2 = dsn2;
	totalValue.dsn = dsn;
	totalValue.dsn_alias = dsn_alias;
	totalValue.dsn3_alias = dsn3_alias;
	cashActions.dsn2 = dsn2;
	cashActions.dsn = dsn;
	cashActions.dsn_alias = dsn_alias;
	cashActions.dsn3_alias = dsn3_alias;
	cashActions.upload_folder = upload_folder;
</cfscript>
<cfif isdefined("attributes.is_form_submitted")>
	<cfif isdefined("attributes.record_date") and isdate (attributes.record_date)><cf_date tarih ="attributes.record_date"></cfif>
	<cfif isdefined("attributes.record_date2") and isdate (attributes.record_date2)><cf_date tarih ="attributes.record_date2"></cfif>
    <cfif isdefined("attributes.start_date") and isdate(attributes.start_date)><cf_date tarih = "attributes.start_date"></cfif>
    <cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)><cf_date tarih = "attributes.finish_date"></cfif>
    <cfscript>
		get_cash_actions = cashActions.getCashActions
		(
			is_excel : attributes.is_excel,
			acc_type_id : attributes.acc_type_id,
			employee_id : attributes.employee_id,
			emp_id : attributes.emp_id,
			record_date : attributes.record_date,
			record_date2 : attributes.record_date2,
			start_date : attributes.start_date,
			finish_date : attributes.finish_date,
			page_action_type : attributes.page_action_type,
			company_id : attributes.company_id,
			consumer_id : attributes.consumer_id,
			member_type : attributes.member_type,
			company : attributes.company,
			record_emp_id : attributes.record_emp_id,
			record_emp_name : attributes.record_emp_name,
			keyword : attributes.keyword,
			paper_number : attributes.paper_number,
			cash : attributes.cash,
			action : attributes.action,
			special_definition_id : attributes.special_definition_id,
			branch_id : attributes.branch_id,
			cash_status : attributes.cash_status,
			action_cash : attributes.action_cash,
			project_head : attributes.project_head,
			project_id : attributes.project_id,
			is_money : iif(isdefined("attributes.is_money") and len(attributes.is_money),de("attributes.is_money"),de('')),
			oby : attributes.oby,
			startrow : attributes.startrow,
			maxrows : attributes.maxrows,
			fuseaction : attributes.fuseaction,
			module_power_user_ehesap : '#get_module_power_user(48)#'
		);
		getTotalValue = totalValue.getCashActionTotal
		(
			acc_type_id : attributes.acc_type_id,
			employee_id : attributes.employee_id,
			emp_id : attributes.emp_id,
			record_date : attributes.record_date,
			record_date2 : attributes.record_date2,
			start_date : attributes.start_date,
			finish_date : attributes.finish_date,
			page_action_type : attributes.page_action_type,
			company_id : attributes.company_id,
			consumer_id : attributes.consumer_id,
			member_type : attributes.member_type,
			company : attributes.company,
			record_emp_id : attributes.record_emp_id,
			record_emp_name : attributes.record_emp_name,
			keyword : attributes.keyword,
			paper_number : attributes.paper_number,
			cash : attributes.cash,
			action : attributes.action,
			special_definition_id : attributes.special_definition_id,
			branch_id : attributes.branch_id,
			cash_status : attributes.cash_status,
			action_cash : attributes.action_cash,
			project_head : attributes.project_head,
			project_id : attributes.project_id,
			oby : attributes.oby,
			fuseaction : attributes.fuseaction,
			module_power_user_ehesap : '#get_module_power_user(48)#'
		);
	</cfscript>
    
	<cfif not (isdefined("attributes.is_excel") and attributes.is_excel eq 1)>
        <cfparam name="attributes.totalrecords" default='#get_cash_actions.query_count#'>
    <cfelse>
        <cfparam name="attributes.totalrecords" default="0">
    </cfif>
	<cfset arama_yapilmali = 0 >
<cfelse>
	<cfset GET_CASH_ACTIONS.recordcount = 0 >
    <cfparam name="attributes.totalrecords" default="0">
	<cfset arama_yapilmali = 1 >
</cfif>
<cfquery name="get_money_rate" datasource="#dsn2#">
	SELECT 
        MONEY, 
        RATE2, 
        MONEY_STATUS, 
        PERIOD_ID, 
        COMPANY_ID
    FROM 
    	SETUP_MONEY 
    WHERE 
	    MONEY_STATUS = 1 ORDER BY MONEY_ID
</cfquery>

<cfoutput query="get_money_rate">
	<cfset "rate_#money#" = rate2>
</cfoutput>
<cfquery name="get_branchs" datasource="#dsn#">
	SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH 
	<cfif session.ep.isBranchAuthorization>
		WHERE
			BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
	</cfif>
	ORDER BY BRANCH_ID
</cfquery>
<cfif isDefined("attributes.cash") and len(attributes.cash) and attributes.oby eq 2 and isDefined('attributes.start_date') and len(attributes.start_date)>
	<cfquery name="SUM_CASHS_BORC" datasource="#dsn2#">
		SELECT
			SUM(CASH_ACTION_VALUE) TOPLAM
		FROM 
			CASH_ACTIONS 
		WHERE
			ACTION_ID IS NOT NULL AND
			CASH_ACTION_TO_CASH_ID = #attributes.cash#
			<cfif isDefined('attributes.start_date') and len(attributes.start_date)> AND ACTION_DATE < #attributes.start_date#</cfif>
	</cfquery>
	<cfquery name="SUM_CASHS_ALACAK" datasource="#dsn2#">
		SELECT
			SUM(CASH_ACTION_VALUE) TOPLAM
		FROM 
			CASH_ACTIONS 
		WHERE
			ACTION_ID IS NOT NULL AND
			CASH_ACTION_FROM_CASH_ID = #attributes.cash#
			<cfif isDefined('attributes.start_date') and len(attributes.start_date)> AND ACTION_DATE < #attributes.start_date#</cfif>
	</cfquery>
	<cfquery name="get_cash_money" datasource="#dsn2#">
		SELECT CASH_CURRENCY_ID FROM CASH WHERE CASH_ID = #attributes.cash#
	</cfquery>
	<cfif len(SUM_CASHS_BORC.TOPLAM)>
		<cfset toplam_bakiye = toplam_bakiye + SUM_CASHS_BORC.TOPLAM>
		<cfset toplam_bakiye_ = toplam_bakiye_ + evaluate("rate_#get_cash_money.cash_currency_id#")*SUM_CASHS_BORC.TOPLAM>
	</cfif>
	<cfif len(SUM_CASHS_ALACAK.TOPLAM)>
		<cfset toplam_bakiye = toplam_bakiye - SUM_CASHS_ALACAK.TOPLAM>
		<cfset toplam_bakiye_ = toplam_bakiye_ - evaluate("rate_#get_cash_money.cash_currency_id#")*SUM_CASHS_ALACAK.TOPLAM>
	</cfif>
</cfif>
<cfset cat_list = '30,31,32,310,320,33,120,21,22,121,311,34,35'><!---34 VE 35 V15 KAPSAMINDA EKLENDİ --->
<cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
	SELECT PROCESS_TYPE,PROCESS_CAT_ID,#dsn#.Get_Dynamic_Language(PROCESS_CAT_ID,'#session.ep.language#','SETUP_PROCESS_CAT','PROCESS_CAT',NULL,NULL,PROCESS_CAT) AS PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (#cat_list#) ORDER BY PROCESS_TYPE
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="cash_list" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_cash_actions">
            <input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
            <cf_box_search>        
                <div class="form-group">
                    <cfinput type="text" name="keyword"  placeholder="#getLang(48,'Filtre',57460)#" value="#attributes.keyword#" maxlength="50">
                </div>
                <div class="form-group">
                    <input type="text" name="paper_number" id="paper_number" placeholder="<cfoutput>#getLang(468,'Belge No',57880)#</cfoutput>"  maxlength="50" value="<cfoutput>#attributes.paper_number#</cfoutput>">
                </div>
                <div class="form-group">
                    <select name="oby" id="oby">
                        <option value="1" <cfif attributes.oby eq 1>selected</cfif>><cf_get_lang dictionary_id='57926.Azalan Tarih'></option>
                        <option value="2" <cfif attributes.oby eq 2>selected</cfif>><cf_get_lang dictionary_id='57925.Artan Tarih'></option>
                        <option value="3" <cfif attributes.oby eq 3>selected</cfif>><cf_get_lang dictionary_id='29459.Artan No'></option>
                        <option value="4" <cfif attributes.oby eq 4>selected</cfif>><cf_get_lang dictionary_id='29458.Azalan No'></option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="col col-9">
                        <cfoutput>#session.ep.money#</cfoutput> <cf_get_lang dictionary_id='42004.Karşılığı'>
                    </label>
                    <input type="checkbox" name="is_money" id="is_money" <cfif isdefined("attributes.is_money")>checked</cfif>>
                </div>
                <div class="form-group">
                    <label class="col col-9"><cf_get_lang dictionary_id='57858.Excel Getir'></label>
                    <input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>>
                </div>
                <div class="form-group small">
                    <cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function='input_control()'>
                    <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                </div>
            </cf_box_search>
            <cf_box_search_detail>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-consumer_id">
                        <label class="col col-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
                                <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
                                <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
                                <input type="hidden" name="member_type" id="member_type" value="<cfoutput>#attributes.member_type#</cfoutput>">
                                <input name="company" type="text" id="company" onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\',\'0\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','company_id,consumer_id,employee_id,member_type','','3','250');" value="<cfoutput>#attributes.company#</cfoutput>" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_cari_action=1&field_comp_name=cash_list.company&field_comp_id=cash_list.company_id&field_emp_id=cash_list.employee_id&field_name=cash_list.company&field_consumer=cash_list.consumer_id&field_member_name=cash_list.company&field_type=cash_list.member_type<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,2,3,9&keyword='+encodeURIComponent(document.cash_list.company.value));" title="<cf_get_lang dictionary_id='58215.Muhasebe Fişi'>" ></span>
                            </div>
                        </div>    
                    </div>
                    <div class="form-group" id="item-branch_id">
                        <label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                        <div class="col col-12">
                            <select name="branch_id" id="branch_id">
                                <option value=""><cf_get_lang dictionary_id='57453.Şube'></option>
                                <cfoutput query="get_branchs">
                                    <option value="#BRANCH_ID#" <cfif isdefined('attributes.branch_id') and attributes.branch_id eq BRANCH_ID>selected</cfif>>#BRANCH_NAME#</option>
                                </cfoutput>
                            </select>
                        </div>    
                    </div>
                    <div class="form-group" id="item-cash">
                        <label class="col col-12"><cf_get_lang dictionary_id='57520.Kasa'></label>
                        <div class="col col-12">
                            <cf_wrk_Cash name="cash" value="#attributes.cash#" currency_branch="3">
                        </div>   
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-page_action_type">
                        <label class="col col-12"><cf_get_lang dictionary_id='57800.İşlem Tipi'></label>
                        <div class="col col-12">
                            <select name="page_action_type" id="page_action_type">
                                <option value="" selected><cf_get_lang dictionary_id='57800.İşlem Tipi'></option>
                                    <cfoutput query="get_process_cat" group="process_type">
                                        <option value="#process_type#" <cfif '#process_type#' is attributes.page_action_type>selected</cfif>>#get_process_name(process_type)#</option>
                                        <cfoutput>
                                            <option value="#process_type#-#process_cat_id#" <cfif attributes.page_action_type is '#process_type#-#process_cat_id#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#process_cat#</option>
                                        </cfoutput>
                                    </cfoutput>
                            </select>
                        </div>    
                    </div>
                    <div class="form-group" id="item-project_id">
                        <label class="col col-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="project_id" id="project_id" value="<cfoutput>#attributes.project_id#</cfoutput>">
                                <input type="text" name="project_head" id="project_head" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','list_works','3','250');" value="<cfoutput>#attributes.project_head#</cfoutput>" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=list_works.project_head&project_id=list_works.project_id</cfoutput>');" title="<cf_get_lang dictionary_id='58797.Proje Seiniz'>" ></span>
                            </div>
                        </div>    
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-action_cash">
                        <label class="col col-12"><cf_get_lang dictionary_id='57554.Giriş'>/<cf_get_lang dictionary_id='57431.Çıkış'></label>
                        <div class="col col-12">
                            <select name="action_cash" id="action_cash">
                                <option value="2"><cf_get_lang dictionary_id='57554.Giriş'>/<cf_get_lang dictionary_id='57431.Çıkış'></option>
                                <option value="1"<cfif isDefined("attributes.action_cash") and (attributes.action_cash eq 1)> selected</cfif>><cf_get_lang dictionary_id='57554.Giriş'></option>
                                <option value="0"<cfif isDefined("attributes.action_cash") and (attributes.action_cash eq 0)> selected</cfif>><cf_get_lang dictionary_id='57431.Çıkış'></option>
                            </select>
                        </div>    
                    </div>
                    <div class="form-group" id="item-cash_status">
                        <label class="col col-12"><cf_get_lang dictionary_id='57756.Durum'></label>
                        <div class="col col-12">
                            <select name="cash_status" id="cash_status">
                                <option value=""><cf_get_lang dictionary_id='57756.Durum'></option>
                                <option value="1"<cfif isDefined("attributes.cash_status") and (attributes.cash_status eq 1)> selected</cfif>><cf_get_lang dictionary_id ='49911.Aktif Kasa'></option>
                                <option value="0"<cfif isDefined("attributes.cash_status") and (attributes.cash_status eq 0)> selected</cfif>><cf_get_lang dictionary_id ='49912.Pasif Kasa'></option>
                            </select>
                        </div>    
                    </div>
                    <div class="form-group" id="item-special_definition">
                        <label class="col col-12"><cf_get_lang dictionary_id='57845.Tahsilat/Ödeme Tipi'></label>
                        <div class="col col-12">
                        <cf_wrk_special_definition width_info="130" list_filter_info="1" field_id="special_definition_id" selected_value='#attributes.special_definition_id#'>
                        </div>    
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                    <div class="form-group" id="item-record_emp">
                        <label class="col col-12"><cf_get_lang dictionary_id='57899.Kaydeden'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="record_emp_id"  id="record_emp_id" value="<cfoutput>#attributes.record_emp_id#</cfoutput>">
                                <input type="text" name="record_emp_name" id="record_emp_name" onFocus="AutoComplete_Create('record_emp_name','FULLNAME','FULLNAME','get_emp_pos','','EMPLOYEE_ID','record_emp_id','cash_list','3','125')" value="<cfoutput>#attributes.record_emp_name#</cfoutput>" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=cash_list.record_emp_id&field_name=cash_list.record_emp_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9');" title="<cf_get_lang dictionary_id='57899.Kaydeden'>"></span>
                            </div>
                        </div>    
                    </div>
                    <div class="form-group" id="item-record_date">
                        <label class="col col-12"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></label>
                        <div class="col col-6">
                            <div class="input-group">
                                <cfinput type="text" name="record_date" value="#dateformat(attributes.record_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#getLang('','Lütfen Tarih giriniz',58503)#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="record_date"></span>
                            </div>
                        </div>
                        <div class="col col-6">
                            <div class="input-group">
                                <cfinput type="text" name="record_date2" value="#dateformat(attributes.record_date2,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#getLang('','Başlama Tarihi',57655)#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="record_date2"></span>
                            </div>
                        </div>    
                    </div>
                    <div class="form-group" id="item-start_date">
                        <label class="col col-12"><cf_get_lang dictionary_id ='57879.İşlem Tarihi'></label>
                        <div class="col col-6">
                            <div class="input-group">
                                <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#getLang('','İşlem Tarihi',57879)#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span> 
                            </div>
                        </div>
                        <div class="col col-6">
                            <div class="input-group">
                                <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#getLang('','Bitiş Tarihi',57700)#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span> 
                            </div>
                        </div>    
                    </div>
                </div>
            </cf_box_search_detail>
        </cfform>
    </cf_box>
    <cf_box title="#getLang(1485,'Kasa İşlemleri',58897)#" uidrop="1" hide_table_column="1">
        <cf_grid_list>    
            <thead>
                <tr>
                    <th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='57880.Belge No'></th>
                    <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                    <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
                    <th><cf_get_lang dictionary_id='57800.İşlem Tipi'></th>
                    <th><cfoutput>#getlang(142,'İşlem Kategorisi',36305)#</cfoutput></th>
                    <th><cf_get_lang dictionary_id='57520.Kasa'></th>
                    <th><cf_get_lang dictionary_id='57519.cari Hesap'></th>
                    <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                    <th><cf_get_lang dictionary_id='57453.Şube'></th>
                    <th><cf_get_lang dictionary_id='57416.Proje'></th>
                    <th><cf_get_lang dictionary_id='57483.Kayıt'></th>
                    <cfif isdefined("attributes.action_cash") and ((attributes.action_cash eq 1) or (attributes.action_cash eq 2))>
                        <th><cf_get_lang dictionary_id ='57587.Borç'></th>
                        <th><cf_get_lang dictionary_id ='57489.Para Br'></th>
                    </cfif> 
                    <cfif isdefined("attributes.action_cash") and ((attributes.action_cash eq 0) or (attributes.action_cash eq 2))>
                        <th><cf_get_lang dictionary_id ='57588.Alacak'></th>
                        <th><cf_get_lang dictionary_id ='57489.Para Br'></th>
                    </cfif> 
                    <cfif isdefined("attributes.cash") and len(attributes.cash) and isdefined("attributes.oby") and len(attributes.oby) and (attributes.oby eq 2)>
                        <th><cf_get_lang dictionary_id='57589.Bakiye'></th>
                    </cfif>
                    <cfif isdefined("attributes.is_money")>
                        <cfif isdefined("attributes.action_cash") and ((attributes.action_cash eq 1) or (attributes.action_cash eq 2))>
                            <th><cfoutput>#session.ep.money#</cfoutput> <cf_get_lang dictionary_id ='57587.Borç'></th>
                        </cfif> 
                        <cfif isdefined("attributes.action_cash") and ((attributes.action_cash eq 0) or (attributes.action_cash eq 2))>
                            <th><cfoutput>#session.ep.money#</cfoutput> <cf_get_lang dictionary_id ='57588.Alacak'></th>
                        </cfif> 
                    </cfif>
                    <!-- sil --><th width="20" class="header_icn_none text-center" ><i class="fa fa-print" title="<cf_get_lang dictionary_id='57474.Yazdır'>" alt="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></th><!-- sil -->
                </tr>
            </thead>
            <cfif not (isdefined("attributes.is_excel") and attributes.is_excel eq 1)>
                <cfif get_cash_actions.recordcount>
                    <tbody>
                        <cfif isDefined("attributes.cash") and len(attributes.cash) and attributes.oby eq 2>
                            <tr class="color-list">
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td class="text-left"><cf_get_lang dictionary_id ='49913.Önceki Devir'></td>
                                <td class="text-right"> 
                                    <cfif attributes.page gt 1 >
                                        <cfset toplam_bakiye = attributes.total_val> 
                                        <cfoutput>#attributes.total_val#</cfoutput> 
                                    <cfelse>
                                        <cfoutput>#TLFormat(toplam_bakiye)#</cfoutput>
                                    </cfif>
                                </td>
                                <cfif isdefined("attributes.is_money")>
                                    <cfif isdefined("attributes.action_cash") and ((attributes.action_cash eq 1) or (attributes.action_cash eq 2))>
                                        <td></td>
                                    </cfif> 
                                    <cfif isdefined("attributes.action_cash") and ((attributes.action_cash eq 0) or (attributes.action_cash eq 2))>
                                        <td></td>
                                    </cfif> 
                                </cfif>
                                <!-- sil --><td></td><!-- sil -->
                            </tr>
                        </cfif>
                            <!---<cfloop from="1" to="#(attributes.page-1)*attributes.maxrows#" index="kkk">
                                <cfif (len(get_cash_actions.CASH_ACTION_FROM_CASH_ID[kkk]) and get_cash_actions.CASH_ACTION_FROM_CASH_ID[kkk] eq attributes.cash)>
                                    <cfset toplam_bakiye = toplam_bakiye -get_cash_actions.CASH_ACTION_VALUE[kkk]> 
                                <cfelseif (len(get_cash_actions.CASH_ACTION_TO_CASH_ID[kkk]) and get_cash_actions.CASH_ACTION_TO_CASH_ID[kkk] eq attributes.cash)>
                                    <cfset toplam_bakiye = toplam_bakiye +get_cash_actions.CASH_ACTION_VALUE[kkk]> 
                                </cfif>
                            </cfloop>--->
                            
                        <cfset money_type = ''>
                        <cfoutput query="get_cash_actions">
                            <cfswitch expression = "#get_cash_actions.action_type_id#">
                                <cfcase value=21><cfset type="#listgetat(attributes.fuseaction,1,'.')#.popup_dsp_invest_money"></cfcase>
                                <cfcase value=22><cfset type="#listgetat(attributes.fuseaction,1,'.')#.popup_dsp_get_money"></cfcase>
                                <cfcase value=30><cfset type="#listgetat(attributes.fuseaction,1,'.')#.form_add_cash_open&event=upd"></cfcase>
                                <cfcase value=31><cfset type="#listgetat(attributes.fuseaction,1,'.')#.form_add_cash_revenue&event=upd"></cfcase>
                                <cfcase value=32><cfset type="#listgetat(attributes.fuseaction,1,'.')#.form_add_cash_payment&event=upd"></cfcase>
                                <cfcase value=310><cfset type="#listgetat(attributes.fuseaction,1,'.')#.form_add_cash_revenue&event=updMulti"></cfcase>
                                <cfcase value=320><cfset type="#listgetat(attributes.fuseaction,1,'.')#.form_add_cash_payment&event=updMulti"></cfcase>
                                <cfcase value="33"><cfset type="#listgetat(attributes.fuseaction,1,'.')#.form_add_cash_to_cash&event=upd"></cfcase>
                                <cfcase value="37"><cfset type="cash.popup_upd_gider_pusula"></cfcase>
                                <cfcase value="1040"><cfset type="#listgetat(attributes.fuseaction,1,'.')#.popup_dsp_payroll_bank_revenue"></cfcase>
                                <cfcase value="1050"><cfset type="#listgetat(attributes.fuseaction,1,'.')#.popup_dsp_voucher_payroll_bank_revenue"></cfcase>
                                <cfcase value="1054"><cfset type="objects.popup_voucher_det"></cfcase>
                                <cfdefaultcase><cfset type="#listgetat(attributes.fuseaction,1,'.')#.list_cash_actions"></cfdefaultcase>
                            </cfswitch>
                            <cfswitch expression="#get_cash_actions.action_type_id#">
                                <cfcase value="21,22">
                                    <cfset table_name="BANK_ACTIONS">
                                    <cfset VAL_ID = GET_CASH_ACTIONS.BANK_ACTION_ID>
                                </cfcase>
                                <cfcase value="92">
                                    <cfset table_name="PAYROLL">
                                    <cfset VAL_ID = GET_CASH_ACTIONS.PAYROLL_ID>
                                </cfcase>
                                <cfcase value="104">
                                    <cfset table_name="VOUCHER_PAYROLL">
                                    <cfset VAL_ID = GET_CASH_ACTIONS.PAYROLL_ID>
                                </cfcase>
                                <cfdefaultcase>
                                    <cfset table_name="CASH_ACTIONS">
                                    <cfset VAL_ID = GET_CASH_ACTIONS.ACTION_ID>
                                </cfdefaultcase>
                            </cfswitch>
                            <tr>
                                <td>#rowNum#</td>
                                <td>#get_cash_actions.PAPER_NO#</td>
                                <td>#dateformat(get_cash_actions.ACTION_DATE,dateformat_style)#</td>
                                <td>#dateformat(get_cash_actions.record_date,dateformat_style)#</td>
                                <td>
                                    <cfif action_type_id eq 34><!---Alış Faturası Kapama İşlemi--->
                                        <cfif action_type contains 'Serbest'><!---Serbest Meslek Makbuzu Ödemesi--->
                                            <a href="#request.self#?fuseaction=invoice.form_add_bill_other&event=upd&iid=#BILL_ID#"  >#action_type#</a>
                                        <cfelseif action_type contains 'demir'>
                                            <a href="#request.self#?fuseaction=invent.add_invent_purchase&event=upd&invoice_id=#BILL_ID#"  >#action_type#</a>
                                        <cfelse>
                                            <a href="#request.self#?fuseaction=invoice.form_add_bill_purchase&event=upd&iid=#BILL_ID#"  >#action_type#</a>
                                        </cfif>                 
                                    <cfelseif action_type_id eq 35><!---Satış Faturası Kapama İşlemi--->
                                        <a href="#request.self#?fuseaction=invoice.form_add_bill&event=upd&iid=#BILL_ID#"  >#action_type#</a>                        
                                    <cfelseif action_type_id eq 311 and len(multi_action_id)><!--- kur değerleme işlemi--->
                                        <a   href="javascript://" onClick="javascript:windowopen('#request.self#?fuseaction=cash.popup_dsp_cash_rate_valuation&multi_action_id=#multi_action_id#','small')">#action_type#</a> 
                                    <cfelseif action_type_id eq 31 and len(multi_action_id)><!--- Toplu tahsilat --->
                                        <a href="#request.self#?fuseaction=cash.form_add_cash_revenue&event=updMulti&multi_id=#multi_action_id#"  >#action_type#</a> 
                                    <cfelseif action_type_id eq 32 and len(multi_action_id)><!--- Toplu ödeme --->
                                        <a href="#request.self#?fuseaction=cash.form_add_cash_payment&event=updMulti&multi_id=#multi_action_id#"  >#action_type#</a> 
                                    <cfelseif listfind('31',action_type_id) and process_cat eq 0 and len(order_id)><!--- taksitli satış ekranından yapılan tahsilatlar kendi sayfasından güncellenmeli --->
                                        <a   href="javascript://" onClick="alert('<cf_get_lang dictionary_id='49972.Bu İşlemi İlgili Olduğu Ödeme Planından Güncelleyebilirsiniz'>! <cf_get_lang dictionary_id='57880.Belge No'> :#paper_no#');">#ACTION_TYPE#</a>
                                    <cfelseif listfind('31',action_type_id) and process_cat eq 0 and not len(order_id)><!--- taksitli satış ekranından yapılan tahsilatlar kendi sayfasından güncellenmeli --->
                                        <a   href="javascript://" onClick="alert('<cf_get_lang dictionary_id='49973.Bu İşlemi İlgili Olduğu Senet Tahsilat İşleminden Güncelleyebilirsiniz'>!<cf_get_lang dictionary_id='57880.Belge No'> :#paper_no#');">#ACTION_TYPE#</a>
                                    <cfelseif action_type_id eq 32 and process_cat eq 0><!--- senet tahsilat iptal --->
                                        <a   href="javascript://" onClick="alert('Senet Tahsilat İşleminden Kaydedilen Ödeme İşlemini Güncelleyemezsiniz !');">#ACTION_TYPE#</a>
                                    <cfelseif action_type_id eq 120>
                                        <a   href="#request.self#?fuseaction=cost.form_add_expense_cost&event=upd&expense_id=#expense_id#">#action_type#</a>
                                    <cfelseif action_type_id eq 121>
                                        <a   href="#request.self#?fuseaction=cost.add_income_cost&event=upd&expense_id=#expense_id#">#action_type#</a>
                                    <cfelseif action_type_id eq 33>
                                        <cfif with_next_row eq 0>
                                            <cfquery name="first_action_id" datasource="#dsn2#" maxrows="1">
                                                SELECT ACTION_ID FROM CASH_ACTIONS WHERE ACTION_ID < #ACTION_ID# ORDER BY ACTION_ID DESC
                                            </cfquery>
                                        </cfif>		
                                        <a   href="#request.self#?fuseaction=#type#&ID=<cfif with_next_row neq 0>#ACTION_ID#<cfelse>#first_action_id.ACTION_ID#</cfif>">#ACTION_TYPE#</a>
                                    <cfelse>
                                        <!---<cfif not (type is '#listgetat(attributes.fuseaction,1,'.')#.list_cash_actions')>
                                            <a   href="javascript://"
                                            onClick="javascript:windowopen('#request.self#?fuseaction=#type#
                                            <cfif type is 'cash.form_add_cash_open&event=upd'>
                                                &CID=#CASH_ACTION_TO_CASH_ID#</cfif>
                                            <cfif type is 'objects.popup_voucher_det'>
                                                &id=#voucher_id#<cfelse>&ID=#VAL_ID#</cfif>','
                                            <cfif table_name is 'PAYROLL'>list
                                            <cfelseif (type is '#listgetat(attributes.fuseaction,1,'.')#.form_add_cash_payment&event=upd') or (type is '#listgetat(attributes.fuseaction,1,'.')#.form_add_cash_revenue&event=upd') or (type is '#listgetat(attributes.fuseaction,1,'.')#.popup_dsp_payroll_bank_revenue') or (type is '#listgetat(attributes.fuseaction,1,'.')#.popup_upd_cash_to_cash') or (type is '#listgetat(attributes.fuseaction,1,'.')#.popup_dsp_voucher_payroll_bank_revenue')>list<cfelse>medium</cfif>');">
                                        </cfif>
                                        #ACTION_TYPE#
                                        <cfif not (type is '#listgetat(attributes.fuseaction,1,'.')#.list_cash_actions')>
                                            </a> 
                                        </cfif>
                                        --->
                                        <cfif not (type is '#listgetat(attributes.fuseaction,1,'.')#.list_cash_actions')>
                                            <cfif type is 'cash.form_add_cash_open&event=upd'>
                                                <a   href="#request.self#?fuseaction=#type#&ID=#ACTION_ID#">
                                            <cfelseif (type is '#listgetat(attributes.fuseaction,1,'.')#.form_add_cash_payment&event=upd') or (type is '#listgetat(attributes.fuseaction,1,'.')#.form_add_cash_revenue&event=upd') or (type is '#listgetat(attributes.fuseaction,1,'.')#.form_add_cash_to_cash&event=upd')>
                                                <a   href="#request.self#?fuseaction=#type#&ID=#VAL_ID#">
                                            <cfelse>
                                                <a   href="javascript://" onClick="javascript:windowopen('#request.self#?fuseaction=#type#<cfif type is 'objects.popup_voucher_det'>&id=#voucher_id#<cfelse>&ID=#VAL_ID#</cfif>','<cfif (table_name is 'PAYROLL') or (type is '#listgetat(attributes.fuseaction,1,'.')#.popup_dsp_payroll_bank_revenue') or (type is '#listgetat(attributes.fuseaction,1,'.')#.popup_dsp_voucher_payroll_bank_revenue')>list<cfelse>medium</cfif>');">
                                            </cfif>
                                            
                                            #ACTION_TYPE#
                                        <cfif not (type is '#listgetat(attributes.fuseaction,1,'.')#.list_cash_actions')>
                                            </a> 
                                        </cfif>
                                    </cfif>
                                </cfif>
                                </td>
                                    <td> 
                                        #get_cash_actions.STAGE#
                                    </td>
                                <td>
                                    <cfif len(CASH)>
                                        #CASH#
                                    </cfif>
                                </td>
                                <td>
                                    <cfif len(COMPANY)>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#COMP_ID#','medium');"  >#COMPANY#</a>
                                    </cfif>
                                    <cfif len(CONSUMER)>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#CONS_ID#','medium');"  >#CONSUMER#</a>
                                    </cfif>
                                    <cfif len(EMPLOYEE)>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#EMP_ID#','medium');"  >#EMPLOYEE#</a>                        	
                                    </cfif>
                                    <cfif len(ACCOUNT)>
                                        #ACCOUNT#
                                    </cfif>
                                    <cfif len(EXPENSE_ITEM)>
                                        #EXPENSE_ITEM#
                                    </cfif>
                                </td>
                                <td title="#ACTION_DETAIL#"><cfif fusebox.fuseaction contains 'autoexcelpopuppage_'>#ACTION_DETAIL#<cfelse>#left(ACTION_DETAIL,20)#</cfif></td>
                                <!--- Proje ve Şube --->
                                    <td>#get_cash_actions.BRANCH#</td>
                                    <td>#get_cash_actions.PROJECT#</td>

                                <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#rec_emp_id#','medium');"  > #RECORD_EMP# </a></td>
                                <cfif isdefined("attributes.action_cash") and ((attributes.action_cash eq 1) or (attributes.action_cash eq 2))>
                                    <td class="text-right">
                                        <cfif len(CASH_ACTION_TO_CASH_ID)>
                                            <cfif isDefined("attributes.CASH") and len(attributes.CASH) and CASH_ACTION_TO_CASH_ID eq attributes.CASH>
                                                #TLFormat(get_cash_actions.CASH_ACTION_VALUE)#
                                            <cfelseif isDefined("attributes.CASH") and not len(attributes.CASH)>
                                                #TLFormat(get_cash_actions.CASH_ACTION_VALUE)#
                                            </cfif>
                                        </cfif>
                                    </td>
                                    <td><cfif len(CASH_ACTION_TO_CASH_ID)>#get_cash_actions.CASH_ACTION_CURRENCY_ID#</cfif></td>
                                </cfif>
                                <cfif isdefined("attributes.action_cash") and ((attributes.action_cash eq 0) or (attributes.action_cash eq 2))>
                                    <td class="text-right">
                                        <cfif len(CASH_ACTION_FROM_CASH_ID)>
                                            <cfif isDefined("attributes.CASH") and len(attributes.CASH) and CASH_ACTION_FROM_CASH_ID eq attributes.CASH>
                                                #TLFormat(get_cash_actions.CASH_ACTION_VALUE)#
                                            <cfelseif isDefined("attributes.CASH") and not len(attributes.CASH)>
                                                #TLFormat(get_cash_actions.CASH_ACTION_VALUE)#
                                            </cfif>
                                        </cfif>
                                    </td>
                                    <td><cfif len(CASH_ACTION_FROM_CASH_ID)>#get_cash_actions.CASH_ACTION_CURRENCY_ID#</cfif></td>
                                </cfif>
                                <cfif isdefined("attributes.cash") and len(attributes.cash) and attributes.oby eq 2>
                                        <cfif len(get_cash_actions.CASH_ACTION_FROM_CASH_ID) and (get_cash_actions.CASH_ACTION_FROM_CASH_ID eq attributes.cash)>
                                            <cfset toplam_bakiye = toplam_bakiye -get_cash_actions.CASH_ACTION_VALUE> 
                                        <cfelseif len(get_cash_actions.CASH_ACTION_TO_CASH_ID) and (get_cash_actions.CASH_ACTION_TO_CASH_ID eq attributes.cash)>
                                            <cfset toplam_bakiye = toplam_bakiye +get_cash_actions.CASH_ACTION_VALUE> 
                                        </cfif>
                                        <td class="text-right">#TLFormat(toplam_bakiye)#<cfif toplam_bakiye gt 0>(B)<cfelse>(A)</cfif></td>
            
                                </cfif>
                                <cfif isdefined("attributes.is_money")>
                                    <cfif isdefined("attributes.action_cash") and ((attributes.action_cash eq 1) or (attributes.action_cash eq 2))>
                                        <td class="text-right">
                                            <cfif len(CASH_ACTION_TO_CASH_ID)>
                                                <cfif isDefined("attributes.CASH") and len(attributes.CASH) and CASH_ACTION_TO_CASH_ID eq attributes.CASH>
                                                    #TLFormat(SYSTEM_ACTION_VALUE)#
                                                <cfelseif isDefined("attributes.CASH") and not len(attributes.CASH)>
                                                    #TLFormat(SYSTEM_ACTION_VALUE)#
                                                </cfif>
                                            </cfif>
                                        </td>
                                    </cfif>
                                    <cfif isdefined("attributes.action_cash") and ((attributes.action_cash eq 0) or (attributes.action_cash eq 2))>
                                        <td class="text-right">
                                            <cfif len(CASH_ACTION_FROM_CASH_ID)>
                                                <cfif isDefined("attributes.CASH") and len(attributes.CASH) and CASH_ACTION_FROM_CASH_ID eq attributes.CASH>
                                                    #TLFormat(SYSTEM_ACTION_VALUE)#
                                                <cfelseif isDefined("attributes.CASH") and not len(attributes.CASH)>
                                                    #TLFormat(SYSTEM_ACTION_VALUE)#
                                                </cfif>
                                            </cfif>
                                        </td>
                                    </cfif>
                                </cfif>
                                <!-- sil -->
                                <cfif get_cash_actions.action_type_id eq 31 >
                                    <td><a href="javascript://" onClick="window.open('#request.self#?fuseaction=objects.popup_print_files&print_type=133&action_id=#val_id#','print_page')"><i class="fa fa-print" title="<cf_get_lang dictionary_id='57474.Yazdır'>" alt="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></a></td>
                                <cfelseif get_cash_actions.action_type_id eq 32>
                                    <td>
                                        <a href="javascript://" onclick="window.open('#request.self#?fuseaction=objects.popup_print_files&print_type=132&action_id=#val_id#','print_page');"><i class="fa fa-print" title="<cf_get_lang dictionary_id='57474.Yazdır'>" alt="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></a>
                                    </td>
                                <cfelse>
                                    <td></td>
                                </cfif>
                                <!-- sil -->
                            </tr>
                            <cfset attributes.total_val = toplam_bakiye>                    
                        </cfoutput>                    
                    </tbody>
                    <tfoot>
                        <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <cfoutput><td class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57680.Genel Toplam'></td></cfoutput>
                            <cfif isdefined("attributes.action_cash") and attributes.action_cash neq 0>
                                <td class="txtbold" style="text-align:right;">
                                    <cfoutput query="getTotalValue">
                                        <cfif debt_total gt 0>
                                            #Tlformat(debt_total)#<br/>
                                        </cfif>
                                    </cfoutput>
                                </td>
                                <td class="txtbold">
                                    <cfoutput query="getTotalValue">
                                        <cfif debt_total gt 0>
                                            #debt_curr#<br/>
                                        </cfif>
                                    </cfoutput>
                                </td>
                            </cfif>
                            <cfif isdefined("attributes.action_cash") and attributes.action_cash neq 1>
                                <td class="txtbold" style="text-align:right;">
                                    <cfoutput query="getTotalValue">
                                        <cfif claim_total gt 0>
                                            #Tlformat(claim_total)#<br/>
                                        </cfif>
                                    </cfoutput>
                                </td>
                                <td class="txtbold">
                                    <cfoutput query="getTotalValue">
                                        <cfif claim_total gt 0>
                                            #claim_curr#<br/>
                                        </cfif>
                                    </cfoutput>
                                </td>
                            </cfif>
                            <cfif isdefined("attributes.cash") and len(attributes.cash) and attributes.oby eq 2>
                                <td class="txtbold" style="text-align:right;"><cfoutput>#tlFormat(toplam_bakiye)#<cfif toplam_bakiye gt 0>(B)<cfelse>(A)</cfif></cfoutput></td>
                            </cfif>
                            <!--- <cfset col_ = 1>
                            <cfif isDefined("attributes.cash") and len(attributes.cash) and attributes.oby eq 2>
                                <cfif isdefined("attributes.action_cash") and ((attributes.action_cash eq 1) or (attributes.action_cash eq 2))>
                                    <cfset col_ = col_ + 1>
                                </cfif>
                                <cfif isdefined("attributes.action_cash") and ((attributes.action_cash eq 0) or (attributes.action_cash eq 2))>
                                    <cfset col_ = col_ + 1>
                                </cfif>
                            </cfif> --->
                            <!--- <cfif isdefined("attributes.is_money")><cfset col_ = col_ + 2></cfif> --->
                            <cfif isdefined("attributes.is_money")>
                                <cfif isdefined("attributes.action_cash") and ((attributes.action_cash eq 1) or (attributes.action_cash eq 2))>
                                    <td></td>
                                </cfif> 
                                <cfif isdefined("attributes.action_cash") and ((attributes.action_cash eq 0) or (attributes.action_cash eq 2))>
                                    <td></td>
                                </cfif> 
                            </cfif>
                            <td></td>
                        </tr>
                    </tfoot>
                </cfif>
            </cfif>
        </cf_grid_list>
        <cfif get_cash_actions.recordcount eq 0>
            <div class="ui-info-bottom">
                <p><cfif arama_yapilmali eq 1><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</cfif></p>
            </div>
        </cfif>
        <cfset adres="#listgetat(attributes.fuseaction,1,'.')#.list_cash_actions">
        <cfif isDefined('attributes.action') and len(attributes.action)>
            <cfset adres = adres&"&action="&attributes.action>
        </cfif>
        <cfif len(attributes.keyword)>
            <cfset adres = adres&"&keyword="&attributes.keyword>
        </cfif>
        <cfif len(attributes.paper_number)>
            <cfset adres = adres&"&paper_number="&attributes.paper_number>
        </cfif>
        <cfif isDefined('attributes.oby') and len(attributes.oby)>
            <cfset adres = adres&'&oby='&attributes.oby>
        </cfif>
        <cfif isDefined('attributes.branch_id') and len(attributes.branch_id)>
            <cfset adres = adres&'&branch_id='&attributes.branch_id>
        </cfif>
        <cfif isDefined('attributes.page_action_type')>
            <cfset adres = adres&"&page_action_type="&attributes.page_action_type>
        </cfif>
        <cfif isDefined('attributes.cash')>
            <cfset adres = adres&"&cash="&attributes.cash>
        </cfif>
        <cfif isDefined('attributes.company') and len(attributes.company)>
            <cfset adres = adres&"&company="&attributes.company>
        </cfif>
        <cfif isDefined('attributes.company_id') and len(attributes.company_id)>
            <cfset adres = adres&"&company_id="&attributes.company_id>
        </cfif>
        <cfif isDefined('attributes.consumer_id') and len(attributes.consumer_id)>
            <cfset adres = adres&"&consumer_id="&attributes.consumer_id>
        </cfif>
        <cfif isDefined('attributes.employee_name') and len(attributes.employee_name)>
            <cfset adres = adres&"&employee_name="&attributes.employee_name>
        </cfif>
        <cfif isDefined('attributes.employee_id') and len(attributes.employee_id)>
            <cfset adres = adres&"&employee_id="&attributes.employee_id>
        </cfif>
        <cfif isDefined('attributes.member_type') and len(attributes.member_type)>
            <cfset adres = adres&"&member_type="&attributes.member_type>
        </cfif>
        <cfif isDefined('attributes.cash_status') and len(attributes.cash_status)>
            <cfset adres = adres&"&cash_status="&attributes.cash_status>
        </cfif>
        <cfif isDefined('attributes.record_emp_id') and len(attributes.record_emp_id)>
            <cfset adres = adres&"&record_emp_id="&attributes.record_emp_id>
            <cfset adres = adres&"&record_emp_name="&attributes.record_emp_name>
        </cfif>
        <cfif isdefined('attributes.is_form_submitted') and len(attributes.is_form_submitted)>
            <cfset adres = adres&"&is_form_submitted=" &1>
        </cfif>
        <cfif isDefined('attributes.special_definition_id') and len(attributes.special_definition_id)>
            <cfset adres = '#adres#&special_definition_id=#attributes.special_definition_id#'>
        </cfif>
        <cfif isDefined('attributes.action_cash')>
            <cfset adres = '#adres#&action_cash=#attributes.action_cash#'>
        </cfif>
        <cfif isDefined('attributes.is_money')>
            <cfset adres = '#adres#&is_money=#attributes.is_money#'>
        </cfif>
        <cfif len(attributes.project_id)>
            <cfset adres = "#adres#&project_id=#attributes.project_id#">
        </cfif>
        <cfif len(attributes.project_head)>
            <cfset adres = "#adres#&project_head=#attributes.project_head#">
        </cfif>
        <cfset adres = "#adres#&record_date=#dateformat(attributes.record_date,dateformat_style)#">
        <cfset adres = "#adres#&record_date2=#dateformat(attributes.record_date2,dateformat_style)#">
        <cfset adres = "#adres#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
        <cfset adres = "#adres#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
        <cfset adres = "#adres#&total_val=#attributes.total_val#">
        <cf_paging 
            page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="#adres#">
    </cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function input_control()
	{
		if(cash_list.company.value.length == 0)
		{
			cash_list.company_id.value = '';
			cash_list.consumer_id.value = '';
		}
		<cfif not session.ep.our_company_info.unconditional_list>
			if(document.getElementById('page_action_type').value.length == 0 && document.getElementById('keyword').value.length == 0 && document.getElementById('paper_number').value.length == 0 && ((document.getElementById('company').value.length == 0 || document.getElementById('employee_id').value.length == 0)) &&(document.getElementById('company').value.length == 0 || document.getElementById('company_id').value.length == 0) && document.getElementById('consumer_id').value.length == 0 && (document.getElementById('start_date').value.length ==0 && document.getElementById('finish_date').value.length ==0) )
				{
					alert("<cf_get_lang dictionary_id='58950.En az bir alanda filtre etmelisiniz'>!");
					return false;
				}
			else return true;
		<cfelse>
			return true;
		</cfif>
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
    <cfsetting showdebugoutput="1">