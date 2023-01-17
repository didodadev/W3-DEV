<cf_get_lang_set module_name="settings"><!--- sayfanin en altinda kapanisi var --->

	<cfoutput>
		<div class="params_content">
			<div class="col col-3 col-md-4 col-sm-6 col-xs-12 params_item">
				<ul class="params_list">
					<div class="params_list_title color-SI"><cf_get_lang dictionary_id='29673.Aktarimlar'></div> 
					<span><i class="fa fa-angle-down"></i><cf_get_lang dictionary_id='57444.İnsan Kaynakları'></span>
				
						<ul>
							<cfif get_module_user(48) and (get_module_user(3))>
								<li><a href="#request.self#?fuseaction=ehesap.import_employee">-<cf_get_lang dictionary_id='43256.Çalışan Aktarım'></a></li>
								<li><a href="#request.self#?fuseaction=ehesap.import_employee_relative">-<cf_get_lang dictionary_id='42784.Çalışan Yakını Aktarım'></a></li>
								<li><a href="#request.self#?fuseaction=ehesap.form_transfer_salary">-<cf_get_lang dictionary_id='43527.Çalışan Maaş Aktarımı'></a></li>
								<li><a href="#request.self#?fuseaction=ehesap.import_employee_banks">-<cf_get_lang dictionary_id='44671.Çalışan Banka Bilgileri Aktarım'></a></li>
								<li><a href="#request.self#?fuseaction=ehesap.import_sgk_puantaj_add_rows">-<cf_get_lang dictionary_id='42020.Çalışan SGK Devir Aktarım'></a></li>
								<li><a href="#request.self#?fuseaction=ehesap.import_cumulative_tax_total">-<cf_get_lang dictionary_id='42022.Kümülatif Vergi Matrahı Aktarım'></a></li>
								<li><a href="#request.self#?fuseaction=ehesap.import_employee_offdays">-<cf_get_lang dictionary_id='42340.Calisan Gecmis Donem Izin Gunu'></a></li>
								<li><a href="#request.self#?fuseaction=ehesap.cv_import">-<cf_get_lang dictionary_id='43561.Cv Aktarım'></a></li>
								<li><a href="#request.self#?fuseaction=ehesap.import_positions">-<cf_get_lang dictionary_id="58497.Pozisyon"> <cf_get_lang dictionary_id="43531.Aktarım"></a></li>
								<li><a href="#request.self#?fuseaction=ehesap.import_employee_position_in">-<cf_get_lang dictionary_id="42825.İşe Giriş Aktarım"></a></li>
								<li><a href="#request.self#?fuseaction=ehesap.import_employee_position_history">-<cf_get_lang dictionary_id="42830.Görev Değişikliği Aktarım"></a></li>
								<li><a href="#request.self#?fuseaction=ehesap.import_employee_edu_info">-<cf_get_lang dictionary_id="42833.Çalışan Eğitim Bilgileri Aktarım"></a></li>
								<li><a href="#request.self#?fuseaction=ehesap.import_employee_business_codes">-<cf_get_lang dictionary_id="42834.Çalışan Meslek Kodu Aktarım"></a></li>
								<li><a href="#request.self#?fuseaction=ehesap.import_employee_contact_person">-<cf_get_lang dictionary_id="45474.Bağlantı Kurulacak Kişi Aktarım"></a></li>
								<li><a href="#request.self#?fuseaction=ehesap.import_standby">-<cf_get_lang dictionary_id="45472.Çalışan Amirleri Aktarım"></a></li>
								<li><a href="#request.self#?fuseaction=ehesap.form_transfer_salary_scale">-<cf_get_lang dictionary_id="51195.Temel ücret skalası import"></a></li>
								<li><a href="#request.self#?fuseaction=ehesap.import_monthly_average_net">-<cf_get_lang dictionary_id="61253.Aylık Ortalama Net Aktarım"></a></li>
							</cfif>
						</ul>
				</ul>
			</div>
		</div>
	</cfoutput>
	<script src="../design/SpryAssets/left_menus/jquery.treeview.js" type="text/javascript"></script>
	<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
	