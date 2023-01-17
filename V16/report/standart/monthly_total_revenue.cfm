<cfparam name="attributes.module_id_control" default="16">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfinclude template="report_authority_control.cfm">
<cfsavecontent variable="ay1"><cf_get_lang dictionary_id='57592.Ocak'></cfsavecontent>
<cfsavecontent variable="ay2"><cf_get_lang dictionary_id='57593.Şubat'></cfsavecontent>
<cfsavecontent variable="ay3"><cf_get_lang dictionary_id='57594.Mart'></cfsavecontent>
<cfsavecontent variable="ay4"><cf_get_lang dictionary_id='57595.Nisan'></cfsavecontent>
<cfsavecontent variable="ay5"><cf_get_lang dictionary_id='57596.Mayıs'></cfsavecontent>
<cfsavecontent variable="ay6"><cf_get_lang dictionary_id='57597.Haziran'></cfsavecontent>
<cfsavecontent variable="ay7"><cf_get_lang dictionary_id='57598.Temmuz'></cfsavecontent>
<cfsavecontent variable="ay8"><cf_get_lang dictionary_id='57599.Ağustos'></cfsavecontent>
<cfsavecontent variable="ay9"><cf_get_lang dictionary_id='57600.Eylül'></cfsavecontent>
<cfsavecontent variable="ay10"><cf_get_lang dictionary_id='57601.Ekim'></cfsavecontent>
<cfsavecontent variable="ay11"><cf_get_lang dictionary_id='57602.Kasım'></cfsavecontent>
<cfsavecontent variable="ay12"><cf_get_lang dictionary_id='57603.Aralık'></cfsavecontent>
<cfset aylar = "#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#">
<cfparam name="attributes.time_type" default="">
<cfparam name="attributes.report_type" default="1">
<cfparam name="attributes.member_cat_type" default="">
<cfparam name="attributes.pos_code" default="">
<cfparam name="attributes.pos_code_text" default="">
<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
	<cf_date tarih="attributes.date2">
<cfelse>
	<cfset attributes.date2 = createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#')>
</cfif>
<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
	<cf_date tarih="attributes.date1">
<cfelse>
	<cfset attributes.date1 = date_add('ww',-1,attributes.date2)>
</cfif>
<!--- vade tarihi --->
<cfif isdefined("attributes.due_date1") and isdate(attributes.due_date1)>
	<cf_date tarih="attributes.due_date1">
<cfelse>
	<cfset attributes.due_date1 = "">
</cfif>
<cfif isdefined("attributes.due_date2") and isdate(attributes.due_date2)>
	<cf_date tarih="attributes.due_date2">
<cfelse>
	<cfset attributes.due_date2 = "">
</cfif>
<!--- tahsilat tarihi --->
<cfif isdefined("attributes.rev_date1") and isdate(attributes.rev_date1)>
	<cf_date tarih="attributes.rev_date1">
<cfelse>
	<cfset attributes.rev_date1 = "">
</cfif>
<cfif isdefined("attributes.rev_date2") and isdate(attributes.rev_date2)>
	<cf_date tarih="attributes.rev_date2">
<cfelse>
	<cfset attributes.rev_date2 = "">
</cfif>
<cfquery name="GET_COMPANY_CAT" datasource="#dsn#">
	<!--- SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT --->
	SELECT DISTINCT	
		COMPANYCAT_ID,
		COMPANYCAT
	FROM
		GET_MY_COMPANYCAT
	WHERE
		EMPLOYEE_ID = #session.ep.userid# AND
		OUR_COMPANY_ID = #session.ep.company_id#
	ORDER BY
		COMPANYCAT
