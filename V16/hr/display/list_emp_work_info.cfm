<cfif not isdefined("get_hr_detail")>
	<cfquery name="GET_HR_DETAIL" datasource="#dsn#">
		SELECT SHIFT_ID FROM EMPLOYEES_DETAIL WHERE EMPLOYEE_ID=#attributes.EMPLOYEE_ID#
	</cfquery>
</cfif>
<cfquery name="get_in_out" datasource="#DSN#">
	SELECT * FROM EMPLOYEES_IN_OUT WHERE IN_OUT_ID = #attributes.IN_OUT_ID#
</cfquery>
<cfif not isdefined("get_moneys")>
	<cfinclude template="../ehesap/query/get_moneys.cfm">
</cfif>
<cfset attributes.month_ = 'M#dateformat(now(),'m')#'>
<cfinclude template="../ehesap/query/get_ssk_yearly.cfm">
<cfinclude template="../ehesap/query/get_active_shifts.cfm">
<cfinclude template="../ehesap/query/get_position.cfm">
<cfif len(get_in_out.PAYMETHOD_ID)>
	<cfset attributes.paymethod_id = get_in_out.PAYMETHOD_ID>
	<cfinclude template="../ehesap/query/get_paymethod.cfm">
	<cfset PAY_TEMP = "#get_paymethod.paymethod#">
<cfelse>
	<cfset PAY_TEMP = "">
</cfif>
<cfquery name="get_isBranchAuthorization" datasource="#dsn#">
	SELECT 
        BRANCH_ID
    FROM
        BRANCH
    <cfif session.ep.isBranchAuthorization>
        WHERE
		    BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
            AND BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_position.branch_id#">
	</cfif>
</cfquery>
<cfif not get_isBranchAuthorization.recordcount>
    <cf_get_lang dictionary_id="57997.Şube yetkiniz uygun değil.">
    <cfabort>
</cfif>
<cfset attributes.SAL_MON = month(now())>
<cfset attributes.SAL_YEAR = year(now())>
<cfif attributes.SAL_MON neq 1>
	<cfquery name="get_kumulative" datasource="#dsn#" maxrows="1">
		SELECT 
			EMPLOYEES_PUANTAJ_ROWS.KUMULATIF_GELIR_MATRAH
		FROM 
			EMPLOYEES_PUANTAJ,
			EMPLOYEES_PUANTAJ_ROWS
		WHERE 
			EMPLOYEES_PUANTAJ.PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID AND
			EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND
			EMPLOYEES_PUANTAJ.SAL_YEAR = #session.ep.period_year# AND
			EMPLOYEES_PUANTAJ.SAL_MON = #attributes.SAL_MON-1#
		ORDER BY
			EMPLOYEE_PUANTAJ_ID DESC
	</cfquery>
<cfelseif (attributes.SAL_MON eq 1) and (year(now()) gt session.ep.period_year)>
	<cfquery name="get_kumulative" datasource="#dsn#" maxrows="1">
		SELECT 
			EMPLOYEES_PUANTAJ_ROWS.KUMULATIF_GELIR_MATRAH
		FROM 
			EMPLOYEES_PUANTAJ,
			EMPLOYEES_PUANTAJ_ROWS
		WHERE 
			EMPLOYEES_PUANTAJ.PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID AND
			EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND
			EMPLOYEES_PUANTAJ.SAL_YEAR = #year(now())-1# AND
			EMPLOYEES_PUANTAJ.SAL_MON = 12
		ORDER BY
			EMPLOYEE_PUANTAJ_ID DESC
	</cfquery>
<cfelseif (attributes.SAL_MON eq 1) and (year(now()) eq session.ep.period_year)>
	<cfset get_kumulative.KUMULATIF_GELIR_MATRAH = 0>
	<cfset get_kumulative.recordcount = 0>
</cfif>
<cfif get_kumulative.recordcount>
	<cfset cumulative_tax_total_= get_kumulative.KUMULATIF_GELIR_MATRAH> 
<cfelseif year(get_in_out.start_date) lt session.ep.period_year>
	<cfset cumulative_tax_total_ = 0>
