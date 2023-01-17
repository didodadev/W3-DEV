<cfcomponent extends="cfc.queryJSONConverter">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset result = StructNew()>
    <cffunction name="add_event" access="remote" returntype="string" returnformat="json">
        <cftry>
            <cfquery name="ADD_EVENT" datasource="#DSN#" result="MAX_ID">
                INSERT INTO 
                    EVENT
                    (
                        EVENTCAT_ID,
                        STARTDATE, 
                        FINISHDATE, 
                        EVENT_HEAD,
                        EVENT_DETAIL,
                        EVENT_STAGE,		
                        WARNING_EMAIL, 
                        <cfif isdefined("arguments.project_id")>PROJECT_ID,</cfif>
                        <cfif isdefined('arguments.to_emp_ids') and len(arguments.to_emp_ids)>EVENT_TO_POS,</cfif>
                        <cfif isdefined('arguments.to_par_ids') and len(arguments.to_par_ids)>EVENT_TO_PAR,</cfif>
                        <cfif isdefined('arguments.to_cons_ids') and len(arguments.to_cons_ids)>EVENT_TO_CON,</cfif>
                        <cfif isdefined('arguments.cc_emp_ids') and len(arguments.cc_emp_ids)>EVENT_CC_POS,</cfif>
                        <cfif isdefined('arguments.cc_par_ids') and len(arguments.cc_par_ids)>EVENT_CC_PAR,</cfif>
                        <cfif isdefined('arguments.cc_cons_ids') and len(arguments.cc_cons_ids)>EVENT_CC_CON,</cfif>
                        <cfif isdefined('arguments.warning_start') and len(arguments.warning_start)>WARNING_START,</cfif>
                        <cfif isDefined("arguments.view_to_all")>VIEW_TO_ALL,</cfif>
                        <cfif isDefined("session.pp.userid")>RECORD_PAR,</cfif>
                        <cfif isDefined("arguments.emp_id") and len(arguments.emp_id)>EVENT_TO_PAR,</cfif>
                        <cfif isDefined("link_id") and len(link_id)>LINK_ID,</cfif>
                        ONLINE_MEET_LINK,
                        IS_GOOGLE_CAL,
                        CREATED_GOOGLE_EVENT_ID,
                        RECORD_IP,
                        RECORD_DATE
                    )
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.eventcat_id#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finishdate#">,
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value='#arguments.event_head#'>,
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value='#arguments.event_detail#'>,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.email_alert_day#">,
                        <cfif isdefined("arguments.project_id")>#arguments.project_id#,</cfif>
                        <cfif isdefined('arguments.to_emp_ids') and len(arguments.to_emp_ids)>',#arguments.to_emp_ids#,',</cfif>
                        <cfif isdefined('arguments.to_par_ids') and len(arguments.to_par_ids)>',#arguments.to_par_ids#,',</cfif>
                        <cfif isdefined('arguments.to_cons_ids') and  len(arguments.to_cons_ids)>',#arguments.to_cons_ids#,',</cfif>
                        <cfif isdefined('arguments.cc_emp_ids') and len(arguments.cc_emp_ids)>',#arguments.cc_emp_ids#,',</cfif>
                        <cfif isdefined('arguments.cc_par_ids') and len(arguments.cc_par_ids)>',#arguments.cc_par_ids#,',</cfif>
                        <cfif isdefined('arguments.cc_cons_ids') and len(arguments.cc_cons_ids)>',#arguments.cc_cons_ids#,',</cfif>
                        <cfif isdefined('arguments.warning_start') and len(arguments.warning_start)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.warning_start#">,</cfif>
                        <cfif isDefined("arguments.view_to_all")>#arguments.view_to_all#,</cfif>
                        <cfif isdefined("session.pp.userid")>#session.pp.userid#,</cfif>
                        <cfif isDefined("arguments.emp_id") and len(arguments.emp_id)>#arguments.emp_id#,</cfif>
                        <cfif isdefined("link_id") and len(link_id)>#link_id#,</cfif>
                        <cfif isDefined("arguments.meetLink") and len(arguments.meetLink)>
                            '#arguments.meetLink#',
                        <cfelseif isDefined("arguments.place_online") and len(arguments.place_online) and not len(arguments.meetLink)>
                            '#arguments.place_online#',
                        <cfelse>
                            NULL,
                        </cfif>
                        <cfif isdefined('arguments.google_cal') and len(arguments.google_cal)>1,<cfelse>0,</cfif>
                        <cfif isdefined('arguments.googleEventId') and len(arguments.googleEventId)>'#arguments.googleEventId#',<cfelse>0,</cfif>
                        '#cgi.remote_addr#',
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    )
            </cfquery>
            <cfif isdefined("arguments.action_section") and len(arguments.action_section) and isdefined("arguments.action_id") and len(arguments.action_id)>
                <cfquery name="INS_OFFER_PLUS" datasource="#DSN#">
                    INSERT INTO
                        EVENTS_RELATED
                    (
                        ACTION_ID,
                        ACTION_SECTION,
                        EVENT_ID,
                        COMPANY_ID		
                    )
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_section#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.our_company_id#">                        
                    )	
                </cfquery>
            </cfif>

            <cfset result.status = true>
            <cfset result.success_message = "Ajanda Kaydı Yapıldı, Yönlendiriliyor">
            <cfif len(arguments.emp_id)>
                <cfset result.identity = arguments.emp_id>
            </cfif>            
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
                <cfset result.error = cfcatch >
                <cfdump var ="#result.error#">
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="del_event" access="remote" returntype="string" returnformat="json">
        <cftry>
            <cfquery name="DEL_EVENT" datasource="#DSN#">
                DELETE FROM
                    EVENT
                WHERE
                    EVENT_ID = #arguments.action_id#
            </cfquery>

            <cfset result.status = true>
            <cfset result.success_message = "Etkinlik Silindi, Yönlendiriliyor">
            <cfset result.identity = ''>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
                <cfset result.error = cfcatch >
                <cfdump var ="#result.error#">
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="upd_event" access="remote" returntype="string" returnformat="json">
        <cfif isdefined("arguments.event_start_hour")>
            <cfset arguments.startdate =  DateAdd('h',arguments.event_start_hour,arguments.startdate)>
        </cfif>
        <cfif isdefined("arguments.event_start_minute")>
            <cfset arguments.startdate =  DateAdd('n',arguments.event_start_minute,arguments.startdate)>
        </cfif>
        <cfif isdefined("arguments.event_finish_hour")>
            <cfset arguments.finishdate =  DateAdd('h',arguments.event_finish_hour,arguments.finishdate)>
        </cfif>
        <cfif isdefined("arguments.event_finish_minute")>
            <cfset arguments.finishdate =  DateAdd('n',arguments.event_finish_minute,arguments.finishdate)>
        </cfif>
        
        <cftry>
            <cfquery name="UPD_EVENT" datasource="#DSN#" result="MAX_ID">
                UPDATE
                    EVENT
                SET
                    STARTDATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#">, 
                    FINISHDATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finishdate#">, 
                    EVENT_HEAD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.event_head#">,
                    <cfif isdefined("arguments.process_stage")>EVENT_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,</cfif>
                    <cfif isdefined("arguments.email_alert_day")>WARNING_EMAIL = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.email_alert_day#">,</cfif>
                    <cfif isdefined("arguments.project_id") and len(arguments.project_id)>PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">,</cfif>
                    <cfif isdefined('arguments.to_emp_ids') and len(arguments.to_emp_ids)>EVENT_TO_POS = ',#arguments.to_emp_ids#,',</cfif>
                    <cfif isdefined('arguments.to_par_ids') and len(arguments.to_par_ids)>EVENT_TO_PAR = ',#arguments.to_par_ids#,',</cfif>
                    <cfif isdefined('arguments.to_cons_ids') and len(arguments.to_cons_ids)>EVENT_TO_CON = ',#arguments.to_cons_ids#,',</cfif>
                    <cfif isdefined('arguments.cc_emp_ids') and len(arguments.cc_emp_ids)>EVENT_CC_POS = ',#arguments.cc_emp_ids#,',</cfif>
                    <cfif isdefined('arguments.cc_par_ids') and len(arguments.cc_par_ids)>EVENT_CC_PAR = ',#arguments.cc_par_ids#,',</cfif>
                    <cfif isdefined('arguments.cc_cons_ids') and len(arguments.cc_cons_ids)>EVENT_CC_CON = ',#arguments.cc_cons_ids#,',</cfif>
                    <cfif isdefined('arguments.warning_start') and len(arguments.warning_start)>WARNING_START = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.warning_start#">,</cfif>
                    <cfif isDefined("arguments.view_to_all")>VIEW_TO_ALL = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.view_to_all#">,</cfif>
                    <cfif isdefined("arguments.google_cal")>IS_GOOGLE_CAL = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.google_cal#">,</cfif>
                    <cfif isdefined("arguments.eventcat_id") and len(arguments.eventcat_id)>EVENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.eventcat_id#">,</cfif>
                    <cfif isdefined("arguments.event_place") and len(arguments.event_place)>EVENT_PLACE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.event_place#">,</cfif>
                    <cfif isdefined("arguments.online") and len(arguments.online)>ONLINE_MEET_LINK = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.online#">,</cfif>
                    EVENT_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.event_detail#">
                WHERE
                    EVENT_ID = #arguments.event_id#
            </cfquery>

            <cfset result.status = true>
            <cfset result.success_message = "Güncelleme Yapıldı, Yönlendiriliyor">
            <cfif not isdefined("arguments.is_control")><cfset result.identity = arguments.event_id></cfif>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
                <cfset result.error = cfcatch >
                <cfdump var ="#result.error#">
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>
</cfcomponent>