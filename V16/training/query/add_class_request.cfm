<cfquery name="get_kontrol" datasource="#dsn#">
	SELECT 
		TRAIN_REQUEST_ID 
	FROM 
		TRAINING_REQUEST 
	WHERE 
		EMPLOYEE_ID = #session.ep.userid# AND
		REQUEST_YEAR = #attributes.request_year#
</cfquery>
<cfif get_kontrol.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='205.Eğitim Talep Edilen Döneme Ait Bir Talep Formunuz Var'>!");
		history.go(-1);
	</script>
	<cfabort>
</cfif> 
<cfquery name="GET_AMIR_ALL" datasource="#dsn#">
	SELECT POSITION_CODE, EMPLOYEE_ID, UPPER_POSITION_CODE, IS_MASTER FROM EMPLOYEE_POSITIONS
</cfquery>
<cfquery name="GET_EMP" dbtype="query">
	SELECT 
		POSITION_CODE,
		EMPLOYEE_ID,
		UPPER_POSITION_CODE
	FROM
		GET_AMIR_ALL
	WHERE
		IS_MASTER=1 AND 
		EMPLOYEE_ID=#session.ep.userid#
</cfquery>
<cfif not len(GET_EMP.UPPER_POSITION_CODE)>
	<script  type="text/javascript">
		{
			alert("Amir tanımlı değil.Kontrol Ediniz!");
			history.go(-1);
		}
	</script>
</cfif>
<cfset amir_list="">
<cfset amir_pos_list="">
<cfloop from="1" to="6" index="i">
	<cfif not len(GET_EMP.UPPER_POSITION_CODE) or GET_EMP.UPPER_POSITION_CODE eq 0>
		<cfbreak>
	</cfif>
	<cfquery name="GET_EMP" dbtype="query">
		SELECT 
			POSITION_CODE,
			EMPLOYEE_ID,
			UPPER_POSITION_CODE
		FROM
			GET_AMIR_ALL
		WHERE
			POSITION_CODE=#GET_EMP.UPPER_POSITION_CODE#
	</cfquery>
	<cfif len(GET_EMP.EMPLOYEE_ID) and GET_EMP.EMPLOYEE_ID gt 0>
		<cfset amir_list=listappend(amir_list,GET_EMP.EMPLOYEE_ID,',')>
		<cfif len(get_emp.POSITION_CODE)>
			<cfset amir_pos_list=listappend(amir_pos_list,get_emp.POSITION_CODE,',')>
		<cfelse>
			<cfset amir_pos_list=listappend(amir_pos_list,0,',')>
		</cfif>
	</cfif>
