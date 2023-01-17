<cfinclude template="../query/get_forums.cfm">
<cfinclude template="../query/get_topic.cfm">

<table align="center" cellpadding="0" cellspacing="0" border="0" height="35" style="width:100%; height:35px;">
	<tr> 
		<td class="headbold"><cf_get_lang no='991.Konu Düzenle'></td>
	</tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" align="center" style="width:100%">
	<tr class="color-border">
		<td>
			<table border="0" cellspacing="1" cellpadding="2" align="center" style="width:100%">
				<cfform enctype="multipart/form-data" action="#request.self#?fuseaction=objects2.emptypopup_upd_topic" method="post" name="upd_topic">
				<input type="hidden" name="topicid" id="topicid" value="<cfoutput>#attributes.topicid#</cfoutput>">
				<input type="hidden" name="topic_attach" id="topic_attach" value="<cfoutput>#topic.forum_topic_file#</cfoutput>">
				<input type="hidden" name="topic_attach_server_id" id="topic_attach_server_id" value="<cfoutput>#topic.forum_topic_file_server_id#</cfoutput>">
				<tr class="color-row">
					<td style="width:100px; vertical-align:top">
  	  					<table>
							<tr style="height:20px;">
								<td class="txtboldblue"><cf_get_lang no='983.İmge Seçiniz'></td>
							</tr>
							<cfloop from="1" to="16" index="i">
								<cfoutput>
								<tr>
									<td><input type="radio" name="imageid" id="imageid" value="#i#" <cfif i is topic.imageid>checked</cfif>> <img src="/forum/images/data/icon#i#.gif" border="0"></td>
								</tr>
								</cfoutput>
							</cfloop>
		 				</table>
					</td>
					<td style="vertical-align:top">
 						<table>
    						<tr style="height:20px;">
								<td class="txtboldblue">&nbsp;&nbsp;<cf_get_lang no='986.Forum Adı'></td>
							</tr>
    						<tr> 
								<td>&nbsp;
									<select name="forumid" id="forumid" style="width:200px;">
								  		<cfoutput query="forums">
											<option value="#forumid#" <cfif forumid eq topic.forumid>selected</cfif>>#forumname#
								  		</cfoutput>
								  	</select>
									<cfif isdefined("session.ww.userid")>
										<input type="checkbox" name="email_emp" id="email_emp" value="<cfoutput>#session.ww.userid#</cfoutput>" <cfif len(topic.email_emps) and listfindnocase(topic.email_emps,session.ww.userid) neq 0>checked</cfif>>
									<cfelseif isdefined("session.pp.userid")>
										<input type="checkbox" name="email_emp" id="email_emp" value="<cfoutput>#session.pp.userid#</cfoutput>" <cfif len(topic.email_emps) and listfindnocase(topic.email_emps,session.pp.userid) neq 0>checked</cfif>>
									</cfif>
       								<cf_get_lang no='984.Cevapları Mail Gönder'> &nbsp;<input type="checkbox" name="locked" id="locked" value="1" <cfif topic.locked eq 1>checked</cfif>>  <cf_get_lang no='987.Yeni Cevap Kapalı'>
	  							</td>
    						</tr>
							<tr style="height:20px;"> 
      							<td class="txtboldblue">&nbsp;&nbsp;<cf_get_lang_main no='68.Başlık'></td>
	  						</tr>
							<tr> 
							  	<td>&nbsp;&nbsp;<input type="text" name="title" id="title"  style="width:96%" value="<cfoutput>#topic.title#</cfoutput>"></td>
							</tr>
							<tr> 
      							<td>
                                	<cfmodule template="../../../fckeditor/fckeditor.cfm"
                                        toolbarset="Basic"
                                        basepath="/fckeditor/"
                                        instancename="topic"
                                        valign="top"
                                        value="#topic.topic#"
                                        width="550"
                                        height="300">
	                             </td>
    						</tr>
							<tr style="height:20px;">
							  	<td class="txtboldblue">&nbsp;&nbsp;<cf_get_lang_main no='56.Belge'></td>
							</tr>	    
							<tr>
								<td>&nbsp;
									<cfif len(topic.forum_topic_file)>
										<cfoutput><a href="javascript://" onclick="windowopen('#file_web_path#forum/#topic.forum_topic_file#','large')"><img src="/images/asset.gif" border="0" title="Belgeyi Gör" align="absmiddle"></cfoutput></a>
										<input type="checkbox" name="delete" id="delete" value="">
										<cf_get_lang no='989.Eski Belgeyi Sil'>
									<cfelse>
										<cf_get_lang no='990.Ekli Belge Yok'>
									</cfif>
								</td>
							</tr>
							<tr style="height:20px;">  
							  	<td class="txtboldblue">&nbsp;&nbsp;<cf_get_lang_main no='103.Dosya Ekle'></td>
							</tr>		
							<tr>
							  	<td>&nbsp;&nbsp;<input type="file" name="attach_topic_file" id="attach_topic_file" style="width:96%"></td>
							</tr>	
							<tr style="height:35px;">  
							  	<td style="text-align:right;">
									<cf_workcube_buttons 
									  	is_upd='1' 
									  	delete_page_url='#request.self#?fuseaction=objects2.emptypopup_del_topic' 
									  	add_function='OnFormSubmit()'> 
							 			&nbsp;&nbsp;&nbsp;&nbsp;
							  	</td>
    						</tr>
						</table>
					</td>
				</tr>
				</cfform>
			</table>
		</td>
	</tr>
</table>
<br/>

