<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
			<cfif not isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');</cfif>
	</script>
	<cfabort>
</cfif>
<cfif isDefined('session.ep.period_start_date') and len(session.ep.period_start_date)>
	<cfset attributes.open_date= dateformat(session.ep.period_start_date,dateformat_style)>
<cfelse>
    <cfset attributes.open_date= dateformat(session.ep.period_date,dateformat_style)>
</cfif>
<cf_date tarih='attributes.open_date'>
<!--- e-defter islem kontrolu FA --->
<cfif session.ep.our_company_info.is_edefter eq 1>
    <cfstoredproc procedure="GET_NETBOOK" datasource="#DSN2#">
    	<cfprocparam cfsqltype="cf_sql_timestamp" value="#attributes.open_date#">
        <cfprocparam cfsqltype="cf_sql_timestamp" value="#attributes.open_date#">
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
<cfscript>
	hata_kod = 0;
	get_record_account = cfquery(datasource : "#dsn2#", sqlstring : "SELECT ACCOUNT_CODE FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = '#attributes.acc_code#'");
	if(get_record_account.recordcount eq 0)
	{
	  hata_kod = 1; // hata kod 1 ise muhasebe kodu tanimli degil demektir
	}
	if(hata_kod eq 0)
	{
		get_record_sub_account = cfquery(datasource : "#dsn2#", sqlstring : "SELECT SUB_ACCOUNT, ACCOUNT_CODE FROM ACCOUNT_PLAN WHERE SUB_ACCOUNT = 1 AND ACCOUNT_CODE = '#attributes.acc_code#'");
		if(get_record_sub_account.recordcount eq 1)
		{
		  hata_kod = 2; // hata kod 1 ise muhasebe kodu tanimli ama alt hesaplari var 
		}
	}
</cfscript>
<cfif hata_kod eq 1>
	<script type="text/javascript">
		alert("<cf_get_lang no ='236.Muhasebe Hesapları İçinde Kayıtlı Olmayan Hesap Kodu Seçtiniz'>!");
		history.back();	
	</script>
	<cfabort>
<cfelseif hata_kod eq 2>
	<script type="text/javascript">
		alert("<cf_get_lang no ='235.Üst Hesap Seçtiniz'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_ACCOUNT_CARD_ROW_ALICI" datasource="#dsn2#">
			INSERT INTO
				ACCOUNT_CARD_ROWS
					(
					CARD_ID,
					ACCOUNT_ID,
					BA,
					ACC_BRANCH_ID,
					ACC_DEPARTMENT_ID,
					ACC_PROJECT_ID,
					AMOUNT,
					AMOUNT_CURRENCY,
					AMOUNT_2,
					AMOUNT_CURRENCY_2,
					OTHER_AMOUNT,
					OTHER_CURRENCY,
					<cfif session.ep.our_company_info.is_ifrs eq 1>
						IFRS_CODE,
						ACCOUNT_CODE2,
					</cfif>
					DETAIL,
					QUANTITY,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE
					)				
			VALUES
					(
					#attributes.card_id#,
					'#attributes.acc_code#',
					<cfif len(attributes.debt) and attributes.debt neq 0>0,<cfelse>1,</cfif>
					<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>#attributes.branch_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.acc_department_id") and len(attributes.acc_department_id)>#attributes.acc_department_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.project_name") and len(attributes.project_name) and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
					<cfif len(attributes.debt) and attributes.debt neq 0>#attributes.debt#,<cfelse>#attributes.claim#,</cfif>
					'#session.ep.money#',
					<cfif attributes.amount_2 gt 0>#attributes.amount_2#,<cfelse>NULL,</cfif>
					<cfif len(session.ep.money2)>'#session.ep.money2#',<cfelse>NULL,</cfif>
					<cfif attributes.other_cash_amount gt 0>#attributes.other_cash_amount#,<cfelse>NULL,</cfif>
					<cfif attributes.other_cash_amount gt 0>'#attributes.other_cash_currency#',<cfelse>NULL,</cfif>
					<cfif session.ep.our_company_info.is_ifrs eq 1>
						<cfif len(attributes.ifrs_code)>'#attributes.ifrs_code#',<cfelse>NULL,</cfif>
						<cfif len(attributes.account_code2)>'#attributes.account_code2#',<cfelse>NULL,</cfif>
					</cfif>
					'#left(attributes.detail,500)#',
					<cfif len(attributes.quantity)>#attributes.quantity#<cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					)
		</cfquery>
		<cfquery name="GET_MAX_ROW_ID" datasource="#dsn2#">
			SELECT MAX(CARD_ROW_ID) AS MAX_ROW_ID FROM ACCOUNT_CARD_ROWS WHERE CARD_ID = #attributes.card_id#
		</cfquery>
		<cfloop from="1" to="#attributes.kur_say#" index="fnc_i">
			<cfset "attributes.txt_rate2_#fnc_i#" =filterNum(evaluate("attributes.txt_rate2_#fnc_i#"),#session.ep.our_company_info.rate_round_num#)>
			<cfset "attributes.txt_rate1_#fnc_i#" =filterNum(evaluate("attributes.txt_rate1_#fnc_i#"),#session.ep.our_company_info.rate_round_num#)>
			<cfquery name="add_acc_row_money" datasource="#dsn2#">
				INSERT INTO ACCOUNT_CARD_ROWS_MONEY
				(
					ACTION_ID,
					ACTION_ROW_ID,
					MONEY_TYPE,
					RATE2,
					RATE1,
					IS_SELECTED
				)
				VALUES
				(
					#attributes.card_id#,
					#GET_MAX_ROW_ID.MAX_ROW_ID#,
					'#wrk_eval("attributes.hidden_rd_money_#fnc_i#")#',
					#evaluate("attributes.txt_rate2_#fnc_i#")#,
					#evaluate("attributes.txt_rate1_#fnc_i#")#,
				<cfif evaluate("attributes.hidden_rd_money_#fnc_i#") is attributes.other_cash_currency>
					1
				<cfelse>
					0
				</cfif>			
				)
			</cfquery>
		</cfloop>
	</cftransaction>
</cflock>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');</cfif>
</script>
