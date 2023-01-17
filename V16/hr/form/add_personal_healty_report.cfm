<cfsavecontent variable="txt">
    <cf_get_lang dictionary_id='55828.İşçi Sağlık Raporu'> : <cfoutput>#get_emp_info(attributes.employee_id,0,0)#</cfoutput>
</cfsavecontent>
<cf_box title="#txt#" scroll="1" collapsable="0" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="add_healty_report" method="post" action="#request.self#?fuseaction=hr.emptypopup_add_personal_healty_report">
        <input type="hidden" value="<cfoutput>#attributes.employee_id#</cfoutput>" name="employee_id" id="employee_id">
        <cfsavecontent variable="message"><cf_get_lang dictionary_id="55826.Doktor"></cfsavecontent>
        <cf_seperator id="doktor" header="#message#">
        <cf_box_elements>
            <div id="doktor">
                <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <label><cf_get_lang dictionary_id='57631.Ad'></label>
                    </div>
                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57631.Ad '></cfsavecontent>
                        <cfinput type="Text" name="doctor_name" required="yes" style="width:150px;" maxlength="50" message="#message#" value="">
                    </div>
                </div>
                <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <label><cf_get_lang dictionary_id='32332.Görev'></label>
                    </div>
                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='55575.Doktor Görevi Girmelisiniz'></cfsavecontent>
                        <cfinput type="Text" name="doctor_task" required="yes" style="width:150px;" maxlength="50" message="#message#" value="">
                    </div>
                </div>
                <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <label><cf_get_lang dictionary_id='58726.Soyad'></label>
                    </div>
                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58726.Soyad'></cfsavecontent>
                        <cfinput type="Text" name="doctor_surname" required="yes" style="width:150px;" maxlength="50" message="#message#" value="">
                    </div>
                </div>
                <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <label><cf_get_lang no='610.Diploma No'></label>
                    </div>
                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='56629.Doktor Diploma No Girmelisiniz'></cfsavecontent>
                        <input type="Text" name="doctor_diploma_no" id="doctor_diploma_no" style="width:150px;" maxlength="50" message="#message#" value="">
                    </div>
                </div>
                <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <label><cf_get_lang dictionary_id='55825.Rapor Tarihi'></label>
                    </div>
                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent>
                            <cfinput validate="#validate_style#" required="Yes" message="#message#" type="text" name="report_date" style="width:65px;">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="report_date"></i></span>
                        </div>
                    </div>
                </div>
            </div>
        </cf_box_elements>
        
        <cfsavecontent variable="message"><cf_get_lang dictionary_id="55824.İşçi Özgeçmişi"></cfsavecontent>
        <cf_seperator id="ozgecmis" header="#message#" is_closed="1">
        <cf_box_elements>
            <div id="ozgecmis" style="display:none;">
                <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <label><cf_get_lang dictionary_id='55821.Konjenital ve diğer hastalıklar'></label>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <input type="Text" name="konjentinal" id="konjentinal" style="width:100%;" maxlength="250" value="">
                    </div>
                </div>
                <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <label><cf_get_lang dictionary_id='55819.İş Kazaları'></label>
                    </div>
                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                        <input type="Text" name="is_kazasi" id="is_kazasi" style="width:100%;" maxlength="250" value="">
                    </div>
                </div>
                <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <label><cf_get_lang dictionary_id='55818.Diğer Kazalar'></label>
                    </div>
                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                        <input type="Text" name="diger_kaza" id="diger_kaza" style="width:100%;" maxlength="250" value="">
                    </div>
                </div>
                <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <label><cf_get_lang dictionary_id='55793.Çiçek'></label>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <input type="Text" name="cicek" id="cicek" style="width:150px;" maxlength="50" value="">
                    </div>
                </div>
                <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <label><cf_get_lang dictionary_id='55694.BCG'></label>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <input type="Text" name="bcg" id="bcg" style="width:150px;" maxlength="50" value="">
                    </div>
                </div>
                <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <label><cf_get_lang dictionary_id='55787.Tetanoz'></label>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <input type="Text" name="tetanoz" id="tetanoz" style="width:150px;" maxlength="50" value="">
                    </div>
                </div>
                <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <label><cf_get_lang dictionary_id='55677.Tiberkülin Testi'></label>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <input type="Text" name="tiberkulin" id="tiberkulin" style="width:150px;" maxlength="50" value="">
                    </div>
                </div>
                <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <label><cf_get_lang dictionary_id='55746.Zehirlenmeler'></label>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <input type="Text" name="zehirlenme" id="zehirlenme" style="width:150px;" maxlength="50" value="">
                    </div>
                </div>
                <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <label><cf_get_lang dictionary_id='55675.Alerjik Durum'></label>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <input type="Text" name="alerji" id="alerji" style="width:150px;" maxlength="50" value="">
                    </div>
                </div>
                <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <label><cf_get_lang dictionary_id='55742.Tanzim edilen veya edilmeyen meslek hastalıkları'></label>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <input type="Text" name="meslek_hastalik" id="meslek_hastalik" style="width:100%;" maxlength="250" value="">
                    </div>
                </div>
                <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <label><cf_get_lang dictionary_id='55735.Boy'></label>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <input type="Text" name="boy" id="boy" style="width:150px;" maxlength="50" value="">
                    </div>
                </div>
                <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <label><cf_get_lang dictionary_id='55662.Göğüs Çevresi'></label>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <input type="Text" name="gogus" id="gogus" style="width:150px;" maxlength="50" value="">
                    </div>
                </div>
                <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <label><cf_get_lang dictionary_id='29784.Ağırlık'></label>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <input type="Text" name="agirlik" id="agirlik" style="width:150px;" maxlength="50" value="">
                    </div>
                </div>
                <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <label><cf_get_lang dictionary_id='55635.Görünüş'></label>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <input type="Text" name="gorunus" id="gorunus" style="width:150px;" maxlength="50" value="">
                    </div>
                </div>
            </div>
        </cf_box_elements>
        
        <cfsavecontent variable="message"><cf_get_lang dictionary_id="55726.Doktorun Görüşleri"></cfsavecontent>
        <cf_seperator id="doktor_gorus" header="#message#" is_closed="1">
        <cf_box_elements>
            <div id="doktor_gorus" style="display:none;">
                <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id='55722.Deri'></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="Text" name="deri" id="deri" style="width:150px;" maxlength="50" value="">
                    </div>
                </div>
                <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id='55623.Ağız ve Dişler'></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="Text" name="agiz_dis" id="agiz_dis" style="width:150px;" maxlength="50" value="">
                    </div>
                </div>
                <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id='55717.İskelet ve Kas Sistemi'></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="Text" name="iskelet_sistemi" id="iskelet_sistemi" style="width:150px;" maxlength="50" value="">
                    </div>
                </div>
                <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id='55606.Dahiliye'></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="Text" name="dahiliye" id="dahiliye" style="width:150px;" maxlength="50" value="">
                    </div>
                </div>
                <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id='55714.Ruh ve Sinir Hastalıkları'></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="Text" name="ruh_sinir" id="ruh_sinir" style="width:150px;" maxlength="50" value="">
                    </div>
                </div>
                <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id='55599.Solunum Sistemi'></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="Text" name="solunum_sistemi" id="solunum_sistemi" style="width:150px;" maxlength="50" value="">
                    </div>
                </div>
                <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id='55713.Üro Genital Sistem'></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="Text" name="uro_genital" id="uro_genital" style="width:150px;" maxlength="50" value="">
                    </div>
                </div>
                <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id='55582.Sindirim Sistemi'></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="Text" name="sindirim_sistemi" id="sindirim_sistemi" style="width:150px;" maxlength="50" value="">
                    </div>
                </div>
            </div>
        </cf_box_elements>
        
        <cfsavecontent variable="message"><cf_get_lang dictionary_id="55709.Duyu Organları"></cfsavecontent>
        <cf_seperator id="duyu_organlari" header="#message#" is_closed="1">
        <cf_box_elements>
            <div id="duyu_organlari" style="display:none;">
                <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id='55708.Göz'></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="Text" name="goz" id="goz" style="width:150px;" maxlength="50" value="">
                    </div>
                </div>
                <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id='55577.Burun'></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="Text" name="burun" id="burun" style="width:150px;" maxlength="50" value="">
                    </div>
                </div>
                <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id='55697.Kulak'></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="Text" name="kulak" id="kulak" style="width:150px;" maxlength="50" value="">
                    </div>
                </div>
                <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label><cf_get_lang dictionary_id='55576.Boğaz'></label>
                    </div>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="Text" name="bogaz" id="bogaz" style="width:150px;" maxlength="50" value="">
                    </div>
                </div>
            </div>
        </cf_box_elements>
        
        <cf_popup_box_footer>
            <cf_workcube_buttons is_upd='0' add_function='#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_healty_report' , #attributes.modal_id#)"),DE(""))#'>
        </cf_popup_box_footer>
    </cfform>
</cf_box>