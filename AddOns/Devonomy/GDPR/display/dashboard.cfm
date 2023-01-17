<!---
    File: 
    Author: Devonomy-TolgaS <tolga@devonomy.com>
	Date: 
	Controller: GDPRActionsController.cfm
    Description:
		
--->
<!--dashboard -->
<div class="blog">
	<div id="hr_content">
			<cf_catalystHeader>
			<cfif not listfindnocase(denied_pages,'gdpr.sensitivity_label')>
				<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
					<div class="hr_box">
						<a href="<cfoutput>#request.self#?fuseaction=gdpr.sensitivity_label</cfoutput>" class="tableyazi">
							<div class="circleBox color-A">
								<i class="fa fa-user-secret"></i>
							</div>
							<div class="circleIconTitle">
								<cf_get_lang dictionary_id='270.Güvenlik Seviyesi(Sensitivity Label)'>
							</div>
						</a>
						<div class="sub_desc"> 
							<i class="fa fa-caret-right"></i>&nbsp;<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=gdpr.sensitivity_label"><cf_get_lang dictionary_id='270.Güvenlik Seviyesi(Sensitivity Label)'></a>
						</div>
					</div>
				</div>
			</cfif>
			<cfif not listfindnocase(denied_pages,'gdpr.data_category_type')>
				<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
					<div class="hr_box">
						<a href="<cfoutput>#request.self#?fuseaction=gdpr.data_category_type</cfoutput>" class="tableyazi">
							<div class="circleBox color-E">
								<i class="fa fa-tag"></i>
							</div>
							<div class="circleIconTitle">
								<cf_get_lang dictionary_id='61728.Veri Kategori Tipi (Category Type)'> 
							</div>
						</a>
						<div class="sub_desc">
							<i class="fa fa-caret-right"></i>&nbsp;<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=gdpr.data_category_type"><cf_get_lang dictionary_id='61730.Kişisel Veri, Özel nitelikli kişisel veri gibi kategory tipleri'></a>
						</div>
					</div>
				</div>
			</cfif>
			<cfif not listfindnocase(denied_pages,'gdpr.data_category')>
				<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
					<div class="hr_box">
						<a href="<cfoutput>#request.self#?fuseaction=gdpr.data_category</cfoutput>" class="tableyazi">
							<div class="circleBox color-PM">
								<i class="fa fa-tags"></i>
							</div>
							<div class="circleIconTitle">
								<cf_get_lang dictionary_id='61729.Veri Kategorisi'>
							</div>
						</a>
						<div class="sub_desc">
							<i class="fa fa-caret-right"></i>&nbsp;<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=gdpr.data_category"><cf_get_lang dictionary_id='61731.Kimlik (Ad,soyad,TC kimlik no) gibi veri kategorilerinin tanımları'></a>
						</div>
					</div>
				</div>
			</cfif>
			<cfif not listfindnocase(denied_pages,'gdpr.classification_keyword')>
				<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
					<div class="hr_box">
						<a href="<cfoutput>#request.self#?fuseaction=gdpr.classification_keyword</cfoutput>" class="tableyazi">
							<div class="circleBox color-HR">
								<i class="fa fa-key"></i>
							</div>
							<div class="circleIconTitle">
								<cf_get_lang dictionary_id='35597.Anahtar Kelimeler (Keyword)'>
							</div>
						</a>
						<div class="sub_desc">
							<i class="fa fa-caret-right"></i>&nbsp;<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=gdpr.classification_keyword"><cf_get_lang dictionary_id='61732.Sınıflandırma yapılacağı zaman Veritabanı vs içerisinde aranacak anahtar kelimeler'></a>
						</div>
					</div>
				</div>
			</cfif>
			<cfif not listfindnocase(denied_pages,'gdpr.data_precaution')>
				<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
					<div class="hr_box">
						<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=gdpr.data_precaution">
							<div class="circleBox color-V">
								<i class="fa fa-exclamation-triangle"></i>
							</div>
							<div class="circleIconTitle">
								<cf_get_lang dictionary_id='61733.Güvenlik Önlemi'>
							</div>
						</a>
						<div class="sub_desc">
							<i class="fa fa-caret-right"></i>&nbsp;<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=gdpr.data_precaution"><cf_get_lang dictionary_id='61734.Veri Korunması için Gerekli Önlemler'></a>
						</div>
					</div>
				</div>
			</cfif>
			<cfif not listfindnocase(denied_pages,'gdpr.data_transfer_group')>
				<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
					<div class="hr_box">
						<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=gdpr.data_transfer_group">
							<div class="circleBox color-CE">
								<i class="fa fa-exchange"></i>
							</div>
							<div class="circleIconTitle">
								<cf_get_lang dictionary_id='61735.Veri Aktarım Grupları'>
							</div>
						</a>
						<div class="sub_desc">
							<i class="fa fa-caret-right"></i>&nbsp;<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=gdpr.data_transfer_group"><cf_get_lang dictionary_id='61736.(Alıcılar) Hissedar, Kamu Kurumları, Bankalar vs...'></a>
						</div>
					</div>
				</div>
			</cfif>
			<cfif not listfindnocase(denied_pages,'gdpr.data_subject_group')>
				<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
					<div class="hr_box">
						<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=gdpr.data_subject_group">
							<div class="circleBox color-LM">
								<i class="fa fa-users"></i>
							</div>
							<div class="circleIconTitle">
								<cf_get_lang dictionary_id='61737.Veri Konusu Kişi Grupları'>
							</div>
						</a>
						<div class="sub_desc">
							<i class="fa fa-caret-right"></i>&nbsp;<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=gdpr.data_subject_group"><cf_get_lang dictionary_id='61738.Çalışan, Çalışan Adayı, Ürün veya Hizmet Alan Kişi'></a>
						</div>
					</div>
				</div>
			</cfif>
			<cfif not listfindnocase(denied_pages,'gdpr.data_processing_purpose')>
				<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
					<div class="hr_box">
						<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=gdpr.data_processing_purpose">
							<div class="circleBox color-ER">
								<i class="fa fa-tasks"></i>
							</div>
							<div class="circleIconTitle">
								<cf_get_lang dictionary_id='61739.Veri İşleme Amaçları'>
							</div>
						</a>
						<div class="sub_desc">
							<i class="fa fa-caret-right"></i>&nbsp;<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=gdpr.data_processing_purpose"> <cf_get_lang dictionary_id='61740.Çalışanlar İçin İş Akdi ve Mevzuat Kaynaklı Yükümlülüklerin Yerine Getirilmesi, Mal / Hizmet Satın Alım Süreçlerinin Yürütülmesi'></a>
						</div>
					</div>
				</div>
			</cfif>
			<cfif not listfindnocase(denied_pages,'gdpr.data_officer')>
				<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
					<div class="hr_box">
						<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=gdpr.data_officer">
							<div class="circleBox color-PO">
								<i class="fa fa-user-circle-o"></i>
							</div>
							<div class="circleIconTitle">
								<cf_get_lang dictionary_id='61741.Veri Sorumlusu Ekranı'>
							</div>
						</a>
						<div class="sub_desc">
							<i class="fa fa-caret-right"></i>&nbsp;<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=gdpr.data_officer"><cf_get_lang dictionary_id='61742.Tanımlama, listeleme vs...'></a>
						</div>
					</div>
				</div>
			</cfif>
			<cfif not listfindnocase(denied_pages,'')>
				<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
					<cfset comp = createObject("component","AddOns.Devonomy.GDPR.cfc.gdpr_decleration")/>
					<cfset Data_Decleration = comp.Data_Decleration()/>
					<cfset MAX_DECLERATION = comp.MAX_DECLERATION()/>
					<div class="hr_box">
						<cfif Data_Decleration.recordcount>
							<a href="<cfoutput>#request.self#?fuseaction=gdpr.decleration_text&event=upd&gdpr_decleration_id=#MAX_DECLERATION.MAX#</cfoutput>">
							<cfelse>
								<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=gdpr.decleration_text&event=add">
							</cfif>
					
							<div class="circleBox color-SU">
								<i class="fa fa-plug"></i>
							</div>
							<div class="circleIconTitle">
								<cf_get_lang dictionary_id='61743.Aydınlatma Metni Oluşturma'>
							</div>
							<div class="sub_desc">
								<i class="fa fa-caret-right"></i>&nbsp;	<cfif Data_Decleration.recordcount><a href="<cfoutput>#request.self#?fuseaction=gdpr.decleration_text&event=upd&gdpr_decleration_id=#MAX_DECLERATION.MAX#</cfoutput>">
								<cfelse>
									<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=gdpr.decleration_text&event=add">
								</cfif><cf_get_lang dictionary_id='65071.Aydınlatma Metnininin son versiyonu ,hangi tarihte oluşturulduğu ve kim tarafından oluşturulduğu bu ekranda yer almaktadır. History kısmından önceki kayıtlara erişilebilir.'></a>
							</div>
						</a>
					</div>
					
				</div>
			</cfif>
			<cfif not listfindnocase(denied_pages,'')>
				<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
					<div class="hr_box">
						<a href="<cfoutput>#request.self#?fuseaction=gdpr.approve</cfoutput>">
							<div class="circleBox color-SU">
								<i class="fa fa-unlock"></i>
							</div>
							<div class="circleIconTitle">
								<cf_get_lang dictionary_id='55143.İzinler'>
							</div>
							<div class="sub_desc">
								<i class="fa fa-caret-right"></i>&nbsp;<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=gdpr.approve"> <cf_get_lang dictionary_id='65070.GDPR Aydınlatma Metnine göre Çlışanların listelendiği ve onay verildiği ekrandır.'></a>
							</div>
						</a>
					</div>
				</div>
			</cfif>
			<cfif not listfindnocase(denied_pages,'')>
				<div class="col col-2 col-md-3 col-sm-4 col-xs-6 fade">
					<div class="hr_box">
						<a href="">
							<div class="circleBox color-PM">
								<i class="fa fa-bar-chart"></i>
							</div>
							<div class="circleIconTitle">
								<cf_get_lang dictionary_id='47642.Raporlama'>
							</div>
						</a>
					</div>
				</div>
			</cfif>
	</div>
</div>
