<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT 
		PROCESS_TYPE,
		IS_CARI,
		IS_ACCOUNT,
		ACTION_FILE_NAME,
		ACTION_FILE_FROM_TEMPLATE,
		IS_ACCOUNT_GROUP
	 FROM 
	 	SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfquery name="getActionDetail" datasource="#dsn2#">
	SELECT MULTI_ACTION_ID FROM CARI_ACTIONS_MULTI WHERE MULTI_ACTION_ID = #attributes.multi_id#
</cfquery>
<cf_date tarih='attributes.action_date'>
<cfscript>
	process_type = get_process_type.process_type;
	account_group = get_process_type.is_account_group;
	for(b=1; b lte attributes.record_num; b=b+1)
		if(evaluate("attributes.row_kontrol#b#") eq 1)
		{
			'attributes.action_value#b#' = filterNum(evaluate('attributes.action_value#b#'));
			'attributes.action_value_other#b#' = filterNum(evaluate('attributes.action_value_other#b#'));
			'attributes.system_amount#b#' = filterNum(evaluate('attributes.system_amount#b#'));
		}
	for(s=1; s lte attributes.kur_say; s=s+1)
	{
		'attributes.txt_rate2_#s#' = filterNum(evaluate('attributes.txt_rate2_#s#'),session.ep.our_company_info.rate_round_num);
		'attributes.txt_rate1_#s#' = filterNum(evaluate('attributes.txt_rate1_#s#'),session.ep.our_company_info.rate_round_num);
	}
