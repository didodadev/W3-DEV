<cfif isdefined("form.cash")><!--- kasa seçili ise --->
	<cfquery name="get_cash_code" datasource="#dsn2#">
		SELECT CASH_ACC_CODE,BRANCH_ID FROM CASH WHERE CASH_ID=#KASA#
	</cfquery>
	<cfif len(get_cash_code.BRANCH_ID)> <!--- carici ve muhasebecide kullanılıyor --->
		<cfset cash_branch_id = get_cash_code.BRANCH_ID>
	<cfelse>
		<cfset cash_branch_id = ''>
	</cfif>
	<cfif len(get_number.cash_id)><!--- eski kasa hareketlerini sil --->
		<cfquery name="UPD_ALISF_KAPA" datasource="#dsn2#">
			UPDATE
				CASH_ACTIONS
			SET
				CASH_ACTION_FROM_CASH_ID = #KASA#,
				ACTION_TYPE_ID = 34,
				BILL_ID = #form.invoice_id#,
			<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
				CASH_ACTION_TO_COMPANY_ID = #attributes.company_id#,
			<cfelse>
				CASH_ACTION_TO_CONSUMER_ID = #attributes.consumer_id#,
			</cfif>
				CASH_ACTION_VALUE = #wrk_round(form.basket_net_total-form.stopaj)#,
				CASH_ACTION_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SESSION.EP.MONEY#">,
				ACTION_DATE = #attributes.invoice_date#,
				IS_PROCESSED = 1,
				PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.INVOICE_NUMBER#">,
				IS_ACCOUNT = <cfif session.ep.period_is_integrated>1,<cfelse>0,</cfif>
				IS_ACCOUNT_TYPE = 12,
				UPDATE_EMP = #SESSION.EP.USERID#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				UPDATE_DATE = #now()#,
				PROCESS_CAT = 0,
				ACTION_VALUE = #form.basket_net_total#,
				ACTION_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
				<cfif len(session.ep.money2)>
					,ACTION_VALUE_2 = #wrk_round(form.basket_net_total/attributes.currency_multiplier,4)#
					,ACTION_CURRENCY_ID_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
				</cfif>
			WHERE
				ACTION_ID=#get_number.cash_id#
		</cfquery>
		<cfset act_id = get_number.cash_id>
	<cfelse>
		<cfquery name="ADD_ALISF_KAPA" datasource="#dsn2#">
			INSERT INTO CASH_ACTIONS
				(
				CASH_ACTION_FROM_CASH_ID,		
				ACTION_TYPE,
				ACTION_TYPE_ID,
				BILL_ID,
			<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
				CASH_ACTION_TO_COMPANY_ID,
			<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
				CASH_ACTION_TO_CONSUMER_ID,
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
				<cfif len(session.ep.money2)>
					,ACTION_VALUE_2
					,ACTION_CURRENCY_ID_2
				</cfif>
				)
			VALUES
				(
				#KASA#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#str_line_detail# Ödemesi">,
				34,
				#form.invoice_id#,
			<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
				#attributes.company_id#,
			<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
				#attributes.consumer_id#,
			</cfif>
				#wrk_round(form.basket_net_total-form.stopaj)#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#SESSION.EP.MONEY#">,
				#attributes.invoice_date#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#str_line_detail# Ödemesi">,
				1,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.INVOICE_NUMBER#">,
				<cfif session.ep.period_is_integrated>
					1,
					12,
				<cfelse>
					0,
					12,
				</cfif>
				#SESSION.EP.USERID#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				#NOW()#,
				0,
				#form.basket_net_total#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
				<cfif len(session.ep.money2)>
					,#wrk_round(form.basket_net_total/attributes.currency_multiplier,4)#
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
				</cfif>
				)
		</cfquery>
		<cfquery name="GET_ACT_ID" datasource="#dsn2#">
			SELECT MAX(ACTION_ID) AS ACT_ID FROM CASH_ACTIONS
		</cfquery>
		<cfset act_id=get_act_id.ACT_ID>
	</cfif>
	<cfscript>
		if(is_cari)//kasa cari
		{
			carici(
				action_id : act_id,  
				action_table : 'CASH_ACTIONS',
				workcube_process_type : 34,
				workcube_old_process_type : 34,
				account_card_type : 12,
				islem_tarihi : attributes.invoice_date,
				islem_tutari : wrk_round(form.basket_net_total-form.stopaj) ,
				islem_belge_no : FORM.INVOICE_NUMBER,
				to_consumer_id : attributes.consumer_id,
				to_cmp_id : attributes.company_id,
				islem_detay : '#str_line_detail# Ödemesi',
				action_detail : note,
				other_money_value :wrk_round((form.basket_net_total-form.stopaj)/form.basket_rate2),
				other_money : form.basket_money,
				action_currency : SESSION.EP.MONEY,
				from_cash_id : KASA,
				from_branch_id :iif(len(cash_branch_id),de('#cash_branch_id#'),de('')),
				process_cat : 0,
				currency_multiplier : attributes.currency_multiplier,
				rate2:paper_currency_multiplier
				 );
				}
		else
		{
			if(len(get_number.cash_id))
				cari_sil(action_id:get_number.cash_id, process_type:34); // old process type yerine 34
		}
		
		if(is_account)
		{
			muhasebeci(
				action_id : act_id,
				workcube_process_type : 34,
				workcube_old_process_type : 34,
				account_card_type : 12,//0,
				company_id : attributes.company_id,
				consumer_id : attributes.consumer_id,
				islem_tarihi : attributes.invoice_date,
				borc_hesaplar : ACC,
				borc_tutarlar : wrk_round(form.basket_net_total-form.stopaj),
				other_amount_borc :wrk_round((form.basket_net_total-form.stopaj)/form.basket_rate2),
				other_currency_borc : form.basket_money,
				alacak_hesaplar : get_cash_code.CASH_ACC_CODE,
				alacak_tutarlar : wrk_round(form.basket_net_total-form.stopaj),
				other_amount_alacak : wrk_round((form.basket_net_total-form.stopaj)/form.basket_rate2),
				other_currency_alacak :form.basket_money,
				from_branch_id :iif(len(cash_branch_id),de('#cash_branch_id#'),de('')),
				fis_detay : '#str_line_detail# Ödemesi',
				fis_satir_detay : '#str_line_detail# Ödemesi',
				belge_no : form.invoice_number,
				is_account_group : is_account_group,
				currency_multiplier : attributes.currency_multiplier
			);
		}
		else
		{
			if(len(get_number.cash_id))
				muhasebe_sil(action_id:get_number.cash_id, process_type:34);
		}

	</cfscript>
	<cfquery name="UPD_INVOICE_ACC" datasource="#dsn2#">
		UPDATE 
			INVOICE
		SET
			CASH_ID=#act_id#,
			KASA_ID=#KASA#,
			IS_CASH=1,
			IS_ACCOUNTED = #cari_hesap_secili#
		WHERE
			INVOICE_ID=#form.invoice_id#
	</cfquery>
<cfelse>
	<cfif len(get_number.cash_id)><!--- eski kasa hareketlerini siler --->
		<cfquery name="DEL_CASH" datasource="#dsn2#">
			DELETE FROM	CASH_ACTIONS WHERE ACTION_ID=#GET_NUMBER.CASH_ID#
		</cfquery>
		<cfscript>
			muhasebe_sil(action_id:get_number.cash_id, process_type:34);
			cari_sil(action_id:get_number.cash_id, process_type:34);
		</cfscript>
	</cfif>
	<cfquery name="UPD_INVOICE_ACC" datasource="#dsn2#">
		UPDATE 
			INVOICE
		SET
			CASH_ID = NULL,
			KASA_ID = NULL,
			IS_CASH = 0,
			IS_ACCOUNTED = 0
		WHERE
			INVOICE_ID=#form.invoice_id#
	</cfquery>
</cfif>
