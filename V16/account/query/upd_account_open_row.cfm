<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='45701.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
			<cfif not isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');</cfif>
	</script>
	<cfabort>
</cfif>

<cfquery name="GET_CARD_HISTORY" datasource="#dsn2#">
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
    	<cfprocparam cfsqltype="cf_sql_timestamp" value="#get_card_history.action_date#">
        <cfprocparam cfsqltype="cf_sql_timestamp" value="#get_card_history.action_date#">
        <cfprocparam cfsqltype="cf_sql_varchar" value="">
        <cfprocresult name="getNetbook">
    </cfstoredproc>
	<cfif getNetbook.recordcount>
		<script language="javascript">
            alert('<cf_get_lang dictionary_id="63221.Muhasebeci : İşlemi yapamazsınız. İşlem tarihine ait e-defter bulunmaktadır.">');
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
		hata_kod = 1; // hata kod 1 ise muhasebe kodu tanimli degil demektir
	if(hata_kod eq 0)
	{
		get_record_sub_account = cfquery(datasource : "#dsn2#", sqlstring : "SELECT SUB_ACCOUNT, ACCOUNT_CODE FROM ACCOUNT_PLAN WHERE SUB_ACCOUNT = 1 AND ACCOUNT_CODE = '#attributes.acc_code#'");
		if(get_record_sub_account.recordcount eq 1)
		  hata_kod = 2; // hata kod 2 ise muhasebe kodu tanimli ama alt hesaplari var 
	}
</cfscript>
<cfif hata_kod eq 1>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id ='47498.Muhasebe Hesapları İçinde Kayıtlı Olmayan Hesap Kodu Seçtiniz'>!");
		history.back();	
	</script>
	<cfabort>
<cfelseif hata_kod eq 2>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id ='47497.Üst Hesap Seçtiniz'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfinclude template="add_bill_history.cfm"><!--- muhasebe fisi history kaydı yazılıyor sadece guncellenen saıtr icin --->
		<cfquery name="ADD_ACCOUNT_CARD_ROW_ALICI" datasource="#DSN2#">
			UPDATE 
				ACCOUNT_CARD_ROWS 
			SET
				ACCOUNT_ID='#attributes.acc_code#',
				BA=<cfif len(attributes.debt) and attributes.debt neq 0>0,<cfelse>1,</cfif>
				ACC_BRANCH_ID=<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>#attributes.branch_id#<cfelse>NULL</cfif>,
				ACC_DEPARTMENT_ID=<cfif isdefined("attributes.acc_department_id") and len(attributes.acc_department_id)>#attributes.acc_department_id#<cfelse>NULL</cfif>,
				ACC_PROJECT_ID=<cfif isdefined("attributes.project_name") and len(attributes.project_name) and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
				AMOUNT=<cfif len(attributes.debt) and attributes.debt neq 0>#attributes.debt#,<cfelse>#attributes.claim#,</cfif>
				AMOUNT_CURRENCY='#session.ep.money#',
				AMOUNT_2=<cfif attributes.amount_2 gt 0>#attributes.amount_2#,<cfelse>NULL,</cfif>
				AMOUNT_CURRENCY_2=<cfif len(session.ep.money2)>'#session.ep.money2#',<cfelse>NULL,</cfif>
				OTHER_AMOUNT = <cfif attributes.other_cash_amount gt 0>#attributes.other_cash_amount#,<cfelse>NULL,</cfif>
				OTHER_CURRENCY = <cfif attributes.other_cash_amount gt 0>'#attributes.other_cash_currency#',<cfelse>NULL,</cfif>
			<cfif session.ep.our_company_info.is_ifrs eq 1>
				IFRS_CODE = <cfif len(attributes.ifrs_code)>'#attributes.ifrs_code#',<cfelse>NULL,</cfif> 
				ACCOUNT_CODE2 = <cfif len(attributes.account_code2)>'#attributes.account_code2#',<cfelse>NULL,</cfif>
			</cfif> 
				DETAIL = '#left(attributes.detail,500)#',
				QUANTITY = <cfif len(attributes.quantity)>#attributes.quantity#<cfelse>NULL</cfif>,
                UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = '#CGI.REMOTE_ADDR#',
				UPDATE_DATE = #NOW()#
			WHERE
				CARD_ID=#attributes.card_id# AND
				ACCOUNT_ID = '#attributes.old_acc_code#' AND
				CARD_ROW_ID =#CARD_ROW_ID#
		</cfquery>
		<cfquery name="del_acc_row_money" datasource="#dsn2#">
			DELETE FROM ACCOUNT_CARD_ROWS_MONEY WHERE ACTION_ID=#attributes.card_id# AND ACTION_ROW_ID=#CARD_ROW_ID#
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
					#CARD_ROW_ID#,
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

