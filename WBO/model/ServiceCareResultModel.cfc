<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Semih Bozal	
Analys Date : 01/04/2016			Dev Date	: 25/05/2016		
Description :
	Bu component bakım planı sonucları ait CRUD ve list fonksiyonlarını gerceklestirir.
----------------------------------------------------------------------->

<cfcomponent>	
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cfset dsn3 = '#dsn#_#session.ep.company_id#'>
	<cfset server_machine = application.systemParam.systemParam().fusebox.server_machine>
    <cfset dir_seperator = application.systemParam.systemParam().dir_seperator>
    <cfset upload_folder = application.systemParam.systemParam().upload_folder>
    
	 <!--- list --->
	<cffunction name="list" access="public" returntype="query">    	
		<cfargument name="keyword" type="string" default="" required="no" hint="Keyword; konu,ürün,sirket numarasına göre arama yapar">  
        <cfargument name="service_care" type="string" default="" required="no" hint="Servis Bakım Tipi">
		<cfargument name="start_date" type="string" default="" required="no" hint="Servis Bakım Baslangıc Tarihi">      
     	<cfargument name="finish_date" type="string" default="" required="no" hint="Servis Bakım Bitis Tarihi">
        <cfargument name="task_employee_id" type="numeric" default="0" required="no" hint="Servis Calisani Id"> 
        <cfargument name="task_employee_id2" type="numeric" default="0" required="no" hint="Servis Calisani 2 Id">
        <cfargument name="product_id" type="numeric" default="0" required="no" hint="Urun Id">
        <cfargument name="company_id" type="numeric" default="0" required="no" hint="Company Id">  
        <cfargument name="consumer_id" type="numeric" default="0" required="no" hint="Consumer Id">
        <cfargument name="service_substatus_id" type="numeric" default="0" required="no" hint="Consumer Id">  
 		<cfquery name="GET_SERVICE_REPORT" datasource="#DSN3#">
            SELECT
                SCR.CARE_DATE,
                SCR.COMPANY_PARTNER_TYPE,
                SCR.COMPANY_PARTNER_ID,
                SCR.CARE_CAT,
                SCR.SERVICE_SUBSTATUS,
                SCR.CONTRACT_HEAD,
                SCR.SERIAL_NO,
                SCR.CARE_FINISH_DATE,
                SCR.CARE_REPORT_ID,
                P.PRODUCT_NAME,
                CP.PARTNER_ID,
                C.COMPANY_ID,
                C.FULLNAME,
                CONS.CONSUMER_ID,
                CONS.CONSUMER_NAME,
                CONS.CONSUMER_SURNAME,
                SS.SERVICE_SUBSTATUS SUBSTATUS,
                SS.SERVICE_SUBSTATUS_ID,
                SCC.SERVICE_CARE,
                SCC.SERVICE_CARECAT_ID
            FROM
                SERVICE_CARE_REPORT SCR
                LEFT JOIN PRODUCT P ON P.PRODUCT_ID = SCR.PRODUCT_ID
                LEFT JOIN #dsn#.COMPANY_PARTNER CP ON CP.PARTNER_ID = SCR.COMPANY_PARTNER_ID
                LEFT JOIN #dsn#.COMPANY C ON C.COMPANY_ID = CP.COMPANY_ID
                LEFT JOIN #dsn#.CONSUMER CONS ON CONS.CONSUMER_ID = SCR.COMPANY_PARTNER_ID
                LEFT JOIN SERVICE_SUBSTATUS SS ON SS.SERVICE_SUBSTATUS_ID = SCR.SERVICE_SUBSTATUS
                LEFT JOIN SERVICE_CARE_CAT SCC ON SCC.SERVICE_CARECAT_ID = SCR.CARE_CAT
            WHERE
                P.PRODUCT_ID=SCR.PRODUCT_ID
                <cfif len(arguments.keyword)>
                    AND (CONTRACT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR SERIAL_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR P.PRODUCT_NAME  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> )
                </cfif>
                <cfif len(arguments.service_care)>
                    AND SCR.CARE_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_care#">
                </cfif>
                <cfif len(arguments.start_date)>
                    AND SCR.CARE_DATE >= #arguments.start_date#
                </cfif>
                <cfif len(arguments.finish_date)>
                    AND SCR.CARE_DATE <= #arguments.finish_date#
                </cfif>
                <cfif arguments.task_employee_id neq 0>
                    AND	SCR.EMPLOYEE1_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.task_employee_id#">
                </cfif>
                <cfif arguments.task_employee_id2 neq 0>
                    AND	SCR.EMPLOYEE2_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.task_employee_id2#">
                </cfif>
                <cfif arguments.product_id neq 0>
                    AND SCR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
                </cfif>
                <cfif arguments.company_id neq 0> 
                    AND SCR.COMPANY_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
                </cfif>
                <cfif arguments.consumer_id neq 0> 
                    AND SCR.COMPANY_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
                </cfif>
                <cfif arguments.service_substatus_id neq 0> 
                    AND SCR.SERVICE_SUBSTATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_substatus_id#">
                </cfif>
            ORDER BY
                SCR.CONTRACT_HEAD
		</cfquery>
		<cfreturn GET_SERVICE_REPORT>
	</cffunction>
    
    <!--- get --->    
    
    <cffunction name="get" access="public" returntype="query">
        <cfargument name="id" type="numeric" default="0" required="yes" hint="Servis Bakım Planı Belge Id">
        <cfquery NAME="GET_SERVICE_CARE_CON" DATASOURCE="#DSN3#">
            SELECT 
                SCR.*,
                P.PRODUCT_ID,
                P.PRODUCT_NAME,
                ISNULL(CP.COMPANY_PARTNER_NAME +' '+ CP.COMPANY_PARTNER_SURNAME,CONS.CONSUMER_NAME +' '+CONS.CONSUMER_SURNAME) NAME,
                ISNULL(C.FULLNAME,CONS.COMPANY) COMPANY 
            FROM 
                SERVICE_CARE_REPORT SCR
                LEFT JOIN SERVICE_CARE SC ON SC.PRODUCT_CARE_ID = SCR.CARE_REPORT_ID
                LEFT JOIN PRODUCT P ON P.PRODUCT_ID = SCR.PRODUCT_ID
                LEFT JOIN #dsn#.COMPANY_PARTNER CP ON CP.PARTNER_ID = SCR.COMPANY_PARTNER_ID
                LEFT JOIN #dsn#.COMPANY C ON C.COMPANY_ID = SCR.COMPANY_PARTNER_ID
                LEFT JOIN #dsn#.CONSUMER CONS ON CONS.CONSUMER_ID = SCR.COMPANY_PARTNER_ID
            WHERE 
                SCR.CARE_REPORT_ID=#arguments.id#
    </cfquery>
    	<cfreturn GET_SERVICE_CARE_CON>    
    </cffunction>
    
    <!--- add --->
    <cffunction name="add" access="public" returntype="string">
		<cfargument name="serial_no" type="string" default="" required="yes" hint="Ürün Seri No">
        <cfargument name="service_member_type" type="string" required="yes" hint="Servis Firma Tipi">
        <cfargument name="service_member_id" type="numeric" default="0" required="yes" hint="Servis Firma Id">
		<cfargument name="employee_id" type="numeric" default="0" required="no" hint="Servis Calısan Id">
        <cfargument name="employee_id2" type="string" default="0" required="no" hint="Servis Calısan Id 2">
        <cfargument name="file_name" type="string" required="no" hint="Destek Belgesi">        
        <cfargument name="service_start_date" default="" type="string" required="no" hint="Bakım Baslangıc Tarihi">
        <cfargument name="service_finish_date" default="" type="string" required="no" hint="Bakım Bitis Tarihi">        
        <cfargument name="detail" type="string" required="no" default="" hint="Acıklama">        
        <cfargument name="product_id" type="numeric" required="yes" hint="Urun Id">        
        <cfargument name="service_substatus" type="numeric" default="0" required="no" hint="Servis Alt Asama">        
        <cfargument name="contract_head" type="string" required="yes" hint="Konu">        
        <cfargument name="service_care" type="numeric" required="no" hint="Bakım Tipi">
        <cfquery NAME="ADD_SERVICE_CONTRACT" DATASOURCE="#DSN3#" result="MAX_ID">
            INSERT INTO
                SERVICE_CARE_REPORT
                (
                    SERIAL_NO,
                    COMPANY_PARTNER_TYPE,
                    COMPANY_PARTNER_ID,
                    EMPLOYEE1_ID,
                    EMPLOYEE2_ID,
                    FILE_NAME,
                    FILE_SERVER_ID,
                    CARE_DATE,
                    CARE_FINISH_DATE,
                    DETAIL,
                    PRODUCT_ID,
                    SERVICE_SUBSTATUS,
                    CONTRACT_HEAD,
                    CARE_CAT,
                    RECORD_EMP,
                    RECORD_IP,
                    RECORD_DATE
                )
            VALUES
                (
                    '#arguments.SERIAL_NO#',
                    <cfif len(arguments.service_member_type)>'#arguments.service_member_type#'<cfelse>NULL</cfif>,
                    <cfif arguments.service_member_id neq 0>#arguments.service_member_id#<cfelse>NULL</cfif>,
                    <cfif arguments.employee_id neq 0>#arguments.employee_id#<cfelse>NULL</cfif>,
                    <cfif arguments.employee_id2 neq 0>#arguments.employee_id2#<cfelse>NULL</cfif>,
                    <cfif len(arguments.file_name)>'#arguments.file_name#'<cfelse>NULL</cfif>,
                    <cfif len(arguments.file_name)>#server_machine#<cfelse>NULL</cfif>,
                    <cfif len(arguments.service_start_date)>#arguments.service_start_date#<cfelse>NULL</cfif>,
                    <cfif len(arguments.service_finish_date)>#arguments.service_finish_date#<cfelse>NULL</cfif>,
                    <cfif len(arguments.detail)>'#arguments.detail#'<cfelse>NULL</cfif>,
                    #arguments.product_id#,
                    <cfif arguments.service_substatus neq 0>#arguments.service_substatus#<cfelse>NULL</cfif>,
                    '#arguments.contract_head#',
                    <cfif arguments.service_care neq 0>#arguments.service_care#<cfelse>NULL</cfif>,
                    #session.ep.userid#,
                    '#cgi.remote_addr#',
                    #now()#
                )
        </cfquery>
        <cfreturn MAX_ID.IDENTITYCOL>        
	</cffunction>
    
    <!--- upd --->
    <cffunction name="upd" access="public" returntype="string">
		<cfargument name="id" type="numeric" default="0" required="yes" hint="Servis Bakım Planı Belge Id">
        <cfargument name="serial_no" type="string" default="" required="yes" hint="Ürün Seri No">
        <cfargument name="service_member_type" type="string" required="yes" hint="Servis Firma Tipi">
        <cfargument name="service_member_id" type="numeric" default="0" required="yes" hint="Servis Firma Id">
		<cfargument name="employee_id" type="numeric" default="0" required="no" hint="Servis Calısan Id">
        <cfargument name="employee_id2" type="string" default="0" required="no" hint="Servis Calısan Id 2">
        <cfargument name="file_name" type="string" required="no" hint="Destek Belgesi">        
        <cfargument name="service_start_date" default="" type="string" required="no" hint="Bakım Baslangıc Tarihi">
        <cfargument name="service_finish_date" default="" type="string" required="no" hint="Bakım Bitis Tarihi">        
        <cfargument name="detail" type="string" required="no" default="" hint="Acıklama">        
        <cfargument name="product_id" type="numeric" required="yes" hint="Urun Id">        
        <cfargument name="service_substatus" type="numeric" default="0" required="no" hint="Servis Alt Asama">        
        <cfargument name="contract_head" type="string" required="yes" hint="Konu">        
        <cfargument name="service_care" type="numeric" required="no" hint="Bakım Tipi">
		<cfquery NAME="UPD_SERVICE_CONTRACT" DATASOURCE="#DSN3#">
            UPDATE
                SERVICE_CARE_REPORT
            SET
                SERIAL_NO='#arguments.serial_no#',
                COMPANY_PARTNER_TYPE=<cfif len(arguments.service_member_type)>'#arguments.service_member_type#'<cfelse>NULL</cfif>,
                COMPANY_PARTNER_ID=<cfif len(arguments.service_member_id)>#arguments.service_member_id#<cfelse>NULL</cfif>,
                EMPLOYEE1_ID=<cfif len(arguments.employee_id)>#arguments.employee_id#<cfelse>NULL</cfif>,
                EMPLOYEE2_ID=<cfif len(arguments.employee_id2)>#arguments.employee_id2#<cfelse>NULL</cfif>,
                <cfif len(arguments.file_name)>
                    FILE_NAME='#arguments.file_name#',
                    FILE_SERVER_ID=#server_machine#,
                </cfif>
                CARE_DATE=<cfif len(arguments.service_start_date)>#arguments.service_start_date#<cfelse>NULL</cfif>,
                CARE_FINISH_DATE = <cfif len(arguments.service_finish_date)>#arguments.service_finish_date#<cfelse>NULL</cfif>,
                DETAIL=<cfif len(arguments.detail)>'#arguments.detail#'<cfelse>NULL</cfif>,
                PRODUCT_ID=#arguments.product_id#,
                SERVICE_SUBSTATUS=<cfif arguments.service_substatus neq 0>#arguments.service_substatus#<cfelse>NULL</cfif>,
                CONTRACT_HEAD='#arguments.contract_head#',
                CARE_CAT=<cfif arguments.service_care neq 0>#arguments.service_care#<cfelse>NULL</cfif>,
                UPDATE_EMP=#session.ep.userid#,
                UPDATE_IP='#cgi.remote_addr#',
                UPDATE_DATE=#now()#
            WHERE
                CARE_REPORT_ID=#arguments.id#
        </cfquery>        
		<cfreturn arguments.id>
	</cffunction>
    
    <!--- del --->
    <cffunction name="del" access="public" returntype="boolean">
        <cfargument name="id" type="numeric" default="0" required="yes" hint="Servis Bakım Belge Id">
        <cfargument name="file_name" type="string" required="no" hint="Kullanım Belgesi Dosya Adı">
        <cfquery name="DEL_SERVICE_CARE_REPORT" datasource="#DSN3#">
            DELETE FROM SERVICE_CARE_REPORT WHERE CARE_REPORT_ID = #arguments.id#
        </cfquery>
        <cfif len(arguments.file_name)>
        	<cffile action = "delete" file = "#upload_folder#service#dir_seperator##arguments.file_name#">
        </cfif>
        <cfreturn true>
    </cffunction>
         
</cfcomponent>