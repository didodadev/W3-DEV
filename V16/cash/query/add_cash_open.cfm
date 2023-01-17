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
<cf_date tarih='attributes.ACTION_DATE'>
<cfif isdefined("CASH_ACTION_TO_CASH_ID")>
	<cflock name="#createUUID()#" timeout="60">
		<cftransaction>
			<cfquery name="CASH_OPEN" datasource="#dsn2#">
				INSERT INTO
					CASH_ACTIONS
					(
						PROCESS_CAT,
						ACTION_TYPE,
						ACTION_TYPE_ID,
						ACTION_DATE,
						CASH_ACTION_VALUE,
						CASH_ACTION_CURRENCY_ID,
						CASH_ACTION_TO_CASH_ID,
						OTHER_CASH_ACT_VALUE,
						OTHER_MONEY,
						ACTION_DETAIL,
						IS_ACCOUNT,
						IS_ACCOUNT_TYPE,
						RECORD_EMP,
						RECORD_IP,
						RECORD_DATE,
						ACTION_VALUE,
						ACTION_CURRENCY_ID
						<cfif len(session.ep.money2)>
							,ACTION_VALUE_2
							,ACTION_CURRENCY_ID_2
						</cfif>
					)
					VALUES
					(
						#form.process_cat#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="KASA AÇILIŞI">,
						#process_type#,
						#attributes.ACTION_DATE#,
						#attributes.CASH_ACTION_VALUE#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_CURRENCY_ID#">,
						#CASH_ACTION_TO_CASH_ID#,
						<cfif isDefined("attributes.OTHER_CASH_ACT_VALUE") and len(attributes.OTHER_CASH_ACT_VALUE)>#attributes.OTHER_CASH_ACT_VALUE#,<cfelse>NULL,</cfif>
						<cfif isDefined("attributes.money_type") and len(attributes.money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#money_type#">,<cfelse>NULL,</cfif>
						<cfif isdefined("attributes.ACTION_DETAIL") and len(attributes.ACTION_DETAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_DETAIL#">,<cfelse>NULL,</cfif>
						<cfif is_account eq 1>1,30,<cfelse>0,30,</cfif>
						#SESSION.EP.USERID#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
						#NOW()#,
						#attributes.system_amount#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
						<cfif len(session.ep.money2)>
							,#wrk_round(attributes.system_amount/currency_multiplier,4)#
							,<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
						</cfif>
					)
			</cfquery>
			<cfquery name="GET_ACT_ID" datasource="#dsn2#">
				SELECT	MAX(ACTION_ID) AS ACT_ID FROM CASH_ACTIONS
			</cfquery>
			<!--- acilan kasanin durumunu acik göster--->
			<cfquery name="UPD_CASH_STATUS" datasource="#dsn2#">
				UPDATE
					CASH
				SET
					ISOPEN=1
				WHERE
					CASH_ID=#CASH_ACTION_TO_CASH_ID#
			</cfquery>
			<!---kasa durumu güncellendi--->
			<cfscript>
				f_kur_ekle_action(action_id:GET_ACT_ID.ACT_ID,process_type:0,action_table_name:'CASH_ACTION_MONEY',action_table_dsn:'#dsn2#');
			</cfscript>
			<!--- onay ve uyarıların gelebilmesi icin action file sarti kaldirildi --->
			<!--- <cfif len(get_process_type.action_file_name)> ---><!--- secilen islem kategorisine bir action file eklenmisse --->
				<cf_workcube_process_cat 
					process_cat="#form.process_cat#"
					action_id = #GET_ACT_ID.ACT_ID#
					is_action_file = 1
					action_file_name='#get_process_type.action_file_name#'
					action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_cash_open&event=upd&id=#GET_ACT_ID.ACT_ID#'
					action_db_type = '#dsn2#'
					is_template_action_file = '#get_process_type.action_file_from_template#'>
			<!--- </cfif> --->	
		</cftransaction>
	</cflock>
    <cfset attributes.actionId = GET_ACT_ID.ACT_ID>
	<script type="text/javascript">	
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_cash_open&event=upd&id=#GET_ACT_ID.ACT_ID#</cfoutput>';
	</script>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang no='91.Açılacak Kasa Yok Önce Kasa Ekleyiniz !'>");
		history.back();
	</script>
	<cfabort>
</cfif>
