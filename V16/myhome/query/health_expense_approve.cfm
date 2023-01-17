
<!---
    File: health_expense_approve.cfm
    Controller: hr = HealthExpenseController.cfm
    Author: Esma R. UYSAL
    Date: 25/12/2019 
    Description:
        Sağlık talebinden harcama oluşturuldu.
--->

<cfset attributes.sal_mon = month(attributes.EXPENSE_DATE)>
<cfset attributes.sal_year = year(attributes.EXPENSE_DATE)>
<cf_date tarih='attributes.EXPENSE_DATE'>
<cfinclude template="/V16/hr/ehesap/query/get_program_parameter.cfm">
<cfset allowance_expense_cmp = createObject("component","V16.myhome.cfc.allowance_expense") /><!--- Ek Ödenek / Kesinti --->
<cfset get_in_out_id  = allowance_expense_cmp.GET_IN_OUT_ID(attributes.EXPENSE_EMPLOYEE_ID)><!--- In out Id --->
<cfset get_payments_cmp = createObject("component","V16.hr.ehesap.cfc.get_payments") /><!--- Ödenek Tanımları --->
<cfset get_health_cmp = createObject("component","V16.myhome.cfc.health_expense") /><!--- Gider Kalemi/gelir kalemi/ Muhasebe kodu, harcama fişi upd --->
<cfset attributes.expense_employee_id = listfirst(attributes.expense_employee_id,'_')>
<!--- Anlaşmalı kurum değil ise  --->
<cflock timeout="60" name="#CreateUUID()#">
<cfif isdefined("get_program_parameters.salaryparam_pay_id") and len(get_program_parameters.salaryparam_pay_id) and isdefined("get_program_parameters.expense_item_id") and len(get_program_parameters.expense_item_id) and isdefined("get_program_parameters.EXPENSE_CENTER_ID") and len(get_program_parameters.EXPENSE_CENTER_ID) and not isdefined("attributes.ch_company")> 
    <cfset get_payments = get_payments_cmp.SETUP_PAYMENT_INTERRUPTION(odkes_id : get_program_parameters.salaryparam_pay_id)><!--- Ödenek Bilgileri --->
    <cfset get_allowance_expense = allowance_expense_cmp.ADD_SALARYPARAM_PAY(
        comment_pay :  get_payments.comment_pay,<!--- Ödenek İsmi --->
        comment_pay_id : get_payments.odkes_id,<!---Ödenek Id --->
        amount_pay : attributes.our_company_health_amount,<!--- Ödenek (Kurum Payı) --->
        ssk : get_payments.ssk,<!--- ssk 1 : muaf, 2: muaf değil ---> 
        tax : get_payments.tax,<!--- vergi 1 : muaf, 2: muaf değil---> 
        is_damga : get_payments.is_damga,<!--- damga vergisi --->
        is_issizlik : get_payments.is_issizlik,<!--- işsizlik ---> 
        show : get_payments.show,<!--- bordroda görünsün ---> 
        method_pay : get_payments.method_pay,<!--- 1: artı, 2 : ay , 3 : gün, 4 : saat---> 
        period_pay : get_payments.period_pay,<!--- 1: ayda 1, 2 : 3 ayda 1 , 3 : 6 ayda 1, 4 : yılda 1---> 
        start_sal_mon : attributes.sal_mon,<!--- Başlangıç Ayı --->
        end_sal_mon : attributes.sal_mon,<!--- Bitiş Ayı --->
        employee_id : attributes.EXPENSE_EMPLOYEE_ID,<!--- çalışan id --->
        term : attributes.sal_year,<!--- yıl --->
        calc_days : get_payments.calc_days,<!---tutar günü 0 : tümü, 1: gün,2 : fiili gün --->
        is_kidem : get_payments.is_kidem,<!--- kıdeme dahil 1:kıdeme ahil,0 kıdeme dahil değil ??? sorulacak--->
        in_out_id : get_in_out_id.in_out_id,<!--- Giriş çıkış id --->
        from_salary : get_payments.from_salary, <!--- 0 :net,1 : brüt --->
        is_ehesap : get_payments.is_ehesap,<!--- üst düzey ik yetkisi 1 : dahi, 0 :dahil değil--->
        is_ayni_yardim : get_payments.is_ayni_yardim,<!--- ayni yardım --->
        tax_exemption_value : get_payments.tax_exemption_value,<!--- Gelir Vergisi Muafiyet Tutarı --->
        tax_exemption_rate : get_payments.tax_exemption_rate,<!--- Gelir Vergisi Muafiyet Oranı--->
        money : get_payments.MONEY,<!--- Para birimi--->
        is_income : get_payments.is_income,<!--- kazançlara dahil--->
        is_not_execution : get_payments.is_not_execution,<!--- İcraya Dahil Değil --->
        comment_type : get_payments.comment_type<!--- 1: ek ödenek, 2: kazanc --->
        ) /> 
        <cfset get_acc_code = get_health_cmp.GET_ACC_CODE(expense_item_id : get_program_parameters.EXPENSE_ITEM_ID)/><!---Bütçe kaleminin muhasebe kodu--->
        <cfscript>
            row_detail = '#session.ep.period_year# #attributes.sal_mon#.Ay - Sağlık Harcaması';
            butce_sil(action_id:attributes.health_id,process_type:2503);
            butceci(
                action_id : attributes.health_id,
                is_income_expense : 'false',
                process_type : attributes.process_stage,
                nettotal : attributes.OUR_COMPANY_HEALTH_AMOUNT,
                other_money_value : attributes.OUR_COMPANY_HEALTH_AMOUNT,
                action_currency : session.ep.money,
                action_table : 'EXPENSE_ITEM_PLAN_REQUESTS',
                expense_date : attributes.EXPENSE_DATE,
                expense_center_id : get_program_parameters.EXPENSE_CENTER_ID,
                expense_item_id : get_program_parameters.EXPENSE_ITEM_ID,
                detail : '#row_detail#',
                branch_id : attributes.branch_id,
                employee_id : attributes.EXPENSE_EMPLOYEE_ID,
                muhasebe_db:dsn2,
                insert_type : 1//banka vs den eklenen masraflar için farklı ekleme metodu tanımlar                 
            );
            muhasebe_sil(action_id:attributes.health_id,process_type:2503);
            muhasebeci (
                action_id:attributes.health_id,
                workcube_process_type:2503,
                account_card_type:13,
                belge_no : attributes.paper_number,
                action_table :'EXPENSE_ITEM_PLAN_REQUESTS',
                islem_tarihi:attributes.EXPENSE_DATE,
                borc_hesaplar: get_acc_code.ACCOUNT_CODE,
                borc_tutarlar: attributes.OUR_COMPANY_HEALTH_AMOUNT,
                other_amount_borc : attributes.OUR_COMPANY_HEALTH_AMOUNT,
                other_currency_borc : session.ep.money,
                alacak_hesaplar: get_program_parameters.HEALTH_ACCOUNT_CODE,
                alacak_tutarlar: attributes.OUR_COMPANY_HEALTH_AMOUNT,
                other_amount_alacak : attributes.OUR_COMPANY_HEALTH_AMOUNT,
                other_currency_alacak : session.ep.money,
                fis_detay:'Sağlık Harcaması',
                fis_satir_detay:'Sağlık Harcaması',
                workcube_process_cat : attributes.PROCESS_CAT		
                );
        </cfscript>		
        <cfset health_approve = get_health_cmp.EXPENSE_ITEM_PLAN_REQUESTS_HEALTH_APPROVE(health_id = attributes.health_id)>
