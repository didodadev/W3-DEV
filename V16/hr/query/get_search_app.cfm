<cfquery name="GET_APPS" datasource="#dsn#">
	SELECT
		EMPLOYEES_APP.EMPAPP_ID,
		EMPLOYEES_APP_POS.APP_POS_ID,
		EMPLOYEES_APP_POS.POSITION_ID,
		EMPLOYEES_APP_POS.POSITION_CAT_ID,
		EMPLOYEES_APP_POS.APP_DATE,
		EMPLOYEES_APP.NAME,
		EMPLOYEES_APP.SURNAME,
		EMPLOYEES_APP.STEP_NO,
		EMPLOYEES_APP_POS.NOTICE_ID,
		EMPLOYEES_APP.COMMETHOD_ID,
		EMPLOYEES_APP_POS.APP_POS_STATUS,
		EMPLOYEES_APP.RECORD_DATE,
		EMPLOYEES_IDENTY.BIRTH_DATE
	FROM
		EMPLOYEES_APP,
		EMPLOYEES_IDENTY,
		EMPLOYEES_APP_POS
	WHERE
		EMPLOYEES_APP.EMPAPP_ID IS NOT NULL
		AND EMPLOYEES_APP.EMPAPP_ID=EMPLOYEES_APP_POS.EMPAPP_ID
		AND EMPLOYEES_IDENTY.EMPAPP_ID IS NOT NULL
		AND EMPLOYEES_APP.EMPAPP_ID = EMPLOYEES_IDENTY.EMPAPP_ID
		AND EMPLOYEES_APP_POS.APP_DATE >= #attributes.start_date#  
		AND EMPLOYEES_APP_POS.APP_DATE <= #DATEADD('d',1,attributes.finish_date)#
			<cfif isdefined("attributes.keyword") AND len(attributes.keyword)>
			 AND
			   (EMPLOYEES_APP.NAME LIKE '%#attributes.keyword#%' OR
				EMPLOYEES_APP.SURNAME LIKE '%#attributes.keyword#%')
			</cfif>
			<cfif isdefined("attributes.commethod_id") AND (attributes.commethod_id neq 0)>
				AND EMPLOYEES_APP_POS.COMMETHOD_ID = #attributes.commethod_id#
			</cfif>
			<cfif len(attributes.status) eq 1>
				AND EMPLOYEES_APP_POS.APP_POS_STATUS = #attributes.status#
		 	</cfif>
			<cfif IsDefined("attributes.company_id") and len(attributes.company_id) and len(attributes.company)>
				AND EMPLOYEES_APP_POS.COMPANY_ID=#attributes.company_id#
			</cfif>
			<cfif IsDefined("attributes.process_stage") and len(attributes.process_stage)>
				AND EMPLOYEES_APP_POS.APP_STAGE=#ATTRIBUTES.PROCESS_STAGE#
			</cfif>
			<cfif IsDefined("attributes.department") and len(attributes.department) and IsDefined('attributes.department_id') and len(attributes.department_id)>
				AND EMPLOYEES_APP_POS.DEPARTMENT_ID=#attributes.department_id#
			</cfif>
			<cfif IsDefined("attributes.branch") and len(attributes.branch) and IsDefined('attributes.branch_id') and len(attributes.branch_id)>
				AND EMPLOYEES_APP_POS.BRANCH_ID=#attributes.branch_id#
				<cfif IsDefined('attributes.our_company_id') and len(attributes.our_company_id)>
					AND EMPLOYEES_APP_POS.OUR_COMPANY_ID=#attributes.our_company_id#
				</cfif>	
			</cfif>
			<cfif isdefined("attributes.notice_id") and len(attributes.notice_id) and len(attributes.notice_head)>
		  		AND EMPLOYEES_APP_POS.NOTICE_ID = #attributes.notice_id#
			</cfif>
			<cfif isdefined("attributes.in_status") and len(attributes.in_status)>
		  		AND EMPLOYEES_APP_POS.IS_INTERNAL = #attributes.in_status#
			</cfif>
			<cfif isdefined('attributes.notice_cat_id') and  len(attributes.notice_cat_id)>
				AND EMPLOYEES_APP_POS.NOTICE_ID IN (SELECT NOTICE_ID FROM NOTICES WHERE NOTICE_CAT_ID IN(#attributes.notice_cat_id#))
			</cfif>
		 <cfif attributes.date_status eq 1>ORDER BY EMPLOYEES_APP_POS.APP_DATE DESC
			<cfelseif attributes.date_status eq 2>ORDER BY EMPLOYEES_APP_POS.APP_DATE ASC
			<cfelseif attributes.date_status eq 3>ORDER BY EMPLOYEES_APP.RECORD_DATE DESC
			<cfelseif attributes.date_status eq 4>ORDER BY EMPLOYEES_APP.RECORD_DATE ASC
			<cfelseif attributes.date_status eq 5>ORDER BY NAME DESC
			<cfelseif attributes.date_status eq 6>ORDER BY NAME ASC
		</cfif>
</cfquery>

