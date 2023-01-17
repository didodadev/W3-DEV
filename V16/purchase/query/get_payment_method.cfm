<cfquery name="GET_PAYMENT_METHOD" datasource="#dsn#">
	SELECT 
		PAYMETHOD_ID,
        PAYMETHOD ,
		PAYMENT_VEHICLE,
		IS_DUE_ENDOFMONTH,
		ISNULL(DUE_START_DAY,ISNULL(DUE_START_MONTH*30,0)) + ISNULL(DUE_DAY,0) DUE_DAY <!--- fbs 20140902 Ortalama Vadeye, Vade Baslangici Da Ekleniyor --->
	FROM 
		SETUP_PAYMETHOD SP
		<cfif not(isDefined('pay_id') and len(pay_id))>
			,SETUP_PAYMETHOD_OUR_COMPANY SPOC
		</cfif>
	WHERE	
		<cfif isDefined('pay_id') and len(pay_id)>
			SP.PAYMETHOD_ID = #pay_id#
		<cfelse>
			SP.PAYMETHOD_STATUS = 1
			AND SP.PAYMETHOD_ID = SPOC.PAYMETHOD_ID 
			AND SPOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		</cfif>
</cfquery>
