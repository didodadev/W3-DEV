<cf_xml_page_edit fuseact="account.list_account_card_rows">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.acc_code1_1" default="">
<cfparam name="attributes.acc_code2_1" default="">
<cfparam name="attributes.acc_code1_2" default="">
<cfparam name="attributes.acc_code2_2" default="">
<cfparam name="attributes.acc_code1_3" default="">
<cfparam name="attributes.acc_code2_3" default="">
<cfparam name="attributes.acc_code1_4" default="">
<cfparam name="attributes.acc_code2_4" default="">
<cfparam name="attributes.acc_code1_5" default="">
<cfparam name="attributes.acc_code2_5" default="">
<cfparam name="attributes.is_system_money_2" default="">
<cfparam name="attributes.other_money_based" default="">
<cfparam name="bakiye" default="0">
<cfparam name="attributes.form_is_submitted" default="0">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.acc_card_type" default="">
<cfparam name="attributes.acc_code_type" default="0">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.is_quantity" default="0">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.is_sub_project" default="">
<cfif isdefined("attributes.form_is_submitted") and attributes.form_is_submitted eq 1 and isdefined("attributes.is_excel") and attributes.is_excel eq 1>
    <cfquery name="get_account_id" datasource="#dsn2#">
         SELECT *
         INTO ####GET_ACOOUNT_ID_#session.ep.userid#
         FROM
         (
            SELECT
                <cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
                    IFRS_CODE AS ACCOUNT_CODE,
                    IFRS_NAME AS ACCOUNT_NAME
                <cfelse>
                    ACCOUNT_CODE,
                    ACCOUNT_NAME
                </cfif>
            FROM
                ACCOUNT_PLAN
            WHERE
                (
                    SUB_ACCOUNT <> <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
                )
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
                                        1 = 1
                                        <cfif isDefined("attributes.acc_code1_#kk#") and len(evaluate("attributes.acc_code1_#kk#"))>
                                            <cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
                                                AND IFRS_CODE >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.acc_code1_#kk#")#">
                                            <cfelse>
                                                AND ACCOUNT_CODE >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.acc_code1_#kk#")#">
                                            </cfif>
                                        </cfif>
                                        <cfif isDefined("attributes.acc_code2_#kk#") and len(evaluate("attributes.acc_code2_#kk#"))>
                                            <cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
                                                AND IFRS_CODE <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.acc_code2_#kk#")#">
                                            <cfelse>
                                                AND ACCOUNT_CODE <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.acc_code2_#kk#")#">
                                            </cfif>
                                        </cfif>
                                    )
                                </cfif>
                            )
                        </cfloop>
                    )
                </cfif>
                <cfif isdefined('attributes.is_acc_with_action')><!---secilen tarihler arasında hareketi olmayan hesapların gelmemesi icin --->
                    AND ACCOUNT_CODE IN (	SELECT DISTINCT
                                                ACCOUNT_ID
                                            FROM
                                                ACCOUNT_CARD ACC,
                                                ACCOUNT_CARD_ROWS ACC_R
                                            WHERE
                                                <cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)>
                                                    (
                                                        <cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
                                                            (ACC.CARD_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(type_ii,'-')#"> AND ACC.CARD_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(type_ii,'-')#">)
                                                            <cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
                                                        </cfloop>
                                                    ) AND
                                                </cfif>
                                                <cfif isdefined('attributes.project_head') and len(attributes.project_head) and len(attributes.project_id)>
                                                    <cfif attributes.is_sub_project eq 1>
                                                        ISNULL((SELECT RELATED_PROJECT_ID FROM #dsn_alias#.PRO_PROJECTS WHERE PROJECT_ID = ACC_R.ACC_PROJECT_ID),ACC_R.ACC_PROJECT_ID) = #attributes.project_id#
                                                    <cfelse>
                                                        ACC_R.ACC_PROJECT_ID = #attributes.project_id#
                                                    </cfif>
                                                    AND
                                                </cfif>
                                                <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
                                                    ACC_R.ACC_BRANCH_ID = #attributes.branch_id# AND
                                                </cfif>
                                                <cfif isdefined("attributes.department") and len(attributes.department)>
                                                    ACC_R.ACC_DEPARTMENT_ID = #attributes.department# AND
                                                </cfif>
                                                ACC.CARD_ID = ACC_R.CARD_ID
                                                AND ACC.ACTION_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
                                        )
                </cfif>
        UNION ALL
             SELECT
                    <cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
                        IFRS_CODE AS ACCOUNT_CODE,
                        IFRS_NAME AS ACCOUNT_NAME
                    <cfelse>
                        ACCOUNT_CODE,
                        ACCOUNT_NAME
                    </cfif>
                FROM
                    ACCOUNT_PLAN
                WHERE
                    (
                        (SUB_ACCOUNT = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND (SELECT COUNT(*) FROM ACCOUNT_PLAN AC WHERE AC.ACCOUNT_CODE LIKE ACCOUNT_PLAN.ACCOUNT_CODE+'.%') = 0)
    
                    )
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
                                            1 = 1
                                            <cfif isDefined("attributes.acc_code1_#kk#") and len(evaluate("attributes.acc_code1_#kk#"))>
                                                <cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
                                                    AND IFRS_CODE >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.acc_code1_#kk#")#">
                                                <cfelse>
                                                    AND ACCOUNT_CODE >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.acc_code1_#kk#")#">
                                                </cfif>
                                            </cfif>
                                            <cfif isDefined("attributes.acc_code2_#kk#") and len(evaluate("attributes.acc_code2_#kk#"))>
                                                <cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
                                                    AND IFRS_CODE <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.acc_code2_#kk#")#">
                                                <cfelse>
                                                    AND ACCOUNT_CODE <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.acc_code2_#kk#")#">
                                                </cfif>
                                            </cfif>
                                        )
                                    </cfif>
                                )
                            </cfloop>
                        )
                    </cfif>
                    <cfif isdefined('attributes.is_acc_with_action')><!---secilen tarihler arasında hareketi olmayan hesapların gelmemesi icin --->
                        AND ACCOUNT_CODE IN (	SELECT DISTINCT
                                                    ACCOUNT_ID
                                                FROM
                                                    ACCOUNT_CARD ACC,
                                                    ACCOUNT_CARD_ROWS ACC_R
                                                WHERE
                                                    <cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)>
                                                        (
                                                            <cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
                                                                (ACC.CARD_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(type_ii,'-')#"> AND ACC.CARD_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(type_ii,'-')#">)
                                                                <cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
                                                            </cfloop>
                                                        ) AND
                                                    </cfif>
                                                    <cfif isdefined('attributes.project_head') and len(attributes.project_head) and len(attributes.project_id)>
                                                        <cfif attributes.is_sub_project eq 1>
                                                            ISNULL((SELECT RELATED_PROJECT_ID FROM #dsn_alias#.PRO_PROJECTS WHERE PROJECT_ID = ACC_R.ACC_PROJECT_ID),ACC_R.ACC_PROJECT_ID) = #attributes.project_id#
                                                        <cfelse>
                                                            ACC_R.ACC_PROJECT_ID = #attributes.project_id#
                                                        </cfif>
                                                        AND
                                                    </cfif>
                                                    <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
                                                        ACC_R.ACC_BRANCH_ID = #attributes.branch_id# AND
                                                    </cfif>
                                                    <cfif isdefined("attributes.department") and len(attributes.department)>
                                                        ACC_R.ACC_DEPARTMENT_ID = #attributes.department# AND
                                                    </cfif>
                                                    ACC.CARD_ID = ACC_R.CARD_ID
                                                    AND ACC.ACTION_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
                                            )
                    </cfif>
       ) as  GET_ACCOUT_ID
       <cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
            ORDER BY IFRS_CODE
        <cfelse>
            ORDER BY ACCOUNT_CODE
        </cfif>
    </cfquery>
</cfif>
<cfquery name="get_money" datasource="#dsn2#">
	SELECT MONEY FROM SETUP_MONEY WHERE MONEY_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
</cfquery>
<cfquery name="GET_BRANCHES" datasource="#DSN#">
	SELECT
		BRANCH.BRANCH_STATUS,
		BRANCH.HIERARCHY,
		BRANCH.HIERARCHY2,
		BRANCH.BRANCH_ID,
		BRANCH.BRANCH_NAME,
		OUR_COMPANY.COMP_ID,
		OUR_COMPANY.COMPANY_NAME,
		OUR_COMPANY.NICK_NAME
	FROM
		BRANCH,
		OUR_COMPANY
	WHERE
		BRANCH.BRANCH_ID IS NOT NULL
		AND BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
		AND BRANCH.BRANCH_STATUS = 1
	ORDER BY
		OUR_COMPANY.NICK_NAME,
		BRANCH.BRANCH_NAME
</cfquery>
<cfset money_list=valuelist(get_money.money)>
<cfquery name="get_acc_card_type" datasource="#dsn3#">
    SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (10,11,12,13,14,19) ORDER BY PROCESS_TYPE
</cfquery>
<cfif isdefined('attributes.branch_id') and isnumeric(attributes.branch_id)>
    <cfquery name="GET_DEPARTMANT" datasource="#DSN#">
        SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_STATUS = 1 AND BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> ORDER BY DEPARTMENT_HEAD
    </cfquery>
</cfif>

<cfif attributes.form_is_submitted and not(isdefined("attributes.is_excel") and attributes.is_excel eq 1 )>
	<cfquery name="get_account_id" datasource="#dsn2#">
		SELECT 
   			<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
				IFRS_CODE AS ACCOUNT_CODE,
				IFRS_NAME AS ACCOUNT_NAME
			<cfelse>
				ACCOUNT_CODE, 
				ACCOUNT_NAME
			</cfif>
		FROM 
			ACCOUNT_PLAN 
		WHERE 
			(SUB_ACCOUNT <> <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> OR (SUB_ACCOUNT = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND (SELECT COUNT(*) FROM ACCOUNT_PLAN AC WHERE AC.ACCOUNT_CODE LIKE ACCOUNT_PLAN.ACCOUNT_CODE+'.%') = 0))
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
									1 = 1
									<cfif isDefined("attributes.acc_code1_#kk#") and len(evaluate("attributes.acc_code1_#kk#"))>
										<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
											AND IFRS_CODE >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.acc_code1_#kk#")#">
										<cfelse>
											AND ACCOUNT_CODE >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.acc_code1_#kk#")#">
										</cfif>
									</cfif>
									<cfif isDefined("attributes.acc_code2_#kk#") and len(evaluate("attributes.acc_code2_#kk#"))>
										<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
											AND IFRS_CODE <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.acc_code2_#kk#")#">
										<cfelse>
											AND ACCOUNT_CODE <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.acc_code2_#kk#")#">
										</cfif>
									</cfif>
								)
							</cfif>
						)
					</cfloop>
				)
			</cfif>
            <cfif isdefined('attributes.is_acc_with_action')><!---secilen tarihler arasında hareketi olmayan hesapların gelmemesi icin --->
				AND ACCOUNT_CODE IN (	SELECT DISTINCT
											ACC.ACCOUNT_ID 
										FROM
											ACCOUNT_CARD ACC,
											ACCOUNT_CARD_ROWS ACC_R
										WHERE
											<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)>
												(
													<cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
														(ACC.CARD_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(type_ii,'-')#"> AND ACC.CARD_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(type_ii,'-')#">)
														<cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
													</cfloop>
												) AND
											</cfif>
											<cfif isdefined('attributes.project_head') and len(attributes.project_head) and len(attributes.project_id)>
												<cfif attributes.is_sub_project eq 1>
													ISNULL((SELECT RELATED_PROJECT_ID FROM #dsn_alias#.PRO_PROJECTS WHERE PROJECT_ID = ACC_R.ACC_PROJECT_ID),ACC_R.ACC_PROJECT_ID) = #attributes.project_id#
												<cfelse>	
                                                	<cfif attributes.project_id eq -1>
                                                        ACC_R.ACC_PROJECT_ID IS NULL
                                                    <cfelse>
                                                        ACC_R.ACC_PROJECT_ID = #attributes.project_id#
                                                    </cfif> 
												</cfif>
												AND
											</cfif>	
											<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
												ACC_R.ACC_BRANCH_ID = #attributes.branch_id# AND
											</cfif>
											<cfif isdefined("attributes.department") and len(attributes.department)>
												ACC_R.ACC_DEPARTMENT_ID = #attributes.department# AND
											</cfif>	
											ACC.CARD_ID = ACC_R.CARD_ID
											AND ACC.ACTION_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
									)
			</cfif>
			<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
				ORDER BY IFRS_CODE
			<cfelse>
				ORDER BY ACCOUNT_CODE
			</cfif>
	</cfquery>
    
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'account.list_account_card_rows';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'account/display/list_account_card_rows.cfm';
</cfscript>
