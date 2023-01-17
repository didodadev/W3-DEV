<cflock name="#CreateUUID()#" timeout="60">
<cftransaction>
	<cfquery name="GET_CHAPTER" datasource="#dsn#">
		SELECT
			CHAPTER_ID
		FROM 
			EMPLOYEE_QUIZ_CHAPTER 
		WHERE 
			REQ_TYPE_ID=#attributes.REQ_TYPE_ID#
	</cfquery>
	<cfif GET_CHAPTER.RECORDCOUNT>
		<cfquery name="GET_QUESTION" datasource="#dsn#">
			SELECT 
				*
			FROM 
				EMPLOYEE_QUIZ_QUESTION
			WHERE
				CHAPTER_ID=#GET_CHAPTER.CHAPTER_ID#
		</cfquery>
		<cfoutput query="GET_QUESTION">
			<cfloop from="1" to="20" index="i">
				<cfif len(evaluate("get_question.ANSWER#i#_photo"))>
					<!--- <cftry>
						<cffile action="DELETE" file="#upload_folder#hr#dir_seperator###">
						<cfcatch type="Any">
							Dosya bulunamadı ama veritabanından silindi !
						</cfcatch>
					</cftry> --->
					<cf_del_server_file output_file="hr/#evaluate("get_question.ANSWER#i#_photo")#" output_server="#evaluate("get_question.ANSWER#i#_photo_server_id")#">
				</cfif>
			</cfloop>
		</cfoutput>
		<cfquery name="DEL_QUESTION" datasource="#dsn#">
			DELETE 
			FROM 
				EMPLOYEE_QUIZ_QUESTION 
			WHERE 
				CHAPTER_ID=#GET_CHAPTER.CHAPTER_ID#
		</cfquery>
	<!--- bölüm sil--->	
	<cfquery name="DEL_CHAPTER" datasource="#dsn#">
		DELETE 
		FROM 
			EMPLOYEE_QUIZ_CHAPTER 
		WHERE 
			REQ_TYPE_ID=#attributes.REQ_TYPE_ID#
	</cfquery>
	</cfif>
	
	<cf_relation_segment
		is_del=1
		is_upd='0' 
		is_form='0'
		field_id='#attributes.REQ_TYPE_ID#'
		table_name='POSITION_REQ_TYPE'
		action_table_name='RELATION_SEGMENT'
		select_list='1,2,3,4,5,6,7,8'>
			
	<cfquery name="del_pos_req_type" datasource="#dsn#">
		DELETE FROM POSITION_REQ_TYPE WHERE REQ_TYPE_ID = #attributes.REQ_TYPE_ID#
	</cfquery>
</cftransaction>
</cflock>
<!--- <script type="text/javascript">
  wrk_opener_reload();
  window.close();
</script> --->

<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=hr.list_position_req_type</cfoutput>";
</script>

