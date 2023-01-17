<cfif isdefined("session.agenda_userid")>
	<!--- başkasında --->
	<cfif isdefined("session.agenda_userid") and session.agenda_user_type is "p">
		<!--- par --->
		<cfquery name="GET_GRPS" datasource="#DSN#">
			SELECT GROUP_ID FROM USERS WHERE PARTNERS LIKE '%,#session.agenda_userid#,%'
		</cfquery>
		<cfquery name="get_wrkgroups" datasource="#DSN#">
			SELECT WORKGROUP_ID FROM WORKGROUP_EMP_PAR WHERE PARTNER_ID = #session.agenda_userid#	
        </cfquery>
        <cfquery name="GET_BRANCH" datasource="#DSN#">
            SELECT D.BRANCH_ID,D.DEPARTMENT_ID FROM DEPARTMENT D, EMPLOYEE_POSITIONS EP WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND  EP.DEPARTMENT_ID = D.DEPARTMENT_ID 
        </cfquery>
	<cfelseif isdefined("session.agenda_userid") and session.agenda_user_type is "e">
		<!--- emp --->
		<cfquery name="GET_GRPS" datasource="#DSN#">
			SELECT GROUP_ID FROM USERS WHERE POSITIONS LIKE '%,#session.agenda_position_code#,%'
		</cfquery>
		<cfquery name="get_wrkgroups" datasource="#DSN#">
			SELECT WORKGROUP_ID FROM WORKGROUP_EMP_PAR WHERE POSITION_CODE = #session.agenda_position_code#		  
        </cfquery>
        <cfquery name="GET_BRANCH" datasource="#DSN#">
            SELECT D.BRANCH_ID,D.DEPARTMENT_ID FROM DEPARTMENT D, EMPLOYEE_POSITIONS EP WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.agenda_position_code#"> AND  EP.DEPARTMENT_ID = D.DEPARTMENT_ID 
        </cfquery>
	</cfif>
<cfelse>
	<!--- kendinde --->
	<cfquery name="GET_GRPS" datasource="#DSN#">
        SELECT GROUP_ID FROM USERS WHERE POSITIONS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.position_code#,%">
    </cfquery>
    <cfquery name="GET_WRKGROUPS" datasource="#DSN#">
        SELECT WORKGROUP_ID FROM WORKGROUP_EMP_PAR WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">	
    </cfquery>
    <cfquery name="GET_BRANCH" datasource="#DSN#">
        SELECT D.BRANCH_ID,D.DEPARTMENT_ID FROM DEPARTMENT D, EMPLOYEE_POSITIONS EP WHERE EP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND  EP.DEPARTMENT_ID = D.DEPARTMENT_ID 
    </cfquery>
</cfif>
<cfset grps = valuelist(get_grps.group_id)>
<cfset wrkgroups = valuelist(get_wrkgroups.workgroup_id)>
<cfquery name="GET_BRANCH" datasource="#DSN#">
    SELECT D.BRANCH_ID,D.DEPARTMENT_ID FROM DEPARTMENT D, EMPLOYEE_POSITIONS EP WHERE EP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND  EP.DEPARTMENT_ID = D.DEPARTMENT_ID 
</cfquery>
<cfquery name="GET_AGENDA_COMPANY" datasource="#DSN#">
    SELECT 
        SETUP_PERIOD.OUR_COMPANY_ID
    FROM
        EMPLOYEE_POSITION_PERIODS,
        EMPLOYEE_POSITIONS,
        SETUP_PERIOD
    WHERE
        EMPLOYEE_POSITIONS.POSITION_ID = EMPLOYEE_POSITION_PERIODS.POSITION_ID
        AND EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
        AND SETUP_PERIOD.PERIOD_ID = EMPLOYEE_POSITION_PERIODS.PERIOD_ID
