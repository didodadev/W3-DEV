<cfsetting showdebugoutput="no">
<cfhttp url="http://#attributes.my_url#" method="get" resolveURL="yes"></cfhttp>
<cfoutput>#cfhttp.fileContent#</cfoutput>

