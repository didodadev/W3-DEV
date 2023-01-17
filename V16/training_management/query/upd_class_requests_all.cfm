<!--- listeden onaylandiginde once onay verenin kaccinci amir oldugunu bilmek gerekiyor ki daha once onay veren ne onay verdi ise aynen o onayi alsın--->
<cfif isdefined("attributes.valid_req_id") and len(attributes.valid_req_id)>
	<cfquery name="get_emp_pos" datasource="#dsn#">
		SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID=#session.ep.userid#
	</cfquery>
	<cfset position_list=valuelist(get_emp_pos.POSITION_CODE,',')>
	<cflock name="#CREATEUUID()#" timeout="30">
		<cftransaction>
			<cfquery name="upd_class_req_all" datasource="#dsn#">
				SELECT 
					*
				FROM
					TRAINING_REQUEST
				WHERE
					TRAIN_REQUEST_ID IN (#attributes.valid_req_id#)
			</cfquery>
			<cfquery name="upd_class_req" dbtype="query">
				SELECT 
					TRAIN_REQUEST_ID
				FROM
					upd_class_req_all 
				WHERE
					FIRST_BOSS_CODE IN (#position_list#)
					AND TRAIN_REQUEST_ID IN (#attributes.valid_req_id#)
			</cfquery>
			<cfif upd_class_req.recordcount>
				<cfset first_boss_form_id=valuelist(upd_class_req.TRAIN_REQUEST_ID,',')>
				<cfquery name="upd_class_req_row" datasource="#dsn#">
					UPDATE 
						TRAINING_REQUEST_ROWS
					SET
						FIRST_BOSS_VALID_ROW=1,
						FIRST_BOSS_DATE_ROW=#now()#,
						FIRST_BOSS_DETAIL_ROW=NULL,
						IS_CHIEF_VALID = 1,
						CHIEF_VALID_DATE = #NOW()#,
						UPDATE_DATE = #now()#,
						UPDATE_IP = '#CGI.REMOTE_ADDR#',
						UPDATE_EMP = #session.ep.userid#
					WHERE
						TRAIN_REQUEST_ID IN (#first_boss_form_id#)
				</cfquery>
				<cfquery name="upd_class_req" datasource="#dsn#">
					UPDATE 
						TRAINING_REQUEST
					SET
						FIRST_BOSS_VALID=1,
						FIRST_BOSS_VALID_DATE=#now()#,
						FIRST_BOSS_ID=#session.ep.userid#,
						UPDATE_DATE = #now()#,
						UPDATE_IP = '#CGI.REMOTE_ADDR#',
						UPDATE_EMP = #session.ep.userid#
					WHERE
						TRAIN_REQUEST_ID IN (#first_boss_form_id#)
				</cfquery>
				<cfquery name="upd_class_req_last_boss" datasource="#dsn#">
					UPDATE 
						TRAINING_REQUEST
					SET
						FORM_VALID=1
					WHERE
						TRAIN_REQUEST_ID IN (#first_boss_form_id#)
						AND SECOND_BOSS_CODE IS NULL
				</cfquery>
			</cfif>
			<cfquery name="upd_class_req_2" dbtype="query">
				SELECT 
					TRAIN_REQUEST_ID
				FROM
					upd_class_req_all 
				WHERE
					SECOND_BOSS_CODE IN (#position_list#)
					AND TRAIN_REQUEST_ID IN (#attributes.valid_req_id#)
			</cfquery>
			<cfif upd_class_req_2.recordcount>
				<cfset second_boss_form_id=valuelist(upd_class_req_2.TRAIN_REQUEST_ID,',')>
				<cfquery name="upd_class_req_row_2" datasource="#dsn#">
					UPDATE 
						TRAINING_REQUEST_ROWS
					SET
						SECOND_BOSS_VALID_ROW=FIRST_BOSS_VALID_ROW,
						SECOND_BOSS_DATE_ROW=#now()#,
						SECOND_BOSS_DETAIL_ROW=NULL,
						IS_CHIEF_VALID = 1,
						CHIEF_VALID_DATE = #NOW()#,
						UPDATE_DATE = #now()#,
						UPDATE_IP = '#CGI.REMOTE_ADDR#',
						UPDATE_EMP = #session.ep.userid#
					WHERE
						TRAIN_REQUEST_ID IN (#second_boss_form_id#)
				</cfquery>
				<cfquery name="upd_class_req_2" datasource="#dsn#">
					UPDATE 
						TRAINING_REQUEST
					SET
						SECOND_BOSS_VALID=1,
						SECOND_BOSS_VALID_DATE=#now()#,
						SECOND_BOSS_ID=#session.ep.userid#,
						UPDATE_DATE = #now()#,
						UPDATE_IP = '#CGI.REMOTE_ADDR#',
						UPDATE_EMP = #session.ep.userid#
					WHERE
						TRAIN_REQUEST_ID IN (#second_boss_form_id#)
				</cfquery>
				<cfquery name="upd_class_req_last_boss" datasource="#dsn#">
					UPDATE 
						TRAINING_REQUEST
					SET
						FORM_VALID=1
					WHERE
						TRAIN_REQUEST_ID IN (#second_boss_form_id#)
						AND THIRD_BOSS_CODE IS NULL
				</cfquery>
			</cfif>
			<cfquery name="upd_class_req_3" dbtype="query">
				SELECT 
					TRAIN_REQUEST_ID
				FROM
					upd_class_req_all 
				WHERE
					THIRD_BOSS_CODE IN (#position_list#)
					AND TRAIN_REQUEST_ID IN (#attributes.valid_req_id#)
			</cfquery>
			<cfif upd_class_req_3.recordcount>
				<cfset third_boss_form_id=valuelist(upd_class_req_3.TRAIN_REQUEST_ID,',')>
				<cfquery name="upd_class_req_row_3" datasource="#dsn#">
					UPDATE 
						TRAINING_REQUEST_ROWS
					SET
						THIRD_BOSS_VALID_ROW=SECOND_BOSS_VALID_ROW,
						THIRD_BOSS_DATE_ROW=#now()#,
						THIRD_BOSS_DETAIL_ROW=NULL,
						IS_CHIEF_VALID = 1,
						CHIEF_VALID_DATE = #NOW()#,
						UPDATE_DATE = #now()#,
						UPDATE_IP = '#CGI.REMOTE_ADDR#',
						UPDATE_EMP = #session.ep.userid#
					WHERE
						TRAIN_REQUEST_ID IN (#third_boss_form_id#)
				</cfquery>
				<cfquery name="upd_class_req_3" datasource="#dsn#">
					UPDATE 
						TRAINING_REQUEST
					SET
						THIRD_BOSS_VALID=1,
						THIRD_BOSS_VALID_DATE=#now()#,
						THIRD_BOSS_ID=#session.ep.userid#,
						UPDATE_DATE = #now()#,
						UPDATE_IP = '#CGI.REMOTE_ADDR#',
						UPDATE_EMP = #session.ep.userid#
					WHERE
						TRAIN_REQUEST_ID IN (#third_boss_form_id#)
				</cfquery>
				<cfquery name="upd_class_req_last_boss" datasource="#dsn#">
					UPDATE 
						TRAINING_REQUEST
					SET
						FORM_VALID=1
					WHERE
						TRAIN_REQUEST_ID IN (#third_boss_form_id#)
						AND FOURTH_BOSS_CODE IS NULL
				</cfquery>
			</cfif>
			<cfquery name="upd_class_req_4" dbtype="query">
				SELECT 
					TRAIN_REQUEST_ID
				FROM
					upd_class_req_all 
				WHERE
					FOURTH_BOSS_CODE IN (#position_list#)
					AND TRAIN_REQUEST_ID IN (#attributes.valid_req_id#)
			</cfquery>
			<cfif upd_class_req_4.recordcount>
				<cfset fourth_boss_form_id=valuelist(upd_class_req_4.TRAIN_REQUEST_ID,',')>
				<cfquery name="upd_class_req_row_4" datasource="#dsn#">
					UPDATE 
						TRAINING_REQUEST_ROWS
					SET
						FOURTH_BOSS_VALID_ROW=THIRD_BOSS_VALID_ROW,
						FOURTH_BOSS_DATE_ROW=#now()#,
						FOURTH_BOSS_DETAIL_ROW=NULL,
						IS_CHIEF_VALID = 1,
						CHIEF_VALID_DATE = #NOW()#,
						UPDATE_DATE = #now()#,
						UPDATE_IP = '#CGI.REMOTE_ADDR#',
						UPDATE_EMP = #session.ep.userid#
					WHERE
						TRAIN_REQUEST_ID IN (#fourth_boss_form_id#)
				</cfquery>
				<cfquery name="upd_class_req_4" datasource="#dsn#">
					UPDATE 
						TRAINING_REQUEST
					SET
						FOURTH_BOSS_VALID=1,
						FOURTH_BOSS_VALID_DATE=#now()#,
						FOURTH_BOSS_ID=#session.ep.userid#,
						UPDATE_DATE = #now()#,
						UPDATE_IP = '#CGI.REMOTE_ADDR#',
						UPDATE_EMP = #session.ep.userid#
					WHERE
						TRAIN_REQUEST_ID IN (#fourth_boss_form_id#)
				</cfquery>
				<cfquery name="upd_class_req_last_boss" datasource="#dsn#">
					UPDATE 
						TRAINING_REQUEST
					SET
						FORM_VALID=1
					WHERE
						TRAIN_REQUEST_ID IN (#fourth_boss_form_id#)
						AND FIFTH_BOSS_CODE IS NULL
				</cfquery>
			</cfif>
			<cfquery name="upd_class_req_5" dbtype="query">
				SELECT 
					TRAIN_REQUEST_ID
				FROM
					upd_class_req_all 
				WHERE
					FIFTH_BOSS_CODE IN (#position_list#)
					AND TRAIN_REQUEST_ID IN (#attributes.valid_req_id#)
			</cfquery>
			<cfif upd_class_req_5.recordcount>
				<cfset fifth_boss_form_id=valuelist(upd_class_req_5.TRAIN_REQUEST_ID,',')>
				<cfquery name="upd_class_req_row_5" datasource="#dsn#">
					UPDATE
						TRAINING_REQUEST_ROWS
					SET
						FIFTH_BOSS_VALID_ROW=FOURTH_BOSS_VALID_ROW,
						FIFTH_BOSS_DATE_ROW=#now()#,
						FIFTH_BOSS_DETAIL_ROW=NULL,
						IS_CHIEF_VALID = 1,
						CHIEF_VALID_DATE = #NOW()#,
						UPDATE_DATE = #now()#,
						UPDATE_IP = '#CGI.REMOTE_ADDR#',
						UPDATE_EMP = #session.ep.userid#
					WHERE
						TRAIN_REQUEST_ID IN (#fifth_boss_form_id#)
				</cfquery>
				<cfquery name="upd_class_req_5" datasource="#dsn#">
					UPDATE 
						TRAINING_REQUEST
					SET
						FIFTH_BOSS_VALID=1,
						FIFTH_BOSS_VALID_DATE=#now()#,
						FIFTH_BOSS_ID=#session.ep.userid#,
						UPDATE_DATE = #now()#,
						UPDATE_IP = '#CGI.REMOTE_ADDR#',
						UPDATE_EMP = #session.ep.userid#
					WHERE
						TRAIN_REQUEST_ID IN (#fifth_boss_form_id#)
				</cfquery>
				<cfquery name="upd_class_req_last_boss" datasource="#dsn#">
					UPDATE 
						TRAINING_REQUEST
					SET
						FORM_VALID=1
					WHERE
						TRAIN_REQUEST_ID IN (#fifth_boss_form_id#)
				</cfquery>
			</cfif>
		</cftransaction>
	</cflock>
<cfelseif isdefined("attributes.valid_req_row_id") and len(attributes.valid_req_row_id)>
	<cfloop list="#attributes.valid_req_row_id#" index="employee" delimiters=",">
		<cfquery name="GET_CLASS_POTENTIAL_ATTENDER" datasource="#dsn#">
			SELECT
				EMP_ID
			FROM
				TRAINING_CLASS_ATTENDER
			WHERE
				CLASS_ID=#listgetat(employee,3,'-')#
				AND EMP_ID=#listgetat(employee,1,'-')#
		</cfquery>
		<cfif not GET_CLASS_POTENTIAL_ATTENDER.RECORDCOUNT>
			<cfquery name="ADD_CLASS_POTENTIAL_ATTENDERS" datasource="#dsn#">
				INSERT INTO
					TRAINING_CLASS_ATTENDER
					(
					CLASS_ID,
					EMP_ID		
					)
				VALUES
					(
					#listgetat(employee,3,'-')#,
					#listgetat(employee,1,'-')#
					)
			</cfquery>
		</cfif>
		<cfquery name="upd_class_req_row" datasource="#dsn#">
			UPDATE 
				TRAINING_REQUEST_ROWS
			SET
				IS_CHIEF_VALID = 1,
				IS_VALID = 1,
				VALID_EMP=#listgetat(employee,1,'-')#,
				VALID_DATE=#NOW()#,
				CHIEF_VALID_DATE = #NOW()#,
				UPDATE_DATE = #now()#,
				UPDATE_IP = '#CGI.REMOTE_ADDR#',
				UPDATE_EMP = #session.ep.userid#
			WHERE
				REQUEST_ROW_ID = #listgetat(employee,2,'-')#
		</cfquery>
	</cfloop>
</cfif>
<cflocation url="#request.self#?fuseaction=training_management.list_class_requests" addtoken="no">
