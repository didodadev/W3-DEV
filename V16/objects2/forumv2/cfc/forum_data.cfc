<cfcomponent extends="cfc.queryJSONConverter">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset result = StructNew()>
  

    <!--- FORUM EKLE ---->
    
    <!--- <cffunction name="ADD_FORUM" access="remote" returntype="string" returnformat="json">
        
        <cfargument name="STATUS" type="string" default="">
        <cfargument name="is_internet" type="string" default="">
        <cftry>   
            
            <cfquery name="ADD_FORUM" datasource="#dsn#">
                INSERT INTO
                    FORUM_MAIN
                (
                    FORUMNAME,
                    DESCRIPTION,
                    STATUS,                    
                    IS_INTERNET,
                    RECORD_DATE,
                    RECORD_IP,
                    RECORD_EMP
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORUMNAME#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#DESCRIPTION#">,
                    <cfif isDefined("arguments.STATUS")>1,<cfelse>0,</cfif>     
                    <cfif isdefined("arguments.is_internet")>1<cfelse>0</cfif>,
                    #now()#,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
                    #SESSION.PP.USERID#
                )
            </cfquery>        
            <cfset result.status = true>
            <cfset result.success_message = "Kaydı Yapıldı, Yönlendiriliyor">
            <!--- <cfset result.identity = arguments.forumid> --->
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
                <cfset result.error = cfcatch >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

   <!--- FORUM GÜNCELLE ---->
   
   <cffunction name="UPD_FORUM" access="remote" returntype="string" returnformat="json">
    <cfargument name="forumid" type="numeric" default="">
    <cftry>        
        <cfquery name="UPD_FORUM" datasource="#dsn#">
            UPDATE
                FORUM_MAIN
            SET
                FORUMNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORUMNAME#">,
                DESCRIPTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#DESCRIPTION#">,
                STATUS = #STATUS#,    
                FORUM_EMPS = #FORUM_EMPS#,
                IS_INTERNET = <cfif isdefined("attributes.is_internet")>1<cfelse>0</cfif>,
                UPDATE_DATE = #now()#,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
                UPDATE_EMP = #SESSION.PP.USERID#
            WHERE
                FORUMID = #arguments.FORUMID#
        </cfquery>          
        <cfset result.status = true>
        <cfset result.success_message = "Kaydı Yapıldı, Yönlendiriliyor">
        <cfset result.identity = arguments.forumid>
        <cfcatch type="any">
            <cfset result.status = false>
            <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
            <cfset result.error = cfcatch >
        </cfcatch>  
    </cftry>
    <cfreturn Replace(SerializeJSON(result),'//','')>
</cffunction>

