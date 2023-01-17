<cfcomponent extends="cfc.faFunctions">
    <cfscript>
		functions = CreateObject("component","WMO.functions");
		filterNum = functions.filterNum;
        wrk_round = functions.wrk_round;
        getlang = functions.getlang;
	</cfscript>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = '#dsn#_#session.ep.period_year#_#session.ep.company_id#'>
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'> 
    <cfset uploadFolder = application.systemParam.systemParam().upload_folder>
    <cfset dir_seperator = application.systemParam.systemParam().dir_seperator />
    <cfset request.self = application.systemParam.systemParam().request.self />
    <cfset FUSEBOX.PROCESS_TREE_CONTROL = application.systemParam.systemParam().fusebox.process_tree_control>
    <cffunction  name="get_document" access="remote" returntype="any" >
        <cfquery name ="get_document" datasource="#dsn#">
            SELECT TYPE_ID,DOCUMENT_TYPE FROM CARGO_DOCUMENT_TYPE
        </cfquery>
        <cfreturn get_document>
    </cffunction >
    <cffunction name="GET_MONEY" returntype="query">
        <cfquery name="GET_MONEY" datasource="#DSN#">
            SELECT MONEY_ID, RATE1, RATE2, MONEY FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS = 1
        </cfquery> 
        <cfreturn GET_MONEY>
    </cffunction>  
    <cffunction  name="list_cargo"  access="remote" returntype="any">
        <cfargument  name="form_submitted" default="">
        <cfargument name="keyword"default="">
        <cfargument name="startrow" default="1">
        <cfargument  name="start_date" default="">
        <cfargument  name="finish_date" default="">
        <cfargument name="maxrows" default="20">
        <cfargument  name="coming_out" default="">
        <cfargument  name="sender_id" default="">
        <cfargument  name="receiver_id" default="">
        <cfargument  name="register_date" default="">
        <cfargument  name="cargo_id" default="">
        <cfargument  name="sender_comp_id"default="">
        <cfargument  name="receiver_name" default="">
        <cfargument  name="sender_name" default="">
        <cfquery name="list_cargo" datasource="#dsn#">
            SELECT CARGO_ID
                ,COMING_OUT
                ,DOCUMENT_REGISTRATION_NO
                ,DATE_REGISTRATION
                ,SENDER_ID
                ,RECEIVER_ID
                ,DOCUMENT_NO
                ,SENDER_DATE
                ,DELIVERY_DATE
                ,PAYMENT_METHOD
                ,CARGO_PRICE
                ,MONEY_TYPE
                ,CARRIER_COMPANY_ID
                ,CARRIER_PARTNER_ID
                ,DETAIL
                ,SENDER_COMP_ID
                ,CDT.DOCUMENT_TYPE

            FROM PAPER_CARGO_COURIER
            LEFT JOIN CARGO_DOCUMENT_TYPE CDT ON CDT.TYPE_ID = PAPER_CARGO_COURIER.DOCUMENT_TYPE
            WHERE 1=1
                <cfif isdefined("arguments.keyword") and len(arguments.keyword)>
                    AND  PAPER_CARGO_COURIER.DOCUMENT_REGISTRATION_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                </cfif>
                <cfif isdefined("arguments.coming_out") and len(arguments.coming_out)>
                    AND  PAPER_CARGO_COURIER.COMING_OUT = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.coming_out#">
                </cfif>
                <cfif isdefined("arguments.start_date") and len(arguments.start_date)>
                    AND PAPER_CARGO_COURIER.SENDER_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
                </cfif>
                <cfif isdefined("arguments.finish_date") and len(arguments.finish_date)>
                    AND PAPER_CARGO_COURIER.SENDER_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
                </cfif>
                <cfif isdefined("arguments.sender_id") and len(arguments.sender_id) and len(arguments.sender_name)>
                    AND  PAPER_CARGO_COURIER.SENDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sender_id#">
                    <cfelseif isdefined("arguments.sender_comp_id") and len(arguments.sender_comp_id) and len(arguments.sender_name)>
                    AND  PAPER_CARGO_COURIER.SENDER_COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sender_comp_id#">
                </cfif>
                <cfif isdefined("arguments.receiver_id") and len(arguments.receiver_id) and len(arguments.receiver_name)>
                    AND  PAPER_CARGO_COURIER.RECEIVER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.receiver_id#">
                </cfif>
        </cfquery>
        <cfreturn list_cargo>
    </cffunction> 
    <cffunction name="ADD_CARGO"  access="remote" returntype="any">
        <cfargument  name="COMING_OUT" default="">
        <cfargument  name="DOCUMENT_REGISTRATION_NO" default="">
        <cfargument  name="DATE_REGISTRATION" default="">
        <cfargument  name="SENDER_ID"default=""> 
        <cfargument  name="RECEIVER_ID" default="">
        <cfargument  name="DOCUMENT_NO" default="">
        <cfargument  name="SENDER_DATE" default="">
        <cfargument  name="DELIVERY_DATE" default="">
        <cfargument  name="PAYMENT_METHOD" default="">
        <cfargument  name="CARGO_PRICE" default="">
        <cfargument  name="MONEY_TYPE" default="">
        <cfargument  name="CARRIER_COMPANY_ID" default="">
        <cfargument  name="CARRIER_PARTNER_ID" default="">
        <cfargument  name="DETAIL" default="">
        <cfargument name="DOCUMENT_TYPE" default="">
        <cfargument  name="SENDER_COMP_ID" default="">
        <cfargument  name="SENDER_NAME"default="">
        <cfargument  name="CARGO_FILE"default="">
        <cfargument  name="CARGO_FILE_SERVER_ID" default="">
        <cfargument  name="save_folder" default="">
        <cfargument  name="kg" default="">
        <cfargument  name="desi" default="">
        <cfargument  name="piece" default="">
        <cfargument  name="DELIVERY_RECEIVER_ID" default="">
        <cfargument  name="DELIVERY_SENDER_ID" default="">
        <cfargument  name="DELIVERY_RECEIVER_NAME" default="">
        <cfargument  name="DELIVERY_SENDER_NAME" default="">
        <cfargument  name="process_stage" default="">
        <cfargument name = "fuseaction" default="">
        <cfif  isDefined("arguments.CARGO_FILE") and len(arguments.CARGO_FILE)  >
            <cftry>
                <cffile action="upload" filefield="cargo_file" destination="#save_folder#" mode="777" nameconflict="MAKEUNIQUE" />
                <cfset file_name = createUUID()>
                <cffile action="rename" source="#save_folder##variables.dir_seperator##cffile.serverfile#" destination="#save_folder##variables.dir_seperator##file_name#.#cffile.serverfileext#">
                <cfset corgofileName = '#file_name#.#cffile.serverfileext#'>
                <cfset corgofileServerId= '#cffile.serverfile#'>
                <cfcatch type="any">
                    <script type="text/javascript">
                        alert("<cf_get_lang dictionary_id ='44519.Dosyanız Upload Edilemedi ! Dosyanizi Kontrol Ediniz'>!");
                        history.back();
                    </script>
                    <cfabort>
                </cfcatch>	
            </cftry>
        </cfif>
        <cfquery name="ADD_CARGO" datasource="#dsn#" result="MAX_ID">
            INSERT INTO PAPER_CARGO_COURIER
                (COMING_OUT
                ,DOCUMENT_REGISTRATION_NO
                ,DATE_REGISTRATION
                ,SENDER_ID
                ,RECEIVER_ID
                ,DOCUMENT_NO
                ,SENDER_DATE
                ,DELIVERY_DATE
                ,PAYMENT_METHOD
                ,CARGO_PRICE
                ,MONEY_TYPE
                ,CARRIER_COMPANY_ID
                ,CARRIER_PARTNER_ID
                ,DETAIL
                ,DOCUMENT_TYPE
                ,SENDER_COMP_ID
                ,CARGO_FILE
                ,CARGO_FILE_SERVER_ID
                ,KG
                ,DESI
                ,PIECE
                ,DELIVERY_SENDER_ID
                ,DELIVERY_RECEIVER_ID
                ,RECORD_EMP
                ,RECORD_DATE
                ,RECORD_IP
                ,PROCESS_STAGE
                )
            VALUES(
                <cfif isdefined("arguments.COMING_OUT") and len(arguments.COMING_OUT)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.COMING_OUT#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.DOCUMENT_REGISTRATION_NO") and len(arguments.DOCUMENT_REGISTRATION_NO)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DOCUMENT_REGISTRATION_NO#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.DATE_REGISTRATION") and len(arguments.DATE_REGISTRATION)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.DATE_REGISTRATION#"><cfelse>NULL</cfif>,   
                <cfif isdefined("arguments.SENDER_ID") and len(arguments.SENDER_ID) and len(arguments.sender_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SENDER_ID#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.RECEIVER_ID") and len(arguments.RECEIVER_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.RECEIVER_ID#"><cfelse>NULL</cfif>,  
                <cfif isdefined("arguments.DOCUMENT_NO") and len(arguments.DOCUMENT_NO)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DOCUMENT_NO#"><cfelse>NULL</cfif>, 
                <cfif isdefined("arguments.SENDER_DATE") and len(arguments.SENDER_DATE)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.SENDER_DATE#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.DELIVERY_DATE") and len(arguments.DELIVERY_DATE)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.DELIVERY_DATE#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.PAYMENT_METHOD") and len(arguments.PAYMENT_METHOD)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.PAYMENT_METHOD#"><cfelse>NULL</cfif>, 
                <cfif isdefined("arguments.CARGO_PRICE") and len(arguments.CARGO_PRICE)><cfqueryparam cfsqltype="cf_sql_float"  value ="#filterNum(arguments.CARGO_PRICE,4)#"><cfelse>NULL</cfif>, 
                <cfif isdefined("arguments.MONEY_TYPE") and len(arguments.MONEY_TYPE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MONEY_TYPE#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.CARRIER_COMPANY_ID") and len(arguments.CARRIER_COMPANY_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.CARRIER_COMPANY_ID#"><cfelse>NULL</cfif>, 
                <cfif isdefined("arguments.CARRIER_PARTNER_ID") and len(arguments.CARRIER_PARTNER_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.CARRIER_PARTNER_ID#"><cfelse>NULL</cfif>, 
                <cfif isdefined("arguments.DETAIL") and len(arguments.DETAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DETAIL#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.document_type") and len(arguments.document_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.document_type#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.SENDER_COMP_ID") and len(arguments.SENDER_COMP_ID) and len(arguments.sender_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SENDER_COMP_ID#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.CARGO_FILE") and len(arguments.CARGO_FILE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#corgofileName#"><cfelse>NULL</cfif>,
                <cfif isdefined("corgofileServerId") and len(corgofileServerId)><cfqueryparam cfsqltype="cf_sql_varchar" value='#corgofileServerId#'><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.kg") and len(arguments.kg)><cfqueryparam cfsqltype="cf_sql_float" value = "#filterNum(arguments.kg,4)#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.desi") and len(arguments.desi)><cfqueryparam cfsqltype="cf_sql_float" value = "#filterNum(arguments.desi,4)#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.piece") and len(arguments.piece)><cfqueryparam cfsqltype="cf_sql_float" value = "#filterNum(arguments.piece,4)#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.DELIVERY_SENDER_ID") and len(arguments.DELIVERY_SENDER_ID) and len(arguments.delivery_sender_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.DELIVERY_SENDER_ID#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.DELIVERY_RECEIVER_ID") and len(arguments.DELIVERY_RECEIVER_ID) and len(arguments.delivery_receiver_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.DELIVERY_RECEIVER_ID#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                <cfif isdefined("arguments.process_stage") and len(arguments.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#"><cfelse>NULL</cfif>
                )
        </cfquery>
        <cfquery name="get_max_id" datasource="#dsn#">
            SELECT MAX(CARGO_ID) AS CARGO_ID   FROM PAPER_CARGO_COURIER
        </cfquery>    
        <cfset attributes.fuseaction = arguments.fuseaction>
        <cfif isdefined("arguments.process_stage") and len(arguments.process_stage)>           
            <cf_workcube_process 
                is_upd='1' 
                old_process_line='0'
                process_stage='#arguments.process_stage#' 
                record_member='#session.ep.userid#'
                record_date='#now()#' 
                action_table='PAPER_CARGO_COURIER'
                action_column='CARGO_ID'
                action_id='#get_max_id.CARGO_ID#' 
                action_page='#request.self#?fuseaction=correspondence.paperandcargo&event=upd&cargo_id=#get_max_id.CARGO_ID#'>
        </cfif>
        <script>
			window.location.href = '<cfoutput>/index.cfm?fuseaction=correspondence.paperandcargo&event=upd&cargo_id=#get_max_id.CARGO_ID#</cfoutput>';
        </script>
    </cffunction>
    <cffunction  name="UPDATE_CARGO" access="remote"  returntype="any">
        <cfargument  name="cargo_id" default="">
        <cfargument  name="COMING_OUT" default="">
        <cfargument  name="DOCUMENT_REGISTRATION_NO" default="">
        <cfargument  name="DATE_REGISTRATION" default="">
        <cfargument  name="SENDER_ID"default=""> 
        <cfargument  name="RECEIVER_ID" default="">
        <cfargument  name="DOCUMENT_NO" default="">
        <cfargument  name="SENDER_DATE" default="">
        <cfargument  name="DELIVERY_DATE" default="">
        <cfargument  name="PAYMENT_METHOD" default="">
        <cfargument  name="CARGO_PRICE" default="">
        <cfargument  name="MONEY_TYPE" default="">
        <cfargument  name="CARRIER_COMPANY_ID" default="">
        <cfargument  name="CARRIER_PARTNER_ID" default="">
        <cfargument  name="DETAIL" default="">
        <cfargument name="DOCUMENT_TYPE" default="">
        <cfargument  name="SENDER_COMP_ID" default="">
        <cfargument  name="SENDER_NAME"default="">
        <cfargument  name="CARGO_FILE"default="">
        <cfargument  name="CARGO_FILE_SERVER_ID" default="">
        <cfargument  name="save_folder" default="">
        <cfargument  name="old_file" default="">
        <cfargument  name="kg" default="">
        <cfargument  name="desi" default="">
        <cfargument  name="piece" default="">
        <cfargument  name="DELIVERY_RECEIVER_ID" default="">
        <cfargument  name="DELIVERY_SENDER_ID" default="">
        <cfargument  name="DELIVERY_RECEIVER_NAME" default="">
        <cfargument  name="DELIVERY_SENDER_NAME" default="">
        <cfargument  name="fuseaction" default="">
        <cfargument  name="process_stage" default="">

        <cfset getFile = get_list_cargo(arguments.cargo_id)>
        <cfif len(arguments.old_file) or (len(arguments.CARGO_FILE) and len(getFile.CARGO_FILE)) >
        	<cffile action="delete" file="#arguments.save_folder#\#getFile.CARGO_FILE#">
            <cfquery name="DEL_CARGO_FILE" datasource="#dsn#">
                UPDATE 
                    PAPER_CARGO_COURIER 
                SET 
                    CARGO_FILE = NULL,
                    CARGO_FILE_SERVER_ID = NULL
                WHERE CARGO_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cargo_id#"> 
            </cfquery>
        </cfif>
        <cfif  isDefined("arguments.CARGO_FILE") and len(arguments.CARGO_FILE)  >
            <cftry> 
                <cffile action="upload" filefield="cargo_file" destination="#save_folder#" mode="777" nameconflict="MAKEUNIQUE" />
                <cfset file_name = createUUID()>
                <cffile action="rename" source="#save_folder##variables.dir_seperator##cffile.serverfile#" destination="#save_folder##variables.dir_seperator##file_name#.#cffile.serverfileext#">
                <cfset arguments.CARGO_FILE = '#file_name#.#cffile.serverfileext#'>
                <cfset corgofileServerId= '#cffile.serverfile#'>
                <cfquery name="file" datasource="#dsn#">
                UPDATE 
                    PAPER_CARGO_COURIER
                SET
                    CARGO_FILE=<cfif isdefined("arguments.CARGO_FILE") and len(arguments.CARGO_FILE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CARGO_FILE#"><cfelse>NULL</cfif>,
                    CARGO_FILE_SERVER_ID=<cfif isdefined("corgofileServerId") and len(corgofileServerId)><cfqueryparam cfsqltype="cf_sql_varchar" value="#corgofileServerId#"><cfelse>NULL</cfif>
                WHERE 
                    CARGO_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cargo_id#"> 
                </cfquery>
                <cfcatch type="any">
                    <script type="text/javascript">
                        alert("<cf_get_lang dictionary_id ='44519.Dosyanız Upload Edilemedi ! Dosyanizi Kontrol Ediniz'>!");
                        history.back();
                    </script>
                    <cfabort>
                </cfcatch>	
            </cftry>
        </cfif>
        <cfquery name="UPDATE_CARGO" datasource="#dsn#" >
            UPDATE 
                PAPER_CARGO_COURIER
            SET
                COMING_OUT= <cfif isdefined("arguments.COMING_OUT") and len(arguments.COMING_OUT)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.COMING_OUT#"><cfelse>NULL</cfif>,
                DOCUMENT_REGISTRATION_NO=<cfif isdefined("arguments.DOCUMENT_REGISTRATION_NO") and len(arguments.DOCUMENT_REGISTRATION_NO)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DOCUMENT_REGISTRATION_NO#"><cfelse>NULL</cfif>,
                DATE_REGISTRATION=<cfif isdefined("arguments.DATE_REGISTRATION") and len(arguments.DATE_REGISTRATION)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.DATE_REGISTRATION#"><cfelse>NULL</cfif>,   
                SENDER_ID=<cfif isdefined("arguments.SENDER_ID") and len(arguments.SENDER_ID) and len(arguments.sender_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SENDER_ID#"><cfelse>NULL</cfif>,
                RECEIVER_ID=<cfif isdefined("arguments.RECEIVER_ID") and len(arguments.RECEIVER_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.RECEIVER_ID#"><cfelse>NULL</cfif>,  
                DOCUMENT_NO=<cfif isdefined("arguments.DOCUMENT_NO") and len(arguments.DOCUMENT_NO)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DOCUMENT_NO#"><cfelse>NULL</cfif>, 
                SENDER_DATE=<cfif isdefined("arguments.SENDER_DATE") and len(arguments.SENDER_DATE)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.SENDER_DATE#"><cfelse>NULL</cfif>,
                DELIVERY_DATE=<cfif isdefined("arguments.DELIVERY_DATE") and len(arguments.DELIVERY_DATE)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.DELIVERY_DATE#"><cfelse>NULL</cfif>,
                PAYMENT_METHOD=<cfif isdefined("arguments.PAYMENT_METHOD") and len(arguments.PAYMENT_METHOD)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.PAYMENT_METHOD#"><cfelse>NULL</cfif>, 
                CARGO_PRICE=<cfif isdefined("arguments.CARGO_PRICE") and len(arguments.CARGO_PRICE)><cfqueryparam cfsqltype="cf_sql_float" value ="#filterNum(arguments.CARGO_PRICE,4)#"><cfelse>NULL</cfif>, 
                MONEY_TYPE=<cfif isdefined("arguments.MONEY_TYPE") and len(arguments.MONEY_TYPE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MONEY_TYPE#"><cfelse>NULL</cfif>,
                CARRIER_COMPANY_ID=<cfif isdefined("arguments.CARRIER_COMPANY_ID") and len(arguments.CARRIER_COMPANY_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.CARRIER_COMPANY_ID#"><cfelse>NULL</cfif>, 
                CARRIER_PARTNER_ID=<cfif isdefined("arguments.CARRIER_PARTNER_ID") and len(arguments.CARRIER_PARTNER_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.CARRIER_PARTNER_ID#"><cfelse>NULL</cfif>, 
                DETAIL=<cfif isdefined("arguments.DETAIL") and len(arguments.DETAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DETAIL#"><cfelse>NULL</cfif>,
                DOCUMENT_TYPE=<cfif isdefined("arguments.document_type") and len(arguments.document_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.document_type#"><cfelse>NULL</cfif>,
                SENDER_COMP_ID=<cfif isdefined("arguments.SENDER_COMP_ID") and len(arguments.SENDER_COMP_ID) and len(arguments.sender_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SENDER_COMP_ID#"><cfelse>NULL</cfif>, 
                KG=<cfif isdefined("arguments.kg") and len(arguments.kg)><cfqueryparam cfsqltype="cf_sql_float" value = "#filterNum(arguments.kg,4)#"><cfelse>NULL</cfif>,
                DESI=<cfif isdefined("arguments.desi") and len(arguments.desi)><cfqueryparam cfsqltype="cf_sql_float" value = "#filterNum(arguments.desi,4)#"><cfelse>NULL</cfif>,
                PIECE=<cfif isdefined("arguments.piece") and len(arguments.piece)><cfqueryparam cfsqltype="cf_sql_float" value = "#filterNum(arguments.piece,4)#"><cfelse>NULL</cfif>,
                DELIVERY_SENDER_ID=<cfif isdefined("arguments.DELIVERY_SENDER_ID") and len(arguments.DELIVERY_SENDER_ID) and len(arguments.delivery_sender_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.DELIVERY_SENDER_ID#"><cfelse>NULL</cfif>,
                DELIVERY_RECEIVER_ID=<cfif isdefined("arguments.DELIVERY_RECEIVER_ID") and len(arguments.DELIVERY_RECEIVER_ID) and len(arguments.delivery_receiver_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.DELIVERY_RECEIVER_ID#"><cfelse>NULL</cfif>,
                UPDATE_DATE= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,    
                UPDATE_EMP= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                UPDATE_IP=<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                PROCESS_STAGE = <cfif isdefined("arguments.process_stage") and len(arguments.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#"><cfelse>NULL</cfif>
            WHERE
                CARGO_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cargo_id#"> 
        </cfquery> 
        <cfset attributes.fuseaction = arguments.fuseaction>
        <cfif isdefined("arguments.process_stage") and len(arguments.process_stage)>
            <cf_workcube_process 
                is_upd='1' 
                old_process_line='#arguments.old_process_line#'
                process_stage='#arguments.process_stage#' 
                record_member='#session.ep.userid#'
                record_date='#now()#' 
                action_table='PAPER_CARGO_COURIER'
                action_column='CARGO_ID'
                action_id='#arguments.cargo_id#' 
                action_page='#request.self#?fuseaction=correspondence.paperandcargo&event=upd&cargo_id=#arguments.cargo_id#'>
            </cfif>
        <script type="text/javascript">
            window.location.href = '<cfoutput>/index.cfm?fuseaction=correspondence.paperandcargo&event=upd&cargo_id=#arguments.cargo_id#</cfoutput>';
        </script> 
    </cffunction>
    <cffunction name="GET_LIST_CARGO"  access="remote" returntype="any">
        <cfargument  name="cargo_id" default="">
        <cfquery name="get_list_cargo" datasource="#dsn#">
            SELECT CARGO_ID
                ,COMING_OUT
                ,DOCUMENT_REGISTRATION_NO
                ,DATE_REGISTRATION
                ,SENDER_ID
                ,RECEIVER_ID
                ,DOCUMENT_NO
                ,SENDER_DATE
                ,DELIVERY_DATE
                ,PAYMENT_METHOD
                ,CARGO_PRICE
                ,MONEY_TYPE
                ,CARRIER_COMPANY_ID
                ,CARRIER_PARTNER_ID
                ,DETAIL 
                ,SENDER_COMP_ID
                ,CARGO_FILE
                ,CARGO_FILE_SERVER_ID
                ,RECORD_EMP
                ,RECORD_DATE
                ,RECORD_IP
                ,UPDATE_EMP
                ,UPDATE_DATE
                ,UPDATE_IP
                ,DOCUMENT_TYPE
                ,KG
                ,DESI
                ,PIECE
                ,DELIVERY_SENDER_ID
                ,DELIVERY_RECEIVER_ID
                ,PROCESS_STAGE
            FROM 
                PAPER_CARGO_COURIER
            WHERE
                CARGO_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cargo_id#">
        </cfquery>
        <cfreturn get_list_cargo>
    </cffunction> 
    <cffunction name="DEL_CARGO"  access="remote" returntype="any">
        <cfargument  name="cargo_id" default="">
        <cfquery name="DEL_CARGO" datasource="#DSN#">
        DELETE FROM PAPER_CARGO_COURIER  WHERE CARGO_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cargo_id#"> 
        </cfquery>
         <script type="text/javascript">
          	window.document.location.href='/index.cfm?fuseaction=correspondence.paperandcargo';
        </script>
    </cffunction> 
</cfcomponent>