<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'>
    <cfset upload_folder=application.systemParam.systemParam().upload_folder>
    <cfset dir_seperator = application.systemParam.systemParam().dir_seperator />
    <cffunction name="ADD_SERVICE_CARE" access="remote" returntype="any" hint="Servis Bakım Kayıt">
        <cfargument name="product_id" default="">
        <cfargument name="serial_no" default="">
        <cfargument name="status" default="">
        <cfargument name="care_description" default="">
        <cfargument name="sales_date" default="">
        <cfargument name="member_type" default="">
        <cfargument name="member_id" default="">
        <cfargument name="employee_id" default="">
        <cfargument name="employee_id2" default="">
        <cfargument name="aim" default="">
        <cfargument name="service_member_type" default="">   
        <cfargument name="service_member_id" default="">
        <cfargument name="document" default="">   
        <cfargument name="start_date" default="">
        <cfargument name="finish_date" default="">
        <cfargument name="guaranty_start_date" default="">
        <cfargument name="guaranty_finish_date" default="">
        <cfargument name="mark" default="">
        <cfset responseStruct = structNew()>
        <cftry>           
            <cfset upload_folder = "#upload_folder#service#dir_seperator#" />
            <!--- Dizin kontrolü --->
            <cfif Not DirectoryExists("#upload_folder#")>
                <cfdirectory action="create" directory="#upload_folder#" />
            </cfif>
            <cfif isdefined("document") and len(document)>
                <cftry>
                    <cffile action = "upload" 
                        fileField = "document" 
                        destination = "#upload_folder#service#dir_seperator#" 
                        nameConflict = "MakeUnique" 
                        mode="777">
                    <cfset file_name = createUUID() & '.' & #cffile.serverfileext#>
                    <cffile action="rename" source="#upload_folder#service#dir_seperator##cffile.serverfile#" destination="#upload_folder#service#dir_seperator##file_name#">
                    <!---Script dosyalarını engelle  02092010 FA-ND --->
                    <cfset assetTypeName = listlast(cffile.serverfile,'.')>
                    <cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
                    <cfif listfind(blackList,assetTypeName,',')>
                        <cffile action="delete" file="#upload_folder#service#dir_seperator##file_name#">
                        <script type="text/javascript">
                            alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
                            history.back();
                        </script>
                        <cfabort>
                    </cfif>	
                    <cfset form.photo = '#file_name#.#cffile.serverfileext#'>
                    <cfcatch type="Any">
                        <script type="text/javascript">
                            alert("<cf_get_lang no='36.Dosyaniz Upload Edilemedi ! Dosyanizi Kontrol Ediniz !'>");
                            history.back();
                        </script>
                        <cfabort>
                    </cfcatch>  
                </cftry>
            </cfif>
            <cfquery NAME="ADD_SERVICE_CARE" datasource="#DSN3#" result="MAX_ID">
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
                    <cfif isdefined("arguments.status")>1,<cfelse>0,</cfif>
                    '#arguments.care_description#',
                    <cfif isdefined("arguments.sales_date") and len(arguments.sales_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.sales_date#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.member_type)>'#arguments.member_type#'<cfelse>NULL</cfif>,
                    <cfif len(arguments.member_id)>#arguments.member_id#<cfelse>NULL</cfif>,
                    <cfif len(arguments.employee_id)>#arguments.employee_id#<cfelse>NULL</cfif>,
                    <cfif len(arguments.employee_id2)>#arguments.employee_id2#<cfelse>NULL</cfif>,
                    <cfif len(arguments.aim)>'#arguments.aim#'<cfelse>NULL</cfif>,
                    <cfif len(arguments.service_member_type)>'#arguments.service_member_type#'<cfelse>NULL</cfif>,
                    <cfif len(arguments.service_member_id)>#arguments.service_member_id#<cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.document") and len(arguments.document)><cfqueryparam cfsqltype="cf_sql_varchar" value="#file_name#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.document)>#fusebox.server_machine#<cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.start_date") and len(arguments.start_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.finish_date") and len(arguments.finish_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.guaranty_start_date") and len(arguments.guaranty_start_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.guaranty_start_date#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.guaranty_finish_date") and len(arguments.guaranty_finish_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.guaranty_finish_date#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.mark)>'#arguments.mark#'<cfelse>NULL</cfif>,
                    #session.ep.userid#,
                    '#cgi.remote_addr#',
                    #now()#
                )
            </cfquery>
            <cfquery name="GET_MAXID" datasource="#DSN3#">
                SELECT MAX(PRODUCT_CARE_ID) AS MAX_ID FROM SERVICE_CARE
            </cfquery>
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = GET_MAXID.MAX_ID>
            <cfcatch>
                <cftransaction action="rollback">
                <cfset responseStruct.message = "İşlem Hatalı">
                <cfset responseStruct.status = false>
                <cfset responseStruct.error = cfcatch>
            </cfcatch>
    </cftry>
    <cfreturn responseStruct>       
    </cffunction>

    <cffunction  name="select"  access = "public">
        <cfargument name="id" default="">
        <cfquery name="get_service"  datasource="#dsn3#">
            SELECT 
                SC.PRODUCT_CARE_ID,
                SC.PRODUCT_ID,  
                SC.SERIAL_NO,   
                SC.STATUS,  
                SC.CARE_DESCRIPTION,   
                SC.SALES_DATE, 
                SC.COMPANY_AUTHORIZED_TYPE,  
                SC.COMPANY_AUTHORIZED,
                SC.SERVICE_EMPLOYEE, 
                SC.SERVICE_EMPLOYEE2,   
                SC.DETAIL,   
                SC.SERVICE_AUTHORIZED_TYPE,   
                SC.SERVICE_AUTHORIZED_ID,   
                SC.FILE_NAME,   
                SC.START_DATE,   
                SC.FINISH_DATE,   
                SC.GUARANTY_START_DATE,   
                SC.GUARANTY_FINISH_DATE,   
                SC.MARK,   
                SC.FILE_SERVER_ID,   
                SC.RECORD_EMP,   
                SC.RECORD_IP,   
                SC.RECORD_DATE,   
                SC.UPD_IP,   
                SC.UPD_DATE,   
                SC.UPD_EMP,   
                SC.UPDATE_DATE,   
                SC.UPDATE_EMP,
                E.EMPLOYEE_ID,
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME,
                P.PRODUCT_NAME,
                CP.COMPANY_PARTNER_NAME AS NAME,
                CP.COMPANY_PARTNER_SURNAME AS SURNAME,
                CP.COMPANY_ID AS COMP_ID,
                C.FULLNAME AS COMPANY_FN,
                CONS.CONSUMER_NAME AS NAME_CONSUMER,
                CONS.CONSUMER_SURNAME AS SURNAME_CONSUMER,
                CONS.COMPANY AS COMPANY_CONSUMER,
                CPS.COMPANY_PARTNER_NAME AS NAME_SP,
                CPS.COMPANY_PARTNER_SURNAME AS SURNAME_SP,
                CPS.COMPANY_ID AS COMP_ID_SP,
                CS.FULLNAME AS COMPANY_SP,
                CONS_SERVICE.CONSUMER_NAME AS NAME_CS,
                CONS_SERVICE.CONSUMER_SURNAME AS SURNAME_CS,
                CONS_SERVICE.COMPANY AS COMPANY_CS
            FROM
                SERVICE_CARE AS SC
                LEFT JOIN #DSN#.EMPLOYEES AS E ON SC.SERVICE_EMPLOYEE2 = E.EMPLOYEE_ID
                LEFT JOIN PRODUCT AS P ON P.PRODUCT_ID = SC.PRODUCT_ID
                LEFT JOIN #DSN#.COMPANY_PARTNER CP ON CP.PARTNER_ID = SC.COMPANY_AUTHORIZED
                LEFT JOIN #DSN#.COMPANY C ON C.COMPANY_ID = CP.COMPANY_ID
                LEFT JOIN #DSN#.CONSUMER CONS ON CONS.CONSUMER_ID = SC.COMPANY_AUTHORIZED
                LEFT JOIN #DSN#.COMPANY_PARTNER CPS ON CPS.PARTNER_ID = SC.SERVICE_AUTHORIZED_ID
                LEFT JOIN #DSN#.COMPANY CS ON CPS.COMPANY_ID = CS.COMPANY_ID
                LEFT JOIN #DSN#.CONSUMER CONS_SERVICE ON SC.SERVICE_AUTHORIZED_ID = CONS_SERVICE.CONSUMER_ID
            WHERE
                SC.PRODUCT_CARE_ID = #arguments.id#
        </cfquery>

        <cfreturn get_service>
    </cffunction>
    <cffunction  name="get" access="public" returntype="any">
        <cfargument  name="id" default="">
         <cfreturn select(id=arguments.id)> 
    </cffunction> 

    <cffunction name="CARE_STATES" returntype="any">
        <cfquery name="care_states" datasource="#dsn#">
            SELECT 
                CS.CARE_ID,
                CS.CARE_TYPE_ID,
                CS.STATION_ID,
                CS.ASSET_ID,
                CS.SERVICE_ID,
                CS.CARE_STATE_ID,
                CS.PERIOD_ID,
                CS.OUR_COMPANY_ID,
                CS.CARE_DAY,
                CS.CARE_HOUR,
                CS.CARE_MINUTE,
                CS.CARE_KM,
                CS.IS_DETAIL,
                CS.PROCESS_TYPE,
                CS.INS_COMPANY_ID,
                CS.POLICY_NUM,
                CS.AGENCY_NUM,
                CS.RECORD_EMP,
                CS.RECORD_IP,
                CS.RECORD_DATE,
                CS.UPDATE_IP,
                CS.UPDATE_EMP,
                CS.UPDATE_DATE,
                CS.IS_ACTIVE,
                CS.CARE_STATES,
                CS.DETAIL,
                CS.PERIOD_TIME,
                CS.OFFICIAL_EMP_ID,
                CS.OFFICIAL_EMP_ID_1,
                CS.FAILURE_ID,
                CS.PROCESS_STAGE,
                SCC.SERVICE_CARECAT_ID,
                SCC.SERVICE_CARE,
                SCC.DETAIL,
                SCC.RECORD_DATE,
                SCC.RECORD_EMP,
                SCC.RECORD_IP,
                SCC.UPDATE_DATE,
                SCC.UPDATE_EMP,
                SCC.UPDATE_IP
            FROM 
                CARE_STATES AS CS 
                LEFT JOIN #DSN3#.SERVICE_CARE_CAT AS SCC ON CS.CARE_STATE_ID = SCC.SERVICE_CARECAT_ID
            WHERE 
                CS.CARE_TYPE_ID = 3 
                AND 
                CS.IS_ACTIVE = 1
                AND 
                CS.SERVICE_ID = #url.id#
        </cfquery>
        <cfreturn CARE_STATES>
    </cffunction>


    <cffunction name="UPD_SERVICE_CARE" access="remote" returntype="any" hint="Servis Bakım Güncelleme">
        <cfargument name="product_id" default="">
        <cfargument name="serial_no" default="">
        <cfargument name="status" default="">
        <cfargument name="care_description" default="">
        <cfargument name="sales_date" default="">
        <cfargument name="member_type" default="">
        <cfargument name="member_id" default="">
        <cfargument name="employee_id" default="">
        <cfargument name="employee_id2" default="">
        <cfargument name="aim" default="">
        <cfargument name="service_member_type" default="">   
        <cfargument name="service_member_id" default="">
        <cfargument name="document" default="">   
        <cfargument name="start_date" default="">
        <cfargument name="finish_date" default="">
        <cfargument name="guaranty_start_date" default="">
        <cfargument name="guaranty_finish_date" default="">
        <cfargument name="mark" default="">
        <cfargument name="id" default="">
        <cfset attributes = arguments>
        <cfif len(arguments.sales_date)> <cf_date tarih="arguments.sales_date"></cfif>
        <cfif len(arguments.guaranty_start_date)><cf_date tarih="arguments.guaranty_start_date"></cfif>
        <cfif len(arguments.guaranty_finish_date)><cf_date tarih="arguments.guaranty_finish_date"></cfif>
        <cfif len(arguments.start_date)><cf_date tarih="arguments.start_date"></cfif>
        <cfif len(arguments.finish_date)><cf_date tarih="arguments.finish_date"></cfif>
        <cfset responseStruct = structNew()>
            <cftry>           
                <cfif isdefined("document") and len(document)>
                <cftry>
                    <cffile action = "upload" 
                      fileField = "document" 
                      destination = "#upload_folder#service#dir_seperator#" 
                      nameConflict = "MakeUnique" 
                      mode="777">
                    <cfset file_name = createUUID() & '.' & #cffile.serverfileext#>
                    <cffile action="rename" source="#upload_folder#service#dir_seperator##cffile.serverfile#" destination="#upload_folder#service#dir_seperator##file_name#">
                    <!---Script dosyalarını engelle  02092010 FA-ND --->
                    <cfset assetTypeName = listlast(cffile.serverfile,'.')>
                    <cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
                    <cfif listfind(blackList,assetTypeName,',')>
                        <cffile action="delete" file="#upload_folder#service#dir_seperator##file_name#">
                        <script type="text/javascript">
                            alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
                            history.back();
                        </script>
                        <cfabort>
                    </cfif>	
                    <cfset form.photo = '#file_name#.#cffile.serverfileext#'>
                    <cfcatch type="Any">
                        <script type="text/javascript">
                            alert("Dosyaniz upload edilemedi ! Dosyanizi kontrol ediniz !");
                            history.back();
                        </script>
                        <cfabort>
                </cfcatch>  
                </cftry>
            </cfif>
            <cfquery NAME="UPD_SERVICE_CARE" DATASOURCE="#DSN3#">
                UPDATE
                    SERVICE_CARE
                SET
                    PRODUCT_ID = #arguments.product_id#,
                    SERIAL_NO = '#arguments.serial_no#',
                    STATUS = <cfif isdefined("arguments.STATUS")>1<cfelse>0</cfif>,
                    CARE_DESCRIPTION = '#arguments.care_description#',
                    SALES_DATE = <cfif len(arguments.sales_date)>#arguments.sales_date#<cfelse>NULL</cfif>,
                    COMPANY_AUTHORIZED_TYPE = <cfif len(arguments.member_type)>'#arguments.member_type#'<cfelse>NULL</cfif>,
                    COMPANY_AUTHORIZED = <cfif len(arguments.member_id)>#arguments.member_id#<cfelse>NULL</cfif>,
                    SERVICE_EMPLOYEE = <cfif len(arguments.employee_id)>#arguments.employee_id#<cfelse>NULL</cfif>,
                    SERVICE_EMPLOYEE2 = <cfif len(arguments.employee_id2)>#arguments.employee_id2#<cfelse>NULL</cfif>,
                    DETAIL = <cfif len(arguments.aim)>'#arguments.aim#'<cfelse>NULL</cfif>,
                    SERVICE_AUTHORIZED_TYPE = <cfif len(arguments.service_member_type)>'#arguments.service_member_type#'<cfelse>NULL</cfif>,
                    SERVICE_AUTHORIZED_ID = <cfif len(arguments.service_member_id)>#arguments.service_member_id#<cfelse>NULL</cfif>,
                    <cfif len(arguments.document)>FILE_NAME = '#file_name#',</cfif>
                    FILE_SERVER_ID= <cfif len(arguments.document)>#fusebox.server_machine#<cfelse>NULL</cfif>,
                    START_DATE = #arguments.start_date#,
                    FINISH_DATE =<cfif len(arguments.finish_date)>#arguments.finish_date#<cfelse>NULL</cfif>,
                    GUARANTY_START_DATE = <cfif len(arguments.guaranty_start_date)>#arguments.guaranty_start_date#<cfelse>NULL</cfif>,
                    GUARANTY_FINISH_DATE = <cfif len(arguments.guaranty_finish_date)>#arguments.guaranty_finish_date#<cfelse>NULL</cfif>,
                    MARK = <cfif len(arguments.mark)>'#arguments.mark#'<cfelse>NULL</cfif>,
                    UPD_EMP = #session.ep.userid#,
                    UPD_IP = '#cgi.remote_addr#',
                    UPD_DATE = #now()#	
                WHERE
                    PRODUCT_CARE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
            </cfquery>
            <cfquery name="GET_CARE_NAME" datasource="#DSN3#">
                SELECT
                    *
                FROM
                    #dsn#.CARE_STATES
                WHERE
                    CARE_TYPE_ID = 3 AND
                    IS_ACTIVE = 1 AND
                    SERVICE_ID = #arguments.id#
            </cfquery>
            <cfloop query="get_care_name">
            <cfquery name="ADD_CARE" datasource="#DSN3#">
                UPDATE
                    #dsn#.CARE_STATES
                SET
                    PERIOD_ID = #evaluate("arguments.period"&currentrow)#,
                    CARE_DAY = #evaluate("arguments.day"&currentrow)#,
                    CARE_HOUR = #evaluate("arguments.hour"&currentrow)#,
                    CARE_MINUTE = #evaluate("arguments.minute"&currentrow)#,
                    RECORD_EMP = #session.ep.userid#,
                    RECORD_DATE = #now()#,
                    RECORD_IP = '#cgi.remote_addr#',
                    IS_ACTIVE = <cfif isdefined("arguments.status")>1<cfelse>0</cfif>
                WHERE
                    CARE_ID = #get_care_name.care_id#
                </cfquery>
            </cfloop>
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = #arguments.id#>
            <cfcatch>
                <cftransaction action="rollback">
                <cfset responseStruct.message = "İşlem Hatalı">
                <cfset responseStruct.status = false>
                <cfset responseStruct.error = cfcatch>
            </cfcatch>
    </cftry>
    <cfreturn responseStruct>  
    </cffunction>    
</cfcomponent>