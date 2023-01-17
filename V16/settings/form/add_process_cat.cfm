<cf_catalystHeader>
<cfscript>
	netbook = createObject("component","V16.e_government.cfc.netbook");
	netbook.dsn = dsn;
	get_account_card_document_types = netbook.getAccountCardDocumentTypes(is_company : 1, is_active : 1);
	get_account_card_payment_types = netbook.getAccountCardPaymentTypes(is_active : 1);
</cfscript>
<cfform name="form_process_cat" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=settings.emptypopup_add_process_cat">
<cf_box>
<cf_box_elements>
	<input type="hidden" name="position_cats" id="position_cats" value="">
	<input type="hidden" name="process_multi_type" id="process_multi_type" value="" />
	<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
		<div class="form-group" id="item-process_cat">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42382.İşlem Kategorisi'>*</label>
			<div class="col col-8 col-xs-12">
				<div class="input-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='58555.kategori girmelisiniz'></cfsavecontent>
					<cfinput maxlength="100" required="Yes" type="text" name="process_cat" message="#message#">
					<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onclick="windowopen('index.cfm?fuseaction=settings.popup_list_process_types&field_id=form_process_cat.process_type_id&field_name=form_process_cat.process_cat&field_module_id=form_process_cat.module_id&detail=form_process_cat.fuse_names&profile_id=form_process_cat.profile_id&invoice_type_code=form_process_cat.invoice_type_code&process_multi_type=form_process_cat.process_multi_type','list');"></span>
				</div>
			</div>
		</div>	
		<div id="ship_type_" style="display:none">
			<div class="form-group" id="item-ship_type">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="29430.İrsaliye Tipi"></label>
				<div id="ship_type2_" style="display:none" class="col col-8 col-xs-12">
					<select name="ship_type" id="ship_type">
						<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
					</select>
				</div>
			</div>
		</div>
	<!--- E-İrsaliye Tipi --->
		<div id="despatch_advice_type_" style="display:none">
			<div class="form-group" id="item-despatch_advice_type">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="60910.E-irsaliye Tipi"></label>
				<div class="col col-8 col-xs-12">
					<select name="despatch_advice_type" id="despatch_advice_type">
						<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
						<option value="1"><cf_get_lang dictionary_id="30098.Satış İrsaliye"></option>
					</select>
				</div>
			</div>
		</div>
		<div id="eshipment_profile_id_" style="display:none"><!--- E-İrsaliye icin eklendi --->
			<div class="form-group" id="item-eshipment_profile_id">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59321.Senaryo"></label>
				<div class="col col-8 col-xs-12">
					<select name="eshipment_profile_id" id="eshipment_profile_id">
						<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
						<option value="TEMELIRSALIYE"><cf_get_lang dictionary_id="60934.Temel İrsaliye"></option>
					</select>
				</div>
			</div>
		</div>
	<!---  --->
		<cfif session.ep.our_company_info.is_efatura eq 1>
			<div id="invoice_type_code_tr"><!--- E Fatura icin eklendi --->
				<div class="form-group" id="item-invoice_type_code">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57288.Fatura Tipi'></label>
					<div class="col col-8 col-xs-12">
						<select name="invoice_type_code" id="invoice_type_code" disabled="disabled">
							<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
							<option value="SATIS"><cf_get_lang dictionary_id="57448.SATIS"></option>
							<option value="IADE"><cf_get_lang dictionary_id="29418.IADE"></option>
						</select>
					</div>
				</div>
			</div>	
			<div id="profile_id_tr"><!--- E Fatura icin eklendi --->
				<div class="form-group" id="item-profile_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59321.Senaryo"></label>
					<div class="col col-8 col-xs-12">
						<select name="profile_id" id="profile_id">
							<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
							<option value="TEMELFATURA"><cf_get_lang dictionary_id="57067.Temel Fatura"></option>
							<option value="TICARIFATURA"><cf_get_lang dictionary_id="59874.Ticari Fatura"></option>
							<option value="IHRACAT"><cf_get_lang dictionary_id="60823.İhracat"></option>
							<option value="YOLCUBERABERFATURA"><cf_get_lang dictionary_id="60824.Yolcu Beraber Fatura"></option>
							<option value="BEDELSIZIHRACAT"><cf_get_lang dictionary_id="60825.Bedelsiz İhracat"></option>
							<option value="KAMU"><cf_get_lang dictionary_id="41536.Kamu Fatura"></option>
						</select>
					</div>
				</div>
			</div>	
		</cfif>
		<div class="form-group" id="item-module_id">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42178.Modül'> <cf_get_lang dictionary_id="58527.ID"></label>
			<div class="col col-8 col-xs-12">
				<input type="text" name="module_id" id="module_id" value="" readonly="yes">
			</div>
		</div>	
		<div class="form-group" id="item-process_type_id">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43246.Process'> <cf_get_lang dictionary_id="58527.ID"></label>
			<div class="col col-8 col-xs-12">
				<input type="text" name="process_type_id" id="process_type_id" value="" readonly="yes">
			</div>
		</div>
		<div class="form-group" id="item-special_code">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'></label>
			<div class="col col-8 col-xs-12">
				<input type="text"  name="special_code" id="special_code" value="">
			</div>
		</div>	
		<div id="tr_document_type" style="display:none">
			<div class="form-group" id="item-document_type">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58533.Belge Tipi'></label>
				<div class="col col-8 col-xs-12">
					<select name="document_type" id="document_type">
                        <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                        <cfoutput query="get_account_card_document_types">
                            <option value="#document_type_id#">#document_type#</option>
                        </cfoutput>
                	</select>
                </div>
			</div>
		</div>	
        <div id="tr_payment_type" style="display:none">
			<div class="form-group" id="item-payment_type">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30057.Ödeme Şekli'></label>
				<div class="col col-8 col-xs-12">
					<select name="payment_type" id="payment_type">
						<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
						<cfoutput query="get_account_card_payment_types">
							<option value="#payment_type_id#">#payment_type#</option>
						</cfoutput>
					</select>
				</div>
			</div>	
		</div>
		<div class="form-group" id="fuse_names">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42142.Fuseaction'></label>
			<div class="col col-8 col-xs-12">
                <textarea name="fuse_names" id="fuse_names"  rows="5"></textarea>
            </div>
		</div>
		<div class="form-group" id="item-display_file_name">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59000.Display File'></label>
			<div class="col col-8 col-xs-12">
				<div class="input-group">
					<input type="file" name="display_file_name" id="display_file_name">
					<input type="text" name="display_file_name_template" id="display_file_name_template" readonly="" style="display:none;" value="">
					<span class="input-group-addon" id="value11" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=process.popup_dsp_template&field_name=form_process_cat.display_file_name_template&field_id=form_process_cat.display_file_name&type=1&process_type=2','list');">
					<i class="fa fa-plus"></i></span>
					<span class="input-group-addon" href="javascript://" id="value12" onclick="del_template_display_file();" style="display:none;">
					<i class="fa fa-minus"></i></span>
				</div>
			</div>
		</div>
		<div class="form-group" id="item-display_file_name">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59001.Action File'></label>
			<div class="col col-8 col-xs-12">
				<div class="input-group">
					<input type="file" name="action_file_name" id="action_file_name">
					<input type="text" name="action_file_name_template" id="action_file_name_template" readonly="" style="display:none;" value="">
					<span class="input-group-addon" id="value21" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=process.popup_dsp_template&field_name=form_process_cat.action_file_name_template&field_id=form_process_cat.action_file_name&type=2&process_type=2','list');">
					<i class="fa fa-plus"></i></span>
					<span class="input-group-addon" href="javascript://" id="value22" onclick="del_template_action_file();" style="display:none;">
					<i class="fa fa-minus"></i></span>
				</div>
			</div>
		</div>
	</div>
	<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
	       	<div id="tr_is_cari">
				<div class="form-group" id="item-is_cari">
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_cari" id="is_cari" value="1"><cf_get_lang dictionary_id='42480.Cari İşlem'></label>
				</div>
			</div>
			<div id="tr_is_account">
				<div class="form-group" id="item-is_account">
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_account" id="is_account" value="1" onchange="document_payment_types()"><cf_get_lang dictionary_id='42491.Muhasebe İşlemi'></label>
				</div>
			</div>
			<div id="tr_is_budget">
				<div id="is_budget_field">
					<div class="form-group" id="item-is_budget">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_budget" id="is_budget" value="1"><cf_get_lang dictionary_id='43233.Bütçe İşlemi Yapılsın'></label>
					</div>
				</div>
			</div>	
			<div id="export_registered" style="display:none;">
				<div class="form-group" id="item-is_export_registered">
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12"> <input type="checkbox" name="is_export_registered" id="is_export_registered" value="1"><cf_get_lang dictionary_id ='60097.İhraç Kayıtlı İşlem (Dahilde İşlem)'></label>
				</div>
			</div>
			<div id="export_product"style="display:none;">
				<div class="form-group" id="item-is_export_product">
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_export_product" id="is_export_product" value="1"><cf_get_lang dictionary_id ='60094.İhraç Kayıtlı İşlem (Nihai Ürün)'></label>
				</div>
			</div>
			<div id="allowance_deduction" style="display:none;">
				<div class="form-group" id="item-is_allowance_deduction">
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_allowance_deduction" id="is_allowance_deduction" value="1"><cf_get_lang dictionary_id ='60864.ödenek işlemi yapılsın'></label>
				</div>
				<div class="form-group" id="item-is_allowance_deduction">
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_deduction" id="is_deduction" value="1"><cf_get_lang dictionary_id ='60895.Kesinti işlemi yapılsın'></label>
				</div>
			</div>
			<div id="sales_cost" style="display:none">
				<div class="form-group" id="item-is_account">
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_cost" id="is_cost" value="1"><cf_get_lang dictionary_id='43234.Maliyet İşlemi Yapılsın'></label>
				</div>	
			</div>
			<div id="stock" style="display:none">
				<div class="form-group" id="item-is_stock_action">
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_stock_action" id="is_stock_action" value="1"><cf_get_lang dictionary_id='43235.Stok Hareketi Yapılsın'></label>
				</div>
			</div>
			<div id="zero_stock" style="display:none">
				<div class="form-group" id="item-is_zero_stock_action">
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_zero_stock_action" id="is_zero_stock_action" value="1"><cf_get_lang dictionary_id ='43880.Sıfır Stok Kontrolu Yapılsın'></label>
				</div>
			</div>
			<div class="form-group" id="item-is_default">
				<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_default" id="is_default" value="1"><cf_get_lang dictionary_id='43115.Standart Seçenek Olarak Gelsin'>(Default)</label>
			</div>
			<div id="discount" style="display:none">
				<div class="form-group" id="item-is_discount">
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_discount" id="is_discount" value="1"><cf_get_lang dictionary_id='43236.Muhasebe İşlemlerinde İskontolar Alınmasın'></label>
				</div>
			</div>
			<div id="account_prod_cost" style="display:none">
				<div class="form-group" id="item-is_prod_cost_acc_action">
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_prod_cost_acc_action" id="is_prod_cost_acc_action" value="1"><cf_get_lang dictionary_id='60826.Satılan Malın Maliyeti Muhasebe Hareketi Yapılsın'></label>
				</div>
			</div>
			<div id="tr_is_project_based_acc">
				<div class="form-group" id="item-is_project_based_acc">
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_project_based_acc" id="is_project_based_acc" onclick="change_based_acc(1);" value="1"><cf_get_lang dictionary_id='43237.Proje Bazlı Muhasebeleştirme Yapılsın'></label>
				</div>
			</div>
			<div id="_is_dept_based_acc_" style="display:none;">
				<div class="form-group" id="item-is_dept_based_acc">
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_dept_based_acc" id="is_dept_based_acc" value="1"><cf_get_lang dictionary_id='60827.Depo Bazlı Muhasebeleştirme Yapılsın'></label>
				</div>	
			</div>
			<div id="is_project_based_budget_field">
				<div class="form-group" id="item-is_project_based_budget">
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_project_based_budget" id="is_project_based_budget" value="1"><cf_get_lang dictionary_id='43238.Proje Bazlı Bütçe İşlemi Yapılsın'></label>
				</div>	
			</div>
			<div id="tr_is_account_group">
				<div id=" _is_account_group">
					<div class="form-group" id="item-is_account_group">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_account_group" id="is_account_group" value="1"><cf_get_lang dictionary_id='43239.Hesap Bazında Grupla'></label>
					</div>
				</div>
			</div>
			<div class="form-group" id="item-is_partner">
				<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_partner" id="is_partner" value="1"><cf_get_lang dictionary_id='43240.Partner da Kullanılsın'></label>
			</div>
			<div class="form-group" id="item-is_public">
				<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_public" id="is_public" value="1"><cf_get_lang dictionary_id='43241.Public de Kullanılsın'></label>
			</div>
			<div id="cheque" style="display:none">
				<div class="form-group" id="item-is_cheque_based_action">
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_cheque_based_action" id="is_cheque_based_action" value="1"><cf_get_lang dictionary_id ='43882.Çek Bazında Cari ve Muhasebe İşlemi Yapılsın'></label>
				</div>	
			</div>
			<div id="cheque_voucher" style="display:none">
				<div class="form-group" id="item-is_cheque_based_acc_action">
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_cheque_based_acc_action" id="is_cheque_based_acc_action" value="1"><cf_get_lang dictionary_id ='43544.Çek ve Senet Bazında Muhasebe İşlemi Yapılsın'></label>
				</div>	
			</div>
			<div id="cheque1" style="display:none">
				<div class="form-group" id="item-is_upd_cari_row">
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_upd_cari_row" id="is_upd_cari_row" value="1"><cf_get_lang dictionary_id ='43879.Tahsilat Değeri Extreyi Günceller'></label>
				</div>	
			</div>
			<div id="_is_due_date_based_cari_" style="display:none">
				<div class="form-group" id="item-is_due_date_based_cari">
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_due_date_based_cari" id="is_due_date_based_cari" onclick="change_based_cari(1);" value="1"><cf_get_lang dictionary_id ='43881.Vade ve Döviz Bazında Cari İşlem Yapılsın'></label>
				</div>
			</div>
			<div id="_is_paymethod_based_cari_" style="display:none">
				<div class="form-group" id="item-is_paymethod_based_cari">
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_paymethod_based_cari" id="is_paymethod_based_cari" onclick="change_based_cari(2);" value="1"><cf_get_lang dictionary_id='43430.Ödeme Yöntemi Bazında Cari İşlem Yapılsın'></label>
				</div>	
			</div>
			<div id="_is_row_project_based_cari_" style="display:none">
				<div class="form-group" id="item-is_row_project_based_cari">
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_row_project_based_cari" id="is_row_project_based_cari" onclick="change_based_cari(3);" value="1"><cf_get_lang dictionary_id='60833.Satırdaki Proje Bazında Cari İşlem Yapılsın'></label>
				</div>
			</div>
			<div id="_is_exp_based_acc_" style="display:none">
				<div class="form-group" id="item-is_exp_based_acc">
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_exp_based_acc" id="is_exp_based_acc" onclick="change_based_acc(2);" value="1"><cf_get_lang dictionary_id='43442.Hizmet Kalemiyle Muhasebeleştir'></label>
				</div>	
			</div>
			<div id="_is_add_inventory_" style="display:none">
				<div class="form-group" id="item-is_add_inventory">
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_add_inventory" id="is_add_inventory" value="1"><cf_get_lang dictionary_id='60834.Demirbaş Stok Fişi Kaydı Yapılsın'></label>
				</div>	
			</div>
			<div id="_is_process_currency_" style="display:none">
				<div class="form-group" id="item-is_process_currency">
					<div class="col col-1 col-xs-1">
						<input type="checkbox" name="is_process_currency" id="is_process_currency" value="1">
					</div>
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='60835.İşlem Dövizi Kurlarından Hesap Yapılmasın'></label>
				</div>
			</div>
			<div id="_is_lot_no" style="display:none">
				<div class="form-group" id="item-is_lot_no">
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_lot_no" id="is_lot_no" value="1"><cf_get_lang dictionary_id='43045.Lot No Kullanılsın'></label>
				</div>	
			</div>
			<div id="_is_visible_tevkifat" style="display:none">
				<div class="form-group" id="item-is_vis_tevkifat">
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12"> <input type="checkbox" name="is_visible_tevkifat" id="is_visible_tevkifat" value="1"><cf_get_lang dictionary_id='62832.İade Faturalarında Tevkifat Muhasebeleşmesin'></label>
				</div>
			</div>
			<div id="_is_expensing_tax" style="display:none;">
				<div class="form-group" id="item-is_expensing_tax">
					<label class="col col-10 col-xs-11"><input type="checkbox" name="is_expensing_tax" id="is_expensing_tax" value="1"><cf_get_lang dictionary_id="56183.KDV'yi giderleştir"></label>
				</div>
			</div>
			<div id="_is_expensing_oiv" style="display:none;">
				<div class="form-group" id="item-is_expensing_oiv">
					<label class="col col-10 col-xs-11"><input type="checkbox" name="is_expensing_oiv" id="is_expensing_oiv" value="1"><cf_get_lang dictionary_id="61094.öiv'yi giderleştir"></label>
				</div>
			</div>
			<div id="_is_expensing_otv" style="display:none;">
				<div class="form-group" id="item-is_expensing_otv">
					<label class="col col-10 col-xs-11"><input type="checkbox" name="is_expensing_otv" id="is_expensing_otv" value="1"><cf_get_lang dictionary_id="61095.ötv'yi giderleştir"></label>
				</div>
			</div>
			<div id="next_periods_accrual_action">
                <div class="form-group" id="item-next_periods_accrual_action">
					<label class="col col-10 col-xs-11"><input type="checkbox" name="next_periods_accrual_action" id="next_periods_accrual_action" value="1"><cf_get_lang dictionary_id='60836.Gelecek Ay ve Yıllara Ait İşlemleri Tahakkuklaştır'></label>
                </div>
            </div>
            <div id="accrual_budget_action">
                <div class="form-group" id="item-accrual_budget_action">
                    <label class="col col-10 col-xs-11"><input type="checkbox" name="accrual_budget_action" id="accrual_budget_action" value="1"><cf_get_lang dictionary_id='60840.Tahakkuk İşlemine Göre Bütçe Planı Kaydı At'></label>
                </div>
			</div>
			<div id="budget_reserved_control" style="display:none">
                <div class="form-group" id="item-budget_reserved_control">
                    <label class="col col-10 col-xs-11"><input type="checkbox" name="budget_reserved_control" id="budget_reserved_control" value="1"><cf_get_lang dictionary_id='60843.Bütçe Rezerve İşlemi Yap'></label>
                </div>
            </div>
			<div id="_is_expensing_bsmv" style="display:none">
				<div class="form-group" id="item-is_expensing_bsmv">
					<label class="col col-10 col-xs-11"><input type="checkbox" name="is_expensing_bsmv" id="is_expensing_bsmv" value="1"><cf_get_lang dictionary_id="60845.BSMV'yi giderleştir"></label>
				</div>
			</div>
			<div id="_is_inventory_valuation" style="display:none">
				<div class="form-group" id="item-is_inventory_valuation">
					<label class="col col-10 col-xs-11"><input type="checkbox" name="is_inventory_valuation" id="is_inventory_valuation" value="1"><cf_get_lang dictionary_id='56413.Değer Artışı Yaratan İşlem'></label>
				</div>
			</div>
			<div class="form-group" id="item-is_all_users">
				<label class="col col-10 col-xs-11"><input type="checkbox" name="is_all_users" id="is_all_users" value="1"><cf_get_lang dictionary_id='59523.Tüm Kullanıcılar'></label>
			</div>
	</div>
	<div class="col col-4 col-md-4 col-sm-6 col-xs-12" index="3">
            <cf_flat_list>
                <thead>
					<tr>
						<th width="20">
							<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_position_cats_multiuser&table_row_name=table_row_pcat&field_form_name=form_process_cat&field_poscat_id=position_cats&field_td=td_yetkili2&table_name=pos_cats&row_count=row_count_positon_cat&function_row_name=sil_process_cat</cfoutput>','list');">
							<i class="fa fa-plus"></i></a>
						</th>
						<th>
							<cf_get_lang dictionary_id = '43395.Yetkili Pozisyon Kategorileri' >
						</th>
					</tr>
				</thead>
				<tbody id="pos_cats" name="pos_cats">
					<tr id="table_row_pcat0" name="table_row_pcat0">
						<input type="hidden" name="row_count_positon_cat" id="row_count_positon_cat" value="0">
						<td></td>
						<td></td>
					</tr>
				</tbody>
            </cf_flat_list>
            <cfsavecontent variable="txt_2"><cf_get_lang dictionary_id='42683.Yetkili Pozisyonlar'></cfsavecontent>
			<cf_workcube_to_cc is_update="0" to_dsp_name="#txt_2#" form_name="form_process_cat" str_list_param="1" data_type="1">    
	</div>