<!--- FORUM SİL --->
 <cffunction name="DEL_FORUM" access="remote" returntype="string" returnformat="json">
    <cfargument name="forumid" type="numeric" default="">
    <cftry>
    <cftransaction>
		<cfquery name="GET_FORUM_REPLY" datasource="#dsn#">
			SELECT TOPICID FROM FORUM_TOPIC WHERE FORUMID = #arguments.FORUMID#
		</cfquery>
		<cfif GET_FORUM_REPLY.recordcount>
			<cfquery name="DEL_FORUM_MESSAGES" datasource="#dsn#">
				DELETE 
				FROM
					FORUM_REPLYS 
				WHERE 
					TOPICID IN (#valuelist(GET_FORUM_REPLY.TOPICID,',')#)
			</cfquery>	
		</cfif>
		<cfquery name="TOPICS" datasource="#dsn#">
			DELETE
			FROM
				FORUM_TOPIC
			WHERE
				FORUMID = #arguments.FORUMID#
		</cfquery>		
		<cfquery name="DEL_FORUM" datasource="#dsn#">
			DELETE
			FROM
				FORUM_MAIN
			WHERE
				FORUMID = #arguments.FORUMID#
		</cfquery>	
		
	</cftransaction>
        <cfset result.status = true>
        <cfset result.success_message = "Kaydı Yapıldı, Yönlendiriliyor">
        <!--- <cfset result.identity = arguments.forumid> --->
        <cfcatch type="any">
            <cfset result.status = false>
            <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
            <cfset result.error = cfcatch >
        </cfcatch>  
    </cftry>
    <cfreturn Replace(SerializeJSON(result),'//','')>
</cffunction>  --->

<!--- Konu Ekle --->
<cffunction name="ADD_TOPIC" access="remote" returntype="string" returnargumentsat="json">
    <cfargument name="forumid" type="numeric" default="">
    <cfargument name="forumname" type="string" default="">
    <cfargument name="topic" type="string" default="">
    <cfargument name="locked" type="string" default="0">
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
                    TOPIC_STATUS,
                    VERIFIED,
                    LOCKED,
                    FORUMID,
                    <cfif isdefined("arguments.file_name") and len(arguments.file_name)>
                    FORUM_TOPIC_REAL_FILE,
                    FORUM_TOPIC_FILE,
                    FORUM_TOPIC_FILE_SERVER_ID,
                    </cfif>
                    <!---
                    EMAIL_EMPS,--->
                    RECORD_DATE,
                    <cfif isdefined("SESSION.PP.USERID")>
                        RECORD_PAR,
                    <cfelse>
                        RECORD_CON,
                    </cfif>		
                        RECORD_IP,
                        UPDATE_DATE,
                    <cfif isdefined("SESSION.PP.USERID")>
                        UPDATE_PAR,
                    <cfelse>
                        UPDATE_CON,
                    </cfif>		
                    UPDATE_IP                   
                    )
                VALUES
                    (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.USERKEY#">,
                    <!---#IMAGEID#,--->
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.topic#">,
                    <cfif isdefined('arguments.topic_status')>1,<cfelse>0,</cfif>
                    1,
                    #arguments.LOCKED#,
                    #arguments.FORUMID#,
                    <cfif isdefined("arguments.file_name") and len(arguments.file_name)>
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.file_real_name#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.file_name#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.server_machine#">,
                    </cfif>
                    
                    <!---
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email_emp#">,--->
                    #now()#,
                    <cfif isdefined("session.pp.userid")>
                        #session.pp.userid#,
                    <cfelse>
                        #session.ww.userid#,
                    </cfif>
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
                    #now()#,
                    <cfif isdefined("session.pp.userid")>
                        #session.pp.userid#,
                    <cfelse>
                        #session.ww.userid#,
                    </cfif>
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
                    )						
            </cfquery>
            <cfquery name="UPD_FORUM_LAST_MSG_DATE" datasource="#dsn#">
                UPDATE
                    FORUM_MAIN
                SET
                    LAST_MSG_DATE = #now()#,
                    LAST_MSG_USERKEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.USERKEY#">,
                    TOPIC_COUNT = TOPIC_COUNT+1
                WHERE
                    FORUMID = #arguments.FORUMID#
            </cfquery>
           
        
        </cftransaction>           
        <cfset result.status = true>
        <cfset result.success_message = "Kaydı Yapıldı, Yönlendiriliyor">
        <cfset result.identity = arguments.forumid>
        <cfcatch type="any">
            <cfset result.status = false>
            <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
            <cfset result.error = cfcatch >
        </cfcatch>  
    </cftry>
    <cfreturn Replace(SerializeJSON(result),'//','')>
</cffunction>
<!--- Konu Güncele --->

