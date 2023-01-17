<!---session'daki değerler için kapıtıldı OS 20130625
<cfif isdefined('session.pda.screen_width')>
	<cfif isdefined('attributes.screen_width')>
		<cfset session.pda.screen_width = attributes.screen_width>
	<cfelse>
		<cfset action_page = "#request.self#?#cgi.query_string#">
		<form name="form_login" id="form_login" method="post" action="<cfoutput>#action_page#</cfoutput>">
			<input type="hidden" name="screen_width" id="screen_width">
		</form>
		<script type="text/javascript">
			if(window.screen.width > '#session.pda.screen_width#')
				screen_width = '#session.pda.screen_width#';
			else
				screen_width = window.screen.width;
				
			if(screen_width - 10 != <cfoutput>#session.pda.screen_width#</cfoutput>)
			{
				form_login.screen_width.value = screen_width -10;
				form_login.submit();			
			}
		</script>	
	</cfif>	
</cfif>--->
<cfquery name="GET_MAIN_MENU_SETTINGS" datasource="#DSN#">
	SELECT 
		LOGO_FILE, 
		IS_LOGO, 
		IS_FLASH_LOGO,
		LOGO_HEIGHT,
		LOGO_WIDTH,
		LOGO_FILE_SERVER_ID,
		MENU_ID, 
		GENERAL_WIDTH, 
		GENERAL_WIDTH_TYPE, 
		OUR_COMPANY_ID, 
        SECOND_FILE,
        SECOND_HEIGHT,
		MAIN_HEIGHT 
	FROM 
		MAIN_MENU_SETTINGS 
	WHERE 
		SITE_TYPE = 4 AND 
		IS_ACTIVE = 1  AND 
		SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.http_host#">
</cfquery>
<cfif not get_main_menu_settings.recordcount>
	Bu Sistem İçin Pda Portal Tanımı Yapılmamış!
	<cfexit method="exittemplate">
<cfelse>
	<cfquery name="GET_PDA_LINKS" datasource="#DSN#">
		SELECT SELECTED_LINK, LINK_IMAGE, LINK_NAME FROM MAIN_MENU_SELECTS WHERE MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_main_menu_settings.menu_id#"> AND IS_SESSION = 0 ORDER BY ORDER_NO
	</cfquery>
	<cfoutput>
    <!---Pda modülü için uzunluk 320px belirtildi  OS 20130625--->
	<table cellspacing="1" cellpadding="2" class="color-border" <cfif len(get_main_menu_settings.general_width)><cfoutput>style="height:98%; width:#get_main_menu_settings.general_width##get_main_menu_settings.general_width_type#;"</cfoutput><cfelse>style="height:98%; width:320px;"</cfif>>
		<tr class="color-header" style="height:#get_main_menu_settings.main_height#px;">
			<td class="form-title">
				<table cellpadding="2" cellspacing="1" style="width:100%">
					<tr>
						<td nowrap="nowrap" style="width:#get_main_menu_settings.logo_width#px;">
							<cfif len(get_main_menu_settings.logo_file)>
								<cfinclude template="../../design/dynamic_menu_logo.cfm">
							<cfelse>	
								<a href="#request.self#?fuseaction=pda.popup_welcome"><img src="/images/logo_pda.gif" align="absmiddle" border="0"><font color="FFFFFF"><b> Workcube PDA</b></font></a>
							</cfif>
						</td>
						<cfif ListLen(pda_url,';') gt 1>
							<td><cfquery name="GET_OUR_COMPANY_NAME" datasource="#DSN#">
									SELECT NICK_NAME FROM OUR_COMPANY WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(pda_companies,listfindnocase(pda_url,cgi.http_host,';'),';')#">
								</cfquery>
								<font color="red">#Left(get_our_company_name.nick_name,14)#</font> 
							</td>
						</cfif>
						<td align="right" style="color:white;">
							<a href="#request.self#?fuseaction=pda.popup_welcome" class="upper_menu_link">Anasayfa</a>  <font class="upper_menu_link">||</font> <a href="#request.self#?fuseaction=home.logout" class="upper_menu_link">Çıkış</a>
						</td>
					</tr>
				</table>			
			</td>
		</tr>
        <cfif len(get_main_menu_settings.second_file)>
        	<tr style="height:#get_main_menu_settings.second_height#px;">
            	<td class="color-list"><cfinclude template="../../#get_main_menu_settings.second_file#"></td>
            </tr>
        <cfelse>
            <tr>
                <td class="color-list">
                    <table cellspacing="1" cellpadding="1" style="width:100%;" align="left">
                        <tr nowrap>
                            <cfloop query="get_pda_links"><!--- Ana Menu Imajlari Goruntuleniyor --->
                                <td><a href="#request.self#?fuseaction=#selected_link#"><img src="/documents/settings/#link_image#" align="absmiddle" border="0" title="#link_name#"></a></td>
                            </cfloop>
                        </tr>
                    </table>
                </td>
            </tr>
		</cfif>        
		<tr class="color-row">
			<td style="vertical-align:top;height:100%;width:100%"><div id="#fusebox.circuit#">#fusebox.layout#</div></td>
		</tr>  
	</table>
	</cfoutput>
</cfif>

