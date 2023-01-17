<cf_xml_page_edit fuseact="settings.system_transfers">
<table class="dph">
    <tr>
        <td class="dpht"><cf_get_lang_main no='1876.Aktarimlar'></td>
    </tr>
</table>
<cfif session.ep.admin eq 1>
	<cfoutput>
		<div class="pagemenus_container">
			<div style="float:left;">
				<ul class="pagemenus">
					<li><strong><cf_get_lang_main no='2157.Genel'></strong>
						<ul>
							<li><a href="#request.self#?fuseaction=settings.xml_export"><cf_get_lang no='694.XML Export'></a></li>
							<li><a href="#request.self#?fuseaction=settings.xml_cycle"><cf_get_lang no='814.XML Aktarım'></a></li>
							<cfif (is_denied_module eq 1 and get_module_user(46)) or is_denied_module eq 0>  
								<li><a href="#request.self#?fuseaction=settings.form_add_budget_items_import"><cf_get_lang no='3182.Bütçe Kalemi Aktarım'></a></li>
							</cfif>
							<cfif (is_denied_module eq 1 and get_module_user(8)) or is_denied_module eq 0> 
								<li><a href="#request.self#?fuseaction=settings.form_add_assetp_import"><cf_get_lang no='3123.Fiziki Varlık Aktarım'></a></li>
							</cfif>
							<cfif (is_denied_module eq 1 and get_module_user(1)) or is_denied_module eq 0> 
								<li><a href="#request.self#?fuseaction=settings.form_add_project_import"><cf_get_lang no='3184.Project Transfer'></a></li>
							</cfif>
							<cfif (is_denied_module eq 1 and get_module_user(22)) or is_denied_module eq 0> 
								<li><a href="#request.self#?fuseaction=settings.import_account_plan"><cf_get_lang no='1477.Hesap Planı Aktarım'></a></li>
							</cfif>
							<cfif (is_denied_module eq 1 and get_module_user(4)) or is_denied_module eq 0> 
								<li><a href="#request.self#?fuseaction=settings.import_note"><cf_get_lang no='1547.Not Aktarım'></a></li>
							</cfif>
							<cfif (is_denied_module eq 1 and get_module_user(21)) or is_denied_module eq 0> 
								<li><a href="#request.self#?fuseaction=settings.form_cheque_voucher_import"><cf_get_lang_main no ='1117.Çek Senet İmport'></a></li> 
							</cfif>
							<cfif (is_denied_module eq 1 and get_module_user(31)) or is_denied_module eq 0> 
								<li><a href="#request.self#?fuseaction=settings.form_add_inventory_import"><cf_get_lang no='1775.Demirbaş Aktarım'></a></li>
							</cfif>
							<li><a href="#request.self#?fuseaction=settings.import_add_info"><cf_get_lang no='838.Ek Bilgi Aktarımı'></a></li>
							<cfif (is_denied_module eq 1 and get_module_user(19)) or is_denied_module eq 0> 
								<li><a href="#request.self#?fuseaction=settings.form_bank_branch_import"><cf_get_lang no='2764.Banka Şubesi Aktarım'></a></li>
								<li><a href="#request.self#?fuseaction=settings.form_add_bank_account_import"><cf_get_lang no='3176.Banka Hesabı Aktarım'></a></li>
							</cfif>
							<cfif (is_denied_module eq 1 and get_module_user(11)) or is_denied_module eq 0> 
								<li><a href="#request.self#?fuseaction=settings.form_add_order_import"><cf_get_lang no='2777.Sipariş Aktarım'></a></li>
							</cfif>
							<cfif (is_denied_module eq 1 and get_module_user(5)) or is_denied_module eq 0> 
								<li><a href="#request.self#?fuseaction=settings.demand_import"><cf_get_lang no='3177.Takip Aktarım'></a></li>
							</cfif>
							<li><a href="#request.self#?fuseaction=settings.budget_plan_import">Planlama ve Tahakkuk Fişi Aktarım</a></li>
						</ul>
					</li>
				</ul>
				<div class="pagemenus_clear"></div>
				<ul class="pagemenus">
					<li><strong><cf_get_lang_main no='5.Üyeler'></strong>
						<ul>
							<cfif (is_denied_module eq 1 and get_module_user(4)) or is_denied_module eq 0>
								<li><a href="#request.self#?fuseaction=settings.form_member_import"><cf_get_lang no='35.Kurumsal Üye Aktarım'></a></li>
								<li><a href="#request.self#?fuseaction=settings.form_add_consumer_member_import"><cf_get_lang no='3175.Bireysel Üye Aktarım'></a></li>
								<li><a href="#request.self#?fuseaction=settings.form_add_company_partner_import"><cf_get_lang no='3185.Kurumsal Çalışan Aktarımı'></a></li>
								<li><a href="#request.self#?fuseaction=settings.form_add_company_branch_import"><cf_get_lang no='3186.Kurumsal Üye Şube Aktarımı'></a></li>
							</cfif>
							<cfif (is_denied_module eq 1 and get_module_user(22)) or is_denied_module eq 0> 
								<li><a href="#request.self#?fuseaction=settings.form_member_period_import"><cf_get_lang_main no='1399.Muhasebe Kodu'> <cf_get_lang no='1548.Aktarım'></a></li>
							</cfif>
							<cfif (is_denied_module eq 1 and get_module_user(16)) or is_denied_module eq 0> 
								<li><a href="#request.self#?fuseaction=settings.form_member_risk_limit_import"><cf_get_lang no='1774.Üye Risk Bilgileri Aktarım'></a></li>
							</cfif>
							<cfif (is_denied_module eq 1 and get_module_user(11)) or is_denied_module eq 0> 
								<li><a href="#request.self#?fuseaction=settings.form_add_subscription_import"><cf_get_lang no='38.Abone Aktarım'></a></li>
								<li><a href="#request.self#?fuseaction=settings.form_add_payment_plan_import"><cf_get_lang_main no='1420.Abone'><cf_get_lang no='3183.Ödeme Planı Aktarım'></a></li>
								<li><a href="#request.self#?fuseaction=settings.form_add_invoice_payment_plan_import"><cf_get_lang_main no='29.Fatura'><cf_get_lang no='3183.Ödeme Planı Aktarım'></a></li>
 								<cfif session.ep.our_company_info.is_efatura eq 1>                               
                                    <li><a href="#request.self#?fuseaction=settings.einvoice_comp_import">E-Fatura Mükellef Listesi Aktarım</a></li>
                                </cfif>
							</cfif>
							<cfif (is_denied_module eq 1 and get_module_user(19)) or is_denied_module eq 0> 
								<li><a href="#request.self#?fuseaction=settings.form_add_dbs_limit_import"><cf_get_lang no="857.DBS Aktarım"></a></li>
							</cfif>
						</ul>
					</li>
				</ul>
			</div>
			<div style="float:left;">
				<ul class="pagemenus">
					<li><strong><cf_get_lang_main no='40.Stok'>-<cf_get_lang_main no='245.Ürün'>-<cf_get_lang_main no='1052.Üretim'></strong>
						<ul>
							<cfif (is_denied_module eq 1 and get_module_user(5)) or is_denied_module eq 0> 
								<li><a href="#request.self#?fuseaction=settings.form_product_import"><cf_get_lang no='1272.Ürün Aktarım'></a></li>
                                <li><a href="#request.self#?fuseaction=settings.product_category_import">Ürün Kategorileri Aktarım</a></li>
								<li><a href="#request.self#?fuseaction=settings.import_unit"><cf_get_lang no='1773.Birim Aktarım'></a></li>
								<li><a href="#request.self#?fuseaction=settings.form_company_stock_code_import"><cf_get_lang no='3139.Üye Stok Kodu Aktarım'></a></li>
								<li><a href="#request.self#?fuseaction=settings.import_stock_extra_barcodes"><cf_get_lang no='2565.Ek Barkod Aktarım'></a></li>
								<li><a href="#request.self#?fuseaction=settings.import_seri_no"><cf_get_lang no='1033.Seri Aktarım'></a></li>
								<li><a href="#request.self#?fuseaction=settings.import_seri_no_local"><cf_get_lang no='1032.Lokal Seriden Seri Aktarım'></a></li>
                                <li><a href="#request.self#?fuseaction=settings.import_seri_no_subscription"><cf_get_lang_main no='1420.abone'> <cf_get_lang no='1033.Seri Aktarım'></a></li>
								<li><a href="#request.self#?fuseaction=settings.import_brand"><cf_get_lang_main no='1435.Marka'> <cf_get_lang no="1548.Aktarım"></a></li>
								<li><a href="#request.self#?fuseaction=settings.import_brand_models"><cf_get_lang_main no='813.Model'> <cf_get_lang no="1548.Aktarım"></a></li>
							</cfif>
							<cfif (is_denied_module eq 1 and get_module_user(35)) or is_denied_module eq 0> 
								<li><a href="#request.self#?fuseaction=settings.form_product_tree_import"><cf_get_lang no='839.Ürün Ağacı Aktarım'></a></li>
								<li><a href="#request.self#?fuseaction=settings.form_add_workstation_import"><cf_get_lang no='2783.İstasyon Aktarım'></a></li>
								<li><a href="#request.self#?fuseaction=settings.form_add_workstations_expense_center_import"><cf_get_lang no='3181.İş İstasyonu Masraf Merkezi Yansıma Oranı Aktarımı'></a></li>
							</cfif>
						</ul>
					</li>
				</ul>
				<!---
				<div class="pagemenus_clear"></div>
				<ul class="pagemenus">
					<li><strong><cf_get_lang_main no='32.İnsan Kaynakları'></strong>
						<ul>
							<cfif (is_denied_module eq 1 and listgetat(session.ep.user_level, 3) and structkeyexists(fusebox.circuits,'hr')) or is_denied_module eq 0> 
								<li><a href="#request.self#?fuseaction=settings.import_employee"><cf_get_lang no='1273.Çalışan Aktarım'></a></li>
								<li><a href="#request.self#?fuseaction=settings.import_employee_relative"><cf_get_lang no='801.Çalışan Yakını Aktarım'></a></li>
								<li><a href="#request.self#?fuseaction=settings.form_transfer_salary"><cf_get_lang no='1544.Çalışan Maaş Aktarımı'></a></li>
								<li><a href="#request.self#?fuseaction=settings.import_employee_banks"><cf_get_lang no='2688.Çalışan Banka Bilgileri Aktarım'></a></li>
								<li><a href="#request.self#?fuseaction=settings.import_sgk_puantaj_add_rows"><cf_get_lang no='37.Çalışan SGK Devir Aktarım'></a></li>
								<li><a href="#request.self#?fuseaction=settings.import_cumulative_tax_total"><cf_get_lang no='39.Kümülatif Vergi Matrahı Aktarım'></a></li>
								<li><a href="#request.self#?fuseaction=settings.import_employee_offdays"><cf_get_lang no='357.Calisan Gecmis Donem Izin Gunu'></a></li>
								<li><a href="#request.self#?fuseaction=settings.cv_import"><cf_get_lang no='1578.Cv Aktarım'></a></li>
								<li><a href="#request.self#?fuseaction=settings.import_positions"><cf_get_lang_main no="1085.Pozisyon"> <cf_get_lang no="1548.Aktarım"></a></li>
								<li><a href="#request.self#?fuseaction=settings.import_employee_position_in"><cf_get_lang no="842.İşe Giriş Aktarım"></a></li>
								<li><a href="#request.self#?fuseaction=settings.import_employee_position_history"><cf_get_lang no="847.Görev Değişikliği Aktarım"></a></li>
								<li><a href="#request.self#?fuseaction=settings.import_employee_edu_info"><cf_get_lang no="850.Çalışan Eğitim Bilgileri Aktarım"></a></li>
								<li><a href="#request.self#?fuseaction=settings.import_employee_business_codes"><cf_get_lang no="851.Çalışan Meslek Kodu Aktarım"></a></li>
							</cfif>
						</ul>
					</li>
				</ul>---><!--- ehesap aktarimlar altina tasindi --->
				<div class="pagemenus_clear"></div>
				<ul class="pagemenus">
					<li><strong><cf_get_lang_main no='28.Eğitim Yönetimi'></strong>
						<ul>
							<cfif (is_denied_module eq 1 and get_module_user(9)) or is_denied_module eq 0> 
								<li><a href="#request.self#?fuseaction=settings.form_add_edu_import"><cf_get_lang no='3178.Eğitim Aktarımı'></a></li>
								<li><a href="#request.self#?fuseaction=settings.form_add_edu_participant_import"><cf_get_lang no='3179.Eğitim Katılımcı Aktarımı'></a></li>
								<li><a href="#request.self#?fuseaction=settings.form_add_employee_orientation_edu_import"><cf_get_lang no='3180.Çalışan Oryantasyon Eğitimi Aktarımı'></a></li>
							</cfif>
						</ul>
					</li>
				</ul>
		   </div>
	   </div>
	</cfoutput>
</cfif>
<script src="../design/SpryAssets/left_menus/jquery.treeview.js" type="text/javascript"></script>