<cffunction name="UPD_TOPIC" access="remote" returntype="string" returnformat="json">
    <cfargument name="TOPICS" type="string" default="">    
    <cfargument name="TOPICID" type="numeric" default="">
    <cfargument name="LOCKED" type="numeric" default="0">
    <cfargument name="topic_status" type="numeric" default="0">
  
    <cftry>       
        
        <cfquery name="UPD_TOPIC" datasource="#dsn#">
            UPDATE 
                FORUM_TOPIC 
            SET
                FORUMID = #arguments.FORUMID#,
                <!---IMAGEID = #IMAGEID#,--->               
                TOPIC = '#arguments.TOPICS#',
                TOPIC_STATUS = <cfif isdefined('arguments.topic_status')>1,<cfelse>0,</cfif>
                VERIFIED = 1,
                LOCKED = #arguments.LOCKED#,
                <!---EMAIL_EMPS = '#NEW_EMAILS#',--->
                UPDATE_DATE = #now()#,
                <cfif isdefined("SESSION.PP.USERID")>
                    UPDATE_PAR = #SESSION.PP.USERID#,
                <cfelseif isdefined("SESSION.WW.USERID")>
                    UPDATE_CON = #SESSION.WW.USERID#,
                </cfif>		
                UPDATE_IP = '#CGI.REMOTE_ADDR#'
                <cfif (isdefined("arguments.attach_topic_file") and len(arguments.attach_topic_file)) or isdefined("arguments.delete")>		
                ,FORUM_TOPIC_FILE = '#file_name#'
                ,FORUM_TOPIC_FILE_SERVER_ID = #fusebox.server_machine#
                </cfif>	
            WHERE
                TOPICID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.topicid#">
        </cfquery>         
        <cfset result.status = true>
        <cfset result.success_message = "Kaydı Yapıldı, Yönlendiriliyor">
        <cfset result.identity = arguments.forumid>
        <cfcatch type="any">
            <cfset result.status = false>
            <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
            <cfset result.error = cfcatch >
        </cfcatch>  
    </cftry>
    <cfreturn Replace(SerializeJSON(result),'//','')>
</cffunction>

<!--- Konu Sil --->
<cffunction name="DEL_TOPIC" access="remote" returntype="string" returnformat="json">
    <cfargument name="TOPICID" type="string" default="">    
    <cfargument name="forumid" type="string" default="">    
       
    <cftry>       
        
        <cfquery name="FORUM_ID" datasource="#dsn#">
            SELECT 
                FORUMID
            FROM
                FORUM_TOPIC
            WHERE
                TOPICID = #arguments.action_id#
        </cfquery>
        <cfset arguments.forumid = forum_id.forumid>
        <cfquery name="REPLY_COUNT" datasource="#dsn#">
            SELECT 
                COUNT(REPLYID) AS TOTAL
            FROM
                FORUM_REPLYS
            WHERE
                TOPICID = #arguments.action_id#
        </cfquery>
        <cfquery name="DEL_REPLIES" datasource="#dsn#">
            DELETE 
            FROM
                FORUM_REPLYS
            WHERE
                TOPICID = #arguments.action_id#
        </cfquery>
        <cfquery name="DEL_TOPIC" datasource="#dsn#">
            DELETE 
            FROM
                FORUM_TOPIC 
            WHERE
                TOPICID = #arguments.action_id#
        </cfquery>
        <cfquery name="UPD_FORUM_LAST_MSG_DATE" datasource="#dsn#">
            UPDATE
                FORUM_MAIN
            SET
                TOPIC_COUNT = TOPIC_COUNT - 1
                <cfif REPLY_COUNT.RECORDCOUNT GT 0>
                , REPLY_COUNT = REPLY_COUNT - #REPLY_COUNT.TOTAL#
                </cfif>
            WHERE
                FORUMID = #arguments.FORUMID#
        </cfquery>        
        <cfset result.status = true>
        <cfset result.success_message = "Kaydı Yapıldı, Yönlendiriliyor">
        <cfset result.identity = arguments.forumid>
        <cfcatch type="any">
            <cfset result.status = false>
            <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
            <cfset result.error = cfcatch >
        </cfcatch>  
    </cftry>
    <cfreturn Replace(SerializeJSON(result),'//','')>
</cffunction>


