<cffunction name="get_cards_fnc" returntype="query">
	<cfargument name="fis_type" default="">
	<cfargument name="start_date" default=""/>
	<cfargument name="finish_date" default=""/>
	<cfargument name="employee_id" default=""/>
	<cfargument name="employee_name" default=""/>
	<cfargument name="record_date" default=""/>
	<cfargument name="finish_record_date" default=""/>
	<cfargument name="action_process_cat" default="">
	<cfargument name="keyword" default=""/>
	<cfargument name="oby" default="">
	<cfargument name="acc_branch_id" default="">
	<cfargument name="project_id" default="">
	<cfargument name="project_head" default="">
	<cfargument name="show_type" default="">
    <cfargument name="startrow" default="">
	<cfargument name="maxrows" default="">
	<cfquery name="GET_CARDS" datasource="#this.dsn2#">
		WITH CTE1 AS (
        SELECT DISTINCT 
			NEW_CARD_ID AS CARD_ID,
			NEW_BILL_NO AS BILL_NO,
			NEW_CARD_TYPE_NO AS CARD_TYPE_NO,
			CARD_TYPE,
			CARD_CAT_ID,
			'' AS ACC_COMPANY_ID,
			'' AS ACC_CONSUMER_ID,	
			'' AS ACC_EMPLOYEE_ID,			
			PROCESS_DATE,
			RECORD_EMP,
			'' AS RECORD_PAR,
			'' AS RECORD_CONS,
			RECORD_IP
		FROM 
			ACCOUNT_CARD_SAVE
		WHERE
		<cfif arguments.fis_type eq 3>
			NEW_CARD_ID NOT IN (SELECT CARD_ID FROM ACCOUNT_CARD) 
			AND IS_TEMPORARY_SOLVED=1
		<cfelse>
			ACTION_ID IS NULL	
		</cfif>	
		<cfif isdate(arguments.start_date) and isdate(arguments.finish_date)>
			AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
			AND ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,arguments.finish_date)#">
		<cfelseif isdate(arguments.finish_date)>
			AND ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,arguments.finish_date)#">
		<cfelseif isdate(arguments.start_date)>
			AND ACTION_DATE >=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> 
		</cfif>
		<cfif isDefined("arguments.employee_id") and len(arguments.employee_id)  and isDefined("arguments.employee_name") and len(arguments.employee_name)>
			AND RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
		</cfif>
		<cfif isdate(arguments.record_date)>
			AND RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.record_date#"> 
		</cfif>
        <cfif isdate(arguments.finish_record_date)>
			AND RECORD_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,arguments.finish_record_date)#"> 
		</cfif>
		<cfif isnumeric(arguments.keyword)>
			AND
			(
				NEW_BILL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
				NEW_CARD_TYPE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#"> COLLATE SQL_Latin1_General_CP1_CI_AI
			)
		</cfif>
		<cfif isDefined("arguments.action_process_cat") and len(arguments.action_process_cat)><!--- fişin baglı oldugu işlemin kategorisi --->
			<cfif listlen(arguments.action_process_cat,'-') eq 1 or (listlen(arguments.action_process_cat,'-') gt 1 and listlast(arguments.action_process_cat,'-') eq 0)>
				AND ACTION_TYPE=#listfirst(arguments.action_process_cat,'-')#
			<cfelse>
				AND ACTION_CAT_ID=#listlast(arguments.action_process_cat,'-')#
			</cfif>
		</cfif>
        <cfif isdefined("arguments.acc_branch_id") and len(arguments.acc_branch_id)>
			<cfif (isdefined('arguments.list_type_form') and arguments.list_type_form eq 2)>
				AND ACCOUNT_CARD_SAVE.ACC_BRANCH_ID= #arguments.acc_branch_id#
			<cfelse>
				AND ACCOUNT_CARD_SAVE.CARD_ID IN
					(
						SELECT 
							ACCR.CARD_ID 
						FROM 
							ACCOUNT_CARD_SAVE_ROWS ACCR 
						WHERE 
							ACCR.CARD_ID = ACCOUNT_CARD_SAVE.CARD_ID 
							AND ACCR.ACC_BRANCH_ID= #arguments.acc_branch_id#
					)
			</cfif>
		</cfif>
		<cfif isdefined("arguments.project_id") and len(arguments.project_id) and len(arguments.project_head)>
			<cfif (isdefined('arguments.list_type_form') and arguments.list_type_form eq 2)>
				AND ACCOUNT_CARD_SAVE.ACC_PROJECT_ID= #arguments.project_id#
			<cfelse>
				AND ACCOUNT_CARD_SAVE.CARD_ID IN
					(
						SELECT 
							ACCR.CARD_ID 
						FROM 
							ACCOUNT_CARD_SAVE_ROWS ACCR 
						WHERE 
							ACCR.CARD_ID = ACCOUNT_CARD_SAVE.CARD_ID 
							AND ACCR.ACC_PROJECT_ID= #arguments.project_id#
					)
			</cfif>
		</cfif>
        ),
        CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (	<cfif isDefined('arguments.oby') and arguments.oby eq 2>
                                            ORDER BY PROCESS_DATE
                                        <cfelseif isDefined('arguments.oby') and arguments.oby eq 3>
                                            ORDER BY BILL_NO
                                        <cfelseif isDefined('arguments.oby') and arguments.oby eq 4>
                                            ORDER BY NEW_BILL_NO DESC
                                        <cfelse>
                                            ORDER BY PROCESS_DATE DESC
                                        </cfif>
									) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
				FROM
					CTE1
			)
			SELECT
				CTE2.*
			FROM
				CTE2
			WHERE
				RowNum BETWEEN #startrow# and #startrow#+(#maxrows#-1)
	</cfquery>
	<cfreturn GET_CARDS>
