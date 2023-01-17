<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.special_definition" default="">
<cfinclude template="../query/get_head_topic.cfm">
<cfinclude template="../query/get_forums.cfm">
<cfinclude template="../query/get_replies.cfm">
<cfinclude template="../query/add_topic_count.cfm">
<cfinclude template="../query/get_email_alert.cfm"> 
<cfquery name="GET_SPECIAL_DEFINITION" datasource="#DSN#">
	SELECT SPECIAL_DEFINITION_ID,SPECIAL_DEFINITION FROM SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 8
</cfquery>
<cfif session.ep.admin eq 1>
	<cfset is_update_ = 1>
<cfelseif listlen(head_topic.admin_pos) and listfindnocase(head_topic.admin_pos,get_position_id(session.ep.position_code))>
	<cfset is_update_ = 1>
<cfelse>
	<cfset is_update_ = 0>
</cfif>
<cfoutput query="head_topic">
	<cfset attributes.userkey = userkey>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default='#replies.recordcount#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <table class="dph">
        <tr>
            <td class="dpht"><a href="#request.self#?fuseaction=forum.view_topic&forumid=#forumid#">#forumname#</a></td>
            <td class="dphb">
                <cfform method="post" action="">
                <table style="text-align:right;">
                    <input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
                    <input type="hidden" name="topicid" id="topicid" value="<cfif isdefined("attributes.topicid") and len(attributes.topicid)><cfoutput>#attributes.topicid#</cfoutput></cfif>">
                    <tr>
                        <td>
                            <select name="special_definition" id="special_definition" style="width:142px">
                                <option value="">Özel Tanım <cf_get_lang_main no='322.Seçiniz'></option>
                                <cfloop query="get_special_definition">
                                    <option value="#special_definition_id#" <cfif attributes.special_definition eq special_definition_id>selected</cfif>>#special_definition#</option>
                                </cfloop>
                            </select> 
                        </td>
                        <td>
                            <select name="reply_status" id="reply_status" style="width:80px;">
                                <option value=""><cf_get_lang_main no ='296.Tümü'></option>
                                <option value="1"<cfif isDefined("attributes.reply_status") and (attributes.reply_status eq 1)> selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
                                <option value="0"<cfif isDefined("attributes.reply_status") and (attributes.reply_status eq 0)> selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
                            </select>
                        </td>
                        <td><cf_get_lang_main no='48.Filtre'></td>
                        <td><cfinput type="text" name="keyword" id="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
                        <td><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                        </td>
                        <td><cf_wrk_search_button is_excel='0'></td>
                    </tr>
                </table>
                </cfform>
            </td>
        </tr>
    </table>
    <cfset tr_topic=topic>
    <table width="99%" align="center" style="border:1px solid ##069;">
        <tr>
            <td>
            <cf_area width="260">
                <table width="99%"cellpadding="2" cellspacing="2">
                    <tr>
                        <td class="formbold">
                            <cfinclude template="../query/get_username.cfm">
                            <cfif listfirst(attributes.userkey,"-") is "e">
                            	<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#listlast(attributes.userkey,"-")#','medium');" >#username.name# #username.surname#</a>
                            <cfelseif listfirst(attributes.userkey,"-") is "p">
                              	<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#listlast(attributes.userkey,"-")#','medium');" >#username.name# #username.surname#</a>
                            <cfelseif listfirst(attributes.userkey,"-") is "c">
                              	<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#listlast(attributes.userkey,"-")#','medium');" >#username.name# #username.surname#</a>
                            </cfif>
                        </td>
                    </tr>		
                    <tr>
                        <td>
                            <cfif listfirst(attributes.userkey,"-") is "e">
                                <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#listlast(attributes.userkey,"-")#','medium');"><img src="/images/messenger2.gif" title="<cf_get_lang no='64.Profil Göster'>"></a>
                            <cfelseif listfirst(attributes.userkey,"-") is "p">
                                <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#listlast(attributes.userkey,"-")#','medium');"><img src="/images/messenger2.gif" title="<cf_get_lang no='64.Profil Göster'>"></a>
                            <cfelseif listfirst(attributes.userkey,"-") is "c">
                                <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#listlast(attributes.userkey,"-")#','medium');"><img src="/images/messenger2.gif" title="<cf_get_lang no='64.Profil Göster'>"></a>
                            </cfif>
                            <cfif (trim(session.ep.userkey) is trim(userkey))>
                                <a href="#request.self#?fuseaction=forum.form_upd_topic&topicid=#attributes.topicid#"><img src="/images/messenger4.gif" title="<cf_get_lang_main no='52.Güncelle'>"></a>
                            </cfif>
                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_send_mail&email=#username.email#','list')"><img src="/images/messenger8.gif" title="<cf_get_lang_main no='63.Mail Gönder'>"></a>
                            <cfif locked neq 1>
                                <a href="#request.self#?fuseaction=forum.form_add_reply&topicid=#attributes.topicid#"><img src="/images/messenger5.gif" title="<cf_get_lang no='54.Konuya Cevap Ver'>" ></a>
                            </cfif>
                            <a href="javascript://" onclick="javascript:window.print();"><img src="/images/messenger3.gif" title="<cf_get_lang_main no='62.Yazdır'>"></a>
                            <cfparam name="attributes.page" default=1>
                            <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
                            <cfparam name="attributes.totalrecords" default="#replies.recordcount#">
                            <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
                        </td>
                    </tr>  
                </table>
            </cf_area>
            <cf_area>
                <table>
                    <tr>
                        <td>#tr_topic#</td>
                    </tr>
                    <tr>
                        <td>
                            <cfif len(forum_topic_file)>
                                <a href="javascript://" onclick="windowopen('#file_web_path#forum/#forum_topic_file#','large')"><img src="/images/attach.gif" title="<cf_get_lang no='67.Konuya Ekli Belge'>"><cf_get_lang no='67.Konuya Ekli Belge'></a>
                            </cfif>
                        </td>
                    </tr>
                </table>
            </cf_area>
           </td>
       </tr>
    </table>
    
    <table width="100%" height="15">
        <tr>
            <td class="color-header" width="100%" colspan="2"></td>
        </tr>
    </table>
