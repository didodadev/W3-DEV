<cf_get_lang_set module_name="ch">
<cf_xml_page_edit fuseact="ch.list_caris">
<cfset adres="#listgetat(attributes.fuseaction,1,'.')#.list_caris">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.company_name" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.action_type_ch" default="">
<cfparam name="attributes.member_cat_type" default="">
<cfparam name="attributes.record_emp" default="">
<cfparam name="attributes.record_name" default="">
<cfparam name="attributes.asset_id" default="">
<cfparam name="attributes.asset_name" default="">
<cfparam name="attributes.expense_center_id" default="">
<cfparam name="attributes.expense_center_name" default="">
<cfparam name="attributes.expense_item_id" default="">
<cfparam name="attributes.expense_item_name" default="">
<cfparam name="attributes.special_definition_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.pos_code" default="">
<cfparam name="attributes.pos_code_text" default="">
<cfparam name="attributes.is_paper_closer" default="1">
<cfparam name="attributes.is_excel" default="">
<cfscript>
  	getAccountingType = createObject("component", "V16.settings.cfc.accountingType");
 	getAccount = getAccountingType.getAccountType();
</cfscript>
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelse>
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.start_date = ''>
	<cfelse>
		<cfset attributes.start_date = date_add('d',-7,wrk_get_today())>
	</cfif>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelse>
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.finish_date = ''>
	<cfelse>
	<cfset attributes.finish_date = date_add('d',7,attributes.start_date)>
	</cfif>
</cfif>
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.form_varmi")>
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
	<cfset list_acc_type_id = "">
	<cfset list_company = "">
	<cfset list_consumer = "">
	<cfif len(attributes.member_cat_type)>
		<cfloop from="1" to="#listlen(attributes.member_cat_type,',')#" index="ix">
			<cfset list_getir = listgetat(attributes.member_cat_type,ix,',')>
			<cfif listfirst(list_getir,'-') eq 1 and listlast(list_getir,'-') neq 0>
				<cfset list_company = listappend(list_company,listlast(list_getir,'-'),'-')>
			<cfelseif listfirst(list_getir,'-') eq 2 and listlast(list_getir,'-') neq 0>
				<cfset list_consumer = listappend(list_consumer,listlast(list_getir,'-'),'-')>
			<cfelseif listfirst(list_getir,'-') eq 3 and replace(list_getir,'#listfirst(list_getir,'-')#-','') neq 0>
				<cfset list_acc_type_id = listappend(list_acc_type_id,replace(list_getir,'#listfirst(list_getir,'-')#-',''),',')>
			</cfif>
			<cfset list_company = listsort(listdeleteduplicates(replace(list_company,"-",",","all"),','),'numeric','ASC',',')>
			<cfset list_consumer = listsort(listdeleteduplicates(replace(list_consumer,"-",",","all"),','),'numeric','ASC',',')>
		</cfloop>
	</cfif>
	<cfscript>
    get_caris_list_action = createObject("component", "V16.ch.cfc.get_caris");
	get_caris_list_action.dsn2 = dsn2;
	get_caris_list_action.dsn_alias = dsn_alias;
	get_caris_list_action.fusebox.general_cached_time = fusebox.general_cached_time;
	get_caris_list_action.upload_folder = upload_folder;
	get_caris = get_caris_list_action.get_caris_fnc
		(
			action_type_ch : '#IIf(IsDefined("attributes.action_type_ch"),"attributes.action_type_ch",DE(""))#',
			start_date : '#IIf(IsDefined("attributes.start_date"),"attributes.start_date",DE(""))#',
			finish_date : '#IIf(IsDefined("attributes.finish_date"),"attributes.finish_date",DE(""))#',
			keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(""))#',
			consumer_id : '#IIf(IsDefined("attributes.consumer_id"),"attributes.consumer_id",DE(""))#',
			company_name : '#IIf(IsDefined("attributes.company_name"),"attributes.company_name",DE(""))#',
			company_id : '#IIf(IsDefined("attributes.company_id"),"attributes.company_id",DE(""))#',
			emp_id : '#IIf(IsDefined("attributes.emp_id"),"#attributes.emp_id#",DE(""))#',
			employee_name : '#IIf(IsDefined("attributes.employee_name"),"attributes.employee_name",DE(""))#',
			member_cat_type : '#IIf(IsDefined("attributes.member_cat_type"),"attributes.member_cat_type",DE(""))#',
			branch_id : '#IIf(IsDefined("attributes.branch_id"),"attributes.branch_id",DE(""))#',
			record_name : '#IIf(IsDefined("attributes.record_name"),"attributes.record_name",DE(""))#',
			record_emp : '#IIf(IsDefined("attributes.record_emp"),"attributes.record_emp",DE(""))#',
			asset_id : '#IIf(IsDefined("attributes.asset_id"),"attributes.asset_id",DE(""))#',
			asset_name : '#IIf(IsDefined("attributes.asset_name"),"attributes.asset_name",DE(""))#',
			expense_center_id : '#IIf(IsDefined("attributes.expense_center_id"),"attributes.expense_center_id",DE(""))#',
			expense_center_name : '#IIf(IsDefined("attributes.expense_center_name"),"attributes.expense_center_name",DE(""))#',
			expense_item_id : '#IIf(IsDefined("attributes.expense_item_id"),"attributes.expense_item_id",DE(""))#',
			expense_item_name : '#IIf(IsDefined("attributes.expense_item_name"),"attributes.expense_item_name",DE(""))#',
			special_definition_id : '#IIf(IsDefined("attributes.special_definition_id"),"attributes.special_definition_id",DE(""))#',
			acc_type_id : '#IIf(IsDefined("attributes.acc_type_id"),"attributes.acc_type_id",DE(""))#',
			project_id : '#IIf(IsDefined("attributes.project_id"),"attributes.project_id",DE(""))#',
			project_head : '#IIf(IsDefined("attributes.project_head"),"attributes.project_head",DE(""))#',
            is_paper_closer : attributes.is_paper_closer,
			module_power_user_ehesap : '#get_module_power_user(48)#',
			module_power_user_hr : '#get_module_power_user(3)#',
			fuseaction_ : '#attributes.fuseaction#',
			dsn : '#dsn#',
			dsn_alias : '#dsn_alias#',
			dsn2_alias : '#dsn2_alias#',
			dsn3_alias : '#dsn3_alias#',
			oby : '#IIf(IsDefined("attributes.oby"),"attributes.oby",DE(""))#',
			list_company : '#IIf(IsDefined("list_company"),"list_company",DE(""))#',
			list_consumer : '#IIf(IsDefined("list_consumer"),"list_consumer",DE(""))#',
			list_acc_type_id : '#IIf(IsDefined("list_acc_type_id"),"list_acc_type_id",DE(""))#',
			startrow : '#IIf(IsDefined("attributes.startrow"),"attributes.startrow",DE(""))#',
			maxrows : '#IIf(IsDefined("attributes.maxrows"),"attributes.maxrows",DE(""))#',
			pos_code : '#IIf(IsDefined("attributes.pos_code"),"#attributes.pos_code#",DE(""))#',
			pos_code_text : '#IIf(IsDefined("attributes.pos_code_text"),"attributes.pos_code_text",DE(""))#',
			is_excel : attributes.is_excel,
			x_branch_info : x_branch_info,
			x_project_info : x_project_info,
            x_control_ims : x_control_ims,
            subscription_id :  '#IIf(IsDefined("attributes.subscription_id"),"attributes.subscription_id",DE(""))#',
            subscription_no : '#IIf(IsDefined("attributes.subscription_no"),"attributes.subscription_no",DE(""))#',
            acc_type : '#IIf(IsDefined("attributes.acc_type"),"attributes.acc_type",DE(""))#'
		);
	</cfscript>
	<cfset arama_yapilmali = 0>
