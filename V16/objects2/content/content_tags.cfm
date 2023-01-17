<cfquery name="GET_KEYWORDS" datasource="#DSN#" maxrows="20">
	SELECT 
		KEYWORD,
		COUNT(CONTENT_KEYWORD_ID) TOTAL
	FROM 
		CONTENT_KEYWORDS
	GROUP BY
		KEYWORD
	ORDER BY
		TOTAL DESC
</cfquery>

<cfset total_keyword_contents = 0>
<cfloop query="get_keywords">
	<cfset total_keyword_contents = total_keyword_contents + total>
</cfloop>
<div style="width:100%; text-align:left">
	<cfoutput query="get_keywords">
		<cfset rate = total / total_keyword_contents>
		<cfif rate gte 0.8>
			<cfset fnt_size = 18> 
		<cfelseif rate gte 0.6>
			<cfset fnt_size = 16> 
		<cfelseif rate gte 0.4>
			<cfset fnt_size = 14> 
		<cfelseif rate gte 0.2>
			<cfset fnt_size = 12> 
        <cfelse>
			<cfset fnt_size = 10>         
		</cfif> 
		<a href="#request.self#?fuseaction=#attributes.fuseaction#&keyword=#keyword#" style="font-size:#fnt_size#px;">#keyword#</a>
	</cfoutput>
</div>
