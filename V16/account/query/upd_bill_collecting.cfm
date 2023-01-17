<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.opener.location.href='<cfoutput>#request.self#?fuseaction=account.list_cards</cfoutput>';
		window.close();
	</script>
	<cfabort>
</cfif>
<cf_date tarih='attributes.process_date'>
<cf_date tarih='attributes.due_date'>
<cfquery name="get_card_history" datasource="#dsn2#">
	 SELECT
		*
	 FROM
		ACCOUNT_CARD
	 WHERE
	 	CARD_ID =#attributes.card_id#
</cfquery>
<!--- e-defter islem kontrolu FA --->
<cfif session.ep.our_company_info.is_edefter eq 1>
	<cfstoredproc procedure="GET_NETBOOK" datasource="#dsn2#">
        <cfprocparam cfsqltype="cf_sql_timestamp" value="#get_card_history.action_date#" null="#not(len(get_card_history.action_date))#">
        <cfprocparam cfsqltype="cf_sql_timestamp" value="#attributes.process_date#">
        <cfprocparam cfsqltype="cf_sql_varchar" value="">
        <cfprocresult name="getNetbook">
    </cfstoredproc>
	<cfif getNetbook.recordcount>
		<script language="javascript">
            alert('Muhasebeci : İşlemi yapamazsınız. İşlem tarihine ait e-defter bulunmaktadır.');
			history.back();
        </script>
        <cfabort>
    </cfif>
