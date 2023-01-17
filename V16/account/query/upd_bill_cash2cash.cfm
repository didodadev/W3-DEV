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
    <cfstoredproc procedure="GET_NETBOOK" datasource="#DSN2#">
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
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfinclude template="add_bill_history.cfm"><!--- muhasebe fisi history kaydı yazılıyor --->
		<cfquery name="DEL_ROWS" datasource="#DSN2#">
			DELETE FROM ACCOUNT_CARD_ROWS WHERE CARD_ID=#attributes.CARD_ID#
			DELETE FROM ACCOUNT_ROWS_IFRS WHERE CARD_ID=#attributes.CARD_ID#
		</cfquery> 
		<cfquery name="UPD_ACCOUNT_CARD" datasource="#dsn2#">
			UPDATE
				ACCOUNT_CARD
			SET
				IS_OTHER_CURRENCY = <cfif isdefined("attributes.IS_OTHER_CURRENCY")>1<cfelse>0</cfif>,
				IS_ACCOUNT_CODE2 = <cfif isdefined("attributes.IS_ACCOUNT_CODE2")>1<cfelse>0</cfif>,
				CARD_DETAIL = '#left(ATTRIBUTES.BILL_DETAIL,150)#',
				CARD_TYPE_NO = #attributes.MAHSUP_BILL_NO#,
				CARD_CAT_ID = #form.process_cat#,
				<cfif not len(attributes.action_id)>
					ACTION_TYPE = #process_type#,
					ACTION_CAT_ID = #form.process_cat#,
				</cfif>
				CARD_TYPE=<cfif isdefined('acc_process_type') and len(acc_process_type)>#acc_process_type#<cfelse>13</cfif>,
				ACTION_DATE = #attributes.PROCESS_DATE#,
                CARD_DOCUMENT_TYPE = <cfif isdefined("attributes.document_type") and len(attributes.document_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.document_type#"><cfelse>NULL</cfif>,
                CARD_PAYMENT_METHOD = <cfif isdefined("attributes.payment_type") and len(attributes.payment_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.payment_type#"><cfelse>NULL</cfif>,
                PAPER_NO = <cfif isdefined("attributes.paper_no") and len(attributes.paper_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_no#"><cfelse>NULL</cfif>,
                DUE_DATE = <cfif isdefined("attributes.document_type") and (attributes.document_type eq -1 or attributes.document_type eq -3) and isdefined("attributes.due_date") and len(attributes.due_date)><cfqueryparam cfsqltype="cf_sql_date" value="#attributes.due_date#"><cfelse>NULL</cfif>,
                UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = '#CGI.REMOTE_ADDR#',
				UPDATE_DATE = #NOW()# ,
				RECORD_TYPE = <cfif isdefined("attributes.show_type") and len(attributes.show_type)>#attributes.show_type#<cfelse>1</cfif>
			WHERE
				CARD_ID = #attributes.CARD_ID#
		</cfquery>
		<cfif attributes.show_type eq 2>
			<cfset table_name = "ACCOUNT_ROWS_IFRS">
		<cfelse>
			<cfset table_name = "ACCOUNT_CARD_ROWS">
		</cfif>
		<cfloop from="1" to="#attributes.rowCount#" index="i">
			<cfif acc_code_index lte listlen(attributes.acc_code,',') and ( listgetat(attributes.debt,i,',') gt 0 or listgetat(attributes.claim,i,',') gt 0 or (listgetat(attributes.debt,i,',') lte 0 and listgetat(attributes.claim,i,',') lte 0 and listgetat(attributes.other_amount,i,',') gt 0) )>
				<!--- wrk_not : acc_code listesi diger form elemanlarina gore eksik gelebildigi icin (satir silmeden dolayi) rakami dolu olan elemanlar icin kendi icindeki sira (acc_code_index) ile seciliyor  --->
				<cfset detl = evaluate("attributes.detail_#i#")>
				<cfquery name="ADD_ACCOUNT_CARD_ROW_ALICI" datasource="#dsn2#">
					INSERT INTO
						#table_name#
						(
							CARD_ID,
							ACCOUNT_ID,
							BA,
							QUANTITY,
							PRICE,
							AMOUNT,
							AMOUNT_CURRENCY,
							AMOUNT_2,
							AMOUNT_CURRENCY_2,				
							OTHER_AMOUNT,
							OTHER_CURRENCY,
							IFRS_CODE,
							ACCOUNT_CODE2,
							ACC_DEPARTMENT_ID,
							ACC_BRANCH_ID,
							ACC_PROJECT_ID,
							DETAIL
						)				
					VALUES
						(
							#attributes.CARD_ID#,
							'#listgetat(attributes.acc_code,acc_code_index,',')#',
							<cfif listgetat(attributes.debt,i,',') gt 0>0,<cfelse>1,</cfif>
							<cfif isdefined("attributes.quantity") and listgetat(attributes.quantity, i,',') gt 0>'#listgetat(attributes.quantity, i,',')#'<cfelse>NULL</cfif>,
							<cfif isdefined("attributes.price") and listgetat(attributes.price, i,',') gt 0>'#listgetat(attributes.price, i,',')#'<cfelse>NULL</cfif>,
							<cfif listgetat(attributes.debt,i,',') gt 0>#listgetat(attributes.debt,i,',')#,<cfelse>#listgetat(attributes.claim,i,',')#,</cfif>
							'#session.ep.money#',
							<cfif isdefined("attributes.amount_2") and listgetat(attributes.amount_2, i,',') gt 0>#listgetat(attributes.amount_2, i, ',')#<cfelse>NULL</cfif>,
							'#session.ep.money2#',					
							<cfif isdefined("attributes.IS_OTHER_CURRENCY") and listgetat(attributes.other_currency, i,',') neq 0 >#listgetat(attributes.other_amount, i, ',')#<cfelse><cfif listgetat(attributes.debt, i,',') gt 0>#listgetat(attributes.debt, i, ',')#<cfelse>#listgetat(attributes.claim, i, ',')#</cfif></cfif>,
							<cfif isdefined("attributes.IS_OTHER_CURRENCY") and listgetat(attributes.other_currency, i,',') neq 0 >'#listgetat(attributes.other_currency, i,',')#'<cfelse>'#session.ep.money#'</cfif>,
							<cfif isdefined("attributes.is_ifrs") and isdefined("attributes.ifrs_code") and listgetat(attributes.ifrs_code, i,',') neq 0>'#listgetat(attributes.ifrs_code, i, ',')#',<cfelse>NULL,</cfif>
							<cfif isdefined("attributes.IS_ACCOUNT_CODE2") and isdefined("attributes.account_code2") and listgetat(attributes.account_code2, i,',') neq 0>'#listgetat(attributes.account_code2, i, ',')#',<cfelse>NULL,</cfif>
							<cfif isdefined("attributes.acc_department_id#i#") and len(evaluate("attributes.acc_department_id#i#")) and isdefined("attributes.acc_department_name#i#") and len(evaluate("attributes.acc_department_name#i#"))>#evaluate("attributes.acc_department_id#i#")#<cfelse>NULL</cfif>,
							<cfif isdefined("attributes.acc_branch_id") and len(attributes.acc_branch_id)>#attributes.acc_branch_id#<cfelse>#ListGetAt(session.ep.user_location,2,"-")#</cfif>,
							<cfif isdefined("attributes.acc_project_id#i#") and len(evaluate("attributes.acc_project_id#i#")) and isdefined("attributes.acc_project_name#i#") and len(evaluate("attributes.acc_project_name#i#"))>#evaluate("attributes.acc_project_id#i#")#<cfelse>NULL</cfif>,
							'#left(detl,500)#'
						)
				</cfquery>
				<cfset acc_code_index = acc_code_index+1>
			</cfif>
		</cfloop>
		<cfscript>
			f_kur_ekle_action(action_id:attributes.CARD_ID,process_type:1,action_table_name:'ACCOUNT_CARD_MONEY',action_table_dsn:'#dsn2#');
			if(session.ep.our_company_info.is_ifrs and attributes.show_type eq 3){
				muhasebeci_ifrs(card_id :attributes.CARD_ID, dsn_type : dsn2);
			}
		</cfscript>
        <cf_add_log employee_id="#session.ep.userid#" log_type="0" action_id="#attributes.CARD_ID#" action_name= "#attributes.MAHSUP_BILL_NO# Güncellendi" paper_no= "#attributes.paper_no#" period_id="#session.ep.period_id#" process_type="#get_process_type.PROCESS_TYPE#" data_source="#dsn2#"> 
	</cftransaction>

	<!--- Fiş Bilgileri Servis ile Farklı W3' e Gönderilecek İse Bu Blok Çalışır --->
	<cfset create_accounter_wex = createObject("component","WEX.accounter.components.WorkcubetoAccounter").init( sessions: session_base )>
	<cfset comp_info = create_accounter_wex.COMP_INFO()>
	<cfif isdefined("comp_info") and comp_info.IS_ACCOUNTER_INTEGRATED eq 1 and len( comp_info.ACCOUNTER_DOMAIN ) and len( comp_info.ACCOUNTER_KEY )>
		<cfset get_result = create_accounter_wex.WRK_TO_ACCOUNTER( card_id: attributes.card_id )>
		<cfif get_result.STATUS >
			<script>
				alert("<cfoutput>#get_result.MESSAGE#</cfoutput>");
			</script>
		<cfelse>
			<script>
				alert("<cfoutput>#get_result.MESSAGE#</cfoutput>");
			</script>
		</cfif>
	</cfif>
	<!--- Fiş Bilgileri Servis ile Farklı W3' e Gönderilecek İse Bu Blok Çalışır --->
</cflock>
<cfset attributes.actionId=attributes.card_id />
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=account.form_add_bill_cash2cash&event=upd&card_id=#attributes.CARD_ID#</cfoutput>';
</script>
