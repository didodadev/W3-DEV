
<cfquery name="GET_SEARCH_WORD" datasource="#dsn#">
	SELECT WORD FROM SOCIAL_MEDIA_SEARCH_WORDS
</cfquery>
<cfset result1= []>
<cfloop query="GET_SEARCH_WORD" >
	<cfset arrayAppend(result1,GET_SEARCH_WORD.WORD)>
</cfloop>


<cfloop index="w" from="1" to="#arrayLen(result1)#">
	<cfset search =result1[w]>
	<cfset maxRequests = 10>
<cfquery name="GET_LAST_COMMENT_DATE" datasource="#dsn#"> 
	SELECT 
		TOP 1 PUBLISH_DATE
	FROM 
		SOCIAL_MEDIA_REPORT
	WHERE 
		SEARCH_KEY='#search#'	
</cfquery>
<cfquery name="GET_RECORD_COUNT" datasource="#dsn#">
	SELECT 
		PUBLISH_DATE
	FROM 
		SOCIAL_MEDIA_REPORT 
	WHERE 
		SEARCH_KEY='#search#' AND SITE='twitter'			
</cfquery>
	<cfset page = 1>
	<cfset max_ = 10>
	<cfset done = false>
	<cfset errorFlag = false>
	<cfset maxFlag = false>
	<cfset lst_com_date= dateformat(GET_LAST_COMMENT_DATE.PUBLISH_DATE,"yyyy-mm-dd")>
	<cfset searchURL = urlEncodedFormat(search)>
	<cfset results = []>
	<cfloop condition="not done">
		<cfif GET_RECORD_COUNT.recordcount neq 0>
			<cfhttp url="http://search.twitter.com/search.json?page=#page#&rpp=#max_#&q=#search#&since=#lst_com_date#" result="result"></cfhttp>
		<cfelse>
			<cfhttp url="http://search.twitter.com/search.json?page=#page#&rpp=#max_#&q=#search#" result="result"></cfhttp>
		</cfif>
		<cfif result.responseheader.status_code is "200">
			<cfset content = result.fileContent.toString()>
			<cfset data = deserializeJSON(content)>
			
			<cfloop index="item" array="#data.results#">
				<cfset arrayAppend(results, item)>
			</cfloop>
			<cfif structKeyExists(data, "next_page")>
				<cfset page++>
				<cfif page gt maxRequests>
					<cfset maxFlag = true>
					<cfset done = true>
				</cfif>
			<cfelse>
				<cfset done = true>
			</cfif>
		<cfelse>
			<cfset errorFlag = true>
			<cfset done = true>
		</cfif>
	</cfloop>
	<cfloop index="x" from="1" to="#arrayLen(results)#">
		<cfset twit1 = results[x]>
		<cfset twit2.text=URLDecode(twit1.text)> 
		<cfquery name="insert_social_media_info" datasource="#dsn#">
			INSERT INTO
				SOCIAL_MEDIA_REPORT
				(
					SOCIAL_MEDIA_ID,
					IMAGE,
					USER_NAME,
					PUBLISH_DATE,
					SOCIAL_MEDIA_CONTENT,
					SEARCH_KEY,
					SITE,
					PROCESS_ROW_ID,
					RECORD_EMP,
					LANGUAGE
				)
				VALUES
				(
					'#twit1.id_str#',
					'#twit1.profile_image_url#',
					#sql_unicode()#'#twit1.from_user#',
					'#dateformat(twit1.created_at,"yyyy-mm-dd")#',
					#sql_unicode()#'#twit2.text#',
					'#search#',
					'twitter',
					#get_process_types.ROW_ID#,
					1,
					'#twit1.iso_language_code#'
				)
		</cfquery>
	</cfloop>
</cfloop>


			

