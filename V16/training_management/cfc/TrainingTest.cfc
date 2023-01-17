<!--- File: training_management\cfc\TrainingTest.cfc
Author: Melek KOCABEY <melekkocabey@workcube.com>
Date: 28.08.2019
Controller: TrainingManagementQuizController.cfm
Description: Eğitim Testleri/Genel sayfasının add,update,list,delete cfc'ye alınması için oluşturulmuştur.​ --->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="ADD_QUIZ_FUNC" access="public" returnType="any" hint="Test ekle">
		<cfargument name="QUIZ_STARTDATE"  default="">
		<cfargument name="QUIZ_FINISHDATE"  default="">
		<cfargument name="class_id" default="">
		<cfargument name="process_stage"  default="">
		<cfargument name="SCORE1"  default="">
		<cfargument name="SCORE2"  default="">
		<cfargument name="SCORE3"  default="">
		<cfargument name="SCORE4"  default="">
		<cfargument name="SCORE5"  default="">
		<cfargument name="COMMENT1"  default="">
		<cfargument name="COMMENT2"  default="">
		<cfargument name="COMMENT3"  default="">
		<cfargument name="COMMENT4"  default="">
		<cfargument name="COMMENT5"  default="">
		<cfargument name="QUIZ_PARTNERS"  default="">
		<cfargument name="QUIZ_CONSUMERS"  default="">
		<cfargument name="QUIZ_DEPARTMENTS"  default="">
		<cfargument name="QUIZ_OBJECTIVE"  default="">
		<cfargument name="TRAINING_SEC_ID"  default="">
		<cfargument name="TRAINING_CAT_ID"  default="">
        <cfargument name="test_type_id" default="">
		<cfargument name="TRAINING_ID" default="">
		<cfargument name="QUIZ_AVERAGE"  default="">
		<cfargument name="TAKE_LIMIT"  default="">
		<cfargument name="TOTAL_TIME"  default="">
		<cfargument name="TOTAL_POINTS"  default="">
		<cfargument name="TIMING_STYLE"  default="">
		<cfargument name="QUIZ_HEAD"   default="">
		<cfargument name="QUIZ_TYPE"  default="">
		<cfargument name="RANDOM"  default="">
		<cfargument name="MAX_QUESTIONS"  default="">
        
        <cfargument name="TRAIN_ID" default="">
        <cf_date tarih = "arguments.QUIZ_STARTDATE">
        <cf_date tarih = "arguments.QUIZ_FINISHDATE">
        <cftry>
            <cfset responseStruct = structNew()>
            <cfquery name="ADD_QUIZ" datasource="#dsn#" result="result">
                INSERT INTO
                    QUIZ
                (
                    QUIZ_STARTDATE, 
                    QUIZ_FINISHDATE, 
                    PROCESS_STAGE,
                    SCORE1,
                    SCORE2,
                    SCORE3,
                    SCORE4,
                    SCORE5,
                    COMMENT1,
                    COMMENT2,
                    COMMENT3,
                    COMMENT4,
                    COMMENT5,
                    QUIZ_PARTNERS,
                    QUIZ_CONSUMERS,
                    QUIZ_DEPARTMENTS,
                    QUIZ_POSITION_CATS,
                    QUIZ_OBJECTIVE,
                    TRAINING_SEC_ID, 
                    TRAINING_CAT_ID, 
                    TRAINING_ID,
                    CLASS_ID,
                    QUIZ_AVERAGE,
                    TAKE_LIMIT,
                    TOTAL_TIME,
                    TOTAL_POINTS,
                    TIMING_STYLE, 
                    GRADE_STYLE, 
                    QUIZ_HEAD, 
                    QUIZ_TYPE, 
                    RANDOM, 
                    MAX_QUESTIONS, 
                    RECORD_EMP, 
                    RECORD_IP,
                    TEST_TYPE
                )
                VALUES
                (
                    <cfif len(arguments.QUIZ_STARTDATE) and isdefined("arguments.QUIZ_STARTDATE")><cfqueryparam cfsqltype="cf_sql_date" value="#arguments.QUIZ_STARTDATE#">,<cfelse>NULL,</cfif>
                    <cfif len(arguments.QUIZ_FINISHDATE) and isdefined("arguments.QUIZ_FINISHDATE")><cfqueryparam cfsqltype="cf_sql_date" value="#arguments.QUIZ_FINISHDATE#">,<cfelse>NULL,</cfif>
                    <cfif len(arguments.process_stage) and isdefined("arguments.process_stage")><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,<cfelse>NULL,</cfif>
                    <cfif len(arguments.SCORE1) and isdefined("arguments.SCORE1")><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SCORE1#">,<cfelse>NULL,</cfif>
                    <cfif len(arguments.SCORE2) and isdefined("arguments.SCORE2")><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SCORE2#">,<cfelse>NULL,</cfif>
                    <cfif len(arguments.SCORE3) and isdefined("arguments.SCORE3")><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SCORE3#">,<cfelse>NULL,</cfif>
                    <cfif len(arguments.SCORE4) and isdefined("arguments.SCORE4")><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SCORE4#">,<cfelse>NULL,</cfif>
                    <cfif len(arguments.SCORE5) and isdefined("arguments.SCORE5")><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SCORE5#">,<cfelse>NULL,</cfif>
                    <cfif len(arguments.COMMENT1) and isdefined("arguments.COMMENT1")><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.COMMENT1#">,<cfelse>NULL,</cfif>
                    <cfif len(arguments.COMMENT2) and isdefined("arguments.COMMENT2")><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.COMMENT2#">,<cfelse>NULL,</cfif>
                    <cfif len(arguments.COMMENT3) and isdefined("arguments.COMMENT3")><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.COMMENT3#">,<cfelse>NULL,</cfif>
                    <cfif len(arguments.COMMENT4) and isdefined("arguments.COMMENT4")><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.COMMENT4#">,<cfelse>NULL,</cfif>
                    <cfif len(arguments.COMMENT5 ) and isdefined("arguments.COMMENT5")><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.COMMENT5#">,<cfelse>NULL,</cfif>
                    <cfif isDefined("arguments.QUIZ_PARTNERS") and len(arguments.QUIZ_PARTNERS)><cfqueryparam cfsqltype="cf_sql_nvarchar" value=',#arguments.QUIZ_PARTNERS#,'>,<cfelse>NULL,</cfif>
                    <cfif isDefined("arguments.QUIZ_CONSUMERS") and len(arguments.QUIZ_CONSUMERS)><cfqueryparam cfsqltype="cf_sql_nvarchar" value=',#arguments.QUIZ_CONSUMERS#,'>,<cfelse>NULL,</cfif>
                    <cfif isDefined("arguments.QUIZ_DEPARTMENTS") and len(arguments.QUIZ_DEPARTMENTS)><cfqueryparam cfsqltype="cf_sql_nvarchar" value=',#arguments.QUIZ_DEPARTMENTS#,'>,<cfelse>NULL,</cfif>
                    <cfif isDefined("arguments.QUIZ_POSITION_CATS") and len(arguments.QUIZ_POSITION_CATS)><cfqueryparam cfsqltype="cf_sql_nvarchar" value=',#arguments.QUIZ_POSITION_CATS#,'>,<cfelse>NULL,</cfif>
                    <cfif isDefined("arguments.QUIZ_OBJECTIVE") and len(arguments.QUIZ_OBJECTIVE)><cfqueryparam cfsqltype="cf_sql_nvarchar" value='#arguments.QUIZ_OBJECTIVE#'>,<cfelse>NULL,</cfif>
                    <cfif isDefined("arguments.TRAINING_SEC_ID") and len(arguments.TRAINING_SEC_ID) and arguments.TRAINING_SEC_ID neq 0><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TRAINING_SEC_ID#">,<cfelse>NULL,</cfif>
                    <cfif isDefined("arguments.TRAINING_CAT_ID") and len(arguments.TRAINING_CAT_ID) and arguments.TRAINING_CAT_ID neq 0><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TRAINING_CAT_ID#">,<cfelse>NULL,</cfif>
                    <cfif isDefined("arguments.TRAINING_ID") and len(arguments.TRAINING_ID) and arguments.TRAINING_ID neq 0><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TRAINING_ID#">,<cfelse>NULL,</cfif>
                    <cfif isdefined("arguments.class_id") and len(arguments.class_id) and (arguments.class_id neq 0)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#">,<cfelse>NULL,</cfif>
                    <cfif isDefined("arguments.QUIZ_AVERAGE") and len(arguments.QUIZ_AVERAGE)><cfqueryparam cfsqltype="cf_sql_integer" value="#EncodeForHTML(arguments.QUIZ_AVERAGE)#">,<cfelse>NULL,</cfif>
                    <cfif isDefined("arguments.TAKE_LIMIT") and len(arguments.TAKE_LIMIT)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TAKE_LIMIT#">,<cfelse>NULL,</cfif> 
                    <cfif isDefined("arguments.TOTAL_TIME") and TIMING_STYLE EQ 1><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TOTAL_TIME#">,<cfelse>NULL,</cfif>
                    <cfif isDefined("arguments.TOTAL_POINTS") and GRADE_STYLE EQ 1><cfqueryparam cfsqltype="cf_sql_integer" value="#EncodeForHTML(arguments.TOTAL_POINTS)#">,<cfelse>NULL,</cfif>
                    <cfif isDefined("arguments.TIMING_STYLE") and len(arguments.TIMING_STYLE)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.TIMING_STYLE#">,<cfelse>NULL,</cfif>
                    <cfif isDefined("arguments.GRADE_STYLE") and len(arguments.GRADE_STYLE)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.GRADE_STYLE#">,<cfelse>NULL,</cfif> 
                    <cfif isDefined("arguments.QUIZ_HEAD") and len(arguments.QUIZ_HEAD)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#EncodeForHTML(arguments.QUIZ_HEAD)#">,<cfelse>NULL,</cfif>
                    <cfif isDefined("arguments.QUIZ_TYPE") and len(arguments.QUIZ_TYPE)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.QUIZ_TYPE#">,<cfelse>NULL,</cfif>
                    <cfif isDefined("arguments.RANDOM") and len(arguments.RANDOM)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.RANDOM#">,<cfelse>NULL,</cfif>
                    <cfif isDefined("arguments.MAX_QUESTIONS") and len(arguments.MAX_QUESTIONS)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.MAX_QUESTIONS#">,<cfelse>NULL,</cfif>
                    <cfif isDefined("SESSION.EP.USERID") and len(SESSION.EP.USERID)><cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">,<cfelse>NULL,</cfif>
                    <cfif isDefined("CGI.REMOTE_ADDR") and len(CGI.REMOTE_ADDR)><cfqueryparam cfsqltype="cf_sql_nvarchar" value='#CGI.REMOTE_ADDR#'>,<cfelse>NULL,</cfif>
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.test_type_id#">
                )
            </cfquery>
            <cfquery name="GET_LAST_ID" datasource="#dsn#" maxrows="1">
                SELECT MAX(QUIZ_ID) AS LAST_ID FROM QUIZ
            </cfquery>
            <cfquery name="ADD_SUBJECT_TO_QUIZ" datasource="#DSN#">
                INSERT INTO
                    QUIZ_TRAINING_SUBJECTS
                (
                    QUIZ_ID,
                    TRAINING_SUBJECT_ID,
                    RECORD_EMP,
                    RECORD_DATE,
                    RECORD_IP
                )
                VALUES
                (
                    #GET_LAST_ID.LAST_ID#,
                    <cfif isDefined("arguments.TRAIN_ID") and len(arguments.TRAIN_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TRAIN_ID#">,<cfelse>NULL,</cfif>
                    <cfif isDefined("SESSION.EP.USERID") and len(SESSION.EP.USERID)><cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">,<cfelse>NULL,</cfif>
                    #now()#,
                    <cfif isDefined("CGI.REMOTE_ADDR") and len(CGI.REMOTE_ADDR)><cfqueryparam cfsqltype="cf_sql_nvarchar" value='#CGI.REMOTE_ADDR#'><cfelse>NULL</cfif>
                )
            </cfquery>
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = GET_LAST_ID.LAST_ID>
        <cfcatch type="database">
            <cftransaction action="rollback">
            <cfset responseStruct.message = "İşlem Hatalı">
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = cfcatch>
        </cfcatch>
        </cftry>
        <cfreturn responseStruct>
	</cffunction>
	<cffunction  name="get_max_quiz" access="public" returnType="any" hint="max guiz id sı al">
		<cfquery name="get_max_quiz" datasource="#dsn#">
			SELECT
				MAX(QUIZ_ID) AS QUIZ_ID
			FROM
				QUIZ
		</cfquery>
		<cfreturn get_max_quiz>
	</cffunction>
	<cffunction  name="add_relation" access="public" returnType="any" hint="İlişkili test ekle">
		<cfargument  name="class_id" default="">
		<cfargument  name="get_max_quiz_id" default="">
		<cfargument  name="QUIZ_HEAD" default="">
		<cfquery name="add_relation_q" datasource="#dsn#" result="add_relation_r">
			INSERT INTO
				QUIZ_RELATION
			(
				QUIZ_ID,
				QUIZ_HEAD,
				CLASS_ID
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_integer" value=#arguments.get_max_quiz_id#>,
				<cfqueryparam cfsqltype="cf_sql_nvarchar" value=#arguments.QUIZ_HEAD#>,
				<cfqueryparam cfsqltype="cf_sql_integer" value=#arguments.class_id#>
			)
		</cfquery>
		<cfreturn add_relation_r>
	</cffunction>
	<cffunction  name="ADD_QUIZ_QUESTIONS" returnType="any" hint="quiz sorusu ekle">
		<cfargument  name="copy_quiz_id" default="">
		<cfargument  name="get_quiz_id" default="">
		<cfif isdefined("arguments.copy_quiz_id")>
			<cfquery name="ADD_QUIZ_QUESTIONS" datasource="#DSN#">
				INSERT INTO
					QUIZ_QUESTIONS
				(
					QUIZ_ID,
					QUESTION_ID
				)
				SELECT
					<cfqueryparam cfsqltype="cf_sql_integer" value=#get_quiz_id#>,
					QUESTION_ID
				FROM
					QUIZ_QUESTIONS
				WHERE
					QUIZ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value=#arguments.copy_quiz_id#>
			</cfquery>
		</cfif>
	</cffunction>
	<cffunction  name="GET_QUIZ_QUESTIONS" returnType="any" hint="Quiz Getir">
		<cfquery name="GET_QUIZ_QUESTION_COUNT" datasource="#dsn#">
			SELECT 
				COUNT(QUESTION_ID) AS COUNTED
			FROM 
				QUIZ_QUESTIONS
			WHERE
				QUIZ_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.QUIZ_ID#">
		</cfquery>
		<cfreturn GET_QUIZ_QUESTION_COUNT>
	</cffunction>
	<cffunction name="UPD_QUIZ_FUNC" access="public" returnType="any" hint="Test Güncelle">
			<cfargument name="QUIZ_STARTDATE"  default="">
			<cfargument name="QUIZ_FINISHDATE"  default="">
			<cfargument name="class_id" default="">
			<cfargument name="process_stage" default="">
			<cfargument name="SCORE1"  default="">
			<cfargument name="SCORE2"  default="">
			<cfargument name="SCORE3"  default="">
			<cfargument name="SCORE4"  default="">
			<cfargument name="SCORE5"  default="">
			<cfargument name="COMMENT1"  default="">
			<cfargument name="COMMENT2"  default="">
			<cfargument name="COMMENT3"  default="">
			<cfargument name="COMMENT4"  default="">
			<cfargument name="COMMENT5"  default="">
			<cfargument name="QUIZ_PARTNERS"  default="">
			<cfargument name="QUIZ_CONSUMERS"  default="">
			<cfargument name="QUIZ_DEPARTMENTS"  default="">
			<cfargument name="QUIZ_OBJECTIVE"  default="">
			<cfargument name="TRAINING_SEC_ID"  default="">
			<cfargument name="TRAINING_CAT_ID"  default="">
			<cfargument name="test_type_id" default="">
			<cfargument name="TRAINING_ID" default="">
			<cfargument name="QUIZ_AVERAGE"  default="">
			<cfargument name="TAKE_LIMIT"  default="">
			<cfargument name="TOTAL_TIME"  default="">
			<cfargument name="TOTAL_POINTS"  default="">
			<cfargument name="TIMING_STYLE"  default="">
			<cfargument name="QUIZ_HEAD"   default="">
			<cfargument name="QUIZ_TYPE"  default="">
			<cfargument name="RANDOM"  default="">
			<cfargument name="MAX_QUESTIONS"  default="">
			<cfargument  name="QUIZ_ID" default="">
			<cfargument  name="TRAIN_ID" default="">
            <cf_date tarih = "arguments.QUIZ_STARTDATE">
            <cf_date tarih = "arguments.QUIZ_FINISHDATE">
            <cftry>
                <cfset responseStruct = structNew()>
                <cfquery name="UPD_QUIZ" datasource="#dsn#">
                    UPDATE
                        QUIZ
                    SET
                        QUIZ_STARTDATE=<cfif len(arguments.QUIZ_STARTDATE) and isdefined("arguments.QUIZ_STARTDATE")><cfqueryparam cfsqltype="cf_sql_date" value="#arguments.QUIZ_STARTDATE#">,<cfelse>NULL,</cfif>
                        QUIZ_FINISHDATE=<cfif len(arguments.QUIZ_FINISHDATE) and isdefined("arguments.QUIZ_FINISHDATE")><cfqueryparam cfsqltype="cf_sql_date" value="#arguments.QUIZ_FINISHDATE#">,<cfelse>NULL,</cfif>
                        PROCESS_STAGE=<cfif len(arguments.process_stage) and isdefined("arguments.process_stage")><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,<cfelse>NULL,</cfif>
                        SCORE1=<cfif len(arguments.SCORE1) and isdefined("arguments.SCORE1")><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SCORE1#">,<cfelse>NULL,</cfif>
                        SCORE2=<cfif len(arguments.SCORE2) and isdefined("arguments.SCORE2")><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SCORE2#">,<cfelse>NULL,</cfif>
                        SCORE3=<cfif len(arguments.SCORE3) and isdefined("arguments.SCORE3")><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SCORE3#">,<cfelse>NULL,</cfif>
                        SCORE4=<cfif len(arguments.SCORE4) and isdefined("arguments.SCORE4")><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SCORE4#">,<cfelse>NULL,</cfif>
                        SCORE5=<cfif len(arguments.SCORE5) and isdefined("arguments.SCORE5")><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SCORE5#">,<cfelse>NULL,</cfif>
                        COMMENT1=<cfif len(arguments.COMMENT1) and isdefined("arguments.COMMENT1")><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.COMMENT1#">,<cfelse>NULL,</cfif>
                        COMMENT2=<cfif len(arguments.COMMENT2) and isdefined("arguments.COMMENT2")><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.COMMENT2#">,<cfelse>NULL,</cfif>
                        COMMENT3=<cfif len(arguments.COMMENT3) and isdefined("arguments.COMMENT3")><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.COMMENT3#">,<cfelse>NULL,</cfif>
                        COMMENT4=<cfif len(arguments.COMMENT4) and isdefined("arguments.COMMENT4")><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.COMMENT4#">,<cfelse>NULL,</cfif>
                        COMMENT5=<cfif len(arguments.COMMENT5 ) and isdefined("arguments.COMMENT5")><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.COMMENT5#">,<cfelse>NULL,</cfif>
                        QUIZ_PARTNERS=<cfif isDefined("arguments.QUIZ_PARTNERS") and len(arguments.QUIZ_PARTNERS)><cfqueryparam cfsqltype="cf_sql_nvarchar" value=',#arguments.QUIZ_PARTNERS#,'>,<cfelse>NULL,</cfif>
                        QUIZ_CONSUMERS=<cfif isDefined("arguments.QUIZ_CONSUMERS") and len(arguments.QUIZ_CONSUMERS)><cfqueryparam cfsqltype="cf_sql_nvarchar" value=',#arguments.QUIZ_CONSUMERS#,'>,<cfelse>NULL,</cfif>
                        QUIZ_DEPARTMENTS=<cfif isDefined("arguments.QUIZ_DEPARTMENTS") and len(arguments.QUIZ_DEPARTMENTS)><cfqueryparam cfsqltype="cf_sql_nvarchar" value=',#arguments.QUIZ_DEPARTMENTS#,'>,<cfelse>NULL,</cfif>
                        QUIZ_POSITION_CATS=<cfif isDefined("arguments.QUIZ_POSITION_CATS") and len(arguments.QUIZ_POSITION_CATS)><cfqueryparam cfsqltype="cf_sql_nvarchar" value=',#arguments.QUIZ_POSITION_CATS#,'>,<cfelse>NULL,</cfif>
                        QUIZ_OBJECTIVE=<cfif isDefined("arguments.QUIZ_OBJECTIVE") and len(arguments.QUIZ_OBJECTIVE)><cfqueryparam cfsqltype="cf_sql_nvarchar" value='#arguments.QUIZ_OBJECTIVE#'>,<cfelse>NULL,</cfif>
                        TRAINING_SEC_ID=<cfif isDefined("arguments.TRAINING_SEC_ID") and len(arguments.TRAINING_SEC_ID) and arguments.TRAINING_SEC_ID neq 0><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TRAINING_SEC_ID#">,<cfelse>NULL,</cfif>
                        TRAINING_CAT_ID=<cfif isDefined("arguments.TRAINING_CAT_ID") and len(arguments.TRAINING_CAT_ID) and arguments.TRAINING_CAT_ID neq 0><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TRAINING_CAT_ID#">,<cfelse>NULL,</cfif>
                        TRAINING_ID=<cfif isDefined("arguments.TRAINING_ID") and len(arguments.TRAINING_ID) and arguments.TRAINING_ID neq 0><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TRAINING_ID#">,<cfelse>NULL,</cfif>
                        TIMING_STYLE=<cfif isDefined("arguments.TOTAL_TIME") and TIMING_STYLE EQ 1><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TOTAL_TIME#">,<cfelse>NULL,</cfif>
                        TOTAL_POINTS=<cfif isDefined("arguments.TOTAL_POINTS") and GRADE_STYLE EQ 1><cfqueryparam cfsqltype="cf_sql_integer" value="#EncodeForHTML(arguments.TOTAL_POINTS)#">,<cfelse>NULL,</cfif>
                        QUIZ_AVERAGE=<cfif isDefined("arguments.QUIZ_AVERAGE") and len(arguments.QUIZ_AVERAGE)><cfqueryparam cfsqltype="cf_sql_integer" value="#EncodeForHTML(arguments.QUIZ_AVERAGE)#">,<cfelse>NULL,</cfif> 
                        TAKE_LIMIT=<cfif isDefined("arguments.TAKE_LIMIT") and len(arguments.TAKE_LIMIT)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TAKE_LIMIT#">,<cfelse>NULL,</cfif> 
                        GRADE_STYLE=<cfif isDefined("arguments.GRADE_STYLE") and len(arguments.GRADE_STYLE)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.GRADE_STYLE#">,<cfelse>NULL,</cfif>  
                        QUIZ_HEAD=<cfif isDefined("arguments.QUIZ_HEAD") and len(arguments.QUIZ_HEAD)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#EncodeForHTML(arguments.QUIZ_HEAD)#">,<cfelse>NULL,</cfif>
                        QUIZ_TYPE=<cfif isDefined("arguments.QUIZ_TYPE") and len(arguments.QUIZ_TYPE)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.QUIZ_TYPE#">,<cfelse>NULL,</cfif>
                        RANDOM = <cfif isDefined("arguments.RANDOM") and len(arguments.RANDOM)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.RANDOM#">,<cfelse>NULL,</cfif>
                        MAX_QUESTIONS=<cfif isDefined("arguments.MAX_QUESTIONS") and len(arguments.MAX_QUESTIONS)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.MAX_QUESTIONS#">,<cfelse>NULL,</cfif>
                        UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                        UPDATE_EMP =<cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">, 
                        UPDATE_IP =<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#CGI.REMOTE_ADDR#">,
                        TEST_TYPE=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.test_type_id#">
                    WHERE
                        QUIZ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.QUIZ_ID#">
		        </cfquery>
                <cfquery name="UPD_SUBJECT_TO_QUIZ" datasource="#DSN#">
                    UPDATE
                        QUIZ_TRAINING_SUBJECTS
                    SET
                        QUIZ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.QUIZ_ID#">,
                        TRAINING_SUBJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.train_id#">,
                        UPDATE_EMP = <cfif isDefined("SESSION.EP.USERID") and len(SESSION.EP.USERID)><cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">,<cfelse>NULL,</cfif>
                        UPDATE_DATE = #now()#
                    WHERE
                        QUIZ_TRAINING_SUBJECTS = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.QUIZ_TRAINING_SUBJECTS#">
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
	<cffunction  name="GET_QUIZ_CHAPTER_FUNC" returnType="any" hint="sınav bölümünü getir">
		<cfargument  name="CHAPTER_ID" default="">
		<cfquery name="GET_QUIZ_CHAPTER" datasource="#dsn#">
			SELECT 
				* 
			FROM 
				EMPLOYEE_QUIZ_CHAPTER
			WHERE
				CHAPTER_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.CHAPTER_ID#">
		</cfquery>
		<cfreturn GET_QUIZ_CHAPTER>
	</cffunction>
	<cffunction  name="GET_QUESTION_FUNC"  returnType="any" hint="sınav soruları getir">
		<cfargument  name="CHAPTER_ID" default="">
		<cfquery name="GET_QUESTION" datasource="#dsn#">
			SELECT 
				* 
			FROM 
				EMPLOYEE_QUIZ_QUESTION
			WHERE
				CHAPTER_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.CHAPTER_ID#">
		</cfquery>
		<cfreturn GET_QUESTION>
	</cffunction>
	<cffunction  name="DEL_QUESTION_FUNC" returnType="any" hint="sınav ve quiz soruları sil">
		<cfargument  name="CHAPTER_ID" default="">
		<cfargument  name="QUIZ_ID" default="">
		<cfargument  name="relation_status" default="">
		<cfargument  name="del_result_status" default="">
		<cfargument  name="del_quiz_status" default="">
		<cfargument  name="result_quiz_list" default="#result_quiz_list#">
        <cftry>
            <cfset responseStruct = structNew()>
            <cfif isdefined("arguments.chapter_id") and len(arguments.chapter_id)>
                <cfquery name="DEL_QUESTION" datasource="#dsn#">
                    DELETE FROM EMPLOYEE_QUIZ_QUESTION WHERE CHAPTER_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.CHAPTER_ID#">
                </cfquery>
            <cfelse>
                <cfquery name="DEL_QUESTIONS" datasource="#dsn#">
                    DELETE FROM QUIZ_QUESTIONS WHERE QUIZ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.QUIZ_ID#">
                </cfquery>
            </cfif>
            <cfif (relation_status eq 1) and len(relation_status)>
                <cfquery name="DEL_RELATIONS" datasource="#dsn#">
                    DELETE FROM QUIZ_RELATION WHERE QUIZ_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.QUIZ_ID#">
                </cfquery>
            </cfif>
            <cfif isdefined("arguments.result_quiz_list") and len(arguments.result_quiz_list)>
                <cfquery name="DEL_QUIZ_RESULTS_DETAILS" datasource="#dsn#">
                    DELETE FROM QUIZ_RESULTS_DETAILS WHERE RESULT_ID (<cfqueryparam cfsqltype="cf_sql_integer" value="#result_quiz_list#" list="yes">)
                </cfquery>
            </cfif>
            <cfif isDefined("del_result_status") and (del_result_status eq 1)>
                <cfquery name="DEL_RESULTS" datasource="#dsn#">
                    DELETE FROM QUIZ_RESULTS WHERE QUIZ_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.QUIZ_ID#">
                </cfquery>
            </cfif>
            <cfif isdefined("del_quiz_status") and (del_quiz_status eq 1)>
                <cfquery name="DEL_QUIZ" datasource="#dsn#">
                    DELETE FROM QUIZ WHERE QUIZ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.QUIZ_ID#">
                </cfquery>
                <cfquery name="DEL_QUIZ_SUBJECT" datasource="#dsn#">
                    DELETE FROM QUIZ_TRAINING_SUBJECTS WHERE QUIZ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.QUIZ_ID#">
                </cfquery>
            </cfif>
        <cfcatch type="database">
            <cftransaction action="rollback">
            <cfset responseStruct.message = "İşlem Hatalı">
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = cfcatch>
        </cfcatch>
        </cftry>
        <cfreturn responseStruct>
	</cffunction>
	<cffunction  name="DEL_CHAPTER_FUNC" returnType="any" hint="sınav bölümünü sil">
		<cfargument  name="CHAPTER_ID" default="">
		<cfquery name="DEL_CHAPTER" datasource="#dsn#">
			DELETE FROM EMPLOYEE_QUIZ_CHAPTER WHERE CHAPTER_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.CHAPTER_ID#">
		</cfquery>
	</cffunction>
	<cffunction  name="GET_QUIZS_FUNC" returnType="any" hint="QUİZ LİSTELE">
		<cfargument  name="TRAINING_SEC_ID" default="">
		<cfargument  name="ATTENDERS" default="">
		<cfargument  name="KEYWORD" default="">
		<cfargument  name="QUIZ_ID" default="">
		<cfquery name="GET_QUIZS" datasource="#dsn#">
			SELECT 
				QUIZ.QUIZ_ID,
				QUIZ.QUIZ_HEAD,
				QUIZ.QUIZ_OBJECTIVE,
				QUIZ.QUIZ_PARTNERS,
				QUIZ.QUIZ_CONSUMERS,
				QUIZ.QUIZ_DEPARTMENTS,
				QUIZ.RECORD_EMP,
				QUIZ.RECORD_PAR,
				QUIZ.RECORD_DATE,
				QUIZ.TOTAL_TIME,
				QUIZ.STAGE_ID,
				QUIZ.TRAINING_CAT_ID,
				QUIZ.PROCESS_STAGE,
				QUIZ.QUIZ_TYPE,
				QUIZ.QUIZ_STARTDATE,
				QUIZ.QUIZ_FINISHDATE,
				QUIZ.RANDOM,
				QUIZ.MAX_QUESTIONS,
				QUIZ.TAKE_LIMIT,
				QUIZ.TIMING_STYLE,
				QUIZ.GRADE_STYLE,
				QUIZ.TOTAL_POINTS,
				QUIZ.SCORE1,
				QUIZ.COMMENT1,
				QUIZ.SCORE2,
				QUIZ.COMMENT2,
				QUIZ.SCORE3,
				QUIZ.COMMENT3,
				QUIZ.SCORE4,
				QUIZ.COMMENT4,
				QUIZ.SCORE5,
				QUIZ.COMMENT5,
				QUIZ.QUIZ_POSITION_CATS,
				QUIZ.QUIZ_AVERAGE,
				QUIZ.TRAINING_SEC_ID,
				QUIZ.TRAINING_ID,
				QUIZ.UPDATE_DATE,
				QUIZ.TEST_TYPE
			FROM 
				QUIZ
			WHERE
				<cfif isdefined("arguments.QUIZ_ID") and len(arguments.QUIZ_ID)>
					QUIZ_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.QUIZ_ID#">
				<cfelse>
					QUIZ_ID IS NOT NULL
				</cfif>
				<cfif isDefined("arguments.TRAINING_SEC_ID") and (arguments.TRAINING_SEC_ID NEQ 0) and len(arguments.TRAINING_SEC_ID)>
					AND QUIZ.TRAINING_SEC_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TRAINING_SEC_ID#">
				</cfif>
				<cfif isDefined("arguments.ATTENDERS") and len(arguments.ATTENDERS)>
					<cfif arguments.ATTENDERS EQ 1>
					AND QUIZ.QUIZ_DEPARTMENTS IS NOT NULL
					<cfelseif arguments.ATTENDERS EQ 2>
					AND QUIZ.QUIZ_PARTNERS IS NOT NULL
					<cfelseif arguments.ATTENDERS EQ 3>
					AND QUIZ.QUIZ_CONSUMERS IS NOT NULL
					</cfif>
				</cfif>
				<cfif isDefined("arguments.KEYWORD") and len(arguments.KEYWORD)>
					AND
					(QUIZ.QUIZ_HEAD LIKE '%#arguments.KEYWORD#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR QUIZ.QUIZ_OBJECTIVE LIKE '%#arguments.KEYWORD#%' COLLATE SQL_Latin1_General_CP1_CI_AI)
				</cfif>
			ORDER BY
				QUIZ_ID DESC
		</cfquery>
		<cfreturn GET_QUIZS>
	</cffunction>
	<cffunction  name="GET_TRAINING_SECS_FUNC" returnType="any" hint="Eğitim Bölümleri Getir">
	<cfargument  name="sec_id" default="">
		<cfquery name="GET_TRAINING_SECS" datasource="#dsn#">
			SELECT
				
				TRAINING_SEC.SECTION_DETAIL,
				TRAINING_SEC.RECORD_DATE,
				TRAINING_CAT.TRAINING_CAT_ID,
				TRAINING_SEC.TRAINING_SEC_ID,
				TRAINING_SEC.SECTION_NAME,
				TRAINING_CAT.TRAINING_CAT
			FROM
				TRAINING_SEC,
				TRAINING_CAT
			WHERE
				TRAINING_SEC_ID IS NOT NULL AND
				TRAINING_SEC.TRAINING_CAT_ID = TRAINING_CAT.TRAINING_CAT_ID
				<cfif isdefined("arguments.sec_id") and len(arguments.sec_id)>
					AND TRAINING_SEC.TRAINING_SEC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sec_id#">
				</cfif>
				<cfif isDefined("arguments.TRAINING_CAT_ID") and len(arguments.TRAINING_CAT_ID) AND (arguments.TRAINING_CAT_ID neq 0)>
			AND
				TRAINING_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TRAINING_CAT_ID#">
				</cfif>
				<cfif isDefined("arguments.KEYWORD") and len(arguments.KEYWORD)>
			AND
				(
				SECTION_NAME LIKE '%#arguments.KEYWORD#%' COLLATE SQL_Latin1_General_CP1_CI_AI
			OR
				SECTION_DETAIL LIKE '%#arguments.KEYWORD#%' COLLATE SQL_Latin1_General_CP1_CI_AI
				)
				</cfif>
			ORDER BY
				TRAINING_CAT.TRAINING_CAT,
				TRAINING_SEC.SECTION_NAME
		</cfquery>
		<cfreturn GET_TRAINING_SECS>
	</cffunction>
	<cffunction  name="GET_TRAINING_CAT_FUNC" returnType="any" hint="EĞİTİM KATEGORİLERİNİ GETİR">
		<cfquery name="GET_TRAINING_CAT" datasource="#dsn#">
			SELECT TRAINING_CAT_ID,TRAINING_CAT FROM TRAINING_CAT
		</cfquery>
		<cfreturn GET_TRAINING_CAT>
	</cffunction>
	<cffunction  name="GET_TRAINING_FUNC" returnType="any" hint="KONU SELECTİNİ DOLDUR">
		<cfquery name="GET_TRAINING" datasource="#DSN#">
			SELECT TRAIN_ID,TRAIN_HEAD FROM TRAINING
		</cfquery>
		<cfreturn GET_TRAINING>
	</cffunction>
	<cffunction  name="GET_QUIZ_RESULTS_FUNC" returnType="any" hint="QUIZ SONUCUNU GETİR">
		<cfargument  name="QUIZ_ID" default="">
		<cfquery name="GET_QUIZ_RESULTS" datasource="#dsn#">
			SELECT
				'employee' AS TYPE,
				EP.EMPLOYEE_ID AS USER_ID,
				EP.EMPLOYEE_NAME AS AD, 
				EP.EMPLOYEE_SURNAME AS SOYAD,
				QUIZ_RESULTS.RESULT_ID,
				QUIZ_RESULTS.QUESTION_COUNT,
				QUIZ_RESULTS.USER_RIGHT_COUNT,
				QUIZ_RESULTS.USER_WRONG_COUNT,
				QUIZ_RESULTS.USER_POINT,
				TC.CLASS_NAME
			FROM 
				QUIZ_RESULTS LEFT JOIN TRAINING_CLASS TC ON QUIZ_RESULTS.CLASS_ID = TC.CLASS_ID
				INNER JOIN EMPLOYEE_POSITIONS EP ON QUIZ_RESULTS.EMP_ID = EP.EMPLOYEE_ID
				INNER JOIN DEPARTMENT D ON EP.DEPARTMENT_ID=D.DEPARTMENT_ID
				INNER JOIN BRANCH B ON D.BRANCH_ID=B.BRANCH_ID
				INNER JOIN OUR_COMPANY C ON C.COMP_ID=B.COMPANY_ID
			WHERE
				B.BRANCH_ID IN (
									SELECT
										BRANCH_ID
									FROM
										EMPLOYEE_POSITION_BRANCHES
									WHERE
										POSITION_CODE = #SESSION.EP.POSITION_CODE#
								) AND 
				QUIZ_RESULTS.QUIZ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.QUIZ_ID#">
				<cfif isdefined('arguments.class_id') and len(arguments.class_id)>
					AND TC.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#">
				</cfif>
			UNION
			SELECT
				'partner' AS TYPE,
				CP.PARTNER_ID AS USER_ID,
				CP.COMPANY_PARTNER_NAME AS AD,
				CP.COMPANY_PARTNER_USERNAME AS SOYAD,
				QUIZ_RESULTS.RESULT_ID,
				QUIZ_RESULTS.QUESTION_COUNT,
				QUIZ_RESULTS.USER_RIGHT_COUNT,
				QUIZ_RESULTS.USER_WRONG_COUNT,
				QUIZ_RESULTS.USER_POINT,
				TC.CLASS_NAME
			FROM 
				QUIZ_RESULTS LEFT JOIN TRAINING_CLASS TC ON QUIZ_RESULTS.CLASS_ID = TC.CLASS_ID
				INNER JOIN COMPANY_PARTNER AS CP ON CP.PARTNER_ID = QUIZ_RESULTS.PARTNER_ID
				INNER JOIN COMPANY AS C ON C.COMPANY_ID=CP.COMPANY_ID
			WHERE
				QUIZ_RESULTS.QUIZ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.QUIZ_ID#">
				<cfif isdefined('arguments.class_id') and len(arguments.class_id)>
					AND TC.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#">
				</cfif>
			UNION
			SELECT
				'consumer' AS TYPE,
				CONSUMER.CONSUMER_ID AS USER_ID,
				CONSUMER.CONSUMER_NAME AS AD,
				CONSUMER.CONSUMER_SURNAME AS SOYAD,
				QUIZ_RESULTS.RESULT_ID,
				QUIZ_RESULTS.QUESTION_COUNT,
				QUIZ_RESULTS.USER_RIGHT_COUNT,
				QUIZ_RESULTS.USER_WRONG_COUNT,
				QUIZ_RESULTS.USER_POINT,
				TC.CLASS_NAME
			FROM 
				QUIZ_RESULTS LEFT JOIN TRAINING_CLASS TC ON QUIZ_RESULTS.CLASS_ID = TC.CLASS_ID
				INNER JOIN CONSUMER ON CONSUMER.CONSUMER_ID = QUIZ_RESULTS.CONSUMER_ID
			WHERE
				QUIZ_RESULTS.QUIZ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.QUIZ_ID#">
				<cfif isdefined('arguments.class_id') and len(arguments.class_id)>
					AND TC.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#">
				</cfif>
			ORDER BY
				QUIZ_RESULTS.USER_POINT DESC
		</cfquery>
		<cfreturn GET_QUIZ_RESULTS>
	</cffunction>
	<cffunction  name="QUIZ_RESULT_COUNT" returnType="any">
		<cfargument  name="RESULT_ID" default="">
		<cfargument  name="QUIZ_ID"  default="">
		<cfargument  name="employee_id"  default="">
		<cfargument  name="class_id"  default="">
		<cfquery name="get_quiz_result_count" datasource="#dsn#">
			SELECT
				COUNT(RESULT_ID) AS TOPLAM,
				EMP_ID
			FROM
				QUIZ_RESULTS
			WHERE
			<cfif isdefined("arguments.employee_id") and len(arguments.employee_id)>
				EMP_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.EMPLOYEE_ID#"> AND				 
			</cfif>
			<cfif isdefined("arguments.RESULT_ID") and len(arguments.RESULT_ID)>
				RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.RESULT_ID#">
			<cfelseif isdefined("arguments.QUIZ_ID") and len(arguments.QUIZ_ID)>
				QUIZ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.QUIZ_ID#"><cfif isdefined("arguments.is_stop") and len(arguments.is_stop) and arguments.is_stop eq 0> AND IS_STOPPED_QUIZ = 0 </cfif>
			</cfif>
			<cfif isdefined("arguments.class_id") and len(arguments.class_id)>
				AND CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#">
			</cfif>
			GROUP BY
				EMP_ID
		</cfquery>
		<cfreturn get_quiz_result_count>
	</cffunction>
	<cffunction  name="GET_QUIZ_RIGHT_SUM_FUNC" returnType="any" hint="Başarılı,Başarısız ve toplam doğru sayısını verir">
		<cfargument  name="QUIZ_ID" default="">
		<cfargument  name="user_point" default="">
		<cfquery name="GET_QUIZ_RIGHT_SUM" datasource="#dsn#">
			SELECT 
				AVG(USER_RIGHT_COUNT) AS RIGHT_SUM,
				COUNT(RESULT_ID) AS TOTAL_ATTENDS,
				COUNT(RESULT_ID) AS TOTAL_WINNERS
			FROM 
				QUIZ_RESULTS
			WHERE
				QUIZ_RESULTS.QUIZ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.QUIZ_ID#">
				<cfif isdefined("arguments.user_point") and len(arguments.user_point)>
					AND USER_POINT >= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.user_point#">
				</cfif>
		</cfquery>
		<cfreturn GET_QUIZ_RIGHT_SUM>
	</cffunction>
	<cffunction  name="GET_CONSUMER_FUNC" returnType="any" hint="">
		<cfargument  name="is_active_consumer_cat" default="">
		<cfquery name="GET_CONSUMER_CATS" datasource="#DSN#">
			SELECT 
				CONSCAT_ID,
				CONSCAT,
				HIERARCHY
			FROM 
				CONSUMER_CAT
			<cfif isdefined("arguments.is_active_consumer_cat") and len(arguments.is_active_consumer_cat)>
			WHERE
				IS_ACTIVE = 1
			</cfif>
			ORDER BY 
				CONSCAT
		</cfquery>
		<cfreturn GET_CONSUMER_CATS>
	</cffunction>
	<cffunction  name="GET_PARTNERS_FUNC" returnType="any" hint="">
		<cfquery name="GET_PARTNER_CATS" datasource="#dsn#">
			SELECT 
				COMPANYCAT_ID,
				COMPANYCAT 
			FROM 
				COMPANY_CAT
		</cfquery>
		<cfreturn GET_PARTNER_CATS>
	</cffunction>
	<cffunction  name="GET_POSITION_CATS_FUNC" returnType="any" hint="">
		<cfquery name="GET_POSITION_CATS" datasource="#DSN#">
			SELECT POSITION_CAT, POSITION_CAT_ID FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT
		</cfquery>
		<cfreturn GET_POSITION_CATS>
	</cffunction>
	<cffunction  name="GET_QUIZ_STAGES_F" returnType="any" hint="">
		<cfquery name="get_quiz_stages" datasource="#dsn#">
			SELECT
				STAGE_ID,
				STAGE_NAME
			FROM
				SETUP_QUIZ_STAGE
			ORDER BY
				STAGE_NAME
		</cfquery>
		<cfreturn get_quiz_stages>
	</cffunction>
	<cffunction  name="GET_DEPARTMENTS_FUNC" returnType="any" hint="">
		<cfquery name="GET_DEPARTMENTS" datasource="#DSN#">
			SELECT 
				DEPARTMENT.DEPARTMENT_ID,
				DEPARTMENT.DEPARTMENT_HEAD,
				DEPARTMENT.BRANCH_ID,
				DEPARTMENT.DEPARTMENT_STATUS,
				BRANCH.BRANCH_NAME,
				BRANCH.BRANCH_STATUS
			FROM 
				DEPARTMENT,
				BRANCH
			WHERE
				BRANCH.BRANCH_STATUS = 1
				AND BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID
				AND DEPARTMENT.DEPARTMENT_STATUS = 1
			ORDER BY
				DEPARTMENT.BRANCH_ID
		</cfquery>
		<cfreturn GET_DEPARTMENTS>
	</cffunction>
	<cffunction  name="GET_TEST_TYPES_FUNC" returnType="any" hint="">
		<cfquery name="GET_TEST_TYPES" datasource="#DSN#">
			SELECT 
				ID,
                TEST_TYPE
			FROM 
				SETUP_TEST_TYPE
		</cfquery>
		<cfreturn GET_TEST_TYPES>
	</cffunction>
	<cffunction  name="GET_QUIZ_SUBJECT_FUNC" returnType="any" hint="">
		<cfargument name="quiz_id" default="">
		<cfquery name="GET_QUIZ_SUBJECT" datasource="#DSN#">
			SELECT
                QTS.QUIZ_TRAINING_SUBJECTS,
				QTS.QUIZ_ID,
                QTS.TRAINING_SUBJECT_ID,
                T.TRAIN_HEAD
			FROM 
				QUIZ_TRAINING_SUBJECTS QTS
                    INNER JOIN TRAINING T ON T.TRAIN_ID = QTS.TRAINING_SUBJECT_ID
            WHERE
                QTS.QUIZ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.quiz_id#">
            ORDER BY
                QTS.QUIZ_TRAINING_SUBJECTS DESC
		</cfquery>
		<cfreturn GET_QUIZ_SUBJECT>
	</cffunction>
</cfcomponent>