
<cfparam name="attributes.process_cat" default="">
<cfparam name="attributes.period_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.location_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.cash_id" default="">
<cfparam name="attributes.deliver_get" default="">
<cfparam name="attributes.deliver_get_id" default="">	
<cfparam name="attributes.EMPO_ID" default="">	
<cfparam name="attributes.PARTO_ID" default="">	
<cfparam name="attributes.PARTNER_NAMEO" default="">
<cfparam name="attributes.dep_name" default="">

<cfquery name="get_pro_cat_1" datasource="#DSN#_#attributes.OUR_COMPANY_ID#">
	SELECT PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (63,60,61,51,591,59,55)
</cfquery>
<cfquery name="get_period" datasource="#DSN#">
	SELECT * FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #attributes.OUR_COMPANY_ID#
</cfquery>
<cfquery  name="get_comp_money"  datasource="#DSN#">
	SELECT
		COMP_ID,
		NICK_NAME
	FROM
		SETUP_MONEY SM,
		OUR_COMPANY OC
	WHERE
		OC.COMP_ID = SM.COMPANY_ID AND
		SM.MONEY_STATUS = 1 AND
		RATE1 = RATE2 AND
		PERIOD_ID = #SESSION.EP.PERIOD_ID# AND
		MONEY = '#SESSION.EP.MONEY#' AND
		COMPANY_ID <> #SESSION.EP.COMPANY_ID#
		AND COMP_ID = #attributes.OUR_COMPANY_ID#
</cfquery>
<cfscript>
	new_dsn3 = '#dsn#_#get_comp_money.COMP_ID#';			
	if (database_type IS 'MSSQL') {new_dsn2 = '#dsn#_#get_period.PERIOD_YEAR#_#get_comp_money.COMP_ID#';new_dsn2_alias='#new_dsn2#';new_dsn3_alias = '#dsn3#';}
	else if (database_type IS 'DB2') {new_dsn2 = '#dsn#_#get_comp_money.COMP_ID#_#right(get_period.PERIOD_YEAR,2)#';new_dsn2_alias='#new_dsn2#_dbo';new_dsn3_alias = '#dsn3#_dbo';}
</cfscript>
<cfquery name="get_inv" datasource="#dsn2#">
	SELECT * FROM INVOICE_GROUP_COMP_INVOICE WHERE INVOICE_ID = #attributes.invoice_id#
</cfquery>
<cfif get_inv.recordcount >
	<cfquery name="get_pur_inv" datasource="#new_dsn2#">
		SELECT * FROM INVOICE WHERE INVOICE_ID = #get_inv.REACTION_INVOICE_ID#
	</cfquery>
	<cfquery name="get_dep_name" datasource="#DSN#">
		SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = #get_pur_inv.DEPARTMENT_ID#
	</cfquery>
	<cfscript>
		attributes.process_cat = get_pur_inv.PROCESS_CAT;
		attributes.period_id = get_inv.PERIOD_ID;
		attributes.department_id = get_pur_inv.DEPARTMENT_ID;
		attributes.dep_name = get_dep_name.DEPARTMENT_HEAD;
		attributes.location_id = get_pur_inv.DEPARTMENT_LOCATION;
		attributes.cash_id = get_pur_inv.CASH_ID;
		attributes.deliver_get = get_emp_info(get_pur_inv.DELIVER_EMP,0,0);
		attributes.deliver_get_id = get_pur_inv.DELIVER_EMP;
		attributes.EMPO_ID = get_pur_inv.SALE_EMP;
		if(len(get_pur_inv.SALE_EMP) and isnumeric(get_pur_inv.SALE_EMP))
			attributes.PARTNER_NAMEO =get_emp_info(get_pur_inv.SALE_EMP,0,0);
	</cfscript>
</cfif>
<cfquery name="KASA" datasource="#new_dsn2#">
	SELECT * FROM CASH  WHERE CASH_ACC_CODE IS NOT NULL ORDER BY CASH_NAME
</cfquery>
