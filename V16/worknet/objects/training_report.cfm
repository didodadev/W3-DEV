<cfif isdefined('session.pp.userid')>
	<cfparam name="attributes.page" default="1">
	<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfset getPartner = createObject("component","V16.worknet.query.worknet_member").getPartner(company_id:session.pp.company_id) />
	<cfparam name="attributes.totalrecords" default="#getPartner.recordcount#">
	
	<div class="haber_liste">
		<div class="haber_liste_1">
			<div class="haber_liste_11"><h1><cf_get_lang no='287.Eğitim Raporu'></h1></div>
		</div>
		<div class="haber_liste_2">
	        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tablo">
               <tr class="mesaj_31">
                <td width="15" class="mesaj_311_1">No</td>
                <td class="mesaj_311_1"><cf_get_lang_main no='219.Ad'> <cf_get_lang_main no='1314.Soyad'></td>
                <td class="mesaj_311_1"><cf_get_lang_main no='41.Sube'></td>
				<td class="mesaj_311_1"><cf_get_lang_main no='161.Görev'></td>
                <td width="100" class="mesaj_311_1">Eğitim Sayısı</td>
               </tr>
			<cfif getPartner.recordcount>
				<cfoutput query="getPartner" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
					<tr <cfif (currentrow mod 2) eq 0>class="mesaj_35"<cfelse>class="mesaj_34"</cfif>>
                        <td class="tablo1">#currentrow#</td>
                        <td class="tablo1">
							<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.dsp_partner&pid=#getPartner.partner_id#">#getPartner.company_partner_name# #getPartner.company_partner_surname#</a>
						</td>
                        <td class="tablo1">
							<cfif (getPartner.compbranch_id eq 0) or not len(getPartner.compbranch_id)>
								<cf_get_lang no='143.Merkez Ofis'>
							<cfelse>
								#compbranch__name#
							</cfif>
						</td>
						<td class="tablo1">#PARTNER_POSITION#</td>
                        <td class="mesaj_311_1" style=" text-align:center; float:none;">
							<cfset get_data = createObject("component","worknet.objects.worknet_objects").getTrainingData(
								member_id:partner_id,
								member_type:1
							) />
							<cfif get_data.recordcount>
								<cfset encId = encrypt(partner_id, 'trainingDetail','CFMX_COMPAT','hex')>
								<cfset encName = encrypt("#getPartner.company_partner_name# #getPartner.company_partner_surname#",'trainingDetail','CFMX_COMPAT','hex')>
								<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.my_training&partner_id=#encId#&partnerName=#encName#" style=" text-align:center; float:none;">
									#get_data.recordcount#
								</a>
							<cfelse>
								0
							</cfif>
						</td>
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
				
						  <cf_paging page="#attributes.page#" 
							page_type="1"
							maxrows="#attributes.maxrows#" 
							totalrecords="#attributes.totalrecords#" 
							startrow="#attributes.startrow#" 
							adres="#attributes.fuseaction#">
					
			</cfif>
		</div>
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
