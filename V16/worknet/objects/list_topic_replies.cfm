<cfif isdefined('session.pp.userid')>	
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.page" default="1">
	<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>	
	<cfset getTopic = createObject("component","worknet.objects.forums").getTopic(topicid:attributes.topicid) />
	<cfset getReply = createObject("component","worknet.objects.forums").getReply(topicid:attributes.topicid,reply_status:1) />
	<cfparam name="attributes.totalrecords" default="#getReply.recordcount#">
	
	<div class="haber_liste">
		<div class="haber_liste_1">
			<div class="haber_liste_11"><h1><cf_get_lang_main no='9.FORUM'></h1></div>
		</div>
		
        <div class="forum">
            <div class="forum_1">
              <div class="forum_12"><a href="<cfoutput>#request.self#?fuseaction=worknet.detail_content&cid=#attributes.forum_rules_id#</cfoutput>" target="_blank"><cf_get_lang no='193.Forum Kuralları'></a></div>
               <div class="forum_14"><cfoutput>#getTopic.forumname#</cfoutput></div>
            </div>
            <div class="forum_3">
                <div class="forum_31">
                    <div class="forum_311"><cfoutput>#getTopic.title#</cfoutput></div>
                    <div class="forum_312"><cfoutput>#getTopic.name#</cfoutput></div>
                    <div class="forum_313"><cfoutput>#dateformat(date_add('h',session_base.time_zone,getTopic.record_date),dateformat_style)#</cfoutput></div>
                </div>
                <div class="forum_32"><cfoutput>#getTopic.topic#</cfoutput></div>
            </div>
            <div class="forum_33">
                <div class="forum_331"><cf_get_lang no='196.Yanıtlar'></div>
                <div class="forum_332">
                    <input type="button" class="forum_35_btn" name="reply_button" id="reply_button" value="<cf_get_lang no='197.Yanıtla'>" style="border:none;" onclick="quick_reply();"/>
                </div>
            </div>
    
             <cfif getReply.recordcount>
				 <cfoutput query="getReply" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                      <div class="forum_34">
                        <div style="margin-bottom:10px;">
                              
                              <div>
                               <cfif not(hierarchy contains '.')>
                               	<div class="forum_341"></div>
                               	 <div class="forum_342">
                                 <span>
										<cfif len(record_par)>
											<a href="#request.self#?fuseaction=worknet.dsp_partner&pid=#record_par#">#name#</a>
										<cfelse>
											#name#
										</cfif>
										&nbsp; -#dateformat(date_add('h',session.pp.time_zone,getReply.reply_date),dateformat_style)# #timeformat(date_add('h',session.pp.time_zone,getReply.reply_date),timeformat_style)#
								 </span>
								 <samp>#reply#</samp>
                                 </div>
                                 <cfelse>
                                 <div class="forum_341" style="margin-left:33px; margin-top:-1px;"></div>
                                 <table class="forum_342_table">
                                    <tr>
                                        <td valign="top">
                                        <span>
											<cfif len(record_par)>
                                   				<a href="#request.self#?fuseaction=worknet.dsp_partner&pid=#record_par#">#name#</a>
											<cfelse>
												#name#
											</cfif>
												&nbsp; -#dateformat(date_add('h',session.pp.time_zone,getReply.reply_date),dateformat_style)# #timeformat(date_add('h',session.pp.time_zone,getReply.reply_date),timeformat_style)#
										 </span><br />
										 <samp>#reply#</samp>
                                        </td>
                                    </tr>
                                </table>
                                 
                                </cfif>
                             </div>
                       </div>
                     </div> 
                    </cfoutput>
            <cfelse>
                <div class="forum_34">
                    <div class="forum_341"></div>
                    <div class="forum_342">
                        <span>&nbsp;</span>
                        <samp><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</samp>
                        <span>&nbsp;</span>
                    </div>
                </div>
            </cfif>        

            <div class="maincontent">
				<cfif attributes.totalrecords gt attributes.maxrows>
                    <cfset urlstr="&keyword=#attributes.keyword#">
                   
                              <cf_paging page="#attributes.page#" 
                                page_type="1"
                                maxrows="#attributes.maxrows#" 
                                totalrecords="#attributes.totalrecords#" 
                                startrow="#attributes.startrow#" 
                                adres="#attributes.fuseaction##urlstr#">
                            
                </cfif>
            </div>
           
			<input type="hidden" name="topicid" id="topicid" value="<cfoutput>#getTopic.topicid#</cfoutput>" style="border:0;"/>	
			<div class="forum_35" id="message_forum">
				<div class="forum_351"></div>
				<div class="forum_352">
					<textarea class="forum_352_txa" name="reply_area" id="reply_area" style="border:0;"></textarea>
				</div>
				<input type="button" class="forum_35_btn" name="reply_button" id="reply_button" value="<cf_get_lang_main no='1331.Gönder'>" style="border:none;" onclick="add_reply();"/>
			</div>
			<div id="message_forum2" class="forum_311" style="border-right:none; display:none;">
				<cf_get_lang no='195.Teşekkürler Konu ile ilgili cevabınız alınmıştır Sistem moderatörü tarafından onaylandığında yayına alınacaktır'>
			</div>
        </div>
	</div>
	<script language="javascript">
		function quick_reply()
		{
			document.getElementById('reply_area').focus();
		}
	
		function add_reply()
		{   
			if(document.getElementById('reply_area').value == '')
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='131.Mesaj'>");
				document.getElementById('reply_area').focus();
				return false;
			}
			else
			{
				<cfoutput>
					AjaxPageLoad('#request.self#?fuseaction=worknet.emptypopup_query_forum_reply&topicid=#getTopic.topicid#&reply_area='+document.getElementById('reply_area').value+'');
				</cfoutput>
				gizle(message_forum);
				goster(message_forum2);
			}
		}
	</script>
<cfelseif isdefined("session.ww.userid")>

	<script>

		alert('Bu sayfaya erişmek için firma çalışanı olarak giriş yapmanız gerekmektedir!');

		history.back();

	</script>

	<cfabort>
<cfelse>
	<cfinclude template="member_login.cfm">
</cfif>
		
