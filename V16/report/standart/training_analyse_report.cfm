<cfsetting  showdebugoutput="true" >
<cfparam name="attributes.module_id_control" default="34">
<cfinclude template="report_authority_control.cfm">
<cfprocessingdirective suppresswhitespace="yes">
<cfscript>
	bu_ay_basi = CreateDate(year(now()),month(now()),1);
	bu_ay_sonu = DaysInMonth(bu_ay_basi);
</cfscript>
<cfparam name="attributes.startdate" default="#date_add('m',-1,bu_ay_basi)#">
<cfparam name="attributes.finishdate" default="#Createdate(year(bu_ay_basi),month(bu_ay_basi),bu_ay_sonu)#">
<cfparam name="attributes.tr_startdate" default="#date_add('m',-1,bu_ay_basi)#">
<cfparam name="attributes.tr_finishdate" default="#Createdate(year(bu_ay_basi),month(bu_ay_basi),bu_ay_sonu)#">
<cfparam name="attributes.inout_statue" default="2">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.comp_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.mem_department" default="">
<cfparam name="attributes.report_type" default="1">
<cfparam name="attributes.report_basis" default="1">
<cfif isdefined("attributes.is_submitted")>
	<cf_date tarih="attributes.startdate">
	<cf_date tarih="attributes.finishdate">
	<cfif attributes.report_type neq 4>
		<cf_date tarih="attributes.tr_startdate">
		<cf_date tarih="attributes.tr_finishdate">
	</cfif>
	<cfif attributes.report_type eq 4>
		<cfif isdefined('attributes.train_id') and len(attributes.train_id)>
			<cfquery name="get_related_field" datasource="#dsn#">
				SELECT DISTINCT
					RELATION_ACTION
				FROM
					RELATION_SEGMENT_TRAINING
				WHERE
					RELATION_FIELD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_id#">
					AND RELATION_TABLE = 'TRAINING'
			</cfquery>
			<cfset field_list = ''>
			<cfif get_related_field.recordcount>
				<cfset field_list = valuelist(get_related_field.relation_action,',')>
			</cfif>
		<cfelse>
			<script type="text/javascript">
				alert('Konu seçmelisiniz!');
				history.back();
			</script>
			<cfabort>
		</cfif>
	</cfif>
	<cfif attributes.report_basis eq 1>
		<cfquery name="get_emp_tra" datasource="#dsn#">
			SELECT DISTINCT
				E.EMPLOYEE_NAME AS NAME,
				E.EMPLOYEE_SURNAME AS SURNAME,
				EP.POSITION_NAME,
				D.DEPARTMENT_HEAD,
				B.BRANCH_NAME,
				OC.NICK_NAME,
				E.GROUP_STARTDATE,
				ED.SEX,
				EI.BIRTH_DATE,
	            EI.TC_IDENTY_NO,
				E.EMPLOYEE_ID,
	            TC.CLASS_ID,
	            TC.CLASS_NAME,
	            CU.UNIT_NAME,
	            TCG.GROUP_HEAD
	            <cfif attributes.report_type eq 4>
	            	,CASE WHEN DT.EMP_ID IS NOT NULL THEN 1 WHEN TC.CLASS_ID IS NULL THEN 0 WHEN TC.CLASS_ID IS NOT NULL AND DT.EMP_ID IS NULL THEN 2 END AS KATILIM
	            </cfif>
			FROM
				EMPLOYEES E <cfif isdefined('attributes.get_all_pos')> LEFT JOIN <cfelse>INNER JOIN</cfif> EMPLOYEE_POSITIONS EP
				ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID
	            LEFT JOIN EMPLOYEES_IDENTY EI ON E.EMPLOYEE_ID = EI.EMPLOYEE_ID
	            LEFT JOIN EMPLOYEES_DETAIL ED ON E.EMPLOYEE_ID = ED.EMPLOYEE_ID
	            LEFT JOIN DEPARTMENT D ON EP.DEPARTMENT_ID = D.DEPARTMENT_ID
	            LEFT JOIN BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
	            LEFT JOIN OUR_COMPANY OC ON OC.COMP_ID = B.COMPANY_ID
	            LEFT JOIN SETUP_CV_UNIT CU ON CU.UNIT_ID = EP.FUNC_ID
	            <cfif attributes.report_type neq 2>
					LEFT JOIN TRAINING_CLASS_ATTENDER TCA ON TCA.EMP_ID = E.EMPLOYEE_ID
	            </cfif>
	            <cfif attributes.report_type neq 4>
					,TRAINING_CLASS TC
				<cfelse>
					LEFT JOIN TRAINING_CLASS TC ON TC.CLASS_ID = TCA.CLASS_ID AND TC.TRAINING_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_id#">
					LEFT JOIN TRAINING_CLASS_ATTENDANCE TCS ON TCS.CLASS_ID = TC.CLASS_ID
					LEFT JOIN TRAINING_CLASS_ATTENDANCE_DT DT ON TCS.CLASS_ATTENDANCE_ID = DT.CLASS_ATTENDANCE_ID AND DT.EMP_ID = E.EMPLOYEE_ID AND DT.ATTENDANCE_MAIN >0 AND DT.IS_TRAINER = 0
					<cfif len(field_list)>
						<cfif listFind(field_list,'1')>
							INNER JOIN RELATION_SEGMENT_TRAINING RST ON RST.RELATION_ACTION = 1 AND RST.RELATION_ACTION_ID = OC.COMP_ID AND RST.RELATION_FIELD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_id#">
						</cfif>
						<cfif listFind(field_list,'2')>
							INNER JOIN RELATION_SEGMENT_TRAINING RST_DEP ON RST_DEP.RELATION_ACTION = 2 AND RST_DEP.RELATION_ACTION_ID = EP.DEPARTMENT_ID AND RST_DEP.RELATION_FIELD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_id#">
						</cfif>
						<cfif listFind(field_list,'3')>
							INNER JOIN RELATION_SEGMENT_TRAINING RST_POSCAT ON RST_POSCAT.RELATION_ACTION = 3 AND RST_POSCAT.RELATION_ACTION_ID = EP.POSITION_CAT_ID AND RST_POSCAT.RELATION_FIELD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_id#">
						</cfif>
						<cfif listFind(field_list,'5')>
							INNER JOIN RELATION_SEGMENT_TRAINING RST_FUNC ON RST_FUNC.RELATION_ACTION = 5 AND RST_FUNC.RELATION_ACTION_ID = EP.FUNC_ID AND RST_FUNC.RELATION_FIELD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_id#">
						</cfif>
						<cfif listFind(field_list,'6')>
							INNER JOIN RELATION_SEGMENT_TRAINING RST_STEP ON RST_STEP.RELATION_ACTION = 6 AND RST_STEP.RELATION_ACTION_ID = EP.ORGANIZATION_STEP_ID AND RST_STEP.RELATION_FIELD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_id#">
						</cfif>
						<cfif listFind(field_list,'7')>
							INNER JOIN RELATION_SEGMENT_TRAINING RST_BRANCH ON RST_BRANCH.RELATION_ACTION = 7 AND RST_BRANCH.RELATION_ACTION_ID = B.BRANCH_ID AND RST_BRANCH.RELATION_FIELD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_id#">
						</cfif>
						<cfif listFind(field_list,'9')>
							INNER JOIN RELATION_SEGMENT_TRAINING RST_REQ ON RST_REQ.RELATION_ACTION = 9 AND RST_REQ.RELATION_ACTION_ID IN (SELECT REQ_TYPE_ID FROM POSITION_REQUIREMENTS WHERE POSITION_ID=EP.POSITION_ID) AND RST_REQ.RELATION_FIELD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_id#">
						</cfif>
					</cfif>
				</cfif>
	            LEFT JOIN TRAINING_CLASS_GROUP_CLASSES TCGC ON TC.CLASS_ID=TCGC.CLASS_ID
	            LEFT JOIN TRAINING_CLASS_GROUPS TCG ON TCG.TRAIN_GROUP_ID = TCGC.TRAIN_GROUP_ID
			WHERE
				E.EMPLOYEE_ID IS NOT NULL
				<cfif not isdefined('attributes.get_all_pos')>
					AND EP.IS_MASTER = 1
				</cfif>
	            <cfif attributes.report_type neq 2 and attributes.report_type neq 4>
					AND TC.CLASS_ID = TCA.CLASS_ID 
	            </cfif>
				<cfif isdefined('attributes.class_id') and len(attributes.class_id) and len(attributes.class_name)>
					AND TC.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
				</cfif>
				<cfif isdefined('attributes.train_id') and len(attributes.train_id) and attributes.report_type neq 4>
					AND TC.TRAINING_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_id#">
				</cfif>
				<cfif isdefined('attributes.tr_startdate') and isdate(attributes.tr_startdate) and attributes.report_type neq 4>
					AND TC.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.tr_startdate#">
				</cfif>
				<cfif isdefined('attributes.tr_finishdate') and isdate(attributes.tr_finishdate) and attributes.report_type neq 4>
					AND TC.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.tr_finishdate#">
				</cfif>
				<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
					AND 
					(E.EMPLOYEE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
					OR E.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
	            	OR TC.CLASS_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)      
				</cfif>
				<cfif attributes.report_type eq 1>
					AND E.EMPLOYEE_ID IN(
					SELECT
						DT.EMP_ID
					FROM
						TRAINING_CLASS_ATTENDANCE TCS,
						TRAINING_CLASS_ATTENDANCE_DT DT
					WHERE
						DT.EMP_ID IS NOT NULL AND
						TCS.CLASS_ATTENDANCE_ID = DT.CLASS_ATTENDANCE_ID AND
						DT.ATTENDANCE_MAIN >0 AND
                        DT.IS_TRAINER = 0 AND
						TCS.CLASS_ID = TC.CLASS_ID
						<cfif isdefined('attributes.class_id') and len(attributes.class_id) and len(attributes.class_name)>
						AND TCS.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
						</cfif>	
					)
				<cfelseif attributes.report_type eq 2>
					AND E.EMPLOYEE_ID NOT IN(
					SELECT DISTINCT
						EMP_ID
					FROM
						TRAINING_CLASS_ATTENDER
		           	WHERE
		               	EMP_ID IS NOT NULL
						<cfif isdefined('attributes.class_id') and len(attributes.class_id) and len(attributes.class_name)>
							AND CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
						</cfif>		
		               <cfif isdefined('attributes.train_id') and len(attributes.train_id)>
		                    AND CLASS_ID IN(SELECT CLASS_ID FROM TRAINING_CLASS WHERE TRAINING_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_id#"> AND CLASS_ID = TC.CLASS_ID)
		                </cfif>
					)
				<cfelseif attributes.report_type eq 3>
					AND E.EMPLOYEE_ID IN(
						SELECT EMP_ID 
						FROM TRAINING_CLASS_ATTENDER 
						WHERE EMP_ID IS NOT NULL
						AND CLASS_ID = TC.CLASS_ID
					)
					AND E.EMPLOYEE_ID NOT IN(
					SELECT
						DT.EMP_ID
					FROM
						TRAINING_CLASS_ATTENDANCE TCS,
						TRAINING_CLASS_ATTENDANCE_DT DT
					WHERE
						DT.EMP_ID IS NOT NULL AND
						TCS.CLASS_ATTENDANCE_ID = DT.CLASS_ATTENDANCE_ID AND
						TCS.CLASS_ID = TC.CLASS_ID AND
                        DT.IS_TRAINER = 0
						<cfif isdefined('attributes.class_id') and len(attributes.class_id) and len(attributes.class_name)>
						AND TCS.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
						</cfif>		
					)
				</cfif>
				<cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
					AND OC.COMP_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.comp_id#">)
				</cfif>
		        <cfif IsDefined('attributes.branch_id') and len(attributes.branch_id)>
		        	AND B.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.branch_id#">)
				</cfif>
		        <cfif IsDefined('attributes.department') and len(attributes.department)>
		        	AND EP.DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.department#">)
				</cfif>
				<cfif isdefined("attributes.func_id") and len(attributes.func_id)>
					AND EP.FUNC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.func_id#">
				</cfif>
				<cfif isdefined("attributes.title_id") and len(attributes.title_id)>
					AND EP.TITLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.title_id#">
				</cfif>
		        <cfif isdefined("attributes.train_group_id") and len(attributes.train_group_id)>
					AND TCGC.TRAIN_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_group_id#">
				</cfif>
		        <cfif isdefined('attributes.inout_statue') and attributes.inout_statue eq 1><!--- Girişler --->
		        	AND (E.EMPLOYEE_ID IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT EIO WHERE 1=1
					<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
		                AND EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
		            </cfif>
		            <cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
		                AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
		            </cfif>
		            ) <cfif isdefined('attributes.get_all_pos')> OR E.EMPLOYEE_ID NOT IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT EIO)</cfif>)
		        <cfelseif isdefined('attributes.inout_statue') and attributes.inout_statue eq 0><!--- Çıkışlar --->
		        	AND (E.EMPLOYEE_ID IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT EIO WHERE 1=1
		            <cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
		                AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
		            </cfif>
		            <cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
		                AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
		            </cfif>
		            AND	EIO.FINISH_DATE IS NOT NULL
	            ) <cfif isdefined('attributes.get_all_pos')> OR E.EMPLOYEE_ID NOT IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT EIO)</cfif>)
		        <cfelseif isdefined('attributes.inout_statue') and attributes.inout_statue eq 2><!--- aktif calisanlar --->
		            AND (E.EMPLOYEE_ID IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT EIO WHERE
		            (
		                <cfif isdate(attributes.startdate) or isdate(attributes.finishdate)>
		                    <cfif isdate(attributes.startdate) and not isdate(attributes.finishdate)>
		                    (
		                        (
		                        EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
		                        EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
		                        )
		                        OR
		                        (
		                        EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
		                        EIO.FINISH_DATE IS NULL
		                        )
		                    )
		                    <cfelseif not isdate(attributes.startdate) and isdate(attributes.finishdate)>
		                    (
		                        (
		                        EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND
		                        EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
		                        )
		                        OR
		                        (
		                        EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND
		                        EIO.FINISH_DATE IS NULL
		                        )
		                    )
		                    <cfelse>
		                    (
		                        (
		                        EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
		                        EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
		                        )
		                        OR
		                        (
		                        EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
		                        EIO.FINISH_DATE IS NULL
		                        )
		                        OR
		                        (
		                        EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
		                        EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
		                        )
		                        OR
		                        (
		                        EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
		                        EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
		                        )
		                    )
		                    </cfif>
		                <cfelse>
		                    EIO.FINISH_DATE IS NULL
		                </cfif>
		            ) ) <cfif isdefined('attributes.get_all_pos')> OR E.EMPLOYEE_ID NOT IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT EIO)</cfif>)
		        <cfelse><!--- giriş ve çıkışlar Seçili ise --->
		           AND (E.EMPLOYEE_ID IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT EIO WHERE 
		            (
		                (
		                    EIO.START_DATE IS NOT NULL
		                    <cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
		                        AND EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
		                    </cfif>
		                    <cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
		                        AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
		                    </cfif>
		                )
		                OR
		                (
		                    EIO.START_DATE IS NOT NULL
		                    <cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
		                        AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
		                    </cfif>
		                    <cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
		                        AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
		                    </cfif>
		                )
		            ) ) <cfif isdefined('attributes.get_all_pos')> OR E.EMPLOYEE_ID NOT IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT EIO)</cfif>)
		        </cfif>
			ORDER BY
				E.EMPLOYEE_NAME
		</cfquery>
	<cfelseif attributes.report_basis eq 2>
		<cfquery name="get_emp_tra" datasource="#dsn#">
			SELECT
				CON.CONSUMER_NAME AS NAME,
				CON.CONSUMER_SURNAME AS SURNAME,
				SPP.PARTNER_POSITION AS POSITION_NAME,
				SPD.PARTNER_DEPARTMENT AS DEPARTMENT_HEAD,
				'' AS BRANCH_NAME,
				CON.COMPANY AS NICK_NAME,
				CON.START_DATE AS GROUP_STARTDATE,
				CON.SEX,
				CON.BIRTHDATE AS BIRTH_DATE,
				CON.TC_IDENTY_NO,
				CON.CONSUMER_ID,
				'' AS PARTNER_ID,
				TC.CLASS_ID,
				TC.CLASS_NAME,
				TCG.GROUP_HEAD
				<cfif attributes.report_type eq 4>
	            	,CASE WHEN DT.CON_ID IS NOT NULL THEN 1 WHEN TC.CLASS_ID IS NULL THEN 0 WHEN TC.CLASS_ID IS NOT NULL AND DT.CON_ID IS NULL THEN 2 END AS KATILIM
	            </cfif>
			FROM
				CONSUMER CON 
				LEFT JOIN SETUP_PARTNER_POSITION SPP ON CON.MISSION = SPP.PARTNER_POSITION_ID
				LEFT JOIN SETUP_PARTNER_DEPARTMENT SPD ON CON.DEPARTMENT = SPD.PARTNER_DEPARTMENT_ID
				<cfif attributes.report_type neq 2>LEFT JOIN TRAINING_CLASS_ATTENDER TCA ON TCA.CON_ID = CON.CONSUMER_ID</cfif>
				<cfif attributes.report_type neq 4>
					,TRAINING_CLASS TC
				<cfelse>
					LEFT JOIN TRAINING_CLASS TC ON TC.CLASS_ID = TCA.CLASS_ID AND TC.TRAINING_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_id#"><cfif len(attributes.tr_startdate)> AND TC.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.tr_startdate#"></cfif><cfif len(attributes.tr_finishdate)> AND TC.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.tr_finishdate#"></cfif>
					LEFT JOIN TRAINING_CLASS_ATTENDANCE TCS ON TCS.CLASS_ID = TC.CLASS_ID
					LEFT JOIN TRAINING_CLASS_ATTENDANCE_DT DT ON TCS.CLASS_ATTENDANCE_ID = DT.CLASS_ATTENDANCE_ID AND DT.CON_ID = CON.CONSUMER_ID AND DT.ATTENDANCE_MAIN >0 AND DT.IS_TRAINER = 0
					<cfif len(field_list)>
						<cfif listFind(field_list,'8')>
							INNER JOIN RELATION_SEGMENT_TRAINING RST ON RST.RELATION_ACTION = 8 AND RST.RELATION_ACTION_ID = CON.CONSUMER_CAT_ID AND RST.RELATION_FIELD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_id#">
						</cfif>
					</cfif>
				</cfif>
				LEFT JOIN TRAINING_CLASS_GROUP_CLASSES TCGC ON TC.CLASS_ID=TCGC.CLASS_ID
			    LEFT JOIN TRAINING_CLASS_GROUPS TCG ON TCG.TRAIN_GROUP_ID = TCGC.TRAIN_GROUP_ID
			WHERE
				CON.CONSUMER_ID IS NOT NULL
				<cfif attributes.report_type neq 2 and attributes.report_type neq 4>
					AND TC.CLASS_ID = TCA.CLASS_ID 
		      	</cfif>
		      	<cfif isdefined('attributes.class_id') and len(attributes.class_id) and len(attributes.class_name)>
					AND TC.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
				</cfif>
				<cfif isdefined('attributes.train_id') and len(attributes.train_id) and attributes.report_type neq 4>
					AND TC.TRAINING_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_id#">
				</cfif>
				<cfif isdefined('attributes.tr_startdate') and isdate(attributes.tr_startdate) and attributes.report_type neq 4>
					AND TC.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.tr_startdate#">
				</cfif>
				<cfif isdefined('attributes.tr_finishdate') and isdate(attributes.tr_finishdate) and attributes.report_type neq 4>
					AND TC.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.tr_finishdate#">
				</cfif>
				<cfif isdefined("attributes.train_group_id") and len(attributes.train_group_id)>
					AND TCGC.TRAIN_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_group_id#">
				</cfif>
				<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
					AND 
					(CON.CONSUMER_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
						OR
					CON.CONSUMER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		            	OR TC.CLASS_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)      
				</cfif>
				<cfif IsDefined('attributes.mem_department') and len(attributes.mem_department)>
		        	AND CON.DEPARTMENT IN (#attributes.mem_department#)
				</cfif>
				<cfif attributes.report_type eq 1>
					AND CON.CONSUMER_ID IN(
					SELECT
						DT.CON_ID
					FROM
						TRAINING_CLASS_ATTENDANCE TCS,
						TRAINING_CLASS_ATTENDANCE_DT DT
					WHERE
						DT.CON_ID IS NOT NULL AND
						TCS.CLASS_ATTENDANCE_ID = DT.CLASS_ATTENDANCE_ID AND
						DT.ATTENDANCE_MAIN > 0 AND
						TCS.CLASS_ID = TC.CLASS_ID AND
                        DT.IS_TRAINER = 0
						<cfif isdefined('attributes.class_id') and len(attributes.class_id) and len(attributes.class_name)>
							AND TCS.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
						</cfif>		
					)
				<cfelseif attributes.report_type eq 2>
					AND CON.CONSUMER_ID NOT IN(
					SELECT DISTINCT
						CON_ID
					FROM
						TRAINING_CLASS_ATTENDER
		           	WHERE
		               	CON_ID IS NOT NULL
						<cfif isdefined('attributes.class_id') and len(attributes.class_id) and len(attributes.class_name)>
							AND CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
						</cfif>		
		               <cfif isdefined('attributes.train_id') and len(attributes.train_id)>
		                    AND CLASS_ID IN(SELECT CLASS_ID FROM TRAINING_CLASS WHERE TRAINING_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_id#"> AND CLASS_ID = TC.CLASS_ID)
		                </cfif>
					)
				<cfelseif attributes.report_type eq 3>
					AND CON.CONSUMER_ID IN(
						SELECT CON_ID 
						FROM TRAINING_CLASS_ATTENDER 
						WHERE CON_ID IS NOT NULL
						AND CLASS_ID = TC.CLASS_ID
					)
					AND CON.CONSUMER_ID NOT IN(
					SELECT
						DT.CON_ID
					FROM
						TRAINING_CLASS_ATTENDANCE TCS,
						TRAINING_CLASS_ATTENDANCE_DT DT
					WHERE
						DT.CON_ID IS NOT NULL AND
						TCS.CLASS_ATTENDANCE_ID = DT.CLASS_ATTENDANCE_ID AND
						TCS.CLASS_ID = TC.CLASS_ID AND
                        DT.IS_TRAINER = 0
						<cfif isdefined('attributes.class_id') and len(attributes.class_id) and len(attributes.class_name)>
							AND TCS.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
						</cfif>		
					)
				</cfif>
			UNION
			SELECT
				CP.COMPANY_PARTNER_NAME AS NAME,
				CP.COMPANY_PARTNER_SURNAME AS SURNAME,
				SPP.PARTNER_POSITION AS POSITION_NAME,
				SPD.PARTNER_DEPARTMENT AS DEPARTMENT_HEAD,
				B.COMPBRANCH__NAME AS BRANCH_NAME,
				C.NICKNAME AS NICK_NAME,
				CP.START_DATE AS GROUP_STARTDATE,
				CP.SEX,
				CP.BIRTHDATE AS BIRTH_DATE,
				CP.TC_IDENTITY AS TC_IDENTY_NO,
				'' AS CONSUMER_ID,
				CP.PARTNER_ID,
				TC.CLASS_ID,
				TC.CLASS_NAME,
				TCG.GROUP_HEAD
				<cfif attributes.report_type eq 4>
	            	,CASE WHEN DT.PAR_ID IS NOT NULL THEN 1 WHEN TC.CLASS_ID IS NULL THEN 0 WHEN TC.CLASS_ID IS NOT NULL AND DT.PAR_ID IS NULL THEN 2 END AS KATILIM
	            </cfif>
			FROM
				COMPANY_PARTNER CP
				LEFT JOIN SETUP_PARTNER_POSITION SPP ON CP.MISSION = SPP.PARTNER_POSITION_ID
				LEFT JOIN COMPANY_BRANCH B ON B.COMPBRANCH_ID = CP.COMPBRANCH_ID
				LEFT JOIN SETUP_PARTNER_DEPARTMENT SPD ON CP.DEPARTMENT = SPD.PARTNER_DEPARTMENT_ID
				LEFT JOIN COMPANY C ON C.COMPANY_ID = CP.COMPANY_ID
				<cfif attributes.report_type neq 2>LEFT JOIN TRAINING_CLASS_ATTENDER TCA ON TCA.PAR_ID = CP.PARTNER_ID</cfif>
				<cfif attributes.report_type neq 4>
					,TRAINING_CLASS TC
				<cfelse>
					LEFT JOIN TRAINING_CLASS TC ON TC.CLASS_ID = TCA.CLASS_ID AND TC.TRAINING_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_id#"><cfif len(attributes.tr_startdate)> AND TC.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.tr_startdate#"></cfif><cfif len(attributes.tr_finishdate)> AND TC.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.tr_finishdate#"></cfif>
					LEFT JOIN TRAINING_CLASS_ATTENDANCE TCS ON TCS.CLASS_ID = TC.CLASS_ID
					LEFT JOIN TRAINING_CLASS_ATTENDANCE_DT DT ON TCS.CLASS_ATTENDANCE_ID = DT.CLASS_ATTENDANCE_ID AND DT.PAR_ID = CP.PARTNER_ID AND DT.ATTENDANCE_MAIN >0 AND DT.IS_TRAINER = 0
					<cfif len(field_list)>
						<cfif listFind(field_list,'4')>
							INNER JOIN RELATION_SEGMENT_TRAINING RST ON RST.RELATION_ACTION = 4 AND RST.RELATION_ACTION_ID = C.COMPANYCAT_ID AND RST.RELATION_FIELD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_id#">
						</cfif>
					</cfif>
				</cfif>
				LEFT JOIN TRAINING_CLASS_GROUP_CLASSES TCGC ON TC.CLASS_ID=TCGC.CLASS_ID
			    LEFT JOIN TRAINING_CLASS_GROUPS TCG ON TCG.TRAIN_GROUP_ID = TCGC.TRAIN_GROUP_ID
			WHERE
				CP.PARTNER_ID IS NOT NULL
				<cfif attributes.report_type neq 2 and attributes.report_type neq 4>
					AND TC.CLASS_ID = TCA.CLASS_ID 
		      	</cfif>
		      	<cfif isdefined('attributes.class_id') and len(attributes.class_id) and len(attributes.class_name)>
					AND TC.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
				</cfif>
				<cfif isdefined('attributes.train_id') and len(attributes.train_id) and attributes.report_type neq 4>
					AND TC.TRAINING_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_id#">
				</cfif>
				<cfif isdefined('attributes.tr_startdate') and isdate(attributes.tr_startdate) and attributes.report_type neq 4>
					AND TC.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.tr_startdate#">
				</cfif>
				<cfif isdefined('attributes.tr_finishdate') and isdate(attributes.tr_finishdate) and attributes.report_type neq 4>
					AND TC.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.tr_finishdate#">
				</cfif>
				<cfif isdefined("attributes.train_group_id") and len(attributes.train_group_id)>
					AND TCGC.TRAIN_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_group_id#">
				</cfif>
				<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
					AND 
					(CP.COMPANY_PARTNER_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
						OR
					CP.COMPANY_PARTNER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		            	OR TC.CLASS_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)      
				</cfif>
				<cfif IsDefined('attributes.mem_department') and len(attributes.mem_department)>
		        	AND CP.DEPARTMENT IN (#attributes.mem_department#)
				</cfif>
				<cfif attributes.report_type eq 1>
					AND CP.PARTNER_ID IN(
					SELECT
						DT.PAR_ID
					FROM
						TRAINING_CLASS_ATTENDANCE TCS,
						TRAINING_CLASS_ATTENDANCE_DT DT
					WHERE
						DT.PAR_ID IS NOT NULL AND
						TCS.CLASS_ATTENDANCE_ID = DT.CLASS_ATTENDANCE_ID AND
						DT.ATTENDANCE_MAIN > 0 AND
						TCS.CLASS_ID = TC.CLASS_ID AND
                        DT.IS_TRAINER = 0
						<cfif isdefined('attributes.class_id') and len(attributes.class_id) and len(attributes.class_name)>
							AND TCS.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
						</cfif>		
					)
				<cfelseif attributes.report_type eq 2>
					AND CP.PARTNER_ID NOT IN(
					SELECT DISTINCT
						PAR_ID
					FROM
						TRAINING_CLASS_ATTENDER
		           	WHERE
		               	PAR_ID IS NOT NULL
						<cfif isdefined('attributes.class_id') and len(attributes.class_id) and len(attributes.class_name)>
							AND CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
						</cfif>		
		               <cfif isdefined('attributes.train_id') and len(attributes.train_id)>
		                    AND CLASS_ID IN(SELECT CLASS_ID FROM TRAINING_CLASS WHERE TRAINING_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_id#"> AND CLASS_ID = TC.CLASS_ID)
		                </cfif>
					)
				<cfelseif attributes.report_type eq 3>
					AND CP.PARTNER_ID IN(
						SELECT PAR_ID 
						FROM TRAINING_CLASS_ATTENDER 
						WHERE PAR_ID IS NOT NULL
						AND CLASS_ID = TC.CLASS_ID
					)
					AND CP.PARTNER_ID NOT IN(
					SELECT
						DT.PAR_ID
					FROM
						TRAINING_CLASS_ATTENDANCE TCS,
						TRAINING_CLASS_ATTENDANCE_DT DT
					WHERE
						DT.PAR_ID IS NOT NULL AND
						TCS.CLASS_ATTENDANCE_ID = DT.CLASS_ATTENDANCE_ID AND
						TCS.CLASS_ID = TC.CLASS_ID AND
                        DT.IS_TRAINER = 0
						<cfif isdefined('attributes.class_id') and len(attributes.class_id) and len(attributes.class_name)>
							AND TCS.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
						</cfif>		
					)
				</cfif>
		</cfquery>
	</cfif>	
<cfelse>
	<cfset get_emp_tra.recordcount = 0>
</cfif>
<cfquery name="training" datasource="#dsn#">
	SELECT TRAIN_ID,TRAIN_HEAD,SUBJECT_STATUS FROM TRAINING
</cfquery>
<cfquery name="get_our_company" datasource="#dsn#">
	SELECT COMP_ID,COMPANY_NAME FROM OUR_COMPANY ORDER BY COMPANY_NAME
</cfquery>
<cfquery name="get_units" datasource="#dsn#">
	SELECT UNIT_ID,UNIT_NAME FROM SETUP_CV_UNIT 
</cfquery>
<cfquery name="TITLES" datasource="#dsn#">
	SELECT TITLE_ID,TITLE FROM SETUP_TITLE WHERE IS_ACTIVE = 1 ORDER BY TITLE
</cfquery>
<cfquery name="training_groups" datasource="#dsn#">
	SELECT TRAIN_GROUP_ID,GROUP_HEAD FROM TRAINING_CLASS_GROUPS ORDER BY GROUP_HEAD
</cfquery>
<cfquery name="get_branchs" datasource="#dsn#">
    SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE <cfif isdefined('attributes.comp_id') and len(attributes.comp_id)>COMPANY_ID IN(#attributes.comp_id#)<cfelse>1=0</cfif>ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="get_department" datasource="#dsn#">
	SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>BRANCH_ID IN(#attributes.branch_id#)<cfelse>1=0</cfif> AND DEPARTMENT_STATUS = 1 ORDER BY DEPARTMENT_HEAD
</cfquery>
<cfquery name="get_mem_department" datasource="#dsn#">
	SELECT PARTNER_DEPARTMENT_ID,PARTNER_DEPARTMENT FROM SETUP_PARTNER_DEPARTMENT ORDER BY PARTNER_DEPARTMENT
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_emp_tra.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="form" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
<cf_report_list_search id="search" title="#getLang('report',311)#">
<cf_report_list_search_area>
           <div class="row">
                <div class="col col-12 col-xs-12">
                    <div class="row formContent">
						<div class="row" type="row">
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='48.Filtre'></label>
										<div class="col col-12 col-xs-12">
											<cfinput type="text" name="keyword" value="#attributes.keyword#">
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no="7.Eğitim"></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="class_id" id="class_id" value="<cfif isdefined('attributes.class_id') and len(attributes.class_id) and len(attributes.class_name)><cfoutput>#attributes.class_id#</cfoutput></cfif>">
												<input type="text" name="class_name" id="class_name" value="<cfif isdefined('attributes.class_id') and len(attributes.class_id) and len(attributes.class_name)><cfoutput>#attributes.class_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('class_name','CLASS_NAME','CLASS_NAME','get_training_class','','CLASS_ID','class_id','','3','200');">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen(<cfoutput>'#request.self#</cfoutput>?fuseaction=objects.popup_list_classes&field_id=form.class_id&field_name=form.class_name','list')"></span>
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"  name="tra_date_td_label" id="tra_date_td_label" nowrap <cfif attributes.report_type eq 4>style="display:none;"</cfif>><cf_get_lang_main no="7.Eğitim"><cf_get_lang_main no='1278.Tarih Aralığı'>*</label>
										<div class="col col-6" name="tra_date_td" id="tra_date_td" nowrap <cfif attributes.report_type eq 4>style="display:none;"</cfif>>
											<div class="input-group">
												<cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no='641.Başlangıç Tarihi'></cfsavecontent>
												<cfinput type="text" name="tr_startdate" id="tr_startdate" maxlength="10" validate="#validate_style#" required="yes" message="#message#"  value="#dateformat(attributes.tr_startdate,dateformat_style)#">
												<span class="input-group-addon"><cf_wrk_date_image date_field="tr_startdate"></span>
											</div>
										</div>
										<div class="col col-6" name="tra_date_td1" id="tra_date_td1" nowrap <cfif attributes.report_type eq 4>style="display:none;"</cfif>>
											<div class="input-group">
												<cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no='288.Bitiş Tarihi'></cfsavecontent>
												<cfinput type="text" name="tr_finishdate" id="tr_finishdate" maxlength="10" validate="#validate_style#" required="yes" message="#message#" value="#dateformat(attributes.tr_finishdate,dateformat_style)#">
												<span class="input-group-addon"><cf_wrk_date_image date_field="tr_finishdate"></span>
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang no='673.Konular'></label>
										<div class="col col-12 col-xs-12">
											<select name="train_id" id="train_id">
												<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
												<cfoutput query="training">
													<option <cfif subject_status eq 0>style="color:999999"</cfif>value="#TRAIN_ID#"<cfif isdefined("attributes.TRAIN_ID") and attributes.TRAIN_ID eq training.TRAIN_ID>selected</cfif>>#TRAIN_HEAD#</option>
												</cfoutput>
											</select>
										</div>
									</div>
								</div>								
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='1548.Rapor Tipi'></label>
											<div class="col col-12 col-xs-12">
												<select name="report_basis" id="report_basis" onchange="filtre_kontrol(this.value);">
													<option value="1" <cfif isdefined("attributes.report_basis") and attributes.report_basis eq 1>selected</cfif>><cf_get_lang no='1001.Çalışan Bazında'></option>
													<option value="2" <cfif isdefined("attributes.report_basis") and attributes.report_basis eq 2>selected</cfif>><cf_get_lang no='938.Üye Bazında'></option>
												</select>
											</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='344.Durum'></label>
											<div class="col col-12 col-xs-12">
												<select name="report_type" id="report_type" onchange="report_type_control();">
													<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
													<option value="1" <cfif attributes.report_type eq 1>selected</cfif>><cf_get_lang no='674.Katılmış'></option>
													<option value="2" <cfif attributes.report_type eq 2>selected</cfif>><cf_get_lang no='675.Katılmamış'></option>
													<option value="3" <cfif attributes.report_type eq 3>selected</cfif>>Katılacağı Kesinleşen</option>
													<option value="4" <cfif attributes.report_type eq 4>selected</cfif>>Katılması Gerekenler</option>
												</select>
											</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12" id="date_td3" name="date_td3" <cfif attributes.report_basis neq 1>style="display:none;"</cfif>><cf_get_lang no='708.Gruba Giriş'><cf_get_lang_main no='1278.Tarih Aralığı'>*</label>
										<div class="col col-6" id="date_td" name="date_td" <cfif attributes.report_basis neq 1>style="display:none;"</cfif>>
											<div class="input-group">
												<cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no='641.Başlangıç Tarihi'></cfsavecontent>
												<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
													<cfinput type="text" name="startdate" id="startdate" maxlength="10" validate="#validate_style#" message="#message#"  required="yes" value="#dateformat(attributes.startdate,dateformat_style)#">
												<cfelse>
													<cfinput type="text" name="startdate" id="startdate" maxlength="10" validate="#validate_style#" required="yes" message="#message#" >
												</cfif>
												<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
											</div>
										</div>
										<div class="col col-6" id="date_td1" name="date_td1" <cfif attributes.report_basis neq 1>style="display:none;"</cfif>>
											<div class="input-group">
												<cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no='288.Bitiş Tarihi'></cfsavecontent>
												<cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
													<cfinput type="text" name="finishdate" id="finishdate" maxlength="10" required="yes" validate="#validate_style#" message="#message#" value="#dateformat(attributes.finishdate,dateformat_style)#">
												<cfelse>
													<cfinput type="text" name="finishdate" id="finishdate" maxlength="10" required="yes" validate="#validate_style#" message="#message#" >
												</cfif>
												<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
											</div>
										</div>	
									</div>
									<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang_main no='637.Sınıflar'></label>
											<div class="col col-12 col-xs-12">
												<select name="train_group_id" id="train_group_id" >
													<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
													<cfoutput query="training_groups">
														<option value="#train_group_id#"<cfif isdefined("attributes.train_group_id") and attributes.train_group_id eq train_group_id>selected</cfif>>#GROUP_HEAD#</option>
													</cfoutput>
												</select>
											</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12" id="mem_department_td3_" name="mem_department_td3_" <cfif attributes.report_basis neq 2>style="display:none;"</cfif>>
										<cf_get_lang_main no='160.Departman'></label>
										<div class="col col-12 col-xs-12" id="mem_department_td" name="mem_department_td" <cfif attributes.report_basis neq 2>style="display:none;"</cfif>>
												<cf_multiselect_check 
													query_name="get_mem_department"  
													name="mem_department"
													width="140" 
													option_text="#getLang('main',322)#" 
													option_value="partner_department_id"
													option_name="partner_department"
													value="#attributes.mem_department#">
										</div>
									</div>
								</div>
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12" id="comp_td3" name="comp_td3" <cfif attributes.report_basis neq 1>style="display:none;"</cfif>><cf_get_lang_main no='1734.Şirketler'></label>
										<div class="col col-12 col-xs-12" id="comp_td" name="comp_td" <cfif attributes.report_basis neq 1>style="display:none;"</cfif>>
											<div class="multiselect-z2">
												<cf_multiselect_check 
												query_name="get_our_company"  
												name="comp_id"
												width="140" 
												option_value="COMP_ID"
												option_name="company_name"
												option_text="#getLang('main',322)#"
												value="#attributes.comp_id#"
												onchange="get_branch_list(this.value)">
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"  id="func_td3" name="func_td3" <cfif attributes.report_basis neq 1>style="display:none;"</cfif>><cf_get_lang no='671.Fonksiyonlar'></label>
										<div class="col col-12 col-xs-12" id="func_td" name="func_td" <cfif attributes.report_basis neq 1>style="display:none;"</cfif>>
											<select name="func_id" id="func_id">
												<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
												<cfoutput query="get_units">
													<option value="#unit_id#"<cfif isdefined("attributes.func_id") and attributes.func_id eq get_units.unit_id>selected</cfif>>#unit_name#</option>
												</cfoutput>
											</select>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12" id="title_td3" name="title_td3" colspan="2" <cfif attributes.report_basis neq 1>style="display:none;"</cfif>><cf_get_lang no='672.Ünvanlar'></label>
										<div class="col col-12 col-xs-12" id="title_td" name="title_td" colspan="2" <cfif attributes.report_basis neq 1>style="display:none;"</cfif>>
											<select name="title_id" id="title_id">
												<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
												<cfoutput query="titles">
													<option value="#title_id#" <cfif isdefined("attributes.title_id") and attributes.title_id eq title_id>selected</cfif>>#title#</option>
												</cfoutput>
											</select>
										</div>
									</div>
									<div class="form-group">
											<label class="col col-12 col-xs-12" id="inout_td3" name="inout_td3" <cfif attributes.report_basis neq 1>style="display:none;"</cfif>><cf_get_lang dictionary_id='53208.Giriş ve Çıkışlar'></label>
										<div class="col col-12 col-xs-12" id="inout_td" name="inout_td" <cfif attributes.report_basis neq 1>style="display:none;"</cfif>>
											<select name="inout_statue" id="inout_statue" style="width:140px;">
												<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
												<option value="1"<cfif attributes.inout_statue eq 1> selected</cfif>><cf_get_lang_main no='1123.Girişler'></option>
												<option value="0"<cfif attributes.inout_statue eq 0> selected</cfif>><cf_get_lang_main no='1124.Çıkışlar'></option>
												<option value="2"<cfif attributes.inout_statue eq 2> selected</cfif>><cf_get_lang no='362.Aktif Çalışanlar'></option>
											</select>
										</div>
									</div>
								</div>						
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">	
									<div class="form-group">
										<label class="col col-12 col-xs-12"  id="branch_td3" name="branch_td3" <cfif attributes.report_basis neq 1>style="display:none;"</cfif>><cf_get_lang_main no='41.Şube'></label>
										<div class="col col-12 col-xs-12"v  id="branch_td" name="branch_td" <cfif attributes.report_basis neq 1>style="display:none;"</cfif>>
											<div id="BRANCH_PLACE" class="multiselect-z2">
												<cf_multiselect_check 
												query_name="get_branchs"  
												name="branch_id"
												width="140" 
												option_value="BRANCH_ID"
												option_name="BRANCH_NAME"
												option_text="#getLang('main',322)#" 
												value="#attributes.branch_id#">
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12" id="department_td3" name="department_td3" <cfif attributes.report_basis neq 1>style="display:none;"</cfif>><cf_get_lang_main no='160.Departman'></label>
										<div class="col col-12 col-xs-12" id="department_td" name="department_td" <cfif attributes.report_basis neq 1>style="display:none;"</cfif>>
											<div class="multiselect-z2" id="DEPARTMENT_PLACE">
												<cf_multiselect_check 
													query_name="get_department"  
													name="department"
													width="140" 
													option_text="#getLang('main',322)#"  
													option_value="department_id"
													option_name="department_head"
													value="#attributes.department#">
											</div>
										</div>
									</div>
									<div class="form-group">
										<div class="col col-12 col-xs-12" colspan="2" id="allpos_td" name="allpos_td" <cfif attributes.report_basis neq 1>style="display:none;"</cfif>>
											<label>
												<input type="checkbox" name="get_all_pos" id="get_all_pos" value="1" <cfif isdefined('attributes.get_all_pos')>checked</cfif>><cf_get_lang dictionary_id='65019.Ücret ve Pozisyon kartı olmayanlar da gelsin'></td>
											</label>
										</div>
									</div>
								</div>
							</div>	
						</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
							<label><cf_get_lang_main no='446.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>
                                <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3" style="width:25px;">
							<cfelse>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" range="1,999" message="#message#" maxlength="3" style="width:25px;">
							</cfif>
								<cfsavecontent variable="message"><cf_get_lang_main no ='499.Çalıştır'></cfsavecontent>
								<input type="hidden" name="is_submitted" id="is_submitted" value="1">
								<cf_wrk_report_search_button  search_function='control()' insert_info='#message#' button_type='1' is_excel="1">   
						</div>
            		</div>
				</div>
			</div>
</cf_report_list_search_area>
</cf_report_list_search>
</cfform> 
<cfif attributes.is_excel eq 1>
		<cfset filename="training_analyse_report#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
		<cfheader name="Expires" value="#Now()#">
		<cfcontent type="application/vnd.msexcel;charset=utf-16">
		<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
		<meta http-equiv="content-type" content="text/plain; charset=utf-16">
		<cfset attributes.startrow=1>
		<cfset attributes.maxrows=get_emp_tra.recordcount>
		<cfset type_ = 1>
	<cfelse>
		<cfset type_ = 0>
</cfif>
<cfif IsDefined("attributes.is_submitted")>
	<cf_report_list>
		<thead>
			<tr> 
				<th><cf_get_lang_main no='613.TC Kimlik No'></th>
				<th><cf_get_lang_main no='158.Ad Soyad'></th>
				<th><cf_get_lang_main  no='7.Eğitim'></th>
				<cfif attributes.report_type neq 2>
					<th><cf_get_lang no='2045.Yoklama'></th>
					<th><cf_get_lang no='1872.Geldi'></th>
					<th><cf_get_lang no='1874.Gelmedi'></th>
				</cfif>
				<th><cf_get_lang no='1940.Sınıf'></th>
				<th><cf_get_lang_main no='162.Şirket'></th>
				<th><cf_get_lang_main no='41.Şube'></th>
				<th><cf_get_lang_main no='160.Departman'></th>
				<th><cf_get_lang_main no='1085.Pozisyon'></th>
				<cfif attributes.report_basis eq 1>
					<th><cf_get_lang_main no='1289.Fonksiyon'></th>
				</cfif>
				<th><cf_get_lang no='191.Gruba Giriş Tarihi'></th>
				<th><cf_get_lang_main no='352.Cinsiyet'></th>
				<th><cf_get_lang no='677.Yaş'></th>
				<cfif attributes.report_type eq 4><th></th></cfif>
			</tr>
		</thead>
		<cfif get_emp_tra.recordcount>  
			<tbody>
				<cfoutput query="get_emp_tra" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					
					<cfif attributes.report_type neq 2 and len(class_id)>
						<cfquery datasource="#dsn#" name="GET_TRAIN_CLASS_DT">
							SELECT
								TCADT.ATTENDANCE_MAIN,
								TCADT.IS_EXCUSE_MAIN,
								TCADT.EXCUSE_MAIN,
								TCA.START_DATE
							FROM
								TRAINING_CLASS_ATTENDANCE TCA,
								TRAINING_CLASS_ATTENDANCE_DT TCADT
							WHERE
								TCA.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#class_id#">
								<cfif attributes.report_basis eq 1>
									AND TCADT.EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#employee_id#">
								<cfelseif attributes.report_basis eq 2>
									<cfif len(partner_id) and partner_id neq 0>
										AND TCADT.PAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#partner_id#">
									<cfelseif len(consumer_id) and consumer_id neq 0>
										AND TCADT.CON_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#consumer_id#">
									</cfif>
								</cfif>
								AND TCA.CLASS_ATTENDANCE_ID = TCADT.CLASS_ATTENDANCE_ID
								AND TCADT.IS_TRAINER = 0
						</cfquery>
					<cfelse>
						<cfset get_train_class_dt.recordcount = 0>
					</cfif>
					<tr>
						<td>#tc_identy_no#</td>
						<td><cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>#name#&nbsp;#surname#<cfelse><cfif attributes.report_basis eq 1><a href="#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#employee_id#" class="tableyazi">#name#&nbsp;#surname#</a><cfelseif attributes.report_basis eq 2><cfif partner_id neq 0 and len(partner_id)><a href="#request.self#?fuseaction=member.list_contact&event=upd&pid=#partner_id#" class="tableyazi">#name#&nbsp;#surname#</a><cfelseif len(consumer_id) and consumer_id neq 0><a href="#request.self#?fuseaction=member.consumer_list&event=det&cid=#consumer_id#" class="tableyazi">#name#&nbsp;#surname#</a></cfif></cfif></cfif></td>
						<td>#class_name#</td>
						<cfif attributes.report_type neq 2>
						<td>	
							<cfif get_train_class_dt.recordcount and len(class_id)>
								<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
									<cfloop query="GET_TRAIN_CLASS_DT">
										#DateFormat(start_date,dateformat_style)#-<cfif (IsNumeric(ATTENDANCE_MAIN) AND ATTENDANCE_MAIN) or ATTENDANCE_MAIN gte 0>%#ATTENDANCE_MAIN#<cfelseif IS_EXCUSE_MAIN IS 1>#EXCUSE_MAIN#</cfif><br />
									</cfloop>
								<cfelse>
									<cfloop query="get_train_class_dt">
										<p><cfif ATTENDANCE_MAIN eq 0><font color="FF0000">#DateFormat(START_DATE,dateformat_style)#-</font><cfelse>#DateFormat(START_DATE,dateformat_style)#-</cfif><cfif IsNumeric(ATTENDANCE_MAIN) AND ATTENDANCE_MAIN>%#ATTENDANCE_MAIN#<cfelseif ATTENDANCE_MAIN gte 0><font color="FF0000">%#ATTENDANCE_MAIN#</font><cfelseif IS_EXCUSE_MAIN IS 1>#EXCUSE_MAIN#</cfif></p>
									</cfloop>
								</cfif>
							</cfif>
						</td>
						<td>
							<cfif len(class_id)>
								<cfquery datasource="#dsn#" name="get_train_att_join">
									SELECT 
										COUNT (TCAD.ATTENDANCE_MAIN) AS geldi
									FROM
										TRAINING_CLASS_ATTENDANCE_DT TCAD,
										TRAINING_CLASS_ATTENDANCE TCA
									WHERE
										TCA.CLASS_ATTENDANCE_ID = TCAD.CLASS_ATTENDANCE_ID
										AND TCA.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#class_id#">
										<cfif attributes.report_basis eq 1>
											AND TCAD.EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#employee_id#">
										<cfelseif attributes.report_basis eq 2>
											<cfif len(partner_id) and partner_id neq 0>
												AND TCAD.PAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#partner_id#">
											<cfelseif len(consumer_id) and consumer_id neq 0>
												AND TCAD.CON_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#consumer_id#">
											</cfif>
										</cfif>
										AND TCAD.ATTENDANCE_MAIN > 0
										AND TCAD.IS_TRAINER = 0
								</cfquery>
								#get_train_att_join.geldi#
							</cfif>
						</td>
						<td>
							<cfif len(class_id)>
								<cfquery datasource="#dsn#" name="get_train_att_ntjoin">
									SELECT 
										COUNT (TCAD.ATTENDANCE_MAIN) AS gelmedi
									FROM
										TRAINING_CLASS_ATTENDANCE_DT TCAD,
										TRAINING_CLASS_ATTENDANCE TCA
									WHERE
										TCA.CLASS_ATTENDANCE_ID = TCAD.CLASS_ATTENDANCE_ID
										AND TCA.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#class_id#">
										<cfif attributes.report_basis eq 1>
											AND TCAD.EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#employee_id#">
										<cfelseif attributes.report_basis eq 2>
											<cfif len(partner_id) and partner_id neq 0>
												AND TCAD.PAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#partner_id#">
											<cfelseif len(consumer_id) and consumer_id neq 0>
												AND TCAD.CON_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#consumer_id#">
											</cfif>
										</cfif>
										AND TCAD.ATTENDANCE_MAIN = 0
										AND TCAD.IS_TRAINER = 0
								</cfquery>
								#get_train_att_ntjoin.gelmedi#
							</cfif>
						</td>
						</cfif>
						<td>#group_head#</td>
						<td>#nick_name#</td>
						<td>#branch_name#</td>
						<td>#department_head#</td>
						<td>#position_name#</td>
						<cfif attributes.report_basis eq 1>
							<td>#unit_name#</td>
						</cfif>
						<td>#dateformat(group_startdate,dateformat_style)#</td>
						<td><cfif sex is 0><cf_get_lang no='200.Bayan'><cfelse><cf_get_lang_main no='1547.Erkek'></cfif></td>
						<td><cfif len(birth_date)>#datediff("yyyy",get_emp_tra.birth_date,now())#</cfif></td>
						<cfif attributes.report_type eq 4><cf_wrk_html_td><cfif katilim eq 1><img src="../../images/green_glob.gif" title="Katıldı"><cfelseif katilim eq 0><img src="../../images/red_glob.gif" title="Katılmadı"><cfelseif katilim eq 2><img src="../../images/blue_glob.gif" title="Kesinleşen"></cfif></cf_wrk_html_td></cfif>
					</tr>
				</cfoutput>
			</tbody>
		<cfelse>
			<tbody>
				<tr>
					<td colspan="16"><cfif isdefined("attributes.is_submitted")><cf_get_lang_main no='72.Kayıt yok'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz '>!</cfif></td>
				</tr>
			</tbody>
		</cfif>
		<tfoot>
		</tfoot>       
	</cf_report_list>
	<cfif isdefined("attributes.is_submitted") and attributes.totalrecords gt attributes.maxrows>
		<cfset url_str = "">
		<cfset url_str = "#url_str#&keyword=#attributes.keyword#&is_submitted=#attributes.is_submitted#&report_type=#attributes.report_type#">
		<cfif isdefined('attributes.train_id') and len(attributes.train_id)>
			<cfset url_str = "#url_str#&train_id=#attributes.train_id#">
		</cfif>
		<cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
			<cfset url_str = "#url_str#&comp_id=#attributes.comp_id#">
		</cfif>
		<cfif isdefined("attributes.func_id") and len(attributes.func_id)>
			<cfset url_str = "#url_str#&func_id=#attributes.func_id#">
		</cfif>
		<cfif isdefined('attributes.title_id') and len(attributes.title_id)>
			<cfset url_str = "#url_str#&title_id=#attributes.title_id#">
		</cfif>
		<cfif isdefined('attributes.class_id') and len(attributes.class_id) and len(attributes.class_name)>
			<cfset url_str = "#url_str#&class_id=#attributes.class_id#&class_name=#attributes.class_name#">
		</cfif>
		<cfif isdefined('attributes.date') and len(attributes.date)>
			<cfset url_str = "#url_str#&date=##dateformat(attributes.date,dateformat_style)##">
		</cfif>
		<cfif isdefined('attributes.inout_statue') and len(attributes.inout_statue)>
			<cfset url_str = "#url_str#&inout_statue=#attributes.inout_statue#">
		</cfif>
		<cfif len(attributes.startdate) and isdate(attributes.startdate)>
			<cfset url_str = "#url_str#&startdate=#dateformat(attributes.startdate,dateformat_style)#">
		</cfif>
		<cfif len(attributes.finishdate) and isdate(attributes.finishdate)>
			<cfset url_str = "#url_str#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#">
		</cfif>
		<cfif len(attributes.tr_startdate) and isdate(attributes.tr_startdate)>
			<cfset url_str = "#url_str#&tr_startdate=#dateformat(attributes.tr_startdate,dateformat_style)#">
		</cfif>
		<cfif len(attributes.tr_finishdate) and isdate(attributes.tr_finishdate)>
			<cfset url_str = "#url_str#&tr_finishdate=#dateformat(attributes.tr_finishdate,dateformat_style)#">
		</cfif>
		<cfif isdefined('attributes.get_all_pos')>
			<cfset url_str = "#url_str#&get_all_pos=1">
		</cfif>
		<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
			<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
		</cfif>
		<cfif isdefined('attributes.department') and len(attributes.department)>
			<cfset url_str = "#url_str#&department=#attributes.department#">
		</cfif>
		<cfif isdefined('attributes.train_group_id') and len(attributes.train_group_id)>
			<cfset url_str = "#url_str#&train_group_id=#attributes.train_group_id#">
		</cfif>
		<cfif isdefined('attributes.report_basis') and len(attributes.report_basis)>
			<cfset url_str = "#url_str#&report_basis=#attributes.report_basis#">
		</cfif>
		<!-- sil --><cf_paging page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#attributes.fuseaction#&#url_str#"><!-- sil -->
	</cfif>
</cfif>
</cfprocessingdirective>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function get_branch_list(gelen)
	{
		checkedValues_b = $("#comp_id").multiselect("getChecked");
		var comp_id_list='';
		for(kk=0;kk<checkedValues_b.length; kk++)
		{
			if(comp_id_list == '')
				comp_id_list = checkedValues_b[kk].value;
			else
				comp_id_list = comp_id_list + ',' + checkedValues_b[kk].value;
		}
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=branch_id&comp_id="+comp_id_list;
		AjaxPageLoad(send_address,'BRANCH_PLACE',1,'İlişkili Şubeler');
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=department&branch_id=0";
		AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
	}
	function get_department_list(gelen)
	{
		checkedValues_b = $("#branch_id").multiselect("getChecked");
		var branch_id_list='';
		for(kk=0;kk<checkedValues_b.length; kk++)
		{
			if(branch_id_list == '')
				branch_id_list = checkedValues_b[kk].value;
			else
				branch_id_list = branch_id_list + ',' + checkedValues_b[kk].value;
		}
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=department&branch_id="+branch_id_list;
		AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
	}
	function filtre_kontrol(i)
	{
		if (i == 1)
		{
			document.getElementById('comp_td').style.display = '';
			document.getElementById('comp_td3').style.display = '';
			document.getElementById('branch_td').style.display = '';
			document.getElementById('branch_td3').style.display = '';
			document.getElementById('department_td').style.display = '';
			document.getElementById('department_td3').style.display = '';
			document.getElementById('mem_department_td').style.display = 'none';
			document.getElementById('mem_department_td3_').style.display = 'none';
			document.getElementById('func_td').style.display = '';
			document.getElementById('func_td3').style.display = '';
			document.getElementById('title_td').style.display = '';
			document.getElementById('title_td3').style.display = '';
			document.getElementById('date_td').style.display = '';
			document.getElementById('date_td1').style.display = '';
			document.getElementById('date_td3').style.display = '';
			document.getElementById('inout_td').style.display = '';
			document.getElementById('inout_td3').style.display = '';
			document.getElementById('allpos_td').style.display = '';
		}
		else if (i == 2)
		{
			document.getElementById('comp_td').style.display = 'none';
			document.getElementById('comp_td3').style.display = 'none';
			document.getElementById('branch_td').style.display = 'none';
			document.getElementById('branch_td3').style.display = 'none';
			document.getElementById('department_td').style.display = 'none';
			document.getElementById('department_td3').style.display = 'none';
			document.getElementById('mem_department_td').style.display = '';
			document.getElementById('mem_department_td3_').style.display = '';
			document.getElementById('func_td').style.display = 'none';
			document.getElementById('func_td3').style.display = 'none';
			document.getElementById('title_td').style.display = 'none';
			document.getElementById('title_td3').style.display = 'none';
			document.getElementById('date_td').style.display = 'none';
			document.getElementById('date_td1').style.display = 'none';
			document.getElementById('date_td3').style.display = 'none';
			document.getElementById('inout_td').style.display = 'none';
			document.getElementById('inout_td3').style.display = 'none';
			document.getElementById('allpos_td').style.display = 'none';
		}
	}
	function report_type_control()
	{
		if ($('#report_type').val() == 4){
			$('#tra_date_td').css('display','none');
			$('#tra_date_td1').css('display','none');
			$('#tra_date_td_label').css('display','none');
		}
		else{
			$('#tra_date_td').css('display','');
			$('#tra_date_td1').css('display','');
			$('#tra_date_td_label').css('display','');
		}
	}
	function control(){
		if(datediff(document.getElementById('tr_startdate').value,document.getElementById('tr_finishdate').value) < 0)
        {
            alert("<cf_get_lang no ='1746.Başlangıç Tarihi Bitiş Tarihinden Büyük Olmamalıdır'>");
            return false;
        }
        if ((document.form.startdate.value != '') && (document.form.finishdate.value != '') &&
        !date_check(form.startdate,form.finishdate,"<cf_get_lang no ='1093.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
             return false;
		
		if(document.form.is_excel.checked==false)
			{
				document.form.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.training_analyse_report"
				return true;
			}
			else{
				document.form.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_training_analyse_report</cfoutput>"}
		
	}
</script>