</cfoutput>
<cfif replies.recordcount>
	<cfset user_reply_list = ValueList(replies.userkey,',')>
	<cfif len(user_reply_list)>
		<cfset user_reply_list = listsort(listdeleteduplicates(user_reply_list),'TEXT','ASC',',')>
		<cfquery name="USER_REPLY_COUNT" datasource="#DSN#">
			SELECT 
				COUNT(REPLYID) TOTAL,			
				RECORD_EMP
			FROM 
				FORUM_REPLYS
			WHERE 
                <cfloop from="1" to="#listlen(user_reply_list,',')#" index="i_"> 
                	USERKEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(user_reply_list,i_,',')#">
                    <cfif listlen(user_reply_list,',') neq i_> OR </cfif> 
                </cfloop>
			GROUP BY 
				RECORD_EMP
		</cfquery>
		<cfoutput query="user_reply_count">
			<cfset 'emp_count#record_emp#' = TOTAL ><!--- userkey string ifade içerdigi için record_emp atandı.20081028MA --->
		</cfoutput>
	</cfif>	
	<cfset ind = 0>
	<cfset main_reply = 1>
	<cfoutput query="replies" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		<cfset attributes.userkey = userkey>
		<cfinclude template="../query/get_username.cfm">
		<form name="print_form#ind#">
			<cfset cont = reply>
			<cfset cont = ReplaceList(cont,'#chr(39)#','')>
			<cfset cont = ReplaceList(cont,'#chr(10)#','')>
			<cfset cont = ReplaceList(cont,'#chr(13)#','')>
			<cfif listlen(hierarchy,'.') eq 1 and currentrow neq 1>
                <cfset main_reply = main_reply + 1>
            </cfif>
        	<table>
         		<tr>
           			<td>
           				<cf_area width="240">
                	<table width="98%">
                    <tr>
                        <td width="80">				
                        <cfif listfirst(attributes.userkey,"-") is "e">
                            <cf_online id="#listlast(attributes.userkey,"-")#" zone="ep">
                        <cfelseif listfirst(attributes.userkey,"-") is "p">
                            <cf_online id="#listlast(attributes.userkey,"-")#" zone="pp">
                        <cfelseif listfirst(attributes.userkey,"-") is "c">
                            <cf_online id="#listlast(attributes.userkey,"-")#" zone="ww">
                        </cfif>
                        </td>
                        <td>
                        <span class="formbold" style="cursor:pointer;">
                        <cfif listfirst(attributes.userkey,"-") is "e">
                            <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#listlast(attributes.userkey,"-")#','medium');"></a>
                        <cfelseif listfirst(attributes.userkey,"-") is "p">
                            <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#listlast(attributes.userkey,"-")#','medium');"></a>
                        <cfelseif listfirst(attributes.userkey,"-") is "c">
                            <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#listlast(attributes.userkey,"-")#','medium');"></a>
                        </cfif>#username.name# #username.surname#</span>
                        </td>                        
                    </tr>
                    <tr>
                    	<td class="txtbold"><cf_get_lang_main no='330.Tarih'></td>
                        <td>
                            :#dateformat(date_add('h',session.ep.time_zone,update_date),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,update_date),timeformat_style)#
                            <input type="hidden" name="forum_Date" id="forum_Date" value="#dateformat(date_add('h',session.ep.time_zone,update_date),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,update_date),timeformat_style)#)">
                            <input type="hidden" name="forum_Forum" id="forum_Forum" value="Forum / Konu : #head_topic.forumname# / #head_topic.title#">
                            <input type="hidden" name="forum_From" id="forum_From" value="#head_topic.forumname#&nbsp;Forum">
                            <input type="hidden" name="forum_Subject" id="forum_Subject" value="#head_topic.title#">
                            <input type="hidden" name="forum_Message" id="forum_Message" value="..:: #dateformat(date_add('h',session.ep.time_zone,update_date),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,update_date),timeformat_style)#) Tarihli Mesaj ::..<br/>#htmleditformat(cont)#">
                            <input type="hidden" name="forum_Reply" id="forum_Reply" value="#htmleditformat(cont)#">
                        </td>                        
                    </tr>
                    <tr>
                    	<td class="txtbold"><cf_get_lang no='52.Toplam Mesaj Sayısı'></td>
                        <td>				
                            :<cfif listfirst(attributes.userkey,"-") is "e">
                                <cfif isdefined('emp_count#username.EMPLOYEE_ID#')>#Evaluate('emp_count#username.EMPLOYEE_ID#')# <cfelse>0</cfif>	
                             <cfelseif listfirst(attributes.userkey,"-") is "p">
                                <cfif isdefined('emp_count#username.PARTNER_ID#')>#Evaluate('emp_count#username.PARTNER_ID#')# <cfelse>0</cfif>
                             <cfelseif listfirst(attributes.userkey,"-") is "c">
                                <cfif isdefined('emp_count#username.CONSUMER_ID#')>#Evaluate('emp_count#username.CONSUMER_ID#')# <cfelse>0</cfif>
                             </cfif>
                        </td>       
                    </tr>
                    <tr>
                        <td colspan="2">
                            <cfif is_update_ eq 1 or record_emp eq session.ep.userid>
                                <a href="#request.self#?fuseaction=forum.form_upd_reply&replyid=#replyid#&topicid=#topicid#"><img src="/images/messenger4.gif" title="<cf_get_lang no='60.Cevap Düzenle'>"></a>
                            </cfif>
                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_send_mail&editor_name=print_form#ind#.forum_Message&editor_header=print_form#ind#.forum_Subject&editor_From=print_form#ind#.forum_From&email=#username.email#','list');"><img src="/images/messenger8.gif" title="<cf_get_lang_main no='63.Mail Gönder'>"></a>
                            <cfif head_topic.locked neq 1>
                                <a href="#request.self#?fuseaction=forum.form_add_reply&topicid=#attributes.topicid#&replyid=#replyid#"><img src="/images/messenger5.gif" title="<cf_get_lang_main no='1242.Cevap Ver'>"></a>
                            </cfif>
                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_print_editor&editor_name=print_form#ind#.forum_Reply&editor_header=print_form#ind#.forum_Date&editor_Forum=print_form#ind#.forum_Forum&title1=Tarih&title2=','list');"><img src="/images/messenger3.gif" title="<cf_get_lang_main no='62.Yazdır'>"></a>
                        </td>
                    </tr>
                </table>
            </cf_area>
            <cf_area>         
               <table>
                    <tr>
                        <td>#reply#</td>
                    </tr>
                    <tr>
                        <td>
                        <cfif len(FORUM_REPLY_FILE)>
                        <a href="javascript://" onclick="windowopen('#file_web_path#forum/#FORUM_REPLY_FILE#','large')"><img src="/images/attach.gif" title="<cf_get_lang no='48.Cevaba Ekli Belge'>"></a>
                        </cfif>
                        </td>
                    </tr>
                </table>
            </cf_area>
            </td>
          </tr>
        </table>
        <table width="100%" height="15">
            <tr>
                <td class="color-header" width="100%" colspan="2"></td>
            </tr>
        </table>
        <cfset ind = ind + 1>
