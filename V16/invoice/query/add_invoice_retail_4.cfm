<cfinclude template = "../../objects/query/session_base.cfm">
<cfif isdefined("form.cash") and (form.cash eq 1)><!--- kasa seçili ise --->
	<cfloop from="1" to="#kur_say#" index="k">
	  <cfif isdefined("kasa#k#") and isdefined("cash_amount#k#") and (filterNum(evaluate('cash_amount#k#')) gt 0)>
		<cfset 'attributes.cash_amount#k#' = filternum(evaluate('cash_amount#k#'))>
		<cfquery name="get_cash_code" datasource="#dsn2#">
			SELECT CASH_ACC_CODE,BRANCH_ID FROM CASH WHERE CASH_ID=#evaluate("kasa#k#")#
		</cfquery>
		<cfif len(get_cash_code.BRANCH_ID)> <!--- carici ve muhasebecide kullanılıyor --->
			<cfset cash_branch_id = get_cash_code.BRANCH_ID>
		<cfelse>
			<cfset cash_branch_id = ''>
		</cfif>
		<cfquery name="ADD_ALISF_KAPA" datasource="#dsn2#">
			INSERT INTO CASH_ACTIONS
				(
				CASH_ACTION_TO_CASH_ID,
				ACTION_TYPE,
				ACTION_TYPE_ID,
				BILL_ID,
			<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
				CASH_ACTION_FROM_COMPANY_ID,
			<cfelse>
				CASH_ACTION_FROM_CONSUMER_ID,
			</cfif>
				CASH_ACTION_VALUE,
				CASH_ACTION_CURRENCY_ID,				
				ACTION_DATE,
				ACTION_DETAIL,
				IS_PROCESSED,
				PAPER_NO,
				IS_ACCOUNT,
				IS_ACCOUNT_TYPE,
				RECORD_EMP,
				RECORD_IP,
				RECORD_DATE,
				PROCESS_CAT,
				ACTION_VALUE,
				ACTION_CURRENCY_ID
				<cfif len(session_base.money2)>
					,ACTION_VALUE_2
					,ACTION_CURRENCY_ID_2
				</cfif>
				)
			VALUES
				(
				#evaluate("kasa#k#")#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="SATIŞ FATURASI KAPAMA İŞLEMİ">,
				35,
				#get_invoice_id.max_id#,
			<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
				#attributes.company_id#,
			<cfelse>
				#attributes.consumer_id#,
			</cfif>
				#evaluate('attributes.cash_amount#k#')#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('currency_type#k#')#">,
				#attributes.invoice_date#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="SATIŞ FATURASI KAPAMA İŞLEMİ">,
			<cfif is_account>1<cfelse>0</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.INVOICE_NUMBER#">,
				<cfif is_account eq 1>
					1,
					11,
				<cfelse>
					0,
					11,
				</cfif>
				#session_base.USERID#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				#NOW()#,
				0,
				#evaluate('system_cash_amount#k#')#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.money#">
				<cfif len(session_base.money2)>
					,#wrk_round(evaluate('system_cash_amount#k#')/attributes.currency_multiplier,4)#
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.money2#">
				</cfif>
				)
		</cfquery>
		<cfquery name="GET_ACT_ID" datasource="#dsn2#">
			SELECT MAX(ACTION_ID) AS ACT_ID	FROM CASH_ACTIONS
		</cfquery>
		<cfset act_id=get_act_id.ACT_ID>
		<cfquery name="UPD_INVOICE_CASH" datasource="#dsn2#">
			INSERT INTO INVOICE_CASH_POS
				(
				INVOICE_ID,
				CASH_ID,
				KASA_ID
				)
			VALUES
				(
				#get_invoice_id.max_id#,
				#ACT_ID#,
				#evaluate("kasa#k#")#
				)
		</cfquery>
 		<cfscript>
			if(is_cari eq 1)
			{
				carici(
					action_id : ACT_ID,  
					action_table : 'CASH_ACTIONS',
					workcube_process_type : 35,
					account_card_type : 13,
					islem_tarihi : attributes.invoice_date,
					islem_tutari : evaluate("attributes.system_cash_amount#k#"),
					islem_belge_no : FORM.INVOICE_NUMBER,
					from_cmp_id : attributes.company_id,
					from_consumer_id : attributes.consumer_id,
					islem_detay : 'SATIŞ FATURASI KAPAMA İŞLEMİ',
					action_detail : note,
					other_money_value : evaluate("attributes.cash_amount#k#"),
					other_money : evaluate("attributes.currency_type#k#"),
					action_currency : session_base.MONEY,
					to_cash_id : evaluate("kasa#k#"),
					to_branch_id :iif(len(cash_branch_id),de('#cash_branch_id#'),de('')),
					process_cat : 0,
					currency_multiplier : attributes.currency_multiplier
					);
			}
			if(is_account eq 1)
			{
				DETAIL_2 = DETAIL_ & " KAPAMA ISLEMI";
				muhasebeci(
					wrk_id='#wrk_id#',
					action_id : ACT_ID,
					workcube_process_type : 35,
					account_card_type : 11, 
					company_id : attributes.company_id,
					consumer_id : attributes.consumer_id,
					islem_tarihi : attributes.invoice_date,
					borc_hesaplar : get_cash_code.CASH_ACC_CODE,
					borc_tutarlar : wrk_round(evaluate("attributes.system_cash_amount#k#")),
					other_amount_borc : evaluate("attributes.cash_amount#k#"),
					other_currency_borc : evaluate("attributes.currency_type#k#"),
					alacak_hesaplar : ACC,
					alacak_tutarlar : wrk_round(evaluate("attributes.system_cash_amount#k#")),
					other_amount_alacak : evaluate("attributes.cash_amount#k#"),
					other_currency_alacak : evaluate("attributes.currency_type#k#"),
					to_branch_id :iif(len(cash_branch_id),de('#cash_branch_id#'),de('')),
					fis_detay : '#DETAIL_2#',
					fis_satir_detay : 'Satış Fatura Kapama',
					belge_no : form.invoice_number,
					is_account_group : is_account_group,
					currency_multiplier : attributes.currency_multiplier 
					);
			}
		</cfscript>		
	 </cfif>
	</cfloop>
	<cfquery name="UPD_INVOICE_ACC" datasource="#dsn2#">
		UPDATE INVOICE SET IS_ACCOUNTED=#is_account# WHERE INVOICE_ID=#get_invoice_id.max_id#
	</cfquery> 
<cfelse>
	<cfquery name="UPD_INVOICE_ACC" datasource="#dsn2#">
		UPDATE INVOICE SET IS_ACCOUNTED=0 WHERE INVOICE_ID=#get_invoice_id.max_id#
	</cfquery>
</cfif>
