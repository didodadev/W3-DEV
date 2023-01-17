<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=account.list_cards</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cf_date tarih='attributes.process_date'>
<cf_date tarih='attributes.due_date'>
<!--- e-defter islem kontrolu FA --->
<cfif session.ep.our_company_info.is_edefter eq 1>
    <cfstoredproc procedure="GET_NETBOOK" datasource="#DSN2#">
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
<cfset acc_code_index = 1>
<cfinclude template="get_acc_process_cat.cfm"><!---işlem kategorisi--->
<cfinclude template="get_account_plan.cfm">
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
					CARD_DETAIL,
					ACTION_TYPE,
					ACTION_CAT_ID,
					BILL_NO,
					CARD_TYPE,
					CARD_CAT_ID,
					CARD_TYPE_NO,
					ACTION_DATE,
					IS_RATE_DIFF,
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
	                <cfqueryparam cfsqltype="cf_sql_varchar" value="#BILL_DETAIL#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#process_type#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#form.process_cat#">,
	                <cfqueryparam cfsqltype="cf_sql_integer" value="#get_bill_no.BILL_NO#">,
					<cfif isdefined('acc_process_type') and len(acc_process_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#acc_process_type#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="13"></cfif>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#form.process_cat#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#get_bill_no.mahsup_bill_no#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.PROCESS_DATE#">,
					<cfif isdefined('attributes.is_rate_diff') and len(attributes.is_rate_diff)>1<cfelse>0</cfif>, <!--- 1 ise kur farkı fisi --->
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
		<cfif attributes.show_type eq 2>
			<cfset table_name = "ACCOUNT_ROWS_IFRS">
		<cfelse>
			<cfset table_name = "ACCOUNT_CARD_ROWS">
		</cfif>
		<cfloop from="1" to="#attributes.rowcount#" index="i">
			<cfif acc_code_index lte listlen(attributes.acc_code,',') and (listgetat(attributes.debt,i,',') gt 0 or listgetat(attributes.claim,i,',') gt 0)>
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
							IFRS_CODE,
							ACCOUNT_CODE2,
							OTHER_AMOUNT,
							OTHER_CURRENCY,	
							IS_RATE_DIFF_ROW,						
							ACC_DEPARTMENT_ID,
							ACC_BRANCH_ID,
							ACC_PROJECT_ID,
							DETAIL
						)				
					VALUES
						(
							<cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(attributes.acc_code,acc_code_index,',')#">,
							<cfif listgetat(attributes.debt, i,',') gt 0><cfqueryparam cfsqltype="cf_sql_bit" value="0"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="1"></cfif>,
 							<cfif  isdefined("attributes.quantity") and listgetat(attributes.quantity, i,',') gt 0>'#listgetat(attributes.quantity, i,',')#'<cfelse>NULL</cfif>,
							<cfif  isdefined("attributes.price") and listgetat(attributes.price, i,',') gt 0>'#listgetat(attributes.price, i,',')#'<cfelse>NULL</cfif>, 
 							<cfif listgetat(attributes.debt, i,',') gt 0>#listgetat(attributes.debt, i, ',')#<cfelse>#listgetat(attributes.claim, i, ',')#</cfif>,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
							<cfif isdefined("attributes.amount_2") and listgetat(attributes.amount_2, i,',') gt 0>#listgetat(attributes.amount_2, i, ',')#<cfelse>NULL</cfif>,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">,
							<cfif isdefined("attributes.is_ifrs") and isdefined("attributes.ifrs_code") and listgetat(attributes.ifrs_code, i,',') neq 0>'#listgetat(attributes.ifrs_code, i, ',')#'<cfelse>NULL</cfif>,
							<cfif isdefined("attributes.IS_ACCOUNT_CODE2") and isdefined("attributes.account_code2") and listgetat(attributes.account_code2, i,',') neq 0>'#listgetat(attributes.account_code2, i, ',')#'<cfelse>NULL</cfif>,
							<cfif isdefined("attributes.IS_OTHER_CURRENCY") and listgetat(attributes.other_currency, i,',') neq 0 >#listgetat(attributes.other_amount, i, ',')#<cfelse><cfif listgetat(attributes.debt, i,',') gt 0>#listgetat(attributes.debt, i, ',')#<cfelse>#listgetat(attributes.claim, i, ',')#</cfif></cfif>,
							<cfif isdefined("attributes.IS_OTHER_CURRENCY") and listgetat(attributes.other_currency, i,',') neq 0 >'#listgetat(attributes.other_currency, i,',')#'<cfelse>'#session.ep.money#'</cfif>,
							<cfif isdefined('is_rate_diff_row_#i#') and len(evaluate('is_rate_diff_row_#i#'))>1<cfelse>0</cfif>,
							<cfif isdefined("attributes.acc_department_id#i#") and len(evaluate("attributes.acc_department_id#i#")) and isdefined("attributes.acc_department_name#i#") and len(evaluate("attributes.acc_department_name#i#"))>#evaluate("attributes.acc_department_id#i#")#<cfelse>NULL</cfif>,
							<cfif isdefined("attributes.acc_branch_id") and len(attributes.acc_branch_id)>#attributes.acc_branch_id#<cfelseif listlen(session.ep.user_location,"-") gte 2>#ListGetAt(session.ep.user_location,2,"-")#<cfelse>NULL</cfif>,
							<cfif isdefined("attributes.acc_project_id#i#") and len(evaluate("attributes.acc_project_id#i#")) and isdefined("attributes.acc_project_name#i#") and len(evaluate("attributes.acc_project_name#i#"))>#evaluate("attributes.acc_project_id#i#")#<cfelse>NULL</cfif>,
							<cfif isdefined("detl") and len(detl)>'#left(detl,500)#'<cfelseif len(attributes.BILL_DETAIL)>'#left(attributes.BILL_DETAIL,500)#'<cfelse>NULL</cfif>
						)
				</cfquery>
				<cfset acc_code_index = acc_code_index+1>
			</cfif>
		</cfloop>
		<cfquery name="UPD_BILL_NO" datasource="#DSN2#">
			UPDATE BILLS SET BILL_NO = BILL_NO+1, MAHSUP_BILL_NO = MAHSUP_BILL_NO+1
		</cfquery>
		<cfscript>
			f_kur_ekle_action(action_id:MAX_ID.IDENTITYCOL,process_type:0,action_table_name:'ACCOUNT_CARD_MONEY',action_table_dsn:'#dsn2#');
			if(session.ep.our_company_info.is_ifrs and attributes.show_type eq 3){
				muhasebeci_ifrs(card_id : MAX_ID.IDENTITYCOL, dsn_type : dsn2);
			}
		</cfscript>
         <cf_add_log employee_id="#session.ep.userid#" log_type="1" action_id="#MAX_ID.IDENTITYCOL#" action_name= "#get_bill_no.BILL_NO# Eklendi" paper_no= "#attributes.paper_no#" period_id="#session.ep.period_id#" process_type="#get_process_type.PROCESS_TYPE#" data_source="#dsn2#">  
	</cftransaction>
