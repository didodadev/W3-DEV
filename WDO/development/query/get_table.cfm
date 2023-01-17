<cfsetting showdebugoutput="no">

<cfquery name="GET_TABLE_NAME" datasource="#DSN#">
	SELECT
    		*
	FROM 
		WRK_OBJECT_INFORMATION
	WHERE
		OBJECT_NAME LIKE '%#attributes.table_name#%' 
</cfquery>
<cfoutput>
	<div id="_search_table_" style="width:355px;height:200px;z-index:1;overflow:auto; z-index:9999;background-color: #colorrow#; border: 1px outset cccccc;">
</cfoutput>
<table width="100%" align="center" border="0" cellpadding="0" cellspacing="0" class="color-border">
	<tr class="color-list" height="20">
	 	<td colspan="3"><cfoutput><b>#attributes.table_name#</b> ile ilgili sonuçlar...</cfoutput></td>
		<td style="text-align:right;"><a href="##" onClick="gizle(check_table_layer);"  class="tableyazi"><img src="../images/pod_close.gif" alt="Gizle" border="0"></a></td> 
	</tr>
	<cfif GET_TABLE_NAME.recordcount>
		<cfoutput query="GET_TABLE_NAME">
		<tr valign="top" height="20" <cfif currentrow mod 2>class="color-row"<cfelse>class="color-list"</cfif> onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" style="cursor:pointer;">
			<td>
				<a href="#request.self#?fuseaction=dev.form_upd_table&TABLE_ID=#OBJECT_ID#">#OBJECT_NAME#</a>
			</td>
			<td><a href="#request.self#?fuseaction=dev.form_upd_table&TABLE_ID=#OBJECT_ID#">#DB_NAME#</a></td>
			<td colspan="2">&nbsp;</td>				
		</tr>
		</cfoutput>
	<cfelse>
	<tr>
		<td colspan="4">Kayıt Bulunamadı</td>
	</tr>
	</cfif>
</table>
