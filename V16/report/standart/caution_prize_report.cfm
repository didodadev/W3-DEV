<cfsetting showdebugoutput="no">
<cfparam name="attributes.module_id_control" default="3,48">
<cfinclude template="report_authority_control.cfm">
<cfscript>
	bu_ay_basi = CreateDate(year(now()),month(now()),1);
	bu_ay_sonu = DaysInMonth(bu_ay_basi);
</cfscript>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.report_type" default="0">
<cfparam name="attributes.comp_id" default="">
<cfparam name="attributes.zone_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.pos_cat_id" default="">
<cfparam name="attributes.title_id" default="">
<cfparam name="attributes.func_id" default="">
<cfparam name="attributes.inout_statue" default="2">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.is_not_in_out" default="">
<cfparam name="attributes.caution_type_id" default="">
<cfparam name="attributes.prize_type_id" default="">
<!---
<cfparam name="attributes.start_date" default="1/#month(now())#/#session.ep.period_year#">
<cfparam name="attributes.finish_date" default="#bu_ay_sonu#/#month(now())#/#session.ep.period_year#">
<cfparam name="attributes.startdate" default="1/#month(now())#/#session.ep.period_year#">
<cfparam name="attributes.finishdate" default="#bu_ay_sonu#/#month(now())#/#session.ep.period_year#">
--->
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfif len(attributes.start_date) and isdate(attributes.start_date) >
	<cf_date tarih="attributes.start_date">
<cfelse>
	<cfset attributes.start_date = "">
