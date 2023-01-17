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

<cfhttp url="https://graph.facebook.com/search?q=#search#&type=post" method="get" result="result"></cfhttp>
<cfset content2 = result.fileContent.toString()>
<cfset content2 = replace(content2,'â€™','','all')>
<cfset content2 = replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(content2,'Ã¶','*bk*','all'),'Ä±','*ob*','all'),'ÅŸ','*we4','all'),'Ä°','*123*','all'),'ÄŸ','*qwe','all'),'Ã¼','*12q','all'),'Ã§','*pl*','all'),'Ã‡','*p*','all'),'Äž','*l*','all'),'Ã–','*n*','all'),'Åž','*v*','all'),'Ãœ','*h*','all'),'â€œ','','all'),'â€�','','all')>
<cfset content2 = replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(content2,'*bk*','ö','all'),'*ob*','ı','all'),'*we4','ş','all'),'*123*','İ','all'),'*qwe','ğ','all'),'*12q','ü','all'),'*pl*','ç','all'),'*p*','Ç','all'),'*l*','Ğ','all'),'*n*','Ö','all'),'*v*','Ş','all'),'*h*','Ü','all'),'\n','<br/>','all'),'\u003cbr /\u003e','<br/>','all')>
<cfset data = deserializeJSON(content2)>
<cfloop index="item" array="#data.data#">
	<cfset arrayAppend(results, item)>
</cfloop>
<cfloop index="x" from="1" to="#arrayLen(results)#">
		<cfset facebook=results[x]>
			<cfif isdefined("facebook.likes") and (#facebook.likes.count#) gt 0>
			<cfset comments=[]>
				<cfloop index="item" array="#facebook.likes.data#">
					<cfset arrayAppend(comments,item)>
				</cfloop>
				
				<cfloop index="y" from="1" to="#arrayLen(comments)#">
					<cfset facebook_likes=comments[y]>
					
					<cfquery name="check_comments" datasource="#dsn#">
						SELECT SOCIAL_MEDIA_ID FROM SOCIAL_MEDIA_COMMENT WHERE SOCIAL_MEDIA_ID='#facebook.id#' AND USER_ID='#facebook_likes.id#'	
					</cfquery>
					<cfif check_comments.recordcount eq 0>
						<cfset date1_= dateformat(listgetat(facebook.updated_time,1,'T'),dateformat_style)>
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
									'Bunu Beğendi',
									'#facebook.id#',
									<cfif isdefined ("facebook_likes.name")>#sql_unicode()#'#facebook_likes.name#'<cfelse></cfif>,
									null,
									<CFQUERYPARAM cfsqltype="cf_sql_date" VALUE="#date1_#">,
									<cfif isdefined ("facebook_likes.id")>'#facebook_likes.id#'<cfelse><cfdump var="#facebook_likes#"><cfabort></cfif>
								)
						</cfquery>
					</cfif>
				</cfloop>
			</cfif>
		<cfquery name="check" datasource="#dsn#">
		 SELECT SOCIAL_MEDIA_ID FROM SOCIAL_MEDIA_REPORT WHERE SITE='facebook' and SOCIAL_MEDIA_ID='#facebook.id#'
		</cfquery>
		<cfif check.recordcount eq 0>
			<cfset date1_ = dateformat(listgetat(facebook.created_time,1,'T'),dateformat_style)>
			<cf_date tarih="date1_">
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
					'#facebook.id#',
					'/images/male.jpg',
					#sql_unicode()#'#facebook.from.name#',
					<CFQUERYPARAM cfsqltype="cf_sql_date" VALUE="#date1_#">,
					<cfif isdefined("facebook.description")>#sql_unicode()#'#facebook.description#'<cfelseif isdefined("facebook.name")>#sql_unicode()#'#facebook.name#'<cfelseif isdefined("facebook.message")>#sql_unicode()#'#facebook.message#'</cfif>,
					'#search#',

					'facebook',
					#get_process_types.ROW_ID#,
					1,
					<cfif isdefined("facebook.link")>'#facebook.link#'<cfelse>null</cfif>,
					'#facebook.from.id#'
				)				
			</cfquery>
		</cfif>
	</cfloop>
</cfloop>

