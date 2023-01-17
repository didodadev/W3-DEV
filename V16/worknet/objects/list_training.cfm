<cfif isdefined('attributes.cat_id') and len(attributes.cat_id)>
	<cfparam name="attributes.training_cat_id" default="#attributes.cat_id#">
<cfelse>
	<cfparam name="attributes.training_cat_id" default="">
</cfif>
<cfif isdefined('attributes.sec_id') and len(attributes.sec_id)>
	<cfparam name="attributes.training_sec_id" default="#attributes.sec_id#">
<cfelse>
	<cfparam name="attributes.training_sec_id" default="">
</cfif>

<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfset getTraining = createObject("component","worknet.objects.worknet_objects").getTraining(
	training_type:attributes.training_type,
	cat_id:attributes.training_cat_id,
	sec_id:attributes.training_sec_id,
	language:session_base.language
) />

<cfparam name="attributes.totalrecords" default="#getTraining.recordcount#">
<div class="haber_liste">
	<div class="haber_liste_1">
		<div class="haber_liste_11"><h1><cfif session_base.language is 'tr'>İHKİB<cfelse>IHKIB</cfif> <cf_get_lang no='207.Akademi'></h1></div>
	</div>
	<cfif len(attributes.content_head_id)>
		<div class="forum_1">
			<samp style="width:900px;">
				<cfoutput>#createObject("component","worknet.objects.worknet_objects").getContent(content_id:attributes.content_head_id)#</cfoutput>
			</samp>
		</div>
	</cfif>
	<div class="akademi_1">
		<div class="akademi_11">
			<cfif isdefined('session.pp.userid')>
				<cfset user_id = session.pp.userid>
				<cfset user_type = 1>
			<cfelseif isdefined('session.ww.userid')>
				<cfset user_id = session.ww.userid>
				<cfset user_type = 2>
			</cfif>
			
			<cfoutput>
			<ul>
				<li><a <cfif attributes.training_type eq 0>class="aktif"</cfif> href="#request.self#?fuseaction=worknet.list_training"><cf_get_lang no='198.Guncel Egitimler'></a></li>
				<li><a <cfif attributes.training_type eq 1>class="aktif"</cfif> href="#request.self#?fuseaction=worknet.online_training"><cf_get_lang no='199.Online Egitimler'></a></li>
				<li><a href="#request.self#?fuseaction=worknet.my_training"><cf_get_lang no='200.Aldigim Egitimler'></a></li>
				<!---<li><a href="training_demands"><cf_get_lang no='213.Eğitim Taleplerim'></a></li>--->
				<li style="margin-right:0px;">
					<a href="training_recommendations"><cf_get_lang no='201.Egitim Onerileri'>
						<cfif isdefined('user_id')>
                            <cfset getTRNotRead = createObject("component","worknet.objects.worknet_objects").getTrainingRecommendations(member_id:user_id,member_type:user_type,is_read:0) />
                            <cfif getTRNotRead.recordcount><samp><cfoutput>#getTRNotRead.recordcount#</cfoutput></samp></cfif>
                        </cfif>
                   	</a>
				</li>
			</ul>
			</cfoutput>
		</div>
		<div class="akademi_12">
			<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tablo">
				<tr class="mesaj_31">
					<td width="15" class="mesaj_311_1"><cf_get_lang_main no='75.No'></td>
					<td class="mesaj_311_1"><cf_get_lang_main no='7.Egitim'></td>
					<td class="mesaj_311_1"><cf_get_lang_main no='74.Kategori'></td>
					<cfif attributes.training_type eq 1>
						<td class="mesaj_311_1"><cf_get_lang_main no='89.Baslangic'></td>
						<td class="mesaj_311_1"><cf_get_lang_main no='90.Bitis'></td>
						<td class="mesaj_311_1"><cf_get_lang_main no='344.Durum'></td>
					</cfif>
				</tr>
				<cfif getTraining.recordcount>
					<cfoutput query="getTraining" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
						<tr <cfif (currentrow mod 2) eq 0>class="mesaj_35"<cfelse>class="mesaj_34"</cfif>>
							<td class="tablo1">#currentrow#</td>
							<td class="tablo1"><a href="#request.self#?fuseaction=worknet.dsp_training&id=#class_id#">#class_name#</a></td>
							<td class="tablo1" style="padding-left:5px;">#training_cat#<cfif len(section_name)> <br/> #section_name#</cfif></td>
							<cfif attributes.training_type eq 1>
								<td class="tablo1">#dateformat(start_date,dateformat_style)# #timeformat(date_add('h',session_base.time_zone,start_date),timeformat_style)#</td>
								<td class="tablo1">#dateformat(finish_date,dateformat_style)# #timeformat(date_add('h',session_base.time_zone,finish_date),timeformat_style)#</td>
								<td class="tablo2" style="padding-left:5px;">
									<cfif len(finish_date) and len(start_date) AND ((datediff('n',now(),start_date) lte 15) and (datediff('n',now(),finish_date) gte 0)) and (online eq 1)>
										<font color="red"><cf_get_lang no='216.Canlı'></font>
									<cfelse>
										<cf_get_lang no='217.Başlamadı'>
									</cfif>
								</td>
							</cfif>
						</tr>
					</cfoutput>
				<cfelse>
					<tr class="mesaj_34">
						<td class="tablo1" colspan="6"> <cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
					</tr>
				</cfif>
			</table>
		</div>
		<div class="maincontent">
			<cfif attributes.totalrecords gt attributes.maxrows>
				<cfset urlstr="&training_cat_id=#attributes.training_cat_id#&training_sec_id=#attributes.training_sec_id#">
			
						  <cf_paging page="#attributes.page#" 
							page_type="1"
							maxrows="#attributes.maxrows#" 
							totalrecords="#attributes.totalrecords#" 
							startrow="#attributes.startrow#" 
							adres="#attributes.fuseaction##urlstr#">
						
			</cfif>
		</div>
	</div>
	<cfinclude template="training_cat.cfm">
</div>
