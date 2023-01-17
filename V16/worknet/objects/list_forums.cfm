<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>	
<cfset getForum = createObject("component","worknet.objects.forums").getForum(keyword:attributes.keyword,status:1) />
<cfparam name="attributes.totalrecords" default="#getForum.recordcount#">

<div class="haber_liste">
	<div class="haber_liste_1">
		<div class="haber_liste_11"><h1><cf_get_lang_main no='9.FORUM'></h1></div>
	</div>
	<div class="forum">
		<div class="forum_1">
			<cfform name="search_" action="" method="post">
			<cfif len(attributes.content_head_id)>
				<samp style="width:550px;">
					<cfoutput>#createObject("component","worknet.objects.worknet_objects").getContent(content_id:attributes.content_head_id)#</cfoutput>
				</samp>
			</cfif>
            <div class="forum_11">
				<input class="mesaj_11_txt" name="keyword" id="keyword" type="text" value="<cfoutput>#attributes.keyword#</cfoutput>" style="border:0;" />
				<input class="mesaj_11_btn" name="" type="button" onclick="formSearch();" style="border:0;"/>
			</div>
            </cfform>
		   <div class="forum_12"><a href="<cfoutput>#request.self#?fuseaction=worknet.detail_content&cid=#attributes.forum_rules_id#</cfoutput>" target="_blank"><cf_get_lang no='193.Forum Kuralları'></a></div>
		</div>
		<div class="forum_2">
			<div class="forum_21">
				<div class="forum_211" style="width:196px;"><cf_get_lang_main no='68.Konu'></div>
				<div class="forum_211" style="width:555px;"><cf_get_lang_main no='217.Açıklama'></div>
				<div class="forum_211" style="width:95px; border-right:none;"><cf_get_lang no='190.Başlık Sayısı'></div>
			</div>
			<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tablo">
				<cfif getForum.recordcount>
					<cfoutput query="getForum" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
						<tr <cfif (currentrow mod 2) eq 0>class="mesaj_35"<cfelse>class="mesaj_34"</cfif>>
							<td class="tablo1" style="width:196px;"><a href="#request.self#?fuseaction=worknet.forum_topics&forumid=#forumid#">#forumname#</a></td>
							<td class="tablo1" style="width:555px;">#left(description,150)#</td>
							<td class="tablo1" style="width:95px; border-right:none; text-align:center;">#topic_count#</td>
						</tr>
					</cfoutput>	
				<cfelse>
					<tr class="mesaj_34">
					 	<td class="tablo1" colspan="5"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
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
</div>
<script language="javascript">
	function formSearch()
	{
		document.getElementById('search_').submit();
	}
</script>
