<cf_get_lang_set module_name="bank">
<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_bank_actions</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfquery name="GET_PROCESS_TYPE" datasource="#DSN3#">
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
	process_type = get_process_type.process_type;
	is_cari =get_process_type.is_cari;
	is_account = get_process_type.is_account;
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
			if(evaluate("attributes.hidden_rd_money_#mon#") is attributes.money_type)
				paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
		}
</cfscript>
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="BANK_ACCOUNT_OPEN" datasource="#DSN2#" result="MAX_ID">
			INSERT INTO
				BANK_ACTIONS
			(
				ACTION_TYPE,
				ACTION_TYPE_ID,
				ACTION_VALUE,
				ACTION_CURRENCY_ID,
				<cfif attributes.ba_status eq 0>
					ACTION_TO_ACCOUNT_ID,
					TO_BRANCH_ID,
				<cfelse>
					ACTION_FROM_ACCOUNT_ID,
					FROM_BRANCH_ID,
				</cfif>
				PROCESS_CAT,
				ACTION_DATE,
				OTHER_CASH_ACT_VALUE,
				OTHER_MONEY,	
				ACTION_DETAIL,
				IS_ACCOUNT,
				IS_ACCOUNT_TYPE,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP,
				SYSTEM_ACTION_VALUE,
				SYSTEM_CURRENCY_ID
				<cfif len(session.ep.money2)>
					,ACTION_VALUE_2
					,ACTION_CURRENCY_ID_2
				</cfif>
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(getLang('bank',97))#">,
				#process_type#,
				#attributes.action_value#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.currency_id#">,
				#attributes.account_id#,
				#branch_id_info#,						
				#form.process_cat#,
				#attributes.action_date#,
				<cfif isDefined("attributes.OTHER_CASH_ACT_VALUE") and len(attributes.OTHER_CASH_ACT_VALUE)>#attributes.OTHER_CASH_ACT_VALUE#,<cfelse>NULL,</cfif>
				<cfif isDefined("attributes.money_type") and len(attributes.money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money_type#">,<cfelse>NULL,</cfif>	
				<cfif isDefined("attributes.action_detail") and len(attributes.action_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_detail#">,<cfelse>NULL,</cfif>
				<cfif is_account eq 1>1,10,<cfelse>0,10,</cfif>
				#now()#,
				#session.ep.userid#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				#attributes.system_amount#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
				<cfif len(session.ep.money2)>
					,#wrk_round(attributes.system_amount/currency_multiplier,4)#
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
				</cfif>
			)
		</cfquery>
		<cfscript>	
			f_kur_ekle_action(action_id:MAX_ID.IDENTITYCOL,process_type:0,action_table_name:'BANK_ACTION_MONEY',action_table_dsn:'#dsn2#');
		</cfscript>
        <!---HESAP O DÖNEMDE KAYDEDİLMİŞSE, O DÖNEM BİLGİSİNE GÖRE GÜNCELLİYOR. DAHA ÖNCEDEN KAYDEDİLMİŞSE, IS_OPEN = 1 OLARAK YENI KAYIT ATIYOR. ÇÜNKÜ EKLEME SAYFASINDA SELECTE GELEN HESAPLAR,  HEM HESAP ID HEM DE PERIOD_ID E GÖRE GELİYOR. SK--->
        <cfquery name="CHECK_ACCOUNT_STATUS" datasource="#dsn2#">
        	SELECT
            	*
            FROM
            	#dsn3_alias#.ACCOUNTS_OPEN_CONTROL
            WHERE
            	ACCOUNT_ID = #attributes.account_id#
                AND PERIOD_ID = #session.ep.period_id#
        </cfquery>
        <cfif CHECK_ACCOUNT_STATUS.recordcount gt 0>
            <cfquery name="UPD_ACCOUNT_STATUS" datasource="#dsn2#">
                UPDATE
                    #dsn3_alias#.ACCOUNTS_OPEN_CONTROL
                SET
                    IS_OPEN = 1
                WHERE
                    ACCOUNT_ID = #attributes.account_id#
                    AND PERIOD_ID = #session.ep.period_id#
            </cfquery>
        <cfelse>
            <cfquery name="ADD_ACCOUNT_CONTROL" datasource="#DSN2#">
                INSERT INTO
                    #dsn3_alias#.ACCOUNTS_OPEN_CONTROL
                    (
                        ACCOUNT_ID,
                        IS_OPEN,
                        PERIOD_ID
                    )
                    VALUES
                    (
                        #attributes.account_id#,
                        1,
                        #session.ep.period_id#
                    )
            </cfquery>
        </cfif>
		
			<cf_workcube_process_cat 
				process_cat="#form.process_cat#"
				action_id = #MAX_ID.IDENTITYCOL#
				is_action_file = 1
				action_file_name='#get_process_type.action_file_name#'
				action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_bank_account_open&event=upd&id=#MAX_ID.IDENTITYCOL#'
				action_db_type = '#dsn2#'
				is_template_action_file = '#get_process_type.action_file_from_template#'>
		
	</cftransaction>
</cflock> 
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_bank_account_open&event=upd&id=#MAX_ID.IDENTITYCOL#</cfoutput>';
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
