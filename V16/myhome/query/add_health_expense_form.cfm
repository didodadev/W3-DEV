<cfparam name="attributes.tax_value" default="">
<cfparam name="attributes.expense_amount" default="">
<cfif attributes.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='29456.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı.\rMuhasebe Döneminizi Kontrol Ediniz'>");
		history.back();
	</script>
	<cfabort>
</cfif>
<cf_date tarih = 'attributes.expense_date'>
<cf_date tarih = 'attributes.process_date'>
<cf_date tarih = 'attributes.invoice_date'>
<cf_papers paper_type="health_allowence_expense">
<cfset attributes.acc_type_id = "">
<cfif isdefined("attributes.ch_member_type") and len(attributes.ch_member_type) and isDefined('attributes.ch_company') and len(attributes.ch_company)>
    <cfif isDefined('attributes.emp_id') and len(attributes.emp_id)>
        <cfset attributes.acc_type_id = listlast(attributes.emp_id,'_')>
        <cfset attributes.emp_id = listfirst(attributes.emp_id,'_')>
    <cfelseif isdefined('attributes.ch_partner_id') and len(attributes.ch_partner_id)>
        <cfset attributes.acc_type_id = listlast(attributes.ch_partner_id,'_')>
        <cfset attributes.ch_partner_id = listfirst(attributes.ch_partner_id,'_')>
    </cfif>
</cfif>
<cfset attributes.expense_employee_id = listfirst(attributes.expense_employee_id,'_')>
<cfif isDefined('attributes.assurance_id') and len(attributes.assurance_id)>
    <cfset attributes.assurance_type_id = listlast(attributes.assurance_id,'_')>
    <cfset attributes.assurance_id = listfirst(attributes.assurance_id,'_')>
<cfelse>
    <cfset attributes.assurance_type_id = "">
</cfif>
<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
    <cfset branch_id_ = attributes.branch_id>
<cfelseif listFirst(attributes.fuseaction,'.') eq 'myhome'>
    <cfset branch_id_ = listlast(session.ep.user_location,'-')>
<cfelse>
    <cfset branch_id_ = ''>
</cfif>
<cfif isdefined("attributes.x_acc_type") and len(attributes.x_acc_type)>
    <cfset acc_type_id_ = attributes.x_acc_type>
<cfelse>
    <cfset acc_type_id_ = 0>
</cfif>  
<cfif not isDefined("attributes.interrupt") or not len(attributes.interrupt)>
    <cfset attributes.interrupt  = 0>