</cf_box_elements>
	<div class="ui-form-list-btn">
		<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
	</div>
</cf_box>
</cfform>
<script type="text/javascript">
	$(function(){
        
        $('#is_export_registered').change(function(){
            $('#is_export_product').prop("checked", false);
        });
        $('#is_export_product').change(function(){
            $('#is_export_registered').prop("checked", false);
        });
    })
	function document_payment_types()
	{
		if(document.getElementById('is_account').checked == true && !(list_find('160,11,12,13',document.form_process_cat.process_type_id.value)))
		{
			document.getElementById('tr_document_type').style.display = '';
			document.getElementById('tr_payment_type').style.display = '';
		}
		else
		{
			document.getElementById('tr_document_type').style.display = 'none';
			document.getElementById('tr_document_type').value = '';
			document.getElementById('tr_payment_type').style.display = 'none';
			document.getElementById('tr_payment_type').value = '';
		}
	}
	function sil_process_cat(param_sil)
	{
		var my_element = eval("document.all.table_row_pcat" + param_sil);
		my_element.disabled=true;
		try{
		my_element.innerHTML = '';//Chrome'da sorun cikartiyordu diye ekledim. Silinen öge tekrar yükleniyordu.
		}catch(e){}
		my_element.style.display = "none";
	}
	function kontrol()
	{

		if (form_process_cat.process_type_id.value =="")
		{
			alert("<cf_get_lang no='1259.İşlem Kategorisi Seçiniz'>");
			return false;
		}
		/* ilgili fatura tiplerinde irsaliye tipi secme zorunlulugu */
		if (list_find("62,52,53,690,592,531,591,532,64,59,54,55",document.form_process_cat.process_type_id.value) && document.getElementById('ship_type') != undefined && document.getElementById('ship_type').value == "")
		{
			alert("İrsaliye Tipi Seçiniz!");
			return false;
		}

		var obj =  document.form_process_cat.action_file_name.value;
		var obj_template =  document.form_process_cat.action_file_name_template.value;
		extention = list_getat(obj,list_len(obj,'.'),'.');
		extention_template = list_getat(obj_template,list_len(obj_template,'.'),'.');
		if((obj != '' && extention != 'cfm') || (obj_template != '' && extention_template != 'cfm'))
		{
			alert("<cf_get_lang no ='1905.Lütfen Action File İçin cfm Dosyası Seçiniz '>!");
			return false;
		}

		var obj2 =  document.form_process_cat.display_file_name.value;
		var obj2_template =  document.form_process_cat.display_file_name_template.value;
		extention2 = list_getat(obj2,list_len(obj2,'.'),'.');
		extention2_template = list_getat(obj2_template,list_len(obj2_template,'.'),'.');
		if((obj2 != '' && extention2 != 'cfm') || (obj2_template != '' && extention2_template != 'cfm'))
		{
			alert("<cf_get_lang no ='2588.Lütfen Display File İçin cfm Dosyası Seçiniz '>!");
			return false;
		}
		if(document.form_process_cat.is_upd_cari_row != undefined && document.form_process_cat.is_upd_cari_row.checked == true && document.form_process_cat.is_cheque_based_action.checked == false)
		{
			alert("Tahsilat Değeri Ekstreyi Günceller Seçeneğini Seçmek İçin Çek ve Senet Bazında Cari İşlem Yapılsın Seçeneği Seçili Olmalıdır ! ");
			return false;
		}

		if(document.form_process_cat.is_default!=undefined && document.form_process_cat.is_default.checked==true)
		{
			var listParam = document.form_process_cat.module_id.value + "*" + document.form_process_cat.process_type_id.value;
			if(list_find("51,54,55,59,60,61,63,591",document.form_process_cat.process_type_id.value))// versiyondan tekrar ekledim bu satırı py
				str_default_sql= 'set_get_default_process';
			else if(list_find("50,52,53,56,57,58,62,531",document.form_process_cat.process_type_id.value))
				str_default_sql= 'set_get_default_process_2';
			else if(list_find("73,74,75,76,77",document.form_process_cat.process_type_id.value))
				str_default_sql= 'set_get_default_process_3';
			else if(list_find("70,71,72,78,79",document.form_process_cat.process_type_id.value))
				str_default_sql= 'set_get_default_process_4';
			else if(list_find("140,141",document.form_process_cat.process_type_id.value))
				str_default_sql= 'set_get_default_process_5';
			else
				str_default_sql= 'set_get_default_process_6';
			var get_default_process_ = wrk_safe_query(str_default_sql,'dsn3',0,listParam);
			if(get_default_process_.recordcount)
				if(confirm("Aynı Process Tipli ' " +get_default_process_.PROCESS_CAT+ "' İşlem Kategorisi Default Seçenek Olarak Tanımlanmış.\n Default Seçenek Değiştirilecektir, Değişikliği Kaydetmek İstiyor musunuz?")); else return false;
		}
		<cfif session.ep.our_company_info.is_efatura>
			if(document.getElementById('invoice_type_code').value != '' && document.getElementById('profile_id').value == '')
			{
				alert('Senaryo Seçiniz !');
				return false;
			}
		</cfif>

		document.getElementById('invoice_type_code').disabled = false;

		return true;
	}

	function del_template_action_file()
	{
		form_process_cat.action_file_name.style.display='';
		form_process_cat.action_file_name_template.style.display='none';
		form_process_cat.action_file_name_template.value='';
		value21.style.display='';
		value22.style.display='none';
	}
	function del_template_display_file()
	{
		form_process_cat.display_file_name.style.display='';
		form_process_cat.display_file_name_template.style.display='none';
		form_process_cat.display_file_name_template.value='';
		value11.style.display='';
		value12.style.display='none';
	}
	function change_based_cari(type_info)
	{
		if(type_info == 1)
		{
			document.getElementById('is_paymethod_based_cari').checked = false;
			document.getElementById('is_row_project_based_cari').checked = false;
		}
		else if(type_info == 2)
		{
			document.getElementById('is_due_date_based_cari').checked = false;
			document.getElementById('is_row_project_based_cari').checked = false;
		}
		else
		{
			document.getElementById('is_due_date_based_cari').checked = false;
			document.getElementById('is_paymethod_based_cari').checked = false;
		}
	}
	function change_based_acc(type_info)
	{
		if(type_info == 1)
		{
			if(document.getElementById('is_exp_based_acc') != undefined)
				document.getElementById('is_exp_based_acc').checked = false;
		}
		else if(type_info == 2)
		{
			if(document.getElementById('is_project_based_acc') != undefined)
				document.getElementById('is_project_based_acc').checked = false;
		}
	}
	function addOption(value,text)
	{
		var selectBox = document.getElementById('ship_type');
		if(selectBox.options.length != 1)
			selectBox.options[0]=new Option('<cf_get_lang_main no="322.Seçiniz">','',false,true);
		selectBox.options[selectBox.options.length] = new Option(value,text);
	}
</script>