<!--- CEVAP EKLE --->
<cffunction name="ADD_REPLY" access="remote" returntype="string" returnformat="json">
    <cftry>       
        <cfset reply = arguments['reply_#arguments.topicid#'] >
        <cftransaction>
            <cfquery name="ADD_REPLY" datasource="#dsn#">
                INSERT INTO 
                    FORUM_REPLYS 
                    (
                        TOPICID,
                        RELATION_REPLYID, 
                        USERKEY, 
                        REPLY,
                        VERIFIED,
                        <!---IMAGEID,--->
                        RECORD_PAR,
                        <!---<cfif isdefined("attributes.attach_reply_file") and len(attributes.attach_reply_file)>
                            FORUM_REPLY_FILE,
                            FORUM_REPLY_FILE_SERVER_ID,
                        </cfif>--->                        
                        RECORD_DATE,
                        RECORD_IP,                        
                        UPDATE_DATE,
                        UPDATE_IP,                        
                        <cfif isdefined("session.pp.userid")>
                            UPDATE_PAR
                        <cfelse>
                            UPDATE_CON
                        </cfif>
                    )
                    VALUES  
                    (
                        #arguments.topicid#,
                        <cfif isdefined("arguments.replyid") and len(arguments.replyid)>#replyid#,<cfelse>NULL,</cfif>
                        <cfif isdefined("session.pp.userid")>
                            '#session.pp.userkey#',
                        <cfelseif isdefined("session.ww.userid")>
                            '#session.ww.userkey#',
                        </cfif>
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#reply#">,                         
                        1,
                        <!---#arguments.imageid#,--->
                        #session.pp.userid#,
                        <!---<cfif isdefined("attributes.attach_reply_file") and len(attributes.attach_reply_file)>
                            '#file_name#',
                            #fusebox.server_machine#,
                        </cfif>--->                       
                        #now()#,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,                       
                        #now()#,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,                        
                        <cfif isdefined("session.pp.userid")>
                            #session.pp.userid#
                        <cfelseif isdefined("session.ww.userid")>
                            #session.ww.userid#
                        </cfif>
                    )
            </cfquery>
            
           
                    
        
        </cftransaction>
        <cfquery name="EMAIL_EMPS" datasource="#DSN#">
            SELECT EMAIL_EMPS, TITLE FROM FORUM_TOPIC WHERE TOPICID = <cfqueryparam cfsqltype="cf_sql_integer" value="#topicid#">
        </cfquery>
        <cfif not isdefined("email_emp")><cfset email_emp = 0></cfif>
        <cfquery name="GET_FORUMID" datasource="#DSN#">
            SELECT
                FORUM_MAIN.FORUMID
            FROM
                FORUM_MAIN,
                FORUM_TOPIC
            WHERE
                FORUM_MAIN.FORUMID = FORUM_TOPIC.FORUMID AND
                FORUM_TOPIC.TOPICID = <cfqueryparam cfsqltype="cf_sql_integer" value="#topicid#">
        </cfquery>
            
        <cfquery name="UPD_FORUM_LAST_MSG_DATE" datasource="#DSN#">
            UPDATE
                FORUM_MAIN
            SET
                LAST_MSG_DATE = #now()#,
                REPLY_COUNT = REPLY_COUNT+1
            WHERE
                FORUMID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_forumid.forumid#">
        </cfquery>
            
        <cfquery name="UPD_TOPIC_LAST_REPLY_DATE" datasource="#DSN#">
            UPDATE
                FORUM_TOPIC
            SET
                LAST_REPLY_DATE = #now()#,
                REPLY_COUNT = REPLY_COUNT+1
            WHERE
                TOPICID = <cfqueryparam cfsqltype="cf_sql_integer" value="#topicid#">
        </cfquery>               
        <cfset result.status = true>
        <cfset result.success_message = "Kaydı Yapıldı, Yönlendiriliyor">
        <cfset result.identity = arguments.forumid>
        <cfcatch type="any">
            <cfset result.status = false>
            <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
            <cfset result.error = cfcatch >
        </cfcatch>  
    </cftry>
    <cfreturn Replace(SerializeJSON(result),'//','')>
</cffunction>

