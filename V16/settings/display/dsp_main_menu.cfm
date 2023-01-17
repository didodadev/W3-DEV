<cfquery name="GET_MY_SETTINGS_" datasource="#DSN#">
	SELECT 
		MENU_ID,
		MENU_NAME
	FROM 
		MAIN_MENU_SETTINGS 
	WHERE 
		MENU_ID = #attributes.menu_id#
</cfquery>

<cfquery name="GET_LINK_1" datasource="#DSN#">
	SELECT * FROM MAIN_MENU_SELECTS WHERE LINK_AREA = -1 AND MENU_ID = #attributes.menu_id#
</cfquery>	

<cfquery name="GET_LINK_2" datasource="#DSN#">
	SELECT * FROM MAIN_MENU_SELECTS WHERE LINK_AREA = -2 AND MENU_ID = #attributes.menu_id#
</cfquery>
<cfoutput>
<cf_popup_box title="#getLang('settings',891)#: <cfoutput>#get_my_settings_.menu_name#</cfoutput>">
    <cf_area>
        <table width="99%" align="center">			
            <tr>
                <td class="txtbold"><cf_get_lang no='892.Üst Menü'></td>
            </tr>
            <tr>
                <td>
                    <cfloop query="get_link_1">
                        <img src="/images/tree_2.gif" align="absmiddle">&nbsp;
                        <cfif len(selected_link) and (listgetat(selected_link,1,'.') is 'objects2')>
                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=settings.popup_select_site_objects&faction=#selected_link#&menu_id=#menu_id#','medium');" class="tableyazi">#LINK_NAME# = #SELECTED_LINK#</a> -
                        <cfelse>
                            #link_name# = #selected_link# -
                        </cfif>
                        <cfif listFindNoCase('-3,-4,-5,-6,-7,-8',link_type,',')>
                            <cfswitch  expression="#link_type#">
                                <cfcase value="-3"><cfset popup_type = 'Small'></cfcase>
                                <cfcase value="-4"><cfset popup_type = 'Medium'></cfcase>
                                <cfcase value="-5"><cfset popup_type = 'List'></cfcase>
                                <cfcase value="-6"><cfset popup_type = 'Page'></cfcase>
                                <cfcase value="-7"><cfset popup_type = 'Project'></cfcase>
                                <cfcase value="-8"><cfset popup_type = 'Horizantal'></cfcase>						
                                <cfdefaultcase><cfset popup_type = 'Small'></cfdefaultcase>
                            </cfswitch>
                            Popup #popup_type#
                        <cfelseif link_type eq -9>
                            Layer
                        <cfelseif link_type eq -2>
                            <cf_get_lang no='903.Yeni Sayfa'>
                        <cfelse>
                            <cf_get_lang no='379.Normal'>
                        </cfif>
                        <br/>
                        <cfif link_type eq -1>
                            <cfquery name="get_link_1_subs" datasource="#dsn#">
                                SELECT * FROM MAIN_MENU_SUB_SELECTS WHERE SELECTED_ID = #get_link_1.selected_id#
                            </cfquery>
                            <cfloop query="get_link_1_subs">
                                <img src="/images/tree_6.gif" align="absmiddle">&nbsp;
                                <cfif len(selected_link) and (listgetat(selected_link,1,'.') is 'objects2')>
                                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=settings.popup_select_site_objects&faction=#selected_link#&menu_id=#menu_id#','medium');" class="tableyazi">#LINK_NAME# = #SELECTED_LINK#</a> -
                                <cfelse>
                                    #link_name# = #selected_link# -
                                </cfif>  
                                <cfif listFindNoCase('-3,-4,-5,-6,-7,-8',link_type,',')>
                                    <cfswitch  expression="#link_type#">
                                        <cfcase value="-3"><cfset popup_type = 'Small'></cfcase>
                                        <cfcase value="-4"><cfset popup_type = 'Medium'></cfcase>
                                        <cfcase value="-5"><cfset popup_type = 'List'></cfcase>
                                        <cfcase value="-6"><cfset popup_type = 'Page'></cfcase>
                                        <cfcase value="-7"><cfset popup_type = 'Project'></cfcase>
                                        <cfcase value="-8"><cfset popup_type = 'Horizantal'></cfcase>						
                                        <cfdefaultcase><cfset popup_type = 'Small'></cfdefaultcase>
                                    </cfswitch>
                                    #popup_type#
                                <cfelseif link_type eq -2>
                                    <cf_get_lang no='903.Yeni Sayfa'>
                                <cfelse>
                                    <cf_get_lang no='379.Normal'>
                                </cfif>
                                <br/>																
                            </cfloop>
                        </cfif>
                        <cfif link_type eq -9>
                            <cfquery name="get_link_1_layers" datasource="#dsn#">
                                SELECT * FROM MAIN_MENU_LAYER_SELECTS WHERE SELECTED_ID = #get_link_1.selected_id#
                            </cfquery>
                            <cfloop query="get_link_1_layers">
                                <img src="/images/tree_6.gif" align="absmiddle">&nbsp;
                                <cfif len(selected_link)>
                                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=settings.popup_select_site_objects&faction=#selected_link#&menu_id=#menu_id#','medium');" class="tableyazi">#LINK_NAME# = #SELECTED_LINK#</a> -
                                <cfelse>
                                    #link_name# = #selected_link# -
                                </cfif>  
                                <cfif listFindNoCase('-3,-4,-5,-6,-7,-8',link_type,',')>
                                    <cfswitch expression="#link_type#">
                                        <cfcase value="-3"><cfset popup_type = 'Small'></cfcase>
                                        <cfcase value="-4"><cfset popup_type = 'Medium'></cfcase>
                                        <cfcase value="-5"><cfset popup_type = 'List'></cfcase>
                                        <cfcase value="-6"><cfset popup_type = 'Page'></cfcase>
                                        <cfcase value="-7"><cfset popup_type = 'Project'></cfcase>
                                        <cfcase value="-8"><cfset popup_type = 'Horizantal'></cfcase>						
                                        <cfdefaultcase><cfset popup_type = 'Small'></cfdefaultcase>
                                    </cfswitch>
                                    #popup_type#
                                <cfelseif link_type eq -2>
                                    <cf_get_lang no='903.Yeni Sayfa'>
                                <cfelse>
                                    <cf_get_lang no='379.Normal'>
                                </cfif>
                                <br/>
                                <cfquery name="get_link_1_subs" datasource="#dsn#">
                                    SELECT * FROM MAIN_MENU_SUB_SELECTS WHERE LAYER_ROW_ID = #get_link_1_layers.LAYER_ROW_ID#
                                </cfquery>
                                <cfloop query="get_link_1_subs">				
                                    <img src="/images/tree_5.gif" align="absmiddle">&nbsp;
                                    <cfif len(selected_link)>
                                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=settings.popup_select_site_objects&faction=#selected_link#&menu_id=#menu_id#','medium');" class="tableyazi">#LINK_NAME# = #SELECTED_LINK#</a> -
                                    <cfelse>
                                        #link_name# = #selected_link# -
                                    </cfif>  
                                    <cfif listFindNoCase('-3,-4,-5,-6,-7,-8',link_type,',')>
                                        <cfswitch  expression="#link_type#">
                                            <cfcase value="-3"><cfset popup_type = 'Small'></cfcase>
                                            <cfcase value="-4"><cfset popup_type = 'Medium'></cfcase>
                                            <cfcase value="-5"><cfset popup_type = 'List'></cfcase>
                                            <cfcase value="-6"><cfset popup_type = 'Page'></cfcase>
                                            <cfcase value="-7"><cfset popup_type = 'Project'></cfcase>
                                            <cfcase value="-8"><cfset popup_type = 'Horizantal'></cfcase>						
                                            <cfdefaultcase><cfset popup_type = 'Small'></cfdefaultcase>
                                        </cfswitch>
                                        #popup_type#										
                                    <cfelseif link_type eq -2>
                                        <cf_get_lang no='903.Yeni Sayfa'>
                                    <cfelse>
                                        <cf_get_lang no='379.Normal'>
                                    </cfif>	
                                    <br/>
                                </cfloop>										
                            </cfloop>
                        </cfif>
                    </cfloop>
                </td>
            </tr>
        </table>
    </cf_area>
    <cf_area>
        <table>
            <tr>
                <td class="txtbold"><cf_get_lang no='893.Ara Menü'></td>
            </tr>
            <tr>
                <td>
                    <cfloop query="get_link_2">
                        <img src="/images/tree_2.gif" align="absmiddle">&nbsp;
                        <cfif len(selected_link)>
                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=settings.popup_select_site_objects&faction=#selected_link#&menu_id=#menu_id#','medium');" class="tableyazi">#LINK_NAME# = #SELECTED_LINK#</a> -
                        <cfelse>
                            #link_name# = #selected_link# -
                        </cfif>
                        <cfif listFindNoCase('-3,-4,-5,-6,-7,-8',link_type,',')>
                            <cfswitch  expression="#link_type#">
                                <cfcase value="-3"><cfset popup_type = 'Small'></cfcase>
                                <cfcase value="-4"><cfset popup_type = 'Medium'></cfcase>
                                <cfcase value="-5"><cfset popup_type = 'List'></cfcase>
                                <cfcase value="-6"><cfset popup_type = 'Page'></cfcase>
                                <cfcase value="-7"><cfset popup_type = 'Project'></cfcase>
                                <cfcase value="-8"><cfset popup_type = 'Horizantal'></cfcase>						
                                <cfdefaultcase><cfset popup_type = 'Small'></cfdefaultcase>
                            </cfswitch>
                            Popup #popup_type#
                        <cfelseif link_type eq -9>
                            Layer
                        <cfelseif link_type eq -2>
                            <cf_get_lang no='903.Yeni Sayfa'>
                        <cfelse>
                            <cf_get_lang no='379.Normal'>
                        </cfif>
                        <br/>
                        <cfif link_type eq -1>
                            <cfquery name="get_link_2_subs" datasource="#dsn#">
                                SELECT * FROM MAIN_MENU_SUB_SELECTS WHERE SELECTED_ID = #get_link_2.selected_id#
                            </cfquery>
                            <cfloop query="get_link_2_subs">
                                <img src="/images/tree_6.gif" align="absmiddle">&nbsp;
                                <cfif len(selected_link)>
                                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=settings.popup_select_site_objects&faction=#selected_link#&menu_id=#menu_id#','medium');" class="tableyazi">#LINK_NAME# = #SELECTED_LINK#</a> -
                                <cfelse>
                                    #link_name# = #selected_link# -
                                </cfif>
                                <cfif listFindNoCase('-3,-4,-5,-6,-7,-8',link_type,',')>
                                    <cfswitch  expression="#link_type#">
                                        <cfcase value="-3"><cfset popup_type = 'Small'></cfcase>
                                        <cfcase value="-4"><cfset popup_type = 'Medium'></cfcase>
                                        <cfcase value="-5"><cfset popup_type = 'List'></cfcase>
                                        <cfcase value="-6"><cfset popup_type = 'Page'></cfcase>
                                        <cfcase value="-7"><cfset popup_type = 'Project'></cfcase>
                                        <cfcase value="-8"><cfset popup_type = 'Horizantal'></cfcase>						
                                        <cfdefaultcase><cfset popup_type = 'Small'></cfdefaultcase>
                                    </cfswitch>
                                    #popup_type#
                                <cfelseif link_type eq -2>
                                    <cf_get_lang no='903.Yeni Sayfa'>
                                <cfelse>
                                    <cf_get_lang no='379.Normal'>
                                </cfif>
                                <br/>																
                            </cfloop>
                        </cfif>
                        <cfif link_type eq -9>
                            <cfquery name="get_link_2_layers" datasource="#dsn#">
                                SELECT * FROM MAIN_MENU_LAYER_SELECTS WHERE SELECTED_ID = #get_link_2.selected_id#
                            </cfquery>
                            <cfloop query="get_link_2_layers">				
                                <img src="/images/tree_6.gif" align="absmiddle">&nbsp;
                                <cfif len(selected_link)>
                                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=settings.popup_select_site_objects&faction=#selected_link#&menu_id=#menu_id#','medium');" class="tableyazi">#LINK_NAME# = #SELECTED_LINK#</a> -
                                <cfelse>
                                    #link_name# = #selected_link# -
                                </cfif>
                                <cfif listFindNoCase('-3,-4,-5,-6,-7,-8',link_type,',')>
                                    <cfswitch  expression="#link_type#">
                                        <cfcase value="-3"><cfset popup_type = 'Small'></cfcase>
                                        <cfcase value="-4"><cfset popup_type = 'Medium'></cfcase>
                                        <cfcase value="-5"><cfset popup_type = 'List'></cfcase>
                                        <cfcase value="-6"><cfset popup_type = 'Page'></cfcase>
                                        <cfcase value="-7"><cfset popup_type = 'Project'></cfcase>
                                        <cfcase value="-8"><cfset popup_type = 'Horizantal'></cfcase>						
                                        <cfdefaultcase><cfset popup_type = 'Small'></cfdefaultcase>
                                    </cfswitch>
                                    #popup_type#
                                <cfelseif link_type eq -2>
                                    <cf_get_lang no='903.Yeni Sayfa'>
                                <cfelse>
                                    <cf_get_lang no='379.Normal'>
                                </cfif>
                                <br/>
                                <cfquery name="get_link_2_subs" datasource="#dsn#">
                                    SELECT * FROM MAIN_MENU_SUB_SELECTS WHERE LAYER_ROW_ID = #get_link_2_layers.LAYER_ROW_ID#
                                </cfquery>
                                <cfloop query="get_link_2_subs">				
                                    <img src="/images/tree_5.gif" align="absmiddle">&nbsp;
                                    <cfif len(selected_link)>
                                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=settings.popup_select_site_objects&faction=#selected_link#&menu_id=#menu_id#','medium');" class="tableyazi">#LINK_NAME# = #SELECTED_LINK#</a> -
                                    <cfelse>
                                        #link_name# = #selected_link# -
                                    </cfif>  
                                    <cfif listFindNoCase('-3,-4,-5,-6,-7,-8',link_type,',')>
                                        <cfswitch  expression="#link_type#">
                                            <cfcase value="-3"><cfset popup_type = 'Small'></cfcase>
                                            <cfcase value="-4"><cfset popup_type = 'Medium'></cfcase>
                                            <cfcase value="-5"><cfset popup_type = 'List'></cfcase>
                                            <cfcase value="-6"><cfset popup_type = 'Page'></cfcase>
                                            <cfcase value="-7"><cfset popup_type = 'Project'></cfcase>
                                            <cfcase value="-8"><cfset popup_type = 'Horizantal'></cfcase>						
                                            <cfdefaultcase><cfset popup_type = 'Small'></cfdefaultcase>
                                        </cfswitch>
                                        #popup_type#										
                                    <cfelseif link_type eq -2>
                                        <cf_get_lang no='903.Yeni Sayfa'>
                                    <cfelse>
                                        <cf_get_lang no='379.Normal'>
                                    </cfif>	
                                    <br/>
                                </cfloop>										
                            </cfloop>
                        </cfif>
                    </cfloop>
                </td>
            </tr>
        </table>
    </cf_area>
</cf_popup_box>
</cfoutput>
