<cfscript>
	attributes.due_date_rate = filterNum(attributes.due_date_rate);
	attributes.delay_interest_rate = filterNum(attributes.delay_interest_rate,4);
	attributes.first_interest_rate = filterNum(attributes.first_interest_rate,4);
</cfscript>
<cfquery name="UPD_PAYMETHOD" datasource="#DSN#">
	UPDATE 
		SETUP_PAYMETHOD
	SET 
		PAYMETHOD_STATUS = <cfif isdefined("attributes.status")>1<cfelse>0</cfif>,
		PAYMETHOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#paymethod#">,
		DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#detail#">,
		IN_ADVANCE = <cfif LEN(attributes.in_advance)>#attributes.in_advance#<cfelseif isdefined("attributes.pay_vehicle") and attributes.pay_vehicle eq 6>100<cfelse>NULL</cfif>, 
		DUE_DATE_RATE = <cfif LEN(attributes.due_date_rate)>#attributes.due_date_rate#<cfelse>NULL</cfif>,
		DUE_DAY = <cfif len(attributes.due_day)>#attributes.due_day#<cfelse>NULL</cfif>,
		DUE_MONTH = <cfif len(attributes.due_month)>#attributes.due_month#<cfelse>NULL</cfif>,
		PAYMENT_VEHICLE = <cfif isdefined('attributes.pay_vehicle') and len(attributes.pay_vehicle)>#attributes.pay_vehicle#<cfelse>NULL</cfif>,
		DELAY_INTEREST_RATE = <cfif isdefined('attributes.delay_interest_rate') and len(attributes.delay_interest_rate)>#attributes.delay_interest_rate#<cfelse>NULL</cfif>,
		FIRST_INTEREST_RATE = <cfif isdefined('attributes.first_interest_rate') and len(attributes.first_interest_rate)>#attributes.first_interest_rate#<cfelse>NULL</cfif>,
		DELAY_INTEREST_DAY = <cfif isdefined('attributes.delay_interest_day') and len(attributes.delay_interest_day)>#attributes.delay_interest_day#<cfelse>NULL</cfif>,
		DUE_START_DAY = <cfif isdefined('attributes.due_start_day') and len(attributes.due_start_day)>#attributes.due_start_day#<cfelse>NULL</cfif>,
		DUE_START_MONTH = <cfif isdefined('attributes.due_start_month') and len(attributes.due_start_month)>#attributes.due_start_month#<cfelse>NULL</cfif>,
		IS_DUE_ENDOFMONTH = <cfif isdefined("attributes.is_due_endofmonth")>1<cfelse>0</cfif>,
		IS_DUE_BEGINOFMONTH = <cfif isdefined("attributes.is_due_beginofmonth")>1<cfelse>0</cfif>,
		MONEY = <cfif isdefined('attributes.money') and len(attributes.money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money#"><cfelse>NULL</cfif>,
		COMPOUND_RATE = <cfif isdefined("attributes.compound_rate")>1<cfelse>0</cfif>,
		FINANCIAL_COMPOUND_RATE = <cfif isdefined("attributes.financial_compound_rate")>1<cfelse>0</cfif>,
		BALANCED_PAYMENT = <cfif isdefined("attributes.balanced_payment")>1<cfelse>0</cfif>,
		NO_COMPOUND_RATE = <cfif isdefined("attributes.no_compound_rate")>1<cfelse>0</cfif>,
		IS_PARTNER = <cfif isdefined("attributes.is_partner")>1<cfelse>0</cfif>,
		IS_PUBLIC = <cfif isdefined("attributes.is_public")>1<cfelse>0</cfif>,
        PAYMENT_MEANS_CODE = <cfif len(attributes.payment_means_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#listfirst(attributes.payment_means_code)#"><cfelse>NULL</cfif>,
		PAYMENT_MEANS_CODE_NAME =  <cfif len(attributes.payment_means_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#listlast(attributes.payment_means_code)#"><cfelse>NULL</cfif>,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		BANK_ID = <cfif isdefined("attributes.pay_vehicle") and attributes.pay_vehicle eq 8 and isdefined("attributes.bank_id") and len(attributes.bank_id)>#attributes.bank_id#<cfelse>NULL</cfif>,
		IS_DATE_CONTROL = <cfif isdefined("attributes.is_due")>1<cfelse>0</cfif>,
		NEXT_DAY = <cfif isdefined("attributes.next_day") and len(attributes.next_day)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.next_day#"><cfelse>NULL</cfif>,
		IS_BUSINESS_DUE_DAY = <cfif isdefined("attributes.is_business_due_day") and len(attributes.is_business_due_day)>1<cfelse>0</cfif>
	WHERE 
		PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#paymethod_id#">
</cfquery>
<cfquery name="DEL_FIXED_DATE" datasource="#DSN#">
	DELETE FROM SETUP_PAYMETHOD_FIXED_DATE WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#paymethod_id#">
</cfquery>
<cfif isdefined("attributes.due_month") and len(attributes.due_month)>
	<cfloop from="1" to="#attributes.due_month#" index="i">
		<cfif isdefined("attributes.fixed_date#i#") and len(evaluate("attributes.fixed_date#i#"))>
			<cf_date tarih = "attributes.fixed_date#i#">
			<cfif evaluate("attributes.row_kontrol#i#") neq 0>
				<cfquery name="ADD_FIXED_DATE" datasource="#DSN#">
					INSERT INTO
						SETUP_PAYMETHOD_FIXED_DATE
						(
							PAYMETHOD_ID,
							FIXED_DATE,
							INSTALLMENT_NAME
						)
						VALUES
						(
							#paymethod_id#,
							#evaluate("attributes.fixed_date#i#")#,
							<cfif len(evaluate("attributes.installment_name#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.installment_name#i#")#"><cfelse>NULL</cfif>
						)
				</cfquery>
			</cfif>		
		</cfif>
	</cfloop>
</cfif>
<cfif isDefined("attributes.paymethod_our_company_id") and Len(attributes.paymethod_our_company_id)>
	<!--- Iliskili Sirketler --->
	<cfquery name="Del_Paymethod_Our_Company" datasource="#dsn#">
		DELETE FROM SETUP_PAYMETHOD_OUR_COMPANY WHERE PAYMETHOD_ID = #paymethod_id#
	</cfquery>
	<cfloop list="#attributes.paymethod_our_company_id#" index="poc">
		<cfquery name="Add_Paymethod_Our_Company" datasource="#dsn#">
			INSERT INTO
				SETUP_PAYMETHOD_OUR_COMPANY
				(	
					PAYMETHOD_ID, 
					OUR_COMPANY_ID	
				)
				VALUES
				(	
					#paymethod_id#, 
					#poc#	
				)
		</cfquery>
	</cfloop>
</cfif>
<cflocation url="#request.self#?fuseaction=settings.form_upd_paymethod&paymethod_id=#paymethod_id#" addtoken="no">
