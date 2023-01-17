<cfif isdefined('session.pp.userid')>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfset getTrainingDemands = createObject("component","worknet.objects.worknet_objects").getTraining() />
<cfset getTraining.recordcount = 0>
<cfparam name="attributes.totalrecords" default="#getTrainingDemands.recordcount#">
<div class="haber_liste">
	<div class="haber_liste_1">
		<div class="haber_liste_11"><h1>İHKİB <cf_get_lang no='207.Akademi'></h1></div>
	</div>
	<div class="akademi_1">
		<div class="akademi_11">
			<cfoutput>
			<ul>
				<li><a href="#request.self#?fuseaction=worknet.list_training"><cf_get_lang no='198.Guncel Egitimler'></a></li>
				<li><a href="#request.self#?fuseaction=worknet.online_training"><cf_get_lang no='199.Online Egitimler'></a></li>
				<li><a href="#request.self#?fuseaction=worknet.my_training"><cf_get_lang no='200.Aldigim Egitimler'></a></li>
				<!---<li><a class="aktif" href="training_demands"><cf_get_lang no='213.Eğitim Taleplerim'></a></li>--->
				<li style="margin-right:0px;"><a href="training_recommendations"><cf_get_lang no='201.Egitim Onerileri'></a></li>
			</ul>
			</cfoutput>
		</div>
		<div class="akademi_12">
			<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tablo">
				<tr class="mesaj_31">
					<td width="15" class="mesaj_311_1"><cf_get_lang_main no='75.No'></td>
					<td class="mesaj_311_1"><cf_get_lang_main no='7.Egitim'></td>
					<td class="mesaj_311_1"><cf_get_lang_main no='74.Kategori'></td>
				</tr>
				<cfif getTraining.recordcount>
					<cfoutput query="getTrainingDemands" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
						<tr <cfif (currentrow mod 2) eq 0>class="mesaj_35"<cfelse>class="mesaj_34"</cfif>>
							<td class="tablo1">#currentrow#</td>
							<td class="tablo1"><a href="#request.self#?fuseaction=worknet.dsp_training&id=#class_id#">#class_name#</a></td>
							<td class="tablo2" style="padding-left:5px;">#training_cat#<cfif len(section_name)> / #section_name#</cfif></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr class="mesaj_34">
						<td class="tablo1" colspan="6"> <!---<cf_get_lang_main no='72.Kayıt Bulunamadı'>!---> Yapım Aşamasında...</td>
					</tr>
				</cfif>
			</table>
		</div>
		<div class="haber_liste_3">
			<ul>
				<cfif attributes.totalrecords gt attributes.maxrows>
					<cfset urlstr="">
				
							  <cf_paging page="#attributes.page#" 
								page_type="3"
								maxrows="#attributes.maxrows#" 
								totalrecords="#attributes.totalrecords#" 
								startrow="#attributes.startrow#" 
								adres="#attributes.fuseaction##urlstr#">
						
				</cfif>
			</ul>
		</div>
	</div>
	<cfinclude template="training_cat.cfm">
</div>
<cfelseif isdefined("session.ww.userid")>

	<script>

		alert('Bu sayfaya erişmek için firma çalışanı olarak giriş yapmanız gerekmektedir!');

		history.back();

	</script>

	<cfabort>
<cfelse>
	<cfinclude template="member_login.cfm">
</cfif>
