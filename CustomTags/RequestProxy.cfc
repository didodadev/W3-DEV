<cfcomponent>
	<cffunction name="ParseHeaderAndSetCookie" returntype="numeric" output="false">
		<cfargument name="HeaderText" required="yes" type="string"/>
		<cfset var CurrentCookieName = ListGetAt(ListGetAt(Arguments.HeaderText, 1, "="), 1, ";")/>
		<cfset var CurrentCookieValue = ListGetAt(ListGetAt(Arguments.HeaderText, 2, "="), 1, ";")/>
		<cfcookie name="#CurrentCookieName#" value="#CurrentCookieValue#" expires="never"/>
		<cfreturn 1/>
	</cffunction>
	
	<cffunction name="Request" returntype="struct" output="false">
		<cfargument name="Url" required="yes" type="string" hint="Örn: http://www.interajans.com/asdasd.aspx"/>
		<!---<cfargument name="SessionVariablesToSet" required="no" type="struct" hint="ASP.NET session'unda set edilmesi istenen değişkenler"/>--->
		<cfset var RequestProxyResult = ""/>
		<cfset var RequestProxyResultCookiesArray = ""/>
		<cfset var RequestProxyResultCookies = ""/>
		
		<cfhttp url="#Arguments.Url#" method="get" result="RequestProxyResult">
		</cfhttp>
<cfdump var="#RequestProxyResult#"/>

		<cfset RequestProxyResultCookiesArray = StructFindKey(StructGet("RequestProxyResult.Responseheader"), "Set-Cookie")/>
		
		<cfif ArrayLen(RequestProxyResultCookiesArray)>
			<cfset RequestProxyResultCookies = RequestProxyResultCookiesArray[1].value/>
			<cfif IsStruct(RequestProxyResultCookies)>
				<cfdump var="#RequestProxyResultCookies#" label="RequestProxyResultCookies"/>
				<cfloop from="1" to="#StructCount(RequestProxyResultCookies)#" index="CurrentIndex">
					<cfset ParseHeaderAndSetCookie(RequestProxyResultCookies[CurrentIndex])/>
				</cfloop>
			<cfelse>
				<cfset ParseHeaderAndSetCookie(RequestProxyResultCookies)/>
			</cfif>
		</cfif>
		
		<cfreturn RequestProxyResult/>
	</cffunction>
</cfcomponent>

