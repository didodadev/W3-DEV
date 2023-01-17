<cfquery name="GET_LIT_NAMES" datasource="#dsn#">
	SELECT
		CONTENTCAT,
		CONTENTCAT_ID 
	FROM
		CONTENT_CAT
	WHERE
		IS_RULE = 1 AND
		LANGUAGE_ID = '#SESSION.EP.LANGUAGE#'
	ORDER BY CONTENTCAT
</cfquery>
<table>
	<cfoutput query="GET_LIT_NAMES">
	<tr>
		<td valign="top">
			<table>
				<tr>
					<td width="100" valign="top"><img src="/images/arrow.gif" align="baseline"> <a href="#request.self#?fuseaction=rule.view_category&contentcat_id=#CONTENTCAT_ID#" class="formbold">#CONTENTCAT#</a></td>
				</tr>					
			</table>
		</td>
		<td valign="top"><cfinclude template="chapters.cfm"></td>
	</tr>
	</cfoutput>
	<tr>
		<td colspan="2"><HR></td>
	</tr>
</table>
<cfinclude template="../query/get_cat_names.cfm">
<table  border="0">
	<cfoutput query="GET_CAT_NAMES">
		<tr>
			<td width="9" valign="baseline"><img src="/images/arrow.gif" align="baseline" ></td>	
			<td class="formbold" width="100"><a href="#request.self#?fuseaction=rule.view_category&contentcat_id=#CONTENTCAT_ID#">#CONTENTCAT#</a></td>
		</tr>			
	</cfoutput>
</table>