<cfsetting showdebugoutput="no">
<cfparam name="attributes.satir" default="1">
<cfparam name="attributes.ourcompany_id" default="#session.ep.company_id#">

<cfquery name="check" datasource="#dsn#">
	SELECT
		*
	FROM
		OUR_COMPANY_INFO
	WHERE
		OUR_COMPANY_INFO.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ourcompany_id#">;
</cfquery>

<cfquery name="get_company" datasource="#dsn#">
	SELECT COMPANY_NAME FROM OUR_COMPANY WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ourcompany_id#">
</cfquery>

<cfif not(isdefined("attributes.callAjax") and len("attributes.callAjax"))>
	<div class="row col col-3 col-md-3 col-sm-12 col-xs-12" type="row">
		<cfsavecontent variable = "company_title"><cf_get_lang dictionary_id='42865.Şirket Akış Parametreleri'></cfsavecontent>
		<cf_box title="#company_title#" closable="0" collapsed="0">	
			<cfinclude template="../display/list_company.cfm">
		</cf_box>
	</div>
</cfif>

<!--- Google API --->
<cfset getComponent = createObject('component','WEX.google.cfc.google_api')>

<cfif not(isdefined("attributes.callAjax") and len("attributes.callAjax"))>
	<div class="col col-9 col-md-9 col-sm-12 col-xs-12" id="detail_div">
