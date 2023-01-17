<cfif not isdefined("session.ww.userid") and not isdefined("session.pp.userid")>
<cf_get_lang no='233.Erişim İzni Yok'>.
<cfexit method="exittemplate">
</cfif>

<cfparam name="attributes.keyword" default="">
<cfinclude template="../query/get_results.cfm">
<cfinclude template="../query/get_forums.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
<cfparam name="attributes.totalrecords" default=#results.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<table width="100%" align="center" cellpadding="0" cellspacing="0" border="0">
<tr height="35"> 
<td class="headbold"><cf_get_lang_main no='676.Arama Sonuçları'></td>
<td  valign="bottom" style="text-align:right;">
	<table>
	<cfform method="post" action="#request.self#?fuseaction=objects2.search">
	<tr>
    <td><cf_get_lang_main no='48.Filtre'>:</td>
	<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
	<td><select name="forumid" id="forumid" style="width:100px;">
		<option value="0" selected><cf_get_lang_main no='669.Hepsi'>
		<cfoutput query="forums">
			<option value="#forumid#"<cfif attributes.forumid eq forumid>selected</cfif>>#forumname#
		</cfoutput> 
		</select>
	</td>
	<td>
	<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
		<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
	</td>
	<td><cf_wrk_search_button></td>
	</tr>
	</cfform>
	</table>
	</td>
  </tr>
<tr><td colspan="2" bgcolor="#999999"></td></tr>
</table>
	 <table  width="100%" border="0" align="center">
	<cfif results.recordcount>
		<cfoutput query="results" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#" group="topicid">
		<cfset attributes.topicid = topicid>
		<cfinclude template="../query/get_reply_count.cfm">
			<tr class="color-row">
				<td width="20"><img src="images/notkalem.gif" border="0"></td>
				<td><a href="#request.self#?fuseaction=objects2.view_reply&TOPICID=#topicid#">#title#</a></td>
			  </tr>
			<tr>
			  <td>&nbsp;</td>
			  <td><cf_get_lang_main no='215.Kayıt Tarihi'>:#dateformat(date_add('h',session_base.time_zone,record_date),'dd/mm/yyyy')# (#timeformat(date_add('h',session_base.time_zone,record_date),'HH:MM')#)</td>
		  </tr>
			<tr>
			  <td>&nbsp;</td>
			  <td><cf_get_lang no='996.Cevap Sayısı'>:#reply_count.total#</td>
		  </tr>
			<tr>
			  <td>&nbsp;</td>
			  <td><cf_get_lang_main no='9.Forum'>:<a href="#request.self#?fuseaction=objects2.view_topic&FORUMID=#forumid#" class="TABLEYAZI">#forumname#</a></td>
		  </tr>
			<tr>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
		  </tr>
		</cfoutput>
	<cfelse>
		<tr height="20" class="color-row"><td colspan="2"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td></tr>
	</cfif>
	</table>
	<cfif attributes.totalrecords gt attributes.maxrows>
	<table width="100%" align="center" border="0">
	  <tr> 
	    <td>
		<cf_pages page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="--------fuseaction-------">
		</td>
	    <td style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
	  </tr>
	</table>
	</cfif>	
	<br/>
