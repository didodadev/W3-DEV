<cfparam name="attributes.keyword" default="">
<cfinclude template="../query/get_replies.cfm">
<cfinclude template="../query/get_head_topic.cfm">
<cfinclude template="../query/add_topic_count.cfm">
<cfinclude template="../query/get_forums.cfm">
<cfinclude template="../query/get_email_alert.cfm">

<cfoutput query="head_topic">
	<cfset lock = locked>
	<cfset attributes.userkey = userkey>
	<cfinclude template="../query/get_username.cfm">
	<table border="0" cellpadding="0" cellspacing="0" align="center" style="width:100%;">
		<tr style="height:35px;">  
      		<td class="headbold"> <a href="#request.self#?fuseaction=objects2.view_topic&forumid=#forumid#">#forumname#</a> / <img src="/objects2/forum/images/data/icon#imageid#.gif" title="" border="0" align="absbottom" style="width:20px; height:20px;">#title#</td>
			<td style="vertical-align:bottom;text-align:right;">
				<cfform method="post" action="#request.self#?fuseaction=objects2.search">
					<table>
                        <tr>
                        	<td><cf_get_lang_main no='48.Filtre'></td>
                        	<td><cfinput type="text" name="keyword" id="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
                        	<td>
                            	<select name="forumid" id="forumid" style="width:150px;">
                                    <option value="0" selected><cf_get_lang_main no='669.Hepsi'>
                                    <cfloop query="forums">
                                        <option value="#forums.forumid#">#forums.forumname#
                                    </cfloop> 
                                </select>
                        	</td>
                        	<td><cf_wrk_search_button></td>
                        </tr>
                  	</table>
                </cfform>
   			</td>
        </tr>
    </table>

	<table cellspacing="1" cellpadding="2" border="0" style="width:100%;">
		<cfset tr_topic=topic>
		<tr class="color-list" style="height:30px;">
	  		<td colspan="2">
	    		<table cellpadding="0" cellspacing="0" border="0" style="width:100%;">
        			<tr>
                        <td>#tr_topic#</td>
                        <td style="text-align:right; vertical-align:top;">
							<cfif len(forum_topic_file)>
                                <a href="javascript://" onClick="windowopen('#file_web_path#forum/#forum_topic_file#','large')"><img src="/images/asset.gif" title="Konuya Ekli Belge" border="0"></a>
                            </cfif>
                            <cfif locked neq 1>
                                <a href="#request.self#?fuseaction=objects2.form_add_reply&topicid=#attributes.topicid#"><img src="/images/out.gif" title="Cevap Ver" border="0"></a>
                            </cfif>
                            <cfparam name="attributes.page" default=1>
                            <cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
                            <cfparam name="attributes.totalrecords" default='#replies.recordcount#'>
                            <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
                        </td>
					</tr>
				</table>
			</td>
		</tr>
			</cfoutput>
                <cfif replies.recordcount>
                    <cfoutput query="replies">
                        <cfquery name="GET_RELATION_REPLY" datasource="#DSN#">
                            SELECT USERKEY, IMAGEID, UPDATE_DATE, REPLY FROM FORUM_REPLYS WHERE RELATION_REPLYID = <cfqueryparam cfsqltype="cf_sql_integer" value="#replyid#">
                        </cfquery>
                        <cfset attributes.userkey = userkey>
                        <cfinclude template="../query/get_user_reply_count.cfm">
                        <cfinclude template="../query/get_username.cfm">
                        <tr class="color-row">
                            <td  style="width:150px; vertical-align:top;"> 
                                <span class="formbold">#get_username.username#</span>,&nbsp;
                                <cfif listfirst(attributes.userkey,"-") is "e">
                                    <cf_online id="#listlast(attributes.userkey,"-")#" zone="ep">
                                <cfelseif listfirst(attributes.userkey,"-") is "p">
                                    <cf_online id="#listlast(attributes.userkey,"-")#" zone="pp">
                                <cfelseif listfirst(attributes.userkey,"-") is "c">
                                    <cf_online id="#listlast(attributes.userkey,"-")#" zone="ww">
                                </cfif>
                                <br/><cf_get_lang no='994.Mesaj Sayısı'>#user_reply_count.total#<br/>
                            </td>
                            <td style="vertical-align:top;"> 
                                <table border="0" cellspacing="0" cellpadding="0" style="width:99%;">
                                    <tr> 
                                        <td><img src="/objects2/forum/images/data/icon#imageid#.gif" width="20" height="20" title="Konu" border="0"> <cf_get_lang_main no='330.Tarih'> #dateformat(date_add('h',session_base.time_zone,update_date),'dd/mm/yyyy')# (#timeformat(date_add('h',session_base.time_zone,update_date),'HH:MM')#)</td>
                                        <td style="text-align:right;">
                                            <cfif head_topic.locked neq 1>
                                                <a href="#request.self#?fuseaction=objects2.form_add_reply&topicid=#attributes.topicid#&replyid=#replyid#"><img src="/images/out.gif" title="Cevap Ver" border="0"></a> 
                                            </cfif>
                                        </td>
                                    </tr>
                                    <tr> 
                                        <td colspan="2" align="center"><img src="/images/cizgi_yan_1pix.gif" style="width:100%; height:1px;"></td>
                                    </tr>
                                    <tr> 
                                        <td colspan="2">#reply#</td>
                                    </tr>
                                </table>
                                <br/>
                            </td>
                        </tr>
                        <cfloop query="get_relation_reply">
                            <cfset attributes.userkey = get_relation_reply.userkey>
                            <cfinclude template="../query/get_user_reply_count.cfm">
                            <cfinclude template="../query/get_username.cfm">
                            <tr class="color-row">
                                <td width="150" valign="top"> 
                                    <span class="formbold">#get_username.username#</span>,&nbsp;
                                    <cfif listfirst(attributes.userkey,"-") is "e">
                                        <cf_online id="#listlast(attributes.userkey,"-")#" zone="ep">
                                    <cfelseif listfirst(attributes.userkey,"-") is "p">
                                        <cf_online id="#listlast(attributes.userkey,"-")#" zone="pp">
                                    <cfelseif listfirst(attributes.userkey,"-") is "c">
                                        <cf_online id="#listlast(attributes.userkey,"-")#" zone="ww">
                                    </cfif>
                                    <br/><cf_get_lang no='994.Mesaj Sayısı'>#user_reply_count.total#<br/>
                                </td>
                                <td style="vertical-align:top;"> 
                                    <table border="0" cellspacing="0" cellpadding="0" style="width:99%;">
                                        <tr> 
                                            <td><img src="/objects2/forum/images/data/icon#imageid#.gif" width="20" height="20" title="Konu" border="0"> <cf_get_lang_main no='330.Tarih'> #dateformat(date_add('h',session_base.time_zone,update_date),'dd/mm/yyyy')# (#timeformat(date_add('h',session_base.time_zone,update_date),'HH:MM')#)</td>
                                            <td  style="text-align:right;">
                                                <cfif head_topic.locked neq 1>
                                                    <a href="#request.self#?fuseaction=objects2.form_add_reply&topicid=#attributes.topicid#&replyid=#replies.replyid#"><img src="/images/out.gif" title="Cevap Ver" border="0"></a> 
                                                </cfif>
                                            </td>
                                        </tr>
                                        <tr> 
                                            <td colspan="2" align="center"><img src="/images/cizgi_yan_1pix.gif" style="width:100%; height:1px;"></td>
                                        </tr>
                                        <tr> 
                                            <td colspan="2">#reply#</td>
                                        </tr>
                                    </table>
                                    <br/>
                                </td>
                            </tr>
                        </cfloop>
                    </cfoutput>
                    <cfoutput query="head_topic">
                        <tr class="color-list" height="30">
                            <td colspan="2"  style="text-align:right;">
                                <cfset lock = locked>
                                <cfif locked neq 1>
                                    <a href="#request.self#?fuseaction=objects2.form_add_reply&topicid=#attributes.topicid#"><img src="/images/out.gif" title="Cevap Ver" border="0"></a>
                                </cfif>
                            </td>
                        </tr>
                    </cfoutput>	
                <cfelse>
                    <tr class="color-row" style="height:20px;">
                        <td colspan="2"><cf_get_lang_main no='72.Kayıt Bulunamadı'></td>
                    </tr>
                </cfif>
            </table>
        </td>
    </tr>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
	<table width="98%" align="center" border="0">
		<tr> 
			<td><cf_pages page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="objects2.view_reply&TOPICID=#TOPICID#"></td>
			<td width="275"  style="text-align:right;"><cfoutput>Toplam Kayıt#attributes.totalrecords# - Sayfa#attributes.page#/#lastpage#</cfoutput></td>
		</tr>
	</table>
</cfif>
<br/>
