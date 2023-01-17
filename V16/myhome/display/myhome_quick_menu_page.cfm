<script type="text/javascript" src="/JS/widget/domdrag.js"></script>
<script type="text/javascript" src="/JS/widget/homebox.js"></script>
<cfoutput>
<table width="98%" height="98%" border="0" cellspacing="3" cellpadding="3" align="center">
	<tr height="25" class="color-list">
        <td width="25%" height="50" class="formbold" valign="middle">
            <table border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td><img src="/images/source_manage.gif"></td>
                    <td class="formbold"><cf_get_lang dictionary_id='30877.Kaynak Yönetimi'></td>
                </tr>
            </table>
        </td>
        <td width="25%" class="formbold">
            <table border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td><img src="/images/operation_manage.gif"></td>
                    <td class="formbold"><cf_get_lang dictionary_id='32261.Operasyonel Yönetim'></td>
                </tr>
            </table>
        </td>
        <td width="25%" class="formbold">
            <table border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td><img src="/images/collabration_manage.gif"></td>
                    <td class="formbold">&nbsp;&nbsp;<cf_get_lang dictionary_id='32262.İşbirliği ve İletişim'></td>
                </tr>
            </table>
        </td>
        <td width="25%" class="formbold">
            <table border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td><img src="/images/analitic_manage.gif"></td>
                    <td class="formbold">&nbsp;&nbsp;<cf_get_lang dictionary_id='32263.Analitik Rapor'></td>
                </tr>
            </table>
        </td>
	</tr>
	<tr bgcolor="FFFFFF">
		<td valign="top" width="25%" style="overflow:auto;">
            <div id="musteri" style="width:100%;height:99%; z-index:88;overflow:auto;">
            <cfif get_module_user(3)>
                <b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(insan_kaynak);"><cf_get_lang dictionary_id='57444.İnsan Kaynakları'></a></b><br/>
                <span id="insan_kaynak" style="display:none;">
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=hr.welcome"><cf_get_lang dictionary_id='29661.HR'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.list_puantaj"><cf_get_lang dictionary_id='57654.E-Hesap'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=hr.list_hr"><cf_get_lang dictionary_id='57990.E-Profil'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=hr.list_positions"><cf_get_lang dictionary_id='58123.Planlama'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=hr.apps"><cf_get_lang dictionary_id='57996.İşe Alma'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=hr.list_total_performances"><cf_get_lang dictionary_id='58003.Performans'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=hr.organization_schema"><cf_get_lang dictionary_id='57972.Organizasyon'></a><br/>
                </span>
            </cfif>
            
            <cfif get_module_user(48)>
                <b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(ehesap1);"><cf_get_lang dictionary_id='57654.E-Hesap'></a></b><br/>
                <span id="ehesap1" style="display:none;">
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.list_fire"><cf_get_lang dictionary_id='32153.Giriş-Çıkış'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.offtimes"><cf_get_lang dictionary_id='30820.İzinler'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.form_add_offtime_popup','medium');"><cf_get_lang dictionary_id='32156.İzin Talebi Ekle'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.list_visited_relative"><cf_get_lang dictionary_id='31535.Çalışan Yakınına Vizite'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_ssk_fee_relative','medium');"><cf_get_lang dictionary_id='32157.Çalışan Yakını İçin Vizite Kağıdı'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.list_emp_rel_healty"><cf_get_lang dictionary_id='32158.Sağlık Belgesi'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_ssk_healty','small');"><cf_get_lang dictionary_id='32159.Sağlık Belgesi Ekle'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.list_visited"><cf_get_lang dictionary_id='32160.Çalışana Vizite'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.list_caution"><cf_get_lang dictionary_id='32161.Disiplin İşlemleri'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_add_caution','medium');"><cf_get_lang dictionary_id='32162.Disiplin İşlemi Ekle'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.list_prizes"><cf_get_lang dictionary_id='31013.Ödüller'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_add_prize','list');"><cf_get_lang dictionary_id='32163.Ödül Ekle'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_add_event','list');"><cf_get_lang dictionary_id='32164.Olay Tutanağı Ekle'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.list_inventory_zimmet"><cf_get_lang dictionary_id='32165.Zimmetler'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_add_inventory_zimmet','list');"><cf_get_lang dictionary_id='32166.Demirbaş Zimmet Formu'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.list_employee_healty_all"><cf_get_lang dictionary_id='32167.Sağlık İşlemleri'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_add_employee_healty','medium');"><cf_get_lang dictionary_id='32168.İşçi Sağlığı'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.list_audits"><cf_get_lang dictionary_id='32169.Denetim İşlemleri'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_add_audit','medium');"><cf_get_lang dictionary_id='32170.Denetim Ekle'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_templates&module=3&assetcat_id=8','list');"><cf_get_lang dictionary_id='32171.Ek Formlar'></a><br/>                </span>
            </cfif>
            
            <cfif get_module_user(48)>
            	<b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(ehesap_tanim);"><cf_get_lang dictionary_id='32172.E-Hesap Tanımları'></a></b><br/>
               	<span id="ehesap_tanim" style="display:none;">
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.personal_payment"><cf_get_lang dictionary_id='32173.Personel Ücret Bilgileri'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_form_add_insurance_payments','small');"><cf_get_lang dictionary_id='32174.Sigorta Primine Esas Ücret Ekle'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_form_add_insurance_ratio','medium');"><cf_get_lang dictionary_id='53057.Sigorta Primi Oranı Ekle'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_form_add_tax_slice','medium');"><cf_get_lang dictionary_id='32176.Vergi Dilimi Ekle'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.list_program_parameters"><cf_get_lang dictionary_id='32177.Akış Parametreleri'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.form_upd_ozel_gider_ind"><cf_get_lang dictionary_id='32178.Özel Gider İndirim Parametreleri'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.shift"><cf_get_lang dictionary_id='32180.Vardiyalar'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_form_add_shift','small');"><cf_get_lang dictionary_id='32181.Vardiya Ekle'></a><br/>
					<img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.list_offtime_limit"><cf_get_lang dictionary_id='32182.İzin Süreleri'></a><br/>
					<img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.list_payroll_accounts"><cf_get_lang dictionary_id='32183.Muhasebe Hesapları'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.list_expense_item"><cf_get_lang dictionary_id='32184.Gider Kalemleri'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.list_expense_item&event=add','small');"><cf_get_lang dictionary_id='31062.Gider Kalemi Ekle'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.list_caution_type"><cf_get_lang dictionary_id='32185.Disiplin Cezası Tipleri'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_add_caution_type','small');"><cf_get_lang dictionary_id='32186.İhtar Tipi Ekle'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.list_salary_money"><cf_get_lang dictionary_id='32187.Döviz Karşılıkları'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.list_salary_money&event=add','small');"><cf_get_lang dictionary_id='32188.Döviz Karşılığı Ekle'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.list_odenek"><cf_get_lang dictionary_id='32189.Ek Ödenek'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.list_odenek&event=add','small');"><cf_get_lang dictionary_id='32190.Ödenek Ekle'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.list_kesinti"><cf_get_lang dictionary_id='32191.Kesinti'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.list_kesinti&event=add','small');"><cf_get_lang dictionary_id='32192.Kesinti Ekle'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.list_prize_type"><cf_get_lang dictionary_id='32193.Ödül Tipleri'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_add_prize_type','small');"><cf_get_lang dictionary_id='32194.Ödül Tipi Ekle'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.list_tax_exception"><cf_get_lang dictionary_id='32195.Vergi İstisnaları'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_add_tax_exception','small');"><cf_get_lang dictionary_id='32196.Vergi İstisnası Ekle'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.form_add_work_accident_type"><cf_get_lang dictionary_id='32197.İş Kazası Çeşitleri'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.form_add_accident_security"><cf_get_lang dictionary_id='32198.İş Kazası İhlal Edilen Güvenlik Maddesi'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_clear_kumulatif','list');"><cf_get_lang dictionary_id='32199.Kümülatifleri Sıfırla'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.hours"><cf_get_lang dictionary_id='32200.Şirket SSK Çalışma Saatleri'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_add_our_comp_hours','medium');"><cf_get_lang dictionary_id='32201.SSK İşyeri Çalışma Saati Ekleme'></a><br/>
              	</span>
            </cfif>
            
            <cfif get_module_user(48)>
              	<b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(ehesap_bordro);"><cf_get_lang dictionary_id='32319.E-Hesap/Bordro'></a></b><br/>
                <span id="ehesap_bordro" style="display:none;">
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.list_bordro"><cf_get_lang dictionary_id='32115.Yatay Bordro'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.list_ozel_bordro"><cf_get_lang dictionary_id='32116.Özel Bordro'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.list_ozet_bordro"><cf_get_lang dictionary_id='32117.Şube Özel Özet Bordro'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.list_ozet_bordro_personal"><cf_get_lang dictionary_id='32118.Kişi Özel Özet Bordro'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.list_icmal_all"><cf_get_lang dictionary_id='32119.Genel İcmal'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.list_ozel_gider_ind_bordro"><cf_get_lang dictionary_id='32120.Özel Gider İndirim Bordrosu'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.list_icmal"><cf_get_lang dictionary_id='32121.Şube İcmal'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.list_icmal_dept"><cf_get_lang dictionary_id='32122.Departman İcmal'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.list_icmal_personal"><cf_get_lang dictionary_id='32123.Kişi İcmal'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.personel_extre"><cf_get_lang dictionary_id='32124.Muhasebe Ekstresi'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.price_compass"><cf_get_lang dictionary_id='32126.Ücret Pusulası'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.list_payments"><cf_get_lang dictionary_id='32127.Ödenek Listesi'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.list_interruption"><cf_get_lang dictionary_id='32128.Kesinti Listesi'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.list_tax_except"><cf_get_lang dictionary_id='32129.Vergi İstisnaları Listesi'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.list_bank_payment_emps"><cf_get_lang dictionary_id='32130.Banka Ödeme Emirleri'></a><br/>
                </span>
            </cfif>
            
            <cfif get_module_user(48)>
                <b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(ehesap_bildirim);"><cf_get_lang dictionary_id='32318.E-Hesap/Bildirimler'></a></b><br/>
                <span id="ehesap_bildirim" style="display:none;">
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.list_ssk_xml_export"><cf_get_lang dictionary_id='32103.SSK Aylık E-Bildirge'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_form_export_ssk_xml','medium');"><cf_get_lang dictionary_id='32104.SSK E-Bildirge XML Dosyası Oluşturma'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_ssk_month_premium','list');"><cf_get_lang dictionary_id='32105.SSK Aylık Bildirgesi'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_ssk_4month','list');"><cf_get_lang dictionary_id='32106.SSK Bordro 4 Aylık'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.ssk_eva','list');"><cf_get_lang dictionary_id='32107.SSK Bilgi Formu'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.ssk_worker_notify','list');"><cf_get_lang dictionary_id='32108.İşçi Bildirim Listesi'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.ssk_worker_out','list');"><cf_get_lang dictionary_id='32109.İşçi Çıkış Listesi'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.form_upd_personel','list');"><cf_get_lang dictionary_id='32110.Personel Durum Çizelgesi'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_print_iskur_shop','list');"><cf_get_lang dictionary_id='32111.İşyeri Bildirgesi'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_ssk_manager','list');"><cf_get_lang dictionary_id='32113.SSK Yetkili Bildirgesi'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.ssk_worker_notify','project');"><cf_get_lang dictionary_id='32114.Çalışma İşyeri Bildirgesi'></a><br/>
                </span>
            </cfif>
            
            <cfif get_module_user(48)>
                 <b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(ehesap_puantaj);"><cf_get_lang dictionary_id='32317.E-Hesap/Puantaj'></a></b><br/>
                 <span id="ehesap_puantaj" style="display:none;">
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.list_salary"><cf_get_lang dictionary_id='56118.Ücret Ödenek'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.list_puantaj"><cf_get_lang dictionary_id='58650.Puantaj'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.list_ext_worktimes"><cf_get_lang dictionary_id='31547.Fazla Mesailer'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_form_add_ext_worktime','small');"><cf_get_lang dictionary_id='32222.Çalışan Fazla Mesai Süresi Ekle'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.shift"><cf_get_lang dictionary_id='32180.Vardiyalar'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.list_payment_requests"><cf_get_lang dictionary_id='32227.Avans Talepleri'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_add_payment_request','list');"><cf_get_lang dictionary_id='30827.Avans Talebi Ekle'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ehesap.list_setup_salary"><cf_get_lang dictionary_id='52966.Toplu Ücret Ayarlama'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_form_add_setup_salary','medium');"><cf_get_lang dictionary_id='32225.Toplu Maaş Ayarlaması'></a><br/>
                 </span>
            </cfif>
            
            <cfif get_module_user(3)>
           		<b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(planlama);"><cf_get_lang dictionary_id='58123.Planlama'></a></b><br/>
              	<span id="planlama" style="display:none;">
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=hr.list_positions"><cf_get_lang dictionary_id='31358.Pozisyonlar'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=hr.list_positions&event=add"><cf_get_lang dictionary_id='32228.Pozisyon Ekle'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=hr.form_add_position_cat"><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=hr.list_position_names"><cf_get_lang dictionary_id='32229.Pozisyon Adları'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_add_position_name','small');"><cf_get_lang dictionary_id='32230.Pozisyon İsmi Ekle'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_form_transfer','small');"><cf_get_lang dictionary_id='30962.Pozisyon Görevi Aktar'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=hr.list_standby"><cf_get_lang dictionary_id='32231.Yedekler ve Amirler'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=hr.form_add_standby"><cf_get_lang dictionary_id='32239.Yedek ve Amir Seçimi'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=hr.add_title"><cf_get_lang dictionary_id='32232.Ünvanlar'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=hr.list_contents"><cf_get_lang dictionary_id='31014.Yetki ve Sorumluluklar'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=hr.form_add_content"><cf_get_lang dictionary_id='32233.Yetki ve Sorumluluk Ekle'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=hr.list_norm_positions"><cf_get_lang dictionary_id='32234.Norm Kadrolar'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=hr.list_norm_staff_minus"><cf_get_lang dictionary_id='32235.Norm Kadro Eksikleri'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=hr.list_position_req_type"><cf_get_lang dictionary_id='32236.Yeterlilik Tanımları'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_add_pos_req_type','small');"><cf_get_lang dictionary_id='32237.Yeterlilik Ekle'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=hr.list_requirement_types"><cf_get_lang dictionary_id='32238.Yeterliliklere Uygun Çalışanlar'></a><br/>
             	</span>
            </cfif>
            
            <cfif get_module_user(3)>
              	<b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(performans);"><cf_get_lang dictionary_id='58003.Performans'></a></b><br/>
                <span id="performans" style="display:none;">
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=hr.list_perform"><cf_get_lang dictionary_id='31340.Ölçme-Değerlendirme'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=hr.form_add_perf_emp_info"><cf_get_lang dictionary_id='31093.Ölçme-Değerlendirme Formları'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=hr.list_out_employees"><cf_get_lang dictionary_id='30922.Mülakatlar'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=hr.list_quizs"><cf_get_lang dictionary_id='29768.Formlar'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=hr.form_add_quiz"><cf_get_lang dictionary_id='32218.Form Ekle'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=report.time_cost_report"><cf_get_lang dictionary_id='32219.Zaman Yönetimi'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=hr.targets"><cf_get_lang dictionary_id='57964.Hedefler'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.form_add_target_popup','medium');"><cf_get_lang dictionary_id='31422.Hedef Ekle'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=hr.list_total_performances"><cf_get_lang dictionary_id='58003.Performans'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=hr.form_add_total_performance_info"><cf_get_lang dictionary_id='32220.Toplam Performans Girişi'></a><br/>
                </span>
            </cfif>
            
            <cfif get_module_user(3)>
             	<b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(ise_alma);"><cf_get_lang dictionary_id='57996.İşe Alma'></a></b><br/>
                <span id="ise_alma" style="display:none;">
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=hr.list_hr&event=add"><cf_get_lang dictionary_id='32202.Çalışan Ekle'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=hr.apps"><cf_get_lang dictionary_id='58186.Başvurular'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=hr.search_app"><cf_get_lang dictionary_id='32204.Başvuru Ara'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=hr.list_notice"><cf_get_lang dictionary_id='32748.İlanlar'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=hr.list_notice&event=add"><cf_get_lang dictionary_id='32205.İlan Ekle'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=hr.list_orientation"><cf_get_lang dictionary_id='32210.Oryantasyon Eğitimleri'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_add_training_orientation','small');"><cf_get_lang dictionary_id='32145.Oryantasyon Ekle'></a><br/>
                </span>
            </cfif>
            
            <cfif get_module_user(3)>
                <b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(organizasyon);"><cf_get_lang dictionary_id='57972.Organizasyon'></a></b><br/>
                <span id="organizasyon" style="display:none;">
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=hr.organization_schema"><cf_get_lang dictionary_id='32211.Organizasyon Şeması'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=hr.form_add_company_zone&hr=1"><cf_get_lang dictionary_id='32213.Bölgeler'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=hr.form_add_company_branch&hr=1"><cf_get_lang dictionary_id='29434.Şubeler'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=hr.form_add_department&hr=1"><cf_get_lang dictionary_id='32214.Departmanlar'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=hr.list_workgroup"><cf_get_lang dictionary_id='29818.İş Grupları'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=hr.list_workgroup&event=add"><cf_get_lang dictionary_id='32215.İş Grubu Ekle'></a><br/>

                </span>
            </cfif>
            
            <cfif get_module_user(4)>
              	<b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(uye_yonetimi);"><cf_get_lang dictionary_id='32316.Müşteriler/Tedarikçiler'></a></b><br/>
                <span id="uye_yonetimi" style="display:none;">
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=member.welcome"><cf_get_lang dictionary_id='32315.Üye Başvuruları'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=member.form_list_company"><cf_get_lang dictionary_id='57585.Kurumsal Üye'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=member.form_add_company"><cf_get_lang dictionary_id='29409.Kurumsal Üye Ekle'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=member.consumer_list"><cf_get_lang dictionary_id='57586.Bireysel Üye'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=member.consumer_list&event=add"><cf_get_lang dictionary_id='29407.Bireysel Üye Ekle'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=member.list_analysis"><cf_get_lang dictionary_id='57560.Analiz'></a><br/>
                </span>
            </cfif>
            
            <cfif get_module_user(40)>
                <b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(fiziki_varlik);"><cf_get_lang dictionary_id='30004.Fiziki Varlıklar'></a></b><br/>
                <span id="fiziki_varlik" style="display:none;">
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=assetcare.list_assetp"><cf_get_lang dictionary_id='30004.Fiziki Varlıklar'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=assetcare.list_assetp&event=add"><cf_get_lang dictionary_id='31847.Fiziki Varlık Ekle'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=assetcare.list_vehicles"><cf_get_lang dictionary_id='57414.Araçlar'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=assetcare.list_asset_it"><cf_get_lang dictionary_id='31848.IT Varlıkları'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=assetcare.list_assetp_period"><cf_get_lang dictionary_id='29682.Bakım Planı'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=assetcare.dsp_care_calender"><cf_get_lang dictionary_id='30005.Bakım Takvimi'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=assetcare.list_asset_care"><cf_get_lang dictionary_id='31863.Bakım Raporları'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=assetcare.list_sales_purchase_stuff"><cf_get_lang dictionary_id='31912.Fiziki Varlık Alış-Satış'></a><br/>	
                </span>
            </cfif>
            
            <cfif get_module_user(46)>
                <b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(butce);"><cf_get_lang dictionary_id='57559.Bütçe'></a></b><br/>
                <span id="butce" style="display:none;">
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=budget.list_budgets"><cf_get_lang dictionary_id='57524.Bütçeler'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=budget.popup_add_budget','medium');"><cf_get_lang dictionary_id='31133.Bütçe Ekle'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=budget.popup_form_add_expense_item','small');"><cf_get_lang dictionary_id='31177.Bütçe Kalemi Ekle '></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=cost.list_expense_income"><cf_get_lang dictionary_id='57498.Masraf Yönetimi'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=budget.definitions"><cf_get_lang dictionary_id='57529.Tanımlar'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=budget.list_expense_center"><cf_get_lang dictionary_id='31033.Masraf/Gelir Merkezleri'></a><br/>
                    <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=budget.popup_add_expense_center','list');"><cf_get_lang dictionary_id='31135.Masraf/Gelir Merkezi Ekle'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=budget.list_expense_cat"><cf_get_lang dictionary_id='31136.Bütçe Kategorileri'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=budget.popup_form_add_expense_cat"><cf_get_lang dictionary_id='31137.Bütçe Kategorisi Ekle'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=budget.list_expense_item"><cf_get_lang dictionary_id='31176.Bütçe Kalemleri'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=budget.popup_form_add_expense_item"><cf_get_lang dictionary_id='31177.Bütçe Kalemi Ekle'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=budget.list_scenarios"><cf_get_lang dictionary_id='31178.Bütçe Tanımları'></a><br/>
                    <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=finance.popup_form_add_scenarios"><cf_get_lang dictionary_id='31179.Senaryo Tanımı Ekle'></a><br/>
                </span>
            </cfif>
            </div>
		</td>
        <td valign="top" width="25%" style="height:80%; overflow:auto;">
        <!--- Mali Sistem --->
        <div id="mali" style="width:100%;height:99%; z-index:88;overflow:auto;">
        <cfif get_module_user(20)>
            <b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(fatura);"><cf_get_lang dictionary_id='57441.Fatura'></a></b><br/>
            <span id="fatura" style="display:none;">
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=invoice.list_bill"><cf_get_lang dictionary_id='57919.Hareketler'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=invoice.list_purchase"><cf_get_lang dictionary_id='57528.Emirler'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=invoice.form_add_bill"><cf_get_lang dictionary_id='31387.Satış Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=invoice.form_add_bill_purchase"><cf_get_lang dictionary_id='31390.Alış Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=invoice.marketplace_commands"><cf_get_lang dictionary_id='57819.Hal Faturası'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=invoice.form_add_bill_other"><cf_get_lang dictionary_id='30067.Diğer Alış Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=invoice.definition"><cf_get_lang dictionary_id='57529.Tanımlar'></a><br/>
            </span>	
        </cfif>
        
        <cfif get_module_user(16)>
            <b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(finans);"><cf_get_lang dictionary_id='57442.Finans'></a></b><br/>
            <span id="finans" style="display:none;">
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=finance.welcome"><cf_get_lang dictionary_id='30846.Finans Gündemi'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=finance.list_payment_actions&act_type=2"><cf_get_lang dictionary_id='31427.Ödeme Talepleri'></a><br/>
                <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=finance.add_payment_actions&act_type=2','medium');"><cf_get_lang dictionary_id='31433.Ödeme Talebi Ekle'></a><br/> 
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=finance.list_payment_actions&act_type=3"><cf_get_lang dictionary_id='31439.Ödeme Emirleri'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=finance.scenario"><cf_get_lang dictionary_id='31445.Finans Senaryoları'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=finance.list_scen_expense"><cf_get_lang dictionary_id='31447.Senaryo Gelir Giderleri'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=finance.form_add_scen_expense"><cf_get_lang dictionary_id='31448.Senaryo Gelir Gider Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=finance.list_securefund"><cf_get_lang dictionary_id='57676.Teminatlar'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=finance.list_credits"><cf_get_lang dictionary_id='31489.Risk Tanımları'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=finance.definitions"><cf_get_lang dictionary_id='57529.Tanımlar'></a><br/>
            </span>
        </cfif>
        
        <cfif get_module_user(23)>
            <b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(cari);"><cf_get_lang dictionary_id='57519.Cari Hesap'></a></b><br/>
            <span id="cari" style="display:none;">
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ch.list_caris"><cf_get_lang dictionary_id='57919.Hareketler'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ch.list_extre"><cf_get_lang dictionary_id='57809.Hesap Ekstresi'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ch.list_duty_claim"><cf_get_lang dictionary_id='30076.Borç Alacak Dökümü'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=finance.add_payment_actions&act_type=2"><cf_get_lang dictionary_id='31286.Ödeme Oluştur'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ch.dsp_make_age"><cf_get_lang dictionary_id='31302.Borç Yaşlandırma'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=ch.form_upd_account_open&var_=ch_opening_card"><cf_get_lang dictionary_id='31288.Açılış/Devir Fişi'></a><br/>
                <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ch.popup_form_add_debit_claim_note','small');"><cf_get_lang dictionary_id='31310.Dekont Ekle'></a><br/>
            </span>
        </cfif>
        
        <cfif get_module_user(18)>
            <b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(kasa);"><cf_get_lang dictionary_id='57520.Kasa'></a></b><br/>
            <span id="kasa" style="display:none;">
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=cash.list_cashes"><cf_get_lang dictionary_id='58657.Kasalar'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=cash.form_add_cash"><cf_get_lang dictionary_id='31531.Kasa Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=cash.form_add_cash_open"><cf_get_lang dictionary_id='31533.Kasa Devir'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=cash.list_cash_actions"><cf_get_lang dictionary_id='58897.Kasa İşlemleri'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=cash.form_add_cash_to_cash"><cf_get_lang dictionary_id='58060.Virman'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=cash.form_add_cash_revenue"><cf_get_lang dictionary_id='30081.Nakit Tahsilat'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=cash.form_add_cash_payment"><cf_get_lang dictionary_id='57847.Ödeme'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=cash.form_purchase_doviz"><cf_get_lang dictionary_id='29558.Döviz Alış İşlemi'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=cash.form_sale_doviz"><cf_get_lang dictionary_id='29559.Döviz Satış İşlemi'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=finance.list_stores_daily_reports"><cf_get_lang dictionary_id='29569.Şube Kasa Raporu'></a><br/>
                <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=finance.popup_add_daily_sales_report_stores&field_id=get_store_ids.store_ids','small');"><cf_get_lang dictionary_id='31689.Şube Günlük Kasa Raporu Ekle'></a><br/>
            </span>
        </cfif>
        
        <cfif get_module_user(19)>
            <b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(banka);"><cf_get_lang dictionary_id='57521.Banka'></a></b><br/>
            <span id="banka" style="display:none;">
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=bank.list_bank_account"><cf_get_lang dictionary_id='59002.Banka Hesapları'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=bank.form_add_bank_account"><cf_get_lang dictionary_id='59010.Banka Hesabı Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=finance.list_bank_branch"><cf_get_lang dictionary_id='30042.Banka Şubeleri'></a><br/>
                <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=bank.popup_add_bank_branch','medium');"><cf_get_lang dictionary_id='31095.Banka Şubesi Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=bank.list_bank_actions"><cf_get_lang dictionary_id='58896.Banka İşlemleri'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=bank.form_add_bank_account_open"><cf_get_lang dictionary_id='30077.Banka Hesabı Açılışı'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=bank.form_add_invest_money"><cf_get_lang dictionary_id='30082.Hesaba Para Yatır'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=bank.form_add_get_money"><cf_get_lang dictionary_id='30083.Hesaptan Para Çek'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=bank.form_add_virman"><cf_get_lang dictionary_id='58060.Virman'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=bank.form_add_gelenh"><cf_get_lang dictionary_id='57834.Gelen Havale'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=bank.form_add_gidenh"><cf_get_lang dictionary_id='57835.Giden Havale'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=bank.list_creditcard_revenue"><cf_get_lang dictionary_id='31118.Kredi Kartlı Satışlar'></a><br/>
            </span>
        </cfif>
        
        <cfif get_module_user(21)>
            <b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(ceksenet);"><cf_get_lang dictionary_id='57522.Çek/Senet'></a></b><br/>
            <span id="ceksenet" style="display:none;">
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=cheque.list_cheque_actions"><cf_get_lang dictionary_id='30087.Çek İşlemleri'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=cheque.list_cheques"><cf_get_lang dictionary_id='30102.Çek Listesi'></a><br/>
                <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=cheque.popup_add_self_cheque_list','small');"><cf_get_lang dictionary_id='31314.Çek Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=cheque.form_add_payroll_entry"><cf_get_lang dictionary_id='57852.Çek Giriş Bordrosu'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=cheque.form_add_payroll_bank_revenue"><cf_get_lang dictionary_id='31315.Çek Çıkış-Tahsil'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=cheque.form_add_payroll_bank_guaranty"><cf_get_lang dictionary_id='31316.Çek Çıkış-Banka'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=cheque.form_add_payroll_endorsement"><cf_get_lang dictionary_id='30089.Çek Çıkış Bordrosu'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=cheque.form_add_payroll_entry_return"><cf_get_lang dictionary_id='57856.Çek İade Giriş Bordrosu'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=cheque.form_add_payroll_endor_return"><cf_get_lang dictionary_id='57857.Çek İade Çıkış Bordrosu'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=cheque.list_voucher_actions"><cf_get_lang dictionary_id='30091.Senet İşlemleri'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=cheque.list_vouchers"><cf_get_lang dictionary_id='30092.Senet Listesi'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=cheque.form_add_voucher_payroll_entry"><cf_get_lang dictionary_id='58010.Senet Giriş Bordro'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=cheque.form_add_voucher_payroll_revenue"><cf_get_lang dictionary_id='31320.Senet Çıkış-Tahsil'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=cheque.form_add_voucher_payroll_bank_tah"><cf_get_lang dictionary_id='31366.Senet Çıkış-Banka Tahsil'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=cheque.form_add_voucher_payroll_bank_tem"><cf_get_lang dictionary_id='31367.Senet Çıkış-Banka Teminat'></a><br/>
            </span>
        </cfif>
        
        <cfif get_module_user(49)>
            <b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(masraf);"><cf_get_lang dictionary_id='57498.Masraf Yönetimi'></a></b><br/>
            <span id="masraf" style="display:none;">
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=cost.list_expense_income"><cf_get_lang dictionary_id='31708.Harcamalar'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=cost.list_cost"><cf_get_lang dictionary_id='31709.Harcama Raporu'></a><br/>
            </span>
        </cfif>
        
        <cfif get_module_user(22)>
            <b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(muhasebe);"><cf_get_lang dictionary_id='57447.Muhasebe'></a></b><br/>
            <span id="muhasebe" style="display:none;">
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=account.list_cards"><cf_get_lang dictionary_id='31718.Muhasebe Fişleri'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=account.form_add_bill_collecting&bill_type=2&var_=collecting_card"><cf_get_lang dictionary_id='31745.Tahsil Fişi Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=account.form_add_bill_payment&var_=payment_card"><cf_get_lang dictionary_id='31758.Tediye Fişi Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=account.form_add_bill_cash2cash&var_=cash2cash_card"><cf_get_lang dictionary_id='31786.Mahsup Fişi Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=account.form_upd_bill_opening&var_=opening_card&CARD_ID=864"><cf_get_lang dictionary_id='58756.Açılış Fişi'></a><br/>
                <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=account.popup_add_account_to_account','small');"><cf_get_lang dictionary_id='31788.Virman İşlemi'></a><br/>
                <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=account.add_acc_to_acc','small');"><cf_get_lang dictionary_id='31789.Hesap Aktarım İşlemi'></a><br/>
                <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=account.popup_add_sum_bills','small');"><cf_get_lang dictionary_id='31790.Hareket Birleştirme'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=account.list_account_card"><cf_get_lang dictionary_id='31791.Yevmiye Defteri'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=account.list_account_card_rows"><cf_get_lang dictionary_id='31792.Muavin Defteri Dökümü'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=account.list_kebir"><cf_get_lang dictionary_id='31793.Defter-i Kebir'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=account.list_scale"><cf_get_lang dictionary_id='57530.Mali Tablolar'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=account.list_scale"><cf_get_lang dictionary_id='31794.Mizan'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=account.list_income_table&requesttimeout=500"><cf_get_lang dictionary_id='31795.Gelir Tablosu'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=account.list_cost_table&requesttimeout=500"><cf_get_lang dictionary_id='31796.Satış Maliyet Tablosu'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=account.list_balance_sheet&requesttimeout=500"><cf_get_lang dictionary_id='31797.Bilanço'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=account.list_cash_flow_detail"><cf_get_lang dictionary_id='31798.Nakit Akışı'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=account.list_fund_flow_detail"><cf_get_lang dictionary_id='31799.Fon Akışı'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=account.list_scale_record"><cf_get_lang dictionary_id='31800.Kayıtlı Mizan Tabloları'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=account.list_income_table_record"><cf_get_lang dictionary_id='31801.Kayıtlı Gelir Tabloları'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=account.list_cost_table_record"><cf_get_lang dictionary_id='31802.Kayıtlı Satış Maliyet Tabloları'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=account.list_balance_sheet_record"><cf_get_lang dictionary_id='31803.Kayıtlı Bilançolar'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=account.list_cash_flow_records"><cf_get_lang dictionary_id='31804.Kayıtlı Nakit Akışları'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=account.list_fund_flow_records"><cf_get_lang dictionary_id='31805.Kayıtlı Fon Akışları'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=invent.list_inventory"><cf_get_lang dictionary_id='57531.Sabit Kıymetler'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=invent.add_invent_purchase"><cf_get_lang dictionary_id='31806.Sabit Kıymet Alımı'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=invent.add_invent_sale"><cf_get_lang dictionary_id='31807.Sabit Kıymet Satışı'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=account.list_account_plan"><cf_get_lang dictionary_id='57529.Tanımlar'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=account.list_account_plan"><cf_get_lang dictionary_id='31808.Hesap Planı'></a><br/>
                <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=account.popup_form_add_account','small');"><cf_get_lang dictionary_id='31809.Hesap Kodu Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=account.form_add_income_table_def"><cf_get_lang dictionary_id='31810.Gelir Tablosu Tanımları'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=account.form_add_balance_sheet_def"><cf_get_lang dictionary_id='31811.Bilanço Tablosu Tanımları'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=account.form_add_fund_flow_def"><cf_get_lang dictionary_id='31812.Nakit Akım Tablosu Tanımları'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=account.form_add_fund_flow_def"><cf_get_lang dictionary_id='31813.Fon Akım Tablosu Tanımları'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=account.form_add_cost_table_def"><cf_get_lang dictionary_id='31815.Satış Maliyet Tablosu Tanımları'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=account.form_add_invent"><cf_get_lang dictionary_id='31816.Demirbaş Tanımları'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=account.list_inflation"><cf_get_lang dictionary_id='31817.Enflasyon Tanımları'></a><br/>
                <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=account.popup_form_add_inflation','small');"><cf_get_lang dictionary_id='31818.Enflasyon Tanımı Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=account.form_concentrate_bill_no"><cf_get_lang dictionary_id='58616.Belge Numaraları'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=account.bill_no"><cf_get_lang dictionary_id='31819.Fiş Numaraları'></a><br/>
            </span>
        </cfif>
        
        <cfif get_module_user(11)>
            <b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(satis);"><cf_get_lang dictionary_id='57448.Satış'></a></b><br/>
            <span id="satis" style="display:none;">
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=sales.list_order"><cf_get_lang dictionary_id='31106.Siparişler'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=sales.list_opportunity"><cf_get_lang dictionary_id='58694.Fırsatlar'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=sales.form_add_opportunity"><cf_get_lang dictionary_id='58489.Fırsat Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=sales.list_offer"><cf_get_lang dictionary_id='31104.Teklifler'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=sales.list_offer&event=add"><cf_get_lang dictionary_id='32016.Teklif Ver'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=sales.list_order"><cf_get_lang dictionary_id='31106.Siparişler'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=sales.list_order&event=add"><cf_get_lang dictionary_id='32017.Sipariş Al'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=myhome.my_companies"><cf_get_lang dictionary_id='30762.Müşterilerim'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=sales.list_product"><cf_get_lang dictionary_id='57564.Ürünler'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=product.form_add_product"><cf_get_lang dictionary_id='29410.Ürün Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=sales.list_proms"><cf_get_lang dictionary_id='57583.Promosyonlar'></a><br/>
            </span>
        </cfif>
        
        <cfif get_module_user(12)>
            <b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(satinalma);"><cf_get_lang dictionary_id='57449.Satın alma'></a></b><br/>
            <span id="satinalma" style="display:none;">
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=purchase.list_order"><cf_get_lang dictionary_id='30850.Satın alma Gündemi'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=purchase.list_offer"><cf_get_lang dictionary_id='31104.Teklifler'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=purchase.list_offer&event=add"><cf_get_lang dictionary_id='32010.Teklif Al'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=purchase.list_order"><cf_get_lang dictionary_id='31106.Siparişler'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=purchase.list_order&event=add"><cf_get_lang dictionary_id='32011.Sipariş Ver'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=purchase.add_order_product_all_criteria"><cf_get_lang dictionary_id='32012.Toplu Sipariş Ver'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=purchase.list_product&iframe=1"><cf_get_lang dictionary_id='57564.Ürünler'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=product.form_add_product"><cf_get_lang dictionary_id='29410.Ürün Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=product.conditions"><cf_get_lang dictionary_id='32014.Satınalma Koşulları'></a><br/>
            </span>
        </cfif>
        
        <cfif get_module_user(13)>
            <b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(stok);"><cf_get_lang dictionary_id='57452.Stok'></a></b><br/>
            <span id="stok" style="display:none;">
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=stock.list_stock"><cf_get_lang dictionary_id='58166.Stoklar'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=stock.list_purchase"><cf_get_lang dictionary_id='57919.Hareketler'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=stock.form_add_sale"><cf_get_lang dictionary_id='31387.Satış Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=stock.form_add_purchase"><cf_get_lang dictionary_id='31390.Alış Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=stock.add_ship_dispatch"><cf_get_lang dictionary_id='30099.Depo Sevk'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=stock.add_marketplace_ship"><cf_get_lang dictionary_id='29582.Hal İrsaliyesi'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=stock.form_add_fis"><cf_get_lang dictionary_id='32032.Fiş Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=stock.form_add_ship_open_fis"><cf_get_lang dictionary_id='32033.Açılış Fişi Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=stock.add_dispatch_internaldemand"><cf_get_lang dictionary_id='32035.Depolararası Sevk Talebi Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=stock.list_departments"><cf_get_lang dictionary_id='57662.Alan'></a><br/>
                <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=stock.popup_add_department','small');"><cf_get_lang dictionary_id='32036.Depo Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=stock.list_shelves"><cf_get_lang dictionary_id='29944.Raflar'></a><br/>
                <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=product.popup_form_add_product_place&pid=','medium');"><cf_get_lang dictionary_id='32038.Raf Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=stock.list_category_place"><cf_get_lang dictionary_id='32039.Kategori Alanı'></a><br/>
                <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=stock.popup_add_category_place','small');"><cf_get_lang dictionary_id='32040.Kategori Alanı Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=stock.list_stock_count"><cf_get_lang dictionary_id='32041.Sayım'></a><br/>
               <!---  <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_import_stock_open_genius&department_id=1','small');"><cf_get_lang no='1555.Stok Sayımı'></a><br/> --->
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=stock.list_stock_cost"><cf_get_lang dictionary_id='58906.Stok Maliyeti'></a><br/>
            </span>
        </cfif>
        
        <cfif get_module_user(5)>
            <b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(urun);"><cf_get_lang dictionary_id='57458.Ürün Yönetimi'></a></b><br/>
            <span id="urun" style="display:none;">
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=product.list_product"><cf_get_lang dictionary_id='57564.Ürünler'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=product.form_add_product"><cf_get_lang dictionary_id='29410.Ürün Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=product.list_catalog_promotion"><cf_get_lang dictionary_id='58988.Aksiyonlar'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=product.form_add_catalog_promotion"><cf_get_lang dictionary_id='32083.Aksiyon Planlama'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=product.conditions"><cf_get_lang dictionary_id='32084.Koşullar'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=product.collacted_product_prices"><cf_get_lang dictionary_id='29411.Fiyatlar'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=product.list_price_change"><cf_get_lang dictionary_id='32086.Fiyat Önerisi'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=product.list_promotions"><cf_get_lang dictionary_id='57583.Promosyonlar'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=product.form_add_detail_prom"><cf_get_lang dictionary_id='31987.Promosyon Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=product.rivals"><cf_get_lang dictionary_id='30104.Rekabet'></a><br/>
                <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=product.popup_form_add_rival','small');"><cf_get_lang dictionary_id='32087.Rakip Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=product.list_rival_product_prices"><cf_get_lang dictionary_id='32089.Rakip Fiyatlar'></a><br/>
                <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=product.popup_form_add_rival_product_price','medium');"><cf_get_lang dictionary_id='32090.Rakip Fiyat Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=product.list_definition"><cf_get_lang dictionary_id='57529.Tanımlar'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=product.list_price_cat"><cf_get_lang dictionary_id='58964.Fiyat Listeleri'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=product.form_add_pricecat"><cf_get_lang dictionary_id='32092.Fiyat Listesi Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=product.list_unit"><cf_get_lang dictionary_id='32073.Birimler'></a><br/>
                <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=product.popup_form_add_unit','small');"><cf_get_lang dictionary_id='32074.Birim Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=product.list_product_cat"><cf_get_lang dictionary_id='58137.Kategoriler'></a><br/>
                <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=product.popup_form_add_product_cat','medium');"><cf_get_lang dictionary_id='29481.Kategori Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=product.list_property"><cf_get_lang dictionary_id='58910.Ürün Özellikler'></a><br/>
                <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=product.popup_add_property_main','small');"><cf_get_lang dictionary_id='32076.Özellik Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=product.list_product_segment"><cf_get_lang dictionary_id='32095.Hedef Pazar'></a><br/>
                <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=product.popup_add_product_segment','small');"><cf_get_lang dictionary_id='32096.Hedef Pazar Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=product.list_product_comp"><cf_get_lang dictionary_id='32099.Fiyat Yetki Tanımları'></a><br/>
                <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=product.popup_add_product_comp','medium');"><cf_get_lang dictionary_id='32098.Fiyat Yetki Tanımı Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=product.list_product_brands"><cf_get_lang dictionary_id='32097.Markalar'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=product.list_product_configration"><cf_get_lang dictionary_id='32101.Ürün Konfigüratörü'></a><br/>
                <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=product..popup_add_product_configuration','medium');"><cf_get_lang dictionary_id='32102.Konfigürasyon Ekle'></a><br/>
            </span>
        </cfif>
        
        <cfif get_module_user(26)>
            <b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(uretim_planlama);"><cf_get_lang dictionary_id='58464.Üretim Planlama'></a></b><br/>
            <span id="uretim_planlama" style="display:none;">
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=prod.tracking"><cf_get_lang dictionary_id='31106.Siparişler'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=prod.order"><cf_get_lang dictionary_id='57528.Emirler'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=prod.add_prod_order"><cf_get_lang dictionary_id='32043.Üretim Emri Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=prod.list_results"><cf_get_lang dictionary_id='58135.Sonuçlar'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=prod.graph_gant"><cf_get_lang dictionary_id='32044.Çizelge'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=prod.list_workstation_state"><cf_get_lang dictionary_id='32047.Üretim Takibi'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=prod.list_product_tree"><cf_get_lang dictionary_id='32061.Ürün Ağaçları'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=prod.list_materials_total"><cf_get_lang dictionary_id='32045.Malzeme'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=prod.list_definition"><cf_get_lang dictionary_id='57529.Tanımlar'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=prod.list_workstation"><cf_get_lang dictionary_id='32050.İş İstasyonları'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=prod.popup_add_workstation"><cf_get_lang dictionary_id='32051.İş İstasyonu Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=prod.list_route"><cf_get_lang dictionary_id='32052.Rotalar'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=prod.popup_add_route"><cf_get_lang dictionary_id='32053.Rota Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=prod.list_operationtype"><cf_get_lang dictionary_id='32065.İşlem Tipleri'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=prod.add_operationtype"><cf_get_lang dictionary_id='32066.İşlem Tipi Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=prod.list_unit"><cf_get_lang dictionary_id='32073.Birimler'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=product.popup_form_add_unit"><cf_get_lang dictionary_id='32074.Birim Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=prod.list_property"><cf_get_lang dictionary_id='58910.Özellikler'></a><br/>
                <img src="/images/tree_3.gif"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=prod.popup_add_property_main','small');"><cf_get_lang dictionary_id='32076.Özellik Ekle'></a><br/>
            </span>
        </cfif>
        
        <cfif get_module_user(15)>
            <b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(kampanyalar);"><cf_get_lang dictionary_id='57900.Kampanya Yönetimi'></a></b><br/>
            <span id="kampanyalar" style="display:none;">
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=campaign.list_campaign"><cf_get_lang dictionary_id='31098.Kampanyalar'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=campaign.list_campaign&event=add"><cf_get_lang dictionary_id='31914.Kampanya Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=campaign.list_target_markets"><cf_get_lang dictionary_id='57905.Hedef Kitleler'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=campaign.form_add_target_market"><cf_get_lang dictionary_id='31915.Hedef Kitle Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=campaign.list_survey"><cf_get_lang dictionary_id='57947.Anketler'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=campaign.form_add_survey"><cf_get_lang dictionary_id='31916.Anket Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_templates&module=15&assetcat_id=-15','list');"><cf_get_lang dictionary_id='32006.Şablonlar'></a><br/>
            </span>
        </cfif>
        
        <cfif get_module_user(14)>
            <b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(servis);"><cf_get_lang dictionary_id='32019.Servis-Müşteri Hizmetleri'></a></b><br/>
            <span id="servis" style="display:none;">
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=service.list_service"><cf_get_lang dictionary_id='58186.Başvurular'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=service.add_service"><cf_get_lang dictionary_id='31952.Başvuru Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.serial_no&event=det','list')"><cf_get_lang dictionary_id='32020.Seri No Sorgula'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=service.list_guaranty"><cf_get_lang dictionary_id='32021.Alış Garantileri'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=service.list_support"><cf_get_lang dictionary_id='32023.Destek Hesapları'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=service.add_support"><cf_get_lang dictionary_id='32024.Destek Hesabı Aç'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=service.list_care"><cf_get_lang dictionary_id='29682.Bakım Planı'></a><br/>
                <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=service.popup_add_service_care','list')"><cf_get_lang dictionary_id='32025.Bakım Bilgisi Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=service.dsp_service_calender"><cf_get_lang dictionary_id='30857.Servis Gündemi'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=service.list_service_report"><cf_get_lang dictionary_id='32026.Servis Raporları'></a><br/>
                <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=service.popup_add_service_care_contract','page')"><cf_get_lang dictionary_id='32027.Servis Raporu Ekle'></a><br/>
            </span>
        </cfif>
        </div>
        <!--- mali Sistem --->
        </td>
        <td valign="top" width="25%" style="height:80%; overflow:auto;">
        <!--- operasyonel --->
        <div id="operasyonel" style="width:100%;height:99%; z-index:88;overflow:auto;">
        <cfif get_module_user(27)>
            <b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(call_center);"><cf_get_lang dictionary_id='57438.Call Center'></a></b><br/>
            <span id="call_center" style="display:none;">
                <img src="/images/tree_3.gif"><a href= "#request.self#?fuseaction=call.list_callcenter"><cf_get_lang dictionary_id='57438.Call Center'></a><br/>
                <img src="/images/tree_3.gif"><a href= "#request.self#?fuseaction=call.helpdesk"><cf_get_lang dictionary_id='58729.Etkilesimler'></a><br/>
                <img src="/images/tree_3.gif"><a href= "#request.self#?fuseaction=call.add_service"><cf_get_lang dictionary_id='31840.Servis Başvuru Ekle'></a><br/>
            </span>
        </cfif>
        
        <cfif get_module_user(2)>
            <b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(icerik);"><cf_get_lang dictionary_id='57443.İçerik Yönetimi'></a></b><br/>
            <span id="icerik" style="display:none;">
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=content.list_content"><cf_get_lang dictionary_id='57443.İçerik Yönetimi'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=content.list_content"><cf_get_lang dictionary_id='31502.Konular'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=content.add_form_content"><cf_get_lang dictionary_id='32133.Konu Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=content.list_chapters"><cf_get_lang dictionary_id='58139.Bölümler'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=content.add_form_chapter"><cf_get_lang dictionary_id='32247.Bölüm Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=content.list_banners"><cf_get_lang dictionary_id='32248.Banner'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=content.list_banners&event=add"><cf_get_lang dictionary_id='32249.Banner Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_templates&module=2&assetcat_id=-7','medium');"><cf_get_lang dictionary_id='32006.Şablonlar'></a><br/>
            </span>
        </cfif>
        
        <cfif get_module_user(1)>
            <b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(proje);"><cf_get_lang dictionary_id='57416.Proje'></a></b><br/>
            <span id="proje" style="display:none;">
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=project.list_project_work"><cf_get_lang dictionary_id='32007.Proje Yönetimi'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=project.projects"><cf_get_lang dictionary_id='58015.Projeler'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=project.projects&event=add"><cf_get_lang dictionary_id='32008.Proje Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=project.works"><cf_get_lang dictionary_id='58020.İşler'></a><br/>
            </span>
        </cfif>
        
        <cfif get_module_user(6)>
            <b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(ajanda);"><cf_get_lang dictionary_id='57415.Ajanda'></a></b><br/>
            <span id="ajanda" style="display:none;">
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=agenda.view_daily"><cf_get_lang dictionary_id='58457.Günlük'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=agenda.view_weekly"><cf_get_lang dictionary_id='58458.Haftalık'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=agenda.view_monthly"><cf_get_lang dictionary_id='58932.Aylık'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=agenda.view_daily&event=add"><cf_get_lang dictionary_id='58496.Olay Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=agenda.form_settings"><cf_get_lang dictionary_id='57529.Tanımlar'></a><br/>
            </span>
        </cfif>
        
        <cfif get_module_user(9)>
            <b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(egitim);"><cf_get_lang dictionary_id='57419.Eğitim'></a></b><br/>
            <span id="egitim" style="display:none;">
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=training.list_class_agenda"><cf_get_lang dictionary_id='29912.Eğitimler'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=training.list_class_agenda"><cf_get_lang dictionary_id='58043.Eğitim Ajandası'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=training.list_training_subjects"><cf_get_lang dictionary_id='31502.Konular'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=training.list_quizs"><cf_get_lang dictionary_id='58051.Testler'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=training.list_class"><cf_get_lang dictionary_id='58063.Dersler'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=training.list_results"><cf_get_lang dictionary_id='58135.Sonuçlar'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=training.list_class_request"><cf_get_lang dictionary_id='57527.Talep'></a><br/>
            </span>
        </cfif>
        
        <cfif get_module_user(9)>
            <b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(egitim_yonetimi);"><cf_get_lang dictionary_id='57440.Eğitim Yönetimi'></a></b><br/>
            <span id="egitim_yonetimi" style="display:none;">
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=training_management.list_class_agenda"><cf_get_lang dictionary_id='32148.Eğitim Gündemi'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=training_management.definitions"><cf_get_lang dictionary_id='32131.Eğitim Kategorileri'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=training_management.form_add_training_section"><cf_get_lang dictionary_id='32132.Eğitim Kategorisi Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=training_management.list_class"><cf_get_lang dictionary_id='57419.Eğitim'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=training_management.list_class_requests"><cf_get_lang dictionary_id='31017.Eğitim Talepleri'></a><br/>
                <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_form_add_class_join_request','medium');"><cf_get_lang dictionary_id='32136.Eğitim Talebi Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=training_management.list_class_finished"><cf_get_lang dictionary_id='32137.Biten Eğitim'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=training_management.list_class_agenda"><cf_get_lang dictionary_id='32138.Takvim'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=training_management.list_trainers"><cf_get_lang dictionary_id='32139.Eğitimciler'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=training_management.list_training_groups"><cf_get_lang dictionary_id='32140.Eğitim Grupları'></a><br/>
                <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_add_train_group','small');"><cf_get_lang dictionary_id='32141.Eğitim Grubu Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=training_management.list_training_eval"><cf_get_lang dictionary_id='31949.Değerlendirme'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=training_management.form_add_eval_quiz"><cf_get_lang dictionary_id='32143.Değerlendirme Formu Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=training_management.list_questions"><cf_get_lang dictionary_id='58810.Soru'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=training_management.list_quizs"><cf_get_lang dictionary_id='58826.Test'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=training_management.form_add_quiz"><cf_get_lang dictionary_id='32147.Test Ekle'></a><br/>
            </span>
        </cfif>
        
        <cfif get_module_user(10)>
            <b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(forum);"><cf_get_lang dictionary_id='57421.Forum'></a></b><br/>
            <span id="forum" style="display:none;">
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=forum.list_forum"><cf_get_lang dictionary_id='58128.Forumlar'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=forum.form_add_forum"><cf_get_lang dictionary_id='32241.Forum Aç'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=forum.form_add_topic&forumid=2"><cf_get_lang dictionary_id='32133.Konu Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=forum.advanced_search"><cf_get_lang dictionary_id='57904.Detaylı Arama'></a><br/>
            </span>
        </cfif>
        
        <b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(gundem);"><cf_get_lang dictionary_id='32242.Gündem ve Ben'></a></b><br/>
        <span id="gundem" style="display:none;">
            <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=myhome.popup_transfer_work','small')";><cf_get_lang dictionary_id='30962.Pozisyon Görevi Aktar'></a><br/>
            <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=myhome.list_warnings"><cf_get_lang dictionary_id='30761.Onaylarım'></a><br/>
            <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=myhome.my_companies"><cf_get_lang dictionary_id='30762.Müşterilerim'></a><br/>
            <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=myhome.my_position"><cf_get_lang dictionary_id='30793.Pozisyonum'></a><br/>
            <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=myhome.my_extre"><cf_get_lang dictionary_id='57809.Hesap Extresi'></a><br/>
            <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=myhome.my_targets"><cf_get_lang dictionary_id='57964.Hedeflerim'></a><br/>
            <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=myhome.my_offtimes"><cf_get_lang dictionary_id='30820.İzinlerim'></a><br/>
            <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=myhome.my_notes"><cf_get_lang dictionary_id='30821.Notlarım'></a><br/>
            <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=myhome.list_assetp"><cf_get_lang dictionary_id='57420.Varlıklarım'></a><br/>
            <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=myhome.mytime_management"><cf_get_lang dictionary_id='30823.Zaman Yönetimim'></a><br/>
            <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=myhome.time_cost"><cf_get_lang dictionary_id='30824.Zaman Harcaması Ekle'></a><br/>
            <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=myhome.my_payment_request"><cf_get_lang dictionary_id='30826.Avans Taleplerim'></a><br/>
            <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=myhome.form_add_payment_request"><cf_get_lang dictionary_id='30827.Avans Talebi Ekle'></a><br/>
            <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=myhome.list_internaldemand"><cf_get_lang dictionary_id='31011.Satınalma Taleplerim'></a><br/>
            <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=myhome.list_my_caution"><cf_get_lang dictionary_id='31012.İhtarlar'></a><br/>
            <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=myhome.list_my_prizes"><cf_get_lang dictionary_id='31013.Ödüller'></a><br/>
            <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=myhome.list_my_tranings"><cf_get_lang dictionary_id='29912.Eğitimlerim'></a><br/>
            <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=myhome.list_class_request"><cf_get_lang dictionary_id='31017.Eğitim Talepleri'></a><br/>
            <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training.popup_form_add_class_join_request','small');"><cf_get_lang dictionary_id='32136.Eğitim Talebi Ekle'></a><br/>
            <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=myhome.list_warnings"><cf_get_lang dictionary_id='30766.Uyarılarım'></a><br/>
            <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=myhome.list_mydesign"><cf_get_lang dictionary_id='57430.Ayarlarım'></a><br/>
        </span>
        
        <cfif get_module_user(8)>
            <b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(varliklar);"><cf_get_lang dictionary_id='57420.Varlıklar'></a></b><br/>
            <span id="varliklar" style="display:none;">
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=asset.list_asset"><cf_get_lang dictionary_id='57562.Dijital Varlıklar'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=asset.list_asset&event=add"><cf_get_lang dictionary_id='32258.Dijital Varlık Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=assetcare.list_assetp"><cf_get_lang dictionary_id='30004.Fiziki Varlıklar'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=assetcare.list_assetp&event=add"><cf_get_lang dictionary_id='31847.Fiziki Varlık Ekle'></a><br/>
            </span>
        </cfif>
        
        <cfif get_module_user(8)>
            <b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(kutuphane);"><cf_get_lang dictionary_id='57697.Kütüphane'></a></b><br/>
            <span id="kutuphane" style="display:none;">
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=asset.library"><cf_get_lang dictionary_id='32259.Kütüphane Varlıkları'></a><br/>
                <img src="/images/tree_3.gif"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=asset.popup_add_list_library_asset','medium');"><cf_get_lang dictionary_id='32312.Kütüphane Varlığı Ekle'></a><br/>
            </span>
        </cfif>
        
        <cfif get_module_user(43)>
            <b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(literatur);"><cf_get_lang dictionary_id='57418.Literatür'></a></b><br/>
            <span id="literatur" style="display:none;">
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=rule.list_rule"><cf_get_lang dictionary_id='31502.Konular'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=rule.organization"><cf_get_lang dictionary_id='57972.Organizasyon'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=rule.workgroup"><cf_get_lang dictionary_id='29818.İş Grupları'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=rule.list_hr"><cf_get_lang dictionary_id='32255.Kim Kimdir'></a><br/>
            </span>
        </cfif>
        
        <cfif get_module_user(29)>
            <b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(yazismalar);"><cf_get_lang dictionary_id='32268.Yazışmalar ve WebMail'></a></b><br/>
            <span id="yazismalar" style="display:none;">
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=correspondence.list_correspondence"><cf_get_lang dictionary_id='57459.Yazışmalar'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=correspondence.add_correspondence"><cf_get_lang dictionary_id='32254.Yazışma Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=correspondence.list_internaldemand&event=add"><cf_get_lang dictionary_id='31011.Satınalma Taleplerim'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=correspondence.add_payment_actions"><cf_get_lang dictionary_id='31427.Ödeme Talepleri'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=correspondence.add_assetp_demand"><cf_get_lang dictionary_id='32267.Varlık Talebi'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=correspondence.cubemail"><cf_get_lang dictionary_id ='29681.CubeMail'></a><br/>
            </span>
        </cfif> 
        
        <b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=correspondence.addressbook','list')"><cf_get_lang dictionary_id='57429.Adres Defteri'></a></b><br/>
        <b><img src="/images/tree_1.gif" align="absmiddle"><a href="#request.self#?fuseaction=worknet.list_dashboard"><cf_get_lang dictionary_id='57436.Worknet'></a></b><br/>
        
        </div>
        </td>
        <td valign="top" width="25%" style="height:80%; overflow:auto;">
        <div id="ik_portal" style="width:100%;height:99%; z-index:88;overflow:auto;">
        
        <cfif get_module_user(36)>
            <b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(executive_suite);"><cf_get_lang dictionary_id='57439.Executive Suite'></a></b><br/>
            <span id="executive_suite" style="display:none;">
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=report.mizan_raporu"><cf_get_lang dictionary_id='32150.Genel Mizan'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=report.report_targets"><cf_get_lang dictionary_id='57964.Hedefler'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=executive.list_correspondence"><cf_get_lang dictionary_id='57459.Yazışmalar'></a><br/>
            </span>
        </cfif>
        
        <cfif get_module_user(30)>
        	<b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(is_akis);"><cf_get_lang dictionary_id='31032.İş Akış'></a></b><br/>
            <span id="is_akis" style="display:none;">
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=process.list_process"><cf_get_lang dictionary_id='31032.İş Akışları'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=process.designer"><cf_get_lang dictionary_id='36203.Süreç Tasarım'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=process.list_warnings"><cf_get_lang dictionary_id='57690.Uyarılar ve Onaylar'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=process.list_analyses"><cf_get_lang dictionary_id ='58799.Analizler'></a><br/>
            </span>
        </cfif>
        
        <cfif get_module_user(33)>
            <b><img src="/images/tree_1.gif" align="absmiddle"><a href="javascript://" onClick="gizle_goster(rapor);"><cf_get_lang dictionary_id='32266.Rapor Sistemi'></a></b><br/>
            <span id="rapor" style="display:none;">
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=report.list_reports"><cf_get_lang dictionary_id='57626.Raporlar'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=report.list_saved_reports"><cf_get_lang dictionary_id='31052.Kayıtlı Raporlar'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=report.list_reports&event=add"><cf_get_lang dictionary_id='31056.Özel Rapor Ekle'></a><br/>
                <img src="/images/tree_3.gif"><a href="#request.self#?fuseaction=report.list_schedules"><cf_get_lang dictionary_id='31058.Zamanlı Raporlar'></a><br/>
            </span>
        </cfif>
        </div>
        </td>
  	</tr>
    <tr class="color-list" height="15">
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
    </tr>
  	<tr style="vertical-align:bottom;">
		<td>&nbsp;</td>
		<td style="text-align:right"><img src="/images/userguide.gif" align="absmiddle"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=myhome.popup_dsp_user_guides','medium');"><cf_get_lang dictionary_id='32265.Kullanıcı Dökümanları'></a>&nbsp;&nbsp;</td>
		<td><img src="/images/systemguide.gif" align="absmiddle"><a href="#request.self#?fuseaction=settings.management">&nbsp;<cf_get_lang dictionary_id='32264.Sistem Yöneticisi'></a></td>
		<td>&nbsp;</td>
	</tr>
</table>
</cfoutput>
