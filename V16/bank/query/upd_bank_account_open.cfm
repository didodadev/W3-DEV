<cf_get_lang_set module_name="bank">
<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_bank_actions</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT 
		PROCESS_TYPE,
		IS_CARI,
		IS_ACCOUNT,
		ACTION_FILE_NAME,
		ACTION_FILE_FROM_TEMPLATE
	 FROM
	 	SETUP_PROCESS_CAT
	WHERE 
		PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cf_date tarih="attributes.action_date">
<cfscript>
	process_type = get_process_type.PROCESS_TYPE;
	is_cari =get_process_type.IS_CARI;
	is_account = get_process_type.IS_ACCOUNT;
	if(isdefined("attributes.branch_id") and len(attributes.branch_id))
		branch_id_info = attributes.branch_id;
	else
		branch_id_info = listgetat(session.ep.user_location,2,'-');
	
	currency_multiplier = '';
	paper_currency_multiplier = '';
	if(isDefined('attributes.kur_say') and len(attributes.kur_say))
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
		{
			if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
				currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
			if(evaluate("attributes.hidden_rd_money_#mon#") is form.money_type)
				paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
		}					
</cfscript>
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="UPD_BANK_ACCOUNT_OPEN" datasource="#dsn2#">
			UPDATE
				BANK_ACTIONS
			SET 
				PROCESS_CAT = #form.process_cat#,
				ACTION_VALUE = #attributes.ACTION_VALUE#,
				ACTION_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.currency_id#">,
				<cfif attributes.ba_status eq 0>
					ACTION_TO_ACCOUNT_ID = #attributes.old_acc_id#,
					ACTION_FROM_ACCOUNT_ID = NULL,
					TO_BRANCH_ID = #branch_id_info#,
					FROM_BRANCH_ID = NULL,
				<cfelse>
					ACTION_FROM_ACCOUNT_ID = #attributes.old_acc_id#,
					ACTION_TO_ACCOUNT_ID = NULL,
					TO_BRANCH_ID = NULL,
					FROM_BRANCH_ID = #branch_id_info#,
				</cfif>
				OTHER_CASH_ACT_VALUE= <cfif len(attributes.OTHER_CASH_ACT_VALUE)>#attributes.OTHER_CASH_ACT_VALUE#<cfelse>NULL</cfif>,
				OTHER_MONEY = <cfif len(attributes.money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money_type#"><cfelse>NULL</cfif>,
				ACTION_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_detail#">,
				ACTION_DATE = #attributes.action_date#,
				IS_ACCOUNT = <cfif is_account eq 1>1,<cfelse>0,</cfif>
				IS_ACCOUNT_TYPE = 10,
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				SYSTEM_ACTION_VALUE = #attributes.system_amount#,
				SYSTEM_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
				<cfif len(session.ep.money2)>
					,ACTION_VALUE_2 = #wrk_round(attributes.system_amount/currency_multiplier,4)#
					,ACTION_CURRENCY_ID_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
				</cfif>			
			WHERE
				ACTION_ID = #attributes.ID#
		</cfquery>
		<cfscript>
			f_kur_ekle_action(action_id:attributes.ID,process_type:1,action_table_name:'BANK_ACTION_MONEY',action_table_dsn:'#dsn2#');
		</cfscript>
		<cfif len(get_process_type.action_file_name)>
			<cf_workcube_process_cat 
				process_cat="#form.process_cat#"
				action_id = #attributes.ID#
				is_action_file = 1
				action_file_name='#get_process_type.action_file_name#'
				action_db_type = '#dsn2#'
				is_template_action_file = '#get_process_type.action_file_from_template#'>
		</cfif>	
	</cftransaction>
</cflock>
<cfset attributes.actionId=attributes.id>
<script type="text/javascript">
	<cfif isdefined("attributes.is_popup") and attributes.is_popup eq 1>
		wrk_opener_reload();
		window.close();
	<cfelse>
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_bank_account_open&event=upd&id=#attributes.ID#</cfoutput>';
	</cfif>
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
