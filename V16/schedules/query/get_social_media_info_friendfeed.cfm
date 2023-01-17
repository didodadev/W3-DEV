										
<cfquery name="GET_SEARCH_WORD" datasource="#dsn#">
	SELECT WORD FROM SOCIAL_MEDIA_SEARCH_WORDS
</cfquery>
<cfset result1= []>
<cfloop query="GET_SEARCH_WORD" >
	<cfset arrayAppend(result1,GET_SEARCH_WORD.WORD)>
</cfloop>
<cfset social_media_id=[]>
<cfloop index="x" from="1" to="#arrayLen(result1)#">
<cfset search =result1[x]>
<cfset results=[]>
<cfset comments=[]>
<cfhttp url="http://friendfeed-api.com/v2/search?q=+intitle%3A#search#" method="get" result="result"></cfhttp>
<cfset content2 = result.fileContent.toString()>
<cfset content2 = replace(content2,'â€™','','all')>
<cfset content2 = replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(content2,'Ã¶','*bk*','all'),'Ä±','*ob*','all'),'ÅŸ','*we4','all'),'Ä°','*123*','all'),'ÄŸ','*qwe','all'),'Ã¼','*12q','all'),'Ã§','*pl*','all'),'Ã‡','*p*','all'),'Äž','*l*','all'),'Ã–','*n*','all'),'Åž','*v*','all'),'Ãœ','*h*','all'),'â€œ','','all'),'â€�','','all')>

<cfset content2 = replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(content2,'*bk*','ö','all'),'*ob*','ı','all'),'*we4','ş','all'),'*123*','İ','all'),'*qwe','ğ','all'),'*12q','ü','all'),'*pl*','ç','all'),'*p*','Ç','all'),'*l*','Ğ','all'),'*n*','Ö','all'),'*v*','Ş','all'),'*h*','Ü','all'),'\n','<br/>','all'),'\u003cbr /\u003e','<br/>','all')>
<cfset data = deserializeJSON(content2)>
<cfif isdefined("data.entries")>
<cfloop index="item" array="#data.entries#">
	<cfset arrayAppend(results, item)>
</cfloop>
<cfloop index="x" from="1" to="#arrayLen(results)#">
		<cfset friendfeed=results[x]>
		<cfif isdefined ("friendfeed.comments")>
			<cfloop index="item" array="#friendfeed.comments#">
				<cfset arrayAppend(comments,item)>
			</cfloop>
			<cfloop index="y" from="1" to="#arrayLen(comments)#">
				<cfset friendfeed_comments=comments[y]>
				<cfquery name="check_comments" datasource="#dsn#">
					SELECT SOCIAL_MEDIA_COMMENT_ID FROM SOCIAL_MEDIA_COMMENT WHERE SOCIAL_MEDIA_COMMENT_ID='#friendfeed_comments.id#'	
				</cfquery>
					<cfif check_comments.recordcount eq 0>
						<cfquery name="insert_social_media_comments" datasource="#dsn#">
							INSERT INTO 
								SOCIAL_MEDIA_COMMENT
								(
									SOCIAL_MEDIA_COMMENT_CONTENT,
									SOCIAL_MEDIA_ID,
									USER_NAME,
									SOCIAL_MEDIA_COMMENT_ID,
									PUBLISH_DATE,
									USER_ID
								)
								VALUES
								(
									#sql_unicode()#'#friendfeed_comments.body#',
									'#friendfeed.id#',
									#sql_unicode()#'#friendfeed_comments.from.name#',
									'#friendfeed_comments.id#',
									'#friendfeed_comments.date#',
									'#friendfeed_comments.from.id#'
								)
						</cfquery>
					</cfif>
			</cfloop>
		</cfif>	
		<cfquery name="check" datasource="#dsn#">
		 SELECT SOCIAL_MEDIA_ID FROM SOCIAL_MEDIA_REPORT WHERE SITE='friendfeed' and SOCIAL_MEDIA_ID='#friendfeed.id#'
		</cfquery>
		<cfif check.recordcount eq 0>
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
					COMMENT_URL,
					USER_ID
				)
				VALUES
				(
					'#friendfeed.id#',
					'/images/male.jpg',
					#sql_unicode()#'#friendfeed.from.name#',
					'#friendfeed.date#', 
					#sql_unicode()#'#friendfeed.body#',
					'#search#',
					'friendfeed',
					#get_process_types.ROW_ID#,
					1,
					'#friendfeed.url#',
					'#friendfeed.from.id#'
				)				
			</cfquery>
		</cfif>
	
	</cfloop>
	</cfif>	
</cfloop>






