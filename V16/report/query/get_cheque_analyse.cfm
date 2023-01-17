<cfset kurumsal = ''>
<cfset bireysel = ''>
<cfif listlen(attributes.member_cat_type)>
	<cfset uzunluk=listlen(attributes.member_cat_type)>
	<cfloop from="1" to="#uzunluk#" index="catyp">
		<cfset eleman = listgetat(attributes.member_cat_type,catyp,',')>
		<cfif listlen(eleman) and listfirst(eleman,'-') eq 1>
			<cfset kurumsal = listappend(kurumsal,eleman)>
		<cfelseif listlen(eleman) and listfirst(eleman,'-') eq 2>
			<cfset bireysel = listappend(bireysel,eleman)>
		</cfif>
	</cfloop>
</cfif>
<cfquery name="check_our_company" datasource="#dsn#">
	SELECT IS_REMAINING_AMOUNT FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfif len(attributes.start_date) and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
</cfif>
<cfif len(attributes.finish_date) and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
</cfif>
<cfif len(attributes.record_date1) and isdate(attributes.record_date1)>
	<cf_date tarih = "attributes.record_date1">
</cfif>
<cfif len(attributes.record_date2) and isdate(attributes.record_date2)>
	<cf_date tarih = "attributes.record_date2">
</cfif>
<cfif len(attributes.action_date1) and isdate(attributes.action_date1)>
	<cf_date tarih = "attributes.action_date1">
</cfif>
<cfif len(attributes.action_date2) and isdate(attributes.action_date2)>
	<cf_date tarih = "attributes.action_date2">
</cfif>
<cfif isdefined("attributes.is_cheque") and attributes.report_type neq 6>
	<cfif listfind(attributes.status,'14')>
		<cfquery name="get_cheque_voucher_transfer" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
			<!--- cariye bağlanmayan transfer işlemi için PY --->
			SELECT
			     <cfif attributes.report_type eq 4>
			    (SELECT TOP 1 P.PAYROLL_TYPE FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY_TYPE,
				(SELECT TOP 1 P.PAYROLL_NO FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY_NO,
				(SELECT TOP 1 CHH.PAYROLL_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY,
			    </cfif>			
				(SELECT TOP 1 P.COMPANY_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS = 4 ORDER BY CHH.HISTORY_ID DESC) AS NEW_COMPANY_ID,
				ISNULL((SELECT TOP 1 P.PAYROLL_ACCOUNT_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(2,3) ORDER BY CHH.HISTORY_ID DESC),C.ACCOUNT_ID) AS NEW_ACCOUNT_ID,
				<cfif attributes.report_type eq 1>
					C.ACCOUNT_NO,
					C.CHEQUE_ID AS ISLEM_ID,
					C.CHEQUE_CODE AS OZEL_KOD,
					C.CHEQUE_DUEDATE AS DUE_DATE,
					C.CHEQUE_NO AS PAPER_NO,
					C.BANK_NAME,
					C.BANK_BRANCH_NAME,
					(SELECT TOP 1 P.PAYROLL_TYPE FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY_TYPE,
					(SELECT TOP 1 P.PAYROLL_NO FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY_NO,
					(SELECT TOP 1 CHH.PAYROLL_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY,
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							ISNULL((SELECT CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID IN(SELECT ACTION_ID FROM PAYROLL WHERE PAYROLL_TYPE=106)),C.CHEQUE_STATUS_ID) AS STATUS,
						<cfelseif len(attributes.action_date2)>
							ISNULL((SELECT TOP 1 CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID) AS STATUS,
						<cfelse>	
							C.CHEQUE_STATUS_ID AS STATUS,
						</cfif>
					<cfelse>	
						C.CHEQUE_STATUS_ID AS STATUS,
					</cfif>
					C.DEBTOR_NAME AS DEBTOR_NAME,
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						)
					<cfelse>
						C.CASH_ID
					</cfif> AS CASH_ID,
					ISNULL((SELECT TOP 1 P.PAYROLL_ACCOUNT_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(2,3) ORDER BY CHH.HISTORY_ID DESC),C.ACCOUNT_ID) AS ACCOUNT_ID,
					0 AS ORDER_ID,
					0 AS GECIKME_TUTAR,
					0 AS PAYMETHOD_ID,
					C.OTHER_MONEY_VALUE,
					C.OTHER_MONEY_VALUE2,
					C.CHEQUE_VALUE AS OTHER_ACT_VALUE,
					C.CURRENCY_ID AS OTHER_MONEY,
					0 AS MEMBER_ID,
					'' AS MUSTERI,
					'' AS MEMBER_CODE,
					'' AS M_OZEL_KOD,
					0 AS MEMBER_TYPE,
					0 AS TYPE,
                    PR.PROJECT_HEAD,
					(SELECT TOP 1 CH.ACT_DATE FROM CHEQUE_HISTORY CH WHERE CH.CHEQUE_ID=C.CHEQUE_ID <cfif len(attributes.status)>AND CH.STATUS IN(#attributes.status#)</cfif> ORDER BY CH.RECORD_DATE DESC) TAHSILAT_TARIHI
				<cfelseif attributes.report_type eq 2>
					SUM(C.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),C.CHEQUE_DUEDATE)*C.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					<cfif isdefined("attributes.is_other_money")>
						SUM(C.CHEQUE_VALUE) AS TOTAL_AMOUNT_OTHER,
						C.CURRENCY_ID AS OTHER_MONEY,
					</cfif>			
					<cfif isdefined("attributes.is_money2")>
						SUM(C.OTHER_MONEY_VALUE2) AS TOTAL_AMOUNT2,
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						0 AS TOTAL_GECIKME,
					</cfif>				
					<cfif isdefined("attributes.bloke_member") and attributes.bloke_member eq 1>
						CR.FILE_NUMBER,
						CR.LAW_ADWOCATE,
					</cfif>
					0 AS MEMBER_ID,
					'' AS MUSTERI,
					'' AS MEMBER_CODE,
					'' AS M_OZEL_KOD,
					'' MOBIL_TEL,
					0 AS MEMBER_TYPE
				<cfelseif attributes.report_type eq 3>
					SUM(C.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),C.CHEQUE_DUEDATE)*C.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					<cfif isdefined("attributes.is_other_money")>
						SUM(C.CHEQUE_VALUE) AS TOTAL_AMOUNT_OTHER,
						C.CURRENCY_ID AS OTHER_MONEY,
					</cfif>			
					<cfif isdefined("attributes.is_money2")>
						SUM(C.OTHER_MONEY_VALUE2) AS TOTAL_AMOUNT2,
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						0 AS TOTAL_GECIKME,
					</cfif>
					CR.LAW_ADWOCATE
				<cfelseif attributes.report_type eq 4>
					SUM(C.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),C.CHEQUE_DUEDATE)*C.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					<cfif isdefined("attributes.is_other_money")>
						SUM(C.CHEQUE_VALUE) AS TOTAL_AMOUNT_OTHER,
						C.CURRENCY_ID AS OTHER_MONEY,
					</cfif>			
					<cfif isdefined("attributes.is_money2")>
						SUM(C.OTHER_MONEY_VALUE2) AS TOTAL_AMOUNT2,
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						0 AS TOTAL_GECIKME,
						0 AS TOTAL_GECIKME_VADE,
					</cfif>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						)
					<cfelse>
						C.CASH_ID
					</cfif> AS CASH_ID,
					CASH.CASH_NAME AS CASH_NAME,
					0 AS TOTAL_AMOUNT_ICRA,
					0 AS AVG_DUEDATE_ICRA,
					0 AS TOTAL_AMOUNT_VADE,
					0 AS AVG_DUEDATE_VADE
				<cfelseif attributes.report_type eq 5>
					SUM(C.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),C.CHEQUE_DUEDATE)*C.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					C.CHEQUE_DUEDATE AS DUE_DATE,
					MONTH(C.CHEQUE_DUEDATE) AS MONTH_DUE,
					YEAR(C.CHEQUE_DUEDATE) AS YEAR_DUE,
					C.CHEQUE_STATUS_ID AS STATUS
					<cfif isdefined("attributes.is_other_money")>
						,SUM(C.CHEQUE_VALUE) AS TOTAL_AMOUNT_OTHER
						,C.CURRENCY_ID AS OTHER_MONEY
					</cfif>
				</cfif>
			FROM
				CHEQUE C,
				PAYROLL P
                <cfif attributes.report_type eq 1>
                	LEFT JOIN #dsn_alias#.PRO_PROJECTS PR ON P.PROJECT_ID = PR.PROJECT_ID
                </cfif>
				<cfif (isdefined("attributes.bloke_member") and attributes.bloke_member eq 1) or attributes.report_type eq 3>
					,#dsn_alias#.COMPANY_LAW_REQUEST CR
				</cfif>
				<cfif attributes.report_type eq 4>
					,CASH
				</cfif>
			WHERE
				C.CHEQUE_PAYROLL_ID = P.ACTION_ID
                <cfif isdefined("attributes.self_cheque1") and len(attributes.self_cheque1)>
                	AND C.SELF_CHEQUE = 1
                <cfelseif isdefined("attributes.self_cheque2") and len(attributes.self_cheque2)>
                	AND C.SELF_CHEQUE = 0
                </cfif>
				<cfif isdefined("attributes.cash_id") and len(attributes.cash_id)>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						AND ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID) = #attributes.cash_id#
					<cfelseif isdefined("attributes.is_status_info")>
						AND ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						) = #attributes.cash_id#
					<cfelse>
						AND C.CASH_ID = #attributes.cash_id#
					</cfif>
				</cfif>
				<cfif isdefined("attributes.account_id") and len(attributes.account_id)>
					AND (SELECT TOP 1 P.PAYROLL_ACCOUNT_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(2,3) ORDER BY CHH.HISTORY_ID DESC) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account_id#" list="yes">)
				</cfif>
				<cfif isdefined("attributes.new_account_id") and len(attributes.new_account_id)>
					AND (SELECT TOP 1 P.PAYROLL_ACCOUNT_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(2,3) ORDER BY CHH.HISTORY_ID DESC) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.new_account_id#" list="yes">)
				</cfif>
				<cfif (isdefined("attributes.bloke_member") and attributes.bloke_member eq 1) or attributes.report_type eq 3>
					AND COMP.COMPANY_ID = CR.COMPANY_ID
					AND CR.REQUEST_STATUS = 1
					<cfif len(attributes.lawyer_name) and len(attributes.lawyer_id)>
						AND CR.LAW_ADWOCATE = #attributes.lawyer_id#
					</cfif>
				<cfelseif isdefined("attributes.bloke_member") and attributes.bloke_member eq 2>
					AND COMP.COMPANY_ID NOT IN(SELECT COMPANY_ID FROM #dsn_alias#.COMPANY_LAW_REQUEST WHERE COMPANY_ID IS NOT NULL)
				</cfif>
				<cfif isdefined("kurumsal") and listlen(kurumsal)>
					AND COMP.COMPANY_ID IN
						(
						SELECT 
							C.COMPANY_ID 
						FROM 
							#dsn_alias#.COMPANY C,
							#dsn_alias#.COMPANY_CAT CAT 
						WHERE 
							C.COMPANYCAT_ID = CAT.COMPANYCAT_ID AND
							(
								<cfloop list="#kurumsal#" delimiters="," index="cat_i">
									(CAT.COMPANYCAT_ID = #listlast(cat_i,'-')#)
									<cfif cat_i neq listlast(kurumsal,',') and listlen(kurumsal,',') gte 1> OR</cfif>
								</cfloop>  
							)
						)
				</cfif>
				<cfif isDefined("attributes.sales_zones") and len(attributes.sales_zones)>
					AND COMP.SALES_COUNTY = #attributes.sales_zones#
				</cfif>
				<cfif isDefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_code_text)>
					AND COMP.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE= #attributes.pos_code# AND IS_MASTER=1 AND OUR_COMPANY_ID = #session.ep.company_id# AND COMPANY_ID IS NOT NULL)
				</cfif>
				<cfif isDefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.employee)>
					AND P.REVENUE_COLLECTOR_ID = #attributes.employee_id#
				</cfif>
				<cfif isdate(attributes.start_date)>
					AND C.CHEQUE_DUEDATE >=#attributes.start_date#
				</cfif>
				<cfif isdate(attributes.finish_date)>
					AND C.CHEQUE_DUEDATE <=#attributes.finish_date#
				</cfif>
                <cfif isdefined("attributes.is_interest_show")>
                	AND DATEDIFF(day,C.CHEQUE_DUEDATE,GETDATE()) > 0
                </cfif>
				<cfif len(attributes.record_date1) and isdate(attributes.record_date1)>
					AND C.RECORD_DATE >=#attributes.record_date1#
				</cfif>
				<cfif len(attributes.record_date2) and isdate(attributes.record_date2)>
					AND C.RECORD_DATE < #DATEADD('d',1,attributes.record_date2)#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.company_id)>
					AND C.COMPANY_ID = #attributes.company_id#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.consumer_id)>
					AND C.CONSUMER_ID = #attributes.consumer_id#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.employee_id_)>
					AND C.EMPLOYEE_ID = #attributes.employee_id_#
				</cfif>
				<cfif len(trim(attributes.company2)) and len(attributes.company_id2)>
					AND (SELECT TOP 1 P.COMPANY_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS = 4 ORDER BY CHH.HISTORY_ID DESC) = #attributes.company_id2#
				</cfif>
				<cfif len(attributes.status)>
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							AND ISNULL((SELECT CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID IN(SELECT ACTION_ID FROM PAYROLL WHERE PAYROLL_TYPE=106)),C.CHEQUE_STATUS_ID) IN (#attributes.status#)
						<cfelseif len(attributes.action_date2)>
							AND ISNULL((SELECT TOP 1 CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID) IN (#attributes.status#)
						<cfelse>	
							AND C.CHEQUE_STATUS_ID IN (#attributes.status#)
						</cfif>
					<cfelse>	
						AND C.CHEQUE_STATUS_ID IN (#attributes.status#)
					</cfif>
				</cfif>
				<cfif attributes.report_type eq 4>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						AND CASH.CASH_ID = ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						AND CASH.CASH_ID = ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						)
					<cfelse>
						AND CASH.CASH_ID = C.CASH_ID
					</cfif>
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							AND ISNULL((SELECT CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID IN(SELECT ACTION_ID FROM PAYROLL WHERE PAYROLL_TYPE=106)),C.CHEQUE_STATUS_ID) = 1
						<cfelseif len(attributes.action_date2)>
							AND ISNULL((SELECT TOP 1 CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID) = 1
						<cfelse>	
							AND C.CHEQUE_STATUS_ID = 1
						</cfif>
					<cfelse>	
						AND C.CHEQUE_STATUS_ID = 1
					</cfif>
				</cfif>
				<cfif len(attributes.action_date1) and isdate(attributes.action_date1)>
					AND C.CHEQUE_ID IN(SELECT CH.CHEQUE_ID FROM CHEQUE_HISTORY CH WHERE <cfif len(attributes.status)>CH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(CH.ACT_DATE,DATEADD(day,-1,CH.RECORD_DATE)) >=#attributes.action_date1#) AND C.CHEQUE_ID = CH.CHEQUE_ID)
				</cfif>
				<cfif len(attributes.action_date2) and isdate(attributes.action_date2)>
					AND C.CHEQUE_ID IN(SELECT CH.CHEQUE_ID FROM CHEQUE_HISTORY CH WHERE <cfif len(attributes.status)>CH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(CH.ACT_DATE,DATEADD(day,-1,CH.RECORD_DATE)) <= #attributes.action_date2#) AND C.CHEQUE_ID = CH.CHEQUE_ID)
				</cfif>
				<cfif isdefined("attributes.is_open_acts")>
					AND P.PAYROLL_NO='-1'
				</cfif>
				<cfif len(attributes.owner_company) and len(attributes.owner_company_id) and attributes.owner_member_type eq 'partner'>
					AND C.OWNER_COMPANY_ID = #attributes.owner_company_id#
				<cfelseif len(attributes.owner_company) and len(attributes.owner_consumer_id) and attributes.owner_member_type eq 'consumer'>
					AND C.OWNER_CONSUMER_ID = #attributes.owner_consumer_id#
				<cfelseif len(attributes.owner_company) and len(attributes.owner_employee_id) and attributes.owner_member_type eq 'employee'>
					AND C.OWNER_EMPLOYEE_ID = #attributes.owner_employee_id#
				</cfif>
			<cfif attributes.report_type neq 1>	
				GROUP BY
			</cfif>
			<cfif attributes.report_type eq 2>
				C.ACCOUNT_ID,
				P.COMPANY_ID,
				COMP.NICKNAME,
				COMP.MEMBER_CODE,
				C.CHEQUE_ID,
				COMP.OZEL_KOD
				<cfif isdefined("attributes.is_other_money")>
				,C.CURRENCY_ID
				</cfif>
				<cfif isdefined("attributes.bloke_member") and attributes.bloke_member eq 1>
				,CR.FILE_NUMBER
				,CR.LAW_ADWOCATE
				</cfif>
			<cfelseif attributes.report_type eq 3>
				CR.LAW_ADWOCATE,
				C.CHEQUE_ID,
				C.ACCOUNT_ID
				<cfif isdefined("attributes.is_other_money")>
				,C.CURRENCY_ID
				</cfif>
			<cfelseif attributes.report_type eq 4>
				<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
					ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID)
				<cfelseif isdefined("attributes.is_status_info")>
					ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						)
				<cfelse>
					C.CASH_ID
				</cfif>,
				C.CHEQUE_ID,
				C.ACCOUNT_ID,
				CASH.CASH_NAME
				<cfif isdefined("attributes.is_other_money")>
					,C.CURRENCY_ID
				</cfif>
			<cfelseif attributes.report_type eq 5>
				C.CHEQUE_ID,
				C.ACCOUNT_ID,
				C.CHEQUE_DUEDATE,
				MONTH(C.CHEQUE_DUEDATE),
				YEAR(C.CHEQUE_DUEDATE),
				C.CHEQUE_STATUS_ID
				<cfif isdefined("attributes.is_other_money")>
				,C.CURRENCY_ID
				</cfif>
			</cfif>
		</cfquery>
	</cfif>
	<cfif len(kurumsal) or not len(bireysel)>
		<cfquery name="get_cheque_voucher_1" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
			<!--- company_ dolu olan --->
			SELECT
			     <cfif attributes.report_type eq 4>
			    (SELECT TOP 1 P.PAYROLL_TYPE FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY_TYPE,
				(SELECT TOP 1 P.PAYROLL_NO FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY_NO,
				(SELECT TOP 1 CHH.PAYROLL_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY,
			    </cfif>			
				(SELECT TOP 1 P.COMPANY_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS = 4 ORDER BY CHH.HISTORY_ID DESC) AS NEW_COMPANY_ID,
				ISNULL((SELECT TOP 1 P.PAYROLL_ACCOUNT_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(2,3) ORDER BY CHH.HISTORY_ID DESC),C.ACCOUNT_ID) AS NEW_ACCOUNT_ID,
				<cfif attributes.report_type eq 1>
					C.ACCOUNT_NO,
					C.CHEQUE_ID AS ISLEM_ID,
					C.CHEQUE_CODE AS OZEL_KOD,
					C.CHEQUE_DUEDATE AS DUE_DATE,
					C.CHEQUE_NO AS PAPER_NO,
					C.BANK_NAME,
					C.BANK_BRANCH_NAME,
					(SELECT TOP 1 P.PAYROLL_TYPE FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY_TYPE,
					(SELECT TOP 1 P.PAYROLL_NO FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY_NO,
					(SELECT TOP 1 CHH.PAYROLL_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY,
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							ISNULL((SELECT CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID IN(SELECT ACTION_ID FROM PAYROLL WHERE PAYROLL_TYPE=106)),C.CHEQUE_STATUS_ID) AS STATUS,
						<cfelseif len(attributes.action_date2)>
							ISNULL((SELECT TOP 1 CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID) AS STATUS,
						<cfelse>	
							C.CHEQUE_STATUS_ID AS STATUS,
						</cfif>
					<cfelse>	
						C.CHEQUE_STATUS_ID AS STATUS,
					</cfif>
					C.DEBTOR_NAME AS DEBTOR_NAME,
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						)
					<cfelse>
						C.CASH_ID
					</cfif> AS CASH_ID,
					ISNULL((SELECT TOP 1 P.PAYROLL_ACCOUNT_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(2,3) ORDER BY CHH.HISTORY_ID DESC),C.ACCOUNT_ID) AS ACCOUNT_ID,
					0 AS ORDER_ID,
					0 AS GECIKME_TUTAR,
					0 AS PAYMETHOD_ID,
					C.OTHER_MONEY_VALUE,
					C.OTHER_MONEY_VALUE2,
					C.CHEQUE_VALUE AS OTHER_ACT_VALUE,
					C.CURRENCY_ID AS OTHER_MONEY,
					P.COMPANY_ID AS MEMBER_ID,
					COMP.NICKNAME AS MUSTERI,
					COMP.MEMBER_CODE AS MEMBER_CODE,
					COMP.OZEL_KOD AS M_OZEL_KOD,
					0 AS MEMBER_TYPE,
					0 AS TYPE,
                    PR.PROJECT_HEAD,
					(SELECT TOP 1 CH.ACT_DATE FROM CHEQUE_HISTORY CH WHERE CH.CHEQUE_ID=C.CHEQUE_ID <cfif len(attributes.status)>AND CH.STATUS IN(#attributes.status#)</cfif> ORDER BY CH.RECORD_DATE DESC) TAHSILAT_TARIHI
				<cfelseif attributes.report_type eq 2>
					SUM(C.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),C.CHEQUE_DUEDATE)*C.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					<cfif isdefined("attributes.is_other_money")>
						SUM(C.CHEQUE_VALUE) AS TOTAL_AMOUNT_OTHER,
						C.CURRENCY_ID AS OTHER_MONEY,
					</cfif>			
					<cfif isdefined("attributes.is_money2")>
						SUM(C.OTHER_MONEY_VALUE2) AS TOTAL_AMOUNT2,
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						0 AS TOTAL_GECIKME,
					</cfif>				
					<cfif isdefined("attributes.bloke_member") and attributes.bloke_member eq 1>
						CR.FILE_NUMBER,
						CR.LAW_ADWOCATE,
					</cfif>
					P.COMPANY_ID AS MEMBER_ID,
					COMP.NICKNAME AS MUSTERI,
					COMP.MEMBER_CODE AS MEMBER_CODE,
					COMP.OZEL_KOD AS M_OZEL_KOD,
					'' MOBIL_TEL,
					0 AS MEMBER_TYPE
				<cfelseif attributes.report_type eq 3>
					SUM(C.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),C.CHEQUE_DUEDATE)*C.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					<cfif isdefined("attributes.is_other_money")>
						SUM(C.CHEQUE_VALUE) AS TOTAL_AMOUNT_OTHER,
						C.CURRENCY_ID AS OTHER_MONEY,
					</cfif>			
					<cfif isdefined("attributes.is_money2")>
						SUM(C.OTHER_MONEY_VALUE2) AS TOTAL_AMOUNT2,
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						0 AS TOTAL_GECIKME,
					</cfif>
					CR.LAW_ADWOCATE
				<cfelseif attributes.report_type eq 4>
					SUM(C.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),C.CHEQUE_DUEDATE)*C.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					<cfif isdefined("attributes.is_other_money")>
						SUM(C.CHEQUE_VALUE) AS TOTAL_AMOUNT_OTHER,
						C.CURRENCY_ID AS OTHER_MONEY,
					</cfif>			
					<cfif isdefined("attributes.is_money2")>
						SUM(C.OTHER_MONEY_VALUE2) AS TOTAL_AMOUNT2,
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						0 AS TOTAL_GECIKME,
						0 AS TOTAL_GECIKME_VADE,
					</cfif>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						)
					<cfelse>
						C.CASH_ID
					</cfif> AS CASH_ID,
					CASH.CASH_NAME AS CASH_NAME,
					0 AS TOTAL_AMOUNT_ICRA,
					0 AS AVG_DUEDATE_ICRA,
					0 AS TOTAL_AMOUNT_VADE,
					0 AS AVG_DUEDATE_VADE
				<cfelseif attributes.report_type eq 5>
					SUM(C.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),C.CHEQUE_DUEDATE)*C.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					C.CHEQUE_DUEDATE AS DUE_DATE,
					MONTH(C.CHEQUE_DUEDATE) AS MONTH_DUE,
					YEAR(C.CHEQUE_DUEDATE) AS YEAR_DUE,
					C.CHEQUE_STATUS_ID AS STATUS
					<cfif isdefined("attributes.is_other_money")>
						,SUM(C.CHEQUE_VALUE) AS TOTAL_AMOUNT_OTHER
						,C.CURRENCY_ID AS OTHER_MONEY
					</cfif>
				</cfif>
			FROM
				CHEQUE C,
				PAYROLL P
                <cfif attributes.report_type eq 1>
                	LEFT JOIN #dsn_alias#.PRO_PROJECTS PR ON P.PROJECT_ID = PR.PROJECT_ID
                </cfif>,
				#dsn_alias#.COMPANY COMP
				<cfif (isdefined("attributes.bloke_member") and attributes.bloke_member eq 1) or attributes.report_type eq 3>
					,#dsn_alias#.COMPANY_LAW_REQUEST CR
				</cfif>
				<cfif attributes.report_type eq 4>
					,CASH
				</cfif>
			WHERE
				C.CHEQUE_PAYROLL_ID = P.ACTION_ID
				AND P.COMPANY_ID = COMP.COMPANY_ID
                <cfif isdefined("attributes.self_cheque1") and len(attributes.self_cheque1)>
                	AND C.SELF_CHEQUE = 1
                <cfelseif isdefined("attributes.self_cheque2") and len(attributes.self_cheque2)>
                	AND C.SELF_CHEQUE = 0
                </cfif>
				<cfif isdefined("attributes.cash_id") and len(attributes.cash_id)>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						AND ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID) = #attributes.cash_id#
					<cfelseif isdefined("attributes.is_status_info")>
						AND ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						) = #attributes.cash_id#
					<cfelse>
						AND C.CASH_ID = #attributes.cash_id#
					</cfif>
				</cfif>
				<cfif isdefined("attributes.account_id") and len(attributes.account_id)>
					AND ISNULL((SELECT TOP 1 P.PAYROLL_ACCOUNT_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(2,3) ORDER BY CHH.HISTORY_ID DESC),C.ACCOUNT_ID) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account_id#" list="yes">)
				</cfif>
				<cfif isdefined("attributes.new_account_id") and len(attributes.new_account_id)>
					AND ISNULL((SELECT TOP 1 P.PAYROLL_ACCOUNT_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(2,3) ORDER BY CHH.HISTORY_ID DESC),C.ACCOUNT_ID) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.new_account_id#" list="yes">)
				</cfif>
				<cfif (isdefined("attributes.bloke_member") and attributes.bloke_member eq 1) or attributes.report_type eq 3>
					AND COMP.COMPANY_ID = CR.COMPANY_ID
					AND CR.REQUEST_STATUS = 1
					<cfif len(attributes.lawyer_name) and len(attributes.lawyer_id)>
						AND CR.LAW_ADWOCATE = #attributes.lawyer_id#
					</cfif>
				<cfelseif isdefined("attributes.bloke_member") and attributes.bloke_member eq 2>
					AND COMP.COMPANY_ID NOT IN(SELECT COMPANY_ID FROM #dsn_alias#.COMPANY_LAW_REQUEST WHERE COMPANY_ID IS NOT NULL)
				</cfif>
				<cfif isdefined("kurumsal") and listlen(kurumsal)>
					AND COMP.COMPANY_ID IN
						(
						SELECT 
							C.COMPANY_ID 
						FROM 
							#dsn_alias#.COMPANY C,
							#dsn_alias#.COMPANY_CAT CAT 
						WHERE 
							C.COMPANYCAT_ID = CAT.COMPANYCAT_ID AND
							(
								<cfloop list="#kurumsal#" delimiters="," index="cat_i">
									(CAT.COMPANYCAT_ID = #listlast(cat_i,'-')#)
									<cfif cat_i neq listlast(kurumsal,',') and listlen(kurumsal,',') gte 1> OR</cfif>
								</cfloop>  
							)
						)
				</cfif>
				<cfif isDefined("attributes.sales_zones") and len(attributes.sales_zones)>
					AND COMP.SALES_COUNTY = #attributes.sales_zones#
				</cfif>
				<cfif isDefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_code_text)>
					AND COMP.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE= #attributes.pos_code# AND IS_MASTER=1 AND OUR_COMPANY_ID = #session.ep.company_id# AND COMPANY_ID IS NOT NULL)
				</cfif>
				<cfif isDefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.employee)>
					AND P.REVENUE_COLLECTOR_ID = #attributes.employee_id#
				</cfif>
				<cfif isdate(attributes.start_date)>
					AND C.CHEQUE_DUEDATE >=#attributes.start_date#
				</cfif>
				<cfif isdate(attributes.finish_date)>
					AND C.CHEQUE_DUEDATE <=#attributes.finish_date#
				</cfif>
                <cfif isdefined("attributes.is_interest_show")>
                	AND DATEDIFF(day,C.CHEQUE_DUEDATE,GETDATE()) > 0
                </cfif>
				<cfif len(attributes.record_date1) and isdate(attributes.record_date1)>
					AND C.RECORD_DATE >=#attributes.record_date1#
				</cfif>
				<cfif len(attributes.record_date2) and isdate(attributes.record_date2)>
					AND C.RECORD_DATE < #DATEADD('d',1,attributes.record_date2)#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.company_id)>
					AND C.COMPANY_ID = #attributes.company_id#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.consumer_id)>
					AND C.CONSUMER_ID = #attributes.consumer_id#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.employee_id_)>
					AND C.EMPLOYEE_ID = #attributes.employee_id_#
				</cfif>
				<cfif len(trim(attributes.company2)) and len(attributes.company_id2)>
					AND (SELECT TOP 1 P.COMPANY_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS = 4 ORDER BY CHH.HISTORY_ID DESC) = #attributes.company_id2#
				</cfif>
				<cfif len(attributes.status)>
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							AND ISNULL((SELECT CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID IN(SELECT ACTION_ID FROM PAYROLL WHERE PAYROLL_TYPE=106)),C.CHEQUE_STATUS_ID) IN (#attributes.status#)
						<cfelseif len(attributes.action_date2)>
							AND ISNULL((SELECT TOP 1 CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID) IN (#attributes.status#)
						<cfelse>	
							AND C.CHEQUE_STATUS_ID IN (#attributes.status#)
						</cfif>
					<cfelse>	
						AND C.CHEQUE_STATUS_ID IN (#attributes.status#)
					</cfif>
				</cfif>
				<cfif attributes.report_type eq 4>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						AND CASH.CASH_ID = ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						AND CASH.CASH_ID = ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						)
					<cfelse>
						AND CASH.CASH_ID = C.CASH_ID
					</cfif>
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							AND ISNULL((SELECT CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID IN(SELECT ACTION_ID FROM PAYROLL WHERE PAYROLL_TYPE=106)),C.CHEQUE_STATUS_ID) = 1
						<cfelseif len(attributes.action_date2)>
							AND ISNULL((SELECT TOP 1 CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID) = 1
						<cfelse>	
							AND C.CHEQUE_STATUS_ID = 1
						</cfif>
					<cfelse>	
						AND C.CHEQUE_STATUS_ID = 1
					</cfif>
				</cfif>
				<cfif len(attributes.action_date1) and isdate(attributes.action_date1)>
					AND C.CHEQUE_ID IN(SELECT CH.CHEQUE_ID FROM CHEQUE_HISTORY CH WHERE <cfif len(attributes.status)>CH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(CH.ACT_DATE,DATEADD(day,-1,CH.RECORD_DATE)) >=#attributes.action_date1#) AND C.CHEQUE_ID = CH.CHEQUE_ID)
				</cfif>
				<cfif len(attributes.action_date2) and isdate(attributes.action_date2)>
					AND C.CHEQUE_ID IN(SELECT CH.CHEQUE_ID FROM CHEQUE_HISTORY CH WHERE <cfif len(attributes.status)>CH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(CH.ACT_DATE,DATEADD(day,-1,CH.RECORD_DATE)) <= #attributes.action_date2#) AND C.CHEQUE_ID = CH.CHEQUE_ID)
				</cfif>
				<cfif isdefined("attributes.is_open_acts")>
					AND P.PAYROLL_NO='-1'
				</cfif>
				<cfif len(attributes.owner_company) and len(attributes.owner_company_id) and attributes.owner_member_type eq 'partner'>
					AND C.OWNER_COMPANY_ID = #attributes.owner_company_id#
				<cfelseif len(attributes.owner_company) and len(attributes.owner_consumer_id) and attributes.owner_member_type eq 'consumer'>
					AND C.OWNER_CONSUMER_ID = #attributes.owner_consumer_id#
				<cfelseif len(attributes.owner_company) and len(attributes.owner_employee_id) and attributes.owner_member_type eq 'employee'>
					AND C.OWNER_EMPLOYEE_ID = #attributes.owner_employee_id#
				</cfif>
			<cfif attributes.report_type neq 1>	
				GROUP BY
			</cfif>
			<cfif attributes.report_type eq 2>
				C.ACCOUNT_ID,
				P.COMPANY_ID,
				COMP.NICKNAME,
				COMP.MEMBER_CODE,
				C.CHEQUE_ID,
				COMP.OZEL_KOD
				<cfif isdefined("attributes.is_other_money")>
				,C.CURRENCY_ID
				</cfif>
				<cfif isdefined("attributes.bloke_member") and attributes.bloke_member eq 1>
				,CR.FILE_NUMBER
				,CR.LAW_ADWOCATE
				</cfif>
			<cfelseif attributes.report_type eq 3>
				CR.LAW_ADWOCATE,
				C.CHEQUE_ID,
				C.ACCOUNT_ID
				<cfif isdefined("attributes.is_other_money")>
				,C.CURRENCY_ID
				</cfif>
			<cfelseif attributes.report_type eq 4>
				<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
					ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID)
				<cfelseif isdefined("attributes.is_status_info")>
					ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						)
				<cfelse>
					C.CASH_ID
				</cfif>,
				C.CHEQUE_ID,
				C.ACCOUNT_ID,
				CASH.CASH_NAME
				<cfif isdefined("attributes.is_other_money")>
					,C.CURRENCY_ID
				</cfif>
			<cfelseif attributes.report_type eq 5>
				C.CHEQUE_ID,
				C.ACCOUNT_ID,
				C.CHEQUE_DUEDATE,
				MONTH(C.CHEQUE_DUEDATE),
				YEAR(C.CHEQUE_DUEDATE),
				C.CHEQUE_STATUS_ID
				<cfif isdefined("attributes.is_other_money")>
				,C.CURRENCY_ID
				</cfif>
			</cfif>
		</cfquery>
		<cfquery name="get_cheque_voucher_3" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
			<!--- çek de company olanlar --->
			SELECT
			<cfif attributes.report_type eq 4>
			    (SELECT TOP 1 P.PAYROLL_TYPE FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY_TYPE,
				(SELECT TOP 1 P.PAYROLL_NO FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY_NO,
				(SELECT TOP 1 CHH.PAYROLL_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY,
			</cfif>
				(SELECT TOP 1 P.COMPANY_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS = 4 ORDER BY CHH.HISTORY_ID DESC) AS NEW_COMPANY_ID,
				ISNULL((SELECT TOP 1 P.PAYROLL_ACCOUNT_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(2,3) ORDER BY CHH.HISTORY_ID DESC),C.ACCOUNT_ID) AS NEW_ACCOUNT_ID,
				<cfif attributes.report_type eq 1>
					C.ACCOUNT_NO,
					C.CHEQUE_ID AS ISLEM_ID,
					C.CHEQUE_CODE AS OZEL_KOD,
					C.CHEQUE_DUEDATE AS DUE_DATE,
					C.CHEQUE_NO AS PAPER_NO,
					C.BANK_NAME,
					C.BANK_BRANCH_NAME,
					(SELECT TOP 1 P.PAYROLL_TYPE FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY_TYPE,
					(SELECT TOP 1 P.PAYROLL_NO FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY_NO,
					(SELECT TOP 1 CHH.PAYROLL_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY,
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							ISNULL((SELECT CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID IN(SELECT ACTION_ID FROM PAYROLL WHERE PAYROLL_TYPE=106)),C.CHEQUE_STATUS_ID) AS STATUS,
						<cfelseif len(attributes.action_date2)>
							ISNULL((SELECT TOP 1 CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID) AS STATUS,
						<cfelse>	
							C.CHEQUE_STATUS_ID AS STATUS,
						</cfif>
					<cfelse>	
						C.CHEQUE_STATUS_ID AS STATUS,
					</cfif>
					C.DEBTOR_NAME AS DEBTOR_NAME,
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						)
					<cfelse>
						C.CASH_ID
					</cfif> AS CASH_ID,
					ISNULL((SELECT TOP 1 P.PAYROLL_ACCOUNT_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(2,3) ORDER BY CHH.HISTORY_ID DESC),C.ACCOUNT_ID) AS ACCOUNT_ID,
					0 AS ORDER_ID,
					0 AS GECIKME_TUTAR,
					0 AS PAYMETHOD_ID,
					C.OTHER_MONEY_VALUE,
					C.OTHER_MONEY_VALUE2,
					C.CHEQUE_VALUE AS OTHER_ACT_VALUE,
					C.CURRENCY_ID AS OTHER_MONEY,
					COMP.COMPANY_ID AS MEMBER_ID,
					COMP.NICKNAME AS MUSTERI,
					COMP.MEMBER_CODE AS MEMBER_CODE,
					COMP.OZEL_KOD AS M_OZEL_KOD,
					0 AS MEMBER_TYPE,
					0 AS TYPE,
                    PR.PROJECT_HEAD,
					(SELECT TOP 1 CH.ACT_DATE FROM CHEQUE_HISTORY CH WHERE CH.CHEQUE_ID=C.CHEQUE_ID <cfif len(attributes.status)>AND CH.STATUS IN(#attributes.status#)</cfif> ORDER BY CH.RECORD_DATE DESC) TAHSILAT_TARIHI
				<cfelseif attributes.report_type eq 2>
					SUM(C.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),C.CHEQUE_DUEDATE)*C.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					<cfif isdefined("attributes.is_other_money")>
						SUM(C.CHEQUE_VALUE) AS TOTAL_AMOUNT_OTHER,
						C.CURRENCY_ID AS OTHER_MONEY,
					</cfif>			
					<cfif isdefined("attributes.is_money2")>
						SUM(C.OTHER_MONEY_VALUE2) AS TOTAL_AMOUNT2,
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						0 AS TOTAL_GECIKME,
					</cfif>				
					<cfif isdefined("attributes.bloke_member") and attributes.bloke_member eq 1>
						CR.FILE_NUMBER,
						CR.LAW_ADWOCATE,
					</cfif>
					C.COMPANY_ID AS MEMBER_ID,
					COMP.NICKNAME AS MUSTERI,
					COMP.MEMBER_CODE AS MEMBER_CODE,
					COMP.OZEL_KOD AS M_OZEL_KOD,
					'' MOBIL_TEL,
					0 AS MEMBER_TYPE
				<cfelseif attributes.report_type eq 3>
					SUM(C.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),C.CHEQUE_DUEDATE)*C.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					<cfif isdefined("attributes.is_other_money")>
						SUM(C.CHEQUE_VALUE) AS TOTAL_AMOUNT_OTHER,
						C.CURRENCY_ID AS OTHER_MONEY,
					</cfif>			
					<cfif isdefined("attributes.is_money2")>
						SUM(C.OTHER_MONEY_VALUE2) AS TOTAL_AMOUNT2,
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						0 AS TOTAL_GECIKME,
					</cfif>
					CR.LAW_ADWOCATE
				<cfelseif attributes.report_type eq 4>
					SUM(C.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),C.CHEQUE_DUEDATE)*C.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					<cfif isdefined("attributes.is_other_money")>
						SUM(C.CHEQUE_VALUE) AS TOTAL_AMOUNT_OTHER,
						C.CURRENCY_ID AS OTHER_MONEY,
					</cfif>			
					<cfif isdefined("attributes.is_money2")>
						SUM(C.OTHER_MONEY_VALUE2) AS TOTAL_AMOUNT2,
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						0 AS TOTAL_GECIKME,
						0 AS TOTAL_GECIKME_VADE,
					</cfif>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						)
					<cfelse>
						C.CASH_ID
					</cfif> AS CASH_ID,
					CASH.CASH_NAME AS CASH_NAME,
					0 AS TOTAL_AMOUNT_ICRA,
					0 AS AVG_DUEDATE_ICRA,
					0 AS TOTAL_AMOUNT_VADE,
					0 AS AVG_DUEDATE_VADE
				<cfelseif attributes.report_type eq 5>
					SUM(C.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),C.CHEQUE_DUEDATE)*C.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					C.CHEQUE_DUEDATE AS DUE_DATE,
					MONTH(C.CHEQUE_DUEDATE) AS MONTH_DUE,
					YEAR(C.CHEQUE_DUEDATE) AS YEAR_DUE,
					C.CHEQUE_STATUS_ID AS STATUS
					<cfif isdefined("attributes.is_other_money")>
						,SUM(C.CHEQUE_VALUE) AS TOTAL_AMOUNT_OTHER
						,C.CURRENCY_ID AS OTHER_MONEY
					</cfif>
				</cfif>
			FROM
				CHEQUE C,
				PAYROLL P
                <cfif attributes.report_type eq 1>
                	LEFT JOIN #dsn_alias#.PRO_PROJECTS PR ON P.PROJECT_ID = PR.PROJECT_ID
                </cfif>,
				#dsn_alias#.COMPANY COMP
				<cfif (isdefined("attributes.bloke_member") and attributes.bloke_member eq 1) or attributes.report_type eq 3>
					,#dsn_alias#.COMPANY_LAW_REQUEST CR
				</cfif>
				<cfif attributes.report_type eq 4>
					,CASH
				</cfif>
			WHERE
				C.CHEQUE_PAYROLL_ID = P.ACTION_ID
				AND P.PAYROLL_TYPE IN (106, 135)<!---135 transfer----->
				AND P.COMPANY_ID IS NULL
				AND P.CONSUMER_ID IS NULL
				AND C.COMPANY_ID = COMP.COMPANY_ID
                <cfif isdefined("attributes.self_cheque1") and len(attributes.self_cheque1)>
                	AND C.SELF_CHEQUE = 1
                <cfelseif isdefined("attributes.self_cheque2") and len(attributes.self_cheque2)>
                	AND C.SELF_CHEQUE = 0
                </cfif>
				<cfif isdefined("attributes.cash_id") and len(attributes.cash_id)>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						AND ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID) = #attributes.cash_id#
					<cfelseif isdefined("attributes.is_status_info")>
						AND ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						) = #attributes.cash_id#
					<cfelse>
						AND C.CASH_ID = #attributes.cash_id#
					</cfif>
				</cfif>
				<cfif isdefined("attributes.account_id") and len(attributes.account_id)>
					AND (SELECT TOP 1 P.PAYROLL_ACCOUNT_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(2,3) ORDER BY CHH.HISTORY_ID DESC) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account_id#" list="yes">)
				</cfif>
				<cfif isdefined("attributes.new_account_id") and len(attributes.new_account_id)>
					AND (SELECT TOP 1 P.PAYROLL_ACCOUNT_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(2,3) ORDER BY CHH.HISTORY_ID DESC) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.new_account_id#" list="yes">)
				</cfif>
				<cfif (isdefined("attributes.bloke_member") and attributes.bloke_member eq 1) or attributes.report_type eq 3>
					AND COMP.COMPANY_ID = CR.COMPANY_ID
					AND CR.REQUEST_STATUS = 1
					<cfif len(attributes.lawyer_name) and len(attributes.lawyer_id)>
						AND CR.LAW_ADWOCATE = #attributes.lawyer_id#
					</cfif>
				<cfelseif isdefined("attributes.bloke_member") and attributes.bloke_member eq 2>
					AND COMP.COMPANY_ID NOT IN(SELECT COMPANY_ID FROM #dsn_alias#.COMPANY_LAW_REQUEST WHERE COMPANY_ID IS NOT NULL)
				</cfif>
				<cfif isdefined("kurumsal") and listlen(kurumsal)>
					AND COMP.COMPANY_ID IN
						(
						SELECT 
							C.COMPANY_ID 
						FROM 
							#dsn_alias#.COMPANY C,
							#dsn_alias#.COMPANY_CAT CAT 
						WHERE 
							C.COMPANYCAT_ID = CAT.COMPANYCAT_ID AND
							(
								<cfloop list="#kurumsal#" delimiters="," index="cat_i">
									(CAT.COMPANYCAT_ID = #listlast(cat_i,'-')#)
									<cfif cat_i neq listlast(kurumsal,',') and listlen(kurumsal,',') gte 1> OR</cfif>
								</cfloop>  
							)
						)
				</cfif>
				<cfif isDefined("attributes.sales_zones") and len(attributes.sales_zones)>
					AND COMP.SALES_COUNTY = #attributes.sales_zones#
				</cfif>
				<cfif isDefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_code_text)>
					AND COMP.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE= #attributes.pos_code# AND IS_MASTER=1 AND OUR_COMPANY_ID = #session.ep.company_id# AND COMPANY_ID IS NOT NULL)
				</cfif>
				<cfif isDefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.employee)>
					AND P.REVENUE_COLLECTOR_ID = #attributes.employee_id#
				</cfif>
				<cfif isdate(attributes.start_date)>
					AND C.CHEQUE_DUEDATE >=#attributes.start_date#
				</cfif>
				<cfif isdate(attributes.finish_date)>
					AND C.CHEQUE_DUEDATE <=#attributes.finish_date#
				</cfif>
                <cfif isdefined("attributes.is_interest_show")>
                	AND DATEDIFF(day,C.CHEQUE_DUEDATE,GETDATE()) > 0
                </cfif>
				<cfif len(attributes.record_date1) and isdate(attributes.record_date1)>
					AND C.RECORD_DATE >=#attributes.record_date1#
				</cfif>
				<cfif len(attributes.record_date2) and isdate(attributes.record_date2)>
					AND C.RECORD_DATE < #DATEADD('d',1,attributes.record_date2)#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.company_id)>
					AND C.COMPANY_ID = #attributes.company_id#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.consumer_id)>
					AND C.CONSUMER_ID = #attributes.consumer_id#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.employee_id_)>
					AND C.EMPLOYEE_ID = #attributes.employee_id_#
				</cfif>
				<cfif len(trim(attributes.company2)) and len(attributes.company_id2)>
					AND (SELECT TOP 1 P.COMPANY_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS = 4 ORDER BY CHH.HISTORY_ID DESC) = #attributes.company_id2#
				</cfif>
				<cfif len(attributes.status)>
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							AND ISNULL((SELECT CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID IN(SELECT ACTION_ID FROM PAYROLL WHERE PAYROLL_TYPE=106)),C.CHEQUE_STATUS_ID) IN (#attributes.status#)
						<cfelseif len(attributes.action_date2)>
							AND ISNULL((SELECT TOP 1 CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID) IN (#attributes.status#)
						<cfelse>	
							AND C.CHEQUE_STATUS_ID IN (#attributes.status#)
						</cfif>
					<cfelse>	
						AND C.CHEQUE_STATUS_ID IN (#attributes.status#)
					</cfif>
				</cfif>
				<cfif attributes.report_type eq 4>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						AND CASH.CASH_ID = ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						AND CASH.CASH_ID = ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						)
					<cfelse>
						AND CASH.CASH_ID = C.CASH_ID
					</cfif>
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							AND ISNULL((SELECT CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID IN(SELECT ACTION_ID FROM PAYROLL WHERE PAYROLL_TYPE=106)),C.CHEQUE_STATUS_ID) = 1
						<cfelseif len(attributes.action_date2)>
							AND ISNULL((SELECT TOP 1 CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID) = 1
						<cfelse>	
							AND C.CHEQUE_STATUS_ID IN  = 1
						</cfif>
					<cfelse>	
						AND C.CHEQUE_STATUS_ID = 1
					</cfif>
				</cfif>
				<cfif len(attributes.action_date1) and isdate(attributes.action_date1)>
					AND C.CHEQUE_ID IN(SELECT CH.CHEQUE_ID FROM CHEQUE_HISTORY CH WHERE <cfif len(attributes.status)>CH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(CH.ACT_DATE,DATEADD(day,-1,CH.RECORD_DATE)) >=#attributes.action_date1#) AND C.CHEQUE_ID = CH.CHEQUE_ID)
				</cfif>
				<cfif len(attributes.action_date2) and isdate(attributes.action_date2)>
					AND C.CHEQUE_ID IN(SELECT CH.CHEQUE_ID FROM CHEQUE_HISTORY CH WHERE <cfif len(attributes.status)>CH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(CH.ACT_DATE,DATEADD(day,-1,CH.RECORD_DATE)) <= #attributes.action_date2#) AND C.CHEQUE_ID = CH.CHEQUE_ID)
				</cfif>
				<cfif isdefined("attributes.is_open_acts")>
					AND P.PAYROLL_NO='-1'
				</cfif>
				<cfif len(attributes.owner_company) and len(attributes.owner_company_id) and attributes.owner_member_type eq 'partner'>
					AND C.OWNER_COMPANY_ID = #attributes.owner_company_id#
				<cfelseif len(attributes.owner_company) and len(attributes.owner_consumer_id) and attributes.owner_member_type eq 'consumer'>
					AND C.OWNER_CONSUMER_ID = #attributes.owner_consumer_id#
				<cfelseif len(attributes.owner_company) and len(attributes.owner_employee_id) and attributes.owner_member_type eq 'employee'>
					AND C.OWNER_EMPLOYEE_ID = #attributes.owner_employee_id#
				</cfif>
			<cfif attributes.report_type neq 1>	
				GROUP BY
			</cfif>
			<cfif attributes.report_type eq 2>
				C.ACCOUNT_ID,
				C.COMPANY_ID,
				COMP.NICKNAME,
				COMP.MEMBER_CODE,
				C.CHEQUE_ID,
				COMP.OZEL_KOD
				<cfif isdefined("attributes.is_other_money")>
				,C.CURRENCY_ID
				</cfif>
				<cfif isdefined("attributes.bloke_member") and attributes.bloke_member eq 1>
				,CR.FILE_NUMBER
				,CR.LAW_ADWOCATE
				</cfif>
			<cfelseif attributes.report_type eq 3>
				CR.LAW_ADWOCATE,
				C.CHEQUE_ID,
				C.ACCOUNT_ID
				<cfif isdefined("attributes.is_other_money")>
				,C.CURRENCY_ID
				</cfif>
			<cfelseif attributes.report_type eq 4>
				<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
					ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID)
				<cfelseif isdefined("attributes.is_status_info")>
					ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						)
				<cfelse>
					C.CASH_ID
				</cfif>,
				C.CHEQUE_ID,
				C.ACCOUNT_ID,
				CASH.CASH_NAME
				<cfif isdefined("attributes.is_other_money")>
				,C.CURRENCY_ID
				</cfif>
			<cfelseif attributes.report_type eq 5>
				C.CHEQUE_ID,
				C.ACCOUNT_ID,
				C.CHEQUE_DUEDATE,
				MONTH(C.CHEQUE_DUEDATE),
				YEAR(C.CHEQUE_DUEDATE),
				C.CHEQUE_STATUS_ID
				<cfif isdefined("attributes.is_other_money")>
				,C.CURRENCY_ID
				</cfif>
			</cfif>
		</cfquery>
	</cfif>
	<cfif len(bireysel) or not len(kurumsal)>
		<cfquery name="get_cheque_voucher_2" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
			<!--- consumer dolu olan --->
			SELECT
			<cfif attributes.report_type eq 4>
			    (SELECT TOP 1 P.PAYROLL_TYPE FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY_TYPE,
				(SELECT TOP 1 P.PAYROLL_NO FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY_NO,
				(SELECT TOP 1 CHH.PAYROLL_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY,
			</cfif>
				(SELECT TOP 1 P.COMPANY_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS = 4 ORDER BY CHH.HISTORY_ID DESC) AS NEW_COMPANY_ID,
				(SELECT TOP 1 P.PAYROLL_ACCOUNT_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(2,3) ORDER BY CHH.HISTORY_ID DESC) AS NEW_ACCOUNT_ID,
				<cfif attributes.report_type eq 1>
					C.ACCOUNT_NO,
					C.CHEQUE_ID AS ISLEM_ID,
					C.CHEQUE_CODE AS OZEL_KOD,
					C.CHEQUE_DUEDATE AS DUE_DATE,
					C.CHEQUE_NO AS PAPER_NO,
					C.BANK_NAME,
					C.BANK_BRANCH_NAME,
					(SELECT TOP 1 P.PAYROLL_TYPE FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY_TYPE,
					(SELECT TOP 1 P.PAYROLL_NO FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY_NO,
					(SELECT TOP 1 CHH.PAYROLL_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY,
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							ISNULL((SELECT CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID IN(SELECT ACTION_ID FROM PAYROLL WHERE PAYROLL_TYPE=106)),C.CHEQUE_STATUS_ID) AS STATUS,
						<cfelseif len(attributes.action_date2)>
							ISNULL((SELECT TOP 1 CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID) AS STATUS,
						<cfelse>	
							C.CHEQUE_STATUS_ID AS STATUS,
						</cfif>
					<cfelse>	
						C.CHEQUE_STATUS_ID AS STATUS,
					</cfif>
					C.DEBTOR_NAME AS DEBTOR_NAME,
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						)
					<cfelse>
						C.CASH_ID
					</cfif> AS CASH_ID,
					P.PAYROLL_ACCOUNT_ID AS ACCOUNT_ID,
					0 AS ORDER_ID,
					0 AS GECIKME_TUTAR,
					0 AS PAYMETHOD_ID,
					C.OTHER_MONEY_VALUE,
					C.OTHER_MONEY_VALUE2,
					C.CHEQUE_VALUE AS OTHER_ACT_VALUE,
					C.CURRENCY_ID AS OTHER_MONEY,
					P.CONSUMER_ID AS MEMBER_ID,
					(CONS.CONSUMER_NAME+ ' ' + CONS.CONSUMER_SURNAME) AS MUSTERI,
					CONS.MEMBER_CODE AS MEMBER_CODE,
					CONS.OZEL_KOD AS M_OZEL_KOD,
					1 AS MEMBER_TYPE,
					0 AS TYPE,
                    PR.PROJECT_HEAD,
					(SELECT TOP 1 CH.ACT_DATE FROM CHEQUE_HISTORY CH WHERE CH.CHEQUE_ID=C.CHEQUE_ID <cfif len(attributes.status)>AND CH.STATUS IN(#attributes.status#)</cfif> ORDER BY CH.RECORD_DATE DESC) TAHSILAT_TARIHI
				<cfelseif attributes.report_type eq 2>
					SUM(C.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),C.CHEQUE_DUEDATE)*C.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					<cfif isdefined("attributes.is_other_money")>
						SUM(C.CHEQUE_VALUE) AS TOTAL_AMOUNT_OTHER,
						C.CURRENCY_ID AS OTHER_MONEY,
					</cfif>			
					<cfif isdefined("attributes.is_money2")>
						SUM(C.OTHER_MONEY_VALUE2) AS TOTAL_AMOUNT2,
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						0 AS TOTAL_GECIKME,
					</cfif>			
					<cfif isdefined("attributes.bloke_member") and attributes.bloke_member eq 1>
						CR.FILE_NUMBER,
						CR.LAW_ADWOCATE,
					</cfif>
					P.CONSUMER_ID AS MEMBER_ID,
					(CONS.CONSUMER_NAME+ ' ' + CONS.CONSUMER_SURNAME) AS MUSTERI,
					CONS.MEMBER_CODE AS MEMBER_CODE,
					CONS.OZEL_KOD AS M_OZEL_KOD,
					('0'+CONS.MOBIL_CODE+ '' + CONS.MOBILTEL) AS  MOBIL_TEL,
					1 AS MEMBER_TYPE
				<cfelseif attributes.report_type eq 3>
					SUM(C.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),C.CHEQUE_DUEDATE)*C.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					<cfif isdefined("attributes.is_other_money")>
						SUM(C.CHEQUE_VALUE) AS TOTAL_AMOUNT_OTHER,
						C.CURRENCY_ID AS OTHER_MONEY,
					</cfif>			
					<cfif isdefined("attributes.is_money2")>
						SUM(C.OTHER_MONEY_VALUE2) AS TOTAL_AMOUNT2,
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						0 AS TOTAL_GECIKME,
					</cfif>
					CR.LAW_ADWOCATE
				<cfelseif attributes.report_type eq 4>
					SUM(C.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),C.CHEQUE_DUEDATE)*C.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					<cfif isdefined("attributes.is_other_money")>
						SUM(C.CHEQUE_VALUE) AS TOTAL_AMOUNT_OTHER,
						C.CURRENCY_ID AS OTHER_MONEY,
					</cfif>			
					<cfif isdefined("attributes.is_money2")>
						SUM(C.OTHER_MONEY_VALUE2) AS TOTAL_AMOUNT2,
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						0 AS TOTAL_GECIKME,
						0 AS TOTAL_GECIKME_VADE,
					</cfif>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						)
					<cfelse>
						C.CASH_ID
					</cfif> AS CASH_ID,
					CASH.CASH_NAME AS CASH_NAME,
					0 AS TOTAL_AMOUNT_ICRA,
					0 AS AVG_DUEDATE_ICRA,
					0 AS TOTAL_AMOUNT_VADE,
					0 AS AVG_DUEDATE_VADE
				<cfelseif attributes.report_type eq 5>
					SUM(C.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),C.CHEQUE_DUEDATE)*C.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					C.CHEQUE_DUEDATE AS DUE_DATE,
					MONTH(C.CHEQUE_DUEDATE) AS MONTH_DUE,
					YEAR(C.CHEQUE_DUEDATE) AS YEAR_DUE,
					C.CHEQUE_STATUS_ID AS STATUS
					<cfif isdefined("attributes.is_other_money")>
						,SUM(C.CHEQUE_VALUE) AS TOTAL_AMOUNT_OTHER
						,C.CURRENCY_ID AS OTHER_MONEY
					</cfif>
				</cfif>
			FROM
				CHEQUE C,
				PAYROLL P
                <cfif attributes.report_type eq 1>
                	LEFT JOIN #dsn_alias#.PRO_PROJECTS PR ON P.PROJECT_ID = PR.PROJECT_ID
                </cfif>,
				#dsn_alias#.CONSUMER CONS
				<cfif (isdefined("attributes.bloke_member") and attributes.bloke_member eq 1) or attributes.report_type eq 3>
					,#dsn_alias#.COMPANY_LAW_REQUEST CR
				</cfif>
				<cfif attributes.report_type eq 4>
					,CASH
				</cfif>
			WHERE
				C.CHEQUE_PAYROLL_ID = P.ACTION_ID
				AND P.CONSUMER_ID = CONS.CONSUMER_ID
                <cfif isdefined("attributes.self_cheque1") and len(attributes.self_cheque1)>
                	AND C.SELF_CHEQUE = 1
                <cfelseif isdefined("attributes.self_cheque2") and len(attributes.self_cheque2)>
                	AND C.SELF_CHEQUE = 0
                </cfif>
				<cfif isdefined("attributes.cash_id") and len(attributes.cash_id)>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						AND ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID) = #attributes.cash_id#
					<cfelseif isdefined("attributes.is_status_info")>
						AND ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						) = #attributes.cash_id#
					<cfelse>
						AND C.CASH_ID = #attributes.cash_id#
					</cfif>
				</cfif>
				<cfif isdefined("attributes.account_id") and len(attributes.account_id)>
					AND (SELECT TOP 1 P.PAYROLL_ACCOUNT_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(2,3) ORDER BY CHH.HISTORY_ID DESC) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account_id#" list="yes">)
				</cfif>
				<cfif isdefined("attributes.new_account_id") and len(attributes.new_account_id)>
					AND (SELECT TOP 1 P.PAYROLL_ACCOUNT_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(2,3) ORDER BY CHH.HISTORY_ID DESC) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.new_account_id#" list="yes">)
				</cfif>
				<cfif (isdefined("attributes.bloke_member") and attributes.bloke_member eq 1) or attributes.report_type eq 3>
					AND CONS.CONSUMER_ID = CR.CONSUMER_ID
					AND CR.REQUEST_STATUS = 1
					<cfif len(attributes.lawyer_name) and len(attributes.lawyer_id)>
						AND CR.LAW_ADWOCATE = #attributes.lawyer_id#
					</cfif>
				<cfelseif isdefined("attributes.bloke_member") and attributes.bloke_member eq 2>
					AND CONS.CONSUMER_ID NOT IN(SELECT CONSUMER_ID FROM #dsn_alias#.COMPANY_LAW_REQUEST WHERE CONSUMER_ID IS NOT NULL)
				</cfif>
				<cfif isdefined("bireysel") and listlen(bireysel)>
					AND CONS.CONSUMER_ID IN
						(
						SELECT 
							C.CONSUMER_ID 
						FROM 
							#dsn_alias#.CONSUMER C,
							#dsn_alias#.CONSUMER_CAT CAT 
						WHERE 
							C.CONSUMER_CAT_ID = CAT.CONSCAT_ID AND
							(
								<cfloop list="#bireysel#" delimiters="," index="cat_i">
									(CAT.CONSCAT_ID = #listlast(cat_i,'-')#)
									<cfif cat_i neq listlast(bireysel,',') and listlen(bireysel,',') gte 1> OR</cfif>
								</cfloop>  
							)
						)
				</cfif>
				<cfif isDefined("attributes.sales_zones") and len(attributes.sales_zones)>
					AND CONS.SALES_COUNTY = #attributes.sales_zones#
				</cfif>
				<cfif isdefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_code_text)>
					AND CONS.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE= #attributes.pos_code# AND IS_MASTER=1 AND OUR_COMPANY_ID = #session.ep.company_id# AND CONSUMER_ID IS NOT NULL)
				</cfif>
				<cfif isDefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.employee)>
					AND P.REVENUE_COLLECTOR_ID = #attributes.employee_id#
				</cfif>
				<cfif isdate(attributes.start_date)>
					AND C.CHEQUE_DUEDATE >=#attributes.start_date#
				</cfif>
				<cfif isdate(attributes.finish_date)>
					AND C.CHEQUE_DUEDATE <=#attributes.finish_date#
				</cfif>
                <cfif isdefined("attributes.is_interest_show")>
                	AND DATEDIFF(day,C.CHEQUE_DUEDATE,GETDATE()) > 0
                </cfif>
				<cfif len(attributes.record_date1) and isdate(attributes.record_date1)>
					AND C.RECORD_DATE >=#attributes.record_date1#
				</cfif>
				<cfif len(attributes.record_date2) and isdate(attributes.record_date2)>
					AND C.RECORD_DATE < #DATEADD('d',1,attributes.record_date2)#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.company_id)>
					AND C.COMPANY_ID = #attributes.company_id#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.consumer_id)>
					AND C.CONSUMER_ID = #attributes.consumer_id#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.employee_id_)>
					AND C.EMPLOYEE_ID = #attributes.employee_id_#
				</cfif>
				<cfif len(trim(attributes.company2)) and len(attributes.company_id2)>
					AND (SELECT TOP 1 P.COMPANY_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS = 4 ORDER BY CHH.HISTORY_ID DESC) = #attributes.company_id2#
				</cfif>
				<cfif len(attributes.status)>
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							AND ISNULL((SELECT CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID IN(SELECT ACTION_ID FROM PAYROLL WHERE PAYROLL_TYPE=106)),C.CHEQUE_STATUS_ID) IN (#attributes.status#)
						<cfelseif len(attributes.action_date2)>
							AND ISNULL((SELECT TOP 1 CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID) IN (#attributes.status#)
						<cfelse>	
							AND C.CHEQUE_STATUS_ID IN (#attributes.status#)
						</cfif>
					<cfelse>	
						AND C.CHEQUE_STATUS_ID IN (#attributes.status#)
					</cfif>
				</cfif>
				<cfif attributes.report_type eq 4>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						AND CASH.CASH_ID = ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						AND CASH.CASH_ID = ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						)
					<cfelse>
						AND CASH.CASH_ID = C.CASH_ID
					</cfif>
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							AND ISNULL((SELECT CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID IN(SELECT ACTION_ID FROM PAYROLL WHERE PAYROLL_TYPE=106)),C.CHEQUE_STATUS_ID) = 1
						<cfelseif len(attributes.action_date2)>
							AND ISNULL((SELECT TOP 1 CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID) = 1
						<cfelse>	
							AND C.CHEQUE_STATUS_ID = 1
						</cfif>					
					<cfelse>	
						AND C.CHEQUE_STATUS_ID = 1
					</cfif>
				</cfif>
				<cfif len(attributes.action_date1) and isdate(attributes.action_date1)>
					AND C.CHEQUE_ID IN(SELECT CH.CHEQUE_ID FROM CHEQUE_HISTORY CH WHERE <cfif len(attributes.status)>CH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(CH.ACT_DATE,DATEADD(day,-1,CH.RECORD_DATE)) >=#attributes.action_date1#) AND C.CHEQUE_ID = CH.CHEQUE_ID)
				</cfif>
				<cfif len(attributes.action_date2) and isdate(attributes.action_date2)>
					AND C.CHEQUE_ID IN(SELECT CH.CHEQUE_ID FROM CHEQUE_HISTORY CH WHERE <cfif len(attributes.status)>CH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(CH.ACT_DATE,DATEADD(day,-1,CH.RECORD_DATE)) <= #attributes.action_date2#) AND C.CHEQUE_ID = CH.CHEQUE_ID)
				</cfif>
				<cfif isdefined("attributes.is_open_acts")>
					AND P.PAYROLL_NO='-1'
				</cfif>
				<cfif len(attributes.owner_company) and len(attributes.owner_company_id) and attributes.owner_member_type eq 'partner'>
					AND C.OWNER_COMPANY_ID = #attributes.owner_company_id#
				<cfelseif len(attributes.owner_company) and len(attributes.owner_consumer_id) and attributes.owner_member_type eq 'consumer'>
					AND C.OWNER_CONSUMER_ID = #attributes.owner_consumer_id#
				<cfelseif len(attributes.owner_company) and len(attributes.owner_employee_id) and attributes.owner_member_type eq 'employee'>
					AND C.OWNER_EMPLOYEE_ID = #attributes.owner_employee_id#
				</cfif>
			<cfif attributes.report_type neq 1>	
				GROUP BY
			</cfif>
			<cfif attributes.report_type eq 2>
				P.CONSUMER_ID,
				CONS.CONSUMER_NAME,
				CONS.CONSUMER_SURNAME,
				CONS.MEMBER_CODE,
				C.CHEQUE_ID,
				CONS.OZEL_KOD,
				CONS.MOBIL_CODE,
				CONS.MOBILTEL
				<cfif isdefined("attributes.is_other_money")>
				,C.CURRENCY_ID
				</cfif>
				<cfif isdefined("attributes.bloke_member") and attributes.bloke_member eq 1>
				,CR.FILE_NUMBER
				,CR.LAW_ADWOCATE
				</cfif>
			<cfelseif attributes.report_type eq 3>
				CR.LAW_ADWOCATE,
				C.CHEQUE_ID
				<cfif isdefined("attributes.is_other_money")>
				,C.CURRENCY_ID
				</cfif>
			<cfelseif attributes.report_type eq 4>
				<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
					ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID),
				<cfelseif isdefined("attributes.is_status_info")>
					ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						),
				<cfelse>
					C.CASH_ID,
				</cfif>
				C.CHEQUE_ID,
				CASH.CASH_NAME
				<cfif isdefined("attributes.is_other_money")>
				,C.CURRENCY_ID
				</cfif>
			<cfelseif attributes.report_type eq 5>
				C.CHEQUE_ID,
				C.CHEQUE_DUEDATE,
				MONTH(C.CHEQUE_DUEDATE),
				YEAR(C.CHEQUE_DUEDATE),
				C.CHEQUE_STATUS_ID
				<cfif isdefined("attributes.is_other_money")>
				,C.CURRENCY_ID
				</cfif>
			</cfif>
		</cfquery>
		<cfquery name="get_cheque_voucher_4" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
				<!--- çek de consumer dolu olanlar --->
				SELECT
				<cfif attributes.report_type eq 4>
			       (SELECT TOP 1 P.PAYROLL_TYPE FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY_TYPE,
				   (SELECT TOP 1 P.PAYROLL_NO FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY_NO,
				   (SELECT TOP 1 CHH.PAYROLL_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY,
			    </cfif>
					(SELECT TOP 1 P.COMPANY_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS = 4 ORDER BY CHH.HISTORY_ID DESC) AS NEW_COMPANY_ID,
					(SELECT TOP 1 P.PAYROLL_ACCOUNT_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(2,3) ORDER BY CHH.HISTORY_ID DESC) AS NEW_ACCOUNT_ID,
					<cfif attributes.report_type eq 1>
						C.ACCOUNT_NO,
						C.CHEQUE_ID AS ISLEM_ID,
						C.CHEQUE_CODE AS OZEL_KOD,
						C.CHEQUE_DUEDATE AS DUE_DATE,
						C.CHEQUE_NO AS PAPER_NO,
						C.BANK_NAME,
						C.BANK_BRANCH_NAME,
						(SELECT TOP 1 P.PAYROLL_TYPE FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY_TYPE,
						(SELECT TOP 1 P.PAYROLL_NO FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY_NO,
						(SELECT TOP 1 CHH.PAYROLL_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY,
						<cfif isdefined("attributes.is_status_info")>
							<cfif isdefined("attributes.is_open_acts")>
								ISNULL((SELECT CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID IN(SELECT ACTION_ID FROM PAYROLL WHERE PAYROLL_TYPE=106)),C.CHEQUE_STATUS_ID) AS STATUS,
							<cfelseif len(attributes.action_date2)>
								ISNULL((SELECT TOP 1 CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID) AS STATUS,
							<cfelse>	
								C.CHEQUE_STATUS_ID AS STATUS,
							</cfif>						
						<cfelse>	
							C.CHEQUE_STATUS_ID AS STATUS,
						</cfif>
						C.DEBTOR_NAME AS DEBTOR_NAME,
						<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
							ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID)
						<cfelseif isdefined("attributes.is_status_info")>
							ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						)
						<cfelse>
							C.CASH_ID
						</cfif> AS CASH_ID,
						P.PAYROLL_ACCOUNT_ID AS ACCOUNT_ID,
						0 AS ORDER_ID,
						0 AS GECIKME_TUTAR,
						0 AS PAYMETHOD_ID,
						C.OTHER_MONEY_VALUE,
						C.OTHER_MONEY_VALUE2,
						C.CHEQUE_VALUE AS OTHER_ACT_VALUE,
						C.CURRENCY_ID AS OTHER_MONEY,
						P.CONSUMER_ID AS MEMBER_ID,
						(CONS.CONSUMER_NAME+ ' ' + CONS.CONSUMER_SURNAME) AS MUSTERI,
						CONS.MEMBER_CODE AS MEMBER_CODE,
						CONS.OZEL_KOD AS M_OZEL_KOD,
						1 AS MEMBER_TYPE,
						0 AS TYPE,
                        PR.PROJECT_HEAD,
						(SELECT TOP 1 CH.ACT_DATE FROM CHEQUE_HISTORY CH WHERE CH.CHEQUE_ID=C.CHEQUE_ID <cfif len(attributes.status)>AND CH.STATUS IN(#attributes.status#)</cfif> ORDER BY CH.RECORD_DATE DESC) TAHSILAT_TARIHI
					<cfelseif attributes.report_type eq 2>
						SUM(C.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
						SUM((DATEDIFF(day,GETDATE(),C.CHEQUE_DUEDATE)*C.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
						<cfif isdefined("attributes.is_other_money")>
							SUM(C.CHEQUE_VALUE) AS TOTAL_AMOUNT_OTHER,
							C.CURRENCY_ID AS OTHER_MONEY,
						</cfif>			
						<cfif isdefined("attributes.is_money2")>
							SUM(C.OTHER_MONEY_VALUE2) AS TOTAL_AMOUNT2,
						</cfif>
						<cfif isdefined("attributes.is_interest")>
							0 AS TOTAL_GECIKME,
						</cfif>			
						<cfif isdefined("attributes.bloke_member") and attributes.bloke_member eq 1>
							CR.FILE_NUMBER,
							CR.LAW_ADWOCATE,
						</cfif>
						C.CONSUMER_ID AS MEMBER_ID,
						(CONS.CONSUMER_NAME+ ' ' + CONS.CONSUMER_SURNAME) AS MUSTERI,
						CONS.MEMBER_CODE AS MEMBER_CODE,
						CONS.OZEL_KOD AS M_OZEL_KOD,
						('0'+CONS.MOBIL_CODE+ '' + CONS.MOBILTEL) AS  MOBIL_TEL,
						1 AS MEMBER_TYPE
					<cfelseif attributes.report_type eq 3>
						SUM(C.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
						SUM((DATEDIFF(day,GETDATE(),C.CHEQUE_DUEDATE)*C.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
						<cfif isdefined("attributes.is_other_money")>
							SUM(C.CHEQUE_VALUE) AS TOTAL_AMOUNT_OTHER,
							C.CURRENCY_ID AS OTHER_MONEY,
						</cfif>			
						<cfif isdefined("attributes.is_money2")>
							SUM(C.OTHER_MONEY_VALUE2) AS TOTAL_AMOUNT2,
						</cfif>
						<cfif isdefined("attributes.is_interest")>
							0 AS TOTAL_GECIKME,
						</cfif>
						CR.LAW_ADWOCATE
					<cfelseif attributes.report_type eq 4>
						SUM(C.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
						SUM((DATEDIFF(day,GETDATE(),C.CHEQUE_DUEDATE)*C.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
						<cfif isdefined("attributes.is_other_money")>
							SUM(C.CHEQUE_VALUE) AS TOTAL_AMOUNT_OTHER,
							C.CURRENCY_ID AS OTHER_MONEY,
						</cfif>			
						<cfif isdefined("attributes.is_money2")>
							SUM(C.OTHER_MONEY_VALUE2) AS TOTAL_AMOUNT2,
						</cfif>
						<cfif isdefined("attributes.is_interest")>
							0 AS TOTAL_GECIKME,
							0 AS TOTAL_GECIKME_VADE,
						</cfif>
						<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
							ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID)
						<cfelseif isdefined("attributes.is_status_info")>
							ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						)
						<cfelse>
							C.CASH_ID
						</cfif> AS CASH_ID,
						CASH.CASH_NAME AS CASH_NAME,
						0 AS TOTAL_AMOUNT_ICRA,
						0 AS AVG_DUEDATE_ICRA,
						0 AS TOTAL_AMOUNT_VADE,
						0 AS AVG_DUEDATE_VADE
					<cfelseif attributes.report_type eq 5>
						SUM(C.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
						SUM((DATEDIFF(day,GETDATE(),C.CHEQUE_DUEDATE)*C.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
						C.CHEQUE_DUEDATE AS DUE_DATE,
						MONTH(C.CHEQUE_DUEDATE) AS MONTH_DUE,
						YEAR(C.CHEQUE_DUEDATE) AS YEAR_DUE,
						C.CHEQUE_STATUS_ID AS STATUS
						<cfif isdefined("attributes.is_other_money")>
							,SUM(C.CHEQUE_VALUE) AS TOTAL_AMOUNT_OTHER
							,C.CURRENCY_ID AS OTHER_MONEY
						</cfif>
					</cfif>
				FROM
					CHEQUE C,
					PAYROLL P
					<cfif attributes.report_type eq 1>
                        LEFT JOIN #dsn_alias#.PRO_PROJECTS PR ON P.PROJECT_ID = PR.PROJECT_ID
                    </cfif>,
					#dsn_alias#.CONSUMER CONS
					<cfif (isdefined("attributes.bloke_member") and attributes.bloke_member eq 1) or attributes.report_type eq 3>
						,#dsn_alias#.COMPANY_LAW_REQUEST CR
					</cfif>
					<cfif attributes.report_type eq 4>
						,CASH
					</cfif>
				WHERE
					C.CHEQUE_PAYROLL_ID = P.ACTION_ID
					AND P.PAYROLL_TYPE IN (106, 135)<!---135 transfer----->
					AND P.CONSUMER_ID IS NULL
					AND P.COMPANY_ID IS NULL
					AND C.CONSUMER_ID = CONS.CONSUMER_ID
					<cfif isdefined("attributes.self_cheque1") and len(attributes.self_cheque1)>
                        AND C.SELF_CHEQUE = 1
                    <cfelseif isdefined("attributes.self_cheque2") and len(attributes.self_cheque2)>
                        AND C.SELF_CHEQUE = 0
                    </cfif>
					<cfif isdefined("attributes.cash_id") and len(attributes.cash_id)>
						<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
							AND ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID) = #attributes.cash_id#
						<cfelseif isdefined("attributes.is_status_info")>
							AND ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						) = #attributes.cash_id#
						<cfelse>
							AND C.CASH_ID = #attributes.cash_id#
						</cfif>
					</cfif>
					<cfif isdefined("attributes.account_id") and len(attributes.account_id)>
						AND (SELECT TOP 1 P.PAYROLL_ACCOUNT_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(2,3) ORDER BY CHH.HISTORY_ID DESC) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account_id#" list="yes">)				
					</cfif>
					<cfif isdefined("attributes.new_account_id") and len(attributes.new_account_id)>
						AND (SELECT TOP 1 P.PAYROLL_ACCOUNT_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(2,3) ORDER BY CHH.HISTORY_ID DESC) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.new_account_id#" list="yes">)
					</cfif>
					<cfif (isdefined("attributes.bloke_member") and attributes.bloke_member eq 1) or attributes.report_type eq 3>
						AND CONS.CONSUMER_ID = CR.CONSUMER_ID
						AND CR.REQUEST_STATUS = 1
						<cfif len(attributes.lawyer_name) and len(attributes.lawyer_id)>
							AND CR.LAW_ADWOCATE = #attributes.lawyer_id#
						</cfif>
					<cfelseif isdefined("attributes.bloke_member") and attributes.bloke_member eq 2>
						AND CONS.CONSUMER_ID NOT IN(SELECT CONSUMER_ID FROM #dsn_alias#.COMPANY_LAW_REQUEST WHERE CONSUMER_ID IS NOT NULL)
					</cfif>
					<cfif isdefined("bireysel") and listlen(bireysel)>
						AND CONS.CONSUMER_ID IN
							(
							SELECT 
								C.CONSUMER_ID 
							FROM 
								#dsn_alias#.CONSUMER C,
								#dsn_alias#.CONSUMER_CAT CAT 
							WHERE 
								C.CONSUMER_CAT_ID = CAT.CONSCAT_ID AND
								(
									<cfloop list="#bireysel#" delimiters="," index="cat_i">
										(CAT.CONSCAT_ID = #listlast(cat_i,'-')#)
										<cfif cat_i neq listlast(bireysel,',') and listlen(bireysel,',') gte 1> OR</cfif>
									</cfloop>  
								)
							)
					</cfif>
					<cfif isDefined("attributes.sales_zones") and len(attributes.sales_zones)>
						AND CONS.SALES_COUNTY = #attributes.sales_zones#
					</cfif>
					<cfif isdefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_code_text)>
						AND CONS.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE= #attributes.pos_code# AND IS_MASTER=1 AND OUR_COMPANY_ID = #session.ep.company_id# AND CONSUMER_ID IS NOT NULL)
					</cfif>
					<cfif isDefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.employee)>
						AND P.REVENUE_COLLECTOR_ID = #attributes.employee_id#
					</cfif>
					<cfif isdate(attributes.start_date)>
						AND C.CHEQUE_DUEDATE >=#attributes.start_date#
					</cfif>
					<cfif isdate(attributes.finish_date)>
						AND C.CHEQUE_DUEDATE <=#attributes.finish_date#
					</cfif>
					<cfif isdefined("attributes.is_interest_show")>
                        AND DATEDIFF(day,C.CHEQUE_DUEDATE,GETDATE()) > 0
                    </cfif>
					<cfif len(attributes.record_date1) and isdate(attributes.record_date1)>
						AND C.RECORD_DATE >=#attributes.record_date1#
					</cfif>
					<cfif len(attributes.record_date2) and isdate(attributes.record_date2)>
						AND C.RECORD_DATE < #DATEADD('d',1,attributes.record_date2)#
					</cfif>
					<cfif len(trim(attributes.company)) and len(attributes.company_id)>
						AND C.COMPANY_ID = #attributes.company_id#
					</cfif>
					<cfif len(trim(attributes.company)) and len(attributes.consumer_id)>
						AND C.CONSUMER_ID = #attributes.consumer_id#
					</cfif>
					<cfif len(trim(attributes.company)) and len(attributes.employee_id_)>
						AND C.EMPLOYEE_ID = #attributes.employee_id_#
					</cfif>
					<cfif len(trim(attributes.company2)) and len(attributes.company_id2)>
						AND (SELECT TOP 1 P.COMPANY_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS = 4 ORDER BY CHH.HISTORY_ID DESC) = #attributes.company_id2#
					</cfif>
					<cfif len(attributes.status)>
						<cfif isdefined("attributes.is_status_info")>
							<cfif isdefined("attributes.is_open_acts")>
								AND ISNULL((SELECT CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID IN(SELECT ACTION_ID FROM PAYROLL WHERE PAYROLL_TYPE=106)),C.CHEQUE_STATUS_ID) IN (#attributes.status#)
							<cfelseif len(attributes.action_date2)>
								AND ISNULL((SELECT TOP 1 CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID) IN (#attributes.status#)
							<cfelse>	
								AND C.CHEQUE_STATUS_ID IN (#attributes.status#)
							</cfif>
						<cfelse>	
							AND C.CHEQUE_STATUS_ID IN (#attributes.status#)
						</cfif>
					</cfif>
					<cfif attributes.report_type eq 4>
						<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
							AND CASH.CASH_ID = ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID)
						<cfelseif isdefined("attributes.is_status_info")>
							AND CASH.CASH_ID = ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						)
						<cfelse>
							AND CASH.CASH_ID = C.CASH_ID
						</cfif>
						<cfif isdefined("attributes.is_status_info")>
							<cfif isdefined("attributes.is_open_acts")>
								AND ISNULL((SELECT CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID IN(SELECT ACTION_ID FROM PAYROLL WHERE PAYROLL_TYPE=106)),C.CHEQUE_STATUS_ID) = 1
							<cfelseif len(attributes.action_date2)>
								AND ISNULL((SELECT TOP 1 CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID) = 1
							<cfelse>	
								AND C.CHEQUE_STATUS_ID = 1
							</cfif>						
						<cfelse>	
							AND C.CHEQUE_STATUS_ID = 1
						</cfif>
					</cfif>
					<cfif len(attributes.action_date1) and isdate(attributes.action_date1)>
						AND C.CHEQUE_ID IN(SELECT CH.CHEQUE_ID FROM CHEQUE_HISTORY CH WHERE <cfif len(attributes.status)>CH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(CH.ACT_DATE,DATEADD(day,-1,CH.RECORD_DATE)) >=#attributes.action_date1#) AND C.CHEQUE_ID = CH.CHEQUE_ID)
					</cfif>
					<cfif len(attributes.action_date2) and isdate(attributes.action_date2)>
						AND C.CHEQUE_ID IN(SELECT CH.CHEQUE_ID FROM CHEQUE_HISTORY CH WHERE <cfif len(attributes.status)>CH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(CH.ACT_DATE,DATEADD(day,-1,CH.RECORD_DATE)) <= #attributes.action_date2#) AND C.CHEQUE_ID = CH.CHEQUE_ID)
					</cfif>
					<cfif isdefined("attributes.is_open_acts")>
						AND P.PAYROLL_NO='-1'
					</cfif>
					<cfif len(attributes.owner_company) and len(attributes.owner_company_id) and attributes.owner_member_type eq 'partner'>
						AND C.OWNER_COMPANY_ID = #attributes.owner_company_id#
					<cfelseif len(attributes.owner_company) and len(attributes.owner_consumer_id) and attributes.owner_member_type eq 'consumer'>
						AND C.OWNER_CONSUMER_ID = #attributes.owner_consumer_id#
					<cfelseif len(attributes.owner_company) and len(attributes.owner_employee_id) and attributes.owner_member_type eq 'employee'>
						AND C.OWNER_EMPLOYEE_ID = #attributes.owner_employee_id#
					</cfif>
				<cfif attributes.report_type neq 1>	
					GROUP BY
				</cfif>
				<cfif attributes.report_type eq 2>
					C.CONSUMER_ID,
					CONS.CONSUMER_NAME,
					CONS.CONSUMER_SURNAME,
					CONS.MEMBER_CODE,
					C.CHEQUE_ID,
					CONS.OZEL_KOD,
					CONS.MOBIL_CODE,
					CONS.MOBILTEL
					<cfif isdefined("attributes.is_other_money")>
					,C.CURRENCY_ID
					</cfif>
					<cfif isdefined("attributes.bloke_member") and attributes.bloke_member eq 1>
					,CR.FILE_NUMBER
					,CR.LAW_ADWOCATE
					</cfif>
				<cfelseif attributes.report_type eq 3>
					CR.LAW_ADWOCATE,
					C.CHEQUE_ID
					<cfif isdefined("attributes.is_other_money")>
					,C.CURRENCY_ID
					</cfif>
				<cfelseif attributes.report_type eq 4>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID),
					<cfelseif isdefined("attributes.is_status_info")>
						ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						),
					<cfelse>
						C.CASH_ID,
					</cfif>
					C.CHEQUE_ID,
					CASH.CASH_NAME
					<cfif isdefined("attributes.is_other_money")>
					,C.CURRENCY_ID
					</cfif>
				<cfelseif attributes.report_type eq 5>
					C.CHEQUE_ID,
					C.CHEQUE_DUEDATE,
					MONTH(C.CHEQUE_DUEDATE),
					YEAR(C.CHEQUE_DUEDATE),
					C.CHEQUE_STATUS_ID
					<cfif isdefined("attributes.is_other_money")>
					,C.CURRENCY_ID
					</cfif>
				</cfif>
			</cfquery>	
	</cfif>
	<cfif not len(bireysel) or not len(kurumsal)>
		<cfquery name="get_cheque_voucher_13" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
			<!--- employee dolu olan --->
			SELECT
			<cfif attributes.report_type eq 4>
			    (SELECT TOP 1 P.PAYROLL_TYPE FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY_TYPE,
				(SELECT TOP 1 P.PAYROLL_NO FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY_NO,
				(SELECT TOP 1 CHH.PAYROLL_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY,
			</cfif>
				(SELECT TOP 1 P.COMPANY_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS = 4 ORDER BY CHH.HISTORY_ID DESC) AS NEW_COMPANY_ID,
				ISNULL((SELECT TOP 1 P.PAYROLL_ACCOUNT_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(2,3) ORDER BY CHH.HISTORY_ID DESC),C.ACCOUNT_ID) AS NEW_ACCOUNT_ID,
				<cfif attributes.report_type eq 1>
					C.ACCOUNT_NO,
					C.CHEQUE_ID AS ISLEM_ID,
					C.CHEQUE_CODE AS OZEL_KOD,
					C.CHEQUE_DUEDATE AS DUE_DATE,
					C.CHEQUE_NO AS PAPER_NO,
					C.BANK_NAME,
					C.BANK_BRANCH_NAME,
					(SELECT TOP 1 P.PAYROLL_TYPE FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY_TYPE,
					(SELECT TOP 1 P.PAYROLL_NO FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY_NO,
					(SELECT TOP 1 CHH.PAYROLL_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY,
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							ISNULL((SELECT CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID IN(SELECT ACTION_ID FROM PAYROLL WHERE PAYROLL_TYPE=106)),C.CHEQUE_STATUS_ID) AS STATUS,
						<cfelseif len(attributes.action_date2)>
							ISNULL((SELECT TOP 1 CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID) AS STATUS,
						<cfelse>	
							C.CHEQUE_STATUS_ID AS STATUS,
						</cfif>
					<cfelse>	
						C.CHEQUE_STATUS_ID AS STATUS,
					</cfif>
					C.DEBTOR_NAME AS DEBTOR_NAME,
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						)
					<cfelse>
						C.CASH_ID
					</cfif> AS CASH_ID,
					ISNULL((SELECT TOP 1 P.PAYROLL_ACCOUNT_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(2,3) ORDER BY CHH.HISTORY_ID DESC),C.ACCOUNT_ID) AS ACCOUNT_ID,
					0 AS ORDER_ID,
					0 AS GECIKME_TUTAR,
					0 AS PAYMETHOD_ID,
					C.OTHER_MONEY_VALUE,
					C.OTHER_MONEY_VALUE2,
					C.CHEQUE_VALUE AS OTHER_ACT_VALUE,
					C.CURRENCY_ID AS OTHER_MONEY,
					P.EMPLOYEE_ID AS MEMBER_ID,
					EMP.EMPLOYEE_NAME+' '+EMP.EMPLOYEE_SURNAME AS MUSTERI,
					EMP.EMPLOYEE_NO AS MEMBER_CODE,
					'' M_OZEL_KOD,
					2 AS MEMBER_TYPE,
					0 AS TYPE,
                    PR.PROJECT_HEAD,
					(SELECT TOP 1 CH.ACT_DATE FROM CHEQUE_HISTORY CH WHERE CH.CHEQUE_ID=C.CHEQUE_ID <cfif len(attributes.status)>AND CH.STATUS IN(#attributes.status#)</cfif> ORDER BY CH.RECORD_DATE DESC) TAHSILAT_TARIHI
				<cfelseif attributes.report_type eq 2>
					SUM(C.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),C.CHEQUE_DUEDATE)*C.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					<cfif isdefined("attributes.is_other_money")>
						SUM(C.CHEQUE_VALUE) AS TOTAL_AMOUNT_OTHER,
						C.CURRENCY_ID AS OTHER_MONEY,
					</cfif>			
					<cfif isdefined("attributes.is_money2")>
						SUM(C.OTHER_MONEY_VALUE2) AS TOTAL_AMOUNT2,
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						0 AS TOTAL_GECIKME,
					</cfif>			
					<cfif isdefined("attributes.bloke_member") and attributes.bloke_member eq 1>
						'' FILE_NUMBER,
						0 LAW_ADWOCATE,
					</cfif>	
					P.EMPLOYEE_ID AS MEMBER_ID,
					EMP.EMPLOYEE_NAME+' '+EMP.EMPLOYEE_SURNAME AS MUSTERI,
					EMP.EMPLOYEE_NO AS MEMBER_CODE,
					'' AS M_OZEL_KOD,
					'' MOBIL_TEL,
					2 AS MEMBER_TYPE
				<cfelseif attributes.report_type eq 3>
					SUM(C.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),C.CHEQUE_DUEDATE)*C.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					<cfif isdefined("attributes.is_other_money")>
						SUM(C.CHEQUE_VALUE) AS TOTAL_AMOUNT_OTHER,
						C.CURRENCY_ID AS OTHER_MONEY,
					</cfif>			
					<cfif isdefined("attributes.is_money2")>
						SUM(C.OTHER_MONEY_VALUE2) AS TOTAL_AMOUNT2,
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						0 AS TOTAL_GECIKME,
					</cfif>
					0 AS LAW_ADWOCATE
				<cfelseif attributes.report_type eq 4>
					SUM(C.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),C.CHEQUE_DUEDATE)*C.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					<cfif isdefined("attributes.is_other_money")>
						SUM(C.CHEQUE_VALUE) AS TOTAL_AMOUNT_OTHER,
						C.CURRENCY_ID AS OTHER_MONEY,
					</cfif>			
					<cfif isdefined("attributes.is_money2")>
						SUM(C.OTHER_MONEY_VALUE2) AS TOTAL_AMOUNT2,
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						0 AS TOTAL_GECIKME,
						0 AS TOTAL_GECIKME_VADE,
					</cfif>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						)
					<cfelse>
						C.CASH_ID
					</cfif> AS CASH_ID,
					CASH.CASH_NAME AS CASH_NAME,
					0 AS TOTAL_AMOUNT_ICRA,
					0 AS AVG_DUEDATE_ICRA,
					0 AS TOTAL_AMOUNT_VADE,
					0 AS AVG_DUEDATE_VADE
				<cfelseif attributes.report_type eq 5>
					SUM(C.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),C.CHEQUE_DUEDATE)*C.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					C.CHEQUE_DUEDATE AS DUE_DATE,
					MONTH(C.CHEQUE_DUEDATE) AS MONTH_DUE,
					YEAR(C.CHEQUE_DUEDATE) AS YEAR_DUE,
					C.CHEQUE_STATUS_ID AS STATUS
					<cfif isdefined("attributes.is_other_money")>
						,SUM(C.CHEQUE_VALUE) AS TOTAL_AMOUNT_OTHER
						,C.CURRENCY_ID AS OTHER_MONEY
					</cfif>
				</cfif>
			FROM
				CHEQUE C,
				PAYROLL P
                <cfif attributes.report_type eq 1>
                	LEFT JOIN #dsn_alias#.PRO_PROJECTS PR ON P.PROJECT_ID = PR.PROJECT_ID
                </cfif>,
				#dsn_alias#.EMPLOYEES EMP
				<cfif attributes.report_type eq 4>
					,CASH
				</cfif>
			WHERE
				C.CHEQUE_PAYROLL_ID = P.ACTION_ID
				AND P.EMPLOYEE_ID = EMP.EMPLOYEE_ID
                <cfif isdefined("attributes.self_cheque1") and len(attributes.self_cheque1)>
                	AND C.SELF_CHEQUE = 1
                <cfelseif isdefined("attributes.self_cheque2") and len(attributes.self_cheque2)>
                	AND C.SELF_CHEQUE = 0
                </cfif>
				<cfif isdefined("attributes.cash_id") and len(attributes.cash_id)>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						AND ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID) = #attributes.cash_id#
					<cfelseif isdefined("attributes.is_status_info")>
						AND ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						) = #attributes.cash_id#
					<cfelse>
						AND C.CASH_ID = #attributes.cash_id#
					</cfif>
				</cfif>
				<cfif isdefined("attributes.account_id") and len(attributes.account_id)>
					AND (SELECT TOP 1 P.PAYROLL_ACCOUNT_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(2,3) ORDER BY CHH.HISTORY_ID DESC) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account_id#" list="yes">)				
				</cfif>
				<cfif isdefined("attributes.new_account_id") and len(attributes.new_account_id)>
					AND (SELECT TOP 1 P.PAYROLL_ACCOUNT_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(2,3) ORDER BY CHH.HISTORY_ID DESC) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.new_account_id#" list="yes">)
				</cfif>
				<cfif isdefined("kurumsal") and listlen(kurumsal)>
					AND 1 = 2
				</cfif>
				<cfif isdefined("bireysel") and listlen(bireysel)>
					AND 1 = 2
				</cfif>
				<cfif isDefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_code_text)>
					AND EMP.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE= #attributes.pos_code# AND IS_MASTER=1 AND OUR_COMPANY_ID = #session.ep.company_id# AND EMPLOYEE_ID IS NOT NULL)
				</cfif>
				<cfif isDefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.employee)>
					AND P.REVENUE_COLLECTOR_ID = #attributes.employee_id#
				</cfif>
				<cfif isdate(attributes.start_date)>
					AND C.CHEQUE_DUEDATE >=#attributes.start_date#
				</cfif>
				<cfif isdate(attributes.finish_date)>
					AND C.CHEQUE_DUEDATE <=#attributes.finish_date#
				</cfif>
                <cfif isdefined("attributes.is_interest_show")>
                	AND DATEDIFF(day,C.CHEQUE_DUEDATE,GETDATE()) > 0
                </cfif>
				<cfif len(attributes.record_date1) and isdate(attributes.record_date1)>
					AND C.RECORD_DATE >=#attributes.record_date1#
				</cfif>
				<cfif len(attributes.record_date2) and isdate(attributes.record_date2)>
					AND C.RECORD_DATE < #DATEADD('d',1,attributes.record_date2)#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.company_id)>
					AND C.COMPANY_ID = #attributes.company_id#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.consumer_id)>
					AND C.CONSUMER_ID = #attributes.consumer_id#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.employee_id_)>
					AND C.EMPLOYEE_ID = #attributes.employee_id_#
				</cfif>
				<cfif len(trim(attributes.company2)) and len(attributes.company_id2)>
					AND (SELECT TOP 1 P.COMPANY_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS = 4 ORDER BY CHH.HISTORY_ID DESC) = #attributes.company_id2#
				</cfif>
				<cfif len(attributes.status)>
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							AND ISNULL((SELECT CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID IN(SELECT ACTION_ID FROM PAYROLL WHERE PAYROLL_TYPE=106)),C.CHEQUE_STATUS_ID) IN (#attributes.status#)
						<cfelseif len(attributes.action_date2)>
							AND ISNULL((SELECT TOP 1 CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID) IN (#attributes.status#)
						<cfelse>	
							AND C.CHEQUE_STATUS_ID IN (#attributes.status#)
						</cfif>
					<cfelse>	
						AND C.CHEQUE_STATUS_ID IN (#attributes.status#)
					</cfif>
				</cfif>
				<cfif attributes.report_type eq 4>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						AND CASH.CASH_ID = ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						AND CASH.CASH_ID = ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						)
					<cfelse>
						AND CASH.CASH_ID = C.CASH_ID
					</cfif>
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							AND ISNULL((SELECT CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID IN(SELECT ACTION_ID FROM PAYROLL WHERE PAYROLL_TYPE=106)),C.CHEQUE_STATUS_ID) = 1
						<cfelseif len(attributes.action_date2)>
							AND ISNULL((SELECT TOP 1 CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID) = 1
						<cfelse>	
							AND C.CHEQUE_STATUS_ID = 1
						</cfif>
					<cfelse>	
						AND C.CHEQUE_STATUS_ID = 1
					</cfif>
				</cfif>
				<cfif len(attributes.action_date1) and isdate(attributes.action_date1)>
					AND C.CHEQUE_ID IN(SELECT CH.CHEQUE_ID FROM CHEQUE_HISTORY CH WHERE <cfif len(attributes.status)>CH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(CH.ACT_DATE,DATEADD(day,-1,CH.RECORD_DATE)) >=#attributes.action_date1#) AND C.CHEQUE_ID = CH.CHEQUE_ID)
				</cfif>
				<cfif len(attributes.action_date2) and isdate(attributes.action_date2)>
					AND C.CHEQUE_ID IN(SELECT CH.CHEQUE_ID FROM CHEQUE_HISTORY CH WHERE <cfif len(attributes.status)>CH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(CH.ACT_DATE,DATEADD(day,-1,CH.RECORD_DATE)) <= #attributes.action_date2#) AND C.CHEQUE_ID = CH.CHEQUE_ID)
				</cfif>
				<cfif isdefined("attributes.is_open_acts")>
					AND P.PAYROLL_NO='-1'
				</cfif>
				<cfif len(attributes.owner_company) and len(attributes.owner_company_id) and attributes.owner_member_type eq 'partner'>

					AND C.OWNER_COMPANY_ID = #attributes.owner_company_id#
				<cfelseif len(attributes.owner_company) and len(attributes.owner_consumer_id) and attributes.owner_member_type eq 'consumer'>
					AND C.OWNER_CONSUMER_ID = #attributes.owner_consumer_id#
				<cfelseif len(attributes.owner_company) and len(attributes.owner_employee_id) and attributes.owner_member_type eq 'employee'>
					AND C.OWNER_EMPLOYEE_ID = #attributes.owner_employee_id#
				</cfif>
			<cfif attributes.report_type neq 1>	
				GROUP BY
			</cfif>
			<cfif attributes.report_type eq 2>
				C.ACCOUNT_ID,
				P.EMPLOYEE_ID,
				EMP.EMPLOYEE_NAME,
				EMP.EMPLOYEE_SURNAME,
				EMP.EMPLOYEE_NO,
				C.CHEQUE_ID
				<cfif isdefined("attributes.is_other_money")>
					,C.CURRENCY_ID
				</cfif>
			<cfelseif attributes.report_type eq 3>
				C.CHEQUE_ID,
				C.ACCOUNT_ID
				<cfif isdefined("attributes.is_other_money")>
					,C.CURRENCY_ID
				</cfif>
			<cfelseif attributes.report_type eq 4>
				<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
					ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID)
				<cfelseif isdefined("attributes.is_status_info")>
					ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						)
				<cfelse>
					C.CASH_ID
				</cfif>,
				C.CHEQUE_ID,
				C.ACCOUNT_ID,
				CASH.CASH_NAME
				<cfif isdefined("attributes.is_other_money")>
					,C.CURRENCY_ID
				</cfif>
			<cfelseif attributes.report_type eq 5>
				C.CHEQUE_ID,
				C.ACCOUNT_ID,
				C.CHEQUE_DUEDATE,
				MONTH(C.CHEQUE_DUEDATE),
				YEAR(C.CHEQUE_DUEDATE),
				C.CHEQUE_STATUS_ID
				<cfif isdefined("attributes.is_other_money")>
					,C.CURRENCY_ID
				</cfif>
			</cfif>
		</cfquery>
		<cfquery name="get_cheque_voucher_14" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
			<!--- çek de employee olanlar --->
			SELECT
			<cfif attributes.report_type eq 4>
			    (SELECT TOP 1 P.PAYROLL_TYPE FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY_TYPE,
				(SELECT TOP 1 P.PAYROLL_NO FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY_NO,
				(SELECT TOP 1 CHH.PAYROLL_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY,
			</cfif>
				(SELECT TOP 1 P.COMPANY_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS = 4 ORDER BY CHH.HISTORY_ID DESC) AS NEW_COMPANY_ID,
				ISNULL((SELECT TOP 1 P.PAYROLL_ACCOUNT_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(2,3) ORDER BY CHH.HISTORY_ID DESC),C.ACCOUNT_ID) AS NEW_ACCOUNT_ID,
				<cfif attributes.report_type eq 1>
					C.ACCOUNT_NO,
					C.CHEQUE_ID AS ISLEM_ID,
					C.CHEQUE_CODE AS OZEL_KOD,
					C.CHEQUE_DUEDATE AS DUE_DATE,
					C.CHEQUE_NO AS PAPER_NO,
					C.BANK_NAME,
					C.BANK_BRANCH_NAME,
					(SELECT TOP 1 P.PAYROLL_TYPE FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY_TYPE,
					(SELECT TOP 1 P.PAYROLL_NO FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY_NO,
					(SELECT TOP 1 CHH.PAYROLL_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY,	
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							ISNULL((SELECT CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID IN(SELECT ACTION_ID FROM PAYROLL WHERE PAYROLL_TYPE=106)),C.CHEQUE_STATUS_ID) AS STATUS,
						<cfelseif len(attributes.action_date2)>
							ISNULL((SELECT TOP 1 CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID) AS STATUS,
						<cfelse>	
							C.CHEQUE_STATUS_ID AS STATUS,
						</cfif>
					<cfelse>	
						C.CHEQUE_STATUS_ID AS STATUS,
					</cfif>
					C.DEBTOR_NAME AS DEBTOR_NAME,
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						)
					<cfelse>
						C.CASH_ID
					</cfif> AS CASH_ID,
					ISNULL((SELECT TOP 1 P.PAYROLL_ACCOUNT_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(2,3) ORDER BY CHH.HISTORY_ID DESC),C.ACCOUNT_ID) AS ACCOUNT_ID,
					0 AS ORDER_ID,
					0 AS GECIKME_TUTAR,
					0 AS PAYMETHOD_ID,
					C.OTHER_MONEY_VALUE,
					C.OTHER_MONEY_VALUE2,
					C.CHEQUE_VALUE AS OTHER_ACT_VALUE,
					C.CURRENCY_ID AS OTHER_MONEY,
					C.EMPLOYEE_ID AS MEMBER_ID,
					EMP.EMPLOYEE_NAME+' '+EMP.EMPLOYEE_SURNAME AS MUSTERI,
					EMP.EMPLOYEE_NO AS MEMBER_CODE,
					'' AS M_OZEL_KOD,
					2 AS MEMBER_TYPE,
					0 AS TYPE,
                    PR.PROJECT_HEAD,
					(SELECT TOP 1 CH.ACT_DATE FROM CHEQUE_HISTORY CH WHERE CH.CHEQUE_ID=C.CHEQUE_ID <cfif len(attributes.status)>AND CH.STATUS IN(#attributes.status#)</cfif> ORDER BY CH.RECORD_DATE DESC) TAHSILAT_TARIHI
				<cfelseif attributes.report_type eq 2>
					SUM(C.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),C.CHEQUE_DUEDATE)*C.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					<cfif isdefined("attributes.is_other_money")>
						SUM(C.CHEQUE_VALUE) AS TOTAL_AMOUNT_OTHER,
						C.CURRENCY_ID AS OTHER_MONEY,
					</cfif>			
					<cfif isdefined("attributes.is_money2")>
						SUM(C.OTHER_MONEY_VALUE2) AS TOTAL_AMOUNT2,
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						0 AS TOTAL_GECIKME,
					</cfif>		
					<cfif isdefined("attributes.bloke_member") and attributes.bloke_member eq 1>
						'' FILE_NUMBER,
						0 LAW_ADWOCATE,
					</cfif>		
					C.EMPLOYEE_ID AS MEMBER_ID,
					EMP.EMPLOYEE_NAME+' '+EMP.EMPLOYEE_SURNAME AS MUSTERI,
					EMP.EMPLOYEE_NO AS MEMBER_CODE,
					'' AS M_OZEL_KOD,
					'' MOBIL_TEL,
					0 AS MEMBER_TYPE
				<cfelseif attributes.report_type eq 3>
					SUM(C.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),C.CHEQUE_DUEDATE)*C.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					<cfif isdefined("attributes.is_other_money")>
						SUM(C.CHEQUE_VALUE) AS TOTAL_AMOUNT_OTHER,
						C.CURRENCY_ID AS OTHER_MONEY,
					</cfif>			
					<cfif isdefined("attributes.is_money2")>
						SUM(C.OTHER_MONEY_VALUE2) AS TOTAL_AMOUNT2,
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						0 AS TOTAL_GECIKME,
					</cfif>
					0 AS LAW_ADWOCATE
				<cfelseif attributes.report_type eq 4>
					SUM(C.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),C.CHEQUE_DUEDATE)*C.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					<cfif isdefined("attributes.is_other_money")>
						SUM(C.CHEQUE_VALUE) AS TOTAL_AMOUNT_OTHER,
						C.CURRENCY_ID AS OTHER_MONEY,
					</cfif>			
					<cfif isdefined("attributes.is_money2")>
						SUM(C.OTHER_MONEY_VALUE2) AS TOTAL_AMOUNT2,
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						0 AS TOTAL_GECIKME,
						0 AS TOTAL_GECIKME_VADE,
					</cfif>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						)
					<cfelse>
						C.CASH_ID
					</cfif> AS CASH_ID,
					CASH.CASH_NAME AS CASH_NAME,
					0 AS TOTAL_AMOUNT_ICRA,
					0 AS AVG_DUEDATE_ICRA,
					0 AS TOTAL_AMOUNT_VADE,
					0 AS AVG_DUEDATE_VADE
				<cfelseif attributes.report_type eq 5>
					SUM(C.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),C.CHEQUE_DUEDATE)*C.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					C.CHEQUE_DUEDATE AS DUE_DATE,
					MONTH(C.CHEQUE_DUEDATE) AS MONTH_DUE,
					YEAR(C.CHEQUE_DUEDATE) AS YEAR_DUE,
					C.CHEQUE_STATUS_ID AS STATUS
					<cfif isdefined("attributes.is_other_money")>
						,SUM(C.CHEQUE_VALUE) AS TOTAL_AMOUNT_OTHER
						,C.CURRENCY_ID AS OTHER_MONEY
					</cfif>
				</cfif>
			FROM
				CHEQUE C,
				PAYROLL P
				<cfif attributes.report_type eq 1>
                	LEFT JOIN #dsn_alias#.PRO_PROJECTS PR ON P.PROJECT_ID = PR.PROJECT_ID
                </cfif>,
				#dsn_alias#.EMPLOYEES EMP
				<cfif attributes.report_type eq 4>
					,CASH
				</cfif>
			WHERE
				C.CHEQUE_PAYROLL_ID = P.ACTION_ID
				AND P.PAYROLL_TYPE IN (106, 135)<!---135 transfer----->
				AND P.COMPANY_ID IS NULL
				AND P.CONSUMER_ID IS NULL
				AND P.EMPLOYEE_ID IS NULL
				AND C.EMPLOYEE_ID = EMP.EMPLOYEE_ID
                <cfif isdefined("attributes.self_cheque1") and len(attributes.self_cheque1)>
                	AND C.SELF_CHEQUE = 1
                <cfelseif isdefined("attributes.self_cheque2") and len(attributes.self_cheque2)>
                	AND C.SELF_CHEQUE = 0
                </cfif>
				<cfif isdefined("attributes.cash_id") and len(attributes.cash_id)>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						AND ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID) = #attributes.cash_id#
					<cfelseif isdefined("attributes.is_status_info")>
						AND ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						) = #attributes.cash_id#
					<cfelse>
						AND C.CASH_ID = #attributes.cash_id#
					</cfif>
				</cfif>
				<cfif isdefined("attributes.account_id") and len(attributes.account_id)>
					AND (SELECT TOP 1 P.PAYROLL_ACCOUNT_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(2,3) ORDER BY CHH.HISTORY_ID DESC) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account_id#" list="yes">)				
				</cfif>
				<cfif isdefined("attributes.new_account_id") and len(attributes.new_account_id)>
					AND (SELECT TOP 1 P.PAYROLL_ACCOUNT_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(2,3) ORDER BY CHH.HISTORY_ID DESC) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.new_account_id#" list="yes">)
				</cfif>
				<cfif isdefined("kurumsal") and listlen(kurumsal)>
					AND 1 = 2
				</cfif>
				<cfif isdefined("bireysel") and listlen(bireysel)>
					AND 1 = 2
				</cfif>
				<cfif isDefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.employee)>
					AND P.REVENUE_COLLECTOR_ID = #attributes.employee_id#
				</cfif>
				<cfif isdate(attributes.start_date)>
					AND C.CHEQUE_DUEDATE >=#attributes.start_date#
				</cfif>
				<cfif isdate(attributes.finish_date)>
					AND C.CHEQUE_DUEDATE <=#attributes.finish_date#
				</cfif>
                <cfif isdefined("attributes.is_interest_show")>
                	AND DATEDIFF(day,C.CHEQUE_DUEDATE,GETDATE()) > 0
                </cfif>
				<cfif len(attributes.record_date1) and isdate(attributes.record_date1)>
					AND C.RECORD_DATE >=#attributes.record_date1#
				</cfif>
				<cfif len(attributes.record_date2) and isdate(attributes.record_date2)>
					AND C.RECORD_DATE < #DATEADD('d',1,attributes.record_date2)#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.company_id)>
					AND C.COMPANY_ID = #attributes.company_id#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.consumer_id)>
					AND C.CONSUMER_ID = #attributes.consumer_id#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.employee_id_)>
					AND P.EMPLOYEE_ID = #attributes.employee_id_#
				</cfif>
				<cfif len(trim(attributes.company2)) and len(attributes.company_id2)>
					AND (SELECT TOP 1 P.COMPANY_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS = 4 ORDER BY CHH.HISTORY_ID DESC) = #attributes.company_id2#
				</cfif>
				<cfif len(attributes.status)>
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							AND ISNULL((SELECT CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID IN(SELECT ACTION_ID FROM PAYROLL WHERE PAYROLL_TYPE=106)),C.CHEQUE_STATUS_ID) IN (#attributes.status#)
						<cfelseif len(attributes.action_date2)>
							AND ISNULL((SELECT TOP 1 CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID) IN (#attributes.status#)
						<cfelse>	
							AND C.CHEQUE_STATUS_ID IN (#attributes.status#)
						</cfif>
					<cfelse>	
						AND C.CHEQUE_STATUS_ID IN (#attributes.status#)
					</cfif>
				</cfif>
				<cfif attributes.report_type eq 4>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						AND CASH.CASH_ID = ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						AND CASH.CASH_ID = ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						)
					<cfelse>
						AND CASH.CASH_ID = C.CASH_ID
					</cfif>
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							AND ISNULL((SELECT CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID IN(SELECT ACTION_ID FROM PAYROLL WHERE PAYROLL_TYPE=106)),C.CHEQUE_STATUS_ID) = 1
						<cfelseif len(attributes.action_date2)>
							AND ISNULL((SELECT TOP 1 CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID) = 1
						<cfelse>	
							AND C.CHEQUE_STATUS_ID IN  = 1
						</cfif>
					<cfelse>	
						AND C.CHEQUE_STATUS_ID = 1
					</cfif>
				</cfif>
				<cfif len(attributes.action_date1) and isdate(attributes.action_date1)>
					AND C.CHEQUE_ID IN(SELECT CH.CHEQUE_ID FROM CHEQUE_HISTORY CH WHERE <cfif len(attributes.status)>CH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(CH.ACT_DATE,DATEADD(day,-1,CH.RECORD_DATE)) >=#attributes.action_date1#) AND C.CHEQUE_ID = CH.CHEQUE_ID)
				</cfif>
				<cfif len(attributes.action_date2) and isdate(attributes.action_date2)>
					AND C.CHEQUE_ID IN(SELECT CH.CHEQUE_ID FROM CHEQUE_HISTORY CH WHERE <cfif len(attributes.status)>CH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(CH.ACT_DATE,DATEADD(day,-1,CH.RECORD_DATE)) <= #attributes.action_date2#) AND C.CHEQUE_ID = CH.CHEQUE_ID)
				</cfif>
				<cfif isdefined("attributes.is_open_acts")>
					AND P.PAYROLL_NO='-1'
				</cfif>
				<cfif len(attributes.owner_company) and len(attributes.owner_company_id) and attributes.owner_member_type eq 'partner'>
					AND C.OWNER_COMPANY_ID = #attributes.owner_company_id#
				<cfelseif len(attributes.owner_company) and len(attributes.owner_consumer_id) and attributes.owner_member_type eq 'consumer'>
					AND C.OWNER_CONSUMER_ID = #attributes.owner_consumer_id#
				<cfelseif len(attributes.owner_company) and len(attributes.owner_employee_id) and attributes.owner_member_type eq 'employee'>
					AND C.OWNER_EMPLOYEE_ID = #attributes.owner_employee_id#
				</cfif>
			<cfif attributes.report_type neq 1>	
				GROUP BY
			</cfif>
			<cfif attributes.report_type eq 2>
				C.ACCOUNT_ID,
				C.COMPANY_ID,
				C.EMPLOYEE_ID,
				EMP.EMPLOYEE_NAME,
				EMP.EMPLOYEE_SURNAME,
				EMP.EMPLOYEE_NO,
				C.CHEQUE_ID
				<cfif isdefined("attributes.is_other_money")>
					,C.CURRENCY_ID
				</cfif>
			<cfelseif attributes.report_type eq 3>
				C.CHEQUE_ID,
				C.ACCOUNT_ID
				<cfif isdefined("attributes.is_other_money")>
					,C.CURRENCY_ID
				</cfif>
			<cfelseif attributes.report_type eq 4>
				<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
					ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID)
				<cfelseif isdefined("attributes.is_status_info")>
					ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						)
				<cfelse>
					C.CASH_ID
				</cfif>,
				C.CHEQUE_ID,
				C.ACCOUNT_ID,
				CASH.CASH_NAME
				<cfif isdefined("attributes.is_other_money")>
					,C.CURRENCY_ID
				</cfif>
			<cfelseif attributes.report_type eq 5>
				C.CHEQUE_ID,
				C.ACCOUNT_ID,
				C.CHEQUE_DUEDATE,
				MONTH(C.CHEQUE_DUEDATE),
				YEAR(C.CHEQUE_DUEDATE),
				C.CHEQUE_STATUS_ID
				<cfif isdefined("attributes.is_other_money")>
					,C.CURRENCY_ID
				</cfif>
			</cfif>
		</cfquery>
	</cfif>
	<cfif attributes.report_type eq 4>
		<cfif len(kurumsal) or not len(bireysel)>
			<cfquery name="get_cheque_voucher_5" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
			SELECT
				(SELECT TOP 1 P.PAYROLL_TYPE FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY_TYPE,
				(SELECT TOP 1 P.PAYROLL_NO FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY_NO,
				(SELECT TOP 1 CHH.PAYROLL_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY,
				(SELECT TOP 1 P.COMPANY_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS = 4 ORDER BY CHH.HISTORY_ID DESC) AS NEW_COMPANY_ID,
				(SELECT TOP 1 P.PAYROLL_ACCOUNT_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(2,3) ORDER BY CHH.HISTORY_ID DESC) AS NEW_ACCOUNT_ID,
				0 AS TOTAL_AMOUNT,
				0 AS AVG_DUEDATE,
				<cfif isdefined("attributes.is_other_money")>
					0 AS TOTAL_AMOUNT_OTHER,
					'#session.ep.money#' AS OTHER_MONEY,
				</cfif>			
				<cfif isdefined("attributes.is_money2")>
					0 AS TOTAL_AMOUNT2,
				</cfif>
				<cfif isdefined("attributes.is_interest")>
					0 AS TOTAL_GECIKME,
					0 AS TOTAL_GECIKME_VADE,
				</cfif>
				<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
					ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID)
				<cfelseif isdefined("attributes.is_status_info")>
					ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						)
				<cfelse>
					C.CASH_ID
				</cfif> AS CASH_ID,
				CASH.CASH_NAME AS CASH_NAME,
				SUM(C.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT_ICRA,
				SUM((DATEDIFF(day,GETDATE(),C.CHEQUE_DUEDATE)*C.OTHER_MONEY_VALUE)) AS AVG_DUEDATE_ICRA,
				0 AS TOTAL_AMOUNT_VADE,
				0 AS AVG_DUEDATE_VADE
			FROM
				CHEQUE C,
				PAYROLL P,
				CASH
			WHERE
				C.CHEQUE_PAYROLL_ID = P.ACTION_ID
                <cfif isdefined("attributes.self_cheque1") and len(attributes.self_cheque1)>
                	AND C.SELF_CHEQUE = 1
                <cfelseif isdefined("attributes.self_cheque2") and len(attributes.self_cheque2)>
                	AND C.SELF_CHEQUE = 0
                </cfif>
				<cfif isdefined("attributes.cash_id") and len(attributes.cash_id)>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						AND ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID) = #attributes.cash_id#
					<cfelseif isdefined("attributes.is_status_info")>
						AND ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						) = #attributes.cash_id#
					<cfelse>
						AND C.CASH_ID = #attributes.cash_id#
					</cfif>
				</cfif>
				<cfif isdefined("attributes.account_id") and len(attributes.account_id)>
					AND (SELECT TOP 1 P.PAYROLL_ACCOUNT_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(2,3) ORDER BY CHH.HISTORY_ID DESC) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account_id#" list="yes">)	
				</cfif>
				<cfif isdefined("attributes.new_account_id") and len(attributes.new_account_id)>
					AND (SELECT TOP 1 P.PAYROLL_ACCOUNT_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(2,3) ORDER BY CHH.HISTORY_ID DESC) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.new_account_id#" list="yes">)
				</cfif>
				<cfif isdefined("bireysel") and listlen(bireysel)>
					AND P.CONSUMER_ID IN
						(
						SELECT 
							C.CONSUMER_ID 
						FROM 
							#dsn_alias#.CONSUMER C,
							#dsn_alias#.CONSUMER_CAT CAT 
						WHERE 
							C.CONSUMER_CAT_ID = CAT.CONSCAT_ID AND
							(
								<cfloop list="#bireysel#" delimiters="," index="cat_i">
									(CAT.CONSCAT_ID = #listlast(cat_i,'-')#)
									<cfif cat_i neq listlast(bireysel,',') and listlen(bireysel,',') gte 1> OR</cfif>
								</cfloop>  
							)
						)
				</cfif>
				<cfif isDefined("attributes.sales_zones") and len(attributes.sales_zones)>
					AND C.COMPANY_ID IN(SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANY.SALES_COUNTY = #attributes.sales_zones#)
				</cfif>
				<cfif isdefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_code_text)>
					AND C.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE= #attributes.pos_code# AND IS_MASTER=1 AND OUR_COMPANY_ID = #session.ep.company_id# AND CONSUMER_ID IS NOT NULL)
				</cfif>
				<cfif isDefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.employee)>
					AND P.REVENUE_COLLECTOR_ID = #attributes.employee_id#
				</cfif>
				<cfif isdate(attributes.start_date)>
					AND C.CHEQUE_DUEDATE >=#attributes.start_date#
				</cfif>
				<cfif isdate(attributes.finish_date)>
					AND C.CHEQUE_DUEDATE <=#attributes.finish_date#
				</cfif>
                <cfif isdefined("attributes.is_interest_show")>
                	AND DATEDIFF(day,C.CHEQUE_DUEDATE,GETDATE()) > 0
                </cfif>
				<cfif len(trim(attributes.company)) and len(attributes.company_id)>
					AND C.COMPANY_ID = #attributes.company_id#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.consumer_id)>
					AND C.CONSUMER_ID = #attributes.consumer_id#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.employee_id_)>
					AND C.EMPLOYEE_ID = #attributes.employee_id_#
				</cfif>
				<cfif len(trim(attributes.company2)) and len(attributes.company_id2)>
					AND (SELECT TOP 1 P.COMPANY_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS = 4 ORDER BY CHH.HISTORY_ID DESC) = #attributes.company_id2#
				</cfif>
				<cfif len(attributes.status)>
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							AND ISNULL((SELECT CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID IN(SELECT ACTION_ID FROM PAYROLL WHERE PAYROLL_TYPE=106)),C.CHEQUE_STATUS_ID) IN (#attributes.status#)
						<cfelseif len(attributes.action_date2)>
							AND ISNULL((SELECT TOP 1 CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID) IN (#attributes.status#)
						<cfelse>	
							AND C.CHEQUE_STATUS_ID IN (#attributes.status#)
						</cfif>
					<cfelse>	
						AND C.CHEQUE_STATUS_ID IN (#attributes.status#)
					</cfif>
				</cfif>
				AND (
						P.CONSUMER_ID IN(SELECT CONSUMER_ID FROM #dsn_alias#.COMPANY_LAW_REQUEST WHERE CONSUMER_ID IS NOT NULL)
						OR P.COMPANY_ID IN(SELECT COMPANY_ID FROM #dsn_alias#.COMPANY_LAW_REQUEST WHERE COMPANY_ID IS NOT NULL)
					)
				<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
					AND CASH.CASH_ID = ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID)
				<cfelseif isdefined("attributes.is_status_info")>
					AND CASH.CASH_ID = ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						)
				<cfelse>
					AND CASH.CASH_ID = C.CASH_ID
				</cfif>
				<cfif isdefined("attributes.is_status_info")>
					<cfif isdefined("attributes.is_open_acts")>
						AND ISNULL((SELECT CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID IN(SELECT ACTION_ID FROM PAYROLL WHERE PAYROLL_TYPE=106)),C.CHEQUE_STATUS_ID) = 1
					<cfelseif len(attributes.action_date2)>
						AND ISNULL((SELECT TOP 1 CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID) = 1
					<cfelse>	
						AND C.CHEQUE_STATUS_ID = 1
					</cfif>
				<cfelse>	
					AND C.CHEQUE_STATUS_ID = 1
				</cfif>
				<cfif len(attributes.action_date1) and isdate(attributes.action_date1)>
					AND C.CHEQUE_ID IN(SELECT CH.CHEQUE_ID FROM CHEQUE_HISTORY CH WHERE <cfif len(attributes.status)>CH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(CH.ACT_DATE,DATEADD(day,-1,CH.RECORD_DATE)) >=#attributes.action_date1#) AND C.CHEQUE_ID = CH.CHEQUE_ID)
				</cfif>
				<cfif len(attributes.action_date2) and isdate(attributes.action_date2)>
					AND C.CHEQUE_ID IN(SELECT CH.CHEQUE_ID FROM CHEQUE_HISTORY CH WHERE <cfif len(attributes.status)>CH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(CH.ACT_DATE,DATEADD(day,-1,CH.RECORD_DATE)) <= #attributes.action_date2#) AND C.CHEQUE_ID = CH.CHEQUE_ID)
				</cfif>
				<cfif isdefined("attributes.is_open_acts")>
					AND P.PAYROLL_NO='-1'
				</cfif>
				<cfif len(attributes.owner_company) and len(attributes.owner_company_id) and attributes.owner_member_type eq 'partner'>
					AND C.OWNER_COMPANY_ID = #attributes.owner_company_id#
				<cfelseif len(attributes.owner_company) and len(attributes.owner_consumer_id) and attributes.owner_member_type eq 'consumer'>
					AND C.OWNER_CONSUMER_ID = #attributes.owner_consumer_id#
				<cfelseif len(attributes.owner_company) and len(attributes.owner_employee_id) and attributes.owner_member_type eq 'employee'>
					AND C.OWNER_EMPLOYEE_ID = #attributes.owner_employee_id#
				</cfif>
			GROUP BY
				<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
					ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID),
				<cfelseif isdefined("attributes.is_status_info")>
					ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						),
				<cfelse>
					C.CASH_ID,
				</cfif>
				C.CHEQUE_ID,
				CASH.CASH_NAME
				<cfif isdefined("attributes.is_other_money")>
				,C.CURRENCY_ID
				</cfif>
		</cfquery>
		</cfif>
		<cfif len(bireysel) or not len(kurumsal)>
			<cfquery name="get_cheque_voucher_6" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
				SELECT
					(SELECT TOP 1 P.PAYROLL_TYPE FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY CHH.HISTORY_ID DESC) AS PAY_TYPE,
					(SELECT TOP 1 VP.PAYROLL_NO FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY_NO,
					(SELECT TOP 1 VHH.PAYROLL_ID FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY,
					(SELECT TOP 1 P.COMPANY_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS = 4 ORDER BY CHH.HISTORY_ID DESC) AS NEW_COMPANY_ID,
					(SELECT TOP 1 P.PAYROLL_ACCOUNT_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(2,3) ORDER BY CHH.HISTORY_ID DESC) AS NEW_ACCOUNT_ID,
					0 AS TOTAL_AMOUNT,
					0 AS AVG_DUEDATE,
					<cfif isdefined("attributes.is_other_money")>
						0 AS TOTAL_AMOUNT_OTHER,
						'#session.ep.money#' AS OTHER_MONEY,
					</cfif>			
					<cfif isdefined("attributes.is_money2")>
						0 AS TOTAL_AMOUNT2,
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						0 AS TOTAL_GECIKME,
						0 AS TOTAL_GECIKME_VADE,
					</cfif>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						)
					<cfelse>
						C.CASH_ID
					</cfif> AS CASH_ID,
					CASH.CASH_NAME AS CASH_NAME,
					0 AS TOTAL_AMOUNT_ICRA,
					0 AS AVG_DUEDATE_ICRA,
					SUM(C.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT_VADE,
					SUM((DATEDIFF(day,GETDATE(),C.CHEQUE_DUEDATE)*C.OTHER_MONEY_VALUE)) AS AVG_DUEDATE_VADE
				FROM
				 	VOUCHER V,
					CHEQUE C,
					PAYROLL P,
					CASH
				WHERE
					C.CHEQUE_PAYROLL_ID = P.ACTION_ID
					<cfif isdefined("attributes.self_cheque1") and len(attributes.self_cheque1)>
                        AND C.SELF_CHEQUE = 1
                    <cfelseif isdefined("attributes.self_cheque2") and len(attributes.self_cheque2)>
                        AND C.SELF_CHEQUE = 0
                    </cfif>
					<cfif isdefined("attributes.cash_id") and len(attributes.cash_id)>
						<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
							AND ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID) = #attributes.cash_id#
						<cfelseif isdefined("attributes.is_status_info")>
							AND ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						) = #attributes.cash_id#
						<cfelse>
							AND C.CASH_ID = #attributes.cash_id#
						</cfif>
					</cfif>
					<cfif isdefined("attributes.account_id") and len(attributes.account_id)>
						AND (SELECT TOP 1 P.PAYROLL_ACCOUNT_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(2,3) ORDER BY CHH.HISTORY_ID DESC) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account_id#" list="yes">)
					</cfif>
					<cfif isdefined("attributes.new_account_id") and len(attributes.new_account_id)>
						AND (SELECT TOP 1 P.PAYROLL_ACCOUNT_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(2,3) ORDER BY CHH.HISTORY_ID DESC) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.new_account_id#" list="yes">)
					</cfif>
					<cfif isdefined("bireysel") and listlen(bireysel)>
						AND P.CONSUMER_ID IN
							(
							SELECT 
								C.CONSUMER_ID 
							FROM 
								#dsn_alias#.CONSUMER C,
								#dsn_alias#.CONSUMER_CAT CAT 
							WHERE 
								C.CONSUMER_CAT_ID = CAT.CONSCAT_ID AND
								(
									<cfloop list="#bireysel#" delimiters="," index="cat_i">
										(CAT.CONSCAT_ID = #listlast(cat_i,'-')#)
										<cfif cat_i neq listlast(bireysel,',') and listlen(bireysel,',') gte 1> OR</cfif>
									</cfloop>  
								)
							)
					</cfif>
					<cfif isDefined("attributes.sales_zones") and len(attributes.sales_zones)>
						AND C.CONSUMER_ID IN(SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER WHERE CONSUMER.SALES_COUNTY = #attributes.sales_zones#)
					</cfif>
					<cfif isdefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_code_text)>
						AND C.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE= #attributes.pos_code# AND IS_MASTER=1 AND OUR_COMPANY_ID = #session.ep.company_id# AND CONSUMER_ID IS NOT NULL)
					</cfif>
					<cfif isDefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.employee)>
						AND P.REVENUE_COLLECTOR_ID = #attributes.employee_id#
					</cfif>
					<cfif isdate(attributes.start_date)>
						AND C.CHEQUE_DUEDATE >=#attributes.start_date#
					</cfif>
					<cfif isdate(attributes.finish_date)>
						AND C.CHEQUE_DUEDATE <=#attributes.finish_date#
					</cfif>
					<cfif isdefined("attributes.is_interest_show")>
                        AND DATEDIFF(day,C.CHEQUE_DUEDATE,GETDATE()) > 0
                    </cfif>
					<cfif len(attributes.record_date1) and isdate(attributes.record_date1)>
						AND C.RECORD_DATE >=#attributes.record_date1#
					</cfif>
					<cfif len(attributes.record_date2) and isdate(attributes.record_date2)>
						AND C.RECORD_DATE < #DATEADD('d',1,attributes.record_date2)#
					</cfif>
					<cfif len(trim(attributes.company)) and len(attributes.company_id)>
						AND C.COMPANY_ID = #attributes.company_id#
					</cfif>
					<cfif len(trim(attributes.company)) and len(attributes.consumer_id)>
						AND C.CONSUMER_ID = #attributes.consumer_id#
					</cfif>
					<cfif len(trim(attributes.company)) and len(attributes.employee_id_)>
						AND C.EMPLOYEE_ID = #attributes.employee_id_#
					</cfif>
					<cfif len(trim(attributes.company2)) and len(attributes.company_id2)>
						AND (SELECT TOP 1 P.COMPANY_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS = 4 ORDER BY CHH.HISTORY_ID DESC) = #attributes.company_id2#
					</cfif>
					<cfif len(attributes.status)>
						<cfif isdefined("attributes.is_status_info")>
							<cfif isdefined("attributes.is_open_acts")>
								AND ISNULL((SELECT CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID IN(SELECT ACTION_ID FROM PAYROLL WHERE PAYROLL_TYPE=106)),C.CHEQUE_STATUS_ID) IN (#attributes.status#)
							<cfelseif len(attributes.action_date2)>
								AND ISNULL((SELECT TOP 1 CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID) IN (#attributes.status#)
							<cfelse>	
								AND C.CHEQUE_STATUS_ID IN (#attributes.status#)
							</cfif>
						<cfelse>	
							AND C.CHEQUE_STATUS_ID IN (#attributes.status#)
						</cfif>
					</cfif>
					AND C.CHEQUE_DUEDATE >= GETDATE()
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						AND CASH.CASH_ID = ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						AND CASH.CASH_ID = ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						)
					<cfelse>
						AND CASH.CASH_ID = C.CASH_ID
					</cfif>
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							AND ISNULL((SELECT CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID IN(SELECT ACTION_ID FROM PAYROLL WHERE PAYROLL_TYPE=106)),C.CHEQUE_STATUS_ID) = 1
						<cfelseif len(attributes.action_date2)>
							AND ISNULL((SELECT TOP 1 CHH.STATUS FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),C.CHEQUE_STATUS_ID) = 1
						<cfelse>	
							AND C.CHEQUE_STATUS_ID = 1
						</cfif>
					<cfelse>	
						AND C.CHEQUE_STATUS_ID = 1
					</cfif>
					<cfif len(attributes.action_date1) and isdate(attributes.action_date1)>
						AND C.CHEQUE_ID IN(SELECT CH.CHEQUE_ID FROM CHEQUE_HISTORY CH WHERE <cfif len(attributes.status)>CH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(CH.ACT_DATE,DATEADD(day,-1,CH.RECORD_DATE)) >=#attributes.action_date1#) AND C.CHEQUE_ID = CH.CHEQUE_ID)
					</cfif>
					<cfif len(attributes.action_date2) and isdate(attributes.action_date2)>
						AND C.CHEQUE_ID IN(SELECT CH.CHEQUE_ID FROM CHEQUE_HISTORY CH WHERE <cfif len(attributes.status)>CH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(CH.ACT_DATE,DATEADD(day,-1,CH.RECORD_DATE)) <= #attributes.action_date2#) AND C.CHEQUE_ID = CH.CHEQUE_ID)
					</cfif>
					<cfif isdefined("attributes.is_open_acts")>
						AND P.PAYROLL_NO='-1'
					</cfif>
					<cfif len(attributes.owner_company) and len(attributes.owner_company_id) and attributes.owner_member_type eq 'partner'>
						AND C.OWNER_COMPANY_ID = #attributes.owner_company_id#
					<cfelseif len(attributes.owner_company) and len(attributes.owner_consumer_id) and attributes.owner_member_type eq 'consumer'>
						AND C.OWNER_CONSUMER_ID = #attributes.owner_consumer_id#
					<cfelseif len(attributes.owner_company) and len(attributes.owner_employee_id) and attributes.owner_member_type eq 'employee'>
						AND C.OWNER_EMPLOYEE_ID = #attributes.owner_employee_id#
					</cfif>
				GROUP BY
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID),
					<cfelseif isdefined("attributes.is_status_info")>
						ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						),
					<cfelse>
						C.CASH_ID,
					</cfif>
					V.VOUCHER_ID,
					C.CHEQUE_ID,
					CASH.CASH_NAME
					<cfif isdefined("attributes.is_other_money")>
						,C.CURRENCY_ID
					</cfif>
			</cfquery>
		</cfif>
	</cfif>
</cfif>
<cfif (isdefined("attributes.is_voucher") or isdefined("attributes.is_pay_term")) and  attributes.report_type neq 6>
	<cfif len(kurumsal) or not len(bireysel)>
		<cfquery name="get_cheque_voucher_7" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
			<!--- company dolu olanlar --->
			SELECT
			<cfif isdefined("attributes.report_type") and attributes.report_type eq 4>
				(SELECT TOP 1 VP.PAYROLL_TYPE FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY_TYPE,
				(SELECT TOP 1 VP.PAYROLL_NO FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY_NO,
				(SELECT TOP 1 VHH.PAYROLL_ID FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY,
			</cfif>
				(SELECT TOP 1 VP.COMPANY_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS = 4 ORDER BY VHH.HISTORY_ID DESC) AS NEW_COMPANY_ID,
				(SELECT TOP 1 VP.PAYROLL_ACCOUNT_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN(2,3) ORDER BY VHH.HISTORY_ID DESC) AS NEW_ACCOUNT_ID,
				<cfif attributes.report_type eq 1>
					V.ACCOUNT_NO,
					V.VOUCHER_ID AS ISLEM_ID,
					V.VOUCHER_CODE AS OZEL_KOD,
					V.VOUCHER_DUEDATE AS DUE_DATE,
					V.VOUCHER_NO AS PAPER_NO,
					'' BANK_NAME,
					'' BANK_BRANCH_NAME,
					(SELECT TOP 1 VP.PAYROLL_TYPE FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY_TYPE,
					(SELECT TOP 1 VP.PAYROLL_NO FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY_NO,
					(SELECT TOP 1 VHH.PAYROLL_ID FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY,
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							ISNULL((SELECT VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID IN(SELECT ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_TYPE = 107)),V.VOUCHER_STATUS_ID) AS STATUS,
						<cfelseif len(attributes.action_date2)>
							ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) AS STATUS,
						<cfelse>	
							V.VOUCHER_STATUS_ID AS STATUS,
						</cfif>
					<cfelse>	
						V.VOUCHER_STATUS_ID AS STATUS,
					</cfif>
					V.DEBTOR_NAME AS DEBTOR_NAME,
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						)
					<cfelse>
						V.CASH_ID
					</cfif> AS CASH_ID,
					VP.PAYROLL_ACCOUNT_ID AS ACCOUNT_ID,
					VP.PAYMENT_ORDER_ID AS ORDER_ID,
					CASE WHEN VOUCHER_STATUS_ID = 3 THEN
						V.DELAY_INTEREST_SYSTEM_VALUE 
					ELSE
						CASE WHEN 
							DATEDIFF(d,VOUCHER_DUEDATE,GETDATE()) > (SELECT SP.DELAY_INTEREST_DAY FROM #dsn_alias#.SETUP_PAYMETHOD SP WHERE SP.PAYMETHOD_ID = VP.PAYMETHOD_ID) 
						THEN
							1
						ELSE
							0
						END	
					END AS GECIKME_TUTAR,
					VP.PAYMETHOD_ID AS PAYMETHOD_ID,
					<!--- <cfif check_our_company.is_remaining_amount eq 1>
						(SELECT OTHER_REMAINING_VALUE FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) OTHER_MONEY_VALUE,
						(SELECT OTHER_REMAINING_VALUE2 FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) OTHER_MONEY_VALUE2,
						(SELECT REMAINING_VALUE FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) OTHER_ACT_VALUE,
					<cfelse> Makın iste��iyle kapatıldı silmeyin Sevda ile konu��ulacak--->
						<cfif isdefined("attributes.is_status_info") and len(attributes.action_date2)>
							CASE WHEN
								ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) <> 3 <!---portfoydeyse --->
							THEN
								V.OTHER_MONEY_VALUE - ISNULL((SELECT (SUM(VC.CLOSED_AMOUNT)) FROM VOUCHER_PAYROLL VP,VOUCHER_CLOSED VC WHERE VC.PAYROLL_ID = VP.ACTION_ID AND VC.ACTION_ID = V.VOUCHER_ID AND ISNULL(VP.PAYROLL_AVG_DUEDATE,DATEADD(day,-1,VP.RECORD_DATE)) <= #attributes.action_date2# GROUP BY VC.ACTION_ID),0)
							ELSE
								V.OTHER_MONEY_VALUE
							END AS OTHER_MONEY_VALUE,
							V.OTHER_MONEY_VALUE2 AS OTHER_MONEY_VALUE2,
							CASE WHEN
								ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) <> 3
							THEN
								V.VOUCHER_VALUE - ISNULL((SELECT (SUM(VC.OTHER_CLOSED_AMOUNT)) FROM VOUCHER_PAYROLL VP,VOUCHER_CLOSED VC WHERE VC.PAYROLL_ID = VP.ACTION_ID AND VC.ACTION_ID = V.VOUCHER_ID AND ISNULL(VP.PAYROLL_AVG_DUEDATE,DATEADD(day,-1,VP.RECORD_DATE)) <= #attributes.action_date2# GROUP BY VC.ACTION_ID),0)
							ELSE
								V.VOUCHER_VALUE
							END AS OTHER_ACT_VALUE,
						<cfelse>
							V.OTHER_MONEY_VALUE AS OTHER_MONEY_VALUE,
							V.OTHER_MONEY_VALUE2 AS OTHER_MONEY_VALUE2,
							V.VOUCHER_VALUE AS OTHER_ACT_VALUE,
						</cfif>
					<!--- </cfif> --->
					V.CURRENCY_ID AS OTHER_MONEY,
					V.COMPANY_ID AS MEMBER_ID,
					COMP.NICKNAME AS MUSTERI,
					COMP.MEMBER_CODE AS MEMBER_CODE,
					COMP.OZEL_KOD AS M_OZEL_KOD,
					0 AS MEMBER_TYPE,
					1 AS TYPE,
                    PR.PROJECT_HEAD,
					(SELECT TOP 1 VH.ACT_DATE FROM VOUCHER_HISTORY VH WHERE VH.VOUCHER_ID=V.VOUCHER_ID <cfif len(attributes.status)>AND VH.STATUS IN(#attributes.status#)</cfif> ORDER BY VH.RECORD_DATE DESC) TAHSILAT_TARIHI
				<cfelseif attributes.report_type eq 2>
					SUM(V.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),V.VOUCHER_DUEDATE)*V.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					<cfif isdefined("attributes.is_other_money")>
						SUM(V.VOUCHER_VALUE) AS TOTAL_AMOUNT_OTHER,
						V.CURRENCY_ID AS OTHER_MONEY,
					</cfif>			
					<cfif isdefined("attributes.is_money2")>
						SUM(V.OTHER_MONEY_VALUE2) AS TOTAL_AMOUNT2,
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						SUM(	
							CASE WHEN 
								V.VOUCHER_STATUS_ID = 3
							THEN	
								V.DELAY_INTEREST_SYSTEM_VALUE
							ELSE
							( 
								CASE WHEN
									DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE()) > SP.DELAY_INTEREST_DAY
								THEN
									(SP.DELAY_INTEREST_RATE*V.OTHER_MONEY_VALUE/30)*DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE())
								ELSE
									0
								END
							)
							END
						) AS TOTAL_GECIKME,
					</cfif>
					<cfif isdefined("attributes.bloke_member") and attributes.bloke_member eq 1>
						CR.FILE_NUMBER,
						CR.LAW_ADWOCATE,
					</cfif>
					VP.COMPANY_ID AS MEMBER_ID,
					COMP.NICKNAME AS MUSTERI,
					COMP.MEMBER_CODE AS MEMBER_CODE,
					COMP.OZEL_KOD AS M_OZEL_KOD,
					'' MOBIL_TEL,
					0 AS MEMBER_TYPE
				<cfelseif attributes.report_type eq 3>
					SUM(V.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),V.VOUCHER_DUEDATE)*V.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					<cfif isdefined("attributes.is_other_money")>
						SUM(V.VOUCHER_VALUE) AS TOTAL_AMOUNT_OTHER,
						V.CURRENCY_ID AS OTHER_MONEY,
					</cfif>			
					<cfif isdefined("attributes.is_money2")>
						SUM(V.OTHER_MONEY_VALUE2) AS TOTAL_AMOUNT2,
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						SUM(	
							CASE WHEN
								DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE()) > SP.DELAY_INTEREST_DAY
							THEN
								(SP.DELAY_INTEREST_RATE*V.OTHER_MONEY_VALUE/30)*DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE())
							ELSE
								0
							END
						) AS TOTAL_GECIKME,
					</cfif>
					CR.LAW_ADWOCATE
				<cfelseif attributes.report_type eq 4>
					SUM(V.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),V.VOUCHER_DUEDATE)*V.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					<cfif isdefined("attributes.is_other_money")>
						SUM(V.VOUCHER_VALUE) AS TOTAL_AMOUNT_OTHER,
						V.CURRENCY_ID AS OTHER_MONEY,
					</cfif>			
					<cfif isdefined("attributes.is_money2")>
						SUM(V.OTHER_MONEY_VALUE2) AS TOTAL_AMOUNT2,
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						SUM(	
							CASE WHEN 
								V.VOUCHER_STATUS_ID = 3
							THEN	
								V.DELAY_INTEREST_SYSTEM_VALUE
							ELSE
							( 
								CASE WHEN
									DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE()) > SP.DELAY_INTEREST_DAY
								THEN
									(SP.DELAY_INTEREST_RATE*V.OTHER_MONEY_VALUE/30)*DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE())
								ELSE
									0
								END
							)
							END
						) AS TOTAL_GECIKME,
						SUM(
							CASE WHEN
								DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE()) > SP.DELAY_INTEREST_DAY
							THEN
								((DATEDIFF(day,GETDATE(),V.VOUCHER_DUEDATE)*(SP.DELAY_INTEREST_RATE*V.OTHER_MONEY_VALUE/30)))
							ELSE
								0
							END
						) AS TOTAL_GECIKME_VADE,
					</cfif>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						)
					<cfelse>
						V.CASH_ID
					</cfif> AS CASH_ID,
					CASH.CASH_NAME AS CASH_NAME,
					0 AS TOTAL_AMOUNT_ICRA,
					0 AS AVG_DUEDATE_ICRA,
					0 AS TOTAL_AMOUNT_VADE,
					0 AS AVG_DUEDATE_VADE
				<cfelseif attributes.report_type eq 5>
					SUM(V.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),V.VOUCHER_DUEDATE)*V.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					V.VOUCHER_DUEDATE AS DUE_DATE,
					MONTH(V.VOUCHER_DUEDATE) AS MONTH_DUE,
					YEAR(V.VOUCHER_DUEDATE) AS YEAR_DUE,
					V.VOUCHER_STATUS_ID AS STATUS
					<cfif isdefined("attributes.is_other_money")>
						,SUM(V.VOUCHER_VALUE) AS TOTAL_AMOUNT_OTHER
						,V.CURRENCY_ID AS OTHER_MONEY
					</cfif>	
				</cfif>
			FROM
				VOUCHER V,
				VOUCHER_PAYROLL VP
                <cfif attributes.report_type eq 1>
                	LEFT JOIN #dsn_alias#.PRO_PROJECTS PR ON VP.PROJECT_ID = PR.PROJECT_ID
                </cfif>,
				#dsn_alias#.COMPANY COMP
				<cfif (isdefined("attributes.bloke_member") and attributes.bloke_member eq 1) or attributes.report_type eq 3>
					,#dsn_alias#.COMPANY_LAW_REQUEST CR
				</cfif>
				<cfif isdefined("attributes.is_interest")>
					,#dsn_alias#.SETUP_PAYMETHOD SP	
				</cfif>
				<cfif attributes.report_type eq 4>
					,CASH
				</cfif>
			WHERE
				V.VOUCHER_PAYROLL_ID = VP.ACTION_ID
				AND VP.COMPANY_ID = COMP.COMPANY_ID
				AND V.OTHER_MONEY_VALUE > 0
				<cfif not isdefined("attributes.is_pay_term")>
					AND V.IS_PAY_TERM = 0
				<cfelseif isdefined("attributes.is_pay_term") and not isdefined("attributes.is_voucher")>	
					AND V.IS_PAY_TERM = 1
				</cfif>
				<cfif isdefined("attributes.is_interest")>
					AND VP.PAYMETHOD_ID = SP.PAYMETHOD_ID
				</cfif>
				<cfif isdefined("attributes.cash_id") and len(attributes.cash_id)>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						AND ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID) = #attributes.cash_id#
					<cfelseif isdefined("attributes.is_status_info")>
						AND ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						) = #attributes.cash_id#
					<cfelse>
						AND V.CASH_ID = #attributes.cash_id#
					</cfif>
				</cfif>
				<cfif isdefined("attributes.account_id") and len(attributes.account_id)>
					AND (SELECT TOP 1 VP.PAYROLL_ACCOUNT_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN(2,3) ORDER BY VHH.HISTORY_ID DESC) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account_id#" list="yes">)
				</cfif>
				<cfif isdefined("attributes.new_account_id") and len(attributes.new_account_id)>
					AND (SELECT TOP 1 VP.PAYROLL_ACCOUNT_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN(2,3) ORDER BY VHH.HISTORY_ID DESC) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.new_account_id#" list="yes">)
				</cfif>
				<cfif (isdefined("attributes.bloke_member") and attributes.bloke_member eq 1) or attributes.report_type eq 3>
					AND COMP.COMPANY_ID = CR.COMPANY_ID
					AND CR.REQUEST_STATUS = 1
					<cfif len(attributes.lawyer_name) and len(attributes.lawyer_id)>
						AND CR.LAW_ADWOCATE = #attributes.lawyer_id#
					</cfif>
				<cfelseif isdefined("attributes.bloke_member") and attributes.bloke_member eq 2>
					AND COMP.COMPANY_ID NOT IN(SELECT COMPANY_ID FROM #dsn_alias#.COMPANY_LAW_REQUEST WHERE COMPANY_ID IS NOT NULL)
				</cfif>
				<cfif isdefined("kurumsal") and listlen(kurumsal)>
					AND COMP.COMPANY_ID IN
						(
						SELECT 
							C.COMPANY_ID 
						FROM 
							#dsn_alias#.COMPANY C,
							#dsn_alias#.COMPANY_CAT CAT 
						WHERE 
							C.COMPANYCAT_ID = CAT.COMPANYCAT_ID AND
							(
								<cfloop list="#kurumsal#" delimiters="," index="cat_i">
									(CAT.COMPANYCAT_ID = #listlast(cat_i,'-')#)
									<cfif cat_i neq listlast(kurumsal,',') and listlen(kurumsal,',') gte 1> OR</cfif>
								</cfloop>  
							)
						)
				</cfif>
				<cfif isDefined("attributes.sales_zones") and len(attributes.sales_zones)>
					AND COMP.SALES_COUNTY = #attributes.sales_zones#
				</cfif>
				<cfif isDefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_code_text)>
					AND COMP.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE= #attributes.pos_code# AND IS_MASTER=1 AND OUR_COMPANY_ID = #session.ep.company_id# AND COMPANY_ID IS NOT NULL)
				</cfif>
				<cfif isDefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.employee)>
					AND VP.REVENUE_COLLECTOR_ID = #attributes.employee_id#
				</cfif>
				<cfif isdate(attributes.start_date)>
					AND V.VOUCHER_DUEDATE >=#attributes.start_date#
				</cfif>
				<cfif isdate(attributes.finish_date)>
					AND V.VOUCHER_DUEDATE <=#attributes.finish_date#
				</cfif>
                <cfif isdefined("attributes.is_interest_show")>
                	AND DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE()) > 0
                </cfif>
				<cfif len(attributes.record_date1) and isdate(attributes.record_date1)>
					AND V.RECORD_DATE >=#attributes.record_date1#
				</cfif>
				<cfif len(attributes.record_date2) and isdate(attributes.record_date2)>
					AND V.RECORD_DATE < #DATEADD('d',1,attributes.record_date2)#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.company_id)>
					AND V.COMPANY_ID = #attributes.company_id#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.consumer_id)>
					AND V.CONSUMER_ID = #attributes.consumer_id#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.employee_id_)>
					AND V.EMPLOYEE_ID = #attributes.employee_id_#
				</cfif>
				<cfif len(trim(attributes.company2)) and len(attributes.company_id2)>
					AND (SELECT TOP 1 VP.COMPANY_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS = 4 ORDER BY VHH.HISTORY_ID DESC) = #attributes.company_id2#
				</cfif>
				<cfif len(attributes.status)>
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							AND ISNULL((SELECT VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID IN(SELECT ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_TYPE = 107)),V.VOUCHER_STATUS_ID) IN (#attributes.status#)
						<cfelseif len(attributes.action_date2)>
							AND ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) IN (#attributes.status#)
						<cfelse>	
							AND V.VOUCHER_STATUS_ID IN (#attributes.status#)
						</cfif>
					<cfelse>	
						AND V.VOUCHER_STATUS_ID IN (#attributes.status#)
					</cfif>
				</cfif>
				<cfif attributes.report_type eq 4>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						AND CASH.CASH_ID = ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						AND CASH.CASH_ID = ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						)
					<cfelse>
						AND CASH.CASH_ID = V.CASH_ID
					</cfif>
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							AND ISNULL((SELECT VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID IN(SELECT ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_TYPE = 107)),V.VOUCHER_STATUS_ID) = 1
						<cfelseif len(attributes.action_date2)>
							AND ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) = 1
						<cfelse>	
							AND V.VOUCHER_STATUS_ID = 1
						</cfif>
					<cfelse>	
						AND V.VOUCHER_STATUS_ID = 1
					</cfif>
				</cfif>
				<cfif len(attributes.action_date1) and isdate(attributes.action_date1)>
					AND V.VOUCHER_ID IN(SELECT VH.VOUCHER_ID FROM VOUCHER_HISTORY VH WHERE <cfif len(attributes.status)>VH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(VH.ACT_DATE,DATEADD(day,-1,VH.RECORD_DATE)) >=#attributes.action_date1#) AND V.VOUCHER_ID = VH.VOUCHER_ID)
				</cfif>
				<cfif len(attributes.action_date2) and isdate(attributes.action_date2)>
					AND V.VOUCHER_ID IN(SELECT VH.VOUCHER_ID FROM VOUCHER_HISTORY VH WHERE <cfif len(attributes.status)>VH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(VH.ACT_DATE,DATEADD(day,-1,VH.RECORD_DATE)) <= #attributes.action_date2#) AND V.VOUCHER_ID = VH.VOUCHER_ID)
				</cfif>
				<cfif isdefined("attributes.is_open_acts")>
					AND VP.PAYROLL_NO='-1'
				</cfif>
				<cfif len(attributes.owner_company) and len(attributes.owner_company_id) and attributes.owner_member_type eq 'partner'>
					AND V.OWNER_COMPANY_ID = #attributes.owner_company_id#
				<cfelseif len(attributes.owner_company) and len(attributes.owner_consumer_id) and attributes.owner_member_type eq 'consumer'>
					AND V.OWNER_CONSUMER_ID = #attributes.owner_consumer_id#
				<cfelseif len(attributes.owner_company) and len(attributes.owner_employee_id) and attributes.owner_member_type eq 'employee'>
					AND V.OWNER_EMPLOYEE_ID = #attributes.owner_employee_id#
				</cfif>
			<cfif attributes.report_type neq 1>	
				GROUP BY
			</cfif>
			<cfif attributes.report_type eq 2>
				VP.COMPANY_ID,
				COMP.NICKNAME,
				COMP.MEMBER_CODE,
				V.VOUCHER_ID,
				COMP.OZEL_KOD
				<cfif isdefined("attributes.is_other_money")>
				,V.CURRENCY_ID
				</cfif>
				<cfif isdefined("attributes.bloke_member") and attributes.bloke_member eq 1>
				,CR.FILE_NUMBER
				,CR.LAW_ADWOCATE
				</cfif>
			 <cfelseif attributes.report_type eq 3>
				CR.LAW_ADWOCATE,
				V.VOUCHER_ID
				<cfif isdefined("attributes.is_other_money")>
				,V.CURRENCY_ID
				</cfif>
			 <cfelseif attributes.report_type eq 4>
				<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
					ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID),
				<cfelseif isdefined("attributes.is_status_info")>
					ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						),
				<cfelse>
					V.CASH_ID,
				</cfif>
				V.VOUCHER_ID,
				CASH.CASH_NAME
				<cfif isdefined("attributes.is_other_money")>
				,V.CURRENCY_ID
				</cfif>
			 <cfelseif attributes.report_type eq 5>
				V.VOUCHER_ID,
				V.VOUCHER_DUEDATE,
				MONTH(V.VOUCHER_DUEDATE),
				YEAR(V.VOUCHER_DUEDATE),
				V.VOUCHER_STATUS_ID
				<cfif isdefined("attributes.is_other_money")>
				,V.CURRENCY_ID
				</cfif>
			 </cfif>
		</cfquery>
		<cfquery name="get_cheque_voucher_9" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
			<!--- senet de company dolu olanlar --->
			SELECT
			    <cfif isdefined("attributes.report_type") and attributes.report_type eq 4>
				(SELECT TOP 1 VP.PAYROLL_TYPE FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY_TYPE,
				(SELECT TOP 1 VP.PAYROLL_NO FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY_NO,
				(SELECT TOP 1 VHH.PAYROLL_ID FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY,
			</cfif>
				(SELECT TOP 1 VP.COMPANY_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS = 4 ORDER BY VHH.HISTORY_ID DESC) AS NEW_COMPANY_ID,
				(SELECT TOP 1 VP.PAYROLL_ACCOUNT_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN(2,3) ORDER BY VHH.HISTORY_ID DESC) AS NEW_ACCOUNT_ID,
				<cfif attributes.report_type eq 1>
					V.ACCOUNT_NO,
					V.VOUCHER_ID AS ISLEM_ID,
					V.VOUCHER_CODE AS OZEL_KOD,
					V.VOUCHER_DUEDATE AS DUE_DATE,
					V.VOUCHER_NO AS PAPER_NO,
					'' BANK_NAME,
					'' BANK_BRANCH_NAME,
					(SELECT TOP 1 VP.PAYROLL_TYPE FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY_TYPE,
				(SELECT TOP 1 VP.PAYROLL_NO FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY_NO,
				(SELECT TOP 1 VHH.PAYROLL_ID FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY,
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							ISNULL((SELECT VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID IN(SELECT ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_TYPE = 107)),V.VOUCHER_STATUS_ID) AS STATUS,
						<cfelseif len(attributes.action_date2)>
							ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) AS STATUS,
						<cfelse>	
							V.VOUCHER_STATUS_ID AS STATUS,
						</cfif>
					<cfelse>	
						V.VOUCHER_STATUS_ID AS STATUS,
					</cfif>
					V.DEBTOR_NAME AS DEBTOR_NAME,
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						)
					<cfelse>
						V.CASH_ID
					</cfif> AS CASH_ID,
					VP.PAYROLL_ACCOUNT_ID AS ACCOUNT_ID,
					VP.PAYMENT_ORDER_ID AS ORDER_ID,
					CASE WHEN VOUCHER_STATUS_ID = 3 THEN
						V.DELAY_INTEREST_SYSTEM_VALUE 
					ELSE
						CASE WHEN 
							DATEDIFF(d,VOUCHER_DUEDATE,GETDATE()) > (SELECT SP.DELAY_INTEREST_DAY FROM #dsn_alias#.SETUP_PAYMETHOD SP WHERE SP.PAYMETHOD_ID = VP.PAYMETHOD_ID) 
						THEN
							1
						ELSE
							0
						END	
					END AS GECIKME_TUTAR,
					VP.PAYMETHOD_ID AS PAYMETHOD_ID,
					<!--- <cfif check_our_company.is_remaining_amount eq 1>
						(SELECT OTHER_REMAINING_VALUE FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) OTHER_MONEY_VALUE,
						(SELECT OTHER_REMAINING_VALUE2 FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) OTHER_MONEY_VALUE2,
						(SELECT REMAINING_VALUE FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) OTHER_ACT_VALUE,
					<cfelse> Makın iste��iyle kapatıldı silmeyin Sevda ile konu��ulacak--->
						<cfif isdefined("attributes.is_status_info") and len(attributes.action_date2)>
							CASE WHEN
								ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) <> 3 <!---portfoydeyse --->
							THEN
								V.OTHER_MONEY_VALUE - ISNULL((SELECT (SUM(VC.CLOSED_AMOUNT)) FROM VOUCHER_PAYROLL VP,VOUCHER_CLOSED VC WHERE VC.PAYROLL_ID = VP.ACTION_ID AND VC.ACTION_ID = V.VOUCHER_ID AND ISNULL(VP.PAYROLL_AVG_DUEDATE,DATEADD(day,-1,VP.RECORD_DATE)) <= #attributes.action_date2# GROUP BY VC.ACTION_ID),0)
							ELSE
								V.OTHER_MONEY_VALUE
							END AS OTHER_MONEY_VALUE,
							V.OTHER_MONEY_VALUE2 AS OTHER_MONEY_VALUE2,
							CASE WHEN
								ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) <> 3
							THEN
								V.VOUCHER_VALUE - ISNULL((SELECT (SUM(VC.OTHER_CLOSED_AMOUNT)) FROM VOUCHER_PAYROLL VP,VOUCHER_CLOSED VC WHERE VC.PAYROLL_ID = VP.ACTION_ID AND VC.ACTION_ID = V.VOUCHER_ID AND ISNULL(VP.PAYROLL_AVG_DUEDATE,DATEADD(day,-1,VP.RECORD_DATE)) <= #attributes.action_date2# GROUP BY VC.ACTION_ID),0)
							ELSE
								V.VOUCHER_VALUE
							END AS OTHER_ACT_VALUE,
						<cfelse>
							V.OTHER_MONEY_VALUE AS OTHER_MONEY_VALUE,
							V.OTHER_MONEY_VALUE2 AS OTHER_MONEY_VALUE2,
							V.VOUCHER_VALUE AS OTHER_ACT_VALUE,
						</cfif>
					<!--- </cfif> --->
					V.CURRENCY_ID AS OTHER_MONEY,
					V.COMPANY_ID AS MEMBER_ID,
					COMP.NICKNAME AS MUSTERI,
					COMP.MEMBER_CODE AS MEMBER_CODE,
					COMP.OZEL_KOD AS M_OZEL_KOD,
					0 AS MEMBER_TYPE,
					1 AS TYPE,
                    PR.PROJECT_HEAD,
					(SELECT TOP 1 VH.ACT_DATE FROM VOUCHER_HISTORY VH WHERE VH.VOUCHER_ID=V.VOUCHER_ID <cfif len(attributes.status)>AND VH.STATUS IN(#attributes.status#)</cfif> ORDER BY VH.RECORD_DATE DESC) TAHSILAT_TARIHI
				<cfelseif attributes.report_type eq 2>
					SUM(V.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),V.VOUCHER_DUEDATE)*V.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					<cfif isdefined("attributes.is_other_money")>
						SUM(V.VOUCHER_VALUE) AS TOTAL_AMOUNT_OTHER,
						V.CURRENCY_ID AS OTHER_MONEY,
					</cfif>			
					<cfif isdefined("attributes.is_money2")>
						SUM(V.OTHER_MONEY_VALUE2) AS TOTAL_AMOUNT2,
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						SUM(	
							CASE WHEN 
								V.VOUCHER_STATUS_ID = 3
							THEN	
								V.DELAY_INTEREST_SYSTEM_VALUE
							ELSE
							( 
								CASE WHEN
									DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE()) > SP.DELAY_INTEREST_DAY
								THEN
									(SP.DELAY_INTEREST_RATE*V.OTHER_MONEY_VALUE/30)*DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE())
								ELSE
									0
								END
							)
							END
						) AS TOTAL_GECIKME,
					</cfif>
					<cfif isdefined("attributes.bloke_member") and attributes.bloke_member eq 1>
						CR.FILE_NUMBER,
						CR.LAW_ADWOCATE,
					</cfif>
					V.COMPANY_ID AS MEMBER_ID,
					COMP.NICKNAME AS MUSTERI,
					COMP.MEMBER_CODE AS MEMBER_CODE,
					COMP.OZEL_KOD AS M_OZEL_KOD,
					'' MOBIL_TEL,
					0 AS MEMBER_TYPE
				<cfelseif attributes.report_type eq 3>
					SUM(V.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),V.VOUCHER_DUEDATE)*V.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					<cfif isdefined("attributes.is_other_money")>
						SUM(V.VOUCHER_VALUE) AS TOTAL_AMOUNT_OTHER,
						V.CURRENCY_ID AS OTHER_MONEY,
					</cfif>			
					<cfif isdefined("attributes.is_money2")>
						SUM(V.OTHER_MONEY_VALUE2) AS TOTAL_AMOUNT2,
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						SUM(	
							CASE WHEN
								DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE()) > SP.DELAY_INTEREST_DAY
							THEN
								(SP.DELAY_INTEREST_RATE*V.OTHER_MONEY_VALUE/30)*DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE())
							ELSE
								0
							END
						) AS TOTAL_GECIKME,
					</cfif>
					CR.LAW_ADWOCATE
				<cfelseif attributes.report_type eq 4>
					SUM(V.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),V.VOUCHER_DUEDATE)*V.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					<cfif isdefined("attributes.is_other_money")>
						SUM(V.VOUCHER_VALUE) AS TOTAL_AMOUNT_OTHER,
						V.CURRENCY_ID AS OTHER_MONEY,
					</cfif>			
					<cfif isdefined("attributes.is_money2")>
						SUM(V.OTHER_MONEY_VALUE2) AS TOTAL_AMOUNT2,
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						SUM(	
							CASE WHEN 
								V.VOUCHER_STATUS_ID = 3
							THEN	
								V.DELAY_INTEREST_SYSTEM_VALUE
							ELSE
							( 
								CASE WHEN
									DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE()) > SP.DELAY_INTEREST_DAY
								THEN
									(SP.DELAY_INTEREST_RATE*V.OTHER_MONEY_VALUE/30)*DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE())
								ELSE
									0
								END
							)
							END
						) AS TOTAL_GECIKME,
						SUM(
							CASE WHEN
	
								DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE()) > SP.DELAY_INTEREST_DAY
							THEN
								((DATEDIFF(day,GETDATE(),V.VOUCHER_DUEDATE)*(SP.DELAY_INTEREST_RATE*V.OTHER_MONEY_VALUE/30)))
							ELSE
								0
							END
						) AS TOTAL_GECIKME_VADE,
					</cfif>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						)
					<cfelse>
						V.CASH_ID
					</cfif> AS CASH_ID,
					CASH.CASH_NAME AS CASH_NAME,
					0 AS TOTAL_AMOUNT_ICRA,
					0 AS AVG_DUEDATE_ICRA,
					0 AS TOTAL_AMOUNT_VADE,
					0 AS AVG_DUEDATE_VADE
				<cfelseif attributes.report_type eq 5>
					SUM(V.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),V.VOUCHER_DUEDATE)*V.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					V.VOUCHER_DUEDATE AS DUE_DATE,
					MONTH(V.VOUCHER_DUEDATE) AS MONTH_DUE,
					YEAR(V.VOUCHER_DUEDATE) AS YEAR_DUE,
					V.VOUCHER_STATUS_ID AS STATUS
					<cfif isdefined("attributes.is_other_money")>
						,SUM(V.VOUCHER_VALUE) AS TOTAL_AMOUNT_OTHER
						,V.CURRENCY_ID AS OTHER_MONEY
					</cfif>	
				</cfif>
			FROM
				VOUCHER V,
				VOUCHER_PAYROLL VP
                <cfif attributes.report_type eq 1>
                	LEFT JOIN #dsn_alias#.PRO_PROJECTS PR ON VP.PROJECT_ID = PR.PROJECT_ID
                </cfif>,
				#dsn_alias#.COMPANY COMP
				<cfif (isdefined("attributes.bloke_member") and attributes.bloke_member eq 1) or attributes.report_type eq 3>
					,#dsn_alias#.COMPANY_LAW_REQUEST CR
				</cfif>
				<cfif isdefined("attributes.is_interest")>
					,#dsn_alias#.SETUP_PAYMETHOD SP	
				</cfif>
				<cfif attributes.report_type eq 4>
					,CASH
				</cfif>
			WHERE
				V.VOUCHER_PAYROLL_ID = VP.ACTION_ID
				AND VP.PAYROLL_TYPE = 107
				AND VP.COMPANY_ID IS NULL
				AND VP.CONSUMER_ID IS NULL
				AND V.COMPANY_ID = COMP.COMPANY_ID
				AND V.OTHER_MONEY_VALUE > 0
				<cfif not isdefined("attributes.is_pay_term")>
					AND V.IS_PAY_TERM = 0
				<cfelseif isdefined("attributes.is_pay_term") and not isdefined("attributes.is_voucher")>	
					AND V.IS_PAY_TERM = 1
				</cfif>
				<cfif isdefined("attributes.is_interest")>
					AND VP.PAYMETHOD_ID = SP.PAYMETHOD_ID
				</cfif>
				<cfif isdefined("attributes.cash_id") and len(attributes.cash_id)>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						AND ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID) = #attributes.cash_id#
					<cfelseif isdefined("attributes.is_status_info")>
						AND ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						) = #attributes.cash_id#
					<cfelse>
						AND V.CASH_ID = #attributes.cash_id#
					</cfif>
				</cfif>
				<cfif isdefined("attributes.account_id") and len(attributes.account_id)>
					AND (SELECT TOP 1 VP.PAYROLL_ACCOUNT_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN(2,3) ORDER BY VHH.HISTORY_ID DESC) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account_id#" list="yes">)
				</cfif>
				<cfif isdefined("attributes.new_account_id") and len(attributes.new_account_id)>
					AND (SELECT TOP 1 VP.PAYROLL_ACCOUNT_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN(2,3) ORDER BY VHH.HISTORY_ID DESC) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.new_account_id#" list="yes">)
				</cfif>
				<cfif (isdefined("attributes.bloke_member") and attributes.bloke_member eq 1) or attributes.report_type eq 3>
					AND COMP.COMPANY_ID = CR.COMPANY_ID
					AND CR.REQUEST_STATUS = 1
					<cfif len(attributes.lawyer_name) and len(attributes.lawyer_id)>
						AND CR.LAW_ADWOCATE = #attributes.lawyer_id#
					</cfif>
				<cfelseif isdefined("attributes.bloke_member") and attributes.bloke_member eq 2>
					AND COMP.COMPANY_ID NOT IN(SELECT COMPANY_ID FROM #dsn_alias#.COMPANY_LAW_REQUEST WHERE COMPANY_ID IS NOT NULL)
				</cfif>
				<cfif isdefined("kurumsal") and listlen(kurumsal)>
					AND COMP.COMPANY_ID IN
						(
						SELECT 
							C.COMPANY_ID 
						FROM 
							#dsn_alias#.COMPANY C,
							#dsn_alias#.COMPANY_CAT CAT 
						WHERE 
							C.COMPANYCAT_ID = CAT.COMPANYCAT_ID AND
							(
								<cfloop list="#kurumsal#" delimiters="," index="cat_i">
									(CAT.COMPANYCAT_ID = #listlast(cat_i,'-')#)
									<cfif cat_i neq listlast(kurumsal,',') and listlen(kurumsal,',') gte 1> OR</cfif>
								</cfloop>  
							)
						)
				</cfif>
				<cfif isDefined("attributes.sales_zones") and len(attributes.sales_zones)>
					AND COMP.SALES_COUNTY = #attributes.sales_zones#
				</cfif>
				<cfif isDefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_code_text)>
					AND COMP.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE= #attributes.pos_code# AND IS_MASTER=1 AND OUR_COMPANY_ID = #session.ep.company_id# AND COMPANY_ID IS NOT NULL)
				</cfif>
				<cfif isDefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.employee)>
					AND VP.REVENUE_COLLECTOR_ID = #attributes.employee_id#
				</cfif>
				<cfif isdate(attributes.start_date)>
					AND V.VOUCHER_DUEDATE >=#attributes.start_date#
				</cfif>
				<cfif isdate(attributes.finish_date)>
					AND V.VOUCHER_DUEDATE <=#attributes.finish_date#
				</cfif>
                 <cfif isdefined("attributes.is_interest_show")>
                	AND DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE()) > 0
                </cfif>
				<cfif len(attributes.record_date1) and isdate(attributes.record_date1)>
					AND V.RECORD_DATE >=#attributes.record_date1#
				</cfif>
				<cfif len(attributes.record_date2) and isdate(attributes.record_date2)>
					AND V.RECORD_DATE < #DATEADD('d',1,attributes.record_date2)#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.company_id)>
					AND V.COMPANY_ID = #attributes.company_id#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.consumer_id)>
					AND V.CONSUMER_ID = #attributes.consumer_id#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.employee_id_)>
					AND V.EMPLOYEE_ID = #attributes.employee_id_#
				</cfif>
				<cfif len(trim(attributes.company2)) and len(attributes.company_id2)>
					AND (SELECT TOP 1 VP.COMPANY_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS = 4 ORDER BY VHH.HISTORY_ID DESC) = #attributes.company_id2#
				</cfif>
				<cfif len(attributes.status)>
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							AND ISNULL((SELECT VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID IN(SELECT ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_TYPE = 107)),V.VOUCHER_STATUS_ID) IN (#attributes.status#)
						<cfelseif len(attributes.action_date2)>
							AND ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) IN (#attributes.status#)
						<cfelse>	
							AND V.VOUCHER_STATUS_ID IN (#attributes.status#)
						</cfif>
					<cfelse>	
						AND V.VOUCHER_STATUS_ID IN (#attributes.status#)
					</cfif>
				</cfif>
				<cfif attributes.report_type eq 4>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						AND CASH.CASH_ID = ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						ADN CASH.CASH_ID = ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						)
					<cfelse>
						AND CASH.CASH_ID = V.CASH_ID
					</cfif>
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							AND ISNULL((SELECT VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID IN(SELECT ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_TYPE = 107)),V.VOUCHER_STATUS_ID)=1
						<cfelseif len(attributes.action_date2)>
							AND ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID)=1
						<cfelse>	
							AND V.VOUCHER_STATUS_ID=1
						</cfif>
					<cfelse>	
						AND V.VOUCHER_STATUS_ID=1
					</cfif>
				</cfif>
				<cfif len(attributes.action_date1) and isdate(attributes.action_date1)>
					AND V.VOUCHER_ID IN(SELECT VH.VOUCHER_ID FROM VOUCHER_HISTORY VH WHERE <cfif len(attributes.status)>VH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(VH.ACT_DATE,DATEADD(day,-1,VH.RECORD_DATE)) >=#attributes.action_date1#) AND V.VOUCHER_ID = VH.VOUCHER_ID)
				</cfif>
				<cfif len(attributes.action_date2) and isdate(attributes.action_date2)>
					AND V.VOUCHER_ID IN(SELECT VH.VOUCHER_ID FROM VOUCHER_HISTORY VH WHERE <cfif len(attributes.status)>VH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(VH.ACT_DATE,DATEADD(day,-1,VH.RECORD_DATE)) <= #attributes.action_date2#) AND V.VOUCHER_ID = VH.VOUCHER_ID)
				</cfif>
				<cfif isdefined("attributes.is_open_acts")>
					AND VP.PAYROLL_NO='-1'
				</cfif>
				<cfif len(attributes.owner_company) and len(attributes.owner_company_id) and attributes.owner_member_type eq 'partner'>
					AND V.OWNER_COMPANY_ID = #attributes.owner_company_id#
				<cfelseif len(attributes.owner_company) and len(attributes.owner_consumer_id) and attributes.owner_member_type eq 'consumer'>
					AND V.OWNER_CONSUMER_ID = #attributes.owner_consumer_id#
				<cfelseif len(attributes.owner_company) and len(attributes.owner_employee_id) and attributes.owner_member_type eq 'employee'>
					AND V.OWNER_EMPLOYEE_ID = #attributes.owner_employee_id#
				</cfif>
			<cfif attributes.report_type neq 1>	
				GROUP BY
			</cfif>
			<cfif attributes.report_type eq 2>
				V.COMPANY_ID,
				COMP.NICKNAME,
				COMP.MEMBER_CODE,
				V.VOUCHER_ID,
				COMP.OZEL_KOD
				<cfif isdefined("attributes.is_other_money")>
				,V.CURRENCY_ID
				</cfif>
				<cfif isdefined("attributes.bloke_member") and attributes.bloke_member eq 1>
				,CR.FILE_NUMBER
				,CR.LAW_ADWOCATE
				</cfif>
			 <cfelseif attributes.report_type eq 3>
				CR.LAW_ADWOCATE,
				V.VOUCHER_ID
				<cfif isdefined("attributes.is_other_money")>
				,V.CURRENCY_ID
				</cfif>
			 <cfelseif attributes.report_type eq 4>
				<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
					ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID),
				<cfelseif isdefined("attributes.is_status_info")>
					ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						),
				<cfelse>
					V.CASH_ID,
				</cfif>
				V.VOUCHER_ID,
				CASH.CASH_NAME
				<cfif isdefined("attributes.is_other_money")>
				,V.CURRENCY_ID
				</cfif>
			 <cfelseif attributes.report_type eq 5>
				V.VOUCHER_ID,
				V.VOUCHER_DUEDATE,
				MONTH(V.VOUCHER_DUEDATE),
				YEAR(V.VOUCHER_DUEDATE),
				V.VOUCHER_STATUS_ID
				<cfif isdefined("attributes.is_other_money")>
				,V.CURRENCY_ID
				</cfif>
			 </cfif>
		</cfquery>		
	</cfif>
	<cfif len(bireysel) or not len(kurumsal)>
		<cfquery name="get_cheque_voucher_8" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
			<!--- consumer dolu olanlar --->
			SELECT
			<cfif isdefined("attributes.report_type") and attributes.report_type eq 4>
				(SELECT TOP 1 VP.PAYROLL_TYPE FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY_TYPE,
				(SELECT TOP 1 VP.PAYROLL_NO FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY_NO,
				(SELECT TOP 1 VHH.PAYROLL_ID FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY,
			</cfif>
				(SELECT TOP 1 VP.COMPANY_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS = 4 ORDER BY VHH.HISTORY_ID DESC) AS NEW_COMPANY_ID,
				(SELECT TOP 1 VP.PAYROLL_ACCOUNT_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN(2,3) ORDER BY VHH.HISTORY_ID DESC) AS NEW_ACCOUNT_ID,
				<cfif attributes.report_type eq 1>
					V.ACCOUNT_NO,
					V.VOUCHER_ID AS ISLEM_ID,
					V.VOUCHER_CODE AS OZEL_KOD,
					V.VOUCHER_DUEDATE AS DUE_DATE,
					V.VOUCHER_NO AS PAPER_NO,
					'' BANK_NAME,
					'' BANK_BRANCH_NAME,
					(SELECT TOP 1 VP.PAYROLL_TYPE FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY_TYPE,
				(SELECT TOP 1 VP.PAYROLL_NO FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY_NO,
				(SELECT TOP 1 VHH.PAYROLL_ID FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY,
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							ISNULL((SELECT VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID IN(SELECT ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_TYPE = 107)),V.VOUCHER_STATUS_ID) AS STATUS,
						<cfelseif len(attributes.action_date2)>
							ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) AS STATUS,
						<cfelse>	
							V.VOUCHER_STATUS_ID AS STATUS,
						</cfif>
					<cfelse>	
						V.VOUCHER_STATUS_ID AS STATUS,
					</cfif>
					V.DEBTOR_NAME AS DEBTOR_NAME,
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						)
					<cfelse>
						V.CASH_ID
					</cfif> AS CASH_ID,
					VP.PAYROLL_ACCOUNT_ID AS ACCOUNT_ID,
					VP.PAYMENT_ORDER_ID AS ORDER_ID,
					CASE WHEN VOUCHER_STATUS_ID = 3 THEN
						V.DELAY_INTEREST_SYSTEM_VALUE 
					ELSE
						CASE WHEN 
							DATEDIFF(d,VOUCHER_DUEDATE,GETDATE()) > (SELECT SP.DELAY_INTEREST_DAY FROM #dsn_alias#.SETUP_PAYMETHOD SP WHERE SP.PAYMETHOD_ID = VP.PAYMETHOD_ID) 
						THEN
							1
						ELSE
							0
						END	
					END AS GECIKME_TUTAR,
					VP.PAYMETHOD_ID AS PAYMETHOD_ID,
					<!--- <cfif check_our_company.is_remaining_amount eq 1>
						(SELECT OTHER_REMAINING_VALUE FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) OTHER_MONEY_VALUE,
						(SELECT OTHER_REMAINING_VALUE2 FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) OTHER_MONEY_VALUE2,
						(SELECT REMAINING_VALUE FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) OTHER_ACT_VALUE,
					<cfelse> Makın iste��iyle kapatıldı silmeyin Sevda ile konu��ulacak--->
						<cfif isdefined("attributes.is_status_info") and len(attributes.action_date2)>
							CASE WHEN
								ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) <> 3 <!---portfoydeyse --->
							THEN
								V.OTHER_MONEY_VALUE - ISNULL((SELECT (SUM(VC.CLOSED_AMOUNT)) FROM VOUCHER_PAYROLL VP,VOUCHER_CLOSED VC WHERE VC.PAYROLL_ID = VP.ACTION_ID AND VC.ACTION_ID = V.VOUCHER_ID AND ISNULL(VP.PAYROLL_AVG_DUEDATE,DATEADD(day,-1,VP.RECORD_DATE)) <= #attributes.action_date2# GROUP BY VC.ACTION_ID),0)
							ELSE
								V.OTHER_MONEY_VALUE
							END AS OTHER_MONEY_VALUE,
							V.OTHER_MONEY_VALUE2 AS OTHER_MONEY_VALUE2,
							CASE WHEN
								ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) <> 3
							THEN
								V.VOUCHER_VALUE -ISNULL((SELECT ( SUM(VC.OTHER_CLOSED_AMOUNT)) FROM VOUCHER_PAYROLL VP,VOUCHER_CLOSED VC WHERE VC.PAYROLL_ID = VP.ACTION_ID AND VC.ACTION_ID = V.VOUCHER_ID AND ISNULL(VP.PAYROLL_AVG_DUEDATE,DATEADD(day,-1,VP.RECORD_DATE)) <= #attributes.action_date2# GROUP BY VC.ACTION_ID),0)
							ELSE
								V.VOUCHER_VALUE
							END AS OTHER_ACT_VALUE,
						<cfelse>
							V.OTHER_MONEY_VALUE AS OTHER_MONEY_VALUE,
							V.OTHER_MONEY_VALUE2 AS OTHER_MONEY_VALUE2,
							V.VOUCHER_VALUE AS OTHER_ACT_VALUE,
						</cfif>
					<!--- </cfif> --->
					V.CURRENCY_ID AS OTHER_MONEY,
					VP.CONSUMER_ID AS MEMBER_ID,
					(CONS.CONSUMER_NAME+ ' ' + CONS.CONSUMER_SURNAME) AS MUSTERI,
					CONS.MEMBER_CODE AS MEMBER_CODE,
					CONS.OZEL_KOD AS M_OZEL_KOD,
					1 AS MEMBER_TYPE,
					1 AS TYPE,
                    PR.PROJECT_HEAD,
					(SELECT TOP 1 VH.ACT_DATE FROM VOUCHER_HISTORY VH WHERE VH.VOUCHER_ID=V.VOUCHER_ID <cfif len(attributes.status)>AND VH.STATUS IN(#attributes.status#)</cfif> ORDER BY VH.RECORD_DATE DESC) TAHSILAT_TARIHI
				<cfelseif attributes.report_type eq 2>
					SUM(V.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),V.VOUCHER_DUEDATE)*V.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					<cfif isdefined("attributes.is_other_money")>
						SUM(V.VOUCHER_VALUE) AS TOTAL_AMOUNT_OTHER,
						V.CURRENCY_ID AS OTHER_MONEY,
					</cfif>			
					<cfif isdefined("attributes.is_money2")>
						SUM(V.OTHER_MONEY_VALUE2) AS TOTAL_AMOUNT2,
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						SUM(	
							CASE WHEN 
								V.VOUCHER_STATUS_ID = 3
							THEN	
								V.DELAY_INTEREST_SYSTEM_VALUE
							ELSE
							( 
								CASE WHEN
									DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE()) > SP.DELAY_INTEREST_DAY
								THEN
									(SP.DELAY_INTEREST_RATE*V.OTHER_MONEY_VALUE/30)*DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE())
								ELSE
									0
								END
							)
							END
						) AS TOTAL_GECIKME,
					</cfif>
					<cfif isdefined("attributes.bloke_member") and attributes.bloke_member eq 1>
						CR.FILE_NUMBER,
						CR.LAW_ADWOCATE,
					</cfif>
					VP.CONSUMER_ID AS MEMBER_ID,
					(CONS.CONSUMER_NAME+ ' ' + CONS.CONSUMER_SURNAME) AS MUSTERI,
					CONS.MEMBER_CODE AS MEMBER_CODE,
					CONS.OZEL_KOD AS M_OZEL_KOD,
					('0'+CONS.MOBIL_CODE+ '' + CONS.MOBILTEL) AS  MOBIL_TEL,
					1 AS MEMBER_TYPE
				<cfelseif attributes.report_type eq 3>
					SUM(V.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),V.VOUCHER_DUEDATE)*V.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					<cfif isdefined("attributes.is_other_money")>
						SUM(V.VOUCHER_VALUE) AS TOTAL_AMOUNT_OTHER,
						V.CURRENCY_ID AS OTHER_MONEY,
					</cfif>			
					<cfif isdefined("attributes.is_money2")>
						SUM(V.OTHER_MONEY_VALUE2) AS TOTAL_AMOUNT2,
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						SUM(	
							CASE WHEN 
								V.VOUCHER_STATUS_ID = 3
							THEN	
								V.DELAY_INTEREST_SYSTEM_VALUE
							ELSE
							( 
								CASE WHEN
									DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE()) > SP.DELAY_INTEREST_DAY
								THEN
									(SP.DELAY_INTEREST_RATE*V.OTHER_MONEY_VALUE/30)*DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE())
								ELSE
									0
								END
							)
							END
						) AS TOTAL_GECIKME,
					</cfif>
					CR.LAW_ADWOCATE
				<cfelseif attributes.report_type eq 4>
					SUM(V.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),V.VOUCHER_DUEDATE)*V.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					<cfif isdefined("attributes.is_other_money")>
						SUM(V.VOUCHER_VALUE) AS TOTAL_AMOUNT_OTHER,
						V.CURRENCY_ID AS OTHER_MONEY,
					</cfif>			
					<cfif isdefined("attributes.is_money2")>
						SUM(V.OTHER_MONEY_VALUE2) AS TOTAL_AMOUNT2,
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						SUM(	
							CASE WHEN 
								V.VOUCHER_STATUS_ID = 3
							THEN	
								V.DELAY_INTEREST_SYSTEM_VALUE
							ELSE
							( 
								CASE WHEN
									DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE()) > SP.DELAY_INTEREST_DAY
								THEN
									(SP.DELAY_INTEREST_RATE*V.OTHER_MONEY_VALUE/30)*DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE())
								ELSE
									0
								END
							)
							END
						) AS TOTAL_GECIKME,
						SUM(
							CASE WHEN
								DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE()) > SP.DELAY_INTEREST_DAY
							THEN
								((DATEDIFF(day,GETDATE(),V.VOUCHER_DUEDATE)*(SP.DELAY_INTEREST_RATE*V.OTHER_MONEY_VALUE/30)))
							ELSE
								0
							END
						) AS TOTAL_GECIKME_VADE,
					</cfif>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						)
					<cfelse>
						V.CASH_ID
					</cfif> AS CASH_ID,
					CASH.CASH_NAME AS CASH_NAME,
					0 AS TOTAL_AMOUNT_ICRA,
					0 AS AVG_DUEDATE_ICRA,
					0 AS TOTAL_AMOUNT_VADE,
					0 AS AVG_DUEDATE_VADE
				<cfelseif attributes.report_type eq 5>
					SUM(V.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),V.VOUCHER_DUEDATE)*V.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					V.VOUCHER_DUEDATE AS DUE_DATE,
					MONTH(V.VOUCHER_DUEDATE) AS MONTH_DUE,
					YEAR(V.VOUCHER_DUEDATE) AS YEAR_DUE,
					V.VOUCHER_STATUS_ID AS STATUS
					<cfif isdefined("attributes.is_other_money")>
						,SUM(V.VOUCHER_VALUE) AS TOTAL_AMOUNT_OTHER
						,V.CURRENCY_ID AS OTHER_MONEY
					</cfif>
				</cfif>
			FROM
				VOUCHER V,
				VOUCHER_PAYROLL VP
                <cfif attributes.report_type eq 1>
                	LEFT JOIN #dsn_alias#.PRO_PROJECTS PR ON VP.PROJECT_ID = PR.PROJECT_ID
                </cfif>,
				#dsn_alias#.CONSUMER CONS
				<cfif (isdefined("attributes.bloke_member") and attributes.bloke_member eq 1) or attributes.report_type eq 3>
					,#dsn_alias#.COMPANY_LAW_REQUEST CR
				</cfif>
				<cfif isdefined("attributes.is_interest")>
					,#dsn_alias#.SETUP_PAYMETHOD SP	
				</cfif>
				<cfif attributes.report_type eq 4>
					,CASH
				</cfif>
			WHERE
				V.VOUCHER_PAYROLL_ID = VP.ACTION_ID
				AND VP.CONSUMER_ID = CONS.CONSUMER_ID
				AND V.OTHER_MONEY_VALUE > 0
				<cfif not isdefined("attributes.is_pay_term")>
					AND V.IS_PAY_TERM = 0
				<cfelseif isdefined("attributes.is_pay_term") and not isdefined("attributes.is_voucher")>	
					AND V.IS_PAY_TERM = 1
				</cfif>
				<cfif isdefined("attributes.is_interest")>
					AND VP.PAYMETHOD_ID = SP.PAYMETHOD_ID
				</cfif>
				<cfif isdefined("attributes.cash_id") and len(attributes.cash_id)>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						AND ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID) = #attributes.cash_id#
					<cfelseif isdefined("attributes.is_status_info")>
						AND ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						) = #attributes.cash_id#
					<cfelse>
						AND V.CASH_ID = #attributes.cash_id#
					</cfif>
				</cfif>
				<cfif isdefined("attributes.account_id") and len(attributes.account_id)>
					AND (SELECT TOP 1 VP.PAYROLL_ACCOUNT_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN(2,3) ORDER BY VHH.HISTORY_ID DESC) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account_id#" list="yes">)
				</cfif>
				<cfif isdefined("attributes.new_account_id") and len(attributes.new_account_id)>
					AND (SELECT TOP 1 VP.PAYROLL_ACCOUNT_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN(2,3) ORDER BY VHH.HISTORY_ID DESC) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.new_account_id#" list="yes">)
				</cfif>
				<cfif (isdefined("attributes.bloke_member") and attributes.bloke_member eq 1) or attributes.report_type eq 3>
					AND CONS.CONSUMER_ID = CR.CONSUMER_ID
					AND CR.REQUEST_STATUS = 1
					<cfif len(attributes.lawyer_name) and len(attributes.lawyer_id)>
						AND CR.LAW_ADWOCATE = #attributes.lawyer_id#
					</cfif>
				<cfelseif isdefined("attributes.bloke_member") and attributes.bloke_member eq 2>
					AND CONS.CONSUMER_ID NOT IN(SELECT CONSUMER_ID FROM #dsn_alias#.COMPANY_LAW_REQUEST WHERE CONSUMER_ID IS NOT NULL)

				</cfif>

				<cfif isdefined("bireysel") and listlen(bireysel)>
					AND CONS.CONSUMER_ID IN
						(
						SELECT 
							C.CONSUMER_ID 
						FROM 
							#dsn_alias#.CONSUMER C,
							#dsn_alias#.CONSUMER_CAT CAT 
						WHERE 
							C.CONSUMER_CAT_ID = CAT.CONSCAT_ID AND
							(
								<cfloop list="#bireysel#" delimiters="," index="cat_i">
									(CAT.CONSCAT_ID = #listlast(cat_i,'-')#)
									<cfif cat_i neq listlast(bireysel,',') and listlen(bireysel,',') gte 1> OR</cfif>
								</cfloop>  
							)
						)
				</cfif>
				<cfif isDefined("attributes.sales_zones") and len(attributes.sales_zones)>
					AND CONS.SALES_COUNTY = #attributes.sales_zones#
				</cfif>
				<cfif isdefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_code_text)>
					AND CONS.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE= #attributes.pos_code# AND IS_MASTER=1 AND OUR_COMPANY_ID = #session.ep.company_id# AND CONSUMER_ID IS NOT NULL)
				</cfif>
				<cfif isDefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.employee)>
					AND VP.REVENUE_COLLECTOR_ID = #attributes.employee_id#
				</cfif>
				<cfif isdate(attributes.start_date)>
					AND V.VOUCHER_DUEDATE >=#attributes.start_date#
				</cfif>
				<cfif isdate(attributes.finish_date)>
					AND V.VOUCHER_DUEDATE <=#attributes.finish_date#
				</cfif>
                 <cfif isdefined("attributes.is_interest_show")>
                	AND DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE()) > 0
                </cfif>
				<cfif len(attributes.record_date1) and isdate(attributes.record_date1)>
					AND V.RECORD_DATE >=#attributes.record_date1#
				</cfif>
				<cfif len(attributes.record_date2) and isdate(attributes.record_date2)>
					AND V.RECORD_DATE < #DATEADD('d',1,attributes.record_date2)#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.company_id)>
					AND V.COMPANY_ID = #attributes.company_id#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.consumer_id)>
					AND V.CONSUMER_ID = #attributes.consumer_id#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.employee_id_)>
					AND V.EMPLOYEE_ID = #attributes.employee_id_#
				</cfif>
				<cfif len(trim(attributes.company2)) and len(attributes.company_id2)>
					AND (SELECT TOP 1 VP.COMPANY_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS = 4 ORDER BY VHH.HISTORY_ID DESC) = #attributes.company_id2#
				</cfif>
				<cfif len(attributes.status)>
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							AND ISNULL((SELECT VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID IN(SELECT ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_TYPE = 107)),V.VOUCHER_STATUS_ID) IN (#attributes.status#)
						<cfelseif len(attributes.action_date2)>
							AND ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) IN (#attributes.status#)
						<cfelse>	
							AND V.VOUCHER_STATUS_ID IN (#attributes.status#)
						</cfif>
					<cfelse>	
						AND V.VOUCHER_STATUS_ID IN (#attributes.status#)
					</cfif>
				</cfif>
				<cfif attributes.report_type eq 4>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						AND CASH.CASH_ID = ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						AND CASH.CASH_ID = ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						)
					<cfelse>
						AND CASH.CASH_ID = V.CASH_ID
					</cfif>
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							AND ISNULL((SELECT VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID IN(SELECT ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_TYPE = 107)),V.VOUCHER_STATUS_ID)=1
						<cfelseif len(attributes.action_date2)>
							AND ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID)=1
						<cfelse>	
							AND V.VOUCHER_STATUS_ID=1
						</cfif>
					<cfelse>	
						AND V.VOUCHER_STATUS_ID =1
					</cfif>
				</cfif>
				<cfif len(attributes.action_date1) and isdate(attributes.action_date1)>
					AND V.VOUCHER_ID IN(SELECT VH.VOUCHER_ID FROM VOUCHER_HISTORY VH WHERE <cfif len(attributes.status)>VH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(VH.ACT_DATE,DATEADD(day,-1,VH.RECORD_DATE)) >=#attributes.action_date1#) AND V.VOUCHER_ID = VH.VOUCHER_ID)
				</cfif>
				<cfif len(attributes.action_date2) and isdate(attributes.action_date2)>
					AND V.VOUCHER_ID IN(SELECT VH.VOUCHER_ID FROM VOUCHER_HISTORY VH WHERE <cfif len(attributes.status)>VH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(VH.ACT_DATE,DATEADD(day,-1,VH.RECORD_DATE)) <= #attributes.action_date2#) AND V.VOUCHER_ID = VH.VOUCHER_ID)
				</cfif>
				<cfif isdefined("attributes.is_open_acts")>
					AND VP.PAYROLL_NO='-1'
				</cfif>
				<cfif len(attributes.owner_company) and len(attributes.owner_company_id) and attributes.owner_member_type eq 'partner'>
					AND V.OWNER_COMPANY_ID = #attributes.owner_company_id#
				<cfelseif len(attributes.owner_company) and len(attributes.owner_consumer_id) and attributes.owner_member_type eq 'consumer'>
					AND V.OWNER_CONSUMER_ID = #attributes.owner_consumer_id#
				<cfelseif len(attributes.owner_company) and len(attributes.owner_employee_id) and attributes.owner_member_type eq 'employee'>
					AND V.OWNER_EMPLOYEE_ID = #attributes.owner_employee_id#
				</cfif>
			<cfif attributes.report_type neq 1>	
				GROUP BY
			</cfif>
			<cfif attributes.report_type eq 2>
				VP.CONSUMER_ID,
				V.VOUCHER_ID,
				CONS.CONSUMER_NAME,
				CONS.CONSUMER_SURNAME,
				CONS.MEMBER_CODE,
				CONS.OZEL_KOD,
				CONS.MOBIL_CODE,
				CONS.MOBILTEL
				<cfif isdefined("attributes.is_other_money")>
				,V.CURRENCY_ID
				</cfif>
				<cfif isdefined("attributes.bloke_member") and attributes.bloke_member eq 1>
				,CR.FILE_NUMBER
				,CR.LAW_ADWOCATE
				</cfif>
			<cfelseif attributes.report_type eq 3>
				CR.LAW_ADWOCATE,
				V.VOUCHER_ID
				<cfif isdefined("attributes.is_other_money")>
				,V.CURRENCY_ID
				</cfif>
			<cfelseif attributes.report_type eq 4>
				<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
					ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID),
				<cfelseif isdefined("attributes.is_status_info")>
					ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						),
				<cfelse>
					V.CASH_ID,
				</cfif>
				V.VOUCHER_ID,
				CASH.CASH_NAME
				<cfif isdefined("attributes.is_other_money")>
				,V.CURRENCY_ID
				</cfif>
			<cfelseif attributes.report_type eq 5>
				V.VOUCHER_ID,
				V.VOUCHER_DUEDATE,
				MONTH(V.VOUCHER_DUEDATE),
				YEAR(V.VOUCHER_DUEDATE),
				V.VOUCHER_STATUS_ID
				<cfif isdefined("attributes.is_other_money")>
				,V.CURRENCY_ID
				</cfif>
			</cfif>
		</cfquery>
		<cfquery name="get_cheque_voucher_10" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
			<!--- senet de consumer dolu olanlar --->
			SELECT
			    <cfif isdefined("attributes.report_type") and attributes.report_type eq 4>
				(SELECT TOP 1 VP.PAYROLL_TYPE FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY_TYPE,
				(SELECT TOP 1 VP.PAYROLL_NO FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY_NO,
				(SELECT TOP 1 VHH.PAYROLL_ID FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY,
			    </cfif>
				(SELECT TOP 1 VP.COMPANY_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS = 4 ORDER BY VHH.HISTORY_ID DESC) AS NEW_COMPANY_ID,
				(SELECT TOP 1 VP.PAYROLL_ACCOUNT_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN(2,3) ORDER BY VHH.HISTORY_ID DESC) AS NEW_ACCOUNT_ID,
				<cfif attributes.report_type eq 1>
					V.ACCOUNT_NO,
					V.VOUCHER_ID AS ISLEM_ID,
					V.VOUCHER_CODE AS OZEL_KOD,
					V.VOUCHER_DUEDATE AS DUE_DATE,
					V.VOUCHER_NO AS PAPER_NO,
					'' BANK_NAME,
					'' BANK_BRANCH_NAME,
					(SELECT TOP 1 VP.PAYROLL_TYPE FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY_TYPE,
					(SELECT TOP 1 VP.PAYROLL_NO FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY_NO,
					(SELECT TOP 1 VHH.PAYROLL_ID FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY,
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							ISNULL((SELECT VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID IN(SELECT ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_TYPE = 107)),V.VOUCHER_STATUS_ID) AS STATUS,
						<cfelseif len(attributes.action_date2)>
							ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) AS STATUS,
						<cfelse>	
							V.VOUCHER_STATUS_ID AS STATUS,
						</cfif>
					<cfelse>	
						V.VOUCHER_STATUS_ID AS STATUS,
					</cfif>
					V.DEBTOR_NAME AS DEBTOR_NAME,
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						)
					<cfelse>
						V.CASH_ID
					</cfif> AS CASH_ID,
					VP.PAYROLL_ACCOUNT_ID AS ACCOUNT_ID,
					VP.PAYMENT_ORDER_ID AS ORDER_ID,
					CASE WHEN VOUCHER_STATUS_ID = 3 THEN
						V.DELAY_INTEREST_SYSTEM_VALUE 
					ELSE
						CASE WHEN 
							DATEDIFF(d,VOUCHER_DUEDATE,GETDATE()) > (SELECT SP.DELAY_INTEREST_DAY FROM #dsn_alias#.SETUP_PAYMETHOD SP WHERE SP.PAYMETHOD_ID = VP.PAYMETHOD_ID) 
						THEN
							1
						ELSE
							0
						END	
					END AS GECIKME_TUTAR,
					VP.PAYMETHOD_ID AS PAYMETHOD_ID,
					<!--- <cfif check_our_company.is_remaining_amount eq 1>
						(SELECT OTHER_REMAINING_VALUE FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) OTHER_MONEY_VALUE,
						(SELECT OTHER_REMAINING_VALUE2 FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) OTHER_MONEY_VALUE2,
						(SELECT REMAINING_VALUE FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) OTHER_ACT_VALUE,
					<cfelse> Makın iste��iyle kapatıldı silmeyin Sevda ile konu��ulacak--->
						<cfif isdefined("attributes.is_status_info") and len(attributes.action_date2)>
							CASE WHEN
								ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) <> 3 <!---portfoydeyse --->
							THEN
								V.OTHER_MONEY_VALUE - ISNULL((SELECT (SUM(VC.CLOSED_AMOUNT)) FROM VOUCHER_PAYROLL VP,VOUCHER_CLOSED VC WHERE VC.PAYROLL_ID = VP.ACTION_ID AND VC.ACTION_ID = V.VOUCHER_ID AND ISNULL(VP.PAYROLL_AVG_DUEDATE,DATEADD(day,-1,VP.RECORD_DATE)) <= #attributes.action_date2# GROUP BY VC.ACTION_ID),0)
							ELSE
								V.OTHER_MONEY_VALUE
							END AS OTHER_MONEY_VALUE,
							V.OTHER_MONEY_VALUE2 AS OTHER_MONEY_VALUE2,
							CASE WHEN
								ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) <> 3
							THEN
								V.VOUCHER_VALUE - ISNULL((SELECT (SUM(VC.OTHER_CLOSED_AMOUNT)) FROM VOUCHER_PAYROLL VP,VOUCHER_CLOSED VC WHERE VC.PAYROLL_ID = VP.ACTION_ID AND VC.ACTION_ID = V.VOUCHER_ID AND ISNULL(VP.PAYROLL_AVG_DUEDATE,DATEADD(day,-1,VP.RECORD_DATE)) <= #attributes.action_date2# GROUP BY VC.ACTION_ID),0)
							ELSE
								V.VOUCHER_VALUE
							END AS OTHER_ACT_VALUE,
						<cfelse>
							V.OTHER_MONEY_VALUE AS OTHER_MONEY_VALUE,
							V.OTHER_MONEY_VALUE2 AS OTHER_MONEY_VALUE2,
							V.VOUCHER_VALUE AS OTHER_ACT_VALUE,
						</cfif>
					<!--- </cfif> --->
					V.CURRENCY_ID AS OTHER_MONEY,
					CONS.CONSUMER_ID AS MEMBER_ID,
					(CONS.CONSUMER_NAME+ ' ' + CONS.CONSUMER_SURNAME) AS MUSTERI,
					CONS.MEMBER_CODE AS MEMBER_CODE,
					CONS.OZEL_KOD AS M_OZEL_KOD,
					1 AS MEMBER_TYPE,
					1 AS TYPE,
                    PR.PROJECT_HEAD,
					(SELECT TOP 1 VH.ACT_DATE FROM VOUCHER_HISTORY VH WHERE VH.VOUCHER_ID=V.VOUCHER_ID <cfif len(attributes.status)>AND VH.STATUS IN(#attributes.status#)</cfif> ORDER BY VH.RECORD_DATE DESC) TAHSILAT_TARIHI
				<cfelseif attributes.report_type eq 2>
					SUM(V.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),V.VOUCHER_DUEDATE)*V.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					<cfif isdefined("attributes.is_other_money")>
						SUM(V.VOUCHER_VALUE) AS TOTAL_AMOUNT_OTHER,
						V.CURRENCY_ID AS OTHER_MONEY,
					</cfif>			
					<cfif isdefined("attributes.is_money2")>
						SUM(V.OTHER_MONEY_VALUE2) AS TOTAL_AMOUNT2,
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						SUM(	
							CASE WHEN 
								V.VOUCHER_STATUS_ID = 3
							THEN	
								V.DELAY_INTEREST_SYSTEM_VALUE
							ELSE
							( 
								CASE WHEN
									DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE()) > SP.DELAY_INTEREST_DAY
								THEN
									(SP.DELAY_INTEREST_RATE*V.OTHER_MONEY_VALUE/30)*DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE())
								ELSE
									0
								END
							)
							END
						) AS TOTAL_GECIKME,
					</cfif>
					<cfif isdefined("attributes.bloke_member") and attributes.bloke_member eq 1>
						CR.FILE_NUMBER,
						CR.LAW_ADWOCATE,
					</cfif>
					V.CONSUMER_ID AS MEMBER_ID,
					(CONS.CONSUMER_NAME+ ' ' + CONS.CONSUMER_SURNAME) AS MUSTERI,
					CONS.MEMBER_CODE AS MEMBER_CODE,
					CONS.OZEL_KOD AS M_OZEL_KOD,
					('0'+CONS.MOBIL_CODE+ '' + CONS.MOBILTEL) AS  MOBIL_TEL,
					1 AS MEMBER_TYPE
				<cfelseif attributes.report_type eq 3>
					SUM(V.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),V.VOUCHER_DUEDATE)*V.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					<cfif isdefined("attributes.is_other_money")>
						SUM(V.VOUCHER_VALUE) AS TOTAL_AMOUNT_OTHER,
						V.CURRENCY_ID AS OTHER_MONEY,
					</cfif>			
					<cfif isdefined("attributes.is_money2")>
						SUM(V.OTHER_MONEY_VALUE2) AS TOTAL_AMOUNT2,
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						SUM(	
							CASE WHEN 
								V.VOUCHER_STATUS_ID = 3
							THEN	
								V.DELAY_INTEREST_SYSTEM_VALUE
							ELSE
							( 
								CASE WHEN
									DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE()) > SP.DELAY_INTEREST_DAY
								THEN
									(SP.DELAY_INTEREST_RATE*V.OTHER_MONEY_VALUE/30)*DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE())
								ELSE
									0
								END
							)
							END
						) AS TOTAL_GECIKME,
					</cfif>
					CR.LAW_ADWOCATE
				<cfelseif attributes.report_type eq 4>
					SUM(V.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),V.VOUCHER_DUEDATE)*V.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					<cfif isdefined("attributes.is_other_money")>

						SUM(V.VOUCHER_VALUE) AS TOTAL_AMOUNT_OTHER,
						V.CURRENCY_ID AS OTHER_MONEY,
					</cfif>			
					<cfif isdefined("attributes.is_money2")>
						SUM(V.OTHER_MONEY_VALUE2) AS TOTAL_AMOUNT2,
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						SUM(	
							CASE WHEN 
								V.VOUCHER_STATUS_ID = 3
							THEN	
								V.DELAY_INTEREST_SYSTEM_VALUE
							ELSE
							( 
								CASE WHEN
									DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE()) > SP.DELAY_INTEREST_DAY
								THEN
									(SP.DELAY_INTEREST_RATE*V.OTHER_MONEY_VALUE/30)*DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE())
								ELSE
									0
								END
							)
							END
						) AS TOTAL_GECIKME,
						SUM(
							CASE WHEN
								DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE()) > SP.DELAY_INTEREST_DAY
							THEN
								((DATEDIFF(day,GETDATE(),V.VOUCHER_DUEDATE)*(SP.DELAY_INTEREST_RATE*V.OTHER_MONEY_VALUE/30)))
							ELSE
								0
							END
						) AS TOTAL_GECIKME_VADE,
					</cfif>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						)
					<cfelse>
						V.CASH_ID
					</cfif> AS CASH_ID,
					CASH.CASH_NAME AS CASH_NAME,
					0 AS TOTAL_AMOUNT_ICRA,
					0 AS AVG_DUEDATE_ICRA,
					0 AS TOTAL_AMOUNT_VADE,
					0 AS AVG_DUEDATE_VADE
				<cfelseif attributes.report_type eq 5>
					SUM(V.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),V.VOUCHER_DUEDATE)*V.OTHER_MONEY_VALUE))/SUM(V.OTHER_MONEY_VALUE) AS AVG_DUEDATE,
					V.VOUCHER_DUEDATE AS DUE_DATE,
					MONTH(V.VOUCHER_DUEDATE) AS MONTH_DUE,
					YEAR(V.VOUCHER_DUEDATE) AS YEAR_DUE,
					V.VOUCHER_STATUS_ID AS STATUS
					<cfif isdefined("attributes.is_other_money")>
						,SUM(V.VOUCHER_VALUE) AS TOTAL_AMOUNT_OTHER
						,V.CURRENCY_ID AS OTHER_MONEY
					</cfif>
				</cfif>
			FROM
				VOUCHER V,
				VOUCHER_PAYROLL VP
                <cfif attributes.report_type eq 1>
                	LEFT JOIN #dsn_alias#.PRO_PROJECTS PR ON VP.PROJECT_ID = PR.PROJECT_ID
                </cfif>,
				#dsn_alias#.CONSUMER CONS
				<cfif (isdefined("attributes.bloke_member") and attributes.bloke_member eq 1) or attributes.report_type eq 3>
					,#dsn_alias#.COMPANY_LAW_REQUEST CR
				</cfif>
				<cfif isdefined("attributes.is_interest")>
					,#dsn_alias#.SETUP_PAYMETHOD SP	
				</cfif>
				<cfif attributes.report_type eq 4>
					,CASH
				</cfif>
			WHERE
				V.VOUCHER_PAYROLL_ID = VP.ACTION_ID
				AND VP.PAYROLL_TYPE = 107
				AND VP.COMPANY_ID IS NULL
				AND VP.CONSUMER_ID IS NULL
				AND V.CONSUMER_ID = CONS.CONSUMER_ID
				AND V.OTHER_MONEY_VALUE > 0
				<cfif not isdefined("attributes.is_pay_term")>
					AND V.IS_PAY_TERM = 0
				<cfelseif isdefined("attributes.is_pay_term") and not isdefined("attributes.is_voucher")>	
					AND V.IS_PAY_TERM = 1
				</cfif>
				<cfif isdefined("attributes.is_interest")>
					AND VP.PAYMETHOD_ID = SP.PAYMETHOD_ID
				</cfif>
				<cfif isdefined("attributes.cash_id") and len(attributes.cash_id)>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						AND ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID) = #attributes.cash_id#
					<cfelseif isdefined("attributes.is_status_info")>
						AND ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						) = #attributes.cash_id#
					<cfelse>
						AND V.CASH_ID = #attributes.cash_id#
					</cfif>
				</cfif>
				<cfif isdefined("attributes.account_id") and len(attributes.account_id)>
					AND (SELECT TOP 1 VP.PAYROLL_ACCOUNT_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN(2,3) ORDER BY VHH.HISTORY_ID DESC) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account_id#" list="yes">)
				</cfif>
				<cfif isdefined("attributes.new_account_id") and len(attributes.new_account_id)>
					AND (SELECT TOP 1 VP.PAYROLL_ACCOUNT_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN(2,3) ORDER BY VHH.HISTORY_ID DESC) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.new_account_id#" list="yes">)
				</cfif>
				<cfif (isdefined("attributes.bloke_member") and attributes.bloke_member eq 1) or attributes.report_type eq 3>
					AND CONS.CONSUMER_ID = CR.CONSUMER_ID
					AND CR.REQUEST_STATUS = 1
					<cfif len(attributes.lawyer_name) and len(attributes.lawyer_id)>
						AND CR.LAW_ADWOCATE = #attributes.lawyer_id#
					</cfif>
				<cfelseif isdefined("attributes.bloke_member") and attributes.bloke_member eq 2>
					AND CONS.CONSUMER_ID NOT IN(SELECT CONSUMER_ID FROM #dsn_alias#.COMPANY_LAW_REQUEST WHERE CONSUMER_ID IS NOT NULL)
				</cfif>
				<cfif isdefined("bireysel") and listlen(bireysel)>
					AND CONS.CONSUMER_ID IN
						(
						SELECT 
							C.CONSUMER_ID 
						FROM 
							#dsn_alias#.CONSUMER C,
							#dsn_alias#.CONSUMER_CAT CAT 
						WHERE 
							C.CONSUMER_CAT_ID = CAT.CONSCAT_ID AND
							(
								<cfloop list="#bireysel#" delimiters="," index="cat_i">
									(CAT.CONSCAT_ID = #listlast(cat_i,'-')#)
									<cfif cat_i neq listlast(bireysel,',') and listlen(bireysel,',') gte 1> OR</cfif>
								</cfloop>  
							)
						)
				</cfif>
				<cfif isDefined("attributes.sales_zones") and len(attributes.sales_zones)>
					AND CONS.SALES_COUNTY = #attributes.sales_zones#
				</cfif>
				<cfif isdefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_code_text)>
					AND CONS.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE= #attributes.pos_code# AND IS_MASTER=1 AND OUR_COMPANY_ID = #session.ep.company_id# AND CONSUMER_ID IS NOT NULL)
				</cfif>
				<cfif isDefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.employee)>
					AND VP.REVENUE_COLLECTOR_ID = #attributes.employee_id#
				</cfif>
				<cfif isdate(attributes.start_date)>
					AND V.VOUCHER_DUEDATE >=#attributes.start_date#
				</cfif>
				<cfif isdate(attributes.finish_date)>
					AND V.VOUCHER_DUEDATE <=#attributes.finish_date#
				</cfif>
                 <cfif isdefined("attributes.is_interest_show")>
                	AND DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE()) > 0
                </cfif>
				<cfif len(attributes.record_date1) and isdate(attributes.record_date1)>
					AND V.RECORD_DATE >=#attributes.record_date1#
				</cfif>
				<cfif len(attributes.record_date2) and isdate(attributes.record_date2)>
					AND V.RECORD_DATE < #DATEADD('d',1,attributes.record_date2)#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.company_id)>
					AND V.COMPANY_ID = #attributes.company_id#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.consumer_id)>
					AND V.CONSUMER_ID = #attributes.consumer_id#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.employee_id_)>
					AND V.EMPLOYEE_ID = #attributes.employee_id_#
				</cfif>
				<cfif len(trim(attributes.company2)) and len(attributes.company_id2)>
					AND (SELECT TOP 1 VP.COMPANY_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS = 4 ORDER BY VHH.HISTORY_ID DESC) = #attributes.company_id2#
				</cfif>
				<cfif len(attributes.status)>
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							AND ISNULL((SELECT VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID IN(SELECT ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_TYPE = 107)),V.VOUCHER_STATUS_ID) IN (#attributes.status#)
						<cfelseif len(attributes.action_date2)>
							AND ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) IN (#attributes.status#)
						<cfelse>	
							AND V.VOUCHER_STATUS_ID IN (#attributes.status#)
						</cfif>
					<cfelse>	
						AND V.VOUCHER_STATUS_ID IN (#attributes.status#)
					</cfif>
				</cfif>
				<cfif attributes.report_type eq 4>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						AND CASH.CASH_ID = ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						AND CASH.CASH_ID = ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						)
					<cfelse>
						AND CASH.CASH_ID = V.CASH_ID
					</cfif>
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							AND ISNULL((SELECT VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID IN(SELECT ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_TYPE = 107)),V.VOUCHER_STATUS_ID)=1
						<cfelseif len(attributes.action_date2)>
							AND ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID)=1
						<cfelse>	
							AND V.VOUCHER_STATUS_ID=1
						</cfif>
					<cfelse>	
						AND V.VOUCHER_STATUS_ID=1
					</cfif>
				</cfif>
				<cfif len(attributes.action_date1) and isdate(attributes.action_date1)>
					AND V.VOUCHER_ID IN(SELECT VH.VOUCHER_ID FROM VOUCHER_HISTORY VH WHERE <cfif len(attributes.status)>VH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(VH.ACT_DATE,DATEADD(day,-1,VH.RECORD_DATE)) >=#attributes.action_date1#) AND V.VOUCHER_ID = VH.VOUCHER_ID)
				</cfif>
				<cfif len(attributes.action_date2) and isdate(attributes.action_date2)>
					AND V.VOUCHER_ID IN(SELECT VH.VOUCHER_ID FROM VOUCHER_HISTORY VH WHERE <cfif len(attributes.status)>VH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(VH.ACT_DATE,DATEADD(day,-1,VH.RECORD_DATE)) <= #attributes.action_date2#) AND V.VOUCHER_ID = VH.VOUCHER_ID)
				</cfif>
				<cfif isdefined("attributes.is_open_acts")>
					AND VP.PAYROLL_NO='-1'
				</cfif>
				<cfif len(attributes.owner_company) and len(attributes.owner_company_id) and attributes.owner_member_type eq 'partner'>
					AND V.OWNER_COMPANY_ID = #attributes.owner_company_id#
				<cfelseif len(attributes.owner_company) and len(attributes.owner_consumer_id) and attributes.owner_member_type eq 'consumer'>
					AND V.OWNER_CONSUMER_ID = #attributes.owner_consumer_id#
				<cfelseif len(attributes.owner_company) and len(attributes.owner_employee_id) and attributes.owner_member_type eq 'employee'>
					AND V.OWNER_EMPLOYEE_ID = #attributes.owner_employee_id#
				</cfif>
			<cfif attributes.report_type neq 1>	
				GROUP BY
			</cfif>
			<cfif attributes.report_type eq 2>
				V.CONSUMER_ID,
				V.VOUCHER_ID,
				CONS.CONSUMER_NAME,
				CONS.CONSUMER_SURNAME,
				CONS.MEMBER_CODE,
				CONS.OZEL_KOD,
				CONS.MOBIL_CODE,
				CONS.MOBILTEL
				<cfif isdefined("attributes.is_other_money")>
				,V.CURRENCY_ID
				</cfif>
				<cfif isdefined("attributes.bloke_member") and attributes.bloke_member eq 1>
				,CR.FILE_NUMBER
				,CR.LAW_ADWOCATE
				</cfif>
			<cfelseif attributes.report_type eq 3>
				CR.LAW_ADWOCATE,
				V.VOUCHER_ID
				<cfif isdefined("attributes.is_other_money")>
				,V.CURRENCY_ID
				</cfif>
			<cfelseif attributes.report_type eq 4>
				<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
					ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID),
				<cfelseif isdefined("attributes.is_status_info")>
					ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						),
				<cfelse>
					V.CASH_ID,
				</cfif>
				V.VOUCHER_ID,
				CASH.CASH_NAME
				<cfif isdefined("attributes.is_other_money")>
				,V.CURRENCY_ID
				</cfif>
			<cfelseif attributes.report_type eq 5>
				V.VOUCHER_ID,
				V.VOUCHER_DUEDATE,
				MONTH(V.VOUCHER_DUEDATE),
				YEAR(V.VOUCHER_DUEDATE),
				V.VOUCHER_STATUS_ID
				<cfif isdefined("attributes.is_other_money")>
				,V.CURRENCY_ID
				</cfif>
			</cfif>
		</cfquery>		
	</cfif>
	<cfif not len(bireysel) or not len(kurumsal)>
		<cfquery name="get_cheque_voucher_15" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
			<!--- employee dolu olanlar --->
			SELECT
			    <cfif isdefined("attributes.report_type") and attributes.report_type eq 4>
				(SELECT TOP 1 VP.PAYROLL_TYPE FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY_TYPE,
				(SELECT TOP 1 VP.PAYROLL_NO FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY_NO,
				(SELECT TOP 1 VHH.PAYROLL_ID FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY,
			    </cfif>
				(SELECT TOP 1 VP.COMPANY_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS = 4 ORDER BY VHH.HISTORY_ID DESC) AS NEW_COMPANY_ID,
				(SELECT TOP 1 VP.PAYROLL_ACCOUNT_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN(2,3) ORDER BY VHH.HISTORY_ID DESC) AS NEW_ACCOUNT_ID,
				<cfif attributes.report_type eq 1>
					V.ACCOUNT_NO,
					V.VOUCHER_ID AS ISLEM_ID,
					V.VOUCHER_CODE AS OZEL_KOD,
					V.VOUCHER_DUEDATE AS DUE_DATE,
					V.VOUCHER_NO AS PAPER_NO,
					'' BANK_NAME,
					'' BANK_BRANCH_NAME,
					(SELECT TOP 1 VP.PAYROLL_TYPE FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY_TYPE,
				(SELECT TOP 1 VP.PAYROLL_NO FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY_NO,
				(SELECT TOP 1 VHH.PAYROLL_ID FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY,
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							ISNULL((SELECT VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID IN(SELECT ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_TYPE = 107)),V.VOUCHER_STATUS_ID) AS STATUS,
						<cfelseif len(attributes.action_date2)>
							ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) AS STATUS,
						<cfelse>	
							V.VOUCHER_STATUS_ID AS STATUS,
						</cfif>
					<cfelse>	
						V.VOUCHER_STATUS_ID AS STATUS,
					</cfif>
					V.DEBTOR_NAME AS DEBTOR_NAME,
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						)
					<cfelse>
						V.CASH_ID
					</cfif> AS CASH_ID,
					VP.PAYROLL_ACCOUNT_ID AS ACCOUNT_ID,
					VP.PAYMENT_ORDER_ID AS ORDER_ID,
					CASE WHEN VOUCHER_STATUS_ID = 3 THEN
						V.DELAY_INTEREST_SYSTEM_VALUE 
					ELSE
						CASE WHEN 
							DATEDIFF(d,VOUCHER_DUEDATE,GETDATE()) > (SELECT SP.DELAY_INTEREST_DAY FROM #dsn_alias#.SETUP_PAYMETHOD SP WHERE SP.PAYMETHOD_ID = VP.PAYMETHOD_ID) 
						THEN
							1
						ELSE
							0
						END	
					END AS GECIKME_TUTAR,
					VP.PAYMETHOD_ID AS PAYMETHOD_ID,
					<!--- <cfif check_our_company.is_remaining_amount eq 1>
						(SELECT OTHER_REMAINING_VALUE FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) OTHER_MONEY_VALUE,
						(SELECT OTHER_REMAINING_VALUE2 FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) OTHER_MONEY_VALUE2,
						(SELECT REMAINING_VALUE FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) OTHER_ACT_VALUE,
					<cfelse> Makın iste��iyle kapatıldı silmeyin Sevda ile konu��ulacak--->
						<cfif isdefined("attributes.is_status_info") and len(attributes.action_date2)>
							CASE WHEN
								ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) <> 3 <!---portfoydeyse --->
							THEN
								V.OTHER_MONEY_VALUE - ISNULL((SELECT (SUM(VC.CLOSED_AMOUNT)) FROM VOUCHER_PAYROLL VP,VOUCHER_CLOSED VC WHERE VC.PAYROLL_ID = VP.ACTION_ID AND VC.ACTION_ID = V.VOUCHER_ID AND ISNULL(VP.PAYROLL_AVG_DUEDATE,DATEADD(day,-1,VP.RECORD_DATE)) <= #attributes.action_date2# GROUP BY VC.ACTION_ID),0)
							ELSE
								V.OTHER_MONEY_VALUE
							END AS OTHER_MONEY_VALUE,
							V.OTHER_MONEY_VALUE2 AS OTHER_MONEY_VALUE2,
							CASE WHEN
								ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) <> 3
							THEN
								V.VOUCHER_VALUE - ISNULL((SELECT (SUM(VC.OTHER_CLOSED_AMOUNT)) FROM VOUCHER_PAYROLL VP,VOUCHER_CLOSED VC WHERE VC.PAYROLL_ID = VP.ACTION_ID AND VC.ACTION_ID = V.VOUCHER_ID AND ISNULL(VP.PAYROLL_AVG_DUEDATE,DATEADD(day,-1,VP.RECORD_DATE)) <= #attributes.action_date2# GROUP BY VC.ACTION_ID),0)
							ELSE
								V.VOUCHER_VALUE
							END AS OTHER_ACT_VALUE,
						<cfelse>
							V.OTHER_MONEY_VALUE AS OTHER_MONEY_VALUE,
							V.OTHER_MONEY_VALUE2 AS OTHER_MONEY_VALUE2,
							V.VOUCHER_VALUE AS OTHER_ACT_VALUE,
						</cfif>
					<!--- </cfif> --->
					V.CURRENCY_ID AS OTHER_MONEY,
					V.EMPLOYEE_ID AS MEMBER_ID,
					EMP.EMPLOYEE_NAME+' '+EMP.EMPLOYEE_SURNAME AS MUSTERI,
					EMP.EMPLOYEE_NO AS MEMBER_CODE,
					'' AS M_OZEL_KOD,
					2 AS MEMBER_TYPE,
					1 AS TYPE,
                    PR.PROJECT_HEAD,
					(SELECT TOP 1 VH.ACT_DATE FROM VOUCHER_HISTORY VH WHERE VH.VOUCHER_ID=V.VOUCHER_ID <cfif len(attributes.status)>AND VH.STATUS IN(#attributes.status#)</cfif> ORDER BY VH.RECORD_DATE DESC) TAHSILAT_TARIHI
				<cfelseif attributes.report_type eq 2>
					SUM(V.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),V.VOUCHER_DUEDATE)*V.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					<cfif isdefined("attributes.is_other_money")>
						SUM(V.VOUCHER_VALUE) AS TOTAL_AMOUNT_OTHER,
						V.CURRENCY_ID AS OTHER_MONEY,
					</cfif>			
					<cfif isdefined("attributes.is_money2")>
						SUM(V.OTHER_MONEY_VALUE2) AS TOTAL_AMOUNT2,
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						SUM(	
							CASE WHEN 
								V.VOUCHER_STATUS_ID = 3
							THEN	
								V.DELAY_INTEREST_SYSTEM_VALUE
							ELSE
							( 
								CASE WHEN
									DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE()) > SP.DELAY_INTEREST_DAY
								THEN
									(SP.DELAY_INTEREST_RATE*V.OTHER_MONEY_VALUE/30)*DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE())
								ELSE
									0
								END
							)
							END
						) AS TOTAL_GECIKME,
					</cfif>
					<cfif isdefined("attributes.bloke_member") and attributes.bloke_member eq 1>
						'' FILE_NUMBER,
						0 LAW_ADWOCATE,
					</cfif>
					VP.EMPLOYEE_ID AS MEMBER_ID,
					EMP.EMPLOYEE_NAME+' '+EMP.EMPLOYEE_SURNAME AS MUSTERI,
					EMP.EMPLOYEE_NO AS MEMBER_CODE,
					'' AS M_OZEL_KOD,
					'' MOBIL_TEL,
					2 AS MEMBER_TYPE
				<cfelseif attributes.report_type eq 3>
					SUM(V.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),V.VOUCHER_DUEDATE)*V.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					<cfif isdefined("attributes.is_other_money")>
						SUM(V.VOUCHER_VALUE) AS TOTAL_AMOUNT_OTHER,
						V.CURRENCY_ID AS OTHER_MONEY,
					</cfif>			
					<cfif isdefined("attributes.is_money2")>
						SUM(V.OTHER_MONEY_VALUE2) AS TOTAL_AMOUNT2,
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						SUM(	
							CASE WHEN
								DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE()) > SP.DELAY_INTEREST_DAY
							THEN
								(SP.DELAY_INTEREST_RATE*V.OTHER_MONEY_VALUE/30)*DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE())
							ELSE
								0
							END
						) AS TOTAL_GECIKME,
					</cfif>
					0 AS LAW_ADWOCATE
				<cfelseif attributes.report_type eq 4>
					SUM(V.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),V.VOUCHER_DUEDATE)*V.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					<cfif isdefined("attributes.is_other_money")>
						SUM(V.VOUCHER_VALUE) AS TOTAL_AMOUNT_OTHER,
						V.CURRENCY_ID AS OTHER_MONEY,
					</cfif>			
					<cfif isdefined("attributes.is_money2")>
						SUM(V.OTHER_MONEY_VALUE2) AS TOTAL_AMOUNT2,
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						SUM(	
							CASE WHEN 
								V.VOUCHER_STATUS_ID = 3
							THEN	
								V.DELAY_INTEREST_SYSTEM_VALUE
							ELSE
							( 
								CASE WHEN
									DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE()) > SP.DELAY_INTEREST_DAY
								THEN
									(SP.DELAY_INTEREST_RATE*V.OTHER_MONEY_VALUE/30)*DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE())
								ELSE
									0
								END
							)
							END
						) AS TOTAL_GECIKME,
						SUM(
							CASE WHEN
								DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE()) > SP.DELAY_INTEREST_DAY
							THEN
								((DATEDIFF(day,GETDATE(),V.VOUCHER_DUEDATE)*(SP.DELAY_INTEREST_RATE*V.OTHER_MONEY_VALUE/30)))
							ELSE
								0
							END
						) AS TOTAL_GECIKME_VADE,
					</cfif>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						)
					<cfelse>
						V.CASH_ID
					</cfif> AS CASH_ID,
					CASH.CASH_NAME AS CASH_NAME,
					0 AS TOTAL_AMOUNT_ICRA,
					0 AS AVG_DUEDATE_ICRA,
					0 AS TOTAL_AMOUNT_VADE,
					0 AS AVG_DUEDATE_VADE
				<cfelseif attributes.report_type eq 5>
					SUM(V.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),V.VOUCHER_DUEDATE)*V.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					V.VOUCHER_DUEDATE AS DUE_DATE,
					MONTH(V.VOUCHER_DUEDATE) AS MONTH_DUE,
					YEAR(V.VOUCHER_DUEDATE) AS YEAR_DUE,
					V.VOUCHER_STATUS_ID AS STATUS
					<cfif isdefined("attributes.is_other_money")>
						,SUM(V.VOUCHER_VALUE) AS TOTAL_AMOUNT_OTHER
						,V.CURRENCY_ID AS OTHER_MONEY
					</cfif>	
				</cfif>
			FROM
				VOUCHER V,
				VOUCHER_PAYROLL VP
                <cfif attributes.report_type eq 1>
                	LEFT JOIN #dsn_alias#.PRO_PROJECTS PR ON VP.PROJECT_ID = PR.PROJECT_ID
                </cfif>,
				#dsn_alias#.EMPLOYEES EMP
				<cfif isdefined("attributes.is_interest")>
					,#dsn_alias#.SETUP_PAYMETHOD SP	
				</cfif>
				<cfif attributes.report_type eq 4>
					,CASH
				</cfif>
			WHERE
				V.VOUCHER_PAYROLL_ID = VP.ACTION_ID
				AND VP.EMPLOYEE_ID = EMP.EMPLOYEE_ID
				AND V.OTHER_MONEY_VALUE > 0
				<cfif not isdefined("attributes.is_pay_term")>
					AND V.IS_PAY_TERM = 0
				<cfelseif isdefined("attributes.is_pay_term") and not isdefined("attributes.is_voucher")>	
					AND V.IS_PAY_TERM = 1
				</cfif>
				<cfif isdefined("attributes.is_interest")>
					AND VP.PAYMETHOD_ID = SP.PAYMETHOD_ID
				</cfif>
				<cfif isdefined("attributes.cash_id") and len(attributes.cash_id)>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						AND ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID) = #attributes.cash_id#
					<cfelseif isdefined("attributes.is_status_info")>
						AND ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						) = #attributes.cash_id#
					<cfelse>
						AND V.CASH_ID = #attributes.cash_id#
					</cfif>
				</cfif>
				<cfif isdefined("attributes.account_id") and len(attributes.account_id)>
					AND (SELECT TOP 1 VP.PAYROLL_ACCOUNT_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN(2,3) ORDER BY VHH.HISTORY_ID DESC) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account_id#" list="yes">)
				</cfif>
				<cfif isdefined("attributes.new_account_id") and len(attributes.new_account_id)>
					AND (SELECT TOP 1 VP.PAYROLL_ACCOUNT_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN(2,3) ORDER BY VHH.HISTORY_ID DESC) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.new_account_id#" list="yes">)
				</cfif>
				<cfif isDefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.employee)>
					AND VP.REVENUE_COLLECTOR_ID = #attributes.employee_id#
				</cfif>
				<cfif isdate(attributes.start_date)>
					AND V.VOUCHER_DUEDATE >=#attributes.start_date#
				</cfif>
				<cfif isdate(attributes.finish_date)>
					AND V.VOUCHER_DUEDATE <=#attributes.finish_date#
				</cfif>
                <cfif isdefined("attributes.is_interest_show")>
                	AND DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE()) > 0
                </cfif>
				<cfif len(attributes.record_date1) and isdate(attributes.record_date1)>
					AND V.RECORD_DATE >=#attributes.record_date1#
				</cfif>
				<cfif len(attributes.record_date2) and isdate(attributes.record_date2)>
					AND V.RECORD_DATE < #DATEADD('d',1,attributes.record_date2)#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.company_id)>
					AND V.COMPANY_ID = #attributes.company_id#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.consumer_id)>
					AND V.CONSUMER_ID = #attributes.consumer_id#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.employee_id_)>
					AND V.EMPLOYEE_ID = #attributes.employee_id_#
				</cfif>
				<cfif len(trim(attributes.company2)) and len(attributes.company_id2)>
					AND (SELECT TOP 1 VP.COMPANY_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS = 4 ORDER BY VHH.HISTORY_ID DESC) = #attributes.company_id2#
				</cfif>
				<cfif len(attributes.status)>
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							AND ISNULL((SELECT VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID IN(SELECT ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_TYPE = 107)),V.VOUCHER_STATUS_ID) IN (#attributes.status#)
						<cfelseif len(attributes.action_date2)>
							AND ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) IN (#attributes.status#)
						<cfelse>	
							AND V.VOUCHER_STATUS_ID IN (#attributes.status#)
						</cfif>
					<cfelse>	
						AND V.VOUCHER_STATUS_ID IN (#attributes.status#)
					</cfif>
				</cfif>
				<cfif attributes.report_type eq 4>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						AND CASH.CASH_ID = ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						AND CASH.CASH_ID = ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						)
					<cfelse>
						AND CASH.CASH_ID = V.CASH_ID
					</cfif>
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							AND ISNULL((SELECT VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID IN(SELECT ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_TYPE = 107)),V.VOUCHER_STATUS_ID) = 1
						<cfelseif len(attributes.action_date2)>
							AND ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) = 1
						<cfelse>	
							AND V.VOUCHER_STATUS_ID = 1
						</cfif>
					<cfelse>	
						AND V.VOUCHER_STATUS_ID = 1
					</cfif>
				</cfif>
				<cfif len(attributes.action_date1) and isdate(attributes.action_date1)>
					AND V.VOUCHER_ID IN(SELECT VH.VOUCHER_ID FROM VOUCHER_HISTORY VH WHERE <cfif len(attributes.status)>VH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(VH.ACT_DATE,DATEADD(day,-1,VH.RECORD_DATE)) >=#attributes.action_date1#) AND V.VOUCHER_ID = VH.VOUCHER_ID)
				</cfif>
				<cfif len(attributes.action_date2) and isdate(attributes.action_date2)>
					AND V.VOUCHER_ID IN(SELECT VH.VOUCHER_ID FROM VOUCHER_HISTORY VH WHERE <cfif len(attributes.status)>VH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(VH.ACT_DATE,DATEADD(day,-1,VH.RECORD_DATE)) <= #attributes.action_date2#) AND V.VOUCHER_ID = VH.VOUCHER_ID)
				</cfif>
				<cfif isdefined("attributes.is_open_acts")>
					AND VP.PAYROLL_NO='-1'
				</cfif>
				<cfif len(attributes.owner_company) and len(attributes.owner_company_id) and attributes.owner_member_type eq 'partner'>
					AND V.OWNER_COMPANY_ID = #attributes.owner_company_id#
				<cfelseif len(attributes.owner_company) and len(attributes.owner_consumer_id) and attributes.owner_member_type eq 'consumer'>
					AND V.OWNER_CONSUMER_ID = #attributes.owner_consumer_id#
				<cfelseif len(attributes.owner_company) and len(attributes.owner_employee_id) and attributes.owner_member_type eq 'employee'>
					AND V.OWNER_EMPLOYEE_ID = #attributes.owner_employee_id#
				</cfif>
			<cfif attributes.report_type neq 1>	
				GROUP BY
			</cfif>
			<cfif attributes.report_type eq 2>
				VP.EMPLOYEE_ID,
				EMP.EMPLOYEE_NAME,
				EMP.EMPLOYEE_SURNAME,
				EMP.EMPLOYEE_NO,
				V.VOUCHER_ID
				<cfif isdefined("attributes.is_other_money")>
				,V.CURRENCY_ID
				</cfif>
			 <cfelseif attributes.report_type eq 3>
				V.VOUCHER_ID
				<cfif isdefined("attributes.is_other_money")>
				,V.CURRENCY_ID
				</cfif>
			 <cfelseif attributes.report_type eq 4>
				<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
					ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID),
				<cfelseif isdefined("attributes.is_status_info")>
					ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						),
				<cfelse>
					V.CASH_ID,
				</cfif>
				V.VOUCHER_ID,
				CASH.CASH_NAME
				<cfif isdefined("attributes.is_other_money")>
				,V.CURRENCY_ID
				</cfif>
			 <cfelseif attributes.report_type eq 5>
				V.VOUCHER_ID,
				V.VOUCHER_DUEDATE,
				MONTH(V.VOUCHER_DUEDATE),
				YEAR(V.VOUCHER_DUEDATE),
				V.VOUCHER_STATUS_ID
				<cfif isdefined("attributes.is_other_money")>
				,V.CURRENCY_ID
				</cfif>
			 </cfif>
		</cfquery>
		<cfquery name="get_cheque_voucher_16" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
			<!--- senet de employee dolu olanlar --->
			SELECT
			<cfif isdefined("attributes.report_type") and attributes.report_type eq 4>
				(SELECT TOP 1 VP.PAYROLL_TYPE FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY_TYPE,
				(SELECT TOP 1 VP.PAYROLL_NO FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY_NO,
				(SELECT TOP 1 VHH.PAYROLL_ID FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY,
			</cfif>
				(SELECT TOP 1 VP.COMPANY_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS = 4 ORDER BY VHH.HISTORY_ID DESC) AS NEW_COMPANY_ID,
				(SELECT TOP 1 VP.PAYROLL_ACCOUNT_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN(2,3) ORDER BY VHH.HISTORY_ID DESC) AS NEW_ACCOUNT_ID,
				<cfif attributes.report_type eq 1>
					V.ACCOUNT_NO,
					V.VOUCHER_ID AS ISLEM_ID,
					V.VOUCHER_CODE AS OZEL_KOD,
					V.VOUCHER_DUEDATE AS DUE_DATE,
					V.VOUCHER_NO AS PAPER_NO,
					'' BANK_NAME,
					'' BANK_BRANCH_NAME,
					(SELECT TOP 1 VP.PAYROLL_TYPE FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY_TYPE,
					(SELECT TOP 1 VP.PAYROLL_NO FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY_NO,
					(SELECT TOP 1 VHH.PAYROLL_ID FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY,
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							ISNULL((SELECT VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID IN(SELECT ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_TYPE = 107)),V.VOUCHER_STATUS_ID) AS STATUS,
						<cfelseif len(attributes.action_date2)>
							ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) AS STATUS,
						<cfelse>	
							V.VOUCHER_STATUS_ID AS STATUS,
						</cfif>
					<cfelse>	
						V.VOUCHER_STATUS_ID AS STATUS,
					</cfif>
					V.DEBTOR_NAME AS DEBTOR_NAME,
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						)
					<cfelse>
						V.CASH_ID
					</cfif> AS CASH_ID,
					VP.PAYROLL_ACCOUNT_ID AS ACCOUNT_ID,
					VP.PAYMENT_ORDER_ID AS ORDER_ID,
					CASE WHEN VOUCHER_STATUS_ID = 3 THEN
						V.DELAY_INTEREST_SYSTEM_VALUE 
					ELSE
						CASE WHEN 
							DATEDIFF(d,VOUCHER_DUEDATE,GETDATE()) > (SELECT SP.DELAY_INTEREST_DAY FROM #dsn_alias#.SETUP_PAYMETHOD SP WHERE SP.PAYMETHOD_ID = VP.PAYMETHOD_ID) 
						THEN
							1
						ELSE
							0
						END	
					END AS GECIKME_TUTAR,
					VP.PAYMETHOD_ID AS PAYMETHOD_ID,
					<!--- <cfif check_our_company.is_remaining_amount eq 1>
						(SELECT OTHER_REMAINING_VALUE FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) OTHER_MONEY_VALUE,
						(SELECT OTHER_REMAINING_VALUE2 FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) OTHER_MONEY_VALUE2,
						(SELECT REMAINING_VALUE FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) OTHER_ACT_VALUE,
					<cfelse> Makın iste��iyle kapatıldı silmeyin Sevda ile konu��ulacak--->
						<cfif isdefined("attributes.is_status_info") and len(attributes.action_date2)>
							CASE WHEN
								ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) <> 3 <!---portfoydeyse --->
							THEN
								V.OTHER_MONEY_VALUE - ISNULL((SELECT (SUM(VC.CLOSED_AMOUNT)) FROM VOUCHER_PAYROLL VP,VOUCHER_CLOSED VC WHERE VC.PAYROLL_ID = VP.ACTION_ID AND VC.ACTION_ID = V.VOUCHER_ID AND ISNULL(VP.PAYROLL_AVG_DUEDATE,DATEADD(day,-1,VP.RECORD_DATE)) <= #attributes.action_date2# GROUP BY VC.ACTION_ID),0)
							ELSE
								V.OTHER_MONEY_VALUE
							END AS OTHER_MONEY_VALUE,
							V.OTHER_MONEY_VALUE2 AS OTHER_MONEY_VALUE2,
							CASE WHEN
								ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) <> 3
							THEN
								V.VOUCHER_VALUE - ISNULL((SELECT (SUM(VC.OTHER_CLOSED_AMOUNT)) FROM VOUCHER_PAYROLL VP,VOUCHER_CLOSED VC WHERE VC.PAYROLL_ID = VP.ACTION_ID AND VC.ACTION_ID = V.VOUCHER_ID AND ISNULL(VP.PAYROLL_AVG_DUEDATE,DATEADD(day,-1,VP.RECORD_DATE)) <= #attributes.action_date2# GROUP BY VC.ACTION_ID),0)
							ELSE
								V.VOUCHER_VALUE
							END AS OTHER_ACT_VALUE,
						<cfelse>
							V.OTHER_MONEY_VALUE AS OTHER_MONEY_VALUE,
							V.OTHER_MONEY_VALUE2 AS OTHER_MONEY_VALUE2,
							V.VOUCHER_VALUE AS OTHER_ACT_VALUE,
						</cfif>
					<!--- </cfif> --->
					V.CURRENCY_ID AS OTHER_MONEY,
					V.EMPLOYEE_ID AS MEMBER_ID,
					EMP.EMPLOYEE_NAME+' '+EMP.EMPLOYEE_SURNAME AS MUSTERI,
					EMP.EMPLOYEE_NO AS MEMBER_CODE,
					'' AS M_OZEL_KOD,
					2 AS MEMBER_TYPE,
					1 AS TYPE,
                    PR.PROJECT_HEAD,
					(SELECT TOP 1 VH.ACT_DATE FROM VOUCHER_HISTORY VH WHERE VH.VOUCHER_ID=V.VOUCHER_ID <cfif len(attributes.status)>AND VH.STATUS IN(#attributes.status#)</cfif> ORDER BY VH.RECORD_DATE DESC) TAHSILAT_TARIHI
				<cfelseif attributes.report_type eq 2>
					SUM(V.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),V.VOUCHER_DUEDATE)*V.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					<cfif isdefined("attributes.is_other_money")>
						SUM(V.VOUCHER_VALUE) AS TOTAL_AMOUNT_OTHER,
						V.CURRENCY_ID AS OTHER_MONEY,
					</cfif>			
					<cfif isdefined("attributes.is_money2")>
						SUM(V.OTHER_MONEY_VALUE2) AS TOTAL_AMOUNT2,
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						SUM(	
							CASE WHEN 
								V.VOUCHER_STATUS_ID = 3
							THEN	
								V.DELAY_INTEREST_SYSTEM_VALUE
							ELSE
							( 
								CASE WHEN
									DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE()) > SP.DELAY_INTEREST_DAY
								THEN
									(SP.DELAY_INTEREST_RATE*V.OTHER_MONEY_VALUE/30)*DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE())
								ELSE
									0
								END
							)
							END
						) AS TOTAL_GECIKME,
					</cfif>
					<cfif isdefined("attributes.bloke_member") and attributes.bloke_member eq 1>
						'' FILE_NUMBER,
						0 LAW_ADWOCATE,
					</cfif>
					V.EMPLOYEE_ID AS MEMBER_ID,
					EMP.EMPLOYEE_NAME+' '+EMP.EMPLOYEE_SURNAME AS MUSTERI,
					EMP.EMPLOYEE_NO AS MEMBER_CODE,
					'' AS M_OZEL_KOD,
					'' MOBIL_TEL,
					2 AS MEMBER_TYPE
				<cfelseif attributes.report_type eq 3>
					SUM(V.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),V.VOUCHER_DUEDATE)*V.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					<cfif isdefined("attributes.is_other_money")>
						SUM(V.VOUCHER_VALUE) AS TOTAL_AMOUNT_OTHER,
						V.CURRENCY_ID AS OTHER_MONEY,
					</cfif>			
					<cfif isdefined("attributes.is_money2")>
						SUM(V.OTHER_MONEY_VALUE2) AS TOTAL_AMOUNT2,
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						SUM(	
							CASE WHEN
								DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE()) > SP.DELAY_INTEREST_DAY
							THEN
								(SP.DELAY_INTEREST_RATE*V.OTHER_MONEY_VALUE/30)*DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE())
							ELSE
								0
							END
						) AS TOTAL_GECIKME,
					</cfif>
					0 AS LAW_ADWOCATE
				<cfelseif attributes.report_type eq 4>
					SUM(V.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),V.VOUCHER_DUEDATE)*V.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					<cfif isdefined("attributes.is_other_money")>
						SUM(V.VOUCHER_VALUE) AS TOTAL_AMOUNT_OTHER,
						V.CURRENCY_ID AS OTHER_MONEY,
					</cfif>			
					<cfif isdefined("attributes.is_money2")>
						SUM(V.OTHER_MONEY_VALUE2) AS TOTAL_AMOUNT2,
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						SUM(	
							CASE WHEN 
								V.VOUCHER_STATUS_ID = 3
							THEN	
								V.DELAY_INTEREST_SYSTEM_VALUE
							ELSE
							( 
								CASE WHEN
									DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE()) > SP.DELAY_INTEREST_DAY
								THEN
									(SP.DELAY_INTEREST_RATE*V.OTHER_MONEY_VALUE/30)*DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE())
								ELSE
									0
								END
							)
							END
						) AS TOTAL_GECIKME,
						SUM(
							CASE WHEN
	
								DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE()) > SP.DELAY_INTEREST_DAY
							THEN
								((DATEDIFF(day,GETDATE(),V.VOUCHER_DUEDATE)*(SP.DELAY_INTEREST_RATE*V.OTHER_MONEY_VALUE/30)))
							ELSE
								0
							END
						) AS TOTAL_GECIKME_VADE,
					</cfif>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						)
					<cfelse>
						V.CASH_ID
					</cfif> AS CASH_ID,
					CASH.CASH_NAME AS CASH_NAME,
					0 AS TOTAL_AMOUNT_ICRA,
					0 AS AVG_DUEDATE_ICRA,
					0 AS TOTAL_AMOUNT_VADE,
					0 AS AVG_DUEDATE_VADE
				<cfelseif attributes.report_type eq 5>
					SUM(V.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT,
					SUM((DATEDIFF(day,GETDATE(),V.VOUCHER_DUEDATE)*V.OTHER_MONEY_VALUE)) AS AVG_DUEDATE,
					V.VOUCHER_DUEDATE AS DUE_DATE,
					MONTH(V.VOUCHER_DUEDATE) AS MONTH_DUE,
					YEAR(V.VOUCHER_DUEDATE) AS YEAR_DUE,
					V.VOUCHER_STATUS_ID AS STATUS
					<cfif isdefined("attributes.is_other_money")>
						,SUM(V.VOUCHER_VALUE) AS TOTAL_AMOUNT_OTHER
						,V.CURRENCY_ID AS OTHER_MONEY
					</cfif>	
				</cfif>
			FROM
				VOUCHER V,
				VOUCHER_PAYROLL VP
                <cfif attributes.report_type eq 1>
                	LEFT JOIN #dsn_alias#.PRO_PROJECTS PR ON VP.PROJECT_ID = PR.PROJECT_ID
                </cfif>,
				#dsn_alias#.EMPLOYEES EMP
				<cfif isdefined("attributes.is_interest")>
					,#dsn_alias#.SETUP_PAYMETHOD SP	
				</cfif>
				<cfif attributes.report_type eq 4>
					,CASH
				</cfif>
			WHERE
				V.VOUCHER_PAYROLL_ID = VP.ACTION_ID
				AND VP.PAYROLL_TYPE = 107
				AND VP.COMPANY_ID IS NULL
				AND VP.CONSUMER_ID IS NULL
				AND VP.EMPLOYEE_ID IS NULL
				AND V.EMPLOYEE_ID = EMP.EMPLOYEE_ID
				AND V.OTHER_MONEY_VALUE > 0
				<cfif not isdefined("attributes.is_pay_term")>
					AND V.IS_PAY_TERM = 0
				<cfelseif isdefined("attributes.is_pay_term") and not isdefined("attributes.is_voucher")>	
					AND V.IS_PAY_TERM = 1
				</cfif>
				<cfif isdefined("attributes.is_interest")>
					AND VP.PAYMETHOD_ID = SP.PAYMETHOD_ID
				</cfif>
				<cfif isdefined("attributes.cash_id") and len(attributes.cash_id)>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						AND ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID) = #attributes.cash_id#
					<cfelseif isdefined("attributes.is_status_info")>
						AND ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						) = #attributes.cash_id#
					<cfelse>
						AND V.CASH_ID = #attributes.cash_id#
					</cfif>
				</cfif>
				<cfif isdefined("attributes.account_id") and len(attributes.account_id)>
					AND (SELECT TOP 1 VP.PAYROLL_ACCOUNT_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN(2,3) ORDER BY VHH.HISTORY_ID DESC) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account_id#" list="yes">)
				</cfif>
				<cfif isdefined("attributes.new_account_id") and len(attributes.new_account_id)>
					AND (SELECT TOP 1 VP.PAYROLL_ACCOUNT_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN(2,3) ORDER BY VHH.HISTORY_ID DESC) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.new_account_id#" list="yes">)
				</cfif>
				<cfif isdefined("kurumsal") and listlen(kurumsal)>
					AND V.COMPANY_ID IN
						(
						SELECT 
							C.COMPANY_ID 
						FROM 
							#dsn_alias#.COMPANY C,
							#dsn_alias#.COMPANY_CAT CAT 
						WHERE 
							C.COMPANYCAT_ID = CAT.COMPANYCAT_ID AND
							(
								<cfloop list="#kurumsal#" delimiters="," index="cat_i">
									(CAT.COMPANYCAT_ID = #listlast(cat_i,'-')#)
									<cfif cat_i neq listlast(kurumsal,',') and listlen(kurumsal,',') gte 1> OR</cfif>
								</cfloop>  
							)
						)
				</cfif>
				<cfif isDefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.employee)>
					AND VP.REVENUE_COLLECTOR_ID = #attributes.employee_id#
				</cfif>
				<cfif isdate(attributes.start_date)>
					AND V.VOUCHER_DUEDATE >=#attributes.start_date#
				</cfif>
				<cfif isdate(attributes.finish_date)>
					AND V.VOUCHER_DUEDATE <=#attributes.finish_date#
				</cfif>
                <cfif isdefined("attributes.is_interest_show")>
                	AND DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE()) > 0
                </cfif>
				<cfif len(attributes.record_date1) and isdate(attributes.record_date1)>
					AND V.RECORD_DATE >=#attributes.record_date1#
				</cfif>
				<cfif len(attributes.record_date2) and isdate(attributes.record_date2)>
					AND V.RECORD_DATE < #DATEADD('d',1,attributes.record_date2)#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.company_id)>
					AND V.COMPANY_ID = #attributes.company_id#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.consumer_id)>
					AND V.CONSUMER_ID = #attributes.consumer_id#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.employee_id_)>
					AND V.EMPLOYEE_ID = #attributes.employee_id_#
				</cfif>
				<cfif len(trim(attributes.company2)) and len(attributes.company_id2)>
					AND (SELECT TOP 1 VP.COMPANY_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS = 4 ORDER BY VHH.HISTORY_ID DESC) = #attributes.company_id2#
				</cfif>
				<cfif len(attributes.status)>
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							AND ISNULL((SELECT VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID IN(SELECT ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_TYPE = 107)),V.VOUCHER_STATUS_ID) IN (#attributes.status#)
						<cfelseif len(attributes.action_date2)>
							AND ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) IN (#attributes.status#)
						<cfelse>	
							AND V.VOUCHER_STATUS_ID IN (#attributes.status#)
						</cfif>
					<cfelse>	
						AND V.VOUCHER_STATUS_ID IN (#attributes.status#)
					</cfif>
				</cfif>
				<cfif attributes.report_type eq 4>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						AND CASH.CASH_ID = ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						AND CASH.CASH_ID = ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						)
					<cfelse>
						AND CASH.CASH_ID = V.CASH_ID
					</cfif>
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							AND ISNULL((SELECT VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID IN(SELECT ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_TYPE = 107)),V.VOUCHER_STATUS_ID)=1
						<cfelseif len(attributes.action_date2)>
							AND ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID)=1
						<cfelse>	
							AND V.VOUCHER_STATUS_ID=1
						</cfif>
					<cfelse>	
						AND V.VOUCHER_STATUS_ID=1
					</cfif>
				</cfif>
				<cfif len(attributes.action_date1) and isdate(attributes.action_date1)>
					AND V.VOUCHER_ID IN(SELECT VH.VOUCHER_ID FROM VOUCHER_HISTORY VH WHERE <cfif len(attributes.status)>VH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(VH.ACT_DATE,DATEADD(day,-1,VH.RECORD_DATE)) >=#attributes.action_date1#) AND V.VOUCHER_ID = VH.VOUCHER_ID)
				</cfif>
				<cfif len(attributes.action_date2) and isdate(attributes.action_date2)>
					AND V.VOUCHER_ID IN(SELECT VH.VOUCHER_ID FROM VOUCHER_HISTORY VH WHERE <cfif len(attributes.status)>VH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(VH.ACT_DATE,DATEADD(day,-1,VH.RECORD_DATE)) <= #attributes.action_date2#) AND V.VOUCHER_ID = VH.VOUCHER_ID)
				</cfif>
				<cfif isdefined("attributes.is_open_acts")>
					AND VP.PAYROLL_NO='-1'
				</cfif>
				<cfif len(attributes.owner_company) and len(attributes.owner_company_id) and attributes.owner_member_type eq 'partner'>
					AND V.OWNER_COMPANY_ID = #attributes.owner_company_id#
				<cfelseif len(attributes.owner_company) and len(attributes.owner_consumer_id) and attributes.owner_member_type eq 'consumer'>
					AND V.OWNER_CONSUMER_ID = #attributes.owner_consumer_id#
				<cfelseif len(attributes.owner_company) and len(attributes.owner_employee_id) and attributes.owner_member_type eq 'employee'>
					AND V.OWNER_EMPLOYEE_ID = #attributes.owner_employee_id#
				</cfif>
			<cfif attributes.report_type neq 1>	
				GROUP BY
			</cfif>
			<cfif attributes.report_type eq 2>
				V.EMPLOYEE_ID,
				EMP.EMPLOYEE_NAME,
				EMP.EMPLOYEE_SURNAME,
				EMP.EMPLOYEE_NO,
				V.VOUCHER_ID
				<cfif isdefined("attributes.is_other_money")>
				,V.CURRENCY_ID
				</cfif>
			 <cfelseif attributes.report_type eq 3>
				V.VOUCHER_ID
				<cfif isdefined("attributes.is_other_money")>
				,V.CURRENCY_ID
				</cfif>
			 <cfelseif attributes.report_type eq 4>
				<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
					ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID),
				<cfelseif isdefined("attributes.is_status_info")>
					ISNULL(
						(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
						(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
					),
				<cfelse>
					V.CASH_ID,
				</cfif>
				V.VOUCHER_ID,
				CASH.CASH_NAME
				<cfif isdefined("attributes.is_other_money")>
				,V.CURRENCY_ID
				</cfif>
			 <cfelseif attributes.report_type eq 5>
				V.VOUCHER_ID,
				V.VOUCHER_DUEDATE,
				MONTH(V.VOUCHER_DUEDATE),
				YEAR(V.VOUCHER_DUEDATE),
				V.VOUCHER_STATUS_ID
				<cfif isdefined("attributes.is_other_money")>
				,V.CURRENCY_ID
				</cfif>
			 </cfif>
		</cfquery>
	</cfif>
	<cfif attributes.report_type eq 4>
		<cfif len(kurumsal) or not len(bireysel)>
			<cfquery name="get_cheque_voucher_11" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
			SELECT
				(SELECT TOP 1 VP.PAYROLL_TYPE FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY_TYPE,
				(SELECT TOP 1 VP.PAYROLL_NO FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY_NO,
				(SELECT TOP 1 VHH.PAYROLL_ID FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY,
				(SELECT TOP 1 VP.COMPANY_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS = 4 ORDER BY VHH.HISTORY_ID DESC) AS NEW_COMPANY_ID,
				(SELECT TOP 1 VP.PAYROLL_ACCOUNT_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN(2,3) ORDER BY VHH.HISTORY_ID DESC) AS NEW_ACCOUNT_ID,
				0 AS TOTAL_AMOUNT,
				0 AS AVG_DUEDATE,
				<cfif isdefined("attributes.is_other_money")>
					0 AS TOTAL_AMOUNT_OTHER,
					'#session.ep.money#' AS OTHER_MONEY,
				</cfif>			
				<cfif isdefined("attributes.is_money2")>
					0 AS TOTAL_AMOUNT2,
				</cfif>
				<cfif isdefined("attributes.is_interest")>
					0 AS TOTAL_GECIKME,
					0 AS TOTAL_GECIKME_VADE,
				</cfif>
				<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
					ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID)
				<cfelseif isdefined("attributes.is_status_info")>
					ISNULL(
						(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
						(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
					)
				<cfelse>
					V.CASH_ID
				</cfif> AS CASH_ID,
				CASH.CASH_NAME AS CASH_NAME,
				SUM(V.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT_ICRA,
				SUM((DATEDIFF(day,GETDATE(),V.VOUCHER_DUEDATE)*V.OTHER_MONEY_VALUE)) AS AVG_DUEDATE_ICRA,
				0 AS TOTAL_AMOUNT_VADE,
				0 AS AVG_DUEDATE_VADE
			FROM
				VOUCHER V,
				VOUCHER_PAYROLL VP,
				#dsn_alias#.CONSUMER CONS,
				CASH
				<cfif isdefined("attributes.is_interest")>
				,#dsn_alias#.SETUP_PAYMETHOD SP	
				</cfif>
			WHERE
				V.VOUCHER_PAYROLL_ID = VP.ACTION_ID
				AND VP.CONSUMER_ID = CONS.CONSUMER_ID
				<cfif not isdefined("attributes.is_pay_term")>
					AND V.IS_PAY_TERM = 0
				<cfelseif isdefined("attributes.is_pay_term") and not isdefined("attributes.is_voucher")>	
					AND V.IS_PAY_TERM = 1
				</cfif>
				<cfif isdefined("attributes.is_interest")>
					AND VP.PAYMETHOD_ID = SP.PAYMETHOD_ID
				</cfif>
				<cfif isdefined("attributes.cash_id") and len(attributes.cash_id)>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						AND ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID) = #attributes.cash_id#
					<cfelseif isdefined("attributes.is_status_info")>
						AND ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						) = #attributes.cash_id#
					<cfelse>
						AND V.CASH_ID = #attributes.cash_id#
					</cfif>
				</cfif>
				<cfif isdefined("attributes.account_id") and len(attributes.account_id)>
					AND (SELECT TOP 1 VP.PAYROLL_ACCOUNT_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN(2,3) ORDER BY VHH.HISTORY_ID DESC) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account_id#" list="yes">)
				</cfif>
				<cfif isdefined("attributes.new_account_id") and len(attributes.new_account_id)>
					AND (SELECT TOP 1 VP.PAYROLL_ACCOUNT_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN(2,3) ORDER BY VHH.HISTORY_ID DESC) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.new_account_id#" list="yes">)
				</cfif>
				<cfif isdefined("bireysel") and listlen(bireysel)>
					AND CONS.CONSUMER_ID IN
						(
						SELECT 
							C.CONSUMER_ID 
						FROM 
							#dsn_alias#.CONSUMER C,
							#dsn_alias#.CONSUMER_CAT CAT 
						WHERE 
							C.CONSUMER_CAT_ID = CAT.CONSCAT_ID AND
							(
								<cfloop list="#bireysel#" delimiters="," index="cat_i">
									(CAT.CONSCAT_ID = #listlast(cat_i,'-')#)
									<cfif cat_i neq listlast(bireysel,',') and listlen(bireysel,',') gte 1> OR</cfif>
								</cfloop>  
							)
						)
				</cfif>
				<cfif isDefined("attributes.sales_zones") and len(attributes.sales_zones)>
					AND CONS.SALES_COUNTY = #attributes.sales_zones#
				</cfif>
				<cfif isdefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_code_text)>
					AND CONS.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE= #attributes.pos_code# AND IS_MASTER=1 AND OUR_COMPANY_ID = #session.ep.company_id# AND CONSUMER_ID IS NOT NULL)
				</cfif>
				<cfif isDefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.employee)>
					AND VP.REVENUE_COLLECTOR_ID = #attributes.employee_id#
				</cfif>
				<cfif isdate(attributes.start_date)>
					AND V.VOUCHER_DUEDATE >=#attributes.start_date#
				</cfif>
				<cfif isdate(attributes.finish_date)>
					AND V.VOUCHER_DUEDATE <=#attributes.finish_date#
				</cfif>
                <cfif isdefined("attributes.is_interest_show")>
                	AND DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE()) > 0
                </cfif>
				<cfif len(attributes.record_date1) and isdate(attributes.record_date1)>
					AND V.RECORD_DATE >=#attributes.record_date1#
				</cfif>
				<cfif len(attributes.record_date2) and isdate(attributes.record_date2)>
					AND V.RECORD_DATE < #DATEADD('d',1,attributes.record_date2)#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.company_id)>
					AND V.COMPANY_ID = #attributes.company_id#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.consumer_id)>
					AND V.CONSUMER_ID = #attributes.consumer_id#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.employee_id_)>
					AND V.EMPLOYEE_ID = #attributes.employee_id_#
				</cfif>
				<cfif len(trim(attributes.company2)) and len(attributes.company_id2)>
					AND (SELECT TOP 1 VP.COMPANY_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS = 4 ORDER BY VHH.HISTORY_ID DESC) = #attributes.company_id2#
				</cfif>
				<cfif len(attributes.status)>
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							AND ISNULL((SELECT VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID IN(SELECT ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_TYPE = 107)),V.VOUCHER_STATUS_ID) IN (#attributes.status#)
						<cfelseif len(attributes.action_date2)>
							AND ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) IN (#attributes.status#)
						<cfelse>	
							AND V.VOUCHER_STATUS_ID IN (#attributes.status#)
						</cfif>
					<cfelse>	
						AND V.VOUCHER_STATUS_ID IN (#attributes.status#)
					</cfif>
				</cfif>
				AND (
						VP.CONSUMER_ID IN(SELECT CONSUMER_ID FROM #dsn_alias#.COMPANY_LAW_REQUEST WHERE CONSUMER_ID IS NOT NULL)
						OR VP.COMPANY_ID IN(SELECT COMPANY_ID FROM #dsn_alias#.COMPANY_LAW_REQUEST WHERE COMPANY_ID IS NOT NULL)
					)
				<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
					AND CASH.CASH_ID = ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID)
				<cfelseif isdefined("attributes.is_status_info")>
					AND CASH.CASH_ID = ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						

						)
				<cfelse>
					AND CASH.CASH_ID = V.CASH_ID
				</cfif>
				<cfif isdefined("attributes.is_status_info")>
					<cfif isdefined("attributes.is_open_acts")>
						AND ISNULL((SELECT VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID IN(SELECT ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_TYPE = 107)),V.VOUCHER_STATUS_ID)=1
					<cfelseif len(attributes.action_date2)>
						AND ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID)=1
					<cfelse>	
						AND V.VOUCHER_STATUS_ID=1
					</cfif>
				<cfelse>	
					AND V.VOUCHER_STATUS_ID=1
				</cfif>
				<cfif len(attributes.action_date1) and isdate(attributes.action_date1)>
					AND V.VOUCHER_ID IN(SELECT VH.VOUCHER_ID FROM VOUCHER_HISTORY VH WHERE <cfif len(attributes.status)>VH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(VH.ACT_DATE,DATEADD(day,-1,VH.RECORD_DATE)) >=#attributes.action_date1#) AND V.VOUCHER_ID = VH.VOUCHER_ID)
				</cfif>
				<cfif len(attributes.action_date2) and isdate(attributes.action_date2)>
					AND V.VOUCHER_ID IN(SELECT VH.VOUCHER_ID FROM VOUCHER_HISTORY VH WHERE <cfif len(attributes.status)>VH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(VH.ACT_DATE,DATEADD(day,-1,VH.RECORD_DATE)) <= #attributes.action_date2#) AND V.VOUCHER_ID = VH.VOUCHER_ID)
				</cfif>
				<cfif isdefined("attributes.is_open_acts")>
					AND VP.PAYROLL_NO='-1'
				</cfif>
				<cfif len(attributes.owner_company) and len(attributes.owner_company_id) and attributes.owner_member_type eq 'partner'>
					AND V.OWNER_COMPANY_ID = #attributes.owner_company_id#
				<cfelseif len(attributes.owner_company) and len(attributes.owner_consumer_id) and attributes.owner_member_type eq 'consumer'>
					AND V.OWNER_CONSUMER_ID = #attributes.owner_consumer_id#
				<cfelseif len(attributes.owner_company) and len(attributes.owner_employee_id) and attributes.owner_member_type eq 'employee'>
					AND V.OWNER_EMPLOYEE_ID = #attributes.owner_employee_id#
				</cfif>
			GROUP BY
			<cfif attributes.report_type eq 4>
				<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
					ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID),
				<cfelseif isdefined("attributes.is_status_info")>
					ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						),
				<cfelse>
					V.CASH_ID,
				</cfif>
				V.VOUCHER_ID,
				CASH.CASH_NAME
				<cfif isdefined("attributes.is_other_money")>
					,V.CURRENCY_ID
				</cfif>
			</cfif>
		</cfquery>
		</cfif>
		<cfif len(bireysel) or not len(kurumsal)>
			<cfquery name="get_cheque_voucher_12" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
				SELECT
					(SELECT TOP 1 VP.PAYROLL_TYPE FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY_TYPE,
					(SELECT TOP 1 VP.PAYROLL_NO FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY_NO,
					(SELECT TOP 1 VHH.PAYROLL_ID FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY,
					(SELECT TOP 1 VP.COMPANY_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS = 4 ORDER BY VHH.HISTORY_ID DESC) AS NEW_COMPANY_ID,
					(SELECT TOP 1 VP.PAYROLL_ACCOUNT_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN(2,3) ORDER BY VHH.HISTORY_ID DESC) AS NEW_ACCOUNT_ID,
					0 AS TOTAL_AMOUNT,
					0 AS AVG_DUEDATE,
					<cfif isdefined("attributes.is_other_money")>
						0 AS TOTAL_AMOUNT_OTHER,
						'#session.ep.money#' AS OTHER_MONEY,
					</cfif>			
					<cfif isdefined("attributes.is_money2")>
						0 AS TOTAL_AMOUNT2,
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						0 AS TOTAL_GECIKME,
						0 AS TOTAL_GECIKME_VADE,
					</cfif>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						)
					<cfelse>
						V.CASH_ID
					</cfif> AS CASH_ID,
					CASH.CASH_NAME AS CASH_NAME,
					0 AS TOTAL_AMOUNT_ICRA,
					0 AS AVG_DUEDATE_ICRA,
					SUM(V.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT_VADE,
					SUM((DATEDIFF(day,GETDATE(),V.VOUCHER_DUEDATE)*V.OTHER_MONEY_VALUE)) AS AVG_DUEDATE_VADE
				FROM
					VOUCHER V,
					VOUCHER_PAYROLL VP,
					#dsn_alias#.COMPANY COMP,
					CASH
					<cfif isdefined("attributes.is_interest")>
					,#dsn_alias#.SETUP_PAYMETHOD SP	
					</cfif>
				WHERE
					V.VOUCHER_PAYROLL_ID = VP.ACTION_ID
					AND VP.COMPANY_ID = COMP.COMPANY_ID
					<cfif not isdefined("attributes.is_pay_term")>
						AND V.IS_PAY_TERM = 0
					<cfelseif isdefined("attributes.is_pay_term") and not isdefined("attributes.is_voucher")>	
						AND V.IS_PAY_TERM = 1
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						AND VP.PAYMETHOD_ID = SP.PAYMETHOD_ID
					</cfif>
					<cfif isdefined("attributes.cash_id") and len(attributes.cash_id)>
						<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
							AND ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID) = #attributes.cash_id#
						<cfelseif isdefined("attributes.is_status_info")>
							AND ISNULL(
								(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
								(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
							) = #attributes.cash_id#
						<cfelse>
							AND V.CASH_ID = #attributes.cash_id#
						</cfif>
					</cfif>
					<cfif isdefined("attributes.account_id") and len(attributes.account_id)>
						AND (SELECT TOP 1 VP.PAYROLL_ACCOUNT_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN(2,3) ORDER BY VHH.HISTORY_ID DESC) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account_id#" list="yes">)
					</cfif>
					<cfif isdefined("attributes.new_account_id") and len(attributes.new_account_id)>
						AND (SELECT TOP 1 VP.PAYROLL_ACCOUNT_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN(2,3) ORDER BY VHH.HISTORY_ID DESC) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.new_account_id#" list="yes">)
					</cfif>
					<cfif isdefined("kurumsal") and listlen(kurumsal)>
						AND COMP.COMPANY_ID IN
							(
							SELECT 
								C.COMPANY_ID 
							FROM 
								#dsn_alias#.COMPANY C,
								#dsn_alias#.COMPANY_CAT CAT 
							WHERE 
								C.COMPANYCAT_ID = CAT.COMPANYCAT_ID AND
								(
									<cfloop list="#kurumsal#" delimiters="," index="cat_i">
										(CAT.COMPANYCAT_ID = #listlast(cat_i,'-')#)
										<cfif cat_i neq listlast(kurumsal,',') and listlen(kurumsal,',') gte 1> OR</cfif>
									</cfloop>  
								)
							)
					</cfif>
					<cfif isDefined("attributes.sales_zones") and len(attributes.sales_zones)>
						AND COMP.SALES_COUNTY = #attributes.sales_zones#
					</cfif>
					<cfif isDefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_code_text)>
						AND COMP.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE= #attributes.pos_code# AND IS_MASTER=1 AND OUR_COMPANY_ID = #session.ep.company_id# AND COMPANY_ID IS NOT NULL)
					</cfif>
					<cfif isDefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.employee)>
						AND VP.REVENUE_COLLECTOR_ID = #attributes.employee_id#
					</cfif>
					<cfif isdate(attributes.start_date)>
						AND V.VOUCHER_DUEDATE >=#attributes.start_date#
					</cfif>
					<cfif isdate(attributes.finish_date)>
						AND V.VOUCHER_DUEDATE <=#attributes.finish_date#
					</cfif>
					<cfif isdefined("attributes.is_interest_show")>
                        AND DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE()) > 0
                    </cfif>
					<cfif len(attributes.record_date1) and isdate(attributes.record_date1)>
						AND V.RECORD_DATE >=#attributes.record_date1#
					</cfif>
					<cfif len(attributes.record_date2) and isdate(attributes.record_date2)>
						AND V.RECORD_DATE < #DATEADD('d',1,attributes.record_date2)#
					</cfif>
					<cfif len(trim(attributes.company)) and len(attributes.company_id)>
						AND V.COMPANY_ID = #attributes.company_id#
					</cfif>
					<cfif len(trim(attributes.company)) and len(attributes.consumer_id)>
						AND V.CONSUMER_ID = #attributes.consumer_id#
					</cfif>
					<cfif len(trim(attributes.company)) and len(attributes.employee_id_)>
						AND V.EMPLOYEE_ID = #attributes.employee_id_#
					</cfif>
					<cfif len(trim(attributes.company2)) and len(attributes.company_id2)>
						AND (SELECT TOP 1 VP.COMPANY_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS = 4 ORDER BY VHH.HISTORY_ID DESC) = #attributes.company_id2#
					</cfif>
					<cfif len(attributes.status)>
						<cfif isdefined("attributes.is_status_info")>
							<cfif isdefined("attributes.is_open_acts")>
								AND ISNULL((SELECT VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID IN(SELECT ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_TYPE = 107)),V.VOUCHER_STATUS_ID) IN (#attributes.status#)
							<cfelseif len(attributes.action_date2)>
								AND ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) IN (#attributes.status#)
							<cfelse>	
								AND V.VOUCHER_STATUS_ID IN (#attributes.status#)
							</cfif>
						<cfelse>	
							AND V.VOUCHER_STATUS_ID IN (#attributes.status#)
						</cfif>
					</cfif>
					AND V.VOUCHER_DUEDATE >= GETDATE()
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						AND CASH.CASH_ID = ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID)
					<cfelseif isdefined("attributes.is_status_info")>
						AND CASH.CASH_ID = ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						)
					<cfelse>
						AND CASH.CASH_ID = V.CASH_ID
					</cfif>
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							AND ISNULL((SELECT VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID IN(SELECT ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_TYPE = 107)),V.VOUCHER_STATUS_ID)=1
						<cfelseif len(attributes.action_date2)>
							AND ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID)=1
						<cfelse>	
							AND V.VOUCHER_STATUS_ID=1
						</cfif>
					<cfelse>	
						AND V.VOUCHER_STATUS_ID=1
					</cfif>
					<cfif len(attributes.action_date1) and isdate(attributes.action_date1)>
						AND V.VOUCHER_ID IN(SELECT VH.VOUCHER_ID FROM VOUCHER_HISTORY VH WHERE <cfif len(attributes.status)>VH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(VH.ACT_DATE,DATEADD(day,-1,VH.RECORD_DATE)) >=#attributes.action_date1#) AND V.VOUCHER_ID = VH.VOUCHER_ID)
					</cfif>
					<cfif len(attributes.action_date2) and isdate(attributes.action_date2)>
						AND V.VOUCHER_ID IN(SELECT VH.VOUCHER_ID FROM VOUCHER_HISTORY VH WHERE <cfif len(attributes.status)>VH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(VH.ACT_DATE,DATEADD(day,-1,VH.RECORD_DATE)) <= #attributes.action_date2#) AND V.VOUCHER_ID = VH.VOUCHER_ID)
					</cfif>
					<cfif isdefined("attributes.is_open_acts")>
						AND VP.PAYROLL_NO='-1'
					</cfif>
					<cfif len(attributes.owner_company) and len(attributes.owner_company_id) and attributes.owner_member_type eq 'partner'>
						AND V.OWNER_COMPANY_ID = #attributes.owner_company_id#
					<cfelseif len(attributes.owner_company) and len(attributes.owner_consumer_id) and attributes.owner_member_type eq 'consumer'>
						AND V.OWNER_CONSUMER_ID = #attributes.owner_consumer_id#
					<cfelseif len(attributes.owner_company) and len(attributes.owner_employee_id) and attributes.owner_member_type eq 'employee'>
						AND V.OWNER_EMPLOYEE_ID = #attributes.owner_employee_id#
					</cfif>
				GROUP BY
				<cfif attributes.report_type eq 4>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID),
					<cfelseif isdefined("attributes.is_status_info")>
						ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						),
					<cfelse>
						V.CASH_ID,
					</cfif>
					V.VOUCHER_ID,
					CASH.CASH_NAME
					<cfif isdefined("attributes.is_other_money")>
						,V.CURRENCY_ID
					</cfif>
				</cfif>
			</cfquery>
		</cfif>
		<cfif not len(kurumsal) or not len(bireysel)>
			<cfquery name="get_cheque_voucher_17" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
			SELECT
				(SELECT TOP 1 VP.PAYROLL_TYPE FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY_TYPE,			
				(SELECT TOP 1 VP.PAYROLL_NO FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY_NO,
				(SELECT TOP 1 VHH.PAYROLL_ID FROM VOUCHER_PAYROLL VP, VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14) ORDER BY VHH.HISTORY_ID DESC) AS PAY,
				(SELECT TOP 1 VP.COMPANY_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS = 4 ORDER BY VHH.HISTORY_ID DESC) AS NEW_COMPANY_ID,
				(SELECT TOP 1 VP.PAYROLL_ACCOUNT_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN(2,3) ORDER BY VHH.HISTORY_ID DESC) AS NEW_ACCOUNT_ID,
				0 AS TOTAL_AMOUNT,
				0 AS AVG_DUEDATE,
				<cfif isdefined("attributes.is_other_money")>
					0 AS TOTAL_AMOUNT_OTHER,
					'#session.ep.money#' AS OTHER_MONEY,
				</cfif>			
				<cfif isdefined("attributes.is_money2")>
					0 AS TOTAL_AMOUNT2,
				</cfif>
				<cfif isdefined("attributes.is_interest")>
					0 AS TOTAL_GECIKME,
					0 AS TOTAL_GECIKME_VADE,
				</cfif>
				<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
					ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID)
				<cfelseif isdefined("attributes.is_status_info")>
					ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						)
				<cfelse>
					V.CASH_ID
				</cfif> AS CASH_ID,
				CASH.CASH_NAME AS CASH_NAME,
				SUM(V.OTHER_MONEY_VALUE) AS TOTAL_AMOUNT_ICRA,
				SUM((DATEDIFF(day,GETDATE(),V.VOUCHER_DUEDATE)*V.OTHER_MONEY_VALUE)) AS AVG_DUEDATE_ICRA,
				0 AS TOTAL_AMOUNT_VADE,
				0 AS AVG_DUEDATE_VADE
			FROM
				VOUCHER V,
				VOUCHER_PAYROLL VP,
				#dsn_alias#.EMPLOYEES EMP,
				CASH
				<cfif isdefined("attributes.is_interest")>
				,#dsn_alias#.SETUP_PAYMETHOD SP	
				</cfif>
			WHERE
				V.VOUCHER_PAYROLL_ID = VP.ACTION_ID
				AND VP.EMPLOYEE_ID = EMP.EMPLOYEE_ID
				<cfif not isdefined("attributes.is_pay_term")>
					AND V.IS_PAY_TERM = 0
				<cfelseif isdefined("attributes.is_pay_term") and not isdefined("attributes.is_voucher")>	
					AND V.IS_PAY_TERM = 1
				</cfif>
				<cfif isdefined("attributes.is_interest")>
					AND VP.PAYMETHOD_ID = SP.PAYMETHOD_ID
				</cfif>
				<cfif isdefined("attributes.cash_id") and len(attributes.cash_id)>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						AND ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID) = #attributes.cash_id#
					<cfelseif isdefined("attributes.is_status_info")>
						AND ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						) = #attributes.cash_id#
					<cfelse>
						AND V.CASH_ID = #attributes.cash_id#
					</cfif>
				</cfif>
				<cfif isdefined("attributes.account_id") and len(attributes.account_id)>
					AND (SELECT TOP 1 VP.PAYROLL_ACCOUNT_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN(2,3) ORDER BY VHH.HISTORY_ID DESC) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account_id#" list="yes">)
				</cfif>
				<cfif isdefined("attributes.new_account_id") and len(attributes.new_account_id)>
					AND (SELECT TOP 1 VP.PAYROLL_ACCOUNT_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN(2,3) ORDER BY VHH.HISTORY_ID DESC) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.new_account_id#" list="yes">)
				</cfif>
				<cfif isdefined("bireysel") and listlen(bireysel)>
					AND CONS.CONSUMER_ID IN
						(
						SELECT 
							C.CONSUMER_ID 
						FROM 
							#dsn_alias#.CONSUMER C,
							#dsn_alias#.CONSUMER_CAT CAT 
						WHERE 
							C.CONSUMER_CAT_ID = CAT.CONSCAT_ID AND
							(
								<cfloop list="#bireysel#" delimiters="," index="cat_i">
									(CAT.CONSCAT_ID = #listlast(cat_i,'-')#)
									<cfif cat_i neq listlast(bireysel,',') and listlen(bireysel,',') gte 1> OR</cfif>
								</cfloop>  
							)
						)
				</cfif>
				<cfif isDefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.employee)>
					AND VP.REVENUE_COLLECTOR_ID = #attributes.employee_id#
				</cfif>
				<cfif isdate(attributes.start_date)>
					AND V.VOUCHER_DUEDATE >=#attributes.start_date#
				</cfif>
				<cfif isdate(attributes.finish_date)>
					AND V.VOUCHER_DUEDATE <=#attributes.finish_date#
				</cfif>
                <cfif isdefined("attributes.is_interest_show")>
                	AND DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE()) > 0
                </cfif>
				<cfif len(attributes.record_date1) and isdate(attributes.record_date1)>
					AND V.RECORD_DATE >=#attributes.record_date1#
				</cfif>
				<cfif len(attributes.record_date2) and isdate(attributes.record_date2)>
					AND V.RECORD_DATE < #DATEADD('d',1,attributes.record_date2)#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.company_id)>
					AND V.COMPANY_ID = #attributes.company_id#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.consumer_id)>
					AND V.CONSUMER_ID = #attributes.consumer_id#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.employee_id_)>
					AND V.EMPLOYEE_ID = #attributes.employee_id_#
				</cfif>
				<cfif len(trim(attributes.company2)) and len(attributes.company_id2)>
					AND (SELECT TOP 1 VP.COMPANY_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS = 4 ORDER BY VHH.HISTORY_ID DESC) = #attributes.company_id2#
				</cfif>
				<cfif len(attributes.status)>
					<cfif isdefined("attributes.is_status_info")>
						<cfif isdefined("attributes.is_open_acts")>
							AND ISNULL((SELECT VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID IN(SELECT ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_TYPE = 107)),V.VOUCHER_STATUS_ID) IN (#attributes.status#)
						<cfelseif len(attributes.action_date2)>
							AND ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID) IN (#attributes.status#)
						<cfelse>	
							AND V.VOUCHER_STATUS_ID IN (#attributes.status#)
						</cfif>
					<cfelse>	
						AND V.VOUCHER_STATUS_ID IN (#attributes.status#)
					</cfif>
				</cfif>
				AND (
						VP.CONSUMER_ID IN(SELECT CONSUMER_ID FROM #dsn_alias#.COMPANY_LAW_REQUEST WHERE CONSUMER_ID IS NOT NULL)
						OR VP.COMPANY_ID IN(SELECT COMPANY_ID FROM #dsn_alias#.COMPANY_LAW_REQUEST WHERE COMPANY_ID IS NOT NULL)
					)
				<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
					AND CASH.CASH_ID = ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID)
				<cfelseif isdefined("attributes.is_status_info")>
					AND CASH.CASH_ID = ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						)
				<cfelse>
					AND CASH.CASH_ID = V.CASH_ID
				</cfif>
				<cfif isdefined("attributes.is_status_info")>
					<cfif isdefined("attributes.is_open_acts")>
						AND ISNULL((SELECT VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID IN(SELECT ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_TYPE = 107)),V.VOUCHER_STATUS_ID)=1
					<cfelseif len(attributes.action_date2)>
						AND ISNULL((SELECT TOP 1 VHH.STATUS FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),V.VOUCHER_STATUS_ID)=1
					<cfelse>	
						AND V.VOUCHER_STATUS_ID=1
					</cfif>
				<cfelse>	
					AND V.VOUCHER_STATUS_ID=1
				</cfif>
				<cfif len(attributes.action_date1) and isdate(attributes.action_date1)>
					AND V.VOUCHER_ID IN(SELECT VH.VOUCHER_ID FROM VOUCHER_HISTORY VH WHERE <cfif len(attributes.status)>VH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(VH.ACT_DATE,DATEADD(day,-1,VH.RECORD_DATE)) >=#attributes.action_date1#) AND V.VOUCHER_ID = VH.VOUCHER_ID)
				</cfif>
				<cfif len(attributes.action_date2) and isdate(attributes.action_date2)>
					AND V.VOUCHER_ID IN(SELECT VH.VOUCHER_ID FROM VOUCHER_HISTORY VH WHERE <cfif len(attributes.status)>VH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(VH.ACT_DATE,DATEADD(day,-1,VH.RECORD_DATE)) <= #attributes.action_date2#) AND V.VOUCHER_ID = VH.VOUCHER_ID)
				</cfif>
				<cfif isdefined("attributes.is_open_acts")>
					AND VP.PAYROLL_NO='-1'
				</cfif>
				<cfif len(attributes.owner_company) and len(attributes.owner_company_id) and attributes.owner_member_type eq 'partner'>
					AND V.OWNER_COMPANY_ID = #attributes.owner_company_id#
				<cfelseif len(attributes.owner_company) and len(attributes.owner_consumer_id) and attributes.owner_member_type eq 'consumer'>
					AND V.OWNER_CONSUMER_ID = #attributes.owner_consumer_id#
				<cfelseif len(attributes.owner_company) and len(attributes.owner_employee_id) and attributes.owner_member_type eq 'employee'>
					AND V.OWNER_EMPLOYEE_ID = #attributes.owner_employee_id#
				</cfif>
			GROUP BY
			<cfif attributes.report_type eq 4>
				<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
					ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID),
				<cfelseif isdefined("attributes.is_status_info")>
					ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						),
				<cfelse>
					V.CASH_ID,
				</cfif>
				V.VOUCHER_ID,
				CASH.CASH_NAME
				<cfif isdefined("attributes.is_other_money")>
					,V.CURRENCY_ID
				</cfif>
			</cfif>
		</cfquery>
		</cfif>
	</cfif>
</cfif>
<cfif attributes.report_type eq 6>
	<cfquery name="get_cheque_actions" datasource="#dsn2#">
		<cfif isdefined("attributes.is_cheque")>
			<!--- çek i��lemleri kasada --->
			SELECT
				C.CHEQUE_STATUS_ID STATUS_ID,
				CASH.CASH_CURRENCY_ID CURRENCY_ID,
				<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
					ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID)
				<cfelseif isdefined("attributes.is_status_info")>
					ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						)
				<cfelse>
					C.CASH_ID
				</cfif> AS ACT_TYPE,
				0 AS TYPE,
				SUM(C.CHEQUE_VALUE) AS AMOUNT_VALUE,
				CASH_NAME ACT_CASH_NAME
			FROM
				CHEQUE C,
				CHEQUE_HISTORY CH,
				PAYROLL P,
				CASH 
			WHERE
				C.CHEQUE_STATUS_ID NOT IN (3,4,6,7,8,9)
				AND C.CHEQUE_ID = CH.CHEQUE_ID
				AND CH.PAYROLL_ID = P.ACTION_ID
                <cfif isdefined("attributes.self_cheque1") and len(attributes.self_cheque1)>
                	AND C.SELF_CHEQUE = 1
                <cfelseif isdefined("attributes.self_cheque2") and len(attributes.self_cheque2)>
                	AND C.SELF_CHEQUE = 0
                </cfif>
				<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
					AND ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID) = CASH.CASH_ID
					AND ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID) IS NOT NULL
				<cfelseif isdefined("attributes.is_status_info")>
					AND ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						) = CASH.CASH_ID
					AND ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						) IS NOT NULL
				<cfelse>
					AND C.CASH_ID = CASH.CASH_ID
					AND C.CASH_ID IS NOT NULL
				</cfif>
				AND CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = CH.CHEQUE_ID AND CHH.PAYROLL_ID IS NOT NULL)
				AND
				(
					C.CHEQUE_STATUS_ID <> 5
					OR
					(
						C.CHEQUE_STATUS_ID = 5
						AND (SELECT CH_NEW.STATUS FROM CHEQUE_HISTORY CH_NEW WHERE CH_NEW.CHEQUE_ID = C.CHEQUE_ID AND CH_NEW.HISTORY_ID = (SELECT MAX(CHH_.HISTORY_ID) FROM CHEQUE_HISTORY CHH_ WHERE CHH_.CHEQUE_ID = CH_NEW.CHEQUE_ID AND CHH_.PAYROLL_ID IS NOT NULL)) = 1
					)
				)
				<cfif isdefined("attributes.cash_id") and len(attributes.cash_id)>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						AND ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID) = #attributes.cash_id#
					<cfelseif isdefined("attributes.is_status_info")>
						AND ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						) = #attributes.cash_id#
					<cfelse>
						AND C.CASH_ID = #attributes.cash_id#
					</cfif>
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.company_id)>
					AND C.COMPANY_ID = #attributes.company_id#
				</cfif>
				<cfif len(attributes.status)>
					AND C.CHEQUE_STATUS_ID IN (#attributes.status#)
				</cfif>
				<cfif isDefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.employee)>
					AND P.REVENUE_COLLECTOR_ID = #attributes.employee_id#
				</cfif>
				<cfif len(trim(attributes.company2)) and len(attributes.company_id2)>
					AND (SELECT TOP 1 P.COMPANY_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS = 4 ORDER BY CHH.HISTORY_ID DESC) = #attributes.company_id2#
				</cfif>
				<cfif isdefined("attributes.new_account_id") and len(attributes.new_account_id)>
					AND (SELECT TOP 1 P.PAYROLL_ACCOUNT_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(2,3) ORDER BY CHH.HISTORY_ID DESC) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.new_account_id#" list="yes">)
				</cfif>
				<cfif isdefined("attributes.status") and len(attributes.status)>
					AND C.CHEQUE_STATUS_ID IN (#attributes.STATUS#)
				</cfif>
				<cfif isdefined("attributes.account_id") and len(attributes.account_id)>
					AND P.PAYROLL_ACCOUNT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account_id#" list="yes">)
				</cfif>
				<cfif isdefined("attributes.is_open_acts")>
					AND P.PAYROLL_NO='-1'
				</cfif>
				<cfif isdate(attributes.start_date)>
					AND C.CHEQUE_DUEDATE >=#attributes.start_date#
				</cfif>
                <cfif isdefined("attributes.is_interest_show")>
                	AND DATEDIFF(day,C.CHEQUE_DUEDATE,GETDATE()) > 0
                </cfif>
				<cfif len(attributes.record_date1) and isdate(attributes.record_date1)>
					AND C.RECORD_DATE >=#attributes.record_date1#
				</cfif>
				<cfif len(attributes.record_date2) and isdate(attributes.record_date2)>
					AND C.RECORD_DATE < #DATEADD('d',1,attributes.record_date2)#
				</cfif>
				<cfif len(attributes.action_date1) and isdate(attributes.action_date1)>
					AND C.CHEQUE_ID IN(SELECT CH.CHEQUE_ID FROM CHEQUE_HISTORY CH WHERE <cfif len(attributes.status)>CH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(CH.ACT_DATE,DATEADD(day,-1,CH.RECORD_DATE)) >=#attributes.action_date1#) AND C.CHEQUE_ID = CH.CHEQUE_ID)
				</cfif>
				<cfif isdate(attributes.finish_date)>
					AND C.CHEQUE_DUEDATE <=#attributes.finish_date#
				</cfif>
				<cfif len(attributes.owner_company) and len(attributes.owner_company_id) and attributes.owner_member_type eq 'partner'>
					AND C.OWNER_COMPANY_ID = #attributes.owner_company_id#
				<cfelseif len(attributes.owner_company) and len(attributes.owner_consumer_id) and attributes.owner_member_type eq 'consumer'>
					AND C.OWNER_CONSUMER_ID = #attributes.owner_consumer_id#
				<cfelseif len(attributes.owner_company) and len(attributes.owner_employee_id) and attributes.owner_member_type eq 'employee'>
					AND C.OWNER_EMPLOYEE_ID = #attributes.owner_employee_id#
				</cfif>
			GROUP BY 
				C.CHEQUE_STATUS_ID,
				CASH.CASH_CURRENCY_ID,
				<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
					ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID)
				<cfelseif isdefined("attributes.is_status_info")>
					ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						)
				<cfelse>
					C.CASH_ID
				</cfif>,
				CASH_NAME
			UNION ALL
			<!--- çek i��lemleri bankada --->
			SELECT
				C.CHEQUE_STATUS_ID STATUS_ID,
				ACCOUNTS.ACCOUNT_CURRENCY_ID CURRENCY_ID,
				P.PAYROLL_ACCOUNT_ID AS ACT_TYPE,
				1 AS TYPE,
				SUM(C.CHEQUE_VALUE) AS AMOUNT_VALUE,
				ACCOUNT_NAME ACT_CASH_NAME
			FROM
				CHEQUE C,
				CHEQUE_HISTORY CH,
				PAYROLL P,
				#dsn3_alias#.ACCOUNTS
			WHERE
				C.CHEQUE_STATUS_ID NOT IN (3,4,6,7,8,9,10)
				AND C.CHEQUE_ID = CH.CHEQUE_ID
				AND CH.PAYROLL_ID = P.ACTION_ID
				AND P.PAYROLL_ACCOUNT_ID = ACCOUNTS.ACCOUNT_ID
				AND CH.HISTORY_ID = (SELECT MAX(CHH.HISTORY_ID) FROM CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = CH.CHEQUE_ID AND CHH.PAYROLL_ID IS NOT NULL)
				AND
				(
					C.CHEQUE_STATUS_ID <> 5
					OR
					(
						C.CHEQUE_STATUS_ID = 5
						AND (SELECT CH_NEW.STATUS FROM CHEQUE_HISTORY CH_NEW WHERE CH_NEW.CHEQUE_ID = C.CHEQUE_ID AND CH_NEW.HISTORY_ID = (SELECT MAX(CHH_.HISTORY_ID) FROM CHEQUE_HISTORY CHH_ WHERE CHH_.CHEQUE_ID = CH_NEW.CHEQUE_ID AND CHH_.PAYROLL_ID IS NOT NULL)) IN(2,13)
					)
				)
                <cfif isdefined("attributes.self_cheque1") and len(attributes.self_cheque1)>
                	AND C.SELF_CHEQUE = 1
                <cfelseif isdefined("attributes.self_cheque2") and len(attributes.self_cheque2)>
                	AND C.SELF_CHEQUE = 0
                </cfif>
				<cfif isdefined("attributes.cash_id") and len(attributes.cash_id)>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						AND ISNULL(P.PAYROLL_CASH_ID,C.CASH_ID) = #attributes.cash_id#
					<cfelseif isdefined("attributes.is_status_info")>
						AND ISNULL(
							(SELECT TOP 1 PY.TRANSFER_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC),
							(SELECT TOP 1 PY.PAYROLL_CASH_ID FROM PAYROLL PY,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = PY.ACTION_ID AND ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(CHH.ACT_DATE,DATEADD(day,-1,CHH.RECORD_DATE)) DESC,CHH.HISTORY_ID DESC)
						) = #attributes.cash_id#
					<cfelse>
						AND C.CASH_ID = #attributes.cash_id#
					</cfif>
				</cfif>
				<cfif isdefined("attributes.status") and len(attributes.status)>
					AND C.CHEQUE_STATUS_ID IN (#attributes.STATUS#)
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.company_id)>
					AND C.COMPANY_ID = #attributes.company_id#
				</cfif>
				<cfif len(attributes.status)>
					AND C.CHEQUE_STATUS_ID IN (#attributes.status#)
				</cfif>
				<cfif isDefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.employee)>
					AND P.REVENUE_COLLECTOR_ID = #attributes.employee_id#
				</cfif>
				<cfif len(trim(attributes.company2)) and len(attributes.company_id2)>
					AND (SELECT TOP 1 P.COMPANY_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS = 4 ORDER BY CHH.HISTORY_ID DESC) = #attributes.company_id2#
				</cfif>
				<cfif isdefined("attributes.new_account_id") and len(attributes.new_account_id)>
					AND (SELECT TOP 1 P.PAYROLL_ACCOUNT_ID FROM PAYROLL P,CHEQUE_HISTORY CHH WHERE CHH.CHEQUE_ID = C.CHEQUE_ID AND CHH.PAYROLL_ID = P.ACTION_ID AND CHH.STATUS IN(2,3) ORDER BY CHH.HISTORY_ID DESC) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.new_account_id#" list="yes">)
				</cfif>
				<cfif isdefined("attributes.account_id") and len(attributes.account_id)>
					AND P.PAYROLL_ACCOUNT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account_id#" list="yes">)
				</cfif>
				<cfif isdefined("attributes.is_open_acts")>
					AND P.PAYROLL_NO='-1'
				</cfif>
				<cfif isdate(attributes.start_date)>
					AND C.CHEQUE_DUEDATE >=#attributes.start_date#
				</cfif>
                <cfif isdefined("attributes.is_interest_show")>
                	AND DATEDIFF(day,C.CHEQUE_DUEDATE,GETDATE()) > 0
                </cfif>
				<cfif len(attributes.record_date1) and isdate(attributes.record_date1)>
					AND C.RECORD_DATE >=#attributes.record_date1#
				</cfif>
				<cfif len(attributes.record_date2) and isdate(attributes.record_date2)>
					AND C.RECORD_DATE < #DATEADD('d',1,attributes.record_date2)#
				</cfif>
				<cfif len(attributes.action_date1) and isdate(attributes.action_date1)>
					AND C.CHEQUE_ID IN(SELECT CH.CHEQUE_ID FROM CHEQUE_HISTORY CH WHERE <cfif len(attributes.status)>CH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(CH.ACT_DATE,DATEADD(day,-1,CH.RECORD_DATE)) >=#attributes.action_date1#) AND C.CHEQUE_ID = CH.CHEQUE_ID)
				</cfif>
				<cfif isdate(attributes.finish_date)>
					AND C.CHEQUE_DUEDATE <=#attributes.finish_date#
				</cfif>
				<cfif len(attributes.owner_company) and len(attributes.owner_company_id) and attributes.owner_member_type eq 'partner'>
					AND C.OWNER_COMPANY_ID = #attributes.owner_company_id#
				<cfelseif len(attributes.owner_company) and len(attributes.owner_consumer_id) and attributes.owner_member_type eq 'consumer'>
					AND C.OWNER_CONSUMER_ID = #attributes.owner_consumer_id#
				<cfelseif len(attributes.owner_company) and len(attributes.owner_employee_id) and attributes.owner_member_type eq 'employee'>
					AND C.OWNER_EMPLOYEE_ID = #attributes.owner_employee_id#
				</cfif>
			GROUP BY 
				C.CHEQUE_STATUS_ID,
				ACCOUNTS.ACCOUNT_CURRENCY_ID,
				P.PAYROLL_ACCOUNT_ID,
				ACCOUNT_NAME
		</cfif>
		<cfif isdefined("attributes.is_cheque") and (isdefined("attributes.is_voucher") or isdefined("attributes.is_pay_term"))>
			UNION ALL 
		</cfif>
		<cfif (isdefined("attributes.is_voucher") or isdefined("attributes.is_pay_term"))>
			<!--- Senet i��lemleri kasada --->
			SELECT
				V.VOUCHER_STATUS_ID STATUS_ID,
				CASH.CASH_CURRENCY_ID CURRENCY_ID,
				<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
					ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID)
				<cfelseif isdefined("attributes.is_status_info")>
					ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						)
				<cfelse>
					V.CASH_ID
				</cfif> AS ACT_TYPE,
				0 AS TYPE,
				SUM(V.VOUCHER_VALUE) AS AMOUNT_VALUE ,
				CASH_NAME ACT_CASH_NAME
			FROM
				VOUCHER V,
				VOUCHER_HISTORY VH,
				VOUCHER_PAYROLL VP,
				CASH 
			WHERE
				V.VOUCHER_STATUS_ID NOT IN (3,4,6,7,8,9)
				AND V.VOUCHER_ID = VH.VOUCHER_ID
				AND VH.PAYROLL_ID = VP.ACTION_ID
				<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
					AND ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID) = CASH.CASH_ID
					AND ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID) IS NOT NULL
				<cfelseif isdefined("attributes.is_status_info")>
					AND ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						) = CASH.CASH_ID
					AND ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						) IS NOT NULL
				<cfelse>
					AND V.CASH_ID = CASH.CASH_ID
					AND V.CASH_ID IS NOT NULL
				</cfif>
				<cfif not isdefined("attributes.is_pay_term")>
					AND V.IS_PAY_TERM = 0
				<cfelseif isdefined("attributes.is_pay_term") and not isdefined("attributes.is_voucher")>	
					AND V.IS_PAY_TERM = 1
				</cfif>
				AND VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = VH.VOUCHER_ID AND VHH.PAYROLL_ID IS NOT NULL)
				AND
				(
					V.VOUCHER_STATUS_ID <> 5
					OR
					(
						V.VOUCHER_STATUS_ID = 5
						AND (SELECT VH_NEW.STATUS FROM VOUCHER_HISTORY VH_NEW WHERE VH_NEW.VOUCHER_ID = V.VOUCHER_ID AND VH_NEW.HISTORY_ID = (SELECT MAX(VHH_.HISTORY_ID) FROM VOUCHER_HISTORY VHH_ WHERE VHH_.VOUCHER_ID = VH_NEW.VOUCHER_ID AND VHH_.PAYROLL_ID IS NOT NULL))=1
					)
				)
				<cfif isDefined("attributes.account_id") and len(attributes.account_id)>
					AND VP.PAYROLL_ACCOUNT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account_id#" list="yes">)
				</cfif>
				<cfif isDefined("attributes.status") and len(attributes.status)>
					AND V.VOUCHER_STATUS_ID IN (#attributes.status#)
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.company_id)>
					AND V.COMPANY_ID = #attributes.company_id#
				</cfif>
				<cfif len(attributes.status)>
					AND V.VOUCHER_STATUS_ID IN (#attributes.status#)
				</cfif>
				<cfif isDefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.employee)>
					AND VP.REVENUE_COLLECTOR_ID = #attributes.employee_id#
				</cfif>
				<cfif isdefined("attributes.is_open_acts")>
					AND VP.PAYROLL_NO='-1'
				</cfif>
				<cfif len(trim(attributes.company2)) and len(attributes.company_id2)>
					AND (SELECT TOP 1 VP.COMPANY_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS = 4 ORDER BY VHH.HISTORY_ID DESC) = #attributes.company_id2#
				</cfif>
				<cfif isdefined("attributes.new_account_id") and len(attributes.new_account_id)>
					AND (SELECT TOP 1 VP.PAYROLL_ACCOUNT_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN(2,3) ORDER BY VHH.HISTORY_ID DESC) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.new_account_id#" list="yes">)
				</cfif>
				<cfif isdate(attributes.finish_date)>
					AND V.VOUCHER_DUEDATE <=#attributes.finish_date#
				</cfif>
				<cfif len(attributes.record_date1) and isdate(attributes.record_date1)>
					AND V.RECORD_DATE >=#attributes.record_date1#
				</cfif>
				<cfif len(attributes.record_date2) and isdate(attributes.record_date2)>
					AND V.RECORD_DATE < #DATEADD('d',1,attributes.record_date2)#
				</cfif>
				<cfif len(attributes.action_date1) and isdate(attributes.action_date1)>
					AND V.VOUCHER_ID IN(SELECT VH.VOUCHER_ID FROM VOUCHER_HISTORY VH WHERE <cfif len(attributes.status)>VH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(VH.ACT_DATE,DATEADD(day,-1,VH.RECORD_DATE)) >=#attributes.action_date1#) AND V.VOUCHER_ID = VH.VOUCHER_ID)
				</cfif>
				<cfif isdate(attributes.start_date)>
					AND V.VOUCHER_DUEDATE >=#attributes.start_date#
				</cfif>
                <cfif isdefined("attributes.is_interest_show")>
                	AND DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE()) > 0
                </cfif>
				<cfif isdefined("attributes.cash_id") and len(attributes.cash_id)>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						AND ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID) = #attributes.cash_id#
					<cfelseif isdefined("attributes.is_status_info")>
						AND ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						) = #attributes.cash_id#
					<cfelse>
						AND V.CASH_ID = #attributes.cash_id#
					</cfif>
				</cfif>
				<cfif len(attributes.owner_company) and len(attributes.owner_company_id) and attributes.owner_member_type eq 'partner'>
					AND V.OWNER_COMPANY_ID = #attributes.owner_company_id#
				<cfelseif len(attributes.owner_company) and len(attributes.owner_consumer_id) and attributes.owner_member_type eq 'consumer'>
					AND V.OWNER_CONSUMER_ID = #attributes.owner_consumer_id#
				<cfelseif len(attributes.owner_company) and len(attributes.owner_employee_id) and attributes.owner_member_type eq 'employee'>
					AND V.OWNER_EMPLOYEE_ID = #attributes.owner_employee_id#
				</cfif>
			GROUP BY 
				V.VOUCHER_STATUS_ID,
				CASH.CASH_CURRENCY_ID,
				<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
					ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID)
				<cfelseif isdefined("attributes.is_status_info")>
					ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						)
				<cfelse>
					V.CASH_ID
				</cfif>,
				CASH_NAME
			UNION ALL 
			<!--- senet i��lemleri bankada --->
			SELECT
				V.VOUCHER_STATUS_ID STATUS_ID,
				ACCOUNTS.ACCOUNT_CURRENCY_ID CURRENCY_ID,
				VP.PAYROLL_ACCOUNT_ID AS ACT_TYPE,
				1 AS TYPE,
				SUM(V.VOUCHER_VALUE) AS AMOUNT_VALUE,
				ACCOUNT_NAME ACT_CASH_NAME
			FROM
				VOUCHER V,
				VOUCHER_HISTORY VH,
				VOUCHER_PAYROLL VP,
				#dsn3_alias#.ACCOUNTS
			WHERE
				V.VOUCHER_STATUS_ID NOT IN (3,4,6,7,8,9,10)
				AND V.VOUCHER_ID = VH.VOUCHER_ID
				AND VH.PAYROLL_ID = VP.ACTION_ID
				AND VP.PAYROLL_ACCOUNT_ID = ACCOUNTS.ACCOUNT_ID
				<cfif not isdefined("attributes.is_pay_term")>
					AND V.IS_PAY_TERM = 0
				<cfelseif isdefined("attributes.is_pay_term") and not isdefined("attributes.is_voucher")>	
					AND V.IS_PAY_TERM = 1
				</cfif>
				AND VH.HISTORY_ID = (SELECT MAX(VHH.HISTORY_ID) FROM VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = VH.VOUCHER_ID AND VHH.PAYROLL_ID IS NOT NULL)
				AND
				(
					V.VOUCHER_STATUS_ID <> 5
					OR
					(
						V.VOUCHER_STATUS_ID = 5
						AND (SELECT VH_NEW.STATUS FROM VOUCHER_HISTORY VH_NEW WHERE VH_NEW.VOUCHER_ID = V.VOUCHER_ID AND VH_NEW.HISTORY_ID = (SELECT MAX(VHH_.HISTORY_ID) FROM VOUCHER_HISTORY VHH_ WHERE VHH_.VOUCHER_ID = VH_NEW.VOUCHER_ID AND VHH_.PAYROLL_ID IS NOT NULL))IN(2,13)
					)
				)
				<cfif isDefined("attributes.account_id") and len(attributes.account_id)>
					AND VP.PAYROLL_ACCOUNT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account_id#" list="yes">)
				</cfif>
				<cfif isDefined("attributes.status") and len(attributes.status)>
					AND V.VOUCHER_STATUS_ID IN (#attributes.status#)
				</cfif>		
				<cfif isdate(attributes.finish_date)>
					AND V.VOUCHER_DUEDATE <=#attributes.finish_date#
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.company_id)>
					AND V.COMPANY_ID = #attributes.company_id#
				</cfif>
				<cfif len(attributes.status)>
					AND V.VOUCHER_STATUS_ID IN (#attributes.status#)
				</cfif>
				<cfif isDefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.employee)>
					AND VP.REVENUE_COLLECTOR_ID = #attributes.employee_id#
				</cfif>
				<cfif isdefined("attributes.is_open_acts")>
					AND VP.PAYROLL_NO='-1'
				</cfif>
				<cfif len(trim(attributes.company2)) and len(attributes.company_id2)>
					AND (SELECT TOP 1 VP.COMPANY_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS = 4 ORDER BY VHH.HISTORY_ID DESC) = #attributes.company_id2#
				</cfif>
				<cfif isdefined("attributes.new_account_id") and len(attributes.new_account_id)>
					AND (SELECT TOP 1 VP.PAYROLL_ACCOUNT_ID FROM VOUCHER_PAYROLL VP,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = VP.ACTION_ID AND VHH.STATUS IN(2,3) ORDER BY VHH.HISTORY_ID DESC) IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.new_account_id#" list="yes">)
				</cfif>
				<cfif isdate(attributes.start_date)>
					AND V.VOUCHER_DUEDATE >=#attributes.start_date#
				</cfif>
                <cfif isdefined("attributes.is_interest_show")>
                	AND DATEDIFF(day,V.VOUCHER_DUEDATE,GETDATE()) > 0
                </cfif>
				<cfif len(attributes.record_date1) and isdate(attributes.record_date1)>

					AND V.RECORD_DATE >=#attributes.record_date1#
				</cfif>
				<cfif len(attributes.record_date2) and isdate(attributes.record_date2)>
					AND V.RECORD_DATE < #DATEADD('d',1,attributes.record_date2)#
				</cfif>
				<cfif len(attributes.action_date1) and isdate(attributes.action_date1)>
					AND V.VOUCHER_ID IN(SELECT VH.VOUCHER_ID FROM VOUCHER_HISTORY VH WHERE <cfif len(attributes.status)>VH.STATUS IN (#attributes.status#) AND </cfif>(ISNULL(VH.ACT_DATE,DATEADD(day,-1,VH.RECORD_DATE)) >=#attributes.action_date1#) AND V.VOUCHER_ID = VH.VOUCHER_ID)
				</cfif>
				<cfif isdefined("attributes.cash_id") and len(attributes.cash_id)>
					<cfif isdefined("attributes.is_first_cash") and attributes.is_first_cash eq 1>
						AND ISNULL(VP.PAYROLL_CASH_ID,V.CASH_ID) = #attributes.cash_id#
					<cfelseif isdefined("attributes.is_status_info")>
						AND ISNULL(
							(SELECT TOP 1 PV.TRANSFER_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC),
							(SELECT TOP 1 PV.PAYROLL_CASH_ID FROM VOUCHER_PAYROLL PV,VOUCHER_HISTORY VHH WHERE VHH.VOUCHER_ID = V.VOUCHER_ID AND VHH.PAYROLL_ID = PV.ACTION_ID AND ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) <= #attributes.action_date2# ORDER BY ISNULL(VHH.ACT_DATE,DATEADD(day,-1,VHH.RECORD_DATE)) DESC,VHH.HISTORY_ID DESC)						
						) = #attributes.cash_id#
					<cfelse>
						AND V.CASH_ID = #attributes.cash_id#
					</cfif>
				</cfif>
				<cfif len(attributes.owner_company) and len(attributes.owner_company_id) and attributes.owner_member_type eq 'partner'>
					AND V.OWNER_COMPANY_ID = #attributes.owner_company_id#
				<cfelseif len(attributes.owner_company) and len(attributes.owner_consumer_id) and attributes.owner_member_type eq 'consumer'>
					AND V.OWNER_CONSUMER_ID = #attributes.owner_consumer_id#
				<cfelseif len(attributes.owner_company) and len(attributes.owner_employee_id) and attributes.owner_member_type eq 'employee'>
					AND V.OWNER_EMPLOYEE_ID = #attributes.owner_employee_id#
				</cfif>
			GROUP BY 
				V.VOUCHER_STATUS_ID,
				ACCOUNTS.ACCOUNT_CURRENCY_ID,
				VP.PAYROLL_ACCOUNT_ID,
				ACCOUNT_NAME
		</cfif>
	</cfquery>
	<cfquery name="get_cheque_voucher" dbtype="query">
		SELECT DISTINCT
			ACT_TYPE,
			ACT_CASH_NAME,
			CURRENCY_ID,
			TYPE
		FROM 
			get_cheque_actions
		WHERE 
			TYPE = 0
			<cfif isdefined("attributes.cash_id") and len(attributes.cash_id)>
				AND ACT_TYPE = #attributes.cash_id#
			</cfif>
			<cfif isdefined("attributes.account_id") and len(attributes.account_id)>
				AND 1 = 2
			</cfif>
		UNION 
		SELECT DISTINCT
			ACT_TYPE,
			ACT_CASH_NAME,
			CURRENCY_ID,
			TYPE
		FROM 
			get_cheque_actions
		WHERE
			TYPE = 1
			<cfif isdefined("attributes.account_id") and len(attributes.account_id)>
				AND ACT_TYPE IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account_id#" list="yes">)
			</cfif>
			<cfif isdefined("attributes.cash_id") and len(attributes.cash_id)>
				AND 1 = 2
			</cfif>
		ORDER BY
			TYPE,
			ACT_CASH_NAME
	</cfquery>
</cfif>
<cfif isdefined("attributes.is_cheque") and attributes.report_type neq 6>
	<cfquery name="get_cheque_voucher1" dbtype="query">
		<cfif isdefined("get_cheque_voucher_1")>
			SELECT * FROM get_cheque_voucher_1
		</cfif>
		<cfif isdefined("get_cheque_voucher_2")>
			<cfif isdefined("get_cheque_voucher_1")>UNION ALL</cfif>
			SELECT * FROM get_cheque_voucher_2
		</cfif>
		<cfif isdefined("get_cheque_voucher_3")>
			<cfif isdefined("get_cheque_voucher_1") or isdefined("get_cheque_voucher_2")>UNION ALL</cfif>
			SELECT * FROM get_cheque_voucher_3
		</cfif>
		<cfif isdefined("get_cheque_voucher_4")>			
			<cfif isdefined("get_cheque_voucher_1") or isdefined("get_cheque_voucher_2") or isdefined("get_cheque_voucher_3")>UNION ALL</cfif>
			SELECT * FROM get_cheque_voucher_4
		</cfif>
		<cfif isdefined("get_cheque_voucher_13")>		
			<cfif isdefined("get_cheque_voucher_1") or isdefined("get_cheque_voucher_2") or isdefined("get_cheque_voucher_3") or isdefined("get_cheque_voucher_4")>UNION ALL</cfif>
			SELECT * FROM get_cheque_voucher_13
		</cfif>
		<cfif isdefined("get_cheque_voucher_14")>			
			<cfif isdefined("get_cheque_voucher_1") or isdefined("get_cheque_voucher_2") or isdefined("get_cheque_voucher_3") or isdefined("get_cheque_voucher_4") or isdefined("get_cheque_voucher_13")>UNION ALL</cfif>
			SELECT * FROM get_cheque_voucher_14
		</cfif>
		<cfif isdefined("get_cheque_voucher_transfer")>
		<cfif isdefined("get_cheque_voucher_1") or isdefined("get_cheque_voucher_2") or isdefined("get_cheque_voucher_3") or isdefined("get_cheque_voucher_4") or isdefined("get_cheque_voucher_13") or isdefined("get_cheque_voucher_14")>UNION ALL</cfif>
			SELECT * FROM get_cheque_voucher_transfer
		</cfif>
		<cfif attributes.report_type eq 4>
			<cfif isdefined("get_cheque_voucher_5")>			
				<cfif isdefined("get_cheque_voucher_1") or isdefined("get_cheque_voucher_2") or isdefined("get_cheque_voucher_3") or isdefined("get_cheque_voucher_4")or isdefined("get_cheque_voucher_13")or isdefined("get_cheque_voucher_14")>UNION ALL</cfif>
				SELECT * FROM get_cheque_voucher_5
			</cfif>
			<cfif isdefined("get_cheque_voucher_6")>			
				<cfif isdefined("get_cheque_voucher_1") or isdefined("get_cheque_voucher_2") or isdefined("get_cheque_voucher_3") or isdefined("get_cheque_voucher_4") or isdefined("get_cheque_voucher_5") or isdefined("get_cheque_voucher_13") or isdefined("get_cheque_voucher_14")>UNION ALL</cfif>
				SELECT * FROM get_cheque_voucher_6
			</cfif>
		</cfif>
	</cfquery>
</cfif>
<cfif (isdefined("attributes.is_voucher") or isdefined("attributes.is_pay_term")) and attributes.report_type neq 6>
	<cfquery name="get_cheque_voucher2" dbtype="query">
		<cfif isdefined("get_cheque_voucher_7")>
			SELECT * FROM get_cheque_voucher_7
		</cfif>
		<cfif isdefined("get_cheque_voucher_8")>
			<cfif isdefined("get_cheque_voucher_7")>UNION ALL</cfif>
			SELECT * FROM get_cheque_voucher_8
		</cfif>
		<cfif isdefined("get_cheque_voucher_9")>
			<cfif isdefined("get_cheque_voucher_7") or isdefined("get_cheque_voucher_8")>UNION ALL</cfif>
			SELECT * FROM get_cheque_voucher_9
		</cfif>
		<cfif isdefined("get_cheque_voucher_10")>			
			<cfif isdefined("get_cheque_voucher_7") or isdefined("get_cheque_voucher_8") or isdefined("get_cheque_voucher_9")>UNION ALL</cfif>
			SELECT * FROM get_cheque_voucher_10
		</cfif>
		<cfif isdefined("get_cheque_voucher_15")>			
			<cfif isdefined("get_cheque_voucher_7") or isdefined("get_cheque_voucher_8") or isdefined("get_cheque_voucher_9") or isdefined("get_cheque_voucher_10")>UNION ALL</cfif>
			SELECT * FROM get_cheque_voucher_15
		</cfif>
		<cfif isdefined("get_cheque_voucher_16")>			
			<cfif isdefined("get_cheque_voucher_7") or isdefined("get_cheque_voucher_8") or isdefined("get_cheque_voucher_9") or isdefined("get_cheque_voucher_10") or isdefined("get_cheque_voucher_15")>UNION ALL</cfif>
			SELECT * FROM get_cheque_voucher_16
		</cfif>
		<cfif attributes.report_type eq 4>
			<cfif isdefined("get_cheque_voucher_11")>			
				<cfif isdefined("get_cheque_voucher_7") or isdefined("get_cheque_voucher_8") or isdefined("get_cheque_voucher_9") or isdefined("get_cheque_voucher_10") or isdefined("get_cheque_voucher_15") or isdefined("get_cheque_voucher_16")>UNION ALL</cfif>
				SELECT * FROM get_cheque_voucher_11
			</cfif>
			<cfif isdefined("get_cheque_voucher_12")>			
				<cfif isdefined("get_cheque_voucher_7") or isdefined("get_cheque_voucher_8") or isdefined("get_cheque_voucher_9") or isdefined("get_cheque_voucher_10") or isdefined("get_cheque_voucher_15") or isdefined("get_cheque_voucher_16") or isdefined("get_cheque_voucher_11")>UNION ALL</cfif>
				SELECT * FROM get_cheque_voucher_12
			</cfif>
			<cfif isdefined("get_cheque_voucher_17")>			
				<cfif isdefined("get_cheque_voucher_7") or isdefined("get_cheque_voucher_8") or isdefined("get_cheque_voucher_9") or isdefined("get_cheque_voucher_10") or isdefined("get_cheque_voucher_15") or isdefined("get_cheque_voucher_16") or isdefined("get_cheque_voucher_11") or isdefined("get_cheque_voucher_12")>UNION ALL</cfif>
				SELECT * FROM get_cheque_voucher_17
			</cfif>
		</cfif>
	</cfquery>
</cfif>
<cfif attributes.report_type neq 6>
	<cfquery name="get_cheque_voucher" dbtype="query">
		<cfif isdefined("attributes.is_cheque")>
			SELECT * FROM get_cheque_voucher1
		</cfif>
		<cfif isdefined("attributes.is_cheque") and (isdefined("attributes.is_voucher") or isdefined("attributes.is_pay_term"))>
			UNION ALL
		</cfif>
		<cfif (isdefined("attributes.is_voucher") or isdefined("attributes.is_pay_term"))>
			SELECT * FROM get_cheque_voucher2
		</cfif>
	</cfquery>
	<cfif get_cheque_voucher.recordcount>	
		<cfquery name="get_cheque_voucher" dbtype="query">
			SELECT 
				<cfif attributes.report_type neq 1 and attributes.report_type neq 5>
					SUM(TOTAL_AMOUNT) AS TOTAL_AMOUNT,
					SUM(AVG_DUEDATE)/SUM(TOTAL_AMOUNT) AS AVG_DUEDATE,
					<cfif isdefined("attributes.is_other_money")>
						SUM(TOTAL_AMOUNT_OTHER) AS TOTAL_AMOUNT_OTHER,
						OTHER_MONEY,
					</cfif>			
					<cfif isdefined("attributes.is_money2")>
						SUM(TOTAL_AMOUNT2) AS TOTAL_AMOUNT2,
					</cfif>
					<cfif isdefined("attributes.is_interest")>
						SUM(TOTAL_GECIKME) AS TOTAL_GECIKME,
						<cfif attributes.report_type eq 4>
							SUM(TOTAL_GECIKME_VADE) AS TOTAL_GECIKME_VADE,	
						</cfif>
					</cfif>
				</cfif>
				<cfif attributes.report_type eq 1>
					SUM(GECIKME_TUTAR) GECIKME_TUTAR,
					SUM(OTHER_MONEY_VALUE) OTHER_MONEY_VALUE,
					SUM(OTHER_MONEY_VALUE2) OTHER_MONEY_VALUE2,
					SUM(OTHER_ACT_VALUE) OTHER_ACT_VALUE,
					ACCOUNT_NO,
					ISLEM_ID,
					OZEL_KOD,
					DUE_DATE,
					PAPER_NO,
					STATUS,
					DEBTOR_NAME,
					BANK_NAME,
					BANK_BRANCH_NAME,
					PAY_NO,
					PAY_TYPE,
					PAY,
					CASH_ID,
					NEW_COMPANY_ID,
					NEW_ACCOUNT_ID,
					ACCOUNT_ID,
					ORDER_ID,
					PAYMETHOD_ID,
					OTHER_MONEY,
					MEMBER_ID,
					MUSTERI,
					MEMBER_CODE,
					M_OZEL_KOD,
					MEMBER_TYPE,
					TYPE,
                    PROJECT_HEAD,
					TAHSILAT_TARIHI	
				<cfelseif attributes.report_type eq 3>
					LAW_ADWOCATE
				<cfelseif attributes.report_type eq 4>
					CASH_ID,
					CASH_NAME,
					SUM(TOTAL_AMOUNT_ICRA) AS TOTAL_AMOUNT_ICRA,
					SUM(AVG_DUEDATE_ICRA) AS AVG_DUEDATE_ICRA,
					SUM(TOTAL_AMOUNT_VADE) AS TOTAL_AMOUNT_VADE,
					SUM(AVG_DUEDATE_VADE) AS AVG_DUEDATE_VADE
				<cfelseif attributes.report_type eq 2>
					<cfif isdefined("attributes.bloke_member") and attributes.bloke_member eq 1>
						FILE_NUMBER,
						LAW_ADWOCATE,
					</cfif>
					MEMBER_ID,
					MUSTERI,
					MEMBER_CODE,
					M_OZEL_KOD,
					MOBIL_TEL,
					MEMBER_TYPE		
				<cfelseif attributes.report_type eq 5>
					STATUS,
					MONTH_DUE,
					YEAR_DUE
					<cfif isdefined("attributes.is_other_money")>
					,OTHER_MONEY
					,SUM(TOTAL_AMOUNT_OTHER) TUTAR
					<cfelse>
					,SUM(TOTAL_AMOUNT) TUTAR
					</cfif>
				</cfif>
			FROM
				get_cheque_voucher
			GROUP BY
				<cfif attributes.report_type eq 1>
					ACCOUNT_NO,
					ISLEM_ID,
					OZEL_KOD,
					DUE_DATE,
					PAPER_NO,
					STATUS,
					DEBTOR_NAME,
					BANK_NAME,
					BANK_BRANCH_NAME,
					PAY_NO,
					PAY_TYPE,
					PAY,
					CASH_ID,
					NEW_COMPANY_ID,
					NEW_ACCOUNT_ID,
					ACCOUNT_ID,
					ORDER_ID,
					PAYMETHOD_ID,
					OTHER_MONEY,
					MEMBER_ID,
					MUSTERI,
					MEMBER_CODE,
					M_OZEL_KOD,
					MEMBER_TYPE,
					TYPE,
                    PROJECT_HEAD,
					TAHSILAT_TARIHI
				<cfelseif attributes.report_type eq 3>
					LAW_ADWOCATE
				<cfelseif attributes.report_type eq 4>
					CASH_ID,
					CASH_NAME	
				<cfelseif attributes.report_type eq 2>
					<cfif isdefined("attributes.bloke_member") and attributes.bloke_member eq 1>
						FILE_NUMBER,
						LAW_ADWOCATE,
					</cfif>
					MEMBER_ID,
					MUSTERI,
					MEMBER_CODE,
					M_OZEL_KOD,
					MOBIL_TEL,
					MEMBER_TYPE
				<cfelseif attributes.report_type eq 5>
					STATUS,
					MONTH_DUE,
					YEAR_DUE
					<cfif isdefined("attributes.is_other_money")>
					,OTHER_MONEY
					</cfif>
				</cfif>
				<cfif isdefined("attributes.is_other_money")>
				,OTHER_MONEY
				</cfif>
			<cfif isdefined("attributes.is_interest")>
				<cfif attributes.report_type eq 1>
					<cfif len(attributes.amount_value1) and len(attributes.amount_value2)>AND OTHER_MONEY_VALUE BETWEEN #filterNum(attributes.amount_value1)# AND #filterNum(attributes.amount_value2)#</cfif>
				<cfelseif attributes.report_type eq 5>
					<cfif len(attributes.amount_value1) and len(attributes.amount_value2)>HAVING TOTAL_AMOUNT BETWEEN #filterNum(attributes.amount_value1)# AND #filterNum(attributes.amount_value2)#</cfif>
				<cfelse>
					HAVING TOTAL_GECIKME > 0
					<cfif len(attributes.amount_value1) and len(attributes.amount_value2)>AND TOTAL_AMOUNT BETWEEN #filterNum(attributes.amount_value1)# AND #filterNum(attributes.amount_value2)#</cfif>
				</cfif>
			<cfelse>
				<cfif len(attributes.amount_value1) and len(attributes.amount_value2)>HAVING <cfif attributes.report_type eq 1>OTHER_MONEY_VALUE<cfelse>TOTAL_AMOUNT</cfif> BETWEEN #filterNum(attributes.amount_value1)# AND #filterNum(attributes.amount_value2)#</cfif>
			</cfif>
			ORDER BY
				<cfif attributes.report_type eq 3>
					LAW_ADWOCATE
				<cfelseif attributes.report_type eq 4>
					CASH_NAME	
				<cfelseif attributes.report_type eq 2>
					MUSTERI
				<cfelse>
					DUE_DATE DESC
				</cfif>
		</cfquery>
	</cfif>
</cfif>