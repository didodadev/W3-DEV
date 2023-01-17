<cfparam name="attributes.visitTime" default="">
<cfparam name="attributes.visitTime_exit" default="">
<cfparam name="attributes.isg_entry_time" default="">
<cfparam name="attributes.isg_exit_time" default="">
<cfinclude template="../../header.cfm">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfoutput>
        <cf_box>
            <cfform name="saveProductOffFunction" id="saveProductOffFunction">
                <cf_box_elements>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cf_workcube_process is_upd='0' process_cat_width='250' is_detail='0'></div>
                        </div>
                        <div class="form-group" id="item-tcIdentityNumber">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62119.Ziyaretçi TCKN'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <input type="text" name="tcIdentityNumber" id="tcIdentityNumber" maxlength="11">
                                    <span class="input-group-addon btnPointer" onclick="getVisitorInfo();"><i class="fa fa-search"></i></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-visitorName">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37187.Ziyaretçi'><cf_get_lang dictionary_id='32370.Adı Soyadı'> *</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="text" name="visitorName" id="visitorName"></div>
                        </div>
                        <div class="form-group" id="item-special_code">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62114.Hes Kodu'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <input type="text" name="special_code" id="special_code">
                                    <span class="input-group-addon btnPointer" onclick="readBarcode()"><i class="fa fa-barcode"></i></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-phoneNumber">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57220.Telefon Numarası'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cfinput type="text" name="phoneNumber" id="phoneNumber" maxlength="11"></div>
                        </div>
                        <div class="form-group" id="item-emailAddress">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32508.E-mail'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="text" name="emailAddress" id="emailAddress"></div>
                        </div>
                        <div class="form-group" id="item-analyze_company_name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58607.Firma'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="consumer_id" id="consumer_id">
                                    <input type="hidden" name="company_id" id="company_id">
                                    <input type="hidden" name="member_type" id="member_type">
                                    <input name="analyze_company_name" type="text" id="analyze_company_name" onFocus="AutoComplete_Create('analyze_company_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','consumer_id,company_id,member_type','','3','250');" value="<cfif isdefined("attributes.analyze_company_name") and len(attributes.analyze_company_name)><cfoutput>#attributes.analyze_company_name#</cfoutput></cfif>" autocomplete="off">
                                    <cfset str_linke_ait="&field_consumer=saveProductOffFunction.consumer_id&field_comp_id=saveProductOffFunction.company_id&field_member_name=saveProductOffFunction.analyze_company_name&field_type=saveProductOffFunction.member_type">
                                    <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars<cfoutput>#str_linke_ait#</cfoutput>&select_list=7,8&keyword='+encodeURIComponent(document.saveProductOffFunction.analyze_company_name.value),'list');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-car_number">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='60932.Araç Plaka Numarası'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="text" name="car_number" id="car_number"></div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-employeeName">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51923.Ziyaret Edilen'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="employeeId" id="employeeId"  value="">
                                    <input type="text" name="employeeName" id="employeeName" onFocus="AutoComplete_Create('employeeName','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3,0,0,0,2,1,0,0,1','EMPLOYEE_ID','employeeId','saveProductOffFunction','3','135');" value="<cfif isdefined("attributes.employeeName") and len(attributes.employeeName)><cfoutput>#attributes.employeeName#</cfoutput></cfif>">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=saveProductOffFunction.employeeId&field_name=saveProductOffFunction.employeeName&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.saveProductOffFunction.employeeName.value),'list');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-visitTime">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62110.Ziyaret Zamanı Giriş'></label>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <cfinput type="text" name="visitTime" id="visitTime" value="#dateformat(attributes.visitTime,dateformat_style)#" validate="#validate_style#" maxlength="10" readonly>
                                <!--- <span class="input-group-addon"><cf_wrk_date_image date_field="visitTime"></span> --->
                            </div>
                            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                <cf_wrkTimeFormat name="visit_entry_hour" value="" <!--- value="#hour(now())#" ---> disable="disabled">
                            </div>
                            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                <select name="visit_entry_minute" id="visit_entry_minute" disabled>
                                    <cfloop from="0" to="59" index="a">
                                        <cfoutput><option value="#Numberformat(a,00)#" <!--- #Numberformat(a,00) eq minute(now()) ? 'selected' : ''# --->>#Numberformat(a,00)#</option></cfoutput>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-visitTime_exit">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62109.Ziyaret Zamanı Çıkış'></label>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <cfinput type="text" name="visitTime_exit" id="visitTime_exit" value="#dateformat(attributes.visitTime_exit,dateformat_style)#" validate="#validate_style#" maxlength="10" readonly>
                                <!--- <span class="input-group-addon"><cf_wrk_date_image date_field="visitTime_exit"></span> --->
                            </div>
                            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                <cf_wrkTimeFormat name="visit_exit_hour" value="" <!--- value="#hour(now())#" ---> disable="disabled">
                            </div>
                            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                <select name="visit_exit_minute" id="visit_exit_minute" disabled>
                                    <cfloop from="0" to="59" index="a">
                                        <cfoutput><option value="#Numberformat(a,00)#" <!--- #Numberformat(a,00) eq minute(now()) ? 'selected' : ''# --->>#Numberformat(a,00)#</option></cfoutput>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-visitorCartnumber">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62115.Ziyaretçi Kartı Numarası'> *</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="text" name="visitorCartnumber" id="visitorCartnumber"></div>
                        </div>
                        <div class="form-group" id="item-visitorPurpose">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62113.Ziyaret Amacı'> *</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="text" name="visitorPurpose" id="visitorPurpose"></div>
                        </div>
                        <div class="form-group" id="item-note">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <textarea name="note" id="note" style="width:140px;height:45px;"></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group" id="item-isg_entry_time">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62112.ISG Eğitim Veriliş Tarihi'></label>
                            <div class="col col-8 col-md-3 col-sm-3 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="isg_entry_time" value="#dateformat(attributes.isg_entry_time,dateformat_style)#" validate="#validate_style#" maxlength="10" message="" readonly>
                                    <!--- <span class="input-group-addon"><cf_wrk_date_image date_field="isg_entry_time"></span> --->
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-isg_exit_time">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='62111.ISG Eğitim Geçerlilik Tarihi'></label>
                            <div class="col col-8 col-md-3 col-sm-3 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="isg_exit_time" value="#dateformat(attributes.isg_exit_time,dateformat_style)#" validate="#validate_style#" maxlength="10" message="" readonly>
                                    <!--- <span class="input-group-addon"><cf_wrk_date_image date_field="isg_exit_time"></span> --->
                                </div>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <cf_workcube_buttons add_function="kontrol()"> 
                </cf_box_footer>
            </cfform>
        </cf_box>
    </cfoutput>
