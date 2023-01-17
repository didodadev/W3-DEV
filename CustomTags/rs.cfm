<!---
Server daki application degerlerini yeniden olusturmak icin 
20020824-20041118
--->
<cfif isDefined("session.ep.userid")>
	<cfif isDefined("attributes.start") and attributes.start eq 1>
		<cftry>
			<cfquery name="DEL_SESSIONS" datasource="#CALLER.DSN#">
				DELETE FROM WRK_SESSION
			</cfquery>
			<cfif isdefined("session")>
				<cfloop collection="#session#" item="key_field">
					<cfset temp = StructDelete(session, key_field)>
				</cfloop>
			</cfif>
			<cfcatch>
				<!--- hata olmussa hangi degerler hala ayakta bakalim --->
				<cfloop collection="#session#" item="k">
					<cfoutput>#k#</cfoutput>
				</cfloop>
			</cfcatch>
		</cftry>
	</cfif>
</cfif>
<cflocation url="#request.self#?fuseaction=myhome.welcome" addtoken="No">
<cfabort>
