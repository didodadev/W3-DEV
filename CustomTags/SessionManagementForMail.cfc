<cfcomponent>
	
	<cffunction name="CreateASessionForMailInterface" returntype="numeric" output="false">
		<cfargument name="ASPNetSessionManager" required="yes" type="string" hint="Örn: http://mail.benimexperim.com/enterprise/lang/en/Forms/mycube/SESSIONMANAGEMENT.ASPX"/>
		<cfargument name="PostofficeName" required="yes" type="string" hint="MailEnable GUI'sinde ağaçta görünen isim. Örn: benimexperim.com"/>
		<cfargument name="PostOfficeDirectory" required="yes" type="string" hint="Örn: D:\Program Files\Mail Enable\POSTOFFICES\benimexperim.com"/>
		<cfargument name="Password" required="yes" type="string" hint="Hash'lenmiş parola. Örn: ASDFASDFASDFASDF3245ASDFASF"/>
		<cfset var RequestProxy = CreateObject("component", "RequestProxy")/>
		<cfset var RequestProxyResult = RequestProxy.Request(Url="#Arguments.ASPNetSessionManager#?lang=en&skin=/enterprise/skins/Enterprise/&AUTH_USERNAME=#Arguments.UserName#&AUTH_PASSWORD=#Arguments.Password#&AUTH_RIGHTS=USER&AUTH_ACCOUNT=#Arguments.PostofficeName#&POSTOFFICE=#Arguments.PostofficeName#&VALID=True&POSTOFFICE_ROOT_PATH=#Arguments.PostOfficeDirectory#&offset=-180&MessagePreview=1&UseDeletedItemsFolder=1&MessagesPerPage=50&HTML_BODY_CHARSET=&HTML_BODY")/>

		<cfreturn 1/>
	</cffunction>
</cfcomponent>

