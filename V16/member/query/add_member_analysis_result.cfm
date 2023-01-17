<!--- ilgili analizler --->
<cfquery name="GET_ANALYSIS" datasource="#DSN#">
	SELECT ANALYSIS_AVERAGE,ANALYSIS_HEAD,ANALYSIS_PARTNERS,ANALYSIS_CONSUMERS FROM MEMBER_ANALYSIS WHERE ANALYSIS_ID = #attributes.analysis_id#
</cfquery>
<!--- Ilgili analize ait sorular --->
<cfquery name="GET_ANALYSIS_QUESTIONS" datasource="#DSN#">
	SELECT * FROM  MEMBER_QUESTION WHERE ANALYSIS_ID = #attributes.analysis_id# ORDER BY QUESTION_ID
</cfquery>

<cfif isDefined("attributes.is_report") and attributes.is_report eq 1>
	<!--- Rapordan Soru Secmek Icin Geliyor, Kayit Yapilmiyor, Degistirmeyin Lutfen FBS 20100513 --->
	<cfset Company_Id_List = "">
	<cfset Consumer_Id_List = "">
	<cfif get_analysis_questions.recordcount>
		<cfset Answer_ = 0>
		<cfloop query="get_analysis_questions">
			<cfif Len(Evaluate("user_answer_#currentrow#"))><cfset Answer_ = Answer_ + 1></cfif>
		</cfloop>
		<cfif Answer_ neq 0>
			<cfloop query="get_analysis_questions">
				<cfif Len(Evaluate("user_answer_#currentrow#"))><!--- Sadece Isaretli Sorularda Filtreleme Yapilir --->
					<cfquery name="Get_Member_Analysis_Result" datasource="#dsn#">
						SELECT
							MR.COMPANY_ID,
							MR.CONSUMER_ID
						FROM
							MEMBER_ANALYSIS_RESULTS MR,
							MEMBER_ANALYSIS_RESULTS_DETAILS MRD
						WHERE
							MR.ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.analysis_id#"> AND
							MR.RESULT_ID = MRD.RESULT_ID AND
							MRD.QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#question_id#"> AND
							(	MRD.QUESTION_USER_ANSWERS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('user_answer_#currentrow#')#"> OR
								MRD.QUESTION_USER_ANSWERS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('user_answer_#currentrow#')#,%"> OR
								MRD.QUESTION_USER_ANSWERS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#Evaluate('user_answer_#currentrow#')#"> OR
								MRD.QUESTION_USER_ANSWERS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#Evaluate('user_answer_#currentrow#')#,%">
							)
					</cfquery>
					<cfif Get_Member_Analysis_Result.RecordCount>
						<cfloop query="Get_Member_Analysis_Result">
							<cfif Len(Company_Id)>
								<cfif isDefined("Company_Id_#Company_Id#")>
									<cfset "Company_Id_#Company_Id#" = Evaluate("Company_Id_#Company_Id#") + 1>
								<cfelse>
									<cfset "Company_Id_#Company_Id#" = 1>
								</cfif>
								<cfif isDefined("attributes.comparison_type") and attributes.comparison_type eq 1><!--- Ve Secenegi --->
									<cfif Answer_ eq Evaluate("Company_Id_#Company_Id#")>
										<cfset Company_Id_List = ListAppend(Company_Id_List,Company_Id,',')>
									</cfif>
								<cfelse><!--- Veya Secenegi --->
									<cfset Company_Id_List = ListAppend(Company_Id_List,Company_Id,',')>
								</cfif>
							</cfif>
							<cfif Len(Consumer_Id)>
								<cfif isDefined("Consumer_Id_#Consumer_Id#")>
									<cfset "Consumer_Id_#Consumer_Id#" = Evaluate("Consumer_Id_#Consumer_Id#") + 1>
								<cfelse>
									<cfset "Consumer_Id_#Consumer_Id#" = 1>
								</cfif>
								<cfif isDefined("attributes.comparison_type") and attributes.comparison_type eq 1><!--- Ve Secenegi --->
									<cfif Answer_ eq Evaluate("Consumer_Id_#Consumer_Id#")>
										<cfset Consumer_Id_List = ListAppend(Consumer_Id_List,Consumer_Id,',')>
									</cfif>
								<cfelse><!--- Veya Secenegi --->
									<cfset Consumer_Id_List = ListAppend(Consumer_Id_List,Consumer_Id,',')>
								</cfif>
							</cfif>
						</cfloop>
					</cfif>
				</cfif>
			</cfloop>
			<cfset Company_Id_List = ListSort(ListDeleteDuplicates(Company_Id_List),"numeric","asc",",")>
			<cfset Consumer_Id_List = ListSort(ListDeleteDuplicates(Consumer_Id_List),"numeric","asc",",")>
		</cfif>
	</cfif>
	<script type="text/javascript">
		<cfoutput>
		//Rapora ilgili veriler gonderiliyor
		window.opener.document.getElementById('analyse_answer').value = '#Answer_#';
		window.opener.document.getElementById('analyse_company_id_list').value = '#Company_Id_List#';
		window.opener.document.getElementById('analyse_consumer_id_list').value = '#Consumer_Id_List#';
		window.opener.document.getElementById('analyse_id').value = '#attributes.analysis_id#';
		window.opener.document.getElementById('analyse_name').value = '#GET_ANALYSIS.ANALYSIS_HEAD#';
		</cfoutput>
		window.close();
	</script>
