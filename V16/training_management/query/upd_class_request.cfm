<!--- amir son amir ise form onayı bir set edilecek o nedenden son amirmi diye kontrol ediliyor--->
<cfquery name="get_last_amir" datasource="#dsn#">
	SELECT 
		<cfif attributes.amir eq 1>
			FIRST_BOSS_ID SON_AMIR
		<cfelseif attributes.amir eq 2>
			SECOND_BOSS_ID SON_AMIR		
		<cfelseif attributes.amir eq 3>
			THIRD_BOSS_ID SON_AMIR		
		<cfelseif attributes.amir eq 4>
			FOURTH_BOSS_ID SON_AMIR
		<cfelseif attributes.amir eq 5>
			FIFTH_BOSS_ID SON_AMIR
		</cfif>
	FROM 
		TRAINING_REQUEST
	WHERE 
		TRAIN_REQUEST_ID=#attributes.train_req_id#
		<cfif attributes.amir eq 1>
			AND SECOND_BOSS_ID IS NULL
		<cfelseif attributes.amir eq 2>
			AND THIRD_BOSS_ID IS NULL
		<cfelseif attributes.amir eq 3>
			AND FOURTH_BOSS_ID IS NULL
		<cfelseif attributes.amir eq 4>
			AND FIFTH_BOSS_ID IS NULL
		</cfif>
</cfquery>