<cfelse>
	<cfset get_caris.recordcount = 0>
	<cfset arama_yapilmali = 1>
</cfif>
<cfquery name="get_branchs" datasource="#dsn#">
	SELECT 
		BRANCH_ID,
		BRANCH_NAME 
	FROM 
		BRANCH 
	WHERE
		COMPANY_ID = #session.ep.company_id#
		<cfif session.ep.isBranchAuthorization>
			AND	BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
		</cfif>
	ORDER BY 
		BRANCH_ID
</cfquery>
<cfif get_caris.recordcount>
	<cfif not (isdefined("attributes.is_excel") and attributes.is_excel eq 1)>
    	<cfparam name="attributes.totalrecords" default="#get_caris.query_count#">
    <cfelse>
    	<cfparam name="attributes.totalrecords" default="0">
    </cfif>
<cfelse>	
	<cfparam name="attributes.totalrecords" default="0">
</cfif>
<cfinclude template="../query/get_money_rate.cfm">
<cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
	SELECT DISTINCT	
		COMPANYCAT_ID,
		COMPANYCAT
	FROM
		GET_MY_COMPANYCAT
	WHERE
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> 
	ORDER BY
		COMPANYCAT
</cfquery>
<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
	SELECT DISTINCT	
		CONSCAT_ID,
		CONSCAT,
		HIERARCHY
	FROM
		GET_MY_CONSUMERCAT
	WHERE
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	ORDER BY
		HIERARCHY		
