<!--- Ilgili Chapter'a  Option Eklenir --->
<cfif isdefined('attributes.option_record_num') and len(attributes.option_record_num)>
	<cfquery name="del_survey_options" datasource="#dsn#">
		DELETE FROM SURVEY_OPTION WHERE SURVEY_CHAPTER_ID = #attributes.survey_chapter_id# AND SURVEY_QUESTION_ID IS NULL
	</cfquery>
	<!--- <cfif isdefined("attributes.question_type") and attributes.question_type eq 4><!--- skor --->
		<cfquery name="add_survey_options1" datasource="#dsn#">
		INSERT INTO 
			SURVEY_OPTION
			(	
				SURVEY_CHAPTER_ID,
				<!--- SCORE_RATE1,
				SCORE_RATE2, --->
				QUESTION_TYPE,
				QUESTION_DESIGN, 
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP 
			)
			VALUES
			(	
				#attributes.survey_chapter_id#,
				<!--- <cfif isdefined("attributes.option_score_rate1") and  len(evaluate("attributes.option_score_rate1"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.option_score_rate1')#">,<cfelse>NULL,</cfif> 
				<cfif isdefined("attributes.option_score_rate2") and len(evaluate("attributes.option_score_rate2"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.option_score_rate2')#"><cfelse>NULL</cfif> , --->
				<cfif isdefined('attributes.question_type') and len(attributes.question_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.question_type#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.question_design') and len(attributes.question_design)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.question_design#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">
			)
		</cfquery>
	<cfelse> --->
		<cfloop from="1" to="#attributes.option_record_num#" index="j">
		<cfif isdefined("attributes.add_row_kontrol#j#") and evaluate("attributes.add_row_kontrol#j#") eq 1>
		<cfquery name="add_survey_options1" datasource="#dsn#">
			INSERT INTO 
				SURVEY_OPTION
				(	
					SURVEY_CHAPTER_ID,
					OPTION_HEAD,
					OPTION_DETAIL,
					<!--- OPTION_NOTE, --->
					OPTION_SCORE, 
					<!--- SCORE_RATE1,
					SCORE_RATE2,  ---> 
					OPTION_POINT,
					OPTION_IMAGE_PATH,
					QUESTION_TYPE,
					QUESTION_DESIGN, 
					RECORD_EMP,
					RECORD_DATE,
					RECORD_IP 
				)
				VALUES
				(	
					#attributes.survey_chapter_id#,
					<cfif isdefined("attributes.option_head#j#") and len(evaluate("attributes.option_head#j#"))><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate('attributes.option_head#j#')#">,<cfelse>NULL,</cfif>
					<cfif isdefined("attributes.option_detail#j#") and len(evaluate("attributes.option_detail#j#"))><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate('attributes.option_detail#j#')#">,<cfelse>NULL,</cfif>
					<!--- <cfif isdefined("attributes.option_add_note#j#")>1<cfelse>0</cfif>, --->
					<cfif isdefined("attributes.option_score#j#")>1<cfelse>0</cfif>,
					<!--- <cfif isdefined("attributes.option_score_rate1") and  len(evaluate("attributes.option_score_rate1"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.option_score_rate1')#">,<cfelse>NULL,</cfif> 
					<cfif isdefined("attributes.option_score_rate2") and len(evaluate("attributes.option_score_rate2"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.option_score_rate2')#">,<cfelse>NULL,</cfif>  ---> 
					<cfif isdefined("attributes.option_point#j#")and len(evaluate("attributes.option_point#j#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.option_point#j#')#"><cfelse>NULL</cfif>,
					<cfif isdefined("attributes.option_image#j#")and len(evaluate("attributes.option_image#j#"))><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#file_name#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.question_type') and len(attributes.question_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.question_type#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.question_design') and len(attributes.question_design)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.question_design#"><cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">
				)
		</cfquery>
		</cfif>
		</cfloop>
	<!--- </cfif> --->
	<cfif isdefined('attributes.question_type') and isdefined('attributes.question_design')>
		<cfquery name="upd_chapter_detail2" datasource="#dsn#">
			UPDATE 
				SURVEY_QUESTION 
			SET
				QUESTION_TYPE = <cfif isdefined('attributes.question_type') and len(attributes.question_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.question_type#"><cfelse>NULL</cfif>, 
				QUESTION_DESIGN = <cfif isdefined('attributes.question_design') and len(attributes.question_design)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.question_design#"><cfelse>NULL</cfif>
			WHERE 
				SURVEY_CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_chapter_id#">
		</cfquery>
	</cfif>
	 <cfquery name="upd_chapter_detail2" datasource="#dsn#">
		UPDATE 
			SURVEY_CHAPTER 
		SET 
			SURVEY_CHAPTER_DETAIL2 = '#attributes.chapter_detail2#', 
			IS_CHAPTER_DETAIL2 = <cfif isdefined("attributes.IS_CHAPTER_DETAIL2")>1<cfelse>0</cfif> ,
			IS_SHOW_GD = <cfif isdefined("attributes.is_show_gd") and len(attributes.is_show_gd)>#attributes.is_show_gd#<cfelse>NULL</cfif>
		WHERE 
			SURVEY_CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_chapter_id#">
	</cfquery>  
</cfif>
<!--- //Ilgili Chapter'a  Option Eklenir --->
<script language="javascript">
	window.close();
</script>
