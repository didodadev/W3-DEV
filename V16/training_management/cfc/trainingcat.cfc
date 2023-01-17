<!---29.06.2019- ceren - eğitim kataloğu genel cfc dosyası insert,delete,update,select işlemleri eklendi --->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="cat" access="public">
		 <cfargument name="record_date" default="#NOW()#">
		 <cfargument name="RECORD_EMP" default="">
		 <cfargument name="RECORD_IP" default="">
		 <cfargument name="TRAIN_HEAD" default="">
		 <cfargument name="TRAIN_OBJECTIVE" default="">
		 <cfargument name="TRAIN_DETAIL" default="">
		 <cfargument name="SUBJECT_STATUS" default="">
		 <cfargument name="SUBJECT_CURRENCY_ID"  default="">
		 <cfargument name="TRAINER_EMP"  default="">
		 <cfargument name="TRAINER_PAR"  default="">
		 <cfargument name="TRAINER_CONS" default="">
		 <cfargument name="TRAINING_SEC_ID" default="">
		 <cfargument name="TRAINING_CAT_ID" default="">
		 <cfargument name="TRAINING_STYLE" default="">
		 <cfargument name="TRAINING_TYPE" default="">
		 <cfargument name="TOTAL_DAY"  default="">
		 <cfargument name="TRAINING_EXPENSE" default="">
		 <cfargument name="MONEY_CURRENCY" type="string" default="">
		 <cfargument name="member_type"  default="">
		 <cfargument name="TOTALDAY"  default="">
		 <cfargument name="EXPENSE"  default="">
		 <cfargument name="MONEY" default="">
		 <cfargument name="product_id" default="">
		<cfargument name="total_hours" default="">
		<cfargument name="process_stage" default="">
		<cfargument name="language_id" default="">
		<cftransaction>
        <cfquery name="ADD_TRAINING" datasource="#dsn#" result="query">
			INSERT 
			INTO
				TRAINING
				(
					RECORD_DATE,
					RECORD_EMP, 
					RECORD_IP,
					TRAIN_HEAD, 
					TRAIN_OBJECTIVE, 
					TRAIN_DETAIL, 
					SUBJECT_STATUS,
					<cfif isdefined("CURRENCY_ID") and len(CURRENCY_ID)> SUBJECT_CURRENCY_ID,</cfif>
					TRAINER_EMP,
					TRAINER_PAR,
					TRAINER_CONS,
					TRAINING_SEC_ID,
					TRAINING_CAT_ID,
					TRAINING_STYLE,
					TRAINING_TYPE,
					TOTAL_DAY,
					TRAINING_EXPENSE,
					MONEY_CURRENCY,
					PRODUCT_ID,
					TOTAL_HOURS,
					TRAINING_STAGE,
                    LANGUAGE
				)
			VALUES
				(
					#now()#,
					#SESSION.EP.USERID#,
					'#CGI.REMOTE_ADDR#',
					<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.TRAIN_HEAD#">,
					<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.TRAIN_OBJECTIVE#">,
					<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.TRAIN_DETAIL#">,
					<cfif isDefined("arguments.SUBJECT_STATUS") and len(arguments.SUBJECT_STATUS)>1,<cfelse>0,</cfif>
					<cfif isdefined("CURRENCY_ID") and len(CURRENCY_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.CURRENCY_ID#">,</cfif>
					<cfif arguments.member_type eq "employee">
						<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TRAINER_EMP#">,
						NULL,
						NULL,
					<cfelseif arguments.member_type eq "partner">
						NULL,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TRAINER_PAR#">,
						NULL,
					<cfelseif arguments.member_type eq "consumer">
						NULL,
						NULL,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TRAINER_CONS#">,
					<cfelse>
						NULL,
						NULL,
						NULL,	
					</cfif>
					<cfif isdefined("arguments.training_sec_id") and len(arguments.training_sec_id) and arguments.training_sec_id NEQ 0>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.training_sec_id#">,
					<cfelse>
						NULL,
					</cfif>
					<cfif isdefined("arguments.training_cat_id") and len(arguments.training_cat_id) and arguments.training_cat_id NEQ 0>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.training_cat_id#">,
					<cfelse>
						NULL,
					</cfif>
					<cfif len(arguments.training_style)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.training_style#">,<cfelse>NULL,</cfif>
					<cfif len(arguments.training_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.training_type#"> ,<cfelse>NULL,</cfif>
					<cfif len(arguments.totalday)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.totalday#">,<cfelse>NULL,</cfif>
					<cfif len(arguments.expense)>#arguments.expense#,<cfelse>NULL,</cfif>
					'#arguments.money#',
					<cfif isdefined("arguments.product_id") and len(arguments.product_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"><cfelse>NULL</cfif>,
					<cfif isdefined("arguments.total_hours") and len(arguments.total_hours)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.total_hours#"><cfelse>NULL</cfif>,
					<cfif isdefined("arguments.process_stage") and len(arguments.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#"><cfelse>NULL</cfif>,
					<cfif isdefined("arguments.language_id") and len(arguments.language_id)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.language_id#"><cfelse>NULL</cfif>
				)
		</cfquery>
		<cfreturn query>
        </cftransaction>
    </cffunction>
	<cffunction name="del" access="public">
		<cfargument name="TRAIN_ID" default="">
		    <cftransaction>
			  <cfquery name="DEL_TRAINING" datasource="#dsn#" result="query">
				DELETE FROM
					TRAINING
				WHERE
					TRAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TRAIN_ID#">
			  </cfquery>
			  <cfreturn query>
	        </cftransaction>
	</cffunction>
	
	<cffunction name="update" access="remote"  returntype="any">
		<cfargument name="UPDATE_DATE" default="#NOW()#">
		<cfargument name="UPDATE_EMP" default=""> 
		<cfargument name="UPDATE_IP" default="">
		<cfargument name="TRAIN_HEAD" default="">
		<cfargument name="TRAIN_OBJECTIVE" default="">
		<cfargument name="TRAIN_DETAIL" default="">
		<cfargument name="SUBJECT_STATUS" default="">
		<cfargument name="SUBJECT_CURRENCY_ID" default="">
		<cfargument name="TRAIN_PARTNERS" default="">
		<cfargument name="TRAIN_CONSUMERS" default="">
		<cfargument name="TRAIN_DEPARTMENTS" default="">
		<cfargument name="TRAIN_POSITION_CATS" default="">
		<cfargument name="TRAINER_EMP" default="">
		<cfargument name="TRAINER_PAR" default="">
		<cfargument name="TRAINER_CONS" default="">
		<cfargument name="TRAINING_SEC_ID" default="">
		<cfargument name="TRAINING_CAT_ID" default="">
		<cfargument name="TRAINING_STYLE" default="">
		<cfargument name="TRAINING_TYPE" default="">
		<cfargument name="TOTAL_DAY" default="">
		<cfargument name="TRAINING_EXPENSE" default="">
		<cfargument name="MONEY_CURRENCY" type="string" default="">
		<cfargument name="member_type" default="">
		<cfargument name="TOTALDAY" default="">
		<cfargument name="EXPENSE" default="">
		<cfargument name="MONEY" default="">
		<cfargument name="product_id" default="">
		<cfargument name="total_hours" default="">
		<cfargument name="process_stage" default="">
		<cfargument name="fuseaction" default="">
		<cfargument name="language_id" default="">
		    <cftransaction>
			    <cfquery name="UPD_TRAINING" datasource="#dsn#">
				UPDATE
			        TRAINING
				SET
					UPDATE_DATE = #now()#,
					UPDATE_EMP = #SESSION.EP.USERID#,
					UPDATE_IP = '#CGI.REMOTE_ADDR#',
					TRAIN_HEAD = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.TRAIN_HEAD#">,
					TRAIN_OBJECTIVE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.TRAIN_OBJECTIVE#">,
					TRAIN_DETAIL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.TRAIN_DETAIL#">,
					SUBJECT_STATUS = <cfif len(SUBJECT_STATUS)>#SUBJECT_STATUS#, <cfelse> 0,</cfif>
					<cfif isdefined("CURRENCY_ID") and len(CURRENCY_ID)>#CURRENCY_ID#,</cfif>
					<cfif isDefined("FORM.TRAIN_PARTNERS")> TRAIN_PARTNERS =',#TRAIN_PARTNERS#,',<cfelse> TRAIN_PARTNERS = NULL, </cfif>
					<cfif isDefined("FORM.TRAIN_CONSUMERS")> TRAIN_CONSUMERS = ',#TRAIN_CONSUMERS#,', <cfelse>TRAIN_CONSUMERS = NULL,</cfif>
			        <cfif isDefined("FORM.TRAIN_DEPARTMENTS")>TRAIN_DEPARTMENTS = ',#TRAIN_DEPARTMENTS#,', <cfelse>TRAIN_DEPARTMENTS = NULL,</cfif>
			        <cfif isDefined("FORM.TRAIN_POSITION_CATS")> TRAIN_POSITION_CATS = ',#TRAIN_POSITION_CATS#,', <cfelse> TRAIN_POSITION_CATS = NULL,</cfif>
				<cfif arguments.member_type eq "employee">
					TRAINER_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.emp_id#">,
					TRAINER_PAR = NULL,
					TRAINER_CONS = NULL,
				<cfelseif arguments.member_type eq "partner">
					TRAINER_EMP = NULL,
					TRAINER_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.par_id#">,
					TRAINER_CONS = NULL,
				<cfelseif arguments.member_type eq "consumer">
					TRAINER_EMP = NULL,
					TRAINER_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cons_id#">,
					TRAINER_PAR = NULL,
				<cfelse>
					TRAINER_EMP = NULL,
					TRAINER_PAR = NULL,
					TRAINER_CONS = NULL,
				</cfif>
				<cfif isdefined("arguments.training_sec_id") and len(arguments.training_sec_id) and arguments.training_sec_id NEQ 0>
						TRAINING_SEC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.training_sec_id#">,
					<cfelse>
						TRAINING_SEC_ID = NULL,
				</cfif>
				<cfif isdefined("arguments.TRAINING_CAT_ID") and len(arguments.TRAINING_CAT_ID) and arguments.TRAINING_CAT_ID NEQ 0>
				        TRAINING_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.training_cat_id#">,
			       <cfelse>
				        TRAINING_CAT_ID = NULL,
			    </cfif>
				TRAINING_STYLE = <cfif Len(arguments.training_style)>#arguments.training_style#,<cfelse>NULL,</cfif>
				TRAINING_TYPE = <cfif Len(arguments.training_type)>#arguments.training_type#,<cfelse>NULL,</cfif>
				TOTAL_DAY = <cfif len(arguments.totalday)>#arguments.totalday#,<cfelse>NULL,</cfif>
				TRAINING_EXPENSE = <cfif len(arguments.expense)>#arguments.expense#,<cfelse>NULL,</cfif>
				MONEY_CURRENCY = <cfif isdefined("arguments.money") and len(arguments.money)>'#arguments.money#'<cfelse>NULL</cfif>,
				PRODUCT_ID = <cfif isdefined("arguments.product_id") and len(arguments.product_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"><cfelse>NULL</cfif>,
				TOTAL_HOURS = <cfif isdefined("arguments.total_hours") and len(arguments.total_hours)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.total_hours#"><cfelse>NULL</cfif>,
				TRAINING_STAGE = <cfif isdefined("arguments.process_stage") and len(arguments.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#"><cfelse>NULL</cfif>,
				LANGUAGE = <cfif isdefined("arguments.language_id") and len(arguments.language_id)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.language_id#"><cfelse>NULL</cfif>
			WHERE
				TRAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TRAIN_ID#">
			  </cfquery>
            <cfset attributes.fuseaction = arguments.fuseaction>
			<cfset FUSEBOX.PROCESS_TREE_CONTROL = application.systemParam.systemParam().fusebox.process_tree_control>
			  <cfif isDefined("arguments.process_stage") and len(arguments.process_stage)>
				<cf_workcube_process is_upd='1' 
					old_process_line='0'
					process_stage='#arguments.process_stage#' 
					record_member='#session.ep.userid#' 
					record_date='#now()#' 
					action_table='TRAINING'
					action_column='TRAINING_ID'
					action_id='#arguments.TRAIN_ID#'
					action_page='/index.cfm?fuseaction=training_management.list_training_subjects&event=upd&train_id=#arguments.TRAIN_ID#'
					warning_description="Müfredat : #arguments.TRAIN_ID#">
				</cfif>	
			<script>
				window.location.href = '<cfoutput>/index.cfm?fuseaction=training_management.list_training_subjects&event=upd&train_id=#arguments.TRAIN_ID#</cfoutput>';
			</script>
	        </cftransaction>
			
	</cffunction>
	<cffunction name="get_training_cat" access="public">
	    <cftransaction>
	        <cfquery name="get_training_cat" datasource="#dsn#" result="query">
	            SELECT * FROM TRAINING_CAT
            </cfquery>
	        <cfreturn get_training_cat>
	    </cftransaction>
	</cffunction>
	<cffunction name="get_training_sec" access="public">
	    <cftransaction>
	        <cfquery name="get_training_sec" datasource="#dsn#" result="query">
	            SELECT * FROM TRAINING_SEC
            </cfquery>
	        <cfreturn get_training_sec>
	    </cftransaction>
	</cffunction>
	<cffunction name="get_emp_det" access="public">
	    <cfargument name="EMPLOYEE_ID" default="">
	    <cftransaction>
	       <cfquery name="get_emp_det" datasource="#dsn#" result="query">
				SELECT
					OC.COMP_ID,
					B.BRANCH_ID,
					D.DEPARTMENT_ID,
					EP.FUNC_ID,
					EP.POSITION_CAT_ID,
					EP.ORGANIZATION_STEP_ID
				FROM
					EMPLOYEE_POSITIONS EP,
					OUR_COMPANY OC,
					BRANCH B,
					DEPARTMENT D
				WHERE
					OC.COMP_ID = B.COMPANY_ID AND
					B.BRANCH_ID = D.BRANCH_ID AND
					D.DEPARTMENT_ID = EP.DEPARTMENT_ID AND
					EP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
					EP.IS_MASTER = 1
			</cfquery>
			<cfreturn get_emp_det>
		</cftransaction>
	</cffunction>
	
	<cffunction name="get_train_id" access="public">
	    <cfargument name="RELATION_ACTION" default="">
		<cfargument name="RELATION_ACTION_ID" default="">
	    <cftransaction>
	<cfquery name="get_train_id" datasource="#DSN#">
			SELECT
				RELATION_FIELD_ID
			FROM
				RELATION_SEGMENT_TRAINING
			WHERE
				<cfif len(get_emp_det.COMP_ID)>
				(
					RELATION_ACTION = 1 AND
					RELATION_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp_det.COMP_ID#">
				) OR
				</cfif>
				<cfif len(get_emp_det.DEPARTMENT_ID)>
				(
					RELATION_ACTION = 2 AND
					RELATION_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp_det.DEPARTMENT_ID#">
				) OR
				</cfif>
				<cfif len(get_emp_det.POSITION_CAT_ID)>
				(
					RELATION_ACTION = 3 AND
					RELATION_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp_det.POSITION_CAT_ID#">
				) OR
				</cfif>
				<cfif len(get_emp_det.FUNC_ID)>
				(
					RELATION_ACTION = 5 AND
					RELATION_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp_det.FUNC_ID#">
				) OR
				</cfif>
				<cfif len(get_emp_det.ORGANIZATION_STEP_ID)>
				(
					RELATION_ACTION = 6 AND
					RELATION_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp_det.ORGANIZATION_STEP_ID#"> 
				) OR
				</cfif>
				<cfif len(get_emp_det.BRANCH_ID)>
				(
					RELATION_ACTION = 7 AND
					RELATION_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp_det.BRANCH_ID#">  
				)
				</cfif>
    </cfquery>
		<cfreturn get_train_id>
		</cftransaction>
	</cffunction>

	<cffunction name="get_class" access="public">
		<cftransaction>
			<cfquery name="get_class" datasource="#dsn#">
				SELECT
					TC.*
				FROM
					TRAINING_CLASS TC
			</cfquery>
			<cfreturn get_class>
		</cftransaction>
	</cffunction>

	<cffunction name="get_training_groups" access="public">
		<cfargument name="class_id" default="">
		<cftransaction>
			<cfquery name="get_training_groups" datasource="#dsn#">
				SELECT
					TCG.GROUP_HEAD,
					TCGC.CLASS_GROUP_ID,
					TCGC.TRAIN_GROUP_ID,
					TGA.EMP_ID
				FROM
					TRAINING_CLASS_GROUPS TCG 
					LEFT JOIN TRAINING_CLASS_GROUP_CLASSES TCGC ON TCG.TRAIN_GROUP_ID = TCGC.TRAIN_GROUP_ID
					LEFT JOIN TRAINING_CLASS TC ON TC.CLASS_ID=TCGC.CLASS_ID
					INNER JOIN TRAINING_GROUP_ATTENDERS TGA ON TGA.TRAINING_GROUP_ID = TCG.TRAIN_GROUP_ID
				WHERE
					TC.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.class_id#"> 
			</cfquery>
			<cfreturn get_training_groups>
		</cftransaction>
	</cffunction>
	
	<cffunction name="GET_RELATION_COMP_CAT" access="public">
	    <cfargument name="field_id" default="">
	    <cftransaction>
			<cfquery name="GET_RELATION_COMP_CAT" datasource="#DSN#">
				SELECT 
					RELATION_ID,
					RELATION_ACTION,
					RELATION_ACTION_ID,
					RELATION_YEAR,
					IS_FILL,
					COMPANY_CAT.COMPANYCAT
				FROM 
					RELATION_SEGMENT_TRAINING RELATION_SEGMENT,
					COMPANY_CAT
				WHERE 
					RELATION_FIELD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.field_id#">AND
					RELATION_TABLE = 'TRAINING'  AND
					RELATION_ACTION = 4 AND
					COMPANY_CAT.COMPANYCAT_ID = RELATION_SEGMENT.RELATION_ACTION_ID
			</cfquery>
			<cfreturn GET_RELATION_COMP_CAT>
		</cftransaction>
	</cffunction>
	
	<cffunction name="GET_RELATION_POS_CAT" access="public">
	    <cfargument name="field_id" default="">
	    <cftransaction>
			<cfquery name="GET_RELATION_POS_CAT" datasource="#DSN#">
				SELECT 
					RELATION_ID,
					RELATION_ACTION,
					RELATION_ACTION_ID,
					RELATION_YEAR,
					IS_FILL,
					SETUP_POSITION_CAT.POSITION_CAT
				FROM 
					RELATION_SEGMENT_TRAINING RELATION_SEGMENT,
					SETUP_POSITION_CAT
				WHERE 
					RELATION_FIELD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.field_id#">AND
					RELATION_TABLE = 'TRAINING'  AND
					RELATION_ACTION = 3 AND
					SETUP_POSITION_CAT.POSITION_CAT_ID = RELATION_SEGMENT.RELATION_ACTION_ID
			</cfquery>
			<cfreturn GET_RELATION_POS_CAT>
		</cftransaction>
	</cffunction>
	
	<cffunction name="GET_RELATION_CONS_CAT" access="public">
	    <cfargument name="field_id" default="">
	    <cftransaction>
			<cfquery name="GET_RELATION_CONS_CAT" datasource="#DSN#">
				SELECT 
					RELATION_ID,
					RELATION_ACTION,
					RELATION_ACTION_ID,
					RELATION_YEAR,
					IS_FILL,
					CONSUMER_CAT.CONSCAT
				FROM 
					RELATION_SEGMENT_TRAINING RELATION_SEGMENT,
					CONSUMER_CAT
				WHERE 
					RELATION_FIELD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.field_id#">AND
					RELATION_TABLE = 'TRAINING'  AND
					RELATION_ACTION = 8 AND
					CONSUMER_CAT.CONSCAT_ID = RELATION_SEGMENT.RELATION_ACTION_ID
			</cfquery>
			<cfreturn GET_RELATION_CONS_CAT>
		</cftransaction>
	</cffunction>

	<cffunction name="get_content" access="public">
		<cftransaction>
			<cfquery name="get_content" datasource="#dsn#">
				SELECT DISTINCT
					TOP 5
					C.*,
					CC.*,
					CCH.*,
					CI.CONTIMAGE_SMALL AS PHOTO
				FROM
					CONTENT C,
					CONTENT_CHAPTER CCH,
					CONTENT_CAT CC,
					CONTENT_IMAGE CI
				WHERE
					CC.IS_TRAINING = 1
					AND CC.CONTENTCAT_ID = CCH.CONTENTCAT_ID
					AND CCH.CHAPTER_ID = C.CHAPTER_ID
					AND CI.CONTENT_ID = C.CONTENT_ID
			</cfquery>
			<cfreturn get_content>
		</cftransaction>
	</cffunction>
	
	<cffunction name="GET_TRAININGS" access="public">
		<cfargument name="KEYWORD" default="">
		<cfargument name="TRAINING_CAT_ID" default="">
		<cfargument name="TRAINING_SEC_ID" default="">
		<cfargument name="STATUS" default="">
		<cfargument name="LANGUAGE" default="">
		<cftransaction>
		<cfquery name="GET_TRAININGS" datasource="#DSN#">
			SELECT 
				T.TRAIN_ID, 
				T.TRAIN_OBJECTIVE,
				T.TRAIN_HEAD,
				T.TRAINING_SEC_ID,
				T.TRAIN_PARTNERS,
				T.TRAIN_CONSUMERS,
				T.TRAIN_DEPARTMENTS,
				T.RECORD_DATE,
				T.RECORD_EMP,
				T.TRAINING_STYLE,
				T.TRAINING_TYPE,
				T.TOTAL_DAY,
				T.TOTAL_HOURS,
				T.RECORD_PAR,
				T.LANGUAGE,
                T.TRAINING_STAGE
			FROM 
				TRAINING T
			WHERE
				T.TRAIN_ID <> 0
			<cfif isDefined("arguments.KEYWORD") and len(arguments.KEYWORD)>
			AND 
			(
				T.TRAIN_OBJECTIVE LIKE '%#arguments.KEYWORD#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
				T.TRAIN_HEAD LIKE '%#arguments.KEYWORD#%' COLLATE SQL_Latin1_General_CP1_CI_AI
			)
			</cfif>
			<cfif isDefined("arguments.TRAINING_CAT_ID") and len(arguments.TRAINING_CAT_ID) and (arguments.TRAINING_CAT_ID NEQ 0)>AND T.TRAINING_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.training_cat_id#"> </cfif>
			<cfif isDefined("arguments.TRAINING_SEC_ID") and len(arguments.TRAINING_SEC_ID) and (arguments.TRAINING_SEC_ID NEQ 0)>AND T.TRAINING_SEC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.training_sec_id#"></cfif>
			<cfif isdefined("arguments.status") and len(arguments.status)>AND T.SUBJECT_STATUS = #arguments.STATUS#</cfif>
			<cfif isdefined("arguments.language") and len(arguments.language)>AND T.LANGUAGE = '#arguments.LANGUAGE#'</cfif>
			ORDER BY T.RECORD_DATE DESC,T.TRAIN_HEAD 
		</cfquery>
			<cfreturn GET_TRAININGS>
			</cftransaction>
	</cffunction>
	<cffunction name="GET_TRAINING_STYLE" access="public">
	    <cftransaction>
	        <cfquery name="GET_TRAINING_STYLE" datasource="#dsn#" result="query">
	            SELECT 
					* 
				FROM 
					SETUP_TRAINING_STYLE
            </cfquery>
	        <cfreturn GET_TRAINING_STYLE>
	    </cftransaction>
	</cffunction>
	<cffunction name="GET_MONEY" access="public">
	    <cftransaction>
	        <cfquery name="GET_MONEY" datasource="#dsn#" result="query">
	          SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> 
            </cfquery>
	        <cfreturn GET_MONEY>
	    </cftransaction>
	</cffunction>
	<cffunction name="GET_TRAINING_SUBJECT" access="public">
	    <cftransaction>
	        <cfquery name="GET_TRAINING_SUBJECT" datasource="#dsn#" result="query">
	          SELECT 
				*
			FROM 
				TRAINING
			WHERE 
				TRAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TRAIN_ID#">  
            </cfquery>
	        <cfreturn GET_TRAINING_SUBJECT>
	    </cftransaction>
	</cffunction>
	<cffunction name="GET_STAGE" access="public">
	    <cftransaction>
	        <cfquery name="GET_STAGE" datasource="#dsn#" result="query">
	         SELECT TRAINING_STAGE_ID, TRAINING_STAGE FROM SETUP_TRAINING_STAGE 
            </cfquery>
	        <cfreturn GET_STAGE>
	    </cftransaction>
	</cffunction>
</cfcomponent>