<cfelseif len(get_in_out.CUMULATIVE_TAX_TOTAL)>
	<cfset cumulative_tax_total_ = get_in_out.CUMULATIVE_TAX_TOTAL>
<cfelse>
	<cfset cumulative_tax_total_ = 0>
</cfif>
<cfquery name="GET_KUMULATIVE_TAX" datasource="#DSN#">
	SELECT
		SUM(EMPLOYEES_PUANTAJ_ROWS.GELIR_VERGISI) AS GELIR_VERGISI
	FROM
		EMPLOYEES_PUANTAJ,
		EMPLOYEES_PUANTAJ_ROWS
	WHERE
		EMPLOYEES_PUANTAJ.PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID AND
		EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND
		EMPLOYEES_PUANTAJ.SAL_YEAR = #session.ep.period_year# AND
		EMPLOYEES_PUANTAJ.SAL_MON < #attributes.SAL_MON#
</cfquery>
<cfif GET_KUMULATIVE_TAX.recordcount>
	<cfset gelir_wegisi = GET_KUMULATIVE_TAX.GELIR_VERGISI>
<cfelse>
	<cfset gelir_wegisi = 0>  
</cfif>
<cf_catalystHeader>
<cf_box>
<cfform action="#request.self#?fuseaction=hr.emptypopup_upd_emp_work_info" method="post" name="employe_work">
    <cf_box_elements>
    <input type="hidden" name="in_out_id" id="in_out_id" value="<cfoutput>#attributes.in_out_id#</cfoutput>" />
    <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>" />
                	<cfoutput>
                    <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    	<div class="form-group" id="item-branch_name">
                        	<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                            <label class="col col-7 col-xs-12"><cfif len(get_position.position_id)>#get_position.branch_name#</cfif></label>
                        </div>
                        <div class="form-group" id="item-dateformat">
                        	<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='56401.Son İşe Başlama - Bitiş'></label>
                            <label class="col col-7 col-xs-12">#dateformat(get_in_out.start_date,dateformat_style)# - <cfif len(get_in_out.finish_date)>#dateformat(get_in_out.finish_date,dateformat_style)#</cfif></label>
                        </div>
                        <div class="form-group" id="item-TRADE_UNION_DEDUCTION">
                        	<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id ='56446.Sendika Kesinti'></label>
                            <label class="col col-7 col-xs-12">#TLFormat(get_in_out.TRADE_UNION_DEDUCTION)#-#get_in_out.TRADE_UNION_DEDUCTION_MONEY#</label>
                        </div>
                        <div class="form-group" id="item-use_ssk">
                        	<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='58537.SSK lı Çalışan mı'>?</label>
                            <label class="col col-7 col-xs-12"><cfif get_in_out.use_ssk eq 1><cf_get_lang_main no='83.Evet'><cfelse><cf_get_lang_main no='84.Hayır'></cfif></label>
                        </div>
                        <div class="form-group" id="item-duty_type">
                        	<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='58538.Görev Tipi'></label>
                            <label class="col col-7 col-xs-12">
                            	<cfif get_in_out.duty_type eq 2><cf_get_lang dictionary_id='57576.Çalışan'>
								<cfelseif get_in_out.duty_type eq 1><cf_get_lang dictionary_id='56405.İşveren Vekili'>
                                <cfelseif get_in_out.duty_type eq 0 ><cf_get_lang dictionary_id='56406.İşveren'>
                                </cfif>
                            </label>
                        </div>
                        <div class="form-group" id="item-CUMULATIVE_TAX_TOTAL">
                        	<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='58539.Dönem Başı Kümüle Vergi Matrahı'></label>
                            <label class="col col-7 col-xs-12">
                            	#TLFormat(get_in_out.CUMULATIVE_TAX_TOTAL)#
                            </label>
                        </div>
                        <div class="form-group" id="item-START_CUMULATIVE_TAX">
                        	<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='58540.Dönem Başı Kümüle Vergi Tutarı'></label>
                            <label class="col col-7 col-xs-12">
                            	#TLFormat(get_in_out.START_CUMULATIVE_TAX)#
                            </label>
                        </div>
                        <div class="form-group" id="item-cumulative_tax_total_">
                        	<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='56425.Son Kümüle Vergi Matrahı'></label>
                            <label class="col col-7 col-xs-12">
                            	<cfoutput>#TLFormat(cumulative_tax_total_)#</cfoutput>
                            </label>
                        </div>
                        <div class="form-group" id="item-gelir_wegisi">
                        	<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='56426.Son Kümülatif Vergi Tutarı'></label>
                            <label class="col col-7 col-xs-12">
                            	#TLFormat(gelir_wegisi)#
                            </label>
                        </div>
                        <div class="form-group" id="item-sureli_is_akdi">
                        	<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='56428.Süreli İş Akdi'></label>
                            <label class="col col-7 col-xs-12">
                            	<cfif get_in_out.sureli_is_akdi eq 1><cf_get_lang dictionary_id='57495.Evet'> - #dateformat(get_in_out.sureli_is_finishdate,dateformat_style)#</cfif>
                            </label>
                        </div>
                        <div class="form-group" id="item-sabit_prim">
                        	<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='55716.Ücret Tipi'></label>
                            <label class="col col-7 col-xs-12">
                            	<cfif get_in_out.sabit_prim eq 0><cf_get_lang dictionary_id='58544.Sabit'>
								<cfelseif get_in_out.sabit_prim eq 1><cf_get_lang dictionary_id='56430.Primli'>
                                </cfif>
                            </label>
                        </div>
                        <div class="form-group" id="item-PAY_TEMP">
                        	<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id ='56432.Ödeme Metodu'></label>
                            <label class="col col-7 col-xs-12">
                            	#PAY_TEMP#
                            </label>
                        </div>
                        <div class="form-group" id="item-money">
                        	<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id ='55123.Ücret'></label>
                            <label class="col col-7 col-xs-12">
                            	#TLFormat(evaluate("get_ssk_yearly.#attributes.month_#"))# - #get_ssk_yearly.money#
                            </label>
                        </div>
                        <div class="form-group" id="item-gross_net">
                        	<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id ='56435.Brüt / Net'></label>
                            <label class="col col-7 col-xs-12">
                            	<cfif get_in_out.gross_net eq 0><cf_get_lang dictionary_id ='56257.Brüt'>
								<cfelseif get_in_out.gross_net eq 1><cf_get_lang dictionary_id='58083.Net'>
                                </cfif>
                            </label>
                        </div>
                        <div class="form-group" id="item-salary_type">
                        	<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id ='56437.Ücret Yöntemi'></label>
                            <label class="col col-7 col-xs-12">
                            	<cfif get_in_out.salary_type eq 2><cf_get_lang dictionary_id='58724.Ay'>
								<cfelseif get_in_out.salary_type eq 1><cf_get_lang dictionary_id='57490.Gün'>
                                <cfelseif get_in_out.salary_type eq 0><cf_get_lang dictionary_id='57491.Saat'>
                                </cfif>
                            </label>
                        </div>
                        <div class="form-group" id="item-ozel_gider_indirim">
                        	<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id ='56439.Özel Gider İndirim Matrahı'></label>
                            <label class="col col-7 col-xs-12">
                            	#TLFormat(get_in_out.ozel_gider_indirim)#
                            </label>
                        </div>
                        <div class="form-group" id="item-fis_toplam">
                        	<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id="56441.Özel Gider İnd Harcama Tutarı"></label>
                            <label class="col col-7 col-xs-12">
                            	#TLFormat(get_in_out.fis_toplam)#
                            </label>
                        </div>
                        <div class="form-group" id="item-fazla_mesai_saat">
                        	<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id ='56443.Fazla Mesai Saat'></label>
                            <label class="col col-7 col-xs-12">
                            	#TLFormat(get_in_out.fazla_mesai_saat)#
                            </label>
                        </div>
                    </div>
                    <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    	<div class="form-group" id="item-position_id">
                        	<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='58497.Pozisyon'></label>
                            <label class="col col-7 col-xs-12"><cfif len(get_position.position_id)>#get_position.position_name#</cfif></label>
                        </div>
                        <div class="form-group" id="item-trade_union_no">
                        	<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='56402.Sendika'>-<cf_get_lang dictionary_id='56403.Sendika No'></label>
                            <label class="col col-7 col-xs-12">#get_in_out.trade_union# -  #get_in_out.trade_union_no#</label>
                        </div>
                        <div class="form-group" id="item-socialsecurity_no">
                        	<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='55663.SSK No'></label>
                            <label class="col col-7 col-xs-12">#get_in_out.socialsecurity_no#</label>
                        </div>
                        <div class="form-group" id="item-RETIRED_SGDP_NUMBER">
                        	<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id ='56447.Emekli ise SGDP Tahsis No'></label>
                            <label class="col col-7 col-xs-12">#get_in_out.RETIRED_SGDP_NUMBER#</label>
                        </div>
                        <div class="form-group" id="item-ssk_statute">
                        	<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='56407.SSK Satüsü'></label>
                            <label class="col col-7 col-xs-12">
                            	<cfif get_in_out.ssk_statute eq 1><cf_get_lang dictionary_id='55514.Normal'>
								<cfelseif get_in_out.ssk_statute eq 2><cf_get_lang dictionary_id='58541.Emekli'>
                                <cfelseif get_in_out.ssk_statute eq 3><cf_get_lang dictionary_id='56408.Stajyer Öğrenci'>
                                <cfelseif get_in_out.ssk_statute eq 4><cf_get_lang dictionary_id='56409.Çırak'>
                                <cfelseif get_in_out.ssk_statute eq 5><cf_get_lang dictionary_id='56410.Anlaşmaya Tabi Olmayan Yabancı'>
                                <cfelseif get_in_out.ssk_statute eq 6><cf_get_lang dictionary_id='56411.Anlaşmalı Ülke Yabancı Uyruk'>
                                <cfelseif get_in_out.ssk_statute eq 7><cf_get_lang dictionary_id='56412.Deniz,Basım,Azot,Şeke'>
                                <cfelseif get_in_out.ssk_statute eq 8><cf_get_lang dictionary_id='54082.Yeraltı Sürekli'>
                                <cfelseif get_in_out.ssk_statute eq 9><cf_get_lang dictionary_id='56414.Yeraltı Gruplu'>
                                <cfelseif get_in_out.ssk_statute eq 10><cf_get_lang dictionary_id='56415.Yerüstü Gruplu'>
                                <cfelseif get_in_out.ssk_statute eq 11><cf_get_lang dictionary_id='56416.YÖK Kısmi İstihdam Öğrenci'>
                                <cfelseif get_in_out.ssk_statute eq 12><cf_get_lang dictionary_id='58542.Aylık Sigorta Prim İşsizlik Hariç'>
                                <cfelseif get_in_out.ssk_statute eq 13><cf_get_lang dictionary_id='56417.LIBYA'>
                                <cfelseif get_in_out.ssk_statute eq 14><cf_get_lang dictionary_id='56418.2098 Sayılı Kanun İşsizlik Hariç'>
                                <cfelseif get_in_out.ssk_statute eq 15><cf_get_lang dictionary_id='56419.2098 Görevli Malül. Aylığı Alanlar'>
                                <cfelseif get_in_out.ssk_statute eq 16><cf_get_lang dictionary_id='56420.Görev Malüllük Aylığı Alanlar'>
                                <cfelseif get_in_out.ssk_statute eq 17><cf_get_lang dictionary_id='56421.İş Kazası,Mes.Hast.,Analık ve Hast. Sig. Tabi'>
                                <cfelseif get_in_out.ssk_statute eq 18><cf_get_lang dictionary_id='56415.Yeraltı Emekli'>
                                <cfelseif get_in_out.ssk_statute eq 19><cf_get_lang dictionary_id='56415.Tüm sigorta kollarına tabi çalışıp 180 gün fiili hizmet süresi zammına tabi çalışanlar'>
                                <cfelseif get_in_out.ssk_statute eq 50><cf_get_lang dictionary_id='56422.Emekli Sandığı'>
                                <cfelseif get_in_out.ssk_statute eq 60><cf_get_lang dictionary_id='56423.Banka ve Diğerleri'>
                                <cfelseif get_in_out.ssk_statute eq 70><cf_get_lang dictionary_id='56424.Bağ-kur'>
                                <cfelseif get_in_out.ssk_statute eq 33><cf_get_lang dictionary_id='63737.5434 Sayılı Kanuna Tabi Çalışan'>
                                </cfif>
                            </label>
                        </div>
                        </cfoutput>
                        <div class="form-group" id="item-shift_id">
                        	<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='56427.Vardiyalar'></label>
                            <label class="col col-7 col-xs-12">
                            	<cfif get_active_shifts.recordcount eq 0>
                                -
                                <cfelse>
                                    <cfoutput query="get_active_shifts">
                                        <cfif get_hr_detail.shift_id eq shift_id>#shift_name# (#start_hour#-#end_hour#)</cfif>
                                    </cfoutput>
                                </cfif>
                            </label>
                        </div>
                        <cfoutput>
                        <div class="form-group" id="item-is_vardiya">
                        	<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='58543.Mesai Tipi'></label>
                            <label class="col col-7 col-xs-12">
                            	<cfif get_in_out.is_vardiya eq 0><cf_get_lang dictionary_id='58544.Sabit'>
								<cfelseif get_in_out.is_vardiya eq 1 or get_in_out.is_vardiya eq 2><cf_get_lang dictionary_id='58545.Vardiyalı'>
                                </cfif>
                            </label>
                        </div>
                        <div class="form-group" id="item-first_ssk_date">
                        	<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='56429.İlk Sigortalı Oluş Tarihi'></label>
                            <label class="col col-7 col-xs-12">
                            	#dateformat(get_in_out.first_ssk_date,dateformat_style)#
                            </label>
                        </div>
                        <div class="form-group" id="item-use_tax">
                        	<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='53565.Vergi İndirimi Kullanıyor mu'>?</label>
                            <label class="col col-7 col-xs-12">
                            	<cfif get_in_out.use_tax eq 1><cf_get_lang dictionary_id='57495.Evet'></cfif>
                            </label>
                        </div>
                        <div class="form-group" id="item-use_pdks">
                        	<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id ='56433.Devam Kontrol Sistemine Bağlı'></label>
                            <label class="col col-7 col-xs-12">
                            	<cfif get_in_out.use_pdks eq 1><cf_get_lang dictionary_id="57495.Evet"><cfelse><cf_get_lang dictionary_id="57496.Hayır"></cfif>
                            </label>
                        </div>
                        <div class="form-group" id="item-pdks_type_id">
                        	<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id="56887.PDKS No"></label>
                            <div class="col col-7 col-xs-12">
                                <div class="col col-6 col-xs-12">
                                    <input type="text" name="pdks_number" id="pdks_number" value="#get_in_out.pdks_number#" style="width:55px;">
                                    <cfquery name="get_pdks_types" datasource="#dsn#">
                                        SELECT PDKS_TYPE_ID,PDKS_TYPE FROM SETUP_PDKS_TYPES
                                    </cfquery>
                                        </div>
                                        <div class="col col-6 col-xs-12">
                                    <select name="pdks_type_id" id="pdks_type_id">
                                        <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                        <cfloop query="get_pdks_types">
                                        <option value="#get_pdks_types.PDKS_TYPE_ID#" <cfif get_in_out.PDKS_TYPE_ID eq get_pdks_types.PDKS_TYPE_ID>selected</cfif>>#get_pdks_types.PDKS_TYPE#</option>
                                        </cfloop>
                                    </select>
                                </div>
                            </div>
                        </div>
                        </cfoutput>
                        <div class="form-group" id="item-transport_type_id">
                        	<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id="55667.Ulaşım Şekli"></label>
                            <div class="col col-7 col-xs-12">
                            	<cfquery name="get_transport_types" datasource="#dsn#">
                                    SELECT * FROM (
                                            SELECT 
                                            STT1.*,
                                            STT2.TRANSPORT_TYPE AS UPPER_TYPE 
                                            FROM 
                                            SETUP_TRANSPORT_TYPES STT1,
                                            SETUP_TRANSPORT_TYPES STT2
                                            WHERE
                                            STT1.UPPER_TRANSPORT_TYPE_ID = STT2.TRANSPORT_TYPE_ID AND
                                            STT1.BRANCH_ID = #get_in_out.BRANCH_ID#
                                            UNION ALL
                                            SELECT 
                                            *,
                                            #dsn#.Get_Dynamic_Language(TRANSPORT_TYPE_ID,'#session.ep.language#','SETUP_TRANSPORT_TYPES','TRANSPORT_TYPE',NULL,NULL,TRANSPORT_TYPE) AS UPPER_TYPE

                                            FROM 
                                            SETUP_TRANSPORT_TYPES
                                            WHERE
                                            UPPER_TRANSPORT_TYPE_ID IS NULL
                                            
                                            ) ALL_TYPES
                                            ORDER BY
                                            UPPER_TYPE,
                                            TRANSPORT_TYPE
                                </cfquery>
                                <select name="transport_type_id" id="transport_type_id">
                                <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                <cfoutput query="get_transport_types" GROUP="UPPER_TYPE">
                                <optgroup label="#upper_type#">
                                <cfoutput>
                                <cfif currentrow neq get_transport_types.recordcount and get_transport_types.upper_transport_type_id[currentrow+1] eq transport_type_id>
                                <cfelse>
                                <option value="#transport_TYPE_ID#" <cfif get_in_out.transport_TYPE_ID eq transport_TYPE_ID>selected</cfif>>#transport_TYPE#</option>
                                </cfif>
                                </cfoutput>
                                </cfoutput>
                                </select>
                            </div>
                        </div>
                        <cfoutput>
                        <div class="form-group" id="item-DEFECTION_LEVEL">
                        	<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id ='56434.Sakatlık Derecesi'></label>
                            <label class="col col-7 col-xs-12">
                            	<cfif get_in_out.DEFECTION_LEVEL eq 0><cf_get_lang dictionary_id='58546.Yok'>
								<cfelseif get_in_out.DEFECTION_LEVEL eq 1>1
                                <cfelseif get_in_out.DEFECTION_LEVEL eq 2>2
                                <cfelseif get_in_out.DEFECTION_LEVEL eq 3>3
                                </cfif>
                            </label>
                        </div>
                        <div class="form-group" id="item-SALARY_VISIBLE">
                        	<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id ='56436.Ücreti diğerleri görsün'></label>
                            <label class="col col-7 col-xs-12">
                            	<cfif get_in_out.SALARY_VISIBLE eq 1><cf_get_lang dictionary_id='57495.Evet'></cfif>
                            </label>
                        </div>
                        <div class="form-group" id="item-EFFECTED_CORPORATE_CHANGE">
                        	<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id ='53578.Toplu ücret ayarlamasından etkilensin'></label>
                            <label class="col col-7 col-xs-12">
                            	<cfif get_in_out.EFFECTED_CORPORATE_CHANGE eq 1><cf_get_lang dictionary_id='57495.Evet'></cfif>
                            </label>
                        </div>
                        <div class="form-group" id="item-ozel_gider_vergi">
                        	<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id ='56440.Özel Gider Vergi Tutarı'></label>
                            <label class="col col-7 col-xs-12">
                            	#TLFormat(get_in_out.ozel_gider_vergi)#
                            </label>
                        </div>
                        <div class="form-group" id="item-mahsup_iade">
                        	<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id ='56442.Mahsup Edilen İade Tutarı'></label>
                            <label class="col col-7 col-xs-12">
                            	#TLFormat(get_in_out.mahsup_iade)#
                            </label>
                        </div>
                        </cfoutput>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    	<cf_workcube_buttons is_upd='0'>
                </cf_box_footer>
</cfform>
</cf_box>