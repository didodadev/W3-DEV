<cfif len(attributes.card_image)>
	<cfset upload_folder = "#upload_folder##dir_seperator#finance#dir_seperator#">
	<CFTRY>
		<cffile action="UPLOAD" 
				filefield="card_image" 
				destination="#upload_folder#" 
				mode="777" 
				nameconflict="MAKEUNIQUE" accept="image/*">

		<cfset file_name = createUUID()>
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
		<!---Script dosyalarını engelle  02092010 ND --->
		<cfset assetTypeName = listlast(cffile.serverfile,'.')>
		<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
		<cfif listfind(blackList,assetTypeName,',')>
			<cffile action="delete" file="#upload_folder##file_name#.#cffile.serverfileext#">
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='32535.php,jsp,asp,cfm,cfml Formatlarında Dosya Girmeyiniz!!'>");
				history.back();
			</script>
			<cfabort>
		</cfif>
		<cfset attributes.file_name = '#file_name#.#cffile.serverfileext#'>
	
		<CFCATCH type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='57455.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'> !");
				history.back();
			</script>
			<cfabort>
		</CFCATCH>  
	</CFTRY>
</cfif>

<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="ADD_CREDITCARD_EXPENSE" datasource="#DSN3#" result="MAXID">
			INSERT
			INTO
				CREDITCARD_PAYMENT_TYPE
			(
				IS_ACTIVE,
				CARD_NO,
				CARD_IMAGE,
				CARD_IMAGE_SERVER_ID,
				BANK_ACCOUNT,
				<!---COMPANY_ID,6 aya siline FA22102013--->
				NUMBER_OF_INSTALMENT,
				P_TO_INSTALMENT_ACCOUNT,<!--- Hesaba Geçiş Günü --->
				SERVICE_RATE,
				SERVICE_ACCOUNT_CODE,
				RECORD_DATE,
				RECORD_IP,
				RECORD_EMP,
				IS_COMISSION,
				COMMISSION_PRODUCT_ID,
				COMMISSION_STOCK_ID,
				COMMISSION_MULTIPLIER,
				COMMISSION_MULTIPLIER_DSP,
				ACCOUNT_CODE,
				IS_PESIN,<!--- Banka hemen öder işlemi --->
				POS_TYPE,<!--- Sanal pos bilgisi--->
				PAYMENT_RATE,<!--- partner tek ödeme oranı --->
				PAYMENT_RATE_DSP,
				PAYMENT_RATE_ACC,
				IS_PARTNER,
				IS_PUBLIC,
				IS_SPECIAL,
				IS_COMISSION_TOTAL_AMOUNT,
				IS_PROM_CONTROL,
				PUBLIC_COMMISSION_PRODUCT_ID,
				PUBLIC_COMMISSION_STOCK_ID,
				PUBLIC_COMMISSION_MULTIPLIER,
				PUBLIC_COM_MULTIPLIER_DSP,
				FIRST_INTEREST_RATE,
				VFT_CODE,
				VFT_RATE,
                PUBLIC_MIN_AMOUNT,
                PAYMENT_MEANS_CODE,
                PAYMENT_MEANS_CODE_NAME,
				IS_CASH_REGISTER
			)
				VALUES
			(
				<cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
				'#attributes.card_no#',
				<cfif len(attributes.card_image)>'#attributes.file_name#',<cfelse>NULL,</cfif>
				<cfif len(attributes.card_image)>#fusebox.server_machine#,<cfelse>NULL,</cfif>
				<cfif len(attributes.account_id)>#attributes.account_id#<cfelse>NULL</cfif>,
				<!---<cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,6 aya siline FA22102013--->
				<cfif len(attributes.number_of_instalment)>#attributes.number_of_instalment#<cfelse>NULL</cfif>,
				<cfif len(attributes.passingday_to_instalment_account)>#attributes.passingday_to_instalment_account#<cfelse>0</cfif>,
				<cfif len(attributes.service_rate)>#attributes.service_rate#<cfelse>NULL</cfif>,
				<cfif len(attributes.service_account_code_id)>'#attributes.service_account_code_id#'<cfelse>NULL</cfif>,
				#NOW()#,
				'#CGI.REMOTE_ADDR#',
				#SESSION.EP.USERID#,
				<cfif isdefined("attributes.is_comission")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.product_id") and len(attributes.product_id)>#attributes.product_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>#attributes.stock_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.commission_multiplier)>#attributes.commission_multiplier#<cfelse>NULL</cfif>,
				<cfif len(attributes.commission_multiplier_dsp)>#attributes.commission_multiplier_dsp#<cfelse>NULL</cfif>,
				'#attributes.account_code#',
				<cfif isdefined("attributes.is_pesin")>1<cfelse>0</cfif>,
				<cfif len(attributes.pos_type)>#attributes.pos_type#<cfelse>NULL</cfif>,
				<cfif len(attributes.payment_rate)>#attributes.payment_rate#<cfelse>NULL</cfif>,
				<cfif len(attributes.payment_rate_dsp)>#attributes.payment_rate_dsp#<cfelse>NULL</cfif>,
				<cfif len(attributes.payment_rate_acc) and len(attributes.payment_rate_acc_name)>'#attributes.payment_rate_acc#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.is_partner")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_public")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_special")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_comission_total_amount")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_prom_control")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.public_product_id") and len(attributes.public_product_id)>#attributes.public_product_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.public_stock_id") and len(attributes.public_stock_id)>#attributes.public_stock_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.public_commission_multiplier)>#attributes.public_commission_multiplier#<cfelse>NULL</cfif>,
				<cfif len(attributes.public_com_multiplier_dsp)>#attributes.public_com_multiplier_dsp#<cfelse>NULL</cfif>,
				<cfif len(attributes.first_interest_rate)>#attributes.first_interest_rate#<cfelse>NULL</cfif>,
				<cfif len(attributes.vft_code)>'#attributes.vft_code#'<cfelse>NULL</cfif>,
				<cfif len(attributes.vft_rate)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.vft_rate#"><cfelse>NULL</cfif>,
				<cfif len(attributes.public_min_amount)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.public_min_amount#"><cfelse>NULL</cfif>,
                <cfif len(attributes.payment_means_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#listfirst(attributes.payment_means_code)#"><cfelse>NULL</cfif>,
                <cfif len(attributes.payment_means_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#listlast(attributes.payment_means_code)#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.is_cash_register")>1<cfelse>0</cfif>
			)
		</cfquery>
	</cftransaction>
</cflock>
<script type="text/javascript">
	location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=finance.list_credit_payment_types&event=upd&ID=<cfoutput>#MAXID.IdentityCol#</cfoutput>';
</script>
