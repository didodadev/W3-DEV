<cfif not IsDefined("Cookie.my_vote_#ReplaceList(cgi.http_host,'-,:','_,_')#")>
	<cfset my_cookie_ = createUUID()>
	<cfcookie name="my_vote_#ReplaceList(cgi.http_host,'-,:','_,_')#" value="#my_cookie_#" expires="1">
</cfif>

<cfquery name="PRODUCT_VOTE_" datasource="#DSN3#">
	SELECT 
		COUNT(PRODUCT_COMMENT_POINT) AS PUAN_YUZDE
	FROM 
		PRODUCT_COMMENT 
	WHERE 
		PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
</cfquery>

<cfquery name="GET_PRODUCT_VOTE" datasource="#DSN3#">
	SELECT 
		PRODUCT_COMMENT_POINT,
		COUNT(PRODUCT_COMMENT_POINT) AS PUAN
	FROM 
		PRODUCT_COMMENT 
	WHERE 
		PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
	GROUP BY 
		PRODUCT_COMMENT_POINT
</cfquery>

<cfquery name="GET_PRODUCT_VOTE_CONTROL" datasource="#DSN3#">
	SELECT 
		PRODUCT_COMMENT_POINT
	FROM 
		PRODUCT_COMMENT 
	WHERE 
		PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> AND
		COOKIE_NAME=<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("Cookie.my_vote_#ReplaceList(cgi.http_host,'-,:','_,_')#")#">
</cfquery>

<table border="0" cellspacing="1" cellpadding="2" align="center" style="width:98%;">
  	<tr>
		<td style="vertical-align:top;">
	  		<cfform name="add_vote" method="post" action="#request.self#?fuseaction=objects2.emptypopup_add_product_vote&product_id=#attributes.pid#">
            <table border="0">
                <tr>
                    <td class="txtbold"><cf_get_lang_main no='1572.Puan'></td>
                    <td><input name="product_comment_point" id="product_comment_point" type="radio" value="1">1
                        <input name="product_comment_point" id="product_comment_point" type="radio" value="2">2
                        <input name="product_comment_point" id="product_comment_point" type="radio" value="3">3
                        <input name="product_comment_point" id="product_comment_point" type="radio" value="4">4
                        <input name="product_comment_point" id="product_comment_point" type="radio" value="5">5
                    </td>
                </tr>
                <tr>
                    <cfif not get_product_vote_control.recordcount>
                        <td colspan="2" style="text-align:right;">
                            <input type="button" name="submit_button" id="submit_button" onClick="gonder_form();" value="<cf_get_lang_main no='1331.Gonder'>">
                        </td>
                    <cfelse>
                        <td colspan="2"><b><cfoutput>#get_product_vote_control.product_comment_point# <cf_get_lang no='416.Puan Verdiniz'>.</cfoutput></b></td>
                    </cfif>
                </tr>
                </cfform>
                <cfif get_product_vote.recordcount>
                    <cfoutput query="get_product_vote">
                        <cfset my_width = (#get_product_vote.puan#*100/#product_vote_.puan_yuzde#)>
                        <tr>
                            <td colspan="2">#product_comment_point# 
                                <img src="../objects2/image/center1.gif" width="#my_width#px" height="20" align="absmiddle"> 
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
