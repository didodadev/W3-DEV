<cfquery name="GET_MY_SETTINGS_" datasource="#DSN#">
	SELECT 
		MENU_ID,
		MENU_NAME,
		SITE_DOMAIN
	FROM 
		MAIN_MENU_SETTINGS 
	WHERE 
		MENU_ID = #attributes.menu_id#
</cfquery>

<cfquery name="GET_LINK_1" datasource="#DSN#">
		SELECT 
		MSL.MENU_ID,
        MSL.FACTION,
		MSL.HEADER
	FROM 
		MAIN_SITE_LAYOUTS MSL
	WHERE 
		MSL.MENU_ID IS NOT NULL
	ORDER BY
		MSL.FACTION,
		(SELECT MENU_NAME FROM MAIN_MENU_SETTINGS WHERE MENU_ID = MSL.MENU_ID)
</cfquery>	

 
<cfset https="http://">
<tbody>

</tbody>
<cf_medium_list>
 
	<tbody>
		<cfoutput query="get_link_1">
		  	<tr> 			
				<td class="cart_product"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=protein.popup_select_site_objects&faction=#faction#&menu_id=#menu_id#','medium');" class="tableyazi"> =#faction# </a> </td>
				<td class="cart_product"><a href="#https##GET_MY_SETTINGS_.SITE_DOMAIN#/#faction#" target="_blank" class="tableyazi">#GET_MY_SETTINGS_.SITE_DOMAIN#/#faction#</a></td>
				<td class="cart_product">#HEADER#</td>
			</tr>
		</cfoutput>		 
	</tbody>
</cf_medium_list>
 
