<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Göksenin Sönmez Özkorucu		
Analys Date : 01/04/2016			Dev Date	: 23/05/2016		
Description :
	Bu component hedefler objesine ait CRUD ve list fonksiyonlarını gerceklestirir.
----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    
    <!--- list --->
    <cffunction name="list" access="public" returntype="query">
    	<cfargument name="keyword" type="string" default="" required="no" hint="Keyword; hedef, çalışan adı ve soyadına göre arama yapar">
    	<cfargument name="departmentId" type="numeric" default="0" required="no" hint="Departman ID">
        <cfargument name="branchId" type="numeric" default="0" required="no" hint="Şube ID">
        <cfargument name="targetCatId" type="numeric" default="0" required="no" hint="Kategori ID">
        <cfargument name="positionCode" type="numeric" default="0" required="no" hint="Pozisyon Kodu">
        <cfargument name="startDate" type="string" default="" required="no" hint="Gönderilen tarihten sonraki hedefleri getirir">
        <cfargument name="finishDate" type="string" default="" required="no" hint="Gönderilen tarihten önceki hedefleri getirir">
        <cfargument name="authorizationControl" type="numeric" default="0" required="no" hint="Şube Yetki Kontrolü">
    	<cfquery name="GET_TARGETS" datasource="#dsn#">
            SELECT 
                TARGET.TARGET_ID,
                TARGET.POSITION_CODE,
                TARGET.STARTDATE,
                TARGET.FINISHDATE,
                TARGET.TARGET_HEAD,
                TARGET.TARGET_NUMBER,
                TARGET.TARGETCAT_ID,
                EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
                EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
                EMPLOYEE_POSITIONS.EMPLOYEE_ID,
                TARGET_CAT.TARGETCAT_NAME,
                TARGET.TARGET_EMP,
                TARGET.RECORD_EMP,
                TARGET.TARGET_WEIGHT,
                E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS EMP_NAME
            FROM 
                TARGET
                INNER JOIN TARGET_CAT ON TARGET_CAT.TARGETCAT_ID = TARGET.TARGETCAT_ID
                INNER JOIN EMPLOYEE_POSITIONS ON EMPLOYEE_POSITIONS.POSITION_CODE = TARGET.POSITION_CODE
                INNER JOIN DEPARTMENT ON EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
                INNER JOIN BRANCH ON DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
                INNER JOIN OUR_COMPANY ON BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
                LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID = TARGET.TARGET_EMP
            WHERE
                TARGET.POSITION_CODE IS NOT NULL
                <cfif len(arguments.departmentId) and arguments.departmentId neq 0>
                	AND DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.departmentId#">
                </cfif>
                <cfif len(arguments.branchId) and arguments.branchId neq 0>
                	AND DEPARTMENT.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branchId#">
                </cfif>
                <cfif len(arguments.positionCode) and arguments.positionCode neq 0>
                	AND TARGET.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.positionCode#">
                </cfif>
                <cfif len(arguments.keyword)>
                	AND (TARGET.TARGET_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR EMPLOYEE_POSITIONS.EMPLOYEE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)
                </cfif>
                <cfif len(arguments.targetCatId) and arguments.targetCatId neq 0>AND TARGET.TARGETCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.targetCatId#"></cfif>
                <cfif len(arguments.startDate)>AND STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startDate#"></cfif>
                <cfif len(arguments.finishDate)>AND FINISHDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finishDate#"></cfif>
                <cfif authorizationControl neq 0>
                	AND DEPARTMENT.BRANCH_ID IN (
                                    SELECT
                                        BRANCH_ID
                                    FROM
                                        EMPLOYEE_POSITION_BRANCHES
                                    WHERE
                                        POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
                                )
                </cfif>
            ORDER BY TARGET.STARTDATE DESC
        </cfquery>
		<cfreturn GET_TARGETS>
    </cffunction>
    
    <!--- get --->
    <cffunction name="get" access="public" returntype="query">
    	<cfargument name="targetId" type="numeric" default="" required="yes" hint="Hedef ID">
    	<cfquery name="GET_TARGET" datasource="#dsn#">
            SELECT
            	T.CALCULATION_TYPE,
            	T.FINISHDATE,
                T.OTHER_DATE1,
                T.OTHER_DATE2,
            	T.PER_ID,
                T.RECORD_DATE,
                T.RECORD_EMP,
                T.STARTDATE,
                T.SUGGESTED_BUDGET,
                T.TARGET_DETAIL,
                T.TARGET_EMP,
                T.TARGET_HEAD,
                T.TARGET_ID,
                T.TARGET_MONEY,
                T.TARGET_NUMBER,
                T.TARGET_WEIGHT,
                T.TARGETCAT_ID,
                T.UPDATE_DATE,
                T.UPDATE_EMP
            FROM 
                TARGET T 
            WHERE 
                T.TARGET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.targetId#">
        </cfquery>
		<cfreturn GET_TARGET>
    </cffunction>
    
    <!--- add --->
    <cffunction name="add" access="public" returntype="string">
    	<cfargument name="perId" type="numeric" default="0" required="no" hint="Performans Form ID">
        <cfargument name="positionCode" type="numeric" default="0" required="no" hint="Çalışan Pozisyon Kodu">
        <cfargument name="empId" type="numeric" default="0" required="no" hint="Çalışan ID">
        <cfargument name="targetCatId" type="numeric" default="0" required="yes" hint="Hedef Kategorisi ID">
        <cfargument name="startDate" type="string" default="" required="yes" hint="Başlangıç Tarihi">
        <cfargument name="finishDate" type="string" default="" required="yes" hint="Bitiş Tarihi">
        <cfargument name="targetHead" type="string" default="" required="yes" hint="Hedef">
        <cfargument name="targetNumber" type="string" default="" required="no" hint="Rakam">
        <cfargument name="targetDetail" type="string" default="" required="no" hint="Açıklama">
        <cfargument name="calculationType" type="numeric" default="0" required="no" hint="Hesaplama Tipi">
        <cfargument name="suggestedBudget" type="string" default="" required="no" hint="Ayrılan Bütçe">
        <cfargument name="moneyType" type="string" default="" required="no" hint="Para Birimi">
        <cfargument name="targetEmpId" type="numeric" default="0" required="no" hint="Hedef Veren Çalışan ID">
        <cfargument name="targetWeight" type="string" default="" required="yes" hint="Ağırlık">
        <cfargument name="otherDate1" type="string" default="" required="no" hint="Ara Görüşme Tarihi 1">
        <cfargument name="otherDate2" type="string" default="" required="no" hint="Ara Görüşme Tarihi 2">
        
		<cfif len(arguments.perId) and arguments.perId>
            <cfquery name="upd_perform" datasource="#dsn#">
                UPDATE
                    EMPLOYEE_PERFORMANCE_TARGET
                SET
                    FIRST_BOSS_VALID_FORM = NULL,
                    FIRST_BOSS_VALID_DATE_FORM = NULL,
                    SECOND_BOSS_VALID_FORM = NULL,
                    SECOND_BOSS_VALID_DATE_FORM = NULL,
                    THIRD_BOSS_VALID_FORM = NULL,
                    THIRD_BOSS_VALID_DATE_FORM = NULL,
                    FOURTH_BOSS_VALID_FORM = NULL,
                    FOURTH_BOSS_VALID_DATE_FORM = NULL,
                    FIFTH_BOSS_VALID_FORM = NULL,
                    FIFTH_BOSS_VALID_DATE_FORM = NULL,
                    UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                WHERE
                    PER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.per_id#">
            </cfquery>
        </cfif>
        <cfquery name="ADD_TARGET" datasource="#dsn#" result="MAX_ID">
            INSERT INTO 
                TARGET
            (
                RECORD_EMP,
                RECORD_IP,
                PER_ID,
                POSITION_CODE,
                EMP_ID,
                TARGETCAT_ID,
                STARTDATE,
                FINISHDATE,
                TARGET_HEAD,
                TARGET_NUMBER,
                TARGET_DETAIL,
                SUGGESTED_BUDGET,
                CALCULATION_TYPE,
                TARGET_EMP,
                TARGET_WEIGHT,
                OTHER_DATE1,
                OTHER_DATE2,
                TARGET_MONEY
            )
            VALUES 
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                <cfif len(arguments.perId) and arguments.perId neq 0><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.perId#"><cfelse>NULL</cfif>,
                <cfif len(arguments.positionCode) and arguments.positionCode neq 0><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.positionCode#"><cfelse>NULL</cfif>,
                <cfif len(arguments.empId) and arguments.empId neq 0><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.empId#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.targetCatId#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startDate#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finishDate#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.targetHead#">,
                <cfif len(arguments.targetNumber)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.targetNumber#"><cfelse>NULL</cfif>,
                '#arguments.targetDetail#',
                <cfif len(arguments.suggestedBudget)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.suggestedBudget#"><cfelse>NULL</cfif>,
                <cfif len(arguments.calculationType) and arguments.calculationType neq 0><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.calculationType#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.targetEmpId#">,
                <cfif len(arguments.targetWeight)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.targetWeight#"><cfelse>0</cfif>,
                <cfif len(arguments.otherDate1)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.otherDate1#"><cfelse>NULL</cfif>,
                <cfif len(arguments.otherDate2)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.otherDate2#"><cfelse>NULL</cfif>,
                <cfif len(arguments.moneyType)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moneyType#"><cfelse>NULL</cfif>
            )
        </cfquery>
        <cfreturn MAX_ID.IDENTITYCOL>
    </cffunction>
    
    <!--- upd --->
    <cffunction name="upd" access="public" returntype="string">
    	<cfargument name="positionCode" type="numeric" default="0" required="no" hint="Çalışan Pozisyon Kodu">
        <cfargument name="targetCatId" type="numeric" default="0" required="yes" hint="Hedef Kategorisi ID">
        <cfargument name="startDate" type="string" default="" required="yes" hint="Başlangıç Tarihi">
        <cfargument name="finishDate" type="string" default="" required="yes" hint="Bitiş Tarihi">
        <cfargument name="targetHead" type="string" default="" required="yes" hint="Hedef">
        <cfargument name="targetNumber" type="string" default="" required="no" hint="Rakam">
        <cfargument name="targetDetail" type="string" default="" required="no" hint="Açıklama">
        <cfargument name="calculationType" type="numeric" default="0" required="no" hint="Hesaplama Tipi">
        <cfargument name="suggestedBudget" type="string" default="" required="no" hint="Ayrılan Bütçe">
        <cfargument name="moneyType" type="string" default="" required="no" hint="Para Birimi">
        <cfargument name="targetEmpId" type="numeric" default="#session.ep.userid#" required="no" hint="Hedef Veren Çalışan ID">
        <cfargument name="targetWeight" type="string" default="0" required="yes" hint="Ağırlık">
        <cfargument name="otherDate1" type="string" default="" required="no" hint="Ara Görüşme Tarihi 1">
        <cfargument name="otherDate2" type="string" default="" required="no" hint="Ara Görüşme Tarihi 2">
        <cfargument name="targetId" type="numeric" default="" required="yes" hint="Hedef ID">
        <cfargument name="perId" type="numeric" default="0" required="no" hint="Performans Form ID">
        
    	<cfquery name="UPP_TARGET" datasource="#dsn#">
            UPDATE 
                TARGET
            SET 
                <cfif len(arguments.positionCode) and arguments.positionCode neq 0>
                	POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.positionCode#">,
                </cfif>
                TARGETCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.targetCatId#">,
                STARTDATE = <cfif len(arguments.startDate) and isdate(arguments.startDate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startDate#"><cfelse>NULL</cfif>,
                FINISHDATE = <cfif len(arguments.finishDate) and isdate(arguments.finishDate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finishDate#"><cfelse>NULL</cfif>,
                TARGET_HEAD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.targetHead#">,
                TARGET_NUMBER = <cfif len(arguments.targetNumber)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.targetNumber#"><cfelse>NULL</cfif>,
                TARGET_DETAIL = '#arguments.targetDetail#',
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                CALCULATION_TYPE = <cfif len(arguments.calculationType)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.calculationType#"><cfelse>NULL</cfif>,
                SUGGESTED_BUDGET = <cfif len(arguments.suggestedBudget)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.suggestedBudget#"><cfelse>NULL</cfif>,
                TARGET_MONEY = <cfif len(arguments.moneyType)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moneyType#"><cfelse>NULL</cfif>,
                TARGET_EMP = <cfif len(arguments.targetEmpId)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.targetEmpId#"></cfif>,
                TARGET_WEIGHT = <cfif len(arguments.targetWeight)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.targetWeight#"></cfif>,
                OTHER_DATE1 = <cfif len(arguments.otherDate1)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.otherDate1#"><cfelse>NULL</cfif>,
                OTHER_DATE2 = <cfif len(arguments.otherDate2)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.otherDate2#"><cfelse>NULL</cfif>
            WHERE 
                TARGET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.targetId#">
        </cfquery>
        
        <!--- hedef yetkinlik formundan gelen guncelleme icin--->
		<cfif len(arguments.perId) and arguments.perId neq 0>
            <cfquery name="upd_perform" datasource="#dsn#">
                UPDATE
                    EMPLOYEE_PERFORMANCE_TARGET
                SET
                    FIRST_BOSS_VALID_FORM = NULL,
                    FIRST_BOSS_VALID_DATE_FORM = NULL,
                    SECOND_BOSS_VALID_FORM = NULL,
                    SECOND_BOSS_VALID_DATE_FORM = NULL,
                    THIRD_BOSS_VALID_FORM = NULL,
                    THIRD_BOSS_VALID_DATE_FORM = NULL,
                    FOURTH_BOSS_VALID_FORM = NULL,
                    FOURTH_BOSS_VALID_DATE_FORM = NULL,
                    FIFTH_BOSS_VALID_FORM = NULL,
                    FIFTH_BOSS_VALID_DATE_FORM = NULL,
                    UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                WHERE
                    PER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.perId#">
            </cfquery>
        </cfif>
        <!--- //hedef yetkinlik formundan gelen guncelleme icin--->
        <cfreturn arguments.targetId>
    </cffunction>
    
    <!--- del --->
    <cffunction name="del" access="public">
        <cfargument name="targetId" type="numeric" default="0" required="yes" hint="Hedef ID">
        <cfargument name="perId" type="numeric" default="0" required="no" hint="Performans Form ID">
        
        <cfquery name="DEL_TARGET" datasource="#dsn#">
            DELETE FROM TARGET WHERE TARGET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.targetId#">
        </cfquery>
        
        <!--- hedef yetkinlik formundan gelen silme icin--->
		<cfif len(arguments.perId)>
            <cfquery name="upd_perform" datasource="#dsn#">
                UPDATE
                    EMPLOYEE_PERFORMANCE_TARGET
                SET
                    FIRST_BOSS_VALID_FORM = NULL,
                    FIRST_BOSS_VALID_DATE_FORM = NULL,
                    SECOND_BOSS_VALID_FORM = NULL,
                    SECOND_BOSS_VALID_DATE_FORM = NULL,
                    THIRD_BOSS_VALID_FORM = NULL,
                    THIRD_BOSS_VALID_DATE_FORM = NULL,
                    FOURTH_BOSS_VALID_FORM = NULL,
                    FOURTH_BOSS_VALID_DATE_FORM = NULL,
                    FIFTH_BOSS_VALID_FORM = NULL,
                    FIFTH_BOSS_VALID_DATE_FORM = NULL,
                    UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                WHERE
                    PER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.perId#">
            </cfquery>
        </cfif>
        <!--- //hedef yetkinlik formundan gelen silme icin--->
        <cfreturn arguments.targetId>
    </cffunction>
    
    <!--- get total weight --->
    <cffunction name="get_total_weight" access="public" returntype="query">
    	<cfargument name="yearFinishDate" type="numeric" default="0" required="no" hint="Bitiş Tarihi Yılı">
        <cfargument name="yearStartDate" type="numeric" default="0" required="no" hint="Başlangıç Tarihi Yılı">
        <cfargument name="empId" type="numeric" default="0" required="no" hint="Çalışan ID">
        <cfargument name="positionCode" type="numeric" default="0" required="no" hint="Pozisyon Kodu">
        <cfargument name="targetId" type="numeric" default="0" required="no" hint="Hedef ID">
    	<cfquery name="get_total_target_weight" datasource="#dsn#">
            SELECT 
                SUM(TARGET_WEIGHT) AS TOTAL_WEIGHT
            FROM 
                TARGET 
            WHERE
            	1 = 1
                <cfif len(arguments.empId) and arguments.empId neq 0>
                    AND EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.empId#">
                </cfif>
                <cfif len(arguments.positionCode) and arguments.positionCode neq 0>
                    AND POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.positionCode#">
                </cfif>
                <cfif len(arguments.targetId) and arguments.targetId neq 0>
                	AND TARGET_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.targetId#">
                    AND YEAR(FINISHDATE) = (SELECT YEAR(FINISHDATE) FROM TARGET WHERE TARGET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.targetId#">)
            		AND YEAR(STARTDATE) = (SELECT YEAR(STARTDATE) FROM TARGET WHERE TARGET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.targetId#">)
               	<cfelse>
					<cfif len(arguments.yearFinishDate) and arguments.yearFinishDate neq 0>
                        AND YEAR(FINISHDATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.yearFinishDate#">
                    </cfif>
                    <cfif len(arguments.yearStartDate) and arguments.yearStartDate neq 0>
                        AND YEAR(STARTDATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.yearStartDate#">
                    </cfif>
                </cfif>
        </cfquery>
        <cfreturn get_total_target_weight>
    </cffunction>
</cfcomponent>