<cfelseif isdefined("get_program_parameters.salaryparam_pay_id") and len(get_program_parameters.salaryparam_pay_id) and isdefined("get_program_parameters.expense_item_id") and len(get_program_parameters.expense_item_id) and isdefined("get_program_parameters.EXPENSE_CENTER_ID") and len(get_program_parameters.EXPENSE_CENTER_ID) and isdefined("attributes.ch_company") >
    <cfif isDefined("attributes.EXPENSE_ITEM_PLANS_ID") and len(attributes.EXPENSE_ITEM_PLANS_ID)>
        <cfset get_acc_code = get_health_cmp.GET_ACC_CODE(expense_item_id : get_program_parameters.EXPENSE_ITEM_ID)/><!---Bütçe kaleminin muhasebe kodu--->
         <cfset GET_EXPENSE_ROWS = get_health_cmp.GET_EXPENSE_ROWS( health_id : attributes.EXPENSE_ITEM_PLANS_ID)/><!---Fişin Kdv değeri çekilecek--->
         <cfif len (GET_EXPENSE_ROWS.KDV_RATE)>
             <cfset kdv_rate_ = GET_EXPENSE_ROWS.KDV_RATE>
         </cfif>
        <cfset upd_expense_rows = get_health_cmp.UPD_SET_EXPENSE_ROWS(
            expense_item_id : get_program_parameters.EXPENSE_ITEM_ID,
            expense_center_id : get_program_parameters.EXPENSE_CENTER_ID,
            expense_account_code : get_program_parameters.HEALTH_ACCOUNT_CODE,
            health_id : attributes.EXPENSE_ITEM_PLANS_ID,
            total_amount : (isdefined("attributes.relative_id") and len(attributes.relative_id)) ? attributes.lastTotal : ''
        )>
        <cfscript>
            row_detail = '#session.ep.period_year# #attributes.sal_mon#.Ay - Sağlık Harcaması';
            butce_sil(action_id:attributes.health_id,process_type:2503);
            butceci(
                action_id : attributes.health_id,
                is_income_expense : 'false',
                process_type : attributes.process_stage,
                nettotal : attributes.OUR_COMPANY_HEALTH_AMOUNT,
                other_money_value : attributes.OUR_COMPANY_HEALTH_AMOUNT,
                action_currency : session.ep.money,
                action_table : 'EXPENSE_ITEM_PLAN_REQUESTS',
                expense_date : attributes.EXPENSE_DATE,
                expense_center_id : get_program_parameters.EXPENSE_CENTER_ID,
                expense_item_id : get_program_parameters.EXPENSE_INCOME_ITEM_ID,
                detail : '#row_detail#',
                branch_id : attributes.branch_id,
                employee_id : attributes.EXPENSE_EMPLOYEE_ID,
                muhasebe_db:dsn2,
                insert_type : 1//banka vs den eklenen masraflar için farklı ekleme metodu tanımlar                 
            );

        </cfscript>
        <cfscript>
            muhasebe_sil(action_id:attributes.health_id,process_type:2503);
            borc_hesaplar_list =  get_program_parameters.HEALTH_ACCOUNT_CODE;
            borc_tutarlar_list = attributes.OUR_COMPANY_HEALTH_AMOUNT;
            other_amount_borc_list = attributes.OUR_COMPANY_HEALTH_AMOUNT;
            other_currency_borc_list = session.ep.money;
            if(isdefined("attributes.relative_id") and len(attributes.relative_id)){
                   if(isDefined("kdv_rate_")) //kdv
                        get_tax_acc_code = cfquery(datasource : "#dsn2#", sqlstring : "SELECT PURCHASE_CODE,DIRECT_EXPENSE_CODE FROM SETUP_TAX WHERE TAX =#kdv_rate_#");
                    borc_hesaplar_list = ListAppend(borc_hesaplar_list, get_tax_acc_code.direct_expense_code, ",");
                    borc_tutarlar_list = (borc_tutarlar_list - GET_EXPENSE_ROWS.AMOUNT_KDV);
                    borc_tutarlar_list = ListAppend(borc_tutarlar_list, GET_EXPENSE_ROWS.AMOUNT_KDV, ",");
                    other_amount_borc_list = (other_amount_borc_list - GET_EXPENSE_ROWS.AMOUNT_KDV);
                    other_amount_borc_list = ListAppend(other_amount_borc_list, GET_EXPENSE_ROWS.AMOUNT_KDV, ",");
                    other_currency_borc_list = ListAppend(other_currency_borc_list, session.ep.money, ",");
            }
            muhasebeci (
                action_id:attributes.health_id,
                workcube_process_type:2503,
                account_card_type:13,
                belge_no : attributes.paper_number,
                action_table :'EXPENSE_ITEM_PLAN_REQUESTS',
                islem_tarihi:attributes.EXPENSE_DATE,
                borc_hesaplar: borc_hesaplar_list,
                borc_tutarlar: borc_tutarlar_list,
                other_amount_borc : other_amount_borc_list,
                other_currency_borc : other_currency_borc_list,
                alacak_hesaplar: get_acc_code.ACCOUNT_CODE,
                alacak_tutarlar: attributes.OUR_COMPANY_HEALTH_AMOUNT,
                other_amount_alacak : attributes.OUR_COMPANY_HEALTH_AMOUNT,
                other_currency_alacak : session.ep.money,
                fis_detay:'Sağlık Harcaması',
                fis_satir_detay:'Sağlık Harcaması',
                workcube_process_cat : attributes.PROCESS_CAT		
                );
        </cfscript>
    <cfset health_approve = get_health_cmp.EXPENSE_ITEM_PLAN_REQUESTS_HEALTH_APPROVE(health_id = attributes.health_id)><!--- Talebi onaylama --->
    <cfif len(get_program_parameters.PAYMENT_INTERRUPTION_ID)><!--- bordro akış parametrelerinde Kesinti tanımlanışsa --->
        <cfset interruption_id = get_program_parameters.PAYMENT_INTERRUPTION_ID><!--- Kesinti id--->
        <cfset get_interruption = get_payments_cmp.SETUP_PAYMENT_INTERRUPTION(odkes_id : interruption_id)><!--- Kesinti Bilgileri --->
        <cfif get_interruption.recordcount>
            <cfset add_interruption = allowance_expense_cmp.ADD_SALARYPARAM_GET(
                comment_get : get_interruption.comment_pay,<!--- Kesinti İsmi --->
                comment_get_id : get_interruption.odkes_id,<!---Kesinti Id --->
                amount_get : attributes.employee_health_amount,<!--- kesitni ücreti --->
                total_get : attributes.employee_health_amount,<!--- kesitni ücreti --->
                period_get : get_interruption.period_pay, <!--- 1: ayda 1, 2 : 3 ayda 1 , 3 : 6 ayda 1, 4 : yılda 1---> 
                method_get : get_interruption.method_pay,  <!--- 1: eksi, 2 : ay , 3 : gün, 4 : saat---> 
                show : get_interruption.show,  <!--- bordroda görünsün ---> 
                start_sal_mon : attributes.sal_mon,<!--- Başlangıç Ayı --->
                end_sal_mon : attributes.sal_mon,<!--- Bitiş Ayı --->
                employee_id : attributes.EXPENSE_EMPLOYEE_ID,<!--- çalışan id --->
                term : attributes.sal_year,<!--- yıl --->
                calc_days : get_interruption.calc_days,<!---tutar günü 0 : tümü, 1: gün,2 : fiili gün --->
                from_salary : get_interruption.from_salary, <!--- 0 :net,1 : brüt --->
                in_out_id : get_in_out_id.in_out_id,<!--- Giriş çıkış id --->
                is_inst_avans : get_interruption.is_inst_avans,<!--- Taksitlendirilmiş Avans --->
                is_ehesap : get_interruption.is_ehesap,<!--- üst düzey ik yetkisi 1 : dahi, 0 :dahil değil--->
                money : get_interruption.MONEY,<!--- Para birimi--->
                tax : get_interruption.tax<!--- vergi 1 : muaf, 2: muaf değil--->
            )>
        </cfif>
    <cfelse>
        Bordro akış parametrelerinde Kesinti tanımı eksik
    </cfif>
    <cfelse>
        Anlaşmalı Kurum Değil
    </cfif>
<cfelse>
    Bordro akış parametrelerinde sağlık tanımları eksik . Lütfen tanımlayınız.
</cfif>
</cflock>
<script type="text/javascript">
    alert("Harcama Onaylandı");
    window.location.href = "<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.health_expense_approve&event=upd&health_id=#attributes.health_id#</cfoutput>";
</script>