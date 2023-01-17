<cfif not isDefined("get_expense")>
    <cfparam name="get_expense.treated" default="1">
    <cfparam name="get_expense.emp_id" default="#session.ep.userid#">
    <cfparam name="get_expense.relative_id" default="">
</cfif>
<cf_box id="list_selected_assurance_limits" title="#getLang('','Limitler',47147)#" collapsable="0" closable="0">
    <div class="row">
        <div class="col col-12 col-xs-12 uniqueRow">
            <div class="row" type="row" id="working_type_limits">
            </div>
            <div class="row" type="row" id="limits">
            </div>
        </div>
    </div>
</cf_box>
<cfsavecontent variable="title"><cf_get_lang dictionary_id="41808.Sağlık Harcamaları"></cfsavecontent>
<cf_box id="list_my_health_expenses" title="#title#" collapsable="0" closable="0">
    <div class="row">
        <div class="col col-12 col-xs-12 uniqueRow">
            <div class="row" type="row">
                <div class="form-group col col-12 col-xs-12" id="item-sal_year">
                    <div class="input-group">
                        <select name="sal_year" id="sal_year">
                            <cfloop from="#year(now())-5#" to="#year(now())#" index="yr">
                                <option value="<cfoutput>#yr#</cfoutput>" <cfif isdefined('attributes.sal_year') and (yr eq attributes.sal_year)>selected</cfif>><cfoutput>#yr#</cfoutput></option>
                            </cfloop>
                        </select>
                        <span class="input-group-addon"><i class="fa fa-calendar" style="cursor:default;"></i></span>
                    </div>
                </div>
                <cfset list_relative_level_name = "#getLang('myhome',1204,'babası')#,#getLang('myhome',1205,'annesi')#,#getLang('myhome',572,'Eşi')#,#getLang('myhome',573,'Oğlu')#,#getLang('myhome',574,'Kızı')#,#getLang('myhome',692,'Kardeşi')#">
                <div class="form-group col col-12 col-xs-12" id="item-limit_relative">
                    <cfif len(get_expense.emp_id)>
                        <cfquery name="get_relatives" datasource="#dsn#">
                            select RELATIVE_ID, NAME + ' ' + SURNAME AS FULLNAME,RELATIVE_LEVEL from EMPLOYEES_RELATIVES where employee_Id = #get_expense.emp_id#
                        </cfquery>
                    <cfelse>
                        <cfset get_relatives.recordcount = 0>
                    </cfif>
                    <select name="relatives_id" id="relatives_id">
                        <option value=""><cf_get_lang dictionary_id="34712.Tedavi Gören"></option>
                        <cfoutput>
                            <option value="#get_expense.emp_id#_1" <cfif get_expense.treated eq 1>selected</cfif>>#get_emp_info(get_expense.emp_id,0,0)#</option>
                        </cfoutput>
                        <cfif get_relatives.recordcount>
                            <cfoutput query="get_relatives">
                                <option value="#relative_id#_2" <cfif get_expense.treated eq 2 and get_expense.relative_id eq relative_id> selected</cfif>>#get_relatives.FULLNAME# - #listGetAt(list_relative_level_name,RELATIVE_LEVEL)#</option>
                            </cfoutput>
                        </cfif>
                    </select>
                </div>
                <div class="col col-12 col-xs-12 mb-1 padding-0">
                    <div class="form-group col col-6 col-xs-12" id="item-sum_expense">
                        <label class="control-label bold"><cf_get_lang dictionary_id="60198.Aile"><cf_get_lang dictionary_id='39885.Toplam Harcama'></label>
                    </div>
                    <div class="form-group col col-6 col-xs-12 text-right" id="item-sum_expense_inp">
                        <label name="total_expense" id="total_expense"></label>
                    </div>
                </div>
                <div class="col col-12 col-xs-12 mb-1 padding-0">
                    <div class="form-group col col-6 col-xs-12" id="item-comp_emp_amount">
                        <label class="control-label bold"><cf_get_lang dictionary_id='41154.Kurum Payı'></label>
                    </div>
                    <div class="form-group col col-6 col-xs-12 text-right" id="item-comp_emp_amount_inp">
                        <label name="comp_amount" id="comp_amount"></label>
                    </div>
                </div>
                <div class="col col-12 col-xs-12 mb-1 padding-0">
                    <div class="form-group col col-6 col-xs-12" id="item-comp_emp_amount">
                        <label class="control-label bold"><cf_get_lang dictionary_id="41148.Çalışan Payı"></label>
                    </div>
                    <div class="form-group col col-6 col-xs-12 text-right" id="item-comp_emp_amount_inp">
                        <label name="emp_amount" id="emp_amount"></label>
                    </div>
                </div>
            </div>
        </div>
        <div class="col col-12 col-xs-12 uniqueRow">
            <div class="row" type="row">
                <!---Teminat Tiplerine Göre Çalışanın Sağlık Harcamaları--->
                <cf_seperator id="health_expense_by_assurance_type" header="#getLang('','Teminat Tiplerine Göre Harcamalar',64196)#">
                <div class="" id="health_expense_by_assurance_type"></div>
            </div>
        </div>
    </div>
