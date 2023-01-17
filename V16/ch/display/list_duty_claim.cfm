<cf_xml_page_edit fuseact="ch.list_duty_claim">
<cf_get_lang_set module_name="ch">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfparam name="attributes.startdate2" default="">
<cfparam name="attributes.finishdate2" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.member_cat_type" default="">
<cfparam name="attributes.member_cat_value" default="">
<cfparam name="attributes.money_info" default="">
<cfparam name="attributes.due_info" default="1">
<cfparam name="attributes.order_type" default="1">
<cfparam name="attributes.city" default="">
<cfparam name="attributes.country" default="">
<cfparam name="attributes.sales_zones" default="">
<cfparam name="attributes.duty_claim" default="">
<cfparam name="attributes.resource" default="">
<cfparam name="attributes.customer_value" default="">
<cfparam name="attributes.buy_status" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.vade_dev" default="">
<cfparam name="attributes.comp_status" default="">
<cfparam name="attributes.ims_code_id" default=""> 
<cfparam name="attributes.vade_borc_ara_toplam" default="0">
<cfparam name="attributes.vade_alacak_ara_toplam" default="0">
<cfparam name="attributes.money_type_info" default="">
<cfparam name="attributes.asset_id" default="">
<cfparam name="attributes.asset_name" default="">
<cfparam name="attributes.special_definition_type" default="">
<cfparam name="attributes.expense_center_id" default="">
<cfparam name="attributes.expense_center_name" default="">
<cfparam name="attributes.expense_item_id" default="">
<cfparam name="attributes.expense_item_name" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.subscription_id" default="">
<cfif session.ep.isBranchAuthorization>
    <cfset is_store_module=1>
<cfelse>
    <cfset is_store_module=''>
</cfif>
<cfif not isdefined("is_revenue_duedate")>
	<cfset is_revenue_duedate = 0>
</cfif>
<cfscript>
	cmp_branch = createObject("component","V16.hr.cfc.get_branches");
	cmp_branch.dsn = dsn;
	get_branchs = cmp_branch.get_branch();
</cfscript>
<cfquery name="get_company_cat" datasource="#dsn#">
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
<cfquery name="get_consumer_cat" datasource="#dsn#">
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
<cfquery name="get_customer_value" datasource="#dsn#">
	SELECT CUSTOMER_VALUE_ID,CUSTOMER_VALUE FROM SETUP_CUSTOMER_VALUE ORDER BY CUSTOMER_VALUE
</cfquery>
<cfquery name="get_country" datasource="#dsn#">
	SELECT COUNTRY_ID,COUNTRY_NAME FROM SETUP_COUNTRY ORDER BY COUNTRY_NAME
</cfquery>
<cfquery name="get_sales_zones" datasource="#dsn#">
	SELECT SZ_ID, SZ_NAME FROM SALES_ZONES ORDER BY SZ_NAME
</cfquery>
<cfquery name="get_resource" datasource="#dsn#">
	SELECT RESOURCE_ID, RESOURCE FROM COMPANY_PARTNER_RESOURCE ORDER BY RESOURCE
