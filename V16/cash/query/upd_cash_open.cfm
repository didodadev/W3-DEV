<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=cash.list_cash_actions</cfoutput>';
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

<cf_date tarih='attributes.ACTION_DATE'>

<cfscript>
	process_type = get_process_type.PROCESS_TYPE;
	is_cari =get_process_type.IS_CARI;
	is_account = get_process_type.IS_ACCOUNT;
	CASH_ACTION_TO_CASH_ID = listfirst(attributes.CASH_ACTION_TO_CASH_ID,';');
	ACTION_CURRENCY_ID = listlast(attributes.CASH_ACTION_TO_CASH_ID,';');
	currency_multiplier = '';
	if(isDefined('attributes.kur_say') and len(attributes.kur_say))
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
			if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
				currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
</cfscript>

<cflock name="#createUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="CASH_OPEN" datasource="#dsn2#">
			UPDATE
				CASH_ACTIONS
			SET
				PROCESS_CAT = #form.process_cat#,
				CASH_ACTION_VALUE=#attributes.CASH_ACTION_VALUE#,
				CASH_ACTION_CURRENCY_ID= <cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_CURRENCY_ID#">,
				CASH_ACTION_TO_CASH_ID=#CASH_ACTION_TO_CASH_ID#	,
				OTHER_CASH_ACT_VALUE = <cfif len(attributes.OTHER_CASH_ACT_VALUE)>#attributes.OTHER_CASH_ACT_VALUE#<cfelse>NULL</cfif>,
				OTHER_MONEY = <cfif len(money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#money_type#"><cfelse>NULL</cfif>,
				ACTION_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_DETAIL#">,
				IS_ACCOUNT = <cfif is_account>1,<cfelse>0,</cfif>
				IS_ACCOUNT_TYPE = 10,
				ACTION_DATE = #attributes.ACTION_DATE#,
				UPDATE_EMP=#SESSION.EP.USERID#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				UPDATE_DATE=#NOW()#,
				ACTION_VALUE = #attributes.system_amount#,
				ACTION_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
				<cfif len(session.ep.money2)>
					,ACTION_VALUE_2 = #wrk_round(attributes.system_amount/currency_multiplier,4)#
					,ACTION_CURRENCY_ID_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
				</cfif>	
			WHERE
				ACTION_ID=#attributes.id#	
		</cfquery>
		<cfscript>
			f_kur_ekle_action(action_id:attributes.id,process_type:1,action_table_name:'CASH_ACTION_MONEY',action_table_dsn:'#dsn2#');
		</cfscript>	
		<!--- onay ve uyarıların gelebilmesi icin action file sarti kaldirildi --->
		<!--- <cfif len(get_process_type.action_file_name)> ---><!--- secilen islem kategorisine bir action file eklenmisse --->
			<cf_workcube_process_cat 
				process_cat="#form.process_cat#"
				action_id = #attributes.id#
				is_action_file = 1
				action_file_name='#get_process_type.action_file_name#'
				action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_cash_open&event=upd&id=#attributes.id#'
				action_db_type = '#dsn2#'
				is_template_action_file = '#get_process_type.action_file_from_template#'>
		<!--- </cfif> --->
	</cftransaction>
</cflock>
<cfset attributes.actionId = attributes.id>
<script type="text/javascript">
	<cfif isdefined("attributes.is_popup") and attributes.is_popup eq 1>
		wrk_opener_reload();
		window.close();
	<cfelse>
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_cash_open&event=upd&id=#attributes.id#</cfoutput>';
	</cfif>
</script>
