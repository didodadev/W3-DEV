<CFTRANSACTION>
<!--- GENERAL_PREMIUM --->
<cfif attributes.record_num>
	<cfloop FROM="1" TO="#attributes.record_num#" INDEX="i">
	<cfif evaluate("attributes.row_kontrol#I#") neq 0>
		<cfquery name="ADD_PURCHASE_GENERAL_PREMIUM" datasource="#dsn3#">
		INSERT INTO
			CONTRACT_PURCHASE_GENERAL_PREMIUM
			(
			CONTRACT_ID,
			PERIOD,
			TUTAR1,
			MONEY,
			PREMIUM_TYPE_RATE_AMOUNT,
			PREMIUM,
			RECORD_EMP, RECORD_IP, RECORD_DATE
			)
		VALUES
			(
			#CONTRACT_ID#,
			<cfif isDefined("attributes.PERIOD#i#")>#evaluate("attributes.PERIOD#i#")#<cfelse>NULL</cfif>,
			<cfif len(evaluate("attributes.TUTAR1#i#"))>#evaluate("attributes.TUTAR1#i#")#<cfelse>0</cfif>,
			<cfif isDefined("attributes.MONEY#i#")>'#wrk_eval("attributes.MONEY#i#")#'<cfelse>NULL</cfif>,
			#evaluate("attributes.PREMIUM_TYPE_RATE_AMOUNT#i#")#,
			<cfif len(evaluate("attributes.PREMIUM#i#"))>#evaluate("attributes.PREMIUM#i#")#<cfelse>NULL</cfif>,
			#session.ep.userid#, '#REMOTE_ADDR#', #now()#
			)
		</cfquery>
	</cfif>
	</cfloop>
</cfif>
<!--- //GENERAL_PREMIUM --->
<!--- RETAIL --->
<cfif Len(attributes.GENERAL_JOIN) OR Len(attributes.YEARLY_USE) OR Len(attributes.ENTRANCE)>
	<cfquery name="ADD_PURCHASE_RETAIL" datasource="#dsn3#">
	INSERT INTO
		CONTRACT_PURCHASE_RETAIL
		(
		CONTRACT_ID,
		GENERAL_JOIN, GENERAL_JOIN_MONEY,
		YEARLY_USE, YEARLY_USE_MONEY,
		ENTRANCE, ENTRANCE_MONEY,
		RECORD_EMP, RECORD_IP, RECORD_DATE
		)
	VALUES
		(
		#CONTRACT_ID#,
		<cfif len(attributes.GENERAL_JOIN)>#attributes.GENERAL_JOIN#,<cfelse>NULL,</cfif> '#attributes.GENERAL_JOIN_MONEY#', 
		<cfif len(attributes.YEARLY_USE)>#attributes.YEARLY_USE#,<cfelse>NULL,</cfif> '#attributes.YEARLY_USE_MONEY#', 
		<cfif len(attributes.ENTRANCE)>#attributes.ENTRANCE#,<cfelse>NULL,</cfif> '#attributes.ENTRANCE_MONEY#', 
		#session.ep.userid#, '#REMOTE_ADDR#', #now()#
		)
	</cfquery>
