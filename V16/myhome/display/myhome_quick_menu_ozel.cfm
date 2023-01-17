<cfquery name="GET_MY_HOME_MENU" datasource="#DSN#" maxrows="1">
	SELECT * FROM MAIN_MENU_SETTINGS WHERE MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.menu_id#">
</cfquery>
<cfquery name="GET_MAIN_MENU_UST" datasource="#DSN#">
	SELECT
		*
	FROM
		MAIN_MENU_SELECTS
	WHERE
		LINK_AREA = -1 AND
		MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_my_home_menu.menu_id#">
	<cfif get_my_home_menu.is_alphabetic eq 1>
	ORDER BY
		LINK_NAME
	<cfelse>					
	ORDER BY
		ORDER_NO ASC
	</cfif>
</cfquery>
<cfquery name="GET_MAIN_MENU_ALT" datasource="#DSN#">
	SELECT
		*
	FROM
		MAIN_MENU_SELECTS
	WHERE
		LINK_AREA = -2 AND 
		MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_my_home_menu.menu_id#">
	<cfif get_my_home_menu.is_alphabetic eq 1>
	ORDER BY
		LINK_NAME
	<cfelse>					
	ORDER BY
		ORDER_NO ASC
	</cfif>
</cfquery>

<cfoutput>
<table cellpadding="0" cellspacing="0" align="center" width="98%" height="100%">
	<tr class="color-list">
		<td class="txtbold" align="center" height="5" colspan="200"></td>
	</tr>
	<tr>
		<td>
		<div id="musteri" style="position:absolute;width:100%;height:100%; z-index:88;overflow:auto;">
        <table cellpadding="2" cellspacing="2">
    <cfloop query="get_main_menu_alt">
        <cfif (currentrow mod 6) eq 1 or currentrow eq 1>
        	<tr>
        </cfif>
            	<td valign="top">
                <table>
                    <tr>
                        <td nowrap>
                            <cfif listFindNoCase('-3,-4,-5,-6,-7,-8',link_type,',')>
                                <cfswitch  expression="#link_type#">
                                    <cfcase value="-3"><cfset popup_type = 'small'></cfcase>
                                    <cfcase value="-4"><cfset popup_type = 'medium'></cfcase>
                                    <cfcase value="-5"><cfset popup_type = 'list'></cfcase>
                                    <cfcase value="-6"><cfset popup_type = 'page'></cfcase>
                                    <cfcase value="-7"><cfset popup_type = 'project'></cfcase>
                                    <cfcase value="-8"><cfset popup_type = 'horizantal'></cfcase>						
                                    <cfdefaultcase><cfset popup_type = 'small'></cfdefaultcase>
                                </cfswitch>
                                <img src="/images/folder_medium.gif" align="absmiddle"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=#selected_link#','#popup_type#');" class="txtbold">#link_name#</a>
                            <cfelse>
                                <img src="/images/folder_medium.gif" align="absmiddle"><a href="#request.self#?fuseaction=#selected_link#" class="txtbold" <cfif link_type eq -2>target="_blank"</cfif>>#link_name#</a>
                            </cfif>
                            <cfquery name="GET_LINK_1_SUBS" datasource="#DSN#">
                                SELECT
                                    *
                                FROM
                                    MAIN_MENU_SUB_SELECTS
                                WHERE
                                    SELECTED_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_main_menu_alt.selected_id#">
                                <cfif get_my_home_menu.is_alphabetic eq 1>
                                ORDER BY
                                    LINK_NAME
                                <cfelse>
                                ORDER BY
                                    ORDER_NO ASC
                                </cfif>
                            </cfquery>	
                            <br/>
                            <cfif get_link_1_subs.recordcount>
                                <cfloop query="get_link_1_subs">
                                    <cfif listFindNoCase('-3,-4,-5,-6,-7,-8',link_type,',')>
                                        <cfswitch  expression="#link_type#">
                                            <cfcase value="-3"><cfset popup_type = 'small'></cfcase>
                                            <cfcase value="-4"><cfset popup_type = 'medium'></cfcase>
                                            <cfcase value="-5"><cfset popup_type = 'list'></cfcase>
                                            <cfcase value="-6"><cfset popup_type = 'page'></cfcase>
                                            <cfcase value="-7"><cfset popup_type = 'project'></cfcase>
                                            <cfcase value="-8"><cfset popup_type = 'horizantal'></cfcase>						
                                            <cfdefaultcase><cfset popup_type = 'small'></cfdefaultcase>
                                        </cfswitch>
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/tree_1.gif"> <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=#selected_link#','#popup_type#');" class="tableyazi">#link_name#</a>
                                    <cfelse>
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/tree_1.gif"> <a href="#request.self#?fuseaction=#selected_link#" class="tableyazi">#link_name#</a>
                                    </cfif>
                                <br/>					
                                </cfloop>
                            </cfif>
                        </td>
                    </tr>
                </table>	
            	</td>
        <cfif (currentrow mod 6) eq 0 or currentrow eq get_main_menu_alt.recordcount>
            </tr>
        </cfif>
    </cfloop>
        </table>
		</div>
		</td>
	</tr>
</table>
</cfoutput>
