<cfquery name="INS_DELETED_ROWS" datasource="#dsn3#">
	INSERT INTO CONTRACT_PROD_DISCOUNT_DELETED_ROWS
	(PURCHASE_SALES,PROD_DISCOUNT_ID,CONTRACT_ID,PRODUCT_ID,DISCOUNT1,DISCOUNT2,DISCOUNT3,DISCOUNT4,DISCOUNT5,DISCOUNT6,DISCOUNT7,DISCOUNT8,DISCOUNT9,DISCOUNT10,PAYMETHOD_ID,DELIVERY_DATENO,COMPANY_ID,START_DATE,FINISH_DATE,RECORD_EMP,RECORD_IP,RECORD_DATE,UPDATE_EMP,UPDATE_IP,UPDATE_DATE,DEL_RECORD_DATE,DEL_RECORD_IP,DEL_RECORD_EMP)
	SELECT 0,C_P_PROD_DISCOUNT_ID,CONTRACT_ID,PRODUCT_ID,DISCOUNT1,DISCOUNT2,DISCOUNT3,DISCOUNT4,DISCOUNT5,DISCOUNT6,DISCOUNT7,DISCOUNT8,DISCOUNT9,DISCOUNT10,PAYMETHOD_ID,DELIVERY_DATENO,COMPANY_ID,START_DATE,FINISH_DATE,RECORD_EMP,RECORD_IP,RECORD_DATE,UPDATE_EMP,UPDATE_IP,UPDATE_DATE,#now()#,'#remote_addr#',#session.ep.userid#
	FROM CONTRACT_PURCHASE_PROD_DISCOUNT WHERE C_P_PROD_DISCOUNT_ID=#attributes.DISCOUNT_ID#
</cfquery>
<cfquery name="DEL_PURCHASE_PROD_DISCOUNT" datasource="#dsn3#">
	DELETE FROM
		CONTRACT_PURCHASE_PROD_DISCOUNT
	WHERE
		C_P_PROD_DISCOUNT_ID=#attributes.DISCOUNT_ID#
</cfquery>
<cf_add_log employee_id="#session.ep.userid#" log_type="-1" action_id="#attributes.DISCOUNT_ID#" action_name="#attributes.head# " period_id="#session.ep.period_id#">
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