<cfelse>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">	
</cfif>
	<cf_box title="#get_company.company_name#" closable="0" collapsed="0" >
		<cfform name="add_our_company_info#attributes.satir#" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_our_company_info">
			<cf_box_elements vertical="1">
				<cfoutput>
					<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
						<input type="hidden" name="comp_id" id="comp_id" value="#attributes.ourcompany_id#">
						<input type="hidden" name="comp_name" id="comp_name" value="#get_company.company_name#">
						<div class="form-group" id="item-comp_vizyon">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57758.Şirket Vizyonu'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61361.Şirket vizyonunun eklendiği metin alanıdır.'></div>
									<input type="text" name="comp_vizyon" id="comp_vizyon" rows="1" value="<cfif check.recordCount>#check.comp_vizyon#</cfif>"></input>
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="item-workcube_sector">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43193.Workcube Sektör'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61362.Şirket sektör bilgisi yer alır.'> <cf_get_lang dictionary_id='61363.Sistem tarafından otomatik tanımlanan Metal, IT, Per ve Tersane seçeneklerinden birini seçiniz'></div>
									<select name="workcube_sector" id="workcube_sector" style="width:200px;">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<option value="metal" <cfif check.workcube_sector eq 'metal'>selected</cfif>><cf_get_lang dictionary_id ='43864.Metal'></option>
										<option value="it" <cfif check.workcube_sector eq 'it'>selected</cfif>><cf_get_lang dictionary_id="33705.It"></option>
										<option value="per" <cfif check.workcube_sector eq 'per'>selected</cfif>><cf_get_lang dictionary_id="57949.Per"></option>
										<option value="tersane" <cfif check.workcube_sector eq 'tersane'>selected</cfif>><cf_get_lang dictionary_id="33697.Tersane"></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="item-email">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43195.İnsan Kaynakları Mail'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61364.Kariyer portalımız üzerinden giden maillerin gönderileceği mail adresini tanımladığımız yer.'></div>
									<cfsavecontent variable="message"><cf_get_lang dictionary_id ='44146.E-mail Adresi Hatalı'></cfsavecontent>
									<cfinput type="text" name="EMAIL" validate="email" value="#check.email#" message="#message#" style="width:200px;">
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="item-is_time">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43509.Zaman Harcaması Uyarısı Yapılsın'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61386.Haftalık zaman harcamamızı doldurmadığımızda, bir sonraki hafta başladığında sisteme ilk girişte  zaman harcamanı doldur  uyarısı gelerek zaman harcaması sayfasına yönlendirir. Ayrıca, seçildiği zaman iş detayına girilen zaman harcaması kaydını gerçekleştirmeden önce çalışan pozisyon maliyeti kontrolünü gerçekleştirir.'></div>
									<select name="is_time" id="is_time">
										<option value="1" <cfif check.recordcount and check.is_time eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.recordcount and check.is_time eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="item-IS_PROJECT_FOLLOWUP">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43199.Alış ve satış işlemlerinde proje takibi yapılsın mı'>?</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61372.Alış ve satış işlemlerimizde (fatura, irsaliye vb.) proje ile ilişkilendirebilecek şekilde çalışıp çalışmayacağını tanımladığımız parametre. Proje seçim alanı işlemlerde görünsün mü görünmesin mi?'></div>
									<select name="IS_PROJECT_FOLLOWUP" id="IS_PROJECT_FOLLOWUP">
										<option value="1" <cfif check.recordcount and check.is_project_followup eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.recordcount and check.is_project_followup eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-IS_SALES_ZONE_FOLLOWUP">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43200.Satış Bölgelerine Göre Müşteri Erişim Kontrolu Yapılsın mı'> ?</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61374.Satış planlama modülünde bölge tanımlanıp yetkili kişi veya ekipleri bölge veya şube bazında oluşturulabiliriz. Üyeler bölümünden filtreleme yapılınca bölgede çalışan kişiler o bölgedeki üyeleri görebilir. Satış bölgelerine yetkili olmayan kullanıcılar o bölgedeki müşterileri göremez'></div>
									<select name="IS_SALES_ZONE_FOLLOWUP" id="IS_SALES_ZONE_FOLLOWUP">
										<option value="1" <cfif check.recordcount and check.is_sales_zone_followup eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.recordcount and check.is_sales_zone_followup eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-IS_STORE_FOLLOWUP">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='43867.Şubelere Göre Müşteri Erişim Kontrolu Yapılsın mı'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61375.Evet seçilirse çalışan hangi şubede yetkili ise o şube ile ilişkili üyeleri görebilmektedir.'></div>
									<select name="IS_STORE_FOLLOWUP" id="IS_STORE_FOLLOWUP">
										<option value="1" <cfif check.recordcount and check.is_store_followup eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.recordcount and check.is_store_followup eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-IS_UNCONDITIONAL_LIST">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43204.Liste sayfaları koşulsuz çalışsın mı'>?</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61376.Evet seçilirse liste sayfalarında herhangi bir koşula bağlı olmadan listeleyebilmemizi sağlar. Evet, seçilmezse liste sayfalarında en az bir alanda filtre etmemiz gerekir.Seçilir ise tarihler dolu olarak gelir. Performans açısından seçilmesi önerilir.'></div>
									<select name="IS_UNCONDITIONAL_LIST" id="IS_UNCONDITIONAL_LIST">
										<option value="1" <cfif check.recordcount and check.is_unconditional_list eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.recordcount and check.is_unconditional_list eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-IS_MAXROWS_CONTROL_OFF">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='43868.Listelerde kayıt sayısı kontrolü kapalı olsun mu'>?</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61378.Bu seçenek maksimum kayıt sayısının 250 olarak belirlenmesini sağlar. Select box seçildiğinde maksimum 250 olan kayıt sayısı gözardı edilir ve daha fazla kayıda izin verir. Performans açısından seçilmesi önerilir.'></div>
									<select name="IS_MAXROWS_CONTROL_OFF" id="IS_MAXROWS_CONTROL_OFF">
										<option value="1" <cfif check.recordcount and check.is_maxrows_control_off eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.recordcount and check.is_maxrows_control_off eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="item-is_multi_analysis_result">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='44565.Çoklu Analiz Sonucu'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61393.Üyeler tarafından çoklu analiz girilmesine olanak verir.'></div>
									<select name="is_multi_analysis_result" id="is_multi_analysis_result">
										<option value="1" <cfif check.recordcount and check.is_multi_analysis_result eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.recordcount and check.is_multi_analysis_result eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="item-is_paper_closer">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43510.Belge Kapama İşlemi Yapılsın'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61387.Seçildiğinde bir ödeme geldiğinde fatura manuel olarak kapatılır.İşlem yaptığınızda belge kapama sayfasının açılmasını sağlar.'></div>
									<select name="is_paper_closer" id="is_paper_closer">
										<option value="1" <cfif check.recordcount and check.is_paper_closer eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.recordcount and check.is_paper_closer eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="item-IS_COST">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43234.Maliyet İşlemi Yapılsın'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61380.Maliyet kayıtlarının sistemde oluşup, ilgili raporlarda maliyetlerin karşımıza çıkmasını sağlar.'></div>
									<select name="IS_COST" id="IS_COST">
										<option value="1" <cfif check.recordcount and check.is_cost eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.recordcount and check.is_cost eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="item-COST_CALC_TYPE">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='43869.Maliyet Hesap Yöntemi'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61381.Maliyet hesaplarken TL olarak mı hesaplansın, her para birimi kendi içinde mi hesaplansı seçtiğimiz parametre(Yardım alanından hesaplama bilgilerine ulaşılabilir)'></div>
									<select name="COST_CALC_TYPE" id="COST_CALC_TYPE" style="width:200px;">
										<option value="1" <cfif check.recordcount and check.cost_calc_type eq 1> selected</cfif>>#session.ep.money# <cf_get_lang dictionary_id ='43870.Para Birimlerinden Hesaplanarak'></option>
										<option value="2" <cfif check.recordcount and check.cost_calc_type eq 2> selected</cfif>><cf_get_lang dictionary_id ='43871.Her Para Birimi Kendi İçinde Hesaplanarak'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="item-IS_RATE_FROM_PRE_PAPER">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43596.Kur bir önceki belgeden alır'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61383.Sipariş, irsaliye ve fatura tarihleri farklı olsa da hangi belgeden oluşmuşsa o belgenin kurunu alır. Örnek siparişten oluşturulan faturada siparişteki kur ne ise faturadaki kur da o olur.'></div>
									<select name="IS_RATE_FROM_PRE_PAPER" id="IS_RATE_FROM_PRE_PAPER">
										<option value="1" <cfif check.RecordCount and check.is_rate_from_pre_paper eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.RecordCount and check.is_rate_from_pre_paper eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="item-is_project_group">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42504.Muhasebe Fişleri Proje Bazında Gruplansın'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61392.Seçildiğinde kaydedilen muhasebesel işlemlerde farklı projeler var ise oluşan muhasebe fişinde proje bazında kayıtlar oluşur.'></div>
									<select name="is_project_group" id="is_project_group">
										<option value="1" <cfif check.recordcount and check.is_project_group eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.recordcount and check.is_project_group eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="item-is_detailed_risk_info">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='44764.Detaylı Risk Takibi Yapılsın'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61394.Basket, Risk Analiz Raporu ve Finansal özet sayfalarında risk bilgilerini getirirken, belgelerin satır bazında kontrol edilmesini sağlar.'></div>
									<select name="is_detailed_risk_info" id="is_detailed_risk_info">
										<option value="1" <cfif check.recordcount and check.is_detailed_risk_info eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.recordcount and check.is_detailed_risk_info eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="item-is_select_risk_money">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='44787.Risk Bilgilerindeki İşlem Dövizi Seçili Gelsin'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61395.Üyenin risk bilgilerinde seçili olan işlem dövizinin belgenin içine otomatik düşmesini sağlar. Kuru belge tarihteki kurdan alır. Kur bilgisi değişmeyecekse dahi, günlük olarak kur girilmesi gerekir.'></div>
									<select name="is_select_risk_money" id="is_select_risk_money">
										<option value="1" <cfif check.recordcount and check.is_select_risk_money eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.recordcount and check.is_select_risk_money eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="item-is_remaining_amount">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="33677.Kısmi Tahsil Senetlerde Kalan Tutar Gösterilsin Mi?"></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61397.Sistemde kayıtlı senetler için kısmi tahsilat yapılıyor ise kalan tutarın ayrı bir kolonda görüntülenmesini sağlar.'></div>
									<select name="is_remaining_amount" id="is_remaining_amount">
										<option value="1" <cfif check.recordcount and check.is_remaining_amount eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.recordcount and check.is_remaining_amount eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="item-rate_round_num">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43598.Kur Yuvarlama Sayısı'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61400.Kurların görünecek ondalık hane sayısını belirtir.'></div>
									<select name="rate_round_num" id="rate_round_num" style="width:55px;">
										<cfloop from="1" to="8" index="k">
											<option value="#k#" <cfif check.recordcount and check.rate_round_num eq k> selected</cfif>>#k#</option>
										</cfloop>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="item-purchase_price_round_num">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='43872.Alış Fiyatı Yuvarlama Sayısı'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61401.Alış fiyatlarında görünecek ondalık hane sayısını belirtir.'></div>
									<select name="purchase_price_round_num" id="purchase_price_round_num" style="width:55px;">
										<cfloop from="1" to="8" index="k">
											<option value="#k#" <cfif check.recordcount and check.purchase_price_round_num eq k> selected</cfif>>#k#</option>
										</cfloop>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>
								</div>	
							</div>
						</div>
						<div class="form-group" id="item-sales_price_round_num">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='43873.Satış Fiyatı Yuvarlama Sayısı'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61402.Satış fiyatlarında görünecek ondalık hane sayısını belirtir.'></div>
									<select name="sales_price_round_num" id="sales_price_round_num" style="width:55px;">
										<cfloop from="1" to="8" index="k">
											<option value="#k#" <cfif check.recordcount and check.sales_price_round_num eq k> selected</cfif>>#k#</option>
										</cfloop>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="item-is_other_money">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="33852.Muhasebe Fişlerinde İşlem Dövizi Seçili Gelsin Mi?"></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61416.İşlem Dövizi kullanan firmalar içindir. Seçilir ise belgelerde işlem dövizi checkboxı default olarak seçili gelir.'></div>
									<select name="is_other_money" id="is_other_money">
										<option value="1" <cfif check.is_other_money eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.is_other_money eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="item-IS_ACCOUNT_CARD_UPD">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30138.İşleme Bağlı Muhasebe Hareketleri Değişirilebilsin mi'>?</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61377.İşlemler sonucunda oluşan muhasebe hareketlerini muhasebeden manuel olarak değiştirip değiştiremeyeceğimizi sağlar. Güncellemelerimizi sadece yaptığımız işlem üzerinden gerçekleştirebiliriz. Eğer evet dersek manuel olarakta muhasebeden işleme bağlı muhasebe hareketlerini güncelleriz.'></div>
									<select name="IS_ACCOUNT_CARD_UPD" id="IS_ACCOUNT_CARD_UPD">
										<option value="1" <cfif check.recordcount and check.is_account_card_update eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.recordcount and check.is_account_card_update eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-IS_ASSET_FOLLOWUP">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58264.Finansal İşlemlerde Fiziki Varlık Seçilsin mi'>?</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61373.Finansal işlemlerde (fatura veya çek kaydı gibi) fiziki varlık seçilmek isteniyorsa bu checkbox seçili olmalıdır.'></div>
									<select name="IS_ASSET_FOLLOWUP" id="IS_ASSET_FOLLOWUP">
										<option value="1" <cfif check.recordcount and check.is_asset_followup eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.recordcount and check.is_asset_followup eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-is_use_ifrs">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43569.UFRS Kod Kullan'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61391.Uluslar arası Finansal Raporlama Sistemi kodlarını da kullanabileceğimiz alanlar açılmasını sağlar.'></div>
									<select name="is_use_ifrs" id="is_use_ifrs">
										<option value="1" <cfif check.recordcount and check.is_use_ifrs eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.recordcount and check.is_use_ifrs eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>
								</div>	
							</div>
						</div>
						<div class="form-group" id="item-account_code">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43559.İnternetten Gelen Üyeler İçin Muhasebe Hesabı'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61405.Bireysel üyelerin toplu olarak kayıt aşamasında aldığı hesap kodu, torba hesap kodu.'></div>
									<input type="hidden" name="account_code" id="account_code" value="#check.PUBLIC_ACCOUNT_CODE#">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='42766.Muhasebe Kodu Seçmelisiniz'>!</cfsavecontent>
									<cfif len(check.public_account_code)>
										<cfquery name="GET_ACC_2" datasource="#DSN2#">
											SELECT ACCOUNT_NAME FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = '#check.public_account_code#'
										</cfquery>
										<cfinput type="text" name="account_code_name" value="#check.public_account_code# - #get_acc_2.account_name#" message="#message#" passthrough="readonly"  style="width:200px;">
									<cfelse>
										<cfinput type="text" name="account_code_name" value="" message="#message#" passthrough="readonly" style="width:200px;">
									</cfif>
									<cfoutput><span class="input-group-addon icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_account_plan&field_name=add_our_company_info#attributes.satir#.account_code_name&field_id=add_our_company_info#attributes.satir#.account_code','list')"></span></cfoutput>
									<span class="input-group-addon icon-question input-group-tooltip"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-is_efatura">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43184.E-Fatura Kullanılıyor mu'>?</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61365.Şirket e-fatura kullanıyor ise bu textbox seçili olmalıdır. Bu seçeneğe bağlı olarak ikonlar/tanımlar/filtreler/alanlar gelir.'></div>
									<cfif check.recordcount and check.is_efatura eq 1><input type="text" value="<cf_get_lang dictionary_id='57495.Evet'>" readonly><cfelse><input type="text" value="<cf_get_lang dictionary_id='57496.Hayır'>" readonly></cfif>
									<span class="input-group-addon icon-question input-group-tooltip"></span>
								</div>
							</div>	
						</div>
						<div class="form-group" id="item-dateformat_style">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30556.E-Fatura Geçiş Tarihi'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61366.Vermiş olduğunuz tarihten itibaren ikonlar görünür ve fatura kesilir.'></div>
									<input type="text" value="<cfif len(check.efatura_date)>#dateformat(check.efatura_date,dateformat_style)#</cfif>" readonly> 
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="item-IS_GUARANTY_FOLLOWUP">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43197.Garanti Takip, Tamir ve Seri No uygulansın mı'>?</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61369.Servis başvurusu detayında Kabul Teslimat Bilgisi ve Teslim Bilgisi alanları, stok modülündeki seri ve lot işlemleri bu seçeneğe bağlı olarak görünmektedir. Seçilmezse o alanlar görünmez.'></div>
									<select name="IS_GUARANTY_FOLLOWUP" id="IS_GUARANTY_FOLLOWUP">
										<option value="1" <cfif check.recordcount and check.is_guaranty_followup eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.recordcount and check.is_guaranty_followup eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select> 
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="item-is_serial_control">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43506.Seri Takip'> - <cf_get_lang dictionary_id='43507.Dönüş Kontrolü Yapılsın'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61384.Bu sistemden önceki (yıllarda) dönemlerde imal edilip, satılan ürünlerden iade geldiğinde sisteme kayıtlarının yapılıp yapılamayacağına dairdir.'></div>
									<select name="is_serial_control" id="is_serial_control">
										<option value="1" <cfif check.recordcount and check.is_serial_control eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.recordcount and check.is_serial_control eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="item-IS_SUBSCRIPTION_CONTRACT">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43198.Abonelik sözleşmesi çalışsın mı'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61367.Satış modülündeki aboneler bu parametreye bağlı olarak görünmektedir. Seçilmezse görünmez.'></div>
									<select name="IS_SUBSCRIPTION_CONTRACT" id="IS_SUBSCRIPTION_CONTRACT">
										<option value="1" <cfif check.recordcount and check.is_subscription_contract eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.recordcount and check.is_subscription_contract eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-is_ship_control">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43508.İrsaliye Takip'> - <cf_get_lang dictionary_id='43507.Dönüş Kontrolü Yapılsın'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61385.Bu seçenek de sistemden önceki (yıllarda) dönemlerde imal edilip, satılan ürünlerden iade geldiğinde sisteme kayıtlarının yapılıp yapılamayacağına dairdir.'></div>
									<select name="is_ship_control" id="is_ship_control">
										<option value="1" <cfif check.RecordCount and check.is_ship_control eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.RecordCount and check.is_ship_control eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="item-is_order_upd">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='60149.İşlenmiş Satış Siparişler Güncellenebilsin'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61389.Siparişle ilgili bir işlem yapıldığında ( irsaliye, fatura vb. ) bu sipariş güncellenebilsin mi ?'></div>
									<select name="is_order_upd" id="is_order_upd">
										<option value="1" <cfif check.recordcount and check.is_order_update eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.recordcount and check.is_order_update eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="item-is_purchase_order_upd">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="60034.İşlenmiş Satınalma Siparişleri Güncellenebilsin"></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61389.Siparişle ilgili bir işlem yapıldığında ( irsaliye, fatura vb. ) bu sipariş güncellenebilsin mi ?'></div>
									<select name="is_purchase_order_upd" id="is_purchase_order_upd">
										<option value="1" <cfif check.recordcount and check.is_purchase_order_update eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.recordcount and check.is_purchase_order_update eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="item-IS_BARCOD_REQ">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43196.Ürün envantere dahil ise barkod alanı zorunlu mu'>?</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61368.Evet seçildiğinde, ürün ekleme sayfasında envantere dahil seçeneği seçilirse barkod numarasını zorunlu kılar, ürün kaydetmeye sistem izin vermez. Aksi durumda barkod numarası kaydetmenize izin verir.'></div>
									<select name="IS_BARCOD_REQ" id="IS_BARCOD_REQ">
										<option value="1" <cfif check.recordcount and check.is_barcod_required eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.recordcount and check.is_barcod_required eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>  
									<span class="input-group-addon icon-question input-group-tooltip"></span>
								</div>	
							</div>
						</div>
						<div class="form-group" id="item-IS_BRAND_TO_CODE">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43205.Markaya bağlı ürün kodu oluşturulsun mu'>?</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61379.Ürün eklerken marka ve modeli zorunlu kılıyor. Özel kodu ise Marka kodu+Kategori kodu+model ismine göre atıyor. Ürün kodu değil özel kod oluşturuyor.'></div>
									<select name="IS_BRAND_TO_CODE" id="IS_BRAND_TO_CODE">
										<option value="1" <cfif check.recordcount and check.is_brand_to_code eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.recordcount and check.is_brand_to_code eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-IS_LOT_NO">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43040.Lot No Zorunlu Olsun mu?'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61370.Evet seçilir ise Lot No bazında stok takibi yapılır. Üründe de ve işlem tipinde de seçili olmalıdır. Bu sayede üretim sonucu kaydederken lot no zorunlu olur.'></div>
									<select name="IS_LOT_NO" id="IS_LOT_NO">
										<option value="1" <cfif check.recordcount and check.is_lot_no eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.recordcount and check.is_lot_no eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="item-IS_LOCATION_FOLLOW">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58999.Lokasyon Bazlı Takip Yapılsın Mı'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61371.Kullanıcıların sadece yetkili oldukları depo lokasyonlarında işlem yapması isteniyor ise seçili olmalıdır. Seçili olmaz ise depo yetkisine bakılmaz.'></div>
									<select name="IS_LOCATION_FOLLOW" id="IS_LOCATION_FOLLOW">
										<option value="1" <cfif check.recordcount and check.is_location_follow eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.recordcount and check.is_location_follow eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="item-is_stock_based_cost">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="33683.Stok Bazında Maliyet Takibi Yapılsın Mı"></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61396.Ürün maliyetlerini stok bazında takip etmenizi sağlar, maliyet kayıtlarında bulunan stok baz alınır.'></div>
									<select name="is_stock_based_cost" id="is_stock_based_cost">
										<option value="1" <cfif check.recordcount and check.is_stock_based_cost eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.recordcount and check.is_stock_based_cost eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="item-IS_PRODUCT_COMPANY">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="33673.Ürün parametre bilgisi şirkete bağlı olarak gelsin mi?"></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61399.İşaretlenir ise her şirketin ürün bilgilieri tutar. Örneğin bir şirkette ürün envantere dahil ve ötv kullanıyor iken diğer şirketlerde bu seçenekler seçili olmaz.'></div>
									<select name="IS_PRODUCT_COMPANY" id="IS_PRODUCT_COMPANY">
										<option value="1" <cfif check.recordcount and check.IS_PRODUCT_COMPANY eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.recordcount and check.IS_PRODUCT_COMPANY eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="item-spect_type">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43206.Spec Tanımı'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61403.Stok Özellik ve Konfigürasyon Ekranı ve Basketlerde üretilen ürün seçildiğinde ve seçilen ürünün tipine göre otomatik spec oluşturur'></div>
									<select name="spect_type" id="spect_type" style="width:200px;">
										<option value="0" <cfif check.recordcount and check.spect_type eq 0>selected</cfif>><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<option value="1" <cfif check.recordcount and check.spect_type eq 1>selected</cfif>><cf_get_lang dictionary_id='43208.Fiyat Farklı Alternatif Ürünlü Kon'></option>
										<option value="2" <cfif check.recordcount and check.spect_type eq 2>selected</cfif>><cf_get_lang dictionary_id='43209.Fiyatlı Alternatif Ürünlü Kon'>.</option>
										<option value="3" <cfif check.recordcount and check.spect_type eq 3>selected</cfif>><cf_get_lang dictionary_id='43210.Fiyatlı Özellik-Varyasyonlu Spec'></option>
										<option value="6" <cfif check.recordcount and check.spect_type eq 6>selected</cfif>><cf_get_lang dictionary_id='43514.Fiyatlı Alternatif Ürünlü Özellikli Kon'>.</option>
										<option value="7" <cfif check.recordcount and check.spect_type eq 7>selected</cfif>><cf_get_lang dictionary_id ='43874.Ürün Kategori Özellikli Kon'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>
								</div>	
							</div>
						</div>
						<div class="form-group" id="item-work_product_name">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43512.Standart İşcilik Ürünü'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61404.Ürün eklerken işçilik ürünü alanına burada seçtiğimiz ürün default olarak gelir.'></div>
									<cf_wrk_products form_name = 'add_our_company_info#attributes.satir#' product_name='work_product_name' stock_id='work_stock_id'>
									<input type="hidden" name="work_stock_id" id="work_stock_id" value="#check.work_stock_id#">
									<input type="text" name="work_product_name" id="work_product_name" value="<cfif len(check.work_stock_id)>#get_product_name(stock_id:check.work_stock_id,with_property:1)#</cfif>" style="width:200px;" onkeyup="get_product();">
									<cfoutput><span class="input-group-addon icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_product_names&field_id=add_our_company_info#attributes.satir#.work_stock_id&field_name=add_our_company_info#attributes.satir#.work_product_name','list');"></span></cfoutput>
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
								
							</div>
						</div>
						<div class="form-group" id="item-is_use_cargo">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='42061.Kargo Entegrasyonu Kullanılacak Mı'>?</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61407.Kargo firmasına sevkiyat bilgilerini gönderirken ve Kargom nerede bilgisine ulaşmak için kullanılır. Bu selectbox evet seçildiğinde açılan alanların şu şekilde doldurulması gerekmektedir.'></div>
									<select name="is_use_cargo" id="is_use_cargo">
										<option value="1" <cfif len(check.cargo_customer_code) or len(check.cargo_customer_password)>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif not len(check.cargo_customer_code) or not len(check.cargo_customer_password)>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>
								</div>	
							</div>
						</div>
						<div class="form-group" id="is_use_cargo_style#attributes.satir#" <cfif not len(check.cargo_customer_code) and not len(check.cargo_customer_password)>style="display:none;"</cfif>>
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43513.Kargo Müşteri Kodu'>/<cf_get_lang dictionary_id='57487.No'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61417.No Kargo firmasına sevkiyat bilgilerini gönderirken ve Kargom nerede bilgisine ulaşmak için kullanılır.'></div>
									<input type="text" name="cargo_customer_code" id="cargo_customer_code" value="#check.cargo_customer_code#" maxlength="20" style="width:200px;">
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="is_use_cargo_style#attributes.satir#" <cfif not len(check.cargo_customer_code) and not len(check.cargo_customer_password)>style="display:none;"</cfif>>
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='42062.Kargo Müşteri Şifresi'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id ='42062.Kargo Müşteri Şifresi'></div>
									<input type="password" name="cargo_customer_password" id="cargo_customer_password" value="#check.cargo_customer_password#" maxlength="10" style="width:200px;">
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="item-special_menu_file_name">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42305.Özel Menü Dosya Yolu'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61406.Workcube standart menüsü dışında oluşturulacak bir menü kullanılacak ise bu menü için kullanılacak dosyaların yolu belirtilir.'></div>
									<input type="text" name="special_menu_file_name" id="special_menu_file_name" maxlength="100" value="#check.SPECIAL_MENU_FILE#" style="width:200px;">
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="item-IS_ADD_INFORMATIONS">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="33674.Ek Bilgiler Objesi Gelsin mi?"></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61398.Güncelleme ekranlarında görüntülenen ek bilgiler ikonu ile belirtilen ek bilgileri ekleme ve güncelleme ekranlarında obje olarak gelmesini sağlar.'></div>
									<select name="IS_ADD_INFORMATIONS" id="IS_ADD_INFORMATIONS">
										<option value="1" <cfif check.recordcount and check.IS_ADD_INFORMATIONS eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.recordcount and check.IS_ADD_INFORMATIONS eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="item-is_content_follow">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43511.İçerik Detaylı Takip Yapılsın'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61388.İçerik raporunu etkiliyor. Kim okudu, ne zaman kaç defa okudu kayıtlarını sistemin tutmasını sağlar.'></div>
									<select name="is_content_follow" id="is_content_follow">
										<option value="1" <cfif check.recordcount and check.is_content_follow eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.recordcount and check.is_content_follow eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="item-file_size_check">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="33637.Dosya Boyutu Kontrol Edilsin mi?"></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61415.Evet olarak seçildiğinde sisteme yüklenen dosyalar için maksimum boyut belirtilir. Bu boyutu aşan dosyalar sisteme eklenmez. Parametrelerde yer alan Format İkonları ile entegre çalışır.'></div>
									<div class="col col-12" style="padding: 0;">
										<div class="col col-6 col-xs-12">
											<select name="file_size_check" id="file_size_check">
												<option value="1" <cfif check.is_file_size eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
												<option value="0" <cfif check.is_file_size eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
											</select>
										</div>
										<div class="col col-6 col-xs-12" id="is_format_size#attributes.satir#">
											<input type="text" name="file_size" id="file_size"  style="width:40px" onkeyup="isNumber(this);" placeholder="MB" value="<cfif len(check.file_size)>#check.file_size#</cfif>"> 
										</div>
									</div>
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>						
						<div class="form-group" id="item-AUTHORITY">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30003.Aboneler'><cf_get_lang dictionary_id='44702.Yetki Bazında Çalışsın'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61367.Satış modülündeki aboneler bu parametreye bağlı olarak görünmektedir. Seçilmezse görünmez.'></div>
									<select name="IS_SUBSCRIPTION_AUTHORITY" id="IS_SUBSCRIPTION_AUTHORITY">
										<option value="1" <cfif check.recordcount and check.IS_SUBSCRIPTION_AUTHORITY eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.recordcount and check.IS_SUBSCRIPTION_AUTHORITY eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select> 
									<span class="input-group-addon icon-question input-group-tooltip"></span>
								</div>	
							</div>
						</div>
						<div class="form-group" id="item-is_control_branch_project">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='43948.Şube Bazında Proje Kontrolü Yapılsın mı'>?</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"></div>
									<select name="is_control_branch_project" id="is_control_branch_project">
										<option value="1" <cfif check.recordcount and check.is_control_branch_project eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.recordcount and check.is_control_branch_project eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-is_cost_location">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="33696.Çıkış İşlemlerinde Maliyet Takip Yöntemi"></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"></div>
									<select name="IS_COST_LOCATION" id="IS_COST_LOCATION" style="width:200px;">
										<option value="0"><cf_get_lang dictionary_id="57734.Seçiniz"></option>
										<option value="1" <cfif check.recordcount and check.is_cost_location eq 1> selected</cfif>><cf_get_lang dictionary_id="33690.Lokasyon Bazlı"></option>
										<option value="2" <cfif check.recordcount and check.is_cost_location eq 2> selected</cfif>><cf_get_lang dictionary_id="33687.Depo Bazlı"></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="item-IS_RATE">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43505.İleri ve Geriye Dönük Kur İşlemi Yapılsın'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61382.İşlem tarihindeki döviz otomatik olarak ekrana getirilir.'></div>
									<select name="IS_RATE" id="IS_RATE">
										<option value="1" <cfif check.RecordCount and check.is_rate eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.RecordCount and check.is_rate eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="item-is_serial_control_location">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="43293.Lokasyon Bazında Seri Giriş Çıkış Kontrolü Yapılsın"></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"></div>
									<select name="is_serial_control_location" id="is_serial_control_location">
										<option value="1" <cfif check.recordcount and check.is_serial_control_location eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.recordcount and check.is_serial_control_location eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						
						<div class="form-group" id="item-is_ship_upd">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43599.İşlenmiş İrsaliyeler Güncellenebilsin'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61390.İrsaliye bir faturaya çekildiyse daha sonradan bu irsaliyedeki kayıtlar güncellenebilsin mi ?'></div>
									<select name="is_ship_upd" id="is_ship_upd">
										<option value="1" <cfif check.recordcount and check.is_ship_update eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.recordcount and check.is_ship_update eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-is_prod_cost_type">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45085.Üretilen Ürünler İçin Ürün Bazında Maliyet İşlemi Yapılsın Mı?'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61420.Üretilen ürünler için ürün bazında maliyet takibi yapmak isteniyor ise evet seçili olmalıdır. Seçilmemesi durumunda spec bazında maliyet takibi yapılır.'></div>
									<select name="is_prod_cost_type" id="is_prod_cost_type">
										<option value="1" <cfif check.recordcount and check.is_prod_cost_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.recordcount and check.is_prod_cost_type eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="item-IS_ENCRYPTED_SALARY">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="54572.Çalışan Maaşları Şifreli Tutulsun"></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"></div>
									<select name="IS_ENCRYPTED_SALARY" id="IS_ENCRYPTED_SALARY">
										<option value="1" <cfif check.recordcount and check.IS_ENCRYPTED_SALARY eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.recordcount and check.IS_ENCRYPTED_SALARY eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>					
						<div class="form-group" id="is_control_time#attributes.satir#" <cfif check.recordcount and check.is_time neq 1>style="display:none;"</cfif>>
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="33686.Kontrol Periyodu"></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"></div>
									<select name="is_time_style" id="is_time_style" style="width:65px;">
										<option value=""><cf_get_lang dictionary_id='58693.Seç'></option>
										<option value="1" <cfif check.recordcount and check.is_time_style eq 1>selected</cfif>><cf_get_lang dictionary_id='58458.Haftalık'></option>
										<option value="2" <cfif check.recordcount and check.is_time_style eq 2>selected</cfif>><cf_get_lang dictionary_id='58457.Günlük'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
					
						<div class="form-group" id="is_control_time#attributes.satir#" <cfif check.recordcount and check.is_time neq 1>style="display:none;"</cfif>>
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="33685.Kontrol Başlama Tarihi (Günlük)"></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"></div>
									<cfsavecontent variable="date_message"><cf_get_lang dictionary_id="57782.Tarih Değerini Kontrol Ediniz">!</cfsavecontent>
									<cfinput type="text" name="time_control_date" id="time_control_date" value="#DateFormat(check.time_control_date,dateformat_style)#" style="width:65px;" maxlength="10" validate="#validate_style#" message="#date_message#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="time_control_date"></span>
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="item-logo_type">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42394.Logolar'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61419.Çıktı aldığımızda alt kısımda çıkan (Firma adı, adres, telefon)bilgileri bulunduğumuz şirketten mi, şubeden mi alacağını belirlediğimiz kısım'></div>
									<select name="logo_type" id="logo_type" style="width:200px;">
										<option value="is_branch" <cfif check.logo_type eq 'is_branch'>selected</cfif>><cf_get_lang dictionary_id ='43865.Şube Bilgilerini Getirsin'></option>
										<option value="is_company" <cfif check.logo_type eq 'is_company'>selected</cfif>><cf_get_lang dictionary_id ='43866.Şirket Bilgilerini Getirsin'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>
								</div>	
							</div>
						</div>
						<div class="form-group" id="item-is_watalogy_integrated">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61444.Watalogy ile Entegre Çalışsın mı?'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61445.Watalogy ürünlerinizi evrensel olarak kataloglar ve pazar yerlerine entegre eder'></div>
									<select name="is_watalogy_integrated" id="is_watalogy_integrated" style="width:200px;">
										<option value="1" <cfif check.is_watalogy_integrated eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.is_watalogy_integrated eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>
								</div>	
							</div>
						</div>
						<div class="form-group" id="item-watalogy_member_code">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30366.Watalogy'> <cf_get_lang dictionary_id='30707.Member Code'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61511.Benzersiz watalogy üye kodunu belirtir.'></div>
									<input type="text" name="watalogy_member_code" id="watalogy_member_code" value="<cfif check.recordCount and len(check.WATALOGY_MEMBER_CODE)>#check.WATALOGY_MEMBER_CODE#</cfif>"></input>
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="item-is-cti">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61518.CTI'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<select name="is_cti_integrated" id="is_cti_integrated">
										<option value="1" <cfif check.is_cti_integrated eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.is_cti_integrated eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
								</div>	
							</div>
						</div>
						<div class="form-group" id="item-operator">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61519.Operatör'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<select name="operator" id="operator">
										<option value="Verimor" <cfif check.operator eq 'Verimor'>selected</cfif>><cf_get_lang dictionary_id='61520.Verimor'></option>										
									</select>
								</div>	
							</div>
						</div>
						<div class="form-group" id="item-line-limit">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61521.Harici Hat Limiti'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="line_limit" id="line_limit" value="#check.line_limit#">
							</div>
						</div>
						<div class="form-group" id="item-extension-limit">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61522.Dahili Hat Limiti'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="extension_limit" id="extension_limit" value="#check.extension_limit#">
							</div>
						</div>
						<div class="form-group" id="item-tel-numbers">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61523.Telefon Numaraları'></label>
							<div class="col col-8 col-xs-12">
								<textarea type="text" name="tel_numbers" id="tel_numbers" placeholder="Numaraları yazınız">#check.tel_numbers#</textarea>
							</div>
						</div>
						<div class="form-group" id="item-api-key">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61524.API Key'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="api_key" id="api_key" value="#check.api_key#">	
							</div>
						</div>
						<div class="form-group" id="item-is-sms">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='63054.SMS Entegrasyonu Yapılsın Mı'>?</label>
							<div class="col col-8 col-xs-12">
								<select name="IS_SMS" id="IS_SMS">
									<option value="1" <cfif check.recordcount and check.is_sms eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
									<option value="0" <cfif check.recordcount and check.is_sms eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
								</select>	
							</div>
						</div>
						<div class="form-group" id="item-sms-company">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49523.SMS'> <cf_get_lang dictionary_id='61519.Operatör'></label>
							<div class="col col-8 col-xs-12">
								<select name="sms_Company" id="sms_Company">
									<option value="5" <cfif len(check.is_sms) and check.sms_Company eq 1>selected</cfif>><cf_get_lang dictionary_id='61520.Verimor'></option>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-sms-username">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='42223.SMS Kullanıcı Adı'>*</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61411.SMS Kullanıcı Adı Sms kullanımı için kullanıcı adının otomatik gelmesi sağlanır.'></div>
									<input type="text" name="sms_UserName" id="sms_UserName" maxlength="50" value="<cfif len(check.sms_UserName)>#check.sms_UserName#</cfif>">
								</div>
							</div>
						</div>
						<div class="form-group" id="is-sms-password">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='42247.SMS Şifre'>*</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='61412.SMS Şifre Sms kulanımı için gerekli olan şifre seçimi yapılmasını sağlar'></div>
									<input type="password" name="sms_Password" id="sms_Password" maxlength="50" value="<cfif len(check.sms_Password)>#check.sms_Password#</cfif>">
									<span class="input-group-addon icon-question input-group-tooltip"></span>
								</div>	
							</div>
						</div>
						<div class="form-group" id="item-is-sendgrid">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='62655.Sendgrid Entegrasyonu Yapılsın mı'>?</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<select name="is_sendgrid_integrated" id="is_sendgrid_integrated">
										<option value="1" <cfif check.is_sendgrid_integrated eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.is_sendgrid_integrated eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
								</div>	
							</div>
						</div>
						<div class="form-group" id="item-mail-api-key">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43645.SendGrid'> <cf_get_lang dictionary_id='61524.API Key'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="mail_api_key" id="mail_api_key" value="#check.mail_api_key#">	
							</div>
						</div>
						<div class="form-group" id="item-sender-mail">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43645.SendGrid'> <cf_get_lang dictionary_id='62656.Gönderici Maili'> </label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="sender_mail" id="sender_mail" value="#check.sender_mail#">	
							</div>
						</div>
						<div class="form-group" id="item-sender-group-id">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43645.SendGrid'> <cf_get_lang dictionary_id='62952.Group No.'> </label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='65277.Maillere abonelikten çıkma eklentisi eklenir ve Sendgridden aldığınız group idye bu kişileri ekler.'></div>
									<cfinput type="text" onKeyUp="isNumber(this)" validate="integer" name="sendgrid_group_id" id="sendgrid_group_id" value="#check.sendgrid_group_id#">	
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="item-is-kep">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='62763.Kep Entegrasyonu Yapılsın mı?'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<select name="is_kep_integrated" id="is_kep_integrated">
										<option value="1" <cfif check.is_kep_integrated eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
										<option value="0" <cfif check.is_kep_integrated eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
									</select>
								</div>	
							</div>
						</div>
						<div class="form-group" id="item-kep-api-key">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='62764.KEP'><cf_get_lang dictionary_id='61524.API Key'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="kep_api_key" id="kep_api_key" value="#check.kep_api_key#">	
							</div>
						</div>
						<div class="form-group" id="item-company-kep">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'><cf_get_lang dictionary_id='59876.Kep Adresi'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="company_kep_adress" id="company_kep_adress" value="#check.company_kep_adress#">	
							</div>
						</div>
						<div class="form-group" id="item-google-api-key">
							<label class="col col-4 col-xs-12">Google <cf_get_lang dictionary_id='61524.API Key'></label>
							<div class="col col-8 col-xs-12">
                                <cfset get_api_key = getComponent.get_api_key()>
								<input type="text" name="google_api_key" id="google_api_key" value="<cfif len(get_api_key.GOOGLE_API_KEY)>#get_api_key.GOOGLE_API_KEY#</cfif>">	
							</div>
						</div>
						<div class="form-group" id="item-google-client-id">
							<label class="col col-4 col-xs-12">Google <cf_get_lang dictionary_id='64109.CLIENT_ID'></label>
							<div class="col col-8 col-xs-12">
                                <cfset get_api_key = getComponent.get_api_key()>
								<input type="text" name="google_client_id" id="google_client_id" value="<cfif len(get_api_key.GOOGLE_CLIENT_ID)>#get_api_key.GOOGLE_CLIENT_ID#</cfif>">	
							</div>
						</div>
						<div class="form-group" id="item-google-client-secret">
							<label class="col col-4 col-xs-12">Google <cf_get_lang dictionary_id='64110.CLIENT_SECRET'></label>
							<div class="col col-8 col-xs-12">
                                <cfset get_api_key = getComponent.get_api_key()>
								<input type="text" name="google_client_secret" id="google_client_secret" value="<cfif len(get_api_key.GOOGLE_CLIENT_SECRET)>#get_api_key.GOOGLE_CLIENT_SECRET#</cfif>">	
							</div>
						</div>
						<div class="form-group" id="item-google-api-lang">
							<label class="col col-4 col-xs-12">Google Language</label>
							<div class="col col-8 col-xs-12">
								<cfif len(check.google_api_key) and len(check.google_language)>
									<cfset get_lang = getComponent.get_voices()>
									<cfset get_api_lang = deserializeJSON(get_lang)>

									<select name="google_language" id="google_language">
										<cfloop array="#get_api_lang.voices#" item="item">
											<option value = "#item.languageCodes[1]#/#item.name#" <cfif check.google_language eq "#item.languageCodes[1]#/#item.name#">selected</cfif>>#item.languageCodes[1]# / #item.name# / #item.ssmlGender# </option>
										</cfloop>
									</select>
								<cfelse>
									<select name="google_language" id="google_language">
									</select>
								</cfif>
							</div>
						</div>
						<div class="form-group" id="item-is_accounter_integrated">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='64143.Muhasebeciye Gerçek Zamanlı Veri Gönder'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='64144.Muhasebeciniz Workcube, Watom veya Magic Accounter kullanıyorsa bu servisi kullanarak tüm muhasebe kayıtlarınız doğrudan muhasebecinize Rest Full API ile gönderilir'></div>
									<select name="is_accounter_integrated" id="is_accounter_integrated">
										<option value="0" <cfif check.is_accounter_integrated eq 0>selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
										<option value="1" <cfif check.is_accounter_integrated eq 1>selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
									</select>
									<span class="input-group-addon icon-question input-group-tooltip"></span>
								</div>	
							</div>
						</div>
						<div class="form-group" id="item-accounter_domain">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='64145.Muhasebeci Domaini'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='64146.Benzersiz watalogy üye kodunu belirtir.'></div>
									<input type="text" name="accounter_domain" id="accounter_domain" value="<cfif check.recordCount and len(check.ACCOUNTER_DOMAIN)>#check.ACCOUNTER_DOMAIN#</cfif>"></input>
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
						<div class="form-group" id="item-accounter_key">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='64147.Muhasebeci Domain Doğrulama Kodu'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<div class="input-group_tooltip"><cf_get_lang dictionary_id='64147.Muhasebeci Domain Doğrulama Kodu.'></div>
									<input type="text" name="accounter_key" id="accounter_key" value="<cfif check.recordCount and len(check.ACCOUNTER_KEY)>#check.ACCOUNTER_KEY#</cfif>">
									<span class="input-group-addon icon-question input-group-tooltip"></span>	
								</div>
							</div>
						</div>
					</div>
				</cfoutput>
			</cf_box_elements>
			<div class="ui-form-list-btn">
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
				<cf_record_info 
					query_name="check"
					record_emp="record_emp" 
					record_date="record_date"
					update_emp="update_emp"
					update_date="update_date">
				</div>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
				<cf_workcube_buttons is_delete='0' type_format="1" is_upd='1' add_function='upd_control()'>
				</div>
			</div>
		</cfform>
	</cf_box>
