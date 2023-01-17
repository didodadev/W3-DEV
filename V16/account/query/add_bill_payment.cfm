<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=account.list_cards</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cf_date tarih='attributes.PROCESS_DATE'>
<cf_date tarih='attributes.due_date'>
<!--- e-defter islem kontrolu FA --->
<cfif session.ep.our_company_info.is_edefter eq 1>
	<cfstoredproc procedure="GET_NETBOOK" datasource="#dsn2#">
    	<cfprocparam cfsqltype="cf_sql_timestamp" value="#attributes.process_date#">
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
	SELECT PROCESS_TYPE FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.process_cat#">
</cfquery>
<cfset process_type = get_process_type.PROCESS_TYPE>
<cfinclude template="get_account_plan.cfm">
<cfinclude template="get_acc_process_cat.cfm">
<!--- account_card add --->
<cfset acc_code_index = 1>
<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfinclude template="get_bill_no.cfm">
		<cfquery name="ADD_ACCOUNT_CARD" datasource="#dsn2#" result="MAX_ID">
			INSERT INTO
				ACCOUNT_CARD
			(
				IS_OTHER_CURRENCY,
				IS_ACCOUNT_CODE2,
				WRK_ID,
				ACC_COMPANY_ID,
				ACC_CONSUMER_ID,
				ACTION_TYPE,
				ACTION_CAT_ID,
				CARD_DETAIL,
				BILL_NO,
				CARD_TYPE,
				CARD_CAT_ID,
				CARD_TYPE_NO,
				ACTION_DATE,
                CARD_DOCUMENT_TYPE,
                CARD_PAYMENT_METHOD,
                PAPER_NO,
                DUE_DATE,
				RECORD_EMP,
				RECORD_IP,
				RECORD_DATE,
				RECORD_TYPE
			)
			VALUES
			(
				<cfif isdefined("attributes.IS_OTHER_CURRENCY")><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
				<cfif isdefined("attributes.IS_ACCOUNT_CODE2")><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_id#">,
				<cfif isdefined("attributes.member_id") and len(attributes.member_id) and isdefined("attributes.member_name") and len(attributes.member_name)>
					<cfif isdefined("attributes.member_type") and len(attributes.member_type) and attributes.member_type is 'partner'><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.member_type") and len(attributes.member_type) and attributes.member_type is 'consumer'><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_id#"><cfelse>NULL</cfif>,
                <cfelse>
                    NULL,
                    NULL,
                </cfif>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#process_type#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#form.process_cat#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#BILL_DETAIL#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#get_bill_no.BILL_NO#">,
				<cfif isdefined('acc_process_type') and len(acc_process_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#acc_process_type#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="12"></cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.process_cat#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#get_bill_no.TEDIYE_BILL_NO#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.PROCESS_DATE#">,
                <cfif isdefined("attributes.document_type") and len(attributes.document_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.document_type#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.payment_type") and len(attributes.payment_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.payment_type#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.paper_no") and len(attributes.paper_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_no#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.document_type") and (attributes.document_type eq -1 or attributes.document_type eq -3) and isdefined("attributes.due_date") and len(attributes.due_date)><cfqueryparam cfsqltype="cf_sql_date" value="#attributes.due_date#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfif isdefined("attributes.show_type") and len(attributes.show_type)>#attributes.show_type#<cfelse>1</cfif>
			)
		</cfquery>
		<cfif isdefined("attributes.is_ifrs") or isdefined("attributes.IS_ACCOUNT_CODE2")>
			<cfquery name="GET_IFRS" datasource="#dsn2#">
				SELECT IFRS_CODE,ACCOUNT_CODE2 FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.CASH_ACC_CODE#">
			</cfquery>
		</cfif>
		<cfif attributes.show_type eq 2>
			<cfset table_name = "ACCOUNT_ROWS_IFRS">
		<cfelse>
			<cfset table_name = "ACCOUNT_CARD_ROWS">
		</cfif>
		<cfquery name="ADD_ACCOUNT_CARD_ROW_KASA" datasource="#dsn2#">
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
				IFRS_CODE,
				ACCOUNT_CODE2,
				AMOUNT_2,
				AMOUNT_CURRENCY_2,
				ACC_BRANCH_ID,
				ACC_PROJECT_ID,
				DETAIL
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.CASH_ACC_CODE#">,
				<cfqueryparam cfsqltype="cf_sql_bit" value="1">,
				<cfif isdefined("attributes.IS_OTHER_CURRENCY") and attributes.other_cash_amount gt 0><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.other_cash_amount#">,<cfelse><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.cash_claim#">,</cfif>
                <cfif isdefined("attributes.IS_OTHER_CURRENCY") and attributes.other_cash_amount gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.other_cash_currency#">,<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,</cfif>
                <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.cash_claim#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
				<cfif isdefined("attributes.is_ifrs") and len(GET_IFRS.IFRS_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_IFRS.IFRS_CODE#">,<cfelse>NULL,</cfif>
				<cfif isdefined("attributes.IS_ACCOUNT_CODE2") and len(GET_IFRS.ACCOUNT_CODE2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_IFRS.ACCOUNT_CODE2#">,<cfelse>NULL,</cfif>
				<cfif isdefined("attributes.cash_amount_2") and len(attributes.cash_amount_2)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.cash_amount_2#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">,
				<cfif isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_name") and len(attributes.project_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.cash_detail") and len(attributes.cash_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#left(attributes.cash_detail,500)#"><cfelse>NULL</cfif>
			)
		</cfquery>
		<cfloop from="1" to="#attributes.rowCount#" index="i">
			<!---<cfif (ListLen(attributes.acc_code, ',') gte i) and len(ListGetAt(attributes.acc_code, i, ','))>hesap kodunun girilmesi zorunlu--->
			<cfif acc_code_index lte listlen(attributes.acc_code,',') and (listgetat(attributes.debt,i,',') gt 0)>
				<cfset detl = evaluate("attributes.detail_#i#")>
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
						IFRS_CODE,
						ACCOUNT_CODE2,				
						OTHER_AMOUNT,
						OTHER_CURRENCY,
						ACC_DEPARTMENT_ID,
						ACC_PROJECT_ID,
						ACC_BRANCH_ID,
						DETAIL
					)				
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(attributes.acc_code,acc_code_index,',')#">,<!---hesap kodu--->
						<cfqueryparam cfsqltype="cf_sql_bit" value="0">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#ListGetAt(attributes.debt, i, ',')#">,<!---borc degeri--->
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
						<cfif isdefined("attributes.amount_2") and listgetat(attributes.amount_2, i,',') gt 0><cfqueryparam cfsqltype="cf_sql_float" value="#listgetat(attributes.amount_2, i, ',')#"><cfelse>NULL</cfif>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">,	
						<cfif isdefined("attributes.is_ifrs") and isdefined("attributes.ifrs_code") and listgetat(attributes.ifrs_code, i,',') neq 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(attributes.ifrs_code, i, ',')#">,<cfelse>NULL,</cfif>
						<cfif isdefined("attributes.IS_ACCOUNT_CODE2") and isdefined("attributes.account_code2") and listgetat(attributes.account_code2, i,',') neq 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(attributes.account_code2, i, ',')#">,<cfelse>NULL,</cfif>					
						<cfif isdefined("attributes.IS_OTHER_CURRENCY") and listgetat(attributes.other_currency, i,',') neq 0 ><cfqueryparam cfsqltype="cf_sql_float" value="#listgetat(attributes.other_amount, i, ',')#"><cfelse><cfif listgetat(attributes.debt, i,',') gt 0><cfqueryparam cfsqltype="cf_sql_float" value="#listgetat(attributes.debt, i, ',')#"><cfelse><cfqueryparam cfsqltype="cf_sql_float" value="#listgetat(attributes.claim, i, ',')#"></cfif></cfif>,
						<cfif isdefined("attributes.IS_OTHER_CURRENCY") and listgetat(attributes.other_currency, i,',') neq 0 ><cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(attributes.other_currency, i,',')#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#"></cfif>,
						<cfif isdefined("attributes.acc_department_id#i#") and len(evaluate("attributes.acc_department_id#i#")) and isdefined("attributes.acc_department_name#i#") and len(evaluate("attributes.acc_department_name#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.acc_department_id#i#')#"><cfelse>NULL</cfif>,
						<cfif isdefined("attributes.acc_project_id#i#") and len(evaluate("attributes.acc_project_id#i#")) and isdefined("attributes.acc_project_name#i#") and len(evaluate("attributes.acc_project_name#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.acc_project_id#i#')#"><cfelse>NULL</cfif>,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,'-')#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(detl,500)#">
					)
				</cfquery>
				<cfset acc_code_index = acc_code_index + 1>
			</cfif>
		</cfloop>
		<cfquery name="UPD_BILL_NO" datasource="#DSN2#">
			UPDATE
				BILLS
			SET 
				BILL_NO = BILL_NO+1,
				TEDIYE_BILL_NO =TEDIYE_BILL_NO+1
		</cfquery>
		<cfscript>
			f_kur_ekle_action(action_id:MAX_ID.IDENTITYCOL,process_type:0,action_table_name:'ACCOUNT_CARD_MONEY',action_table_dsn:'#dsn2#');
			if(session.ep.our_company_info.is_ifrs and attributes.show_type eq 3){
				muhasebeci_ifrs(card_id : MAX_ID.IDENTITYCOL, dsn_type : dsn2);
			}
		</cfscript>
         <cf_add_log employee_id="#session.ep.userid#" log_type="1" action_id="#MAX_ID.IDENTITYCOL#" action_name="#get_bill_no.TEDIYE_BILL_NO# Eklendi" paper_no= "#attributes.paper_no#" period_id="#session.ep.period_id#" process_type="#get_process_type.PROCESS_TYPE#" data_source="#dsn2#">
	</cftransaction>
</cflock>
<cfset attributes.actionId = #MAX_ID.IDENTITYCOL# >

<script type="text/javascript">
    window.location.href='<cfoutput>#request.self#?fuseaction=account.form_add_bill_payment&event=upd&var_=payment_card&card_id=#MAX_ID.IDENTITYCOL#</cfoutput>';
</script>
