 <!--- islem yapilan donem session dakine uygun mu? --->
<cfif form.active_period neq session.ep.period_id>	
	<script type="text/javascript">
		alert("cf_get_lang dictionary_id='45701.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı.Muhasebe Döneminizi Kontrol Ediniz!'>");
		window.close();
	</script>
	<cfabort>
</cfif>

<cfset attributes.account_name=replacelist(attributes.account_name,"',"""," ")><!--- hesap adına tek ve cift tirnak yazilmamali --->

<cfif attributes.birlestir eq 1>
	<cfset new_acc_code= "#first_line#.#trim(attributes.account_code)#">
<cfelse>
	<cfset new_acc_code = trim(attributes.account_code)>
</cfif>

<cfif len(new_acc_code) lt 3>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='64432.Hesap Kod Uzunluğu Hatalı!'>:"+<cfoutput>#new_acc_code#</cfoutput>);
		history.back();
	</script>
</cfif>

<cfif new_acc_code neq form.old_account>
	<cfquery name="get_new" datasource="#dsn2#">
		SELECT ACCOUNT_CODE FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = '#new_acc_code#'	
	</cfquery>
	<cfif get_new.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='64433.Tanımladığınız Muhasebe Kodu Sistemde Vardır!'>");
			history.back();
		</script>
		<cfabort>	
	</cfif>
</cfif>

<cfquery name="UPD_ACCOUNT" datasource="#dsn2#">
	UPDATE
		ACCOUNT_PLAN 
	SET
	<cfif not sub_account>
		ACCOUNT_CODE = '#new_acc_code#',
	</cfif>
		ACCOUNT_NAME = '#attributes.account_name#',
	<cfif session.ep.our_company_info.is_ifrs eq 1>
		IFRS_CODE = <cfif isdefined('attributes.ifrs_code') and len(attributes.ifrs_code)>'#attributes.ifrs_code#'<cfelse>NULL</cfif>,
		IFRS_NAME = <cfif isdefined('attributes.ifrs_name') and len(attributes.ifrs_name)>'#attributes.ifrs_name#'<cfelse>NULL</cfif>,
		ACCOUNT_CODE2 =<cfif isdefined('attributes.account_code2') and len(attributes.account_code2)>'#attributes.account_code2#'<cfelse>NULL</cfif> ,
		ACCOUNT_NAME2 =<cfif isdefined('attributes.account_name2') and len(attributes.account_name2)>'#attributes.account_name2#'<cfelse>NULL</cfif> ,			
	</cfif>
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		UPDATE_DATE = #now()#
	WHERE
		ACCOUNT_ID = #ACCOUNT_ID#
</cfquery>

<cfif not sub_account>
	<cfquery name="SUB_ACCOUNTS" datasource="#dsn2#">
		UPDATE
			ACCOUNT_CARD_ROWS
		SET
			ACCOUNT_ID = '#new_acc_code#'
		<cfif session.ep.our_company_info.is_ifrs eq 1>
			<cfif isdefined('attributes.ifrs_code') and len(attributes.ifrs_code)>
			,IFRS_CODE = '#attributes.ifrs_code#'
			</cfif>
			<cfif isdefined('attributes.ifrs_code') and len(attributes.ifrs_code)>
			,ACCOUNT_CODE2 = '#attributes.ifrs_code#'
			</cfif>
		</cfif>
		WHERE
			ACCOUNT_ID ='#form.old_account#'
	</cfquery>
	<cfquery name="SUB_ACCOUNTS" datasource="#dsn2#">
		UPDATE
			ACCOUNT_CARD_SAVE_ROWS
		SET
			ACCOUNT_ID = '#new_acc_code#'
		<cfif session.ep.our_company_info.is_ifrs eq 1>
			<cfif isdefined('attributes.ifrs_code') and len(attributes.ifrs_code)>
			,IFRS_CODE = '#attributes.ifrs_code#'
			</cfif>
			<cfif isdefined('attributes.ifrs_code') and len(attributes.ifrs_code)>
			,ACCOUNT_CODE2 = '#attributes.ifrs_code#'
			</cfif>
		</cfif>
		WHERE
			ACCOUNT_ID ='#form.old_account#'
	</cfquery>	
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
