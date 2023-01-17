<cfif session.ep.menu_id neq 0>
	<cfquery name="GET_MY_SETTINGS" datasource="#DSN#">
		SELECT IS_TREE_MENU FROM MAIN_MENU_SETTINGS WHERE MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.menu_id#">
	</cfquery>
</cfif>
<cfif (session.ep.menu_id eq 0) or (isdefined("get_my_settings") and get_my_settings.is_tree_menu eq 1)>
	<script type="text/javascript">
		function hepsini_gizle()
		{
			gizle_goster(geri_git);
			gizle_goster(ileri_git);
			gizle_goster(tree_1);
			gizle_goster(tree_2);	
		}
	</script>
		<cfswitch expression="#session.ep.design_id#">
			   <cfcase value="1">
				  <cfset td_back2 = 'width="15" valign="top" background="/images/leftbackblue.gif" style="display:none;" id="tree_2"'>
				  <cfset td_back = 'width="135" valign="top" background="/images/leftbackblue.gif" id="tree_1"'>
			   </cfcase> 
			   <cfcase value="2">
				  <cfset td_back2 = 'width="15" valign="top" background="/images/leftbackbrown2.gif" style="display:none;" id="tree_2"'>
				  <cfset td_back = 'width="135" valign="top" background="/images/leftbackbrown2.gif" nowrap="nowrap" id="tree_1"'>
			   </cfcase>
			   <cfcase value="3,6">
				  <cfset td_back2 = 'width="15" valign="top" class="color-row" style="border-right : 1px solid cccccc;border-top : 1px solid cccccc;" style="display:none;" id="tree_2"'>
				  <cfset td_back = 'width="135" valign="top" class="color-row" style="border-right : 1px solid cccccc;border-top : 1px solid cccccc;" id="tree_1"'>
			  </cfcase>  
			   <cfcase value="4,7,8,9">
				  <cfset td_back2 = 'width="15" valign="top" class="color-row" style="border-right : 1px solid cccccc;border-top : 1px solid cccccc;display:none;" id="tree_2"'>
				  <cfset td_back = 'width="135" valign="top" class="color-row" style="border-right : 1px solid cccccc;border-top : 1px solid cccccc;" id="tree_1"'>
			  </cfcase> 
			  <cfcase value="5">
				  <cfset td_back2 = 'width="15" valign="top" class="color-row" style="border-right : 1px solid cccccc;border-top : 1px solid cccccc;"  style="display:none;" id="tree_2"'>
				  <cfset td_back = 'width="135" valign="top" class="color-row" style="border-right : 1px solid cccccc;border-top : 1px solid cccccc;" id="tree_1"'>
				</cfcase>
		</cfswitch>
	<td <cfoutput>#td_back2#</cfoutput>>&nbsp;</td>
<cfelse>
	<cfset td_back = 'style="display:none;"'>
</cfif>