</cfquery>
<cfif isdefined("attributes.is_submitted")>
	<cfquery name="get_invoices" datasource="#dsn2#">
		SELECT
			DSP_REPORT_TYPE,
			PROCESS_ID,
			DUE_MONTH,
			DUE_YEAR,
			SUM(NET_TOTAL_SALES) NET_TOTAL_SALES,
			SUM(NET_TOTAL_REVENUE) NET_TOTAL_REVENUE,
			SUM(NET_TOTAL_BORC-CLOSED_AMOUNT) NET_TOTAL_BORC,
			SUM(NET_TOTAL_BORC_2-CLOSED_AMOUNT_2) NET_TOTAL_BORC_2,
			SUM(AVG_DUEDATE_SALES) AVG_DUEDATE_SALES,
			SUM(AVG_DUEDATE_REVENUE) AVG_DUEDATE_REVENUE,
			SUM((NET_TOTAL_BORC-CLOSED_AMOUNT)*AVG_DUEDATE_BORC)/#dsn_alias#.IS_ZERO(SUM(NET_TOTAL_BORC-CLOSED_AMOUNT),1) AVG_DUEDATE_BORC,
			SUM((NET_TOTAL_BORC_2-CLOSED_AMOUNT_2)*AVG_DUEDATE_BORC_2)/#dsn_alias#.IS_ZERO(SUM(NET_TOTAL_BORC_2-CLOSED_AMOUNT_2),1) AVG_DUEDATE_BORC_2
		FROM
		(
		SELECT
			<cfif attributes.report_type eq 1>
				C.FULLNAME DSP_REPORT_TYPE,
				C.COMPANY_ID PROCESS_ID,
			<cfelse>
				EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME DSP_REPORT_TYPE,
				WEP.POSITION_CODE PROCESS_ID,
			</cfif>
			MONTH(ISNULL(I.DUE_DATE,I.INVOICE_DATE)) AS DUE_MONTH,
			YEAR(ISNULL(I.DUE_DATE,I.INVOICE_DATE)) AS DUE_YEAR,
			SUM(I.NETTOTAL) AS NET_TOTAL_SALES,
			0 AS NET_TOTAL_REVENUE,
			0 AS NET_TOTAL_BORC,
			0 AS CLOSED_AMOUNT,
			0 AS NET_TOTAL_BORC_2,
			0 AS CLOSED_AMOUNT_2,
			SUM((DATEDIFF(day,GETDATE(),ISNULL(I.DUE_DATE,I.INVOICE_DATE))*I.NETTOTAL))/SUM(I.NETTOTAL) AS AVG_DUEDATE_SALES,
			0 AS AVG_DUEDATE_REVENUE,
			0 AS AVG_DUEDATE_BORC,
			0 AS AVG_DUEDATE_BORC_2
		FROM
			INVOICE I,
			<cfif attributes.report_type eq 1>
				#dsn_alias#.COMPANY C
			<cfelse>
				#dsn_alias#.EMPLOYEE_POSITIONS EP,
				#dsn_alias#.WORKGROUP_EMP_PAR WEP
			</cfif>
		WHERE
			I.PURCHASE_SALES = 1
			AND INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
			<cfif isdate(attributes.due_date1) and isdate(attributes.due_date2)>
				AND I.DUE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.due_date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.due_date2#">
			<cfelseif isdate(attributes.due_date1)>
				AND I.DUE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.due_date1#">
			<cfelseif isdate(attributes.due_date2)>
				AND I.DUE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.due_date2#">
			</cfif>
			<cfif attributes.report_type eq 1>
				AND I.COMPANY_ID = C.COMPANY_ID
				<cfif len(attributes.member_cat_type)>
					AND C.COMPANYCAT_ID IN (#attributes.member_cat_type#)
				</cfif>
				<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
					AND I.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER = 1 AND OUR_COMPANY_ID= #session.ep.company_id#)
				</cfif>
			<cfelse>
				AND WEP.POSITION_CODE = EP.POSITION_CODE 
				AND WEP.IS_MASTER=1 
				AND WEP.OUR_COMPANY_ID = #session.ep.company_id#
				AND I.COMPANY_ID = WEP.COMPANY_ID
				<cfif len(attributes.member_cat_type)>
					AND I.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANYCAT_ID IN (#attributes.member_cat_type#))
				</cfif>
				<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
					AND WEP.POSITION_CODE = #attributes.pos_code#
				</cfif>
			</cfif>
			AND I.NETTOTAL > 0
            AND I.IS_IPTAL = 0
		GROUP BY
			<cfif attributes.report_type eq 1>
				C.FULLNAME,
				C.COMPANY_ID,
			<cfelse>
				EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME,
				WEP.POSITION_CODE,
			</cfif>
			MONTH(ISNULL(I.DUE_DATE,I.INVOICE_DATE)),
			YEAR(ISNULL(I.DUE_DATE,I.INVOICE_DATE))
	UNION ALL
		SELECT
			<cfif attributes.report_type eq 1>
				C.FULLNAME DSP_REPORT_TYPE,
				C.COMPANY_ID PROCESS_ID,
			<cfelse>
				EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME DSP_REPORT_TYPE,
				WEP.POSITION_CODE PROCESS_ID,
			</cfif>
			MONTH(ISNULL(CR.DUE_DATE,CR.ACTION_DATE)) AS DUE_MONTH,
			YEAR(ISNULL(CR.DUE_DATE,CR.ACTION_DATE)) AS DUE_YEAR,
			0 AS NET_TOTAL_SALES,
			ROUND(SUM(CR.ACTION_VALUE),2) AS NET_TOTAL_REVENUE,
			0 AS NET_TOTAL_BORC,
			0 AS CLOSED_AMOUNT,
			0 AS NET_TOTAL_BORC_2,
			0 AS CLOSED_AMOUNT_2,
			0 AS AVG_DUEDATE_SALES,
			SUM((DATEDIFF(day,GETDATE(),ISNULL(CR.DUE_DATE,CR.ACTION_DATE))*CR.ACTION_VALUE))/#dsn_alias#.IS_ZERO(SUM(CR.ACTION_VALUE),1) AS AVG_DUEDATE_REVENUE,
			0 AS AVG_DUEDATE_BORC,
			0 AS AVG_DUEDATE_BORC_2
		FROM
			CARI_ROWS CR,
			<cfif attributes.report_type eq 1>
				#dsn_alias#.COMPANY C
			<cfelse>
				#dsn_alias#.EMPLOYEE_POSITIONS EP,
				#dsn_alias#.WORKGROUP_EMP_PAR WEP
			</cfif>
		WHERE
			ACTION_TYPE_ID IN (30,32,33,34,35,37,38,39,31,310,20,21,22,23,24,240,25,250,251,26,27,29,245,242,246,243,244,90,91,92,93,94,95,96,1040,1041,1042,1043,1044,1045,1046,105,106,97,98,99,100,101,102,103,1050,1051,1052,1053,1054,1055,1056,104,107,108,241)
			AND CR.ACTION_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
			<cfif isdate(attributes.due_date1) and isdate(attributes.due_date2)>
				AND CR.DUE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.due_date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.due_date2#">
			<cfelseif isdate(attributes.due_date1)>
				AND CR.DUE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.due_date1#">
			<cfelseif isdate(attributes.due_date2)>
				AND CR.DUE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.due_date2#">
			</cfif>
			<cfif isdate(attributes.rev_date1) and isdate(attributes.rev_date2)>
				AND CR.ACTION_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.rev_date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.rev_date2#">
			<cfelseif isdate(attributes.rev_date1)>
				AND CR.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.rev_date1#">
			<cfelseif isdate(attributes.rev_date2)>
				AND CR.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.rev_date2#">
			</cfif>
			<cfif attributes.report_type eq 1>
				AND CR.FROM_CMP_ID = C.COMPANY_ID
				<cfif len(attributes.member_cat_type)>
					AND C.COMPANYCAT_ID IN (#attributes.member_cat_type#)
				</cfif>
				<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
					AND C.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER = 1 AND OUR_COMPANY_ID= #session.ep.company_id#)
				</cfif>
			<cfelse>
				AND CR.FROM_CMP_ID = WEP.COMPANY_ID 
				AND WEP.POSITION_CODE = EP.POSITION_CODE 
				AND WEP.IS_MASTER=1 
				AND WEP.OUR_COMPANY_ID = #session.ep.company_id#
				<cfif len(attributes.member_cat_type)>
					AND CR.FROM_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANYCAT_ID IN (#attributes.member_cat_type#))
				</cfif>
				<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
					AND WEP.POSITION_CODE = #attributes.pos_code#
				</cfif>
			</cfif>
			AND CR.FROM_CMP_ID IS NOT NULL
		GROUP BY
			<cfif attributes.report_type eq 1>
				C.FULLNAME,
				C.COMPANY_ID,
			<cfelse>
				EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME,
				WEP.POSITION_CODE,
			</cfif>
			MONTH(ISNULL(CR.DUE_DATE,CR.ACTION_DATE)),
			YEAR(ISNULL(CR.DUE_DATE,CR.ACTION_DATE))
		<cfif session.ep.our_company_info.is_paper_closer>
		UNION ALL
			SELECT
				<cfif attributes.report_type eq 1>
					C.FULLNAME DSP_REPORT_TYPE,
					C.COMPANY_ID PROCESS_ID,
				<cfelse>
					EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME DSP_REPORT_TYPE,
					WEP.POSITION_CODE PROCESS_ID,
				</cfif>
				MONTH(ISNULL(CR.DUE_DATE,CR.ACTION_DATE)) AS DUE_MONTH,
				YEAR(ISNULL(CR.DUE_DATE,CR.ACTION_DATE)) AS DUE_YEAR,
				0 AS NET_TOTAL_SALES,
				0 AS NET_TOTAL_REVENUE,
				ROUND(SUM(CR.ACTION_VALUE),2) AS NET_TOTAL_BORC,
				0 AS CLOSED_AMOUNT,
				0 AS NET_TOTAL_BORC_2,
				0 AS CLOSED_AMOUNT_2,
				0 AS AVG_DUEDATE_SALES,
				0 AS AVG_DUEDATE_REVENUE,
				SUM((DATEDIFF(day,GETDATE(),ISNULL(CR.DUE_DATE,CR.ACTION_DATE))*CR.ACTION_VALUE))/#dsn_alias#.IS_ZERO(SUM(CR.ACTION_VALUE),1) AS AVG_DUEDATE_BORC,
				0 AS AVG_DUEDATE_BORC_2
			FROM
				CARI_ROWS CR,
				<cfif attributes.report_type eq 1>
					#dsn_alias#.COMPANY C
				<cfelse>
					#dsn_alias#.EMPLOYEE_POSITIONS EP,
					#dsn_alias#.WORKGROUP_EMP_PAR WEP
				</cfif>
			WHERE
				CR.ACTION_TYPE_ID NOT IN (48,49,45,46) 
				AND CR.ACTION_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
				<cfif isdate(attributes.due_date1) and isdate(attributes.due_date2)>
					AND CR.DUE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.due_date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.due_date2#">
				<cfelseif isdate(attributes.due_date1)>
					AND CR.DUE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.due_date1#">
				<cfelseif isdate(attributes.due_date2)>
					AND CR.DUE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.due_date2#">
				</cfif>
				<cfif attributes.report_type eq 1>
					AND CR.TO_CMP_ID = C.COMPANY_ID
					<cfif len(attributes.member_cat_type)>
						AND C.COMPANYCAT_ID IN (#attributes.member_cat_type#)
					</cfif>
					<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
						AND C.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER = 1 AND OUR_COMPANY_ID= #session.ep.company_id#)
					</cfif>
				<cfelse>
					AND CR.TO_CMP_ID = WEP.COMPANY_ID 
					AND WEP.POSITION_CODE = EP.POSITION_CODE 
					AND WEP.IS_MASTER=1 
					AND WEP.OUR_COMPANY_ID = #session.ep.company_id#
					<cfif len(attributes.member_cat_type)>
						AND CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANYCAT_ID IN (#attributes.member_cat_type#))
					</cfif>
					<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
						AND WEP.POSITION_CODE = #attributes.pos_code#
					</cfif>
				</cfif>
				AND CR.TO_CMP_ID IS NOT NULL
				AND CR.DUE_DATE < GETDATE()
				 AND CR.ACTION_ID NOT IN
    (
        SELECT
          ACTION_ID

        FROM CARI_CLOSED_ROW

        WHERE CR.ACTION_TYPE_ID=CARI_CLOSED_ROW.ACTION_TYPE_ID
        AND ( 
				( CR.ACTION_TABLE<>'INVOICE' AND CR.CARI_ACTION_ID=CARI_CLOSED_ROW.CARI_ACTION_ID )
			)
        AND (
				 ( CR.ACTION_TABLE='INVOICE' AND CR.DUE_DATE=CARI_CLOSED_ROW.DUE_DATE ) OR CR.ACTION_TABLE<>'INVOICE' )
        AND CR.OTHER_MONEY=CARI_CLOSED_ROW.OTHER_MONEY
        
        UNION 
        
        
         SELECT
          ACTION_ID

        FROM CARI_CLOSED_ROW

        WHERE CR.ACTION_TYPE_ID=CARI_CLOSED_ROW.ACTION_TYPE_ID
        AND ( (CR.ACTION_TABLE='INVOICE' AND CR.ACTION_ID = CARI_CLOSED_ROW.ACTION_ID  ) )
        AND ( ( CR.ACTION_TABLE='INVOICE' AND CR.DUE_DATE=CARI_CLOSED_ROW.DUE_DATE ) OR CR.ACTION_TABLE<>'INVOICE' )
        AND CR.OTHER_MONEY=CARI_CLOSED_ROW.OTHER_MONEY
        
        
    )
			GROUP BY
				<cfif attributes.report_type eq 1>
					C.FULLNAME,
					C.COMPANY_ID,
				<cfelse>
					EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME,
					WEP.POSITION_CODE,
				</cfif>
				MONTH(ISNULL(CR.DUE_DATE,CR.ACTION_DATE)),
				YEAR(ISNULL(CR.DUE_DATE,CR.ACTION_DATE))
		UNION ALL
			SELECT
				<cfif attributes.report_type eq 1>
					C.FULLNAME DSP_REPORT_TYPE,
					C.COMPANY_ID PROCESS_ID,
				<cfelse>
					EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME DSP_REPORT_TYPE,
					WEP.POSITION_CODE PROCESS_ID,
				</cfif>
				MONTH(ISNULL(CR.DUE_DATE,CR.ACTION_DATE)) AS DUE_MONTH,
				YEAR(ISNULL(CR.DUE_DATE,CR.ACTION_DATE)) AS DUE_YEAR,
				0 AS NET_TOTAL_SALES,
				0 AS NET_TOTAL_REVENUE,
				ROUND(SUM(CR.ACTION_VALUE),2) AS NET_TOTAL_BORC,
				ROUND(ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CR.ACTION_TYPE_ID AND ((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = C_CL_R.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CR.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CR.ACTION_ID),0),2) AS CLOSED_AMOUNT,		
				0 AS NET_TOTAL_BORC_2,
				0 AS CLOSED_AMOUNT_2,
				0 AS AVG_DUEDATE_SALES,
				0 AS AVG_DUEDATE_REVENUE,
				SUM((DATEDIFF(day,GETDATE(),ISNULL(CR.DUE_DATE,CR.ACTION_DATE))*(CR.ACTION_VALUE)))/#dsn_alias#.IS_ZERO(SUM(CR.ACTION_VALUE),1) AS AVG_DUEDATE_BORC,
				0 AS AVG_DUEDATE_BORC_2
			FROM
				CARI_ROWS CR
				<cfif attributes.report_type eq 1>


					,#dsn_alias#.COMPANY C
				<cfelse>
					,#dsn_alias#.EMPLOYEE_POSITIONS EP
					,#dsn_alias#.WORKGROUP_EMP_PAR WEP
				</cfif>
			WHERE
				CR.ACTION_TYPE_ID NOT IN (48,49,45,46)
				AND CR.ACTION_ID IN (SELECT ACTION_ID FROM CARI_CLOSED_ROW WHERE CR.ACTION_TYPE_ID = CARI_CLOSED_ROW.ACTION_TYPE_ID AND ((CR.ACTION_TABLE <> 'INVOICE' AND CR.CARI_ACTION_ID = CARI_CLOSED_ROW.CARI_ACTION_ID) OR CR.ACTION_TABLE = 'INVOICE')  AND ((CR.ACTION_TABLE = 'INVOICE' AND CR.DUE_DATE = CARI_CLOSED_ROW.DUE_DATE) OR CR.ACTION_TABLE <> 'INVOICE') AND CR.OTHER_MONEY = CARI_CLOSED_ROW.OTHER_MONEY)
				AND CR.ACTION_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
				<cfif isdate(attributes.due_date1) and isdate(attributes.due_date2)>
					AND CR.DUE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.due_date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.due_date2#">
				<cfelseif isdate(attributes.due_date1)>
					AND CR.DUE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.due_date1#">
				<cfelseif isdate(attributes.due_date2)>
					AND CR.DUE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.due_date2#">
				</cfif>
				<cfif attributes.report_type eq 1>
					AND CR.TO_CMP_ID = C.COMPANY_ID
					<cfif len(attributes.member_cat_type)>
						AND C.COMPANYCAT_ID IN (#attributes.member_cat_type#)
					</cfif>
					<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
						AND C.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER = 1 AND OUR_COMPANY_ID= #session.ep.company_id#)
					</cfif>
				<cfelse>
					AND CR.TO_CMP_ID = WEP.COMPANY_ID 
					AND WEP.POSITION_CODE = EP.POSITION_CODE 
					AND WEP.IS_MASTER=1 
					AND WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
					<cfif len(attributes.member_cat_type)>
						AND CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANYCAT_ID IN (#attributes.member_cat_type#))
					</cfif>
					<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
						AND WEP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#">
					</cfif>
				</cfif>
				AND CR.TO_CMP_ID IS NOT NULL
				AND CR.DUE_DATE < GETDATE()
			GROUP BY
				<cfif attributes.report_type eq 1>
					C.FULLNAME,
					C.COMPANY_ID,
				<cfelse>
					EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME,
					WEP.POSITION_CODE,
				</cfif>
				MONTH(ISNULL(CR.DUE_DATE,CR.ACTION_DATE)),
				YEAR(ISNULL(CR.DUE_DATE,CR.ACTION_DATE)),
				CR.ACTION_TYPE_ID,
				CR.ACTION_ID,
				CR.ACTION_TABLE,
				CR.DUE_DATE,
				CR.CARI_ACTION_ID,
				CR.OTHER_MONEY
		UNION ALL
			SELECT
				<cfif attributes.report_type eq 1>
					C.FULLNAME DSP_REPORT_TYPE,
					C.COMPANY_ID PROCESS_ID,
				<cfelse>
					EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME DSP_REPORT_TYPE,
					WEP.POSITION_CODE PROCESS_ID,
				</cfif>
				MONTH(ISNULL(CR.DUE_DATE,CR.ACTION_DATE)) AS DUE_MONTH,
				YEAR(ISNULL(CR.DUE_DATE,CR.ACTION_DATE)) AS DUE_YEAR,
				0 AS NET_TOTAL_SALES,
				0 AS NET_TOTAL_REVENUE,
				0 AS NET_TOTAL_BORC,
				0 AS CLOSED_AMOUNT,
				ROUND(SUM(CR.ACTION_VALUE),2) AS NET_TOTAL_BORC_2,
				0 AS CLOSED_AMOUNT_2,			
				0 AS AVG_DUEDATE_SALES,
				0 AS AVG_DUEDATE_REVENUE,
				0 AS AVG_DUEDATE_BORC,
				SUM((DATEDIFF(day,GETDATE(),ISNULL(CR.DUE_DATE,CR.ACTION_DATE))*CR.ACTION_VALUE))/#dsn_alias#.IS_ZERO(SUM(CR.ACTION_VALUE),1) AS AVG_DUEDATE_BORC_2
			FROM
				CARI_ROWS CR,
				<cfif attributes.report_type eq 1>
					#dsn_alias#.COMPANY C
				<cfelse>
					#dsn_alias#.EMPLOYEE_POSITIONS EP,
					#dsn_alias#.WORKGROUP_EMP_PAR WEP
				</cfif>
			WHERE
				CR.ACTION_TYPE_ID NOT IN (48,49,45,46)
				AND CR.ACTION_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
				<cfif isdate(attributes.due_date1) and isdate(attributes.due_date2)>
					AND CR.DUE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.due_date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.due_date2#">
				<cfelseif isdate(attributes.due_date1)>
					AND CR.DUE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.due_date1#">
				<cfelseif isdate(attributes.due_date2)>
					AND CR.DUE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.due_date2#">
				</cfif>
				<cfif attributes.report_type eq 1>
					AND CR.TO_CMP_ID = C.COMPANY_ID
					<cfif len(attributes.member_cat_type)>
						AND C.COMPANYCAT_ID IN (#attributes.member_cat_type#)
					</cfif>
					<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
						AND C.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER = 1 AND OUR_COMPANY_ID= #session.ep.company_id#)
					</cfif>
				<cfelse>
					AND CR.TO_CMP_ID = WEP.COMPANY_ID 
					AND WEP.POSITION_CODE = EP.POSITION_CODE 
					AND WEP.IS_MASTER=1 
					AND WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
					<cfif len(attributes.member_cat_type)>
						AND CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANYCAT_ID IN (#attributes.member_cat_type#))
					</cfif>
					<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
						AND WEP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#">
					</cfif>
				</cfif>
				AND CR.TO_CMP_ID IS NOT NULL
				AND CR.DUE_DATE > GETDATE()
				AND CR.ACTION_ID NOT IN (SELECT ACTION_ID FROM CARI_CLOSED_ROW WHERE CR.ACTION_TYPE_ID = CARI_CLOSED_ROW.ACTION_TYPE_ID AND ((CR.ACTION_TABLE = 'INVOICE' AND CR.DUE_DATE = CARI_CLOSED_ROW.DUE_DATE) OR CR.ACTION_TABLE <> 'INVOICE') AND CR.OTHER_MONEY = CARI_CLOSED_ROW.OTHER_MONEY)
			GROUP BY
				<cfif attributes.report_type eq 1>
					C.FULLNAME,
					C.COMPANY_ID,
				<cfelse>
					EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME,
					WEP.POSITION_CODE,
				</cfif>
				MONTH(ISNULL(CR.DUE_DATE,CR.ACTION_DATE)),
				YEAR(ISNULL(CR.DUE_DATE,CR.ACTION_DATE))
		UNION ALL
			SELECT
				<cfif attributes.report_type eq 1>
					C.FULLNAME DSP_REPORT_TYPE,
					C.COMPANY_ID PROCESS_ID,
				<cfelse>
					EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME DSP_REPORT_TYPE,
					WEP.POSITION_CODE PROCESS_ID,
				</cfif>
				MONTH(ISNULL(CR.DUE_DATE,CR.ACTION_DATE)) AS DUE_MONTH,
				YEAR(ISNULL(CR.DUE_DATE,CR.ACTION_DATE)) AS DUE_YEAR,
				0 AS NET_TOTAL_SALES,
				0 AS NET_TOTAL_REVENUE,
				0 AS NET_TOTAL_BORC,
				0 AS CLOSED_AMOUNT,
				ROUND(SUM(CR.ACTION_VALUE),2) AS NET_TOTAL_BORC_2,
				ROUND(ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM #dsn2_alias#.CARI_CLOSED_ROW C_CL_R WHERE C_CL_R.ACTION_TYPE_ID = CR.ACTION_TYPE_ID AND ((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = C_CL_R.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS')) AND (((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = C_CL_R.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS')) AND C_CL_R.OTHER_MONEY = CR.OTHER_MONEY AND C_CL_R.CLOSED_AMOUNT IS NOT NULL AND C_CL_R.ACTION_ID = CR.ACTION_ID),0),2) AS CLOSED_AMOUNT_2,				
				0 AS AVG_DUEDATE_SALES,
				0 AS AVG_DUEDATE_REVENUE,
				0 AS AVG_DUEDATE_BORC,
				SUM((DATEDIFF(day,GETDATE(),ISNULL(CR.DUE_DATE,CR.ACTION_DATE))*(CR.ACTION_VALUE)))/SUM(CR.ACTION_VALUE) AS AVG_DUEDATE_BORC_2
			FROM
				CARI_ROWS CR
				<cfif attributes.report_type eq 1>
					,#dsn_alias#.COMPANY C
				<cfelse>
					,#dsn_alias#.EMPLOYEE_POSITIONS EP
					,#dsn_alias#.WORKGROUP_EMP_PAR WEP
				</cfif>
			WHERE
				CR.ACTION_TYPE_ID NOT IN (48,49,45,46)
				AND CR.ACTION_ID IN (SELECT ACTION_ID FROM CARI_CLOSED_ROW WHERE CR.ACTION_TYPE_ID = CARI_CLOSED_ROW.ACTION_TYPE_ID AND ((CR.ACTION_TABLE = 'INVOICE' AND CR.DUE_DATE = CARI_CLOSED_ROW.DUE_DATE) OR CR.ACTION_TABLE <> 'INVOICE') AND CR.OTHER_MONEY = CARI_CLOSED_ROW.OTHER_MONEY)
				AND CR.ACTION_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
				<cfif isdate(attributes.due_date1) and isdate(attributes.due_date2)>
					AND CR.DUE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.due_date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.due_date2#">
				<cfelseif isdate(attributes.due_date1)>
					AND CR.DUE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.due_date1#">
				<cfelseif isdate(attributes.due_date2)>
					AND CR.DUE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.due_date2#">
				</cfif>
				<cfif attributes.report_type eq 1>
					AND CR.TO_CMP_ID = C.COMPANY_ID
					<cfif len(attributes.member_cat_type)>
						AND C.COMPANYCAT_ID IN (#attributes.member_cat_type#)
					</cfif>
					<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
						AND C.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER = 1 AND OUR_COMPANY_ID= #session.ep.company_id#)
					</cfif>
				<cfelse>
					AND CR.TO_CMP_ID = WEP.COMPANY_ID 
					AND WEP.POSITION_CODE = EP.POSITION_CODE 
					AND WEP.IS_MASTER=1 
					AND WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
					<cfif len(attributes.member_cat_type)>
						AND CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANYCAT_ID IN (#attributes.member_cat_type#))
					</cfif>
					<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
						AND WEP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#">
					</cfif>
				</cfif>
				AND CR.TO_CMP_ID IS NOT NULL
				AND CR.DUE_DATE > GETDATE()
			GROUP BY
				<cfif attributes.report_type eq 1>
					C.FULLNAME,
					C.COMPANY_ID,
				<cfelse>
					EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME,
					WEP.POSITION_CODE,
				</cfif>
				MONTH(ISNULL(CR.DUE_DATE,CR.ACTION_DATE)),
				YEAR(ISNULL(CR.DUE_DATE,CR.ACTION_DATE)),
				CR.ACTION_TYPE_ID,
				CR.ACTION_ID,
				CR.ACTION_TABLE,
				CR.DUE_DATE,
				CR.CARI_ACTION_ID,
				CR.OTHER_MONEY			
			</cfif>
		)T1
		GROUP BY
			DSP_REPORT_TYPE,
			PROCESS_ID,
			DUE_MONTH,
			DUE_YEAR
		ORDER BY
			DSP_REPORT_TYPE,
			DUE_YEAR,
			DUE_MONTH
	</cfquery>
   
<cfset attributes.totalrecords = get_invoices.recordcount>
	<cfquery name="get_toplam" dbtype="query">
    	SELECT 
            SUM(NET_TOTAL_SALES) AS NET_TOTAL_SALES,
            SUM(NET_TOTAL_REVENUE) AS NET_TOTAL_REVENUE,
            SUM(NET_TOTAL_BORC) AS NET_TOTAL_BORC,
           <!--- SUM(CLOSED_AMOUNT) AS CLOSED_AMOUNT,--->
            SUM(NET_TOTAL_BORC_2) AS NET_TOTAL_BORC_2,
            <!---SUM(CLOSED_AMOUNT_2) AS CLOSED_AMOUNT_2,--->				
            SUM(AVG_DUEDATE_SALES) AS AVG_DUEDATE_SALES,
            SUM(AVG_DUEDATE_REVENUE) AS AVG_DUEDATE_REVENUE,
            SUM(AVG_DUEDATE_BORC) AS  AVG_DUEDATE_BORC,
            SUM(AVG_DUEDATE_BORC_2) AS AVG_DUEDATE_BORC_2,
            PROCESS_ID
        FROM
        	get_invoices
        GROUP BY 
        	PROCESS_ID
    </cfquery>
 <!---<cfdump var="#get_toplam#"><cfabort>--->
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_invoices.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelse>
	<cfset attributes.totalrecords =0>
</cfif>
<cfsavecontent variable="head"><cf_get_lang dictionary_id ='40342.Tahsilat Özet Raporu'></cfsavecontent>
<cfform name="form_report" action="#request.self#?fuseaction=report.monthly_total_revenue" method="post">
	<cf_report_list_search title="#head#">
        <cf_report_list_search_area>			
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-4 col-md-6 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='58690.Tarih Aralığı'>*</label>
										<div class="col col-6">
											<div class="input-group">
												<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>	
												<cfinput type="text" name="date1" id="date1" value="#dateformat(attributes.date1,dateformat_style)#" maxlength="10" required="yes" message="#message#" validate="#validate_style#">
												<span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
											</div>
										</div>
										<div class="col col-6">
											<div class="input-group">
												<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
												<cfinput type="text" name="date2" id="date2" value="#dateformat(attributes.date2,dateformat_style)#" maxlength="10" required="yes" message="#message#" validate="#validate_style#">
												<span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span>
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57881.Vade Tarihi'></label>
										<div class="col col-6">
											<div class="input-group">
												<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
												<cfinput type="text" name="due_date1" id="due_date1" value="#dateformat(attributes.due_date1,dateformat_style)#" maxlength="10"  message="#message#" validate="#validate_style#">
												<span class="input-group-addon"><cf_wrk_date_image date_field="due_date1"></span>
											</div>
										</div>
										<div class="col col-6">
											<div class="input-group">
												<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
												<cfinput type="text" name="due_date2" id="due_date2" value="#dateformat(attributes.due_date2,dateformat_style)#" maxlength="10"  message="#message#" validate="#validate_style#">
												<span class="input-group-addon"><cf_wrk_date_image date_field="due_date2"></span>
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='39144.Tahsilat Tarihi'></label>
										<div class="col col-6">
											<div class="input-group">
												<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
												<cfinput type="text" name="rev_date1" id="rev_date1" value="#dateformat(attributes.rev_date1,dateformat_style)#" maxlength="10" message="#message#" validate="#validate_style#">
												<span class="input-group-addon"><cf_wrk_date_image date_field="rev_date1"></span>
											</div>
										</div>
										<div class="col col-6">
											<div class="input-group">
												<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
												<cfinput type="text" name="rev_date2" id="rev_date2" value="#dateformat(attributes.rev_date2,dateformat_style)#" maxlength="10" message="#message#" validate="#validate_style#">
												<span class="input-group-addon"><cf_wrk_date_image date_field="rev_date2"></span>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-6 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='39242.Müşteri Kat'></label>
										<div class="col col-12 col-xs-12">
											<select name="member_cat_type" id="member_cat_type" style="width:175px; height:70px;" multiple="multiple">
												<optgroup label="<cf_get_lang dictionary_id='58039.Kurumsal Üye Kategorileri'>">
													<cfoutput query="get_company_cat">
													<option value="#companycat_id#" <cfif listfind(attributes.member_cat_type,'#companycat_id#',',')>selected</cfif>>&nbsp;&nbsp;#companycat#</option>
													</cfoutput>
												</optgroup>
											</select>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-6 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58795.Müşteri Temsilci'></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="pos_code" id="pos_code" value="<cfif len(attributes.pos_code_text) and len(attributes.pos_code)><cfoutput>#attributes.pos_code#</cfoutput></cfif>">
												<input type="Text" name="pos_code_text" id="pos_code_text" style="width:140px;" value="<cfif len(attributes.pos_code_text) and len(attributes.pos_code)><cfoutput>#get_emp_info(attributes.pos_code,1,0)#</cfoutput></cfif>" onFocus="AutoComplete_Create('pos_code_text','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','pos_code','','3','140');">
												<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=form_report.pos_code&field_name=form_report.pos_code_text<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9','list')">
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58960.Rapor Tipi'></label>
										<div class="col col-12 col-xs-12">
											<select name="report_type" id="report_type" style="width:150px;">
												<option value="1" <cfif attributes.report_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='39257.Müşteri Bazında'></option>
												<option value="2" <cfif attributes.report_type eq 2>selected</cfif>><cf_get_lang dictionary_id ='39737.Müşteri Temsilcisi Bazında'></option>
											</select>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
							<label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" onKeyUp="isNumber(this)" message="#message#" maxlength="3" style="width:25px;">
							<input type="hidden" name="is_submitted" id="is_submitted" value="1">
							<cf_wrk_report_search_button search_function='control1()' insert_info='#message#' button_type='1' is_excel="1"> 
						</div>
					</div>
				</div>
			</div>
		</cf_report_list_search_area>
	</cf_report_list_search>
</cfform>
<cfset ara_toplam_sales = 0>
<cfset ara_toplam_revenue = 0>
<cfset ara_toplam_borc = 0>
<cfset ara_toplam_borc_2 = 0>

<cfset ara_toplam_due_sales = 0>
<cfset ara_toplam_due_borc = 0>
<cfset ara_toplam_due_revenue = 0>
<cfset ara_toplam_due_borc_2 = 0>

<cfset son_toplam_sales = 0>
<cfset son_toplam_revenue = 0>
<cfset son_toplam_borc = 0>
<cfset son_toplam_borc_2 = 0>

<cfset son_toplam_due_sales = 0>
<cfset son_toplam_due_revenue = 0>
<cfset son_toplam_due_borc = 0>
<cfset son_toplam_due_borc_2 = 0>
<cfif attributes.is_excel eq 1>
		<cfset filename="monthly_total_revenue#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
		<cfheader name="Expires" value="#Now()#">
		<cfcontent type="application/vnd.msexcel;charset=utf-8">
		<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
		<meta http-equiv="content-type" content="text/plain; charset=utf-8">
		<cfset attributes.startrow=1>
		<cfset attributes.maxrows=get_invoices.recordcount>
		<cfset type_ = 1>
	<cfelse>
		<cfset type_ = 0>
</cfif>
<cfif isdefined("attributes.is_submitted")>
	<cf_report_list>
			<thead>
			<tr>
				<cfif attributes.report_type eq 1>
					<th width="110" align="center" ><cf_get_lang dictionary_id='57457.Müşteri'></th>
				<cfelse>
					<th width="110" align="center" ><cf_get_lang dictionary_id='58795.Müşteri Temsilcisi'></th>	
				</cfif>
				<th width="110" align="center" ><cf_get_lang dictionary_id='58472.Dönem'> / <cf_get_lang dictionary_id='58724.Ay'></th>
				<th  width="110" align="center" ><cf_get_lang dictionary_id='58472.Dönem'><cf_get_lang dictionary_id ='39561.Toplam Satışı'></th>
				<th nowrap><cf_get_lang dictionary_id ='57489.Para Br'></th>
				<th  align="center"><cf_get_lang dictionary_id='57448.Satış'> <cf_get_lang dictionary_id ='57861.Ortalama Vade'></th>
				<th  align="center"><cf_get_lang dictionary_id='58472.Dönem'><cf_get_lang dictionary_id ='39894.Toplam Tahsilat'> </th>
				<th nowrap><cf_get_lang dictionary_id ='57489.Para Br'></th>
				<th align="center"><cf_get_lang dictionary_id ='57845.Tahsilat'><cf_get_lang dictionary_id ='57861.Ortalama Vade'></th>
				<cfif session.ep.our_company_info.is_paper_closer>
					<th width="110" align="center"><cf_get_lang dictionary_id ='40343.Günü Geçmiş Açık Hesap'></th>
					<th nowrap><cf_get_lang dictionary_id ='57489.Para Br'></th>
					<th width="110" align="center"><cf_get_lang dictionary_id ='40343.Günü Geçmiş Açık Hesap'> <cf_get_lang dictionary_id ='57861.Ortalama Vade'></th>
					<th width="110" align="center"><cf_get_lang dictionary_id ='40344.Vadesi Gelmemiş Açık Hesap'></th>
					<th nowrap><cf_get_lang dictionary_id ='57489.Para Br'></th>
					<th width="110" align="center"><cf_get_lang dictionary_id ='40344.Vadesi Gelmemiş Açık Hesap'><cf_get_lang dictionary_id ='57861.Ortalama Vade'></th>
					<th width="110" align="center"><cf_get_lang dictionary_id ='40345.Toplam Açık Hesap'></th>
					<th nowrap width="80"><cf_get_lang dictionary_id ='57489.Para Br'></th>
				</cfif>
			</tr>
			</thead>
			<cfif get_invoices.recordcount>
			<tbody>
				<cfoutput query="get_invoices" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>
							<cfif process_id[currentrow] neq process_id[currentrow-1]>
								<cfif attributes.report_type eq 1>
									<cfif not isdefined("attributes.is_excel")>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#process_id#','medium');" class="tableyazi">
										#dsp_report_type#
									</a>
									<cfelse>
										#dsp_report_type#	
									</cfif>
								<cfelse>
									<cfif not isdefined("attributes.is_excel")>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&pos_code=#process_id#','medium');" class="tableyazi">
										#dsp_report_type#
									</a>
									<cfelse>
										#dsp_report_type#
									</cfif>
								</cfif>
							</cfif>
						</td>
						<td>&nbsp;&nbsp;#due_year# / #listgetat(aylar,due_month,',')#</td>
						<td style="text-align:right;">#TLFormat(net_total_sales)# </td>
						<td>&nbsp;#session.ep.money#</td>
						<td style="text-align:right;"><cfif net_total_sales gt 0>#dateformat(date_add('d',avg_duedate_sales,now()),dateformat_style)#<cfelse>0</cfif></td>
						<td style="text-align:right;">#TLFormat(net_total_revenue)#</td>
						<td>&nbsp;#session.ep.money#</td>
						<td style="text-align:right;"><cfif net_total_revenue gt 0>#dateformat(date_add('d',avg_duedate_revenue,now()),dateformat_style)#<cfelse>0</cfif></td>
						<cfif session.ep.our_company_info.is_paper_closer>
							<td style="text-align:right;">#TLFormat(net_total_borc)#</td>
							<td>&nbsp;#session.ep.money#</td>
							<td style="text-align:right;"><cfif net_total_borc gt 0>#dateformat(date_add('d',avg_duedate_borc,now()),dateformat_style)#<cfelse>0</cfif></td>
							<td style="text-align:right;">#TLFormat(net_total_borc_2)#</td>
							<td>&nbsp;#session.ep.money#</td>
							<td style="text-align:right;"><cfif net_total_borc_2 gt 0>#dateformat(date_add('d',avg_duedate_borc_2,now()),dateformat_style)#<cfelse>0</cfif></td>
							<td style="text-align:right;">#TLFormat(net_total_borc+net_total_borc_2)# </td>
							<td>&nbsp;#session.ep.money#</td>
						</cfif>
					</tr>
					<cfif process_id[currentrow] neq process_id[currentrow+1]>
						<cfquery name="GET_TOPLAM1" dbtype="query">
							SELECT * FROM get_toplam WHERE PROCESS_ID = #PROCESS_ID#
						</cfquery>
						<cfscript>
							ara_toplam_sales = GET_TOPLAM1.net_total_sales;
							ara_toplam_revenue =  GET_TOPLAM1.net_total_revenue;
							ara_toplam_borc =  GET_TOPLAM1.net_total_borc;
							ara_toplam_borc_2 =  GET_TOPLAM1.net_total_borc_2;
							
							ara_toplam_due_sales =  GET_TOPLAM1.net_total_sales * GET_TOPLAM1.avg_duedate_sales;
							ara_toplam_due_revenue =  GET_TOPLAM1.net_total_revenue * GET_TOPLAM1.avg_duedate_revenue;
							ara_toplam_due_borc =  GET_TOPLAM1.net_total_borc * GET_TOPLAM1.avg_duedate_borc;
							ara_toplam_due_borc_2 =  GET_TOPLAM1.net_total_borc_2 * GET_TOPLAM1.avg_duedate_borc_2;
						</cfscript>
						<tr class="total">
							<td class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id ='57492.Toplam'></td>
							<td></td>
							<td class="txtbold" style="text-align:right;">#TLFormat(ara_toplam_sales)#</td>
							<td class="txtbold">&nbsp;#session.ep.money#</td>
							<td class="txtbold" style="text-align:right;">
								<cfif ara_toplam_sales gt 0>
									<cfset last_day = ara_toplam_due_sales / ara_toplam_sales>
									#dateformat(date_add('d',last_day,now()),dateformat_style)#
								<cfelse>
									0
								</cfif>
							</td>
							<td class="txtbold" style="text-align:right;">#TLFormat(ara_toplam_revenue)#<cfif ara_toplam_sales gt 0><br/>%#TLFormat((ara_toplam_revenue/ara_toplam_sales)*100)#</cfif></td>
							<td class="txtbold">&nbsp;#session.ep.money#</td>
							<td class="txtbold" style="text-align:right;">
								<cfif ara_toplam_revenue gt 0>
									<cfset last_day = ara_toplam_due_revenue / ara_toplam_revenue>
									#dateformat(date_add('d',last_day,now()),dateformat_style)#
								<cfelse>
									0
								</cfif>
							</td>
							<cfif session.ep.our_company_info.is_paper_closer>
								<td class="txtbold" style="text-align:right;">#TLFormat(ara_toplam_borc)#</td>
								<td>&nbsp;</td>
								<td class="txtbold" style="text-align:right;">
									<cfif ara_toplam_borc gt 0>
										<cfset last_day = ara_toplam_due_borc / ara_toplam_borc>
										#dateformat(date_add('d',last_day,now()),dateformat_style)#
									<cfelse>
										0
									</cfif>
								</td>
								<td class="txtbold" style="text-align:right;">#TLFormat(ara_toplam_borc_2)# </td>
								<td>&nbsp;</td>
								<td class="txtbold" style="text-align:right;">
									<cfif ara_toplam_due_borc_2 gt 0>
										<cfset last_day = ara_toplam_due_borc_2 / ara_toplam_borc_2>
										#dateformat(date_add('d',last_day,now()),dateformat_style)#
									<cfelse>
										0
									</cfif>
								</td>
								<td class="txtbold" style="text-align:right;">#TLFormat(ara_toplam_borc+ara_toplam_borc_2)#</td>
								<td>&nbsp;</td>
							</cfif>
						</tr>
					</cfif>
					<cfset son_satir = currentrow>
				</cfoutput>
			</tbody>
			<cfelse>
					<tbody>
						<tr>
							<td colspan="16"><cfif not isdefined("attributes.is_submitted")><cf_get_lang dictionary_id='57701.Filtre Ediniz'><cfelse><cf_get_lang dictionary_id='57484.Kayıt Yok'></cfif>!</td>
						</tr>
					</tbody>
				</cfif>
			<tfoot>
			</tfoot>
	</cf_report_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset adres = "#fusebox.Circuit#.monthly_total_revenue&is_submitted=1">
			<cfif isdefined("attributes.date1") and len (attributes.date1)>
			<cfset adres = "#adres#&date1=#dateformat(attributes.date1,'dd/mm/yyy')#">
			</cfif>
			<cfif isdefined("attributes.date2") and len (attributes.date2)>
			<cfset adres = "#adres#&date2=#dateformat(attributes.date2,'dd/mm/yyy')#">
			</cfif>
			<cfif isdefined("attributes.member_cat_type") and len (attributes.member_cat_type)>
			<cfset adres = "#adres#&member_cat_type=#attributes.member_cat_type#">
			</cfif>
			<cfif isdefined("attributes.pos_code") and len (attributes.pos_code) and isdefined("attributes.pos_code_text") and len (attributes.pos_code_text) >
			<cfset adres = "#adres#&pos_code=#attributes.pos_code#">
			<cfset adres = "#adres#&pos_code_text=#attributes.pos_code_text#">
			</cfif>

			<cfif isdefined("attributes.due_date1") and len (attributes.due_date1)>
			<cfset adres = "#adres#&due_date1=#dateformat(attributes.due_date1,'dd/mm/yyy')#">
			</cfif>

			<cfif isdefined("attributes.due_date2") and len (attributes.due_date2)>
			<cfset adres = "#adres#&due_date2=#dateformat(attributes.due_date2,'dd/mm/yyy')#">
			</cfif> 

				<cfif isdefined("attributes.report_type") and len (attributes.report_type)>
			<cfset adres = "#adres#&report_type=#attributes.report_type#">
			</cfif> 

			<cfif isdefined("attributes.rev_date1") and len (attributes.rev_date1)>
			<cfset adres = "#adres#&rev_date1=#dateformat(attributes.rev_date1,'dd/mm/yyy')#">
			</cfif>

			<cfif isdefined("attributes.rev_date2") and len (attributes.rev_date2)>
			<cfset adres = "#adres#&rev_date2=#dateformat(attributes.rev_date2,'dd/mm/yyy')#">
			</cfif>
			<!-- sil --><cf_paging 	
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#adres#"><!-- sil -->
		</cfif>
</cfif>

<script>
	function control1()
	{
		if((document.getElementById('date1').value != '') && (document.getElementById('date2').value != '') &&
			!date_check(document.getElementById('date1'), document.getElementById('date2'),'<cf_get_lang dictionary_id="58862.Baslangic Tarihi Bitis Tarihinden Buyuk Olamaz!">'))
			return false;
		if(document.form_report.is_excel.checked==false)
			{
				document.form_report.action="<cfoutput>#request.self#?fuseaction=report.monthly_total_revenue</cfoutput>"
				return true;
			}
		else 
			{
				document.form_report.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_monthly_total_revenue</cfoutput>"
			}		
	}
</script>