</form>
</cfoutput>
	<cfelse>
        <table>
            <tr>
                <td><cfif isdefined("attributes.is_form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'>!<!--- <cfelse><cf_get_lang_main no='289.Filtre Ediniz '>! ---></cfif></td>
            </tr>
        </table>
	</cfif>
<cfif head_topic.locked neq 1>
	<cfsavecontent variable="header"><cf_get_lang no ='72.Quick Reply'></cfsavecontent>
	<cf_form_box title="#header#">
	<cfform action="#request.self#?fuseaction=forum.emptypopup_add_reply" method="post" name="add_reply">
		<cfoutput>
			<input type="Hidden" name="topicid" id="topicid" value="#attributes.TOPICID#">     
			<cfmodule
				template="/fckeditor/fckeditor.cfm"
				toolbarset="Basic"
				basepath="/fckeditor/"
				instancename="reply"
				valign="top"
				value=""
				width="600"
				height="180">
         <table><tr><td><cf_form_box_footer><cf_workcube_buttons is_upd='0' is_cancel='0' insert_alert=''><!---  add_function='OnFormSubmit()' ---></cf_form_box_footer></td></tr></table>
		</cfoutput> 
	</cfform>
	</cf_form_box>
</cfif>
<cfif attributes.totalrecords gt attributes.maxrows>
	<table width="98%" align="center">
        <tr>
            <td> 
                <cf_pages 
                    page="#attributes.page#" 
                    maxrows="#attributes.maxrows#" 
                    totalrecords="#attributes.totalrecords#" 
                    startrow="#attributes.startrow#" 
                    adres="forum.view_reply&TOPICID=#TOPICID#&is_form_submitted=1"></td>
            <!-- sil --><td width="275"  style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
        </tr>
	</table>
</cfif>
