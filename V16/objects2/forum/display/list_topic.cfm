<cfinclude template="../../login/send_login.cfm">
<cfif not isdefined("session_base.userid") and not isDefined("group_id_info")><cfexit method="exittemplate"></cfif>
<cfparam name="attributes.keyword" default="">
<cfif isDefined("group_id_info")><cfset session_base = session.ww></cfif>
<cfinclude template="../query/get_topics.cfm">
<cfinclude template="../query/get_forums.cfm">
<cfinclude template="../query/get_forum_name.cfm">
<cfparam name="attributes.page" default=1>
<cfif isdefined("session.pp")>
	<cfparam name="attributes.maxrows" default='#session.pp.maxrows#'>
<cfelseif isDefined('session.ww')>
	<cfparam name="attributes.maxrows" default='#session.ww.maxrows#'>
<cfelseif isDefined('session.cp')>
	<cfparam name="attributes.maxrows" default='#session.cp.maxrows#'>
</cfif>
<cfparam name="attributes.totalrecords" default=#topics.recordcount#>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>
<div align="center">
    <table cellpadding="0" cellspacing="0" align="center" style="width:98%;">
        <tr style="height:35px;">
            <td class="headbold"><cfoutput>#get_forum_name.forumname#</cfoutput></td>
            <td valign="bottom">
                <cfif not isDefined("group_id_info")>
                    <cfform method="post" action="#request.self#?fuseaction=objects2.view_topic">
                        <table align="right">
                            <tr>
                                <td><cf_get_lang_main no='48.Filtre'>:</td>
                                <td><cfinput type="text" name="keyword" id="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
                                <td>
                                    <select name="forumid" id="forumid" style="width:150px;">
                                        <option value="0" selected><cf_get_lang_main no='669.Hepsi'></option>
                                        <cfoutput query="forums">
                                            <option value="#forumid#">#forumname#</option>
                                        </cfoutput>
                                    </select>
                                </td>
                                <td><cf_wrk_search_button></td>
                            </tr>
                        </table>
                    </cfform>
                </cfif>
            </td>
        </tr>
    </table>
    
    <table cellspacing="1" cellpadding="2" align="center" style="width:98%;">
        <tr class="color-header" style="height:22px;">
            <td align="center" style="width:30px;"><a href="<cfoutput>#request.self#?fuseaction=objects2.form_add_topic&forumid=#attributes.forumid#</cfoutput>"><img title="Konu Ekle" src="/forum/images/data/add_subject.gif" border="0"></a></td>
            <td class="form-title">&nbsp;<cf_get_lang_main no='68.Konu'></td>
            <td class="form-title" style="width:150px;"><cf_get_lang no='979.Konuyu Açan'></td>
            <td class="form-title" style="width:40px;"><cf_get_lang_main no='1242.Cevap'></td>
            <td class="form-title" style="width:40px;"><cf_get_lang no='995.Okuyan'></td>
            <td class="form-title" style="width:120px;"><cf_get_lang_main no='68.Konu'></td>
            <td class="form-title" style="width:120px;"><cf_get_lang no='980.Son Cevap'></td>
            <td></td>
        </tr>
        <cfif topics.recordcount>
            <cfoutput query="topics" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr onmouseover="this.className='color-light';" onmouseout="this.className='color-row';" class="color-row" style="height:20px;">
                    <td align="center"><img src="forum/images/data/icon#imageid#.gif" title="" border="0"></td>
                    <td>
                        <cfif locked eq 1>
                            <img src="forum/images/data/icon_folder_locked.gif" title="Kapalı Konu" align="absmiddle">
                        </cfif>
                        <a href="#request.self#?fuseaction=objects2.view_reply&topicid=#topics.topicid#" class="tableyazi">#mid(title,1,35)#
                            <cfif len(title) gt 35> ... </cfif>
                        </a>
                    </td>
                    <cfset attributes.userkey = userkey>
                    <cfinclude template="../query/get_username.cfm">
                    <td>#get_username.username#</td>
                    <td align="center">#reply_count#</td>
                    <td align="center">#view_count#</td>
                    <td>&nbsp;#dateformat(date_add('h',session_base.time_zone,record_date),'dd/mm/yyyy')# (#timeformat(date_add('h',session_base.time_zone,record_date),'HH:MM')#)</td>
                    <cfset attributes.userkey = last_reply_userkey>
                    <td>
                        <cfif len(last_reply_date)>
                            #dateformat(date_add('h',session_base.time_zone,last_reply_date),'dd/mm/yyyy')#&nbsp; (#timeformat(date_add('h',session_base.time_zone,last_reply_date),'HH:MM')#)<br/>
                            - #get_username.username#
                        <cfelse>
                            <cf_get_lang no='981.Cevap Bulunamadı'>
                        </cfif>
                    </td>
                    <td align="center" width="30">
                        <cfif isdefined("session.ww.userid") and session.ww.userid eq topics.record_con>
                            <a href="#request.self#?fuseaction=objects2.form_upd_topic&topicid=#topics.topicid#"><img title="Konuyu Düzenle" src="/forum/images/data/add_subject.gif" border="0"></a>
                        <cfelseif isdefined("session.pp.userid") and session.pp.userid eq topics.record_par>
                            <a href="#request.self#?fuseaction=objects2.form_upd_topic&topicid=#topics.topicid#"><img title="Konuyu Düzenle" src="/forum/images/data/add_subject.gif" border="0"></a>
                        </cfif>
                    </td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr class="color-row" style="height:20px;">
                <td colspan="8"><cf_get_lang_main no='72.Kayıt Yok'> !</td>
            </tr>
        </cfif>
    </table>

	<cfif attributes.totalrecords gt attributes.maxrows>
        <table border="0" align="center" style="width:98%;">
            <tr style="height:22px;">
                <td align="left">
                    <cf_pages page="#attributes.page#"
                        maxrows="#attributes.maxrows#"
                        totalrecords="#attributes.totalrecords#"
                        startrow="#attributes.startrow#"
                        adres="objects2.view_topic&forumid=#attributes.forumid#"></td>
                <!-- sil --><td style="width:275px;text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
            </tr>
        </table>
    </cfif>
	<br/>
</div>

