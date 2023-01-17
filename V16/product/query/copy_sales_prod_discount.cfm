<cfset dsn3 = "#dsn#_#attributes.compid#">

<cfif len(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
</cfif>
<cfif len(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
</cfif>

<cfquery name="UPDATE_PREVIOUS_FINISH_DATE" datasource="#dsn3#" maxrows="1">
	UPDATE 
		CONTRACT_SALES_PROD_DISCOUNT 
	SET 
		FINISH_DATE=#DATEADD('s',-1,attributes.start_date)# 
	WHERE 
		PRODUCT_ID=#attributes.pid# AND 
		<cfif len(attributes.COMPANY_ID) and len(attributes.COMPANY_NAME)>
			COMPANY_ID=#attributes.COMPANY_ID# AND 
		<cfelse>
			COMPANY_ID IS NULL AND 
		</cfif>
		START_DATE < #attributes.start_date# AND 
		FINISH_DATE IS NULL
</cfquery>
<cfquery name="ADD_SALES_PROD_DISCOUNT" datasource="#dsn3#">
INSERT INTO
	CONTRACT_SALES_PROD_DISCOUNT
	(
		CONTRACT_ID,
		COMPANY_ID,
		PRODUCT_ID, 
		DISCOUNT1,
		DISCOUNT2,
		DISCOUNT3,
		DISCOUNT4,
		DISCOUNT5,
		PAYMETHOD_ID,
		DELIVERY_DATENO,
		RECORD_EMP, 
		RECORD_IP, 
		RECORD_DATE,
		START_DATE,
		FINISH_DATE
	)
VALUES
	(
		NULL,
		<cfif len(attributes.COMPANY_ID) and len(attributes.COMPANY_NAME)>#attributes.COMPANY_ID#,<cfelse>NULL,</cfif>		
		<cfif IsNumeric(attributes.pid)>#attributes.pid#,<cfelse>NULL,</cfif>
		<cfif len(attributes.DISCOUNT1)>#attributes.DISCOUNT1#,<cfelse>NULL,</cfif>
		<cfif len(attributes.DISCOUNT2)>#attributes.DISCOUNT2#,<cfelse>NULL,</cfif>
		<cfif len(attributes.DISCOUNT3)>#attributes.DISCOUNT3#,<cfelse>NULL,</cfif>
		<cfif len(attributes.DISCOUNT4)>#attributes.DISCOUNT4#,<cfelse>NULL,</cfif>
		<cfif len(attributes.DISCOUNT5)>#attributes.DISCOUNT5#,<cfelse>NULL,</cfif>
		<cfif IsNumeric(attributes.PAYMETHOD_ID)>#attributes.PAYMETHOD_ID#,<cfelse>NULL,</cfif>
		<cfif IsNumeric(attributes.DELIVERY_DATENO)>#attributes.DELIVERY_DATENO#,<cfelse>NULL,</cfif>
		#session.ep.userid#, 
		'#REMOTE_ADDR#', 
		#now()#,
		<cfif len(attributes.start_date)>#attributes.start_date#<cfelse>NULL</cfif>,
		<cfif len(attributes.finish_date)>#attributes.finish_date#<cfelse>NULL</cfif>
	)
</cfquery>

<script type="text/javascript">
	window.close();
</script>