</cfif>
<!--- e-defter islem kontrolu FA --->
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT PROCESS_TYPE FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfset process_type = get_process_type.PROCESS_TYPE>
<cfinclude template="get_account_plan.cfm">
<cfinclude template="get_acc_process_cat.cfm">
<cfset acc_code_index = 1>
<!--- account_card add --->
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfinclude template="add_bill_history.cfm"><!--- muhasebe fisi history kaydı yazılıyor --->
		<cfquery name="DEL_CARD_ROWS" datasource="#DSN2#">
			DELETE FROM ACCOUNT_CARD_ROWS WHERE CARD_ID=#attributes.CARD_ID#
			DELETE FROM ACCOUNT_ROWS_IFRS WHERE CARD_ID=#attributes.CARD_ID#
		</cfquery>
		<cfquery name="UPD_ACCOUNT_CARD" datasource="#DSN2#">
			UPDATE
				ACCOUNT_CARD
			SET
				IS_OTHER_CURRENCY = <cfif isdefined("attributes.IS_OTHER_CURRENCY")>1,<cfelse>0,</cfif>
				IS_ACCOUNT_CODE2= <cfif isdefined("attributes.IS_ACCOUNT_CODE2")>1,<cfelse>0,</cfif>
				<cfif isdefined("attributes.member_id") and len(attributes.member_id) and isdefined("attributes.member_name") and len(attributes.member_name)>
					ACC_COMPANY_ID = <cfif isdefined("attributes.member_type") and len(attributes.member_type) and attributes.member_type is 'partner'>#attributes.member_id#<cfelse>NULL</cfif>,
					ACC_CONSUMER_ID = <cfif isdefined("attributes.member_type") and len(attributes.member_type) and attributes.member_type is 'consumer'>#attributes.member_id#<cfelse>NULL</cfif>,
				<cfelse>
					ACC_COMPANY_ID = NULL,
					ACC_CONSUMER_ID = NULL,
				</cfif>
				<cfif not len(attributes.action_id)>
					ACTION_TYPE = #process_type#,
					ACTION_CAT_ID = #form.process_cat#,
				</cfif>
				CARD_TYPE=<cfif isdefined('acc_process_type') and len(acc_process_type)>#acc_process_type#<cfelse>11</cfif>,
				CARD_CAT_ID=#form.process_cat#,
				CARD_DETAIL = '#BILL_DETAIL#',
				CARD_TYPE_NO = #attributes.TAHSIL_BILL_NO#,
				ACTION_DATE = #attributes.PROCESS_DATE#,
                CARD_DOCUMENT_TYPE = <cfif isdefined("attributes.document_type") and len(attributes.document_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.document_type#"><cfelse>NULL</cfif>,
                CARD_PAYMENT_METHOD = <cfif isdefined("attributes.payment_type") and len(attributes.payment_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.payment_type#"><cfelse>NULL</cfif>,
                PAPER_NO = <cfif isdefined("attributes.paper_no") and len(attributes.paper_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_no#"><cfelse>NULL</cfif>,
                DUE_DATE = <cfif isdefined("attributes.document_type") and (attributes.document_type eq -1 or attributes.document_type eq -3) and isdefined("attributes.due_date") and len(attributes.due_date)><cfqueryparam cfsqltype="cf_sql_date" value="#attributes.due_date#"><cfelse>NULL</cfif>,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = '#cgi.remote_addr#',
				UPDATE_DATE = #now()# ,
				RECORD_TYPE = <cfif isdefined("attributes.show_type") and len(attributes.show_type)>#attributes.show_type#<cfelse>1</cfif>
			WHERE
				CARD_ID=#attributes.CARD_ID#
		</cfquery>
		<cfif isdefined("attributes.is_ifrs") or isdefined("attributes.IS_ACCOUNT_CODE2")>
			<cfquery name="GET_IFRS" datasource="#dsn2#">
				SELECT IFRS_CODE,ACCOUNT_CODE2 FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = '#attributes.CASH_ACC_CODE#'
			</cfquery>
		</cfif>
		<cfif attributes.show_type eq 2>
			<cfset table_name = "ACCOUNT_ROWS_IFRS">
		<cfelse>
			<cfset table_name = "ACCOUNT_CARD_ROWS">
		</cfif>
		<cfquery name="ADD_ACCOUNT_CARD_ROW_KASA" datasource="#DSN2#">
			INSERT INTO
				#table_name#
			(
				CARD_ID,
				ACCOUNT_ID,
				BA,
				OTHER_AMOUNT,
				OTHER_CURRENCY,
				AMOUNT,
				AMOUNT_CURRENCY,
				AMOUNT_2,
				IFRS_CODE,
				ACCOUNT_CODE2,
				AMOUNT_CURRENCY_2,
				ACC_BRANCH_ID,
				ACC_PROJECT_ID,
				DETAIL			
			)
			VALUES
			(
				#attributes.CARD_ID#,
				'#attributes.CASH_ACC_CODE#',
				0,
				<cfif isdefined("attributes.IS_OTHER_CURRENCY") and attributes.other_cash_amount gt 0>#attributes.other_cash_amount#,<cfelse>#attributes.cash_debt#,</cfif>
				<cfif isdefined("attributes.IS_OTHER_CURRENCY") and attributes.other_cash_amount gt 0>'#attributes.other_cash_currency#',<cfelse>'#session.ep.money#',</cfif>
				#attributes.cash_debt#,
				'#session.ep.money#',
				<cfif isdefined("attributes.cash_amount_2") and len(attributes.cash_amount_2)>#attributes.cash_amount_2#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.is_ifrs") and len(GET_IFRS.IFRS_CODE)>'#GET_IFRS.IFRS_CODE#',<cfelse>NULL,</cfif>
				<cfif isdefined("attributes.IS_ACCOUNT_CODE2") and len(GET_IFRS.ACCOUNT_CODE2)>'#GET_IFRS.ACCOUNT_CODE2#',<cfelse>NULL,</cfif>
				'#session.ep.money2#',
				<cfif isdefined("attributes.acc_branch_id") and len(attributes.acc_branch_id)>#attributes.acc_branch_id#<cfelse>#ListGetAt(session.ep.user_location,2,"-")#</cfif>,
				<cfif isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_name") and len(attributes.project_name)>#attributes.project_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.cash_detail") and len(attributes.cash_detail)>'#left(attributes.cash_detail,500)#'<cfelse>NULL</cfif>
			)
		</cfquery>
		<cfloop from="1" to="#attributes.rowCount#" index="imc">
			<cfif acc_code_index lte listlen(attributes.acc_code,',') and (listgetat(attributes.claim,imc,',') gt 0)>
				<cfset detl = evaluate("attributes.detail_#imc#")>
				<cfquery name="ADD_ACCOUNT_CARD_ROW_ALICI" datasource="#dsn2#">
					INSERT INTO
						#table_name#
					(
						CARD_ID,
						ACCOUNT_ID,
						BA,
						AMOUNT,
						AMOUNT_CURRENCY,
						AMOUNT_2,
						AMOUNT_CURRENCY_2,
						OTHER_AMOUNT,
						OTHER_CURRENCY,
						IFRS_CODE,
						ACCOUNT_CODE2,
						ACC_DEPARTMENT_ID,
						ACC_PROJECT_ID,
						ACC_BRANCH_ID,
						DETAIL
					)				
					VALUES
					(
						#attributes.CARD_ID#,
						'#listgetat(attributes.acc_code,acc_code_index,',')#',<!---hesap kodu--->
						1,
						#listgetat(attributes.claim,imc,',')#,<!---borc degeri--->
						'#session.ep.money#',
						<cfif isdefined("attributes.amount_2") and listgetat(attributes.amount_2, imc,',') gt 0>#listgetat(attributes.amount_2, imc, ',')#<cfelse>NULL</cfif>,
						'#session.ep.money2#',				
						<cfif isdefined("attributes.IS_OTHER_CURRENCY") and listgetat(attributes.other_currency, imc,',') neq 0 >#listgetat(attributes.other_amount, imc, ',')#<cfelse><cfif listgetat(attributes.claim, imc,',') gt 0>#listgetat(attributes.claim, imc, ',')#<cfelse>#listgetat(attributes.claim, imc, ',')#</cfif></cfif>,
						<cfif isdefined("attributes.IS_OTHER_CURRENCY") and listgetat(attributes.other_currency, imc,',') neq 0 >'#listgetat(attributes.other_currency, imc,',')#'<cfelse>'#session.ep.money#'</cfif>,
						<cfif isdefined("attributes.is_ifrs") and isdefined("attributes.ifrs_code") and listgetat(attributes.ifrs_code, imc,',') neq 0>'#listgetat(attributes.ifrs_code, imc, ',')#',<cfelse>NULL,</cfif>
						<cfif isdefined("attributes.IS_ACCOUNT_CODE2") and isdefined("attributes.account_code2") and listgetat(attributes.account_code2, imc,',') neq 0>'#listgetat(attributes.account_code2, imc, ',')#',<cfelse>NULL,</cfif>
						<cfif isdefined("attributes.acc_department_id#imc#") and len(evaluate("attributes.acc_department_id#imc#")) and isdefined("attributes.acc_department_name#imc#") and len(evaluate("attributes.acc_department_name#imc#"))>#evaluate("attributes.acc_department_id#imc#")#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.acc_project_id#imc#") and len(evaluate("attributes.acc_project_id#imc#")) and isdefined("attributes.acc_project_name#imc#") and len(evaluate("attributes.acc_project_name#imc#"))>#evaluate("attributes.acc_project_id#imc#")#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.acc_branch_id") and len(attributes.acc_branch_id)>#attributes.acc_branch_id#<cfelse>#ListGetAt(session.ep.user_location,2,"-")#</cfif>,
						'#left(detl,500)#'
					)
				</cfquery>
				<cfset acc_code_index = acc_code_index + 1>
			</cfif>
		</cfloop>
		<cfscript>
			f_kur_ekle_action(action_id:attributes.CARD_ID,process_type:1,action_table_name:'ACCOUNT_CARD_MONEY',action_table_dsn:'#dsn2#');
			if(session.ep.our_company_info.is_ifrs and attributes.show_type eq 3){
				muhasebeci_ifrs(card_id : attributes.CARD_ID, dsn_type : dsn2);
			}
		</cfscript>
        <cf_add_log employee_id="#session.ep.userid#" log_type="0" action_id="#attributes.CARD_ID#" action_name="#attributes.paper_no# Güncellendi"  paper_no="#attributes.paper_no#" period_id="#session.ep.period_id#" process_type="#get_process_type.PROCESS_TYPE#" data_source="#dsn2#">
	</cftransaction>
</cflock>
<cfset attributes.actionId = attributes.CARD_ID >
<!--- account_card_row_add --->
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=account.form_add_bill_collecting&event=upd&var_=collecting_card&card_id=#attributes.CARD_ID#</cfoutput>';
</script>