<!--- CEVAP GÜNCELLE --->
<cffunction name="UPD_REPLY" access="remote" returntype="string" returnformat="json">
    <cftry>        
        <cfquery name="UPD_REPLY" datasource="#DSN#">
            UPDATE
                FORUM_REPLYS 
            SET
                REPLY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#replys#">,
                IMAGEID = <cfif isDefined('imageid')>#imageid#<cfelse>NULL</cfif>,
                VERIFIED = 1,
                UPDATE_DATE = #now()#,
                UPDATE_IP = '#cgi.remote_addr#',
                <cfif isdefined("session.pp.userid")>
                    UPDATE_PAR = #session.pp.userid#
                <cfelse>
                    UPDATE_CON = #session.ww.userid#
                </cfif>
                <cfif (isdefined("attributes.attach_reply_file") and len(attributes.attach_reply_file)) or isdefined("attributes.delete")>
                    ,FORUM_REPLY_FILE = '#file_name#'
                    ,FORUM_REPLY_FILE_SERVER_ID=#fusebox.server_machine#
                </cfif>
            WHERE
                REPLYID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.replyid#">
        </cfquery>      
               
        <cfset result.status = true>
        <cfset result.success_message = "Kaydı Yapıldı, Yönlendiriliyor">
        <cfset result.identity = arguments.forumid>
        <cfcatch type="any">
            <cfset result.status = false>
            <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
            <cfset result.error = cfcatch >
        </cfcatch>  
    </cftry>
    <cfreturn Replace(SerializeJSON(result),'//','')>
</cffunction>

<!--- CEVAP SİL --->
<cffunction name="DEL_REPLY" access="remote" returntype="string" returnformat="json">
    <cfargument name="forumid" type="string" default="">
    <cftry>       
        <cfquery name="GET_TOPICID" datasource="#dsn#">
            SELECT
                TOPICID
            FROM
                FORUM_REPLYS
            WHERE
                REPLYID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
        </cfquery>
        
        <cfquery name="DEL_REPLY" datasource="#dsn#">
            DELETE
                FORUM_REPLYS 
            WHERE
                REPLYID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
        </cfquery>
        
        <cfquery name="FORUMID" datasource="#dsn#">
            SELECT
                FORUM_MAIN.FORUMID
            FROM
                FORUM_MAIN,
                FORUM_TOPIC
            WHERE
                FORUM_MAIN.FORUMID = FORUM_TOPIC.FORUMID
                AND
                FORUM_TOPIC.TOPICID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_topicid.topicid#">
        </cfquery>
            
        <cfquery name="UPD_FORUM_MSG_COUNT" datasource="#dsn#">
            UPDATE
                FORUM_MAIN
            SET
                REPLY_COUNT = REPLY_COUNT-1
            WHERE
                FORUMID = <cfqueryparam cfsqltype="cf_sql_integer" value="#forumid.forumid#">
        </cfquery>
            
        <cfquery name="UPD_TOPIC_REPLY_COUNT" datasource="#dsn#">
            UPDATE
                FORUM_TOPIC
            SET
                REPLY_COUNT = REPLY_COUNT-1
            WHERE
                TOPICID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_topicid.topicid#">
        </cfquery>    
               
        <cfset result.status = true>
        <cfset result.success_message = "Kaydı Yapıldı, Yönlendiriliyor">
        <cfset result.identity = arguments.forumid>
        <cfcatch type="any">
            <cfset result.status = false>
            <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
            <cfset result.error = cfcatch >
        </cfcatch>  
    </cftry>
    <cfreturn Replace(SerializeJSON(result),'//','')>
</cffunction>

<!--- cfc dosyaları ---->
<!--- forum.cfc --->

<cffunction name="GET_COMP_CONS_CAT" access="remote">
    <cfif isDefined("session.ww.userid")>
            <!--- get_forumlist.cfm içine get_comp_cons_cat.cfm include edilmiş --->
            <cfquery name="GET_COMP_CONS_CAT" datasource="#DSN#">
                SELECT 
                    CONSUMER_CAT_ID
                FROM 
                    CONSUMER
                WHERE 
                    CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
            </cfquery>
    <cfelseif isDefined("session.pp.userid")>
            <cfquery name="GET_COMP_CONS_CAT" datasource="#DSN#">
                SELECT 
                    C.COMPANYCAT_ID
                FROM 
                    COMPANY C,
                    COMPANY_PARTNER CP
                WHERE 
                    CP.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
                    AND
                    C.COMPANY_ID = CP.COMPANY_ID
            </cfquery>
    </cfif>
    <cfreturn GET_COMP_CONS_CAT> 
