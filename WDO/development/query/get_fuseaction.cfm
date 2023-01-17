<cfsetting showdebugoutput="no">
<cfquery name="GET_FUSEACTION_NAME" datasource="#DSN#">
	SELECT
	    IS_UPDATE,
        IS_ADD,
        IS_DELETE,
    	IS_ACTIVE,
		WRK_OBJECTS_ID,
		HEAD,
		FUSEACTION,
		MODUL,
        MODUL_SHORT_NAME,
		TYPE,
		FOLDER,
		FILE_NAME,
		MODUL_SHORT_NAME,
        FUSEACTION
	FROM 
		WRK_OBJECTS
	WHERE
		FUSEACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.fbx_name#%"> OR
		HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.fbx_name#%"> OR
		FILE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.fbx_name#%"> OR
		(MODUL_SHORT_NAME+'.'+ FUSEACTION) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.fbx_name#">
	<cfif isnumeric(attributes.fbx_name)>
        OR WRK_OBJECTS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.fbx_name#">
    </cfif>
	ORDER BY 
		MODUL,
        FOLDER 
</cfquery>
<cfoutput>
	<div id="_search_fuseaction_" style="position:absolute;width:410px;height:200px;z-index:1;overflow:auto; z-index:9999;background-color: #colorrow#; border: 1px outset cccccc;">
</cfoutput>
<table width="100%" class="color-row">
	<tr>
	 	<td colspan="3" class="color-header"><cfoutput><b>#attributes.fbx_name#</b> ile ilgili sonuçlar...</cfoutput></td>
		<td style="text-align:right;width:11px" class="color-header"><a href="##" onclick="gizle(check_fuseaction_layer);"  class="tableyazi"><img src="../images/pod_close.gif" alt="Gizle" border="0"></a></td> 
	</tr>
	<cfif get_fuseaction_name.recordcount>
		<cfoutput query="get_fuseaction_name">
        
		<tr valign="top" height="20" <cfif currentrow mod 2>class="color-row"<cfelse>class="color-list"</cfif> onmouseover="this.className='color-light';" onmouseout="this.className='color-row';" style="cursor:pointer;">
			<td>
				<a href="#request.self#?fuseaction=dev.upd_fuseaction&woid=#wrk_objects_id#"><cfif get_fuseaction_name.is_active eq 0><font color="FF0000"><b>(P)&nbsp;</b></font></cfif>#HEAD#</a><br />
                <font color="999999" style="font-style:italic">#FUSEACTION#</font>
			</td>
            <td>
            	<font color="999999">
					<cfif listfind(type,'1')> <cfif is_update eq 1>Form Update<br /></cfif><cfif is_add eq 1>Form Add<br /></cfif>
                    <cfelseif listfind(type,'2')>Query <cfif is_update eq 1>Update </cfif><cfif is_delete eq 1>Delete </cfif><cfif is_add eq 1>Add</cfif><br />
                    <cfelseif listfind(type,'3')>Detail<br />
                    <cfelseif listfind(type,'4')>List<br />
                    <cfelseif listfind(type,'5')>Ajax List<br />
                    <cfelseif listfind(type,'6')>Report<br />
                    <cfelseif listfind(type,'7')>Menu<br />
                    <cfelseif listfind(type,'8')>Function<br />
                    <cfelseif listfind(type,'9')>Display<br />
                    </cfif>#modul#
                </font>
            </td>
            <td style="text-align:right;width:10px;">
				<cfif get_fuseaction_name.type neq 'query'>
					<a href="#request.self#?fuseaction=#modul_short_name#.#fuseaction#"><img src="../images/devam.gif" alt="Sayfaya Git" border="0" title="Sayfaya Git"></a>&nbsp;&nbsp;&nbsp;
				</cfif>
            </td>
			</td>
			<td style="text-align:right;">
                <cfquery name="GET_FOLDER" datasource="#DSN#">
                    SELECT FOLDER FROM MODULES WHERE MODULE_SHORT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_fuseaction_name.modul_short_name#"> AND MODULE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_fuseaction_name.modul#">
                </cfquery>
                <cfif get_fuseaction_name.modul_short_name eq 'pda'>
	                <cfset folder_ = "workcube_pda">
				<cfelseif get_fuseaction_name.modul_short_name eq 'myhome'>
	                <cfset folder_ = "myhome">
				<cfelseif get_fuseaction_name.modul_short_name eq 'production'>
	                <cfset folder_ = "production">
                <cfelseif get_fuseaction_name.modul_short_name eq 'myportal'>
	                <cfset folder_ = "myportal">
                <cfelseif get_fuseaction_name.modul_short_name eq 'schedules'>
	                <cfset folder_ = "schedules">
                <cfelse>
                	<cfset folder_ = get_folder.folder>
                </cfif>
                <a href="file://#index_folder#<cfif len(get_folder.folder)>#get_folder.folder#<cfelse>#folder_#</cfif>/#folder#/#file_name#"><img src="../images/topdoc.gif" alt="Open File in Editor"  align="absmiddle" border="0" title="Open File in Editor"></a>&nbsp;  
			</td>				
		</tr>
		</cfoutput>
	<cfelse>
	<tr>
		<td>Kayıt Bulunamadı</td>
	</tr>
	</cfif>
</table>
