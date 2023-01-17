<cfif not IsDefined("Cookie.add_vote_#ReplaceList(cgi.http_host,'-,:','_,_')#")>
	<cfset my_cookie_ = createUUID()>
	<cfcookie name="add_vote_#ReplaceList(cgi.http_host,'-,:','_,_')#" value="#my_cookie_#" expires="1">
</cfif>

<cfquery name="content_vote_" datasource="#dsn#">
	SELECT 
		COUNT(CONTENT_COMMENT_POINT) AS PUAN_YUZDE
	FROM 
		CONTENT_COMMENT 
	WHERE 
		CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">
</cfquery>

<cfquery name="get_content_vote" datasource="#dsn#">
	SELECT 
		CONTENT_COMMENT_POINT,
		COUNT(CONTENT_COMMENT_POINT) AS PUAN
	FROM 
		CONTENT_COMMENT 
	WHERE 
		CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">
	GROUP BY 
		CONTENT_COMMENT_POINT
</cfquery>

<cfquery name="get_content_vote_control" datasource="#dsn#">
	SELECT 
		CONTENT_COMMENT_POINT
	FROM 
		CONTENT_COMMENT 
	WHERE 
		CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#"> AND
		COOKIE_NAME=<cfqueryparam cfsqltype="cf_sql_varchar" value="#EVALUATE("Cookie.add_vote_#ReplaceList(cgi.http_host,'-,:','_,_')#")#">
</cfquery>

<table width="98%" border="0" cellspacing="1" cellpadding="2" align="center">
  <tr>
	<td valign="top">
	  <table border="0">
	  <cfform name="add_vote" method="post" action="#request.self#?fuseaction=objects2.emptypopup_add_content_vote&content_id=#attributes.cid#">
		<tr>
			<td class="txtbold"><cf_get_lang_main no='1572.Puan'></td>
			<td><input name="CONTENT_COMMENT_POINT" id="CONTENT_COMMENT_POINT" type="radio" value="1">1
				<input name="CONTENT_COMMENT_POINT" id="CONTENT_COMMENT_POINT" type="radio" value="2">2
				<input name="CONTENT_COMMENT_POINT" id="CONTENT_COMMENT_POINT" type="radio" value="3">3
				<input name="CONTENT_COMMENT_POINT" id="CONTENT_COMMENT_POINT" type="radio" value="4">4
				<input name="CONTENT_COMMENT_POINT" id="CONTENT_COMMENT_POINT" type="radio" value="5">5
			</td>
		</tr>
		<tr>
			<cfif not get_content_vote_control.recordcount>
				<td colspan="2"  style="text-align:right;">
					<input type="button" name="submit_button" id="submit_button" onClick="gonder_form();" value="<cf_get_lang_main no='1331.Gonder'>">
				</td>
			<cfelse>
				<td colspan="2"><b><cfoutput>#get_content_vote_control.CONTENT_COMMENT_POINT# <cf_get_lang no='416.Puan Verdiniz'>.</cfoutput></b></td>
			</cfif>
		</tr>
	  </cfform>
	  <cfif get_content_vote.recordcount>
	  <cfoutput query="get_content_vote">
	  	<cfset my_width = (#get_content_vote.puan#*100/#content_vote_.puan_yuzde#)>
		<tr>
			<td width="#my_width#%" colspan="2">#CONTENT_COMMENT_POINT# 
				<img src="../objects2/image/center1.gif" width="#my_width#%" height="20" align="absmiddle"> 
				#puan#
			</td>
		</tr>
	  </cfoutput>
	  </cfif>
	  </table>
	</td>
  </tr>
</table>
<script type="text/javascript">
function gonder_form()
{
	windowopen('','small','vote_window');
	add_vote.target='vote_window';
	add_vote.submit_button.disabled=true;
	add_vote.submit();
}
</script>
