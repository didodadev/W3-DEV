		
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
<cfhttp url="https://www.googleapis.com/plus/v1/activities?query=#search#&language=tr&orderBy=recent&pp=1&key=AIzaSyBPOnHCeTJFVkvf_573fgnzARxK056PuE4" result="result"></cfhttp>
<cfset content2 = result.fileContent.tostring()>
<cfset content2 = replace(content2,'â€™','','all')>
<cfset content2 = replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(content2,'Ã¶','*bk*','all'),'Ä±','*ob*','all'),'ÅŸ','*we4','all'),'Ä°','*123*','all'),'ÄŸ','*qwe','all'),'Ã¼','*12q','all'),'Ã§','*pl*','all'),'Ã‡','*p*','all'),'Äž','*l*','all'),'Ã–','*n*','all'),'Åž','*v*','all'),'Ãœ','*h*','all'),'â€œ','','all'),'â€�','','all')>

<cfset content2 = replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(content2,'*bk*','ö','all'),'*ob*','ı','all'),'*we4','ş','all'),'*123*','İ','all'),'*qwe','ğ','all'),'*12q','ü','all'),'*pl*','ç','all'),'*p*','Ç','all'),'*l*','Ğ','all'),'*n*','Ö','all'),'*v*','Ş','all'),'*h*','Ü','all'),'\n','<br/>','all'),'\u003cbr /\u003e','<br/>','all')>
<cfset data = deserializeJSON(content2)>
<cfloop index="item" array="#data.items#">
	<cfset arrayAppend(results,item)>
</cfloop>
<cfloop index="x" from="1" to="#arrayLen(results)#">
<cfset google1=results[x]>
	<cfif google1.object.replies.totalItems gt 0>	
		<cfhttp method="get"  url="https://www.googleapis.com/plus/v1/activities/#google1.id#/comments?alt=json&pp=1&key=AIzaSyBPOnHCeTJFVkvf_573fgnzARxK056PuE4" result="result">
		</cfhttp>
		<cfset content2 = result.fileContent.tostring()>
		<cfset content2 = replace(content2,'â€™','','all')>
		<cfset content2 = replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(content2,'Ã¶','*bk*','all'),'Ä±','*ob*','all'),'ÅŸ','*we4','all'),'Ä°','*123*','all'),'ÄŸ','*qwe','all'),'Ã¼','*12q','all'),'Ã§','*pl*','all'),'Ã‡','*p*','all'),'Äž','*l*','all'),'Ã–','*n*','all'),'Åž','*v*','all'),'Ãœ','*h*','all'),'â€œ','','all'),'â€�','','all')>
		<cfset content2 = URLDecode(content2)>
		<cfset content2 = replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(content2,'*bk*','ö','all'),'*ob*','ı','all'),'*we4','ş','all'),'*123*','İ','all'),'*qwe','ğ','all'),'*12q','ü','all'),'*pl*','ç','all'),'*p*','Ç','all'),'*l*','Ğ','all'),'*n*','Ö','all'),'*v*','Ş','all'),'*h*','Ü','all'),'\n','<br/>','all'),'\u003cbr /\u003e','<br/>','all')>
		<cfset data = deserializeJSON(content2)>
			<cfloop index="item" array="#data.items#">
				<cfset arrayAppend(comments,item)>
			</cfloop>
			
			<cfloop index="y" from="1" to="#arrayLen(comments)#">
				<cfset google1_comments=comments[y]>
					<cfquery name="kontrol_kayit" datasource="#dsn#">
						SELECT SOCIAL_MEDIA_COMMENT_ID FROM SOCIAL_MEDIA_COMMENT WHERE SOCIAL_MEDIA_COMMENT_ID='#google1_comments.id#'
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
											#sql_unicode()#'#google1_comments.object.content#',
											'#google1.id#',
											#sql_unicode()#'#google1_comments.actor.displayName#',
											'#google1_comments.id#',
											'#google1_comments.published#',
											'#google1_comments.actor.id#'
										)		
							</cfquery>
					</cfif>
			</cfloop>
	</cfif>	
<cfquery name="check" datasource="#dsn#">
 SELECT SOCIAL_MEDIA_ID 
 FROM SOCIAL_MEDIA_REPORT 
 WHERE SITE='google plus' and SOCIAL_MEDIA_ID='#google1.id#'
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
		'#google1.id#',
		'#google1.actor.image.url#',
		#sql_unicode()#'#google1.actor.displayName#',
		 substring('#google1.published#',1,10), 
		#sql_unicode()#'#google1.object.content#',
		'#search#',
		'google plus',
		#get_process_types.ROW_ID#,
		1,
		'#google1.object.url#',
		'#google1.actor.id#'
	)
