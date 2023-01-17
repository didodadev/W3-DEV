<cfhttp url="http://www.internethaber.com/" method="GET"></cfhttp>

<cfset finish1 = findnocase("<td width=""100%"" colspan=""2""><img src=""bosluk.gif"" width=""1"" height=""2""></td>",cfhttp.filecontent, 1)>
<cfset finish2 = findnocase("<td width=""100%"" colspan=""2""><img src=""bosluk.gif"" width=""1"" height=""2""></td>",cfhttp.filecontent, finish1+1)>
<cfset finish3 = findnocase("<td width=""100%"" colspan=""2""><img src=""bosluk.gif"" width=""1"" height=""2""></td>",cfhttp.filecontent, finish2+1)>
<cfset finish4 = findnocase("<td width=""100%"" colspan=""2""><img src=""bosluk.gif"" width=""1"" height=""2""></td>",cfhttp.filecontent, finish3+1)>
<cfset finish5 = findnocase("<td width=""100%"" colspan=""2""><img src=""bosluk.gif"" width=""1"" height=""2""></td>",cfhttp.filecontent, finish4+1)>

<cfset start1 = findnocase("<table width=""468"" cellpadding=""0"" cellspacing=""0"" border=""0"">",cfhttp.filecontent,1)>
<cfset start2 = findnocase("<table width=""468"" cellpadding=""0"" cellspacing=""0"" border=""0"">",cfhttp.filecontent,start1+1)>
<cfset start3 = findnocase("<table width=""468"" cellpadding=""0"" cellspacing=""0"" border=""0"">",cfhttp.filecontent,start2+1)>

<cfoutput>
#mid(cfhttp.filecontent,start1,finish3-start1-6)#</table>
#mid(cfhttp.filecontent,start3,finish5-start3-6)#</table>
</cfoutput>

