<cfset attributes.ip = "#CGI.REMOTE_ADDR#">
<cfset attributes.string = "#CGI.SERVER_NAME##cgi.script_name#?#cgi.QUERY_STRING#">
<cfset attributes.server = "#CGI.SERVER_NAME#">
<HTML>
	<HEAD>
		<META http-equiv='Content-Language' content='tr'>
		<META http-equiv='Content-Type' content='text/html; charset=utf-8'>
		<META http-equiv='Content-Type' content='text/html; charset=windows-1254'>
	</HEAD>
	<BODY bgcolor='CCCCCC'>

		<cfoutput>
			<cfset attributes.BUG_CIRCUIT = IsDefined("attributes.fuseaction") ? ListFirst(attributes.fuseaction,'.') : "">
			<cfset attributes.BUG_FUSEACTION = IsDefined("attributes.fuseaction") ? listlast(attributes.fuseaction,'.') : "">
			<cfset attributes.query_str = listlast(attributes.string,'?')>
			<cf_get_lang dictionary_id = "29917.Hata Oluştu">...<br/>
			<cf_get_lang dictionary_id = "29918.Hata Detayları Aşağıdadır"><br/>
			<cfif isDefined("session.ep.userid")>
				Enterprise Portal de #session.ep.position_name# pozisyonundaki #session.ep.name# #session.ep.surname# kullanıcısı aşağıdaki sayfa isteğinde bulundu.
			<cfelseif isDefined("session.pp.userid")>
				Partner Portal de #session.pp.name# #session.pp.surname# (#session.pp.company_nick#) kullanıcısı aşağıdaki sayfa isteğinde bulundu.
			<cfelseif isDefined("session.ww.userid")>
				Public Portal de #session.ww.name# #session.ww.surname# (#session.ww.our_nick#) kullanıcısı aşağıdaki sayfa isteğinde bulundu.
			<cfelseif isDefined("session.pda.userid")>
				Public Portal de #session.pda.name# #session.pda.surname# (Comp_Id:#session.pda.our_company_id# - Per_Year:#session.pda.period_year#) kullanıcısı aşağıdaki sayfa isteğinde bulundu.
			<cfelse>
				<cf_get_lang dictionary_id = "29919.Tanınmayan Kişi Hata Yaptı">...
			</cfif>
			<font face='Verdana' color='##FF0000'>http://#attributes.string# <br/></font>
			<cf_get_lang dictionary_id = "58031.Server Adı"> : #attributes.server# <br/>
			<!---<cfobject action="create" type="java" class="jrunx.kernel.JRun" name="jr">--->
			<cfset strVersion = SERVER.ColdFusion.ProductVersion />
				<cfif listfirst(strVersion) gte 10> 
					<cfset servername = createobject("component","CFIDE.adminapi.runtime").getinstancename()>
				<cfelse>
					 <cfobject action="create" type="java" class="jrunx.kernel.JRun" name="jr">
					 <cfset servername = jr.getServerName()>
				</cfif>
			Instance : #servername# <br/>
			<cf_get_lang dictionary_id = "29920.Workcube Version"> : #workcube_version# <br/>
			<cf_get_lang dictionary_id = "29921.Kullanıcı IP"> : #attributes.ip# <br/>
			<cf_get_lang dictionary_id = "30631.Tarih"> : #dateformat(now(),'dd/mm/yyyy')# #timeformat(now(),'HH:MM')# GMT<br/>
			Referer : #cgi.referer#<br/>
			<cfif isDefined("session.ep.userid")>
				<cf_get_lang dictionary_id = "58472.Dönem"> : #session.ep.company_nick# - #session.ep.PERIOD_YEAR#<br/>
			</cfif>
			<br>
			#attributes.error_mail_info#
			<br>
			<cfif isdefined("error.diagnostics")>
				Workcube<br/>
				<font face='Verdana' color='FF0000' size="1"> <cf_get_lang dictionary_id = "57541.Hata"> : #error.diagnostics#</font><br/><hr>
				<!--- 20040930 sadece cok onemli sorunlar oldugunda tum hata detaylari gelsin diye acilabilir, yoksa habersiz acilmasin
				<cfdump var="#error#"> --->
				<cfif isDefined('error.TagContext') and Arraylen(error.TagContext)><font face='Verdana' color='FF0000' size="2"> <cf_get_lang dictionary_id = "57771.Detay"> : <cfdump var="#error.TagContext[1]#"></font><br/></cfif>
				<cfif isDefined('error.RootCause') and structkeyexists(error.RootCause,'SQL')><font face='Verdana' color='FF0000' size="2"><cf_get_lang dictionary_id = "29926.Hatalı SQL"> : <br/>#error.RootCause.SQL#</font><br/></cfif>
				<cfif isDefined('error.Browser')>Browser : #error.Browser#</cfif><br/>
				<hr><br/>
			</cfif>
			<cfif isdefined("cfcatch")>
				cfcatch<br/>
				<font face='Verdana' color='FF0000' size="1">#cfcatch.message#</font><br/>
				<cfset sCurrent = #CFCATCH.TAGCONTEXT[1]#>
				#structKeyExists( sCurrent, "ID" ) ? sCurrent["ID"] : ''# (#structKeyExists( sCurrent, "LINE" ) ? sCurrent["LINE"] : ''#,#structKeyExists( sCurrent, "COLUMN" ) ? sCurrent["COLUMN"] : ''#) #structKeyExists( sCurrent, "TEMPLATE" ) ? sCurrent["TEMPLATE"] : ''#
				<hr>
				<br/>
			</cfif>
			<cfif isDefined("Exception")>
				Exception<br/>
				<font face='Verdana' color='FF0000' size="1">#StructKeyExists(Exception, "cause") ? Exception.cause.message : Exception.message#</font><br/>
				#StructKeyExists(Exception, "cause") ? Exception.cause.detail : Exception.detail# <br>
				<cfset sCurrent = StructKeyExists(Exception, "cause") ? Exception.Cause.TAGCONTEXT[1] : Exception.TAGCONTEXT[1]>
				#structKeyExists( sCurrent, "ID" ) ? sCurrent["ID"] : ''# (#structKeyExists( sCurrent, "LINE" ) ? sCurrent["LINE"] : ''#,#structKeyExists( sCurrent, "COLUMN" ) ? sCurrent["COLUMN"] : ''#) #structKeyExists( sCurrent, "TEMPLATE" ) ? sCurrent["TEMPLATE"] : ''#
				<br>
				
				<hr>
				<br/>
			</cfif>
		</cfoutput>
		<br/><font size="2">
			<br/>Parameters : <br/>
			<cfif isDefined('attributes')>
				<cfset att_list = listsort(StructKeyList(attributes,','),'text','ASC',',')>
				<cfloop list="#att_list#" index="k" delimiters=",">
					<cfif IsDefined("attributes.#k#") and not isArray(attributes[k]) and not isStruct(attributes[k]) and (k neq 'ICERIK') and (k neq 'PASSWORD') and (k neq 'CARD_NO') and (k neq 'DSP_CARD_NO')><cfoutput>#k#-#evaluate('attributes.#k#')#</cfoutput><br/></cfif>
				</cfloop>
			</cfif>
		</font>
		<br/><br/>
		<font size="2">Browser</font><br/>
		<cfoutput>#CGI.HTTP_USER_AGENT#</cfoutput>
	</BODY>
</HTML>