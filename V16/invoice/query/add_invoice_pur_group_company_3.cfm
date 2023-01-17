<cfif isdefined("form.cash") and invoice_cat neq 591>
	<cfquery name="ADD_ALISF_KAPA" datasource="#new_dsn2#">
		INSERT INTO CASH_ACTIONS
			(
				CASH_ACTION_FROM_CASH_ID,
				ACTION_TYPE,
				ACTION_TYPE_ID,
				BILL_ID,
				CASH_ACTION_TO_COMPANY_ID,
				CASH_ACTION_VALUE,
				CASH_ACTION_CURRENCY_ID,
				ACTION_DATE,
				ACTION_DETAIL,
				IS_PROCESSED,
				PAPER_NO,
				OTHER_CASH_ACT_VALUE,
				OTHER_MONEY,
				IS_ACCOUNT,
				IS_ACCOUNT_TYPE,
				RECORD_EMP,
				RECORD_IP,
				RECORD_DATE,
				PROCESS_CAT,
				ACTION_VALUE,
				ACTION_CURRENCY_ID
				<cfif len(session.ep.money2)>
					,ACTION_VALUE_2
					,ACTION_CURRENCY_ID_2
				</cfif>
			)
		VALUES
			(
				#KASA#,
				'ALIŞ FATURASI KAPAMA İŞLEMİ',
				34,
				#get_invoice_id.max_id#,
				#attributes.company_id#,
				#get_invoice.NETTOTAL#,
				'#SESSION.EP.MONEY#',
				#attributes.invoice_date#,
				'ALIŞ FATURASI KAPAMA İŞLEMİ',
				1,
				'#get_invoice.INVOICE_NUMBER#',
				#Evaluate(get_invoice.NETTOTAL/get_invoice.OTHER_MONEY_VALUE)#,
				'#get_invoice.OTHER_MONEY#',
				<cfif is_account eq 1>
					1,
					12,
				<cfelse>
					0,
					12,
				</cfif>
				#SESSION.EP.USERID#,
				'#CGI.REMOTE_ADDR#',
				#NOW()#,
				0,
				#get_invoice.NETTOTAL#,
				'#session.ep.money#'
				<cfif len(session.ep.money2)>
					,#wrk_round(get_invoice.NETTOTAL/currency_multiplier,4)#
					,'#session.ep.money2#'
				</cfif>
			)
	</cfquery>
	<cfquery name="GET_ACT_ID" datasource="#new_dsn2#">
		SELECT MAX(ACTION_ID) AS ACT_ID FROM CASH_ACTIONS
	</cfquery>
	<cfset act_id = get_act_id.ACT_ID>
	<cfquery name="UPD_INVOICE_LAST" datasource="#new_dsn2#">
		UPDATE INVOICE SET CASH_ID=#ACT_ID#	WHERE INVOICE_ID=#get_invoice_id.max_id#
	</cfquery>
	<cfif is_cari eq 1><!--- kasa carici --->
		<cfscript>
			carici(
				action_id : ACT_ID,  
				action_table : 'CASH_ACTIONS',
				workcube_process_type : 34,
				account_card_type : 12,
				islem_tarihi : attributes.invoice_date,
				islem_tutari : get_invoice.NETTOTAL ,
				islem_belge_no : get_invoice.INVOICE_NUMBER,
				to_cmp_id : attributes.company_id,
				from_cash_id : KASA,							
				from_branch_id : ListGetAt(session.ep.user_location,2,"-"),
				islem_detay : 'ALIŞ FATURASI KAPAMA İŞLEMİ',
				action_detail : get_invoice.note,
				other_money_value : get_invoice.NETTOTAL/get_invoice.OTHER_MONEY_VALUE,
				other_money : get_invoice.OTHER_MONEY,
				action_currency : SESSION.EP.MONEY,
				process_cat : 0,
				cari_db:new_dsn2,
				period_is_integrated:new_period_is_integrated
				 );
		</cfscript>
	</cfif>
	<cfif is_account eq 1><!--- kasa muhasebeci --->
		<cfquery name="get_cash_code" datasource="#new_dsn2#" >
			SELECT * FROM CASH WHERE CASH_ID=#KASA#
		</cfquery>
		<cfscript>
			DETAIL_2 = DETAIL_ & " KAPAMA ISLEMI";
			muhasebeci(
				action_id : ACT_ID,
				workcube_process_type : 34,
				account_card_type : 12,
				islem_tarihi : attributes.invoice_date,
				borc_hesaplar : ACC,
				borc_tutarlar : wrk_round(get_invoice.NETTOTAL),
				alacak_hesaplar : get_cash_code.CASH_ACC_CODE,
				alacak_tutarlar : wrk_round(get_invoice.NETTOTAL),
				fis_detay : '#DETAIL_2#',
				fis_satir_detay : 'Alış Fatura Kapama',
				belge_no : get_invoice.invoice_number,
				muhasebe_db:new_dsn2,
				is_account_group : is_account_group
			);
		</cfscript>
	</cfif>
	<cfquery name="UPD_INVOICE_ACC" datasource="#new_dsn2#">
		UPDATE INVOICE SET IS_ACCOUNTED = #is_account# WHERE INVOICE_ID = #get_invoice_id.max_id#
	</cfquery>
<cfelse>
	<cfquery name="UPD_INVOICE_ACC" datasource="#new_dsn2#">
		UPDATE INVOICE SET IS_ACCOUNTED = 0 WHERE INVOICE_ID = #get_invoice_id.max_id#
	</cfquery>
</cfif>
