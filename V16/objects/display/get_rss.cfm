<cffunction name="create_rss" returntype="any">
	<cfargument name="file_name" type="string" default="">
	<cfargument name="query" type="query">	
		<cfset myStruct = StructNew() />
		<cfset mystruct.link = "http://ep.workcube/" />
		<cfset myStruct.title = "Messages" />
		<cfset mystruct.description = "Messages RSS Example" />
		<cfset mystruct.pubDate = Now() />
		<cfset mystruct.version = "rss_2.0" />
		<cfset myStruct.item = ArrayNew(1) />
		<cfset i=1>
       	<cfoutput query="query">
		<!--- Bu satırlar veritabanından getirilecek --->
			<cfset myStruct.item[i] = StructNew() />
			<cfset myStruct.item[i].guid = structNew() />
			<cfset myStruct.item[i].guid.isPermaLink="YES" />
			<cfset myStruct.item[i].guid.value = 'http://ep.workcube/index.cfm?fuseaction=sales.form_upd_opportunity&opp_id=#ID#' />
			<cfset myStruct.item[i].pubDate = "#DateFormat(DATE, "ddd, dd mmm yyyy")# #TimeFormat(DATE, "hh:mm:ss")#"/>
			<cfset myStruct.item[i].title = "#HEAD#" />
			<cfset myStruct.item[i].description = StructNew() />
			<cfset myStruct.item[i].description.value = "#DETAIL#" />
			<cfset myStruct.item[i].link = 'http://ep.workcube/index.cfm?fuseaction=sales.form_upd_opportunity&opp_id=#ID#' />			
			<cfset i++>
		</cfoutput>	
		<cfoutput>#file_web_path#rss/#file_name#.xml</cfoutput>
       <cffeed action="create" name="#myStruct#" overwrite="true" xmlVar="myXML" outputFile ="#upload_folder#rss/#file_name#.xml"/>
</cffunction>
