<cfif isdefined('attributes.fis_type') and (attributes.fis_type eq 3 or attributes.fis_type eq 5)>
	<cfquery name="GET_CARDS" datasource="#dsn2#">
		SELECT DISTINCT 
			NEW_CARD_ID AS CARD_ID,
			NEW_BILL_NO AS BILL_NO,
			NEW_CARD_TYPE_NO AS CARD_TYPE_NO,
			CARD_TYPE,
			CARD_CAT_ID,
			'' AS ACC_COMPANY_ID,
			'' AS ACC_CONSUMER_ID,			
			PROCESS_DATE,
			RECORD_EMP,
			'' AS RECORD_PAR,
			'' AS RECORD_CONS,
			RECORD_IP
		FROM 
			ACCOUNT_CARD_SAVE
		WHERE
		<cfif attributes.fis_type eq 3>
			NEW_CARD_ID NOT IN (SELECT CARD_ID FROM ACCOUNT_CARD) 
			AND IS_TEMPORARY_SOLVED=1
		<cfelse>
			ACTION_ID IS NULL	
		</cfif>	
		<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
			AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
			AND ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,attributes.finish_date)#">
		<cfelseif isdate(attributes.finish_date)>
			AND ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,attributes.finish_date)#">
		<cfelseif isdate(attributes.start_date)>
			AND ACTION_DATE >=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> 
		</cfif>
		<cfif isDefined("attributes.employee_id") and len(attributes.employee_id)  and isDefined("attributes.employee_name") and len(attributes.employee_name)>
			AND RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
		</cfif>
		<cfif isdate(attributes.record_date)>
			AND RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.record_date#"> 
		</cfif>
        <cfif isdate(attributes.finish_record_date)>
			AND RECORD_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,attributes.finish_record_date)#"> 
		</cfif>
		<cfif isnumeric(attributes.keyword)>
			AND
			(
				NEW_BILL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">  OR
				NEW_CARD_TYPE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">
			)
		</cfif>
       <cfif isdefined("attributes.acc_branch_id") and len(attributes.acc_branch_id)>
			AND ACCOUNT_CARD_SAVE.CARD_ID IN
				(
					SELECT 
						ACCR.CARD_ID 
					FROM 
						ACCOUNT_CARD_SAVE_ROWS ACCR 
					WHERE 
						ACCR.CARD_ID = ACCOUNT_CARD_SAVE.CARD_ID 
						AND ACCR.ACC_BRANCH_ID= #attributes.acc_branch_id#
				)
		</cfif>
		<cfif isDefined('attributes.oby') and attributes.oby eq 2>
			ORDER BY PROCESS_DATE
		<cfelseif isDefined('attributes.oby') and attributes.oby eq 3>
			ORDER BY NEW_BILL_NO
		<cfelseif isDefined('attributes.oby') and attributes.oby eq 4>
			ORDER BY NEW_BILL_NO DESC
		<cfelse>
			ORDER BY PROCESS_DATE DESC
		</cfif>
	</cfquery>
<cfelseif isdefined('attributes.fis_type') and attributes.fis_type eq 6>
	<cfquery name="GET_CARDS" datasource="#dsn2#">
		SELECT
			*,
			'' RECORD_PAR,
			'' RECORD_CONS,
			CARD_CAT_ID PROCESS_CAT
		FROM 
			ACCOUNT_CARD_SAVE
		WHERE
			NEW_CARD_ID = #attributes.main_card_id#
		<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
			AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
			AND ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,attributes.finish_date)#">
		<cfelseif isdate(attributes.finish_date)>
			AND ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,attributes.finish_date)#">
		<cfelseif isdate(attributes.start_date)>
			AND ACTION_DATE >=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> 
		</cfif>
		<cfif isDefined("attributes.employee_id") and len(attributes.employee_id)  and isDefined("attributes.employee_name") and len(attributes.employee_name)>
			AND RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
		</cfif>
		<cfif isdate(attributes.record_date)>
			AND RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.record_date#"> 
		</cfif>
        <cfif isdate(attributes.finish_record_date)>
			AND RECORD_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,attributes.finish_record_date)#"> 
		</cfif>
		<cfif isnumeric(attributes.keyword)>
			AND
			(
				NEW_BILL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">  OR
				NEW_CARD_TYPE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">
			)
		</cfif>
		<cfif isdefined("attributes.acc_branch_id") and len(attributes.acc_branch_id)>
			AND ACCOUNT_CARD_SAVE.CARD_ID IN
				(
					SELECT 
						ACCR.CARD_ID 
					FROM 
						ACCOUNT_CARD_SAVE_ROWS ACCR 
					WHERE 
						ACCR.CARD_ID = ACCOUNT_CARD_SAVE.CARD_ID 
						AND ACCR.ACC_BRANCH_ID= #attributes.acc_branch_id#
				)
		</cfif>		
		<cfif isDefined('attributes.oby') and attributes.oby eq 2>
			ORDER BY PROCESS_DATE
		<cfelseif isDefined('attributes.oby') and attributes.oby eq 3>
			ORDER BY NEW_BILL_NO
		<cfelseif isDefined('attributes.oby') and attributes.oby eq 4>
			ORDER BY NEW_BILL_NO DESC
		<cfelse>
			ORDER BY PROCESS_DATE DESC
		</cfif>
	</cfquery>