</cfquery>
<cfset my_comp_list = ValueList(get_agenda_company.our_company_id)>
<cfquery name="getQueryAgenda" datasource="#dsn#">
    SELECT
        E.EVENT_HEAD,
        E.STARTDATE,
        E.FINISHDATE,
        E.EVENT_ID,
        EC.COLOUR
    FROM 
        EVENT AS E
        LEFT JOIN EVENT_CAT AS EC ON E.EVENTCAT_ID = EC.EVENTCAT_ID
	WHERE
		(
            <cfif isDefined("session.agenda_userid")>
                <!--- baskasinda --->
                <cfif isdefined("session.agenda_user_type") and session.agenda_user_type is "P">
                    <!--- PAR --->
                    ((E.RECORD_PAR = #session.agenda_userid# OR EVENT.UPDATE_PAR = #session.agenda_userid#) AND EC.EVENTCAT_ID <> 1) OR
                    E.EVENT_TO_PAR LIKE '%,#session.agenda_userid#,%' OR EVENT.EVENT_CC_PAR LIKE '%,#session.agenda_userid#,%'
                    <cfloop list="#grps#" index="grp_i">
                        OR E.EVENT_TO_GRP LIKE '%,#grp_i#,%'
                        OR E.EVENT_CC_GRP LIKE '%,#grp_i#,%'
                    </cfloop>
                    <cfloop list="#wrkgroups#" index="wrk">
                        OR E.EVENT_TO_WRKGROUP LIKE '%,#wrk#,%'
                        OR E.EVENT_CC_WRKGROUP LIKE '%,#wrk#,%'
                    </cfloop>
                <cfelseif isdefined("session.agenda_user_type") and session.agenda_user_type is "E">
                    <!--- EMP --->
                    ((E.RECORD_EMP = #session.agenda_userid# OR E.UPDATE_EMP = #session.agenda_userid#) AND EC.EVENTCAT_ID <> 1) OR
                    E.EVENT_TO_POS LIKE '%,#session.agenda_userid#,%' OR
                    E.EVENT_CC_POS LIKE '%,#session.agenda_userid#,%' OR
                    E.VALID_EMP = #session.agenda_userid#
                    <cfloop list="#grps#" index="grp_i">
                        OR E.EVENT_TO_GRP LIKE '%,#grp_i#,%'
                        OR E.EVENT_CC_GRP LIKE '%,#grp_i#,%'
                    </cfloop>
                    <cfloop list="#wrkgroups#" index="wrk">
                        OR E.EVENT_TO_WRKGROUP LIKE '%,#wrk#,%'
                        OR E.EVENT_CC_WRKGROUP LIKE '%,#wrk#,%'
                    </cfloop>
                </cfif>
            <cfelse>
                (
                    E.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> OR
                    E.UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> OR
                    E.VALID_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> OR
                    E.EVENT_TO_POS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.userid#,%"> OR
                    E.EVENT_CC_POS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.userid#,%">
                )
                <cfloop list="#GRPS#" index="GRP_I">
                    OR E.EVENT_TO_GRP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#GRP_I#,%">
                </cfloop>
                <cfloop list="#GRPS#" index="GRP_I">
                    OR E.EVENT_CC_GRP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#GRP_I#,%">
                </cfloop>
            </cfif>
            <cfloop list="#wrkgroups#" index="WRK">
                OR E.EVENT_TO_WRKGROUP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#WRK#,%">
            </cfloop>
            <cfloop list="#wrkgroups#" index="WRK">
                OR E.EVENT_CC_WRKGROUP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#WRK#,%">
            </cfloop>
         <!---  <cfif isdefined('attributes.view_agenda')> --->
                OR E.EVENT_TO_BRANCH LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_branch.branch_id#,%"> 
                OR E.EVENT_TO_BRANCH LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_branch.branch_id#,%">
                OR E.EVENT_TO_BRANCH LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_branch.branch_id#">
                OR E.EVENT_TO_BRANCH = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_branch.branch_id#">
                OR
                (
                    ( 
                        E.VIEW_TO_ALL = 1 
                        AND E.IS_WIEW_BRANCH = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_branch.branch_id#"> 
                        AND E.IS_WIEW_DEPARTMENT = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_branch.department_id#"> 
                        AND 
                            (E.IS_VIEW_COMPANY = 1
                            <cfif isdefined("xml_multiple_comp") and xml_multiple_comp eq 1>
                                AND E.EVENT_ID IN (SELECT EVENT_ID FROM EVENT_COMPANY WHERE COMPANY_ID IN (#my_comp_list#)) 
                            </cfif>
                            )
                    ) OR	
                    ( E.VIEW_TO_ALL = 1 AND E.IS_WIEW_BRANCH = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_branch.branch_id#"> AND E.IS_WIEW_DEPARTMENT IS NULL AND E.IS_VIEW_COMPANY IS NULL) OR 
                    ( E.VIEW_TO_ALL = 1 AND E.IS_WIEW_BRANCH  IS NULL AND E.IS_WIEW_DEPARTMENT IS NULL 
                    AND (E.IS_VIEW_COMPANY = 1
                            <cfif isdefined("xml_multiple_comp") and xml_multiple_comp eq 1>
                                AND E.EVENT_ID IN (SELECT EVENT_ID FROM EVENT_COMPANY WHERE COMPANY_ID IN (#my_comp_list#)) 
                            </cfif>                        
                            )
                    ) OR 
                    ( E.VIEW_TO_ALL = 1 AND E.IS_WIEW_BRANCH IS NULL AND E.IS_WIEW_DEPARTMENT IS NULL AND E.IS_VIEW_COMPANY IS NULL) OR
                    ( E.IS_VIEW_COMPANY = 1
                            <cfif isdefined("xml_multiple_comp") and xml_multiple_comp eq 1>
                                AND E.EVENT_ID IN (SELECT EVENT_ID FROM EVENT_COMPANY WHERE COMPANY_ID IN (#my_comp_list#)) 
                            </cfif> 
                    ) OR
                    ( E.IS_WIEW_BRANCH = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_branch.branch_id#">) OR
                    ( E.IS_WIEW_DEPARTMENT = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_branch.department_id#">)
                )
        <!---   </cfif>--->
        )
        <cfif isdefined('attributes.view_agenda') and attributes.view_agenda eq 1><!--- departman gorsun --->
            AND ( E.IS_WIEW_DEPARTMENT IS NOT NULL AND E.IS_WIEW_DEPARTMENT = #get_all_agenda_department_branch.department_id# )
            OR E.IS_WIEW_DEPARTMENT = #get_all_agenda_department_branch.department_id#
        </cfif>
        <cfif isdefined('attributes.view_agenda') and attributes.view_agenda eq 2><!--- şube görsün --->
            AND ( E.IS_WIEW_BRANCH IS NOT NULL AND E.IS_WIEW_BRANCH = #get_all_agenda_department_branch.branch_id#)
        </cfif>
        <cfif isdefined('attributes.view_agenda') and attributes.view_agenda eq 3><!--- herkes gorsun --->
         <!---     AND E.IS_VIEW_COMPANY = 1
                <cfif isdefined("xml_multiple_comp") and xml_multiple_comp eq 1>
                    AND E.EVENT_ID IN (SELECT EVENT_ID FROM EVENT_COMPANY WHERE COMPANY_ID IN (#my_comp_list#)) 
                </cfif>
            OR E.VIEW_TO_ALL = 1--->
            AND (E.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> OR
            E.UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> OR
            E.VALID_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> OR
            E.EVENT_TO_POS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.userid#,%"> OR
            E.EVENT_CC_POS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.userid#,%">)   
        </cfif> 
        AND E.STARTDATE BETWEEN #dateadd('yyyy',-2,now())# AND #dateadd('yyyy',1,now())#
    ORDER BY
        E.STARTDATE ASC
</cfquery>
<cfif isdefined("attributes.action_id") and len(attributes.action_id)>
    <cfquery name="GET_RELATED_EVENTS" datasource="#DSN#">
        SELECT
            ER.EVENT_ID,
            ER.RELATED_ID,
            E.EVENT_HEAD,
            E.STARTDATE,
            E.FINISHDATE,
            ISNULL(ER.EVENT_TYPE,1) TYPE,
            '' EVENT_ROW_ID,
            EC.EVENTCAT,
            EC.COLOUR
        FROM
            EVENTS_RELATED ER,
            EVENT E,
            EVENT_CAT EC
        WHERE
            E.EVENT_ID = ER.EVENT_ID AND	
            E.EVENTCAT_ID = EC.EVENTCAT_ID AND		
            ER.ACTION_SECTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(attributes.action_section)#"> AND
            ER.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND
            ISNULL(ER.EVENT_TYPE,1) = 1
        UNION ALL	
        SELECT
            ER.EVENT_ID,
            ER.RELATED_ID,
            E.EVENT_PLAN_HEAD EVENT_HEAD,
            EVENT_PLAN_ROW.START_DATE STARTDATE,
            EVENT_PLAN_ROW.FINISH_DATE FINISHDATE,
            ISNULL(ER.EVENT_TYPE,1) TYPE,
            ER.EVENT_ROW_ID,
            '' EVENTCAT,
            '##89d3d9' COLOUR
        FROM
            EVENTS_RELATED ER,
            EVENT_PLAN E,
            EVENT_PLAN_ROW
        WHERE
            E.EVENT_PLAN_ID = EVENT_PLAN_ROW.EVENT_PLAN_ID AND
            E.EVENT_PLAN_ID = ER.EVENT_ID AND	
            ER.ACTION_SECTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(attributes.action_section)#"> AND
            ER.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND
            ISNULL(ER.EVENT_TYPE,1) = 2

        ORDER BY 
            E.STARTDATE DESC
    </cfquery>
</cfif>
<cfquery name="GET_ASSET_CARES_ALL" datasource="#DSN#">
	SELECT 
		SERVICE_CARE.PRODUCT_CARE_ID, 
		SERVICE_CARE.COMPANY_AUTHORIZED_TYPE,
		SERVICE_CARE.COMPANY_AUTHORIZED, 
		SERVICE_CARE.START_DATE,
		SERVICE_CARE.FINISH_DATE,
		SERVICE_CARE.SERIAL_NO,
		SERVICE_CARE.PRODUCT_ID, 
		SERVICE_CARE.SERVICE_EMPLOYEE, 
		SERVICE_CARE.SERVICE_EMPLOYEE2,
		CARE_STATES.PERIOD_ID, 
		CARE_STATES.CARE_STATE_ID ,
		(SELECT PRODUCT_NAME FROM #dsn1_alias#.PRODUCT WHERE PRODUCT_ID = SERVICE_CARE.PRODUCT_ID) PRODUCT_NAME,
		SERVICE_CARE_CAT.*
	FROM 
		#dsn3_alias#.SERVICE_CARE AS SERVICE_CARE, 
		CARE_STATES AS CARE_STATES,
		#dsn3_alias#.SERVICE_CARE_CAT AS SERVICE_CARE_CAT
	WHERE 
		SERVICE_CARE.STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> AND 
		SERVICE_CARE.PRODUCT_CARE_ID=CARE_STATES.SERVICE_ID AND
		SERVICE_CARE_CAT.SERVICE_CARECAT_ID=CARE_STATES.CARE_STATE_ID 
        <cfif service_type eq 0>AND (SERVICE_EMPLOYEE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> OR SERVICE_EMPLOYEE2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">)</cfif>
	ORDER BY 
		SERVICE_CARE.PRODUCT_CARE_ID
</cfquery>
<cfquery name="GET_SERVICE_REQUEST" datasource="#dsn3#">
SELECT 
    S.SERVICE_HEAD,
    S.SERVICE_ID,
    S.START_DATE,
    S.FINISH_DATE
FROM
   SERVICE S
WHERE 
  s.SERVICE_ACTIVE=1
  AND S.START_DATE IS NOT NULL
  AND S.FINISH_DATE IS NOT NULL
</cfquery>
<cfset login_act = createObject("component", "V16.assetcare.cfc.assetp_period")>
<cfset login_act.dsn = dsn />
<cfset GET_WORK_ASSET_CARE = login_act.GET_ASSETP_PERIOD_FNC(keyword : '#iif(isdefined("attributes.keyword") and len(attributes.keyword),"attributes.keyword",DE(""))#',official_emp_id : '#iif(service_type eq 0,session.ep.userid,DE(""))#', official_emp : '#iif(service_type eq 0,DE("EMP"),DE(""))#')>

<cfquery name="get_training_calendar" datasource="#DSN#">
	SELECT
		TRAINING_CLASS.CLASS_ID,
		TRAINING_CLASS.CLASS_NAME,
		TRAINING_CLASS.START_DATE,
		TRAINING_CLASS.CLASS_ID,
		TRAINING_CLASS.FINISH_DATE
	FROM
		TRAINING_CLASS
        <cfif isDefined("attributes.train_group_id") and len(attributes.train_group_id) and attributes.train_group_id neq 0>
            ,TRAINING_CLASS_GROUP_CLASSES TCGC
        </cfif>
	WHERE
		TRAINING_CLASS.CLASS_ID IS NOT NULL AND
		(
			TRAINING_CLASS.CLASS_ID IN(SELECT TRAINING_CLASS.CLASS_ID FROM TRAINING_GROUP_ATTENDERS WHERE EMP_ID = #session.ep.userid#) OR
			TRAINING_CLASS.CLASS_ID IN(SELECT TRAINING_CLASS.CLASS_ID FROM TRAINING_CLASS_TRAINERS WHERE EMP_ID = #session.ep.userid#) OR
			TRAINING_CLASS.VIEW_TO_ALL = 1
		)
        <cfif isDefined("attributes.train_id") and len(attributes.train_id) and attributes.train_id neq 0>
            AND TRAINING_CLASS.TRAINING_ID = #attributes.train_id#
        </cfif>
        <cfif isDefined("attributes.train_group_id") and len(attributes.train_group_id) and attributes.train_group_id neq 0>
            AND TRAINING_CLASS.CLASS_ID = TCGC.CLASS_ID
        </cfif>
</cfquery>