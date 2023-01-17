<cfsetting showdebugoutput="no" />
<cfparam name="attributes.assetId" type="numeric" />
<cfparam name="attributes.commentPage" default="1" />
<cfparam name="attributes.userType" type="string" default="" />
<cfparam name="attributes.commentType" type="numeric" default="1" />
<cfset xfa.video_detail = "" />
<!--- session'daki aktif kullanıcı bilgilerini al --->
<cfif isdefined("session.ww.userid")>
	<cfset userLoggedIn = true />
    <cfset loggedUserId = session.ww.userid />
    <cfset loggedUserType = "consumer" />
<cfelseif isdefined("session.ep.userid")>
	<cfset userLoggedIn = true />
    <cfset loggedUserId = session.ep.userid />
    <cfset loggedUserType = "employee" />
<cfelseif isdefined("session.pp.userid")>
	<cfset userLoggedIn = true />
    <cfset loggedUserId = session.pp.userid />
    <cfset loggedUserType = "partner" />
<cfelse>
	<cfset userLoggedIn = false />
    <cfset loggedUserId = 0 />
    <cfset loggedUserType = "" />
</cfif>
<!--- veritabanından yorumları getir --->
<cfif not isdefined("comments")>
	<cfset cmp=createObject("component","objects2.asset.query.CommentData").init(dsn) />
    <cfif isdefined("session.ww")>
		<cfset comments=cmp.GetConsumerComments(attributes.commentType,attributes.assetId) />
    <cfelseif isdefined("session.ep")>
    	<cfset comments=cmp.GetEmployeeComments(attributes.commentType,attributes.assetId) />
    <cfelseif isdefined("session.pp")>
    	<cfset comments=cmp.GetPartnerComments(attributes.commentType,attributes.assetId) />
    </cfif>
</cfif>
<cffunction name="showProfile" returntype="string" hint="kullanıcı tipine göre profil sayfasının adresini getirir">
	<cfargument name="userType" required="yes" type="string" />
    <cfargument name="userId" required="yes" type="numeric" />
	<cfif isdefined("session.ww")>
    	<cfreturn "#request.self#?fuseaction=myportal.profile&profile_id=#arguments.userId#" />
    <cfelseif isdefined("session.ep")>
    	<cfreturn "" />
    <cfelseif isdefined("session.pp")>
    	<cfreturn "" />
    <cfelse>
    	<cfreturn "" />
    </cfif>
</cffunction>

<!--- yorum tablosu --->
<table width="100%" border="0" cellpadding="3" cellspacing="0">
<cfif comments.recordCount gt 0>
  <cfoutput query="comments" startrow="#(attributes.commentPage-1)*10+1#" maxrows="10">
  <cfif isdefined("session.ww")>
  	<cfset userid = comments.RECORD_PUB />
  <cfelseif isdefined("session.ep")>
  	<cfset userid = comments.RECORD_EMP />
  <cfelseif isdefined("session.pp")>
  	<cfset userid = comments.RECORD_PAR />
  </cfif>
  <cfset link=showProfile(attributes.userType, userid) />
    <tr bgcolor="##999999"><!--- #showProfile(usertype)# --->
      <td height="30" bgcolor="##CCCCCC"><cfif link neq ""><a href="#link#"></cfif>#comments.USER_NAME# #comments.USER_SURNAME#<cfif link neq ""></a></cfif> (#dateFormat(comments.RECORD_DATE,"dd.mm.yyyy")#)</td>
    </tr>
    <tr>
      <td id="commentCell#comments.currentRow#" colspan="2"><a href="javascript:;" style="float:right" onclick="showCommentForm('commentCell#comments.currentRow#','#comments.COMMENT_ID#')"><cf_get_lang no='178.Yanıtla'></a></td>
    </tr>
    <tr>
      <td colspan="2">#comments.BODY#</td>
    </tr>
    <tr>
      <td colspan="2"><hr /></td>
    </tr>
  </cfoutput>
<tr>
  <td colspan="2"><cfoutput><cfif attributes.commentPage gt 1><a href="javascript:;" onclick="ColdFusion.navigate('#request.self#?fuseaction=objects2.emptypopup_list_asset_comments&assetId=#attributes.assetId#&commentPage=#attributes.commentPage-1#','comment_list')">&laquo; <cf_get_lang no='179.Önceki'></a> &nbsp;</cfif><cfif attributes.commentPage lt (comments.recordCount/10)><a href="javascript:;" onclick="ColdFusion.navigate('#request.self#?fuseaction=objects2.emptypopup_list_asset_comments&assetId=#attributes.assetId#&commentPage=#attributes.commentPage+1#','comment_list')"><cf_get_lang no='180.Sonraki'> &raquo;</a></cfif></cfoutput></td>
</tr>
<cfelse>
<tr><td>
&nbsp;<cf_get_lang no='181.İlk yorum yazan siz olun'>.
</td></tr>
</cfif>
</table>
