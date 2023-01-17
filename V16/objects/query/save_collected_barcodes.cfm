<cfsetting showdebugoutput="no">
<cfscript>
CRLF = Chr(13) & Chr(10);
</cfscript>
<cfset liste="">
<cfheader name="Expires" value="#Now()#">
<cfcontent type="text/plain;charset=utf-8">
<cfheader name="Content-Disposition" value="attachment; filename=sube">
<cfoutput>
<cfloop from="1" to="#listlen(attributes.barcode)#" index="i">
<cftry>
	#listgetat(attributes.barcode,i)#,#listgetat(attributes.barcode_count,i)#,#listgetat(attributes.name,i)##CRLF#
	<cfcatch type="Any">
		<cfset liste = listappend(liste,listgetat(attributes.barcode,i),',')>
	</cfcatch>
	 </cftry>
</cfloop>
<cfif listlen(liste)>
	 <br/><font class="txtbold">Hatalı Kayıtlar:</font><br/>
	<cfloop list="#liste#" index="j">
		#j#,#CRLF#
	</cfloop> 
</cfif>
</cfoutput>
