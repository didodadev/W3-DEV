<!---<cfif isdefined('session.pp.userid')>--->
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.page" default="1">
	<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>	
	<cfset getForumName = createObject("component","worknet.objects.forums").getForum(forumid:attributes.forumid) />
	<cfset getTopic = createObject("component","worknet.objects.forums").getTopic(keyword:attributes.keyword,forumid:attributes.forumid,topic_status:1) />
	<cfparam name="attributes.totalrecords" default="#getTopic.recordcount#">
	
	<div class="haber_liste">
		<div class="haber_liste_1">
			<div class="haber_liste_11"><h1><cf_get_lang_main no='9.FORUM'></h1></div>
		</div>
		<div class="forum">
			<div class="forum_1">
				<cfform name="search_" action="" method="post">
                <div class="forum_11">
                    <input class="mesaj_11_txt" name="keyword" id="keyword" type="text" value="<cfoutput>#attributes.keyword#</cfoutput>" style="border:0;" />
                    <input class="mesaj_11_btn" name="" type="button" style="border:0;"/>
                </div>
                </cfform>
			   <div class="forum_12"><a href="<cfoutput>#request.self#?fuseaction=worknet.detail_content&cid=#attributes.forum_rules_id#</cfoutput>" target="_blank"><cf_get_lang no='193.Forum Kuralları'></a></div>
			   <div class="forum_14"><cfoutput>#getForumName.forumname#</cfoutput></div>
			</div>
			<div class="forum_2">
				<div class="forum_21">
					<div class="forum_211" style="width:470px;"><cf_get_lang_main no='1408.Başlık'></div>
					<div class="forum_211" style="width:175px;"><cf_get_lang no='192.Başlığı Oluşturan'></div>
					<div class="forum_211" style="width:75px;"><cf_get_lang_main no='330.Tarih'></div>
					<div class="forum_211" style="width:105px; border-right:none;"><cf_get_lang no='191.Mesaj Sayısı'></div>
				</div>
				<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tablo">
					<cfif getTopic.recordcount>
						<cfoutput query="getTopic" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
							<tr <cfif (currentrow mod 2) eq 0>class="mesaj_35"<cfelse>class="mesaj_34"</cfif>>
								<td class="tablo1" style="width:470px;"><a href="#request.self#?fuseaction=worknet.forum_replies&topicid=#topicid#">#title#</a></td>
								<td class="tablo1" style="width:175px;">#name#</td>
								<td class="tablo1" style="width:75px;">#dateformat(date_add('h',session_base.time_zone,record_date),dateformat_style)#</td>
								<td class="tablo1" style="width:105px; border-right:none; text-align:center;">#reply_count#</td>
							</tr>
						</cfoutput>	
					<cfelse>
						<tr class="mesaj_34">
							<td class="tablo1" colspan="4"> <cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
						</tr>
					</cfif>
				</table>
			</div>
		</div>
        
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
		<div class="haber_detay_3">
			<a href="<cfoutput>#request.self#?fuseaction=worknet.forums</cfoutput>"><cf_get_lang no='194.Geri Dön'></a>
		</div>
	</div>
<!---<cfelseif isdefined("session.ww.userid")>
	<script>
		alert('Bu sayfaya erişmek için firma çalışanı olarak giriş yapmanız gerekmektedir!');
		history.back();
	</script>
	<cfabort>
<cfelse>
	<cfinclude template="member_login.cfm">
</cfif>--->