</cffunction>

<cffunction name="get_cards_fnc2" returntype="query">
	<cfargument name="main_card_id" default="">
	<cfargument name="start_date" default=""/>
	<cfargument name="finish_date" default=""/>
	<cfargument name="employee_id" default=""/>
	<cfargument name="employee_name" default=""/>
	<cfargument name="record_date" default=""/>
	<cfargument name="finish_record_date" default=""/>
	<cfargument name="keyword" default=""/>
	<cfargument name="action_process_cat" default="">
	<cfargument name="oby" default="">
	<cfargument name="acc_branch_id" default="">
	<cfargument name="project_id" default="">
	<cfargument name="project_head" default="">
	<cfargument name="show_type" default="">
    <cfargument name="startrow" default="">
	<cfargument name="maxrows" default="">
	<cfquery name="GET_CARDS" datasource="#this.dsn2#">
		WITH CTE1 AS (
        SELECT
			ACS.*,
			'' RECORD_PAR,
			'' RECORD_CONS,
			CARD_CAT_ID PROCESS_CAT
            <cfif isDefined('session.ep.our_company_info.is_edefter') and session.ep.our_company_info.is_edefter eq 1>
            ,ACDT.DETAIL DOCUMENT_TYPE,
            ACPT.PAYMENT_TYPE
            </cfif>
		FROM 
			ACCOUNT_CARD_SAVE ACS
            <cfif isDefined('session.ep.our_company_info.is_edefter') and session.ep.our_company_info.is_edefter eq 1>
                LEFT JOIN #this.dsn_alias#.ACCOUNT_CARD_PAYMENT_TYPES ACPT ON ACPT.PAYMENT_TYPE_ID = ACS.CARD_PAYMENT_METHOD
                LEFT JOIN #this.dsn_alias#.ACCOUNT_CARD_DOCUMENT_TYPES ACDT ON ACDT.DOCUMENT_TYPE_ID = ACS.CARD_DOCUMENT_TYPE
            </cfif>
		WHERE
			ACS.NEW_CARD_ID = #arguments.main_card_id#
		<cfif isdate(arguments.start_date) and isdate(arguments.finish_date)>
			AND ACS.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
			AND ACS.ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,arguments.finish_date)#">
		<cfelseif isdate(arguments.finish_date)>
			AND ACS.ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,arguments.finish_date)#">
		<cfelseif isdate(arguments.start_date)>
			AND ACS.ACTION_DATE >=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> 
		</cfif>
		<cfif isDefined("arguments.employee_id") and len(arguments.employee_id)  and isDefined("arguments.employee_name") and len(arguments.employee_name)>
			AND ACS.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
		</cfif>
		<cfif isdate(arguments.record_date)>
			AND ACS.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.record_date#"> 
		</cfif>
        <cfif isdate(arguments.finish_record_date)>
			AND ACS.RECORD_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,arguments.finish_record_date)#"> 
		</cfif>
		<cfif isnumeric(arguments.keyword)>
			AND
			(
				ACS.NEW_BILL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
				ACS.NEW_CARD_TYPE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#"> COLLATE SQL_Latin1_General_CP1_CI_AI
			)
		</cfif>
		<cfif isDefined("arguments.action_process_cat") and len(arguments.action_process_cat)><!--- fişin baglı oldugu işlemin kategorisi --->
			<cfif listlen(arguments.action_process_cat,'-') eq 1 or (listlen(arguments.action_process_cat,'-') gt 1 and listlast(arguments.action_process_cat,'-') eq 0)>
				AND ACTION_TYPE=#listfirst(arguments.action_process_cat,'-')#
			<cfelse>
				AND ACTION_CAT_ID=#listlast(arguments.action_process_cat,'-')#
			</cfif>
		</cfif>
        <cfif isdefined("arguments.acc_branch_id") and len(arguments.acc_branch_id)>
			AND ACCOUNT_CARD_SAVE.CARD_ID IN
				(
					SELECT 
						ACCR.CARD_ID 
					FROM 
						ACCOUNT_CARD_SAVE_ROWS ACCR 
					WHERE 
						ACCR.CARD_ID = ACCOUNT_CARD_SAVE.CARD_ID 
						AND ACCR.ACC_BRANCH_ID= #arguments.acc_branch_id#
				)
		</cfif>
		<cfif isdefined("arguments.project_id") and len(arguments.project_id) and len(arguments.project_head)>
			AND ACCOUNT_CARD_SAVE.CARD_ID IN
				(
					SELECT 
						ACCR.CARD_ID 
					FROM 
						ACCOUNT_CARD_SAVE_ROWS ACCR 
					WHERE 
						ACCR.CARD_ID = ACCOUNT_CARD_SAVE.CARD_ID 
						AND ACCR.ACC_PROJECT_ID= #arguments.project_id#
				)
		</cfif>
        ),
         CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (	<cfif isDefined('arguments.oby') and arguments.oby eq 2>
                                            ORDER BY PROCESS_DATE
                                        <cfelseif isDefined('arguments.oby') and arguments.oby eq 3>
                                            ORDER BY NEW_BILL_NO
                                        <cfelseif isDefined('arguments.oby') and arguments.oby eq 4>
                                            ORDER BY NEW_BILL_NO DESC
                                        <cfelse>
                                            ORDER BY PROCESS_DATE DESC
                                        </cfif>
									) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
				FROM
					CTE1
			)
			SELECT
				CTE2.*
			FROM
				CTE2
			WHERE
				RowNum BETWEEN #startrow# and #startrow#+(#maxrows#-1)
	</cfquery>
	<cfreturn GET_CARDS>
