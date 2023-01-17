<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Semih Bozal	
Analys Date : 01/04/2016			Dev Date	: 21/05/2016		
Description :
	Bu component bakım planı objesine ait CRUD ve list fonksiyonlarını gerceklestirir.
----------------------------------------------------------------------->

<cfcomponent>	
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cfset dsn3 = '#dsn#_#session.ep.company_id#'>
	<cfset server_machine = application.systemParam.systemParam().fusebox.server_machine>
    <cfset dir_seperator = application.systemParam.systemParam().dir_seperator>
    <cfset upload_folder = application.systemParam.systemParam().upload_folder>
    
	 <!--- list --->
	<cffunction name="list" access="public" returntype="query">    	
		<cfargument name="is_active" type="string" default="1" required="no" hint="Servis Bakım Planı Aktif Mi Pasif Mi">
        <cfargument name="keyword" type="string" default="" required="no" hint="Keyword; konu,ürün,sirket numarasına göre arama yapar">        
 		<cfquery name="GET_SERVICE_CARE" datasource="#DSN3#">
            SELECT
                SC.PRODUCT_CARE_ID,
                SC.PRODUCT_ID,
                SC.CARE_DESCRIPTION,
                SC.COMPANY_AUTHORIZED_TYPE,
                SC.COMPANY_AUTHORIZED,
                SC.SERIAL_NO,
                SC.RECORD_DATE,
                SC.START_DATE,
                P.PRODUCT_NAME,
                C.COMPANY_ID,
                C.FULLNAME,
                CONS.CONSUMER_ID,
                CONS.CONSUMER_NAME +' '+ CONS.CONSUMER_SURNAME CONS_NAME
            FROM
                SERVICE_CARE AS SC WITH (NOLOCK)
                LEFT JOIN PRODUCT P ON P.PRODUCT_ID = SC.PRODUCT_ID
                LEFT JOIN #dsn#.COMPANY_PARTNER CP ON CP.PARTNER_ID = SC.COMPANY_AUTHORIZED
                LEFT JOIN #dsn#.COMPANY C ON C.COMPANY_ID = CP.COMPANY_ID
                LEFT JOIN #dsn#.CONSUMER CONS ON CONS.CONSUMER_ID =  SC.COMPANY_AUTHORIZED
            WHERE
                SC.PRODUCT_CARE_ID IS NOT NULL
                <cfif len(arguments.is_active)>AND SC.STATUS = #arguments.is_active#</cfif>
                <cfif len(arguments.keyword)>
	                AND SC.CARE_DESCRIPTION LIKE '%#arguments.keyword#%'
                </cfif>
            ORDER BY
                SC.CARE_DESCRIPTION
        </cfquery>        
		<cfreturn GET_SERVICE_CARE>
	</cffunction>
    
    <!--- get --->    
    
    <cffunction name="get" access="public" returntype="query">
        <cfargument name="id" type="numeric" default="0" required="yes" hint="Servis Bakım Belge Id">
        <cfquery name="get_service_care" datasource="#dsn#">
            SELECT            	
                SC.STATUS,
                SC.CARE_DESCRIPTION,
                SC.PRODUCT_ID,
                SC.SERIAL_NO,
                SC.MARK,
                SC.COMPANY_AUTHORIZED,
                SC.COMPANY_AUTHORIZED_TYPE,
                SC.SALES_DATE,
                SC.GUARANTY_START_DATE,
                SC.GUARANTY_FINISH_DATE,
                SC.START_DATE,
                SC.FINISH_DATE,
                SC.SERVICE_EMPLOYEE,
                SC.SERVICE_EMPLOYEE2,
                SC.SERVICE_AUTHORIZED_ID,
                SC.SERVICE_AUTHORIZED_TYPE,
                SC.FILE_NAME,
                SC.DETAIL,
                SC.RECORD_EMP,
                SC.RECORD_DATE,
                SC.UPDATE_EMP,
                SC.UPDATE_DATE,
                ISNULL(CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME,CONS.CONSUMER_NAME + ' ' + CONS.CONSUMER_SURNAME) AS NAME,
                ISNULL(C.FULLNAME,CONS.COMPANY) AS COMPANY,
                ISNULL(CP1.COMPANY_PARTNER_NAME + ' ' + CP1.COMPANY_PARTNER_SURNAME,CONS1.CONSUMER_NAME + ' ' + CONS1.CONSUMER_SURNAME) AS NAME1,
                ISNULL(C1.FULLNAME,CONS1.COMPANY) AS COMPANY1,
                P.PRODUCT_NAME,
                E.EMPLOYEE_ID,
                E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME                
            FROM 
                #dsn3#.SERVICE_CARE SC
                LEFT JOIN COMPANY_PARTNER CP ON SC.COMPANY_AUTHORIZED = CP.PARTNER_ID
                LEFT JOIN COMPANY C ON C.COMPANY_ID = CP.COMPANY_ID
                LEFT JOIN COMPANY_PARTNER CP1 ON SC.SERVICE_AUTHORIZED_ID = CP1.PARTNER_ID
                LEFT JOIN COMPANY C1 ON C1.COMPANY_ID = CP1.COMPANY_ID
                LEFT JOIN CONSUMER CONS ON CONS.CONSUMER_ID = SC.COMPANY_AUTHORIZED
                LEFT JOIN CONSUMER CONS1 ON CONS1.CONSUMER_ID = SC.SERVICE_AUTHORIZED_ID
                LEFT JOIN #dsn3#.PRODUCT P ON P.PRODUCT_ID = SC.PRODUCT_ID
                LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID = SC.SERVICE_EMPLOYEE2
            WHERE 
                SC.PRODUCT_CARE_ID = #arguments.id#
        </cfquery>    
    	<cfreturn get_service_care>    
    </cffunction>
    
    <!--- add --->
    <cffunction name="add" access="public" returntype="string">
		<cfargument name="status" type="numeric" default="1" required="no" hint="Servis Bakım Planı Aktif Mi Pasif Mi">
        <cfargument name="care_description" type="string" required="yes" hint="Servis Bakım Planı Konusu">
        <cfargument name="product_id" type="numeric" default="0" required="yes" hint="Urun Id">
        <cfargument name="member_type" type="string" required="yes" hint="Alıcı Sirket Tipi">
        <cfargument name="member_id" type="numeric" default="0" required="yes" hint="Alıcı Sirket Id">
		<cfargument name="employee_id" type="numeric" default="0" required="no" hint="Servis Calısan Id">
        <cfargument name="employee_id2" type="string" default="0" required="no" hint="Servis Calısan Id 2">
        <cfargument name="aim" type="string" required="no" hint="Kullanım Amacı">
        <cfargument name="service_member_type" type="string" required="no" hint="Servis Sirket Tipi ">
        <cfargument name="service_member_id" default="0" type="numeric" required="yes">
        <cfargument name="file_name" type="string" required="no" hint="Kullanım Belgesi Dosya Adı">
        <cfargument name="action_date" type="string" required="yes" hint="Islem Tarihi">
        <cfargument name="finish_date" type="string" required="no" hint="Bakım Bitis Tarihi">
        <cfargument name="sales_date" type="string" required="no" hint="Satıs Tarihi">
        <cfargument name="guaranty_start_date" type="string" required="no" hint="Servis Garanti Baslangıc Tarihi">
        <cfargument name="guaranty_finish_date" type="string" required="no" hint="Servis Garanti Bitis Tarihi">
        <cfargument name="mark" type="string" required="no" hint="Marka">
        <cfargument name="document" type="string" required="no" hint="Kullanım Belgesi">
        
        <cfquery NAME="ADD_SERVICE_CARE" DATASOURCE="#DSN3#" result="MAX_ID">
            INSERT INTO
                SERVICE_CARE
            (
                PRODUCT_ID,
                SERIAL_NO,
                STATUS,
                CARE_DESCRIPTION,
                SALES_DATE,
                COMPANY_AUTHORIZED_TYPE,
                COMPANY_AUTHORIZED,
                SERVICE_EMPLOYEE,
                SERVICE_EMPLOYEE2,
                DETAIL,
                SERVICE_AUTHORIZED_TYPE,
                SERVICE_AUTHORIZED_ID,
                FILE_NAME,
                FILE_SERVER_ID,
                START_DATE,
                FINISH_DATE,
                GUARANTY_START_DATE,
                GUARANTY_FINISH_DATE,
                MARK,
                RECORD_EMP,
                RECORD_IP,
                RECORD_DATE
            )
            VALUES
            (
                #arguments.product_id#,
                '#arguments.serial_no#',
                <cfif arguments.status eq 1>1,<cfelse>0,</cfif>
                '#arguments.care_description#',
                <cfif len(arguments.sales_date)>#arguments.sales_date#<cfelse>NULL</cfif>,
                <cfif len(arguments.member_type)>'#arguments.member_type#'<cfelse>NULL</cfif>,
                <cfif arguments.member_id neq 0>#arguments.member_id#<cfelse>NULL</cfif>,
                <cfif arguments.employee_id neq 0>#arguments.employee_id#<cfelse>NULL</cfif>,
                <cfif arguments.employee_id2 neq 0>#arguments.employee_id2#<cfelse>NULL</cfif>,
                <cfif len(arguments.aim)>'#arguments.aim#'<cfelse>NULL</cfif>,
                <cfif len(arguments.service_member_type)>'#arguments.service_member_type#'<cfelse>NULL</cfif>,
                <cfif arguments.service_member_id neq 0>#arguments.service_member_id#<cfelse>NULL</cfif>,
                <cfif len(arguments.file_name)>'#arguments.file_name#'<cfelse>NULL</cfif>,
                <cfif len(arguments.file_name)>#server_machine#<cfelse>NULL</cfif>,
                #arguments.action_date#,
                <cfif len(arguments.finish_date)>#arguments.finish_date#<cfelse>NULL</cfif>,
                <cfif len(arguments.guaranty_start_date)>#arguments.guaranty_start_date#<cfelse>NULL</cfif>,
                <cfif len(arguments.guaranty_finish_date)>#arguments.guaranty_finish_date#<cfelse>NULL</cfif>,
                <cfif len(arguments.mark)>'#arguments.mark#'<cfelse>NULL</cfif>,
                #session.ep.userid#,
                '#cgi.remote_addr#',
                #now()#
            )
        </cfquery> 
        <cfreturn MAX_ID.IDENTITYCOL>        
	</cffunction>
    
    <!--- upd --->
    <cffunction name="upd" access="public" returntype="string">
    	<cfargument name="id" type="numeric" required="yes" hint="Servis Bakım Belge Id">
		<cfargument name="status" type="numeric" default="1" required="no" hint="Servis Bakım Planı Aktif Mi Pasif Mi">
        <cfargument name="care_description" type="string" required="yes" hint="Servis Bakım Planı Konusu">
        <cfargument name="product_id" type="numeric" default="0" required="yes" hint="Urun Id">
        <cfargument name="member_type" type="string" required="yes" hint="Alıcı Sirket Tipi">
        <cfargument name="member_id" type="numeric" default="0" required="yes" hint="Alıcı Sirket Id">
		<cfargument name="employee_id" type="numeric" default="0" required="no" hint="Servis Calısan Id">
        <cfargument name="employee_id2" type="string" default="0" required="no" int="Servis Calısan Id 2">
        <cfargument name="aim" type="string" required="no" hint="Kullanım Amacı">
        <cfargument name="service_member_type" type="string" required="no" hint="Servis Sirket Tipi ">
        <cfargument name="service_member_id" default="0" type="numeric" required="yes">
        <cfargument name="file_name" type="string" required="no" hint="Kullanım Belgesi Dosya Adı">
        <cfargument name="action_date" type="string" required="yes" hint="Islem Tarihi">
        <cfargument name="finish_date" type="string" required="no" hint="Bakım Bitis Tarihi">
        <cfargument name="sales_date" type="string" required="no" hint="Satıs Tarihi">
        <cfargument name="guaranty_start_date" type="string" required="no" hint="Servis Garanti Baslangıc Tarihi">
        <cfargument name="guaranty_finish_date" type="string" required="no" hint="Servis Garanti Bitis Tarihi">
        <cfargument name="mark" type="string" required="no" hint="Marka">
		<cfquery name="upd_service_care" DATASOURCE="#DSN3#">
            UPDATE
                SERVICE_CARE
            SET
                PRODUCT_ID = #arguments.product_id#,
                SERIAL_NO = '#arguments.serial_no#',
                STATUS = <cfif arguments.status eq 1>1<cfelse>0</cfif>,
                CARE_DESCRIPTION = '#arguments.care_description#',
                SALES_DATE = <cfif len(arguments.sales_date)>#arguments.sales_date#<cfelse>NULL</cfif>,
                COMPANY_AUTHORIZED_TYPE = <cfif len(arguments.member_type)>'#arguments.member_type#'<cfelse>NULL</cfif>,
                COMPANY_AUTHORIZED = <cfif arguments.member_id neq 0>#arguments.member_id#<cfelse>NULL</cfif>,
                SERVICE_EMPLOYEE = <cfif arguments.employee_id neq 0>#arguments.employee_id#<cfelse>NULL</cfif>,
                SERVICE_EMPLOYEE2 = <cfif arguments.employee_id2 neq 0>#arguments.employee_id2#<cfelse>NULL</cfif>,
                DETAIL = <cfif len(arguments.aim)>'#arguments.aim#'<cfelse>NULL</cfif>,
                SERVICE_AUTHORIZED_TYPE = <cfif len(arguments.service_member_type)>'#arguments.service_member_type#'<cfelse>NULL</cfif>,
                SERVICE_AUTHORIZED_ID = <cfif arguments.service_member_id neq 0>#arguments.service_member_id#<cfelse>NULL</cfif>,
                <cfif len(arguments.file_name)>FILE_NAME = '#arguments.file_name#',</cfif>
                FILE_SERVER_ID= <cfif len(arguments.file_name)>#server_machine#<cfelse>NULL</cfif>,
                START_DATE = #arguments.action_date#,
                FINISH_DATE =<cfif len(arguments.finish_date)>#arguments.finish_date#<cfelse>NULL</cfif>,
                GUARANTY_START_DATE = <cfif len(arguments.guaranty_start_date)>#arguments.guaranty_start_date#<cfelse>NULL</cfif>,
                GUARANTY_FINISH_DATE = <cfif len(arguments.guaranty_finish_date)>#arguments.guaranty_finish_date#<cfelse>NULL</cfif>,
                MARK = <cfif len(arguments.mark)>'#arguments.mark#'<cfelse>NULL</cfif>,
                UPDATE_EMP = #session.ep.userid#,
                UPD_IP = '#cgi.remote_addr#',
                UPDATE_DATE = #now()#	
            WHERE
                PRODUCT_CARE_ID = #arguments.id#
		</cfquery>        
		<cfreturn arguments.id>
	</cffunction>
    
    <cffunction name="getCareStation" access="public" returntype="query">
        <cfargument name="serviceId" type="numeric" default="0" required="yes">
        <cfquery name="GET_CARE_NAME" datasource="#DSN3#">
            SELECT
            	CARE_ID
            FROM
                #dsn#.CARE_STATES
            WHERE
                CARE_TYPE_ID = 3 AND
                IS_ACTIVE = 1 AND
                SERVICE_ID = #arguments.serviceId#
        </cfquery>
        <cfreturn GET_CARE_NAME>
    </cffunction>
    
    <cffunction name="getCareStates" access="public" returntype="query">
    	<cfargument name="id" type="numeric" default="0" required="yes" hint="Servis Bakım Belge Id">
        <cfquery name="care_states" datasource="#dsn#">
            SELECT 
            	CS.CARE_ID,
                CS.PERIOD_ID,
                CS.CARE_DAY,
                CS.CARE_HOUR,
                CS.CARE_MINUTE,
                CS.CARE_STATE_ID,
                SCC.SERVICE_CARE
            FROM 
            	CARE_STATES CS
            	LEFT JOIN #dsn3#.SERVICE_CARE_CAT SCC ON CS.CARE_STATE_ID = SCC.SERVICE_CARECAT_ID
            WHERE 
            	CARE_TYPE_ID = 3 
            	AND IS_ACTIVE = 1 
            	AND SERVICE_ID = #arguments.id#
        </cfquery>
        <cfreturn care_states>        
    </cffunction>        
    
    <cffunction name="addCareStates" access="public" returntype="string">
        <cfargument name="care_id" type="numeric" default="0" required="yes" hint="Bakım Id">
        <cfargument name="id" type="numeric" default="0" required="yes" hint="Bakım Id">
        <cfargument name="period" type="numeric" default="0" required="no" hint="Bakım Periyodu">
        <cfargument name="day_" type="numeric" default="0" required="no" hint="Bakım Gun">
        <cfargument name="hour_" type="numeric" default="0" required="no" hint="Bakım Saat">
        <cfargument name="minute_" type="numeric" default="0" required="no" hint="Bakım Dakika">
        <cfargument name="status" type="numeric" default="0" required="no" hint="Servis Bakım Planı Aktif Mi Pasif Mi">
        <cfquery name="ADD_CARE_VAR_NAME" datasource="#DSN3#" result="MAX_ID">
            INSERT INTO
                #dsn#.CARE_STATES
            	(
                	CARE_TYPE_ID,
                	SERVICE_ID,
                	CARE_STATE_ID,
                	IS_ACTIVE,
                    PERIOD_ID,
                    CARE_DAY,
                    CARE_HOUR,
                    CARE_MINUTE,
                    RECORD_EMP,
                    RECORD_DATE,
                    RECORD_IP
            	)
            	VALUES
            	(
                	3,
                	#arguments.id#,
                	#arguments.care_id#,
                	<cfif arguments.status eq 1>1<cfelse>0</cfif>,
                    #arguments.period#,
                    #arguments.day_#,
                    #arguments.hour_#,
                    #arguments.minute_#,
                    #session.ep.userid#,
                    #now()#,
                    '#cgi.remote_addr#'
            	)
	</cfquery>
        <cfreturn MAX_ID.IDENTITYCOL> 
    </cffunction> 
    
    <!--- del --->
    <cffunction name="delCareStates" access="public" returntype="boolean">
        <cfargument name="id" type="numeric" default="0" required="yes" hint="Servis Bakım Belge Id">
            <cfquery name="del" datasource="#DSN3#">
            	DELETE  FROM  #dsn#.CARE_STATES WHERE SERVICE_ID=#arguments.id#        
            </cfquery>
        <cfreturn true>
    </cffunction>
    
    <cffunction name="del" access="public" returntype="boolean">
        <cfargument name="id" type="numeric" default="0" required="yes" hint="Servis Bakım Belge Id">
        <cfargument name="file_name" type="string" required="no" hint="Kullanım Belgesi Dosya Adı">
        <cfquery name="del" datasource="#DSN3#">
            DELETE FROM SERVICE_CARE WHERE PRODUCT_CARE_ID = #arguments.id# 

            DELETE  FROM  #dsn#.CARE_STATES WHERE SERVICE_ID=#arguments.id#        
        </cfquery>
        <cfif len(arguments.file_name)>
        	<cffile action = "delete" file = "#upload_folder#service#dir_seperator##arguments.file_name#">
        </cfif>
        <cfreturn true>
    </cffunction>
         
</cfcomponent>