</cfloop>
<cflock name="#CREATEUUID()#" timeout="30">
	<cftransaction>
		<cfquery name="ADD_TRAINING_REQUESTS" datasource="#dsn#" result="MAX_ID">
			INSERT INTO
				TRAINING_REQUEST
				(
					EMPLOYEE_ID,
					POSITION_CODE,
					REQUEST_YEAR,
					FIRST_BOSS_ID,
					FIRST_BOSS_CODE,
					SECOND_BOSS_ID,
					SECOND_BOSS_CODE,
					THIRD_BOSS_ID,
					THIRD_BOSS_CODE,
					FOURTH_BOSS_ID,
					FOURTH_BOSS_CODE,
					FIFTH_BOSS_ID,
					FIFTH_BOSS_CODE,
					FORM_VALID,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
				)
			VALUES
				(
					#session.ep.userid#,
					#session.ep.position_code#,
					#attributes.request_year#,
					<cfif listlen(amir_list,',') gte 1>#ListGetAt(amir_list,1,',')#<cfelse>NULL</cfif>,
					<cfif listlen(amir_pos_list,',') gte 1 and listgetat(amir_pos_list,1,',') gt 0>#listgetat(amir_pos_list,1,',')#<cfelse>NULL</cfif>,
					<cfif listlen(amir_list,',') gte 2>#ListGetAt(amir_list,2,',')#<cfelse>NULL</cfif>,
					<cfif listlen(amir_pos_list,',') gte 2 and listgetat(amir_pos_list,2,',') gt 0>#listgetat(amir_pos_list,2,',')#<cfelse>NULL</cfif>,
					<cfif listlen(amir_list,',') gte 3>#ListGetAt(amir_list,3,',')#<cfelse>NULL</cfif>,
					<cfif listlen(amir_pos_list,',') gte 3 and listgetat(amir_pos_list,3,',') gt 0>#listgetat(amir_pos_list,3,',')#<cfelse>NULL</cfif>,
					<cfif listlen(amir_list,',') gte 4>#ListGetAt(amir_list,4,',')#<cfelse>NULL</cfif>,
					<cfif listlen(amir_pos_list,',') gte 4 and listgetat(amir_pos_list,4,',') gt 0>#listgetat(amir_pos_list,4,',')#<cfelse>NULL</cfif>,
					<cfif listlen(amir_list,',') gte 5>#ListGetAt(amir_list,5,',')#<cfelse>NULL</cfif>,
					<cfif listlen(amir_pos_list,',') gte 5 and listgetat(amir_pos_list,5,',') gt 0>#listgetat(amir_pos_list,5,',')#<cfelse>NULL</cfif>,
					0,
					#now()#,
					#session.ep.userid#,
					'#REMOTE_ADDR#'
				)
		</cfquery>
		<cfloop from="1" to="#attributes.record_num_pos_req#" index="i">
			<cfif isdefined("attributes.row_kontrol_pos_req#i#") and evaluate("attributes.row_kontrol_pos_req#i#") eq 1 and len(evaluate("attributes.class_name_pos_req#i#"))>
				<cfquery name="ADD_TRAINING_ROW_POS_REQ" datasource="#dsn#">
					INSERT INTO
						TRAINING_REQUEST_ROWS
						(
							EMPLOYEE_ID,
							TRAIN_REQUEST_ID,
							IS_CHIEF_VALID,
							IS_VALID,
							REQUEST_STATUS,
							TRAINING_ID,
							TRAINING_PRIORITY,
							WORK_TARGET_ADDITION,
							RECORD_DATE,
							RECORD_EMP,
							RECORD_IP
						)
					VALUES
						(
							#session.ep.userid#,						
							#MAX_ID.IDENTITYCOL#,
							0,
							0,
							1,
							<cfif len(evaluate('attributes.class_id_pos_req#i#'))>#evaluate('attributes.class_id_pos_req#i#')#<cfelse>NULL</cfif>,
							'#wrk_eval('attributes.priority_pos_req#i#')#',
							'#wrk_eval('attributes.work_addition_pos_req#i#')#',
							#now()#,
							#session.ep.userid#,
							'#REMOTE_ADDR#'
						)
				</cfquery>
				<!--- EĞİTİM TALEBİ İÇİN AMİRE MAİL --->
				<cfquery name="get_upper_position" datasource="#dsn#">
					SELECT
						POSITION_ID,
						UPPER_POSITION_CODE,
						EMPLOYEE_ID,
						EMPLOYEE_NAME,
						EMPLOYEE_SURNAME
					FROM
						EMPLOYEE_POSITIONS
					WHERE
						POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
				</cfquery>
				<cfif len(get_upper_position.UPPER_POSITION_CODE)>
				<cfquery name="get_emps_detail" datasource="#dsn#">
					SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE =  <cfqueryparam cfsqltype="cf_sql_integer" value="#get_upper_position.UPPER_POSITION_CODE#">
				</cfquery>
				<cfif get_emps_detail.recordcount and len(get_emps_detail.EMPLOYEE_ID)>
					<cfquery name="emps" datasource="#DSN#">
						SELECT EMPLOYEE_EMAIL,EMPLOYEE_SURNAME,EMPLOYEE_ID,EMPLOYEE_NAME
						FROM EMPLOYEES
						WHERE EMPLOYEE_ID = #get_emps_detail.EMPLOYEE_ID#
					</cfquery>
					<cfset subject = 'Eğitim Talebi'>
					<cfif emps.recordcount and len(emps.EMPLOYEE_EMAIL)>
						<cfmail
							to="#emps.EMPLOYEE_EMAIL#"
							from="#session.ep.company#<#session.ep.company_email#>"
							subject="#subject#"type="HTML">
							Sayın #emps.EMPLOYEE_NAME# #emps.EMPLOYEE_SURNAME#,
							<br/><br/>#get_upper_position.employee_name# #get_upper_position.employee_surname# #evaluate("attributes.class_name_pos_req#i#")# konulu eğitime katılım talebinde bulunmuştur.
						</cfmail>
					</cfif>
				</cfif>
				</cfif>
				<!--- EĞİTİM TALEBİ İÇİN AMİRE MAİL --->
			</cfif>
		</cfloop>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=training.form_upd_class_request&train_req_id=#MAX_ID.IDENTITYCOL#" addtoken="no">
