<!--- bu sayfada unicodelar icin sql_unicode fonksiyonu kullanildi --->
<cfquery name="GET_HISTORY" datasource="#DSN#">
	SELECT 
		CONT_BODY, 
		IS_DSP_SUMMARY, 
		CAREER_VIEW, 
		SPOT, 
		CONTENT_STATUS,
		CONTENT_ID, 
		<!---GUEST,---> 
		PRIORITY, 
		INTERNET_VIEW, 
		VIEW_DATE_START, 
		VIEW_DATE_FINISH, 
		IS_VIEWED, 
		EMPLOYEE_VIEW,
		IS_DSP_HEADER, 
		NONE_TREE, 
		CONSUMER_CAT, 
		POSITION_CAT_IDS, 
		USER_GROUP_IDS, 
		CONT_SUMMARY,
		CONT_HEAD, 
		CONT_POSITION, 
		STAGE_ID,
		CHAPTER_ID, 
		COMPANY_CAT, 
		CONTENT_PROPERTY_ID 
	FROM 
		CONTENT_HISTORY 
	WHERE 
		CONTENT_HISTORY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cnth_id#">
</cfquery>
<cfquery name="UPD_HISTORY" datasource="#DSN#">
	UPDATE
		CONTENT
	SET
		CONT_BODY = #sql_unicode()#'#get_history.cont_body#',
		CONT_SUMMARY = #sql_unicode()#'#get_history.cont_summary#',
		CONT_HEAD = #sql_unicode()#'#get_history.cont_head#',
		CONT_POSITION =  #get_history.cont_position#,
		STAGE_ID =  <cfif len(get_history.stage_id)>#get_history.stage_id#<cfelse>NULL</cfif>,
		CHAPTER_ID =  #get_history.chapter_id#,
		CONTENT_PROPERTY_ID = <cfif len(get_history.content_property_id)>#get_history.content_property_id#<cfelse>NULL</cfif>,
		COMPANY_CAT = <cfif len(get_history.company_cat)>'#get_history.company_cat#'<cfelse>NULL</cfif>,
		CONSUMER_CAT = '#get_history.consumer_cat#',
		POSITION_CAT_IDS = '#get_history.position_cat_ids#',
		USER_GROUP_IDS = '#get_history.user_group_ids#',
		NONE_TREE = #get_history.none_tree#,
		IS_DSP_HEADER = <cfif len(get_history.is_dsp_header)>#get_history.is_dsp_header#<cfelse>NULL</cfif>,
		IS_DSP_SUMMARY = <cfif len(get_history.is_dsp_summary)>#get_history.is_dsp_summary#<cfelse>NULL</cfif>,
		CONTENT_STATUS = #get_history.content_status#,
		INTERNET_VIEW = #get_history.internet_view#,
		CAREER_VIEW = #get_history.career_view#,
		EMPLOYEE_VIEW = #get_history.employee_view#,
		IS_VIEWED = #get_history.is_viewed#,
		VIEW_DATE_START = <cfif len(get_history.view_date_start)>'#get_history.view_date_start#'<cfelse>NULL</cfif>,
		VIEW_DATE_FINISH = <cfif len(get_history.view_date_finish)>'#get_history.view_date_finish#'<cfelse>NULL</cfif>,
		PRIORITY = <cfif len(get_history.priority)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_history.priority#"><cfelse>NULL</cfif>,
		<!---GUEST = #get_history.guest#,--->
		UPDATE_MEMBER = #session.ep.userid#,
		UPDATE_DATE = #now()#,
		UPD_COUNT = UPD_COUNT +1,
		SPOT = #get_history.spot#
	WHERE
		CONTENT_ID = #get_history.content_id#
</cfquery>

<script type="text/javascript">
	location.href = document.referrer;
</script>