</div>
<script src="WBP/Recycle/files/js/html5-qrcode.min.js"></script>
<script>
    
    function getVisitorInfo() {
        tc = $('#tcIdentityNumber').val();

        if(tc.length < 11){
            alert("<cfoutput>#getLang(dictionary_id:52469)#</cfoutput>");
            $('#tcIdentityNumber').focus();
            return false;
        }

        var data = new FormData();
        data.append("refinery_visitor_register_tc", tc);
        data.append("our_company_id", <cfoutput>#session.ep.company_id#</cfoutput>);
        AjaxControlPostDataJson( 'WBP/Recycle/files/cfc/recycle_objects.cfc?method=getRegisterVisitor', data, function(response) {
            if( response.length > 0 ){
                response.forEach((e) => {
                    $('#visitorName').val(e.VISITOR_NAME);
                    $('#special_code').val(e.SPECIAL_CODE);
                    $('#phoneNumber').val(e.PHONE_NUMBER);
                    $('#emailAddress').val(e.EMAIL_ADDRESS);
                    $('#consumer_id').val(e.CONSUMER_ID);
                    $('#company_id').val(e.COMPANY_ID);
                    $('#member_type').val(e.MEMBER_TYPE);
                    $('#analyze_company_name').val(e.MEMBER_NAME);
                    $('#car_number').val(e.CAR_NUMBER);
                    $('#employeeId').val(e.EMPLOYEE_ID);
                    $('#employeeName').val(e.EMP_FULLNAME);
                    $('#isg_entry_time').val(e.ISG_ENTRY_TIME);
                    $('#isg_exit_time').val(e.ISG_EXIT_TIME);
                });
            }
            else alert("<cfoutput>#getLang(dictionary_id:62162)#</cfoutput>");
        } );
    }

    function kontrol() {
        if(saveProductOffFunction.visitorName.value == "")
        {
            alert("<cf_get_lang dictionary_id='53168.Ad Soyad Girmelisiniz'> !");	
            return false;
        }
        if(saveProductOffFunction.tcIdentityNumber.value == "")
        {
            alert("<cf_get_lang dictionary_id='62119.Ziyaretçi TCKN'> <cf_get_lang dictionary_id='30941.Boş'>!");	
            return false;
        }
        if(saveProductOffFunction.employeeId.value == "" || saveProductOffFunction.employeeName.value == "")
        {
            alert("<cf_get_lang dictionary_id='51923.Ziyaret Edilen'> <cf_get_lang dictionary_id='30941.Boş'>!");	
            return false;
        }
        if(saveProductOffFunction.visitorCartnumber.value == "")
        {
            alert("<cf_get_lang dictionary_id='62115.Ziyaretçi Kartı Numarası'> <cf_get_lang dictionary_id='30941.Boş'>!");	
            return false;
        }
        if(saveProductOffFunction.visitorPurpose.value == "")
        {
            alert("<cf_get_lang dictionary_id='62113.Ziyaret Amacı'> <cf_get_lang dictionary_id='30941.Boş'>!");	
            return false;
        }
        return true;
    }
    function readBarcode() {

        Swal.fire({
            html: '<div id="qr-reader" style="width:500px"></div><div id="qr-reader-results"></div>',
            showCancelButton: true,
            confirmButtonColor: '#1fbb39',
            cancelButtonColor: '#3085d6',
            confirmButtonText: '<cf_get_lang dictionary_id='57461.Kaydet'>',
            cancelButtonText: '<cf_get_lang dictionary_id='51468.İptal Et'>',
            closeOnConfirm: false,
            allowOutsideClick:false
        }).then((result) => {
            if (result.value) {
                console.log('sa');
            }
        })

        function docReady(fn) {
            // see if DOM is already available
            if (document.readyState === "complete"
                || document.readyState === "interactive") {
                // call on next available tick
                setTimeout(fn, 1);
            } else {
                document.addEventListener("DOMContentLoaded", fn);
            }
        }
    
        docReady(function () {
            var resultContainer = document.getElementById('qr-reader-results');
            var lastResult, countResults = 0;
            function onScanSuccess(qrCodeMessage) {
                if (qrCodeMessage !== lastResult) {
                    ++countResults;
                    lastResult = qrCodeMessage;
                    resultContainer.innerHTML
                        += `<div>[${countResults}] - ${qrCodeMessage}</div>`;
                }
            }
    
            var html5QrcodeScanner = new Html5QrcodeScanner(
                "qr-reader", { fps: 10, qrbox: 250 });
            html5QrcodeScanner.render(onScanSuccess);
        });

    }

</script>