<cfif find("scorm_engine/course", cgi.QUERY_STRING)>
    <cflocation url="%SystemDrive%\inetpub\custerr\<LANGUAGE-TAG>\404.htm">
    <cfabort>
</cfif>
<cfset user_friendly_="">
<cfset is_error_ = 0>
<cfif not structIsEmpty(url)>
	<cfset user_friendly_=replace(cgi.QUERY_STRING,'#cgi.server_name#','*>')>
	<cfset user_friendly_=listLast(user_friendly_,'*>')>
	<cfset oku_ = find('/',user_friendly_)>
</cfif>
<cfif user_friendly_ contains '?'>
	<cfset user_friendly_ = ListFirst(user_friendly_,'?')>
<cfelse>
	<cfset user_friendly_ = user_friendly_>
</cfif>
<cfif user_friendly_ neq "">
	<cfset user_friendly_ = mid(user_friendly_,oku_ + 1,len(user_friendly_))>
	<cfinclude template="fbx_workcube_param.cfm" />
	<cfset this_control_str_ = cgi.QUERY_STRING>
	<cfset reserved_words = 'select,update,*,delete,insert,drop,alter,where,truncate,create,top,char,db,table,database,script,coloum,declare,exec,cast'>
	<cfset error_count_ = 0>
	<cfloop from='1' to="#listlen(reserved_words,',')#" index='i'>
		<cfif this_control_str_ contains '#ListGetAt(reserved_words,i,',')#' or this_control_str_ contains '#ucase(ListGetAt(reserved_words,i,','))#'>
			<cfset error_count_ = error_count_ + 1>
			<cfset attributes.fuseaction=user_friendly_>
			<cfif error_count_ gt 1>
				<cfset hata=11>
				<cfset hata_mesaj = "Özel Tanımlı Sayfa Adresi Güvenlik Sorunları İçermektedir!Lütfen Tanımınızı Değiştiriniz!">
				<cfinclude template='dsp_hata.cfm'>
				<cfabort>
			</cfif>
		</cfif>
	</cfloop>
	
    <cfquery name="GET_THIS_FACTION" datasource="#DSN#">
        SELECT ACTION_ID, FUSEACTION FROM USER_FRIENDLY_URLS WHERE USER_FRIENDLY_URL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#user_friendly_#">
    </cfquery>
	
    <cfif get_this_faction.recordcount eq 1 <!---and (not isdefined('comp_id') or (isdefined('comp_id') and comp_id eq get_content.company_id))--->>
		<cfif listfindnocase(worknet_url,'#cgi.http_host#',';')>
			<cfset GetPageContext().Forward("index.cfm?fuseaction=#replace(GET_THIS_FACTION.FUSEACTION,'objects2.','worknet.','all')#")>
		<cfelse>
			<cfset GetPageContext().Forward("index.cfm?fuseaction=#GET_THIS_FACTION.FUSEACTION#")>
		</cfif>
	<cfelseif listfindnocase(worknet_url,'#cgi.http_host#',';')>
		<cfset xmlFileName = replace(cgi.http_host,'.','','all')>
		<cfset XmlFileName = "#GetDirectoryFromPath(GetCurrentTemplatePath())#worknet#dir_seperator#xml#dir_seperator##xmlFileName#.xml">
		
		<cfset MyDocument = ''>
		<cfif FileExists("#XmlFileName#")>
			<cffile action="read" file="#XmlFileName#" variable="XmlDosyam" charset="UTF-8">
			<cfscript>
				 Dosyam = XmlParse(XmlDosyam);
				 MyDocument = Dosyam.worknet_objects[1];
			</cfscript>
			<cfloop index="xx" from="1" to="#ArrayLen(MyDocument.XmlChildren)#">
				<cfset fuseaction_name_ = Evaluate('MyDocument.XmlChildren[xx].XmlChildren[4].XmlText')>
				<cfset fuseaction_userfriendly_ = Evaluate('MyDocument.XmlChildren[xx].XmlChildren[5].XmlText')>
				<cfif user_friendly_ is '#fuseaction_userfriendly_#'>
					<cfset GetPageContext().Forward("index.cfm?fuseaction=#fuseaction_name_#")>
					<cfbreak>
				<cfelse>
					<cfset is_error_ = 1>
				</cfif>			
			</cfloop>
		<cfelse>
			<cfset is_error_ = 1>
		</cfif>
    <cfelse> 
    	<cfif cgi.QUERY_STRING contains 'newsletter+seminer(1)'>
        	<img src="http://ww.workcube/documents/content/Image/newsletter_seminer(1).png" />
            <cfabort>
        </cfif>
        <cfif is_error_ eq 0>
            <cfquery name="GET_SITE_PAGE" datasource="#DSN#" maxrows="1">
                SELECT 
                    MMS.SELECTED_LINK 
                FROM 
                    MAIN_MENU_SELECTS MMS,
                    MAIN_MENU_SETTINGS MM
                WHERE 
                    MMS.MENU_ID = MM.MENU_ID AND
                    MMS.SELECTED_LINK = <cfqueryparam cfsqltype="cf_sql_varchar" value="#user_friendly_#"> AND 
                <cfif isdefined("session.ww.menu_id") and len(session.ww.menu_id)>
                    MMS.MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.menu_id#">
                <cfelseif isdefined("session.pp.menu_id") and len(session.pp.menu_id)>
                    MMS.MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.menu_id#">
                <cfelse>
                    MM.IS_ACTIVE = 1 AND 
                    MM.SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.http_host#">
                </cfif>
            </cfquery>
              
            <cfif get_site_page.recordcount>
                <cfset GetPageContext().Forward("index.cfm?fuseaction=objects2.user_friendly&user_friendly_url=#user_friendly_#")>
            <cfelse>
                <cfquery name="GET_SITE_PAGE" datasource="#DSN#" maxrows="1">
                    SELECT 
                        MMS.SELECTED_LINK 
                    FROM 
                        MAIN_MENU_LAYER_SELECTS MMS,
                        MAIN_MENU_SETTINGS MM
                    WHERE 
                        MMS.MENU_ID = MM.MENU_ID AND
                        MMS.SELECTED_LINK = '#user_friendly_#' AND 
                    <cfif isdefined("session.ww.menu_id") and len(session.ww.menu_id)>
                        MMS.MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.menu_id#">
                    <cfelseif isdefined("session.pp.menu_id") and len(session.pp.menu_id)>
                        MMS.MENU_ID = #session.pp.menu_id#
                    <cfelse>
                        MM.IS_ACTIVE = 1 AND 
                        MM.SITE_DOMAIN = '#cgi.http_host#'
                    </cfif>
                </cfquery>
                <cfif get_site_page.recordcount>
                    <cfset GetPageContext().Forward("index.cfm?fuseaction=objects2.user_friendly&user_friendly_url=#user_friendly_#")>
                <cfelse>
                    <cfquery name="GET_SITE_PAGE" datasource="#DSN#" maxrows="1">
                        SELECT 
                            MMS.SELECTED_LINK 
                        FROM 
                            MAIN_MENU_SUB_SELECTS MMS,
                            MAIN_MENU_SETTINGS MM
                        WHERE 
                            MMS.MENU_ID = MM.MENU_ID AND
                            MMS.SELECTED_LINK = '#user_friendly_#' AND 
                        <cfif isdefined("session.ww.menu_id") and len(session.ww.menu_id)>
                            MMS.MENU_ID = #session.ww.menu_id#
                        <cfelseif isdefined("session.pp.menu_id") and len(session.pp.menu_id)>
                            MMS.MENU_ID = #session.pp.menu_id#
                        <cfelse>
                            MM.IS_ACTIVE = 1 AND 
                            MM.SITE_DOMAIN = '#cgi.http_host#'
                        </cfif>
                    </cfquery>
                    <cfif get_site_page.recordcount>
                        <cfset GetPageContext().Forward("index.cfm?fuseaction=objects2.user_friendly&user_friendly_url=#user_friendly_#")>
                    <cfelse>
                        <cfset is_error_ = 1>
                    </cfif>							
                </cfif>
            </cfif>
        </cfif>
    </cfif>
<cfelse>
	<cfset is_error_ = 1>
</cfif>
<cfif is_error_ eq 1>
	<cfset attributes.fuseaction=user_friendly_>
	<cfset hata=11>
	<cfset session.ep.errorType = 1>
    <cfset session.ep.error = 2347>
	<cfset attributes.is_hata_mail=0>
	<cfset hata_mesaj = "Hatalı Sayfa İsteği!">
	<cfinclude template='error.cfm'>
	<cfabort>
</cfif>