<cfelse>
	<cfif isdefined("attributes.attendance_date") and len(attributes.attendance_date)><cf_date tarih='attributes.attendance_date'></cfif>
	<cflock name="#createUUID()#" timeout="20">
		<cftransaction>
			<cfquery name="ADD_ANALYSIS_RESULT" datasource="#DSN#" result="MAX_ID">
				INSERT INTO
					MEMBER_ANALYSIS_RESULTS
				(
					ANALYSIS_ID,
					PARTNER_ID,
					COMPANY_ID,
					CONSUMER_ID,
					PROJECT_ID,
					OPPORTUNITY_ID,
					OFFER_ID,	
					OUR_COMPANY_ID,
					RIVAL_ID,
					RECORD_DATE,	
					RECORD_EMP,
					RECORD_IP,
                    ATTENDANCE_DATE,
                    PERIOD
				)
				VALUES
				(
					#attributes.analysis_id#,
				<cfif isdefined('attributes.partner_id') and len(attributes.partner_id)>
					#attributes.partner_id#, 
					#attributes.company_id#, 
					NULL,
				<cfelseif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
					NULL, 
					NULL,
					#attributes.consumer_id#,
				<cfelse>
					NULL,
					NULL,
					NULL,
				</cfif>
					<cfif attributes.action_type eq 'PROJECT'>#attributes.action_type_id#<cfelse>NULL</cfif>,
					<cfif attributes.action_type eq 'OPPORTUNITY'>#attributes.action_type_id#<cfelse>NULL</cfif>,
					<cfif attributes.action_type eq 'OFFER'>#attributes.action_type_id#<cfelse>NULL</cfif>,
					<cfif attributes.action_type eq 'OPPORTUNITY' or attributes.action_type eq 'OFFER'>#session.ep.company_id#<cfelse>NULL</cfif>,
					<cfif attributes.action_type eq 'RIVAL'>#attributes.action_type_id#<cfelse>NULL</cfif>,
					#now()#,
					#session.ep.userid#,
					'#cgi.remote_addr#'	,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.attendance_date#">,
                    <cfif isdefined('attributes.period') and len(attributes.period)>#attributes.period#<cfelse>NULL</cfif>
				)
			</cfquery>
			<cfquery name="ADD_RESULT" datasource="#DSN#">
				UPDATE
					MEMBER_ANALYSIS_RESULTS
				SET
					QUESTION_COUNT = #get_analysis_questions.recordcount#,
					AVERAGE = #get_analysis.analysis_average#
				WHERE
					RESULT_ID = #MAX_ID.IDENTITYCOL#
			</cfquery>
		
			<cfset puan = 0>
			<cfoutput query="get_analysis_questions">
				<cfset puan0 = 0>
				<cfif isdefined("attributes.user_answer_#currentrow#") and isdefined("attributes.user_answer_#currentrow#_point") and get_analysis_questions.question_type neq 3>
					<cfloop list="#evaluate('attributes.user_answer_'&currentrow)#"  index="aaa">
						<cfset puan = puan + ListGetAt(evaluate('attributes.user_answer_'&currentrow&'_point'), aaa)>
					</cfloop>
					<cfloop list="#evaluate('attributes.user_answer_'&currentrow)#"  index="aaa">
						<cfset puan0 = puan0 + ListGetAt(evaluate('attributes.user_answer_'&currentrow&'_point'), aaa)>
					</cfloop>
					<cfif isDefined("attributes.user_answer_#currentrow#")>
						<cfset temp_user_answer = evaluate("attributes.user_answer_#currentrow#")>
						<cfquery name="ADD_RESULT_DETAIL" datasource="#DSN#">
							INSERT INTO
								MEMBER_ANALYSIS_RESULTS_DETAILS
							(
								RESULT_ID,
								QUESTION_ID,
								QUESTION_POINT,
								QUESTION_USER_ANSWERS
							)
							VALUES
							(
								#MAX_ID.IDENTITYCOL#,
								#get_analysis_questions.question_id#,
								#puan0#,
								'#temp_user_answer#'
							)
						</cfquery>
					</cfif>
				<cfelse>
				<!--- acik uclu soru ise kaydi yapiliyor --->	
					<cfif isDefined("attributes.user_answer_#currentrow#")>
						<cfset temp_user_answer = evaluate("attributes.user_answer_#currentrow#")>
						<cfquery name="ADD_RESULT_DETAIL" datasource="#DSN#">
							INSERT INTO
								MEMBER_ANALYSIS_RESULTS_DETAILS
							(
								RESULT_ID,
								QUESTION_ID,
								QUESTION_POINT,
								QUESTION_USER_ANSWERS
							)
							VALUES
							(
								#MAX_ID.IDENTITYCOL#,
								#get_analysis_questions.question_id#,
								0,
								'#temp_user_answer#'
							)
						</cfquery>
					</cfif>
				</cfif>
			</cfoutput>
			<!--- Sonucu guncelle --->
			<cfquery name="UPD_RESULT" datasource="#DSN#">
				UPDATE
					MEMBER_ANALYSIS_RESULTS
				SET
					USER_POINT = #puan#
				WHERE
					RESULT_ID =  #MAX_ID.IDENTITYCOL#
			</cfquery>
		</cftransaction>
	</cflock>
	<script type="text/javascript">
		<cfif attributes.draggable eq 1>
			window.location.href= document.referrer;
		<cfelse>
			wrk_opener_reload();
			window.close();
		</cfif>
	</script>
</cfif>