</cfquery>
<cfquery name="get_all_ch_type" datasource="#dsn#">
    SELECT ACC_TYPE_ID,ACC_TYPE_NAME FROM SETUP_ACC_TYPE ORDER BY ACC_TYPE_ID
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box> 
        <cfform name="list_caris" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_caris">
            <input name="form_varmi" id="form_varmi" value="1" type="hidden">
            <cf_box_search>
                <div class="form-group">
                    <cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang('main',48)#">
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
                    <select name="branch_id" id="branch_id">
                        <option value=""><cf_get_lang dictionary_id='57453.Şube'></option>
                        <cfoutput query="get_branchs">
                            <option value="#BRANCH_ID#"<cfif isdefined('attributes.branch_id') and attributes.branch_id eq BRANCH_ID>selected</cfif>>#BRANCH_NAME#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group">
                    <cfoutput><cf_wrk_chprocesstypes fieldid='action_type_ch' is_cats_and_type="1" select_process_cat="1" selected_value='#attributes.action_type_ch#' width="163"></cfoutput>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Baslangic Tarihi Girmelisiniz'></cfsavecontent>
                        <cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
                            <cfinput type="text" name="start_date" placeholder="#getLang("","",58053)#" value="#dateformat(attributes.start_date, dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
                        <cfelse>
                            <cfinput type="text" name="start_date" placeholder="#getLang("","",58053)#" value="#dateformat(attributes.start_date, dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
                        </cfif>
                        <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
                        <cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
                            <cfinput type="text" name="finish_date" placeholder="#getLang("","",57700)#" value="#dateformat(attributes.finish_date, dateformat_style)#"  validate="#validate_style#" maxlength="10" message="#message#">
                        <cfelse>
                            <cfinput type="text" name="finish_date" placeholder="#getLang("","",57700)#" value="#dateformat(attributes.finish_date, dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
                        </cfif>
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                    </div>
                </div>
                <div class="form-group">
                    <label>
                        <input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'>
                    </label>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button search_function='input_control()' button_type="4">
                </div>
            </cf_box_search>
            <cf_box_search_detail>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <cfif x_select_cost_info>
                        <div class="form-group" id="item-expense_center_id">
                            <label class="col col-12"><cf_get_lang dictionary_id='58235.Masraf\Gelir Merkezi'></label>
                            <div class="col col-12">
                                <cf_wrkexpensecenter width_info="110" img_info="plus_thin" fieldid="expense_center_id" fieldname="expense_center_name" form_name="list_caris" expense_center_id="#attributes.expense_center_id#">
                            </div>
                        </div>
                    </cfif>
                    <div class="form-group" id="item-expense_item_id">
                        <label class="col col-12"><cf_get_lang dictionary_id='58234.Bütçe Kalemi'></label>
                        <div class="col col-12">
                            <cf_wrkexpenseitem width_info="110" img_info="plus_thin" fieldid="expense_item_id" fieldname="expense_item_name" form_name="list_caris" expense_item_id="#attributes.expense_item_id#">
                        </div>
                    </div>
                    <cfif session.ep.our_company_info.asset_followup eq 1>
                        <div class="form-group" id="item-asset_id">
                            <label class="col col-12"><cf_get_lang dictionary_id='58833.Fiziki Varlık'></label>
                            <div class="col col-12">
                                <cfif len(attributes.asset_name)>
                                    <cf_wrkassetp fieldid='asset_id' width="110" fieldname='asset_name' asset_id="#attributes.asset_id#" form_name='list_caris' button_type='plus_thin'>
                                    <cfelse>
                                    <cf_wrkassetp fieldid='asset_id' width="110" fieldname='asset_name' form_name='list_caris' button_type='plus_thin'>
                                </cfif>
                            </div>
                        </div>
                    </cfif>
                    <div class="form-group" id="item-acc_type">
                        <label class="col col-12"><cfoutput>#getLang("bank",20,'hesap tipi')#</cfoutput></label>
                        <div class="col col-12">
                            <select name = "acc_type" id = "acc_type">
                                <option value = ""><cfoutput>#getLang("bank",20,'hesap tipi')#</cfoutput></option>
                                <cfoutput query = "getAccount">
                                    <option value = "#account_type_id#" <cfif isdefined("attributes.acc_type") and attributes.acc_type eq account_type_id>selected</cfif>>#ACCOUNT_TYPE#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-record_name">
                        <label class="col col-12"><cf_get_lang dictionary_id='57899.Kaydeden'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="record_emp" id="record_emp" value="<cfif isdefined("attributes.record_emp")><cfoutput>#attributes.record_emp#</cfoutput></cfif>">
                                <input type="text" name="record_name" id="record_name" value="<cfif isdefined("attributes.record_name") and len(attributes.record_name)><cfoutput>#attributes.record_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('record_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','record_emp','','3','125');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=list_caris.record_emp&field_name=list_caris.record_name&select_list=1,9&branch_related')"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-company_id">
                        <label class="col col-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id") and len(attributes.company_id)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
                                <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
                                <input name="company_name" type="text" id="company_name" onfocus="AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\'','COMPANY_ID,CONSUMER_ID','company_id,consumer_id','','3','225');" value="<cfif ((isDefined("attributes.company_name") and len(attributes.company_id)) or (isdefined("attributes.consumer_id") and len(attributes.consumer_id)) and len(attributes.company_name))><cfoutput>#attributes.company_name#</cfoutput></cfif>" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_name=list_caris.company_name&field_comp_name=list_caris.company_name&field_consumer=list_caris.consumer_id&field_comp_id=list_caris.company_id&select_list=2,3<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>');"></span>				
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-special_definition_id">
                        <label class="col col-12"><cf_get_lang dictionary_id='58929.Tahsilat Tipi'></label>
                        <div class="col col-12">
                            <cf_wrk_special_definition width_info="183" list_filter_info="1" field_id="special_definition_id" selected_value='#attributes.special_definition_id#'>
                        </div>
                    </div>
                    <cfif session.ep.our_company_info.is_paper_closer>
                        <div class="form-group" id="item-is_paper_closer">
                            <label class="col col-12"><cf_get_lang dictionary_id='58787.Belge Kapama'></label>
                            <div class="col col-12">
                                <select name="is_paper_closer" id="is_paper_closer">
                                    <option value="-1" <cfif attributes.is_paper_closer eq -1>selected="selected"</cfif>><cf_get_lang dictionary_id="54513.kapanmışlar"></option>
                                    <option value="0" <cfif attributes.is_paper_closer eq 0>selected="selected"</cfif>><cf_get_lang dictionary_id="54449.kapanmamışlar"></option>
                                    <option value="1" <cfif attributes.is_paper_closer eq 1>selected="selected"</cfif>><cf_get_lang dictionary_id="58081.hepsi"></option>  
                                </select>
                            </div>
                        </div>
                    </cfif>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-project_id">
                        <label class="col col-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="project_id" id="project_id" value="<cfoutput>#attributes.project_id#</cfoutput>">
                                <input type="text" name="project_head" id="project_head" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','list_works','3','250');" value="<cfoutput>#attributes.project_head#</cfoutput>" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=list_caris.project_head&project_id=list_caris.project_id</cfoutput>');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-employee_id">
                        <label class="col col-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined("attributes.employee_id") and len(attributes.employee_id)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
                                <input type="text" name="employee_name" id="employee_name" value="<cfif isDefined("attributes.employee_name") and len(attributes.employee_id) and len(attributes.employee_name)><cfoutput>#attributes.employee_name#</cfoutput></cfif>"  onfocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'3\',\'<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\',\'0\',\'0\'','EMPLOYEE_ID','employee_id','','3','225');">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=list_caris.employee_id&field_name=list_caris.employee_name&select_list=1,9&keyword='+encodeURIComponent(document.list_caris.employee_name.value));return false"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-pos_code">
                        <label class="col col-12"><cf_get_lang dictionary_id='57908.temsilci'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="pos_code" id="pos_code" value="<cfif len(attributes.pos_code)><cfoutput>#attributes.pos_code#</cfoutput></cfif>">
                                <input type="text" name="pos_code_text" id="pos_code_text" value="<cfif len(attributes.pos_code)><cfoutput>#get_emp_info(attributes.pos_code,1,0,0)#</cfoutput></cfif>" onfocus="AutoComplete_Create('pos_code_text','FULLNAME','FULLNAME','get_emp_pos','','POSITION_CODE','pos_code','','3','130');" autocomplete="off">	
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=list_caris.pos_code&field_name=list_caris.pos_code_text<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1');return false"></span>					
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                    <div class="form-group" id="item-member_cat_type">
                        <div class="col col-12">
                            <label class="col col-12"><cf_get_lang dictionary_id='59290.Kurumsal Üye Kategorileri'></label>
                            <select name="member_cat_type" id="member_cat_type">
                                <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                <optgroup label="<cf_get_lang dictionary_id='58039.Kurumsal Üye Kategorileri'>">
                                <cfoutput query="get_company_cat">
                                <option value="1-#COMPANYCAT_ID#" <cfif listfind(attributes.member_cat_type,'1-#COMPANYCAT_ID#',',')>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#COMPANYCAT#</option></cfoutput>
                                <optgroup label="<cf_get_lang dictionary_id='58040.Bireysel Üye Kategorileri'>">
                                <cfoutput query="get_consumer_cat">
                                    <option value="2-#CONSCAT_ID#" <cfif listfind(attributes.member_cat_type,'2-#CONSCAT_ID#',',')>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#CONSCAT#</option>
                                </cfoutput>								
                                <optgroup label="<cf_get_lang dictionary_id='58875.Calisanlar'>">
                                <cfoutput query="get_all_ch_type">
                                    <option value="3-#acc_type_id#" <cfif listfind(attributes.member_cat_type,'3-#acc_type_id#',',')>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#acc_type_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-subscription_no">
                        <label class="col col-12"><cf_get_lang dictionary_id='29502.Sistem No'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfoutput>
                                    <input type="hidden" name="subscription_id" id="subscription_id" value="<cfif isdefined("attributes.subscription_id")>#attributes.subscription_id#</cfif>">
                                    <input type="text" name="subscription_no" id="subscription_no" value="<cfif isdefined("attributes.subscription_no")>#attributes.subscription_no#</cfif>" onfocus="AutoComplete_Create('subscription_no','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','get_subscription','2','SUBSCRIPTION_ID','subscription_id','','3','85');" autocomplete="off" >
                                    <span class="input-group-addon btnPointer icon-ellipsis"  alt="<cf_get_lang dictionary_id='29502.Sistem No'>" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_subscription&field_id=list_caris.subscription_id&field_no=list_caris.subscription_no');"></span>
                                </cfoutput>
                            </div>
                        </div>
                    </div>  
                </div>
            </cf_box_search_detail>	
        </cfform>
    </cf_box>
    <cfsavecontent variable="title"><cf_get_lang dictionary_id="30075.Cari Hareketler"></cfsavecontent>
    <cf_box title="#title#" uidrop="1" hide_table_column="1">
        <cfif isdefined("attributes.company_id") and len(attributes.company_id) and len(attributes.company_name)> 
                <cfinclude template="../../objects/display/company_remainder.cfm">
        </cfif>
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="30"><cf_get_lang dictionary_id='57487.No'></th>
                    <th><cf_get_lang dictionary_id='57880.Belge No'></th>
                    <th><cf_get_lang dictionary_id='57692.İşlem'></th>
                    <cfif x_branch_info>
                        <th><cf_get_lang dictionary_id='57453.Şube'></th>
                    </cfif>
                    <cfif x_project_info>
                        <th><cf_get_lang dictionary_id='57416.Proje'></th>
                    </cfif>
                    <th><cf_get_lang dictionary_id='57652.Hesap'></th>
                    <th><cf_get_lang dictionary_id='57558.Üye No'></th>
                    <th><cf_get_lang dictionary_id='57519.cari hesap'></th>		
                    <th><cf_get_lang dictionary_id='57673.Tutar'></th>
                    <th><cf_get_lang dictionary_id='57489.Para Br'></th>
                    <th><cf_get_lang dictionary_id='58056.Dövizli Tutar'></th>
                    <th><cf_get_lang dictionary_id='57489.Para Br'></th>
                    <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                    <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                    <!-- sil -->
                    <th width="20" class="header_icn_none text-center"><i class="fa fa-bar-chart" alt="<cf_get_lang dictionary_id='57809.Hesap Extresi'>" title="<cf_get_lang dictionary_id='57809.Hesap Extresi'>"></i></th>
                    <cfif isdefined("x_manuel_close") and x_manuel_close eq 1><th width="30" class="header_icn_none text-center"><i class="fa fa-compress" title="<cf_get_lang dictionary_id='58500.Manuel'> <cf_get_lang dictionary_id='42871.Fatura kapama'>" alt="<cf_get_lang dictionary_id='58500.Manuel'> <cf_get_lang dictionary_id='42871.Fatura kapama'>"></i></th></cfif>
                    <!-- sil -->
                </tr>
            </thead>
            <!--- <cfset money_list = ''>
            <cfset action_value=0> --->
            <cfif isdefined("attributes.form_varmi") and get_caris.recordcount>
                <cfif not (isdefined("attributes.is_excel") and attributes.is_excel eq 1)>
                    <tbody>
                        <cfoutput query="get_caris" >
                            <cfset type="">
                            <cfswitch expression = "#get_caris.ACTION_TYPE_ID#">
                                <cfcase value=20><cfset type="bank.popup_dsp_bank_account_open"></cfcase><!---banka hesap açılışı --->
                                <cfcase value=24><cfset type="#listgetat(attributes.fuseaction,1,'.')#.popup_dsp_gelenh"></cfcase><!--- gelen havale --->
                                <cfcase value=25><cfset type="#listgetat(attributes.fuseaction,1,'.')#.popup_dsp_gidenh"></cfcase><!--- giden havale --->
                                <cfcase value=34><cfset type="#listgetat(attributes.fuseaction,1,'.')#.popup_dsp_alisf_kapa"></cfcase><!---alış f. kapama--->
                                <cfcase value=35><cfset type="#listgetat(attributes.fuseaction,1,'.')#.popup_dsp_satisf_kapa"></cfcase><!---satış f. kapama--->
                                <!--- kullanilmiyor? ---><cfcase value=37><cfset type="cash.popup_upd_gider_pusula&view_1"></cfcase><!---gider pusulası--->
                                <cfcase value=31><cfset type="#listgetat(attributes.fuseaction,1,'.')#.popup_dsp_cash_revenue"></cfcase><!---tahsilat--->
                                <cfcase value=32><cfset type="#listgetat(attributes.fuseaction,1,'.')#.popup_dsp_cash_payment"></cfcase><!---ödeme--->
                                <cfcase value="90"><cfset type="#listgetat(attributes.fuseaction,1,'.')#.popup_dsp_payroll_entry"></cfcase><!--- cek giris bordrosu --->
                                <cfcase value="106"><cfset type="#listgetat(attributes.fuseaction,1,'.')#.popup_dsp_payroll_entry"></cfcase><!--- cek acilis devir --->
                                <cfcase value="91"><cfset type="#listgetat(attributes.fuseaction,1,'.')#.popup_dsp_payroll_endorsement"></cfcase><!--- cek cikis bordrosu-ciro --->
                                <cfcase value="92"><cfset type="ch.popup_dsp_payroll_bank_revenue"></cfcase><!--- cikis bordrosu-tahsil --->
                                <cfcase value="93"><cfset type="ch.popup_upd_payroll_bank_guaranty"></cfcase><!--- cikis bordrosu-banka --->
                                <cfcase value="94"><cfset type="ch.popup_dsp_payroll_endor_return"></cfcase><!--- cek iade cikis bordrosu --->
                                <cfcase value="95"><cfset type="ch.popup_dsp_payroll_entry_return"></cfcase><!--- cek iade giris bordrosu --->	
                                <cfcase value="104"><cfset type="ch.popup_check_preview"></cfcase><!--- cek odeme/tahsil --->
                                <cfcase value="105"><cfset type="ch.popup_voucher_preview"></cfcase><!--- senet odeme/tahsil --->
                                <cfcase value="40"><cfset type="ch.form_upd_account_open&event=upd"></cfcase><!--- acilis fisi ekle/liste --->
                                <cfcase value="41,42,45,46"><cfset type="ch.form_add_debit_claim_note&event=upd"></cfcase><!--- borc/alacak dekontu --->
                                <cfcase value="43"><cfif len(multi_action_id)><cfset type="#listgetat(attributes.fuseaction,1,'.')#.form_add_cari_to_cari&event=updMulti"><cfelse><cfset type="ch.form_add_cari_to_cari&event=upd"></cfif></cfcase><!--- cari virman - toplu cari virman--->	
                                <cfcase value="48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,561,601,690,691,591,531,592"><cfset type="objects.popup_detail_invoice"></cfcase><!--- faturalar --->
                                <cfcase value="97,98,99,100,101,108"><cfset type="#listgetat(attributes.fuseaction,1,'.')#.popup_dsp_voucher_payroll_action"></cfcase><!--- senet giris,cikis,giris iade,cikis iade,cikis banka tahsil,cikis banka teminat --->
                                <cfcase value="120">
                                    <cfset type="cost.popup_list_cost_expense">
                                </cfcase><!--- masraf fisi --->
                                <cfcase value="131"><cfset type="objects.popup_dsp_collacted_dekont"></cfcase><!--- ucret dekontu --->
                                <cfcase value="160,161"><cfset type="objects.popup_detail_budget_plan"></cfcase><!--- gelir/gider detay --->
                                <cfcase value="121"><cfset type="cost.popup_list_cost_expense&is_income=1"></cfcase><!--- gelir fisi --->
                                <cfcase value="241,245,2410"><cfset type="#listgetat(attributes.fuseaction,1,'.')#.popup_dsp_credit_card_payment_type"></cfcase><!--- kredi kartı tahsilat --->
                                <cfcase value="242"><cfset type="#listgetat(attributes.fuseaction,1,'.')#.popup_dsp_credit_card_payment"></cfcase><!--- kredi karti tahsilat --->
                                <cfcase value="260,251"><cfset type="bank.popup_dsp_assign_order"></cfcase><!--- giden/gelen banka talimati --->
                                <cfcase value="291,292"><cfset type="credit.popup_dsp_credit_payment"></cfcase><!--- Kredi Odeme, Kredi Tahsilat --->
                                <cfcase value="293,294"><cfset type="credit.popup_dsp_stockbond_purchase"></cfcase><!--- Menkul Kıymet Alımı, Menkul Kıymet Satışı --->
                            </cfswitch>
                            
                            <!--- <cfset action_value = action_value + ACTION_VALUE> --->
                            <cfif len(OTHER_CASH_ACT_VALUE)><cfset bakiye_ = OTHER_CASH_ACT_VALUE><cfelse><cfset bakiye_ = 0></cfif>
                            <cfset money = get_caris.OTHER_MONEY>
                            <!--- <cfif bakiye_ gt 0>
                                <cfset money_list = listappend(money_list,'#bakiye_#*#money#',',')>
                            <cfelse>
                                <cfset money_list = listappend(money_list,'#bakiye_#*#money#',',')>
                            </cfif>	 --->
                            <tr>
                                <td width="30">#get_caris.currentrow+((attributes.page-1)*attributes.maxrows)#</td>
                                <td>#paper_no#</td>
                                <td>
                                    <cfif listfind('20,24,25,31,32,34,35,131,160,161,241,242,245,250,260,251,2410',get_caris.action_type_id,',')>
                                        <cfset page_type = 'small'>
                                    <cfelseif listfind('26,27,33,36,37,104,105,43,291,292,40',get_caris.action_type_id,',')>
                                        <cfset page_type = 'medium'>
                                    <cfelseif listfind('90,97,98,101,108,99,100,410,420,310,320',get_caris.action_type_id,',')>
                                        <cfset page_type = 'page'>
                                    <cfelseif listfind('48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,561,601,690,691,591,531,592,120,121,293,294',get_caris.action_type_id,',')>
                                        <cfset page_type = 'page_display'>
                                    <cfelse>
                                        <cfset page_type = 'list'>
                                    </cfif>
                                    <cfif listfind('90,91,92,93,97,98,99,100,106,107',get_caris.action_type_id) and (not get_module_user(21))>
                                    #get_caris.action_name#
                                    <cfelseif listfind('41,42,45,46',get_caris.action_type_id,',')>
                                        <cfif len(multi_action_id)>
                                            <a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_debit_claim_note&event=updMulti&multi_id=#MULTI_ACTION_ID#" class="tableyazi">#get_caris.action_name#</a>
                                        <cfelse>
                                            <a href="#request.self#?fuseaction=#type#&ID=#get_caris.action_id#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>" class="tableyazi">#get_caris.action_name#</a>
                                        </cfif>
                                    <cfelseif listfind("50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,120",get_caris.action_type_id)>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#type#&ID=#get_caris.action_id#&period_id=#session.ep.period_id#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','#page_type#');">#get_caris.action_name#</a>
                                    <cfelseif get_caris.action_type_id eq 40>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#type#&cari_act_id=#get_caris.cari_action_id#&comp_id=#comp_id#&cons_id=#cons_id#&emp_id=#emp_id#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','#page_type#');"><cfif len(get_caris.action_name)>#get_caris.action_name#<cfelse><cf_get_lang dictionary_id ="58756.Açılış Fişi"></cfif></a>		
                                    <cfelseif get_caris.action_type_id eq 260>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#type#&ID=#get_caris.action_id#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','#page_type#');">#get_caris.action_name#</a><cfif IS_PROCESSED eq 1>(<cf_get_lang dictionary_id='49981.Havale Oluşturulmuş'>)</cfif>
                                    <cfelseif listfind("291,292",get_caris.action_type_id)><!--- Kredi Odemesi ,Kredi Tahsilat --->
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#type#&id=#get_caris.action_id#&period_id=#session.ep.period_id#&our_company_id=#session.ep.company_id#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','#page_type#');">#get_caris.action_name#</a>
                                    <cfelseif listfind("293,294",get_caris.action_type_id)><!--- Menkul Kıymet Alış, Menkul Kıymet Satış --->
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#type#&id=#get_caris.action_id#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','#page_type#');">#get_caris.action_name#</a>
                                    <cfelseif len(multi_action_id) and get_caris.action_type_id eq 43><!--- Toplu Cari Virman --->
                                        <a href="#request.self#?fuseaction=#type#&upd_id=#MULTI_ACTION_ID#" class="tableyazi">#get_caris.action_name#</a>
                                    <cfelseif get_caris.action_type_id eq 43>
                                        <a href="#request.self#?fuseaction=#type#&id=#ACTION_ID#" class="tableyazi">#get_caris.action_name#</a>
                                    <cfelseif not len(type)><!--- display sayfası olmayan tipler için --->
                                        #get_caris.action_name#
                                    <cfelseif get_caris.ACTION_TABLE is 'CHEQUE'> 
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_cheque_det&ID=#get_caris.action_id#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','small')">#get_caris.action_name#</a>
                                    <cfelseif get_caris.ACTION_TABLE is 'VOUCHER'> 
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_voucher_det&ID=#get_caris.action_id#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','small')">#get_caris.action_name#</a>
                                    <cfelseif ACTION_TABLE is 'BUDGET_PLAN'> 
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_budget_plan&ID=#CARI_ACTION_ID#','small')">#get_caris.action_name#</a>
                                    <cfelseif ACTION_TABLE is 'EMPLOYEES_PUANTAJ' and ACTION_TYPE_ID eq 161> 
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_puantaj_act&type=1&ID=#CARI_ACTION_ID#','medium')">#get_caris.action_name#</a>
                                    <cfelse>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#type#&ID=#get_caris.action_id#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','#page_type#');">#get_caris.action_name#</a>
                                    </cfif>
                                </td>
                                <!---Şube ve Proje Sütunları --->
                                <cfif x_branch_info>
                                    <td>#get_caris.BRANCH#</td>
                                </cfif>
                                <cfif x_project_info>
                                    <td>#get_caris.PROJECT#</td>
                                </cfif>
                                <td>
                                    <cfif len(get_caris.FROM_ACCOUNT_ID)>
                                        #ACCOUNT_NAME#
                                    </cfif>
                                    <cfif len(get_caris.TO_ACCOUNT_ID)>
                                        #ACCOUNT_NAME#
                                    </cfif>
                                    <cfif len(get_caris.TO_CASH_ID)>
                                        #CASH_NAME# 
                                    </cfif>
                                    <cfif len(get_caris.FROM_CASH_ID)>
                                        #CASH_NAME# 
                                    </cfif>
                                </td>
                                <td>
                                    <cfif len(get_caris.to_cmp_id) and get_caris.to_cmp_id neq 0>
                                        #MEMBER_CODE#
                                    <cfelseif len(get_caris.from_cmp_id) and get_caris.from_cmp_id neq 0>
                                        #MEMBER_CODE#
                                    <cfelseif len(get_caris.TO_CONSUMER_ID)  and get_caris.TO_CONSUMER_ID neq 0>
                                        #CONSUMER_MEMBER_CODE#
                                    <cfelseif len(get_caris.FROM_CONSUMER_ID)  and get_caris.FROM_CONSUMER_ID neq 0>
                                        #CONSUMER_MEMBER_CODE#
                                    <cfelseif len(FROM_EMPLOYEE_ID)  and get_caris.FROM_EMPLOYEE_ID neq 0>
                                        #EMPLOYEE_MEMBER_CODE#
                                    <cfelseif len(TO_EMPLOYEE_ID)  and get_caris.TO_EMPLOYEE_ID neq 0>	
                                        #EMPLOYEE_MEMBER_CODE#
                                    </cfif>
                                </td>
                                <td>
                                    <cfif len(get_caris.to_cmp_id) and get_caris.to_cmp_id neq 0>
                                        <cfset member_id = get_caris.TO_CMP_ID>
                                        <cfset member_type = 'partner'>
                                        <a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_caris.TO_CMP_ID#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>');">#NICKNAME#</a>
                                    <cfelseif len(get_caris.from_cmp_id) and get_caris.from_cmp_id neq 0>
                                        <cfset member_id = get_caris.FROM_CMP_ID>
                                        <cfset member_type = 'partner'>
                                        <a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_caris.FROM_CMP_ID#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>');">#NICKNAME#</a>
                                    <cfelseif len(get_caris.TO_CONSUMER_ID)  and get_caris.TO_CONSUMER_ID neq 0>
                                        <cfset member_id = get_caris.TO_CONSUMER_ID>
                                        <cfset member_type = 'consumer'>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_caris.TO_CONSUMER_ID#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','medium');">#FULLNAME#</a>
                                    <cfelseif len(get_caris.FROM_CONSUMER_ID)  and get_caris.FROM_CONSUMER_ID neq 0>
                                        <cfset member_id = get_caris.FROM_CONSUMER_ID>
                                        <cfset member_type = 'consumer'>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_caris.FROM_CONSUMER_ID#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','medium');">#FULLNAME#</a>
                                    <cfelseif len(FROM_EMPLOYEE_ID)  and get_caris.FROM_EMPLOYEE_ID neq 0>
                                        <cfset member_id = get_caris.FROM_EMPLOYEE_ID>
                                        <cfset member_type = 'employee'>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_caris.FROM_EMPLOYEE_ID#','medium');">#EMPLOYEE_FULLNAME#</a>
                                    <cfelseif len(TO_EMPLOYEE_ID)  and get_caris.TO_EMPLOYEE_ID neq 0>	
                                        <cfset member_id = get_caris.TO_EMPLOYEE_ID>
                                        <cfset member_type = 'employee'>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_caris.TO_EMPLOYEE_ID#','medium');">#EMPLOYEE_FULLNAME#</a>
                                    </cfif>
                                    <cfif len(acc_type_id) and acc_type_id neq 0>
                                        <cfif member_type eq 'employee'>
                                            - #acc_type_name#
                                        <cfelse>
                                            - #ACCOUNT_TYPE#
                                        </cfif>
                                    </cfif>
                                </td>
                                <td class="moneybox text-right">#TLFormat(get_caris.action_value)#</td>
                                <td class="moneybox">&nbsp;#get_caris.action_currency_id#</td>
                                <td class="moneybox text-right">#TLFormat(get_caris.other_cash_act_value)#</td>
                                <td class="moneybox">&nbsp;#get_caris.other_money#</td>
                                <td><span title="#ACTION_DETAIL#">#left(ACTION_DETAIL,60)#</span></td>
                                <td>#dateformat(get_caris.action_date,dateformat_style)#</td>
                                <!-- sil -->
                                <td width="30" class="text-center">
                                    <cfif (get_caris.ACTION_TYPE_ID eq 41) or (get_caris.ACTION_TYPE_ID eq 42)><a href="javascript://" onclick="javascript:windowopen('#request.self#?fuseaction=objects.popup_print_files&print_type=212&action_id=#get_caris.action_id#','print_page');"><i class="fa fa-print" alt="<cf_get_lang dictionary_id='57474.Yazdır'>" title="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></a></cfif>
                                    <cfif (len(get_caris.TO_CMP_ID) and (get_caris.TO_CMP_ID neq 0)) or (len(get_caris.FROM_CMP_ID) and (get_caris.FROM_CMP_ID neq 0))>
                                        <a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=partner&member_id=#member_id#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>')"><i class="fa fa-bar-chart" alt="<cf_get_lang dictionary_id='57809.Hesap Extresi'>" title="<cf_get_lang dictionary_id='57809.Hesap Extresi'>"></i></a>
                                    <cfelseif (len(get_caris.TO_CONSUMER_ID) and (get_caris.TO_CONSUMER_ID neq 0))or (len(get_caris.FROM_CONSUMER_ID) and (get_caris.FROM_CONSUMER_ID neq 0))>
                                        <a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_comp_extre&member_id=#member_id#&member_type=consumer<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>')"><i class="fa fa-bar-chart" alt="<cf_get_lang dictionary_id='57809.Hesap Extresi'>" title="<cf_get_lang dictionary_id='57809.Hesap Extresi'>"></i></a>
                                    </cfif>
                                </td>
                                <cfif isdefined("x_manuel_close") and x_manuel_close eq 1>
                                    <td>
                                        <cfif len(get_caris.to_cmp_id) and get_caris.to_cmp_id neq 0>
                                            <a href = "#request.self#?fuseaction=finance.list_payment_actions&event=add&member_id=#get_caris.to_cmp_id#&row_action_id=#get_caris.action_id#&row_action_type=#action_type_id#" target = "_blank" title="<cf_get_lang dictionary_id='58500.Manuel'> <cf_get_lang dictionary_id='42871.Fatura kapama'>"> <i class="fa fa-compress"></i></a>                                    
                                        <cfelseif len(get_caris.from_cmp_id) and get_caris.from_cmp_id neq 0>
                                            <a href = "#request.self#?fuseaction=finance.list_payment_actions&event=add&member_id=#get_caris.from_cmp_id#&row_action_id=#get_caris.action_id#&row_action_type=#action_type_id#" target = "_blank" title="<cf_get_lang dictionary_id='58500.Manuel'> <cf_get_lang dictionary_id='42871.Fatura kapama'>"> <i class="fa fa-compress"></i></a>      
                                        <cfelseif len(get_caris.TO_CONSUMER_ID)  and get_caris.TO_CONSUMER_ID neq 0>
                                        <a href = "#request.self#?fuseaction=finance.list_payment_actions&event=add&consumer_id=#get_caris.TO_CONSUMER_ID#&row_action_id=#get_caris.action_id#&row_action_type=#action_type_id#" target = "_blank" title="<cf_get_lang dictionary_id='58500.Manuel'> <cf_get_lang dictionary_id='42871.Fatura kapama'>"> <i class="fa fa-compress"></i></a>      
                                        <cfelseif len(get_caris.FROM_CONSUMER_ID)  and get_caris.FROM_CONSUMER_ID neq 0>
                                            <a href = "#request.self#?fuseaction=finance.list_payment_actions&event=add&consumer_id=#get_caris.FROM_CONSUMER_ID#&row_action_id=#get_caris.action_id#&row_action_type=#action_type_id#" target = "_blank" title="<cf_get_lang dictionary_id='58500.Manuel'> <cf_get_lang dictionary_id='42871.Fatura kapama'>"> <i class="fa fa-compress"></i></a>      
                                        <cfelseif len(FROM_EMPLOYEE_ID)  and get_caris.FROM_EMPLOYEE_ID neq 0>
                                        <a href = "#request.self#?fuseaction=finance.list_payment_actions&event=add&employee_id_new=#get_caris.FROM_EMPLOYEE_ID#&row_action_id=#get_caris.action_id#&row_action_type=#action_type_id#" target = "_blank" title="<cf_get_lang dictionary_id='58500.Manuel'> <cf_get_lang dictionary_id='42871.Fatura kapama'>"> <i class="fa fa-compress"></i></a>      
                                        <cfelseif len(TO_EMPLOYEE_ID)  and get_caris.TO_EMPLOYEE_ID neq 0>	
                                        <a href = "#request.self#?fuseaction=finance.list_payment_actions&event=add&employee_id_new=#get_caris.TO_EMPLOYEE_ID#&row_action_id=#get_caris.action_id#&row_action_type=#action_type_id#" target = "_blank" title="<cf_get_lang dictionary_id='58500.Manuel'> <cf_get_lang dictionary_id='42871.Fatura kapama'>"> <i class="fa fa-compress"></i></a>      
                                        </cfif>
                                    </td>
                                </cfif>
                                <!-- sil -->
                            </tr>
                        </cfoutput>
                    </tbody>
                    <!--- <tfoot>
                        <tr>
                            <td colspan="10"><cf_get_lang dictionary_id='57492.Toplam'> : <cfoutput>#TLFormat(action_value)# #session.ep.money# </cfoutput></td>
                            <td class="txtbold">
                                <cfoutput query="get_money_rate">
                                    <cfset toplam_ara = 0>
                                    <cfloop list="#money_list#" index="i">
                                        <cfset tutar_ = listfirst(i,'*')>
                                        <cfset money_ = listlast(i,'*')>
                                        <cfif money_ eq money>
                                            <cfset toplam_ara = toplam_ara + tutar_>
                                        </cfif>
                                    </cfloop>
                                    <cfif toplam_ara neq 0>
                                        #TLFormat(ABS(toplam_ara))# #money# 
                                    </cfif>
                                </cfoutput>
                            </td>
                            <td colspan="5"></td>
                        </tr>
                    </tfoot> --->
                </cfif>
            <cfelse>
                    <tbody>
                        <tr>
                            <cfset colspan_info = 13>
                            <cfif x_branch_info>
                                <cfset colspan_info = colspan_info + 1>
                            </cfif>
                            <cfif x_project_info>
                                <cfset colspan_info = colspan_info + 1>
                            </cfif>
                            <cfif isdefined("x_manuel_close") and x_manuel_close eq 1>
                                <cfset colspan_info = colspan_info + 1>
                            </cfif>
                            <td colspan="<cfoutput>#colspan_info#</cfoutput>"><cfif arama_yapilmali eq 1><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !<cfelse><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</cfif></td>
                        </tr>
                    </tbody>
            </cfif>
        </cf_grid_list>
        <cfif attributes.totalrecords gt attributes.maxrows>
                <cfif isDefined('attributes.action_type_ch') and len(attributes.action_type_ch)>
                    <cfset adres = '#adres#&action_type_ch=#attributes.action_type_ch#'>
                </cfif>
                <cfif isDefined('attributes.employee_id') and len(attributes.employee_id)>
                    <cfset adres = '#adres#&employee_id=#attributes.employee_id#'>
                </cfif>
                <cfif isDefined('attributes.employee_name') and len(attributes.employee_name)>
                    <cfset adres = '#adres#&employee_name=#attributes.employee_name#'>
                </cfif>
                <cfif isDefined('attributes.company_id') and len(attributes.company_id)>
                    <cfset adres = '#adres#&company_id=#attributes.company_id#'>
                </cfif>
                <cfif isDefined('attributes.company_name') and len(attributes.company_name)>
                    <cfset adres = '#adres#&company_name=#attributes.company_name#'>
                </cfif>
                <cfif isDefined('attributes.consumer_id') and len(attributes.consumer_id)>
                    <cfset adres = '#adres#&consumer_id=#attributes.consumer_id#'>
                </cfif>
                <cfif isdate(attributes.start_date)>
                    <cfset adres = "#adres#&start_date=#dateformat(attributes.start_date,dateformat_style)#" >
                </cfif>
                <cfif isdate(attributes.finish_date)>
                    <cfset adres = "#adres#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#" >
                </cfif>
                <cfif isDefined('attributes.keyword')>
                    <cfset adres = '#adres#&keyword=#attributes.keyword#'>
                </cfif>
                <cfif isdefined("attributes.form_varmi")>
                    <cfset adres = "#adres#&form_varmi=#attributes.form_varmi#" >
                </cfif>
                <cfif isDefined('attributes.oby') and len(attributes.oby)>
                    <cfset adres = '#adres#&oby=#attributes.oby#'>
                </cfif>
                <cfif isDefined("attributes.record_emp") and len(attributes.record_emp)>
                    <cfset adres = adres&"&record_emp="&attributes.record_emp>
                </cfif>
                <cfif isDefined("attributes.record_name") and len(attributes.record_name)>
                    <cfset adres = adres&"&record_name="&attributes.record_name>
                </cfif>
                <cfif isDefined("attributes.asset_id") and len(attributes.asset_id)>
                    <cfset adres = adres&"&asset_id="&attributes.asset_id>
                </cfif>
                <cfif isDefined("attributes.asset_name") and len(attributes.asset_name)>
                    <cfset adres = adres&"&asset_name="&attributes.asset_name>
                </cfif>
                <cfif isDefined("attributes.expense_center_id") and len(attributes.expense_center_id)>
                    <cfset adres = adres&"&expense_center_id="&attributes.expense_center_id>
                </cfif>
                <cfif isDefined("attributes.expense_center_name") and len(attributes.expense_center_name)>
                    <cfset adres = adres&"&expense_center_name="&attributes.expense_center_name>
                </cfif>
                <cfif isDefined("attributes.expense_item_id") and len(attributes.expense_item_id)>
                    <cfset adres = adres&"&expense_item_id="&attributes.expense_item_id>
                </cfif>
                <cfif isDefined("attributes.expense_item_name") and len(attributes.expense_item_name)>
                    <cfset adres = adres&"&expense_item_name="&attributes.expense_item_name>
                </cfif>
                <cfif isDefined('attributes.special_definition_id') and len(attributes.special_definition_id)>
                    <cfset adres = '#adres#&special_definition_id=#attributes.special_definition_id#'>
                </cfif>
                <cfif len(attributes.project_id)>
                    <cfset adres = "#adres#&project_id=#attributes.project_id#">
                </cfif>
                <cfif len(attributes.project_head)>
                    <cfset adres = "#adres#&project_head=#attributes.project_head#">
                </cfif>
                <cfset adres = adres&'&member_cat_type=#attributes.member_cat_type#'>
                <cfif isDefined('attributes.pos_code') and len(attributes.pos_code)>
                    <cfset adres = '#adres#&pos_code=#attributes.pos_code#'>
                </cfif>
                <cfif isDefined('attributes.pos_code_text') and len(attributes.pos_code_text)>
                    <cfset adres = '#adres#&pos_code_text=#attributes.pos_code_text#'>
                </cfif>
                <cfif isDefined('attributes.branch_id') and len(attributes.branch_id)>
                    <cfset adres = '#adres#&branch_id=#attributes.branch_id#'>
                </cfif>
                <cfif isDefined('attributes.is_paper_closer') and len(attributes.is_paper_closer)>
                    <cfset adres = '#adres#&is_paper_closer=#attributes.is_paper_closer#'>
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

<script type="text/javascript">
	document.getElementById('keyword').focus();
	function input_control()
	{
		<cfif not session.ep.our_company_info.UNCONDITIONAL_LIST>
			if (list_caris.start_date.value.length == 0 && list_caris.finish_date.value.length == 0 &&list_caris.keyword.value.length == 0 && list_caris.action_type[list_caris.action_type.selectedIndex].value.length == 0 
				&& (list_caris.company_id.value.length == 0 || list_caris.company_name.value.length == 0) 
				&& (list_caris.consumer_id.value.length == 0 || list_caris.company_name.value.length == 0)  
				&& (list_caris.employee_id.value.length == 0 || list_caris.employee_name.value.length == 0))
				{
					alert("<cf_get_lang dictionary_id='58950.En az bir alanda filtre etmelisiniz'> !");
					return false;
				}
			else return true;
		<cfelse>
			return true;
		</cfif>
	}	
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
<cfsetting showdebugoutput="yes"> 