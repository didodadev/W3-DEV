<cfscript>
	attributes.due_date_rate = filterNum(attributes.due_date_rate);
	attributes.delay_interest_rate = filterNum(attributes.delay_interest_rate);
	attributes.first_interest_rate = filterNum(attributes.first_interest_rate);
</cfscript>
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="INS_PAYMETHOD" datasource="#DSN#">
			INSERT INTO 
				SETUP_PAYMETHOD
            (
                PAYMETHOD_STATUS,
                PAYMETHOD,
                DETAIL,             
                IN_ADVANCE,  
                DUE_DATE_RATE, 
                DUE_DAY,     
                DUE_MONTH,   
                PAYMENT_VEHICLE,
                COMPOUND_RATE,
                FINANCIAL_COMPOUND_RATE,
                BALANCED_PAYMENT,	
                NO_COMPOUND_RATE,		
                DELAY_INTEREST_DAY,
                DELAY_INTEREST_RATE,
                FIRST_INTEREST_RATE,
                DUE_START_DAY,
                DUE_START_MONTH,
				IS_DUE_ENDOFMONTH,
                IS_DUE_BEGINOFMONTH,
                MONEY,
				IS_PARTNER,
				IS_PUBLIC,
                PAYMENT_MEANS_CODE,
                PAYMENT_MEANS_CODE_NAME,
                RECORD_IP,
                RECORD_DATE,
                RECORD_EMP,
				BANK_ID,
				IS_DATE_CONTROL,
                NEXT_DAY,
                IS_BUSINESS_DUE_DAY
            ) 
        VALUES 
            (	
                <cfif isdefined("attributes.status")>1<cfelse>0</cfif>,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#paymethod#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#detail#">,
                <cfif LEN(attributes.in_advance)>#attributes.in_advance#
                <cfelseif isdefined("attributes.pay_vehicle") and attributes.pay_vehicle eq 6>100<cfelse>NULL</cfif> ,
                <cfif LEN(attributes.due_date_rate)>#attributes.due_date_rate#<cfelse>NULL</cfif>,
                <cfif LEN(attributes.due_day)>#attributes.due_day#<cfelse>NULL</cfif>,
                <cfif LEN(attributes.due_month)>#attributes.due_month#<cfelse>NULL</cfif>,
                <cfif isdefined('attributes.pay_vehicle') and len(attributes.pay_vehicle)>#attributes.pay_vehicle#<cfelse>NULL</cfif>,
                <cfif isdefined('attributes.compound_rate')>1<cfelse>0</cfif>,
                <cfif isdefined("attributes.financial_compound_rate")>1<cfelse>0</cfif>,
                <cfif isdefined("attributes.balanced_payment")>1<cfelse>0</cfif>,
                <cfif isdefined("attributes.no_compound_rate")>1<cfelse>0</cfif>,
                <cfif isdefined('attributes.delay_interest_day') and len(attributes.delay_interest_day)>#attributes.delay_interest_day#<cfelse>NULL</cfif>,
                <cfif isdefined('attributes.delay_interest_rate') and len(attributes.delay_interest_rate)>#attributes.delay_interest_rate#<cfelse>NULL</cfif>,
                <cfif isdefined('attributes.first_interest_rate') and len(attributes.first_interest_rate)>#attributes.first_interest_rate#<cfelse>NULL</cfif>,
                <cfif isdefined('attributes.due_start_day') and len(attributes.due_start_day)>#attributes.due_start_day#<cfelse>NULL</cfif>,
                <cfif isdefined('attributes.due_start_month') and len(attributes.due_start_month)>#attributes.due_start_month#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.is_due_endofmonth")>1<cfelse>0</cfif>,
                <cfif isdefined("attributes.is_due_beginofmonth")>1<cfelse>0</cfif>,
                <cfif isdefined('attributes.money') and len(attributes.money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.is_partner")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_public")>1<cfelse>0</cfif>,
				<cfif len(attributes.payment_means_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#listfirst(attributes.payment_means_code)#"><cfelse>NULL</cfif>,
                <cfif len(attributes.payment_means_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#listlast(attributes.payment_means_code)#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                #now()#,
                #session.ep.userid#,
				<cfif isdefined("attributes.pay_vehicle") and attributes.pay_vehicle eq 8 and isdefined("attributes.bank_id") and len(attributes.bank_id)>#attributes.bank_id#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.is_due")>1<cfelse>0</cfif>,
                <cfif isdefined("attributes.next_day") and len(attributes.next_day)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.next_day#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.is_business_due_day") and len(attributes.is_business_due_day)>1<cfelse>0</cfif>
            )
		</cfquery>
        <cfquery name="GET_MAX_ID" datasource="#DSN#">
            SELECT MAX(PAYMETHOD_ID) AS MAX_ID FROM SETUP_PAYMETHOD
        </cfquery>
        <cfif (get_max_id.recordcount) and len(get_max_id.max_id)>
            <cfset max_id = get_max_id.max_id>	
        <cfelse>
            <cfset max_id = 1>
        </cfif>
        <cfif isdefined("attributes.due_month") and len(attributes.due_month)>
            <cfloop from="0" to="#attributes.due_month-1#" index="i">
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
                                    #max_id#,
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
						#max_id#,
						#poc#
					)
				</cfquery>
			</cfloop>
		</cfif>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.form_upd_paymethod&paymethod_id=#max_id#" addtoken="no">
