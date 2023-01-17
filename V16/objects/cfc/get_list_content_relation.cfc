<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="GetLanguage" access="public" returntype="query">
        <cfquery name="get_language" datasource="#dsn#">
            SELECT * FROM SETUP_LANGUAGE
        </cfquery>
        <cfreturn get_language>
    </cffunction> 
    <cffunction name="GetContentProperty" access="public" returntype="query">
        <cfquery name="get_content_property" datasource="#dsn#">
            SELECT 
               CONTENT_PROPERTY_ID, 
               NAME 
            FROM 
               CONTENT_PROPERTY
        </cfquery>
        <cfreturn get_content_property>
    </cffunction> 
    <cffunction name="GetContentRelation" access="public" returntype="query">
        <cfargument name="order_list" default="">
        <cfargument name="KEYWORD" default="">
        <cfargument name="content_property_id" default="">
        <cfargument name="language_id">
        <cfquery name="get_content_relation" datasource="#DSN#">
            SELECT
                C.CONTENT_ID,
                C.CONT_HEAD,
                C.IS_VIEWED,	   
                CC.CHAPTER,
                C.RECORD_DATE,
                C.RECORD_MEMBER,
                C.HIT,
                C.UPD_COUNT,
                C.NONE_TREE,
                C.PRIORITY,
                C.CONTENT_PROPERTY_ID,
                C.LASTVISIT,
                CA.CONTENTCAT,
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME,
                E.EMPLOYEE_EMAIL,
                E.EMPLOYEE_ID
            FROM
                CONTENT C, 
                CONTENT_CHAPTER CC,
                CONTENT_CAT CA,
                EMPLOYEES E
            WHERE
                CA.CONTENTCAT_ID = CC.CONTENTCAT_ID AND
                CC.CHAPTER_ID = C.CHAPTER_ID AND
                E.EMPLOYEE_ID = C.RECORD_MEMBER
                <cfif isDefined("ID")>
                    AND C.CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.ID#">
                </cfif>
                <cfif isDefined("arguments.KEYWORD")>
                    <cfif isDefined("CONT_ST") AND CONT_ST IS "CH">
                        AND C.CHAPTER_ID = #LISTGETAT(arguments.CAT,2,"-")#
                    <cfelseif isDefined("CONT_ST") AND CONT_ST IS "CAT">
                        AND CC.CONTENTCAT_ID = #LISTGETAT(arguments.CAT,2,"-")#
                    </cfif>
                    <cfif len(arguments.KEYWORD)>
                        AND (C.CONT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.KEYWORD#%">
                        <cfif IsValid("integer", arguments.KEYWORD)>
                            OR C.CONTENT_ID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.KEYWORD#">
                        </cfif> 
                            OR C.CONT_SUMMARY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.KEYWORD#%">) 
                    </cfif>	
                </cfif>
                <cfif isdefined("attributes.content_property_id") and len(arguments.content_property_id)>
                    OR C.CONTENT_ID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.KEYWORD#">
                    AND C.CONTENT_PROPERTY_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.content_property_id#">
                </cfif>
                <cfif isdefined("attributes.language_id") and len(attributes.language_id)>
                    AND C.LANGUAGE_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.language_id#">
                </cfif>
            ORDER BY
            <cfif len(arguments.order_list) and arguments.order_list eq 4>
                C.RECORD_DATE DESC
            <cfelseif len(arguments.order_list) and arguments.order_list eq 3>
                C. RECORD_DATE 
            <cfelseif len(arguments.order_list) and arguments.order_list eq 2>
                C.CONT_HEAD DESC
            <cfelse>
                C.CONT_HEAD
            </cfif>
        </cfquery>
        <cfreturn get_content_relation>
    </cffunction>
    <cffunction name="GetAddContentRelation" access="public">
        <cfargument name="action_type" default="">
        <cfargument name="action_type_id" default="">
        <cfargument name="cid" default="">
        <cfquery name="get_add_content_relation" datasource="#DSN#">
            INSERT INTO
                CONTENT_RELATION
                (
                ACTION_TYPE,
                ACTION_TYPE_ID,
                CONTENT_ID,
                COMPANY_ID,
                RECORD_EMP,
                RECORD_DATE,
                RECORD_IP
                )
            VALUES
                (
               <cfqueryparam cfsqltype="cf_sql_varchar" value="#EncodeForHTML(arguments.action_type)#">,
               <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_type_id#">,
               <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cid#">,
               <cfqueryparam cfsqltype="cf_sql_varchar"  value="#session.ep.company_id#">,
               <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.ep.UseriD#">,
               <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
               <cfqueryparam cfsqltype="cf_sql_varchar" value="#EncodeForHTML(cgi.remote_addr)#">
                )
        </cfquery>
    </cffunction>
    <cffunction name="GetChapterHier" access="public" returntype="query">
        <cfquery name="get_chapter_hier" datasource="#dsn#">
            SELECT 
                CC.CONTENTCAT, 
                CC.CONTENTCAT_ID,
                CH.CHAPTER_ID,
                CH.CHAPTER
            FROM 
                CONTENT_CAT CC,
                CONTENT_CHAPTER CH
            WHERE 
                CC.CONTENTCAT_ID = CH.CONTENTCAT_ID 				  		
            ORDER BY
                CC.CONTENTCAT_ID
        </cfquery>
        <cfreturn get_chapter_hier>
    </cffunction> 
    <cffunction name="GetContProperty" access="public" returntype="query">
        <cfquery name="get_cont_property" datasource="#dsn#">
			SELECT 
			   CONTENT_PROPERTY_ID, 
			   NAME 
			FROM 
			   CONTENT_PROPERTY 
			WHERE
			   CONTENT_PROPERTY_ID = CONTENT_PROPERTY_ID
		</cfquery>
		<cfreturn get_cont_property>
	</cffunction>
    <cffunction name="GetContent" access="public" returntype="query">
        <cfargument name="action_type" default="">    
        <cfargument name="action_type_id" default="">    
        <cfargument name="company_id" default="">            
        <cfquery name="GET_CONTENT" datasource="#DSN#">
            SELECT DISTINCT
                CR.CONTENT_ID,
                CR.RECORD_EMP,
                C.RECORD_DATE,
                C.CONT_HEAD,
                C.CONT_SUMMARY,
                C.CONTENT_PROPERTY_ID,
                C.UPDATE_MEMBER,
                PTR.STAGE,
                C.WRITE_VERSION,
                C.UPDATE_DATE,
                CCH.CHAPTER,
                CP.NAME,
                CC.CONTENTCAT
            FROM 
                CONTENT_RELATION CR,
                CONTENT_CHAPTER CCH,
                CONTENT_CAT CC,                
                CONTENT C
                LEFT JOIN CONTENT_PROPERTY CP ON C.CONTENT_PROPERTY_ID = CP.CONTENT_PROPERTY_ID
                LEFT JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = C.PROCESS_STAGE
            WHERE 
                CR.CONTENT_ID = C.CONTENT_ID               
                AND CR.ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_type#">
                AND CR.ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_type_id#"> 
            <cfif isdefined ("arguments.company_id") and len(arguments.company_id)>
                AND CR.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
            </cfif>
                AND CC.CONTENTCAT_ID = CCH.CONTENTCAT_ID
                AND CCH.CHAPTER_ID = C.CHAPTER_ID
        </cfquery>
        <cfreturn GET_CONTENT>  
	</cffunction>
    <cffunction name="get_content_image" access="public">
        <cfargument name="content_id" default="">    
		<cftransaction>
			<cfquery name="get_content_image" datasource="#dsn#">
				SELECT
					CI.CONTIMAGE_SMALL AS PHOTO
				FROM
					CONTENT_IMAGE CI
				WHERE
					CI.CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.content_id#">
			</cfquery>
			<cfreturn get_content_image>
		</cftransaction>
	</cffunction>
    <cffunction name="EMPLOYEE_PHOTO" access="remote" returntype="query"><!----sonradan email ve telefon numarası eklendiği için numara ve email bu queryden çekildi.----->
        <cfargument name="employee_id" default="">
        <cfquery name="EMPLOYEE_PHOTO" datasource="#DSN#">
            SELECT 
                E.PHOTO,
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME,
                E2.SEX,
                EP.POSITION_NAME AS POSITION,
                E.EMPLOYEE_EMAIL,
                E.MOBILCODE,
                E.MOBILTEL,
                E2.MOBILCODE_SPC,
                E2.MOBILTEL_SPC
            FROM 
                EMPLOYEES AS E 
                LEFT JOIN EMPLOYEES_DETAIL AS E2 ON E2.EMPLOYEE_ID = E.EMPLOYEE_ID                
                LEFT JOIN EMPLOYEE_POSITIONS AS EP ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID   
            WHERE E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">               
        </cfquery>
        <cfreturn EMPLOYEE_PHOTO>
    </cffunction>
</cfcomponent>