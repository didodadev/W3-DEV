<table>
<cfif isdefined("attributes.contentcat_id")>
	<cfquery name="GET_CHAPTER" datasource="#dsn#">
		SELECT * FROM CONTENT_CHAPTER WHERE CONTENTCAT_ID=#attributes.CONTENTCAT_ID# ORDER BY HIERARCHY 
	</cfquery> 
	
	<cfquery name="GET_CAT" datasource="#dsn#">
		SELECT CONTENTCAT FROM CONTENT_CAT WHERE CONTENTCAT_ID=#attributes.CONTENTCAT_ID#
	</cfquery> 
	<tr> 
	<td width="10"><img src="/images/arrow_blue.gif"></td>
		<td  clasS="label" height="20"><cfoutput>#get_cat.contentcat#</cfoutput></td>
	</tr>	  
	<cfoutput query="get_chapter">
	<tr> 
		<td width="10"><img src="/images/arrow_org.gif"></td>
		<td width="99%"> <a href="#request.self#?fuseaction=rule.view_chapter&chapter_id=#chapter_id#&contentcat_id=#attributes.CONTENTCAT_ID#" class="tableyazi">#CHAPTER#</a> </td>
	</tr>
	</cfoutput>
  
<cfelseif isdefined("url.cid")>

	<cfquery name="GET_CHAPTER" datasource="#dsn#">
		SELECT 	CH.CHAPTER, CH.CHAPTER_ID, CC.CONTENTCAT_ID, CC.CONTENTCAT FROM CONTENT_CAT CC, CONTENT_CHAPTER CH 
		WHERE 	
			CC.CONTENTCAT_ID = CH.CONTENTCAT_ID AND				
			CC.CONTENTCAT_ID = (SELECT CH.CONTENTCAT_ID FROM CONTENT_CHAPTER CH , CONTENT C
								WHERE C.CONTENT_ID = #URL.CID# AND
								CH.CHAPTER_ID = C.CHAPTER_ID)		
			ORDER BY CH.HIERARCHY
	</cfquery>
	
	  <tr> 
	  <td width="10"><img src="/images/arrow_blue.gif"></td>
		<td height="20"><cfoutput>#get_chapter.contentcat#</cfoutput></td>
	  </tr>
	  <cfoutput query="get_chapter">
		  <tr> 
			<td width="10"><img src="/images/arrow_org.gif"></td>
			<td width="99%"> <a href="#request.self#?fuseaction=rule.view_chapter&chapter_id=#chapter_id#&contentcat_id=#contentcat_id#" class="tableyazi">#CHAPTER#</a> </td>
		  </tr>
	  </cfoutput>
	  
<cfelseif isdefined("attributes.is_home")>

	<cfquery name="GET_CAT" datasource="#dsn#">
		SELECT CONTENTCAT,CONTENTCAT_ID FROM CONTENT_CAT WHERE IS_RULE = 1 AND LANGUAGE_ID = '#SESSION.EP.LANGUAGE#'
	</cfquery> 	
	<cfif GET_CAT.recordcount>
		<cfquery name="GET_CHAPTER" datasource="#dsn#">
			SELECT * FROM CONTENT_CHAPTER WHERE CONTENTCAT_ID=#GET_CAT.CONTENTCAT_ID# ORDER BY HIERARCHY 
		</cfquery> 
		<tr> 
		<td width="10"><img src="/images/arrow_blue.gif"></td>
			<td height="20"><cfoutput>#get_cat.contentcat#</cfoutput></td>
		</tr>	  
		<cfoutput query="get_chapter">
		<tr> 
			<td width="10"><img src="/images/arrow_org.gif"></td>
			<td width="99%"> <a href="#request.self#?fuseaction=rule.view_chapter&chapter_id=#chapter_id#&contentcat_id=#GET_CAT.CONTENTCAT_ID#" class="tableyazi">#CHAPTER#</a> </td>
		</tr>
		</cfoutput>
	</cfif>  

</cfif>
</table>
