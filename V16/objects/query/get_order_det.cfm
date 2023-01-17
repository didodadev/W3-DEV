<cfquery name="GET_SALE_DET" datasource="#dsn3#">
	SELECT * FROM ORDERS WHERE ORDER_ID = #attributes.order_id#
</cfquery>
<cfif not get_sale_det.recordcount>
	<script type="text/javascript">
		alert("Sipariş No Bulunamadı! Kayıtları Kontrol Ediniz!");
		window.close();
	</script>
	<cfabort>
</cfif>
<cfif len(get_sale_det.company_id) and get_sale_det.company_id neq 0>
	<cfset comp="1">
	<cfquery name="GET_SALE_DET_COMP" datasource="#DSN#">
		SELECT 
			COMPANY_ID,
			TAXOFFICE,
			TAXNO,
			COMPANY_ADDRESS,
			FULLNAME,
			SEMT,
			COMPANY_POSTCODE,
			COUNTY,
			CITY,
			COUNTRY
		FROM
			COMPANY
		WHERE 
			COMPANY.COMPANY_ID = #get_sale_det.company_id#
	</cfquery>
	<cfquery name="GET_SALE_DET_CONS" datasource="#DSN#">
		SELECT PARTNER_ID, COMPANY_PARTNER_NAME, COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID = #iif(len(get_sale_det.partner_id),get_sale_det.partner_id,0)#
	</cfquery>
<cfelseif len(get_sale_det.consumer_id) and get_sale_det.consumer_id neq 0>
	<cfquery name="GET_CONS_NAME" datasource="#DSN#">
		SELECT * FROM CONSUMER WHERE CONSUMER_ID = #get_sale_det.consumer_id#
	</cfquery>
</cfif>
<cfif GET_SALE_DET.recordcount>
	<cfquery name="GET_MONEY" datasource="#dsn3#">
		SELECT RATE1, RATE2, MONEY_TYPE, IS_SELECTED FROM ORDER_MONEY WHERE ACTION_ID = #attributes.order_id# AND IS_SELECTED = 1
	</cfquery>
</cfif>
<cfif GET_SALE_DET.recordcount>
	<cfquery name="GET_MONEY_INFO" datasource="#dsn3#">
		SELECT RATE1, RATE2, MONEY_TYPE, IS_SELECTED FROM ORDER_MONEY WHERE ACTION_ID = #attributes.order_id# AND MONEY_TYPE = '#GET_SALE_DET.OTHER_MONEY#'
	</cfquery>
	<cfquery name="GET_MONEY_INFO_SEC" datasource="#dsn3#">
		SELECT RATE1, RATE2, MONEY_TYPE, IS_SELECTED FROM ORDER_MONEY WHERE ACTION_ID = #attributes.order_id#
	</cfquery>
</cfif>
<cfif len(GET_SALE_DET.DELIVER_DEPT_ID)>
	<cfquery name="GET_STORE" datasource="#dsn#">
		SELECT DEPARTMENT_ID, DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = #GET_SALE_DET.DELIVER_DEPT_ID#
	</cfquery>
</cfif>
<cfif len(GET_SALE_DET.SHIP_METHOD)>
	<cfquery name="GET_METHOD" datasource="#dsn#">
		SELECT SHIP_METHOD_ID, SHIP_METHOD FROM SHIP_METHOD WHERE SHIP_METHOD_ID = #GET_SALE_DET.SHIP_METHOD#
	</cfquery>
</cfif>

<cfif len(GET_SALE_DET.PAYMETHOD)>
	<cfquery name="GET_METHOD2" datasource="#dsn#">
		SELECT 
			PAYMETHOD_ID,
			PAYMETHOD,
			DUE_DAY
		FROM 
			SETUP_PAYMETHOD 
		WHERE  
			PAYMETHOD_STATUS = 1 AND 
			PAYMETHOD_ID = #GET_SALE_DET.PAYMETHOD#
	</cfquery>
<cfelseif len(GET_SALE_DET.CARD_PAYMETHOD_ID)>
	<cfquery name="GET_METHOD_CARD" datasource="#dsn3#">
		SELECT CARD_NO FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID=#GET_SALE_DET.CARD_PAYMETHOD_ID#
	</cfquery>
</cfif>
