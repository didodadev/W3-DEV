<cfif isdefined('session.pp.userid') or isdefined('session.ww.userid')>
	<cfparam name="attributes.page" default="1">
	<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	
	<cfif isdefined('session.pp.userid')>
		<cfset user_id = session.pp.userid>
		<cfset user_type = 1>
	<cfelseif isdefined('session.ww.userid')>
		<cfset user_id = session.ww.userid>
		<cfset user_type = 2>
	</cfif>
	<cfset getTrainingRecommendetions = createObject("component","worknet.objects.worknet_objects").getTrainingRecommendations(
		member_id:user_id,
		member_type:user_type
	) />
	
	<cfparam name="attributes.totalrecords" default="#getTrainingRecommendetions.recordcount#">
	<div class="haber_liste">
		<div class="haber_liste_1">
			<div class="haber_liste_11"><h1><cfif session_base.language is 'tr'>İHKİB<cfelse>IHKIB</cfif> <cf_get_lang no='207.Akademi'></h1></div>
		</div>
		<div class="akademi_1">
			<div class="akademi_11">
				<cfset getTRNotRead = createObject("component","worknet.objects.worknet_objects").getTrainingRecommendations(member_id:user_id,member_type:user_type,is_read:0) />
				<cfoutput>
				<ul>
					<li><a href="#request.self#?fuseaction=worknet.list_training"><cf_get_lang no='198.Guncel Egitimler'></a></li>
					<li><a href="#request.self#?fuseaction=worknet.online_training"><cf_get_lang no='199.Online Egitimler'></a></li>
					<li><a href="#request.self#?fuseaction=worknet.my_training"><cf_get_lang no='200.Aldigim Egitimler'></a></li>
					<li style="margin-right:0px;">
						<a class="aktif" href="training_recommendations"><cf_get_lang no='201.Egitim Onerileri'><cfif getTRNotRead.recordcount><samp><cfoutput>#getTRNotRead.recordcount#</cfoutput></samp></cfif></a>
					</li>
				</ul>
				</cfoutput>
			</div>
			<div class="akademi_12">
				<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tablo">
					<tr class="mesaj_31">
						<td width="15" class="mesaj_311_1"><cf_get_lang_main no='75.No'></td>
						<td class="mesaj_311_1"><cf_get_lang_main no='7.Egitim'></td>
						<td class="mesaj_311_1"><cf_get_lang no='206.Öneren'></td>
						<td class="mesaj_311_1"><cf_get_lang_main no='217.Açıklama'></td>
						<td class="mesaj_311_1"><cf_get_lang_main no='330.Tarih'></td>
					</tr>
					<cfif getTrainingRecommendetions.recordcount>
						<cfoutput query="getTrainingRecommendetions" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
							<tr <cfif (currentrow mod 2) eq 0>class="mesaj_35"<cfelse>class="mesaj_34"</cfif>>
								<td class="tablo1">#currentrow#</td>
								<td class="tablo1"><a href="#request.self#?fuseaction=worknet.dsp_training&id=#class_id#">#class_name#</a></td>
								<td class="tablo1">
									<cfif RECORDED_TYPE eq 1>
										<a href="#request.self#?fuseaction=worknet.dsp_partner&pid=#RECORDED_ID#">#oneren#</a>
									<cfelse>
										#oneren#
									</cfif>
								</td>
								<td class="tablo1" <cfif is_read eq 0> style="color:red;"</cfif>>#detail#</td>
								<td class="tablo2" style="padding-left:5px;">#dateformat(record_date,dateformat_style)#</td>
							</tr>
						</cfoutput>
					<cfelse>
						<tr class="mesaj_34">
							<td class="tablo1" colspan="6"> <cf_get_lang_main no='72.Kayıt Bulunamadı'></td>
						</tr>
					</cfif>
				</table>
			</div>
			
			<div class="maincontent">
				<cfif attributes.totalrecords gt attributes.maxrows>
					<cfset urlstr="">
				
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
		<!--- okunmamıs oneriler okundu olarak isaretleniyor --->
		<cfset createObject("component","worknet.objects.worknet_objects").updTrainingRecommendations(member_id:user_id,member_type:user_type) />
	</div>
<cfelse>
	<cfinclude template="member_login.cfm">
</cfif>
