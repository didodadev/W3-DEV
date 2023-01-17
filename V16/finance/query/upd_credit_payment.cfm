<cfif len(attributes.card_image)>
	<cfset upload_folder = "#upload_folder##dir_seperator#finance#dir_seperator#">
	<cftry>
		<cffile action="UPLOAD" 
				filefield="card_image" 
				destination="#upload_folder#" 
				mode="777" 
				nameconflict="MAKEUNIQUE" accept="image/*">
		<cfset file_name = createUUID()>
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
		<cfset assetTypeName = listlast(cffile.serverfile,'.')>
		<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
		<cfif listfind(blackList,assetTypeName,',')>
			<cffile action="delete" file="#upload_folder##file_name#.#cffile.serverfileext#">
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='47804.php,jsp,asp,cfm,cfml Formatlarında Dosya Girmeyiniz!!'>");
				history.back();
			</script>
			<cfabort>
		</cfif>
		<cfset attributes.file_name = '#file_name#.#cffile.serverfileext#'>
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='57455.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'>");
				history.back();
			</script>
			<cfabort>
		</cfcatch>  
	</cftry>
	<cfif len(attributes.old_card_image)>
		<cf_del_server_file output_file="finance/#attributes.old_card_image#" output_server="#attributes.old_card_image_server_id#">
	</cfif>
</cfif>
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>	
		<cfquery name="ADD_CREDITCARD_EXPENSE" datasource="#DSN3#">
			UPDATE
				CREDITCARD_PAYMENT_TYPE
			SET
				IS_ACTIVE = <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
				CARD_NO = '#attributes.card_no#',
				CARD_IMAGE = <cfif len(attributes.card_image)>'#attributes.file_name#',<cfelse>'#attributes.old_card_image#',</cfif>
				CARD_IMAGE_SERVER_ID = <cfif len(attributes.card_image)>#fusebox.server_machine#,<cfelseif len(attributes.old_card_image_server_id)>#attributes.old_card_image_server_id#,<cfelse>NULL,</cfif>
				BANK_ACCOUNT = <cfif len(attributes.account_id)>#attributes.account_id#<cfelse>NULL</cfif>,
				<!---COMPANY_ID = <cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,6 aya siline FA22102013--->
				NUMBER_OF_INSTALMENT = <cfif len(attributes.number_of_instalment)>#attributes.number_of_instalment#<cfelse>NULL</cfif>,
				P_TO_INSTALMENT_ACCOUNT = <cfif len(attributes.passingday_to_instalment_account)>#attributes.passingday_to_instalment_account#<cfelse>0</cfif>,
				SERVICE_RATE = <cfif len(attributes.service_rate)>#attributes.service_rate#<cfelse>NULL</cfif>,
				SERVICE_ACCOUNT_CODE = <cfif len(attributes.service_account_code_id) and len(attributes.service_account_code)>'#attributes.service_account_code_id#'<cfelse>NULL</cfif>,
				COMMISSION_PRODUCT_ID=<cfif len(attributes.product_id) and len(attributes.product_name)>#attributes.product_id#<cfelse>NULL</cfif>,
				COMMISSION_STOCK_ID=<cfif len(attributes.stock_id) and len(attributes.product_name)>#attributes.stock_id#<cfelse>NULL</cfif>,
				COMMISSION_MULTIPLIER = <cfif len(attributes.commission_multiplier)>#attributes.commission_multiplier#<cfelse>NULL</cfif>,
				COMMISSION_MULTIPLIER_DSP = <cfif len(attributes.commission_multiplier_dsp)>#attributes.commission_multiplier_dsp#<cfelse>NULL</cfif>,
				ACCOUNT_CODE = '#attributes.account_code#',
				IS_PESIN = <cfif isdefined("attributes.is_pesin")>1<cfelse>0</cfif>,
				POS_TYPE = <cfif len(attributes.pos_type)>#attributes.pos_type#<cfelse>NULL</cfif>,
				PAYMENT_RATE = <cfif len(attributes.payment_rate)>#attributes.payment_rate#<cfelse>NULL</cfif>,
				PAYMENT_RATE_DSP = <cfif len(attributes.payment_rate_dsp)>#attributes.payment_rate_dsp#<cfelse>NULL</cfif>,
				PAYMENT_RATE_ACC = <cfif len(attributes.payment_rate_acc) and len(attributes.payment_rate_acc_name)>'#attributes.payment_rate_acc#'<cfelse>NULL</cfif>,
				IS_PARTNER = <cfif isdefined("attributes.is_partner")>1<cfelse>0</cfif>,
				IS_PUBLIC = <cfif isdefined("attributes.is_public")>1<cfelse>0</cfif>,
				IS_SPECIAL = <cfif isdefined("attributes.is_special")>1<cfelse>0</cfif>,
				IS_CASH_REGISTER = <cfif isdefined("attributes.is_cash_register")>1<cfelse>0</cfif>,
				IS_COMISSION_TOTAL_AMOUNT = <cfif isdefined("attributes.is_comission_total_amount")>1<cfelse>0</cfif>,
				IS_PROM_CONTROL = <cfif isdefined("attributes.is_prom_control")>1<cfelse>0</cfif>,
				PUBLIC_COMMISSION_PRODUCT_ID = <cfif isdefined("attributes.public_product_id") and len(attributes.public_product_id) and len(attributes.public_product_name)>#attributes.public_product_id#<cfelse>NULL</cfif>,
				PUBLIC_COMMISSION_STOCK_ID = <cfif isdefined("attributes.public_stock_id") and len(attributes.public_stock_id) and len(attributes.public_product_name)>#attributes.public_stock_id#<cfelse>NULL</cfif>,
				PUBLIC_COMMISSION_MULTIPLIER = <cfif len(attributes.public_commission_multiplier)>#attributes.public_commission_multiplier#<cfelse>NULL</cfif>,
				PUBLIC_COM_MULTIPLIER_DSP = <cfif len(attributes.public_com_multiplier_dsp)>#attributes.public_com_multiplier_dsp#<cfelse>NULL</cfif>,
				FIRST_INTEREST_RATE = <cfif len(attributes.first_interest_rate)>#attributes.first_interest_rate#<cfelse>NULL</cfif>,
				VFT_CODE = <cfif len(attributes.vft_code)>'#attributes.vft_code#'<cfelse>NULL</cfif>,
				VFT_RATE = <cfif len(attributes.vft_rate)>#attributes.vft_rate#<cfelse>NULL</cfif>,
				UPDATE_DATE = #NOW()#,
				UPDATE_IP = '#CGI.REMOTE_ADDR#',
				UPDATE_EMP = #SESSION.EP.USERID#,
                PUBLIC_MIN_AMOUNT = <cfif len(attributes.public_min_amount)>#attributes.public_min_amount#<cfelse>NULL</cfif>,
                PAYMENT_MEANS_CODE = <cfif len(attributes.payment_means_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#listfirst(attributes.payment_means_code)#"><cfelse>NULL</cfif>,
                PAYMENT_MEANS_CODE_NAME = <cfif len(attributes.payment_means_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#listlast(attributes.payment_means_code)#"><cfelse>NULL</cfif>
			WHERE
				PAYMENT_TYPE_ID = #attributes.id#
		</cfquery>
	</cftransaction>
</cflock>
<cfset attributes.actionId = attributes.id>
<script type="text/javascript">
	location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=finance.list_credit_payment_types&event=upd&ID=<cfoutput>#attributes.actionId#</cfoutput>';
</script>