<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Emin Yaşartürk			Developer	: Emin Yaşartürk		
Analys Date : 27/05/2016				Dev Date	: 27/05/2016		
Description :
	Bu component oryantasyon eğitimi objesine ait CRUD ve list fonksiyonlarını gerceklestirir.
----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    
    <!--- list, get --->
	<cffunction name="get" access="public" returntype="query">
        <cfargument name="keyword" type="string" default="" required="no" hint="Filtre Alanı">
		<cfargument name="startdate" type="string" default="" required="no" hint="Başlangıç Tarihi">
        <cfargument name="finishdate" type="string" default="" required="no" hint="Bitiş Tarihi">
        <cfargument name="orientationId" type="numeric" default="0" required="yes" hint="Oryantasyon Eğitimi ID; Liste sayfasında 0 olarak gönderilir.">
        <cfquery name="GET_ORIENTATION" datasource="#DSN#">
            SELECT 
                ORIENTATION_ID,
                ORIENTATION_HEAD,
                DETAIL,
                START_DATE,
                FINISH_DATE,
                ATTENDER_EMP,
                TRAINER_EMP,
                IS_ABSENT,
                RECORD_EMP,
                RECORD_DATE,
                UPDATE_EMP,
                UPDATE_DATE,
                UPDATE_IP
            FROM
                TRAINING_ORIENTATION
            WHERE
                ORIENTATION_ID <cfif arguments.orientationId neq 0>= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.orientationId#"><cfelse>>0</cfif>
                <cfif len(arguments.startdate) and len(arguments.finishdate)>
                    AND
                    (
                        START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#"> AND
                        FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finishdate#">
                    )
                <cfelseif len(arguments.startdate) and not len(arguments.finishdate)>
                    AND  START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#">
                <cfelseif not len(arguments.startdate) and len(arguments.finishdate)>
                    AND FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finishdate#"> 
                </cfif>
                <cfif len(arguments.keyword)>
                    AND ORIENTATION_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                </cfif>
        </cfquery>
		<cfreturn GET_ORIENTATION>
	</cffunction>
    
    <!--- add --->
	<cffunction name="add" access="public" returntype="numeric">
        <cfargument name="orientation_head" type="string" default="" required="yes" hint="Oryantasyon Eğitim Adı">
		<cfargument name="detail" type="string" default="" required="no" hint="Açıklama">
        <cfargument name="start_date" type="string" default="" required="yes" hint="Başlangıç Tarihi">
        <cfargument name="finish_date" type="numeric" default="" required="yes" hint="Bitiş Tarihi">
        <cfargument name="emp_id" type="numeric" default="0" required="yes" hint="Sorumlu ID">
		<cfargument name="emp_name" type="string" default="" required="yes" hint="Sorumlu Adı">
        <cfargument name="trainer_emp_id" type="string" default="" required="no" hint="Katılımcı ID">
        <cfargument name="trainer_emp_name" type="string" default="" required="no" hint="Katılımcı Adı">
        
        <cfquery name="ADD_ORIENTATION" datasource="#DSN#" result="MAX_ID">
            INSERT INTO
                TRAINING_ORIENTATION
            (
                ORIENTATION_HEAD,
                DETAIL,
                START_DATE,
                FINISH_DATE,
                ATTENDER_EMP,
                TRAINER_EMP,
                RECORD_DATE,
                RECORD_IP,
                RECORD_EMP
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.orientation_head#">,
                <cfif len(detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail#"><cfelse>NULL</cfif>,
                <cfif len(start_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"><cfelse>NULL</cfif> ,
                <cfif len(finish_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#"><cfelse>NULL</cfif>,
                <cfif len(emp_id) and len(emp_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.emp_id#"><cfelse>NULL</cfif>,
                <cfif len(trainer_emp_id) and len(trainer_emp_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.trainer_emp_id#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
            )
        </cfquery>
		<cfreturn MAX_ID.IDENTITYCOL>
	</cffunction>
    
    <!--- upd --->
	<cffunction name="upd" access="public" returntype="numeric">
        <cfargument name="orientation_head" type="string" default="" required="yes" hint="Oryantasyon Eğitim Adı">
		<cfargument name="detail" type="string" default="" required="no" hint="Açıklama">
        <cfargument name="start_date" type="string" default="" required="yes" hint="Başlangıç Tarihi">
        <cfargument name="finish_date" type="numeric" default="" required="yes" hint="Bitiş Tarihi">
        <cfargument name="emp_id" type="numeric" default="0" required="yes" hint="Sorumlu ID">
		<cfargument name="emp_name" type="string" default="" required="yes" hint="Sorumlu Adı">
        <cfargument name="trainer_emp_id" type="string" default="0" required="yes" hint="Katılımcı ID">
        <cfargument name="trainer_emp_name" type="string" default="" required="yes" hint="Katılımcı Adı">
        <cfargument name="orientation_id" type="numeric" default="0" required="yes" hint="Oryantasyon ID">
        
        <cfquery name="UPD_ORIENTATION" datasource="#DSN#">
            UPDATE 
                TRAINING_ORIENTATION
            SET
                ORIENTATION_HEAD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.orientation_head#">,
                DETAIL = <cfif len(detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail#"><cfelse>NULL</cfif>,
                ATTENDER_EMP = <cfif len(emp_id) and len(emp_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.emp_id#"><cfelse>NULL</cfif>,
                TRAINER_EMP = <cfif len(trainer_emp_id) and len(trainer_emp_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.trainer_emp_id#"><cfelse>NULL</cfif>,
                START_DATE = <cfif len(start_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"><cfelse>NULL</cfif>,
                FINISH_DATE = <cfif len(finish_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#"><cfelse>NULL</cfif>,
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
            WHERE
                ORIENTATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.orientation_id#"> 
        </cfquery>
		<cfreturn arguments.orientation_id>
	</cffunction>
    
    <!--- del --->
	<cffunction name="del" access="public" returntype="numeric">
        <cfargument name="orientation_id" type="numeric" default="0" required="yes" hint="Oryantasyon ID">
        
        <cfquery name="UPD_ORIENTATION" datasource="#DSN#">
            DELETE FROM TRAINING_ORIENTATION WHERE ORIENTATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.orientation_id#">
        </cfquery>
		<cfreturn arguments.orientation_id>
	</cffunction>
</cfcomponent>