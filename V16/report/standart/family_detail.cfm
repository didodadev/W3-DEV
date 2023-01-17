<cfsetting showdebugoutput="no">
<cfscript>
	bu_ay_basi = CreateDate(year(now()),month(now()),1);
	bu_ay_sonu = DaysInMonth(bu_ay_basi);
</cfscript>
<cfparam name="attributes.module_id_control" default="3,48">
<cfparam name="attributes.related_year" default="">
<cfparam name="attributes.comp_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.related_mon" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.inout_statue" default="2">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfparam name="attributes.validdate" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.finish_date_last" default="">
<cfif len(attributes.startdate) and isdate(attributes.startdate) >
	<cf_date tarih="attributes.startdate">
<cfelse>
	<cfset attributes.startdate = "">
</cfif>
<cfif len(attributes.finishdate) and isdate(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
<cfelse>
	<cfset attributes.finishdate="">
</cfif>
<cfif len(attributes.validdate) and isdate(attributes.validdate) >
	<cf_date tarih="attributes.validdate">
</cfif>
<cfif len(attributes.finish_date) and isdate(attributes.finish_date) >
	<cf_date tarih="attributes.finish_date">
</cfif>
<cfif len(attributes.finish_date_last) and isdate(attributes.finish_date_last) >
	<cf_date tarih="attributes.finish_date_last">
</cfif>
<cfscript>
	month_list ="";
	if (len(attributes.related_mon))
	{
		for(i=1; i lte attributes.related_mon; i=i+1)
			month_list = listappend(month_list,i);
	}
</cfscript>
<cfinclude template="report_authority_control.cfm">
<cfquery name="get_emp_branch" datasource="#DSN#">
	SELECT
		*
	FROM
		EMPLOYEE_POSITION_BRANCHES
	WHERE
		POSITION_CODE = #session.ep.position_code#
</cfquery>
<cfset emp_branch_list=ListDeleteDuplicates(valuelist(get_emp_branch.branch_id),',')>
<cfquery name="get_our_company" datasource="#dsn#">
	SELECT 
		COMP_ID,
		COMPANY_NAME 
	FROM 
		OUR_COMPANY 
	<cfif not session.ep.ehesap>
	WHERE
		COMP_ID IN(SELECT DISTINCT B.COMPANY_ID FROM BRANCH B WHERE B.BRANCH_ID IN(#emp_branch_list#))
	</cfif>
	ORDER BY 
		COMPANY_NAME
</cfquery>
<cfquery name="get_branch" datasource="#dsn#">
 SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH 
    WHERE
        <cfif isdefined('attributes.comp_id') and len(attributes.comp_id)>
            COMPANY_ID IN(#attributes.comp_id#) 
            <cfif not session.ep.ehesap>
                AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
            </cfif>
        <cfelse>
            1=0
        </cfif>
    ORDER BY BRANCH_NAME
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined('attributes.form_submit')>
	<cfquery name="get_employees" datasource="#dsn#">
        WITH CTE1 AS (
        <cfif not(isdefined('attributes.relative_level') and attributes.relative_level eq 0)>
            SELECT 
                1 AS TYPE,
                E.EMPLOYEE_ID,
                E.EMPLOYEE_NO,
                E.EMPLOYEE_NAME EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME EMPLOYEE_SURNAME,
                B.BRANCH_NAME,
                B.RELATED_COMPANY,
                (SELECT NICK_NAME FROM OUR_COMPANY WHERE COMP_ID = B.COMPANY_ID) AS NICK_NAME,
                EII.TC_IDENTY_NO AS KISI_TC_NO,
                EII.MARRIED,
                ER.IS_MARRIED,
                EII.BIRTH_DATE AS KISI_DOGUM,
                ED.SEX,
                CASE 
                    WHEN EP.EMPLOYEE_ID IS NOT NULL 
                THEN
                    EP.POSITION_NAME
                ELSE
                    EPCH.POSITION_NAME
                END AS POSITION_NAME,
                CASE 
                    WHEN EP.EMPLOYEE_ID IS NOT NULL 
                THEN
                    (SELECT TITLE FROM SETUP_TITLE WHERE TITLE_ID = EP.TITLE_ID)
                ELSE
                    (SELECT TITLE FROM SETUP_TITLE WHERE TITLE_ID = EPCH.TITLE_ID)
                END AS TITLE,
                ER.NAME,
                ER.SURNAME,
                ER.RELATIVE_LEVEL,
                ER.TC_IDENTY_NO,
                ER.BIRTH_DATE,
                ER.BIRTH_PLACE,
                ER.RECORD_DATE,
                ER.DISCOUNT_STATUS,
                ER.EDUCATION_STATUS,
                ER.WORK_STATUS,
                ER.MARRIAGE_DATE,
                ER.VALIDITY_DATE
            FROM 
                EMPLOYEES_IN_OUT EI 
                INNER JOIN EMPLOYEES E ON EI.EMPLOYEE_ID = E.EMPLOYEE_ID 
                LEFT JOIN BRANCH B ON EI.BRANCH_ID = B.BRANCH_ID
                LEFT JOIN EMPLOYEES_RELATIVES ER ON EI.EMPLOYEE_ID = ER.EMPLOYEE_ID <cfif len(attributes.validdate)>AND ER.RELATIVE_ID = (SELECT TOP 1 RELATIVE_ID FROM EMPLOYEES_RELATIVES WHERE TC_IDENTY_NO = ER.TC_IDENTY_NO AND VALIDITY_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.validdate#"> ORDER BY VALIDITY_DATE DESC)</cfif>
                LEFT JOIN EMPLOYEES_IDENTY EII ON EII.EMPLOYEE_ID = E.EMPLOYEE_ID
                LEFT JOIN EMPLOYEES_DETAIL ED ON ED.EMPLOYEE_ID = E.EMPLOYEE_ID
                LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID
                LEFT JOIN EMPLOYEE_POSITIONS_CHANGE_HISTORY EPCH ON EPCH.EMPLOYEE_ID = E.EMPLOYEE_ID AND EPCH.ID = (
                    SELECT MAX(ID) FROM EMPLOYEE_POSITIONS_CHANGE_HISTORY WHERE EMPLOYEE_ID = E.EMPLOYEE_ID
                    <cfif isdefined('attributes.startdate') and isdate(attributes.startdate) and isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
                        AND ((START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">)
                            OR (START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND FINISH_DATE IS NULL)
                            OR (START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">)
                            OR (FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">))
                    </cfif>)
            WHERE
                (EP.IS_MASTER = 1 OR EP.EMPLOYEE_ID IS NULL)
                <cfif len(attributes.comp_id)>
                     AND B.COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#" list = "yes">)
                </cfif>
                <cfif len(attributes.branch_id)>
                    AND B.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#" list = "yes">)
                </cfif>
                <cfif not session.ep.ehesap>
                    AND B.BRANCH_ID IN (#emp_branch_list#) 
                </cfif>
                <cfif len(month_list)>
                    AND MONTH(ER.RECORD_DATE) IN (#month_list#) 
                </cfif>
                <cfif len(attributes.validdate)>
                    AND ER.VALIDITY_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.validdate#">
                </cfif>
                <cfif isdefined('attributes.relative_level') and len(attributes.relative_level) and attributes.relative_level neq 0>
                    AND ER.RELATIVE_LEVEL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.relative_level#">
              	<cfelseif not (isdefined('attributes.relative_level') and len(attributes.relative_level))  and (not len(attributes.finish_date)) and (not len(attributes.finish_date_last))>
              		AND (ER.RELATIVE_LEVEL = '3' OR ER.RELATIVE_LEVEL = '4' OR ER.RELATIVE_LEVEL = '5' OR ER.RELATIVE_LEVEL = '1' OR ER.RELATIVE_LEVEL = '2')
                </cfif>
                <cfif isdefined('attributes.employee_id') and isdefined('attributes.employee') and len(attributes.employee_id) and len(attributes.employee)>
                	AND E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
                </cfif>
                <cfif isdefined('attributes.is_student') and attributes.is_student eq 1>
                    AND ER.EDUCATION_STATUS = 1
               	<cfelseif isdefined('attributes.is_student') and attributes.is_student eq 0>
               		AND ER.EDUCATION_STATUS <> 1
                </cfif>
                <cfif isdefined('attributes.is_agi') and attributes.is_agi eq 1>
                    AND ER.DISCOUNT_STATUS = 1
              	<cfelseif isdefined('attributes.is_agi') and attributes.is_agi eq 0>
              		AND ER.DISCOUNT_STATUS <> 1
                </cfif>
                <cfif isdefined('attributes.is_work') and attributes.is_work eq 1>
                    AND ER.WORK_STATUS = 1
                <cfelseif isdefined('attributes.is_work') and attributes.is_work eq 0>
                	AND ER.WORK_STATUS <> 1
                </cfif>
                <cfif len(attributes.finish_date) and isdate(attributes.finish_date)>
                	AND (ER.RELATIVE_LEVEL = '4' OR ER.RELATIVE_LEVEL = '5')
                	AND ((ER.WORK_STATUS <> 1 AND ER.DISCOUNT_STATUS = 1 AND ER.EDUCATION_STATUS = 1 AND DATEDIFF(YEAR,ER.BIRTH_DATE,#attributes.finish_date#) < 26)
                	OR (ER.WORK_STATUS <> 1 AND ER.DISCOUNT_STATUS = 1 AND DATEDIFF(YEAR,ER.BIRTH_DATE,#attributes.finish_date#) < 19))
                </cfif>
                <cfif len(attributes.finish_date_last) and isdate(attributes.finish_date_last)>
                	AND (ER.RELATIVE_LEVEL = '4' OR ER.RELATIVE_LEVEL = '5')
                	AND ((ER.WORK_STATUS <> 1 AND ER.DISCOUNT_STATUS = 1 AND ER.EDUCATION_STATUS = 1 AND DATEDIFF(YEAR,ER.BIRTH_DATE,#attributes.finish_date_last#) >= 26)
                	OR (ER.WORK_STATUS <> 1 AND ER.DISCOUNT_STATUS = 1 AND DATEDIFF(YEAR,ER.BIRTH_DATE,#attributes.finish_date_last#) >= 19))
                </cfif>
                <cfif isdefined('attributes.inout_statue') and attributes.inout_statue eq 1><!--- Girişler --->
                    <cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
                        AND EI.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
                    </cfif>
                    <cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
                        AND EI.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                    </cfif>
                <cfelseif isdefined('attributes.inout_statue') and attributes.inout_statue eq 0><!--- Çıkışlar --->
                    <cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
                        AND EI.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
                    </cfif>
                    <cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
                        AND EI.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                    </cfif>
                    AND	EI.FINISH_DATE IS NOT NULL
                <cfelseif isdefined('attributes.inout_statue') and attributes.inout_statue eq 2><!--- aktif calisanlar --->
                    AND E.EMPLOYEE_ID IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE
                    (
                        <cfif isdate(attributes.startdate) or isdate(attributes.finishdate)>
                            <cfif isdate(attributes.startdate) and not isdate(attributes.finishdate)>
                            (
                                (
                                EI.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                                EI.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
                                )
                                OR
                                (
                                EI.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                                EI.FINISH_DATE IS NULL
                                )
                            )
                            <cfelseif not isdate(attributes.startdate) and isdate(attributes.finishdate)>
                            (
                                (
                                EI.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#"> AND
                                EI.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                                )
                                OR
                                (
                                EI.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#"> AND
                                EI.FINISH_DATE IS NULL
                                )
                            )
                            <cfelse>
                            (
                                (
                                EI.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                                EI.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                                )
                                OR
                                (
                                EI.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                                EI.FINISH_DATE IS NULL
                                )
                                OR
                                (
                                EI.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                                EI.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                                )
                                OR
                                (
                                EI.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                                EI.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                                )
                            )
                            </cfif>
                        <cfelse>
                            EI.FINISH_DATE IS NULL
                        </cfif>
                    ) )
                <cfelse><!--- giriş ve çıkışlar Seçili ise --->
                    AND 
                    (
                        (
                            EI.START_DATE IS NOT NULL
                            <cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
                                AND EI.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
                            </cfif>
                            <cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
                                AND EI.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                            </cfif>
                        )
                        OR
                        (
                            EI.START_DATE IS NOT NULL
                            <cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
                                AND EI.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
                            </cfif>
                            <cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
                                AND EI.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                            </cfif>
                        )
                    )
                </cfif>
			<cfif not(isdefined('attributes.relative_level') and len(attributes.relative_level)) and (isdefined("attributes.is_agi") and attributes.is_agi neq 0) and (not isdefined('attributes.is_student')) and attributes.is_student neq 1 and attributes.is_work neq 0 and (not len(attributes.finish_date))>
          		UNION ALL
            </cfif>
        </cfif>
        <cfif ((isdefined('attributes.relative_level') and len(attributes.relative_level) and attributes.relative_level eq 0)) and (not len(attributes.finish_date))>
            SELECT 
                2 AS TYPE,
                E.EMPLOYEE_ID,
                E.EMPLOYEE_NO,
                E.EMPLOYEE_NAME EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME EMPLOYEE_SURNAME,
                B.BRANCH_NAME,
                B.RELATED_COMPANY,
                (SELECT NICK_NAME FROM OUR_COMPANY WHERE COMP_ID = B.COMPANY_ID) AS NICK_NAME,
                EII.TC_IDENTY_NO AS KISI_TC_NO,
                EII.MARRIED,
                EII.BIRTH_DATE AS KISI_DOGUM,
                ED.SEX,
                CASE 
                    WHEN EP.EMPLOYEE_ID IS NOT NULL 
                THEN
                    EP.POSITION_NAME
                ELSE
                    EPCH.POSITION_NAME
                END AS POSITION_NAME,
                CASE 
                    WHEN EP.EMPLOYEE_ID IS NOT NULL 
                THEN
                    (SELECT TITLE FROM SETUP_TITLE WHERE TITLE_ID = EP.TITLE_ID)
                ELSE
                    (SELECT TITLE FROM SETUP_TITLE WHERE TITLE_ID = EPCH.TITLE_ID)
                END AS TITLE,
                '' AS NAME,
                '' AS SURNAME,
                '0' AS RELATIVE_LEVEL,
                '' AS TC_IDENTY_NO,
                EII.BIRTH_DATE AS BIRTH_DATE,
                EII.BIRTH_PLACE AS BIRTH_PLACE,
                E.RECORD_DATE,
                1 AS DISCOUNT_STATUS,
                0 AS EDUCATION_STATUS,
                1 AS WORK_STATUS,
                '' AS MARRIAGE_DATE,
                '' AS VALIDITY_DATE
            FROM 
                EMPLOYEES_IN_OUT EI 
                INNER JOIN EMPLOYEES E ON EI.EMPLOYEE_ID = E.EMPLOYEE_ID 
                LEFT JOIN BRANCH B ON EI.BRANCH_ID = B.BRANCH_ID
                LEFT JOIN EMPLOYEES_IDENTY EII ON EII.EMPLOYEE_ID = E.EMPLOYEE_ID
                LEFT JOIN EMPLOYEES_DETAIL ED ON ED.EMPLOYEE_ID = E.EMPLOYEE_ID
                LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID
                LEFT JOIN EMPLOYEE_POSITIONS_CHANGE_HISTORY EPCH ON EPCH.EMPLOYEE_ID = E.EMPLOYEE_ID AND EPCH.ID = (SELECT MAX(ID) FROM EMPLOYEE_POSITIONS_CHANGE_HISTORY WHERE EMPLOYEE_ID = E.EMPLOYEE_ID
                    <cfif isdefined('attributes.startdate') and isdate(attributes.startdate) and isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
                        AND ((START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">)
                            OR (START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND FINISH_DATE IS NULL)
                            OR (START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">)
                            OR (FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">))
                    </cfif>)
            WHERE
                (EP.IS_MASTER = 1 OR EP.EMPLOYEE_ID IS NULL)
                <cfif len(attributes.comp_id)>
                     AND B.COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#" list = "yes">)
                </cfif>
                <cfif len(attributes.branch_id)>
                    AND B.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#" list = "yes">)
                </cfif>
                <cfif not session.ep.ehesap>
                    AND B.BRANCH_ID IN (#emp_branch_list#) 
                </cfif>
                <cfif len(month_list)>
                    AND MONTH(E.RECORD_DATE) IN (#month_list#) 
                </cfif>
                <cfif isdefined('attributes.employee_id') and isdefined('attributes.employee') and len(attributes.employee_id) and len(attributes.employee)>
                	AND E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
                </cfif>
                <cfif isdefined('attributes.inout_statue') and attributes.inout_statue eq 1><!--- Girişler --->
                    <cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
                        AND EI.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
                    </cfif>
                    <cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
                        AND EI.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                    </cfif>
                <cfelseif isdefined('attributes.inout_statue') and attributes.inout_statue eq 0><!--- Çıkışlar --->
                    <cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
                        AND EI.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
                    </cfif>
                    <cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
                        AND EI.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                    </cfif>
                    AND	EI.FINISH_DATE IS NOT NULL
                <cfelseif isdefined('attributes.inout_statue') and attributes.inout_statue eq 2><!--- aktif calisanlar --->
                    AND E.EMPLOYEE_ID IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE
                    (
                        <cfif isdate(attributes.startdate) or isdate(attributes.finishdate)>
                            <cfif isdate(attributes.startdate) and not isdate(attributes.finishdate)>
                            (
                                (
                                EI.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                                EI.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
                                )
                                OR
                                (
                                EI.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                                EI.FINISH_DATE IS NULL
                                )
                            )
                            <cfelseif not isdate(attributes.startdate) and isdate(attributes.finishdate)>
                            (
                                (
                                EI.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#"> AND
                                EI.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                                )
                                OR
                                (
                                EI.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#"> AND
                                EI.FINISH_DATE IS NULL
                                )
                            )
                            <cfelse>
                            (
                                (
                                EI.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                                EI.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                                )
                                OR
                                (
                                EI.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                                EI.FINISH_DATE IS NULL
                                )
                                OR
                                (
                                EI.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                                EI.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                                )
                                OR
                                (
                                EI.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                                EI.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                                )
                            )
                            </cfif>
                        <cfelse>
                            EI.FINISH_DATE IS NULL
                        </cfif>
                    ) )
                <cfelse><!--- giriş ve çıkışlar Seçili ise --->
                    AND 
                    (
                        (
                            EI.START_DATE IS NOT NULL
                            <cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
                                AND EI.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
                            </cfif>
                            <cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
                                AND EI.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                            </cfif>
                        )
                        OR
                        (
                            EI.START_DATE IS NOT NULL
                            <cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
                                AND EI.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
                            </cfif>
                            <cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
                                AND EI.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                            </cfif>
                        )
                    )
                </cfif>
		</cfif>
            ),
            CTE2 AS (
                SELECT
                    CTE1.*,
                    ROW_NUMBER() OVER (
                        ORDER BY 
                            EMPLOYEE_NAME,
                            EMPLOYEE_SURNAME,
                            TYPE DESC,
                            RELATIVE_LEVEL
            ) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                FROM
                    CTE1
            )
            SELECT
                CTE2.*
            FROM
                CTE2
         	<cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
            WHERE
                RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
         	</cfif>
                ORDER BY 
                    EMPLOYEE_NAME,
                    EMPLOYEE_SURNAME,
                    TYPE DESC,
                    RELATIVE_LEVEL
        </cfquery>
<cfelse>
	<cfset get_employees.recordcount = 0>
    <cfset get_employees.query_count = 0>
</cfif>
<cfparam name="attributes.totalrecords" default='#get_employees.query_count#'>
<cfsavecontent variable="head"><cf_get_lang dictionary_id='39922.Aile Durum Bildirim Raporu'></cfsavecontent>
<cfform name="ara_form" method="post" action="#request.self#?fuseaction=report.family_detail">
    <cf_report_list_search title="#head#">
        <cf_report_list_search_area>
            <div class="row">
                <div class="col col-12 col-xs-12"> 
                    <div class="row formContent">
                        <div class="row" type="row">
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                                <div class="col col-12 col-md-12 col-xs-12">
                                    <div class="form-group">
                                        <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id="57576.calisan"></label>
                                        <div class="col col-12 col-md-12 col-xs-12">
                                            <div class="input-group">
                                            <input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined('attributes.employee_id') and len(attributes.employee)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
                                            <input type="text" name="employee" id="employee" value="<cfif isdefined('attributes.employee') and len(attributes.employee)><cfoutput>#attributes.employee#</cfoutput></cfif>" style="width:120px;" onfocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','135');" autocomplete="off">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=ara_form.employee_id&field_name=ara_form.employee&select_list=1','list');"></span>	
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='29531.Şirketler'></label>
                                        <div class="col col-12 col-xs-12">
                                            <div class="multiselect-z2">
                                                <cf_multiselect_check 
                                                query_name="get_our_company"  
                                                name="comp_id"
                                                option_value="COMP_ID"
                                                option_name="COMPANY_NAME"
                                                option_text="#getLang('main',322)#"
                                                value="#attributes.comp_id#"
                                                onchange="get_branch_list(this.value)">
                                            </div>                                               
                                        </div>     
                                    </div>
                                    <div class="form-group" >
                                        <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                                        <div class="col col-12 col-xs-12" id="BRANCH_PLACE">
                                            <div id="BRANCH_PLACE" class="multiselect-z2">
                                                <cf_multiselect_check 
                                                query_name="get_branch"  
                                                name="branch_id"
                                                option_value="BRANCH_ID"
                                                option_name="BRANCH_NAME"
                                                option_text="#getLang('main',322)#"
                                                value="#attributes.branch_id#">
                                            </div>                                          
                                        </div>     
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                                <div class="col col-12 col-md-12 col-xs-12">
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='50669.Kriter'></label>
                                        <div class="col col-12 col-xs-12">
                                            <select name="inout_statue" id="inout_statue">
                                                <option value="">Giriş ve Çıkışlar</option>
                                                <option value="1"<cfif attributes.inout_statue eq 1> selected</cfif>><cf_get_lang dictionary_id='58535.Girişler'></option>
                                                <option value="0"<cfif attributes.inout_statue eq 0> selected</cfif>><cf_get_lang dictionary_id='58536.Çıkışlar'></option>
                                                <option value="2"<cfif attributes.inout_statue eq 2> selected</cfif>><cf_get_lang dictionary_id='55905.Aktif Çalışanlar'></option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group">	
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='50669.Kriter'><cf_get_lang dictionary_id='58690.Tarih Aralığı'>*</label>	
                                        <div class="col col-12 paddingNone">	
                                            <div class="col col-6">
                                                <div class="input-group">
                                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
                                                    <cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
                                                        <cfinput type="text" name="startdate" id="startdate" maxlength="10" validate="#validate_style#" message="#message#"  value="#dateformat(attributes.startdate,dateformat_style)#">
                                                    <cfelse>
                                                        <cfinput type="text" name="startdate" id="startdate" maxlength="10" validate="#validate_style#" message="#message#" >
                                                    </cfif>
                                                    <span class="input-group-addon">
                                                    <cf_wrk_date_image date_field="startdate">
                                                    </span>
                                                </div>
                                            </div>
                                            <div class="col col-6">
                                                <div class="input-group">
                                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                                                    <cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
                                                        <cfinput type="text" name="finishdate" id="finishdate" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.finishdate,dateformat_style)#">
                                                    <cfelse>
                                                        <cfinput type="text" name="finishdate" id="finishdate" maxlength="10" validate="#validate_style#" message="#message#" >
                                                    </cfif>
                                                    <span class="input-group-addon">
                                                        <cf_wrk_date_image date_field="finishdate">
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='39964.Agi'></label>
                                        <div class="col col-12 col-xs-12">					
                                            <select name="is_agi" id="is_agi">
                                                <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                                <option value="1"<cfif isdefined('attributes.is_agi') and attributes.is_agi eq 1> selected</cfif>><cf_get_lang dictionary_id='29492.Kullanıyor'></option>
                                                <option value="0"<cfif isdefined('attributes.is_agi') and attributes.is_agi eq 0> selected</cfif>><cf_get_lang dictionary_id='29493.Kullanmıyor'></option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                                <div class="col col-12 col-md-12 col-xs-12">
                                    <div class="form-group">
                                        <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='40118.Yakınlık Derecesi'></label>
                                        <div class="col col-12 col-xs-12">
                                            <select name="relative_level" id="relative_level">
                                                <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                                <option value="0" <cfif isdefined('attributes.relative_level') and attributes.relative_level eq 0>selected</cfif>><cf_get_lang dictionary_id='40429.Kendisi'></option>
                                                <option value="3" <cfif isdefined('attributes.relative_level') and attributes.relative_level eq 3>selected</cfif>><cf_get_lang dictionary_id='40356.Eşi'></option>
                                                <option value="4" <cfif isdefined('attributes.relative_level') and attributes.relative_level eq 4>selected</cfif>><cf_get_lang dictionary_id='40368.Oğlu'></option>
                                                <option value="5" <cfif isdefined('attributes.relative_level') and attributes.relative_level eq 5>selected</cfif>><cf_get_lang dictionary_id='40369.Kızı'></option>
                                            </select>	
                                        </div>			
                                    </div>
                                    <div class="form-group">
                                        <div class="col col-6 col-md-6 paddingNone">
                                            <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='58455.Yıl'></label>
                                            <div class="col col-12 col-xs-12">
                                                <select name="related_year" id="related_year">
                                                    <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                                    <cfloop from="#year(now())#" to="2008" index="i" step="-1">
                                                        <cfoutput>
                                                            <option value="#i#"<cfif attributes.related_year eq i> selected</cfif>>#i#</option>
                                                        </cfoutput>
                                                    </cfloop>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col col-6 col-md-6 paddingNone">
                                            <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='58724.Ay'></label>
                                            <div class="col col-12 col-xs-12">   
                                                <select name="related_mon" id="related_mon">
                                                    <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                                    <cfloop from="1" to="12" index="i">
                                                        <cfoutput>
                                                            <option value="#i#"<cfif attributes.related_mon eq i> selected</cfif>>#listgetat(ay_list(),i,',')#</option>
                                                        </cfoutput>
                                                    </cfloop>
                                                </select>   
                                            </div>					
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id ='40120.Okul Durumu'></label>    
                                        <div class="col col-12 col-xs-12">     
                                            <select name="is_student" id="is_student">
                                                    <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                                    <option value="1"<cfif isdefined('attributes.is_student') and attributes.is_student eq 1> selected</cfif>><cf_get_lang dictionary_id ='40130.Öğrenci'></option>
                                                    <option value="0"<cfif isdefined('attributes.is_student') and attributes.is_student eq 0> selected</cfif>><cf_get_lang dictionary_id ='40131.Okumuyor'></option>
                                            </select>
                                        </div>         
                                    </div>
                                    
                                </div>
                            </div>
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                                <div class="col col-12 col-md-12 col-xs-12">
                                    <div class="form-group">    
                                        <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id ='40121.İş Durumu'></label>    
                                        <div class="col col-12 col-xs-12"> 
                                            <select name="is_work" id="is_work">
                                                <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                                <option value="1"<cfif isdefined('attributes.is_work') and attributes.is_work eq 1> selected</cfif>><cf_get_lang dictionary_id ='40137.Çalışıyor'></option>
                                                <option value="0"<cfif isdefined('attributes.is_work') and attributes.is_work eq 0> selected</cfif>><cf_get_lang dictionary_id ='40138.Çalışmıyor'></option>
                                            </select>
                                        </div>					
                                    </div>
                                    <div class="form-group">				
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58624.Geçerlilik Tarihi'></label>
                                        <div class="col col-12 col-xs-12">
                                            <div class="input-group">
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='58624.Geçerlilik Tarihi'></cfsavecontent>
                                                <cfif isdefined('attributes.validdate') and isdate(attributes.validdate)>
                                                    <cfinput type="text" name="validdate" id="validdate" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.validdate,dateformat_style)#">
                                                <cfelse>
                                                    <cfinput type="text" name="validdate" id="validdate" maxlength="10" validate="#validate_style#" message="#message#" >
                                                </cfif>
                                                <span class="input-group-addon">
                                                <cf_wrk_date_image date_field="validdate">
                                                </span>
                                            </div>
                                        </div>					 
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12"><cf_get_lang dictionary_id='57502.Tarih Bitiş'><cf_get_lang dictionary_id='58690.Tarih Aralığı'></label>
                                        <div class="col col-12 paddingNone">
                                            <div class="col col-6">
                                                <div class="input-group">
                                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                                                    <cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
                                                        <cfinput type="text" name="finish_date" id="finish_date" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.finish_date,dateformat_style)#">
                                                    <cfelse>
                                                        <cfinput type="text" name="finish_date" id="finish_date" maxlength="10" validate="#validate_style#" message="#message#" >
                                                    </cfif>
                                                    <span class="input-group-addon">
                                                    <cf_wrk_date_image date_field="finish_date">
                                                    </span>
                                                </div>
                                            </div>
                                            <div class="col col-6">
                                                <div class="input-group">    
                                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                                                    <cfif isdefined('attributes.finish_date_last') and isdate(attributes.finish_date_last)>
                                                        <cfinput type="text" name="finish_date_last" id="finish_date_last" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.finish_date_last,dateformat_style)#">
                                                    <cfelse>
                                                        <cfinput type="text" name="finish_date_last" id="finish_date_last" maxlength="10" validate="#validate_style#" message="#message#" >
                                                    </cfif>
                                                    <span class="input-group-addon">
                                                    <cf_wrk_date_image date_field="finish_date_last">
                                                    </span>
                                                </div>
                                            </div>
                                        </div>	
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row ReportContentBorder">
                        <div class="ReportContentFooter">
                            <label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='57911.Çalıştır'></cfsavecontent>
                            <input name="form_submit" id="form_submit" type="hidden" value="1">
                            <cf_wrk_report_search_button button_type='1' search_function="control()" is_excel='1'>
                        </div>
                    </div>
                </div>
            </div>

        </cf_report_list_search_area>
    </cf_report_list_search> 
</cfform>

    <cfif attributes.is_excel eq 1>
        <cfset type_ = 1>
        <cfset filename = "#createuuid()#">
        <cfheader name="Expires" value="#Now()#">
        <cfcontent type="application/vnd.msexcel;charset=utf-16">
        <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-16">
    <cfelse>
        <cfset type_ = 0>
    </cfif>
<cfif isdefined("form_submit")>
    <cf_report_list>
        <!-- sil -->
        <cfif isdefined("attributes.comp_id")>
            <cfif len(attributes.related_year) and len(attributes.related_mon)>
                <cfset ay_sonu = CreateDateTime(attributes.related_year, attributes.related_mon,daysinmonth(createdate(attributes.related_year,attributes.related_mon,1)), 23,59,59)>
            <cfelse>
                <cfset ay_sonu = CreateDateTime(year(now()), month(now()),daysinmonth(createdate(year(now()),month(now()),1)), 23,59,59)>
            </cfif>
                
            <cfset cocuk_sayisi = 0> 
        <!-- sil -->
                <thead>
                <tr>
                    <th><cf_get_lang dictionary_id ='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id ='58487.Çalışan No'></th>
                    <th><cf_get_lang dictionary_id ='57576.Çalışan'></th>
                    <th><cf_get_lang dictionary_id ='40114.Çalışan Yaşı'></th>
                    <th><cf_get_lang dictionary_id ='57576.Çalışan'><cf_get_lang dictionary_id ='58025.TC No'></th>
                    <th><cf_get_lang dictionary_id ='58497.Pozisyon'></th>
                    <th><cf_get_lang dictionary_id ='57571.Ünvan'></th>
                    <th><cf_get_lang dictionary_id ='57574.Şirket'></th>
                    <th><cf_get_lang dictionary_id ='57453.Şube'></th>
                    <th><cf_get_lang dictionary_id ='38914.Medeni Durum'></th>
                    <th><cf_get_lang dictionary_id ='40117.Yakını'></th>
                    <th><cf_get_lang dictionary_id ='40118.Yakınlık Derecesi'></th>
                    <th><cf_get_lang dictionary_id ='58025.TC No'></th>
                    <th><cf_get_lang dictionary_id ='57790.Doğum Yeri'></th>
                    <th><cf_get_lang dictionary_id ='58727.Doğum Tarihi'></th>
                    <th><cf_get_lang dictionary_id ='39398.Yaş'></th>
                    <th><cf_get_lang dictionary_id ='38971.Vergi İndirimi'></th>
                    <th><cf_get_lang dictionary_id ='40120.Okul Durumu'></th>
                    <th><cf_get_lang dictionary_id ='40121.İş Durumu'></th>
                    <th><cf_get_lang dictionary_id ='58456.ORAN'></th>
                    <th><cf_get_lang dictionary_id ='29911.Evlilik Tarihi'></th>
                    <th><cf_get_lang dictionary_id ='58624.Geçerlilik Tarihi'></th>
                    <th><cf_get_lang dictionary_id ='57700.Bitiş Tarihi'></th>
                </tr>
                </thead>	
                <tbody>
                <cfif get_employees.recordcount>
                <cfoutput query="get_employees">
                    <tr>
                        <td>#rownum#</td>
                        <td>#employee_no#</td>
                        <td>#employee_name# #employee_surname#</td>
                        <td><cfif len(kisi_dogum)>#datediff("yyyy",kisi_dogum,now())#</cfif></td>
                        <td>#kisi_tc_no#</td>
                        <td>#position_name#</td>
                        <td>#title#</td>
                        <td>#nick_name#</td>
                        <td>#branch_name#</td>
                        <td><cfif MARRIED eq 1><cf_get_lang dictionary_id ='38916.Evli'><cfelse><cf_get_lang dictionary_id ='38915.Bekar'></cfif></td>
                        <td><cfif TYPE eq 2>-<cfelse>#name# #surname#</cfif></td>
                        <td>
                        <cfif relative_level eq 3><cfset relative_type = getLang('report',1635)>
                        <cfelseif relative_level eq 4><cfset relative_type = getLang('report',1647)>
                        <cfelseif relative_level eq 5><cfset relative_type = getLang('report',1648)>
                        <cfelseif relative_level eq 1><cfset relative_type = getLang(dictionary_id:55265)>
                        <cfelseif relative_level eq 2><cfset relative_type = getLang(dictionary_id:55470)>
                        <cfelseif relative_level eq 6><cfset relative_type = getLang(dictionary_id:56360)>
                        <cfelse><cfset relative_type =getLang(dictionary_id : 40429)>
                        </cfif>
                        #relative_type#
                        </td>
                        <td><cfif TYPE eq 2>#kisi_tc_no#<cfelse>#tc_identy_no#</cfif></td>
                        <td>#birth_place#</td>
                        <td><cfif TYPE eq 2><cfif len(kisi_dogum)>#DateFormat(kisi_dogum,dateformat_style)#</cfif><cfelse><cfif len(birth_date)>#DateFormat(birth_date,dateformat_style)#</cfif></cfif></td>
                        <td><cfif TYPE eq 2><cfif len(kisi_dogum)>#datediff("yyyy",kisi_dogum,now())#</cfif><cfelse><cfif len(birth_date)>#datediff("yyyy",birth_date,now())#</cfif></cfif></td>
                        <td><cfif discount_status eq 1><cf_get_lang dictionary_id='29492.Kullanıyor'><cfelse><cf_get_lang dictionary_id='29493.Kullanmıyor'></cfif></td>
                        <td><cfif education_status eq 1><cf_get_lang dictionary_id ='40130.Öğrenci'><cfelse><cf_get_lang dictionary_id ='40131.Okumuyor'></cfif></td>
                        <td><cfif work_status eq 1><cf_get_lang dictionary_id ='40137.Çalışıyor'><cfelse><cf_get_lang dictionary_id ='40138.Çalışmıyor'></cfif></td>
                        <td>
                            <cfif type eq 2>50<cfelseif relative_level eq 3>
                                <cfif work_status neq 1 and discount_status eq 1>10<cfelse>0</cfif>
                            <cfelseif (relative_level eq 4 or relative_level eq 5)>
                                <cfif relative_level eq 4 and work_status neq 1 and discount_status eq 1 and education_status eq 1 and datediff("yyyy",birth_date,ay_sonu) lte 25>
                                    <cfif cocuk_sayisi lt 2>7,5<cfelse>5</cfif>
                                    <cfset cocuk_sayisi = cocuk_sayisi + 1>
                                <cfelseif relative_level eq 4 and work_status neq 1 and discount_status eq 1 and datediff("yyyy",birth_date,ay_sonu) lt 18>
                                    <cfif cocuk_sayisi lt 2>7,5<cfelse>5</cfif>
                                    <cfset cocuk_sayisi = cocuk_sayisi + 1>
                                <cfelseif relative_level eq 5 and work_status neq 1 and discount_status eq 1 and education_status eq 1 and datediff("yyyy",birth_date,ay_sonu) lte 25>
                                    <cfif cocuk_sayisi lt 2>7,5<cfelse>5</cfif>
                                    <cfset cocuk_sayisi = cocuk_sayisi + 1>
                                <cfelseif relative_level eq 5 and work_status neq 1 and discount_status eq 1 and datediff("yyyy",birth_date,ay_sonu) lt 18>
                                    <cfif cocuk_sayisi lt 2>7,5<cfelse>5</cfif>
                                    <cfset cocuk_sayisi = cocuk_sayisi + 1>
                                <cfelse>0</cfif>
                            </cfif>
                        </td>
                        <td>
                            <cfif len(marriage_date) and year(marriage_date) gt 1900>#dateformat(marriage_date,dateformat_style)#</cfif>
                        </td>
                        <td>#dateformat(validity_date,dateformat_style)#</td>
                        <td>
                            <cfif (relative_level eq 4 or relative_level eq 5) and len(birth_date)>
                                <cfif work_status neq 1 and discount_status eq 1 and education_status eq 1>
                                    #dateformat(dateadd('yyyy',26,birth_date),dateformat_style)#
                                <cfelseif work_status neq 1 and discount_status eq 1>
                                    #dateformat(dateadd('yyyy',19,birth_date),dateformat_style)#
                                </cfif>
                            </cfif>
                        </td>
                    </tr>
                    <cfif currentrow neq recordcount and employee_id neq employee_id[currentrow+1]>
                        <cfset cocuk_sayisi = 0>
                    </cfif>
                </cfoutput>
                <cfelse>
                    <tr height="20">
                        <td colspan="23"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                    </tr>
                </cfif>
               
                </tbody>
        <!-- sil -->
        </cfif>
      
    </cf_report_list>
    <cfif attributes.totalrecords gt attributes.maxrows>
        <cfscript>
            url_str = "report.family_detail";
            if(isdefined('attributes.form_submit'))
                url_str = "#url_str#&form_submit=#attributes.form_submit#";
            if(isdefined('attributes.branch_id') and len(attributes.branch_id))
                url_str = "#url_str#&branch_id=#attributes.branch_id#";
            if(isdefined('attributes.comp_id') and len(attributes.comp_id))
                url_str = "#url_str#&comp_id=#attributes.comp_id#";
            if(isdefined('attributes.employee') and len(attributes.employee))
                url_str = "#url_str#&employee=#attributes.employee#";
            if(isdefined('attributes.employee_id') and len(attributes.employee_id))
                url_str = "#url_str#&employee_id=#attributes.employee_id#";
            if(isdefined('attributes.inout_statue') and len(attributes.inout_statue))
                url_str = "#url_str#&inout_statue=#attributes.inout_statue#";
            if(isdefined('attributes.is_agi') and len(attributes.is_agi))
                url_str = "#url_str#&is_agi=#attributes.is_agi#";
            if(isdefined('attributes.is_student') and len(attributes.is_student))
                url_str = "#url_str#&is_student=#attributes.is_student#";
            if(isdefined('attributes.is_work') and len(attributes.is_work))
                url_str = "#url_str#&is_work=#attributes.is_work#";
            if(isdefined('attributes.related_mon') and len(attributes.related_mon))
                url_str = "#url_str#&related_mon=#attributes.related_mon#";
            if(isdefined('attributes.related_year') and len(attributes.related_year))
                url_str = "#url_str#&related_year=#attributes.related_year#";
            if(isdefined('attributes.relative_level') and len(attributes.relative_level))
                url_str = "#url_str#&relative_level=#attributes.relative_level#";
            if(isdefined('attributes.startdate') and len(attributes.startdate))
                url_str = "#url_str#&startdate=#dateformat(attributes.startdate,dateformat_style)#";
            if(isdefined('attributes.finishdate') and len(attributes.finishdate))
                url_str = "#url_str#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#";
            if(isdefined('attributes.validdate') and len(attributes.validdate))
                url_str = "#url_str#&validdate=#dateformat(attributes.validdate,dateformat_style)#";
            if(isdefined('attributes.finish_date') and len(attributes.finish_date))
                url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#";
        </cfscript>
        <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="#url_str#">
    </cfif>
</cfif>

<script type="text/javascript">
function get_branch_list(gelen)
	{
		checkedValues_b = $("#comp_id").multiselect("getChecked");
		var comp_id_list='';
		for(kk=0;kk<checkedValues_b.length; kk++)
		{
			if(comp_id_list == '')
				comp_id_list = checkedValues_b[kk].value;
			else
				comp_id_list = comp_id_list + ',' + checkedValues_b[kk].value;
		}
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=branch_id&comp_id="+comp_id_list;
		AjaxPageLoad(send_address,'BRANCH_PLACE',1,'İlişkili Şubeler');
	}

function control(){

        if(!date_check(ara_form.finish_date,ara_form.finish_date_last)){
            alert("<cf_get_lang dictionary_id ='58492.Tarih Filtesini Kontrol Ediniz'>!");
			return false;
		}
        if(!date_check(ara_form.startdate,ara_form.finishdate))
		{
			alert("<cf_get_lang dictionary_id ='58492.Tarih Filtesini Kontrol Ediniz'>!");
			return false;
		}

		if(document.ara_form.is_excel.checked==false)
		{
			document.ara_form.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
			return true;
		}
		else
			document.ara_form.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_family_detail</cfoutput>"
	}
</script>
