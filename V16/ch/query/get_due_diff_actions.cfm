
	<!--- Dekont ve kontrol satırı yazıldığı durumlarda faturalar getiriliyor, parçalı ödemeler için cari_rows a bağlanılıyor --->
	<cfquery name="get_actions" datasource="#dsn2#">
		SELECT
			I.INVOICE_ID,
			I.SUBSCRIPTION_ID,
			I.INVOICE_NUMBER,
			I.INVOICE_DATE,
			I.INVOICE_DATE MAIN_INVOICE_DATE,
			CRR.DUE_DATE,
			CRR.CARI_ACTION_ID,
			ROUND((CRR.ACTION_VALUE-ISNULL((SELECT SUM(CR.CLOSED_AMOUNT) FROM CARI_CLOSED_ROW CR WHERE CR.ACTION_ID = I.INVOICE_ID AND CR.ACTION_TYPE_ID = I.INVOICE_CAT AND CR.DUE_DATE = CRR.DUE_DATE),0)),2) AS NETTOTAL,
			ROUND((CRR.OTHER_CASH_ACT_VALUE-ISNULL((SELECT SUM(CR.OTHER_CLOSED_AMOUNT) FROM CARI_CLOSED_ROW CR WHERE CR.ACTION_ID = I.INVOICE_ID AND CR.ACTION_TYPE_ID = I.INVOICE_CAT AND CR.DUE_DATE = CRR.DUE_DATE),0)),2) AS OTHER_MONEY_VALUE,
			I.OTHER_MONEY,
			<cfif attributes.member_action_type eq 1>
				C.COMPANY_ID MEMBER_ID,
				C.MEMBER_CODE MEMBER_CODE,
				C.FULLNAME,
				C.OZEL_KOD,
				1 TYPE,
			<cfelse>
				C.CONSUMER_ID MEMBER_ID,
				C.MEMBER_CODE,
				C.CONSUMER_NAME+ ' '+ C.CONSUMER_SURNAME FULLNAME,
				C.OZEL_KOD,
				0 TYPE,
			</cfif>
			<cfif attributes.due_diff_rate eq 1>
				ISNULL(SPP.DUE_DATE_RATE,0) DUE_DATE_RATE
			<cfelseif attributes.due_diff_rate eq 2>
				ISNULL(CC.LAST_PAYMENT_INTEREST,0) DUE_DATE_RATE
			<cfelse>
				#filterNum(attributes.due_diff_rate_info,4)# DUE_DATE_RATE
			</cfif>
		FROM
			INVOICE I
			JOIN CARI_ROWS CRR ON I.INVOICE_CAT = CRR.ACTION_TYPE_ID AND I.INVOICE_ID = CRR.ACTION_ID
			<cfif attributes.member_action_type eq 1>
				,#dsn_alias#.COMPANY C
			<cfelse>
				,#dsn_alias#.CONSUMER C
			</cfif>
			<cfif attributes.due_diff_rate eq 1>
				,#dsn_alias#.SETUP_PAYMETHOD SPP
			<cfelseif attributes.due_diff_rate eq 2>
				,#dsn_alias#.COMPANY_CREDIT CC
			</cfif>
		WHERE
			I.NETTOTAL > 0 AND
			I.INVOICE_DATE BETWEEN #attributes.action_date1# AND #attributes.action_date2# AND
			I.PURCHASE_SALES = 1
			<cfif isdefined("due_day_info") and len(due_day_info)>
				AND DATEADD(day,#due_day_info#,CRR.ACTION_DATE) < #now()#
			<cfelse>
				AND CRR.DUE_DATE < #now()#
			</cfif>
			<cfif attributes.is_paper_closer eq 0>
				AND ROUND((CRR.ACTION_VALUE-ISNULL((SELECT SUM(CR.CLOSED_AMOUNT) FROM CARI_CLOSED_ROW CR WHERE CR.ACTION_ID = I.INVOICE_ID AND CR.ACTION_TYPE_ID = I.INVOICE_CAT AND CR.DUE_DATE = CRR.DUE_DATE),0)),2)>0
			<cfelseif attributes.is_paper_closer eq -1>
				AND ROUND((CRR.ACTION_VALUE-ISNULL((SELECT SUM(CR.CLOSED_AMOUNT) FROM CARI_CLOSED_ROW CR WHERE CR.ACTION_ID = I.INVOICE_ID AND CR.ACTION_TYPE_ID = I.INVOICE_CAT AND CR.DUE_DATE = CRR.DUE_DATE),0)),2)=0
			</cfif>
			<cfif attributes.member_action_type eq 1>
				AND I.COMPANY_ID = C.COMPANY_ID 
			<cfelse>
				AND I.CONSUMER_ID = C.CONSUMER_ID 
			</cfif>
			<cfif attributes.is_subscription_process eq 0>
				AND I.SUBSCRIPTION_ID IS NOT NULL
			<cfelseif  attributes.is_subscription_process eq 1>
				AND I.SUBSCRIPTION_ID IS NULL
			</cfif>
			<cfif isdate(attributes.due_date1)>
				AND I.DUE_DATE >= #attributes.due_date1#
			</cfif>
			<cfif isdate(attributes.due_date2)>
				AND I.DUE_DATE <= #attributes.due_date2#
			</cfif>
			<cfif isDefined("attributes.project_id") and len(attributes.project_id)>
				AND I.PROJECT_ID = #attributes.project_id#
			</cfif>
			<cfif attributes.due_diff_rate eq 1>
				AND SPP.PAYMETHOD_ID = I.PAY_METHOD
			<cfelseif attributes.due_diff_rate eq 2>
				<cfif attributes.member_action_type eq 1>
					AND CC.COMPANY_ID = I.COMPANY_ID
					AND CC.OUR_COMPANY_ID = #session.ep.company_id#
				<cfelse>
					AND CC.CONSUMER_ID = I.CONSUMER_ID
					AND CC.OUR_COMPANY_ID = #session.ep.company_id#
				</cfif>
			</cfif>
			<cfif attributes.member_action_type eq 1>
				<cfif isdefined("attributes.customer_value") and len(attributes.customer_value)>
					AND I.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANY_VALUE_ID IN (#attributes.customer_value#))
				</cfif>
				<cfif len(attributes.ozel_kod)>
					AND I.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE OZEL_KOD_2 LIKE '%#attributes.ozel_kod#%')
				</cfif>
				<cfif len(attributes.member_cat_type)>
					AND C.COMPANYCAT_ID IN(#attributes.member_cat_type#)
				</cfif>
				<cfif len(attributes.pos_code) and len(attributes.pos_code_text)>
					AND C.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER = 1 AND OUR_COMPANY_ID= #session.ep.company_id#)
				</cfif>
				<cfif isdefined('attributes.company_id') and len(trim(attributes.company)) and len(attributes.company_id)>
					AND C.COMPANY_ID = #attributes.company_id# 
				</cfif>
			<cfelse>
				<cfif isdefined("attributes.customer_value") and len(attributes.customer_value)>
					AND I.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER WHERE CUSTOMER_VALUE_ID IN (#attributes.customer_value#))
				</cfif>
				<cfif len(attributes.ozel_kod)>
					AND I.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER WHERE OZEL_KOD LIKE '%#attributes.ozel_kod#%')
				</cfif>
				<cfif len(attributes.consumer_cat_type)>
					AND C.CONSUMER_CAT_ID IN(#attributes.consumer_cat_type#)
				</cfif>
				<cfif len(attributes.pos_code) and len(attributes.pos_code_text)>
					AND C.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER = 1 AND OUR_COMPANY_ID= #session.ep.company_id#)
				</cfif>
				<cfif isdefined('attributes.consumer_id') and len(trim(attributes.company)) and len(attributes.consumer_id)>
					AND C.CONSUMER_ID = #attributes.consumer_id# 
				</cfif>
			</cfif>
	ORDER BY
		CRR.DUE_DATE
	</cfquery>

