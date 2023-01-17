<cfquery name="get_images" datasource="#DSN#" maxrows="1">
  select * from content_banners where 
  	CONTENT_ID = #attributes.cid#
	AND
	START_DATE <= #NOW()#
ORDER BY
	START_DATE DESC
</cfquery>

<cfif not get_images.RECORDCOUNT>   
         <cfquery name="get_chapter_contantcat" datasource="#DSN#">
		  SELECT 
		  	CC.CONTENTCAT_ID,
			CH.CHAPTER_ID
		  FROM
			CONTENT_CHAPTER CH,
			CONTENT_CAT CC,
			CONTENT C
		  WHERE
		  	C.CHAPTER_ID = CH.CHAPTER_ID
			AND
			CH.CONTENTCAT_ID = CC.CONTENTCAT_ID
			AND
			CONTENT_ID = #attributes.cid# 
		</cfquery>
			   
	   <cfquery name="get_images" datasource="#DSN#" maxrows="1">
		  select * from content_banners where 
			CHAPTER_ID = #get_chapter_contantcat.CHAPTER_ID#
			AND
			START_DATE <= #NOW()#
		ORDER BY
			START_DATE DESC
	   </cfquery>
	<cfif not get_images.RECORDCOUNT>
	 <cfquery name="get_images" datasource="#DSN#" maxrows="1">
		  select * from content_banners where 
			CONTENTCAT_ID = #get_chapter_contantcat.CONTENTCAT_ID#
			AND
			START_DATE <= #NOW()#
		ORDER BY
			START_DATE DESC
	 </cfquery>
	</cfif>     
</cfif>