</cfif>
<cflock timeout="60" name="#CreateUUID()#">
    <cftransaction>	
        <cfquery datasource="#dsn2#" result="MAX_ID">
            INSERT INTO
                EXPENSE_ITEM_PLAN_REQUESTS
            (
                PAPER_NO,
                EMP_ID,
                EXPENSE_DATE,
                PROCESS_DATE,
                DETAIL,
                RECORD_DATE,
                RECORD_EMP,
                RECORD_IP,
                EXPENSE_STAGE,
                BRANCH_ID,
                DEPARTMENT_ID,
                TOTAL_AMOUNT,
                TREATED,
                NET_KDV_AMOUNT,
                NET_TOTAL_AMOUNT,
                MONEY,
                ASSURANCE_ID,
                TREATMENT_ID,
                RELATIVE_ID,
                PAPER_TYPE,
                SYSTEM_RELATION,
                OUR_COMPANY_HEALTH_AMOUNT,
                EMPLOYEE_HEALTH_AMOUNT,
                EXPENSE_ITEM_PLANS_ID,
                PROCESS_CAT,
                MEMBER_TYPE,
                COMPANY_ID,
                PARTNER_ID,
                CONSUMER_ID,
                ACC_TYPE_ID,
                INVOICE_NO,
                INVOICE_DATE,
                EXPENSE_TYPE,
                TREATMENT_AMOUNT,
                TREATMENT_AMOUNT_RATE,
                COMPANY_AMOUNT_RATE,
                COMPANY_NAME,
                ASSURANCE_TYPE_ID,
                AMOUNT_1,
                AMOUNT_2,
                AMOUNT_3,
                AMOUNT_KDV_1,
                AMOUNT_KDV_2,
                AMOUNT_KDV_3,
                AMOUNT_4,
                AMOUNT_KDV_4,
                PAYMENT_INTERRUPTION_VALUE
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_employee_id#">,  
                <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.expense_date#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.process_date#">,
                <cfif isDefined("attributes.reason_ill") and len(attributes.reason_ill)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.reason_ill#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">,
                <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"><cfelseif listFirst(attributes.fuseaction,'.') eq 'myhome'>#listlast(session.ep.user_location,'-')#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.department_id") and len(attributes.department_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#"><cfelseif listFirst(attributes.fuseaction,'.') eq 'myhome'>#listfirst(session.ep.user_location,'-')#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.expense_amount") and len(attributes.expense_amount)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.expense_amount#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.is_relative") and len(attributes.is_relative)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_relative#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.tax_value") and len(attributes.tax_value)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.tax_value#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.lastTotal") and len(attributes.lastTotal)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.lastTotal#"><cfelse>NULL</cfif>,
                <cfif isDefined("attributes.moneyType") and len(attributes.moneyType)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.moneyType#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.assurance_id") and len(attributes.assurance_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assurance_id#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.treatment_id") and len(attributes.treatment_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.treatment_id#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.relative_id") and len(attributes.relative_id)  and attributes.relative_id neq 0 and attributes.is_relative eq 2><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.relative_id#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.expense_paper_type") and len(attributes.expense_paper_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.expense_paper_type#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.system_relation") and len(attributes.system_relation)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.system_relation#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.our_company_health_amount") and len(attributes.our_company_health_amount)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.our_company_health_amount#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.employee_health_amount") and len(attributes.employee_health_amount)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.employee_health_amount#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.expense_id") and len(attributes.expense_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.PROCESS_CAT") and len(attributes.PROCESS_CAT)> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PROCESS_CAT#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.ch_member_type") and len(attributes.ch_member_type) and attributes.ch_member_type eq 'partner'>
                    'partner',
					<cfif len(attributes.ch_company) and len(attributes.ch_company_id)>#attributes.ch_company_id#<cfelse>NULL</cfif>,
					<cfif len(attributes.ch_company) and len(attributes.ch_partner_id)>#attributes.ch_partner_id#<cfelse>NULL</cfif>,
					NULL,
                    NULL,
				<cfelseif isdefined("attributes.ch_member_type") and len(attributes.ch_member_type) and attributes.ch_member_type eq 'consumer'>
                    'consumer',
					NULL,
					NULL,
					<cfif len(attributes.ch_company) and len(attributes.ch_partner_id)>#attributes.ch_partner_id#<cfelse>NULL</cfif>,
                    <cfif len(attributes.ch_company) and len(attributes.acc_type_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.acc_type_id#"><cfelse>NULL</cfif>,
				<cfelseif isdefined("attributes.ch_member_type") and len(attributes.ch_member_type) and attributes.ch_member_type eq 'employee'>
                    'employee',
					NULL,
					<cfif len(attributes.ch_company) and len(attributes.emp_id)>#attributes.emp_id#<cfelse>NULL</cfif>,
					NULL,
                    <cfif len(attributes.ch_company) and len(attributes.acc_type_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.acc_type_id#"><cfelse>NULL</cfif>,
				<cfelse>
                    NULL,
					NULL,
					NULL,
					NULL,
                    NULL,
				</cfif>
                <cfif isdefined("attributes.serial_number") and len(attributes.serial_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.serial_number#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.invoice_date") and len(attributes.invoice_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.invoice_date#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.expense_type") and len(attributes.expense_type)> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_type#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.TreatmentlastTotal") and len(attributes.TreatmentlastTotal)> <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.TreatmentlastTotal#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.treatment_rate") and len(attributes.treatment_rate)> <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.treatment_rate#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.comp_health_rate") and len(attributes.comp_health_rate)> <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.comp_health_rate#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.expense_comp_name") and len(attributes.expense_comp_name)> <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.expense_comp_name#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.assurance_type_id") and len(attributes.assurance_type_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assurance_type_id#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.amount_1") and len(attributes.amount_1)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.amount_1#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.amount_2") and len(attributes.amount_2)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.amount_2#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.amount_3") and len(attributes.amount_3)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.amount_3#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.amount_kdv_1") and len(attributes.amount_kdv_1)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.amount_kdv_1#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.amount_kdv_2") and len(attributes.amount_kdv_2)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.amount_kdv_2#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.amount_kdv_3") and len(attributes.amount_kdv_3)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.amount_kdv_3#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.amount_4") and len(attributes.amount_4)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.amount_4#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.amount_kdv_4") and len(attributes.amount_kdv_4)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.amount_kdv_4#"><cfelse>NULL</cfif>,
                <cfif isdefined("attributes.interrupt") and len(attributes.interrupt)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.interrupt#"><cfelse>NULL</cfif>
            )
        </cfquery>
        <CFSET attributes.health_id = max_id.identitycol>
        <cfset paper_num = listLast(attributes.paper_number,"-")>
        <cfif len(paper_num)>
            <cfquery name="UPD_GENERAL_PAPERS" datasource="#DSN2#">
                UPDATE 
                    #dsn_alias#.GENERAL_PAPERS_MAIN
                SET
                    HEALTH_ALLOWENCE_EXPENSE_NUMBER = #paper_num#
                WHERE
                    HEALTH_ALLOWENCE_EXPENSE_NUMBER IS NOT NULL
            </cfquery>
        </cfif>
        <cfscript>
            if(isdefined("attributes.process_date") and len(attributes.process_date))
                attributes.expense_date = attributes.process_date;// işlem tarihi üzerinden hareketler yaptırılıyor
        </cfscript>
    </cftransaction>
</cflock>
<cfif  listFirst(attributes.fuseaction,'.') eq 'hr'>
<cfset attributes.sal_mon = month(attributes.EXPENSE_DATE)>
<cfset attributes.sal_year = year(attributes.EXPENSE_DATE)>
<cfset allowance_expense_cmp = createObject("component","V16.myhome.cfc.allowance_expense") /><!--- Ek Ödenek --->
<cfset get_in_out_id  = allowance_expense_cmp.GET_IN_OUT_ID(attributes.EXPENSE_EMPLOYEE_ID,0)><!--- In out Id --->
 <!---Çalışanın grup id'si varsa program akış parametrelerine gönderilir.---->
<cfif len(get_in_out_id.PUANTAJ_GROUP_IDS)>
    <cfset attributes.group_id = get_in_out_id.PUANTAJ_GROUP_IDS>
</cfif>
<cfinclude template="/V16/hr/ehesap/query/get_program_parameter.cfm">
<cfset get_payments_cmp = createObject("component","V16.hr.ehesap.cfc.get_payments") /><!--- Ödenek Tanımları --->
<cfset get_health_cmp = createObject("component","V16.myhome.cfc.health_expense") /><!--- Gider Kalemi/gelir kalemi/ Muhasebe kodu, harcama fişi upd --->
<cfif get_in_out_id.recordcount and len(get_in_out_id.IN_COMPANY_REASON_ID)><!--- Vefat gerekçe id yani çalışan vefat eden bir çalışansa --->
    <cfif isdefined("attributes.x_decease_reason") and len(attributes.x_decease_reason) and attributes.x_decease_reason eq get_in_out_id.IN_COMPANY_REASON_ID>
        <cfset is_decease = 1>
    </cfif>
<cfelseif  get_in_out_id.recordcount and len(get_in_out_id.finish_date)>
    <cfset is_decease = 1>
</cfif>
<!---
 <cfif not get_in_out_id.recordcount or not len(get_in_out_id.in_out_id)>
    <script>
        alert('Çalışan Girişi Yapılmamış');
        history.back();
    </script>
    <cfabort>
</cfif>
--->
<cfif isdefined("attributes.expense_id") and len(attributes.expense_id)>
    <cfset GET_EXPENSE_ROWS = get_health_cmp.GET_EXPENSE_ROWS( health_id : attributes.expense_id)/><!---Fişin Kdv değeri çekilecek--->
    <cfif GET_EXPENSE_ROWS.recordcount>
        <cfset kdv_rates = valuelist(GET_EXPENSE_ROWS.KDV_RATE)>
    </cfif>
<cfelse>    
    <cfset GET_EXPENSE_ROWS.recordcount = 0>
</cfif>
<cfif len(attributes.process_cat)>
    <cfset get_process_type = get_health_cmp.GetProcesssCat(process_cat : attributes.process_cat)>
    <cfscript>
        process_type = get_process_type.PROCESS_TYPE;
        is_cari = get_process_type.IS_CARI;
        is_account = get_process_type.IS_ACCOUNT;
        is_budget = get_process_type.IS_BUDGET;
        is_allowance_deduction = get_process_type.IS_ALLOWANCE_DEDUCTION;
        is_deduction = get_process_type.IS_DEDUCTION;
        if(not len(is_allowance_deduction))
            is_allowance_deduction = 0;
        if(not len(is_deduction))
            is_deduction = 0;
    </cfscript>
<cfelse>    
    <cfscript>
        is_cari = 0;
        is_account = 0;
        is_budget = 0;
        is_allowance_deduction = 0;
        is_deduction = 0; 
    </cfscript>
</cfif>
<cfset delete_health_pay = allowance_expense_cmp.DELETE_SALARYPARAM_PAY_FROM_HEALTH_ID(expense_health_id : attributes.health_id)>
<cfset delete_health_get = allowance_expense_cmp.DELETE_SALARYPARAM_GET_FROM_HEALTH_ID(expense_health_id : attributes.health_id)>
    <!--- Anlaşmasız ise  --->
    <cfif isdefined("get_program_parameters.salaryparam_pay_id") and len(get_program_parameters.salaryparam_pay_id) and isdefined("get_program_parameters.expense_item_id") and len(get_program_parameters.expense_item_id) and isdefined("get_program_parameters.EXPENSE_CENTER_ID") and len(get_program_parameters.EXPENSE_CENTER_ID) and not isdefined("attributes.ch_company")>
        <!--- Çalışan Yakını ise --->
        <cfif attributes.is_relative eq 2 and len(get_program_parameters.salaryparam_pay_id_relative)>
            <cfset get_payments = get_payments_cmp.SETUP_PAYMENT_INTERRUPTION(odkes_id : get_program_parameters.salaryparam_pay_id_relative)><!--- Ödenek Bilgileri --->
        <!--- Çalışan Kendisi ise --->
        <cfelseif attributes.is_relative eq 1>
            <cfset get_payments = get_payments_cmp.SETUP_PAYMENT_INTERRUPTION(odkes_id : get_program_parameters.salaryparam_pay_id)><!--- Ödenek Bilgileri --->
        <cfelse>
            <cfset get_payments.recordcount = 0> 
        </cfif>
         <!--- Çalışan Kesinti ve Ödenek İşlemi Bordroya Yansır ve çalışan kendisi ise veya Çalışan Yakını Kesinti ve Ödenek İşlemi Bordroya Yansır seçili ise ve çalışan yakını ise ERU ---> 
        <cfset corparate_health_amount = (attributes.lastTotal - (attributes.employee_health_amount + attributes.interrupt))>
        <cfif not isdefined("is_decease") and ((isdefined("attributes.x_is_employee_relative_payment") and attributes.x_is_employee_relative_payment eq 1 and attributes.is_relative eq 2) or (isdefined("attributes.x_is_employee_payment") and attributes.x_is_employee_payment eq 1 and attributes.is_relative eq 1)) and  get_payments.recordcount and (is_allowance_deduction eq 1 or is_deduction eq 1) and corparate_health_amount neq 0> 
            <cfif is_allowance_deduction eq 1>
                <cfset get_allowance_expense = allowance_expense_cmp.ADD_SALARYPARAM_PAY(
                    comment_pay :  get_payments.comment_pay,<!--- Ödenek İsmi --->
                    comment_pay_id : get_payments.odkes_id,<!---Ödenek Id --->
                    amount_pay : corparate_health_amount,<!--- Ödenek (Kurum Payı) --->
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
                    comment_type : get_payments.comment_type,<!--- 1: ek ödenek, 2: kazanc --->
                    expense_health_id : attributes.health_id <!--- Sağlık harcaması ID --->
                    ) /> 
            </cfif>
            <cfif len(get_program_parameters.PAYMENT_INTERRUPTION_ID) and is_deduction eq 1><!--- bordro akış parametrelerinde Kesinti tanımlanışsa --->
                <cfset interruption_id = get_program_parameters.PAYMENT_INTERRUPTION_ID><!--- Kesinti id--->
                <cfset get_interruption = get_payments_cmp.SETUP_PAYMENT_INTERRUPTION(odkes_id : interruption_id)><!--- Kesinti Bilgileri --->
                <cfif get_interruption.recordcount>
                    <cfset add_interruption = allowance_expense_cmp.ADD_SALARYPARAM_GET(
                        comment_get : get_interruption.comment_pay,<!--- Kesinti İsmi --->
                        comment_get_id : get_interruption.odkes_id,<!---Kesinti Id --->
                        amount_get : corparate_health_amount,<!--- kesitni ücreti --->
                        total_get : corparate_health_amount,<!--- kesitni ücreti --->
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
                        tax : get_interruption.tax,<!--- vergi 1 : muaf, 2: muaf değil--->
                        expense_health_id : attributes.health_id
                    )>
                </cfif>
            </cfif>
        <!--- Çalışan Kesinti ve Ödenek İşlemi Bordroya Yansır hayır seçili ve çalışan kendisi ise veya Çalışan Yakını Kesinti ve Ödenek İşlemi Bordroya Yansır hayır seçili ise ve çalışan yakını ise ---> 
        <cfelseif (isdefined("attributes.x_is_employee_relative_payment") and attributes.x_is_employee_relative_payment eq 0 and attributes.is_relative eq 2) or (isdefined("attributes.x_is_employee_payment") and attributes.x_is_employee_payment eq 0 and attributes.is_relative eq 1)>
            <cfscript>
                cari_sil(action_id:attributes.health_id,process_type:2503,cari_db : dsn2);
                if(is_cari eq 1)
				{
                    carici(
                        action_id : attributes.health_id,
                        action_table : 'EXPENSE_ITEM_PLAN_REQUESTS',
                        islem_belge_no : attributes.paper_number,
                        workcube_process_type : 2503,	
                        process_cat : attributes.PROCESS_CAT,
                        islem_tarihi : attributes.EXPENSE_DATE,
                        action_detail : '#attributes.paper_number# #getLang("objects",1316,"sağlık harcaması")#',
                        islem_tutari : attributes.OUR_COMPANY_HEALTH_AMOUNT,
                        other_money_value : attributes.OUR_COMPANY_HEALTH_AMOUNT,
                        action_currency : session.ep.money,
                        acc_type_id : acc_type_id_,
                        currency_multiplier : '',
                        account_card_type : 13,
                        islem_detay : '#attributes.paper_number# #getLang("objects",1316,"sağlık harcaması")#',
                        due_date: attributes.EXPENSE_DATE,
                        from_branch_id : branch_id_,
                        from_employee_id : attributes.expense_employee_id,
                        rate2:'',
                        cari_db : dsn2
                        );
                }
            </cfscript>
        </cfif>
        <!--- Limit Aşımı Kesinti tanımları yapılmışsa işlem kategorilerinden kesinti işlemi yapılsın seçildiyse ve xml den evet seçildiysa ---->
        <cfif len(get_program_parameters.LIMIT_INTERRUPTION_ID) and is_deduction eq 1 and attributes.x_is_limit_interruption eq 1 and attributes.interrupt neq 0>
            <cfset limit_interruption_id = get_program_parameters.LIMIT_INTERRUPTION_ID><!--- Kesinti id--->
            <cfset get_interruption_limit = get_payments_cmp.SETUP_PAYMENT_INTERRUPTION(odkes_id : limit_interruption_id)><!--- Kesinti Bilgileri --->
            <cfif get_interruption_limit.recordcount>
                <cfif get_interruption_limit.recordcount>  
                    <cfset add_interruption = allowance_expense_cmp.ADD_SALARYPARAM_GET(
                        comment_get : get_interruption_limit.comment_pay,<!--- Kesinti İsmi --->
                        comment_get_id : get_interruption_limit.odkes_id,<!---Kesinti Id --->
                        amount_get : attributes.interrupt,<!--- kesitni ücreti --->
                        total_get : attributes.interrupt,<!--- kesitni ücreti --->
                        period_get : get_interruption_limit.period_pay, <!--- 1: ayda 1, 2 : 3 ayda 1 , 3 : 6 ayda 1, 4 : yılda 1---> 
                        method_get : get_interruption_limit.method_pay,  <!--- 1: eksi, 2 : ay , 3 : gün, 4 : saat---> 
                        show : get_interruption_limit.show,  <!--- bordroda görünsün ---> 
                        start_sal_mon : attributes.sal_mon,<!--- Başlangıç Ayı --->
                        end_sal_mon : attributes.sal_mon,<!--- Bitiş Ayı --->
                        employee_id : attributes.EXPENSE_EMPLOYEE_ID,<!--- çalışan id --->
                        term : attributes.sal_year,<!--- yıl --->
                        calc_days : get_interruption_limit.calc_days,<!---tutar günü 0 : tümü, 1: gün,2 : fiili gün --->
                        from_salary : get_interruption_limit.from_salary, <!--- 0 :net,1 : brüt --->
                        in_out_id : get_in_out_id.in_out_id,<!--- Giriş çıkış id --->
                        is_inst_avans : get_interruption_limit.is_inst_avans,<!--- Taksitlendirilmiş Avans --->
                        is_ehesap : get_interruption_limit.is_ehesap,<!--- üst düzey ik yetkisi 1 : dahi, 0 :dahil değil--->
                        money : get_interruption_limit.MONEY,<!--- Para birimi--->
                        tax : get_interruption_limit.tax,<!--- vergi 1 : muaf, 2: muaf değil--->
                        expense_health_id : attributes.health_id
                    )>
                </cfif>
            </cfif>
        </cfif>
        <cfset get_acc_code = get_health_cmp.GET_ACC_CODE(expense_item_id : get_program_parameters.EXPENSE_ITEM_ID)/><!---Bütçe kaleminin muhasebe kodu--->
        <cfscript>
            row_detail = '#session.ep.period_year# #attributes.sal_mon#.Ay - Sağlık Harcaması';
            if(is_budget eq 1){
                butce_sil(action_id:attributes.health_id,process_type:2503);
                butceci(
                    action_id : attributes.health_id,
                    is_income_expense : 'false',
                    process_type : 2503,
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
            }
            if(is_account eq 1){
                if(isdefined("attributes.relative_id") and len(attributes.relative_id)  and attributes.relative_id neq 0){ 
                    //anlaşmasız yakını ise
                     if(x_is_employee_amount eq 0)  
                        corparate_health_amount = (attributes.lastTotal - (attributes.employee_health_amount + attributes.interrupt));
                    else
                        corparate_health_amount = (attributes.lastTotal - (attributes.employee_health_amount + attributes.interrupt));

                    borc_hesaplar_list = get_program_parameters.HEALTH_ACCOUNT_CODE; // bordro yakın ??? 
                    borc_tutarlar_list = corparate_health_amount; //
                    alacak_hesaplar_list = get_program_parameters.employee_ACCOUNT_CODE; // çalışandan çekmek yerine bordro akış parametrelerine eklendi
                    if(len(get_program_parameters.LIMIT_INTERRUPTION_ACCOUNT_CODE) and is_deduction eq 1 and attributes.x_is_limit_interruption eq 1){
                        alacak_tutarlar_list = corparate_health_amount + attributes.interrupt;
                        other_amount_alacak_list = corparate_health_amount + attributes.interrupt;
                    }
                    else{
                        alacak_tutarlar_list = corparate_health_amount;
                        other_amount_alacak_list = corparate_health_amount;
                    }
                    other_amount_borc_list = corparate_health_amount;
                    other_currency_borc_list = session.ep.money;
                    other_currency_alacak_list = session.ep.money;
                }
                else{ // anlaşmasız kendisi ise
                   if(not len(attributes.tax_value)) {attributes.tax_value = 0};
                    
                        //Çalışana Kesilen Faturadan KDV indirimi yapılır
                        if(isdefined("attributes.x_kdv_inpterrupt") and attributes.x_kdv_inpterrupt eq 1)
                        {
                            if(x_is_employee_amount eq 0)  
                                corparate_health_amount = (attributes.lastTotal - (attributes.employee_health_amount + attributes.interrupt));
                            else
                                corparate_health_amount = (attributes.lastTotal - (attributes.employee_health_amount + attributes.interrupt));

                            if(len(attributes.lasttotal) and attributes.lasttotal neq 0)
                                taxVal = corparate_health_amount * attributes.tax_value/attributes.lasttotal;
                            else
                                taxVal = 0;
                            alacakValue1 =corparate_health_amount - taxVal; 
    
                            alacak_hesaplar_list =  get_program_parameters.EMployee_ACCOUNT_CODE; //  bordro gider kaleminin muhasebe hesabı 770 
                            if(len(get_program_parameters.LIMIT_INTERRUPTION_ACCOUNT_CODE) and is_deduction eq 1 and attributes.x_is_limit_interruption eq 1){
                                alacak_tutarlar_list = corparate_health_amount + attributes.interrupt;
                                other_amount_alacak_list = corparate_health_amount + attributes.interrupt;
                            }
                            else{
                                alacak_tutarlar_list = corparate_health_amount;
                                other_amount_alacak_list = corparate_health_amount;
                            }
                            borc_hesaplar_list = get_Acc_code.ACCOUNT_CODE; // çalışandan çekmek yerine bordro akış parametrelerine eklendi
                            borc_tutarlar_list = alacakValue1; //
                            other_currency_alacak_list = session.ep.money;
                            other_amount_borc_list = alacakValue1;
                            other_currency_borc_list = session.ep.money;

                            for(kdv=1; kdv<=4 ;kdv++){
                                if(evaluate('attributes.amount_kdv_#kdv#') neq 0){
                                    //KDV'li tutarı, KDV Oranını ve Tutarı alır ERU
                                    kdv_amaunt = evaluate('attributes.amount_kdv_#kdv#');// KDV'li tutar
                                    kdv_val = evaluate('attributes.kdv_#kdv#');//KDV oranı
                                    amount_without_kdv = evaluate('attributes.amount_#kdv#'); //Tutar
                                    //KDV oranlarına göre indirilecek KDV Hesabı
                                    if(len(attributes.lastTotal) and attributes.lastTotal neq 0)
                                        calc_amount = (amount_without_kdv * kdv_val / 100) * (corparate_health_amount / attributes.lastTotal);
                                    else
                                        calc_amount = 0;
                                    get_tax_acc_code = get_health_cmp.GET_ACC_CODE_KDV(kdv_rate : kdv_val);//KDV'nin muhasebe kodu
                                    borc_hesaplar_list = ListAppend(borc_hesaplar_list, get_tax_acc_code.PURCHASE_CODE, ",");// kdv alış hesabı
                                    borc_tutarlar_list = ListAppend(borc_tutarlar_list, calc_amount, ",");
                                    other_amount_borc_list = ListAppend(other_amount_borc_list, calc_amount , ",");
                                    other_currency_borc_list = ListAppend(other_currency_borc_list, session.ep.money, ",");
                                }
                            }
                        }
                        else
                        {
                            if(x_is_employee_amount eq 0)  
                                corparate_health_amount = (attributes.lastTotal - (attributes.employee_health_amount + attributes.interrupt));
                            else
                                corparate_health_amount = (attributes.lastTotal - (attributes.employee_health_amount + attributes.interrupt));
                           
                            alacak_hesaplar_list =  get_program_parameters.EMployee_ACCOUNT_CODE; //  bordro gider kaleminin muhasebe hesabı 770 
                            if(len(get_program_parameters.LIMIT_INTERRUPTION_ACCOUNT_CODE) and is_deduction eq 1 and attributes.x_is_limit_interruption eq 1){
                                alacak_tutarlar_list = corparate_health_amount + attributes.interrupt;
                                other_amount_alacak_list = corparate_health_amount + attributes.interrupt;
                            }
                            else{
                                alacak_tutarlar_list = corparate_health_amount;
                                other_amount_alacak_list = corparate_health_amount;
                            }
                            borc_hesaplar_list = get_Acc_code.ACCOUNT_CODE; // çalışandan çekmek yerine bordro akış parametrelerine eklendi
                            borc_tutarlar_list = corparate_health_amount; 
                            other_amount_borc_list = corparate_health_amount;
                            other_currency_borc_list = session.ep.money;
                            other_currency_alacak_list = session.ep.money;
                            other_amount_borc_list = corparate_health_amount;
                            other_currency_borc_list = session.ep.money;
                        }
                }
                //Limit aşımı kesinti
                if(len(get_program_parameters.LIMIT_INTERRUPTION_ACCOUNT_CODE) and is_deduction eq 1 and attributes.x_is_limit_interruption eq 1)
                {
                    borc_hesaplar_list = ListAppend(borc_hesaplar_list, get_program_parameters.LIMIT_INTERRUPTION_ACCOUNT_CODE, ","); // Çalışan hesabından çekilmesi yerine(çoklu cari tipi) bordro akış parametrelerine eklendi ÇALIŞAN KESIBTI HESABI
                    borc_tutarlar_list = ListAppend(borc_tutarlar_list, attributes.interrupt, ",");
                    other_amount_borc_list = ListAppend(other_amount_borc_list, attributes.interrupt , ",");
                    other_currency_borc_list = ListAppend(other_currency_borc_list, session.ep.money, ",");
                }
               
                GET_NO_ = cfquery(datasource:"#dsn2#", sqlstring:"SELECT * FROM #dsn3_alias#.SETUP_INVOICE_PURCHASE");
							//muhasebe fisi icin, olusabilecek yuvarlama satırının bilgileri
							str_fark_gelir =GET_NO_.FARK_GELIR;
							str_fark_gider =GET_NO_.FARK_GIDER;
							str_max_round = 0.9;
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
                    alacak_hesaplar: alacak_hesaplar_list,
                    alacak_tutarlar: alacak_tutarlar_list,
                    dept_round_account :str_fark_gider,
					claim_round_account : str_fark_gelir,
					max_round_amount :str_max_round,
                    other_amount_alacak : other_amount_alacak_list,
                    other_currency_alacak : other_currency_alacak_list,
                    fis_detay:'Sağlık Harcaması',
                    fis_satir_detay:'Sağlık Harcaması',
                    workcube_process_cat : attributes.PROCESS_CAT		
                    );
                }
        </cfscript>	
    <cfelseif isdefined("get_program_parameters.salaryparam_pay_id") and len(get_program_parameters.salaryparam_pay_id) and isdefined("get_program_parameters.expense_item_id") and len(get_program_parameters.expense_item_id) and isdefined("get_program_parameters.EXPENSE_CENTER_ID") and len(get_program_parameters.EXPENSE_CENTER_ID) and isdefined("attributes.ch_company")>
        <!--- Anlaşmalı kurum ise  --->
        <cfif isDefined("attributes.expense_id") and len(attributes.expense_id)>
            <cfset get_acc_code = get_health_cmp.GET_ACC_CODE(expense_item_id : get_program_parameters.EXPENSE_ITEM_ID)/><!---Bütçe kaleminin muhasebe kodu--->
            <cfif attributes.ch_member_type eq 'partner'>
                <cfset get_acc_code_ch = get_health_cmp.GET_ACC_CODE_CH(company_id : attributes.ch_company_id)/><!---Anlaşmalı Kurumun satış hesabı--->
            <cfelseif attributes.ch_member_type eq 'consumer'>
                <cfset get_acc_code_ch = get_health_cmp.GET_ACC_CODE_CONSUMER(consumer_id : attributes.ch_partner_id)/>
            <cfelseif attributes.ch_member_type eq 'employee'>
                <cfset get_acc_code_ch = get_health_cmp.GET_ACC_CODE_EMPLOYEE_IN_OUT(employee_id : attributes.emp_id)/>
            </cfif>
                <cfscript>
                    row_detail = '#session.ep.period_year# #attributes.sal_mon#.Ay - Sağlık Harcaması';
                      /*  if(is_budget eq 1){
                        butce_sil(action_id:attributes.health_id,process_type:2503);
                        butceci(
                            action_id : attributes.health_id,
                            is_income_expense : 'false',
                            process_type : 2503,
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
                    }*/
                </cfscript>
                <cfscript>
                    if(is_account eq 1){
                    if(isdefined("attributes.relative_id") and len(attributes.relative_id) and attributes.relative_id neq 0){ 
                        if(x_is_employee_amount eq 0)  
                                corparate_health_amount = (attributes.lastTotal - (attributes.employee_health_amount + attributes.interrupt));
                            else
                                corparate_health_amount = attributes.lastTotal - attributes.interrupt;

                        // ÇALIŞAN YAKINI İSE ve anlaşmalı
                        alacak_hesaplar_list = get_acc_code_ch.account_code; //anlaşmalı kurum muhasebe hesabı
                        if(len(get_program_parameters.LIMIT_INTERRUPTION_ACCOUNT_CODE) and is_deduction eq 1 and attributes.x_is_limit_interruption eq 1){
                            alacak_tutarlar_list = attributes.lasttotal; // genel toplam
                            other_amount_alacak_list = attributes.lasttotal;
                        }
                        else{
                            alacak_tutarlar_list = attributes.lasttotal - attributes.interrupt; // genel toplam
                            other_amount_alacak_list = attributes.lasttotal - attributes.interrupt;
                        }
                        other_currency_alacak_list = session.ep.money;

                        borc_hesaplar_list = get_program_parameters.HEALTH_ACCOUNT_CODE; // çalışan yakını gider kalemi muhasebe kodu
                        borc_tutarlar_list = corparate_health_amount;
                        other_amount_borc_list =  corparate_health_amount;
                        other_currency_borc_list = session.ep.money;

                        /* if(isdefined("attributes.employee_health_amount") and len(attributes.employee_health_amount)){
                            if(x_is_employee_amount eq 0)
                                interrupt_calc = attributes.employee_health_amount + attributes.interrupt; 
                            else   
                                interrupt_calc = attributes.interrupt;
                            borc_hesaplar_list = ListAppend(borc_hesaplar_list, get_program_parameters.PAYMENT_ACCOUNT_CODE, ","); // Çalışan hesabından çekilmesi yerine(çoklu cari tipi) bordro akış parametrelerine eklendi
                            borc_tutarlar_list = ListAppend(borc_tutarlar_list, interrupt_calc, ",");
                            other_amount_borc_list = ListAppend(other_amount_borc_list, interrupt_calc , ",");
                            other_currency_borc_list = ListAppend(other_currency_borc_list, session.ep.money, ",");
                        } */
                    }
                    else{ // anlaşmalı kurum ve kendisi
                        alacak_hesaplar_list = get_acc_code_ch.account_code; //anlaşmalı kurum muhasebe hesabı
                        if(len(get_program_parameters.LIMIT_INTERRUPTION_ACCOUNT_CODE) and is_deduction eq 1 and attributes.x_is_limit_interruption eq 1){
                            alacak_tutarlar_list = attributes.lasttotal; // genel toplam
                            other_amount_alacak_list = attributes.lasttotal;
                        }
                        else{
                            alacak_tutarlar_list = attributes.lasttotal - attributes.interrupt; // genel toplam
                            other_amount_alacak_list = attributes.lasttotal - attributes.interrupt;
                        }
                        other_currency_alacak_list = session.ep.money;

                        if(x_is_employee_amount eq 0)  
                            corparate_health_amount = (attributes.lastTotal - (attributes.employee_health_amount + attributes.interrupt));
                        else
                            corparate_health_amount = attributes.lastTotal - attributes.interrupt;
    
                        if(not len(attributes.tax_value)) {attributes.tax_value = 0};

                        if(attributes.tax_value neq 0 and len(attributes.tax_value)){
                            if(len(attributes.lasttotal) and attributes.lasttotal neq 0)
                                borcValue1 = corparate_health_amount - (corparate_health_amount * attributes.tax_value / attributes.lasttotal); //kdvsiz harcama tutarı =Kurum payı-(kurum payı*kdv tutarı/fatura tutarı)
                            else
                                borcValue1 = 0;
                            borc_hesaplar_list = get_Acc_code.ACCOUNT_CODE; //  gider kalemi muhasebe kodu
                            borc_tutarlar_list = borcValue1;
                            other_amount_borc_list =  borcValue1;
                            other_currency_borc_list = session.ep.money;
                        }
                        else{
                            if(len(attributes.lasttotal) and attributes.lasttotal neq 0)
                                borcValue1 = corparate_health_amount - (corparate_health_amount * attributes.tax_value / attributes.lasttotal); //kdvsiz harcama tutarı =Kurum payı-(kurum payı*kdv tutarı/fatura tutarı)
                            else
                                borcValue1 = 0;
                            borc_hesaplar_list = get_Acc_code.ACCOUNT_CODE; //  gider kalemi muhasebe kodu
                            borc_tutarlar_list = borcValue1;
                            other_amount_borc_list =  borcValue1;
                            other_currency_borc_list = session.ep.money;
                        }
                        if(attributes.tax_value neq 0 and len(attributes.tax_value) and GET_EXPENSE_ROWS.recordcount){
                            for (row in get_expense_rows){
                                kdv_rate_ = row.kdv_rate;
                                if(len(attributes.lasttotal) and attributes.lasttotal neq 0 and len(attributes.tax_value) and attributes.tax_value neq 0){
                                    attributes.tax_value_ = (corparate_health_amount*attributes.tax_value)/attributes.lasttotal;
                                    attributes.tax_value_ = (attributes.tax_value_* row.amount_kdv)/attributes.tax_value;
                                }
                                else
                                    attributes.tax_value_ = 0;

                                get_tax_acc_code = get_health_cmp.GET_ACC_CODE_KDV(kdv_rate : kdv_rate_);
                                borc_hesaplar_list = ListAppend(borc_hesaplar_list, get_tax_acc_code.PURCHASE_CODE, ",");// kdv alış hesabı
                                borc_tutarlar_list = ListAppend(borc_tutarlar_list, attributes.tax_value_, ",");
                                other_amount_borc_list = ListAppend(other_amount_borc_list, attributes.tax_value_ , ",");
                                other_currency_borc_list = ListAppend(other_currency_borc_list, session.ep.money, ",");
                            }
                        }
                        //kesinti
                        /* if(isdefined("attributes.employee_health_amount") and len(attributes.employee_health_amount)){
                            if(x_is_employee_amount eq 0)
                                interrupt_calc = attributes.employee_health_amount + attributes.interrupt; 
                            else   
                                interrupt_calc = attributes.interrupt;
                            borc_hesaplar_list = ListAppend(borc_hesaplar_list, get_program_parameters.PAYMENT_ACCOUNT_CODE, ","); // Çalışan hesabından çekilmesi yerine(çoklu cari tipi) bordro akış parametrelerine eklendi ÇALIŞAN KESIBTI HESABI
                            borc_tutarlar_list = ListAppend(borc_tutarlar_list, interrupt_calc, ",");
                            other_amount_borc_list = ListAppend(other_amount_borc_list, interrupt_calc , ",");
                            other_currency_borc_list = ListAppend(other_currency_borc_list, session.ep.money, ",");
                        } */
                    }
                    //Limit aşımı kesinti
                    if(len(get_program_parameters.LIMIT_INTERRUPTION_ACCOUNT_CODE) and is_deduction eq 1 and attributes.x_is_limit_interruption eq 1)
                    {
                        borc_hesaplar_list = ListAppend(borc_hesaplar_list, get_program_parameters.LIMIT_INTERRUPTION_ACCOUNT_CODE, ","); // Çalışan hesabından çekilmesi yerine(çoklu cari tipi) bordro akış parametrelerine eklendi ÇALIŞAN KESIBTI HESABI
                        borc_tutarlar_list = ListAppend(borc_tutarlar_list, attributes.interrupt, ",");
                        other_amount_borc_list = ListAppend(other_amount_borc_list, attributes.interrupt , ",");
                        other_currency_borc_list = ListAppend(other_currency_borc_list, session.ep.money, ",");
                    }
                    GET_NO_ = cfquery(datasource:"#dsn2#", sqlstring:"SELECT * FROM #dsn3_alias#.SETUP_INVOICE_PURCHASE");
                    //muhasebe fisi icin, olusabilecek yuvarlama satırının bilgileri
                    str_fark_gelir =GET_NO_.FARK_GELIR;
                    str_fark_gider =GET_NO_.FARK_GIDER;
                    str_max_round = 0.9;
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
                        alacak_hesaplar: alacak_hesaplar_list,
                        alacak_tutarlar: alacak_tutarlar_list,
                        other_amount_alacak : other_amount_alacak_list,
                        other_currency_alacak : other_currency_alacak_list,
                        dept_round_account :str_fark_gider,
						claim_round_account : str_fark_gelir,
						max_round_amount :str_max_round,
                        fis_detay:'Sağlık Harcaması',
                        fis_satir_detay:'Sağlık Harcaması',
                        workcube_process_cat : attributes.PROCESS_CAT		
                        );
                    }
                </cfscript>
                <cfif len(get_program_parameters.PAYMENT_INTERRUPTION_ID)><!--- bordro akış parametrelerinde Kesinti tanımlanışsa --->
                    <cfset interruption_id = get_program_parameters.PAYMENT_INTERRUPTION_ID><!--- Kesinti id--->
                    <cfset get_interruption = get_payments_cmp.SETUP_PAYMENT_INTERRUPTION(odkes_id : interruption_id)><!--- Kesinti Bilgileri --->
                    <cfif get_interruption.recordcount>
                        <cfif attributes.x_is_employee_amount eq 1>
                            <cfset interrupt_amount = attributes.interrupt>
                        <cfelse>
                            <cfset interrupt_amount = attributes.interrupt + attributes.employee_health_amount>
                        </cfif>  
                        <cfif not isdefined("is_decease") and ((isdefined("attributes.x_is_employee_relative_payment") and attributes.x_is_employee_relative_payment eq 1 and attributes.is_relative eq 2) or (isdefined("attributes.x_is_employee_payment") and attributes.x_is_employee_payment eq 1 and attributes.is_relative eq 1)) and  get_interruption.recordcount and (is_deduction eq 1 or is_allowance_deduction eq 1) and interrupt_amount neq 0>
                            <cfif is_deduction eq 1>
                                <cfset add_interruption = allowance_expense_cmp.ADD_SALARYPARAM_GET(
                                    comment_get : get_interruption.comment_pay,<!--- Kesinti İsmi --->
                                    comment_get_id : get_interruption.odkes_id,<!---Kesinti Id --->
                                    amount_get : interrupt_amount,<!--- kesitni ücreti --->
                                    total_get : interrupt_amount,<!--- kesitni ücreti --->
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
                                    tax : get_interruption.tax,<!--- vergi 1 : muaf, 2: muaf değil--->
                                    expense_health_id : attributes.health_id
                                )>
                            </cfif>
                            <!--- Çalışan Yakını ise --->
                            <cfif attributes.is_relative eq 2 and len(get_program_parameters.salaryparam_pay_id_relative)>
                                <cfset get_payments = get_payments_cmp.SETUP_PAYMENT_INTERRUPTION(odkes_id : get_program_parameters.salaryparam_pay_id_relative)><!--- Ödenek Bilgileri --->
                            <!--- Çalışan Kendisi ise --->
                            <cfelseif attributes.is_relative eq 1>
                                <cfset get_payments = get_payments_cmp.SETUP_PAYMENT_INTERRUPTION(odkes_id : get_program_parameters.salaryparam_pay_id)><!--- Ödenek Bilgileri --->
                            <cfelse>
                                <cfset get_payments.recordcount = 0> 
                            </cfif>
                            <!--- Çalışan Kesinti ve Ödenek İşlemi Bordroya Yansır ve çalışan kendisi ise veya Çalışan Yakını Kesinti ve Ödenek İşlemi Bordroya Yansır seçili ise ve çalışan yakını ise ERU ---> 
                            <cfif  get_payments.recordcount and is_allowance_deduction eq 1> 
                                <cfset get_allowance_expense = allowance_expense_cmp.ADD_SALARYPARAM_PAY(
                                    comment_pay :  get_payments.comment_pay,<!--- Ödenek İsmi --->
                                    comment_pay_id : get_payments.odkes_id,<!---Ödenek Id --->
                                    amount_pay : interrupt_amount,<!--- Ödenek (Kurum Payı) --->
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
                                    comment_type : get_payments.comment_type,<!--- 1: ek ödenek, 2: kazanc --->
                                    expense_health_id : attributes.health_id <!--- Sağlık harcaması ID --->
                                    ) /> 
                            </cfif>
                        <!--- Çalışan Kesinti ve Ödenek İşlemi Bordroya Yansır hayır seçili ve çalışan kendisi ise veya Çalışan Yakını Kesinti ve Ödenek İşlemi Bordroya Yansır hayır seçili ise ve çalışan yakını ise ---> 
                        <cfelseif ((isdefined("attributes.x_is_employee_relative_payment") and attributes.x_is_employee_relative_payment eq 0 and attributes.is_relative eq 2) or (isdefined("attributes.x_is_employee_payment") and attributes.x_is_employee_payment eq 0 and attributes.is_relative eq 1)) and attributes.x_is_employee_amount eq 0>
                            <cfscript>
                                cari_sil(action_id:attributes.health_id,process_type:2503,cari_db : dsn2);
                                if(is_cari eq 1)
                                {
                                    interrupt_amount = attributes.lasttotal - (attributes.employee_health_amount +  attributes.interrupt);
                                    carici(
                                        action_id : attributes.health_id,
                                        action_table : 'EXPENSE_ITEM_PLAN_REQUESTS',
                                        islem_belge_no : attributes.paper_number,
                                        workcube_process_type : 2503,	
                                        process_cat : attributes.PROCESS_CAT,
                                        islem_tarihi : attributes.EXPENSE_DATE,
                                        action_detail : '#attributes.paper_number# #getLang("objects",1316,"sağlık harcaması")#',
                                        islem_tutari : interrupt_amount,
                                        other_money_value : interrupt_amount,
                                        action_currency : session.ep.money,
                                        acc_type_id : acc_type_id_,
                                        currency_multiplier : '',
                                        account_card_type : 13,
                                        islem_detay : '#attributes.paper_number# #getLang("objects",1316,"sağlık harcaması")#',
                                        due_date: attributes.EXPENSE_DATE,
                                        to_branch_id : branch_id_,
                                        to_employee_id : attributes.expense_employee_id,
                                        rate2:'',
                                        cari_db : dsn2
                                        );
                                }
                            </cfscript>
                        </cfif>
                        <!--- Limit Aşımı Kesinti tanımları yapılmışsa işlem kategorilerinden kesinti işlemi yapılsın seçildiyse ve xml den evet seçildiysa ---->
                        <cfif len(get_program_parameters.LIMIT_INTERRUPTION_ID) and is_deduction eq 1 and attributes.x_is_limit_interruption eq 1>
                            <cfset limit_interruption_id = get_program_parameters.LIMIT_INTERRUPTION_ID><!--- Kesinti id--->
                            <cfset get_interruption_limit = get_payments_cmp.SETUP_PAYMENT_INTERRUPTION(odkes_id : limit_interruption_id)><!--- Kesinti Bilgileri --->
                            <cfif get_interruption_limit.recordcount>
                                <cfif get_interruption_limit.recordcount>  
                                    <cfset add_interruption = allowance_expense_cmp.ADD_SALARYPARAM_GET(
                                        comment_get : get_interruption_limit.comment_pay,<!--- Kesinti İsmi --->
                                        comment_get_id : get_interruption_limit.odkes_id,<!---Kesinti Id --->
                                        amount_get : attributes.interrupt,<!--- kesitni ücreti --->
                                        total_get : attributes.interrupt,<!--- kesitni ücreti --->
                                        period_get : get_interruption_limit.period_pay, <!--- 1: ayda 1, 2 : 3 ayda 1 , 3 : 6 ayda 1, 4 : yılda 1---> 
                                        method_get : get_interruption_limit.method_pay,  <!--- 1: eksi, 2 : ay , 3 : gün, 4 : saat---> 
                                        show : get_interruption_limit.show,  <!--- bordroda görünsün ---> 
                                        start_sal_mon : attributes.sal_mon,<!--- Başlangıç Ayı --->
                                        end_sal_mon : attributes.sal_mon,<!--- Bitiş Ayı --->
                                        employee_id : attributes.EXPENSE_EMPLOYEE_ID,<!--- çalışan id --->
                                        term : attributes.sal_year,<!--- yıl --->
                                        calc_days : get_interruption_limit.calc_days,<!---tutar günü 0 : tümü, 1: gün,2 : fiili gün --->
                                        from_salary : get_interruption_limit.from_salary, <!--- 0 :net,1 : brüt --->
                                        in_out_id : get_in_out_id.in_out_id,<!--- Giriş çıkış id --->
                                        is_inst_avans : get_interruption_limit.is_inst_avans,<!--- Taksitlendirilmiş Avans --->
                                        is_ehesap : get_interruption_limit.is_ehesap,<!--- üst düzey ik yetkisi 1 : dahi, 0 :dahil değil--->
                                        money : get_interruption_limit.MONEY,<!--- Para birimi--->
                                        tax : get_interruption_limit.tax,<!--- vergi 1 : muaf, 2: muaf değil--->
                                        expense_health_id : attributes.health_id
                                    )>
                                </cfif>
                            </cfif>
                        </cfif>
                    </cfif>
                
                <cfelse>
                    Bordro akış parametrelerinde Kesinti tanımı eksik
                </cfif>
                <!----<cfset health_approve = get_health_cmp.EXPENSE_ITEM_PLAN_REQUESTS_HEALTH_APPROVE(health_id = attributes.health_id)>--->
        <cfelse>
            Anlaşmalı Kurum Değil
        </cfif>
    <cfelseif listFirst(attributes.fuseaction,'.') eq 'hr'>
    Bordro akış parametrelerinde sağlık tanımları eksik . Lütfen tanımlayınız.
    </cfif>
</cfif>
<cfsavecontent variable="healthExpense"><cf_get_lang dictionary_id = "33706.Sağlık Harcaması"></cfsavecontent>
<cf_workcube_process 
            is_upd='1' 
            data_source='#dsn2#' 
            old_process_line='0'
            process_stage='#attributes.process_stage#' 
            record_member='#session.ep.userid#' 
            record_date='#now()#'
            action_table='EXPENSE_ITEM_PLAN_REQUESTS'
            action_column='EXPENSE_ID'
            action_id='#MAX_ID.IDENTITYCOL#'
            action_page='#request.self#?fuseaction=#fusebox.circuit#.health_expense_approve&event=upd&health_id=#MAX_ID.IDENTITYCOL#' 
            warning_description='#healthExpense#: #attributes.paper_number#'>

        <cfif attributes.fuseaction eq 'hr.health_expense_approve'> 
            <cfquery name="get_type" datasource="#dsn2#">
                SELECT PROCESS_TYPE,PROCESS_CAT_ID,IS_ACCOUNT,ACTION_FILE_NAME,ACTION_FILE_FROM_TEMPLATE FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #attributes.process_cat#
            </cfquery>
            <cf_workcube_process_cat 
				process_cat="#attributes.process_cat#"
				action_id = "#MAX_ID.IDENTITYCOL#"
				action_table="EXPENSE_ITEM_PLAN_REQUESTS"
				action_column="EXPENSE_ID"
				is_action_file = 1
				action_page='#request.self#?fuseaction=#fusebox.circuit#.health_expense_approve&event=upd&health_id=#MAX_ID.IDENTITYCOL#'
				action_file_name='#get_type.action_file_name#'
				action_db_type = '#dsn2#'
                is_template_action_file = '#get_type.action_file_from_template#'>
        </cfif>  
<cfif fusebox.circuit is 'myhome'>
    <cfset attributes.health_id = contentEncryptingandDecodingAES(isEncode:1,content:MAX_ID.IDENTITYCOL,accountKey:'wrk')>
<cfelse>
    <cfset attributes.health_id = MAX_ID.IDENTITYCOL>
</cfif>
<cfif isdefined("attributes.expense_id") and len(attributes.expense_id)>
    <cfquery name="get_expense_item_plans_det" datasource="#dsn2#">
        SELECT EXPENSE_ITEM_PLANS_ID FROM EXPENSE_ITEM_PLANS WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
    </cfquery>
    <cfif get_expense_item_plans_det.EXPENSE_ITEM_PLANS_ID eq "">
        <cfquery name="upd_expense_item_plans_rel" datasource="#dsn2#">
            UPDATE
                EXPENSE_ITEM_PLANS
            SET
                EXPENSE_ITEM_PLANS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.health_id#">
            WHERE
                EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
        </cfquery>
    </cfif>
</cfif>
<script type="text/javascript">
    window.location.href = "<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.health_expense_approve&event=upd&health_id=#attributes.health_id#</cfoutput>";
</script>