<cfcomponent accessors="true">
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="Select" access="public">
        <cfargument name="keyword" type="string" default="">
        <cfquery name="get_group" datasource="#DSN#">
            SELECT DISTINCT
                TCG.TRAIN_GROUP_ID,
                TCG.GROUP_EMP,
                TCG.GROUP_HEAD,
                TCG.FINISH_DATE,
                TCG.QUOTA,
                TCG.PROCESS_STAGE,
                TCG.PATH,
                E.*,
                D.DEPARTMENT_HEAD,
                B.BRANCH_NAME,
                TGA.EMP_ID
            FROM
                TRAINING_CLASS_GROUP_CLASSES TCGC
                    INNER JOIN TRAINING_CLASS_GROUPS TCG ON TCG.TRAIN_GROUP_ID = TCGC.TRAIN_GROUP_ID
                    INNER JOIN TRAINING_CLASS_ATTENDER TCA ON TCGC.CLASS_ID = TCA.CLASS_ID
                    INNER JOIN TRAINING_GROUP_ATTENDERS TGA ON TGA.TRAINING_GROUP_ID = TCG.TRAIN_GROUP_ID
                    INNER JOIN EMPLOYEE_POSITIONS EPOS ON TCA.EMP_ID = EPOS.EMPLOYEE_ID
                    INNER JOIN DEPARTMENT D ON EPOS.DEPARTMENT_ID = D.DEPARTMENT_ID
                    INNER JOIN BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
                    INNER JOIN OUR_COMPANY COMP ON B.COMPANY_ID = COMP.COMP_ID
                    INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = TCG.RECORD_EMP
            WHERE
                TCG.TRAIN_GROUP_ID IS NOT NULL
                AND B.BRANCH_ID IN 
                (
                    SELECT
                        BRANCH_ID
                    FROM
                        EMPLOYEE_POSITION_BRANCHES
                    WHERE
                        POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">	
                )
                AND E.EMPLOYEE_ID = EPOS.EMPLOYEE_ID
                <!---<cfif len(class_id_list)>
                    AND TCGC.CLASS_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#class_id_list#">) 
                </cfif>--->
            <cfif isDefined("arguments.keyword") and len(arguments.keyword)>
                AND GROUP_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI 
            </cfif>

            UNION
            
            SELECT
                TCG.TRAIN_GROUP_ID,
                TCG.GROUP_EMP,
                TCG.GROUP_HEAD,
                TCG.FINISH_DATE,
                TCG.QUOTA,
                TCG.PROCESS_STAGE,
                TCG.PATH,
                E.*,
                D.DEPARTMENT_HEAD,
                B.BRANCH_NAME,
                TGA.EMP_ID
            FROM
                TRAINING_CLASS_GROUPS TCG
                    INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = TCG.RECORD_EMP
                    INNER JOIN EMPLOYEE_POSITIONS EPOS ON TCG.RECORD_EMP = EPOS.EMPLOYEE_ID
                    INNER JOIN DEPARTMENT D ON EPOS.DEPARTMENT_ID = D.DEPARTMENT_ID
                    INNER JOIN BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
                    INNER JOIN TRAINING_GROUP_ATTENDERS TGA ON TGA.TRAINING_GROUP_ID = TCG.TRAIN_GROUP_ID
            WHERE
                1=1
            <cfif isDefined("arguments.keyword") and len(arguments.keyword)>
                AND TCG.GROUP_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> 
            </cfif>
                AND E.EMPLOYEE_ID = EPOS.EMPLOYEE_ID
            ORDER BY 
                TCG.GROUP_HEAD
        </cfquery>
        <cfreturn get_group>
    </cffunction>

    <cffunction name="EMP_NAME" access="public">
        <cfquery NAME="GET_EMP_NAME" DATASOURCE="#DSN#">
            SELECT
                EMPLOYEE_NAME,
                EMPLOYEE_SURNAME
            FROM
                EMPLOYEES
            WHERE
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.EMPLOYEE_ID#">
        </cfquery>
        <cfreturn GET_EMP_NAME>
    </cffunction>

    <cffunction name="GET_PARTNER_NAME" access="remote" returntype="query">    
        <cfargument name="PARTNER_ID" default="">           
        <cfquery name="GET_PARTNER_NAME" datasource="#dsn#">
            SELECT 
                COMPANY_PARTNER.PARTNER_ID,
                COMPANY_PARTNER_NAME,
                COMPANY_PARTNER_SURNAME,
                NICKNAME,
                COMPANY.COMPANY_ID
            FROM
                COMPANY,
                COMPANY_PARTNER
            WHERE
                COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
                COMPANY_PARTNER.PARTNER_ID = #arguments.PARTNER_ID#
        </cfquery>
        <cfreturn GET_PARTNER_NAME>                        
    </cffunction>

    <cffunction name="GET_CONSUMER_NAME" access="remote" returntype="query">
        <cfargument name="consumer_id" default="">
        <cfquery name="GET_CONSUMER_NAME" datasource="#DSN#">
            SELECT 
                C.CONSUMER_ID,
                C.CONSUMER_NAME,
                C.CONSUMER_SURNAME
            FROM 
                CONSUMER C
            WHERE C.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
        </cfquery>
        <cfreturn GET_CONSUMER_NAME>
    </cffunction>

    <cffunction name="class_num" access="public">
        <cfquery name="get_class_num" datasource="#DSN#">
            SELECT
                COUNT(CLASS_ID) AS TOT
            FROM
                TRAINING_CLASS_GROUP_CLASSES
            WHERE
                TRAIN_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TRAIN_GROUP_ID#">
        </cfquery>
        <cfreturn get_class_num>
    </cffunction>
    <cffunction name="SELECTSITE_MENU" access="public">
        <cfquery name="GET_SITE_MENU" datasource="#DSN#">
            SELECT MENU_ID,SITE_DOMAIN,OUR_COMPANY_ID FROM MAIN_MENU_SETTINGS WHERE SITE_DOMAIN IS NOT NULL
        </cfquery>
        <cfreturn GET_SITE_MENU>
    </cffunction>
    <cffunction name="ADDDB" access="public" returnType="any">
        <cfargument name="group_head" type="string" default="">
        <cfargument name="group_detail" type="string" default="">
        <cfargument name="employee_id" default="">
        <cfargument name="is_internet" default="">
        <cfargument name="process_stage" default="">
        <cfargument name="statu">
        <cfargument name="start_date" type="date" default="">
        <cfargument name="finish_date" type="date" default="">
        <cfquery name="ADD_DB" datasource="#DSN#">
            INSERT INTO 
                TRAINING_CLASS_GROUPS
                (
                    GROUP_HEAD,
                    GROUP_DETAIL,
                    GROUP_EMP,
                    IS_INTERNET,
                    START_DATE,
                    FINISH_DATE,
                    RECORD_EMP,
                    RECORD_DATE,
                    RECORD_IP,
                    PROCESS_STAGE,
                    QUOTA,
                    DEPARTMENT_ID,
                    BRANCH_ID,
                    STATU
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.group_head#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.group_detail#">,
                    <cfif len(arguments.employee_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">,<cfelse>NULL,</cfif>
                    <cfif isdefined('arguments.is_internet') and arguments.is_internet eq 1><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
                    <cfif len(arguments.start_date)><cfqueryparam cfsqltype="cf_sql_date" value="#arguments.start_date#">,<cfelse>NULL,</cfif>
                    <cfif len(arguments.finish_date)><cfqueryparam cfsqltype="cf_sql_date" value="#arguments.finish_date#">,<cfelse>NULL,</cfif>
                    #session.ep.userid#,
                    #now()#,
                    '#cgi.remote_user#',
                    <cfif isdefined('arguments.process_stage') and len(arguments.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#"><cfelse>NULL</cfif>,
                    <cfif isdefined('arguments.quota') and len(arguments.quota)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.quota#"><cfelse>NULL</cfif>,
                    <cfif isdefined('arguments.department_id') and len(arguments.department_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined('arguments.branch_id') and len(arguments.branch_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined('arguments.statu') and arguments.statu eq 1><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>
                )
        </cfquery>
        <cfreturn>
        <cf_workcube_process 
            is_upd='0'
            data_source='#dsn#'
            old_process_line='0'
            process_stage='#arguments.process_stage#'
            record_member='#session.ep.userid#'
            record_date='#now()#'
            action_table='TRAINING_CLASS_GROUPS'
            action_column='TRAIN_GROUP_ID'
            action_id='#get_class_id.train_group_id#'
            action_page='#request.self#?fuseaction=training_management.list_training_groups&event=det&train_group_id=#get_class_id.train_group_id#'
            warning_description="#getLang('','İzin',58575)#: #get_class_id.train_group_id#">
    </cffunction>

    <cffunction name="UPDDB" access="public" returnType="any">
        <cfargument name="group_head" type="string" default="">
        <cfargument name="group_detail" type="string" default="">
        <cfargument name="employee_id">
        <cfargument name="is_internet">
        <cfargument name="process_stage" default="">
        <cfargument name="start_date" type="date" default="">
        <cfargument name="finish_date" type="date" default="">
        <cfargument name="train_group_id">
        <cfargument name="statu">
        <cf_date tarih = "arguments.start_date">
        <cf_date tarih = "arguments.finish_date">
        <cftry>
            <cfset responseStruct = structNew()>
            <cfquery name="UPD_DB" datasource="#DSN#">
                UPDATE
                    TRAINING_CLASS_GROUPS
                SET
                    GROUP_HEAD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.group_head#">,
                    GROUP_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.group_detail#">,
                    GROUP_EMP = <cfif len(arguments.employee_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">,<cfelse>NULL,</cfif>
                    IS_INTERNET = <cfif isdefined('arguments.is_internet') and arguments.is_internet eq 1><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
                    START_DATE = <cfif len(arguments.start_date)><cfqueryparam cfsqltype="cf_sql_date" value="#arguments.start_date#">,<cfelse>NULL,</cfif>
                    FINISH_DATE = <cfif len(arguments.finish_date)><cfqueryparam cfsqltype="cf_sql_date" value="#arguments.finish_date#">,<cfelse>NULL,</cfif>
                    UPDATE_EMP = #session.ep.userid#,
                    UPDATE_DATE = #NOW()#,
                    UPDATE_IP = '#CGI.REMOTE_USER#',
                    PROCESS_STAGE = <cfif isdefined('arguments.process_stage') and len(arguments.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#"><cfelse>NULL</cfif>,
                    QUOTA = <cfif isdefined('arguments.quota') and len(arguments.quota)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.quota#"><cfelse>NULL</cfif>,
                    DEPARTMENT_ID = <cfif isdefined('arguments.department_id') and len(arguments.department_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#"><cfelse>NULL</cfif>,BRANCH_ID = <cfif isdefined('arguments.branch_id') and len(arguments.branch_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#"><cfelse>NULL</cfif>,
                    STATU = <cfif isdefined('arguments.statu') and arguments.statu eq 1><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>
                WHERE
                    TRAIN_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.train_group_id#">
            </cfquery>
            <cfif isdefined("arguments.is_internet") and arguments.is_internet eq 1>
                <cfset cmp = createObject("component","V16.training_management.cfc.training_management")>
                <cfset GET_COMPANY = cmp.GET_COMPANY_F()>
                <cfoutput query="get_company">
                    <cfif isdefined("arguments.menu_#menu_id#")>
                        <cfset TRAINING_GROUP_SITE_DOMAIN = trainingSiteDomain
                        (
                            train_group_id : arguments.train_group_id,
                            MENU_ID:arguments["menu_#menu_id#"]
                        )/>
                    </cfif>
                </cfoutput>
            </cfif>
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = ''>
        <cfcatch type="database">
            <cftransaction action="rollback">
            <cfset responseStruct.message = "İşlem Hatalı">
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = cfcatch>
        </cfcatch>
        </cftry>
        <cfreturn responseStruct>
            <cf_workcube_process 
                is_upd='1'
                data_source='#dsn#'
                old_process_line='#attributes.old_process_line#'
                process_stage='#arguments.process_stage#'
                record_member='#session.ep.userid#'
                record_date='#now()#'
                action_table='TRAINING_CLASS_GROUPS'
                action_column='TRAIN_GROUP_ID'
                action_id='#get_class_id.train_group_id#'
                action_page='#request.self#?fuseaction=training_management.list_training_groups&event=det&train_group_id=#get_class_id.train_group_id#'
                warning_description="#getLang('','İzin',58575)#: #get_class_id.train_group_id#">
    </cffunction>

     <cffunction name="DELDB" access="public" returnType="any">
        <cfargument name="train_group_id">
        <cftry>
            <cfset responseStruct = structNew()>
            <cfquery name="DEL_DB" datasource="#DSN#">
                DELETE FROM
                    TRAINING_CLASS_GROUPS
                WHERE
                    TRAIN_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.train_group_id#">
            </cfquery>
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = ''>
        <cfcatch type="database">
            <cftransaction action="rollback">
            <cfset responseStruct.message = "İşlem Hatalı">
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = cfcatch>
        </cfcatch>
        </cftry>
        <cfreturn responseStruct>
    </cffunction>

    <cffunction name="CLASS_ID" access="public">
        <cfquery name="GET_CLASS_ID" datasource="#DSN#">
            SELECT
                MAX(TRAIN_GROUP_ID) AS TRAIN_GROUP_ID
            FROM
                TRAINING_CLASS_GROUPS
        </cfquery>
        <cfreturn GET_CLASS_ID>
    </cffunction>

    <cffunction name="GETCOMPANY" access="public">
        <cfquery name="GET_COMPANY" datasource="#DSN#">
            SELECT MENU_ID,SITE_DOMAIN,OUR_COMPANY_ID FROM MAIN_MENU_SETTINGS WHERE SITE_DOMAIN IS NOT NULL AND IS_ACTIVE = 1
        </cfquery>
        <cfreturn GET_COMPANY>
    </cffunction>
    <cffunction name="trainingSiteDomain" access="public">
        <cfargument name="train_group_id">
        <cfargument name="menu_id">
        <cfquery name="TRAINING_SITE_DOMAIN" datasource="#DSN#">
            INSERT INTO
                TRAINING_CLASS_GROUPS_SITE_DOMAIN
                (
                    TRAINING_CLASS_GROUP_ID,		
                    MENU_ID
                )
            VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.train_group_id#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.menu_id#">
                )	
        </cfquery>
    </cffunction> 
    <cffunction name="getSiteDomain" access="public">
        <cfargument name="train_group_id">
        <cfquery name="GET_SITE_DOMAIN" datasource="#DSN#">
            SELECT 
                TRAINING_CLASS_GROUP_ID, 
                MENU_ID 
            FROM 
                TRAINING_CLASS_GROUPS_SITE_DOMAIN 
            WHERE 
                TRAINING_CLASS_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.train_group_id#">
        </cfquery>
        <cfreturn GET_SITE_DOMAIN>
    </cffunction> 


    <cffunction name="DELETE_SITE_DOMAIN" access="public">
        <cfquery name="DEL_SITE_DOMAIN" datasource="#DSN#">
            DELETE FROM TRAINING_CLASS_GROUPS_SITE_DOMAIN WHERE TRAINING_CLASS_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.train_group_id#">
        </cfquery>
    </cffunction>

    <cffunction name="add_training_group_subjects" access="public">
		 <cfargument name="RECORD_DATE" default="#NOW()#">
		 <cfargument name="RECORD_EMP" default="">
		 <cfargument name="RECORD_IP" default="">
		 <cfargument name="train_group_id" default="">
		 <cfargument name="TRAINING_SEC_ID" default="">
		 <cfargument name="TRAINING_CAT_ID" default="">
		 <cfargument name="TRAIN_ID" default="">

		<cftransaction>
        <cfquery name="add_training_group_subjects" datasource="#dsn#" result="query">
			INSERT INTO
				TRAINING_GROUP_SUBJECTS
				(
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP,
					TRAINING_GROUP_ID,
                    <cfif isDefined("arguments.TRAINING_SEC_ID") and len("arguments.TRAINING_SEC_ID")>
					    TRAINING_SEC_ID,
                    </cfif>
                    <cfif isDefined("arguments.TRAINING_CAT_ID") and len("arguments.TRAINING_CAT_ID")>
					    TRAINING_CAT_ID,
                    </cfif>
					TRAIN_ID,
                    STATUS
				)
			VALUES
				(
					#now()#,
					#SESSION.EP.USERID#,
					'#CGI.REMOTE_ADDR#',
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.train_group_id#">,
                    <cfif isDefined("arguments.TRAINING_SEC_ID") and len(arguments.TRAINING_SEC_ID)>
					    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TRAINING_SEC_ID#">
                    <cfelse>
                        0
                    </cfif>,
                    <cfif isDefined("arguments.TRAINING_CAT_ID") and len(arguments.TRAINING_CAT_ID)>
					    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TRAINING_CAT_ID#">
                    <cfelse>
                        0
                    </cfif>,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TRAIN_ID#">,
                    1
				)
		</cfquery>
		<cfreturn query>
        </cftransaction>
    </cffunction>

    <cffunction name="add_note_to_attender" access="public">
		 <cfargument name="attender_note" default="">
		 <cfargument name="attender_id" default="">

		<cftransaction>
        <cfquery name="add_note_to_attender" datasource="#dsn#" result="query">
			UPDATE TRAINING_GROUP_ATTENDERS
            SET NOTE_FOR_ATTENDER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.attender_note#">	
			WHERE TRAINING_GROUP_ATTENDERS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.attender_id#">
		</cfquery>
		<cfreturn query>
        </cftransaction>
    </cffunction>

    <cffunction name="remove_training_group_subjects" access="public">
		 <cfargument name="train_group_id" default="">
		 <cfargument name="subject_id" default="">
		 <cfargument name="train_id" default="">
		<cftransaction>
        <cfquery name="remove_training_group_subjects" datasource="#dsn#" result="query">
			UPDATE
				TRAINING_GROUP_SUBJECTS
            SET
				STATUS = 0
			WHERE
                TRAINING_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.train_group_id#">
                AND TRAINING_GROUP_SUBJECTS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.subject_id#">
                AND TRAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.train_id#">
		</cfquery>
		<cfreturn query>
        </cftransaction>
    </cffunction>
	
	<cffunction name="get_training_group_subjects" access="public">
        <cfargument name="train_group_id" default="">
	    <cftransaction>
	        <cfquery name="get_training_group_subjects" datasource="#dsn#">
	        	SELECT
					T.*,
                    TGS.*
				FROM
					TRAINING_GROUP_SUBJECTS TGS
				        INNER JOIN TRAINING T ON TGS.TRAIN_ID = T.TRAIN_ID
                        INNER JOIN TRAINING_CLASS_GROUPS TCG ON TGS.TRAINING_GROUP_ID = TCG.TRAIN_GROUP_ID
                WHERE
                    TGS.TRAINING_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.train_group_id#">
            </cfquery>
	        <cfreturn get_training_group_subjects>
	    </cftransaction>
	</cffunction>
	
	<cffunction name="get_training_group_subjects_all" access="public">
	    <cftransaction>
	        <cfquery name="get_training_group_subjects_all" datasource="#dsn#" result="query">
	        	SELECT
					T.*
				FROM
					TRAINING T
            </cfquery>
	        <cfreturn get_training_group_subjects_all>
	    </cftransaction>
	</cffunction>
	
	<cffunction name="get_departments" access="public">
	    <cftransaction>
	        <cfquery name="get_departments" datasource="#DSN#">
                SELECT
                    D.BRANCH_ID,
                    D.DEPARTMENT_ID,
                    D.DEPARTMENT_HEAD,
                    B.BRANCH_NAME
                FROM
                    DEPARTMENT D
                        INNER JOIN BRANCH B ON B.BRANCH_ID = D.BRANCH_ID
                WHERE
                    D.DEPARTMENT_STATUS = 1
                    AND D.IS_STORE <> 1
            </cfquery>
	        <cfreturn get_departments>
	    </cftransaction>
	</cffunction>
	
	<cffunction name="get_lessons" access="public">
        <cfargument name="lesson_id" default="">
	    <cftransaction>
	        <cfquery name="get_lessons" datasource="#DSN#">
                SELECT
                    T.*
                FROM
                    TRAINING_CLASS T
                WHERE
                    T.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.lesson_id#">
            </cfquery>
	        <cfreturn get_lessons>
	    </cftransaction>
	</cffunction>

    <cffunction name="get_training_group" access="public">
        <cfargument name="train_group_id" default="">
	    <cftransaction>
	        <cfquery name="get_training_group" datasource="#DSN#">
                SELECT
                    TCG.*
                FROM
                    TRAINING_CLASS_GROUPS TCG
                WHERE
                    TCG.TRAIN_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.train_group_id#">
            </cfquery>
	        <cfreturn get_training_group>
	    </cftransaction>
	</cffunction>

    <cffunction name="get_training_class_group" access="public">
        <cfargument name="class_id" default="">
	    <cftransaction>
	        <cfquery name="get_training_class_group" datasource="#DSN#">
                SELECT
                    TCG.GROUP_HEAD,
                    TCGC.CLASS_GROUP_ID,
                    TCGC.TRAIN_GROUP_ID
                FROM
                    TRAINING_CLASS_GROUPS TCG 
                    LEFT JOIN TRAINING_CLASS_GROUP_CLASSES TCGC ON TCG.TRAIN_GROUP_ID = TCGC.TRAIN_GROUP_ID
                    LEFT JOIN TRAINING_CLASS TC ON TC.CLASS_ID=TCGC.CLASS_ID
                WHERE
                    TC.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#">
            </cfquery>
	        <cfreturn get_training_class_group>
	    </cftransaction>
	</cffunction>
	
	<cffunction name="get_training_subject_quizs" access="public">
        <cfargument name="train_subject_id" default="">
	    <cftransaction>
	        <cfquery name="get_training_subject_quizs" datasource="#dsn#">
	        	SELECT TOP 1
					QTS.*,
                    Q.*,
                    QU.*
				FROM
					QUIZ_TRAINING_SUBJECTS QTS
                        INNER JOIN QUIZ Q ON Q.QUIZ_ID = QTS.QUIZ_ID
                        INNER JOIN QUIZ_QUESTIONS QQ ON QQ.QUIZ_ID = QTS.QUIZ_ID
                        INNER JOIN QUESTION QU ON QU.QUESTION_ID = QQ.QUESTION_ID
                WHERE
                    TRAINING_SUBJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.train_subject_id#">
                ORDER BY NEWID()
            </cfquery>
	        <cfreturn get_training_subject_quizs>
	    </cftransaction>
	</cffunction>
	
	<cffunction name="get_content_questions" access="public">
        <cfargument name="cntid" default="">
	    <cftransaction>
	        <cfquery name="get_content_questions" datasource="#dsn#">
	        	SELECT TOP 1
					Q.*
				FROM
					QUESTION Q
                        INNER JOIN CONTENT_QUESTIONS CQ ON CQ.QUESTION_ID = Q.QUESTION_ID
                WHERE
                    CQ.CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cntid#">
                ORDER BY NEWID()
            </cfquery>
	        <cfreturn get_content_questions>
	    </cftransaction>
	</cffunction>

	<cffunction name="get_training_groups" access="public">
        <cfargument name="keyword" default="">
        <cfargument name="status" default="">
	    <cftransaction>
	        <cfquery name="get_training_groups" datasource="#DSN#">
                SELECT
                    TCG.*
                FROM
                    TRAINING_CLASS_GROUPS TCG
                WHERE
                    1=1
                    <cfif isDefined("arguments.keyword") and len(arguments.keyword)>
                        AND TCG.GROUP_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> 
                    </cfif>
                    <cfif isDefined("arguments.status") and len(arguments.status) AND arguments.status EQ 1>
                        AND TCG.FINISH_DATE >= #now()#
                    <cfelseif isDefined("arguments.status") and len(arguments.status) AND arguments.status EQ 0>
                        AND TCG.FINISH_DATE < #now()#
                    </cfif>
            </cfquery>
	        <cfreturn get_training_groups>
	    </cftransaction>
	</cffunction>

	<cffunction name="get_training_groups_list" access="public">
        <cfargument name="keyword" default="">
        <cfargument name="status" default="">
	    <cftransaction>
	        <cfquery name="get_training_groups_list" datasource="#DSN#">
                SELECT DISTINCT
                    TCG.*,
                    E.*,
                    D.DEPARTMENT_HEAD,
                    B.BRANCH_NAME
                FROM
                    TRAINING_CLASS_GROUPS TCG
                        INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = TCG.GROUP_EMP
                        INNER JOIN EMPLOYEE_POSITIONS EPOS ON E.EMPLOYEE_ID = EPOS.EMPLOYEE_ID
                        INNER JOIN DEPARTMENT D ON EPOS.DEPARTMENT_ID = D.DEPARTMENT_ID
                        INNER JOIN BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
                WHERE
                    1=1
                    <cfif isDefined("arguments.keyword") and len(arguments.keyword)>
                        AND TCG.GROUP_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> 
                    </cfif>
            </cfquery>
	        <cfreturn get_training_groups_list>
	    </cftransaction>
	</cffunction>
	
	<cffunction name="GET_TRAININGS" access="public">
        <cfargument name="train_group_id" default="">
	    <cftransaction>
	        <cfquery name="GET_TRAININGS" datasource="#DSN#">
                SELECT
                    TC.*,
                    TCG.*
                FROM
                    TRAINING_CLASS_GROUP_CLASSES TCG,
                    TRAINING_CLASS TC
                WHERE
                    TC.CLASS_ID=TCG.CLASS_ID
                AND
                    TCG.TRAIN_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.train_group_id#">
            </cfquery>
	        <cfreturn GET_TRAININGS>
	    </cftransaction>
	</cffunction>
	
	<cffunction name="get_training_group_attenders" access="public">
        <cfargument name="train_group_id" default="">
	    <cftransaction>
	        <cfquery name="get_training_group_attenders" datasource="#DSN#">
                SELECT
                    TGCA.*,
                    TC.*
                FROM
                    TRAINING_GROUP_CLASS_ATTENDANCE TGCA
                        INNER JOIN TRAINING_CLASS TC ON TC.CLASS_ID = TGCA.CLASS_ID
                WHERE
                    TGCA.TRAINING_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.train_group_id#">
                    AND TGCA.STATUS = 1
            </cfquery>
	        <cfreturn get_training_group_attenders>
	    </cftransaction>
	</cffunction>
	
	<cffunction name="get_training_group_attenders_count" access="public">
        <cfargument name="train_group_id" default="">
	    <cftransaction>
	        <cfquery name="get_training_group_attenders_count" datasource="#DSN#">
                SELECT
                    TGCA.EMP_ID
                FROM
                    TRAINING_GROUP_CLASS_ATTENDANCE TGCA
                WHERE
                    TGCA.TRAINING_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.train_group_id#">
                GROUP BY EMP_ID
            </cfquery>
	        <cfreturn get_training_group_attenders_count>
	    </cftransaction>
	</cffunction>
    <cffunction name="addClassToTrainingGroup" access="public">
        <cfargument name="train_group_id">
        <cfargument name="class_id">
        <cfquery name="addClassToTrainingGroup" datasource="#DSN#">
            INSERT INTO 
			TRAINING_CLASS_GROUP_CLASSES
			(
				CLASS_ID,
				TRAIN_GROUP_ID,
				RECORD_EMP,
				RECORD_IP,
				RECORD_DATE
			)
		VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.train_group_id#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">,
				'#CGI.REMOTE_USER#',
				#NOW()#
			)	
        </cfquery>
        <cfquery name="attendance_check" datasource="#DSN#">
            SELECT
                *
            FROM
                TRAINING_GROUP_CLASS_ATTENDANCE
            WHERE
                CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#"> AND
                TRAINING_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.train_group_id#"> AND
                STATUS = 1
        </cfquery>
        <cfif not attendance_check.RECORDCOUNT>
            <cfquery name="get_attender" datasource="#DSN#">
                SELECT
                    *
                FROM
                    TRAINING_GROUP_ATTENDERS
                WHERE
                    TRAINING_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.train_group_id#">
            </cfquery>
            <cfloop query="get_attender">
                <cfquery name="add_att" datasource="#DSN#">
                    INSERT INTO 
                        TRAINING_GROUP_CLASS_ATTENDANCE
                        (
                            CLASS_ID,
                            TRAINING_GROUP_ID,
                            TRAINING_GROUP_ATTENDERS_ID,
                            STATUS,
                            JOINED,
                            NOTE,
                            PROCESS_STAGE
                            <cfif get_attender.EMP_ID gt 0>
                                ,EMP_ID
                            <cfelseif get_attender.PAR_ID gt 0>
                                ,PAR_ID
                            <cfelseif get_attender.COMP_ID gt 0>
                                ,COMP_ID
                            </cfif>
                        )
                    VALUES
                        (
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.train_group_id#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#get_attender.TRAINING_GROUP_ATTENDERS_ID#">,
                            1,
                            0,
                            0,
                            298
                            <cfif get_attender.EMP_ID gt 0>
                                ,<cfqueryparam cfsqltype="cf_sql_integer" value="#get_attender.EMP_ID#">
                            <cfelseif get_attender.PAR_ID gt 0>
                                ,<cfqueryparam cfsqltype="cf_sql_integer" value="#get_attender.PAR_ID#">
                            <cfelseif get_attender.COMP_ID gt 0>
                                ,<cfqueryparam cfsqltype="cf_sql_integer" value="#get_attender.COMP_ID#">
                            </cfif>
                        )
                </cfquery>
            </cfloop>
        </cfif>
    </cffunction> 

    <cffunction name="add_join_request_to_training_group" access="remote" returnType="any">
        <cfargument name="train_group_id">
        <cfargument name="user_id">
        <cftry>
            <cfset responseStruct = structNew()>
            <cfquery name="add_join_request_to_training_group" datasource="#DSN#">
                INSERT INTO 
                    TRAINING_GROUP_ATTENDERS
                    (
                        TRAINING_GROUP_ID,
                        STATUS,
                        JOIN_REQUEST,
                        EMP_ID,
                        JOIN_STATU
                    )
                VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.train_group_id#">,
                        0,
                        1,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.user_id#">,
                        0
                    )
            </cfquery>
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = ''>
        <cfcatch type="database">
            <cftransaction action="rollback">
            <cfset responseStruct.message = "İşlem Hatalı">
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = cfcatch>
        </cfcatch>
        </cftry>
        <cfreturn responseStruct>
    </cffunction>

    <cffunction name="get_requested_attender_check" access="public" returnType="any">
        <cfargument name="train_group_id">
        <cfargument name="user_id">
        <cfquery name="get_requested_attender_check" datasource="#DSN#">
            SELECT TOP 1 * FROM TRAINING_GROUP_ATTENDERS
            WHERE TRAINING_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.train_group_id#">
            AND EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.user_id#">
            ORDER BY TRAINING_GROUP_ATTENDERS_ID DESC
        </cfquery>
        <cfreturn get_requested_attender_check>
    </cffunction>

    <cffunction name="get_requested_attenders" access="public" returnType="any">
        <cfargument name="train_group_id">
        <cfargument name="user_id">
        <cfquery name="get_requested_attenders" datasource="#DSN#">
            SELECT * FROM TRAINING_GROUP_ATTENDERS
            WHERE TRAINING_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.train_group_id#">
            AND JOIN_REQUEST = 1
        </cfquery>
        <cfreturn get_requested_attenders>
    </cffunction>

    <cffunction name="accept_request" access="remote" returnType="any">
        <cfargument name="train_group_id">
        <cfargument name="user_id">
        <cfquery name="accept_request" datasource="#DSN#">
            UPDATE
                TRAINING_GROUP_ATTENDERS
            SET
                JOIN_REQUEST = 0,
                JOIN_STATU = 1,
                STATUS = 1
            WHERE TRAINING_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.train_group_id#">
            AND EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.user_id#">
        </cfquery>
    </cffunction>

    <cffunction name="reject_request" access="remote" returnType="any">
        <cfargument name="train_group_id">
        <cfargument name="user_id">
        <cfquery name="reject_request" datasource="#DSN#">
            UPDATE
                TRAINING_GROUP_ATTENDERS
            SET
                JOIN_REQUEST = 0,
                JOIN_STATU = 3,
                STATUS = 0
            WHERE TRAINING_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.train_group_id#">
            AND EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.user_id#">
        </cfquery>
    </cffunction>

    <cffunction name="send_mail_for_requests" access="remote" returnType="any">
        <cfargument name="user_id">
        <cfargument name="group_head">
        <cfargument name="reason">
        <cfargument name="mail_for">
        <cfquery name="get_employee" datasource="#dsn#">
            SELECT 
                EMPLOYEE_EMAIL,
                EMPLOYEE_SURNAME,
                EMPLOYEE_ID,
                EMPLOYEE_NAME
            FROM 
                EMPLOYEES
            WHERE 
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.user_id#"> AND 
                NOT (EMPLOYEE_EMAIL IS NULL OR EMPLOYEE_EMAIL = '')
        </cfquery>
        <cfif get_employee.recordcount>
            <cfset result = structNew()>
            <cftry>
                <cfmail
                    to="#get_employee.employee_email#"
                    from="#session.ep.company_email#"
                    subject="#arguments.group_head#"
                    type="HTML"
                    usessl="true"
                    charset="utf-8">
                    <cfoutput>
                        <cfif arguments.mail_for eq 3>
                            <cf_get_lang dictionary_id='65254.Sınıf katılımcı listesinden çıkarıldınız'>: #arguments.reason#
                        <cfelseif arguments.mail_for eq 2>
                            <cf_get_lang dictionary_id='65255.Sınıf katılımcı listesinde beklemeye alındınız'>: #arguments.reason#
                        <cfelseif arguments.mail_for eq 1>
                            <cf_get_lang dictionary_id='65256.Sınıf katılımcı listesine kesin kaydınız yapıldı'>: #arguments.reason#
                        </cfif>
                    </cfoutput>
                </cfmail>
            <cfcatch type="any">
                <cfset result['sent'] = false />
            </cfcatch>
            </cftry>
            <cfset result['sent'] = true />
            <cfreturn "#SerializeJSON(result)#">
        </cfif>
    </cffunction>
</cfcomponent>