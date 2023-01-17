<cfif isdefined("attributes.is_agenda")>
	<cfscript>
		session.analysis_id = attributes.analysis_id;
		session.member_type = listfirst(attributes.member_ids, ',');
		session.memberid = listlast(attributes.member_ids,',');
		attributes.analysis_id = attributes.analysis_id;
		attributes.member_type = listfirst(attributes.member_ids, ',');
		attributes.memberid = listlast(attributes.member_ids,',');
	</cfscript>
	<cfquery name="GET_ANALYSIS_RESULTS" datasource="#DSN#">
		SELECT 
			*
		FROM 
			MEMBER_ANALYSIS_RESULTS
		WHERE
			ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.analysis_id#"> AND
		<cfif isdefined("session.pp.userid")>
			PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
		<cfelse>
			CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
		</cfif>
	</cfquery>
	<cfif get_analysis_results.recordcount>
			<script type="text/javascript">
				alert("<cf_get_lang no ='1442.Aynı analiz aynı üyenin birden fazla çalışanına ve Aynı bireysel üyeye birden fazla yapılamaz'> !");
				history.back();
			</script>
		<cfabort>
	</cfif>
</cfif>
<!--- kağıdı gönder --->
<cfinclude template="add_analysis_result.cfm">
<cfquery name="ADD_RESULT" datasource="#dsn#">
    UPDATE
        MEMBER_ANALYSIS_RESULTS
    SET
        ANALYSIS_ID = #SESSION.ANALYSIS_ID#,
    <cfif isdefined("session.member_type") and session.member_type is 'partner'>
        PARTNER_ID = #session.memberid#,
    <cfelseif isdefined("session.member_type") and session.member_type is 'consumer'>
        CONSUMER_ID = #session.memberid#,
    <cfelseif isdefined("session.pp.userid")>
        PARTNER_ID = #session.pp.userid#,
    <cfelse>
        CONSUMER_ID = #session.ww.userid#,
    </cfif>
        QUESTION_COUNT = #GET_ANALYSIS_QUESTIONS.RecordCount#,
        AVERAGE = #GET_ANALYSIS.ANALYSIS_AVERAGE#
    WHERE
        RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.result_id#">
</cfquery>
<cfset puan = 0>
<cfoutput query="get_analysis_questions">
  <cfset puan0 = 0>
    <cfif IsDefined("FORM.user_answer_#currentrow#") and IsDefined("FORM.user_answer_#currentrow#_point")>
        #EVALUATE('FORM.user_answer_'&currentrow)# - 
        #EVALUATE('FORM.user_answer_'&currentrow&'_point')#
         *** 
            <cfloop list="#EVALUATE('FORM.user_answer_'&currentrow)#" index="aaa">
                <cfset puan = puan + #ListGetAt(EVALUATE('FORM.user_answer_'&currentrow&'_point'), aaa)#>
            </cfloop>
            <cfloop list="#EVALUATE('FORM.user_answer_'&currentrow)#"  index="aaa">
                <cfset puan0 = puan0 + #ListGetAt(EVALUATE('FORM.user_answer_'&currentrow&'_point'), aaa)#>
            </cfloop>
            <cfif isDefined("form.user_answer_#currentrow#")>
                <cfset cevap= EVALUATE("FORM.USER_ANSWER_#CURRENTROW#")>
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
                            #SESSION.RESULT_ID#,
                            #GET_ANALYSIS_QUESTIONS.QUESTION_ID#,
                            #puan0#,
                            '#cevap#'
                        )
                    </cfquery>
            </cfif>
    <cfelse>
    <!--- açık uçlu soru ise kaydı yapılıyor --->	
        <cfif isDefined("form.user_answer_#currentrow#")>
        <cfset cevap= EVALUATE("FORM.USER_ANSWER_#CURRENTROW#")>
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
                    #SESSION.RESULT_ID#,
                    #GET_ANALYSIS_QUESTIONS.QUESTION_ID#,
                    0,
                    '#cevap#'
                    )
            </cfquery>
        </cfif>
    </cfif>
    <br/>   
</cfoutput>
<!--- // kağıdı gönder --->
<cfset attributes.result_id = session.result_id>
<!--- sonucu veritabanına gönder --->
<cfquery name="UPD_RESULT" datasource="#dsn#">
    UPDATE
        MEMBER_ANALYSIS_RESULTS
    SET
        USER_POINT = #puan#,
        RECORD_DATE = #now()#,
        RECORD_IP = '#CGI.REMOTE_ADDR#'
    WHERE
        RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.result_id#">
</cfquery>
<cfscript>
	structDelete(session,"memberid");
	structDelete(session,"member_type");
	structDelete(session,"result_id");
	structDelete(session,"analysis_id");
</cfscript>
<cflocation url="#request.self#?fuseaction=objects2.list_analyses" addtoken="no">

