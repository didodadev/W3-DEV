<cfquery name="GET_PERIOD_CONTROL" datasource="#dsn#">
	SELECT 
    	PERIOD_ID, 
        PERIOD, 
        PERIOD_YEAR, 
        IS_INTEGRATED, 
        OUR_COMPANY_ID, 
        PERIOD_DATE, 
        OTHER_MONEY, 
        STANDART_PROCESS_MONEY, 
        RECORD_DATE, 
        RECORD_IP, 
        RECORD_EMP, 
        UPDATE_DATE, 
        UPDATE_IP, 
        UPDATE_EMP, 
        IS_LOCKED, 
        PROCESS_DATE 
    FROM 
    	SETUP_PERIOD 
    WHERE 
	    PERIOD_YEAR = #session.ep.period_year-1# AND OUR_COMPANY_ID = #session.ep.company_id#
</cfquery>
<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
</cfif>
<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
</cfif>
<cfscript>
	if(listlen(attributes.employee_id,'_') eq 2)
		{
			attributes.employee_id = listfirst(attributes.employee_id,'_');
		}
</cfscript>
<cfquery name="GET_CHEQUES" datasource="#dsn2#">
	SELECT DISTINCT
		C.CHEQUE_ID,	
		C.SELF_CHEQUE,
		C.CHEQUE_CODE,
		C.CHEQUE_NO,
		C.DEBTOR_NAME,
		C.BANK_NAME,
		C.TAX_PLACE,
		C.TAX_NO,
		C.BANK_BRANCH_NAME,
		C.CHEQUE_DUEDATE,
		C.CHEQUE_PURSE_NO ,
		C.CHEQUE_CITY,
		C.CHEQUE_VALUE,
		C.CURRENCY_ID,
		C.CHEQUE_PAYROLL_ID,
		C.CHEQUE_STATUS_ID,
		C.ACCOUNT_ID,
		C.ACCOUNT_NO,
		C.COMPANY_ID,
		C.CONSUMER_ID,
		C.EMPLOYEE_ID,
		C.OTHER_MONEY,
		C.OTHER_MONEY_VALUE
		,C.OTHER_MONEY2
		,C.OTHER_MONEY_VALUE2
		<cfif x_project_info eq 1>
			,PP.PROJECT_HEAD
		</cfif> 
	FROM
		CHEQUE_HISTORY CH,
		CHEQUE C
		<cfif x_project_info eq 1>
			LEFT JOIN PAYROLL P ON C.CHEQUE_PAYROLL_ID = P.ACTION_ID
			LEFT JOIN #dsn_alias#.PRO_PROJECTS PP ON P.PROJECT_ID = PP.PROJECT_ID
		</cfif>
		<cfif session.ep.isBranchAuthorization or (isdefined("attributes.account_id") and len(attributes.account_id))>
			,PAYROLL
		</cfif>
	WHERE
		<cfif isdefined("attributes.entry_ret")>
			(
				(
					C.CHEQUE_STATUS_ID = 4 AND 
					(
						CH.PAYROLL_ID IN (SELECT ACTION_ID FROM PAYROLL WHERE ACTION_ID IS NOT NULL <cfif len(attributes.company_id)>AND COMPANY_ID = #attributes.company_id#<cfelseif len(attributes.consumer_id)>AND CONSUMER_ID = #attributes.consumer_id#<cfelseif len(attributes.employee_id)>AND EMPLOYEE_ID = #attributes.employee_id#</cfif>)
						OR C.CHEQUE_ID IN(
										SELECT 
											CHEQUE_ID
										FROM
											CHEQUE
										WHERE
											CHEQUE_ID IS NOT NULL
										<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
											AND COMPANY_ID = #attributes.COMPANY_ID#
										<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
											AND CONSUMER_ID = #attributes.consumer_id#
										<cfelseif isdefined("attributes.employee_id") and len(attributes.employee_id)>
											AND EMPLOYEE_ID = #attributes.employee_id#
										</cfif>
										 )
						OR C.CHEQUE_ID IN(
										SELECT 
											CHEQUE_ID
										FROM
											CHEQUE
										WHERE
											CHEQUE_ID IS NOT NULL
										<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
											AND OWNER_COMPANY_ID = #attributes.COMPANY_ID#
										<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
											AND OWNER_CONSUMER_ID = #attributes.consumer_id#
										<cfelseif isdefined("attributes.employee_id") and len(attributes.employee_id)>
											AND OWNER_EMPLOYEE_ID = #attributes.employee_id#
										</cfif>
										 )
						<!--- Ciro edilen çekler iade alınırken cariden dolayı sorun oluyordu o yüzden geçmiş dönemden kontrol ediyoruz AE&SM 20090112 --->
						<cfif GET_PERIOD_CONTROL.recordcount>
							OR C.CHEQUE_ID IN(
											SELECT 
												CC.TO_CHEQUE_VOUCHER_ID 
											FROM 
												#dsn_alias#.CHEQUE_VOUCHER_COPY_REF CC,
												#dsn#_#session.ep.period_year-1#_#session.ep.company_id#.CHEQUE_HISTORY CHH,
												#dsn#_#session.ep.period_year-1#_#session.ep.company_id#.PAYROLL P
											WHERE 
												CC.TO_CHEQUE_VOUCHER_ID = C.CHEQUE_ID
												AND CC.TO_PERIOD_ID = #session.ep.period_id#
												AND CC.IS_CHEQUE = 1
												AND CC.FROM_CHEQUE_VOUCHER_ID = CHH.CHEQUE_ID
												AND CHH.STATUS IN(1,4)
												AND CHH.PAYROLL_ID = P.ACTION_ID
												<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
													AND P.COMPANY_ID = #attributes.COMPANY_ID#
												<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
													AND P.CONSUMER_ID = #attributes.consumer_id#
												<cfelseif isdefined("attributes.employee_id") and len(attributes.employee_id)>
													AND P.EMPLOYEE_ID = #attributes.employee_id#
												</cfif>
											)
						</cfif>
						<cfif len(attributes.company_id)>
							OR CH.COMPANY_ID =  #attributes.company_id#
						<cfelseif len(attributes.consumer_id)>
							OR CH.CONSUMER_ID = #attributes.consumer_id#
						<cfelseif len(attributes.employee_id)>
							OR CH.EMPLOYEE_ID = #attributes.employee_id#
						</cfif>
					)
				)
				OR 
				(
					C.CHEQUE_STATUS_ID = 6 
					<cfif len(attributes.company_id)>
						AND C.COMPANY_ID = #attributes.company_id#
					<cfelseif len(attributes.consumer_id)>
						AND C.CONSUMER_ID = #attributes.consumer_id#
					<cfelseif len(attributes.employee_id)>
						AND C.EMPLOYEE_ID = #attributes.employee_id#
					</cfif>
				)
			)
			<cfif isdefined("attributes.is_company_select") and attributes.is_company_select>
                <cfif len(attributes.company_id)>
                    AND C.COMPANY_ID = #attributes.company_id#
                <cfelseif len(attributes.consumer_id)>
                    AND C.CONSUMER_ID = #attributes.consumer_id#
                <cfelseif len(attributes.employee_id)>
                    AND C.EMPLOYEE_ID = #attributes.employee_id#
                </cfif>               	
            </cfif>
		<cfelseif isdefined("attributes.endor_ret")><!--- cek iade cıkıs bordrosu --->
		   <cfif isdefined("attributes.endor") and (attributes.endor eq 1)>
		   <!--- secilen kasadaki portföydeki cekler --->
				C.CHEQUE_STATUS_ID = 1
				<cfif isdefined('attributes.cash_id') and len(attributes.cash_id)>
					AND C.CASH_ID = #listfirst(attributes.cash_id,';')#
				</cfif>
		   <cfelseif isdefined("attributes.endor") and (attributes.endor eq 2)>
		   <!--- karsılıksız asamasındaki cekler --->
				C.CHEQUE_STATUS_ID = 5
		   <cfelse>
		   		( 
					(C.CHEQUE_STATUS_ID = 1 AND 
						(
							C.CASH_ID = #listfirst(attributes.cash_id,';')#
							OR C.CHEQUE_ID IN(
											SELECT 
												CHH.CHEQUE_ID
											FROM
												CHEQUE_HISTORY CHH,
												PAYROLL PP
											WHERE
												CHH.CHEQUE_ID = C.CHEQUE_ID
												AND CHH.PAYROLL_ID = PP.ACTION_ID
												AND PP.PAYROLL_CASH_ID = #listfirst(attributes.cash_id,';')#
											)
						)
					)
					OR 
					C.CHEQUE_STATUS_ID = 5 
					OR
					(C.CHEQUE_STATUS_ID = 10
					AND 
						(
							C.CASH_ID = #listfirst(attributes.cash_id,';')#
							OR C.CHEQUE_ID IN(
											SELECT 
												CHH.CHEQUE_ID
											FROM
												CHEQUE_HISTORY CHH,
												PAYROLL PP
											WHERE
												CHH.CHEQUE_ID = C.CHEQUE_ID
												AND CHH.PAYROLL_ID = PP.ACTION_ID
												AND PP.PAYROLL_CASH_ID = #listfirst(attributes.cash_id,';')#
											)
						)
					)
				)
		   </cfif>
		<cfelseif isdefined("attributes.endorsement")>
			<cfif isdefined("attributes.self_") and (attributes.self_ eq 1)>
				C.CHEQUE_STATUS_ID = 1
			<cfelseif isdefined("attributes.self_") and (attributes.self_ eq 2)>
				C.CHEQUE_STATUS_ID = 6
			<cfelse>
				(C.CHEQUE_STATUS_ID = 1)
			</cfif>	
		<cfelseif isDefined("is_return")>
			C.CHEQUE_STATUS_ID IN (2,5,13)
		<cfelseif isdefined("is_transfer")>
			<cfif isdefined("attributes.is_other_act") and attributes.is_other_act eq 1>
				C.CHEQUE_STATUS_ID = 14
				AND C.CASH_ID = #listfirst(attributes.cash_id,';')#
				AND C.CHEQUE_ID IN(
									SELECT 
										CHH.CHEQUE_ID
									FROM
										CHEQUE_HISTORY CHH,
										PAYROLL PP
									WHERE
										CHH.CHEQUE_ID = C.CHEQUE_ID
										AND CHH.PAYROLL_ID = PP.ACTION_ID
										AND PP.TRANSFER_CASH_ID = #listfirst(attributes.to_cash_id,';')#)
			<cfelse>
				C.CHEQUE_STATUS_ID = 1
				AND C.CASH_ID = #listfirst(attributes.cash_id,';')#
			</cfif>
		<cfelse>
			C.CHEQUE_STATUS_ID IN (1,10)
		</cfif>
		<cfif ( (isdefined("attributes.company_id") and len(attributes.company_id)) or (isdefined("attributes.consumer_id") and len(attributes.consumer_id)) or (isdefined("attributes.employee_id") and len(attributes.employee_id))) and not isdefined("attributes.endorsement") and not isdefined("attributes.entry_ret")>
        AND (PAYROLL_ID IN
            (
                SELECT 
                    ACTION_ID
                FROM
                    PAYROLL
                WHERE
                    ACTION_ID IS NOT NULL
                <cfif isdefined("attributes.company_id") and len(attributes.company_id)>
                    AND COMPANY_ID = #attributes.COMPANY_ID#
                <cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
                    AND CONSUMER_ID = #attributes.consumer_id#
                <cfelseif isdefined("attributes.employee_id") and len(attributes.employee_id)>
                    AND EMPLOYEE_ID = #attributes.employee_id#
                </cfif>
            ) 
            OR C.CHEQUE_ID IN
            (
                SELECT 
                    CHEQUE_ID
                FROM
                    CHEQUE
                WHERE
                    CHEQUE_ID IS NOT NULL
                <cfif isdefined("attributes.company_id") and len(attributes.company_id)>
                    AND COMPANY_ID = #attributes.COMPANY_ID#
                <cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
                    AND CONSUMER_ID = #attributes.consumer_id#
                <cfelseif isdefined("attributes.employee_id") and len(attributes.employee_id)>
                    AND EMPLOYEE_ID = #attributes.employee_id#
                </cfif>
            )
            OR C.CHEQUE_ID IN
            (
            SELECT 
                CHEQUE_ID
            FROM
                CHEQUE
            WHERE
                CHEQUE_ID IS NOT NULL
            <cfif isdefined("attributes.company_id") and len(attributes.company_id)>
                AND OWNER_COMPANY_ID = #attributes.COMPANY_ID#
            <cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
                AND OWNER_CONSUMER_ID = #attributes.consumer_id#
            <cfelseif isdefined("attributes.employee_id") and len(attributes.employee_id)>
                AND OWNER_EMPLOYEE_ID = #attributes.employee_id#
            </cfif>
             )
            <cfif GET_PERIOD_CONTROL.recordcount>
                OR C.CHEQUE_ID IN(
                                SELECT 
                                    CC.TO_CHEQUE_VOUCHER_ID 
                                FROM 
                                    #dsn_alias#.CHEQUE_VOUCHER_COPY_REF CC,
                                    #dsn#_#session.ep.period_year-1#_#session.ep.company_id#.CHEQUE_HISTORY CHH,
                                    #dsn#_#session.ep.period_year-1#_#session.ep.company_id#.PAYROLL P
                                WHERE 
                                    CC.TO_CHEQUE_VOUCHER_ID = C.CHEQUE_ID
                                    AND CC.TO_PERIOD_ID = #session.ep.period_id#
                                    AND CC.IS_CHEQUE = 1
                                    AND CC.FROM_CHEQUE_VOUCHER_ID = CHH.CHEQUE_ID
                                    AND CHH.STATUS IN(1,4)
                                    AND CHH.PAYROLL_ID = P.ACTION_ID
                                    <cfif isdefined("attributes.company_id") and len(attributes.company_id)>
                                        AND P.COMPANY_ID = #attributes.COMPANY_ID#
                                    <cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
                                        AND P.CONSUMER_ID = #attributes.consumer_id#
                                    <cfelseif isdefined("attributes.employee_id") and len(attributes.employee_id)>
                                        AND P.EMPLOYEE_ID = #attributes.employee_id#
                                    </cfif>
                                )
            </cfif>
            )	
        </cfif> 
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND
			(		
				C.CHEQUE_CODE LIKE '%#attributes.keyword#%' OR 
				C.CHEQUE_NO LIKE '%#attributes.keyword#%' OR 
				C.DEBTOR_NAME LIKE '%#attributes.keyword#%' OR
				C.CHEQUE_PURSE_NO LIKE '%#attributes.keyword#%'
			)	
		</cfif>	
		<cfif isdefined("attributes.account_id") and len(attributes.account_id)>
			AND PAYROLL.PAYROLL_ACCOUNT_ID=#attributes.account_id#
		</cfif>
		<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
			AND C.CHEQUE_DUEDATE >= #attributes.start_date#
		</cfif>
		<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
			AND C.CHEQUE_DUEDATE <= #attributes.finish_date#
		</cfif>
		<cfif isdefined("attributes.money_type") and len(attributes.money_type)>
			AND C.CURRENCY_ID = '#attributes.money_type#'
		</cfif>
		<cfif session.ep.isBranchAuthorization or (isdefined("attributes.account_id") and len(attributes.account_id))>
			AND CH.HISTORY_ID = (SELECT MAX(HISTORY_ID) HISTORY_ID FROM CHEQUE_HISTORY WHERE CHEQUE_HISTORY.CHEQUE_ID = C.CHEQUE_ID AND CHEQUE_HISTORY.PAYROLL_ID IS NOT NULL)
			AND CH.PAYROLL_ID = PAYROLL.ACTION_ID
		</cfif>
		<cfif session.ep.isBranchAuthorization and not isdefined("is_transfer")>
			AND PAYROLL.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">
		</cfif>
		<cfif isdefined('attributes.cash_id') and len(attributes.cash_id)><!--- gönderilen kasanın para birimine bakacak. --->
			AND C.CURRENCY_ID = '#listgetat(attributes.cash_id,3,';')#'
		</cfif>
		<cfif isdefined('attributes.cur_id') and len(attributes.cur_id)><!--- gönderilen kasanın para birimine bakacak. --->
			AND C.CURRENCY_ID = '#cur_id#'
		</cfif>
		<cfif (isdefined("attributes.companyName") and len(attributes.companyName) and ((isdefined("attributes.companyID") and len(attributes.companyID)) or (isdefined("attributes.consumerID") and len(attributes.consumerID)) or (isdefined("attributes.employeeID") and len(attributes.employeeID))))>
			<cfif isdefined("attributes.companyID") and len(attributes.companyID)>
                AND C.COMPANY_ID = #attributes.companyID#
            <cfelseif isdefined("attributes.consumerID") and len(attributes.consumerID)>
                AND C.CONSUMER_ID = #attributes.consumerID#
            <cfelseif isdefined("attributes.employeeID") and len(attributes.employeeID)>
                AND C.EMPLOYEE_ID = #attributes.employeeID#
            </cfif>
		</cfif>
		AND C.CHEQUE_ID = CH.CHEQUE_ID
	ORDER BY 
		C.CHEQUE_DUEDATE
	<cfif attributes.sort_type eq 2>DESC</cfif>
</cfquery>