</cfquery>
</cfif>
</cfloop>
</cfloop>


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
<cfhttp url="https://www.googleapis.com/plus/v1/activities?query=#search#&orderBy=best&pp=1&key=AIzaSyBPOnHCeTJFVkvf_573fgnzARxK056PuE4" result="result"></cfhttp>
<cfset content2 = result.fileContent.tostring()>
<cfset content2 = replace(content2,'â€™','','all')>
<cfset content2 = replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(content2,'Ã¶','*bk*','all'),'Ä±','*ob*','all'),'ÅŸ','*we4','all'),'Ä°','*123*','all'),'ÄŸ','*qwe','all'),'Ã¼','*12q','all'),'Ã§','*pl*','all'),'Ã‡','*p*','all'),'Äž','*l*','all'),'Ã–','*n*','all'),'Åž','*v*','all'),'Ãœ','*h*','all'),'â€œ','','all'),'â€�','','all')>
<cfset content2 = replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(content2,'*bk*','ö','all'),'*ob*','ı','all'),'*we4','ş','all'),'*123*','İ','all'),'*qwe','ğ','all'),'*12q','ü','all'),'*pl*','ç','all'),'*p*','Ç','all'),'*l*','Ğ','all'),'*n*','Ö','all'),'*v*','Ş','all'),'*h*','Ü','all'),'\n','<br/>','all'),'\u003cbr /\u003e','<br/>','all')>
<cfset data = deserializeJSON(content2)>
<cfloop index="item" array="#data.items#">
	<cfset arrayAppend(results,item)>
</cfloop>
<cfloop index="x" from="1" to="#arrayLen(results)#">
<cfset google1=results[x]>
	<cfif google1.object.replies.totalItems gt 0>	
		<cfhttp method="get"  url="https://www.googleapis.com/plus/v1/activities/#google1.id#/comments?alt=json&pp=1&key=AIzaSyBPOnHCeTJFVkvf_573fgnzARxK056PuE4" result="result">
		</cfhttp>
		<cfset content2 = result.fileContent.tostring()>
		<cfset content2 = replace(content2,'â€™','','all')>
		<cfset content2 = replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(content2,'Ã¶','*bk*','all'),'Ä±','*ob*','all'),'ÅŸ','*we4','all'),'Ä°','*123*','all'),'ÄŸ','*qwe','all'),'Ã¼','*12q','all'),'Ã§','*pl*','all'),'Ã‡','*p*','all'),'Äž','*l*','all'),'Ã–','*n*','all'),'Åž','*v*','all'),'Ãœ','*h*','all'),'â€œ','','all'),'â€�','','all')>
		<cfset content2 = URLDecode(content2)>
		<cfset content2 = replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(content2,'*bk*','ö','all'),'*ob*','ı','all'),'*we4','ş','all'),'*123*','İ','all'),'*qwe','ğ','all'),'*12q','ü','all'),'*pl*','ç','all'),'*p*','Ç','all'),'*l*','Ğ','all'),'*n*','Ö','all'),'*v*','Ş','all'),'*h*','Ü','all'),'\n','<br/>','all'),'\u003cbr /\u003e','<br/>','all')>
		<cfset data = deserializeJSON(content2)>
			<cfloop index="item" array="#data.items#">
				<cfset arrayAppend(comments,item)>
			</cfloop>
			
			<cfloop index="y" from="1" to="#arrayLen(comments)#">
				<cfset google1_comments=comments[y]>
					<cfquery name="kontrol_kayit" datasource="#dsn#">
						SELECT SOCIAL_MEDIA_COMMENT_ID FROM SOCIAL_MEDIA_COMMENT WHERE SOCIAL_MEDIA_COMMENT_ID='#google1_comments.id#'
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
											#sql_unicode()#'#google1_comments.object.content#',
											'#google1.id#',
											#sql_unicode()#'#google1_comments.actor.displayName#',
											'#google1_comments.id#',
											'#google1_comments.published#',
											'#google1_comments.actor.id#'
										)		
							</cfquery>
					</cfif>
			</cfloop>
	</cfif>	
<cfquery name="check" datasource="#dsn#">
 SELECT SOCIAL_MEDIA_ID 
 FROM SOCIAL_MEDIA_REPORT 
 WHERE SITE='google plus' and SOCIAL_MEDIA_ID='#google1.id#'
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
		'#google1.id#',
		'#google1.actor.image.url#',
		#sql_unicode()#'#google1.actor.displayName#',
		 substring('#google1.published#',1,10), 
		#sql_unicode()#'#URLDecode(google1.object.content)#',
		'#search#',
		'google plus',
		#get_process_types.ROW_ID#,
		1,
		'#google1.object.url#',
		'#google1.actor.id#'
	)
</cfquery>
</cfif>
</cfloop>
</cfloop>


	
