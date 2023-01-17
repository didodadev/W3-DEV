<cfif isdefined('session.pp')>
<cfset getPartner = createObject("component","V16.worknet.query.worknet_member").getPartner(partner_id:session.pp.userid)>
<cfset getMemberFollow = createObject("component","worknet.objects.worknet_objects").getMemberFollow(member_id:session.pp.userid)>
<cfset getProduct = createObject("component","V16.worknet.query.worknet_product").getProduct(
	company_id:getPartner.company_id,
	company_name:getPartner.fullname,
	product_status:1,
	is_catalog:0
)>
<cfset getDemand = createObject("component","V16.worknet.query.worknet_demand").getDemand(
	company_id:getPartner.company_id,
	company_name:getPartner.fullname,
	is_status:1,
	my_demand:1
)>
<cfset getMessage = createObject("component","worknet.objects.messages").getMessage(type:'inbox',sortfield:'IS_READ,SENT_DATE') />
<cfset getMessageNotRead = createObject("component","worknet.objects.messages").getMessage(type:'inbox',is_read:0) />
  
<div class="haber_liste">
	<div class="haber_liste_1">
		<div class="haber_liste_11"><h1><cfoutput>#session.pp.company# - #session.pp.name# #session.pp.surname#</cfoutput></h1></div>
	</div>
	<div class="dashboard">
		<div class="dashboard_1">
			<div class="dashboard_11">
				<span><img src="../documents/templates/worknet/tasarim/kutu_icon_4.png" class="chapterImage" alt="İcon" /></span>
				<h2><cf_get_lang no='97.Bilgilerim'></h2>
			</div>
			<cfoutput>
			<div class="dashboard_12">
				<div class="dashboard_121">
					<span style="width:110px;"><cf_get_lang_main no='219.Ad'> <cf_get_lang_main no='1314.Soyad'></span>
					<samp style="width:170px;">#session.pp.name# #session.pp.surname#</samp>
				</div>
				<div class="dashboard_121">
					<span><cf_get_lang_main no='16.E-Posta'></span>
					<samp title="#getPartner.company_partner_email#">#left(getPartner.company_partner_email,25)#</samp>
				</div>
				<div class="dashboard_121">
					<span><cf_get_lang_main no='87.Telefon'></span>
					<samp>#getPartner.company_partner_telcode# #getPartner.company_partner_tel#</samp>
				</div>
				<div class="dashboard_121">
					<span><cf_get_lang_main no='1195.Firma'></span>
					<samp>#getPartner.fullname#</samp>
				</div>
				<div class="dashboard_121">
					<span><cf_get_lang_main no='159.Ünvan'></span>
					<samp>#getPartner.title#</samp>
				</div>
				<div class="dashboard_126">
					<a class="dashboard_162_duzenle" href="#request.self#?fuseaction=worknet.detail_partner&pid=#session.pp.userid#"><font color="FFFFFF"><span><samp><cf_get_lang_main no='1306.Duzenle'></samp></span></font></a>
					<cfif session.pp.userid eq getPartner.manager_partner_id>
						<a class="dashboard_162_tumunu" href="detail_company"><font color="0F155D"><cf_get_lang_main no='1708.Sirket Profili'></font></a>
					<cfelse>
						<a class="dashboard_162_tumunu" href="#request.self#?fuseaction=worknet.dsp_member&cpid=#session.pp.company_id#"><font color="0F155D"><cf_get_lang_main no='1708.Sirket Profili'></font></a>
					</cfif>
				</div>
			</div>
			</cfoutput>
		</div>
		<div class="dashboard_1">
			<div class="dashboard_11">
				<span><img src="../documents/templates/worknet/tasarim/kutu_icon_5.png" style="margin-top: 8px;margin-left: 11px;" class="chapterImage" alt="İcon" /></span>
				<h2><cf_get_lang no='99.Mesajlarim'></h2>
				<cfif getMessageNotRead.recordcount><samp><cfoutput>#getMessageNotRead.recordcount#</cfoutput></samp></cfif>
			</div>
			<div class="dashboard_12">
				<cfif getMessage.recordcount>
					<cfoutput query="getMessage" maxrows="5">
					<a href="#request.self#?fuseaction=worknet.dsp_message&msg_id=#msg_id#">
						<div <cfif is_read eq 1>class="dashboard_122 dashboard_122_pasif"<cfelse>class="dashboard_122"</cfif>>
							<span style="width:100px;">#listlast(sender_name,'-')#</span>
							<samp style="width:125px;">#left(subject,75)#</samp>
						</div>
					</a>
					</cfoutput>
				<cfelse>
					<div class="dashboard_122 dashboard_122_pasif">
						<span><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</span>
					</div>
				</cfif>
				<div class="dashboard_126">
					<a class="dashboard_162_duzenle" href="sent_message"><font color="FFFFFF"><span><samp><cf_get_lang no='188.Yeni Mesaj'></samp></span></font></a>
					<a class="dashboard_162_tumunu" href="inbox"><font color="0F155D"><cf_get_lang no='102.Tümünü Göster'></font></a>
				</div>
			</div>
		</div>
		<div class="dashboard_1" style="margin-right:0px;">
			<div class="dashboard_11">
				<span><img src="../documents/templates/worknet/tasarim/kutu_icon_6.png"  class="chapterImage" alt="İcon" /></span>
				<h2><cf_get_lang no='74.Kontak Listem'></h2>
				<cfif getMemberFollow.recordcount><samp><cfoutput>#getMemberFollow.recordcount#</cfoutput></samp></cfif>
			</div>
			<div class="dashboard_12">
				<cfif getMemberFollow.recordcount>
					<cfoutput query="getMemberFollow" maxrows="5">
					<div class="dashboard_123">
						<span style="width:120px;"><a href="#request.self#?fuseaction=worknet.dsp_partner&pid=#follow_member_id#">#company_partner_name# #company_partner_surname#</a></span>
						<samp style="width:140px;"><a href="#request.self#?fuseaction=worknet.dsp_member&cpid=#getMemberFollow.COMPANY_ID#">#left(nickname,30)#</a></samp>
                        <samp style="width:20px;"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=worknet.popup_sent_message&member_id=#follow_member_id#','medium')"><img src="../documents/templates/worknet/tasarim/sirketp_213_icon_1.png" title="<cf_get_lang_main no='1899.Mesaj Gönder'>"/></a></samp>
					</div>
					</cfoutput>
                    <div class="dashboard_124">
                        <a class="dashboard_162_tumunu" href="contact_list"><font color="0F155D"><cf_get_lang no='102.Tümünü Göster'></font></a>
                    </div>
				<cfelse>
					<div class="dashboard_124">
						<span><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</span>
					</div>
				</cfif>
			</div>
		</div>
	</div>
	<div class="dashboard">
		<div class="dashboard_1">
			<div class="dashboard_11">
				<span><img src="../documents/templates/worknet/tasarim/kutu_icon_7.png" style="margin-left: 12px;margin-top: 7px;" class="chapterImage" alt="İcon" /></span>
			  <h2><cf_get_lang no='109.Ürünlerim'></h2>
			  <cfif getProduct.recordcount><samp><cfoutput>#getProduct.recordcount#</cfoutput></samp></cfif>
		  </div>
			<div class="dashboard_12">
				<cfif getProduct.recordcount>
					<cfoutput query="getProduct" maxrows="5">
						<div class="dashboard_124">
							<span style="width:175px;"><a href="#request.self#?fuseaction=worknet.detail_product&pid=#product_id#">#left(product_name,15)#</a></span>
							<samp style="width:100px;">#stage#</samp>
						</div>
					</cfoutput>
	            <cfelse>
					<div class="dashboard_124">
						<span><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</span>
					</div>
				</cfif>
				<div class="dashboard_126">
	                <a class="dashboard_162_duzenle" href="add_product"><font color="FFFFFF"><span><samp><cf_get_lang_main no='170.Ekle'></samp></span></font></a>
	                <a class="dashboard_162_tumunu" href="<cfoutput>#request.self#?fuseaction=worknet.my_product</cfoutput>"><font color="0F155D"><cf_get_lang no='102.Tümünü Göster'></font></a>
	            </div>
			</div>
		</div>
		<div class="dashboard_1">
			<div class="dashboard_11">
				<span><img src="../documents/templates/worknet/tasarim/kutu_icon_3.png" class="chapterImage" alt="İcon" /></span>
			  <h2><cf_get_lang no='134.Taleplerim'></h2>
			  <cfif getDemand.recordcount><samp><cfoutput>#getDemand.recordcount#</cfoutput></samp></cfif>
			</div>
			<div class="dashboard_12">
				<cfif getDemand.recordcount>
					<cfoutput query="getDemand" maxrows="5">
						<div class="dashboard_124">
							<span><a href="#request.self#?fuseaction=worknet.detail_demand&demand_id=#demand_id#">#left(demand_head,30)#</a></span>
							<samp>#stage#</samp>
						</div>
					</cfoutput>
				<cfelse>
					<div class="dashboard_124">
						<span><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</span>
					</div>
				</cfif>
				<div class="dashboard_126">
	                <a class="dashboard_162_duzenle" href="add_demand"><font color="FFFFFF"><span><samp><cf_get_lang_main no='170.Ekle'></samp></span></font></a>
	                <a class="dashboard_162_tumunu" href="<cfoutput>#request.self#?fuseaction=worknet.my_demand</cfoutput>"><font color="0F155D"><cf_get_lang no='102.Tümünü Göster'></font></a>
	            </div>
			</div>
		</div>
		<div class="dashboard_1" style="margin-right:0px;">
			<div class="dashboard_11">
				<span><img src="../documents/templates/worknet/tasarim/kutu_icon_8.png" class="chapterImage" alt="İcon" /></span>
			  <h2><cf_get_lang no='281.Tıklanma Sayıları'></h2>
		  </div>
			<div class="dashboard_12">
				<div class="dashboard_125">
					<span><a href="detail_company"><cf_get_lang_main no='246.üye'></a></span>
					<samp><cfoutput>#createObject("component","worknet.objects.worknet_objects").getVisit(process_type:'member',process_id:session.pp.company_id)#</cfoutput></samp>
				</div>
				<div class="dashboard_125">
					<span><a href="<cfoutput>#request.self#?fuseaction=worknet.my_product</cfoutput>"><cf_get_lang no='109.Ürünlerim'></a></span>
					<samp><cfoutput>#createObject("component","worknet.objects.worknet_objects").getVisit(process_type:'product')#</cfoutput></samp>
				</div>
				<div class="dashboard_125">
					<span><a href="<cfoutput>#request.self#?fuseaction=worknet.my_catalog</cfoutput>"><cf_get_lang no='173.Kataloglarım'></a></span>
					<samp><cfoutput>#createObject("component","worknet.objects.worknet_objects").getVisit(process_type:'catalog')#</cfoutput></samp>
				</div>
				<div class="dashboard_125">
					<span><a href="<cfoutput>#request.self#?fuseaction=worknet.my_demand</cfoutput>"><cf_get_lang no='134.Taleplerim'></a></span>
					<samp><cfoutput>#createObject("component","worknet.objects.worknet_objects").getVisit(process_type:'demand')#</cfoutput></samp>
				</div>
				<cfif session.pp.userid eq getPartner.manager_partner_id>
					<div class="dashboard_126">
						<a class="dashboard_162_sube" href="add_branch"><font color="FFFFFF"><span><samp><cf_get_lang no='5.Sube Ekle'></samp></span></font></a>
						<a class="dashboard_162_calisan" href="add_partner"><font color="FFFFFF"><span><samp><cf_get_lang no='59.Çalışan Ekle'></samp></span></font></a>
						<a class="dashboard_162_calisan" href="training_report"><font color="FFFFFF"><span><samp><cf_get_lang no='287.Eğitim Raporu'></samp></span></font></a>
					</div>
				</cfif>
			</div>
		</div>
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