<cfelse>
	<cfquery name="GET_CARDS" datasource="#dsn2#">
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
			ACC.RECORD_DATE,
			<cfif isdefined('attributes.list_type_form') and attributes.list_type_form eq 2>
			ACR.DETAIL AS ROW_DETAIL,
			ACR.ACCOUNT_ID,
			ACR.IFRS_CODE,
			AP.ACCOUNT_NAME,
			ACR.AMOUNT,
			ACR.BA,
			</cfif>
			ACC.IS_COMPOUND
		FROM
			ACCOUNT_CARD ACC
			<cfif (isdefined('attributes.list_type_form') and attributes.list_type_form eq 2)><!--- hesap kodu secilmisse veya satır bazında listeleme yapılacaksa --->
			,ACCOUNT_CARD_ROWS ACR
			</cfif>
			<cfif isdefined('attributes.list_type_form') and attributes.list_type_form eq 2>
			,ACCOUNT_PLAN AP
			</cfif>
		WHERE
			ACC.CARD_ID IS NOT NULL
		<cfif isdefined('attributes.fis_type') and attributes.fis_type eq 4><!--- manuel eklenmiş fisler bulunuyor --->
			AND ACC.ACTION_ID IS NULL AND ISNULL(ACC.IS_COMPOUND,0)=0
		</cfif>
		<cfif isdefined('attributes.list_type_form') and attributes.list_type_form eq 2><!--- hesap kodu secilmisse veya satır bazında listeleme yapılacaksa --->
			AND ACC.CARD_ID=ACR.CARD_ID
		</cfif>
		<cfif isdefined('attributes.list_type_form') and attributes.list_type_form eq 2>
			AND ACR.ACCOUNT_ID=AP.ACCOUNT_CODE
		</cfif>
        <cfif isdefined("attributes.acc_branch_id") and len(attributes.acc_branch_id)>
			<cfif (isdefined('attributes.list_type_form') and attributes.list_type_form eq 2)>
				AND ACR.ACC_BRANCH_ID= #attributes.acc_branch_id#
			<cfelse>
				AND ACC.CARD_ID IN
					(
						SELECT 
							ACCR.CARD_ID 
						FROM 
							ACCOUNT_CARD_ROWS ACCR 
						WHERE 
							ACCR.CARD_ID = ACC.CARD_ID 
							AND ACCR.ACC_BRANCH_ID= #attributes.acc_branch_id#
					)
			</cfif>
		</cfif>
		<cfif isDefined("attributes.action_process_cat") and len(attributes.action_process_cat)><!--- fişin baglı oldugu işlemin kategorisi --->
			<cfif listlen(attributes.action_process_cat,'-') eq 1 or (listlen(attributes.action_process_cat,'-') gt 1 and listlast(attributes.action_process_cat,'-') eq 0)>
				AND ACC.ACTION_TYPE=#listfirst(attributes.action_process_cat,'-')#
			<cfelse>
				AND ACC.ACTION_CAT_ID=#listlast(attributes.action_process_cat,'-')#
			</cfif>
		</cfif>
		<cfif isDefined("attributes.page_action_type") and len(attributes.page_action_type)><!--- mahsup,tediye fiş kategorisi  --->
			<cfif listlen(attributes.page_action_type,'-') eq 1 or (listlen(attributes.page_action_type,'-') gt 1 and listlast(attributes.page_action_type,'-') eq 0)>
				AND ACC.CARD_TYPE=#listfirst(attributes.page_action_type,'-')#
			<cfelse>
				AND ACC.CARD_CAT_ID=#listlast(attributes.page_action_type,'-')#
			</cfif>
		</cfif>
		<cfif len(attributes.keyword)>
			<cfif isnumeric(attributes.keyword)>
				AND
				(
					ACC.BILL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR
					ACC.CARD_TYPE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">
				)
			<cfelse>
			AND ACC.CARD_DETAIL LIKE <cfif len(attributes.keyword) gt 3><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"></cfif>
			</cfif>
		</cfif>
		<cfif len(attributes.belge_no)>
			AND ACC.PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.belge_no#">
		</cfif>
		<cfif isDefined("attributes.card_id") and len(attributes.card_id) and not isdefined("attributes.is_add_main_page")>
			AND ACC.CARD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.card_id#">
		</cfif>
        <cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company)>
			AND ACC.ACC_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
        <cfelseif isdefined("attributes.company") and len(attributes.company) and isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
			AND ACC.ACC_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> 
		</cfif>
		<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
			AND ACC.ACTION_DATE >= #attributes.start_date#
			AND ACC.ACTION_DATE < #dateadd('d',1,attributes.finish_date)#
		<cfelseif isdate(attributes.finish_date)>
			AND ACC.ACTION_DATE < #dateadd('d',1,attributes.finish_date)#
		<cfelseif isdate(attributes.start_date)>
			AND ACC.ACTION_DATE >= #attributes.start_date#
		</cfif>
		<cfif isDefined("attributes.employee_id") and len(attributes.employee_id)  and isDefined("attributes.employee_name") and len(attributes.employee_name) >
			AND ACC.RECORD_EMP =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> 
		</cfif>
		<cfif len(attributes.fis_type) and attributes.fis_type eq 1>
			AND ACC.IS_COMPOUND = 1
		<cfelseif len(attributes.fis_type) and attributes.fis_type neq 1>
			AND (ACC.IS_COMPOUND IS NULL OR ACC.IS_COMPOUND = 0)
		</cfif>
		<cfif isdate(attributes.record_date)>
			AND ACC.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.record_date#"> 
		</cfif>
        <cfif isdate(attributes.finish_record_date)>
			AND ACC.RECORD_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,attributes.finish_record_date)#">
		</cfif>
		<cfif (isDefined("attributes.acc_code1_1") and len(evaluate("attributes.acc_code1_1"))) or (isDefined("attributes.acc_code1_2") and len(evaluate("attributes.acc_code1_2"))) or (isDefined("attributes.acc_code1_3") and len(evaluate("attributes.acc_code1_3"))) or (isDefined("attributes.acc_code1_4") and len(evaluate("attributes.acc_code1_4"))) or (isDefined("attributes.acc_code1_5") and len(evaluate("attributes.acc_code1_5")))>
			AND 
			(
				<cfloop from="1" to="5" index="kk">
					<cfif kk neq 1>OR</cfif>
					(
						1 = 0
						<cfif (isDefined("attributes.acc_code1_#kk#") and len(evaluate("attributes.acc_code1_#kk#"))) or (isDefined("attributes.acc_code2_#kk#") and len(evaluate("attributes.acc_code2_#kk#")))>
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
										<cfif isDefined("attributes.acc_code1_#kk#") and len(evaluate("attributes.acc_code1_#kk#"))>
											AND ACCR.ACCOUNT_ID >= '#evaluate("attributes.acc_code1_#kk#")#'
										</cfif>
										<cfif isDefined("attributes.acc_code2_#kk#") and len(evaluate("attributes.acc_code2_#kk#"))>
											AND ACCR.ACCOUNT_ID <= '#evaluate("attributes.acc_code2_#kk#")#'
										</cfif>
								)
							)
						</cfif>
					)
				</cfloop>
			)
		</cfif>
		<cfif isDefined('attributes.oby') and attributes.oby eq 2>
			ORDER BY ACC.ACTION_DATE
		<cfelseif isDefined('attributes.oby') and attributes.oby eq 3>
			ORDER BY ACC.BILL_NO
		<cfelseif isDefined('attributes.oby') and attributes.oby eq 4>
			ORDER BY ACC.BILL_NO DESC
		<cfelse>
			ORDER BY ACC.ACTION_DATE DESC
		</cfif>
	</cfquery>
</cfif>