</cfquery>
<cfquery name="get_all_ch_type" datasource="#dsn#">
    SELECT 
        ACC_TYPE_ID,ACC_TYPE_NAME
    FROM 
		SETUP_ACC_TYPE SAT
    WHERE
        ACC_TYPE_ID IN(SELECT ACC_TYPE_ID FROM SETUP_ACC_TYPE_POSID SP INNER JOIN EMPLOYEE_POSITIONS EP ON SP.POSITION_ID = EP.POSITION_ID) AND <!--- yetkili pozisyon seçili olan hesap tipleri--->
        ACC_TYPE_ID IN(SELECT ACC_TYPE_ID FROM SETUP_ACC_TYPE_POSID SP INNER JOIN EMPLOYEE_POSITIONS EP ON SP.POSITION_ID = EP.POSITION_ID WHERE POSITION_CODE = #session.ep.position_code#)<!--- çalışanın yetkili olarak ekli olduğu hesap tipleri--->	
</cfquery>
<!---Tahsilat / Ödeme tipi alanının multiple olması için eklemiştir.--->
<cfquery name="GET_SPECIAL_DEFINITION" datasource="#DSN#">
	SELECT SPECIAL_DEFINITION_ID,SPECIAL_DEFINITION,SPECIAL_DEFINITION_TYPE FROM SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE IN (1,2)
</cfquery>
<cfif isdefined("attributes.is_submitted")>
	<cfif isdefined("attributes.is_project_group") or isdefined("attributes.is_asset_group")>
		<cfset attributes.money_info = ''>
	</cfif>
	<cfinclude template="../query/get_member.cfm">
<cfelse>
	<cfset get_member.recordcount = 0> 
</cfif>	
<cfscript>
	alacak = 0;
	borc = 0;
	alacak_2 = 0;
	borc_2 = 0;
	top_alacak_dev = 0;
	top_borc_dev = 0;
	top_alacak_dev_2 = 0;
	top_borc_dev_2 = 0;
	top_bakiye_dev = 0;
	sayfa_toplam_alacak = 0;
	sayfa_toplam_borc = 0;
	top_bakiye_dev_2 = 0;
	top_bakiye_dev_3 = 0;
	sayfa_toplam_alacak_2 = 0;
	sayfa_toplam_borc_2 = 0;
	sayfa_toplam_alacak_3 = 0;
	sayfa_toplam_borc_3 = 0;
	top_ceksenet = 0;
	top_ceksenet_ch = 0;
	top_ceksenet_other = 0;
	top_ceksenet2 = 0;
	top_ceksenet_ch2 = 0;
	top_ceksenet_other2 = 0;
	sayfa_toplam_ceksenet_ch = 0;
	sayfa_toplam_ceksenet_other = 0;
	sayfa_toplam_ceksenet_ch2 = 0;
	sayfa_toplam_ceksenet_other2 = 0;
	sayfa_toplam_ceksenet_ch3 = 0;
	sayfa_toplam_ceksenet_other3 = 0;
</cfscript>
<cfquery name="get_money" datasource="#dsn2#">
	SELECT MONEY FROM SETUP_MONEY
</cfquery>
<cfoutput query="get_money">
	<cfset 'toplam_borc_#money#' = 0>
	<cfset 'toplam_alacak_#money#' = 0>
	<cfset 'toplam_ceksenet_#money#' = 0>
	<cfset 'toplam_ceksenet_ch_#money#' = 0>
	<cfset 'toplam_ceksenet_other_#money#' = 0>
</cfoutput>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default = "#session.ep.maxrows#">
<cfparam name="attributes.totalrecords" default = "#get_member.recordcount#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
<cfsavecontent variable="header_">
	<cfif isDefined("attributes.from_rev_collecter")>
		<cf_get_lang dictionary_id='54535.Tahsilat Takip'>
	<cfelse>
		<cf_get_lang dictionary_id='30076.Borç Alacak Dökümü '><cfoutput>: <cfif isdefined('attributes.startdate2') and len(attributes.startdate2) or isdefined('attributes.finishdate2') and len(attributes.finishdate2) > #dateFormat(attributes.startdate2,dateformat_style)#-#dateFormat(attributes.finishdate2,dateformat_style)#<cfelse>#dateformat(now(),dateformat_style)# </cfif></cfoutput>
	</cfif>
</cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="form_list" method="post" <!----action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_duty_claim"---->>
            <input type="hidden" name="member_cat_value" id="member_cat_value" value="">
            <cf_box_search>
                <cfif isDefined("attributes.from_rev_collecter")>
                    <input type="hidden" name="from_rev_collecter" id="from_rev_collecter" value="1">
                </cfif>
                <input type="hidden" name="is_submitted" id="is_submitted" value="1">
                <div class="form-group">
                    <input type="text" name="keyword" id="keyword" placeholder="<cf_get_lang dictionary_id='57460.Filtre'>" maxlength="50" value="<cfif isdefined("attributes.keyword")><cfoutput>#attributes.keyword#</cfoutput></cfif>" />
                </div>
                <div class="form-group">
                    <input type="text" name="ozel_kod" id="ozel_kod" placeholder="<cf_get_lang dictionary_id='57789.Özel Kod'>" value="<cfif isdefined('attributes.ozel_kod') and len(attributes.ozel_kod)><cfoutput>#attributes.ozel_kod#</cfoutput></cfif>">
                </div>
                <div class="form-group">
                    <select name="comp_status" id="comp_status">
                        <option value=""><cf_get_lang dictionary_id='57756.Durum'></option>
                        <option value="1" <cfif isDefined('attributes.comp_status') and attributes.comp_status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                        <option value="0" <cfif isDefined('attributes.comp_status') and attributes.comp_status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                    </select>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
                        <cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3">
                    <cfelse>
                        <cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,250" message="#message#" maxlength="3">
                    </cfif>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button search_function='kontrol()' button_type="4">
                </div>
            </cf_box_search>
            <cf_box_search_detail search_function="kontrol()">
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-money_info">
                        <label class="col col-12"><cf_get_lang dictionary_id='50174.Döviz Seçiniz'></label>
                        <div class="col col-12">
                            <select name="money_info" id="money_info" onchange="kontrol_project(0);show_money_type();kontrol_asset(0);">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'>
                                <option value="1" <cfif isDefined("attributes.money_info") and attributes.money_info eq 1>selected<cfelseif  xml_is_money_info eq 1>selected</cfif>>2.<cf_get_lang dictionary_id='57677.Döviz'>
                                <option value="2" <cfif isDefined("attributes.money_info") and attributes.money_info eq 2>selected</cfif>><cf_get_lang dictionary_id='58121.Islem Dövizi'></option>
                            </select>                        
                        </div>
                    </div>
                    <cfif isdefined("attributes.money_type_info") and len(attributes.money_type_info)>
                        <cfset style = "">
                    <cfelse>
                        <cfset style = "display:none">
                    </cfif>
                    <div class="form-group" id="item-money_type" style="<cfoutput>#style#</cfoutput>">
                        <label class="col col-12"><cf_get_lang dictionary_id='57489.Para Birimi'></label>
                        <div class="col col-12">
                            <select name="money_type_info" id="money_type_info">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_money">
                                    <option value="#MONEY#" <cfif get_money.money eq attributes.money_type_info>selected</cfif>>#MONEY#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-expense_center_id">
                        <cfif not (isdefined("attributes.expense_center_id") and len(attributes.expense_center_id) and len(attributes.expense_center_name))>
                            <cfset attributes.expense_center_id=''>
                        </cfif>
                        <label class="col col-12"><cf_get_lang dictionary_id='58235.Masraf\Gelir Merkezi'></label>
                        <div class="col col-12">
                            <cf_wrkExpenseCenter width_info="110" img_info="plus_thin" fieldId="expense_center_id" fieldName="expense_center_name" form_name="form_list" expense_center_id="#attributes.expense_center_id#">
                        </div>
                    </div>
                    <div class="form-group" id="item-expense_item_id">
                        <cfif not(isdefined("attributes.expense_item_id") and len(attributes.expense_item_id) and len(attributes.expense_item_name))>
                            <cfset attributes.expense_item_id=''>
                        </cfif>
                        <label class="col col-12"><cf_get_lang dictionary_id='58234.Bütçe Kalemi'></label>
                        <div class="col col-12">
                            <cf_wrkExpenseItem width_info="110" img_info="plus_thin" fieldId="expense_item_id" fieldName="expense_item_name" form_name="form_list" expense_item_id="#attributes.expense_item_id#">
                        </div>
                    </div>
                    <div class="form-group" id="item-">
                        <label class="col col-12"><cf_get_lang dictionary_id='58134.Mikro Bölge Kodu'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>
                                    <cfquery name="GET_IMS" datasource="#dsn#">
                                        SELECT IMS_CODE,IMS_CODE_NAME FROM SETUP_IMS_CODE WHERE IMS_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ims_code_id#">
                                    </cfquery>
                                    <input type="hidden" name="ims_code_id" id="ims_code_id" value="<cfoutput>#attributes.ims_code_id#</cfoutput>">
                                    <cfinput type="text" name="ims_code_name" value="#get_ims.ims_code# #get_ims.ims_code_name#">
                                <cfelse>
                                    <input type="hidden" name="ims_code_id" id="ims_code_id">
                                    <cfinput type="text" name="ims_code_name" value="">
                                </cfif>
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ims_code&field_name=form_list.ims_code_name&field_id=form_list.ims_code_id','list');"></span>
                            </div>
                        </div>
                    </div>
                    <cfif session.ep.our_company_info.asset_followup eq 1>
                        <div class="form-group" id="item-asset_id">
                            <label class="col col-12"><cf_get_lang dictionary_id='58833.Fiziki Varlik'></label>
                            <div class="col col-12">
                                <cf_wrkAssetp fieldId='asset_id' asset_id="#attributes.asset_id#" fieldName='asset_name' form_name='form_list' button_type='plus_thin'>
                            </div> 
                        </div>
                    </cfif>
                    <div class="form-group" id="item-asset_id">
                        <label class="col col-12"><cf_get_lang dictionary_id='58832.Abone'><cf_get_lang dictionary_id='57487.No'></label>
                        <div class="col col-12">
                            <cfif len(attributes.subscription_id) and len(attributes.subscription_no)>
                                <cf_wrk_subscriptions width_info='140' subscription_id='#attributes.subscription_id#'  fieldid='subscription_id' fieldname='subscription_no' form_name='list_ekstre' img_info='plus_thin'>
                            <cfelse>
                                <cf_wrk_subscriptions width_info='140' fieldid='subscription_id' fieldname='subscription_no' form_name='list_ekstre' img_info='plus_thin'>
                            </cfif>
                        </div> 
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-branch_id">
                        <label class="col col-12"><cf_get_lang dictionary_id='57453.Sube'></label>
                        <div class="col col-12">
                            <select name="branch_id" id="branch_id">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_branchs">
                                    <option value="#BRANCH_ID#"<cfif isdefined('attributes.branch_id') and attributes.branch_id eq BRANCH_ID>selected</cfif>>#BRANCH_NAME#</option>
                                </cfoutput>
                            </select> 
                        </div>
                    </div>
                    <div class="form-group" id="item-company">
                        <label class="col col-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
                        <div class="col col-12">
                            <input type="hidden" name="company_id" id="company_id" <cfif len(attributes.company_id)>value="<cfoutput>#attributes.company_id#</cfoutput>"</cfif>>
                            <input type="hidden" name="consumer_id" id="consumer_id" <cfif len(attributes.consumer_id)>value="<cfoutput>#attributes.consumer_id#</cfoutput>"</cfif>>
                            <input type="hidden" name="employee_id" id="employee_id" <cfif len(attributes.employee_id)>value="<cfoutput>#attributes.employee_id#</cfoutput>"</cfif>>
                            <input type="hidden" name="member_type" id="member_type" <cfif len(attributes.member_type)>value="<cfoutput>#attributes.member_type#</cfoutput>"</cfif>>
                            <div class="input-group">
                                <input type="text" name="member_name" id="member_name" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\',\'0\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','company_id,consumer_id,employee_id,member_type','','3','225');" <cfif len(attributes.member_name)>value="<cfoutput>#attributes.member_name#</cfoutput>"</cfif> autocomplete="off">
                                <cfset str_linke_ait="field_consumer=form_list.consumer_id&field_comp_id=form_list.company_id&field_comp_name=form_list.member_name&field_name=form_list.member_name&field_emp_id=form_list.employee_id&field_type=form_list.member_type">
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_cari_action=1&<cfoutput>#str_linke_ait#</cfoutput><cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2,3,1,9','list','popup_list_pars');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-pos_code">
                        <label class="col col-12"><cf_get_lang dictionary_id='57908.Temsilci'></label>
                        <div class="col col-12">
                            <input type="hidden" name="pos_code" id="pos_code" value="<cfif isdefined('attributes.pos_code_text') and len(attributes.pos_code)><cfoutput>#attributes.pos_code#</cfoutput></cfif>">
                            <cf_wrk_employee_positions form_name='form_list' pos_code='pos_code' emp_name='pos_code_text'>
                            <div class="input-group">
                                <input type="text" name="pos_code_text" id="pos_code_text" value="<cfif isdefined('attributes.pos_code_text') and len(attributes.pos_code_text)><cfoutput>#attributes.pos_code_text#</cfoutput></cfif>" onKeyUp="get_emp_pos_1();">
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=form_list.pos_code&field_name=form_list.pos_code_text<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1','list');return false"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-project">
                        <label class="col col-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                        <div class="col col-12">
                            <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id')><cfoutput>#attributes.project_id#</cfoutput></cfif>">
                            <div class="input-group">
                                <input type="text" name="project_head" id="project_head" value="<cfif isdefined('attributes.project_id') and len(attributes.project_id) and isdefined('attributes.project_head') and  len(attributes.project_head)><cfoutput>#attributes.project_head#</cfoutput></cfif>">
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=form_list.project_id&project_head=form_list.project_head&is_empty_project&allproject=1');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-due_info">
                        <label class="col col-12"><cf_get_lang dictionary_id='57640.Vade'></label>
                        <div class="col col-12">
                            <select name="due_info" id="due_info">
                                <option value="1" <cfif isDefined("attributes.due_info") and attributes.due_info eq 1>selected</cfif>><cf_get_lang dictionary_id='50033.Adat'></option>
                                <!--- xml e göre alttaki ortalama vade kapatiliyor --->
                                <cfif is_avg_duedate><option value="2" <cfif isDefined("attributes.due_info") and attributes.due_info eq 2>selected</cfif>><cf_get_lang dictionary_id='57861.Ortalama Vade'></option></cfif>
                            </select>
                            <cfif not is_avg_duedate><cfset attributes.due_info = 1></cfif><!--- xmlden kaldirildgnda adat a dönebilisn diye.. --->
                        </div>
                    </div>
                    <div class="form-group" id="item-member_cat_type">
                        <label class="col col-12"><cf_get_lang dictionary_id='59290.Üye Kategorileri'></label>
                        <div class="col col-12">
                            <select name="member_cat_type" id="member_cat_type" multiple>
                                <option value="1_0" <cfif listfind(attributes.member_cat_type,'1_0',',')>selected</cfif>><cf_get_lang dictionary_id='58039.Kurumsal Üye Kategorileri'></option>
                                <cfoutput query="get_company_cat">
                                <option value="1_#COMPANYCAT_ID#" <cfif listfind(attributes.member_cat_type,'1_#COMPANYCAT_ID#',',')>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#COMPANYCAT#</option></cfoutput>
                                <option value="2_0" <cfif listfind(attributes.member_cat_type,'2_0',',')>selected</cfif>><cf_get_lang dictionary_id='58040.Bireysel Üye Kategorileri'></option>
                                <cfoutput query="get_consumer_cat">
                                    <option value="2_#CONSCAT_ID#" <cfif listfind(attributes.member_cat_type,'2_#CONSCAT_ID#',',')>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#CONSCAT#</option>
                                </cfoutput>
                                <option value="3_0" <cfif listfind(attributes.member_cat_type,'3_0',',')>selected</cfif>><cf_get_lang dictionary_id='50118.Bagli Kurumsal Üyeler'></option>
                                <option value="4_0" <cfif listfind(attributes.member_cat_type,'4_0',',')>selected</cfif>><cf_get_lang dictionary_id='50117.Bagli Bireysel Üyeler'></option>					
                                <option value="5_0" <cfif listfind(attributes.member_cat_type,'5_0',',')>selected</cfif>><cf_get_lang dictionary_id='58875.Çalisanlar'></option>
                                <cfoutput query="get_all_ch_type">
                                    <option value="5_#acc_type_id#" <cfif listfind(attributes.member_cat_type,'5_#acc_type_id#',',')>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#acc_type_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-icra_takibi">
                        <label class="col col-12"><cf_get_lang dictionary_id='49978.İcra Takibi'></label>
                        <div class="col col-12">
                            <select name="icra_takibi" id="icra_takibi">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <option value="1" <cfif isDefined("attributes.icra_takibi") and attributes.icra_takibi eq 1>selected</cfif>><cf_get_lang dictionary_id='50042.Yapılanlar'></option>
                                <option value="2" <cfif isDefined("attributes.icra_takibi") and attributes.icra_takibi eq 2>selected</cfif>><cf_get_lang dictionary_id='50104.Yapılmayanlar'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-order_type">
                        <label class="col col-12"><cf_get_lang dictionary_id='58924.Sıralama'></label>
                        <div class="col col-12">
                            <select name="order_type" id="order_type">
                                <option value="1" <cfif isDefined('attributes.order_type') and attributes.order_type eq 1>selected</cfif>><cf_get_lang dictionary_id='35295.Alfabetik'></option>
                                <option value="2" <cfif isDefined('attributes.order_type') and attributes.order_type eq 2>selected</cfif>><cf_get_lang dictionary_id='50123.Artan Bakiye'></option>
                                <option value="3" <cfif isDefined('attributes.order_type') and attributes.order_type eq 3>selected</cfif>><cf_get_lang dictionary_id='50122.Azalan Bakiye'></option>
                                <option value="4" <cfif isDefined('attributes.order_type') and attributes.order_type eq 4>selected</cfif>><cf_get_lang dictionary_id='57486.Kategori'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-country">
                        <label class="col col-12"><cf_get_lang dictionary_id='58219.Ülke'></label>
                        <div class="col col-12">
                            <select name="country" id="country" onChange="LoadCity(this.value,'city','city');">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_country">
                                    <option value="#country_id#" <cfif attributes.country eq country_id>selected</cfif>>#country_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-city">
                        <label class="col col-12"><cf_get_lang dictionary_id='57971.Sehir'></label>
                        <div class="col col-12">
                            <select name="city" id="city">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfquery name="GET_CITY" datasource="#DSN#">
                                    SELECT CITY_ID,CITY_NAME FROM SETUP_CITY <cfif len(attributes.country)>WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country#"></cfif>
                                </cfquery>
                                <cfoutput query="get_city">
                                    <option value="#city_id#" <cfif attributes.city eq city_id>selected</cfif>>#city_name#</option>
                                </cfoutput>
                            </select>                        	
                        </div>
                    </div>
                    <div class="form-group" id="item-sales_zones">
                        <label class="col col-12"><cf_get_lang dictionary_id='57659.Satis Bölgesi'></label>
                        <div class="col col-12">
                            <select name="sales_zones" id="sales_zones">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_sales_zones">
                                    <option value="#sz_id#" <cfif sz_id eq attributes.sales_zones> selected</cfif>>#sz_name#</option>
                                </cfoutput>
                            </select>							                      	
                        </div>
                    </div>
                    <div class="form-group" id="item-special_definition">
                        <label class="col col-12"><cf_get_lang dictionary_id='59291.Tahsilat / Ödeme Tipi'></label>
                        <div class="col col-12">
                            <select name="special_definition_type" id="special_definition_type" multiple>
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <optgroup label="<cf_get_lang dictionary_id='58929.Tahsilat Tipi'>"></optgroup>
                                <cfoutput query="GET_SPECIAL_DEFINITION">
                                    <cfif special_definition_type eq 1>
                                        <option value="#SPECIAL_DEFINITION_ID#" <cfif listfind(attributes.special_definition_type,'#SPECIAL_DEFINITION_ID#',',')>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#SPECIAL_DEFINITION#</option>
                                    </cfif>
                                </cfoutput>
                                <optgroup label="<cf_get_lang dictionary_id='58928.Ödeme Tipi'>"></optgroup>
                                <cfoutput query="GET_SPECIAL_DEFINITION">
                                    <cfif special_definition_type eq 2>
                                        <option value="#SPECIAL_DEFINITION_ID#" <cfif listfind(attributes.special_definition_type,'#SPECIAL_DEFINITION_ID#',',')>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#SPECIAL_DEFINITION#</option>
                                    </cfif>
                                </cfoutput>
                            </select>	
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                    <div class="form-group" id="item-startdate2">
                        <label class="col col-12"><cf_get_lang dictionary_id='57879.Islem Tarihi'></label>
                        <div class="col col-6">
                            <div class="input-group">
                                <cfsavecontent variable="alert"><cf_get_lang dictionary_id='50060.Baslangiç Tarihini Dogru Giriniz'></cfsavecontent>
                                <cfinput type="text" name="startdate2" value="#dateformat(attributes.startdate2,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#alert#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="startdate2"></span>
                            </div>
                        </div>
                        <div class="col col-6">
                            <div class="input-group">
                                <cfsavecontent variable="alert"><cf_get_lang dictionary_id='50059.Bitis Tarihini Dogru Giriniz'></cfsavecontent>
                                <cfinput type="text" name="finishdate2" value="#dateformat(attributes.finishdate2,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#alert#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate2"></span>
                            </div>                        	
                        </div>
                    </div>
                    <div class="form-group" id="item-startdate">
                        <label class="col col-12"><cf_get_lang dictionary_id='57881.Vade Tarihi'></label>
                        <div class="col col-6">
                            <div class="input-group">
                                <cfsavecontent variable="alert"><cf_get_lang dictionary_id='50060.Baslangiç Tarihini Dogru Giriniz'></cfsavecontent>
                                <cfinput type="text" name="startdate" value="#dateformat(attributes.startdate,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#alert#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                            </div>
                        </div>
                        <div class="col col-6">
                            <div class="input-group">
                                <cfsavecontent variable="alert"><cf_get_lang dictionary_id='50059.Bitis Tarihini Dogru Giriniz'></cfsavecontent>
                                <cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#alert#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                            </div>                        	
                        </div>
                    </div>
                    <div class="form-group" id="item-resource">
                        <label class="col col-12"><cf_get_lang dictionary_id='35363.Iliski Tipi'></label>
                        <div class="col col-12">
                            <select name="resource" id="resource">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_resource">
                                    <option value="#resource_id#" <cfif resource_id eq attributes.resource>selected</cfif>>#resource#</option>
                                </cfoutput>
                            </select>                       
                        </div>
                    </div>
                    <div class="form-group" id="item-customer_value">
                        <label class="col col-12"><cf_get_lang dictionary_id='58552.Müsteri Degeri'></label>
                        <div class="col col-12">
                            <select name="customer_value"  id="customer_value">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_customer_value">
                                    <option value="#customer_value_id#" <cfif isdefined('attributes.customer_value') and customer_value_id eq attributes.customer_value> selected</cfif>>#customer_value#</option>
                                </cfoutput>
                            </select>                        
                        </div>
                    </div>
                    <div class="form-group" id="item-buy_status">
                        <label class="col col-12"><cf_get_lang dictionary_id='50173.Alici / Satici'></label>
                        <div class="col col-12">
                            <select name="buy_status" id="buy_status">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <option value="1" <cfif isDefined('attributes.buy_status') and attributes.buy_status eq 1>selected</cfif>><cf_get_lang dictionary_id='58733.Alici'></option>
                                <option value="2" <cfif isDefined('attributes.buy_status') and attributes.buy_status eq 2>selected</cfif>><cf_get_lang dictionary_id='58873.Satici'></option>
                                <option value="3" <cfif isDefined('attributes.buy_status') and attributes.buy_status eq 3>selected</cfif>><cf_get_lang dictionary_id='57577.Potansiyel'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-duty_claim">
                        <label class="col col-12"><cf_get_lang dictionary_id='57867.Borç/Alacak'></label>
                        <div class="col col-12">
                            <select name="duty_claim" id="duty_claim">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <option value="1" <cfif isDefined("attributes.duty_claim") and attributes.duty_claim eq 1>selected</cfif>><cf_get_lang dictionary_id='58180.Borçlu'><cf_get_lang dictionary_id='57417.Üyeler'></option>
                                <option value="2" <cfif isDefined("attributes.duty_claim") and attributes.duty_claim eq 2>selected</cfif>><cf_get_lang dictionary_id='47372.Alacakli'><cf_get_lang dictionary_id='57417.Üyeler'></option>
                            </select>							                      	
                        </div>
                    </div>
                </div>
                <cf_box_elements>
                    <div class="col col-3 col-xs-12">
                        <div class="form-group" id="item-odenmemis_talimatlari_getirme">
                            <label class="col col-12">
                                <input type="checkbox" name="is_pay_bankorders" id="is_pay_bankorders" <cfif isdefined('attributes.is_pay_bankorders')>checked</cfif>>
                                <cf_get_lang dictionary_id='58819.Ödenmemis Talimatlari Getirme'> 
                            </label>
                        </div>
                        <div class="form-group" id="item-carilestirme_tipine_gore_grupla">
                            <label class="col col-12">
                                <input type="checkbox" name="is_acc_type_group" id="is_acc_type_group" value="" <cfif isdefined("attributes.is_acc_type_group")>checked</cfif> onClick="kontrol_acc_type()">
                                <cf_get_lang dictionary_id = "30399.Carileştirme Tipine Göre Grupla">
                            </label>
                        </div>                   
                    </div>
                    <div class="col col-3 col-xs-12">
                        <div class="form-group" id="item-bakiye_getirme">
                            <label class="col col-12">
                                <input type="checkbox" name="is_zero_bakiye" id="is_zero_bakiye" value="" <cfif isdefined("attributes.is_zero_bakiye")>checked</cfif>>
                                <cf_get_lang dictionary_id='50146.Sifir Bakiye Getirme'>
                            </label>
                        </div>
                        <div class="form-group" id="item-proje_bazinda_grupla">
                            <label class="col col-12">
                                <input type="checkbox" name="is_project_group" id="is_project_group" value="" <cfif isdefined("attributes.is_project_group")>checked</cfif> onClick="kontrol_project(1)">
                                <cf_get_lang dictionary_id='58931.Proje Bazinda Grupla'>
                            </label>
                        </div>
                    </div>
                    <div class="col col-3 col-xs-12">
                        <div class="form-group" id="item-aboneye_gore_grupla">
                            <label class="col col-12">
                                <input type="checkbox" name="is_subscription_group" id="is_subscription_group" value="" <cfif isdefined("attributes.is_subscription_group")>checked</cfif> onClick="kontrol_subscription(1)">
                                <cf_get_lang dictionary_id = "30401.Aboneye Göre Grupla">
                            </label>
                        </div>
                        <cfif not isDefined("attributes.from_rev_collecter")>
                            <div class="form-group" id="item-odenmemis_cek_senetleri_getirme">
                                <label class="col col-12">
                                    <input type="checkbox" name="is_pay_cheques" id="is_pay_cheques" value="" <cfif isdefined("attributes.is_pay_cheques")>checked</cfif>>
                                    <cf_get_lang dictionary_id='57913.Ödenmemis Çek/Senetleri Getirme'>
                                </label>
                            </div>
                            </cfif>  
                    </div>
                    <div class="col col-3 col-xs-12">
                        <cfif session.ep.our_company_info.asset_followup eq 1>
                            <div class="form-group" id="item-fiziki_varlik_bazinda_grupla">
                                <label class="col col-12">
                                    <input type="checkbox" name="is_asset_group" id="is_asset_group" value="" <cfif isdefined("attributes.is_asset_group")>checked</cfif> onClick="kontrol_asset(1)">
                                    <cf_get_lang dictionary_id='49983.Fiziki Varlik Bazinda Grupla'>
                                </label>
                            </div>
                        </cfif>
                        <cfif session.ep.our_company_info.is_paper_closer eq 1>
                            <div class="form-group" id="item-belge_kapamaya_gore">
                                <label class="col col-12">
                                    <input type="checkbox" name="is_closed_invoice" id="is_closed_invoice" value="" <cfif isdefined("attributes.is_closed_invoice")>checked</cfif>>
                                    <cf_get_lang dictionary_id='50137.Manuel Belge Kapamaya Göre'>
                                </label>
                            </div>
                        </cfif>
                    </div>
                </cf_box_elements>
            </cf_box_search_detail>
        </cfform>    
    </cf_box>
    <cf_box title="#header_#" uidrop="1" hide_table_column="1" woc_setting = "#{ checkbox_name : 'print_islem_id', print_type : 212 }#">           
        <cf_grid_list>
            <thead>
                <!--- <tr><th colspan="21"><cf_get_lang dictionary_id='30076.Borç Alacak Dökümü'><cfoutput>: <cfif isdefined('attributes.startdate2') and len(attributes.startdate2) and isdefined('attributes.finishdate2') and len(attributes.finishdate2) > #dateFormat(attributes.startdate2,dateformat_style)#-#dateFormat(attributes.finishdate2,dateformat_style)#<cfelse>#dateformat(now(),dateformat_style)# </cfif></cfoutput></th></tr>--->
                <tr>
                <cfoutput>
                    <cfset colspan_count = 6>
                    <cfif isDefined("attributes.money_info") and attributes.money_info neq 2><th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th></cfif>
                    <th><cf_get_lang dictionary_id='57558.Uye No'></th>	
                    <th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
                    <cfif isdefined("attributes.is_acc_type_group")>
                        <cfset colspan_count++>
                        <th><cf_get_lang dictionary_id="57519.Cari Hesap"><cf_get_lang dictionary_id="216.Tipi"></th>
                    </cfif>
                    <cfif xml_account_code eq 1>
                        <cfset colspan_count++>
                        <th><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></th>
                    </cfif>
                    <th><cf_get_lang dictionary_id='39976.Il Kodu'></th>
                    <cfif xml_show_phone_number eq 1>
                        <cfset colspan_count++>
                        <th><cf_get_lang dictionary_id='57499.Telefon'></th>
                    </cfif>
                    <th><cf_get_lang dictionary_id='58795.Müsteri Temsilcisi'></th>
                    <th><cf_get_lang dictionary_id='57486.Kategori'></th>
                    <cfif isdefined("attributes.is_project_group")>
                        <cfset colspan_count++>
                        <th><cf_get_lang dictionary_id='57416.Proje'></th>
                    </cfif>
                    <cfif isdefined("attributes.is_asset_group")>
                        <cfset colspan_count++>
                        <th><cf_get_lang dictionary_id='58833.Fiziki Varlik'></th>
                    </cfif>
                    <cfif isdefined("attributes.is_subscription_group")>
                        <cfset colspan_count++>
                        <th><cf_get_lang dictionary_id="58832.Abone"></th>
                    </cfif>                   
                    <th class="moneybox">#session.ep.money# <cf_get_lang dictionary_id='57587.Borç'></th>
                    <th class="moneybox">#session.ep.money# <cf_get_lang dictionary_id='57588.Alacak'></th>
                    <th class="moneybox">#session.ep.money# <cf_get_lang dictionary_id='57589.Bakiye'></th>
                    <th class="text-center"><cf_get_lang dictionary_id='29683.B/A'></th>
                    <cfif isDefined("attributes.money_info") and len(session.ep.money2) and attributes.money_info eq 1>
                        <th class="moneybox">#session.ep.money2# <cf_get_lang dictionary_id='57587.Borç'></th>
                        <th class="moneybox">#session.ep.money2# <cf_get_lang dictionary_id='57588.Alacak'></th>
                        <th class="moneybox">#session.ep.money2# <cf_get_lang dictionary_id='57589.Bakiye'></th>
                        <th class="text-center"><cf_get_lang dictionary_id='29683.B/A'></th>
                    </cfif>
                    <cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
                        <cfset colspan_count = colspan_count-1>
                        <th class="moneybox"><cf_get_lang dictionary_id='57587.Borç'></th>
                        <th><cf_get_lang dictionary_id='30636.Para Birimi'></th>
                        <th class="moneybox"><cf_get_lang dictionary_id='57588.Alacak'></th>
                        <th><cf_get_lang dictionary_id='30636.Para Birimi'></th>
                        <th class="moneybox"><cf_get_lang dictionary_id='57589.Bakiye'></th>
                        <th><cf_get_lang dictionary_id='30636.Para Birimi'></th>
                        <th class="text-center"><cf_get_lang dictionary_id='29683.B/A'></th>
                    </cfif>
                    <cfif isdefined("attributes.is_pay_cheques")>
                        <th colspan="<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>3<cfelse>2</cfif>"><cf_get_lang dictionary_id="49976.Ödenmemis Müsteri Çek/Senet"></th>
                        <th colspan="<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>3<cfelse>2</cfif>"><cf_get_lang dictionary_id="50013.Ödenmemis Cari Çek/Senet"></th>
                        <th colspan="<cfif isDefined("attributes.money_info") and attributes.money_info eq 2>3<cfelse>2</cfif>"><cf_get_lang dictionary_id='50115.Toplam Bakiye'></th>
                    </cfif>
                    <cfif isDefined("attributes.due_info") and attributes.due_info eq 1>
                        <th class="moneybox"><cf_get_lang dictionary_id='50033.Adat'></th>
                    <cfelse>
                        <th><cf_get_lang dictionary_id='57861.Ortalama Vade'></th>	
                    </cfif>
                </cfoutput>
                <!-- sil -->
                <th width="20">
                    <cfset comp_list = ''>
                    <cfset cons_list = ''>
                    <cfset emp_list = ''>
                    <cfif get_member.recordcount>
                        <cfloop query="get_member">
                            <cfif kontrol eq 0 >
                                <cfset comp_list = ListAppend(comp_list,member_id,',')>
                            <cfelseif kontrol eq 1>
                                <cfset cons_list = ListAppend(cons_list,member_id,',')>
                            <cfelseif kontrol eq 2>
                                <cfset emp_list = ListAppend(emp_list,member_id,',')>
                            </cfif>
                        </cfloop>
                        <a href="<cfoutput>#request.self#?fuseaction=objects.popup_print_files&print_type=215&action_id=#URLEncodedFormat(page_code)#&company_ids=#comp_list#&consumer_ids=#cons_list#&employee_ids=#emp_list#</cfoutput>" target="_blank"><i class='fa fa-print' alt="<cf_get_lang dictionary_id='36535.Toplu Yazdir'>" title="<cf_get_lang dictionary_id='36535.Toplu Yazdir'>"></i></a>
                    </cfif>
                </th>
                <cfif session.ep.our_company_info.sms>
                    <th><i class="fa fa-tablet"></i></th>
                </cfif>
                <th width="20" class="text-center">
                    <input type="hidden" name="rec_num" id="rec_num" value="<cfoutput>#get_member.recordcount#</cfoutput>">
                    <!---<a href="javascript://" onclick="send_print_(1);"><img src="/images/print_multi.gif" title="<cf_get_lang dictionary_id='58057.Toplu'><cf_get_lang dictionary_id='57474.Yazdir'>"></a></br>--->
                    <input type="checkbox" name="allSelectDemand" id="allSelectDemand" onclick="wrk_select_all('allSelectDemand','print_islem_id');">
                </th>
                <cfif isdefined("attributes.duty_claim") && attributes.duty_claim eq 2>
                    <th width="20">
                        <span class="icon-money"></span>
                    </th>
                </cfif>
                <!-- sil -->		
                </tr>
            </thead>
            <tbody>
                <cfif get_member.recordcount>
                <cfset member_id_ = 0>
                <cfif attributes.page neq 1>
                    <cfset comp_id_list = ''>
                    <cfset cons_id_list = ''>
                    <cfset emp_id_list = ''>
                    <cfoutput query="get_member"  maxrows="#attributes.startrow-1#">
                        <cfif not listfind(comp_id_list,member_id) and kontrol eq 0>
                            <cfset comp_id_list = listappend(comp_id_list,member_id)>
                        </cfif>	
                        <cfif not listfind(cons_id_list,member_id) and kontrol eq 1>
                            <cfset cons_id_list = listappend(cons_id_list,member_id)>
                        </cfif>		
                        <cfif not listfind(emp_id_list,member_id) and kontrol eq 2>
                            <cfset emp_id_list = listappend(emp_id_list,member_id)>
                        </cfif>	
                    </cfoutput>
                    <cfif len(comp_id_list)>
                        <cfset comp_id_list=listsort(comp_id_list,"numeric","ASC",",")>
                        <!---<cfquery name="get_comp_bakiye" datasource="#dsn2#">
                            SELECT COMPANY_ID,ALACAK,BORC,BAKIYE FROM COMPANY_REMAINDER WHERE COMPANY_ID IN(#comp_id_list#) ORDER BY COMPANY_ID
                        </cfquery>--->
                        <cfquery name="get_comp_bakiye" datasource="#dsn2#">
                            SELECT
                                COMPANY_ID, 
                                ROUND(SUM(BORC-ALACAK),5) AS BAKIYE, 
                                SUM(BORC) AS BORC,
                                SUM(ALACAK) AS ALACAK
                            FROM
                                CARI_ROWS_TOPLAM
                            WHERE 
                                COMPANY_ID IN(#comp_id_list#) 
                                <cfif isdefined('attributes.finishdate2') and len(attributes.finishdate2)>
                                    AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate2#">
                                </cfif>	
                                <cfif isdefined('attributes.startdate2') and len(attributes.startdate2)>
                                    AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate2#">
                                </cfif>
                            GROUP BY
                                COMPANY_ID
                            ORDER BY COMPANY_ID       
                        </cfquery>
                        <cfset comp_id_list2 = listsort(listdeleteduplicates(valuelist(get_comp_bakiye.company_id,',')),'numeric','ASC',',')>
                    </cfif> 
                    <cfif len(cons_id_list)>
                        <!--- <cfset cons_id_list=listsort(cons_id_list,"numeric","ASC",",")> --->
                        <cfquery name="get_cons_bakiye" datasource="#dsn2#">
                            SELECT CONSUMER_ID,ALACAK,BORC,BAKIYE FROM CONSUMER_REMAINDER WHERE CONSUMER_ID IN(#cons_id_list#) ORDER BY CONSUMER_ID
                        </cfquery>
                        <cfset cons_id_list2 = listsort(listdeleteduplicates(valuelist(get_cons_bakiye.consumer_id,',')),'numeric','ASC',',')>
                    </cfif> 
                    <cfoutput query="GET_MEMBER" maxrows="#attributes.startrow-1#" >
                        <cfscript>
                            if (isDefined("attributes.money_info") and attributes.money_info eq 2 and x_show_system_money eq 1)
                            {
                                if(len(ALACAK)) top_alacak_dev = top_alacak_dev + ALACAK;
                                if(len(BORC)) top_borc_dev = top_borc_dev + BORC;
                                if(len(BAKIYE)) top_bakiye_dev = top_bakiye_dev + BAKIYE;
                            }
                            else if((isDefined("attributes.money_info") and attributes.money_info eq 2 and (MEMBER_CODE[currentrow] neq MEMBER_CODE[currentrow-1] or currentrow mod attributes.maxrows eq 1)))
                            {
                                if (kontrol eq 0)
                                {
                                    top_alacak_dev = top_alacak_dev + get_comp_bakiye.alacak[listfind(comp_id_list2,member_id,',')];
                                    top_borc_dev = top_borc_dev + get_comp_bakiye.borc[listfind(comp_id_list2,member_id,',')];		
                                    top_bakiye_dev =  top_bakiye_dev + (get_comp_bakiye.alacak[listfind(comp_id_list2,member_id,',')] - get_comp_bakiye.borc[listfind(comp_id_list2,member_id,',')]);
                                }
                                else if(kontrol eq 1) 
                                {
                                    top_alacak_dev = top_alacak_dev + get_cons_bakiye.alacak[listfind(cons_id_list2,member_id,',')];
                                    top_borc_dev = top_borc_dev + get_cons_bakiye.borc[listfind(cons_id_list2,member_id,',')];		
                                    top_bakiye_dev =  top_bakiye_dev + (get_cons_bakiye.alacak[listfind(cons_id_list2,member_id,',')] - get_cons_bakiye.borc[listfind(cons_id_list2,member_id,',')]);
                                }
                                else if(kontrol eq 2) 
                                {
                                    top_alacak_dev = top_alacak_dev + MAIN_ALACAK;
                                    top_borc_dev = top_borc_dev + MAIN_BORC;		
                                    top_bakiye_dev =  top_bakiye_dev + (MAIN_ALACAK - MAIN_BORC);
                                }		
                            }
                            else if (not (isDefined("attributes.money_info") and attributes.money_info eq 2))
                            {
                                if(len(ALACAK)) top_alacak_dev = top_alacak_dev + ALACAK;
                                if(len(BORC)) top_borc_dev = top_borc_dev + BORC;
                                if(len(BAKIYE)) top_bakiye_dev = top_bakiye_dev + BAKIYE;
                            }
                            if (isDefined("attributes.money_info") and len(session.ep.money2) and attributes.money_info eq 1)
                            {
                                if(len(ALACAK2)) top_alacak_dev_2 = top_alacak_dev_2 + ALACAK2;
                                if(len(BORC2)) top_borc_dev_2 = top_borc_dev_2 + BORC2;
                                if(len(BAKIYE2)) top_bakiye_dev_2 = top_bakiye_dev_2 + BAKIYE2;
                            }
                            if(isdefined("attributes.is_pay_cheques"))
                            {
                                if(len(cheque_voucher_value2)) top_ceksenet2 = top_ceksenet2 + cheque_voucher_value2;
                                if(len(cheque_voucher_value_ch2)) top_ceksenet_ch2 = top_ceksenet_ch2 + cheque_voucher_value_ch2;
                                if(len(cheque_voucher_value_other2)) top_ceksenet_other2 = top_ceksenet_other2 + cheque_voucher_value_other2;
                                if(len(cheque_voucher_value)) top_ceksenet = top_ceksenet + cheque_voucher_value;
                                if(len(cheque_voucher_value_ch)) top_ceksenet_ch = top_ceksenet_ch + cheque_voucher_value_ch;
                                if(len(cheque_voucher_value_other)) top_ceksenet_other = top_ceksenet_other + cheque_voucher_value_other;
                                if(isDefined("attributes.money_info") and attributes.money_info eq 2)
                                {
                                    'toplam_ceksenet_#other_money#' = evaluate('toplam_ceksenet_#other_money#') + cheque_voucher_value3;
                                    'toplam_ceksenet_ch_#other_money#' = evaluate('toplam_ceksenet_ch_#other_money#') + cheque_voucher_value_ch3;
                                    'toplam_ceksenet_other_#other_money#' = evaluate('toplam_ceksenet_other_#other_money#') + cheque_voucher_value_other3;
                                }
                            }	
                            if(isDefined("attributes.money_info") and attributes.money_info eq 2)
                            {
                                'toplam_borc_#other_money#' = evaluate('toplam_borc_#other_money#') + BORC3;
                                'toplam_alacak_#other_money#' = evaluate('toplam_alacak_#other_money#') + ALACAK3;
                            }
                        </cfscript>
                    </cfoutput>
                    <cfoutput>
                        <tr >
                            <td colspan="<cfif isDefined("attributes.from_rev_collecter")>#colspan_count#<cfelse>#colspan_count#</cfif>" class="txtboldblue"><cf_get_lang dictionary_id='58034.Devreden'><cfoutput>#colspan_count#</cfoutput></td>
                            <cfif not (isDefined("attributes.money_info") and attributes.money_info eq 2) or (isDefined("attributes.money_info") and attributes.money_info eq 2 and x_show_system_money eq 1)>
                                <td class="moneybox">#TLFormat(abs(top_borc_dev))#</td>
                                <td class="moneybox">#TLFormat(top_alacak_dev)#</td>
                                <td class="moneybox">#TLFormat(abs(top_bakiye_dev))#</td>
                                <td class="text-center"><cfif top_borc_dev gt top_alacak_dev>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif top_borc_dev lt top_alacak_dev>(<cf_get_lang dictionary_id='29684.A'>)<cfelse></cfif></td>
                            </cfif>
                            <cfif isDefined("attributes.money_info") and len(session.ep.money2) and attributes.money_info eq 1>
                                <td class="moneybox">#TLFormat(abs(top_borc_dev_2))#</td>
                                <td class="moneybox">#TLFormat(top_alacak_dev_2)#</td>
                                <td class="moneybox">#TLFormat(abs(top_bakiye_dev_2))#</td>
                                <td class="text-center"><cfif top_borc_dev_2 gt top_alacak_dev_2>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif top_borc_dev_2 lt top_alacak_dev_2>(<cf_get_lang dictionary_id='29684.A'>)<cfelse></cfif></td>
                                <cfif isdefined("attributes.is_pay_cheques")>
                                    <td class="moneybox">
                                        #TLFormat(abs(top_ceksenet_other2))#
                                    </td>
                                    <td class="text-center"><cfif top_ceksenet_other2 gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif></td>
                                    <td class="moneybox">
                                        #TLFormat(abs(top_ceksenet_ch2))#
                                    </td>
                                    <td class="text-center"><cfif top_ceksenet_ch2 gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif></td>
                                    <td class="moneybox">
                                        #TlFormat(abs(top_borc_dev_2-top_alacak_dev_2+top_ceksenet2))# 
                                    </td>
                                    <td class="text-center"><cfif (top_borc_dev_2-top_alacak_dev_2+top_ceksenet2) gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif></td>
                                </cfif>
                            </cfif>
                            <cfif isDefined("attributes.money_info") and not len(attributes.money_info)>
                                <cfif isdefined("attributes.is_pay_cheques")>
                                    <td class="moneybox">#TLFormat(abs(top_ceksenet_other))#</td>
                                    <td class="text-center"><cfif top_ceksenet_other gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif></td>
                                    <td class="moneybox">#TLFormat(abs(top_ceksenet_ch))#</td>
                                    <td class="text-center"><cfif top_ceksenet_ch gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif></td>
                                    <td class="moneybox">#TlFormat(abs(top_borc_dev-top_alacak_dev+top_ceksenet))#</td>
                                    <td class="text-center"><cfif (top_borc_dev-top_alacak_dev+top_ceksenet) gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif></td>
                                </cfif>
                            </cfif>
                            <cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
                                <td class="moneybox">
                                    <cfloop query="get_money">
                                        <cfif evaluate('toplam_borc_#get_money.money#') neq 0>
                                            #Tlformat(evaluate('toplam_borc_#get_money.money#'))#<br/>
                                        </cfif>
                                    </cfloop>
                                </td>
                                <td class="text-center">
                                    <cfloop query="get_money">
                                        <cfif evaluate('toplam_borc_#get_money.money#') neq 0>
                                            #get_money.money#<br/>
                                        </cfif>
                                    </cfloop>
                                </td>
                                <td class="moneybox">
                                    <cfloop query="get_money">
                                        <cfif evaluate('toplam_alacak_#get_money.money#') neq 0>
                                            #Tlformat(evaluate('toplam_alacak_#get_money.money#'))#<br/>
                                        </cfif>
                                    </cfloop>
                                </td>
                                <td class="text-center">
                                    <cfloop query="get_money">
                                        <cfif evaluate('toplam_alacak_#get_money.money#') neq 0>
                                            #get_money.money#<br/>
                                        </cfif>
                                    </cfloop>
                                </td>
                                <td class="moneybox">
                                    <cfloop query="get_money">
                                        <cfset bakiye_ = evaluate('toplam_borc_#get_money.money#') - evaluate('toplam_alacak_#get_money.money#')>
                                        <cfif bakiye_ neq 0>
                                            #Tlformat(abs(bakiye_))#<br/>
                                        </cfif>
                                    </cfloop>
                                </td>
                                <td class="text-center">
                                    <cfloop query="get_money">
                                        <cfset bakiye_ = evaluate('toplam_borc_#get_money.money#') - evaluate('toplam_alacak_#get_money.money#')>
                                        <cfif bakiye_ neq 0>
                                            #get_money.money#<br/>
                                        </cfif>
                                    </cfloop>
                                </td>
                                <td class="text-center">
                                    <cfloop query="get_money">
                                        <cfset bakiye_ = evaluate('toplam_borc_#get_money.money#') - evaluate('toplam_alacak_#get_money.money#')>
                                        <cfif bakiye_ neq 0>
                                            <cfif bakiye_ gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif><br/>
                                        </cfif>
                                    </cfloop>
                                </td>
                                <cfif isdefined("attributes.is_pay_cheques")>
                                    <td class="moneybox">
                                        <cfloop query="get_money">
                                            <cfif evaluate('toplam_ceksenet_other_#get_money.money#') neq 0>
                                                #Tlformat(abs(evaluate('toplam_ceksenet_other_#get_money.money#')))#<br/>
                                            </cfif>
                                        </cfloop>
                                    </td>
                                    <td class="text-center">
                                        <cfloop query="get_money">
                                            <cfif evaluate('toplam_ceksenet_other_#get_money.money#') neq 0>
                                                #get_money.money#<br/>
                                            </cfif>
                                        </cfloop>
                                    </td>
                                    <td class="text-center">
                                        <cfloop query="get_money">
                                            <cfif evaluate('toplam_ceksenet_other_#get_money.money#') neq 0>
                                                <cfif evaluate('toplam_ceksenet_other_#money#') gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif><br/>
                                            </cfif>
                                        </cfloop>
                                    </td>
                                    <td class="moneybox">
                                        <cfloop query="get_money">
                                            <cfif evaluate('toplam_ceksenet_ch_#get_money.money#') neq 0>
                                                #Tlformat(abs(evaluate('toplam_ceksenet_ch_#get_money.money#')))#<br/>
                                            </cfif>
                                        </cfloop>
                                    </td>
                                    <td class="text-center">
                                        <cfloop query="get_money">
                                            <cfif evaluate('toplam_ceksenet_ch_#get_money.money#') neq 0>
                                                #get_money.money#<br/>
                                            </cfif>
                                        </cfloop>
                                    </td>
                                    <td class="text-center">
                                        <cfloop query="get_money">
                                            <cfif evaluate('toplam_ceksenet_ch_#get_money.money#') neq 0>
                                                <cfif evaluate('toplam_ceksenet_ch_#money#') gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif><br/>
                                            </cfif>
                                        </cfloop>
                                    </td>
                                    <td class="moneybox">
                                        <cfloop query="get_money">
                                            <cfset bakiye_ceksenet= evaluate('toplam_borc_#get_money.money#') - evaluate('toplam_alacak_#get_money.money#')>
                                            <cfif (bakiye_ceksenet - evaluate('toplam_ceksenet_#get_money.money#')) neq 0>
                                                #Tlformat(abs(bakiye_ceksenet + evaluate('toplam_ceksenet_#get_money.money#')))#<br/>
                                            </cfif>
                                        </cfloop>
                                    </td>
                                    <td class="text-center">
                                        <cfloop query="get_money">
                                            <cfset bakiye_ceksenet= evaluate('toplam_borc_#get_money.money#') - evaluate('toplam_alacak_#get_money.money#')>
                                            <cfif (bakiye_ceksenet - evaluate('toplam_ceksenet_#get_money.money#')) neq 0>
                                                #get_money.money#<br/>
                                            </cfif>
                                        </cfloop>
                                    </td>
                                    <td class="text-center">
                                        <cfloop query="get_money">
                                            <cfset bakiye_ceksenet= evaluate('toplam_borc_#get_money.money#') - evaluate('toplam_alacak_#get_money.money#')>
                                            <cfif (bakiye_ceksenet - evaluate('toplam_ceksenet_#get_money.money#')) neq 0>
                                                <cfif (bakiye_ceksenet + evaluate('toplam_ceksenet_#get_money.money#')) gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif><br/>
                                            </cfif>
                                        </cfloop>
                                    </td>
                                </cfif>
                            </cfif>
                            <td class="moneybox">#TLFormat(attributes.vade_dev,0)#</td>
                            <!-- sil --><td width="15"></td><!-- sil -->
                            <cfif session.ep.our_company_info.sms><td>&nbsp</td></cfif>
                            <!-- sil --><td width="15"></td><!-- sil -->
                        </tr>
                    </cfoutput>
                </cfif>
                <cfset company_list = ''>
                <cfset consumer_list = ''>
                <cfset employee_list = ''>
                <cfset company_count_list = ''>
                <cfset consumer_count_list = ''>
                <cfset employee_count_list = ''>
                <cfset company_id_list2 = ''>
                <cfset consumer_id_list2 = ''>
                <cfset project_id_list = ''>
                <cfset account_code_list = ''>
                <cfset comp_id_list = ''>
                <cfset cons_id_list = ''>
                <cfset emp_id_list = ''>
                <cfset in_out_id_list = ''>
                <cfset city_id_list = ''>
                <cfset asset_id_list = ''>
                <cfset acc_type_id_list = ''>
                <cfset comp_acc_type_id_list = ''>
                <cfset subscription_id_list = ''>
                <cfoutput query="get_member" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <cfif not listfind(comp_id_list,member_id) and kontrol eq 0>
                        <cfset comp_id_list = listappend(comp_id_list,member_id)>
                    </cfif>	
                    <cfif not listfind(cons_id_list,member_id) and kontrol eq 1>
                        <cfset cons_id_list = listappend(cons_id_list,member_id)>
                    </cfif>		
                    <cfif not listfind(emp_id_list,member_id) and kontrol eq 2>
                        <cfset emp_id_list = listappend(emp_id_list,member_id)>
                    </cfif>		
                    <cfif not listfind(city_id_list,city)>
                        <cfset city_id_list = listappend(city_id_list,city)>
                    </cfif>
                    <cfif isdefined("attributes.is_project_group")>
                        <cfif not listfind(project_id_list,project_id)>
                            <cfset project_id_list = listappend(project_id_list,project_id)>
                        </cfif>	
                    </cfif>
                    <cfif isdefined("attributes.is_acc_type_group")>
                        <cfif not listfind(acc_type_id_list,acc_type_id) and acc_type_id neq 0 and member_type eq 'employee'>
                            <cfset acc_type_id_list = listappend(acc_type_id_list,acc_type_id)>
                        </cfif>
                        <cfif not listfind(comp_acc_type_id_list,acc_type_id) and member_type neq 'employee'>
                            <cfset comp_acc_type_id_list = listappend(comp_acc_type_id_list,acc_type_id)>
                        </cfif>
                    <cfelse>
                        <cfif not listfind(acc_type_id_list,acc_type_id) and acc_type_id neq 0 and kontrol eq 2>
                            <cfset acc_type_id_list = listappend(acc_type_id_list,acc_type_id)>
                        </cfif>
                    </cfif>
                    <cfif isdefined("attributes.is_asset_group")>
                        <cfif not listfind(asset_id_list,assetp_id)>
                            <cfset asset_id_list = listappend(asset_id_list,assetp_id)>
                        </cfif>	
                    </cfif>
                    <cfif isdefined("attributes.is_subscription_group")>
                        <cfif not listfind(subscription_id_list,subscription_id)>
                            <cfset subscription_id_list = listappend(subscription_id_list,subscription_id)>
                        </cfif>	
                    </cfif>
                </cfoutput>
                <cfif len(city_id_list)>
                    <cfset city_id_list=listsort(city_id_list,"numeric","ASC",",")>
                    <cfquery name="get_city_name" datasource="#dsn#">
                        SELECT CITY_ID,PLATE_CODE FROM SETUP_CITY WHERE CITY_ID IN (#city_id_list#) ORDER BY CITY_ID
                    </cfquery>
                    <cfset city_id_list = listsort(listdeleteduplicates(valuelist(get_city_name.city_id,',')),'numeric','ASC',',')>
                </cfif> 
                <cfif len(project_id_list)>
                    <cfset project_id_list=listsort(project_id_list,"numeric","ASC",",")>
                    <cfquery name="get_pro_name" datasource="#dsn#">
                        SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_id_list#) ORDER BY PROJECT_ID
                    </cfquery>
                    <cfset project_id_list = listsort(listdeleteduplicates(valuelist(get_pro_name.project_id,',')),'numeric','ASC',',')>
                </cfif>
                <cfif len(asset_id_list)>
                    <cfset asset_id_list=listsort(asset_id_list,"numeric","ASC",",")>
                    <cfquery name="get_asset_name" datasource="#dsn#">
                        SELECT ASSETP_ID,ASSETP FROM ASSET_P WHERE ASSETP_ID IN (#asset_id_list#) ORDER BY ASSETP_ID
                    </cfquery>
                    <cfset asset_id_list = listsort(listdeleteduplicates(valuelist(get_asset_name.ASSETP_ID,',')),'numeric','ASC',',')>
                </cfif>
                <cfif len(subscription_id_list)>
                    <cfset subscription_id_list=listsort(subscription_id_list,"numeric","ASC",",")>
                    <cfquery name="get_subscription_no" datasource="#dsn3#">
                        SELECT SUBSCRIPTION_ID,SUBSCRIPTION_NO FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID IN (#subscription_id_list#) ORDER BY SUBSCRIPTION_ID
                    </cfquery>
                    <cfset subscription_id_list = listsort(listdeleteduplicates(valuelist(get_subscription_no.SUBSCRIPTION_ID,',')),'numeric','ASC',',')>
                </cfif>
                <cfif len(acc_type_id_list)>
                    <cfset acc_type_id_list=listsort(acc_type_id_list,"numeric","ASC",",")>
                    <cfquery name="get_ch_type" datasource="#dsn#">
                        SELECT ACC_TYPE_ID,ACC_TYPE_NAME FROM SETUP_ACC_TYPE WHERE ACC_TYPE_ID IN (#acc_type_id_list#) ORDER BY ACC_TYPE_ID
                    </cfquery>
                    <cfset acc_type_id_list = listsort(listdeleteduplicates(valuelist(get_ch_type.ACC_TYPE_ID,',')),'numeric','ASC',',')>
                </cfif>
                <cfif len(comp_acc_type_id_list)>
                    <cfset comp_acc_type_id_list=listsort(comp_acc_type_id_list,"numeric","ASC",",")>
                    <cfquery name="get_comp_ch_type" datasource="#dsn#">
                        SELECT ACCOUNT_TYPE_ID, ACCOUNT_TYPE FROM ACCOUNT_TYPES WHERE ACCOUNT_TYPE_ID IN (#comp_acc_type_id_list#) ORDER BY ACCOUNT_TYPE_ID
                    </cfquery>
                    <cfset comp_acc_type_id_list = listsort(listdeleteduplicates(valuelist(get_comp_ch_type.ACCOUNT_TYPE_ID,',')),'numeric','ASC',',')>
                </cfif>
                <cfif len(comp_id_list)>
                    <cfset comp_id_list=listsort(comp_id_list,"numeric","ASC",",")>
                    <!---<cfquery name="get_comp_bakiye" datasource="#dsn2#">
                        SELECT COMPANY_ID,ALACAK,BORC,BAKIYE FROM COMPANY_REMAINDER WHERE COMPANY_ID IN(#comp_id_list#) ORDER BY COMPANY_ID
                    </cfquery>--->
                    <cfquery name="get_comp_bakiye" datasource="#dsn2#">
                        SELECT
                                COMPANY_ID, 
                                ROUND(SUM(BORC-ALACAK),5) AS BAKIYE, 
                                SUM(BORC) AS BORC,
                                SUM(ALACAK) AS ALACAK
                            FROM
                                CARI_ROWS_TOPLAM
                            WHERE 
                                COMPANY_ID IN(#comp_id_list#) 
                                <cfif isdefined('attributes.finishdate2') and len(attributes.finishdate2)>
                                    AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate2#">
                                </cfif>	
                                <cfif isdefined('attributes.startdate2') and len(attributes.startdate2)>
                                    AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate2#">
                                </cfif>
                            GROUP BY
                                COMPANY_ID
                            ORDER BY COMPANY_ID   
                    </cfquery>
                    <cfset comp_id_list2 = listsort(listdeleteduplicates(valuelist(get_comp_bakiye.company_id,',')),'numeric','ASC',',')>
                    <cfquery name="get_pos_name" datasource="#DSN#">
                        SELECT
                            EMPLOYEE_NAME,
                            EMPLOYEE_SURNAME,
                            WEB.COMPANY_ID,
                            WEB.POSITION_CODE
                        FROM
                            WORKGROUP_EMP_PAR WEB,
                            EMPLOYEE_POSITIONS
                        WHERE
                            WEB.POSITION_CODE = EMPLOYEE_POSITIONS.POSITION_CODE AND
                            WEB.COMPANY_ID IN (#comp_id_list#) AND
                            WEB.COMPANY_ID IS NOT NULL AND
                            WEB.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                            WEB.IS_MASTER = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
                        ORDER BY 
                            WEB.COMPANY_ID
                    </cfquery>
                    <cfset comp_id_list = listsort(listdeleteduplicates(valuelist(get_pos_name.company_id,',')),'numeric','ASC',',')>
                </cfif> 
                <cfif len(cons_id_list)>
                    <cfset cons_id_list=listsort(cons_id_list,"numeric","ASC",",")>
                    <cfquery name="get_cons_bakiye" datasource="#dsn2#">
                        SELECT CONSUMER_ID,ALACAK,BORC,BAKIYE FROM CONSUMER_REMAINDER WHERE CONSUMER_ID IN(#cons_id_list#) ORDER BY CONSUMER_ID
                    </cfquery>
                    <cfset cons_id_list2 = listsort(listdeleteduplicates(valuelist(get_cons_bakiye.consumer_id,',')),'numeric','ASC',',')>
                    <cfquery name="get_pos_name_2" datasource="#DSN#">
                        SELECT
                            EMPLOYEE_NAME,
                            EMPLOYEE_SURNAME,
                            WEB.CONSUMER_ID,
                            WEB.POSITION_CODE
                        FROM
                            WORKGROUP_EMP_PAR WEB,
                            EMPLOYEE_POSITIONS
                        WHERE
                            WEB.POSITION_CODE = EMPLOYEE_POSITIONS.POSITION_CODE AND
                            WEB.CONSUMER_ID IN (#cons_id_list#) AND
                            WEB.CONSUMER_ID IS NOT NULL AND
                            WEB.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                            WEB.IS_MASTER = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
                        ORDER BY 
                            WEB.CONSUMER_ID
                    </cfquery>
                    <cfset cons_id_list = listsort(listdeleteduplicates(valuelist(get_pos_name_2.consumer_id,',')),'numeric','ASC',',')>
                </cfif> 
                <cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
                    <cfoutput query="get_member" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <cfif listfindnocase(company_list,member_id) and kontrol eq 0>
                            <cfset sira_ = listfindnocase(company_list,member_id)>
                            <cfset sayi_ = listgetat(company_count_list,sira_)>
                            <cfset sayi_ = sayi_ + 1>
                            <cfset company_count_list = listsetat(company_count_list,sira_,sayi_)>
                        <cfelseif listfindnocase(consumer_list,member_id) and kontrol eq 1>
                            <cfset sira_ = listfindnocase(consumer_list,member_id)>
                            <cfset sayi_ = listgetat(consumer_count_list,sira_)>
                            <cfset sayi_ = sayi_ + 1>
                            <cfset consumer_count_list = listsetat(consumer_count_list,sira_,sayi_)>
                        <cfelseif listfindnocase(employee_list,"#member_id#-#acc_type_id#") and kontrol eq 2>
                            <cfset sira_ = listfindnocase(employee_list,"#member_id#-#acc_type_id#")>
                            <cfset sayi_ = listgetat(employee_count_list,sira_)>
                            <cfset sayi_ = sayi_ + 1>
                            <cfset employee_count_list = listsetat(employee_count_list,sira_,sayi_)>	
                        <cfelseif not listfindnocase(company_list,member_id) and kontrol eq 0>
                            <cfset company_list = listappend(company_list,member_id)>
                            <cfset company_count_list = listappend(company_count_list,1)>
                        <cfelseif not listfindnocase(consumer_list,member_id) and kontrol eq 1>
                            <cfset consumer_list = listappend(consumer_list,member_id)>
                            <cfset consumer_count_list = listappend(consumer_count_list,1)>
                        <cfelseif not listfindnocase(employee_list,member_id) and kontrol eq 2>
                            <cfset employee_list = listappend(employee_list,"#member_id#-#acc_type_id#")>
                            <cfset employee_count_list = listappend(employee_count_list,1)>
                        </cfif>
                    </cfoutput>
                </cfif>
                <cfset row_count_=0>
                <cfoutput query="get_member" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <cfif not isDefined('get_member.acc_type_id')>
                        <cfset acc_type_id = ''>
                    </cfif>
                    <cfif x_show_system_money eq 0 and (isDefined("attributes.money_info") and attributes.money_info eq 2 and (MEMBER_CODE[currentrow] neq MEMBER_CODE[currentrow-1] or currentrow mod attributes.maxrows eq 1))>
                        <cfif kontrol eq 0>
                            <cfset sayfa_toplam_alacak = sayfa_toplam_alacak + get_comp_bakiye.alacak[listfind(comp_id_list2,member_id,',')]>
                            <cfset sayfa_toplam_borc = sayfa_toplam_borc + get_comp_bakiye.borc[listfind(comp_id_list2,member_id,',')]>			
                            <cfset BAKIYENEW = get_comp_bakiye.alacak[listfind(comp_id_list2,member_id,',')] - get_comp_bakiye.borc[listfind(comp_id_list2,member_id,',')]>
                        <cfelseif kontrol eq 1 and len(get_cons_bakiye.alacak[listfind(cons_id_list2,member_id,',')])>
                            <cfset sayfa_toplam_alacak = sayfa_toplam_alacak + get_cons_bakiye.alacak[listfind(cons_id_list2,member_id,',')]>
                            <cfset sayfa_toplam_borc = sayfa_toplam_borc + get_cons_bakiye.borc[listfind(cons_id_list2,member_id,',')]>			
                            <cfset BAKIYENEW = get_cons_bakiye.alacak[listfind(cons_id_list2,member_id,',')] - get_cons_bakiye.borc[listfind(cons_id_list2,member_id,',')]>
                        <cfelseif kontrol eq 2>
                            <cfset sayfa_toplam_alacak = sayfa_toplam_alacak + MAIN_ALACAK>
                            <cfset sayfa_toplam_borc = sayfa_toplam_borc + MAIN_BORC>			
                            <cfset BAKIYENEW = MAIN_ALACAK - MAIN_BORC>
                        </cfif>
                    </cfif>
                    <cfscript>
                        if (isDefined("attributes.money_info") and attributes.money_info neq 2)
                        {
                            sayfa_toplam_alacak = sayfa_toplam_alacak + ALACAK;
                            sayfa_toplam_borc = sayfa_toplam_borc + BORC;
                            if (isDefined("attributes.is_pay_cheques"))
                            {
                                sayfa_toplam_ceksenet_ch = sayfa_toplam_ceksenet_ch + CHEQUE_VOUCHER_VALUE_CH;
                                sayfa_toplam_ceksenet_other = sayfa_toplam_ceksenet_other + CHEQUE_VOUCHER_VALUE_OTHER;
                            }
                        }
                        BAKIYENEW = ALACAK - BORC;
                        if( BAKIYENEW lt 0)
                        BAKIYENEW = abs(BAKIYENEW);
                        if (isDefined("attributes.money_info") and len(session.ep.money2) and attributes.money_info eq 1)
                        {
                            if(len(BORC2)) BORC2 = BORC2; else BORC2 = 0;
                            if(len(ALACAK2)) ALACAK2 = ALACAK2; else ALACAK2 = 0;
                            sayfa_toplam_alacak_2 = sayfa_toplam_alacak_2 + ALACAK2;
                            sayfa_toplam_borc_2 = sayfa_toplam_borc_2 + BORC2;
                            if (isDefined("attributes.is_pay_cheques"))
                            {
                                sayfa_toplam_ceksenet_ch2 = sayfa_toplam_ceksenet_ch2 + CHEQUE_VOUCHER_VALUE_CH2;
                                sayfa_toplam_ceksenet_other2 = sayfa_toplam_ceksenet_other2 + CHEQUE_VOUCHER_VALUE_OTHER2;
                            }
                            BAKIYENEW_2 = ALACAK2 - BORC2;
                            if( BAKIYENEW_2 lt 0)
                            BAKIYENEW_2 = abs(BAKIYENEW_2);
                        }
                        if (isDefined("attributes.money_info") and attributes.money_info eq 2)
                        {
                            if(len(BORC3)) BORC3 = BORC3; else BORC3 = 0;
                            if(len(ALACAK3)) ALACAK3 = ALACAK3; else ALACAK3 = 0;
                            sayfa_toplam_alacak_3 = sayfa_toplam_alacak_3 + ALACAK3;
                            sayfa_toplam_borc_3 = sayfa_toplam_borc_3 + BORC3;
                            if (isDefined("attributes.is_pay_cheques"))
                            {
                                sayfa_toplam_ceksenet_ch3 = sayfa_toplam_ceksenet_ch3 + CHEQUE_VOUCHER_VALUE_CH3;
                                sayfa_toplam_ceksenet_other3 = sayfa_toplam_ceksenet_other3 + CHEQUE_VOUCHER_VALUE_OTHER3;
                            }
                            BAKIYENEW_3 = ALACAK3 - BORC3;
                            if( BAKIYENEW_3 lt 0)
                            BAKIYENEW_3 = abs(BAKIYENEW_3);
                        
                            if(kontrol eq 0)
                            {
                                this_sira_ = listfindnocase(company_list,member_id);
                                if(this_sira_ gt 0)
                                    this_rows_ = listgetat(company_count_list,this_sira_);
                                else
                                    this_rows_ = 1;
                            }
                            else if(kontrol eq 1)
                            {	
                                this_sira_ = listfindnocase(consumer_list,member_id);
                                if(this_sira_ gt 0)
                                    this_rows_ = listgetat(consumer_count_list,this_sira_);
                                else
                                    this_rows_ = 1;
                            }
                            else if(kontrol eq 2)
                            {	
                                this_sira_ = listfindnocase(employee_list,"#member_id#-#acc_type_id#");
                                if(this_sira_ gt 0)
                                    this_rows_ = listgetat(employee_count_list,this_sira_);
                                else
                                    this_rows_ = 1;
                            }
                        }
                        else
                            this_rows_ = 1;
                    </cfscript>
                    <cfset row_count_++>
                    <tr >
                        <cfif isDefined("attributes.money_info") and attributes.money_info neq 2><td width="20">#currentrow#</td></cfif>
                        <cfif (kontrol eq 0 and (row_count_ eq 1 or MEMBER_CODE[currentrow] neq MEMBER_CODE[currentrow-1])) or (kontrol eq 0 and isdefined("attributes.is_project_group") and project_id[currentrow] neq project_id[currentrow-1]) or (kontrol eq 0 and isdefined("attributes.is_asset_group") and assetp_id[currentrow] neq assetp_id[currentrow-1]) or (kontrol eq 0 and isdefined("attributes.is_subscription_group") and subscription_id[currentrow] neq subscription_id[currentrow-1]) or (kontrol eq 0 and isdefined("attributes.is_acc_type_group") and acc_type_id[currentrow] neq acc_type_id[currentrow-1])>
                            <cfset member_id_ = MEMBER_ID>
                            <td rowspan="#this_rows_#">#member_code#</td>
                            <td rowspan="#this_rows_#">
                                <cfif kontrol eq 0>
                                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#member_id#','list','popup_com_det');">#fullname#</a>
                                <cfelseif kontrol eq 1>
                                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#member_id#','list','popup_con_det');">#fullname#</a>
                                <cfelseif kontrol eq 2>
                                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#member_id#','list','popup_emp_det');">#fullname# <cfif len(acc_type_id) and acc_type_id neq 0>-#get_ch_type.acc_type_name[listfind(acc_type_id_list,acc_type_id,',')]#</cfif></a>
                                </cfif>
                            </td>
                            <cfif isdefined("attributes.is_acc_type_group")>
                                <td rowspan="#this_rows_#">
                                    <cfif attributes.member_type eq 'employee'>
                                        <cfif len(acc_type_id_list)>
                                            #get_ch_type.acc_type_name[listfind(acc_type_id_list,acc_type_id,',')]#
                                        </cfif>
                                    <cfelse>
                                        <cfif len(comp_acc_type_id_list)>
                                            #get_comp_ch_type.account_type[listfind(comp_acc_type_id_list,acc_type_id,',')]#
                                        </cfif>
                                    </cfif>
                                </td>                        
                            </cfif>
                            <cfif xml_account_code eq 1>
                                <td rowspan="#this_rows_#" style="mso-number-format:'\@'">
                                    <cfif kontrol eq 0>
                                        #get_company_period(company_id : member_id, acc_type_id : acc_type_id)#
                                    <cfelseif kontrol eq 1>
                                        #get_consumer_period(consumer_id : member_id, acc_type_id : acc_type_id)#
                                    <cfelseif kontrol eq 2>
                                        #get_employee_period(employee_id : member_id, acc_type_id : acc_type_id)#
                                    </cfif>
                                </td>    
                            </cfif>
                            <td rowspan="#this_rows_#"><cfif len(city_id_list) and len(city)>#get_city_name.plate_code[listfind(city_id_list,city,',')]#</cfif></td>
                            <cfif xml_show_phone_number eq 1>
                            <td rowspan="#this_rows_#">#COMPANY_TELCODE#-#COMPANY_TEL1#</td>
                            </cfif>
                            <td rowspan="#this_rows_#">
                                <cfif len(comp_id_list)>
                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&pos_code=#get_pos_name.position_code[listfind(comp_id_list,member_id,',')]#','medium');" class="tableyazi">
                                        #get_pos_name.employee_name[listfind(comp_id_list,member_id,',')]# #get_pos_name.employee_surname[listfind(comp_id_list,member_id,',')]#
                                    </a>
                                </cfif>
                            </td>
                            <td rowspan="#this_rows_#">#membercat#</td>
                            <cfif isdefined("attributes.is_project_group")>
                                <td rowspan="#this_rows_#"><cfif len(project_id_list) and project_id gt 0>#get_pro_name.project_head[listfind(project_id_list,project_id,',')]#</cfif></td>
                            </cfif>
                            <cfif isdefined("attributes.is_asset_group")>
                                <td rowspan="#this_rows_#"><cfif len(asset_id_list) and assetp_id gt 0>#get_asset_name.assetp[listfind(asset_id_list,assetp_id,',')]#</cfif></td>
                            </cfif>
                            <cfif isdefined("attributes.is_subscription_group")>
                                <td rowspan="#this_rows_#"><cfif len(subscription_id_list) and subscription_id gt 0>#get_subscription_no.subscription_no[listfind(subscription_id_list,subscription_id,',')]#</cfif></td>
                            </cfif>
                            <cfif x_show_system_money eq 0 or (x_show_system_money eq  1 and isDefined("attributes.money_info") and attributes.money_info neq 2)>
                                <td rowspan="#this_rows_#" class="moneybox"><cfif isDefined("attributes.money_info") and attributes.money_info eq 2>#TLFormat(get_comp_bakiye.borc[listfind(comp_id_list2,member_id,',')])#<cfelse>#TLFormat(BORC)#</cfif></td>
                                <td rowspan="#this_rows_#" class="moneybox"><cfif isDefined("attributes.money_info") and attributes.money_info eq 2>#TLFormat(get_comp_bakiye.alacak[listfind(comp_id_list2,member_id,',')])#<cfelse>#TLFormat(ALACAK)#</cfif></td>
                            </cfif>
                            <cfif kontrol eq 0>
                                <cfset member_type = 'partner'>
                            <cfelseif kontrol eq 1>
                                <cfset member_type = 'consumer'>
                            <cfelseif kontrol eq 2>
                                <cfset member_type = 'employee'>
                            </cfif>
                            <cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
                                <cfif x_show_system_money eq 0>
                                    <td rowspan="#this_rows_#" class="moneybox">
                                        <cfif len(acc_type_id) and member_type is 'employee'>
                                            <cfset member_id_ = member_id&'_'&acc_type_id>
                                        <cfelse>
                                            <cfset member_id_ = member_id>
                                        </cfif>
                                        <cfif kontrol eq 0>
                                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&acc_type_id=#acc_type_id#&member_type=#member_type#&company_id=#member_id#&form_submit=1&comp_name=#fullname#&is_make_age=1&project_id=#attributes.project_id#&project_head=#attributes.project_head#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>
                                            <cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>&due_date_1=#dateformat(attributes.startdate,dateformat_style)#</cfif>
                                            <cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>&due_date_2=#dateformat(attributes.finishdate,dateformat_style)#</cfif>
                                            <cfif isdefined("attributes.startdate2") and isdate(attributes.startdate2)>&action_date_1=#dateformat(attributes.startdate2,dateformat_style)#</cfif>
                                            <cfif isdefined("attributes.finishdate2") and isdate(attributes.finishdate2)>&action_date_2=#dateformat(attributes.finishdate2,dateformat_style)#</cfif>','page')">#TLFormat(abs(get_comp_bakiye.bakiye[listfind(comp_id_list2,member_id,',')]))#</a>
                                        <cfelseif kontrol eq 1>
                                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&acc_type_id=#acc_type_id#&member_type=#member_type#&consumer_id=#member_id#&form_submit=1&comp_name=#fullname#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','page')">#TLFormat(abs(get_comp_bakiye.bakiye[listfind(comp_id_list2,member_id,',')]))#</a>
                                        <cfelseif kontrol eq 2>
                                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=#member_type#&employee_id=#member_id_#&form_submit=1&comp_name=#fullname#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','page')">#TLFormat(abs(MAIN_BAKIYE))#</a>
                                        </cfif>
                                    </td>
                                    <td rowspan="#this_rows_#" class="text-center">
                                        <cfif kontrol eq 0>
                                            <cfif get_comp_bakiye.borc[listfind(comp_id_list2,member_id,',')] gt get_comp_bakiye.alacak[listfind(comp_id_list2,member_id,',')]>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif get_comp_bakiye.bakiye[listfind(comp_id_list2,member_id,',')] eq 0><cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif></a>
                                        <cfelseif kontrol eq 1>
                                            <cfif get_comp_bakiye.borc[listfind(comp_id_list2,member_id,',')] gt get_comp_bakiye.alacak[listfind(comp_id_list2,member_id,',')]>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif get_comp_bakiye.bakiye[listfind(comp_id_list2,member_id,',')] eq 0><cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif></a>
                                        <cfelseif kontrol eq 2>
                                            <cfif MAIN_BORC gt MAIN_ALACAK>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif MAIN_BAKIYE eq 0><cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif></a>
                                        </cfif>
                                    </td>
                                </cfif>
                            <cfelse>
                                <td rowspan="#this_rows_#" class="moneybox">
                                    <cfif len(acc_type_id) and member_type is 'employee'>
                                        <cfset member_id_ = member_id&'_'&acc_type_id>
                                    <cfelse>
                                        <cfset member_id_ = member_id>
                                    </cfif>
                                    <cfif kontrol eq 0>
                                        <cfif isDefined("attributes.from_rev_collecter")>
                                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&acc_type_id=#acc_type_id#&member_type=#member_type#&company_id=#member_id#&form_submit=1&comp_name=#fullname#&is_make_age=1&project_id=#attributes.project_id#&project_head=#attributes.project_head#
                                            <cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>
                                            <cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>&due_date_1=#dateformat(attributes.startdate,dateformat_style)#</cfif>
                                            <cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>&due_date_2=#dateformat(attributes.finishdate,dateformat_style)#</cfif>
                                            <cfif isdefined("attributes.startdate2") and isdate(attributes.startdate2)>&action_date_1=#dateformat(attributes.startdate2,dateformat_style)#</cfif>
                                            <cfif isdefined("attributes.finishdate2") and isdate(attributes.finishdate2)>&action_date_2=#dateformat(attributes.finishdate2,dateformat_style)#</cfif>','page')">#TLFormat(abs(BAKIYENEW))#</a>
                                        <cfelse>
                                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&acc_type_id=#acc_type_id#&member_type=#member_type#&company_id=#member_id#&form_submit=1&comp_name=#fullname#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','page')">#TLFormat(abs(BAKIYENEW))#</a>
                                        </cfif>
                                    <cfelseif kontrol eq 1>
                                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&acc_type_id=#acc_type_id#&member_type=#member_type#&consumer_id=#member_id#&form_submit=1&comp_name=#fullname#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','page')">#TLFormat(abs(BAKIYENEW))#</a>
                                    <cfelseif kontrol eq 2>
                                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=#member_type#&employee_id=#member_id_#&form_submit=1&comp_name=#fullname#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','page')">#TLFormat(abs(BAKIYENEW))#</a>
                                    </cfif>
                                </td>
                                <td class="text-center">
                                    <cfif kontrol eq 0>
                                        <cfif isDefined("attributes.from_rev_collecter")>
                                            <cfif BORC gt ALACAK>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif BAKIYENEW eq 0><cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif>
                                        <cfelse>
                                            <cfif BORC gt ALACAK>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif BAKIYENEW eq 0><cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif>
                                        </cfif>
                                    <cfelseif kontrol eq 1>
                                        <cfif BORC gt ALACAK>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif BAKIYENEW eq 0><cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif>
                                    <cfelseif kontrol eq 2>
                                        <cfif BORC gt ALACAK>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif BAKIYENEW eq 0><cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif>
                                    </cfif>
                                </td>
                                <cfif isDefined("attributes.money_info") and not len(attributes.money_info)>
                                    <cfif isdefined("attributes.is_pay_cheques")>
                                        <td class="moneybox">#TlFormat(abs(cheque_voucher_value_other))#</td>
                                        <td class="text-center"><cfif cheque_voucher_value_other gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif cheque_voucher_value_other neq 0>(<cf_get_lang dictionary_id='29684.A'>)</cfif></td>
                                        <td class="moneybox">#TlFormat(abs(cheque_voucher_value_ch))#</td>
                                        <td class="text-center"><cfif cheque_voucher_value_ch gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif cheque_voucher_value_ch neq 0>(<cf_get_lang dictionary_id='29684.A'>)</cfif></td>
                                        <td class="moneybox">#TlFormat(abs(borc-alacak+cheque_voucher_value))#</td>
                                        <td class="text-center"><cfif (borc-alacak+cheque_voucher_value) gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif (borc-alacak+cheque_voucher_value) neq 0>(<cf_get_lang dictionary_id='29684.A'>)</cfif></td>
                                    </cfif>
                                </cfif>
                            </cfif>
                        <cfelseif (kontrol eq 1 and (row_count_ eq 1 or MEMBER_CODE[currentrow] neq MEMBER_CODE[currentrow-1])) or (kontrol eq 1 and (row_count_ eq 1 or MEMBER_CODE[currentrow] neq MEMBER_CODE [currentrow-1])) or (kontrol eq 1 and currentrow mod attributes.maxrows eq 1) or (kontrol eq 1 and isdefined("attributes.is_project_group") and project_id[currentrow] neq project_id[currentrow-1])  or (kontrol eq 1 and isdefined("attributes.is_asset_group") and assetp_id[currentrow] neq assetp_id[currentrow-1])  or (kontrol eq 1 and isdefined("attributes.is_subscription_group") and subscription_id[currentrow] neq subscription_id[currentrow-1]) or (kontrol eq 1 and isdefined("attributes.is_acc_type_group") and acc_type_id[currentrow] neq acc_type_id[currentrow-1])>
                            <cfset member_id_ = MEMBER_ID> 
                            <td rowspan="#this_rows_#">#member_code#</td>
                            <td rowspan="#this_rows_#">
                                <cfif kontrol eq 0>
                                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#member_id#','list','popup_com_det');">#fullname#</a>
                                <cfelseif kontrol eq 1>
                                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#member_id#','list','popup_con_det');">#fullname#</a>
                                <cfelseif kontrol eq 2>
                                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#member_id#','list','popup_emp_det');">#fullname# <cfif len(acc_type_id) and acc_type_id neq 0>-#get_ch_type.acc_type_name[listfind(acc_type_id_list,acc_type_id,',')]#</cfif></a>
                                </cfif>
                            </td>
                            <cfif isdefined("attributes.is_acc_type_group")>
                                <td rowspan="#this_rows_#">
                                    <cfif attributes.member_type eq 'employee'>
                                        <cfif len(acc_type_id_list)>
                                            #get_ch_type.acc_type_name[listfind(acc_type_id_list,acc_type_id,',')]#
                                        </cfif>
                                    <cfelse>
                                        <cfif len(comp_acc_type_id_list)>
                                            #get_comp_ch_type.account_type[listfind(comp_acc_type_id_list,acc_type_id,',')]#
                                        </cfif>
                                    </cfif>
                                </td>                        
                            </cfif>
                            <cfif xml_account_code eq 1>
                                <td rowspan="#this_rows_#" style="mso-number-format:'\@'">#get_consumer_period(member_id)#</td>
                            </cfif>
                            <td rowspan="#this_rows_#"><cfif len(city_id_list) and len(city)>#get_city_name.plate_code[listfind(city_id_list,city,',')]#</cfif></td>
                            <cfif xml_show_phone_number eq 1>
                            <td rowspan="#this_rows_#">#COMPANY_TELCODE#-#COMPANY_TEL1#</td>
                            </cfif>
                            <td rowspan="#this_rows_#">
                                <cfif len(cons_id_list)>
                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&pos_code=#get_pos_name_2.position_code[listfind(cons_id_list,member_id,',')]#','medium');" class="tableyazi">
                                        #get_pos_name_2.employee_name[listfind(cons_id_list,member_id,',')]# #get_pos_name_2.employee_surname[listfind(cons_id_list,member_id,',')]#
                                    </a>
                                </cfif>
                            </td>
                            <td rowspan="#this_rows_#">#membercat#</td>
                            <cfif isdefined("attributes.is_project_group")>
                                <td rowspan="#this_rows_#"><cfif len(project_id_list) and project_id gt 0>#get_pro_name.project_head[listfind(project_id_list,project_id,',')]#</cfif></td>
                            </cfif>
                            <cfif isdefined("attributes.is_asset_group")>
                                <td rowspan="#this_rows_#"><cfif len(asset_id_list) and assetp_id gt 0>#get_asset_name.assetp[listfind(asset_id_list,assetp_id,',')]#</cfif></td>
                            </cfif>
                            <cfif isdefined("attributes.is_subscription_group")>
                                <td rowspan="#this_rows_#"><cfif len(subscription_id_list) and subscription_id gt 0>#get_subscription_no.subscription_no[listfind(subscription_id_list,subscription_id,',')]#</cfif></td>
                            </cfif>
                            <cfif kontrol eq 0>
                                <cfset member_type = 'partner'>
                            <cfelseif kontrol eq 1>
                                <cfset member_type = 'consumer'>
                            <cfelseif kontrol eq 2>
                                <cfset member_type = 'employee'>
                            </cfif>
                            <cfif x_show_system_money eq 0 or (x_show_system_money eq  1 and isDefined("attributes.money_info") and attributes.money_info neq 2)>
                                <td rowspan="#this_rows_#" class="moneybox"><cfif isDefined("attributes.money_info") and attributes.money_info eq 2>#TLFormat(get_cons_bakiye.borc[listfind(cons_id_list2,member_id,',')])#<cfelse>#TLFormat(BORC)#</cfif></td>
                                <td rowspan="#this_rows_#" class="moneybox"><cfif isDefined("attributes.money_info") and attributes.money_info eq 2>#TLFormat(get_cons_bakiye.alacak[listfind(cons_id_list2,member_id,',')])#<cfelse>#TLFormat(ALACAK)#</cfif></td>
                            </cfif>
                            <cfif len(acc_type_id) and member_type is 'employee'>
                                <cfset member_id_ = member_id&'_'&acc_type_id>
                            <cfelse>
                                <cfset member_id_ = member_id>
                            </cfif>
                            <cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
                                <cfif x_show_system_money eq 0>
                                    <td rowspan="#this_rows_#" class="moneybox">
                                        <cfif kontrol eq 0>
                                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&acc_type_id=#acc_type_id#&member_type=#member_type#&company_id=#member_id#&form_submit=1&comp_name=#fullname#&is_make_age=1&project_id=#attributes.project_id#&project_head=#attributes.project_head#
                                            <cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>
                                            <cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>&due_date_1=#dateformat(attributes.startdate,dateformat_style)#</cfif>
                                            <cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>&due_date_2=#dateformat(attributes.finishdate,dateformat_style)#</cfif>
                                            <cfif isdefined("attributes.startdate2") and isdate(attributes.startdate2)>&action_date_1=#dateformat(attributes.startdate2,dateformat_style)#</cfif>
                                            <cfif isdefined("attributes.finishdate2") and isdate(attributes.finishdate2)>&action_date_2=#dateformat(attributes.finishdate2,dateformat_style)#</cfif>','page')">#TLFormat(abs(get_cons_bakiye.bakiye[listfind(cons_id_list2,member_id,',')]))#</a>
                                        <cfelseif kontrol eq 1>
                                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&acc_type_id=#acc_type_id#&member_type=#member_type#&consumer_id=#member_id#&form_submit=1&comp_name=#fullname#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','page')">
                                                <cfif len(get_cons_bakiye.bakiye[listfind(cons_id_list2,member_id,',')])>
                                                    #TLFormat(abs(get_cons_bakiye.bakiye[listfind(cons_id_list2,member_id,',')]))#
                                                <cfelse>
                                                    #TLFormat(0)#	
                                                </cfif>
                                            </a>
                                        <cfelseif kontrol eq 2>
                                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=#member_type#&employee_id=#member_id_#&form_submit=1&comp_name=#fullname#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','page')">#TLFormat(abs(MAIN_BAKIYE))#</a>
                                        </cfif>					
                                    </td>
                                    <td rowspan="#this_rows_#" class="text-center">
                                        <cfif kontrol eq 0>
                                            <cfif get_cons_bakiye.borc[listfind(cons_id_list2,member_id,',')] gt get_cons_bakiye.alacak[listfind(cons_id_list2,member_id,',')]>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif get_cons_bakiye.bakiye[listfind(cons_id_list2,member_id,',')] eq 0><cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif>
                                        <cfelseif kontrol eq 1>
                                            <cfif get_cons_bakiye.borc[listfind(cons_id_list2,member_id,',')] gt get_cons_bakiye.alacak[listfind(cons_id_list2,member_id,',')]>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif get_cons_bakiye.bakiye[listfind(cons_id_list2,member_id,',')] eq 0><cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif>
                                        <cfelseif kontrol eq 2>
                                            <cfif MAIN_BORC gt MAIN_ALACAK>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif MAIN_BAKIYE eq 0><cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif>
                                        </cfif>
                                    </td>
                                </cfif>
                            <cfelse>
                                <td rowspan="#this_rows_#" class="moneybox">
                                    <cfif kontrol eq 0>
                                        <cfset member_type = 'partner'>
                                    <cfelseif kontrol eq 1>
                                        <cfset member_type = 'consumer'>
                                    <cfelseif kontrol eq 2>
                                        <cfset member_type = 'employee'>
                                    </cfif>
                                    <cfif kontrol eq 0>
                                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&acc_type_id=#acc_type_id#&member_type=#member_type#&company_id=#member_id#&form_submit=1&comp_name=#fullname#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','page')">#TLFormat(abs(BAKIYENEW))#</a>
                                    <cfelseif kontrol eq 1>
                                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&acc_type_id=#acc_type_id#&member_type=#member_type#&consumer_id=#member_id#&form_submit=1&comp_name=#fullname#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','page')">#TLFormat(abs(BAKIYENEW))#</a>
                                    <cfelseif kontrol eq 2>
                                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=#member_type#&employee_id=#member_id_#&form_submit=1&comp_name=#fullname#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','page')">#TLFormat(abs(BAKIYENEW))#</a>
                                    </cfif>
                                </td>
                                <td class="text-center">
                                    <cfif kontrol eq 0>
                                        <cfif BORC gt ALACAK>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif BAKIYENEW eq 0><cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif>
                                    <cfelseif kontrol eq 1>
                                        <cfif BORC gt ALACAK>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif BAKIYENEW eq 0><cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif>
                                    <cfelseif kontrol eq 2>
                                        <cfif BORC gt ALACAK>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif BAKIYENEW eq 0><cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif>
                                    </cfif>
                                </td>
                                <cfif isDefined("attributes.money_info") and not len(attributes.money_info)>
                                    <cfif isdefined("attributes.is_pay_cheques")>
                                        <td class="moneybox">#TlFormat(abs(cheque_voucher_value_other))#</td>
                                        <td class="text-center"><cfif cheque_voucher_value_other gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif cheque_voucher_value_other neq 0>(<cf_get_lang dictionary_id='29684.A'>)</cfif></td>
                                        <td class="moneybox">#TlFormat(abs(cheque_voucher_value_ch))#</td>
                                        <td class="text-center"><cfif cheque_voucher_value_ch gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif cheque_voucher_value_ch neq 0>(<cf_get_lang dictionary_id='29684.A'>)</cfif></td>
                                        <td class="moneybox">#TlFormat(abs(borc-alacak+cheque_voucher_value))#</td>
                                        <td class="text-center"><cfif (borc-alacak+cheque_voucher_value) gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif (borc-alacak+cheque_voucher_value) neq 0>(<cf_get_lang dictionary_id='29684.A'>)</cfif></td>
                                    </cfif>
                                </cfif>
                            </cfif>
                        <cfelseif (kontrol eq 2 and MEMBER_CODE[currentrow] neq MEMBER_CODE[currentrow-1]) or (kontrol eq 2 and ACC_TYPE_ID[currentrow] neq ACC_TYPE_ID[currentrow-1]) or (kontrol eq 2 and currentrow mod attributes.maxrows eq 1) or (kontrol eq 2 and isdefined("attributes.is_project_group") and project_id[currentrow] neq project_id[currentrow-1]) or (kontrol eq 2 and isdefined("attributes.is_asset_group") and assetp_id[currentrow] neq assetp_id[currentrow-1]) or (kontrol eq 2 and isdefined("attributes.is_subscription_group") and subscription_id[currentrow] neq subscription_id[currentrow-1]) or (kontrol eq 2 and isdefined("attributes.is_acc_type_group") and acc_type_id[currentrow] neq acc_type_id[currentrow-1])>
                                <cfset member_id_ = MEMBER_ID>
                                <td rowspan="#this_rows_#"><cf_duxi name="wid" type="label" value="#member_code#" gdpr="3"></td>
                                <td rowspan="#this_rows_#">
                                    <cfif kontrol eq 0>
                                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#member_id#','list','popup_com_det');">#fullname#</a>
                                    <cfelseif kontrol eq 1>
                                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#member_id#','list','popup_con_det');">#fullname#</a>
                                    <cfelseif kontrol eq 2>
                                        <cf_duxi name="wid" type="label" value="#fullname#" gdpr="3" Onclick_="#request.self#?fuseaction=objects.popup_emp_det&emp_id=#member_id#">
                                            <cfif not isdefined("attributes.is_acc_type_group")><cfif len(acc_type_id) and acc_type_id neq 0>-<cf_duxi name="wid" type="label" value="#get_ch_type.acc_type_name[listfind(acc_type_id_list,acc_type_id,',')]#" gdpr="3" Onclick_="#request.self#?fuseaction=objects.popup_emp_det&emp_id=#member_id#"></cfif></cfif>
                                      <!---   <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#member_id#','list','popup_emp_det');">#fullname#<cfif not isdefined("attributes.is_acc_type_group")><cfif len(acc_type_id) and acc_type_id neq 0>-#get_ch_type.acc_type_name[listfind(acc_type_id_list,acc_type_id,',')]#</cfif></cfif></a> --->
                                    </cfif>
                                </td>
                                <cfif isdefined("attributes.is_acc_type_group")>
                                    <td rowspan="#this_rows_#">
                                        <cfif attributes.member_type eq 'employee'>
                                            <cfif len(acc_type_id_list)>
                                                #get_ch_type.acc_type_name[listfind(acc_type_id_list,acc_type_id,',')]#
                                            </cfif>
                                        <cfelse>
                                            <cfif len(comp_acc_type_id_list)>
                                                #get_comp_ch_type.account_type[listfind(comp_acc_type_id_list,acc_type_id,',')]#
                                            </cfif>
                                        </cfif>
                                    </td>
                                </cfif>
                                <cfif xml_account_code eq 1>
                                    <cfif isdefined("attributes.is_acc_type_group")>
                                        <td rowspan="#this_rows_#" style="mso-number-format:'\@'">#emp_account_code#</td>
                                    <cfelse>
                                        <td>#get_employee_period(employee_id : member_id, acc_type_id : acc_type_id)#</td>
                                    </cfif>
                                </cfif>
                                <td rowspan="#this_rows_#"></td>
                                <cfif xml_show_phone_number eq 1>
                                <td rowspan="#this_rows_#">#COMPANY_TELCODE#-#COMPANY_TEL1#</td>
                                </cfif>
                                <td rowspan="#this_rows_#"></td>
                                <td rowspan="#this_rows_#"></td>
                                <cfif isdefined("attributes.is_project_group")>
                                    <td rowspan="#this_rows_#"><cfif len(project_id_list) and project_id gt 0>#get_pro_name.project_head[listfind(project_id_list,project_id,',')]#</cfif></td>
                                </cfif>
                                <cfif isdefined("attributes.is_asset_group")>
                                    <td rowspan="#this_rows_#"><cfif len(asset_id_list) and assetp_id gt 0>#get_asset_name.assetp[listfind(asset_id_list,assetp_id,',')]#</cfif></td>
                                </cfif>
                                <cfif isdefined("attributes.is_subscription_group")>
                                    <td rowspan="#this_rows_#"><cfif len(subscription_id_list) and subscription_id gt 0>#get_subscription_no.subscription_no[listfind(subscription_id_list,subscription_id,',')]#</cfif></td>
                                </cfif>
                                <cfif kontrol eq 0>
                                    <cfset member_type = 'partner'>
                                <cfelseif kontrol eq 1>
                                    <cfset member_type = 'consumer'>
                                <cfelseif kontrol eq 2>
                                    <cfset member_type = 'employee'>
                                </cfif>
                                <cfif x_show_system_money eq 0 or (x_show_system_money eq  1 and isDefined("attributes.money_info") and attributes.money_info neq 2)>
                                    <td rowspan="#this_rows_#" class="moneybox"><cfif isDefined("attributes.money_info") and attributes.money_info eq 2>#TLFormat(MAIN_BORC)#<cfelse>#TLFormat(BORC)#</cfif></td>
                                    <td rowspan="#this_rows_#" class="moneybox"><cfif isDefined("attributes.money_info") and attributes.money_info eq 2>#TLFormat(MAIN_ALACAK)#<cfelse>#TLFormat(ALACAK)#</cfif></td>
                                </cfif>
                                <cfif len(acc_type_id) and member_type is 'employee'>
                                    <cfset member_id_ = member_id&'_'&acc_type_id>
                                <cfelse>
                                    <cfset member_id_ = member_id>
                                </cfif>
                                <cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
                                    <cfif x_show_system_money eq 0>
                                        <td rowspan="#this_rows_#" class="moneybox">
                                            <cfif kontrol eq 0>
                                                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&acc_type_id=#acc_type_id#&member_type=#member_type#&company_id=#member_id#&form_submit=1&comp_name=#fullname#&is_make_age=1&project_id=#attributes.project_id#&project_head=#attributes.project_head#
                                                <cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>
                                                <cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>&due_date_1=#dateformat(attributes.startdate,dateformat_style)#</cfif>
                                                <cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>&due_date_2=#dateformat(attributes.finishdate,dateformat_style)#</cfif>
                                                <cfif isdefined("attributes.startdate2") and isdate(attributes.startdate2)>&action_date_1=#dateformat(attributes.startdate2,dateformat_style)#</cfif>
                                                <cfif isdefined("attributes.finishdate2") and isdate(attributes.finishdate2)>&action_date_2=#dateformat(attributes.finishdate2,dateformat_style)#</cfif>','page')">#TLFormat(abs(get_cons_bakiye.bakiye[listfind(cons_id_list2,member_id,',')]))#</a>
                                            <cfelseif kontrol eq 1>
                                                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&acc_type_id=#acc_type_id#&member_type=#member_type#&consumer_id=#member_id#&form_submit=1&comp_name=#fullname#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','page')">#TLFormat(abs(get_cons_bakiye.bakiye[listfind(cons_id_list2,member_id,',')]))#</a>
                                            <cfelseif kontrol eq 2>
                                                <!--- <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=#member_type#&employee_id=#member_id_#&form_submit=1&comp_name=#fullname#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','page')">#TLFormat(abs(MAIN_BAKIYE))#</a> --->
                                                <cf_duxi type="label" name="main_bakiye" id="main_bakiye" value="#TLFormat(abs(MAIN_BAKIYE))#" Onclick_="#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=#member_type#&employee_id=#member_id_#&form_submit=1&comp_name=#fullname#&is_store_module=#is_store_module#" gdpr="3" hide="0">
                                            </cfif>					
                                        </td>
                                        <td rowspan="#this_rows_#"class="text-center">
                                            <cfif kontrol eq 0>
                                                <cfif get_cons_bakiye.borc[listfind(cons_id_list2,member_id,',')] gt get_cons_bakiye.alacak[listfind(cons_id_list2,member_id,',')]>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif get_cons_bakiye.bakiye[listfind(cons_id_list2,member_id,',')] eq 0><cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif>
                                            <cfelseif kontrol eq 1>
                                                <cfif get_cons_bakiye.borc[listfind(cons_id_list2,member_id,',')] gt get_cons_bakiye.alacak[listfind(cons_id_list2,member_id,',')]>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif get_cons_bakiye.bakiye[listfind(cons_id_list2,member_id,',')] eq 0><cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif>
                                            <cfelseif kontrol eq 2>
                                                <cfif MAIN_BORC gt MAIN_ALACAK>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif MAIN_BAKIYE eq 0><cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif>
                                            </cfif>	
                                        </td>
                                    </cfif>
                                <cfelse>
                                    <td rowspan="#this_rows_#"  class="moneybox">
                                        <cfif kontrol eq 0>
                                            <cfset member_type = 'partner'>
                                        <cfelseif kontrol eq 1>
                                            <cfset member_type = 'consumer'>
                                        <cfelseif kontrol eq 2>
                                            <cfset member_type = 'employee'>
                                        </cfif>
                                        <cfif kontrol eq 0>
                                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&acc_type_id=#acc_type_id#&member_type=#member_type#&company_id=#member_id#&form_submit=1&comp_name=#fullname#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','page')">#TLFormat(abs(BAKIYENEW))#</a>
                                        <cfelseif kontrol eq 1>
                                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&acc_type_id=#acc_type_id#&member_type=#member_type#&consumer_id=#member_id#&form_submit=1&comp_name=#fullname#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','page')">#TLFormat(abs(BAKIYENEW))#</a>
                                        <cfelseif kontrol eq 2>
                                            <!--- <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=#member_type#&employee_id=#member_id_#&form_submit=1&comp_name=#fullname#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','page')">#TLFormat(abs(BAKIYENEW))#</a> --->
                                            <cf_duxi type="label" name="new_bakiye" id="new_bakiye" value="#TLFormat(abs(BAKIYENEW))#" Onclick_="#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=#member_type#&employee_id=#member_id_#&form_submit=1&comp_name=#fullname#&is_store_module=#is_store_module#" gdpr="3" hide="0">
                                        </cfif>
                                    </td>
                                    <td class="text-center">
                                        <cfif kontrol eq 0>
                                            <cfif BORC gt ALACAK>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif BAKIYENEW eq 0><cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif>
                                        <cfelseif kontrol eq 1>
                                            <cfif BORC gt ALACAK>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif BAKIYENEW eq 0><cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif>
                                        <cfelseif kontrol eq 2>
                                            <cfif BORC gt ALACAK>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif BAKIYENEW eq 0><cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif>
                                        </cfif>
                                    </td>
                                    <cfif isDefined("attributes.money_info") and not len(attributes.money_info)>
                                        <cfif isdefined("attributes.is_pay_cheques")>
                                            <td class="moneybox">#TlFormat(abs(cheque_voucher_value_other))#</td>
                                            <td class="text-center"><cfif cheque_voucher_value_other gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif cheque_voucher_value_other neq 0>(<cf_get_lang dictionary_id='29684.A'>)</cfif></td>
                                            <td class="moneybox">#TlFormat(abs(cheque_voucher_value_ch))#</td>
                                            <td class="text-center"><cfif cheque_voucher_value_ch gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif cheque_voucher_value_ch neq 0>(<cf_get_lang dictionary_id='29684.A'>)</cfif></td>
                                            <td class="moneybox">#TlFormat(abs(borc-alacak+cheque_voucher_value))#</td>
                                            <td class="text-center"><cfif (borc-alacak+cheque_voucher_value) gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif (borc-alacak+cheque_voucher_value) neq 0>(<cf_get_lang dictionary_id='29684.A'>)</cfif></td>
                                        </cfif>
                                    </cfif>
                                </cfif>
                        </cfif>
                        <cfif kontrol eq 0>
                            <cfset member_type = 'partner'>
                        <cfelseif kontrol eq 1>
                            <cfset member_type = 'consumer'>
                        <cfelseif kontrol eq 2>
                            <cfset member_type = 'employee'>
                        </cfif>
                        <cfif isDefined("attributes.money_info") and len(session.ep.money2) and attributes.money_info eq 1>
                            <td class="moneybox">#TLFormat(BORC2)#</td>
                            <td class="moneybox">#TLFormat(ALACAK2)#</td>
                            <td class="moneybox">
                            <cfif len(acc_type_id) and member_type is 'employee'>
                                <cfset member_id_ = member_id&'_'&acc_type_id>
                            <cfelse>
                                <cfset member_id_ = member_id>
                            </cfif>
                            <cfif kontrol eq 0>
                                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=#member_type#&company_id=#member_id#&form_submit=1&comp_name=#fullname#&project_id=#attributes.project_id#&project_head=#attributes.project_head#
                                        <cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>
                                        <cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>&due_date_1=#dateformat(attributes.startdate,dateformat_style)#</cfif>
                                        <cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>&due_date_2=#dateformat(attributes.finishdate,dateformat_style)#</cfif>
                                        <cfif isdefined("attributes.startdate2") and isdate(attributes.startdate2)>&action_date_1=#dateformat(attributes.startdate2,dateformat_style)#</cfif>
                                        <cfif isdefined("attributes.finishdate2") and isdate(attributes.finishdate2)>&action_date_2=#dateformat(attributes.finishdate2,dateformat_style)#</cfif>
                                        <cfif isdefined("attributes.money_info") and attributes.money_info eq 2 and len(other_money)>&other_money_2=#other_money#</cfif>','page')">
                                            #TLFormat(abs(BAKIYENEW_2))#
                                    </a> 
                                </td>
                                <td class="text-center"><cfif BORC2 gt ALACAK2>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif BAKIYENEW_2 eq 0><cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif></td>
                            <cfelseif kontrol eq 1>
                                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=#member_type#&consumer_id=#member_id#&form_submit=1&comp_name=#fullname#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','page')">#TLFormat(abs(BAKIYENEW_2))#</a></td>
                                <td class="text-center"><cfif BORC2 gt ALACAK2>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif BAKIYENEW_2 eq 0><cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif></td>
                            <cfelseif kontrol eq 2>
                                <!--- <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=#member_type#&employee_id=#member_id_#&form_submit=1&comp_name=#fullname#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','page')">#TLFormat(abs(BAKIYENEW_2))#</a> --->
                                <cf_duxi type="label" name="new_bakiye2" id="new_bakiye2" value="#TLFormat(abs(BAKIYENEW_2))#" Onclick_="#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=#member_type#&employee_id=#member_id_#&form_submit=1&comp_name=#fullname#&is_store_module=#is_store_module#" gdpr="3" hide="0">
                            </td>
                                <td class="text-center"><cfif BORC2 gt ALACAK2>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif BAKIYENEW_2 eq 0><cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif></td>
                            </cfif>
                            <cfif isdefined("attributes.is_pay_cheques")>
                                <td class="moneybox">#TlFormat(abs(cheque_voucher_value_other2))#</td>
                                <td class="text-center"><cfif cheque_voucher_value_other2 gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif cheque_voucher_value_other2 neq 0>(<cf_get_lang dictionary_id='29684.A'>)</cfif></td>
                                <td class="moneybox">#TlFormat(abs(cheque_voucher_value_ch2))#</td>
                                <td class="text-center"><cfif cheque_voucher_value_ch2 gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif cheque_voucher_value_ch2 neq 0>(<cf_get_lang dictionary_id='29684.A'>)</cfif></td>
                                <td class="moneybox">#TlFormat(abs(borc2-alacak2+cheque_voucher_value2))#</td>
                                <td class="text-center"><cfif (borc2-alacak2+cheque_voucher_value2) gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif (borc2-alacak2+cheque_voucher_value2) neq 0>(<cf_get_lang dictionary_id='29684.A'>)</cfif></td>
                            </cfif>
                        </cfif>
                        <cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
                            <cfif x_show_system_money eq 1>
                                <cfset sayfa_toplam_alacak = sayfa_toplam_alacak + ALACAK>
                                <cfset sayfa_toplam_borc = sayfa_toplam_borc + BORC>
                                <td class="moneybox">#TLFormat(BORC)#</td>
                                <td class="moneybox">#TLFormat(ALACAK)#</td>
                                <td class="moneybox">
                                    <cfif kontrol eq 0>
                                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&acc_type_id=#acc_type_id#&member_type=#member_type#&company_id=#member_id#&form_submit=1&comp_name=#fullname#&is_make_age=1&project_id=#attributes.project_id#&project_head=#attributes.project_head#
                                        <cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>
                                        <cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>&due_date_1=#dateformat(attributes.startdate,dateformat_style)#</cfif>
                                        <cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>&due_date_2=#dateformat(attributes.finishdate,dateformat_style)#</cfif>
                                        <cfif isdefined("attributes.startdate2") and isdate(attributes.startdate2)>&action_date_1=#dateformat(attributes.startdate2,dateformat_style)#</cfif>
                                        <cfif isdefined("attributes.finishdate2") and isdate(attributes.finishdate2)>&action_date_2=#dateformat(attributes.finishdate2,dateformat_style)#</cfif>','page')">#TLFormat(abs(BAKIYE))#</a>
                                    <cfelseif kontrol eq 1>
                                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&acc_type_id=#acc_type_id#&member_type=#member_type#&consumer_id=#member_id#&form_submit=1&comp_name=#fullname#
                                        <cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','page')">#TLFormat(abs(BAKIYE))#</a>
                                    <cfelseif kontrol eq 2>
                                        <!--- <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=#member_type#&employee_id=#member_id_#&form_submit=1&comp_name=#fullname#
                                        <cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','page')">#TLFormat(abs(BAKIYE))#</a> --->
                                        <cf_duxi type="label" name="bakiye" id="bakiye" value="#TLFormat(abs(BAKIYE))#" Onclick_="#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=#member_type#&employee_id=#member_id_#&form_submit=1&comp_name=#fullname#
                                        &is_store_module=#is_store_module#" gdpr="3" hide="0">
                                    </cfif>
                                </td>
                                <td class="text-center">
                                    <cfif kontrol eq 0>
                                        <cfif BORC gt ALACAK>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif BAKIYE eq 0><cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif>
                                    <cfelseif kontrol eq 1>
                                        <cfif BORC gt ALACAK>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif BAKIYE eq 0><cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif>
                                    <cfelseif kontrol eq 2>
                                        <cfif BORC gt ALACAK>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif BAKIYE eq 0><cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif>
                                    </cfif>
                                </td>
                            </cfif>
                            <td class="moneybox">#TLFormat(BORC3)#</td>
                            <td class="text-center">#OTHER_MONEY#</td>
                            <td class="moneybox">#TLFormat(ALACAK3)#</td>
                            <td class="text-center">#OTHER_MONEY#</td>
                            <cfset 'toplam_borc_#other_money#' = evaluate('toplam_borc_#other_money#') + BORC3>
                            <cfset 'toplam_alacak_#other_money#' = evaluate('toplam_alacak_#other_money#') + ALACAK3>
                            <cfif isdefined("attributes.is_pay_cheques")>
                                <cfset 'toplam_ceksenet_ch_#other_money#' = evaluate('toplam_ceksenet_ch_#other_money#') + cheque_voucher_value_ch3>
                                <cfset 'toplam_ceksenet_other_#other_money#' = evaluate('toplam_ceksenet_other_#other_money#') + cheque_voucher_value_other3>
                            </cfif>
                            <td class="moneybox">
                            <cfif len(acc_type_id) and member_type is 'employee'>
                                <cfset member_id_ = member_id&'_'&acc_type_id>
                            <cfelse>
                                <cfset member_id_ = member_id>
                            </cfif>
                            <cfif kontrol eq 0>
                                    <cfset url_info = ''>
                                    <cfif isdefined("attributes.startdate") and isdate(attributes.startdate)><cfset url_info = "&due_date_1=#dateformat(attributes.startdate,dateformat_style)#"></cfif>
                                    <cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)><cfset url_info = "#url_info#&due_date_2=#dateformat(attributes.finishdate,dateformat_style)#"></cfif>
                                    <cfif isdefined("attributes.startdate2") and isdate(attributes.startdate2)><cfset url_info = "#url_info#&action_date_1=#dateformat(attributes.startdate2,dateformat_style)#"></cfif>
                                    <cfif isdefined("attributes.finishdate2") and isdate(attributes.finishdate2)><cfset url_info = "#url_info#&action_date_2=#dateformat(attributes.finishdate2,dateformat_style)#"></cfif>
                                    <cfif session.ep.isBranchAuthorization><cfset url_info = "#url_info#&is_store_module=1"></cfif>
                                    <cfif isdefined("attributes.money_info") and attributes.money_info eq 2 and len(other_money)><cfset url_info = "#url_info#&other_money_2=#other_money#"></cfif>
                                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&acc_type_id=#acc_type_id#&member_type=#member_type#&company_id=#member_id#&form_submit=1&comp_name=#fullname#&is_doviz_group=1&is_make_age=1&project_id=#attributes.project_id#&project_head=#attributes.project_head##url_info#','page')">
                                        #TLFormat(abs(BAKIYENEW_3))#
                                    </a> 
                                </td>
                                <td class="text-center">#OTHER_MONEY#</td>
                                <td class="text-center"><cfif BORC3 gt ALACAK3>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif BAKIYENEW_3 eq 0><cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif></td>
                                <cfif isdefined("attributes.is_pay_cheques")>
                                    <td class="moneybox">#TlFormat(abs(cheque_voucher_value_other3))#</td>
                                    <td class="text-center">#OTHER_MONEY#</td>
                                    <td class="text-center"><cfif cheque_voucher_value_other3 gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif cheque_voucher_value_other3 neq 0>(<cf_get_lang dictionary_id='29684.A'>)</cfif></td>
                                    <td class="moneybox">#TlFormat(abs(cheque_voucher_value_ch3))#</td>
                                    <td class="text-center">#OTHER_MONEY#</td>
                                    <td class="text-center"><cfif cheque_voucher_value_ch3 gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif cheque_voucher_value_ch3 neq 0>(<cf_get_lang dictionary_id='29684.A'>)</cfif></td>
                                    <td class="moneybox">#TlFormat(abs(borc3-alacak3+cheque_voucher_value3))#</td>
                                    <td class="text-center">#OTHER_MONEY#</td>
                                    <td class="text-center"><cfif (borc3-alacak3+cheque_voucher_value3) gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif (borc3-alacak3+cheque_voucher_value3) neq 0>(<cf_get_lang dictionary_id='29684.A'>)</cfif></td>
                                </cfif>
                            <cfelseif kontrol eq 1>
                                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&acc_type_id=#acc_type_id#&member_type=#member_type#&consumer_id=#member_id#&form_submit=1&comp_name=#fullname#<cfif session.ep.isBranchAuthorization>&is_store_module=1<cfelse>&is_doviz_group=1</cfif>','page')">#TLFormat(abs(BAKIYENEW_3))#</a> </td>
                                <td class="text-center">#OTHER_MONEY#</td>
                                <td class="text-center"><cfif BORC3 gt ALACAK3>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif BAKIYENEW_3 eq 0><cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif></td> 
                                <cfif isdefined("attributes.is_pay_cheques")>
                                    <td class="moneybox">#TlFormat(abs(cheque_voucher_value_other3))#</td>
                                    <td class="text-center">#OTHER_MONEY#</td>
                                    <td class="text-center"><cfif cheque_voucher_value_other3 gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif cheque_voucher_value_other3 neq 0>(<cf_get_lang dictionary_id='29684.A'>)</cfif></td>
                                    <td class="moneybox">#TlFormat(abs(cheque_voucher_value_ch3))#</td>
                                    <td class="text-center">#OTHER_MONEY#</td>
                                    <td class="text-center"><cfif cheque_voucher_value_ch3 gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif cheque_voucher_value_ch3 neq 0>(<cf_get_lang dictionary_id='29684.A'>)</cfif></td>
                                    <td class="moneybox">#TlFormat(abs(borc3-alacak3+cheque_voucher_value3))#</td>
                                    <td class="text-center">#OTHER_MONEY#</td>
                                    <td class="text-center"><cfif (borc3-alacak3+cheque_voucher_value3) gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif (borc3-alacak3+cheque_voucher_value3) neq 0>(<cf_get_lang dictionary_id='29684.A'>)</cfif></td>
                                </cfif>
                            <cfelseif kontrol eq 2>
                                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=#member_type#&employee_id=#member_id_#&form_submit=1&comp_name=#fullname#<cfif session.ep.isBranchAuthorization>&is_store_module=1<cfelse>&is_doviz_group=1</cfif>','page')">#TLFormat(abs(BAKIYENEW_3))#</a></td>
                                <td class="text-center">#OTHER_MONEY#</td>
                                <td class="text-center"><cfif BORC3 gt ALACAK3>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif BAKIYENEW_3 eq 0><cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif></td> 
                                <cfif isdefined("attributes.is_pay_cheques")>
                                    <td class="moneybox">#TlFormat(abs(cheque_voucher_value_other3))# </td>
                                    <td class="text-center">#OTHER_MONEY#</td>
                                    <td class="text-center"><cfif cheque_voucher_value_other3 gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif cheque_voucher_value_other3 neq 0>(<cf_get_lang dictionary_id='29684.A'>)</cfif></td>
                                    <td class="moneybox">#TlFormat(abs(cheque_voucher_value_ch3))#</td>
                                    <td class="text-center">#OTHER_MONEY#</td>
                                    <td class="text-center"><cfif cheque_voucher_value_ch3 gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif cheque_voucher_value_ch3 neq 0>(<cf_get_lang dictionary_id='29684.A'>)</cfif></td>
                                    <td class="moneybox">#TlFormat(abs(borc3-alacak3+cheque_voucher_value3))#</td>
                                    <td class="text-center">#OTHER_MONEY#</td>
                                    <td class="text-center"><cfif (borc3-alacak3+cheque_voucher_value3) gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif (borc3-alacak3+cheque_voucher_value3) neq 0>(<cf_get_lang dictionary_id='29684.A'>)</cfif></td>
                                </cfif>
                            </cfif>
                        </cfif>
                        <!---Adat--->  
                        <td class="moneybox">
                            <cfset attributes.vade_alacak_ara_toplam=val(attributes.vade_alacak_ara_toplam)>
                            <cfset attributes.vade_borc_ara_toplam=val(attributes.vade_borc_ara_toplam)>
                            <cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
                                <cfset attributes.vade_alacak_ara_toplam = attributes.vade_alacak_ara_toplam + VADE_ALACAK_ARATOPLAM>
                                <cfset attributes.vade_borc_ara_toplam = attributes.vade_borc_ara_toplam + VADE_BORC_ARATOPLAM>
                                <cfif borc3+alacak3 gt 0>
                                    #TLFormat(((abs(vade_borc) * abs(borc3)) + (abs(vade_alacak) * abs(alacak3)))/(abs(borc3)+abs(alacak3)),0)#
                                <cfelse>
                                    0
                                </cfif>
                                <cfif isDefined("attributes.due_info") and attributes.due_info neq 1>
                                    (#dateformat(date_add('d',(-1*TLFormat(((vade_borc * abs(borc)) + (vade_alacak * abs(alacak)))/(abs(borc)+abs(alacak)),0)),now()),dateformat_style)#)
                                </cfif>
                            <cfelse>
                                <cfset attributes.vade_alacak_ara_toplam = (attributes.vade_alacak_ara_toplam + VADE_ALACAK_ARATOPLAM)>
                                <cfset attributes.vade_borc_ara_toplam = attributes.vade_borc_ara_toplam + VADE_BORC_ARATOPLAM>
                                <cfif borc+alacak gt 0>
                                        <cfset kontrol_due_date = (dateformat(date_add('d',(-1*TLFormat(((vade_borc_1 * abs(borc)) + (vade_alacak_1 * abs(alacak)))/(abs(borc)+abs(alacak)),0)),now()),"mm/dd/yyyy"))>
                                        <cfset kontrol_now_date = dateformat(now(),"mm/dd/YYYY") >
                                        <cfif DateCompare(kontrol_due_date,kontrol_now_date) gt 0 >
                                            -#TLFormat(((abs(vade_borc_1) * abs(borc)) + (abs(vade_alacak_1) * abs(alacak)))/(abs(borc)+abs(alacak)),0)#
                                        <cfelse>
                                            #TLFormat(((abs(vade_borc_1) * abs(borc)) + (abs(vade_alacak_1) * abs(alacak)))/(abs(borc)+abs(alacak)),0)#
                                        </cfif>
                                        
                                <cfelse>
                                    0
                                </cfif>
                                <cfif isDefined("attributes.due_info") and attributes.due_info neq 1>
                                    (#dateformat(date_add('d',(-1*TLFormat(((vade_borc_1 * abs(borc)) + (vade_alacak_1 * abs(alacak)))/(abs(borc)+abs(alacak)),0)),now()),dateformat_style)#)
                                </cfif>
                            </cfif>
                        </td>
                        <!-- sil -->
                        <td>
                            <cfif kontrol eq 0>
                                <cfset member_type = 'partner'>
                            <cfelseif kontrol eq 1>
                                <cfset member_type = 'consumer'>
                            <cfelseif kontrol eq 2>
                                <cfset member_type = 'employee'>
                            </cfif>
                            <!--- member_type print Sablonlarinda keyword ifadesi ile kullaniliyor kaldirmayin, kaldirilmasi gerekiyorsa nedenini konusalim FBS 20111004 --->
                            <cfif isDefined("attributes.from_rev_collecter") and kontrol eq 0 and get_comp_bakiye.alacak[listfind(comp_id_list2,member_id,',')] gt get_comp_bakiye.borc[listfind(comp_id_list2,member_id,',')]>
                                <a href="#request.self#?fuseaction=finance.list_payment_actions&event=add&member_id=#MEMBER_ID#&member_name=#FULLNAME#&act_type=2&invoice_type<cfif isdefined("attributes.money_info") and attributes.money_info eq 2>&money_type=#other_money#</cfif>" class="tableyazi"><img src="images/list_ship.gif" alt="<cf_get_lang dictionary_id='31286.Ödeme Olustur'>" title="<cf_get_lang dictionary_id='31286.Ödeme Olustur'>"></a>
                            <cfelseif isDefined("attributes.from_rev_collecter") and kontrol eq 1 and get_cons_bakiye.alacak[listfind(cons_id_list2,member_id,',')] gt get_cons_bakiye.borc[listfind(cons_id_list2,member_id,',')]>
                                <a href="#request.self#?fuseaction=finance.list_payment_actions&event=add&consumer_id=#MEMBER_ID#&member_name=#FULLNAME#&act_type=2&invoice_type<cfif isdefined("attributes.money_info") and attributes.money_info eq 2>&money_type=#other_money#</cfif>" class="tableyazi"><img src="images/list_ship.gif" alt="<cf_get_lang dictionary_id='31286.Ödeme Olustur'>" title="<cf_get_lang dictionary_id='31286.Ödeme Olustur'>"></a>
                            <cfelse>
                                <a target="_blank" href="#request.self#?fuseaction=objects.popup_print_files&print_type=210&iid=#member_id#&keyword=#member_type#&action_date1=#dateformat(attributes.startdate2,dateformat_style)#&action_date2=#dateformat(attributes.finishdate2,dateformat_style)#<cfif len(attributes.startdate)>&date1=#dateformat(attributes.startdate,dateformat_style)#</cfif><cfif len(attributes.finishdate)>&date2=#dateformat(attributes.finishdate,dateformat_style)#</cfif><cfif isdefined("attributes.money_info") and len(attributes.money_info)>&money_info=#attributes.money_info#<cfif isdefined("other_money") and len(other_money)>&money_type_info=#other_money#</cfif></cfif>">
                                <i class="fa fa-print" alt="<cf_get_lang dictionary_id='57474.Yazdir'>" title="<cf_get_lang dictionary_id='57474.Yazdir'>"></i></a>
                            </cfif>
                        </td>
                        <cfif session.ep.our_company_info.sms>
                            <td>
                                <cfif get_member.BAKIYE gt 0>
                                    <cfif kontrol eq 0>
                                        <cfset member_type_sms = 'company'>
                                    <cfelseif kontrol eq 1>
                                        <cfset member_type_sms = 'consumer'>
                                    <cfelseif kontrol eq 2>
                                        <cfset member_type_sms = 'employee'>
                                    </cfif>
                                    <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_form_send_sms&member_type=#member_type_sms#&member_id=#member_id#&sms_action=#fuseaction#');"  alt="<cf_get_lang dictionary_id='58590.SMS Gönder'>" title="<cf_get_lang dictionary_id='58590.SMS Gönder'>"><i class="fa fa-tablet"></i></a>
                                </cfif>
                            </td>
                        </cfif>
                        <td class="text-center">
                            <cfif kontrol eq 0>
                                <cfset member_type_print = 'company'>
                            <cfelseif kontrol eq 1>
                                <cfset member_type_print = 'consumer'>
                            <cfelseif kontrol eq 2>
                                <cfset member_type_print = 'employee'>
                            </cfif>
                            <input type="checkbox" name="print_islem_id" id="print_islem_id#currentrow#" value="#member_id#">
                            <input type="hidden" name="member_type_" id="member_type_#currentrow#" value="#member_type_print#">
                        </td>
                        <cfif isdefined("attributes.duty_claim") && attributes.duty_claim eq 2>
                            <!--- alacaklı üyelerde ödeme emri linki --->
                            <td>
                                <cfif kontrol eq 0>
                                    <cfset odemeemri_link = "#request.self#?fuseaction=finance.list_payment_actions&event=add&acct_type=3&member_id=#member_id#&money_type=#session.ep.money#">
                                <cfelseif kontrol eq 1>
                                    <cfset odemeemri_link = "#request.self#?fuseaction=finance.list_payment_actions&event=add&acct_type=3&consumer_id=#member_id#&money_type=#session.ep.money#">
                                <cfelseif kontrol eq 2>
                                    <cfset odemeemri_link = "#request.self#?fuseaction=finance.list_payment_actions&event=add&acct_type=3&employee_id_new=#member_id#&money_type=#session.ep.money#">
                                <cfelse>
                                    <cfset odemeemri_link ="">
                                </cfif>
                                <a href="#odemeemri_link#" target="_blank">
                                    <span class="font-green-haze icon-money" title="<cf_get_lang dictionary_id='50340.Ödeme Emri'>"></span>
                                </a>
                            </td>
                        </cfif>
                        <!-- sil -->
                    </tr>
                </cfoutput>
                <cfscript>
                    top_alacak_dev = top_alacak_dev + sayfa_toplam_alacak;
                    top_borc_dev = top_borc_dev + sayfa_toplam_borc;
                    top_bakiye_dev = top_borc_dev - top_alacak_dev;
                    top_alacak_dev_2 = top_alacak_dev_2+ sayfa_toplam_alacak_2;
                    top_borc_dev_2 = top_borc_dev_2 + sayfa_toplam_borc_2;
                    top_bakiye_dev_2 = top_borc_dev_2-top_alacak_dev_2;
                    top_ceksenet_ch  = top_ceksenet_ch + sayfa_toplam_ceksenet_ch;
                    top_ceksenet_other  = top_ceksenet_other + sayfa_toplam_ceksenet_other;
                    top_ceksenet_ch2  = top_ceksenet_ch2 + sayfa_toplam_ceksenet_ch2;
                    top_ceksenet_other2  = top_ceksenet_other2 + sayfa_toplam_ceksenet_other2;
                </cfscript>
            </tbody>
                <tfoot>
                    <tr>
                        <td colspan="<cfoutput>#colspan_count#</cfoutput>" class="txtboldblue"><cf_get_lang dictionary_id='57680.Genel Toplam'></td>
                        <cfif not (isDefined("attributes.money_info") and attributes.money_info eq 2) or (isDefined("attributes.money_info") and attributes.money_info eq 2 and x_show_system_money eq 1)>
                            <td class="moneybox"><cfoutput>#TLFormat(top_borc_dev)#</cfoutput></td>
                            <td class="moneybox"><cfoutput>#TLFormat(top_alacak_dev)#</cfoutput></td>
                            <td class="moneybox"><cfoutput>#TLFormat(abs(top_bakiye_dev))#</cfoutput></td>
                            <td class="text-center"><cfif top_borc_dev gt top_alacak_dev>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif top_borc_dev lt top_alacak_dev>(<cf_get_lang dictionary_id='29684.A'>)<cfelse></cfif></td>
                        <cfelse>
                            <td colspan="4"></td>
                        </cfif>
                        <cfif isDefined("attributes.money_info") and not len(attributes.money_info)>
                            <cfif isdefined("attributes.is_pay_cheques")>
                                <cfoutput>
                                    <td class="moneybox">
                                        #TLFormat(abs(top_ceksenet_other))# 
                                    </td>
                                    <td class="text-center">
                                        <cfif top_ceksenet_other gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif>
                                    </td>
                                    <td class="moneybox">
                                        #TLFormat(abs(top_ceksenet_ch))# 
                                    </td>
                                    <td class="text-center">
                                        <cfif top_ceksenet_ch gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif>
                                    </td>
                                    <td class="moneybox">
                                        #TlFormat(abs(top_borc_dev-top_alacak_dev+top_ceksenet))# 
                                    </td>
                                    <td class="text-center">
                                        <cfif (top_borc_dev-top_alacak_dev+top_ceksenet) gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif>
                                    </td>
                                </cfoutput>
                            </cfif>
                        </cfif>
                        <cfif isDefined("attributes.money_info") and len(session.ep.money2) and attributes.money_info eq 1>
                            <td class="moneybox"><cfoutput>#TLFormat(top_borc_dev_2)#</cfoutput></td>
                            <td class="moneybox"><cfoutput>#TLFormat(top_alacak_dev_2)#</cfoutput></td>
                            <td class="moneybox"><cfoutput>#TLFormat(abs(top_bakiye_dev_2))#</cfoutput></td>
                            <td class="text-center"><cfif top_borc_dev_2 gt top_alacak_dev_2>(<cf_get_lang dictionary_id='58591.B'>)<cfelseif top_borc_dev_2 lt top_alacak_dev_2>(<cf_get_lang dictionary_id='29684.A'>)<cfelse></cfif></td>
                            <cfif isdefined("attributes.is_pay_cheques")>
                                <cfoutput>
                                    <td class="moneybox">
                                        #TLFormat(abs(top_ceksenet_other2))# 
                                    </td>
                                    <td class="moneybox">
                                        <cfif top_ceksenet_other2 gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif>
                                    </td>
                                    <td class="moneybox">
                                        #TLFormat(abs(top_ceksenet_ch2))# 
                                    </td>
                                    <td class="text-center">
                                        <cfif top_ceksenet_ch2 gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif>
                                    </td>
                                    <td class="moneybox">
                                        #TlFormat(abs(top_borc_dev_2-top_alacak_dev_2+top_ceksenet2))# 
                                    </td>
                                    <td class="text-center">
                                        <cfif (top_borc_dev_2-top_alacak_dev_2+top_ceksenet2) gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif>
                                    </td>
                                </cfoutput>
                            </cfif>
                        </cfif>
                        <cfif isDefined("attributes.money_info") and attributes.money_info eq 2>
                            <td class="moneybox">
                                <cfoutput query="get_money">
                                    <cfif evaluate('toplam_borc_#money#') neq 0>
                                        #Tlformat(evaluate('toplam_borc_#money#'))#<br/>
                                    </cfif>
                                </cfoutput>
                            </td>
                            <td class="moneybox">
                                <cfoutput query="get_money">
                                    <cfif evaluate('toplam_borc_#money#') neq 0>
                                        #money#<br/>
                                    </cfif>
                                </cfoutput>
                            </td>
                            <td class="moneybox">
                                <cfoutput query="get_money">
                                    <cfif evaluate('toplam_alacak_#money#') neq 0>
                                        #Tlformat(evaluate('toplam_alacak_#money#'))#<br/>
                                    </cfif>
                                </cfoutput>
                            </td>
                            <td class="moneybox">
                                <cfoutput query="get_money">
                                    <cfif evaluate('toplam_alacak_#money#') neq 0>
                                        #money#<br/>
                                    </cfif>
                                </cfoutput>
                            </td>
                            <td class="moneybox">
                                <cfoutput query="get_money">
                                    <cfset bakiye_ = evaluate('toplam_borc_#get_money.money#') - evaluate('toplam_alacak_#get_money.money#')>
                                    <cfif bakiye_ neq 0>
                                        #Tlformat(abs(bakiye_))#<br/>
                                    </cfif>
                                </cfoutput>
                            </td>
                            <td class="moneybox">
                                <cfoutput query="get_money">
                                    <cfset bakiye_ = evaluate('toplam_borc_#get_money.money#') - evaluate('toplam_alacak_#get_money.money#')>
                                    <cfif bakiye_ neq 0>
                                        #get_money.money#<br/>
                                    </cfif>
                                </cfoutput>
                            </td>
                            <td class="text-center">
                                <cfoutput query="get_money">
                                    <cfset bakiye_ = evaluate('toplam_borc_#get_money.money#') - evaluate('toplam_alacak_#get_money.money#')>
                                    <cfif bakiye_ neq 0>
                                        <cfif bakiye_ gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif><br/>
                                    </cfif>
                                </cfoutput>
                            </td>
                            <cfif isdefined("attributes.is_pay_cheques")>
                                <td class="moneybox">
                                    <cfoutput query="get_money">
                                        <cfif evaluate('toplam_ceksenet_other_#money#') neq 0>
                                            #Tlformat(abs(evaluate('toplam_ceksenet_other_#money#')))#<br/>
                                        </cfif>
                                    </cfoutput>
                                </td>
                                <td class="moneybox">
                                    <cfoutput query="get_money">
                                        <cfif evaluate('toplam_ceksenet_other_#money#') neq 0>
                                            #money#<br/>
                                        </cfif>
                                    </cfoutput>
                                </td>
                                <td class="text-center">
                                    <cfoutput query="get_money">
                                        <cfif evaluate('toplam_ceksenet_other_#money#') neq 0>
                                            <cfif evaluate('toplam_ceksenet_other_#money#') gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif><br/>
                                        </cfif>
                                    </cfoutput>
                                </td>
                                <td class="moneybox">
                                    <cfoutput query="get_money">
                                        <cfif evaluate('toplam_ceksenet_ch_#money#') neq 0>
                                            #Tlformat(abs(evaluate('toplam_ceksenet_ch_#money#')))#<br/>
                                        </cfif>
                                    </cfoutput>
                                </td>
                                <td class="moneybox">
                                    <cfoutput query="get_money">
                                        <cfif evaluate('toplam_ceksenet_ch_#money#') neq 0>
                                            #money#<br/>
                                        </cfif>
                                    </cfoutput>
                                </td>
                                <td class="text-center">
                                    <cfoutput query="get_money">
                                        <cfif evaluate('toplam_ceksenet_ch_#money#') neq 0>
                                            <cfif evaluate('toplam_ceksenet_ch_#money#') gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif><br/>
                                        </cfif>
                                    </cfoutput>
                                </td>
                                <td class="moneybox">
                                    <cfoutput query="get_money">
                                        <cfset bakiye_ceksenet= evaluate('toplam_borc_#get_money.money#') - evaluate('toplam_alacak_#get_money.money#')>
                                        <cfif (bakiye_ceksenet - evaluate('toplam_ceksenet_#get_money.money#')) neq 0>
                                            #Tlformat(abs(bakiye_ceksenet + evaluate('toplam_ceksenet_#get_money.money#')))#<br/>
                                        </cfif>
                                    </cfoutput>
                                </td>
                                <td class="moneybox">
                                    <cfoutput query="get_money">
                                        <cfset bakiye_ceksenet= evaluate('toplam_borc_#get_money.money#') - evaluate('toplam_alacak_#get_money.money#')>
                                        <cfif (bakiye_ceksenet - evaluate('toplam_ceksenet_#get_money.money#')) neq 0>
                                            #get_money.money#<br/>
                                        </cfif>
                                    </cfoutput>
                                </td>
                                <td class="text-center">
                                    <cfoutput query="get_money">
                                        <cfset bakiye_ceksenet= evaluate('toplam_borc_#get_money.money#') - evaluate('toplam_alacak_#get_money.money#')>
                                        <cfif (bakiye_ceksenet - evaluate('toplam_ceksenet_#get_money.money#')) neq 0>
                                            <cfif (bakiye_ceksenet + evaluate('toplam_ceksenet_#get_money.money#')) gt 0>(<cf_get_lang dictionary_id='58591.B'>)<cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif><br/>
                                        </cfif>
                                    </cfoutput>
                                </td>
                            </cfif>
                        </cfif>
                        <td class="moneybox">
                            <cfif top_borc_dev gt 0><cfset vade_ort1 = wrk_round((attributes.vade_borc_ara_toplam/top_borc_dev),0)><cfelse><cfset vade_ort1 = 0></cfif>
                            <cfif top_alacak_dev gt 0><cfset vade_ort2 = wrk_round((attributes.vade_alacak_ara_toplam/top_alacak_dev),0)><cfelse><cfset vade_ort2 = 0></cfif>
                            <cfif top_borc_dev+top_alacak_dev neq 0>
                                <cfset attributes.vade_dev = ((vade_ort1 * abs(top_borc_dev)) + (vade_ort2 * abs(top_alacak_dev)))/(abs(top_borc_dev)+abs(top_alacak_dev))>
                                <cfoutput>#TLFormat(((abs(vade_ort1) * abs(top_borc_dev)) + (abs(vade_ort2) * abs(top_alacak_dev)))/(abs(top_borc_dev)+abs(top_alacak_dev)),0)#</cfoutput>
                            <cfelse>
                                <cfset attributes.vade_dev = 0>
                                <cfoutput>#TLFormat(0)#</cfoutput>
                            </cfif>
                        </td>
                        <!-- sil -->
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <cfif isdefined("attributes.duty_claim") && attributes.duty_claim eq 2>
                                <td>&nbsp;</td>
                            </cfif>
                        <!-- sil -->
                    </tr>
                </tfoot>
            <cfelse>
                <tbody>
                    <!-- sil -->
                        <tr>
                            <td height="20" colspan="21"><cfif IsDefined("attributes.is_submitted")><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
                        </tr>
                    <!-- sil -->
                </tbody>    
            </cfif>
        </cf_grid_list>

        <cfif attributes.fuseaction eq '#fusebox.circuit#.list_duty_claim'>
            <cfset adres="#fusebox.circuit#.list_duty_claim&finishdate=#dateformat(attributes.finishdate,dateformat_style)#&startdate=#dateformat(attributes.startdate,dateformat_style)#&finishdate2=#dateformat(attributes.finishdate2,dateformat_style)#&startdate2=#dateformat(attributes.startdate2,dateformat_style)#">
        <cfelse>
            <cfset adres="#fusebox.circuit#.payment_track&finishdate=#dateformat(attributes.finishdate,dateformat_style)#&startdate=#dateformat(attributes.startdate,dateformat_style)#&finishdate2=#dateformat(attributes.finishdate2,dateformat_style)#&startdate2=#dateformat(attributes.startdate2,dateformat_style)#">    
        </cfif>
        <cfif isdefined("attributes.keyword")>
            <cfset adres=adres&'&keyword=#attributes.keyword#'>
        </cfif>
        <cfif isdefined("attributes.ozel_kod")>
            <cfset adres=adres&'&ozel_kod=#attributes.ozel_kod#'>
        </cfif>
        <cfif isdefined("attributes.member_name") and len(attributes.member_name)>
            <cfset adres=adres&'&member_name=#attributes.member_name#'>
            <cfset adres=adres&'&company_id=#attributes.company_id#'>
            <cfset adres=adres&'&consumer_id=#attributes.consumer_id#'>
            <cfset adres=adres&'&employee_id=#attributes.employee_id#'>
            <cfset adres=adres&'&member_type=#attributes.member_type#'>
        </cfif>
        <cfif isdefined('attributes.member_cat_value') and len(attributes.member_cat_value)>
            <cfset adres=adres&'&member_cat_value=#attributes.member_cat_value#'>
        </cfif>
        <cfif isdefined('attributes.pos_code_text') and len(attributes.pos_code)>
            <cfset adres=adres&'&pos_code_text=#attributes.pos_code_text#&pos_code=#attributes.pos_code#'>
        </cfif>
        <cfif isdefined('attributes.order_type') and len(attributes.order_type)>
            <cfset adres=adres&'&order_type=#attributes.order_type#'>
        </cfif>
        <cfif isdefined("attributes.duty_claim")>
            <cfset adres=adres&'&duty_claim=#attributes.duty_claim#'>
        </cfif>
        <cfif isDefined('attributes.customer_value') and len(attributes.customer_value)>
            <cfset adres = adres&"&customer_value="&attributes.customer_value>
        </cfif>
        <cfif isdefined('attributes.city') and len(attributes.city)>
            <cfset adres=adres&'&city=#attributes.city#'>
        </cfif>
        <cfif isdefined('attributes.sales_zones') and len(attributes.sales_zones)>
            <cfset adres=adres&'&sales_zones=#attributes.sales_zones#'>
        </cfif>
        <cfif isdefined('attributes.resource') and len(attributes.resource)>
            <cfset adres=adres&'&resource=#attributes.resource#'>
        </cfif>
        <cfif isdefined('attributes.buy_status') and len(attributes.buy_status)>
            <cfset adres=adres&'&buy_status=#attributes.buy_status#'>
        </cfif>
        <cfif isdefined('attributes.comp_status') and len(attributes.comp_status)>
            <cfset adres=adres&'&comp_status=#attributes.comp_status#'>
        </cfif>
        <cfif isdefined ("attributes.is_submitted") and len(attributes.is_submitted)>
            <cfset adres = adres&'&is_submitted=#attributes.is_submitted#'>
        </cfif>
        <cfif isdefined ("attributes.member_cat_type") and len (attributes.member_cat_type)>
            <cfset adres = adres&'&member_cat_type=#attributes.member_cat_type#'>
        </cfif>
        <cfif isDefined("attributes.money_info") and len(attributes.money_info)>
            <cfset adres = adres&'&money_info=#attributes.money_info#'>
        </cfif>
        <cfif isDefined("attributes.from_rev_collecter") and len (attributes.from_rev_collecter)>
            <cfset adres = adres&'&from_rev_collecter=#attributes.from_rev_collecter#'>
        </cfif>
        <cfif isDefined("attributes.is_zero_bakiye")>
            <cfset adres = adres&'&is_zero_bakiye=#attributes.is_zero_bakiye#'>
        </cfif>
        <cfif isDefined("attributes.is_closed_invoice")>
            <cfset adres = adres&'&is_closed_invoice=#attributes.is_closed_invoice#'>
        </cfif>
        <cfif isDefined("attributes.project_id") and len(attributes.project_id)>
            <cfset adres = adres&'&project_id=#attributes.project_id#'>
        </cfif>
        <cfif isDefined("attributes.project_head") and len(attributes.project_head)>
            <cfset adres = adres&'&project_head=#attributes.project_head#'>
        </cfif>
        <cfif isDefined("attributes.is_pay_cheques")>
            <cfset adres = adres&'&is_pay_cheques=#attributes.is_pay_cheques#'>
        </cfif>
        <cfif isDefined("attributes.is_pay_bankorders")>
            <cfset adres = adres&'&is_pay_bankorders=#attributes.is_pay_bankorders#'>
        </cfif>				
        <cfif isDefined("attributes.is_project_group")>
            <cfset adres = adres&'&is_project_group=#attributes.is_project_group#'>
        </cfif>
        <cfif isDefined("attributes.due_info") and len(attributes.due_info)>
            <cfset adres = adres&'&due_info=#attributes.due_info#'>
        </cfif>
        <cfif isDefined("attributes.vade_dev") and len(attributes.vade_dev)>
            <cfset adres = adres&'&vade_dev=#attributes.vade_dev#'>
        </cfif>
        <cfif isDefined("attributes.is_asset_group")>
            <cfset adres = adres&'&is_asset_group=#attributes.is_asset_group#'>
        </cfif>
        <cfif isDefined("attributes.is_subscription_group")>
            <cfset adres = adres&'&is_subscription_group=#attributes.is_subscription_group#'>
        </cfif>
        <cfif isDefined("attributes.money_type_info") and len (attributes.money_type_info)>
            <cfset adres = adres&'&money_type_info=#attributes.money_type_info#'>
        </cfif>
        <cfif isDefined("attributes.vade_alacak_ara_toplam") and len (attributes.vade_alacak_ara_toplam)>
            <cfset adres = adres&'&vade_alacak_ara_toplam=#attributes.vade_alacak_ara_toplam#'>
        </cfif>
        <cfif isDefined("attributes.vade_borc_ara_toplam") and len (attributes.vade_borc_ara_toplam)>
            <cfset adres = adres&'&vade_borc_ara_toplam=#attributes.vade_borc_ara_toplam#'>
        </cfif>
        <cfif isDefined("attributes.asset_id") and len(attributes.asset_id)>
            <cfset adres = adres&"&asset_id="&attributes.asset_id>
        </cfif>
        <cfif isDefined("attributes.asset_name") and len(attributes.asset_name)>
            <cfset adres = adres&"&asset_name="&attributes.asset_name>
        </cfif>
        <cfif isDefined('attributes.special_definition_type') and len(attributes.special_definition_type)>
            <cfset adres = '#adres#&special_definition_type=#attributes.special_definition_type#'>
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
        <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
            <cfset adres = adres&"&branch_id="&attributes.branch_id>
        </cfif>
        <cfif isdefined("attributes.ims_code_name") and len(attributes.ims_code_name)>
            <cfset adres=adres&'&ims_code_id=#attributes.ims_code_id#&ims_code_name=#attributes.ims_code_name#'>
        </cfif>
        <cfif isdefined("attributes.member_code") and len(attributes.member_code)>
            <cfset adres=adres&'&member_code=#attributes_member_code#'>
        </cfif>
        <cfif isDefined("attributes.icra_takibi") and len(attributes.icra_takibi)>
            <cfset adres=adres&'&icra_takibi=#attributes.icra_takibi#'>
        </cfif>
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
	function kontrol()
	{
		if(document.form_list.member_name.value != "")
		{
			if (document.form_list.company_id.value != '' && document.form_list.member_type.value == 'partner')
			{
				document.form_list.member_cat_value.value=1;		
			}		
			if (document.form_list.consumer_id.value != '' && document.form_list.member_type.value == 'consumer')
			{
				document.form_list.member_cat_value.value=2;		
			}		
			if (document.form_list.employee_id.value != '' && document.form_list.member_type.value == 'employee')
			{
				document.form_list.member_cat_value.value = 5;		
			}		
			return true;	
		}
		else
		{              
		   //BK
		   document.form_list.company_id.value='';
		   document.form_list.consumer_id.value='';
		   document.form_list.employee_id.value='';
		}
		return true;
	}
	function kontrol_project(type)
	{
		if(type == 0)
		{
			if(document.form_list.money_info.value == 2)
				document.form_list.is_project_group.checked = false;
		}	
	}
	function kontrol_project_id(type)
	{
		if(type == 0)
		{
			if(document.form_list.money_info.value == 2)
				document.form_list.no_project.checked = false;
		}	
	}
	function kontrol_asset(type)
	{
		if(type == 0)
		{
			if(document.form_list.money_info.value == 2 && document.form_list.is_asset_group != undefined)
				document.form_list.is_asset_group.checked = false;
		}	
	}
	function kontrol_subscription(type)
	{
		if(type == 0)
		{
			if(document.form_list.money_info.value == 2 && document.form_list.is_subscription_group != undefined)
				document.form_list.is_subscription_group.checked = false;
		}	
	}
	function show_money_type()
	{
		if(document.getElementById('money_info').value == 2)//islem dövizi seçilmisse
			document.getElementById('item-money_type').style.display = '';
		else
		{
			document.getElementById('item-money_type').style.display = 'none';
			document.getElementById('money_type_info').value='';
		}
        if(document.getElementById('money_info').value == 2)
        {
            document.getElementById('is_acc_type_group').disabled = true;
        }
        else
        {
            document.getElementById('is_acc_type_group').disabled = false;
        } 
	}
    function kontrol_acc_type()
    {
        var checkBox = document.getElementById("is_acc_type_group");
        if (checkBox.checked == true)
        {
            document.getElementById('money_info').options[2].disabled = true;
        } 
        else 
        {
            document.getElementById('money_info').options[2].disabled = false;
        }
    }
    kontrol_acc_type();
    show_money_type();
	/* function send_print_(type)
	{
		company_list_ = "";
		consumer_list_ = "";
		employee_list_ = "";
		<cfif not get_member.recordcount>
			alert("<cf_get_lang dictionary_id='36586.Yazdirilacak Belge Bulunamadi! Toplu Print Yapamazsiniz'>!");
			return false;
		<cfelseif get_member.recordcount eq 1>
			if($('input[name="print_islem_id"]:checked').length == 0)
			{
				alert("<cf_get_lang dictionary_id='36586.Yazdirilacak Belge Bulunamadi! Toplu Print Yapamazsiniz'>!");
				return false;
			}
			else
			{
				member_type_list_ = $('#member_type_1').val();
				if (member_type_list_ == 'company')
					company_list_ = $('#print_islem_id1').val();
				else if (member_type_list_ == 'consumer')
					consumer_list_ = $('#print_islem_id1').val();
				else if (member_type_list_ == 'employee')
					employee_list_ = $('#print_islem_id1').val();
				windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&print_type=215&action_id=#URLEncodedFormat(page_code)#</cfoutput>&company_ids='+company_list_+'&consumer_ids='+consumer_list_+'&employee_ids='+employee_list_,'page');
			}
		<cfelseif get_member.recordcount gt 1>
			member_type = "";
			if ($('input[name="print_islem_id"]:checked').length > 0)
			{
				$('input:checkbox[name=print_islem_id]').each(function() 
				{    
					if($(this).is(':checked'))
					{
						i = $(this).attr('id').substring(14);
						member_type = $('#member_type_'+i).val();
						if(member_type == 'company')
							company_list_ = company_list_ + $(this).val() + ',';
						else if(member_type == 'consumer')
							consumer_list_ = consumer_list_ + $(this).val() + ',';
						else if(member_type == 'employee')
							employee_list_ = employee_list_ + $(this).val() + ',';
					}
				});
			}	
			if(company_list_.length == 0 && consumer_list_.length == 0 && employee_list_.length == 0)
			{
				alert("<cf_get_lang dictionary_id='36586.Yazdirilacak Belge Bulunamadi! Toplu Print Yapamazsiniz'>!");
				return false;
			}	
			if (company_list_.length > 0)
			{
				company_list_ = company_list_.substring(0, company_list_.length-1);
			}
			if (consumer_list_.length > 0)
			{
				consumer_list_ = consumer_list_.substring(0, consumer_list_.length-1);
			}
			if (employee_list_.length > 0)
			{
				employee_list_ = employee_list_.substring(0, employee_list_.length-1);
			}																							
			windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&print_type=215&action_id=#URLEncodedFormat(page_code)#</cfoutput>&company_ids='+company_list_+'&consumer_ids='+consumer_list_+'&employee_ids='+employee_list_,'page');
		<cfelse>
			alert("<cf_get_lang dictionary_id='36586.Yazdirilacak Belge Bulunamadi! Toplu Print Yapamazsiniz'>!");
			return false;
		</cfif>
	} */
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
