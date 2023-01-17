<cfif isdefined("attributes.row_recordcount")>
	<cfloop from="1" to="#attributes.row_recordcount#" index="rr">
		<cfif Len(Evaluate("attributes.ship_result_wrk_row_id_#rr#"))>
			<cfquery name="Ship_Wrk_Relation_Row_Control" datasource="#dsn2#">
				SELECT WRK_ROW_RELATION_ID FROM SHIP_RESULT_ROW_COMPLETE WHERE WRK_ROW_RELATION_ID = '#Evaluate("attributes.ship_result_wrk_row_id_#rr#")#'
			</cfquery>
			<cfif Ship_Wrk_Relation_Row_Control.RecordCount>
				<cfquery name="upd_result_row_complete" datasource="#dsn2#">
					UPDATE
						SHIP_RESULT_ROW_COMPLETE
					SET
						SHIP_RESULT_ID = <cfif isdefined("attributes.ship_result_id_#rr#") and Len(Evaluate("attributes.ship_result_id_#rr#"))>#Evaluate("attributes.ship_result_id_#rr#")#<cfelse>NULL</cfif>,
						PROBLEM_RESULT_ID = <cfif isdefined("attributes.row_problem_type_#rr#") and Len(Evaluate("attributes.row_problem_type_#rr#"))>#Evaluate("attributes.row_problem_type_#rr#")#<cfelse>NULL</cfif>,
						ERROR_CASE_ID = <cfif isdefined("attributes.row_error_case_type_#rr#") and Len(Evaluate("attributes.row_error_case_type_#rr#"))>#Evaluate("attributes.row_error_case_type_#rr#")#<cfelse>NULL</cfif>,
						PROBLEM_CASE_ID = <cfif isdefined("attributes.row_problem_case_type_#rr#") and Len(Evaluate("attributes.row_problem_case_type_#rr#"))>#Evaluate("attributes.row_problem_case_type_#rr#")#<cfelse>NULL</cfif>,
						PROBLEM_DETAIL = <cfif isdefined("attributes.row_problem_detail_#rr#") and Len(Evaluate("attributes.row_problem_detail_#rr#"))>'#Evaluate("attributes.row_problem_detail_#rr#")#'<cfelse>NULL</cfif>,
						IS_GIVE_SERVICE = <cfif isDefined("attributes.is_give_service_#rr#")>1<cfelse>0</cfif>,
						UPDATE_EMP = #session.ep.userid#,
						UPDATE_DATE = #now()#,
						UPDATE_IP = '#cgi.remote_addr#'
					WHERE
						WRK_ROW_RELATION_ID = '#Evaluate("attributes.ship_result_wrk_row_id_#rr#")#'
				</cfquery>
			<cfelse>
				<cfif not isdefined("attributes.result_wrk_row_id_#rr#") or not Len(Evaluate("attributes.result_wrk_row_id_#rr#"))>
					<cfset "attributes.result_wrk_row_id_#rr#" = "#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)#">
				</cfif>
				<cfquery name="add_result_row_complete" datasource="#dsn2#">
					INSERT INTO
						SHIP_RESULT_ROW_COMPLETE
					(
						SHIP_RESULT_ID,
						PROBLEM_RESULT_ID,
						ERROR_CASE_ID,
						PROBLEM_CASE_ID,
						PROBLEM_DETAIL,
						IS_GIVE_SERVICE,
						WRK_ROW_ID,
						WRK_ROW_RELATION_ID,
						RECORD_EMP,
						RECORD_DATE,
						RECORD_IP	
					)
					VALUES
					(
						<cfif isdefined("attributes.ship_result_id_#rr#") and Len(Evaluate("attributes.ship_result_id_#rr#"))>#Evaluate("attributes.ship_result_id_#rr#")#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.row_problem_type_#rr#") and Len(Evaluate("attributes.row_problem_type_#rr#"))>#Evaluate("attributes.row_problem_type_#rr#")#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.row_error_case_type_#rr#") and Len(Evaluate("attributes.row_error_case_type_#rr#"))>#Evaluate("attributes.row_error_case_type_#rr#")#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.row_problem_case_type_#rr#") and Len(Evaluate("attributes.row_problem_case_type_#rr#"))>#Evaluate("attributes.row_problem_case_type_#rr#")#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.row_problem_detail_#rr#") and Len(Evaluate("attributes.row_problem_detail_#rr#"))>'#Evaluate("attributes.row_problem_detail_#rr#")#'<cfelse>NULL</cfif>,
						<cfif isDefined("attributes.is_give_service_#rr#")>1<cfelse>0</cfif>,
						<cfif isdefined("attributes.result_wrk_row_id_#rr#") and Len(Evaluate("attributes.result_wrk_row_id_#rr#"))>'#Evaluate("attributes.result_wrk_row_id_#rr#")#'<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.ship_result_wrk_row_id_#rr#") and Len(Evaluate("attributes.ship_result_wrk_row_id_#rr#"))>'#Evaluate("attributes.ship_result_wrk_row_id_#rr#")#'<cfelse>NULL</cfif>,
						#session.ep.userid#,
						#now()#,
						'#cgi.remote_addr#'
					)
				</cfquery>
			</cfif>
		</cfif>
	</cfloop>
</cfif>
<cfset form_add = "&form_submitted=1">
<cfif isdefined("attributes.team_code_")><cfset form_add = "#form_add#&team_code=#attributes.team_code_#"></cfif>
<cfif isdefined("attributes.team_code_")><cfset form_add = "#form_add#&planning_date=#attributes.planning_date_#"></cfif>
<cflocation url="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_multi_packetship_complete#form_add#" addtoken="no">