</cffunction>

<cffunction name="select_forum" access="public" returntype="any">
    
    
    <cfargument name="forum_ids" default="">
    <cfargument name="cat_id" default="">
    <cfargument name="companycat_id" default="">

    <cfquery name="FORUMLIST" datasource="#DSN#">
        SELECT
            FORUMID,
            FORUMNAME,
            ADMIN_POS,
            ADMIN_CONS,
            ADMIN_PARS,
            FORUM_CONS_CATS,
            FORUM_COMP_CATS,
            FORUM_EMPS,
            DESCRIPTION,
            LAST_MSG_USERKEY,
            LAST_MSG_DATE,
            REPLY_COUNT,
            TOPIC_COUNT,
            RECORD_EMP,
            RECORD_DATE
        FROM
            FORUM_MAIN
        WHERE
            STATUS = 1 AND
            <cfif isdefined('attributes.forum_ids') and len(attributes.forum_ids)>
                FORUMID IN (#attributes.forum_ids#) AND 
            </cfif>
            <cfif isDefined("session.ww.userid")>
                IS_INTERNET = 1 OR
                FORUM_CONS_CATS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_comp_cons_cat.consumer_cat_id#,%">
            <cfelseif isDefined("session.pp.userid")>
                FORUM_COMP_CATS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_comp_cons_cat.companycat_id#,%">
            <cfelse>
                IS_INTERNET = 1 AND
                MYCUBE_GROUP_ID IS NULL
            </cfif>
            ORDER BY
            RECORD_DATE DESC
    </cfquery>

    <cfreturn FORUMLIST> 

</cffunction>

<!--- reply.cfc --->
<cffunction name = "select_reply" returnType = "any" access = "remote" description = "Get topic replies">

    <cfargument name="replyid" default="0">
    <cfargument name="topicid" default="0">
    <cfargument name="keyword" default="">
    <cfargument name="special_definition" default="">
    <cfargument name="reply_status" default="">
    <cfargument name="startrow" default="0">
    <cfargument name="maxrows" default="#session.pp.maxrows#">

    <cfquery name="GET_REPLIES" datasource="#variables.dsn#">
        WITH CTE1 AS(
            SELECT 
                TOPICID,
                USERKEY,
                REPLY,
                HIERARCHY,
                UPDATE_DATE,
                REPLYID,
                FORUM_REPLY_FILE,
                RECORD_PAR,
                FORUM_REPLY_FILE_SERVER_ID,
                SPECIAL_DEFINITION_ID,
                IS_ACTIVE,
                IMAGEID,
                MAIN_HIERARCHY,
                RECORD_DATE
            FROM 
                FORUM_REPLYS
            WHERE 
                <cfif isdefined("arguments.replyid") and arguments.replyid neq 0>
                    REPLYID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.replyid#">
                <cfelseif isdefined("arguments.topicid") and arguments.topicid neq 0>
                    TOPICID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.topicid#">
                </cfif>
                <cfif isdefined("arguments.keyword") and len(arguments.keyword)>
                    AND REPLY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                </cfif>
                <cfif isdefined("arguments.special_definition") and len(arguments.special_definition)>
                    AND SPECIAL_DEFINITION_ID LIKE <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.special_definition#">
                </cfif>
                <cfif (isDefined("arguments.reply_status") and len(arguments.reply_status))>
                    AND IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reply_status#">
                </cfif>
        ),
        CTE2 AS (
                    SELECT
                        CTE1.*,
                        ROW_NUMBER() OVER (	 
                               ORDER BY RECORD_DATE DESC				    							    
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
    
    <cfreturn GET_REPLIES>
    
</cffunction>

<!--- topic.cfc  KONULARI GETİR --->
<cffunction name="select_topic" access="public" returntype="any">

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
                FORUM_TOPIC_FILE_SERVER_ID,
                IMAGEID,          
                TITLE,                           
                VIEW_COUNT,                        
                RECORD_CON,
                RECORD_PAR            
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

<!--- userinfo.cfc --->
<cffunction name = "get_user_info" returnType = "any" access = "public" description = "Get user info">
    <cfargument name="userkey" type="string" required="true" displayname="user key string">
    
    <cfif arguments.userkey contains "e">
        <cfquery name="USERINFO" datasource="#DSN#">
            SELECT
                EMPLOYEE_ID,
                EMPLOYEE_NAME AS NAME,
                EMPLOYEE_SURNAME AS SURNAME,
                EMPLOYEE_EMAIL AS EMAIL,
                'ÇALIŞAN' AS MEMBER_TYPE,
                PHOTO
            FROM
                EMPLOYEES
            WHERE
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(arguments.userkey,"-")#">
        </cfquery>	
    <cfelseif arguments.userkey contains "p">
        <cfquery name="USERINFO" datasource="#DSN#">
            SELECT
                PARTNER_ID,
                COMPANY_PARTNER_NAME AS NAME,
                COMPANY_PARTNER_SURNAME AS SURNAME,
                COMPANY_PARTNER_EMAIL AS EMAIL,
                'PARTNER' AS MEMBER_TYPE,
                PHOTO  
            FROM
                COMPANY_PARTNER
            WHERE
                PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(arguments.userkey,"-")#">
        </cfquery>	
    <cfelseif arguments.userkey contains "c">
        <cfquery name="USERINFO" datasource="#DSN#">
            SELECT
                CONSUMER_ID,
                CONSUMER_NAME AS NAME,
                CONSUMER_SURNAME AS SURNAME,
                CONSUMER_EMAIL AS EMAIL,
                'MÜŞTERI' AS MEMBER_TYPE,
                PICTURE AS PHOTO
            FROM
                CONSUMER
            WHERE
                CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(arguments.userkey,"-")#">
        </cfquery>	
    </cfif>

    <cfreturn USERINFO> 

</cffunction>
<!--- get_forum_name.cfm --->
<cffunction name = "GET_FORUM_NAME" returnType = "any" access = "public">
    <cfargument name="FORUMID" default="">
    <cfquery name="GET_FORUM_NAME" datasource="#dsn#">
       	SELECT 
		FORUMNAME,
		FORUMID, 
		ADMIN_POS,
		ADMIN_CONS,
		ADMIN_PARS,
		FORUM_CONS_CATS, 
		FORUM_COMP_CATS,
		FORUM_EMPS,
		DESCRIPTION,
		LAST_MSG_USERKEY,
		LAST_MSG_DATE,
		REPLY_COUNT,
        RECORD_EMP,
		RECORD_PAR,
		TOPIC_COUNT,
		RECORD_DATE,
		STATUS
	FROM 
		FORUM_MAIN
	WHERE
		FORUMID = #arguments.FORUMID#
    </cfquery>    

    <cfreturn GET_FORUM_NAME> 
</cffunction>
<!--- get_forum.cfm --->
<cffunction name = "GET_ALL_FORUM" returnType = "any" access = "public">
    <cfargument name="forumid" default="">

    <cfquery name="FORUM" datasource="#DSN#">
        SELECT 
            *
        FROM 
            FORUM_MAIN
        WHERE
            FORUMID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.forumid#">
    </cfquery>  

    <cfreturn GET_ALL_FORUM> 
</cffunction>

<!--- get_topic.cfm --->
<cffunction name = "GET_ALL_TOPIC" returnType = "any" access = "public">
    <cfargument name="topicid" default=""> 
    <cfquery name="TOPIC" datasource="#dsn#">
        SELECT 
            * 
        FROM 
            FORUM_TOPIC
        WHERE 
            TOPICID = #arguments.topicid#
    </cfquery>    

    <cfreturn GET_ALL_TOPIC> 
</cffunction>

</cfcomponent>