</cf_box>
<script type="text/javascript">
    <!--- En başta bulunduğumuz yılı ve değerlerini alsın --->
    $('#sal_year').val(<cfoutput>#year(now())#</cfoutput>);
    loadAmounts(<cfoutput>#year(now())#</cfoutput>);
    $("#sal_year").on("change", function() {
        loadAmounts(this.value);
    });
    $('#relatives_id').change(function(){
        loadAmounts( $("#sal_year").val());
    });
    function loadAmounts(selectedYear) {
        <cfif ListFirst(attributes.fuseaction,'.') eq 'myhome'>
            userid = <cfoutput>#session.ep.userid#</cfoutput>;
        <cfelse>
            userid = <cfoutput>#get_expense.emp_id#</cfoutput>;
        </cfif>
        var listParam = userid + "*" + selectedYear;
        var total_amount_kdvli = wrk_safe_query('get_emp_health_expense','dsn2',0,listParam+"*_");
        <cfif x_limit_type eq 1>
            totalAmount = total_amount_kdvli.TOTAL_AMOUNT;
        <cfelse>
            totalAmount = total_amount_kdvli.TREATMENT_AMOUNT;
        </cfif>
        <!--- TOTAL_AMOUNT_KDVLI --->
        if(totalAmount != "") $("#total_expense").text(commaSplit(totalAmount,<cfoutput>#x_rnd_nmbr#</cfoutput>) + " TL");
        else $("#total_expense").text(commaSplit(0,<cfoutput>#x_rnd_nmbr#</cfoutput>) + " TL");

        treated = $('#relatives_id').val();
        if(treated != ""){
            var treated_amount = wrk_safe_query('get_emp_health_expense','dsn2',0,listParam+"*"+treated);
            <!--- COMP_AMOUNT --->
            if(treated_amount.COMP_AMOUNT != "") $("#comp_amount").text(commaSplit(treated_amount.COMP_AMOUNT,<cfoutput>#x_rnd_nmbr#</cfoutput>) + " TL");
            else $("#comp_amount").text(commaSplit(0,<cfoutput>#x_rnd_nmbr#</cfoutput>) + " TL");
            <!--- EMP_AMOUNT --->
            if(treated_amount.EMP_AMOUNT != "") $("#emp_amount").text(commaSplit(treated_amount.EMP_AMOUNT,<cfoutput>#x_rnd_nmbr#</cfoutput>) + " TL");
            else $("#emp_amount").text(commaSplit(0,<cfoutput>#x_rnd_nmbr#</cfoutput>) + " TL");

            <!--- Get Health Expense By Assurance Type --->
            $('#health_expense_by_assurance_type').html('');
            var health_expenses_by_assurance_type = wrk_safe_query('get_emp_health_expense_by_assurance','dsn2',0,listParam+"*"+treated);
            if(health_expenses_by_assurance_type.recordcount >= 0){
                for(i=0;i<health_expenses_by_assurance_type.recordcount;i++){
                    <cfif x_limit_type eq 1>
                        assuranceTotal = health_expenses_by_assurance_type.TOTAL_AMOUNT[i];
                    <cfelse>
                        assuranceTotal = health_expenses_by_assurance_type.TREATMENT_AMOUNT[i];
                    </cfif>
                    $('#health_expense_by_assurance_type').append('<div class="form-group col col-8 col-xs-12" id="item-by_assurance_'+i+'"><label class="control-label text-center bold">'+health_expenses_by_assurance_type.ASSURANCE[i]+'</label></div>');
                    $('#health_expense_by_assurance_type').append('<div class="form-group col col-4 col-xs-12 text-right" id="item-by_assurance_value_'+i+'"><label>'+commaSplit(assuranceTotal,<cfoutput>#x_rnd_nmbr#</cfoutput>)+' TL</label></div>');
                }
            }
        }
        else{
            $('#health_expense_by_assurance_type').html('');
            $("#comp_amount").text(commaSplit(0,<cfoutput>#x_rnd_nmbr#</cfoutput>) + " TL");
            $("#emp_amount").text(commaSplit(0,<cfoutput>#x_rnd_nmbr#</cfoutput>) + " TL");
        }
    }

    loadLimits(); //Sayfa ilk yüklendiğinde çalışsın.
    $('#assurance_id').change(function(){
        loadLimits();
    });
    $('#is_relative').change(function(){
        if($('#is_relative').val() == 2){
            $('#relative_id').change(function(){
                loadLimits();
            });
        }
        else{
            loadLimits();
        }
    });
    function loadLimits() {
        if($('#assurance_id').val() != ""){
            $('#handle_list_selected_assurance_limits a').html($('#assurance_id option:selected').html().split(" -", 1));
            assurance_id = $('#assurance_id').val().split("_",1);
        }
        else{
            $('#handle_list_selected_assurance_limits a').html('<cf_get_lang dictionary_id="38597.Teminat Tipi Seçiniz.">');
            assurance_id = "";
        }
        <cfif ListFirst(attributes.fuseaction,'.') eq 'myhome'>
            userid = <cfoutput>#session.ep.userid#</cfoutput>;
        <cfelse>
            userid = <cfoutput>#get_expense.emp_id#</cfoutput>;
        </cfif>
        if($('#is_relative').val() == 2){
            relative_id = $('#relative_id').val();
        }
        else{
            relative_id = "_";
        }

        $('#working_type_limits').html('');
        if(assurance_id != ""){
            get_assurance_working_type = wrk_safe_query('get_assurance_working_type','dsn',0,assurance_id);
            if(get_assurance_working_type.recordcount){
                if(get_assurance_working_type.WORKING_TYPE == 2){
                    get_assurance_limb_limits = wrk_safe_query('get_assurance_limb_limits','dsn',0,assurance_id);
                    if(get_assurance_limb_limits.recordcount){
                        for(i=0;i<get_assurance_limb_limits.recordcount;i++){
                            get_use_limb_limits = wrk_safe_query('get_use_limb_limits','dsn2',0,userid+"*"+assurance_id+"*"+get_assurance_limb_limits.LIMB_ID[i]+"*"+relative_id);
                            $('#working_type_limits').append('<div class="form-group col col-12 col-xs-12"><label class="control-label text-center bold">' + get_assurance_limb_limits.LIMB_NAME[i] + '</label></div>');
                            $('#working_type_limits').append('<div class="form-group col col-12 col-xs-12"><label class="control-label text-center"><cf_get_lang dictionary_id='54820.Limit'> : ' + get_assurance_limb_limits.MAX[i] + ' x ' + commaSplit(get_assurance_limb_limits.MONEY_LIMIT[i],<cfoutput>#x_rnd_nmbr#</cfoutput>) + ' <cf_get_lang dictionary_id='37345.TL'> / % ' + commaSplit(get_assurance_limb_limits.PAYMENT_RATE[i],<cfoutput>#x_rnd_nmbr#</cfoutput>) + '</label></div>');
                            if(get_use_limb_limits.recordcount){
                                $('#working_type_limits').append('<div class="form-group col col-12 col-xs-12"><label class="control-label text-center"><cf_get_lang dictionary_id='58572.Kullanım'> : ' + get_use_limb_limits.MIKTAR + ' / ' + commaSplit(get_use_limb_limits.TOPLAM,<cfoutput>#x_rnd_nmbr#</cfoutput>) + ' <cf_get_lang dictionary_id='37345.TL'></label></div>');
                            }
                            else{
                                $('#working_type_limits').append('<div class="form-group col col-12 col-xs-12"><label class="control-label text-center"><cf_get_lang dictionary_id='58572.Kullanım'> : 0 / 0</label></div>');
                            }
                            $('#working_type_limits').append('<hr/>');
                        }
                    }
                    else{
                        $('#working_type_limits').append('<div class="form-group col col-12 col-xs-12"><label class="control-label text-center bold" style="color:red;"><cf_get_lang dictionary_id='64643.Uzuv Tanımlamaları Eksik'>!</label></div>');
                        $('#working_type_limits').append('<hr/>');
                    }
                }
                else if(get_assurance_working_type.WORKING_TYPE == 3){
                    get_assurance_treatment_limits = wrk_safe_query('get_assurance_treatment_limits','dsn',0,assurance_id);
                    if(get_assurance_treatment_limits.recordcount){
                        for(i=0;i<get_assurance_treatment_limits.recordcount;i++){
                            get_use_treatments_limits = wrk_safe_query('get_use_treatments_limits','dsn2',0,userid+"*"+assurance_id+"*"+get_assurance_treatment_limits.SETUP_COMPLAINT_ID[i]+"*"+relative_id);
                            $('#working_type_limits').append('<div class="form-group col col-12 col-xs-12"><label class="control-label text-center bold">' + get_assurance_treatment_limits.COMPLAINT[i] + '</label></div>');
                            $('#working_type_limits').append('<div class="form-group col col-12 col-xs-12"><label class="control-label text-center"><cf_get_lang dictionary_id='54820.Limit'> : ' + get_assurance_treatment_limits.MAX[i] + ' x ' + commaSplit(get_assurance_treatment_limits.MONEY_LIMIT[i],<cfoutput>#x_rnd_nmbr#</cfoutput>) + ' <cf_get_lang dictionary_id='37345.TL'> / % ' + commaSplit(get_assurance_treatment_limits.PAYMENT_RATE[i],<cfoutput>#x_rnd_nmbr#</cfoutput>) + '</label></div>');
                            if(get_use_treatments_limits.recordcount){
                                $('#working_type_limits').append('<div class="form-group col col-12 col-xs-12"><label class="control-label text-center"><cf_get_lang dictionary_id='58572.Kullanım'> : ' + get_use_treatments_limits.MIKTAR + ' / ' + commaSplit(get_use_treatments_limits.TOPLAM,<cfoutput>#x_rnd_nmbr#</cfoutput>) + ' <cf_get_lang dictionary_id='37345.TL'></label></div>');
                            }
                            else{
                                $('#working_type_limits').append('<div class="form-group col col-12 col-xs-12"><label class="control-label text-center"><cf_get_lang dictionary_id='58572.Kullanım'> : 0 / 0</label></div>');
                            }
                            $('#working_type_limits').append('<hr/>');
                        }
                    }
                    else{
                        $('#working_type_limits').append('<div class="form-group col col-12 col-xs-12"><label class="control-label text-center bold" style="color:red;"><cf_get_lang dictionary_id='64644.Tedavi Tanımlamaları Eksik'>!</label></div>');
                        $('#working_type_limits').append('<hr/>');
                    }
                }
                else if(get_assurance_working_type.WORKING_TYPE == 4){
                    get_assurance_medication_limits = wrk_safe_query('get_assurance_medication_limits','dsn',0,assurance_id);
                    if(get_assurance_medication_limits.recordcount){
                        for(i=0;i<get_assurance_medication_limits.recordcount;i++){
                            get_use_medication_limits = wrk_safe_query('get_use_medication_limits','dsn2',0,userid+"*"+assurance_id+"*"+get_assurance_medication_limits.DRUG_ID[i]+"*"+relative_id);
                            $('#working_type_limits').append('<div class="form-group col col-12 col-xs-12"><label class="control-label text-center bold">' + get_assurance_medication_limits.DRUG_MEDICINE[i] + '</label></div>');
                            $('#working_type_limits').append('<div class="form-group col col-12 col-xs-12"><label class="control-label text-center"><cf_get_lang dictionary_id='54820.Limit'> : ' + get_assurance_medication_limits.MAX[i] + ' x ' + commaSplit(get_assurance_medication_limits.MONEY_LIMIT[i],<cfoutput>#x_rnd_nmbr#</cfoutput>) + ' <cf_get_lang dictionary_id='37345.TL'> / % ' + commaSplit(get_assurance_medication_limits.PAYMENT_RATE[i],<cfoutput>#x_rnd_nmbr#</cfoutput>) + '</label></div>');
                            if(get_use_medication_limits.recordcount){
                                $('#working_type_limits').append('<div class="form-group col col-12 col-xs-12"><label class="control-label text-center"><cf_get_lang dictionary_id='58572.Kullanım'> : ' + get_use_medication_limits.MIKTAR + ' / ' + commaSplit(get_use_medication_limits.TOPLAM,<cfoutput>#x_rnd_nmbr#</cfoutput>) + ' <cf_get_lang dictionary_id='37345.TL'></label></div>');
                            }
                            else{
                                $('#working_type_limits').append('<div class="form-group col col-12 col-xs-12"><label class="control-label text-center"><cf_get_lang dictionary_id='58572.Kullanım'> : 0 / 0</label></div>');
                            }
                            $('#working_type_limits').append('<hr/>');
                        }
                    }
                    else{
                        $('#working_type_limits').append('<div class="form-group col col-12 col-xs-12"><label class="control-label text-center bold" style="color:red;"><cf_get_lang dictionary_id='64645.İlaç ve Malzeme Tanımlamaları Eksik'>!</label></div>');
                        $('#working_type_limits').append('<hr/>');
                    }
                }
            }
        }

        $('#limits').html('');
        if(assurance_id != ""){

            //Seçilen teminat tipinin üst teminatı var mı? Üst teminat seçili ise o teminata bağlı olan tüm teminatların kullanımı hesaplanır.
            //Üst teminat yoksa sadece o teminatın harcamaları hesaplanır.
            group_assurance_ids = '';
            var get_main_assurance = wrk_safe_query('get_main_assurance_type','dsn',0,assurance_id);
            if(get_main_assurance.MAIN_ASSURANCE_TYPE_ID != ''){
                $('#limits').append('<div class="form-group col col-12 col-xs-12" id="item-interrupt"><label class="control-label text-center bold"><cf_get_lang dictionary_id="62466.Ana Teminat">: '+ get_main_assurance.ASSURANCE +'</label></div>');
                var get_group_assurance_ids = wrk_safe_query('get_group_assurance_ids','dsn',0,get_main_assurance.MAIN_ASSURANCE_TYPE_ID);
                for(k=0; k<get_group_assurance_ids.recordcount; k++){
                    group_assurance_ids += get_group_assurance_ids.ASSURANCE_ID[k];
                    if(k < get_group_assurance_ids.recordcount - 1) group_assurance_ids += ',';
                }
            }
            else{
                group_assurance_ids += assurance_id;
            }

            devreden = 0;
            //Teminat tipinde çalışma şekli Uzuv başına seçiliyse
            if(get_assurance_working_type.WORKING_TYPE == 2)
                var get_limits_by_assurance = get_assurance_limb_limits;
            //Teminat tipinde çalışma şekli Tedavi başına seçiliyse 
            else if(get_assurance_working_type.WORKING_TYPE == 3)
                var get_limits_by_assurance = get_assurance_treatment_limits;
            else if(get_assurance_working_type.WORKING_TYPE == 4)
                var get_limits_by_assurance = get_assurance_medication_limits;
            else
                var get_limits_by_assurance = wrk_safe_query('get_limits_by_assurance','dsn',0,assurance_id);
            var get_sum_expense = wrk_safe_query('get_emp_sum_health_expense','dsn2',0,userid+"*"+group_assurance_ids+"*"+relative_id+"*_");
            <cfif x_limit_type eq 1>
                get_sum_total_amount = get_sum_expense.TOTAL_AMOUNT - get_sum_expense.PAYMENT_INTERRUPTION_VALUE;
            <cfelse>
                get_sum_total_amount = get_sum_expense.TREATMENT_AMOUNT - get_sum_expense.PAYMENT_INTERRUPTION_VALUE;
            </cfif>
            if(get_limits_by_assurance.recordcount){
                if(get_sum_expense != false) $('#limits').append('<div class="form-group col col-12 col-xs-12" id="item-interrupt"><label class="control-label text-center bold"><cf_get_lang dictionary_id="57492.Toplam"><cf_get_lang dictionary_id="32191.Kesinti">: '+ commaSplit(get_sum_expense.PAYMENT_INTERRUPTION_VALUE,<cfoutput>#x_rnd_nmbr#</cfoutput>) +' <cf_get_lang dictionary_id='37345.TL'></label></div>');
                for(i=0;i<get_limits_by_assurance.recordcount;i++){
                    if(get_limits_by_assurance.MIN[i] != '' && get_limits_by_assurance.MIN[i] != 0) min = parseFloat(get_limits_by_assurance.MIN[i]);
                    else min = 0;
                    if(get_limits_by_assurance.MAX[i] != '') max = parseFloat(get_limits_by_assurance.MAX[i]);
                    else max = 9999999;
                    rate = parseFloat(get_limits_by_assurance.RATE[i]);
                    private_rate = parseFloat(get_limits_by_assurance.PRIVATE_COMP_RATE[i]);
                    if(private_rate == 0){
                        private_rate = '-';
                    }
                    if(get_sum_total_amount != '') sumExp = parseFloat(get_sum_total_amount);
                    else sumExp = 0;
                    if(i == 0){
                        if(sumExp >= min && sumExp <= max){
                            diff_rate = wrk_round((sumExp * 100) / max,<cfoutput>#x_rnd_nmbr#</cfoutput>);
                            $('#limits').append('<div class="form-group col col-12 col-xs-12" id="item-limit_'+i+'"><label class="control-label text-center bold"><cf_get_lang dictionary_id='54820.Limit'> '+ (i + 1) +'. <cf_get_lang dictionary_id='57671.Basamak'></label></div>');
                            //Teminat tipinde çalışma şekli tutar aralığı seçiliyse
                            if(get_assurance_working_type.WORKING_TYPE == 1)
                                $('#limits').append('<div class="form-group col col-12 col-xs-12" id="item-limit_value_'+i+'"><label>' + commaSplit(min,<cfoutput>#x_rnd_nmbr#</cfoutput>) + ' - ' + commaSplit(max,<cfoutput>#x_rnd_nmbr#</cfoutput>) + ' <cf_get_lang dictionary_id='37345.TL'> / <cf_get_lang dictionary_id='58714.SGK'>  : %' + rate +' / Özel : %' + private_rate + '</label></div>');    
                            else
                                $('#limits').append('<div class="form-group col col-12 col-xs-12" id="item-limit_value_'+i+'"><label>' + commaSplit(min,<cfoutput>#x_rnd_nmbr#</cfoutput>) + ' - ' + commaSplit(max,<cfoutput>#x_rnd_nmbr#</cfoutput>) + ' <cf_get_lang dictionary_id='37345.TL'> / <cf_get_lang dictionary_id='58456.Oran'>  : %' + rate + '</label></div>');
                            $('#limits').append('<div class="form-group col col-12 col-xs-12" id="item-sum_expense"><label> <cf_get_lang dictionary_id='61465.Kalan Limit'> : ' + commaSplit(max - min - sumExp,<cfoutput>#x_rnd_nmbr#</cfoutput>) + ' <cf_get_lang dictionary_id='37345.TL'></label></div>');
                            $('#limits').append('<div class="form-group col col-12 col-xs-12 progress" title="<cf_get_lang dictionary_id='51390.Kullanılan Limit'> : '+commaSplit(sumExp,<cfoutput>#x_rnd_nmbr#</cfoutput>)+' TL" style="background:##93a6a28c;margin-bottom: 0px;"><div class="project-bar" role="progressbar" aria-valuemin="0" aria-valuemax="100" style="margin-left:-5px;color:black;width:'+diff_rate+'%">'+diff_rate+'%</div></div>');
                        }
                        else if(sumExp > max){
                            devreden = sumExp - max;
                            diff_rate = 100;
                            $('#limits').append('<div class="form-group col col-12 col-xs-12" id="item-limit_'+i+'"><label class="control-label text-center bold">Limit '+ (i + 1) +'. <cf_get_lang dictionary_id='57671.Basamak'></label></div>');
                            //Teminat tipinde çalışma şekli tutar aralığıysa
                            if(get_assurance_working_type.WORKING_TYPE == 1)
                                $('#limits').append('<div class="form-group col col-12 col-xs-12" id="item-limit_value_'+i+'"><label>' + commaSplit(min,<cfoutput>#x_rnd_nmbr#</cfoutput>) + ' - ' + commaSplit(max,<cfoutput>#x_rnd_nmbr#</cfoutput>) + ' <cf_get_lang dictionary_id='37345.TL'> / <cf_get_lang dictionary_id='58714.SGK'> : %' + rate +' / <cf_get_lang dictionary_id='57979.Özel'> : %' + private_rate + '</label></div>');
                            else
                                $('#limits').append('<div class="form-group col col-12 col-xs-12" id="item-limit_value_'+i+'"><label>' + commaSplit(min,<cfoutput>#x_rnd_nmbr#</cfoutput>) + ' - ' + commaSplit(max,<cfoutput>#x_rnd_nmbr#</cfoutput>) + ' <cf_get_lang dictionary_id='37345.TL'> / <cf_get_lang dictionary_id='58456.Oran'> : %' + rate + '</label></div>');             
                            $('#limits').append('<div class="form-group col col-12 col-xs-12" id="item-sum_expense"><label> <cf_get_lang dictionary_id='61465.Kalan Limit'> : ' + commaSplit(0,<cfoutput>#x_rnd_nmbr#</cfoutput>) + ' <cf_get_lang dictionary_id='37345.TL'></label></div>');
                            $('#limits').append('<div class="form-group col col-12 col-xs-12 progress" title="<cf_get_lang dictionary_id='51390.Kullanılan Limit'> : '+commaSplit(max,<cfoutput>#x_rnd_nmbr#</cfoutput>)+' <cf_get_lang dictionary_id='37345.TL'>" style="background:##93a6a28c;margin-bottom: 0px;"><div class="project-bar" role="progressbar" aria-valuemin="0" aria-valuemax="100" style="margin-left:-5px;background-color:red !important;color:black;width:'+(diff_rate + 4)+'%">'+diff_rate+'%</div></div>');
                        }
                    }
                    else{
                        if(devreden != 0){
                            if(sumExp >= min && sumExp <= max){
                                diff_rate = wrk_round((devreden * 100) / max,<cfoutput>#x_rnd_nmbr#</cfoutput>);
                                $('#limits').append('<div class="form-group col col-12 col-xs-12" id="item-limit_'+i+'"><label class="control-label text-center bold">Limit '+ (i + 1) +'. <cf_get_lang dictionary_id='57671.Basamak'></label></div>');
                                $('#limits').append('<div class="form-group col col-12 col-xs-12" id="item-limit_value_'+i+'"><label>' + commaSplit(min,<cfoutput>#x_rnd_nmbr#</cfoutput>) + ' - ' + commaSplit(max,<cfoutput>#x_rnd_nmbr#</cfoutput>) + ' <cf_get_lang dictionary_id='37345.TL'> / <cf_get_lang dictionary_id='58714.SGK'> : %' + rate +' / <cf_get_lang dictionary_id='57979.Özel'> : %' + private_rate + '</label></div>');
                                $('#limits').append('<div class="form-group col col-12 col-xs-12" id="item-sum_expense"><label> <cf_get_lang dictionary_id='61465.Kalan Limit'> : ' + commaSplit(max - min - devreden,<cfoutput>#x_rnd_nmbr#</cfoutput>) + ' <cf_get_lang dictionary_id='37345.TL'></label></div>');
                                $('#limits').append('<div class="form-group col col-12 col-xs-12 progress" title="<cf_get_lang dictionary_id='51390.Kullanılan Limit'> : '+commaSplit(devreden,<cfoutput>#x_rnd_nmbr#</cfoutput>)+' <cf_get_lang dictionary_id='37345.TL'>" style="background:##93a6a28c;margin-bottom: 0px;"><div class="project-bar" role="progressbar" aria-valuemin="0" aria-valuemax="100" style="margin-left:-5px;color:black;width:'+diff_rate+'%">'+diff_rate+'%</div></div>');
                            }
                            else if(sumExp > max){
                                devreden = devreden - (max - min);
                                diff_rate = 100;
                                $('#limits').append('<div class="form-group col col-12 col-xs-12" id="item-limit_'+i+'"><label class="control-label text-center bold">Limit '+ (i + 1) +'. <cf_get_lang dictionary_id='57671.Basamak'></label></div>');
                                $('#limits').append('<div class="form-group col col-12 col-xs-12" id="item-limit_value_'+i+'"><label>' + commaSplit(min,<cfoutput>#x_rnd_nmbr#</cfoutput>) + ' - ' + commaSplit(max,<cfoutput>#x_rnd_nmbr#</cfoutput>) + ' <cf_get_lang dictionary_id='37345.TL'> / <cf_get_lang dictionary_id='58714.SGK'> : %' + rate +' / <cf_get_lang dictionary_id='57979.Özel'> : %' + private_rate + '</label></div>');
                                $('#limits').append('<div class="form-group col col-12 col-xs-12" id="item-sum_expense"><label> <cf_get_lang dictionary_id='61465.Kalan Limit'> : ' + commaSplit(0,<cfoutput>#x_rnd_nmbr#</cfoutput>) + ' <cf_get_lang dictionary_id='37345.TL'></label></div>');
                                $('#limits').append('<div class="form-group col col-12 col-xs-12 progress" title="<cf_get_lang dictionary_id='51390.Kullanılan Limit'> : '+commaSplit(max - min,<cfoutput>#x_rnd_nmbr#</cfoutput>)+' <cf_get_lang dictionary_id='37345.TL'>" style="background:##93a6a28c;margin-bottom: 0px;"><div class="project-bar" role="progressbar" aria-valuemin="0" aria-valuemax="100" style="margin-left:-5px;background-color:red !important;color:black;width:'+(diff_rate + 4)+'%">'+diff_rate+'%</div></div>');
                            }
                        }
                        else{
                            $('#limits').append('<div class="form-group col col-12 col-xs-12" id="item-limit_'+i+'"><label class="control-label text-center bold">Limit '+ (i + 1) +'. <cf_get_lang dictionary_id='57671.Basamak'></label></div>');
                            $('#limits').append('<div class="form-group col col-12 col-xs-12" id="item-limit_value_'+i+'"><label>' + commaSplit(min,<cfoutput>#x_rnd_nmbr#</cfoutput>) + ' - ' + commaSplit(max,<cfoutput>#x_rnd_nmbr#</cfoutput>) + ' <cf_get_lang dictionary_id='37345.TL'> / <cf_get_lang dictionary_id='58714.SGK'> : %' + rate +' / <cf_get_lang dictionary_id='57979.Özel'> : %' + private_rate + '</label></div>');
                            $('#limits').append('<div class="form-group col col-12 col-xs-12" id="item-sum_expense"><label> <cf_get_lang dictionary_id='61465.Kalan Limit'> : ' + commaSplit(max - sumExp,<cfoutput>#x_rnd_nmbr#</cfoutput>) + ' <cf_get_lang dictionary_id='37345.TL'></label></div>');
                            $('#limits').append('<div class="form-group col col-12 col-xs-12 progress" title="<cf_get_lang dictionary_id='51390.Kullanılan Limit'> : '+commaSplit(0,<cfoutput>#x_rnd_nmbr#</cfoutput>)+' <cf_get_lang dictionary_id='37345.TL'>" style="background:##93a6a28c;margin-bottom: 0px;"><div class="project-bar" role="progressbar" aria-valuemin="0" aria-valuemax="100" style="margin-left:-5px;color:black;width:0%">0%</div></div>');
                        }
                    }
                }
            }
            else{
                if(assurance_id != "") $('#limits').append('<div class="form-group col col-12 col-xs-12"><label class="control-label text-center bold" style="color:red;"> <cf_get_lang dictionary_id='64646.Limit Tanımları Yapılmamış'>!</label></div>');
            }
        }
    }
</script>