</cfif>
<cfif len(attributes.finish_date) and isdate(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
<cfelse>
	<cfset attributes.finish_date="">
</cfif>
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
<cfquery name="get_company" datasource="#dsn#">
	SELECT COMP_ID, NICK_NAME FROM OUR_COMPANY
    <cfif not session.ep.ehesap>
        WHERE COMP_ID IN (SELECT DISTINCT B.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH B ON B.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
    </cfif>
    ORDER BY NICK_NAME
</cfquery>
<cfquery name="get_zones" datasource="#dsn#">
    SELECT ZONE_ID,ZONE_NAME FROM ZONE WHERE ZONE_STATUS = 1 ORDER BY ZONE_NAME
</cfquery>
<cfquery name="get_branches" datasource="#dsn#">
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
<cfquery name="get_department" datasource="#dsn#">
	SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>BRANCH_ID IN(#attributes.branch_id#)<cfelse>1=0</cfif> AND DEPARTMENT_STATUS = 1 ORDER BY DEPARTMENT_HEAD
</cfquery>
<cfquery name="get_pos_cats" datasource="#dsn#">
	SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT WHERE POSITION_CAT_STATUS = 1 ORDER BY POSITION_CAT
</cfquery>
<cfquery name="get_titles" datasource="#dsn#">
	SELECT TITLE_ID,TITLE FROM SETUP_TITLE WHERE IS_ACTIVE = 1 ORDER BY TITLE
</cfquery>
<cfquery name="get_units" datasource="#dsn#">
	SELECT UNIT_ID,UNIT_NAME FROM SETUP_CV_UNIT WHERE IS_ACTIVE = 1 ORDER BY UNIT_NAME
</cfquery>
<cfquery name="caution_type" datasource="#dsn#">
	SELECT CAUTION_TYPE_ID,CAUTION_TYPE FROM SETUP_CAUTION_TYPE ORDER BY CAUTION_TYPE
</cfquery>
<cfquery name="prize_type" datasource="#dsn#">
	SELECT PRIZE_TYPE_ID,PRIZE_TYPE FROM SETUP_PRIZE_TYPE ORDER BY PRIZE_TYPE
</cfquery>
<cfif isdefined('attributes.is_form_submit')>
	<cfif attributes.report_type eq 0>
		<cfquery name="get_data" datasource="#dsn#">
            SELECT
                EC.DECISION_NO,
                EC.CAUTION_ID AS ID,
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME,
                E.EMPLOYEE_ID,
                EI.TC_IDENTY_NO,
                E.EMPLOYEE_NO,
                EP.POSITION_NAME,
		        EP.POSITION_CAT_ID,
                SPC.POSITION_CAT,
                EC.CAUTION_HEAD AS HEAD,
                SCT.CAUTION_TYPE AS TYPE,
                EC.WARNER_NAME,
                EC.CAUTION_DATE AS DATE,
                EC.CAUTION_DETAIL AS DETAIL,
                EC.APOLOGY
            FROM
                EMPLOYEES_CAUTION EC
                INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EC.CAUTION_TO
                LEFT JOIN SETUP_CAUTION_TYPE SCT ON SCT.CAUTION_TYPE_ID = EC.CAUTION_TYPE_ID
                LEFT JOIN EMPLOYEES_IDENTY EI ON EI.EMPLOYEE_ID = E.EMPLOYEE_ID
                LEFT JOIN EMPLOYEES_IN_OUT EIO ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND EIO.RECORD_DATE = (SELECT MAX(RECORD_DATE) FROM EMPLOYEES_IN_OUT WHERE E.EMPLOYEE_ID = EMPLOYEE_ID AND START_DATE <= EC.CAUTION_DATE AND (FINISH_DATE >= EC.CAUTION_DATE OR FINISH_DATE IS NULL))
                LEFT JOIN EMPLOYEE_POSITIONS EP ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.IS_MASTER = 1
                LEFT JOIN EMPLOYEE_POSITIONS_CHANGE_HISTORY EPCH ON E.EMPLOYEE_ID = EPCH.EMPLOYEE_ID AND EPCH.RECORD_DATE = (SELECT MAX(RECORD_DATE) FROM EMPLOYEE_POSITIONS_CHANGE_HISTORY WHERE E.EMPLOYEE_ID = EMPLOYEE_ID AND START_DATE <= EC.CAUTION_DATE AND (FINISH_DATE >= EC.CAUTION_DATE OR FINISH_DATE IS NULL))
                LEFT JOIN SETUP_POSITION_CAT SPC ON ((EP.POSITION_ID IS NOT NULL AND EP.POSITION_CAT_ID = SPC.POSITION_CAT_ID) OR (EP.POSITION_ID IS NULL AND EPCH.POSITION_CAT_ID = SPC.POSITION_CAT_ID))
                LEFT JOIN SETUP_TITLE ST ON ((EP.POSITION_ID IS NOT NULL AND EP.TITLE_ID = ST.TITLE_ID) OR (EP.POSITION_ID IS NULL AND EPCH.TITLE_ID = ST.TITLE_ID))
                LEFT JOIN SETUP_CV_UNIT SCU ON ((EP.POSITION_ID IS NOT NULL AND EP.FUNC_ID = SCU.UNIT_ID) OR (EP.POSITION_ID IS NULL AND EPCH.FUNC_ID = SCU.UNIT_ID))
                LEFT JOIN DEPARTMENT D ON ((EIO.IN_OUT_ID IS NOT NULL AND D.DEPARTMENT_ID = EIO.DEPARTMENT_ID) OR (EIO.IN_OUT_ID IS NULL AND D.DEPARTMENT_ID = EPCH.DEPARTMENT_ID) OR (EIO.IN_OUT_ID IS NULL AND EPCH.ID IS NULL AND EP.DEPARTMENT_ID = D.DEPARTMENT_ID))
				LEFT JOIN BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
				LEFT JOIN OUR_COMPANY OC ON OC.COMP_ID = B.COMPANY_ID
                LEFT JOIN ZONE Z ON Z.ZONE_ID = B.ZONE_ID
            WHERE
                1=1
                <cfif len(attributes.keyword)>
                    AND ((E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME) LIKE '%#attributes.keyword#%' OR
                        EC.CAUTION_HEAD LIKE '%#attributes.keyword#%')
                </cfif>
                <cfif len(attributes.comp_id)>
                	AND OC.COMP_ID IN (#attributes.comp_id#)
                </cfif>
                <cfif len(attributes.zone_id)>
                	AND Z.ZONE_ID IN (#attributes.zone_id#)
                </cfif>
                <cfif len(attributes.branch_id)>
                	AND B.BRANCH_ID IN (#attributes.branch_id#)
                </cfif>
                <cfif not session.ep.ehesap>
                    AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
                    AND OC.COMP_ID IN (SELECT DISTINCT BR.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH BR ON BR.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
                </cfif>
                <cfif len(attributes.department)>
                	AND D.DEPARTMENT_ID IN (#attributes.department#)
                </cfif>
                <cfif len(attributes.pos_cat_id)>
                	AND SPC.POSITION_CAT_ID IN (#attributes.pos_cat_id#)
                </cfif>
                <cfif len(attributes.title_id)>
                	AND ST.TITLE_ID IN (#attributes.title_id#)
                </cfif>
                <cfif len(attributes.func_id)>
                	AND SCU.UNIT_ID IN (#attributes.func_id#)
                </cfif>
                <cfif len(attributes.caution_type_id)>
                	AND EC.CAUTION_TYPE_ID = #attributes.caution_type_id#
                </cfif>
                <cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
                	AND EC.CAUTION_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.start_date#">
                </cfif>
                <cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
                	AND EC.CAUTION_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finish_date#">
                </cfif>
                <cfif isdefined('attributes.inout_statue')>AND (
					<cfif isdefined('attributes.is_not_in_out') and attributes.is_not_in_out eq 1>
                        E.EMPLOYEE_ID NOT IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT) OR 
                    </cfif> (
					<cfif attributes.inout_statue eq 1><!--- Girişler --->
                        E.EMPLOYEE_ID IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT EMPIO WHERE 1=1
                        <cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
                            AND EMPIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
                        </cfif>
                        <cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
                            AND EMPIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                        </cfif> )
                    <cfelseif attributes.inout_statue eq 0><!--- Çıkışlar --->
                        E.EMPLOYEE_ID IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT EMPIO WHERE EMPIO.FINISH_DATE IS NOT NULL
                        <cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
                            AND EMPIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
                        </cfif>
                        <cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
                            AND EMPIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                        </cfif> )
                    <cfelseif attributes.inout_statue eq 2><!--- aktif calisanlar --->
                        E.EMPLOYEE_ID IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT EMPIO WHERE
                        (
                            <cfif isdate(attributes.startdate) or isdate(attributes.finishdate)>
                                <cfif isdate(attributes.startdate) and not isdate(attributes.finishdate)>
                                (
                                    (
                                    EMPIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                                    EMPIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
                                    )
                                    OR
                                    (
                                    EMPIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                                    EMPIO.FINISH_DATE IS NULL
                                    )
                                )
                                <cfelseif not isdate(attributes.startdate) and isdate(attributes.finishdate)>
                                (
                                    (
                                    EMPIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#"> AND
                                    EMPIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                                    )
                                    OR
                                    (
                                    EMPIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#"> AND
                                    EMPIO.FINISH_DATE IS NULL
                                    )
                                )
                                <cfelse>
                                (
                                    (
                                    EMPIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                                    EMPIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                                    )
                                    OR
                                    (
                                    EMPIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                                    EMPIO.FINISH_DATE IS NULL
                                    )
                                    OR
                                    (
                                    EMPIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                                    EMPIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                                    )
                                    OR
                                    (
                                    EMPIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                                    EMPIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                                    )
                                )
                                </cfif>
                            <cfelse>
                                EMPIO.FINISH_DATE IS NULL
                            </cfif>
                        ) )
                    <cfelse><!--- giriş ve çıkışlar Seçili ise --->
                        E.EMPLOYEE_ID IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT EMPIO WHERE
                        (
                            (
                                EMPIO.START_DATE IS NOT NULL
                                <cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
                                    AND EMPIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
                                </cfif>
                                <cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
                                    AND EMPIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                                </cfif>
                            )
                            OR
                            (
                                EMPIO.START_DATE IS NOT NULL
                                <cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
                                    AND EMPIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
                                </cfif>
                                <cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
                                    AND EMPIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                                </cfif>
                            )
                        ))
                    </cfif>
                ))
                </cfif>
        </cfquery>
   	<cfelseif attributes.report_type eq 1>
    	<cfquery name="get_data" datasource="#dsn#">
            SELECT
                EPP.PRIZE_HEAD AS HEAD,
                SPT.PRIZE_TYPE AS TYPE,
                EPP.PRIZE_GIVE_PERSON AS WARNER,
                EPP.PRIZE_DATE AS DATE,
                EPP.PRIZE_DETAIL AS DETAIL,
                EPP.PRIZE_ID AS ID,
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME,
                E.EMPLOYEE_ID,
                EW.EMPLOYEE_NAME + ' ' + EW.EMPLOYEE_SURNAME AS WARNER_NAME,
                EI.TC_IDENTY_NO
            FROM
                EMPLOYEES_PRIZE EPP
                INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EPP.PRIZE_TO
                LEFT JOIN EMPLOYEES EW ON EW.EMPLOYEE_ID = EPP.PRIZE_GIVE_PERSON
                LEFT JOIN SETUP_PRIZE_TYPE SPT ON EPP.PRIZE_TYPE_ID = SPT.PRIZE_TYPE_ID
                LEFT JOIN EMPLOYEES_IDENTY EI ON EI.EMPLOYEE_ID = E.EMPLOYEE_ID
                LEFT JOIN EMPLOYEES_IN_OUT EIO ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND EIO.RECORD_DATE = (SELECT MAX(RECORD_DATE) FROM EMPLOYEES_IN_OUT WHERE E.EMPLOYEE_ID = EMPLOYEE_ID AND START_DATE <= EPP.PRIZE_DATE AND (FINISH_DATE >= EPP.PRIZE_DATE OR FINISH_DATE IS NULL))
                LEFT JOIN EMPLOYEE_POSITIONS EP ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.IS_MASTER = 1
                LEFT JOIN EMPLOYEE_POSITIONS_CHANGE_HISTORY EPCH ON E.EMPLOYEE_ID = EPCH.EMPLOYEE_ID AND EPCH.RECORD_DATE = (SELECT MAX(RECORD_DATE) FROM EMPLOYEE_POSITIONS_CHANGE_HISTORY WHERE E.EMPLOYEE_ID = EMPLOYEE_ID AND START_DATE <= EPP.PRIZE_DATE AND (FINISH_DATE >= EPP.PRIZE_DATE OR FINISH_DATE IS NULL))
                LEFT JOIN SETUP_POSITION_CAT SPC ON ((EP.POSITION_ID IS NOT NULL AND EP.POSITION_CAT_ID = SPC.POSITION_CAT_ID) OR (EP.POSITION_ID IS NULL AND EPCH.POSITION_CAT_ID = SPC.POSITION_CAT_ID))
                LEFT JOIN SETUP_TITLE ST ON ((EP.POSITION_ID IS NOT NULL AND EP.TITLE_ID = ST.TITLE_ID) OR (EP.POSITION_ID IS NULL AND EPCH.TITLE_ID = ST.TITLE_ID))
                LEFT JOIN SETUP_CV_UNIT SCU ON ((EP.POSITION_ID IS NOT NULL AND EP.FUNC_ID = SCU.UNIT_ID) OR (EP.POSITION_ID IS NULL AND EPCH.FUNC_ID = SCU.UNIT_ID))
                LEFT JOIN DEPARTMENT D ON ((EIO.IN_OUT_ID IS NOT NULL AND D.DEPARTMENT_ID = EIO.DEPARTMENT_ID) OR (EIO.IN_OUT_ID IS NULL AND D.DEPARTMENT_ID = EPCH.DEPARTMENT_ID) OR (EIO.IN_OUT_ID IS NULL AND EPCH.ID IS NULL AND EP.DEPARTMENT_ID = D.DEPARTMENT_ID))
				LEFT JOIN BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
				LEFT JOIN OUR_COMPANY OC ON OC.COMP_ID = B.COMPANY_ID
                LEFT JOIN ZONE Z ON Z.ZONE_ID = B.ZONE_ID
          	WHERE
                1=1
                <cfif len(attributes.keyword)>
                    AND ((E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME) LIKE '%#attributes.keyword#%' OR
                        EPP.PRIZE_HEAD LIKE '%#attributes.keyword#%')
                </cfif>
                <cfif len(attributes.comp_id)>
                	AND OC.COMP_ID IN (#attributes.comp_id#)
                </cfif>
                <cfif len(attributes.zone_id)>
                	AND Z.ZONE_ID IN (#attributes.zone_id#)
                </cfif>
                <cfif len(attributes.branch_id)>
                	AND B.BRANCH_ID IN (#attributes.branch_id#)
                </cfif>
                <cfif len(attributes.department)>
                	AND D.DEPARTMENT_ID IN (#attributes.department#)
                </cfif>
                <cfif len(attributes.pos_cat_id)>
                	AND SPC.POSITION_CAT_ID IN (#attributes.pos_cat_id#)
                </cfif>
                <cfif len(attributes.title_id)>
                	AND ST.TITLE_ID IN (#attributes.title_id#)
                </cfif>
                <cfif len(attributes.func_id)>
                	AND SCU.UNIT_ID IN (#attributes.func_id#)
                </cfif>
                <cfif len(attributes.prize_type_id)>
                	AND EPP.PRIZE_TYPE_ID = #attributes.prize_type_id#
                </cfif>
                <cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
                	AND EPP.PRIZE_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.start_date#">
                </cfif>
                <cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
                	AND EPP.PRIZE_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finish_date#">
                </cfif>
                <cfif isdefined('attributes.inout_statue')>AND (
					<cfif isdefined('attributes.is_not_in_out') and attributes.is_not_in_out eq 1>
                        E.EMPLOYEE_ID NOT IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT) OR 
                    </cfif> (
					<cfif attributes.inout_statue eq 1><!--- Girişler --->
                        E.EMPLOYEE_ID IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT EMPIO WHERE 1=1
                        <cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
                            AND EMPIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
                        </cfif>
                        <cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
                            AND EMPIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                        </cfif> )
                    <cfelseif attributes.inout_statue eq 0><!--- Çıkışlar --->
                        E.EMPLOYEE_ID IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT EMPIO WHERE EMPIO.FINISH_DATE IS NOT NULL
                        <cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
                            AND EMPIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
                        </cfif>
                        <cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
                            AND EMPIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                        </cfif> )
                    <cfelseif attributes.inout_statue eq 2><!--- aktif calisanlar --->
                        E.EMPLOYEE_ID IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT EMPIO WHERE
                        (
                            <cfif isdate(attributes.startdate) or isdate(attributes.finishdate)>
                                <cfif isdate(attributes.startdate) and not isdate(attributes.finishdate)>
                                (
                                    (
                                    EMPIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                                    EMPIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
                                    )
                                    OR
                                    (
                                    EMPIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                                    EMPIO.FINISH_DATE IS NULL
                                    )
                                )
                                <cfelseif not isdate(attributes.startdate) and isdate(attributes.finishdate)>
                                (
                                    (
                                    EMPIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#"> AND
                                    EMPIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                                    )
                                    OR
                                    (
                                    EMPIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#"> AND
                                    EMPIO.FINISH_DATE IS NULL
                                    )
                                )
                                <cfelse>
                                (
                                    (
                                    EMPIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                                    EMPIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                                    )
                                    OR
                                    (
                                    EMPIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                                    EMPIO.FINISH_DATE IS NULL
                                    )
                                    OR
                                    (
                                    EMPIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                                    EMPIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                                    )
                                    OR
                                    (
                                    EMPIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
                                    EMPIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                                    )
                                )
                                </cfif>
                            <cfelse>
                                EMPIO.FINISH_DATE IS NULL
                            </cfif>
                        ) )
                    <cfelse><!--- giriş ve çıkışlar Seçili ise --->
                        E.EMPLOYEE_ID IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT EMPIO WHERE
                        (
                            (
                                EMPIO.START_DATE IS NOT NULL
                                <cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
                                    AND EMPIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
                                </cfif>
                                <cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
                                    AND EMPIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                                </cfif>
                            )
                            OR
                            (
                                EMPIO.START_DATE IS NOT NULL
                                <cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
                                    AND EMPIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
                                </cfif>
                                <cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
                                    AND EMPIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
                                </cfif>
                            )
                        ))
                    </cfif>
                ))
                </cfif>
      	</cfquery>
        <cfset warner_id_list = valuelist(get_data.warner,',')>
        <cfif len(warner_id_list)>
            <cfset warner_id_list=listsort(warner_id_list,"numeric","ASC",",")>
            <cfquery name="get_employee_detail" datasource="#dsn#">
                SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#warner_id_list#) ORDER BY EMPLOYEE_ID
            </cfquery>
        </cfif>
    </cfif>
<cfelse>
	<cfset get_data.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default="#get_data.recordcount#">
<cfsavecontent variable="head"><cf_get_lang dictionary_id='47815.Disiplin ve Ödül İşlemleri Raporu'></cfsavecontent>
<cfform name="search_form" method="post" action="#request.self#?fuseaction=report.caution_prize_report">
	<cf_report_list_search title="#head#">
		<cf_report_list_search_area>
			<div class="row">
                <div class="row formContent">
                    <div class="row" type="row">
                       <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                            <div class="col col-12 col-md-12 col-xs-12">
                                <div class="col col-12 col-md-12 col-xs-12">
                                    <div class="form-group">
                                        <label class="col col-12"><cf_get_lang dictionary_id='57460.Filtre'></label>
                                        <div class="col col-12">
                                            <input type="text" id="keyword" name="keyword" <cfoutput>value="#attributes.keyword#"</cfoutput>>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
                                        <div class="col col-12 col-md-12 col-xs-12">
                                            <div class="multiselect-z2">
                                                <cf_multiselect_check 
                                                query_name="get_company"  
                                                name="comp_id"
                                                option_value="COMP_ID"
                                                option_name="NICK_NAME"
                                                option_text="#getLang('main',322)#"
                                                value="#attributes.comp_id#"
                                                onchange="get_branch_list(this.value)">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                                        <div class="col col-12 col-md-12 col-xs-12">
                                            <div id="BRANCH_PLACE" class="multiselect-z2">
                                                <cf_multiselect_check 
                                                query_name="get_branches"  
                                                name="branch_id"
                                                option_value="BRANCH_ID"
                                                option_name="BRANCH_NAME"
                                                option_text="#getLang('main',322)#"
                                                value="#attributes.branch_id#">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                                        <div class="col col-12 col-md-12 col-xs-12">
                                            <div class="multiselect-z2" id="DEPARTMENT_PLACE">
                                                <cf_multiselect_check 
                                                query_name="get_department"  
                                                name="department"
                                                option_text="#getLang('main',322)#" 
                                                option_value="department_id"
                                                option_name="department_head"
                                                value="#iif(isdefined("attributes.department"),"attributes.department",DE(""))#">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                            <div class="col col-12 col-md-12 col-xs-12">
                                <div class="col col-12 col-md-12 col-xs-12">
                                    <div class="form-group">
                                        <label class="col col-12 col-md-12"><cf_get_lang dictionary_id="57692.İşlem"><cf_get_lang dictionary_id='58690.Tarih Aralığı'></label>
                                        <div class="col col-6 col-md-6">
                                            <div class="input-group">
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
                                                <cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
                                                    <cfinput type="text" name="start_date" id="start_date" maxlength="10" validate="#validate_style#" message="#message#"  value="#dateformat(attributes.start_date,dateformat_style)#">
                                                <cfelse>
                                                    <cfinput type="text" name="start_date" id="start_date" maxlength="10" validate="#validate_style#" message="#message#" >
                                                </cfif>
                                                <span class="input-group-addon">
                                                    <cf_wrk_date_image date_field="start_date">
                                                </span>
                                            </div>
                                        </div>
                                        <div class="col col-6 col-md-6">
                                            <div class="input-group">
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                                                <cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
                                                    <cfinput type="text" name="finish_date" id="finish_date" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.finish_date,dateformat_style)#">
                                                <cfelse>
                                                    <cfinput type="text" name="finish_date" id="finish_date" maxlength="10" validate="#validate_style#" message="#message#" >
                                                </cfif>
                                                <span class="input-group-addon">
                                                    <cf_wrk_date_image date_field="finish_date">
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-md-12"><cf_get_lang dictionary_id='58960.Rapor Tipi'></label>
                                        <div class="col col-12 col-md-12 col-xs-12 paddingNone">
                                            <div class="col col-6 col-md-6">
                                                <select name="report_type" id="report_type" onchange="tipGoster()">
                                                    <option value="0" <cfif attributes.report_type eq 0>selected</cfif>><cf_get_lang dictionary_id='60659.Disiplin'></option>
                                                    <option value="1" <cfif attributes.report_type eq 1>selected</cfif>><cf_get_lang dictionary_id='53122.Ödül'></option>
                                                </select>
                                            </div>
                                            <div class="col col-6 col-md-6">
                                                <select name="caution_type_id" id="caution_type_id" <cfif attributes.report_type neq 0>display:none;</cfif>>
                                                    <option value=""><cf_get_lang dictionary_id='59088.Tip'></option>
                                                    <cfoutput query="caution_type">
                                                        <option value="#caution_type_id#" <cfif caution_type_id eq attributes.caution_type_id>selected</cfif>>#caution_type#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                            
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-md-12"><cf_get_lang dictionary_id='57992.Bölge'></label>
                                        <div class="col col-12 col-md-12 col-xs-12">
                                            <div class="multiselect-z2">
                                                <cf_multiselect_check 
                                                query_name="get_zones"  
                                                name="zone_id"
                                                option_value="ZONE_ID"
                                                option_name="ZONE_NAME"
                                                option_text="#getLang('main',322)#"
                                                value="#attributes.zone_id#">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-md-12"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></label>
                                        <div class="col col-12 col-md-12 col-xs-12">
                                            <div class="multiselect-z1">
                                                <cf_multiselect_check 
                                                query_name="get_pos_cats"  
                                                name="pos_cat_id"
                                                option_value="POSITION_CAT_ID"
                                                option_name="POSITION_CAT"
                                                option_text="#getLang('main',322)#"
                                                value="#attributes.pos_cat_id#">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                            <div class="col col-12 col-md-12 col-xs-12">
                                <div class="col col-12 col-md-12 col-xs-12">
                                    <div class="form-group">
                                        <label class="col col-12 col-md-12"><cf_get_lang dictionary_id='57571.Ünvan'></label>
                                        <div class="col col-12 col-md-12 col-xs-12">
                                            <div class="multiselect-z1">
                                                <cf_multiselect_check 
                                                query_name="get_titles"  
                                                name="title_id"
                                                option_value="TITLE_ID"
                                                option_name="TITLE"
                                                option_text="#getLang('main',322)#"
                                                value="#attributes.title_id#">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-md-12"><cf_get_lang dictionary_id='58701.Fonksiyon'></label>
                                        <div class="col col-12 col-md-12 col-xs-12">
                                            <div class="multiselect-z1">
                                                <cf_multiselect_check 
                                                query_name="get_units"  
                                                name="func_id"
                                                option_value="UNIT_ID"
                                                option_name="UNIT_NAME"
                                                option_text="#getLang('main',322)#"
                                                value="#attributes.func_id#">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='50669.Kriter'></label>
                                        <div class="col col-12 col-md-12 col-xs-12">
                                            <select name="inout_statue" id="inout_statue">
                                                <option value=""><cf_get_lang dictionary_id='55904.Giriş ve Çıkışlar'></option>
                                                <option value="1"<cfif attributes.inout_statue eq 1> selected</cfif>><cf_get_lang dictionary_id='58535.Girişler'></option>
                                                <option value="0"<cfif attributes.inout_statue eq 0> selected</cfif>><cf_get_lang dictionary_id='58536.Çıkışlar'></option>
                                                <option value="2"<cfif attributes.inout_statue eq 2> selected</cfif>><cf_get_lang dictionary_id='55905.Aktif Çalışanlar'></option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='50669.Kriter'><cf_get_lang dictionary_id='58690.Tarih Aralığı'></label>
                                        <div class="col col-6 col-md-6">
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
                                        <div class="col col-6 col-md-6">
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
                                    <div class="form-group">
                                        <label><input type="checkbox" name="is_not_in_out" id="is_not_in_out" value="1" <cfif attributes.is_not_in_out eq 1>checked</cfif>><cf_get_lang dictionary_id='60660.Ücret kartı olmayanlar da gelsin'></label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row ReportContentBorder">
                    <div class="ReportContentFooter">
                        <label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" message="#message#" maxlength="3" style="width:25px;">
                        <cfelse>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
                        </cfif>
                        <input name="is_form_submit" id="is_form_submit" value="1" type="hidden">
                        <cf_wrk_report_search_button  button_type='1' is_excel='1' search_function="control()">
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
	<cfcontent type="application/vnd.msexcel;charset=utf-8">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cfelse>
	<cfset type_ = 0>
</cfif>
<cfif isdefined("attributes.is_form_submit")>
    <cf_report_list>
        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
            <cfset type_ = 1>
        <cfelse>
            <cfset type_ = 0>
        </cfif>
        <thead>
            <tr>
                <th><cf_get_lang dictionary_id='57487.No'></th>
                <th><cf_get_lang dictionary_id='58025.TC Kimlik No'></th>
                <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
                <th><cf_get_lang dictionary_id='57480.Konu'></th>
                <th><cf_get_lang dictionary_id='57630.Tip'></th>
                <th><cf_get_lang dictionary_id='41644.İşlemi Yapan'></th>
                <th><cf_get_lang dictionary_id='57879.İşlem Tarihi'></th>
                <cfif attributes.report_type eq 0>
                    <th><cf_get_lang dictionary_id='58772.İşlem No'></th>
                </cfif>
                <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                <th><cf_get_lang dictionary_id='51231.Sicil No'></th>
                <th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
                <th><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th>
                <cfif attributes.report_type eq 0>
                    <th><cf_get_lang dictionary_id='55257.Savunma'></th>
                </cfif>
            <tr>
        </thead>
        <tbody>
            <cfif get_data.recordcount>
                <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                    <cfset attributes.startrow=1>
                    <cfset attributes.maxrows = get_data.recordcount>
                </cfif>
                <cfoutput query="get_data" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>#currentrow#</td>
                        <td>#tc_identy_no#</td>
                        <td><cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');" class="tableyazi">#employee_name# #employee_surname#</a><cfelse>#employee_name# #employee_surname#</cfif></td>
                        <td>
                            <cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                                <cfif attributes.report_type eq 0>
                                    <a href="#request.self#?fuseaction=ehesap.list_caution&event=upd&caution_id=#id#" target="blank_" class="tableyazi">#head#</a>
                                <cfelse>
                                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.list_prizes&event=upd&prize_id=#id#','small')" class="tableyazi">#head#</a>
                                </cfif>
                            <cfelse>
                                #head#
                            </cfif>
                        </td>
                        <td>#type#</td>
                        <td>#warner_name#</td>
                        <td>#dateformat(date,dateformat_style)#</td>
                        <cfif attributes.report_type eq 0>
                            <td>#decision_no#</td>
                        </cfif>
                        <td>#detail#</td>
                        <td>#employee_no#</td>
                        <td>#position_cat#</td>
                        <td>#position_name#</td>
                        <cfif attributes.report_type eq 0>
                            <td>#apology#</td>
                        </cfif>
                    </tr>
                </cfoutput>
                <cfelse>
                <tr>
                    <td colspan="10"><cfif isdefined('attributes.is_form_submit')><cf_get_lang dictionary_id='57484.kayıt yok'><cfelse><cf_get_lang dictionary_id ='57701.Filtre Ediniz'></cfif>!</td>
                </tr>
            </cfif>
        </tbody>
    </cf_report_list>
</cfif>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfset url_str = "report.caution_prize_report">
	<cfif isdefined('attributes.is_form_submit')>
		<cfset url_str = '#url_str#&is_form_submit=1'>
    </cfif>
    <cfif len('attributes.keyword')>
		<cfset url_str = '#url_str#&keyword=#attributes.keyword#'>
    </cfif>
    <cfif len('attributes.report_type')>
		<cfset url_str = '#url_str#&report_type=#attributes.report_type#'>
    </cfif>
    <cfif len('attributes.comp_id')>
		<cfset url_str = '#url_str#&comp_id=#attributes.comp_id#'>
    </cfif>
    <cfif len('attributes.zone_id')>
		<cfset url_str = '#url_str#&zone_id=#attributes.zone_id#'>
    </cfif>
    <cfif len('attributes.branch_id')>
		<cfset url_str = '#url_str#&branch_id=#attributes.branch_id#'>
    </cfif>
    <cfif len('attributes.department')>
		<cfset url_str = '#url_str#&department=#attributes.department#'>
    </cfif>
    <cfif len('attributes.pos_cat_id')>
		<cfset url_str = '#url_str#&pos_cat_id=#attributes.pos_cat_id#'>
    </cfif>
    <cfif len('attributes.title_id')>
		<cfset url_str = '#url_str#&title_id=#attributes.title_id#'>
    </cfif>
    <cfif len('attributes.func_id')>
		<cfset url_str = '#url_str#&func_id=#attributes.func_id#'>
    </cfif>
    <cfif len('attributes.is_not_in_out')>
		<cfset url_str = '#url_str#&is_not_in_out=#attributes.is_not_in_out#'>
    </cfif>
    <cfif len(attributes.start_date) and isdate(attributes.start_date)>
		<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
    </cfif>
    <cfif len(attributes.finish_date) and isdate(attributes.finish_date)>
        <cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
    </cfif>
    <cfif len(attributes.inout_statue)>
		<cfset url_str = "#url_str#&inout_statue=#attributes.inout_statue#">
    </cfif>
    <cfif len(attributes.startdate) and isdate(attributes.startdate)>
		<cfset url_str = "#url_str#&startdate=#dateformat(attributes.startdate,dateformat_style)#">
    </cfif>
    <cfif len(attributes.finishdate) and isdate(attributes.finishdate)>
        <cfset url_str = "#url_str#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#">
    </cfif>
    <cfif len(attributes.caution_type_id)>
		<cfset url_str = "#url_str#&caution_type_id=#attributes.caution_type_id#">
    </cfif>
    <cfif len(attributes.prize_type_id)>
		<cfset url_str = "#url_str#&prize_type_id=#attributes.prize_type_id#">
    </cfif>
        <cf_paging 
        page="#attributes.page#" 
        maxrows="#attributes.maxrows#" 
        totalrecords="#attributes.totalrecords#" 
        startrow="#attributes.startrow#" 
        adres="#url_str#">
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
	function get_department_list(gelen)
	{
		checkedValues_b = $("#branch_id").multiselect("getChecked");
		var branch_id_list='';
		for(kk=0;kk<checkedValues_b.length; kk++)
		{
			if(branch_id_list == '')
				branch_id_list = checkedValues_b[kk].value;
			else
				branch_id_list = branch_id_list + ',' + checkedValues_b[kk].value;
		}
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=department&branch_id="+branch_id_list;
		AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
	}
    $(document).ready(function(e){
		tipGoster();
	});
	function tipGoster()
	{   
		if (document.getElementById('report_type').value == 0)
		{
			document.getElementById('caution_type_id').style.display = '';
			document.getElementById('prize_type_id').style.display = 'none';
			document.getElementById('prize_type_id').value = '';
		}
		else if (document.getElementById('report_type').value == 1)
		{
			document.getElementById('caution_type_id').style.display = 'none';
			document.getElementById('prize_type_id').style.display = '';
			document.getElementById('caution_type_id').value = '';
		}
	}
    function control()	
	{
        if(!date_check(search_form.start_date,search_form.finish_date,"<cf_get_lang dictionary_id ='40310.Başlama Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!")){
                    return false;
                }
        if(!date_check(search_form.startdate,search_form.finishdate,"<cf_get_lang dictionary_id ='40310.Başlama Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!")){
                    return false;
                }
        if(document.search_form.is_excel.checked==false)
        {
            document.search_form.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
            return true;
        }
        else
            document.search_form.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_caution_prize_report</cfoutput>"
    }
</script>