<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Göksenin Sönmez Özkorucu		
Analys Date : 01/04/2016			Dev Date	: 20/05/2016		
Description :
	Bu component işyeri denetim işlemleri objesine ait CRUD ve list fonksiyonlarını gerceklestirir.
----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	
    <!--- list --->
    <cffunction name="list" access="public" returntype="query">
    	<cfargument name="keyword" type="string" default="" required="no" hint="Filtre : Şube Adı veya Denetleyende arama yapar">
    	<cfargument name="startdate" type="string" default="" required="no" hint="Başlangıç Tarihi">
        <cfargument name="finishdate" type="string" default="" required="no" hint="Bitiş Tarihi">
        <cfargument name="audit_type" type="string" default="" required="no" hint="Denetim tipi : İç - Dış">
        <cfargument name="branch_id" type="string" default="" required="no" hint="Denetlenen Şube ID'si">
        <cfargument name="department" type="string" default="" required="no" hint="Denetlenen Departman ID'si">
        <cfquery name="list" datasource="#DSN#">
            SELECT 
                AU.*,
                BR.BRANCH_NAME,
                D.DEPARTMENT_HEAD
            FROM 
                EMPLOYEES_AUDIT AS AU INNER JOIN BRANCH AS BR 
                ON BR.BRANCH_ID = AU.AUDIT_BRANCH_ID
                LEFT JOIN DEPARTMENT D ON AU.AUDIT_DEPARTMENT_ID = D.DEPARTMENT_ID
            WHERE
                1=1
                <cfif len(arguments.keyword)>
                	AND (BR.BRANCH_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR AU.AUDITOR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)
                </cfif>
                <cfif len(arguments.startdate)>
                	AND AU.AUDIT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#">
                </cfif>
                <cfif len(arguments.finishdate)>
                	AND AU.AUDIT_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finishdate#">
                </cfif>
                <cfif len(arguments.audit_type)>
                	AND AU.AUDIT_TYPE = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.audit_type#">
                </cfif>
                <cfif len(arguments.branch_id)>
                	AND BR.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">
                </cfif>
                <cfif len(arguments.department)>
                	AND D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department#">
                </cfif>
            ORDER BY
                AUDIT_DATE DESC
        </cfquery>
        <cfreturn list>
    </cffunction>
    <!--- list --->
    
    <!--- get --->
    <cffunction name="get" access="public" returntype="query">
    	<cfargument name="audit_id" type="numeric" default="0" required="yes" hint="Denetleme ID'si">
        
		<cfquery name="get" datasource="#DSN#">
			SELECT
            	AUDIT_BRANCH_ID,
                AUDIT_DATE,
                AUDIT_DEPARTMENT_ID,
                AUDIT_DETAIL,
                AUDIT_MISSINGS,
                AUDIT_RECHECK_DATE,
                AUDIT_RESULT,
                AUDIT_TYPE,
                AUDITOR,
                AUDITOR_POSITION,
                PUNISHMENT_MONEY,
                PUNISHMENT_MONEY_TYPE,
                RECORD_DATE,
				RECORD_EMP,
                TERM_DATE,
                UPDATE_DATE,
                UPDATE_EMP
			FROM 
				EMPLOYEES_AUDIT
			WHERE
				AUDIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.audit_id#">
		</cfquery>
        <cfreturn get>
    </cffunction>
    
    <!--- add --->
    <cffunction name="add" access="public" returntype="string">
    	<cfargument name="audit_branch_id" type="numeric" default="0" required="yes" hint="Denetlenen Şube ID">
        <cfargument name="department" type="numeric" default="0" required="yes" hint="Denetlenen Departman ID">
        <cfargument name="audit_date" type="string" required="yes" hint="Denetleme Tarihi">
        <cfargument name="auditor" type="string" required="yes" hint="Denetleyen">
        <cfargument name="audit_type" type="boolean" default="1" required="yes" hint="Denetim tipi : İç - Dış">
        <cfargument name="auditor_position" type="string" required="yes" hint="Denetleyen Pozisyonu">
        <cfargument name="audit_missings" type="string" required="no" hint="Görülen Eksikler">
        <cfargument name="audit_recheck_date" type="string" required="no" hint="Eksik Giderilme Tarihi">
        <cfargument name="audit_detail" type="string" required="no" hint="Açıklama">
        <cfargument name="audit_result" type="string" required="no" hint="Sonuç">
        <cfargument name="punishment_money" type="any" required="no" hint="Para Cezası Tutar">
        <cfargument name="punishment_money_type" type="string" required="no" hint="Para Cezası Para Birimi">
        <cfargument name="term_date" type="string" required="no" hint="Vade Tarihi">
        
    	<cfquery name="ADD_AUDIT" datasource="#dsn#" result="MAX_ID">
            INSERT INTO
                EMPLOYEES_AUDIT
                (
                    AUDIT_BRANCH_ID,
                    AUDIT_DEPARTMENT_ID,
                    AUDIT_DATE,
                    AUDITOR,
                    AUDIT_TYPE,
                    AUDITOR_POSITION,
                    AUDIT_MISSINGS,
                    AUDIT_RECHECK_DATE,
                    AUDIT_DETAIL,
                    AUDIT_RESULT,
                    PUNISHMENT_MONEY,
                    PUNISHMENT_MONEY_TYPE,
                    TERM_DATE,
                    RECORD_EMP,
                    RECORD_IP,
                    RECORD_DATE
                )
            VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.audit_branch_id#">,
                    <cfif arguments.department neq 0><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.audit_date#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.auditor#">,
                    <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.audit_type#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.auditor_position#">,
                    <cfif len(arguments.audit_missings)>'#arguments.audit_missings#'<cfelse>NULL</cfif>,
                    <cfif len(arguments.audit_recheck_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.audit_recheck_date#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.audit_detail)>'#arguments.audit_detail#'<cfelse>NULL</cfif>,
                    <cfif len(arguments.audit_result)>'#arguments.audit_result#'<cfelse>NULL</cfif>,
                    <cfif len(arguments.punishment_money)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.punishment_money#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.punishment_money_type#">,
                    <cfif len(arguments.term_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.term_date#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                )
        </cfquery>
        <cfreturn MAX_ID.IDENTITYCOL>
    </cffunction>
    
    <!--- upd --->
    <cffunction name="upd" access="public" returntype="string">
    	<cfargument name="audit_id" type="numeric" default="0" required="yes" hint="Denetleme ID'si">
    	<cfargument name="audit_branch_id" type="numeric" default="0" required="yes" hint="Denetlenen Şube ID">
        <cfargument name="department" type="numeric" default="0" required="yes" hint="Denetlenen Departman ID">
        <cfargument name="audit_date" type="string" required="yes" hint="Denetleme Tarihi">
        <cfargument name="auditor" type="string" required="yes" hint="Denetleyen">
        <cfargument name="audit_type" type="boolean" default="1" required="yes" hint="Denetim tipi : İç - Dış">
        <cfargument name="auditor_position" type="string" required="yes" hint="Denetleyen Pozisyonu">
        <cfargument name="audit_missings" type="string" required="no" hint="Görülen Eksikler">
        <cfargument name="audit_recheck_date" type="string" required="no" hint="Eksik Giderilme Tarihi">
        <cfargument name="audit_detail" type="string" required="no" hint="Açıklama">
        <cfargument name="audit_result" type="string" required="no" hint="Sonuç">
        <cfargument name="punishment_money" type="any" required="no" hint="Para Cezası Tutar">
        <cfargument name="punishment_money_type" type="string" required="no" hint="Para Cezası Para Birimi">
        <cfargument name="term_date" type="string" required="no" hint="Vade Tarihi">
        
        <cfquery name="UPD_AUDIT" datasource="#dsn#">
            UPDATE
            	EMPLOYEES_AUDIT
            SET
                AUDIT_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.audit_branch_id#">,
                AUDIT_DEPARTMENT_ID = <cfif arguments.department neq 0><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department#"><cfelse>NULL</cfif>,
                AUDIT_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.audit_date#">,
                AUDITOR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.auditor#">,
                AUDIT_TYPE = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.audit_type#">,
                AUDITOR_POSITION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.auditor_position#">,
                AUDIT_MISSINGS = <cfif len(arguments.audit_missings)> '#arguments.audit_missings#'<cfelse>NULL</cfif>,
                AUDIT_RECHECK_DATE = <cfif len(arguments.audit_recheck_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.audit_recheck_date#"><cfelse>NULL</cfif>,
                AUDIT_DETAIL = <cfif len(arguments.audit_detail)> '#arguments.audit_detail#'<cfelse>NULL</cfif>,
                AUDIT_RESULT = <cfif len(arguments.audit_result)> '#arguments.audit_result#'<cfelse>NULL</cfif>,
                PUNISHMENT_MONEY = <cfif len(arguments.punishment_money)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.punishment_money#"><cfelse>NULL</cfif>,
                PUNISHMENT_MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.punishment_money_type#">,
                TERM_DATE = <cfif len(arguments.term_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.term_date#"><cfelse>NULL</cfif>,
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
            WHERE
            	AUDIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.audit_id#">
        </cfquery>
        <cfreturn arguments.audit_id>
    </cffunction>
    
    <!--- del --->
    <cffunction name="del" access="public" returntype="boolean">
    	<cfargument name="audit_id" type="numeric" default="0" required="yes" hint="Denetleme ID'si">
        
        <cfquery name="DEL_AUDIT" datasource="#dsn#">
            DELETE FROM
                EMPLOYEES_AUDIT
            WHERE
                AUDIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.audit_id#">
        </cfquery>
        <cfreturn true>
    </cffunction>
</cfcomponent>