<cfset attributes.deliver_date_frm = createdatetime(year(attributes.invoice_date),month(attributes.invoice_date),day(attributes.invoice_date),attributes.invoice_date_h,attributes.invoice_date_m,0)>
<cfquery name="UPD_INVOICE" datasource="#dsn2#">
	UPDATE 
		INVOICE 
	SET 
	<cfif isDefined("attributes.cash")>
		KASA_ID=#KASA#,
		IS_CASH=1,
	<cfelse>
		KASA_ID=NULL,
		IS_CASH=0,
	</cfif>
	<cfif isdefined("attributes.account_id") and len(attributes.account_id)>
		BANK_ID = #attributes.account_id#,
	<cfelse>
		BANK_ID = NULL,
	</cfif>
	<cfif isDefined("attributes.EMPO_ID") and len(attributes.EMPO_ID)> 
		<cfif attributes.EMPO_ID neq 0 and len(attributes.PARTNER_NAMEO)>
			SALE_EMP=#EMPO_ID#,
			SALE_PARTNER=NULL,
		<cfelseif attributes.PARTO_ID neq 0 and len(attributes.PARTNER_NAMEO)>
			SALE_EMP=NULL,
			SALE_PARTNER=#PARTO_ID#,
		<cfelse>
			SALE_EMP=NULL,
			SALE_PARTNER=NULL,
		</cfif>
	</cfif>
	<cfif isDefined("attributes.company_id") and len(attributes.company_id) and isDefined("attributes.comp_name") and len(attributes.comp_name)>
		COMPANY_ID=#attributes.company_id#,
		PARTNER_ID=<cfif isDefined("attributes.partner_id") and len(attributes.partner_id)>#attributes.partner_id#<cfelse>NULL</cfif>,
		CONSUMER_ID=NULL,
		EMPLOYEE_ID=NULL,
	<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
		COMPANY_ID=NULL,
		PARTNER_ID=NULL,
		CONSUMER_ID=#attributes.consumer_id#,
		EMPLOYEE_ID=NULL,
	<cfelse>
		COMPANY_ID=NULL,
		PARTNER_ID=NULL,
		CONSUMER_ID=NULL,
		EMPLOYEE_ID=#attributes.employee_id#,
	</cfif>
		IS_IPTAL=0,
		CANCEL_TYPE_ID = NULL,
		<cfif session.ep.our_company_info.project_followup eq 1>
			PROJECT_ID = <cfif len(attributes.project_id) and len(attributes.project_head)>#attributes.project_id#,<cfelse>NULL,</cfif>
		</cfif>
		COMMETHOD_ID = <cfif isDefined("attributes.commethod_id") and len(attributes.commethod_id)>#attributes.commethod_id#<cfelse>NULL</cfif>,
		DEPARTMENT_ID=#attributes.department_id#,
		DEPARTMENT_LOCATION=#attributes.location_id#,
		SHIP_METHOD=<cfif isdefined('attributes.SHIP_METHOD') and len(attributes.SHIP_METHOD)>#attributes.SHIP_METHOD#<cfelse>NULL</cfif>,
		PAY_METHOD=<cfif isdefined('attributes.paymethod_id') and len(attributes.paymethod_id) and isdefined('attributes.paymethod') and len(attributes.paymethod)>#attributes.paymethod_id#<cfelse>NULL</cfif>,
		ZONE_ID=<cfif isdefined("get_customer_info.SALES_COUNTY") and len(get_customer_info.SALES_COUNTY)>#get_customer_info.SALES_COUNTY#<cfelse>NULL</cfif>,
		NOTE=<cfif isDefined("NOTE") and len(NOTE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#NOTE#"><cfelse>NULL</cfif>,
		DELIVER_EMP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LEFT(TRIM(DELIVER_GET),50)#">,
		INVOICE_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.INVOICE_NUMBER#">,
		SERIAL_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.SERIAL_NUMBER#">,
		SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.SERIAL_NO#">,
		INVOICE_DATE = #attributes.invoice_date#,
		SHIP_DATE = <cfif isdefined("attributes.ship_date") and len(attributes.ship_date) and isdate(attributes.ship_date)>#attributes.ship_date#<cfelse>NULL</cfif>,
		DUE_DATE = <cfif len(invoice_due_date) and isdate(invoice_due_date)>#invoice_due_date#<cfelse>NULL</cfif>,		
		UPDATE_DATE = #NOW()#,
		INVOICE_CAT = #INVOICE_CAT#,
		NETTOTAL=#form.basket_net_total#,
		GROSSTOTAL=#form.basket_gross_total#,
		TAXTOTAL=#form.basket_tax_total#,
		OTV_TOTAL =	<cfif len(form.basket_otv_total)>#form.basket_otv_total#<cfelse>NULL</cfif>,
		SA_DISCOUNT = #form.genel_indirim#,
		UPDATE_EMP=#SESSION.EP.USERID#,
		OTHER_MONEY=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.basket_money#">,
		OTHER_MONEY_VALUE=#(form.BASKET_NET_TOTAL/form.basket_rate2)#,<!--- #form.basket_rate2# --->
		PROCESS_CAT = #FORM.PROCESS_CAT#,
		IS_COST = <cfif isDefined("attributes.is_cost") and Len(attributes.is_cost)>#attributes.is_cost#<cfelse>0</cfif>,
		REF_NO  = <cfif isdefined("attributes.ref_no") and len(attributes.ref_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ref_no#"><cfelse>NULL</cfif>,
		GENERAL_PROM_ID=<cfif isdefined("attributes.general_prom_id") and len(attributes.general_prom_id)>#attributes.general_prom_id#<cfelse>NULL</cfif>,
		GENERAL_PROM_LIMIT=<cfif isdefined("attributes.general_prom_limit") and len(attributes.general_prom_limit)>#attributes.general_prom_limit#<cfelse>NULL</cfif>,
		GENERAL_PROM_AMOUNT=<cfif isdefined("attributes.general_prom_amount") and len(attributes.general_prom_amount)>#attributes.general_prom_amount#<cfelse>NULL</cfif>,
		GENERAL_PROM_DISCOUNT=<cfif isdefined("attributes.general_prom_discount") and len(attributes.general_prom_discount)>#attributes.general_prom_discount#<cfelse>NULL</cfif>,
		FREE_PROM_ID=<cfif isdefined("attributes.free_prom_id") and len(attributes.free_prom_id)>#attributes.free_prom_id#<cfelse>NULL</cfif>,
		FREE_PROM_LIMIT=<cfif isdefined("attributes.free_prom_limit") and len(attributes.free_prom_limit)>#attributes.free_prom_limit#<cfelse>NULL</cfif>,
		FREE_PROM_AMOUNT=<cfif isdefined("attributes.free_prom_amount") and len(attributes.free_prom_amount)>#attributes.free_prom_amount#<cfelse>NULL</cfif>,
		FREE_PROM_COST=<cfif isdefined("attributes.free_prom_cost") and len(attributes.free_prom_cost)>#attributes.free_prom_cost#<cfelse>NULL</cfif>,
		FREE_PROM_STOCK_ID=<cfif isdefined("attributes.free_prom_stock_id") and len(attributes.free_prom_stock_id)>#attributes.free_prom_stock_id#<cfelse>NULL</cfif>,
		FREE_STOCK_PRICE=<cfif isdefined("attributes.free_stock_price") and len(attributes.free_stock_price)>#attributes.free_stock_price#<cfelse>NULL</cfif>,
		FREE_STOCK_MONEY=<cfif isdefined("attributes.free_stock_money") and len(attributes.free_stock_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.free_stock_money#"><cfelse>NULL</cfif>,
		TEVKIFAT = <cfif isdefined("attributes.tevkifat_box")>1<cfelse>0</cfif>,
		TEVKIFAT_ORAN = <cfif isdefined("attributes.tevkifat_oran") and len(attributes.tevkifat_oran)>#attributes.tevkifat_oran#<cfelse>NULL</cfif>,
		TEVKIFAT_ID = <cfif isdefined("attributes.tevkifat_id") and len(attributes.tevkifat_id)>#attributes.tevkifat_id#<cfelse>NULL</cfif>,
	<cfif isdefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)>
		CARD_PAYMETHOD_ID= #attributes.card_paymethod_id#,
		CARD_PAYMETHOD_RATE = <cfif isdefined("attributes.commission_rate") and len(attributes.commission_rate)>#attributes.commission_rate#,<cfelse>NULL,</cfif>
	<cfelse>
		CARD_PAYMETHOD_ID= NULL,
		CARD_PAYMETHOD_RATE = NULL,
	</cfif>
		SHIP_ADDRESS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.adres#">,
		SHIP_ADDRESS_ID = <cfif isdefined("attributes.ship_address_id") and len(attributes.ship_address_id) and isdefined("attributes.adres") and len(attributes.adres)>#attributes.ship_address_id#<cfelse>NULL</cfif>,
		RESOURCE_ID = <cfif isdefined("get_customer_info.RESOURCE_ID") and len(get_customer_info.RESOURCE_ID)>#get_customer_info.RESOURCE_ID#<cfelse>NULL</cfif>,
		IMS_CODE_ID = <cfif isdefined("get_customer_info.IMS_CODE_ID") and len(get_customer_info.IMS_CODE_ID)>#get_customer_info.IMS_CODE_ID#<cfelse>NULL</cfif>,
		IS_TAX_OF_OTV = <cfif isdefined('attributes.basket_otv_from_tax_price') and len(attributes.basket_otv_from_tax_price)>#attributes.basket_otv_from_tax_price#<cfelse>NULL</cfif>,
		CUSTOMER_VALUE_ID = <cfif isdefined("get_customer_info.CUSTOMER_VALUE_ID") and len(get_customer_info.CUSTOMER_VALUE_ID)>#get_customer_info.CUSTOMER_VALUE_ID#<cfelse>NULL</cfif>,
		SALES_PARTNER_ID = <cfif len(attributes.sales_member) and (attributes.sales_member_type is "partner")>#attributes.sales_member_id#<cfelse>NULL</cfif>,
		SALES_CONSUMER_ID = <cfif len(attributes.sales_member) and (attributes.sales_member_type is "consumer")>#attributes.sales_member_id#<cfelse>NULL</cfif>,
		CONSUMER_REFERENCE_CODE = <cfif isdefined('attributes.consumer_reference_code') and len(attributes.consumer_reference_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.consumer_reference_code#"><cfelse>NULL</cfif>,
		PARTNER_REFERENCE_CODE = <cfif isdefined('attributes.partner_reference_code') and len(attributes.partner_reference_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.partner_reference_code#"><cfelse>NULL</cfif>,
		CARI_ACTION_TYPE = <!--- parçalı cari işlemi tutuyor --->
			<cfif isDefined("attributes.invoice_payment_plan") and attributes.invoice_payment_plan eq 0>
				<!--- FBS 20120711 Odeme Planini Yeniden Olusturmamasi Icin Type Degerinin Tasinmasi Gerekiyor --->
				<cfif isDefined("attributes.invoice_cari_action_type") and Len(attributes.invoice_cari_action_type)>#attributes.invoice_cari_action_type#<cfelse>4</cfif>
			<cfelse>
				0
			</cfif>, 
		SALES_TEAM_ID = <cfif isdefined("attributes.EMPO_ID") and len(attributes.EMPO_ID) and len(emp_team_id)>#emp_team_id#<cfelse>NULL</cfif>,
		ASSETP_ID = <cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>#attributes.asset_id#<cfelse>NULL</cfif>,
		SUBSCRIPTION_ID = <cfif isdefined("attributes.subscription_id") and len(attributes.subscription_no) and len(attributes.subscription_id)>#attributes.subscription_id#<cfelse>NULL</cfif>,
		ACC_DEPARTMENT_ID = <cfif isdefined("attributes.acc_department_id") and len(attributes.acc_department_id)>#attributes.acc_department_id#<cfelse>NULL</cfif>,
		CONTRACT_ID = <cfif (isdefined('attributes.contract_no') and len(attributes.contract_no)) and isdefined('attributes.contract_id') and len(attributes.contract_id)>#attributes.contract_id#<cfelse>NULL</cfif>,
		STOPAJ = <cfif isdefined("form.stopaj") and len(form.stopaj)>#form.stopaj#<cfelse>NULL</cfif>,
		STOPAJ_ORAN = <cfif isdefined("form.stopaj_yuzde") and len(form.stopaj_yuzde)>#form.stopaj_yuzde#<cfelse>NULL</cfif>,
		STOPAJ_RATE_ID = <cfif isdefined("form.stopaj_rate_id") and len(form.stopaj_rate_id)>#form.stopaj_rate_id#<cfelse>NULL</cfif>,
		ACC_TYPE_ID = <cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>#attributes.acc_type_id#<cfelse>NULL</cfif>,
		PROFILE_ID = <cfif isdefined("inv_profile_id") and len(inv_profile_id)>'#inv_profile_id#'<cfelse>NULL</cfif>,
        SERVICE_ID = <cfif isdefined("attributes.service_id") and len(attributes.service_id)>#attributes.service_id#<cfelse>NULL</cfif>,
		REALIZATION_DATE = <cfif isdefined("attributes.realization_date") and len(attributes.realization_date) and isdate(attributes.realization_date)>#attributes.realization_date#<cfelse>NULL</cfif>,
		PROCESS_TIME=#attributes.deliver_date_frm#,
        BSMV_TOTAL = <cfif isdefined("attributes.total_bsmv") and len(attributes.total_bsmv)>#attributes.total_bsmv#<cfelse>0</cfif>,
		OIV_TOTAL = <cfif isdefined("attributes.total_oiv") and len(attributes.total_oiv)>#attributes.total_oiv#<cfelse>0</cfif>,
		VAT_EXCEPTION_ID = <cfif isdefined("form.exc_id") and len(form.exc_id)>#form.exc_id#<cfelse>NULL</cfif>,
		PROCESS_STAGE = <cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>#attributes.process_stage#<cfelse>NULL</cfif>,
		PAYMENT_COMPANY_ID = <cfif isDefined("attributes.payment_company_id") and len(attributes.payment_company_id) and isDefined("attributes.payment_comp_name") and len(attributes.payment_comp_name)>#attributes.payment_company_id#<cfelse>NULL</cfif>
	WHERE 
		INVOICE_ID = #form.invoice_id#
</cfquery>
