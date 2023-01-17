<table class="dph">
    <tr>
        <td class="dpht"><cf_get_lang_main no='737.Sistem Yönetimi'></td>
    </tr>
</table>
<cfoutput> 
	<div class="pagemenus_container">
		<div style="float:left;">
			<ul class="pagemenus">
				<li><strong><cf_get_lang_main no='1734.Şirketler'></strong>
					<ul>
						<li><a href="#request.self#?fuseaction=settings.form_add_our_company"><cf_get_lang no='207.Şirket Tanımları'></a></li>
						<li><a href="#request.self#?fuseaction=settings.form_list_company"><cf_get_lang no='882.Şirket Akış Parametreleri'></a></li>
					</ul>
				</li>
			</ul>
			<cfif session.ep.admin eq 1>
				<div class="pagemenus_clear"></div>
				<ul class="pagemenus">	
					<li><strong><cf_get_lang no='858.Help Desk'></strong>
						<ul>
							<li><a href="#request.self#?fuseaction=settings.form_add_helpdesk_info"><cf_get_lang no='858.Help Desk'></a></li>
						</ul>
					</li>
				</ul>
				<div class="pagemenus_clear"></div>
				<ul class="pagemenus">	
					<li><strong><cf_get_lang no='214.Lisans'></strong>
						<ul>
							<li><a href="#request.self#?fuseaction=settings.workcube_license"><cf_get_lang no='205.WorkCube Lisans Bilgileri'></a></li>
						</ul>
					</li>
				</ul>
			</cfif>
			<div class="pagemenus_clear"></div>
			<ul class="pagemenus">
				<li><strong><cf_get_lang_main no='1584.Dil'></strong>
					<ul>
						<li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=settings.popup_list_lang_settings','medium');"><cf_get_lang_main no='520.Sözlük'></a></li>
						<li><a href="#request.self#?fuseaction=settings.special_langs"><cf_get_lang no='1265.Özel Diller'></a></li>
						<cfif session.ep.admin eq 1>
							<li><a href="#request.self#?fuseaction=settings.list_languages_deff"><cf_get_lang_main no='1722.Dil Eksiklikleri'></a></li>
							<li><a href="#request.self#?fuseaction=settings.new_lang_settings"><cf_get_lang no='215.Dil Ayarları'></a></li>
							<li><a href="#request.self#?fuseaction=settings.language"><cf_get_lang no='687.Dil Export İmport'></a></li>
							<li><a href="#request.self#?fuseaction=settings.lang_report"><cf_get_lang no ='2577.Dil Arama Rapor'></a></li>
						</cfif>  
					</ul>
				 </li>
			</ul> 
			<cfif session.ep.admin eq 1> 
				<div class="pagemenus_clear"></div>
				<ul class="pagemenus">
					<li><strong><cf_get_lang no='159.Fuseaction'></strong>
						<ul><li><a href="#request.self#?fuseaction=settings.imp_exp_switch"><cf_get_lang no='143.Fuseaction Export Import'></a></li></ul>
					</li>
				</ul>
			</cfif>   
			<div class="pagemenus_clear"></div>  
			<ul class="pagemenus">
				<li><strong><cf_get_lang no='1274.İşlem - Süreç Kategorileri'></strong>
					<ul>
						<li><a href="#request.self#?fuseaction=settings.list_process_cats"><cf_get_lang no='177.İşlem Kategorileri'></a></li>
						<li><a href="#request.self#?fuseaction=settings.form_add_main_process_cat"><cf_get_lang no='1264.Ana İşlem Kategorileri'></a></li>
						<li><a href="#request.self#?fuseaction=process.list_process"><cf_get_lang no='1266.Süreçler'></a></li>
						<li><a href="#request.self#?fuseaction=process.list_process_groups"><cf_get_lang no='1267.Süreç Grupları'></a></li>
					</ul>
				</li>
			</ul>
			<div class="pagemenus_clear"></div>
			<ul class="pagemenus">
				<li><strong><cf_get_lang no='539.Zaman Ayarlı Görevler'></strong>
					<ul><li><a href="#request.self#?fuseaction=settings.list_schedule_settings"><cf_get_lang no='539.Zaman Ayarlı Görevler'></a></li></ul>
				</li>
			</ul>
		</div>
		<div style="float:left;">
			<ul class="pagemenus">     
				<li><strong><cf_get_lang no='216.Dönemler'></strong>
					<ul><li><a href="#request.self#?fuseaction=settings.form_add_period"><cf_get_lang no='189.Muhasebe Dönemleri'></a></li></ul>
				</li>
			</ul>
			<div class="pagemenus_clear"></div>
			<ul class="pagemenus">     
				<li><strong><cf_get_lang no='1546.Banka Tanımlar'></strong>
					<ul>
						<li><a href="#request.self#?fuseaction=settings.form_add_bank_type"><cf_get_lang_main no='575.Bankalar'></a></li>
						<li><a href="#request.self#?fuseaction=settings.list_pos_relation"><cf_get_lang no='3172.Sanal Pos Tanımları'></a></li>
					</ul>
				</li>
			</ul>
			<div class="pagemenus_clear"></div>
			<ul class="pagemenus">     
				<li><strong><cf_get_lang_main no='1204.Belge Numaraları'>-<cf_get_lang no='887.Belge Tipleri'></strong>
					<ul>
						<li><a href="#request.self#?fuseaction=settings.form_add_general_paper"><cf_get_lang_main no='1204.Belge Numaraları'></a></li>
						<li><a href="#request.self#?fuseaction=settings.form_add_document_type"><cf_get_lang no='887.Belge Tipleri'></a></li>
					</ul>
				</li>
			</ul>
			<div class="pagemenus_clear"></div>
			<ul class="pagemenus">     
				<li><strong><cf_get_lang no='218.Fax ve Printer Parametreleri'></strong>
					<ul>
						<li><a href="#request.self#?fuseaction=settings.form_add_printer"><cf_get_lang no='219.Printer Adları'></a></li>
                        <cfquery name="get_einvoice_type" datasource="#DSN#" maxrows="1">
                        	SELECT EINVOICE_TYPE FROM OUR_COMPANY_INFO WHERE EINVOICE_TYPE=1
                        </cfquery>
                        <cfif get_einvoice_type.recordcount>
                        <li><a href="#request.self#?fuseaction=settings.change_einvoice_description"><cf_get_lang_main no='2254.E-Fatura Numara Tanımları'></a></li>
                        </cfif>
					</ul>
				</li>
			</ul>
			<!---
			<div class="pagemenus_clear"></div>
			<ul class="pagemenus">     
				<li><a href="javascript://"><cf_get_lang_main no='221.Barkod'></strong></a>
					<ul><li><a href="#request.self#?fuseaction=settings.add_upd_barcode_param"><cf_get_lang no='221.Barkod Parametreleri'></a></li></ul>
				</li>
			</ul>
			--->
			<div class="pagemenus_clear"></div>
			<ul class="pagemenus">     
				<li><strong><cf_get_lang no='222.Output Şablonları'></strong>
					<ul>
						<li><a href="#request.self#?fuseaction=settings.form_add_template_dimension"><cf_get_lang no='223.A4 Antetli Şablonu'></a></li>
						<li><a href="#request.self#?fuseaction=settings.form_add_sticker_template"><cf_get_lang no='224.Etiket Basım Şablonu'></a></li>
						<li><a href="#request.self#?fuseaction=settings.form_add_template"><cf_get_lang no='225.Belge-Form Şablonları'></a></li>
						<li><a href="#request.self#?fuseaction=settings.form_add_print_files"><cf_get_lang no='854.Sistem İçi Yazıcı Belgeleri'></a></li>
						<cfif session.ep.admin eq 1>
							<li><a href="#request.self#?fuseaction=settings.list_design_paper"><cf_get_lang no ='1278.Şablon Tasarımları'> (<cf_get_lang no ='3173.Design Paper'>)</a></li>
						</cfif>
					</ul>
				</li>
			</ul>
			<div class="pagemenus_clear"></div>
			<ul class="pagemenus">     
				<li><strong><cf_get_lang no='225.Belge-Form Şablonları'></strong>
					<ul>
						<li><a href="#request.self#?fuseaction=settings.add_basket_info_type"><cf_get_lang no='808.Basket Ek Tanımları'></a></li>
						<li><a href="#request.self#?fuseaction=settings.form_add_bskt_detail"><cf_get_lang no='227.Basket Şablonları'></a></li>
						<li><a href="#request.self#?fuseaction=settings.form_add_bskt_temp_detail"><cf_get_lang no='853.Basket Template Şablonları'></a></li>
					</ul>
				</li>
			</ul>
			<div class="pagemenus_clear"></div>
			<ul class="pagemenus">     
				<li><strong><cf_get_lang_main no='9.Forum'></strong>
					<ul><li><a href="#request.self#?fuseaction=settings.form_add_badword"><cf_get_lang no='231.Kelime Filtresi'></a></li></ul>
				</li>
			</ul>
		</div>
		<div style="float:left;">   
			<cfif session.ep.admin eq 1>
				<ul class="pagemenus">
					<li><strong><cf_get_lang no='232.Veri Tabanı'></strong>
						<ul>	
							<li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_db_diff','list');"><cf_get_lang no='233.DB Karşılaştırma'></a></li>
							<li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_history_diff','list');"><cf_get_lang_main no='1730.Veritabanı History Karşılaştırma'></a></li>
							<li><a href="#request.self#?fuseaction=settings.import_export_table_column"><cf_get_lang no='1587.Tablo'>-<cf_get_lang no='1075.Kolon'><cf_get_lang_main no='1945.Export'><cf_get_lang_main no='1229.İmport'></a></li>
						</ul>
					</li>
				</ul>
			</cfif>
            <div class="pagemenus_clear"></div>
			<ul class="pagemenus">	
				 <li><strong><cf_get_lang no='855.Sektör Tanımları'></strong>
					<ul>	
						<li><a href="#request.self#?fuseaction=settings.form_add_branch_sales"><cf_get_lang no='856.Şube Kasa Satış Hesapları'></a></li>
						<li><a href="#request.self#?fuseaction=settings.form_add_branch_discount"><cf_get_lang no='2699.Şube İskonto Yetkisi'></a></li>
					</ul>
				</li>
			</ul>
			<cfif session.ep.admin eq 1>
            	<div class="pagemenus_clear"></div>
				<ul class="pagemenus">
					<li><strong><cf_get_lang_main no='46.Ürün Yönetimi'></strong>
						<ul>
							<li><a href="#request.self#?fuseaction=settings.transfer_work_product"><cf_get_lang_main no='46.Ürün Yönetimi'></a></li>
						</ul>
					</li>
			   </ul>     
			</cfif>
			<!---
			<div class="pagemenus_clear"></div>
			<ul class="pagemenus">
				<li><a href="javascript://"><cf_get_lang no='860.Backgrounds'></strong></a>
					<ul>
						<li><a href="#request.self#?fuseaction=settings.form_add_background"><cf_get_lang no='860.Background'></a></li>
					</ul>
				</li>
			</ul>
			--->
            <div class="pagemenus_clear"></div>
			<ul class="pagemenus">
				<li><strong><cf_get_lang no='1031.XML ler'></strong>
					<ul>
						<li><a href="#request.self#?fuseaction=objects2.product_xml_files"><cf_get_lang_main no='152.Ürünler'> <cf_get_lang_main no='1969.XML'></a></li>
                        <li><a href="#request.self#?fuseaction=settings.list_product_xml_definition">Çoklu Ürün XML Tanımlama</a></li>
						<!---silmeyin Kullanılmaya başlar ise acılsın <li><a href="#request.self#?fuseaction=settings.form_add_xml_converter">XML Converter</a></li>--->
					</ul>
				</li>
			</ul>
			<cfif session.ep.admin eq 1 and workcube_mode eq 0 and fusebox.use_period eq 1>
            	<div class="pagemenus_clear"></div>
				<ul class="pagemenus">
					<li><strong><cf_get_lang no='3187.Grup İçi İşlemler'></strong>
						<ul><li><a href="#request.self#?fuseaction=settings.form_add_company_group_action"><cf_get_lang no='3187.Grup İçi İşlemler'></a></li></ul>
					</li>
				</ul> 
			</cfif>
            <div class="pagemenus_clear"></div>
			<ul class="pagemenus">
				<li><strong><cf_get_lang_main no='1971.Formlar'></strong>
					<ul><li><a href="#request.self#?fuseaction=settings.list_detail_survey"><cf_get_lang no='281.Form Tanımları'></a></li></ul>
				</li>
			</ul>
            <div class="pagemenus_clear"></div>
			<ul class="pagemenus">
				<li><strong><cf_get_lang_main no='1414.Test'></strong>
					<ul>
						<li><a href="#request.self#?fuseaction=settings.list_test_category"><cf_get_lang no='288.Test Kategorileri'></a></li>
						<li><a href="#request.self#?fuseaction=settings.add_subject_cat"><cf_get_lang no='303.Test Tanımları'></a></li>
					</ul>
				</li>
			</ul>
		</div>
	</div>
</cfoutput> 
<script src="../design/SpryAssets/left_menus/jquery.treeview.js" type="text/javascript"></script>
