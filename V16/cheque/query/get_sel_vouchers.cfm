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
<cfquery name="GET_VOUCHERS" datasource="#dsn2#">
	SELECT
		*
		<cfif x_project_info eq 1>
			,PP.PROJECT_HEAD
		</cfif>
	FROM
		VOUCHER V
		<cfif x_project_info eq 1>
			LEFT JOIN VOUCHER_PAYROLL VP ON V.VOUCHER_PAYROLL_ID = VP.ACTION_ID
			LEFT JOIN #dsn_alias#.PRO_PROJECTS PP ON VP.PROJECT_ID = PP.PROJECT_ID
		</cfif>
		,VOUCHER_HISTORY VH
		<cfif session.ep.isBranchAuthorization and not isdefined("is_transfer")>
			,VOUCHER_PAYROLL
             ,CASH C
		</cfif>
	WHERE
		<cfif isDefined("attributes.voucher_company_id") and isDefined("attributes.voucher_company") and len(attributes.voucher_company) and len(attributes.voucher_company_id) and attributes.member_type eq 'partner'>
		 	V.COMPANY_ID=#attributes.voucher_company_id# AND
		<cfelseif isDefined("attributes.voucher_consumer_id") and isDefined("attributes.voucher_company") and len(attributes.voucher_company) and len(attributes.voucher_consumer_id) and attributes.member_type eq 'consumer'>
			V.CONSUMER_ID=#attributes.voucher_consumer_id# AND
		<cfelseif isDefined("attributes.voucher_employee_id") and isDefined("attributes.voucher_company") and len(attributes.voucher_company) and len(attributes.voucher_employee_id) and attributes.member_type eq 'employee'>
			V.EMPLOYEE_ID=#attributes.voucher_employee_id# AND
		</cfif>
		<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
			V.VOUCHER_DUEDATE >= #attributes.start_date# AND 
		</cfif>
		<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
			 V.VOUCHER_DUEDATE <= #attributes.finish_date# AND
		</cfif>
		<cfif isdefined("attributes.entry_ret")>
			( 
			V.VOUCHER_STATUS_ID = 4 OR
			V.VOUCHER_STATUS_ID = 6
			)
		<cfelseif isdefined("attributes.endor_ret")>
		   <cfif isdefined("attributes.endor") and (attributes.endor eq 1)>
				V.VOUCHER_STATUS_ID = 1
				<cfif isdefined('attributes.cash_id') and len(attributes.cash_id)>
					AND V.CASH_ID = #listfirst(attributes.cash_id,';')#
				</cfif>
		   <cfelseif isdefined("attributes.endor") and (attributes.endor eq 2)>
				V.VOUCHER_STATUS_ID = 5
		   <cfelse>
		   		( 
					(V.VOUCHER_STATUS_ID IN(1,11) AND 
						(
							V.CASH_ID = #listfirst(attributes.cash_id,';')#
							OR ( V.VOUCHER_ID IN(
													SELECT 
														VHH.VOUCHER_ID
													FROM
														VOUCHER_HISTORY VHH,
														VOUCHER_PAYROLL PP
													WHERE
														VHH.VOUCHER_ID = V.VOUCHER_ID
														AND VHH.PAYROLL_ID = PP.ACTION_ID
														AND PP.PAYROLL_CASH_ID = #listfirst(attributes.cash_id,';')#
												)
                            	AND V.VOUCHER_ID NOT IN (
                                                    SELECT
                                                    	VHH.VOUCHER_ID
                                                    FROM
                                                    	VOUCHER_HISTORY VHH
                                                        ,VOUCHER_PAYROLL PP
                                                    WHERE VHH.VOUCHER_ID = V.VOUCHER_ID
                                                        AND VHH.PAYROLL_ID = PP.ACTION_ID
                                                        AND PP.PAYROLL_TYPE IN (136,137)
                                )
                        	)
						)
					)
					OR 
					V.VOUCHER_STATUS_ID = 5 
					OR
					V.VOUCHER_STATUS_ID = 10
				)
		   </cfif>
		<cfelseif isdefined("attributes.endorsement")>
			(
			<cfif isdefined("attributes.self_") and (attributes.self_ eq 1)>
				V.VOUCHER_STATUS_ID=1
				<cfif isdefined('attributes.cash_id') and len(attributes.cash_id)>
					AND V.CASH_ID = #listfirst(attributes.cash_id,';')#
				</cfif>
			<cfelseif isdefined("attributes.self_") and (attributes.self_ eq 2)>
				V.VOUCHER_STATUS_ID = 6
			<cfelse>
				(V.VOUCHER_STATUS_ID=1 OR
				V.VOUCHER_STATUS_ID = 6)		
				<cfif isdefined('attributes.cash_id') and len(attributes.cash_id)>
					AND V.CASH_ID = #listfirst(attributes.cash_id,';')#
				</cfif>
			</cfif>	
				
			)
		<cfelseif isDefined("is_return")>
			V.VOUCHER_STATUS_ID IN (2,5,13)
		<cfelseif isdefined("is_transfer")>
			<cfif isdefined("attributes.is_other_act") and attributes.is_other_act eq 1>
				V.VOUCHER_STATUS_ID = 14
				AND V.CASH_ID = #listfirst(attributes.cash_id,';')#
				AND V.VOUCHER_ID IN(
									SELECT 
										VHH.VOUCHER_ID
									FROM
										VOUCHER_HISTORY VHH,
										VOUCHER_PAYROLL PP
									WHERE
										VHH.VOUCHER_ID = V.VOUCHER_ID
										AND VHH.PAYROLL_ID = PP.ACTION_ID
										AND PP.TRANSFER_CASH_ID = #listfirst(attributes.to_cash_id,';')#)
			<cfelse>
				V.VOUCHER_STATUS_ID IN(1,11)
				AND V.CASH_ID = #listfirst(attributes.cash_id,';')#
			</cfif>
		<cfelse>
			V.VOUCHER_STATUS_ID=1
			<cfif isdefined('attributes.cash_id') and len(attributes.cash_id)>
				AND (V.CASH_ID = #listfirst(attributes.cash_id,';')# OR V.CASH_ID IS NULL)
			</cfif>
		</cfif>
			AND 
				(
					V.VOUCHER_PAYROLL_ID  IN (SELECT ACTION_ID FROM VOUCHER_PAYROLL ) OR
					V.VOUCHER_PAYROLL_ID IN (SELECT ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_NO = '-2' AND DEBTOR_NAME = '#SESSION.EP.COMPANY#')
				)
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND
			(		
				V.VOUCHER_CODE LIKE '%#attributes.keyword#%' OR 
				V.VOUCHER_NO LIKE '%#attributes.keyword#%' OR 
				V.DEBTOR_NAME LIKE '%#attributes.keyword#%' OR
				V.VOUCHER_PURSE_NO LIKE '%#attributes.keyword#%'
			)	
		</cfif>	
		<cfif ( (isdefined("attributes.company_id") and len(attributes.company_id)) or (isdefined("attributes.consumer_id") and len(attributes.consumer_id)) or (isdefined("attributes.employee_id") and len(attributes.employee_id))) and not isdefined("attributes.endorsement") and not isdefined("attributes.entry_ret")>
		AND (VOUCHER_PAYROLL_ID IN
			(
				SELECT 
					ACTION_ID
				FROM
					VOUCHER_PAYROLL
				WHERE
					ACTION_ID IS NOT NULL
				<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
					AND COMPANY_ID = #attributes.company_id#
				<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
					AND CONSUMER_ID = #attributes.consumer_id#
				<cfelseif isdefined("attributes.employee_id") and len(attributes.employee_id)>
					AND EMPLOYEE_ID = #attributes.employee_id#
				</cfif>
			) OR
			V.VOUCHER_ID IN
			(
				SELECT 
					VOUCHER_ID
				FROM
					VOUCHER
				WHERE
					VOUCHER_ID IS NOT NULL
				<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
					AND COMPANY_ID = #attributes.company_id#
				<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
					AND CONSUMER_ID = #attributes.consumer_id#
				<cfelseif isdefined("attributes.employee_id") and len(attributes.employee_id)>
					AND EMPLOYEE_ID = #attributes.employee_id#
				</cfif>
			)
			OR
			V.VOUCHER_ID IN
			(
				SELECT 
					VOUCHER_ID
				FROM
					VOUCHER
				WHERE
					VOUCHER_ID IS NOT NULL
				<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
					AND OWNER_COMPANY_ID = #attributes.company_id#
				<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
					AND OWNER_CONSUMER_ID = #attributes.consumer_id#
				<cfelseif isdefined("attributes.employee_id") and len(attributes.employee_id)>
					AND OWNER_EMPLOYEE_ID = #attributes.employee_id#
				</cfif>
			)
		)	
	   </cfif> 
		<!---  Şube tarafındaki düzenlemeler soNrasında eklendi Sadece şubeye ait bankalardaki çekleri getiriyor. --->
		<cfif session.ep.isBranchAuthorization and not isdefined("is_transfer")>
        	AND	V.CASH_ID=C.CASH_ID
			AND VH.HISTORY_ID = (SELECT MAX(HISTORY_ID) HISTORY_ID FROM VOUCHER_HISTORY WHERE VOUCHER_HISTORY.VOUCHER_ID = V.VOUCHER_ID AND VOUCHER_HISTORY.PAYROLL_ID IS NOT NULL)
			AND VH.PAYROLL_ID = VOUCHER_PAYROLL.ACTION_ID
			AND C.BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
		</cfif>			
		AND V.VOUCHER_ID = VH.VOUCHER_ID
		<cfif isdefined('attributes.cash_id') and len(attributes.cash_id)><!--- gönderilen kasanın para birimine bakacak. --->
			AND V.CURRENCY_ID = '#listgetat(attributes.cash_id,3,';')#'
		</cfif>
		<cfif isdefined('attributes.cur_id') and len(attributes.cur_id)><!--- gönderilen kasanın para birimine bakacak. --->
			AND V.CURRENCY_ID = '#attributes.cur_id#'
		</cfif>
		AND VH.HISTORY_ID = (SELECT MAX(HISTORY_ID) HISTORY_ID FROM VOUCHER_HISTORY WHERE VOUCHER_HISTORY.VOUCHER_ID = V.VOUCHER_ID AND VOUCHER_HISTORY.PAYROLL_ID IS NOT NULL)
		<cfif not isdefined("attributes.endor_ret") and not isdefined("attributes.is_transfer")>
			AND ISNULL(IS_PAY_TERM,0) = 0<!--- Ödeme Sözü olan senetler gelmesin diye eklendi, sadece senet çıkış iade işleminde geliyor ödeme sözü --->
		</cfif>
	ORDER BY 
		VOUCHER_DUEDATE
	<cfif attributes.sort_type eq 2>
	DESC
	</cfif>	
</cfquery>
