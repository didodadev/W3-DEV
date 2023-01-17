<cflock name="CreateUUID()" timeout="20">
	<cftransaction>
	<cfif isdefined("attributes.emp_valid") and attributes.emp_valid neq -1 and isdefined("attributes.is_form")>
		<cfquery name="upd_perform" datasource="#dsn#">
			UPDATE
				EMPLOYEE_PERFORMANCE_TARGET
			SET
			<cfif isdefined("attributes.is_form")>
				IS_COACH=<cfif isdefined("attributes.is_coach")>1<cfelse>0</cfif>,
				IS_DEP_ADMIN=<cfif isdefined("attributes.is_dep_admin")>1<cfelse>0</cfif>,
			</cfif>
			<cfif isdefined("attributes.emp_valid") and attributes.emp_valid eq 1>
				EMP_VALID_FORM=1,
				EMP_VALID_DATE_FORM=#NOW()#,
			<cfelseif isdefined("attributes.amir_valid_1") and attributes.amir_valid_1 eq 1>
				FIRST_BOSS_ID=#session.ep.userid#,
				FIRST_BOSS_VALID_FORM=1,
				FIRST_BOSS_VALID_DATE_FORM=#NOW()#,
			<cfelseif isdefined("attributes.amir_valid_2")>
				SECOND_BOSS_ID=#session.ep.userid#,
				SECOND_BOSS_VALID_FORM=1,
				SECOND_BOSS_VALID_DATE_FORM=#NOW()#,
			<cfelseif isdefined("attributes.amir_valid_3")>
				THIRD_BOSS_ID=#session.ep.userid#,
				THIRD_BOSS_VALID_FORM=1,
				THIRD_BOSS_VALID_DATE_FORM=#NOW()#,
			<cfelseif isdefined("attributes.amir_valid_4")>
				FOURTH_BOSS_ID=#session.ep.userid#,
				FOURTH_BOSS_VALID_FORM=1,
				FOURTH_BOSS_VALID_DATE_FORM=#NOW()#,
			<cfelseif isdefined("attributes.amir_valid_5")>
				FIFTH_BOSS_ID=#session.ep.userid#,
				FIFTH_BOSS_VALID_FORM=1,
				FIFTH_BOSS_VALID_DATE_FORM=#NOW()#,
			</cfif>
				UPDATE_EMP = '#SESSION.EP.USERID#',
				UPDATE_IP = '#CGI.REMOTE_ADDR#',
				UPDATE_DATE = #now()#
			WHERE
				PER_ID = #attributes.per_id#
		</cfquery>
	<cfelse>
		<cfquery name="upd_perform" datasource="#dsn#">
			UPDATE
				EMPLOYEE_PERFORMANCE_TARGET
			SET
				EMP_VALID_FORM=NULL,
				EMP_VALID_DATE_FORM=NULL,
				FIRST_BOSS_VALID_FORM=NULL,
				FIRST_BOSS_VALID_DATE_FORM=NULL,
				SECOND_BOSS_VALID_FORM=NULL,
				SECOND_BOSS_VALID_DATE_FORM=NULL,
				THIRD_BOSS_VALID_FORM=NULL,
				THIRD_BOSS_VALID_DATE_FORM=NULL,
				FOURTH_BOSS_VALID_FORM=NULL,
				FOURTH_BOSS_VALID_DATE_FORM=NULL,
				FIFTH_BOSS_VALID_FORM=NULL,
				FIFTH_BOSS_VALID_DATE_FORM=NULL,
				UPDATE_EMP = '#SESSION.EP.USERID#',
				UPDATE_IP = '#CGI.REMOTE_ADDR#',
				UPDATE_DATE = #now()#
			WHERE
				PER_ID = #attributes.per_id#
		</cfquery>
	</cfif>
	</cftransaction>
</cflock>
<cfif fusebox.circuit eq 'myhome'>
	<cfset per_id_ = contentEncryptingandDecodingAES(isEncode:1,content:attributes.per_id,accountKey:session.ep.userid)>
<cfelse>
	<cfset per_id_ = attributes.per_id>
</cfif>
<cflocation url="#request.self#?fuseaction=myhome.upd_target_plan_forms&per_id=#per_id_#" addtoken="no">