</cfscript>
<cf_papers paper_type="debit_claim">
<cfif getActionDetail.recordcount>
    <cflock name="#createUUID()#" timeout="60">			
        <cftransaction>
            <cfquery name="upd_cari_actions_multi" datasource="#dsn2#">
                UPDATE
                    CARI_ACTIONS_MULTI
                SET				
                    PROCESS_CAT = #form.process_cat#,
                    ACTION_TYPE_ID = #process_type#,
                    ACTION_DATE = #attributes.action_date#,
                    IS_ACCOUNT = <cfif get_process_type.is_account eq 1>1<cfelse>0</cfif>,
                    IS_ACCOUNT_TYPE = 13,
                    UPDATE_EMP = #SESSION.EP.USERID#,
                    UPDATE_IP = '#CGI.REMOTE_ADDR#',
                    UPDATE_DATE = #NOW()#
                WHERE
                    MULTI_ACTION_ID = #attributes.multi_id#					
            </cfquery>
            <cfscript>
                currency_multiplier = '';
                if(isDefined('attributes.kur_say') and len(attributes.kur_say))
                    for(mon=1;mon lte attributes.kur_say;mon=mon+1)
                        if( evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
                            currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
            </cfscript>
            <cfset ACTION_CURRENCY_ID = session.ep.money>
            <cfif isdefined("attributes.record_num") and len(attributes.record_num)>
                <cfloop from="1" to="#attributes.record_num#" index="i">
                    <cfscript>
                        attributes.acc_type_id = '';
                        "acc_type_id#i#" = '';
                        if(listlen(evaluate("action_employee_id#i#"),'_') eq 2)
                        {
                            attributes.acc_type_id = listlast(evaluate("action_employee_id#i#"),'_');
                            "acc_type_id#i#" = listlast(evaluate("action_employee_id#i#"),'_');
                            "action_employee_id#i#" = listfirst(evaluate("action_employee_id#i#"),'_');
                        }
                        paper_currency_multiplier = '';
                        if(isDefined('attributes.kur_say') and len(attributes.kur_say))
                            for(mon=1;mon lte attributes.kur_say;mon=mon+1)
                                if( evaluate("attributes.hidden_rd_money_#mon#") is listfirst(evaluate("attributes.money_id#i#"),';'))
                                    paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
                    </cfscript>
                    <cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#") and not isdefined("attributes.act_row_id#i#")><!--- yeni eklenen satırlar --->
                        <cfset paper_number = paper_number + 1>
                        <cfquery name="add_dekont" datasource="#dsn2#">
                            INSERT INTO
                                CARI_ACTIONS
                                (
                                    MULTI_ACTION_ID,
                                    ACTION_NAME,
                                    ACTION_TYPE_ID,
                                    PROCESS_CAT,
                                    ACTION_VALUE,
                                    ACTION_CURRENCY_ID,
                                    OTHER_MONEY,
                                    PROJECT_ID,
                                    OTHER_CASH_ACT_VALUE,
                                    <cfif process_type eq 410 or process_type eq 45>
                                        TO_CMP_ID,								
                                        TO_CONSUMER_ID,
                                        TO_EMPLOYEE_ID,
                                    <cfelse>
                                        FROM_CMP_ID,								
                                        FROM_CONSUMER_ID,
                                        FROM_EMPLOYEE_ID,
                                    </cfif>
                                    ACTION_DETAIL,
                                    ACTION_ACCOUNT_CODE,
                                    ACTION_DATE,
                                    PAPER_NO,
                                    RECORD_EMP,
                                    RECORD_IP,		
                                    RECORD_DATE,
                                    SUBSCRIPTION_ID,
                                    EXPENSE_CENTER_ID,
                                    EXPENSE_ITEM_ID,
                                    INCOME_CENTER_ID,
                                    INCOME_ITEM_ID,
                                    ACC_DEPARTMENT_ID,
                                    ACC_BRANCH_ID,
                                    ASSETP_ID,
                                    CONTRACT_ID,
                                    ACC_TYPE_ID,
                                    RELATION_ACTION_TYPE_ID,
                                    RELATION_ACTION_ID
                                )
                                VALUES
                                (
                                    #attributes.multi_id#,
                                    <cfif process_type eq 410>'#UCase(getLang("main",437))#'<cfelseif process_type eq 420>'#UCase(getLang("main",436))#'<cfelseif process_type eq 45>'#UCase(getLang("main",1483))#'<cfelseif process_type eq 46>'#UCase(getLang("main",1482))#'</cfif>,
                                    <cfif process_type eq 410>41<cfelseif process_type eq 420>42<cfelse>#process_type#</cfif>,
                                    #form.process_cat#,
                                    #evaluate("attributes.action_value#i#")#,
                                    '#ACTION_CURRENCY_ID#',
                                    '#listfirst(evaluate("attributes.money_id#i#"),';')#',
                                    <cfif len(evaluate("attributes.project_head#i#")) and len(evaluate("attributes.project_id#i#"))>#evaluate("attributes.project_id#i#")#<cfelse>NULL</cfif>,
                                    #evaluate("attributes.action_value_other#i#")#,							
                                    <cfif len(evaluate("member_type#i#")) and evaluate("member_type#i#") eq 'partner' and len(evaluate("action_company_id#i#"))>#evaluate("action_company_id#i#")#,<cfelse>NULL,</cfif>
                                    <cfif len(evaluate("member_type#i#")) and evaluate("member_type#i#") eq 'consumer' and len(evaluate("action_consumer_id#i#"))>#evaluate("action_consumer_id#i#")#,<cfelse>NULL,</cfif>
                                    <cfif len(evaluate("member_type#i#")) and evaluate("member_type#i#") eq 'employee' and len(evaluate("action_employee_id#i#"))>#evaluate("action_employee_id#i#")#,<cfelse>NULL,</cfif>
                                    <cfif isDefined("attributes.action_detail#i#") and len(evaluate("attributes.action_detail#i#"))>'#wrk_eval("attributes.action_detail#i#")#',<cfelse>NULL,</cfif>
                                    <cfif isDefined("attributes.action_account_code#i#") and len(evaluate("attributes.action_account_code#i#"))>'#wrk_eval("attributes.action_account_code#i#")#',<cfelse>NULL,</cfif>
                                    #attributes.action_date#,
                                    <cfif isdefined("attributes.paper_number#i#") and len(evaluate("attributes.paper_number#i#"))>'#wrk_eval("attributes.paper_number#i#")#',<cfelse>NULL,</cfif>
                                    #SESSION.EP.USERID#,
                                    '#CGI.REMOTE_ADDR#',
                                    #NOW()#,
                                    <cfif isDefined("attributes.subscription_id#i#") and len(evaluate("attributes.subscription_no#i#")) and len(evaluate("attributes.subscription_id#i#"))>#evaluate("attributes.subscription_id#i#")#<cfelse>NULL</cfif>,	
                                    <cfif isDefined("attributes.expense_center_id#i#") and len(evaluate("attributes.expense_center_name#i#")) and len(evaluate("attributes.expense_center_id#i#"))>#evaluate("attributes.expense_center_id#i#")#<cfelse>NULL</cfif>,
                                    <cfif isDefined("attributes.expense_item_id#i#") and len(evaluate("attributes.expense_item_name#i#")) and len(evaluate("attributes.expense_item_id#i#"))>#evaluate("attributes.expense_item_id#i#")#<cfelse>NULL</cfif>,
                                    <cfif isDefined("attributes.income_center_id#i#") and len(evaluate("attributes.income_center_name#i#")) and len(evaluate("attributes.income_center_id#i#"))>#evaluate("attributes.income_center_id#i#")#<cfelse>NULL</cfif>,
                                    <cfif isDefined("attributes.income_item_id#i#") and len(evaluate("attributes.income_item_name#i#")) and len(evaluate("attributes.income_item_id#i#"))>#evaluate("attributes.income_item_id#i#")#<cfelse>NULL</cfif>,
                                    <cfif isdefined("attributes.acc_department_id") and len(attributes.acc_department_id)>#attributes.acc_department_id#<cfelse>NULL</cfif>,
                                    <cfif isdefined("attributes.acc_branch_id") and len(attributes.acc_branch_id)>#attributes.acc_branch_id#<cfelse>NULL</cfif>,
                                    <cfif isDefined("attributes.asset_id#i#") and len(evaluate("attributes.asset_name#i#")) and len(evaluate("attributes.asset_id#i#"))>#evaluate("attributes.asset_id#i#")#<cfelse>NULL</cfif>,
                                    <cfif isDefined("attributes.contract_id#i#") and len(evaluate("attributes.contract_no#i#")) and len(evaluate("attributes.contract_id#i#"))>#evaluate("attributes.contract_id#i#")#<cfelse>NULL</cfif>,
                                    <cfif isdefined("acc_type_id#i#") and len(evaluate("acc_type_id#i#"))>#evaluate("acc_type_id#i#")#<cfelse>NULL</cfif>,
                                    <cfif isDefined("attributes.related_action_type#i#") and len(evaluate("attributes.related_action_type#i#"))>#evaluate("attributes.related_action_type#i#")#<cfelse>NULL</cfif>,
                                    <cfif isdefined("attributes.related_action_id#i#") and len(evaluate("attributes.related_action_id#i#"))>#evaluate("attributes.related_action_id#i#")#<cfelse>NULL</cfif>
                                )
                        </cfquery>
                        <cfquery name="get_act_id" datasource="#dsn2#">
                            SELECT MAX(ACTION_ID) AS ACTION_ID FROM CARI_ACTIONS
                        </cfquery>
                        <cfscript>
                            from_cmp_id = '';
                            from_consumer_id = '';
                            from_employee_id = '';
                            _branch_id='';
                            if (isdefined("attributes.acc_branch_id") and len(attributes.acc_branch_id))
                                _branch_id =attributes.acc_branch_id;
                            else
                                _branch_id =listgetat(session.ep.user_location,2,'-');
                            if (len(evaluate("action_company_id#i#")) and evaluate("member_type#i#") eq 'partner')
                                from_cmp_id = evaluate("action_company_id#i#");
                            else if (len(evaluate("action_consumer_id#i#")) and evaluate("member_type#i#") eq 'consumer') 
                                from_consumer_id = evaluate("action_consumer_id#i#");
                            else
                                from_employee_id = evaluate("action_employee_id#i#");
                            
                            if(isDefined("attributes.expense_center_id#i#"))
                                exp_center_id = evaluate("attributes.expense_center_id#i#");
                            else
                                exp_center_id = '';
                            
                            if(isDefined("attributes.expense_item_id#i#"))
                                exp_item_id = evaluate("attributes.expense_item_id#i#");
                            else
                                exp_item_id = '';
                                
                            if(isDefined("attributes.income_center_id#i#"))
                                inc_center_id = evaluate("attributes.income_center_id#i#");
                            else
                                inc_center_id = '';
                            
                            if(isDefined("attributes.income_item_id#i#"))
                                inc_item_id = evaluate("attributes.income_item_id#i#");
                            else
                                inc_item_id = '';
                            
                            if(isDefined("attributes.asset_id#i#") and len(evaluate("attributes.asset_name#i#")) and len(evaluate("attributes.asset_id#i#")))
                                asset_id = evaluate("asset_id#i#");
                            else
                                asset_id = '';
                            
                            if(isDefined("attributes.project_id#i#") and len(evaluate("attributes.project_head#i#")) and len(evaluate("attributes.project_id#i#")))
                                project_id_ = evaluate("attributes.project_id#i#");
                            else
                                project_id_ = '';
                            
                            if(isDefined("attributes.subscription_id#i#") and len(evaluate("attributes.subscription_no#i#")) and len(evaluate("attributes.subscription_id#i#")))
                                subscription_id = evaluate("subscription_id#i#");
                            else
                                subscription_id = '';

                            if(isDefined("attributes.acc_department_id#i#") and len(evaluate("attributes.acc_department_id#i#")))
                                acc_department_id = evaluate("acc_department_id#i#");
                            else
                                acc_department_id = '';
                                        
                            if (process_type eq 410 or process_type eq 45)
                            {
                                if(process_type eq 410)
                                {
                                    row_detail_ = UCase(getLang('main',437)); //BORÇ DEKONTU
                                    row_detail_2 = UCase(getLang('main',2713)); //BORÇ DEKONTU MASRAFI
                                    act_value_2 = '';
                                    act_value_other = evaluate("attributes.action_value_other#i#");
                                    pro_type = 41;
                                }
                                else
                                {
                                    row_detail_ = UCase(getLang('main',1483)); //BORÇ KUR DEĞERLEME DEKONTU
                                    row_detail_2 = UCase(getLang('main',2714)); //BORÇ KUR DEĞERLEME DEKONTU MASRAFI
                                    act_value_2 = 0;
                                    act_value_other = 0;
                                    pro_type = 45;
                                }
                                if(get_process_type.is_cari eq 1)
                                {
                                    carici(
                                        action_id : get_act_id.action_id,
                                        islem_belge_no : evaluate("attributes.paper_number#i#"),
                                        process_cat : form.process_cat,
                                        workcube_process_type : pro_type,
                                        action_table : 'CARI_ACTIONS',
                                        islem_tutari : evaluate("attributes.action_value#i#"),
                                        action_currency : session.ep.money,
                                        other_money_value : act_value_other,
                                        other_money : listfirst(evaluate("attributes.money_id#i#"),';'),
                                        islem_tarihi : attributes.action_date,
                                        islem_detay : row_detail_,
                                        action_detail : evaluate("attributes.action_detail#i#"),
                                        to_cmp_id : from_cmp_id,
                                        to_consumer_id : from_consumer_id,
                                        subscription_id : iif((isdefined("subscription_id") and len(subscription_id)),subscription_id,de('')),
                                        to_employee_id : from_employee_id,			
                                        currency_multiplier : currency_multiplier,
                                        account_card_type : 13,
                                        acc_type_id : evaluate("acc_type_id#i#"),
                                        project_id : project_id_,
                                        branch_id:_branch_id,
                                        action_value2 : act_value_2,
                                        assetp_id : asset_id,
                                        rate2:paper_currency_multiplier
                                        );
                                }
                                if(len(inc_center_id) and len(inc_item_id))
                                {
                                    if(len(evaluate("attributes.action_detail#i#")))
                                        action_detail_ = evaluate("attributes.action_detail#i#");
                                    else
                                    {
                                        action_detail_ = row_detail_2;
                                    }
                                        
                                    butceci(
                                        action_id : get_act_id.action_id,
                                        muhasebe_db : dsn2,
                                        is_income_expense : true,
                                        process_type : pro_type,
                                        nettotal : evaluate("attributes.action_value#i#"),
                                        other_money_value : evaluate("attributes.action_value_other#i#"),
                                        action_currency : listfirst(evaluate("attributes.money_id#i#"),';'),
                                        project_id : project_id_,
                                        paper_no : evaluate("attributes.paper_number#i#"),
                                        currency_multiplier : currency_multiplier,
                                        expense_date : attributes.action_date,
                                        expense_center_id : inc_center_id,
                                        expense_item_id : inc_item_id,
                                        detail : action_detail_,
                                        company_id : from_cmp_id,
                                        consumer_id : from_consumer_id,
                                        employee_id : from_employee_id,
                                        branch_id:_branch_id,
                                        insert_type : 1
                                    );
                                }
                            }
                            else
                            {
                                if(isDefined("attributes.subscription_id#i#") and len(evaluate("attributes.subscription_no#i#")) and len(evaluate("attributes.subscription_id#i#")))
                                    subscription_id = evaluate("subscription_id#i#");
                                else
                                    subscription_id = '';
                                if(process_type eq 420)
                                {
                                    row_detail_ = UCase(getLang('main',436));//ALACAK DEKONTU
                                    row_detail_2 = UCase(getLang('main',2715));//ALACAK DEKONTU MASRAFI
                                    act_value_2 = '';
                                    act_value_other = evaluate("attributes.action_value_other#i#");
                                    pro_type = 42;
                                }
                                else
                                {
                                    row_detail_ = UCase(getLang('main',1482));//ALACAK KUR DEĞERLEME DEKONTU
                                    row_detail_2 = UCase(getLang('main',2716));//ALACAK KUR DEĞERLEME DEKONTU MASRAFI
                                    act_value_2 = 0;
                                    act_value_other = 0;
                                    pro_type = 46;
                                }
                                if(get_process_type.is_cari eq 1)
                                {								
                                    carici(
                                        action_id : get_act_id.action_id,
                                        islem_belge_no : evaluate("attributes.paper_number#i#"),
                                        process_cat : form.process_cat,
                                        workcube_process_type : pro_type,
                                        action_table : 'CARI_ACTIONS',
                                        islem_tutari : evaluate("attributes.action_value#i#"),
                                        action_currency : session.ep.money,
                                        other_money_value : act_value_other,
                                        other_money : listfirst(evaluate("attributes.money_id#i#"),';'),
                                        islem_tarihi : attributes.action_date,
                                        islem_detay : row_detail_,
                                        action_detail : evaluate("attributes.action_detail#i#"),
                                        from_cmp_id : from_cmp_id,
                                        subscription_id : iif((isdefined("subscription_id") and len(subscription_id)),subscription_id,de('')),
                                        from_consumer_id : from_consumer_id,
                                        from_employee_id : from_employee_id,			
                                        currency_multiplier : currency_multiplier,
                                        account_card_type : 13,
                                        acc_type_id : evaluate("acc_type_id#i#"),
                                        project_id : project_id_,
                                        from_branch_id : _branch_id,
                                        action_value2 : act_value_2,
                                        assetp_id : asset_id,
                                        rate2:paper_currency_multiplier
                                        );
                                }
                                if(len(exp_center_id) and len(exp_item_id))
                                {
                                    if(len(evaluate("attributes.action_detail#i#")))
                                        action_detail_ = evaluate("attributes.action_detail#i#");
                                    else
                                    {
                                        action_detail_ = row_detail_2;
                                    }
                                        
                                    butceci(
                                        action_id : get_act_id.action_id,
                                        muhasebe_db : dsn2,
                                        is_income_expense : false,
                                        process_type : pro_type,
                                        nettotal : evaluate("attributes.action_value#i#"),
                                        other_money_value : evaluate("attributes.action_value_other#i#"),
                                        action_currency : listfirst(evaluate("attributes.money_id#i#"),';'),
                                        project_id : project_id_,
                                        paper_no : evaluate("attributes.paper_number#i#"),
                                        currency_multiplier : currency_multiplier,
                                        expense_date : attributes.action_date,
                                        expense_center_id : exp_center_id,
                                        expense_item_id : exp_item_id,
                                        detail : action_detail_,
                                        company_id : from_cmp_id,
                                        consumer_id : from_consumer_id,
                                        employee_id : from_employee_id,
                                        branch_id : _branch_id,
                                        insert_type : 1
                                    );
                                }
                            }
                        </cfscript>
                    <cfelseif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#") and isdefined("attributes.act_row_id#i#") and len(evaluate("attributes.act_row_id#i#"))><!--- güncellenecek satırlar --->
                        <cfquery name="upd_dekont" datasource="#dsn2#">
                            UPDATE
                                CARI_ACTIONS
                            SET
                                ACTION_NAME = <cfif process_type eq 410>'#UCase(getLang("main",437))#'<cfelseif process_type eq 420>'#UCase(getLang("main",436))#'<cfelseif process_type eq 45>'#UCase(getLang("main",1483))#'<cfelseif process_type eq 46>'#UCase(getLang("main",1482))#'</cfif>,
                                ACTION_TYPE_ID = <cfif process_type eq 410>41<cfelseif process_type eq 420>42<cfelse>#process_type#</cfif>,
                                ACTION_VALUE = #evaluate("attributes.action_value#i#")#,
                                ACTION_CURRENCY_ID = '#ACTION_CURRENCY_ID#',
                                OTHER_MONEY = '#listfirst(evaluate("attributes.money_id#i#"),';')#',
                                PROJECT_ID = <cfif len(evaluate("attributes.project_head#i#")) and len(evaluate("attributes.project_id#i#"))>#evaluate("attributes.project_id#i#")#<cfelse>NULL</cfif>,
                                OTHER_CASH_ACT_VALUE = #evaluate("attributes.action_value_other#i#")#,
                                <cfif process_type eq 410 or process_type eq 45>
                                    TO_CMP_ID = <cfif len(evaluate("member_type#i#")) and evaluate("member_type#i#") eq 'partner' and len(evaluate("action_company_id#i#"))>#evaluate("action_company_id#i#")#,<cfelse>NULL,</cfif>							
                                    TO_CONSUMER_ID = <cfif len(evaluate("member_type#i#")) and evaluate("member_type#i#") eq 'consumer' and len(evaluate("action_consumer_id#i#"))>#evaluate("action_consumer_id#i#")#,<cfelse>NULL,</cfif>
                                    TO_EMPLOYEE_ID = <cfif len(evaluate("member_type#i#")) and evaluate("member_type#i#") eq 'employee' and len(evaluate("action_employee_id#i#"))>#evaluate("action_employee_id#i#")#,<cfelse>NULL,</cfif>
                                <cfelse>
                                    FROM_CMP_ID = <cfif len(evaluate("member_type#i#")) and evaluate("member_type#i#") eq 'partner' and len(evaluate("action_company_id#i#"))>#evaluate("action_company_id#i#")#,<cfelse>NULL,</cfif>							
                                    FROM_CONSUMER_ID = <cfif len(evaluate("member_type#i#")) and evaluate("member_type#i#") eq 'consumer' and len(evaluate("action_consumer_id#i#"))>#evaluate("action_consumer_id#i#")#,<cfelse>NULL,</cfif>
                                    FROM_EMPLOYEE_ID = <cfif len(evaluate("member_type#i#")) and evaluate("member_type#i#") eq 'employee' and len(evaluate("action_employee_id#i#"))>#evaluate("action_employee_id#i#")#,<cfelse>NULL,</cfif>
                                </cfif>
                                ACTION_DETAIL = <cfif isDefined("attributes.action_detail#i#") and len(evaluate("attributes.action_detail#i#"))>'#wrk_eval("attributes.action_detail#i#")#',<cfelse>NULL,</cfif>
                                ACTION_ACCOUNT_CODE = <cfif isDefined("attributes.action_account_code#i#") and len(evaluate("attributes.action_account_code#i#"))>'#wrk_eval("attributes.action_account_code#i#")#',<cfelse>NULL,</cfif>
                                ACTION_DATE = #attributes.action_date#,
                                PAPER_NO = <cfif isdefined("attributes.paper_number#i#") and len(evaluate("attributes.paper_number#i#"))>'#wrk_eval("attributes.paper_number#i#")#',<cfelse>NULL,</cfif>
                                SUBSCRIPTION_ID = <cfif isDefined("attributes.subscription_id#i#") and len(evaluate("attributes.subscription_no#i#")) and len(evaluate("attributes.subscription_id#i#"))>#evaluate("attributes.subscription_id#i#")#<cfelse>NULL</cfif>,
                                UPDATE_EMP = #SESSION.EP.USERID#,
                                UPDATE_IP = '#CGI.REMOTE_ADDR#',		
                                UPDATE_DATE = #NOW()#,
                                EXPENSE_CENTER_ID = <cfif isDefined("attributes.expense_center_id#i#") and len(evaluate("attributes.expense_center_name#i#")) and len(evaluate("attributes.expense_center_id#i#"))>#evaluate("attributes.expense_center_id#i#")#<cfelse>NULL</cfif>,
                                EXPENSE_ITEM_ID = <cfif isDefined("attributes.expense_item_id#i#") and len(evaluate("attributes.expense_item_name#i#")) and len(evaluate("attributes.expense_item_id#i#"))>#evaluate("attributes.expense_item_id#i#")#<cfelse>NULL</cfif>,
                                INCOME_CENTER_ID = <cfif isDefined("attributes.income_center_id#i#") and len(evaluate("attributes.income_center_name#i#")) and len(evaluate("attributes.income_center_id#i#"))>#evaluate("attributes.income_center_id#i#")#<cfelse>NULL</cfif>,
                                INCOME_ITEM_ID = <cfif isDefined("attributes.income_item_id#i#") and len(evaluate("attributes.income_item_name#i#")) and len(evaluate("attributes.income_item_id#i#"))>#evaluate("attributes.income_item_id#i#")#<cfelse>NULL</cfif>,
                                ASSETP_ID = <cfif isDefined("attributes.asset_id#i#") and len(evaluate("attributes.asset_name#i#")) and len(evaluate("attributes.asset_id#i#"))>#evaluate("attributes.asset_id#i#")#<cfelse>NULL</cfif>,
                                ACC_DEPARTMENT_ID = <cfif isdefined("attributes.acc_department_id") and len(attributes.acc_department_id)>#attributes.acc_department_id#<cfelse>NULL</cfif>,
                                ACC_BRANCH_ID=<cfif isdefined("attributes.acc_branch_id") and len(attributes.acc_branch_id)>#attributes.acc_branch_id#<cfelse>NULL</cfif>,
                                CONTRACT_ID = <cfif isDefined("attributes.contract_id#i#") and len(evaluate("attributes.contract_no#i#")) and len(evaluate("attributes.contract_id#i#"))>#evaluate("attributes.contract_id#i#")#<cfelse>NULL</cfif>,
                                ACC_TYPE_ID = <cfif isdefined("acc_type_id#i#") and len(evaluate("acc_type_id#i#"))>#evaluate("acc_type_id#i#")#<cfelse>NULL</cfif>
                            WHERE 
                                MULTI_ACTION_ID = #attributes.multi_id# AND
                                ACTION_ID = #evaluate("attributes.act_row_id#i#")#
                        </cfquery>
                        <cfscript>						
                            from_cmp_id = '';
                            from_consumer_id = '';
                            from_employee_id = '';
                            _branch_id='';
                            if (isdefined("attributes.acc_branch_id") and len(attributes.acc_branch_id))
                                _branch_id = attributes.acc_branch_id;
                            else
                                _branch_id = listgetat(session.ep.user_location,2,'-');
                            if (len(evaluate("action_company_id#i#")) and evaluate("member_type#i#") eq 'partner')
                                from_cmp_id = evaluate("action_company_id#i#");
                            else if (len(evaluate("action_consumer_id#i#")) and evaluate("member_type#i#") eq 'consumer') 
                                from_consumer_id = evaluate("action_consumer_id#i#");
                            else
                                from_employee_id = evaluate("action_employee_id#i#");
                            
                            if(isDefined("attributes.expense_center_id#i#"))
                                exp_center_id = evaluate("attributes.expense_center_id#i#");
                            else
                                exp_center_id = '';
                            
                            if(isDefined("attributes.expense_item_id#i#"))
                                exp_item_id = evaluate("attributes.expense_item_id#i#");
                            else
                                exp_item_id = '';
                                
                            if(isDefined("attributes.income_center_id#i#"))
                                inc_center_id = evaluate("attributes.income_center_id#i#");
                            else
                                inc_center_id = '';
                            
                            if(isDefined("attributes.income_item_id#i#"))
                                inc_item_id = evaluate("attributes.income_item_id#i#");
                            else
                                inc_item_id = '';
                            
                            if(isDefined("attributes.asset_id#i#") and len(evaluate("attributes.asset_name#i#")) and len(evaluate("attributes.asset_id#i#")))
                                asset_id = evaluate("asset_id#i#");
                            else
                                asset_id = '';
                                
                            if(isDefined("attributes.project_id#i#") and len(evaluate("attributes.project_head#i#")) and len(evaluate("attributes.project_id#i#")))
                                project_id_ = evaluate("attributes.project_id#i#");
                            else
                                project_id_ = '';
                                
                            if(isDefined("attributes.acc_department_id#i#") and len(evaluate("attributes.acc_department_id#i#")))
                                acc_department_id = evaluate("acc_department_id#i#");
                            else
                                acc_department_id = '';
                            
                            //Eski işlem tipine göre masraf kaydını siler
                            if(form.old_process_type eq 410)
                            {
                                butce_sil(action_id:evaluate("attributes.act_row_id#i#"),process_type:41);
                                old_p_type = 41;
                            }
                            else if(form.old_process_type eq 420)
                            {
                                butce_sil(action_id:evaluate("attributes.act_row_id#i#"),process_type:42);
                                old_p_type = 42;
                            }
                            else if(form.old_process_type eq 45)
                            {
                                butce_sil(action_id:evaluate("attributes.act_row_id#i#"),process_type:45);
                                old_p_type = 45;
                            }
                            else
                            {
                                butce_sil(action_id:evaluate("attributes.act_row_id#i#"),process_type:46);
                                old_p_type = 46;
                            }

                            if(isDefined("attributes.subscription_id#i#") and len(evaluate("attributes.subscription_no#i#")) and len(evaluate("attributes.subscription_id#i#")))
                                subscription_id = evaluate("subscription_id#i#");
                            else
                                subscription_id = '';
                            
                            if (process_type eq 410 or process_type eq 45)
                            {
                                if(process_type eq 410)
                                {
                                    row_detail_ = UCase(getLang('main',437)); //BORÇ DEKONTU
                                    row_detail_2 = UCase(getLang('main',2713)); //BORÇ DEKONTU MASRAFI
                                    act_value_2 = '';
                                    act_value_other = evaluate("attributes.action_value_other#i#");
                                    pro_type = 41;
                                }
                                else
                                {
                                    row_detail_ = UCase(getLang('main',1483)); //BORÇ KUR DEĞERLEME DEKONTU
                                    row_detail_2 = UCase(getLang('main',2714)); //BORÇ KUR DEĞERLEME DEKONTU MASRAFI
                                    act_value_2 = 0;
                                    act_value_other = 0;
                                    pro_type = 45;
                                }
                                if(get_process_type.is_cari eq 1)
                                {									
                                    carici(
                                        action_id : evaluate("attributes.act_row_id#i#"),
                                        islem_belge_no : evaluate("attributes.paper_number#i#"),
                                        process_cat : form.process_cat,
                                        workcube_process_type : pro_type,
                                        workcube_old_process_type : old_p_type,
                                        action_table : 'CARI_ACTIONS',
                                        islem_tutari : evaluate("attributes.action_value#i#"),
                                        action_currency : session.ep.money,
                                        other_money_value : act_value_other,
                                        other_money : listfirst(evaluate("attributes.money_id#i#"),';'),
                                        islem_tarihi : attributes.action_date,
                                        islem_detay : row_detail_,
                                        action_detail : evaluate("attributes.action_detail#i#"),
                                        to_cmp_id : from_cmp_id,
                                        to_consumer_id : from_consumer_id,
                                        subscription_id : iif((isdefined("subscription_id") and len(subscription_id)),subscription_id,de('')),
                                        to_employee_id : from_employee_id,
                                        from_cmp_id : '',
                                        from_consumer_id : '',
                                        from_employee_id : '',			
                                        currency_multiplier : '',
                                        account_card_type : 13,
                                        acc_type_id : evaluate("acc_type_id#i#"),
                                        project_id : project_id_,
                                        to_branch_id:_branch_id,
                                        action_value2 : act_value_2,
                                        assetp_id : asset_id,
                                        rate2:paper_currency_multiplier
                                        );
                                }
                                else
                                    cari_sil(action_id:evaluate("attributes.act_row_id#i#"),process_type:old_p_type);
                                if(len(inc_center_id) and len(inc_item_id))
                                {
                                    if(len(evaluate("attributes.action_detail#i#")))
                                        action_detail_ = evaluate("attributes.action_detail#i#");
                                    else
                                    {
                                        action_detail_ = row_detail_2;
                                    }
                                        
                                    butceci(
                                        action_id : evaluate("attributes.act_row_id#i#"),
                                        muhasebe_db : dsn2,
                                        is_income_expense : true,
                                        process_type : pro_type,
                                        nettotal : evaluate("attributes.action_value#i#"),
                                        other_money_value : evaluate("attributes.action_value_other#i#"),
                                        action_currency : listfirst(evaluate("attributes.money_id#i#"),';'),
                                        project_id : project_id_,
                                        paper_no : evaluate("attributes.paper_number#i#"),
                                        currency_multiplier : currency_multiplier,
                                        expense_date : attributes.action_date,
                                        expense_center_id : inc_center_id,
                                        expense_item_id : inc_item_id,
                                        detail : action_detail_,
                                        company_id : from_cmp_id,
                                        consumer_id : from_consumer_id,
                                        employee_id : from_employee_id,
                                        branch_id : _branch_id,
                                        insert_type : 1
                                    );
                                }
                            }
                            else
                            {
                                if(isDefined("attributes.subscription_id#i#") and len(evaluate("attributes.subscription_no#i#")) and len(evaluate("attributes.subscription_id#i#")))
                                    subscription_id = evaluate("subscription_id#i#");
                                else
                                    subscription_id = '';
                                if(process_type eq 420)
                                {
                                    row_detail_ = UCase(getLang('main',436));//ALACAK DEKONTU
                                    row_detail_2 = UCase(getLang('main',2715));//ALACAK DEKONTU MASRAFI
                                    act_value_2 = '';
                                    act_value_other = evaluate("attributes.action_value_other#i#");
                                    pro_type = 42;
                                }
                                else
                                {
                                    row_detail_ = UCase(getLang('main',1482));//ALACAK KUR DEĞERLEME DEKONTU
                                    row_detail_2 = UCase(getLang('main',2716));//ALACAK KUR DEĞERLEME DEKONTU MASRAFI
                                    act_value_2 = 0;
                                    act_value_other = 0;
                                    pro_type = 46;
                                }
                                if(get_process_type.is_cari eq 1)
                                {								
                                    carici(
                                        action_id : evaluate("attributes.act_row_id#i#"),
                                        islem_belge_no : evaluate("attributes.paper_number#i#"),
                                        process_cat : form.process_cat,
                                        workcube_process_type : pro_type,
                                        workcube_old_process_type : old_p_type,
                                        action_table : 'CARI_ACTIONS',
                                        islem_tutari : evaluate("attributes.action_value#i#"),
                                        action_currency : session.ep.money,
                                        other_money_value : act_value_other,
                                        other_money : listfirst(evaluate("attributes.money_id#i#"),';'),
                                        islem_tarihi : attributes.action_date,
                                        islem_detay : row_detail_,
                                        action_detail : evaluate("attributes.action_detail#i#"),
                                        from_cmp_id : from_cmp_id,
                                        from_consumer_id : from_consumer_id,
                                        from_employee_id : from_employee_id,	
                                        subscription_id : iif((isdefined("subscription_id") and len(subscription_id)),subscription_id,de('')),		
                                        to_cmp_id : '',
                                        to_consumer_id : '',
                                        to_employee_id : '',
                                        currency_multiplier : currency_multiplier,
                                        account_card_type : 13,
                                        acc_type_id : evaluate("acc_type_id#i#"),
                                        project_id : project_id_,
                                        from_branch_id : _branch_id,
                                        action_value2 : act_value_2,
                                        assetp_id : asset_id,
                                        rate2:paper_currency_multiplier							
                                        );
                                }
                                else
                                    cari_sil(action_id:evaluate("attributes.act_row_id#i#"),process_type:old_p_type);
                                if(len(exp_center_id) and len(exp_item_id))
                                {
                                    if(len(evaluate("attributes.action_detail#i#")))
                                        action_detail_ = evaluate("attributes.action_detail#i#");
                                    else
                                    {
                                        action_detail_ = row_detail_2;
                                    }
                                        
                                    butceci(
                                        action_id : evaluate("attributes.act_row_id#i#"),
                                        muhasebe_db : dsn2,
                                        is_income_expense : false,
                                        process_type : pro_type,
                                        nettotal : evaluate("attributes.action_value#i#"),
                                        other_money_value : evaluate("attributes.action_value_other#i#"),
                                        action_currency : listfirst(evaluate("attributes.money_id#i#"),';'),
                                        project_id : project_id_,
                                        paper_no : evaluate("attributes.paper_number#i#"),
                                        currency_multiplier : currency_multiplier,
                                        expense_date : attributes.action_date,
                                        expense_center_id : exp_center_id,
                                        expense_item_id : exp_item_id,
                                        detail : action_detail_,
                                        company_id : from_cmp_id,
                                        consumer_id : from_consumer_id,
                                        employee_id : from_employee_id,
                                        branch_id : _branch_id,
                                        insert_type : 1
                                    );
                                }
                            }
                        </cfscript>
                    <cfelseif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#") eq 0 and isdefined("attributes.act_row_id#i#") and len(evaluate("attributes.act_row_id#i#"))><!--- satır silmeler --->
                        <cfquery name="del_dekont" datasource="#dsn2#">
                            DELETE FROM CARI_ACTIONS WHERE MULTI_ACTION_ID = #attributes.multi_id# AND ACTION_ID = #evaluate("attributes.act_row_id#i#")#
                        </cfquery>
                        <cfscript>
                            if(form.old_process_type eq 410)
                            {
                                cari_sil(action_id:evaluate("attributes.act_row_id#i#"),process_type:41);
                                butce_sil(action_id:evaluate("attributes.act_row_id#i#"),process_type:41);
                            }
                            else if(form.old_process_type eq 420)
                            {
                                cari_sil(action_id:evaluate("attributes.act_row_id#i#"),process_type:42);
                                butce_sil(action_id:evaluate("attributes.act_row_id#i#"),process_type:42);
                            }
                            else if(form.old_process_type eq 45)
                            {
                                cari_sil(action_id:evaluate("attributes.act_row_id#i#"),process_type:45);
                                butce_sil(action_id:evaluate("attributes.act_row_id#i#"),process_type:45);
                            }
                            else
                            {
                                cari_sil(action_id:evaluate("attributes.act_row_id#i#"),process_type:46);
                                butce_sil(action_id:evaluate("attributes.act_row_id#i#"),process_type:46);
                            }
                        </cfscript>
                    </cfif>
                </cfloop>
            </cfif>
            <cfscript>
                if(get_process_type.is_account eq 1)
                {
                    borc_hesap_list='';
                    alacak_hesap_list='';
                    borc_tutar_list ='';
                    alacak_tutar_list = '';
                    doviz_tutar_borc = '';
                    doviz_tutar_alacak = '';
                    doviz_currency_borc = '';
                    doviz_currency_alacak = '';
                    acc_project_list_borc = '';
                    acc_project_list_alacak = '';
                    satir_detay_list = ArrayNew(2);
                    if(isdefined('attributes.acc_department_id') and len(attributes.acc_department_id) )
                        acc_department_id = attributes.acc_department_id;
                    else
                        acc_department_id = '';
                    if (process_type eq 410 or process_type eq 45)
                    {
                        if( isdefined("attributes.record_num") and len(attributes.record_num) )
                        {
                            if(process_type eq 45)
                                detail_ = UCase(getLang('main',2717));//BORÇ KUR DEĞERLEME
                            else
                                detail_ = UCase(getLang('main',1773));//TOPLU BORÇ DEKONTU
                            for(k=1; k lte attributes.record_num; k=k+1)
                                if( isdefined("attributes.row_kontrol#k#") and evaluate("attributes.row_kontrol#k#") eq 1 and len(evaluate("attributes.action_account_code#k#")))
                                {
                                    if(len(evaluate("action_company_id#k#")) and len(evaluate("member_type#k#")) and evaluate("member_type#k#") eq 'partner')
                                        my_acc_result = GET_COMPANY_PERIOD(evaluate("action_company_id#k#"));
                                    else if(len(evaluate("action_consumer_id#k#")) and len(evaluate("member_type#k#")) and evaluate("member_type#k#") eq 'consumer')
                                        my_acc_result = GET_CONSUMER_PERIOD(evaluate("action_consumer_id#k#"));
                                    else
                                        my_acc_result = GET_EMPLOYEE_PERIOD(evaluate("action_employee_id#k#"),evaluate("acc_type_id#k#"));
                                    
                                    alacak_hesap_list = listappend(alacak_hesap_list,evaluate("attributes.action_account_code#k#"),',');
                                    borc_hesap_list = listappend(borc_hesap_list,my_acc_result,',');
                                    
                                    borc_tutar_list = listappend(borc_tutar_list,evaluate("attributes.action_value#k#"),',');
                                    doviz_tutar_borc = listappend(doviz_tutar_borc,evaluate("attributes.action_value_other#k#"),',');
                                    doviz_currency_borc = listappend(doviz_currency_borc,listfirst(evaluate("attributes.money_id#k#"),';'),',');
                                    if(account_group neq 1)
                                    {
                                        if (len(evaluate("attributes.action_detail#k#")))
                                            satir_detay_list[1][listlen(borc_tutar_list)]='#evaluate("attributes.comp_name#k#")# - #evaluate("attributes.action_detail#k#")#';
                                        else
                                        {
                                            if(process_type eq 45)
                                                satir_detay_list[1][listlen(borc_tutar_list)]='#evaluate("attributes.comp_name#k#")# - ' & UCase(getLang('main',2717));
                                            else
                                                satir_detay_list[1][listlen(borc_tutar_list)]='#evaluate("attributes.comp_name#k#")# - ' & UCase(getLang('main',1773));
                                        }
                                    }
                                    else
                                        satir_detay_list[1][listlen(borc_tutar_list)]=detail_;
                                
                                    alacak_tutar_list = listappend(alacak_tutar_list,evaluate("attributes.action_value#k#"));
                                    doviz_tutar_alacak = listappend(doviz_tutar_alacak,evaluate("attributes.action_value_other#k#"),',');
                                    doviz_currency_alacak = listappend(doviz_currency_alacak,listfirst(evaluate("attributes.money_id#k#"),';'),',');
                                    
                                    if(account_group neq 1)
                                    {
                                        if (len(evaluate("attributes.action_detail#k#")))
                                            satir_detay_list[2][listlen(alacak_tutar_list)]='#evaluate("attributes.comp_name#k#")# - #evaluate("attributes.action_detail#k#")#';
                                        else
                                        {
                                            if(process_type eq 45)
                                                satir_detay_list[2][listlen(alacak_tutar_list)]='#evaluate("attributes.comp_name#k#")# - ' & UCase(getLang('main',2717));
                                            else
                                                satir_detay_list[2][listlen(alacak_tutar_list)]='#evaluate("attributes.comp_name#k#")# - ' & UCase(getLang('main',1773));
                                        }
                                    }
                                    else
                                        satir_detay_list[2][listlen(alacak_tutar_list)]=detail_;
                                    /* acc_project_id muhasebeciye kaydediliyor */
                                    if(isdefined("attributes.project_id#k#") and len(evaluate("attributes.project_id#k#")) and len(evaluate("attributes.project_head#k#")))
                                    {
                                        acc_project_list_alacak = listappend(acc_project_list_alacak,evaluate("attributes.project_id#k#"),',');
                                        acc_project_list_borc = listappend(acc_project_list_borc,evaluate("attributes.project_id#k#"),',');
                                    }
                                    else
                                    {
                                        acc_project_list_alacak = listappend(acc_project_list_alacak,0,',');
                                        acc_project_list_borc = listappend(acc_project_list_borc,0,',');
                                    }	
                                }
                                muhasebeci (
                                    action_id: attributes.multi_id,
                                    workcube_process_type: process_type,
                                    workcube_old_process_type:form.old_process_type,
                                    workcube_process_cat:form.process_cat,
                                    account_card_type: 13,
                                    acc_department_id:acc_department_id,
                                    islem_tarihi: attributes.action_date,
                                    fis_satir_detay: satir_detay_list,
                                    borc_hesaplar: borc_hesap_list,
                                    borc_tutarlar: borc_tutar_list,
                                    other_amount_borc : doviz_tutar_borc,
                                    other_currency_borc : doviz_currency_borc,
                                    alacak_hesaplar: alacak_hesap_list,
                                    alacak_tutarlar: alacak_tutar_list,
                                    other_amount_alacak : doviz_tutar_alacak,
                                    other_currency_alacak : doviz_currency_alacak,
                                    currency_multiplier : currency_multiplier,
                                    to_branch_id:_branch_id,
                                    fis_detay: detail_,
                                    acc_project_list_alacak : acc_project_list_alacak,
                                    acc_project_list_borc : acc_project_list_borc,
                                    is_account_group : account_group
                                );
                        }
                    }
                    else
                    {
                        if( isdefined("attributes.record_num") and len(attributes.record_num) )
                        {
                            if(process_type eq 46)
                                detail_ = UCase(getLang('main',2718));//ALACAK KUR DEĞERLEME
                            else
                                detail_ = UCase(getLang('main',1774));//TOPLU ALACAK DEKONTU
                            for(k=1; k lte attributes.record_num; k=k+1)
                                if( isdefined("attributes.row_kontrol#k#") and evaluate("attributes.row_kontrol#k#") eq 1 and len(evaluate("attributes.action_account_code#k#")))
                                {
                                    if(len(evaluate("action_company_id#k#")) and len(evaluate("member_type#k#")) and evaluate("member_type#k#") eq 'partner')
                                        my_acc_result = GET_COMPANY_PERIOD(evaluate("action_company_id#k#"));
                                    else if(len(evaluate("action_consumer_id#k#")) and len(evaluate("member_type#k#")) and evaluate("member_type#k#") eq 'consumer')
                                        my_acc_result = GET_CONSUMER_PERIOD(evaluate("action_consumer_id#k#"));
                                    else
                                        my_acc_result = GET_EMPLOYEE_PERIOD(evaluate("action_employee_id#k#"),evaluate("acc_type_id#k#"));
                                    
                                    borc_hesap_list = listappend(borc_hesap_list,evaluate("attributes.action_account_code#k#"),',');
                                    alacak_hesap_list = listappend(alacak_hesap_list,my_acc_result,',');
                                    borc_tutar_list = listappend(borc_tutar_list,evaluate("attributes.action_value#k#"),',');
                                    doviz_tutar_borc = listappend(doviz_tutar_borc,evaluate("attributes.action_value_other#k#"),',');
                                    doviz_currency_borc = listappend(doviz_currency_borc,listfirst(evaluate("attributes.money_id#k#"),';'),',');
                                    
                                    if(account_group neq 1)
                                    {
                                        if (len(evaluate("attributes.action_detail#k#")))
                                            satir_detay_list[1][listlen(borc_tutar_list)]='#evaluate("attributes.comp_name#k#")# - #evaluate("attributes.action_detail#k#")#';
                                        else
                                        {
                                            if(process_type eq 46)
                                                satir_detay_list[1][listlen(borc_tutar_list)]='#evaluate("attributes.comp_name#k#")# - ' & UCase(getLang('main',2718));
                                            else
                                                satir_detay_list[1][listlen(borc_tutar_list)]='#evaluate("attributes.comp_name#k#")# - ' & UCase(getLang('main',1774));
                                        }
                                    }
                                    else
                                        satir_detay_list[1][listlen(borc_tutar_list)]=detail_;
                                        
                                    alacak_tutar_list = listappend(alacak_tutar_list,evaluate("attributes.action_value#k#"));
                                    doviz_tutar_alacak = listappend(doviz_tutar_alacak,evaluate("attributes.action_value_other#k#"),',');
                                    doviz_currency_alacak = listappend(doviz_currency_alacak,listfirst(evaluate("attributes.money_id#k#"),';'),',');
                                    
                                    if(account_group neq 1)
                                    {
                                        if (len(evaluate("attributes.action_detail#k#")))
                                            satir_detay_list[2][listlen(alacak_tutar_list)]='#evaluate("attributes.comp_name#k#")# - #evaluate("attributes.action_detail#k#")#';
                                        else
                                        {									
                                            if(process_type eq 46)
                                                satir_detay_list[2][listlen(alacak_tutar_list)]='#evaluate("attributes.comp_name#k#")# - ' & UCase(getLang('main',2718));
                                            else
                                                satir_detay_list[2][listlen(alacak_tutar_list)]='#evaluate("attributes.comp_name#k#")# - ' & UCase(getLang('main',1774));
                                        }
                                    }
                                    else
                                        satir_detay_list[2][listlen(alacak_tutar_list)]=detail_;
                                    /* acc_project_id muhasebeciye kaydediliyor */
                                    if(isdefined("attributes.project_id#k#") and len(evaluate("attributes.project_id#k#")) and len(evaluate("attributes.project_head#k#")))
                                    {
                                        acc_project_list_alacak = listappend(acc_project_list_alacak,evaluate("attributes.project_id#k#"),',');
                                        acc_project_list_borc = listappend(acc_project_list_borc,evaluate("attributes.project_id#k#"),',');
                                    }
                                    else
                                    {
                                        acc_project_list_alacak = listappend(acc_project_list_alacak,0,',');
                                        acc_project_list_borc = listappend(acc_project_list_borc,0,',');
                                    }		
                                }
                                muhasebeci (
                                    action_id: attributes.multi_id,
                                    workcube_process_type: process_type,
                                    workcube_old_process_type:form.old_process_type,
                                    workcube_process_cat:form.process_cat,
                                    account_card_type: 13,
                                    acc_department_id:acc_department_id,
                                    islem_tarihi: attributes.action_date,
                                    fis_satir_detay: satir_detay_list,
                                    borc_hesaplar: borc_hesap_list,
                                    borc_tutarlar: borc_tutar_list,
                                    other_amount_borc : doviz_tutar_borc,
                                    other_currency_borc : doviz_currency_borc,
                                    alacak_hesaplar: alacak_hesap_list,
                                    alacak_tutarlar: alacak_tutar_list,
                                    other_amount_alacak : doviz_tutar_alacak,
                                    other_currency_alacak : doviz_currency_alacak,
                                    currency_multiplier : currency_multiplier,
                                    from_branch_id : _branch_id,
                                    fis_detay: detail_,
                                    acc_project_list_alacak : acc_project_list_alacak,
                                    acc_project_list_borc : acc_project_list_borc,
                                    is_account_group : account_group
                                );
                        }
                    }
                }
                else
                    muhasebe_sil(action_id:attributes.multi_id,process_type:attributes.old_process_type);
            </cfscript>
            <cfquery name="del_action_money" datasource="#dsn2#">
                DELETE FROM CARI_ACTION_MULTI_MONEY WHERE ACTION_ID=#attributes.multi_id#
            </cfquery>
            <cfloop from="1" to="#attributes.kur_say#" index="i">
                <cfquery name="add_action_money" datasource="#dsn2#">
                    INSERT INTO 
                        CARI_ACTION_MULTI_MONEY 
                        (
                            ACTION_ID,
                            MONEY_TYPE,
                            RATE2,
                            RATE1,
                            IS_SELECTED
                        )
                        VALUES
                        (
                            #attributes.multi_id#,
                            '#wrk_eval("attributes.hidden_rd_money_#i#")#',
                            #evaluate("attributes.txt_rate2_#i#")#,
                            #evaluate("attributes.txt_rate1_#i#")#,
                            <cfif evaluate("attributes.hidden_rd_money_#i#") is listfirst(attributes.rd_money,',')>1<cfelse>0</cfif>
                        )
                </cfquery>
            </cfloop>
            <!--- Belge No Guncelleme --->
            <cfif not isdefined("attributes.act_row_id#attributes.record_num#")>
                <cfquery name="UPD_GENERAL_PAPERS" datasource="#DSN2#">
                    UPDATE 
                        #dsn3_alias#.GENERAL_PAPERS
                    SET
                        DEBIT_CLAIM_NUMBER = #paper_number-1#
                    WHERE
                        DEBIT_CLAIM_NUMBER IS NOT NULL
                </cfquery>
            </cfif>
            <cfif len(get_process_type.action_file_name)>
                <cf_workcube_process_cat 
                    process_cat="#form.process_cat#"
                    action_id = #attributes.multi_id#
                    is_action_file = 1
                    action_file_name='#get_process_type.action_file_name#'
                    action_page='#request.self#?fuseaction=#listGetAt(fuseaction,1,'.')#.form_add_debit_claim_note&event=updMulti&multi_id=#attributes.multi_id#'
                    action_db_type = '#dsn2#'
                    is_template_action_file = '#get_process_type.action_file_from_template#'>
            </cfif>
        </cftransaction>
    </cflock>
</cfif>
<cfset attributes.actionId=attributes.multi_id>
<script type="text/javascript">	
	window.location.href='<cfoutput>#request.self#?fuseaction=#nextEvent##attributes.multi_id#</cfoutput>';
</script>