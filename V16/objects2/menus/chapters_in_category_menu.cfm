<cfif isdefined("attributes.chapter_coloum_number") and len(attributes.chapter_coloum_number)>
	<cfparam name="attributes.chapter_coloum_number" default="#attributes.chapter_coloum_number#">
<cfelse>
	<cfparam name="attributes.chapter_coloum_number" default="1">
</cfif>

<cfquery name="GET_CONTENTCHAPTERS" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		CONTENT_CHAPTER
	WHERE
		CONTENT_CHAPTER_STATUS = 1 AND
		CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CONTENTCAT_ID#">
	ORDER BY 
		HIERARCHY 
</cfquery>
<cfset this_row_ = 0>
<table border="0" cellspacing="2" cellpadding="1" style="width:98%">
	<cfoutput query="get_contentchapters">
		<cfset this_row_ = this_row_ + 1>
		<cfif this_row_ mod attributes.chapter_coloum_number eq 1><tr></cfif>
		  <td class="headbold"><a href="#request.self#?fuseaction=objects2.view_content_category&cat_id=#attributes.CONTENTCAT_ID#&chid=#get_contentchapters.chapter_id#" class="headbold">#GET_CONTENTCHAPTERS.CHAPTER#</a></td>
		<cfif this_row_ mod attributes.chapter_coloum_number eq 0></tr></cfif>
	</cfoutput>
</table>