</div>
<script language="javascript">
function upd_control()
{
	
	if(document.getElementById("is_time").checked == true)
	{
		if(document.getElementById("is_time_style").value == "")
		{
			alert("<cf_get_lang dictionary_id='33833.Zaman Harcaması Kontrol Periyodu Seçmelisiniz!'>");
			return false;
		}
	}

}

$(".input-group-tooltip").mouseover(function() {
	$( this ).closest("div.input-group").css("position","relative");
	$( this ).closest("div.input-group").find( ".input-group_tooltip" ).stop().show();
}).mouseout(function() {
	$( this ).closest("div.input-group").css("position","initial");
	$( this ).closest("div.input-group").find( ".input-group_tooltip" ).stop().hide();
});

//Gelen Google API Key'e göre Google Sesleri çekip selecte yazar.
$("#google_api_key").focusout(function(){
	key_val = $("#google_api_key").val();
	data = {
		"key_val": key_val
	};
	$.ajax({
	 	url :'/wex.cfm/speechtotext/get_voices',
		method: 'post',
		contentType: 'application/json; charset=utf-8',
		dataType: "json",
		data : JSON.stringify(data),
		success : function(response){ 
			if(response.error != undefined)
			{
				if(response.error.message != undefined)
					alert("Google API Key!");
			}
			else
			{
				$('#google_language').find('option').remove();

				for(i = 0; i<response.voices.length; i++)
				{
					$("#google_language").append(new Option(""+response.voices[i].languageCodes[0] +"/"+ response.voices[i].name +"/"+ response.voices[i].ssmlGender+"", response.voices[i].languageCodes[0] +"/"+ response.voices[i].name));
				}
			}
			
		},
		error: function(e) {
			alert("Google API Key!");
		}
	});   
	
});

</script>