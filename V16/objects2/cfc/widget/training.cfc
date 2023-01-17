
<cfcomponent extends="cfc.queryJSONConverter">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset result = StructNew()>
    <cfif isdefined("session.pp")>
        <cfset session_base = evaluate('session.pp')>
        <cfset session_base.period_is_integrated = 0>
    <cfelseif isdefined("session.ep")>
        <cfset session_base = evaluate('session.ep')>
    <cfelseif isdefined("session.ww")>
        <cfset session_base = evaluate('session.ww')>
    <cfelse>
        <cfset session_base = evaluate('session.qq')>
    </cfif> 
    <cffunction name="GET_CLASS" returntype="query">
        <cfargument name="start_date" type="date" required="yes" default="#now()#">
        <cfargument name="maxrows" required="no" default="">
        <cfargument name="train_group_id" default="">
        <cfargument name="widget" type="string" required="no" default="">
        <cfargument name="join" type="string" required="no" default="1">
        <cfargument name="limitdate" type="string" required="no" default="">
        <cfargument name="cat_id" type="string" required="no" default="">
        <cfargument name="language" type="string" required="no" default="">
        <cfquery name="GET_CLASS" datasource="#DSN#">
            SELECT<cfif isDefined('arguments.maxrows') and len(arguments.maxrows)> TOP #arguments.maxrows# </cfif>
                TC.TRAINING_CAT_ID,
                TC.TRAINING_SEC_ID,
                TC.CLASS_ID,
                TC.ONLINE,
                TCT.EMP_ID TRAINER_EMP,
                TCT.PAR_ID TRAINER_PAR,
                TCT.CONS_ID TRAINER_CONS,
                COALESCE(SLIPN.ITEM,TC.CLASS_NAME) AS CLASS_NAME,
                FORMAT(START_DATE, 'dddd', 'tr') AS SDAY,
                FORMAT(START_DATE, 'dddd', 'en') AS SDAY_EN,
                FORMAT(START_DATE, 'dddd', 'de') AS SDAY_DE,
                TC.START_DATE,
                TC.FINISH_DATE,
                TC.CLASS_TARGET,
                TC.CLASS_PLACE,
                TC.CLASS_PLACE_TEL,
                TC.CLASS_OBJECTIVE,
                COALESCE(SLIPD.ITEM,TC.CLASS_ANNOUNCEMENT_DETAIL) AS CLASS_ANNOUNCEMENT_DETAIL,
                TC.ONLINE,
				TC.TRAINING_LINK,
                TC.PATH,
                TC.VIDEO_PATH,
                UFU.USER_FRIENDLY_URL,
                TCGC.TRAIN_GROUP_ID
            FROM
                TRAINING_CLASS TC
                INNER JOIN TRAINING_CLASS_GROUP_CLASSES TCGC ON TCGC.CLASS_ID = TC.CLASS_ID
                <cfif isdefined('arguments.site')>OUTER APPLY(
                    SELECT TOP 1 UFU.USER_FRIENDLY_URL 
                    FROM USER_FRIENDLY_URLS UFU 
                    WHERE UFU.ACTION_TYPE = 'CLASS_ID' 
                    AND UFU.ACTION_ID = TC.CLASS_ID 		
                    AND UFU.PROTEIN_SITE = #arguments.site#) UFU</cfif>
                LEFT JOIN TRAINING_CLASS_TRAINERS TCT ON TC.CLASS_ID = TCT.CLASS_ID
                LEFT JOIN #dsn#.SETUP_LANGUAGE_INFO SLIPN 
                            ON SLIPN.UNIQUE_COLUMN_ID = TC.CLASS_ID  
                            AND SLIPN.COLUMN_NAME ='CLASS_NAME'
                            AND SLIPN.TABLE_NAME = 'TRAINING_CLASS'
                            AND SLIPN.LANGUAGE = '#session_base.language#'
                LEFT JOIN #dsn#.SETUP_LANGUAGE_INFO SLIPD 
                            ON SLIPD.UNIQUE_COLUMN_ID = TC.CLASS_ID  
                            AND SLIPD.COLUMN_NAME ='CLASS_ANNOUNCEMENT_DETAIL'
                            AND SLIPD.TABLE_NAME = 'TRAINING_CLASS'
                            AND SLIPD.LANGUAGE = '#session_base.language#'
            WHERE
                <cfif isDefined("arguments.train_group_id") and len(arguments.train_group_id) >
                    TCGC.TRAIN_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.train_group_id#">AND
                </cfif>
				<cfif isDefined("arguments.limitdate") and len(arguments.limitdate) >
                    <cfif arguments.limitdate eq 1>
                        TC.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#start_date#"> AND
                    <cfelse>
                        TC.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#start_date#"> AND  
                    </cfif>
                <cfelse>
                    TC.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#start_date#"> AND  
                </cfif>
                
                TC.IS_INTERNET = 1 AND
                TC.IS_ACTIVE = 1 
                <cfif isDefined("arguments.cat_id") and len(arguments.cat_id)>
                    AND TC.TRAINING_CAT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cat_id#" list="true">)                   
                </cfif>
                <cfif isDefined("arguments.language") and len(arguments.language) >
                    <cfif arguments.language eq 1>
                    AND TC.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.language#">
                    </cfif>
                </cfif>
                            
            ORDER BY
                TC.START_DATE
        </cfquery>
        <cfreturn GET_CLASS>
    </cffunction>

    <cffunction name="GET_CLASS_COUNT" returntype="query">
        <cfargument name="class_id" type="numeric" required="no" default="">
        <cfquery name="GET_CLASS_COUNT" datasource="#DSN#">
            SELECT
                COUNT(TCGC.CLASS_ID) AS COUNT_CLASS,
                TCGC.CLASS_ID AS LESSON_ID,
                TC.HOUR_NO
            FROM
                TRAINING_CLASS_GROUP_CLASSES TCGC
            LEFT JOIN TRAINING_CLASS TC ON TC.CLASS_ID = TCGC.CLASS_ID
            WHERE TCGC.TRAIN_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#class_id#">
            GROUP BY TCGC.CLASS_ID ,TC.HOUR_NO
        </cfquery>
        <cfreturn GET_CLASS_COUNT>
    </cffunction>

    <cffunction name="GET_CLASS_DETAIL" returntype="query" access="remote">
        <cfargument name="class_id" type="numeric" required="no" default="">
        <cfquery name="GET_CLASS_DETAIL" datasource="#DSN#">
            SELECT
                TCG.GROUP_HEAD class_name,
                TCG.GROUP_OBJECTIVE as CLASS_OBJECTIVE,
                TCG.START_DATE,
                TCG.FINISH_DATE,
                TCG.PATH,
                TCG.VIDEO_PATH,
                TCG.TRAIN_GROUP_ID CLASS_ID,
                TGS.TRAIN_ID
            FROM
                TRAINING_CLASS_GROUPS TCG

            INNER JOIN TRAINING_GROUP_SUBJECTS TGS ON TGS.TRAINING_GROUP_ID = TCG.TRAIN_GROUP_ID
            WHERE
                TCG.IS_INTERNET = 1 AND
                TCG.STATU = 1 AND
                TCG.TRAIN_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLASS_ID#">
        </cfquery>
        <cfreturn GET_CLASS_DETAIL>
    </cffunction>     
    
    <cffunction name="GET_TRAIN_DETAIL" returntype="query">
        <cfargument name="TRAIN_ID" type="numeric" required="no" default="">
        <cfquery name="GET_TRAIN_DETAIL" datasource="#DSN#">
            SELECT
                TRAIN_HEAD,
                TRAIN_OBJECTIVE
            FROM
                TRAINING
            WHERE
                TRAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#TRAIN_ID#">
        </cfquery>
        <cfreturn GET_TRAIN_DETAIL>
    </cffunction>
    
    <cffunction name="GET_CONTENT_COUNT" returntype="query">
        <cfargument name="TRAIN_ID" type="numeric" required="no" default="">
        <cfquery name="GET_CONTENT_COUNT" datasource="#DSN#">
            SELECT COUNT(*) AS CONTENT_COUNT FROM CONTENT_RELATION WHERE ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="train_id"> AND ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#TRAIN_ID#">
        </cfquery>
        <cfreturn GET_CONTENT_COUNT>
    </cffunction> 
    
    <cffunction name="GET_ASSET_COUNT" returntype="query">
        <cfargument name="TRAIN_ID" type="numeric" required="no" default="">
        <cfquery name="GET_ASSET_COUNT" datasource="#DSN#">
            SELECT
                ASSET_FILE_NAME,
                EMBEDCODE_URL
            FROM
                ASSET
            WHERE
                ACTION_SECTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="TRAIN_ID">
                AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#TRAIN_ID#">
        </cfquery>
        <cfreturn GET_ASSET_COUNT>
    </cffunction>

    <cffunction name="TRAINING_REQUEST" access="remote" returntype="string" returnargumentsat="json">
            <cfargument name="CLASS_ID" required="no" default="">
            <cfargument name="TRAIN_ID" required="no" default="">
            <cftry>      
                <cfif isdefined("arguments.CLASS_ID") and len(arguments.CLASS_ID)>
                        <cfquery name="GET_TRAINING_INFO" datasource="#dsn#">
                            SELECT 
                                CLASS_NAME 
                            FROM 
                                TRAINING_CLASS 
                            WHERE 
                                CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.CLASS_ID#">
                        </cfquery>
                    <cfelseif isdefined("arguments.TRAIN_ID") and len(arguments.TRAIN_ID)>
                        <cfquery name="GET_TRAINING_CURRICULUM" datasource="#dsn#">
                            SELECT 
                                TRAIN_HEAD 
                            FROM 
                                TRAINING T 
                            WHERE 
                                TRAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TRAIN_ID#">
                        </cfquery>
                </cfif>
    
                <cfsavecontent variable="topicContent">
                    <cfoutput>
                        <cfif isdefined("arguments.CLASS_ID") and len(arguments.CLASS_ID)>
                            #arguments.CLASS_ID# idli <strong>#GET_TRAINING_INFO.CLASS_NAME#</strong> eğitim/seminer için katılm talep ediliyor </br>
                        <cfelseif isdefined("arguments.TRAIN_ID") and len(arguments.TRAIN_ID)>
                            #arguments.TRAIN_ID# idli <strong>#GET_TRAINING_CURRICULUM.TRAIN_HEAD#</strong> eğitim/seminer için katılm talep ediliyor </br>
                        </cfif>
                        <strong>Firma</strong> : #arguments.trainees_firm#</br>
                        <strong>Ad Soyad</strong> : #arguments.trainees#</br>
                        <strong>Telefon</strong> : #arguments.trainees_phone#</br>
                        <strong>E Mail</strong> : #arguments.trainees_mail#</br>
                        <cfif len(arguments.trainees_note)>
                            <strong>Not</strong> : #arguments.trainees_note#
                        </cfif>
                        </br></br> <em>workcube.com'dan gönderildi.</em>
                        </br><a href="#CGI.HTTP_REFERER#">#CGI.HTTP_REFERER#</a>
                    </cfoutput>
                </cfsavecontent>
    
                
                <cfquery name="GET_TRAINING_REQUEST" datasource="#dsn#" result="query_result">	
                    INSERT INTO
                        CUSTOMER_HELP (
                            PARTNER_ID,
                            COMPANY_ID,					
                            CONSUMER_ID,
                            WORKCUBE_ID,
                            PRODUCT_ID,
                            COMPANY,
                            APP_CAT,
                            INTERACTION_CAT,
                            INTERACTION_DATE,
                            SUBJECT,
                            PROCESS_STAGE,
                            DETAIL,
                            APPLICANT_NAME,
                            APPLICANT_MAIL,
                            IS_REPLY_MAIL,
                            IS_REPLY,	
                            RECORD_EMP,
                            RECORD_DATE,
                            RECORD_IP)
                    VALUES
                        (
                            NULL,
                            NULL,
                            NULL,
                            NULL,
                            NULL,
                            NULL,
                            5,
                            21,
                            GETDATE(),
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#topicContent#">,
                            29,
                            <cfif isdefined("arguments.CLASS_ID") and len(arguments.CLASS_ID)>
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="Etkinlik Katılım Talebi - #GET_TRAINING_INFO.CLASS_NAME#">,
                            <cfelseif isdefined("arguments.TRAIN_ID") and len(arguments.TRAIN_ID)>
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="Etkinlik Katılım Talebi - #GET_TRAINING_CURRICULUM.TRAIN_HEAD#">,
                            </cfif>
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.trainees#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.trainees_mail#">,
                            0,
                            0,
                            1,
                            GETDATE(),
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                        )
                </cfquery>   
               
                <cfif isdefined("arguments.CLASS_ID") and len(arguments.CLASS_ID)>
                    <cfquery name="ADD_CLASS_POTENTIAL_ATTENDERS" datasource="#DSN#" result="add_attender">
                        INSERT INTO
                            TRAINING_GROUP_ATTENDERS
                            (
                                TRAINING_GROUP_ID,
                                NAME,
                                EMAIL,
                                PHONE,
                                STATUS,
                                JOIN_STATU
                            )
                            VALUES
                            (
                                
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.CLASS_ID#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.trainees#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.trainees_mail#">,
                                <cfif len(arguments.trainees_phone)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.trainees_phone#"><cfelse>NULL</cfif>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                            )
                    </cfquery>               
                </cfif>
                     
            <cfset result.status = true>
            <!--- <cfset result.success_message = "Kaydı Yapıldı, Yönlendiriliyor"> --->
            <cfif session_base.language eq "tr">
                <cfset result.success_message ="Kaydı Yapıldı, Yönlendiriliyor">
            <cfelseif session_base.language eq "eng">
                <cfset result.success_message ="Registration Completed, You Are Being Redirected">
            <cfelseif session_base.language eq "de">
                <cfset result.success_message ="Registrierung abgeschlossen, Sie werden weitergeleitet">
            </cfif>
            <cfcatch type="any">
                <cfset result.status = false>
                <!--- <cfset result.danger_message = "Şuanda işlem yapılamıyor..."> --->
                <cfif session_base.language eq "tr">
                    <cfset result.danger_message ="Şuanda işlem yapılamıyor...">
                <cfelseif session_base.language eq "eng">
                    <cfset result.danger_message ="Currently Unable to Operate">
                <cfelseif session_base.language eq "de">
                    <cfset result.danger_message ="Derzeit nicht betriebsbereit">
                </cfif>
                <cfset result.error = cfcatch >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <!--- Sertifika Eğitimleri --->
    <cffunction name="GET_TRAININGS_CURRICULUM" access="public">
		<cfquery name="GET_TRAININGS_CURRICULUM" datasource="#DSN#">
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
                T.PATH,
                UFU.USER_FRIENDLY_URL
			FROM 
				TRAINING T
                OUTER APPLY(
                    SELECT TOP 1 UFU.USER_FRIENDLY_URL 
                    FROM #dsn#.USER_FRIENDLY_URLS UFU 
                    WHERE UFU.ACTION_TYPE = 'TRAIN_ID' 
                    AND UFU.ACTION_ID = T.TRAIN_ID 		
                    AND UFU.PROTEIN_SITE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.site#">) UFU
			WHERE
				T.TRAIN_ID <> 0 AND
		        T.SUBJECT_STATUS = 1 AND
                T.LANGUAGE =<cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.language#">
                
			ORDER BY T.RECORD_DATE DESC,T.TRAIN_HEAD 
		</cfquery>
        
        <cfreturn GET_TRAININGS_CURRICULUM>
	</cffunction>

    <cffunction name="GET_TRAININGS_CURRICULUM_DET" access="public">
		<cfquery name="GET_TRAININGS_CURRICULUM_DET" datasource="#DSN#">
			SELECT 
				T.TRAIN_ID, 
				T.TRAIN_OBJECTIVE,
				T.TRAIN_HEAD,
                T.TRAIN_DETAIL,
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
                T.PATH
			FROM 
				TRAINING T               
			WHERE
				T.TRAIN_ID <> 0 AND
		        T.SUBJECT_STATUS = 1 AND
                T.TRAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.train_id#">
			ORDER BY T.RECORD_DATE DESC,T.TRAIN_HEAD 
		</cfquery>
        <cfreturn GET_TRAININGS_CURRICULUM_DET>
	</cffunction>
    <cffunction name="get_training_group" access="public">
        <cfargument name="start_date" type="date" required="yes" default="#now()#">
        <cfargument name="maxrows" required="no" default="">
        <cfargument name="widget" type="string" required="no" default="">
        <cfargument name="join" type="string" required="no" default="1">
        <cfargument name="limitdate" type="string" required="no" default="">
        <cfargument name="cat_id" type="string" required="no" default="">
        <cfargument name="train_group_id" default="">
	    <cftransaction>
	        <cfquery name="get_training_group" datasource="#DSN#">
                SELECT
                    TCG.*,
                    FORMAT(START_DATE, 'dddd', 'tr') AS SDAY,
                    FORMAT(START_DATE, 'dddd', 'en') AS SDAY_EN,
                    FORMAT(START_DATE, 'dddd', 'de') AS SDAY_DE
                FROM
                    TRAINING_CLASS_GROUPS TCG
                    <cfif isdefined('arguments.site')>OUTER APPLY(
                        SELECT TOP 1 UFU.USER_FRIENDLY_URL 
                        FROM USER_FRIENDLY_URLS UFU 
                        WHERE UFU.ACTION_TYPE = 'CLASS_ID' 
                        AND UFU.ACTION_ID = TC.CLASS_ID 		
                        AND UFU.PROTEIN_SITE = #arguments.site#) UFU</cfif>
                WHERE
                    <cfif isDefined("arguments.limitdate") and len(arguments.limitdate) >
                        <cfif arguments.limitdate eq 1>
                            TCG.START_DATE >= #start_date# AND
                        <cfelse>
                            TCG.FINISH_DATE >= #start_date# AND  
                        </cfif>
                    <cfelse>
                        TCG.FINISH_DATE >= #start_date# AND  
                    </cfif>
                    TCG.TRAIN_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.train_group_id#">
            </cfquery>
	        <cfreturn get_training_group>
	    </cftransaction>
	</cffunction>
    <cffunction name="training_group_count" access="public">
        <cfargument name="train_group_id" default="">
	    <cftransaction>
	        <cfquery name="training_group_count" datasource="#DSN#">
                SELECT
                    COUNT(TC.CLASS_ID) AS CLASS_COUNT
                FROM
                    TRAINING_CLASS_GROUP_CLASSES TCG,
                    TRAINING_CLASS TC
                WHERE
                    TC.CLASS_ID=TCG.CLASS_ID
                AND
                    TCG.TRAIN_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.train_group_id#">
            </cfquery>
	        <cfreturn training_group_count>
	    </cftransaction>
	</cffunction>
</cfcomponent>	