</cffunction>

<cffunction name="get_cards_fnc3" returntype="query">
	<cfargument name="fis_type" default="">
	<cfargument name="list_type_form" default="">
	<cfargument name="start_date" default=""/>
	<cfargument name="finish_date" default=""/>
	<cfargument name="employee_id" default=""/>
	<cfargument name="employee_name" default=""/>
	<cfargument name="record_date" default=""/>
	<cfargument name="finish_record_date" default=""/>
	<cfargument name="keyword" default=""/>
	<cfargument name="oby" default="">
	<cfargument name="action_process_cat" default="">
	<cfargument name="page_action_type" default="">
	<cfargument name="belge_no" default="">
	<cfargument name="card_id" default="">
	<cfargument name="company_id" default="">
	<cfargument name="company" default="">
	<cfargument name="consumer_id" default="">
	<cfargument name="acc_code1_1" default="">
	<cfargument name="acc_code1_2" default="">
	<cfargument name="acc_code1_3" default="">
	<cfargument name="acc_code1_4" default="">
	<cfargument name="acc_code1_5" default="">
	<cfargument name="acc_code2_1" default="">
	<cfargument name="acc_code2_2" default="">
	<cfargument name="acc_code2_3" default="">
	<cfargument name="acc_code2_4" default="">
	<cfargument name="acc_code2_5" default="">
	<cfargument name="project_id" default="">
	<cfargument name="project_head" default="">
	<cfargument name="show_type" default="">
	<cfargument name="is_add_main_page" default="">
    <cfargument name="startrow" default="">
	<cfargument name="maxrows" default="">
	<cfquery name="GET_CARDS" datasource="#this.dsn2#">
		WITH CTE1 AS (
        SELECT
			ACC.ACTION_CAT_ID PROCESS_CAT,
			ACC.CARD_ID,
			ACC.PAPER_NO,
			ACC.CARD_DETAIL,
			ACC.ACTION_DATE,
			ACC.ACTION_TYPE,
			ACC.ACTION_ID,
			ACC.CARD_TYPE,
			ACC.CARD_CAT_ID,
			ACC.CARD_TYPE_NO,
			ACC.BILL_NO,
			ACC.RECORD_EMP,
			ACC.RECORD_PAR,
			ACC.RECORD_CONS,
            ACC.ACC_COMPANY_ID,
            ACC.ACC_CONSUMER_ID,
		    ACC.ACC_EMPLOYEE_ID,
			ACC.RECORD_DATE,
            ISNULL(BA.ACTION_TYPE_ID,CA.ACTION_TYPE_ID) AS EXPENSE_TYPE_ID_,
            ISNULL(BA.EXPENSE_ID,CA.EXPENSE_ID) AS EXPENSE_ID_,
			<cfif isdefined('arguments.list_type_form') and arguments.list_type_form eq 2>
				ACR.DETAIL AS ROW_DETAIL,
				ACR.ACCOUNT_ID,
				ACR.IFRS_CODE,
				AP.ACCOUNT_NAME,
				ACR.AMOUNT,
				ACR.AMOUNT_CURRENCY,
				ACR.BA,
				ACR.ACC_DEPARTMENT_ID,
				ACR.ACC_BRANCH_ID,
				ACR.ACC_PROJECT_ID,
			</cfif>
			ACC.IS_COMPOUND
            <cfif isDefined('session.ep.our_company_info.is_edefter') and session.ep.our_company_info.is_edefter eq 1>
            ,ACDT.DETAIL DOCUMENT_TYPE,
            ACPT.PAYMENT_TYPE
            </cfif>
		FROM
			ACCOUNT_CARD ACC
            	LEFT JOIN BANK_ACTIONS BA ON BA.ACTION_ID = ACC.ACTION_ID AND BA.PAPER_NO = ACC.PAPER_NO
                LEFT JOIN CASH_ACTIONS CA ON CA.ACTION_ID = ACC.ACTION_ID AND CA.PAPER_NO = ACC.PAPER_NO
			<cfif isDefined('session.ep.our_company_info.is_edefter') and session.ep.our_company_info.is_edefter eq 1>
                LEFT JOIN #this.dsn_alias#.ACCOUNT_CARD_PAYMENT_TYPES ACPT ON ACPT.PAYMENT_TYPE_ID = ACC.CARD_PAYMENT_METHOD
                LEFT JOIN #this.dsn_alias#.ACCOUNT_CARD_DOCUMENT_TYPES ACDT ON ACDT.DOCUMENT_TYPE_ID = ACC.CARD_DOCUMENT_TYPE
            </cfif>
			<cfif (isdefined('arguments.list_type_form') and arguments.list_type_form eq 2)><!--- hesap kodu secilmisse veya satır bazında listeleme yapılacaksa --->
			,ACCOUNT_CARD_ROWS ACR
			</cfif>
			<cfif isdefined('arguments.list_type_form') and arguments.list_type_form eq 2>
			,ACCOUNT_PLAN AP
			</cfif>
		WHERE
			ACC.CARD_ID IS NOT NULL
		<cfif isdefined('arguments.fis_type') and arguments.fis_type eq 4><!--- manuel eklenmiş fisler bulunuyor --->
			AND ACC.ACTION_ID IS NULL AND ISNULL(ACC.IS_COMPOUND,0)=0
		</cfif>
		<cfif isdefined('arguments.list_type_form') and arguments.list_type_form eq 2><!--- hesap kodu secilmisse veya satır bazında listeleme yapılacaksa --->
			AND ACC.CARD_ID=ACR.CARD_ID
		</cfif>
		<cfif isdefined('arguments.list_type_form') and arguments.list_type_form eq 2>
			AND ACR.ACCOUNT_ID=AP.ACCOUNT_CODE
		</cfif>
        <cfif isdefined("arguments.acc_branch_id") and len(arguments.acc_branch_id)>
			<cfif (isdefined('arguments.list_type_form') and arguments.list_type_form eq 2)>
				AND ACR.ACC_BRANCH_ID= #arguments.acc_branch_id#
			<cfelse>
				AND ACC.CARD_ID IN
					(
						SELECT 
							ACCR.CARD_ID 
						FROM 
							ACCOUNT_CARD_ROWS ACCR 
						WHERE 
							ACCR.CARD_ID = ACC.CARD_ID 
							AND ACCR.ACC_BRANCH_ID= #arguments.acc_branch_id#
					)
			</cfif>
		</cfif>
		<cfif isdefined("arguments.project_id") and len(arguments.project_id) and len(arguments.project_head)>
			<cfif (isdefined('arguments.list_type_form') and arguments.list_type_form eq 2)>
				AND ACR.ACC_PROJECT_ID= #arguments.project_id#
			<cfelse>
				AND ACC.CARD_ID IN
					(
						SELECT 
							ACCR.CARD_ID 
						FROM 
							ACCOUNT_CARD_ROWS ACCR 
						WHERE 
							ACCR.CARD_ID = ACC.CARD_ID 
							AND ACCR.ACC_PROJECT_ID= #arguments.project_id#
					)
			</cfif>
		</cfif>
		<cfif isDefined("arguments.action_process_cat") and len(arguments.action_process_cat)><!--- fişin baglı oldugu işlemin kategorisi --->
			<cfif listlen(arguments.action_process_cat,'-') eq 1 or (listlen(arguments.action_process_cat,'-') gt 1 and listlast(arguments.action_process_cat,'-') eq 0)>
				AND ACC.ACTION_TYPE=#listfirst(arguments.action_process_cat,'-')#
			<cfelse>
				AND ACC.ACTION_CAT_ID=#listlast(arguments.action_process_cat,'-')#
			</cfif>
		</cfif>
		<cfif isDefined("arguments.page_action_type") and len(arguments.page_action_type)><!--- mahsup,tediye fiş kategorisi  --->
			<cfif listlen(arguments.page_action_type,'-') eq 1 or (listlen(arguments.page_action_type,'-') gt 1 and listlast(arguments.page_action_type,'-') eq 0)>
				AND ACC.CARD_TYPE=#listfirst(arguments.page_action_type,'-')#
			<cfelse>
				AND ACC.CARD_CAT_ID=#listlast(arguments.page_action_type,'-')#
			</cfif>
		</cfif>
		<cfif len(arguments.keyword)>
			<cfif isnumeric(arguments.keyword)>
				AND
				(
					ACC.BILL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
					ACC.CARD_TYPE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#"> COLLATE SQL_Latin1_General_CP1_CI_AI
				)
			<cfelse>
			AND ACC.CARD_DETAIL LIKE <cfif len(arguments.keyword) gt 3><cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI</cfif>
			</cfif>
		</cfif>
		<cfif len(arguments.belge_no)>
			AND ACC.PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.belge_no#">
		</cfif>
		<cfif isDefined("arguments.card_id") and len(arguments.card_id) and not isdefined("arguments.is_add_main_page")>
			AND ACC.CARD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.card_id#">
		</cfif>
		<cfif isDefined("arguments.doc_type") and len(arguments.doc_type)>
			<cfif arguments.doc_type eq 999>
				AND ACC.CARD_DOCUMENT_TYPE IS NULL
			<cfelse>
				AND ACC.CARD_DOCUMENT_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.doc_type#">
			</cfif>
		</cfif>
        <cfif isdefined("arguments.company_id") and len(arguments.company_id) and isdefined("arguments.company") and len(arguments.company)>
			AND ACC.ACC_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
        <cfelseif isdefined("arguments.company") and len(arguments.company) and isdefined("arguments.consumer_id") and len(arguments.consumer_id)>
			AND ACC.ACC_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#"> 
		</cfif>
		<cfif isdate(arguments.start_date) and isdate(arguments.finish_date)>
			AND ACC.ACTION_DATE >= #arguments.start_date#
			AND ACC.ACTION_DATE < #dateadd('d',1,arguments.finish_date)#
		<cfelseif isdate(arguments.finish_date)>
			AND ACC.ACTION_DATE < #dateadd('d',1,arguments.finish_date)#
		<cfelseif isdate(arguments.start_date)>
			AND ACC.ACTION_DATE >= #arguments.start_date#
		</cfif>
		<cfif isDefined("arguments.employee_id") and len(arguments.employee_id)  and isDefined("arguments.employee_name") and len(arguments.employee_name) >
			AND ACC.RECORD_EMP =<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#"> 
		</cfif>
		<cfif len(arguments.fis_type) and arguments.fis_type eq 1>
			AND ACC.IS_COMPOUND = 1
		<cfelseif len(arguments.fis_type) and arguments.fis_type neq 1>
			AND (ACC.IS_COMPOUND IS NULL OR ACC.IS_COMPOUND = 0)
		</cfif>
		<cfif isdate(arguments.record_date)>
			AND ACC.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.record_date#"> 
		</cfif>
        <cfif isdate(arguments.finish_record_date)>
			AND ACC.RECORD_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,arguments.finish_record_date)#">
		</cfif>
		<cfif len(arguments.show_type) and arguments.show_type eq 1> 
			AND ACC.CARD_ID IN
					(
						SELECT 
							ACCR.CARD_ID 
						FROM 
							ACCOUNT_CARD_ROWS ACCR 
						WHERE 
							ACCR.CARD_ID = ACC.CARD_ID 
					)
			AND  ACC.CARD_ID NOT IN
					(
						SELECT 
							ACCR.CARD_ID 
						FROM 
							ACCOUNT_ROWS_IFRS ACCR 
						WHERE 
							ACCR.CARD_ID = ACC.CARD_ID 
					)
		<cfelseif  len(arguments.show_type) and arguments.show_type eq 2>
			AND ACC.CARD_ID NOT IN
					(
						SELECT 
							ACCR.CARD_ID 
						FROM 
							ACCOUNT_CARD_ROWS ACCR 
						WHERE 
							ACCR.CARD_ID = ACC.CARD_ID 
					)
			AND  ACC.CARD_ID IN
					(
						SELECT 
							ACCR.CARD_ID 
						FROM 
							ACCOUNT_ROWS_IFRS ACCR 
						WHERE 
							ACCR.CARD_ID = ACC.CARD_ID 
					)

		<cfelseif  len(arguments.show_type) and arguments.show_type eq 3>
			AND ACC.CARD_ID IN
					(
						SELECT 
							ACCR.CARD_ID 
						FROM 
							ACCOUNT_CARD_ROWS ACCR 
						WHERE 
							ACCR.CARD_ID = ACC.CARD_ID 
					)
			AND  ACC.CARD_ID IN
					(
						SELECT 
							ACCR.CARD_ID 
						FROM 
							ACCOUNT_ROWS_IFRS ACCR 
						WHERE 
							ACCR.CARD_ID = ACC.CARD_ID 
					)
		</cfif> 
		<cfif (isDefined("arguments.acc_code1_1") and len(evaluate("arguments.acc_code1_1"))) or (isDefined("arguments.acc_code1_2") and len(evaluate("arguments.acc_code1_2"))) or (isDefined("arguments.acc_code1_3") and len(evaluate("arguments.acc_code1_3"))) or (isDefined("arguments.acc_code1_4") and len(evaluate("arguments.acc_code1_4"))) or (isDefined("arguments.acc_code1_5") and len(evaluate("arguments.acc_code1_5")))>
			AND 
			(
				<cfloop from="1" to="5" index="kk">
					<cfif kk neq 1>OR</cfif>
					(
						1 = 0
						<cfif (isDefined("arguments.acc_code1_#kk#") and len(evaluate("arguments.acc_code1_#kk#"))) or (isDefined("arguments.acc_code2_#kk#") and len(evaluate("arguments.acc_code2_#kk#")))>
							OR
							(
								ACC.CARD_ID IN
								(
									SELECT 
										ACCR.CARD_ID 
									FROM 
										ACCOUNT_CARD_ROWS ACCR 
									WHERE 
										ACCR.CARD_ID = ACC.CARD_ID 
										<cfif isDefined("arguments.acc_code1_#kk#") and len(evaluate("arguments.acc_code1_#kk#"))>
											AND ACCR.ACCOUNT_ID >= '#evaluate("arguments.acc_code1_#kk#")#'
										</cfif>
										<cfif isDefined("arguments.acc_code2_#kk#") and len(evaluate("arguments.acc_code2_#kk#"))>
											AND ACCR.ACCOUNT_ID <= '#evaluate("arguments.acc_code2_#kk#")#'
										</cfif>
								)
							)
						</cfif>
					)
				</cfloop>
			)
		</cfif>
        ),
        CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (	<cfif isDefined('arguments.oby') and arguments.oby eq 2>
                                            ORDER BY ACTION_DATE
                                        <cfelseif isDefined('arguments.oby') and arguments.oby eq 3>
                                            ORDER BY BILL_NO
                                        <cfelseif isDefined('arguments.oby') and arguments.oby eq 4>
                                            ORDER BY BILL_NO DESC
                                        <cfelse>
                                            ORDER BY ACTION_DATE DESC
                                        </cfif>
									) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
				FROM
					CTE1
			)
			SELECT
				CTE2.*
			FROM
				CTE2
			WHERE
				RowNum BETWEEN #startrow# and #startrow#+(#maxrows#-1)
		
	</cfquery>
	<cfreturn GET_CARDS>
</cffunction>
