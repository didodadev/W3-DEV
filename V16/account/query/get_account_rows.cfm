<cfquery name="GET_ACCOUNT_ROWS" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
	SELECT
		ACR.*,
		AC.ACTION_DATE AS ACTION_DATE,
		AC.ACTION_DATE,		
		AC.CARD_DETAIL,
		AC.BILL_NO,
		AP.ACCOUNT_NAME,
		AP.IFRS_NAME,
		PP.PROJECT_HEAD,
        PP.PROJECT_ID,
		B.BRANCH_NAME,
        B.BRANCH_ID,
        D.DEPARTMENT_HEAD,
		B2.BRANCH_NAME BRANCH_NAME2
	FROM
		ACCOUNT_CARD_ROWS ACR
        	LEFT JOIN #dsn_alias#.PRO_PROJECTS PP ON PP.PROJECT_ID = ACR.ACC_PROJECT_ID
            LEFT JOIN #dsn_alias#.BRANCH B ON B.BRANCH_ID = ACR.ACC_BRANCH_ID
            LEFT JOIN #dsn_alias#.DEPARTMENT D ON D.DEPARTMENT_ID = ACR.ACC_DEPARTMENT_ID
            LEFT JOIN #dsn_alias#.BRANCH B2 ON B2.BRANCH_ID = D.BRANCH_ID,
		ACCOUNT_CARD AC,
		ACCOUNT_PLAN AP
	WHERE
		ACR.CARD_ID=AC.CARD_ID
		AND AP.ACCOUNT_CODE=ACR.ACCOUNT_ID
		<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1><!--- IFRS CODE göre arama yapılıyor --->
			AND AP.IFRS_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CODE#">
		<cfelse>
			AND ACR.ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CODE#">
		</cfif>
		<cfif isdefined('attributes.acc_branch_id') and len(attributes.acc_branch_id)>
			AND ACR.ACC_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.acc_branch_id#">
		</cfif>
		<cfif isdate(attributes.finishdate)>
			AND AC.ACTION_DATE <= #attributes.finishdate#
		</cfif>
		<cfif isdate(attributes.startdate)>
			AND AC.ACTION_DATE >= #attributes.startdate#
		</cfif>
		<cfif len(attributes.keyword)>
			AND 
				(AC.CARD_DETAIL LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%' OR
				ACR.ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">)
		</cfif>
		<cfif isdefined('attributes.project_head') and len(attributes.project_head) and len(attributes.project_id)>
			<cfif attributes.is_sub_project eq 1>
				AND ISNULL((SELECT RELATED_PROJECT_ID FROM #dsn_alias#.PRO_PROJECTS WHERE PROJECT_ID = ACR.ACC_PROJECT_ID),ACR.ACC_PROJECT_ID) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
			<cfelse>
            	<cfif attributes.project_id eq -1>
                    AND ACR.ACC_PROJECT_ID IS NULL
                <cfelse>
                    AND ACR.ACC_PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                </cfif>	
			</cfif>
		</cfif>
	ORDER BY
		AC.ACTION_DATE,
		AC.BILL_NO
</cfquery>
<cfif isdate(attributes.startdate)>
	<cfquery name="GET_ACCOUNT_CARD_ROWS_DEVREDEN" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
		SELECT
			SUM(ACR.AMOUNT) AMOUNT,
			SUM(ACR.AMOUNT_2) AMOUNT_2,
			ACR.BA
			<cfif isdefined("attributes.is_other_money")>
				,SUM(OTHER_AMOUNT) OTHER_AMOUNT
				,OTHER_CURRENCY
			</cfif>
		FROM
			ACCOUNT_CARD_ROWS ACR,
			ACCOUNT_CARD AC,
			ACCOUNT_PLAN AP
		WHERE
			ACR.CARD_ID=AC.CARD_ID
			AND AP.ACCOUNT_CODE=ACR.ACCOUNT_ID 
			<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
				AND AP.IFRS_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CODE#">
			<cfelse>
				AND ACR.ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CODE#">
			</cfif>
			AND AC.ACTION_DATE < #attributes.startdate#
			<cfif len(attributes.keyword)>
				AND AC.CARD_DETAIL LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%'
			</cfif>
            <cfif isdefined('attributes.project_head') and len(attributes.project_head) and len(attributes.project_id)>
				<cfif attributes.is_sub_project eq 1>
                    AND ISNULL((SELECT RELATED_PROJECT_ID FROM #dsn_alias#.PRO_PROJECTS WHERE PROJECT_ID = ACR.ACC_PROJECT_ID),ACR.ACC_PROJECT_ID) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                <cfelse>
					<cfif attributes.project_id eq -1>
                        AND ACR.ACC_PROJECT_ID IS NULL
                    <cfelse>
                        AND ACR.ACC_PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                	</cfif>	
                </cfif>
            </cfif>
		GROUP BY
			ACR.BA
			<cfif isdefined("attributes.is_other_money")>
				,OTHER_CURRENCY
			</cfif>
	</cfquery>
</cfif>