<cflock name="#CREATEUUID()#" timeout="30">
	<cftransaction>
		<cfquery name="ADD_TRAINING_REQUESTS" datasource="#dsn#">
			UPDATE 
				TRAINING_REQUEST
			SET
				<cfif attributes.amir eq 1>
					FIRST_BOSS_ID=#session.ep.userid#,
					FIRST_BOSS_VALID=1,
					FIRST_BOSS_VALID_DATE=#now()#,
				<cfelseif attributes.amir eq 2>
					SECOND_BOSS_ID=#session.ep.userid#,
					SECOND_BOSS_VALID=1,
					SECOND_BOSS_VALID_DATE=#now()#,
				<cfelseif attributes.amir eq 3>
					THIRD_BOSS_ID=#session.ep.userid#,
					THIRD_BOSS_VALID=1,
					THIRD_BOSS_VALID_DATE=#now()#,
				<cfelseif attributes.amir eq 4>
					FOURTH_BOSS_ID=#session.ep.userid#,
					FOURTH_BOSS_VALID=1,
					FOURTH_BOSS_VALID_DATE=#now()#,
				<cfelseif attributes.amir eq 5>
					FIFTH_BOSS_ID=#session.ep.userid#,
					FIFTH_BOSS_VALID=1,
					FIFTH_BOSS_VALID_DATE=#now()#,
				</cfif>
				<cfif get_last_amir.recordcount or attributes.amir eq 5>
					FORM_VALID=1,
				</cfif>
				UPDATE_DATE=#now()#,
				UPDATE_EMP=#session.ep.userid#,
				UPDATE_IP='#REMOTE_ADDR#'
			WHERE 
				TRAIN_REQUEST_ID=#attributes.train_req_id#
		</cfquery>
		
		<cfloop from="1" to="#attributes.record_num_pos_req#" index="i">
			<cfif isdefined("attributes.row_kontrol_pos_req#i#") and evaluate("attributes.row_kontrol_pos_req#i#") eq 1 and len(evaluate("attributes.class_name_pos_req#i#"))>
			  <cfif isdefined("attributes.train_req_row_id_pos_req#i#") and len(evaluate("attributes.train_req_row_id_pos_req#i#"))>
			  	<cfquery name="UPD_TRAINING_ROW_POS_REQ" datasource="#dsn#">
					UPDATE 
						TRAINING_REQUEST_ROWS
					SET
						TRAINING_PRIORITY='#wrk_eval('attributes.priority_pos_req#i#')#',
						WORK_TARGET_ADDITION='#wrk_eval('attributes.work_addition_pos_req#i#')#',
						<cfif attributes.amir eq 1>
							FIRST_BOSS_VALID_ROW=<cfif isdefined("attributes.first_boss_pos_req#i#")>1<cfelse>0</cfif>,
							FIRST_BOSS_DATE_ROW=#now()#,
							FIRST_BOSS_DETAIL_ROW=<cfif isdefined("attributes.first_boss_detail_pos_req#i#") and len(evaluate('attributes.first_boss_detail_pos_req#i#'))>'#wrk_eval('attributes.first_boss_detail_pos_req#i#')#'<cfelse>NULL</cfif>,
						<cfelseif attributes.amir eq 2>
							SECOND_BOSS_VALID_ROW=<cfif isdefined("attributes.second_boss_pos_req#i#")>1<cfelse>0</cfif>,
							SECOND_BOSS_DATE_ROW=#now()#,
							SECOND_BOSS_DETAIL_ROW=<cfif isdefined("attributes.second_boss_detail_pos_req#i#") and len(evaluate('attributes.second_boss_detail_pos_req#i#'))>'#wrk_eval('attributes.second_boss_detail_pos_req#i#')#'<cfelse>NULL</cfif>,	
						<cfelseif attributes.amir eq 3>
							THIRD_BOSS_VALID_ROW=<cfif isdefined("attributes.third_boss_pos_req#i#")>1<cfelse>0</cfif>,
							THIRD_BOSS_DATE_ROW=#now()#,
							THIRD_BOSS_DETAIL_ROW=<cfif isdefined("attributes.third_boss_detail_pos_req#i#") and len(evaluate('attributes.third_boss_detail_pos_req#i#'))>'#wrk_eval('attributes.third_boss_detail_pos_req#i#')#'<cfelse>NULL</cfif>,
						<cfelseif attributes.amir eq 4>
							FOURTH_BOSS_VALID_ROW=<cfif isdefined("attributes.fourth_boss_pos_req#i#")>1<cfelse>0</cfif>,
							FOURTH_BOSS_DATE_ROW=#now()#,
							FOURTH_BOSS_DETAIL_ROW=<cfif isdefined("attributes.fourth_boss_detail_pos_req#i#") and len(evaluate('attributes.fourth_boss_detail_pos_req#i#'))>'#wrk_eval('attributes.fourth_boss_detail_pos_req#i#')#'<cfelse>NULL</cfif>,
						<cfelseif attributes.amir eq 5>
							FIFTH_BOSS_VALID_ROW=<cfif isdefined("attributes.fifth_boss_pos_req#i#")>1<cfelse>0</cfif>,
							FIFTH_BOSS_DATE_ROW=#now()#,
							FIFTH_BOSS_DETAIL_ROW=<cfif isdefined("attributes.fifth_boss_detail_pos_req#i#") and len(evaluate('attributes.fifth_boss_detail_pos_req#i#'))>'#wrk_eval('attributes.fifth_boss_detail_pos_req#i#')#'<cfelse>NULL</cfif>,
						</cfif>
						UPDATE_DATE=#now()#,
						UPDATE_EMP=#session.ep.userid#,
						UPDATE_IP='#REMOTE_ADDR#'
					WHERE
						REQUEST_ROW_ID=#evaluate("attributes.train_req_row_id_pos_req#i#")#
				</cfquery>
			  <cfelse>
				<cfquery name="ADD_TRAINING_ROW_POS_REQ" datasource="#dsn#">
					INSERT INTO
						TRAINING_REQUEST_ROWS
						(
							TRAIN_REQUEST_ID,
							REQUEST_TYPE,
							REQUEST_STATUS,
							CLASS_ID,
							TRAINING_PRIORITY,
							WORK_TARGET_ADDITION,
						<cfif attributes.amir eq 1>
							FIRST_BOSS_VALID_ROW,
							FIRST_BOSS_DATE_ROW,
						<cfelseif attributes.amir eq 2>
							SECOND_BOSS_VALID_ROW,
							SECOND_BOSS_DATE_ROW,
						<cfelseif attributes.amir eq 3>
							THIRD_BOSS_VALID_ROW,
							THIRD_BOSS_DATE_ROW,
						<cfelseif attributes.amir eq 4>
							FOURTH_BOSS_VALID_ROW,
							FOURTH_BOSS_DATE_ROW,
						<cfelseif attributes.amir eq 5>
							FIFTH_BOSS_VALID_ROW,
							FIFTH_BOSS_DATE_ROW,
						</cfif>
							RECORD_DATE,
							RECORD_EMP,
							RECORD_IP
						)
					VALUES
						(
							#attributes.train_req_id#,
							3,
							1,
							#evaluate('attributes.class_id_pos_req#i#')#,
							'#wrk_eval('attributes.priority_pos_req#i#')#',
							'#wrk_eval('attributes.work_addition_pos_req#i#')#',
						<cfif attributes.amir eq 1>
							1,
							#now()#,
						<cfelseif attributes.amir eq 2>
							1,
							#now()#,
						<cfelseif attributes.amir eq 3>
							1,
							#now()#,
						<cfelseif attributes.amir eq 4>
							1,
							#now()#,
						<cfelseif attributes.amir eq 5>
							1,
							#now()#,
						</cfif>
							#now()#,
							#session.ep.userid#,
							'#REMOTE_ADDR#'
						)
				</cfquery>
			  </cfif>
			</cfif>
		</cfloop>
	 	<cfloop from="1" to="#attributes.record_num_tech#" index="i">
			<cfif isdefined("attributes.row_kontrol_tech#i#") and evaluate("attributes.row_kontrol_tech#i#") eq 1 and len(evaluate("attributes.class_name_tech#i#"))>
			  <cfif isdefined("attributes.train_req_row_id_tech#i#") and len(evaluate("attributes.train_req_row_id_tech#i#"))>
				<cfquery name="UPD_TRAINING_ROW_POS_REQ" datasource="#dsn#">
					UPDATE 
						TRAINING_REQUEST_ROWS
					SET
						TRAINING_PRIORITY='#wrk_eval('attributes.priority_tech#i#')#',
						WORK_TARGET_ADDITION='#wrk_eval('attributes.work_addition_tech#i#')#',
						<cfif attributes.amir eq 1>
							FIRST_BOSS_VALID_ROW=<cfif isdefined("attributes.first_boss_tech#i#")>1<cfelse>0</cfif>,
							FIRST_BOSS_DATE_ROW=#now()#,
							FIRST_BOSS_DETAIL_ROW=<cfif isdefined("attributes.first_boss_detail_tech#i#") and len(evaluate('attributes.first_boss_detail_tech#i#'))>'#wrk_eval('attributes.first_boss_detail_tech#i#')#'<cfelse>NULL</cfif>,
						<cfelseif attributes.amir eq 2>
							SECOND_BOSS_VALID_ROW=<cfif isdefined("attributes.second_boss_tech#i#")>1<cfelse>0</cfif>,
							SECOND_BOSS_DATE_ROW=#now()#,
							SECOND_BOSS_DETAIL_ROW=<cfif isdefined("attributes.second_boss_detail_tech#i#") and len(evaluate('attributes.second_boss_detail_tech#i#'))>'#wrk_eval('attributes.second_boss_detail_tech#i#')#'<cfelse>NULL</cfif>,	
						<cfelseif attributes.amir eq 3>
							THIRD_BOSS_VALID_ROW=<cfif isdefined("attributes.third_boss_tech#i#")>1<cfelse>0</cfif>,
							THIRD_BOSS_DATE_ROW=#now()#,
							THIRD_BOSS_DETAIL_ROW=<cfif isdefined("attributes.third_boss_detail_tech#i#") and len(evaluate('attributes.third_boss_detail_tech#i#'))>'#wrk_eval('attributes.third_boss_detail_tech#i#')#'<cfelse>NULL</cfif>,
						<cfelseif attributes.amir eq 4>
							FOURTH_BOSS_VALID_ROW=<cfif isdefined("attributes.fourth_boss_tech#i#")>1<cfelse>0</cfif>,
							FOURTH_BOSS_DATE_ROW=#now()#,
							FOURTH_BOSS_DETAIL_ROW=<cfif isdefined("attributes.fourth_boss_detail_tech#i#") and len(evaluate('attributes.fourth_boss_detail_tech#i#'))>'#wrk_eval('attributes.fourth_boss_detail_tech#i#')#'<cfelse>NULL</cfif>,
						<cfelseif attributes.amir eq 5>
							FIFTH_BOSS_VALID_ROW=<cfif isdefined("attributes.fifth_boss_tech#i#")>1<cfelse>0</cfif>,
							FIFTH_BOSS_DATE_ROW=#now()#,
							FIFTH_BOSS_DETAIL_ROW=<cfif isdefined("attributes.fifth_boss_detail_tech#i#") and len(evaluate('attributes.fifth_boss_detail_tech#i#'))>'#wrk_eval('attributes.fifth_boss_detail_tech#i#')#'<cfelse>NULL</cfif>,
						</cfif>
						UPDATE_DATE=#now()#,
						UPDATE_EMP=#session.ep.userid#,
						UPDATE_IP='#REMOTE_ADDR#'
					WHERE
						REQUEST_ROW_ID=#evaluate("attributes.train_req_row_id_tech#i#")#
				</cfquery>
			  <cfelse>
				<cfquery name="ADD_TRAINING_ROW_TECH" datasource="#dsn#">
				INSERT INTO
					TRAINING_REQUEST_ROWS
					(
						TRAIN_REQUEST_ID,
						REQUEST_TYPE,
						REQUEST_STATUS,
						CLASS_ID,
						OTHER_TRAIN_NAME,
						TRAINING_PRIORITY,
						WORK_TARGET_ADDITION,
						<cfif attributes.amir eq 1>
							FIRST_BOSS_VALID_ROW,
							FIRST_BOSS_DATE_ROW,
						<cfelseif attributes.amir eq 2>
							SECOND_BOSS_VALID_ROW,
							SECOND_BOSS_DATE_ROW,
						<cfelseif attributes.amir eq 3>
							THIRD_BOSS_VALID_ROW,
							THIRD_BOSS_DATE_ROW,
						<cfelseif attributes.amir eq 4>
							FOURTH_BOSS_VALID_ROW,
							FOURTH_BOSS_DATE_ROW,
						<cfelseif attributes.amir eq 5>
							FIFTH_BOSS_VALID_ROW,
							FIFTH_BOSS_DATE_ROW,
						</cfif>
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP
					)
				VALUES
					(
						#attributes.train_req_id#,
						4,
						1,
						<cfif len(evaluate('attributes.class_id_tech#i#')) and evaluate('attributes.class_id_tech#i#') gt 0>#evaluate('attributes.class_id_tech#i#')#<cfelse>NULL</cfif>,
						<cfif len(evaluate('attributes.class_name_tech#i#'))>'#wrk_eval('attributes.class_name_tech#i#')#'<cfelse>NULL</cfif>,
						'#wrk_eval('attributes.priority_tech#i#')#',
						'#wrk_eval('attributes.work_addition_tech#i#')#',
						<cfif attributes.amir eq 1>
							1,
							#now()#,
						<cfelseif attributes.amir eq 2>
							1,
							#now()#,
						<cfelseif attributes.amir eq 3>
							1,
							#now()#,
						<cfelseif attributes.amir eq 4>
							1,
							#now()#,
						<cfelseif attributes.amir eq 5>
							1,
							#now()#,
						</cfif>
						#now()#,
						#session.ep.userid#,
						'#REMOTE_ADDR#'
					)
				</cfquery>
			  </cfif>
			</cfif>
		</cfloop>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=training_management.form_upd_class_request&train_req_id=#attributes.train_req_id#" addtoken="no">
