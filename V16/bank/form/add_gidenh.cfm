<cf_get_lang_set module_name="bank">
<cf_xml_page_edit fuseact="bank.form_add_gidenh">
<cf_papers paper_type="outgoing_transfer">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.project_id" default="">
<cfinclude template="../query/control_bill_no.cfm">
<cfif isdefined("attributes.ID") and len(attributes.ID)>
	<cfif (session.ep.isBranchAuthorization)>
      <cfquery name="get_all_cash" datasource="#dsn2#">
            SELECT CASH_ID FROM CASH WHERE BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#
        </cfquery>
        <cfset cash_list = valuelist(get_all_cash.cash_id)>
        <cfif not listlen(cash_list)><cfset cash_list = 0></cfif>
        <cfset control_branch_id = ListGetAt(session.ep.user_location,2,"-")>
    </cfif>
    <cfquery name="get_gidenh" datasource="#dsn2#">
        SELECT
            BA.*,
            ISNULL(COM.FULLNAME,ISNULL(CON.CONSUMER_NAME +' '+ CON.CONSUMER_SURNAME,E.EMPLOYEE_NAME +' '+ E.EMPLOYEE_SURNAME)) FULLNAME,
            PP.PROJECT_HEAD,
            SA.ACC_TYPE_NAME
        FROM
            BANK_ACTIONS BA
            	LEFT JOIN #dsn_alias#.COMPANY COM ON BA.ACTION_TO_COMPANY_ID = COM.COMPANY_ID
                LEFT JOIN #dsn_alias#.CONSUMER CON ON BA.ACTION_TO_CONSUMER_ID = CON.CONSUMER_ID
                LEFT JOIN #dsn_alias#.EMPLOYEES E ON BA.ACTION_TO_EMPLOYEE_ID = E.EMPLOYEE_ID
                LEFT JOIN #dsn_alias#.PRO_PROJECTS PP ON BA.PROJECT_ID = PP.PROJECT_ID
                LEFT JOIN #dsn_alias#.SETUP_ACC_TYPE SA ON SA.ACC_TYPE_ID = BA.ACC_TYPE_ID
        WHERE
            ACTION_ID=#attributes.ID#
            <cfif (session.ep.isBranchAuthorization)>
            AND                    
            (
                ACTION_TYPE_ID NOT IN (21,22,23) AND
                (FROM_BRANCH_ID = #control_branch_id# OR
                TO_BRANCH_ID = #control_branch_id#)
            )
        	</cfif>
    </cfquery>
    <cfset to_company = get_gidenh.fullname>
    <cfset to_company_id = get_gidenh.ACTION_TO_COMPANY_ID>
    <cfset to_consumer_id = get_gidenh.ACTION_TO_CONSUMER_ID>
    <cfset to_employee_id = get_gidenh.ACTION_TO_EMPLOYEE_ID>
    <cfset from_branch_id = get_gidenh.from_branch_id>    
    <cfset from_account_id = get_gidenh.action_from_account_id>
    <cfset process_cat = get_gidenh.process_cat>
    <cfset to_branch_id = get_gidenh.to_branch_id>
    <cfset special_definition_id = get_gidenh.special_definition_id>
    <cfset acc_department_id = get_gidenh.acc_department_id>
    <cfset project_id = get_gidenh.project_id>
	<cfset project_head = get_gidenh.project_head>
	<cfset assetp_id = get_gidenh.assetp_id>
	<cfset action_date = get_gidenh.action_date>	
	<cfset other_cash_act_value = get_gidenh.other_cash_act_value>
	<cfset masraf = get_gidenh.masraf>
	<cfset expense_center_id = get_gidenh.expense_center_id>
	<cfset expense_item_id = get_gidenh.expense_item_id>
	<cfset other_money_order = get_gidenh.other_money>
    <cfset to_amount = get_gidenh.action_value+get_gidenh.masraf>
    <cfset action_detail = get_gidenh.action_detail>
    <cfset subscription_id = get_gidenh.subscription_id>
    <cfif len(subscription_id)>
        <cfset subscription_no = get_subscription_no(subscription_id)>
    <cfelse>
        <cfset subscription_no = "">
    </cfif>
    <cfif len(get_gidenh.acc_type_id) and len(to_employee_id)>
    	 <cfset to_employee_id &= '_' & get_gidenh.acc_type_id>
         <cfset to_company &= '-' & get_gidenh.acc_type_name>
    </cfif>
<cfelse>
	<cfset from_branch_id = ''>
	<cfset from_account_id = ''>
	<cfset process_cat = ''>
    <cfset to_branch_id = ''>
    <cfset special_definition_id = ''>
    <cfset acc_department_id = ''>
    <cfset project_id = ''>
	<cfset project_head = ''>
	<cfset assetp_id = ''>
	<cfset action_date = now()>
	<cfset other_cash_act_value = ''>
	<cfset masraf = 0>
	<cfset expense_center_id = ''>
	<cfset expense_item_id = ''>
	<cfset other_cash_act_value = ''>
	<cfset other_money_order = ''>
    <cfset to_amount = ''>
    <cfset action_detail = ''>
    <cfset subscription_id = ''>
    <cfset subscription_no = "">
</cfif>
<cfif isdefined("attributes.bank_order_id") and len(attributes.bank_order_id)><!---Banka Talimatlarından eklenen havele için--->
	<cfquery name="get_order" datasource="#dsn2#">
		SELECT 
			BON.*,
			BB.BANK_NAME,
			BB.BANK_BRANCH_NAME,
			A.ACCOUNT_NO,
			A.ACCOUNT_ORDER_CODE,
            SA.ACC_TYPE_NAME,
		<cfif isdefined("attributes.is_company")>
			C.FULLNAME
		<cfelseif isdefined("attributes.is_consumer")>
			C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME AS FULLNAME
        <cfelseif isdefined("attributes.is_employee")>
        	EMP.EMPLOYEE_NAME + ' ' + EMP.EMPLOYEE_SURNAME AS FULLNAME
		</cfif>
		FROM 
			BANK_ORDERS BON
            LEFT JOIN #dsn_alias#.SETUP_ACC_TYPE SA ON SA.ACC_TYPE_ID = BON.ACC_TYPE_ID
			,#dsn3_alias#.ACCOUNTS AS A,
			#dsn3_alias#.BANK_BRANCH AS BB,
		<cfif isdefined("attributes.is_company")>
			#dsn_alias#.COMPANY AS C
		<cfelseif isdefined("attributes.is_consumer")>
			#dsn_alias#.CONSUMER AS C
        <cfelseif isdefined("attributes.is_employee")>
        	#dsn_alias#.EMPLOYEES AS EMP	
		</cfif>
		WHERE 		
			A.ACCOUNT_ID = BON.ACCOUNT_ID AND
			A.ACCOUNT_BRANCH_ID = BB.BANK_BRANCH_ID AND
			BON.BANK_ORDER_ID = #attributes.bank_order_id# AND
		<cfif isdefined("attributes.is_company")>
			C.COMPANY_ID = BON.COMPANY_ID
		<cfelseif isdefined("attributes.is_consumer")>
			C.CONSUMER_ID = BON.CONSUMER_ID
        <cfelseif isdefined("attributes.is_employee")>
        	EMP.EMPLOYEE_ID = BON.EMPLOYEE_ID
		</cfif>
	</cfquery>
 	<cfif len(get_order.special_definition_id)>
    	<cfset special_definition_id=get_order.special_definition_id>
    </cfif>
<cfelseif isdefined("attributes.order_id") and len(attributes.order_id)>
	<cfif isdefined("attributes.to_company_id") and len(attributes.to_company_id)>
		<cfset to_company= get_par_info(attributes.to_company_id,1,1,0)>
		<cfset to_employee="">
		<cfset to_consumer=""> 
	<cfelseif isdefined("attributes.to_employee_id") and len(attributes.to_employee_id)>
		<cfif listlen(attributes.to_employee_id,'_') eq 2>
			<cfset to_employee= get_emp_info(listfirst(attributes.to_employee_id,'_'),0,0,0,listlast(attributes.to_employee_id,'_'))>
		<cfelse>
			<cfset to_employee= get_emp_info(attributes.to_employee_id,0,0)>
		</cfif>
		<cfset to_company= "">
		<cfset to_consumer=""> 
	<cfelseif isdefined("attributes.to_consumer_id") and len(attributes.to_consumer_id)>
		<cfset to_consumer= get_cons_info(attributes.to_consumer_id,0,0)>	
		<cfset to_employee="">
		<cfset to_company="">
	</cfif>
</cfif>

<cfscript>
	if (isdefined("attributes.bank_order_id") and len(attributes.bank_order_id) and get_order.recordcount)//banka talimatından
	{
		bank_order_id = attributes.bank_order_id;
		other_money_order = get_order.OTHER_MONEY;
		from_account_id = get_order.account_id;
		action_date = get_order.PAYMENT_DATE;
		to_amount = get_order.ACTION_VALUE;
		to_company_id = get_order.COMPANY_ID;
		to_consumer_id = get_order.CONSUMER_ID;
		to_employee_id = get_order.EMPLOYEE_ID;
		to_company = get_order.fullname;
		is_disabled = 1;
		action_detail = get_order.action_detail;
		attributes.project_id=get_order.project_id;
		from_branch_id=get_order.from_branch_id;
        subscription_id = get_order.subscription_id;
        if(len(subscription_id))
            subscription_no = get_subscription_no(subscription_id);
        else
            subscription_no = "";
		if(len(get_order.acc_type_id))
		{
			to_employee_id &= '_' & get_order.acc_type_id;
			to_company &= '-' & get_order.acc_type_name;
		}
	}
	else if (isdefined("attributes.order_id") and len(attributes.order_id))//ödeme emirlerinden
	{
		if(isDefined("attributes.action_date"))
			action_date = attributes.action_date;
		else
			action_date = dateformat(now(),dateformat_style);
		to_amount = abs(attributes.ORDER_AMOUNT);
		if (isdefined("attributes.to_company_id") and len(attributes.to_company_id))
		{
			to_company_id = attributes.to_company_id;
			to_consumer_id = "";
			to_employee_id = "";
		}
		from_account_id = "";
		bank_order_id = "";
		if (isdefined("attributes.to_employee_id") and len(attributes.to_employee_id))
		{
			to_employee_id = attributes.to_employee_id;
			to_consumer_id = "";
			to_company_id = "";
		}
		
		if (isdefined("attributes.to_consumer_id") and len(attributes.to_consumer_id))
		{
			to_consumer_id = attributes.to_consumer_id;
			to_employee_id = "";
			to_company_id = "";
		}
		is_disabled = 0;
		other_money_order = '';
	}
	else
	{
		bank_order_id = "";
		is_disabled = 0;
	}
</cfscript>
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
    <cf_box>
        <cfform name="add_gidenh" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_gidenh">
            <input type="hidden" name="ACTION_TYPE" id="ACTION_TYPE" value="<cfoutput>#UCase(getLang('main',423))#</cfoutput>">
            <input type="hidden" name="my_fuseaction" id="my_fuseaction" value="<cfoutput>#fusebox.fuseaction#</cfoutput>">
            <input type="hidden" name="bank_order_id" id="bank_order_id" value="<cfoutput>#bank_order_id#</cfoutput>">
            <input type="hidden" name="bank_order_process_cat" id="bank_order_process_cat" value="<cfif isdefined("attributes.bank_order_id") and len(attributes.bank_order_id)><cfoutput>#get_order.BANK_ORDER_TYPE_ID#</cfoutput></cfif>"> <!--- Banka Talimatı process type --->
            <input type="hidden" name="acc_order_code" id="acc_order_code" value="<cfif isdefined("attributes.bank_order_id") and len(attributes.bank_order_id)><cfoutput>#get_order.ACCOUNT_ORDER_CODE#</cfoutput></cfif>"><!--- Banka Talimat HesaBı Muhasebe Kodu --->
            <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
            <input type="hidden" name="order_id" id="order_id" value="<cfif isdefined("attributes.order_id")><cfoutput>#attributes.order_id#</cfoutput></cfif>"><!--- Ödeme emirlerinden gelip gelmediğini tutuyor --->
            <input type="hidden" name="order_row_id" id="order_row_id" value="<cfif isdefined("attributes.order_row_id")><cfoutput>#attributes.order_row_id#</cfoutput></cfif>"><!--- Ödeme emirlerinden gelip gelmediğini tutuyor --->
            <input type="hidden" name="correspondence_info" id="correspondence_info" value="<cfif isdefined("attributes.correspondence_info")><cfoutput>#attributes.correspondence_info#</cfoutput></cfif>">
            <cf_box_elements>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-process_cat">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.işlem tipi'>*</label>
                            <div class="col col-8 col-xs-12">
                            <cf_workcube_process_cat slct_width="285" process_cat=#process_cat#>
                            </div>
                        </div>
                        <cfif xml_process_stage eq 1>
                            <div class="form-group" id="item-process_stage">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
                                </div>
                            </div>
                        </cfif>
                        <div class="form-group" id="item-from_account_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48706.Banka/Hesap'> *</label>
                            <div class="col col-8 col-xs-12">
                            <cf_wrkBankAccounts width='285' call_function='kur_ekle_f_hesapla' is_disabled='#is_disabled#' selected_value='#from_account_id#' control_status='1'>                                 </div>
                        </div>
                        <cfif isDefined('x_select_branch') and x_select_branch eq 1>
                            <div class="form-group" id="item-branch_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_wrkDepartmentBranch selected_value='#from_branch_id#' fieldId='branch_id' is_branch='1' width='285' is_default='1' is_deny_control='1'>
                                </div>
                            </div> 
                        </cfif>
                        <cfif isDefined("x_select_type_info") and x_select_type_info neq 0>
                            <div class="form-group" id="item-special_definition_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58928.Ödeme Tipi'><cfif x_select_type_info eq 2>*</cfif></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_wrk_special_definition selected_value='#special_definition_id#' width_info='150' type_info='2' field_id="special_definition_id">   
                                </div>
                            </div> 
                        </cfif>
                        <cfif isDefined("x_select_department") and x_select_department eq 1>
                            <div class="form-group" id="item-acc_department_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_wrkDepartmentBranch selected_value='#acc_department_id#' fieldId='acc_department_id' is_department='1' width='150' is_deny_control='0'>
                                </div>
                            </div>
                        </cfif>
                        <div class="form-group" id="item-ACTION_TO_COMPANY_ID">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.cari Hesap'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="EMPLOYEE_ID" id="EMPLOYEE_ID" value="<cfif isdefined("to_employee_id")><cfoutput>#to_employee_id#</cfoutput></cfif>">
                                <input type="hidden" name="ACTION_TO_COMPANY_ID" id="ACTION_TO_COMPANY_ID" value="<cfif isdefined("to_company_id")><cfoutput>#to_company_id#</cfoutput></cfif>">
                                <input type="hidden" name="ACTION_TO_CONSUMER_ID" id="ACTION_TO_CONSUMER_ID" value="<cfif isdefined("to_consumer_id")><cfoutput>#to_consumer_id#</cfoutput></cfif>">
                                <input type="text" name="comp_name" id="comp_name" style="width:150px;" onFocus="AutoComplete_Create('comp_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','get_member_autocomplete','\'1,2,3\',\'<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\',\'1\',\'1\',\'0\'','CONSUMER_ID,COMPANY_ID,EMPLOYEE_ID','ACTION_TO_CONSUMER_ID,ACTION_TO_COMPANY_ID,EMPLOYEE_ID','','3','250','get_money_info(\'add_gidenh\',\'ACTION_DATE\')');" value="<cfif isdefined("to_company") and len(to_company)><cfoutput>#to_company#</cfoutput><cfelseif isdefined("to_consumer") and len(to_consumer)><cfelseif isdefined("to_employee") and len(to_employee)><cfoutput>#to_employee#</cfoutput></cfif>">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&field_comp_id=add_gidenh.ACTION_TO_COMPANY_ID&field_member_name=add_gidenh.comp_name&field_emp_id=add_gidenh.EMPLOYEE_ID&field_name=add_gidenh.comp_name&field_consumer=add_gidenh.ACTION_TO_CONSUMER_ID<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2,3,1,9</cfoutput>','list');"></span>
                            </div>
                        </div>
                        </div>
                        <div class="form-group" id="item-project_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'><cfif isdefined("x_required_project") and x_required_project eq 1>*</cfif></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                            <cfif len(attributes.project_id)>
                                <cfquery name="get_pro_name" datasource="#dsn#">
                                SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID=#attributes.project_id#
                                </cfquery>
                            </cfif>
                            <cfoutput>
                                <input type="hidden"  name="project_id" id="project_id"  value="#project_id#" />
                                <input type="text" style="width:150px" name="project_head" id="project_head" value="#project_head#" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','add_costplan','3','135')" autocomplete="off" />
                            </cfoutput>
                            <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_gidenh.project_id&project_head=add_gidenh.project_head');"></span>
                            </div>
                        </div>
                        </div>
                        <div class="form-group" id="item-subscription_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29502.Abone No'></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_wrk_subscriptions fieldId='subscription_id' fieldName='subscription_no' form_name='add_gidenh' subscription_id='#subscription_id#' subscription_no='#subscription_no#'>
                                </div>
                        </div>
                        <div class="form-group" id="item-asset_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58833.Fiziki Varlık'></label>
                            <div class="col col-8 col-xs-12">
                            <cf_wrkAssetp asset_id="#assetp_id#" fieldId='asset_id' fieldName='asset_name' form_name='add_gidenh'>
                            </div>
                        </div>
                        <div class="form-group" id="item-paper_number">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57880.belge no'> *</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="paper_number" id="paper_number" readonly="readonly" maxlength="50" value="<cfif Len(paper_code)><cfoutput>#paper_code & '-' & paper_number#</cfoutput></cfif>" style="width:150px;">
                        </div>
                        </div>
                        <div class="form-group" id="item-ACTION_DATE">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'> *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfinput value="#dateformat(action_date,dateformat_style)#" maxlength="10" validate="#validate_style#" required="Yes" type="text" name="ACTION_DATE" style="width:150px;" onBlur="change_money_info('add_gidenh','ACTION_DATE','#xml_money_type#');">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="ACTION_DATE" call_function="change_money_info" function_currency_type="#xml_money_type#"></span>
                                </div>
                        </div>
                        </div>
                        <div class="form-group" id="item-ACTION_VALUE">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57673.Tutar'> *</label>
                        <div class="col col-8 col-xs-12">
                            <cfif isdefined("attributes.order_id") and len(attributes.order_id)>
                                <cfinput type="text" name="ACTION_VALUE" readonly="yes" class="moneybox" style="width:150px;" value="#tlformat(to_amount)#" onBlur="kur_ekle_f_hesapla('account_id');" onkeyup="return(FormatCurrency(this,event));">
                            <cfelse>
                                <cfinput type="text" name="ACTION_VALUE" maxlength="51" class="moneybox" style="width:150px;" value="#tlformat(to_amount)#" onBlur="kur_ekle_f_hesapla('account_id');" onkeyup="return(FormatCurrency(this,event));">
                            </cfif>
                        </div>
                        </div>
                        <div class="form-group" id="item-OTHER_CASH_ACT_VALUE">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58056.Dövizli Tutar'></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="OTHER_CASH_ACT_VALUE" maxlength="51" class="moneybox"  style="width:150px;" value="#TLFormat(OTHER_CASH_ACT_VALUE)#" onBlur="kur_ekle_f_hesapla('account_id',true);" onkeyup="return(FormatCurrency(this,event));">
                        </div>
                        </div>
                        <div class="form-group" id="item-ACTION_DETAIL">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="ACTION_DETAIL" id="ACTION_DETAIL"><cfoutput>#action_detail#</cfoutput></textarea>
                        </div>
                        </div>
                        <div class="form-group" id="item-masraf">
                        <label class="col col-8"><cf_get_lang dictionary_id='58930.Masraf'></label>
                        </div>
                        <div class="form-group" id="item-tutar">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57673.Tutar'></label>
                        <div class="col col-8 col-xs-12">
                            <cfif masraf gt 0>
                                <cfinput type="text" name="masraf" maxlength="51" class="moneybox" style="width:150px;" value="#TLFormat(MASRAF)#" onkeyup="return(FormatCurrency(this,event));">
                            <cfelse>
                                <cfinput type="text" name="masraf" maxlength="51" class="moneybox" style="width:150px;" value="" onkeyup="return(FormatCurrency(this,event));">
                            </cfif>   
                        </div>
                        </div>
                        <div class="form-group" id="item-expense_center_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></label>
                        <div class="col col-8 col-xs-12">
                            <cf_wrkExpenseCenter width_info="150" fieldId="expense_center_id" fieldName="expense_center_name" form_name="add_gidenh" expense_center_id="#expense_center_id#" img_info="plus_thin">
                        </div>
                        </div>
                        <div class="form-group" id="item-expense_item_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58234.Bütçe Kalemi'></label>
                        <div class="col col-8 col-xs-12">
                            <cf_wrkExpenseItem width_info="150" fieldId="expense_item_id" fieldName="expense_item_name" form_name="add_gidenh" income_type_info="0" expense_item_id="#expense_item_id#" img_info="plus_thin">
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group">
                        <label class ="col col-12 bold"><cf_get_lang dictionary_id='48714.İşlem Para Br'></label>
                    </div>
                    <cfif isdefined("xml_money_type") and xml_money_type eq 0>
                        <cfset currency_rate_ = 0>
                    <cfelseif isdefined("xml_money_type") and xml_money_type eq 1>
                        <cfset currency_rate_ = 1>
                    <cfelseif isdefined("xml_money_type") and xml_money_type eq 2>
                        <cfset currency_rate_ = 0>
                    </cfif>	  
                    <div class="form-group">
                        <div class="col col-12 scrollContent scroll-x2">
                            <cfscript>f_kur_ekle(rate_purchase : currency_rate_ ,process_type:0,base_value:'ACTION_VALUE',other_money_value:'OTHER_CASH_ACT_VALUE',form_name:'add_gidenh',select_input:'account_id',selected_money='#other_money_order#');</cfscript>
                        </div>
                    </div>
                </div>    			
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-12">
                <cf_workcube_buttons type_format="1" is_upd='0' add_function='kontrol()'>
                </div>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	function kontrol()
	{
		if(!paper_control(add_gidenh.paper_number,'OUTGOING_TRANSFER')) return false;
		if(!chk_process_cat('add_gidenh')) return false;
		if(!check_display_files('add_gidenh')) return false;
		if(!chk_period(document.add_gidenh.ACTION_DATE, 'İşlem')) return false;
		if(!acc_control()) return false;
		kur_ekle_f_hesapla('account_id');//dövizli tutarı silinenler için
        <cfif x_select_type_info eq 2>
            if(document.add_gidenh.special_definition_id.value == "")
            {
                alert("<cf_get_lang dictionary_id='48792.Ödeme Tipi Seçmelisiniz '>!");	
                return false;
            }
        </cfif>	
		if((document.add_gidenh.ACTION_TO_COMPANY_ID.value=="" || document.add_gidenh.EMPLOYEE_ID.VALUE=="" || document.add_gidenh.ACTION_TO_CONSUMER_ID.value=="") && document.getElementById('comp_name').value=='')
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='57519.Cari Hesap'>");
			return false;
        }
        <cfif x_required_project eq 1>
            if(document.add_gidenh.project_id.value == "")
            {
                alert("<cf_get_lang dictionary_id='40045.Proje Seçmelisiniz '>!");	
                return false;
            }
        </cfif>	
		if(document.getElementById('ACTION_VALUE').value == "")
		{
			alert("<cf_get_lang dictionary_id='29535.Tutar Giriniz'>!");
			return false;
		}
		if(document.add_gidenh.masraf.value != "" && document.add_gidenh.masraf.value != 0)//masraf tutarı girildiğindeki kontrol
		{
			if(document.add_gidenh.expense_item_id.value == "" || document.add_gidenh.expense_item_name.value == "")
			{
				alert("<cf_get_lang dictionary_id='58237.Bütçe Kalemi Seçiniz'>!");
				return false;
			}
			if(document.add_gidenh.expense_center_id.value == "" || document.add_gidenh.expense_center_name.value == "")
			{
				alert("<cf_get_lang dictionary_id='58236.Masraf\Gelir Merkezi Seçiniz'>!");
				return false;
			}
        }
      
		if(document.getElementById('account_id').disabled == true)
			document.getElementById('account_id').disabled = false;
		return true;
	}
	kur_ekle_f_hesapla('account_id');
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">

