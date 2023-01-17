<cfinclude template="../../login/send_login.cfm">
<cfif not isdefined("session_base.userid")><cfexit method="exittemplate"></cfif>

<cfinclude template="../query/get_head_topic.cfm">
<cfif head_topic.locked eq 1>
	<cflocation url="#request.self#?fuseaction=objects2.forum" addtoken="No">
</cfif>
<cfinclude template="../query/get_reply.cfm">
<cfset attributes.topicid = reply.topicid>
<cfinclude template="../query/get_email_alert.cfm">

<table border="0" align="center" cellpadding="0" cellspacing="0" style="width:98%; height:35px;">
  	<tr>
    	<td class="headbold"> <cf_get_lang no='988.Cevap Düzenle'> </td>
  	</tr>
</table>
        
<cfform enctype="multipart/form-data" method="post" name="upd_reply" action="#request.self#?fuseaction=objects2.emptypopup_upd_reply">
<table border="0" align="center" cellpadding="0" cellspacing="0" style="width:98%;">
  	<tr class="color-border">
    	<td>
      		<table border="0" cellspacing="1" cellpadding="2" style="width:100%;">
                <input type="Hidden" name="replyid" id="replyid" value="<cfoutput>#attributes.replyid#</cfoutput>">
                <input type="Hidden" name="topicid" id="topicid" value="<cfoutput>#attributes.topicid#</cfoutput>">
                <input type="Hidden" name="reply_attach" id="reply_attach" value="<cfoutput>#reply.forum_reply_file#</cfoutput>">
                <input type="Hidden" name="reply_attach_server_id" id="reply_attach_server_id" value="<cfoutput>#reply.forum_reply_file_server_id#</cfoutput>">
                <tr class="color-row">
                    <td style="width:100px; vertical-align:top;">
                        <table border="0">
							<cfoutput>
                            	<cfloop from="1" to="16" index="i">
                            		<tr>
                            			<td><input type="radio" name="imageid" id="imageid" value="#i#" <cfif reply.imageid eq i>checked</cfif>>
                           			 	<img src="/forum/images/data/icon#i#.gif" border="0"></td>
                            		</tr>
                            	</cfloop>
                            </cfoutput>
                        </table>
                    </td>
                    <td style="vertical-align:top;">
                    	<table>
                            <tr>
                            	<td>
                                	&nbsp;
                            		<cfif isdefined("session.ww.userid")>
                                        <input type="Checkbox" name="email_emp" id="email_emp" value="<cfoutput>#session.ww.userid#</cfoutput>" <cfif listfindnocase(valuelist(email_alert.email_emps),session.ww.userid)>checked</cfif>>
                                        <cfelseif isdefined("session.pp.userid")>
                                        <input type="Checkbox" name="email_emp" id="email_emp" value="<cfoutput>#session.pp.userid#</cfoutput>" <cfif listfindnocase(valuelist(email_alert.email_emps),session.pp.userid)>checked</cfif>>
                            		</cfif>
                            		<cf_get_lang no='984.Cevapları Mail Gönder'>
                                </td>
                            </tr>
                            <tr>
                            	<cfset tr_reply = htmleditformat(reply.reply)>
                            	<td>
                                	<cfmodule template="../../../fckeditor/fckeditor.cfm"
                                        toolbarset="Basic"
                                        basepath="/fckeditor/"
                                        instancename="reply"
                                        valign="top"
                                        value="#reply.reply#"
                                        width="550"
                                        height="300">
                                </td>
                            </tr>
                            <tr style="height:20px;">
                            	<td class="txtboldblue">&nbsp;&nbsp;<cf_get_lang_main no='56.Belge'></td>
                            </tr>
                            <tr>
                            	<td>
                                	&nbsp;
                            		<cfif len(reply.forum_reply_file)>
                            			<cfoutput><a href="javascript://" onclick="windowopen('#file_web_path#forum/#reply.forum_reply_file#','large')"><img src="/images/asset.gif" border="0" title="Belgeyi Gör" align="absmiddle"></cfoutput></a>
                                        <input type="checkbox" name="delete" id="delete" value="">
                                        <cf_get_lang no='989.Eski Belgeyi Sil'>
                                    <cfelse>
                                        <cf_get_lang no='990.Ekli Belge Yok'>
                                    </cfif>
                                </td>
                            </tr>
                            <tr style="height:20px;">
                                <td class="txtboldblue">&nbsp;&nbsp;&nbsp;<cf_get_lang_main no='103.Dosya Ekle'></td>
                            </tr>
                            <tr>
                                <td> 
                					&nbsp;&nbsp;&nbsp;
                					<input type="file" name="attach_reply_file" id="attach_reply_file" style="width:96%">
                				</td>
                			</tr>
                			<tr>
                				<td style="text-align:right;">
                                    <cf_workcube_buttons 
                                        is_upd='1'  
                                        delete_page_url='#request.self#?fuseaction=objects2.emptypopup_del_reply&replyid=#attributes.replyid#&topicid=#attributes.topicid#' 
                                        add_function='OnFormSubmit()'>
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                				</td>
    						</tr>
    					</table>
    				</td>
    			</tr>
    		</table>
    	</td>
    </tr>
</table>
<br/>
</cfform>
