<cfcomponent>

    <cffunction name = "init" access = "public" output="false" description = "Define dsn" returnType="topic">

        <cfargument name="dsn" type="string">
        <cfset variables.dsn = arguments.dsn>
        <cfreturn this>

    </cffunction>

    <cffunction name="select" access="public" returntype="any">

        <cfargument name="forumid" default="">
        <cfargument name="startrow" default="0">
        <cfargument name="maxrows" default="0">

        <cfquery name="FORUM_TOPICS" datasource="#variables.dsn#">
            WITH CTE1 AS(    
                SELECT 
                    LAST_REPLY_DATE,
                    LAST_REPLY_USERKEY,
                    RECORD_DATE,
                    TOPIC,
                    TOPICID,
                    TOPIC_STATUS,
                    USERKEY,
                    LOCKED,
                    REPLY_COUNT,
                    EMAIL_EMPS,
                    FORUM_TOPIC_REAL_FILE,
                    FORUM_TOPIC_FILE,
                    RECORD_EMP,
                    FORUM_TOPIC_FILE_SERVER_ID
                FROM 
                    FORUM_TOPIC
                WHERE 
                    FORUM_TOPIC.FORUMID = <cfqueryparam CFSQLType = "cf_sql_integer"  value = "#arguments.forumid#">
            ),
            CTE2 AS (
                        SELECT
                            CTE1.*,
                            ROW_NUMBER() OVER (	 
                                    ORDER BY
                                        RECORD_DATE DESC						    							    
                            ) AS RowNum,
                            (SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                        FROM
                            CTE1
                    )
                    SELECT
                        CTE2.*
                    FROM
                        CTE2
                    WHERE
                        RowNum BETWEEN #arguments.startrow# and #arguments.startrow#+(#arguments.maxrows#-1)
        </cfquery>

        <cfreturn FORUM_TOPICS>

    </cffunction>

    <cffunction name = "insert" access = "public" description = "Add new topic">
        <cfargument name="forumid" type="numeric" default="">
        <cfargument name="forumname" type="string" default="">
        <cfargument name="topic" type="string" default="">
        <cfargument name="locked" type="string" default="">
        <cfargument name="fileFullName" type="string" default="">
        <cfargument name="file_real_name" type="string" default="">
        <cfargument name="file_name" type="string" default="">
        <cfargument name="server_machine" type="string" default="">
        <cfargument name="topic_status" type="string" default="">
        <cfargument name="email" type="string" default="">
        <cfargument name="email_emp" type="string" default="">      
        <cfargument name="from_mail" type="string" default="">
        <cfargument name="user_domain" type="string" default="">
        
        <cftry>

            <cftransaction>
                <cfquery name="ADD_TOPIC" datasource="#dsn#" result="MAX_ID">
                    INSERT INTO 
                        FORUM_TOPIC 
                        (
                        USERKEY,
                        <!---IMAGEID,--->
                        TOPIC,
                        VERIFIED,
                        LOCKED,
                        FORUMID,
                        <cfif isdefined("arguments.file_name") and len(arguments.file_name)>
                        FORUM_TOPIC_REAL_FILE,
                        FORUM_TOPIC_FILE,
                        FORUM_TOPIC_FILE_SERVER_ID,
                        </cfif>
                        TOPIC_STATUS,
                        EMAIL_EMPS,
                        RECORD_DATE,
                        RECORD_EMP,
                        RECORD_IP,
                        UPDATE_DATE,
                        UPDATE_EMP,
                        UPDATE_IP   
                        )
                    VALUES
                        (
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#SESSION.EP.USERKEY#">,
                        <!---#IMAGEID#,--->
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.topic#">,
                        1,
                        #arguments.LOCKED#,
                        #arguments.FORUMID#,
                        <cfif isdefined("arguments.file_name") and len(arguments.file_name)>
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.file_real_name#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.file_name#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.server_machine#">,
                        </cfif>
                        <cfif isdefined('arguments.topic_status')>1<cfelse>0</cfif>,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email_emp#">,
                        #now()#,
                        #SESSION.EP.USERID#,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
                        #now()#,
                        #SESSION.EP.USERID#,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
                        )						
                </cfquery>
                <cfquery name="UPD_FORUM_LAST_MSG_DATE" datasource="#dsn#">
                    UPDATE
                        FORUM_MAIN
                    SET
                        LAST_MSG_DATE = #now()#,
                        LAST_MSG_USERKEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SESSION.EP.USERKEY#">,
                        TOPIC_COUNT = TOPIC_COUNT+1
                    WHERE
                        FORUMID = #arguments.FORUMID#
                </cfquery>

                <!--- forum yöneticileri için mail gönderimi --->
                <cfif isdefined("arguments.email") and len(arguments.email)>
                    <cfquery name="get_main" datasource="#DSN#">
                        SELECT 
                            ADMIN_POS,
                            ADMIN_PARS,
                            ADMIN_CONS
                        FROM 
                            FORUM_MAIN 
                        WHERE 
                            FORUMID = #arguments.forumid#
                    </cfquery>

                    <cfset admin_cons_list=''>
                    <cfset admin_pars_list=''>
                    <cfset admin_pos_list = ''><!--- admin_pos listeye virgül ile atıyor admin_pos direk cagrıldıgında sayfada sorun olusuyor o nedenle liste yapıldı. MA20081027--->
                    <cfif len(get_main.admin_pars) and not listfind(admin_pars_list,get_main.admin_pars)>
                        <cfloop from="1" to="#listlen(get_main.admin_cons,',')#" index="c_list">			
                            <cfset admin_cons_list = listappend(admin_cons_list,listgetat(get_main.admin_cons,c_list))>
                        </cfloop>
                        <cfset admin_cons_list= listsort(ListRemoveDuplicates(admin_cons_list),'numeric','ASC',',')>															
                        <cfquery name="send_consumer" datasource="#dsn#">
                            SELECT
                                CONSUMER_ID,
                                CONSUMER_NAME,
                                CONSUMER_USERNAME,
                                CONSUMER_SURNAME,
                                CONSUMER_EMAIL
                            FROM
                                CONSUMER
                            WHERE
                                CONSUMER_EMAIL IS NOT NULL AND
                                CONSUMER_STATUS = 1 AND
                                CONSUMER_ID IN (#admin_cons_list#)
                            ORDER BY 
                                CONSUMER_ID
                        </cfquery>
                        <cfset admin_cons_list = listsort(ListRemoveDuplicates(valuelist(send_consumer.CONSUMER_ID,',')),'numeric','ASC',',')>			
                    </cfif>			
                    <cfif len(get_main.admin_pars) and not listfind(admin_pars_list,get_main.admin_pars)>
                        <cfloop from="1" to="#listlen(get_main.admin_pars,',')#" index="p_list">			
                            <cfset admin_pars_list = listappend(admin_pars_list,listgetat(get_main.admin_pars,p_list))>
                        </cfloop>
                        <cfset admin_pars_list= listsort(ListRemoveDuplicates(admin_pars_list),'numeric','ASC',',')>															
                        <cfquery name="send_partner" datasource="#dsn#">
                            SELECT
                                PARTNER_ID,
                                COMPANY_PARTNER_NAME,
                                COMPANY_PARTNER_USERNAME,
                                COMPANY_PARTNER_SURNAME,
                                COMPANY_PARTNER_EMAIL
                            FROM
                                COMPANY_PARTNER
                            WHERE
                                COMPANY_PARTNER_EMAIL IS NOT NULL AND
                                PARTNER_ID IS NOT NULL AND
                                COMPANY_PARTNER_STATUS = 1 AND
                                PARTNER_ID IN (#admin_pars_list#)
                            ORDER BY
                                PARTNER_ID
                        </cfquery>
                        <cfset admin_pars_list = listsort(ListRemoveDuplicates(valuelist(send_partner.PARTNER_ID,',')),'numeric','ASC',',')>			
                    </cfif>	
                    <cfif len(get_main.admin_pos) and not listfind(admin_pos_list,get_main.admin_pos)>
                        <cfloop from="1" to="#listlen(get_main.admin_pos,',')#" index="i_list">			
                            <cfset admin_pos_list = listappend(admin_pos_list,listgetat(get_main.admin_pos,i_list))>
                        </cfloop>
                        <cfset admin_pos_list= listsort(ListRemoveDuplicates(admin_pos_list),'numeric','ASC',',')>							
                        <cfquery name="send_mail" datasource="#DSN#">
                            SELECT 
                                EP.POSITION_ID,
                                EP.EMPLOYEE_ID,
                                EP.EMPLOYEE_NAME,
                                EP.EMPLOYEE_SURNAME,
                                E.EMPLOYEE_EMAIL	
                            FROM
                                EMPLOYEES E,
                                EMPLOYEE_POSITIONS EP
                            WHERE
                                E.EMPLOYEE_EMAIL IS NOT NULL AND
                                EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND
                                POSITION_ID IN (#admin_pos_list#) AND
                                POSITION_STATUS = 1
                            ORDER BY
                                POSITION_ID
                        </cfquery>
                        <cfset admin_pos_list = listsort(ListRemoveDuplicates(valuelist(send_mail.POSITION_ID,',')),'numeric','ASC',',')>
                    </cfif>
                    <cfif listlen(admin_cons_list)>
                        <cfoutput query="send_consumer">
                            <cfmail from="#arguments.from_mail#" to="#CONSUMER_EMAIL#" subject="#application.functions.getlang('bank',196)#" type="HTML" charset="utf-8">
                                <p>#application.functions.getlang('forum',63)# #CONSUMER_NAME# #CONSUMER_NAME#,</p></br>
                                <p>#application.functions.getlang('bank',196)#</p>
                                <p><a href="#arguments.user_domain##request.self#?fuseaction=forum.view_topic&forumid=#arguments.FORUMID#">#application.functions.getlang('bank',197)#</a></p>
                                <p>Forum : #arguments.forumname#</p>
                                <p>#application.functions.getlang('main',68)# : #arguments.topic#</p>
                                </br>
                                <p><strong>Workcube Forum</strong></p>
                            </cfmail>
                        </cfoutput>
                    </cfif>
                    <cfif listlen(admin_pars_list)>
                        <cfoutput query="send_partner">
                            <cfmail from="#arguments.from_mail#" to="#COMPANY_PARTNER_EMAIL#" subject="#application.functions.getlang('bank',196)#" type="HTML" charset="utf-8">
                                <p>#application.functions.getlang('forum',63)# #COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME#,</p></br>
                                <p>#application.functions.getlang('bank',196)#</p>
                                <p><a href="#arguments.user_domain##request.self#?fuseaction=forum.view_topic&forumid=#arguments.FORUMID#">#application.functions.getlang('bank',197)#</a></p>
                                <p>Forum : #arguments.forumname#</p>
                                <p>#application.functions.getlang('main',68)# : #arguments.topic#</p>
                                </br>
                                <p><strong>Workcube Forum</strong></p>
                            </cfmail>
                        </cfoutput>
                    </cfif>
                    <cfif listlen(admin_pos_list)>
                        <cfoutput query="send_mail">
                            <cfmail from="#arguments.from_mail#" to="#EMPLOYEE_EMAIL#" subject="#application.functions.getlang('bank',196)#" type="HTML" charset="utf-8">
                                <p>#application.functions.getlang('forum',63)# #EMPLOYEE_NAME# #EMPLOYEE_SURNAME#,</p></br>
                                <p>#application.functions.getlang('bank',196)#</p>
                                <p><a href="#arguments.user_domain##request.self#?fuseaction=forum.view_topic&forumid=#arguments.FORUMID#">#application.functions.getlang('bank',197)#</a></p>
                                <p>Forum : #arguments.forumname#</p>
                                <p>#application.functions.getlang('main',68)# : #arguments.topic#</p>
                                </br>
                                <p><strong>Workcube Forum</strong></p>
                            </cfmail>
                        </cfoutput>
                    </cfif>
                </cfif>
            
            </cftransaction>
            <cfreturn true>
            <cfcatch type = "any">
                <cfif FileExists(fileFullName)>
                    <cffile action = "delete" file = "#fileFullName#">
                </cfif>
                <cfreturn false>
            </cfcatch>

        </cftry>
    </cffunction>

</cfcomponent>