</cfif>
<!--- //RETAIL --->
<!--- DUE --->
<cfif Len(attributes.NORMAL_DUE) OR Len(attributes.EXTRA_DUE) OR Len(attributes.CASH_PROPERTY_DUE) OR Len(attributes.OPENING_DUE) OR Len(attributes.NEW_LIST_DUE)>
	<cfquery name="ADD_PURCHASE_DUE" datasource="#dsn3#">
	INSERT INTO
		CONTRACT_PURCHASE_DUE
		(
		CONTRACT_ID,
		NORMAL_DUE,
		EXTRA_DUE,
		CASH_PROPERTY_DUE,
		OPENING_DUE,
		NEW_LIST_DUE,
		RECORD_EMP, RECORD_IP, RECORD_DATE
		)
	VALUES
		(
		#CONTRACT_ID#,
		<cfif len(attributes.NORMAL_DUE)>#attributes.NORMAL_DUE#,<cfelse>NULL,</cfif>
		<cfif len(attributes.EXTRA_DUE)>#attributes.EXTRA_DUE#,<cfelse>NULL,</cfif>
		<cfif len(attributes.CASH_PROPERTY_DUE)>#attributes.CASH_PROPERTY_DUE#,<cfelse>NULL,</cfif>
		<cfif len(attributes.OPENING_DUE)>#attributes.OPENING_DUE#,<cfelse>NULL,</cfif>
		<cfif len(attributes.NEW_LIST_DUE)>#attributes.NEW_LIST_DUE#,<cfelse>NULL,</cfif>
		#session.ep.userid#, '#REMOTE_ADDR#', #now()#
		)
	</cfquery>
</cfif>
<!--- //DUE --->
<!--- PHYSICAL --->
<cfif Isdefined("attributes.IS_CENTRAL_STORE") OR Isdefined("attributes.IS_ALL_STORE") OR Len(attributes.DELIVERY_DATE) OR Len(attributes.DELIVERY_TIME) OR 
attributes.IS_ORDER_ACCEPTABLE IS 1 OR attributes.IS_SHIPPING_ACCEPTABLE IS 1 OR
Isdefined("attributes.PACKAGE_UNIT") OR Isdefined("attributes.IS_CUSTOMER_COMPLAINT") OR Isdefined("attributes.IS_PRODUCTION_FAULT") OR Isdefined("attributes.IS_RETURN_INVOICE")
>
	<cfquery name="ADD_PURCHASE_PHYSICAL" datasource="#dsn3#">
	INSERT INTO
		CONTRACT_PURCHASE_PHYSICAL
		(
		CONTRACT_ID,
		IS_CENTRAL_STORE,
		IS_ALL_STORE,
		DELIVERY_DATE,
		DELIVERY_TIME,
		IS_ORDER_ACCEPTABLE,
		IS_SHIPPING_ACCEPTABLE,
		PACKAGE_UNIT,
		IS_CUSTOMER_COMPLAINT,
		IS_PRODUCTION_FAULT,
		IS_RETURN_INVOICE,
		RECORD_EMP, RECORD_IP, RECORD_DATE
		)
	VALUES
		(
		#CONTRACT_ID#,
		<cfif Isdefined("attributes.IS_CENTRAL_STORE")>1,<cfelse>0,</cfif>
		<cfif Isdefined("attributes.IS_ALL_STORE")>1,<cfelse>0,</cfif>
		<cfif len(attributes.DELIVERY_DATE)>#attributes.DELIVERY_DATE#,<cfelse>NULL,</cfif>
		<cfif len(attributes.DELIVERY_TIME)>#attributes.DELIVERY_TIME#,<cfelse>NULL,</cfif>
		<cfif attributes.IS_ORDER_ACCEPTABLE IS 1>1,<cfelse>0,</cfif>
		<cfif attributes.IS_SHIPPING_ACCEPTABLE IS 1>1,<cfelse>0,</cfif>
		<cfif Isdefined("attributes.PACKAGE_UNIT")>'#attributes.PACKAGE_UNIT#',<cfelse>NULL,</cfif>
		<cfif Isdefined("attributes.IS_CUSTOMER_COMPLAINT")>1,<cfelse>0,</cfif>
		<cfif Isdefined("attributes.IS_PRODUCTION_FAULT")>1,<cfelse>0,</cfif>
		<cfif Isdefined("attributes.IS_RETURN_INVOICE")>1,<cfelse>0,</cfif>
		#session.ep.userid#, '#REMOTE_ADDR#', #now()#
		)
	</cfquery>
</cfif>
<!--- //PHYSICAL --->
</CFTRANSACTION>
<script type="text/javascript">
wrk_opener_reload();
window.close();
</script>