</cflock>

<!--- Fiş Bilgileri Servis ile Farklı W3' e Gönderilecek İse Bu Blok Çalışır --->
<cfset create_accounter_wex = createObject("component","WEX.accounter.components.WorkcubetoAccounter").init( sessions: session_base )>
<cfset comp_info = create_accounter_wex.COMP_INFO()>
<cfif isdefined("comp_info") and comp_info.IS_ACCOUNTER_INTEGRATED eq 1 and len( comp_info.ACCOUNTER_DOMAIN ) and len( comp_info.ACCOUNTER_KEY )>
	<cfset get_result = create_accounter_wex.WRK_TO_ACCOUNTER( card_id: MAX_ID.IDENTITYCOL )>
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


<cfif isdefined('attributes.is_rate_diff')> <!--- kur degerleme sayfasından mahsup fisi eklenmis ise --->
	<script type="text/javascript">
		window.location.href='<cfoutput>#request.self#?fuseaction=account.list_cards</cfoutput>';
	</script>
<cfelse>
	<cfset attributes.actionId=MAX_ID.IDENTITYCOL />
	<script type="text/javascript">
		window.location.href='<cfoutput>#request.self#?fuseaction=account.form_add_bill_cash2cash&event=upd&card_id=#MAX_ID.IDENTITYCOL#</cfoutput>';
	</script>
</cfif> 
