
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
<cfhttp url="http://gdata.youtube.com/feeds/api/videos?v=2&alt=jsonc&q=#search#&max-results=50" result="result"></cfhttp>
<cfset content2 = result.fileContent.tostring()>
<cfset content2 = replace(content2,'â€™','','all')>
<cfset content2 = replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(content2,'Ã¶','*bk*','all'),'Ä±','*ob*','all'),'ÅŸ','*we4','all'),'Ä°','*123*','all'),'ÄŸ','*qwe','all'),'Ã¼','*12q','all'),'Ã§','*pl*','all'),'Ã‡','*p*','all'),'Äž','*l*','all'),'Ã–','*n*','all'),'Åž','*v*','all'),'Ãœ','*h*','all'),'â€œ','','all'),'â€�','','all')>
<cfset content2 = replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(content2,'*bk*','ö','all'),'*ob*','ı','all'),'*we4','ş','all'),'*123*','İ','all'),'*qwe','ğ','all'),'*12q','ü','all'),'*pl*','ç','all'),'*p*','Ç','all'),'*l*','Ğ','all'),'*n*','Ö','all'),'*v*','Ş','all'),'*h*','Ü','all'),'\n','<br/>','all'),'\u003cbr /\u003e','<br/>','all')>
<cfset data = deserializeJSON(content2)>
<cfloop index="item" array="#data.data.items#">
	<cfset arrayAppend(results,item)>
</cfloop>
<cfloop index="x" from="1" to="#arrayLen(results)#">
<cfset youtube=results[x]>

	<cfif isdefined ("youtube.commentCount") and youtube.commentCount gt 0>	
		<cfhttp method="get" url="https://gdata.youtube.com/feeds/api/videos/#youtube.id#/comments?v=2&alt=json" result="result">
		</cfhttp>
		<cfset content2 = result.fileContent.tostring()>
		<cfset content2 = replace(content2,'â€™','','all')>
		<cfset content2 = replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(content2,'Ã¶','*bk*','all'),'Ä±','*ob*','all'),'ÅŸ','*we4','all'),'Ä°','*123*','all'),'ÄŸ','*qwe','all'),'Ã¼','*12q','all'),'Ã§','*pl*','all'),'Ã‡','*p*','all'),'Äž','*l*','all'),'Ã–','*n*','all'),'Åž','*v*','all'),'Ãœ','*h*','all'),'â€œ','','all'),'â€�','','all')>
		<cfset content2 = replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(content2,'*bk*','ö','all'),'*ob*','ı','all'),'*we4','ş','all'),'*123*','İ','all'),'*qwe','ğ','all'),'*12q','ü','all'),'*pl*','ç','all'),'*p*','Ç','all'),'*l*','Ğ','all'),'*n*','Ö','all'),'*v*','Ş','all'),'*h*','Ü','all'),'\n','<br/>','all'),'\u003cbr /\u003e','<br/>','all')>
		<cfset data = deserializeJSON(content2)>
		
			<cfloop index="item" array="#data.feed.entry#">
				<cfset arrayAppend(comments,item)>
			</cfloop>
			
			<cfloop index="y" from="1" to="#arrayLen(comments)#">
				<cfset youtube_comments=comments[y]>		
				<cfset name1=[]>
					<cfloop index="z" array="#youtube_comments.author#" >
						<cfset arrayAppend(name1,z)>
					</cfloop>
					
					<cfloop index="t" from="1" to="#arrayLen(name1)#">
						<cfset youtube_name=name1[t].name.$t>
					</cfloop>
					<cfquery name="kontrol_kayit" datasource="#dsn#">
						SELECT SOCIAL_MEDIA_COMMENT_ID FROM SOCIAL_MEDIA_COMMENT WHERE SOCIAL_MEDIA_COMMENT_ID='#youtube_comments.id.$t#'
					</cfquery>
						<cfif kontrol_kayit.recordcount eq 0>
							<cfquery name="insert_social_media_comment" datasource="#dsn#">
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
											#sql_unicode()#'#youtube_comments.content.$t#',
											'#youtube_comments.yt$videoid.$t#',
											#sql_unicode()#'#youtube_name#',
											'#youtube_comments.id.$t#',
											'#youtube_comments.published.$t#',
											'#youtube_name#'
										)		
							</cfquery>
					</cfif>
			</cfloop>
	</cfif>	
<cfquery name="check" datasource="#dsn#">
 SELECT SOCIAL_MEDIA_ID 
 FROM SOCIAL_MEDIA_REPORT 
 WHERE SITE='youtube' and SOCIAL_MEDIA_ID='#youtube.id#'
</cfquery>

<cfif check.recordcount eq 0 >
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
		'#youtube.id#',
		'#youtube.thumbnail.sqDefault#',
		#sql_unicode()#'#youtube.uploader#',
		'#youtube.uploaded#', 
		#sql_unicode()#'#URLDecode(youtube.description)#',
		'#search#',
		'youtube',
		#get_process_types.ROW_ID#,
		1,
		'#youtube.player.default#',
		'#youtube.uploader#'
	)
</cfquery>
</cfif>
</cfloop>
</cfloop>


