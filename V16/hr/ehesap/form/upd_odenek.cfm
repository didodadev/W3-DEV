<cfquery name="get_odenek" datasource="#dsn#">
	SELECT 
        PAY_ID,
        ODKES_ID,
        #dsn#.Get_Dynamic_Language(ODKES_ID,'#session.ep.language#','SETUP_PAYMENT_INTERRUPTION','COMMENT_PAY',NULL,NULL,COMMENT_PAY) AS COMMENT_PAY,
        SALARY_ID,
        PERIOD_PAY,
        METHOD_PAY,
        AMOUNT_PAY,
        SSK,
        TAX,
        SHOW,
        START_SAL_MON,
        END_SAL_MON,
        IS_ODENEK,
        CALC_DAYS,
        IS_INST_AVANS,
        FROM_SALARY,
        IS_KIDEM,
        RECORD_DATE,
        RECORD_EMP,
        RECORD_IP,
        UPDATE_EMP,
        UPDATE_DATE,
        UPDATE_IP,
        IS_EHESAP,
        IS_ISSIZLIK,
        IS_DAMGA,
        SSK_EXEMPTION_RATE,
        TAX_EXEMPTION_RATE,
        TAX_EXEMPTION_VALUE,
        IS_AYNI_YARDIM,
        COMPANY_ID,
        ACCOUNT_CODE,
        ACCOUNT_NAME,
        CONSUMER_ID,
        MONEY,
        ACC_TYPE_ID,
        SSK_EXEMPTION_TYPE,
        AMOUNT_MULTIPLIER,
        STATUS,
        IS_DEMAND,
        IS_INCOME,
        FACTOR_TYPE,
        COMMENT_TYPE,
        IS_NOT_EXECUTION,
        IS_BES,
        IS_RD_DAMGA,
        IS_RD_GELIR,
        IS_RD_SSK,
        CHILD_HELP,
        SSK_STATUE,
        STATUE_TYPE,
        IS_DISCIPLINARY_PUNISHMENT,
        DYNAMIC_RULES_ID,
        EXTRA_PAYMENT_ID
    FROM SETUP_PAYMENT_INTERRUPTION WHERE ODKES_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.odkes_id#">
</cfquery>
<cfquery name="get_ch_types" datasource="#dsn#">
	SELECT * FROM SETUP_ACC_TYPE ORDER BY ACC_TYPE_NAME
</cfquery>
<cfinclude template="../query/get_moneys.cfm">
<cfset get_component = createObject("component","V16.hr.cfc.project_allowance")>
<cfset get_allowance = get_component.get_allowance(from_payment: 1)>
<cf_box title="#getLang('','Ek Ödenek Tanımları',45827)# #getLang('','Güncelle',57464)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="upd_odenek" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_upd_odenek">
	    <cfinput type="hidden" name="odkes_id" value="#attributes.ODKES_ID#" required="yes" message="#getLang('','Tanım Girmelisiniz!',54327)#">
        <cf_box_elements>
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-is_active">
                    <label class="col col-4 col-xs-12"><span class="hide"><cf_get_lang dictionary_id='57493.Aktif'></span></label>
                    <div class="col col-8 col-xs-12">
                        <label><cf_get_lang dictionary_id='57493.Aktif'> <input type="checkbox" name="is_active" id="is_active" value="1" <cfif get_odenek.status eq 1>checked</cfif>></label>
                        <label><cf_get_lang dictionary_id='53179.Bordroda'> <input type="checkbox" name="show" id="show" value="<cfoutput>#get_odenek.show#</cfoutput>" <cfif get_odenek.show eq 1>checked</cfif>></label>
                    </div>
                </div>
                <div class="form-group" id="item-ssk_statue">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53606.SSK Durumu'></label>
                    <div class="col col-8 col-xs-12">
                        <cfsavecontent variable="header_"><cf_get_lang dictionary_id='53606.SSK Durumu'></cfsavecontent>
                        <select  name="ssk_statue" id="ssk_statue" onchange="change_ssk_statue(this.value)">
                            <option value="0"<cfif get_odenek.ssk_statue eq 0>selected</cfif>><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <option value="1"<cfif get_odenek.ssk_statue eq 1>selected</cfif>><cf_get_lang dictionary_id='45049.Worker'></option>
                            <option value="2"<cfif get_odenek.ssk_statue eq 2>selected</cfif>><cf_get_lang dictionary_id='62870.Memur'></option>
                            <option value="3"<cfif get_odenek.ssk_statue eq 3>selected</cfif>><cf_get_lang dictionary_id='62871.Serbest Çalışan'></option>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="statue_type_div"<cfif get_odenek.ssk_statue neq 2>style="display:none;"</cfif>>
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='63047.Bordro Tipi'></label>
                    <div class="col col-8 col-xs-12">
                        <select name="statue_type" id="statue_type">
                            <option value="0"><cf_get_lang dictionary_id='30152.Tipi'></option>
                            <option value="1" <cfif get_odenek.statue_type eq 1>selected</cfif>><cf_get_lang dictionary_id='40071.Maaş'></option>
                            <option value="2" <cfif get_odenek.statue_type eq 2>selected</cfif>><cf_get_lang dictionary_id='62888.Döner Sermaye'></option>
                            <option value="3" <cfif get_odenek.statue_type eq 3>selected</cfif>><cf_get_lang dictionary_id='62956.Ek Ders'></option>
                            <option value="4" <cfif get_odenek.statue_type eq 4>selected</cfif>><cf_get_lang dictionary_id='58015.Projeler'></option>
                            <option value="6" <cfif get_odenek.statue_type eq 6>selected</cfif>><cf_get_lang dictionary_id='64673.Jüri Üyeliği'></option>
                            <option value="8" <cfif get_odenek.statue_type eq 8>selected</cfif>><cf_get_lang dictionary_id='63103.Sanatçı'></option>
                            <option value="10" <cfif get_odenek.statue_type eq 10>selected</cfif>><cf_get_lang dictionary_id='65182.Münferit Ödeme'></option>   
                        </select>
                    </div>
				</div>
                <div class="form-group" id="item-comment">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58233.Tanım'>*</label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfif find('"',get_odenek.comment_pay)>
                                <input type="text" name="comment" id="comment" value='<cfoutput>#get_odenek.comment_pay#</cfoutput>'>
                            <cfelse>
                                <input type="text" name="comment" id="comment" value="<cfoutput>#get_odenek.comment_pay#</cfoutput>">
                            </cfif>
                            <span class="input-group-addon">
                                <cf_language_info	
                                table_name="SETUP_PAYMENT_INTERRUPTION"
                                column_name="COMMENT_PAY" 
                                column_id_value="#attributes.odkes_id#" 
                                maxlength="500" 
                                datasource="#dsn#" 
                                column_id="ODKES_ID" 
                                control_type="1">	
                            </span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-amount">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57673.Tutar'>*</label>
                    <div class="col col-6 col-xs-12">
                        <cfinput type="text" name="amount" required="yes" value="#TLFormat(get_odenek.AMOUNT_PAY)#" onkeyup="return(FormatCurrency(this,event));" message="#getLang('','Tutar Girmelisiniz!',54619)#">
                    </div>
                    <div class="col col-2 col-xs-12">
                        <select name="money" id="money">
                            <cfoutput query="get_moneys">
                                <option value="#money#" <cfif get_odenek.money is money> selected</cfif>>#money#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-SSK">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58714.SSK'></label>
                    <div class="col col-8 col-xs-12">
                        <select name="SSK" id="SSK">
                            <option value="1" <cfif get_odenek.SSK EQ 1>SELECTED</cfif>><cf_get_lang dictionary_id='53401.Muaf'></option>
                            <option value="2"<cfif get_odenek.SSK EQ 2>SELECTED</cfif>><cf_get_lang dictionary_id='53402.Muaf Değil'></option>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-TAX">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53332.Vergi'></label>
                    <div class="col col-8 col-xs-12">
                        <select name="TAX" id="TAX">
                            <option value="1"<cfif get_odenek.TAX EQ 1>SELECTED</cfif>><cf_get_lang dictionary_id='53401.Muaf'></option>
                            <option value="2"<cfif get_odenek.TAX EQ 2>SELECTED</cfif>><cf_get_lang dictionary_id='53402.Muaf Değil'></option>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-is_damga">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='53252.Damga Vergisi'></label>
                    <div class="col col-8 col-xs-12">
                        <select name="is_damga" id="is_damga">
                            <option value="1" <cfif get_odenek.is_damga EQ 1>SELECTED</cfif>><cf_get_lang dictionary_id="53402.Muaf Değil"></option>
                            <option value="0" <cfif get_odenek.is_damga EQ 0>SELECTED</cfif>><cf_get_lang dictionary_id="53401.Muaf"></option>							
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-is_issizlik">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='54034.İşsizlik Payı'></label>
                    <div class="col col-8 col-xs-12">
                        <select name="is_issizlik" id="is_issizlik">
                            <option value="1" <cfif get_odenek.is_issizlik EQ 1>SELECTED</cfif>><cf_get_lang dictionary_id="53402.Muaf Değil"></option>
                            <option value="0" <cfif get_odenek.is_issizlik EQ 0>SELECTED</cfif>><cf_get_lang dictionary_id="53401.Muaf"></option>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-calc_days">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="53970.Tutar Günü"></label>
                    <div class="col col-8 col-xs-12">
                        <select name="calc_days" id="calc_days" onchange="change_calc_days(this.value)">
                            <option value="0" <cfif get_odenek.calc_days EQ 0>SELECTED</cfif>><cf_get_lang dictionary_id="57708.Tümü"></option>
                            <option value="1" <cfif get_odenek.calc_days EQ 1>SELECTED</cfif>><cf_get_lang dictionary_id="57490.Gün"></option>
                            <option value="2" <cfif get_odenek.calc_days EQ 2>SELECTED</cfif>><cf_get_lang dictionary_id="53968.Fiili Gün"></option>
                            <option value="3" <cfif get_odenek.calc_days EQ 3>SELECTED</cfif>><cf_get_lang dictionary_id='64547.Çalışılan Saat'></option>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-SSK_EXEMPTION_TYPE">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59310.SGK Muafiyet Tipi"></label>
                    <div class="col col-8 col-xs-12">
                        <select name="SSK_EXEMPTION_TYPE" id="SSK_EXEMPTION_TYPE">
                            <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                            <option value="1" <cfif get_odenek.SSK_EXEMPTION_TYPE eq 1>selected</cfif>><cf_get_lang dictionary_id="54012.Tutara Göre"></option>
                            <option value="0" <cfif get_odenek.SSK_EXEMPTION_TYPE eq 0>selected</cfif>><cf_get_lang dictionary_id="54019.Asgari Ücrete Göre"></option>
                            <option value="2" <cfif get_odenek.SSK_EXEMPTION_TYPE eq 2>selected</cfif>><cf_get_lang dictionary_id="58457.Günlük"> <cf_get_lang dictionary_id="54019.Asgari Ücrete Göre"></option>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-ssk_muafiyet_orani">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="53973.SGK Muafiyet Oranı"></label>
                    <div class="col col-8 col-xs-12">
                        <cfinput type="text" name="ssk_muafiyet_orani" value="#get_odenek.SSK_EXEMPTION_RATE#" message="#getLang('','SGK Muafiyet Oranı',53973)#">
                    </div>
                </div>
                <div class="form-group" id="item-gelir_vergisi_muafiyet_orani">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="53998.Gelir Vergisi Muafiyet Tutarı"></label>
                    <div class="col col-8 col-xs-12">
                        <cfinput type="text" name="gelir_vergisi_muafiyet_orani" value="#TLFormat(get_odenek.TAX_EXEMPTION_RATE)#" message="#getLang('','Gelir Vergisi Muafiyet Oranı',53988)#">
                    </div>
                </div>
                <div class="form-group" id="item-gelir_vergisi_limiti">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="53988.Gelir Vergisi Muafiyet Oranı"></label>
                    <div class="col col-8 col-xs-12">
                        <input type="text" name="gelir_vergisi_limiti" id="gelir_vergisi_limiti" value="<cfif len(get_odenek.TAX_EXEMPTION_VALUE)><cfoutput>#tlformat(get_odenek.TAX_EXEMPTION_VALUE,4)#</cfoutput></cfif>" onkeyup="return(FormatCurrency(this,event,4));">
                    </div>
                </div>
            </div>  
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                <div class="form-group" id="item-PERIOD">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53310.Periyod'></label>
                    <div class="col col-8 col-xs-12">
                        <select name="PERIOD" id="PERIOD">
                            <option value="1" <cfif get_odenek.PERIOD_PAY EQ 1>SELECTED</cfif>><cf_get_lang dictionary_id='53311.Ayda'>1</option>
                            <option value="2" <cfif get_odenek.PERIOD_PAY EQ 2>SELECTED</cfif>>3 <cf_get_lang dictionary_id='53311.Ayda'> 1</option>
                            <option value="3" <cfif get_odenek.PERIOD_PAY EQ 3>SELECTED</cfif>>6 <cf_get_lang dictionary_id='53311.Ayda'> 1</option>
                            <option value="4" <cfif get_odenek.PERIOD_PAY EQ 4>SELECTED</cfif>><cf_get_lang dictionary_id='53312.Yılda'>1</option>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-METHOD">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="29472.Yöntem"></label>
                    <div class="col col-8 col-xs-12">
                        <select name="METHOD" id="METHOD" >
                            <option value="1" <cfif get_odenek.METHOD_PAY EQ 1>SELECTED</cfif>><cf_get_lang dictionary_id='53136.Artı'></option>
                            <option value="2" <cfif get_odenek.METHOD_PAY EQ 2>SELECTED</cfif>>% <cf_get_lang dictionary_id="53243.Aylık Ücret"></option>
                            <option value="3" <cfif get_odenek.METHOD_PAY EQ 3>SELECTED</cfif>>% <cf_get_lang dictionary_id="53242.Günlük Ücret"></option>
                            <option value="4" <cfif get_odenek.METHOD_PAY EQ 4>SELECTED</cfif>>% <cf_get_lang dictionary_id="53260.Saatlik"> <cf_get_lang dictionary_id="53127.Ücret"></option>
                            <option value="5" <cfif get_odenek.METHOD_PAY EQ 5>SELECTED</cfif>><cf_get_lang dictionary_id='57491.Saat'> x <cf_get_lang dictionary_id='63048.Ödenek Tutarı'></option>
                            <option value="6" <cfif get_odenek.METHOD_PAY EQ 6>SELECTED</cfif>><cf_get_lang dictionary_id='57491.Saat'> x <cf_get_lang dictionary_id='63396.N.Ö. Gündüz'></option>
                            <option value="7" <cfif get_odenek.METHOD_PAY EQ 7>SELECTED</cfif>><cf_get_lang dictionary_id='57491.Saat'> x <cf_get_lang dictionary_id='63397.N.Ö. Gece ve Tatillerde'></option>
                            <option value="8" <cfif get_odenek.METHOD_PAY EQ 8>SELECTED</cfif>><cf_get_lang dictionary_id='57491.Saat'> x <cf_get_lang dictionary_id='63398.İ.Ö. Gece'></option>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-acc_type_id">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="53329.Hesap Tipi"></label>
                    <div class="col col-8 col-xs-12">
                        <select name="acc_type_id" id="acc_type_id">
                            <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                            <cfoutput query="get_ch_types">
                                <option value="#acc_type_id#" <cfif get_odenek.acc_type_id eq acc_type_id>selected</cfif>>#acc_type_name#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-from_salary">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='54032.Net/Brüt'></label>
                    <div class="col col-8 col-xs-12">
                        <select name="from_salary" id="from_salary">
                            <option value="0" <cfif get_odenek.from_salary eq 0>selected</cfif>><cf_get_lang dictionary_id="58083.Net"></option>
                            <option value="1" <cfif get_odenek.from_salary eq 1>selected</cfif>><cf_get_lang dictionary_id="53131.Brüt"></option>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-comment_type">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59311.Ödenek Tipi"></label>
                    <div class="col col-8 col-xs-12">
                        <select name="comment_type">
                            <option value="1" <cfif get_odenek.comment_type eq 1>selected</cfif>><cf_get_lang dictionary_id="53082.Ek Ödenek"></option>
                            <option value="2" <cfif get_odenek.comment_type eq 2>selected</cfif>><cf_get_lang dictionary_id="53971.Kazanç"></option>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-dynamic_rules">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='64456.Dinamik Kural'></label>
                    <div class="col col-8 col-xs-12">
                        <select name="dynamic_rules_id" id="dynamic_rules_id" onchange="set_rules(this.value)">
                            <option value="" <cfif get_odenek.dynamic_rules_id eq 0>selected</cfif>><cf_get_lang dictionary_id='64460.Kural Seçiniz'></option>
                            <option value="1" <cfif get_odenek.dynamic_rules_id eq 1>selected</cfif>><cf_get_lang dictionary_id='53136.Artı'> <cf_get_lang dictionary_id="53082.Ek Ödenek"></option>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-extra_payment_id">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="53082.Ek Ödenek"></label>
                    <div class="col col-8 col-xs-12">
                        <cf_multiselect_check
                            name="extra_payment_id"
                            option_name="comment_pay"
                            option_value="odkes_id"
                            query_name="get_allowance"
                            value="#get_odenek.extra_payment_id#"
                            >
                    </div>
                </div>
                <div class="form-group" id="item-start_sal_mon">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57501.Başlangıç'></label>
                    <div class="col col-4 col-xs-12">
                        <cfoutput>
                        <select name="start_sal_mon" id="start_sal_mon">
                            <cfloop from="1" to="12" index="j">
                                <option value="#j#" <cfif get_odenek.START_SAL_MON EQ J>SELECTED</cfif>>#listgetat(ay_list(),j,',')#</option>
                            </cfloop>
                        </select>
                        </cfoutput>
                    </div>
                </div>
                <div class="form-group" id="item-end_sal_mon">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57502.Bitiş'></label>
                    <div class="col col-4 col-xs-12">
                        <cfoutput>
                        <select name="end_sal_mon" id="end_sal_mon">
                            <cfloop from="1" to="12" index="j">
                                <option value="#j#" <cfif get_odenek.END_SAL_MON EQ J>SELECTED</cfif>>#listgetat(ay_list(),j,',')#</option>
                            </cfloop>
                        </select>
                        </cfoutput>
                    </div>
                </div>
                <div class="form-group" id="item-amount_multiplier">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58865.Çarpan"></label>
                    <div class="col col-4 col-xs-12">
                        <input type="text" name="amount_multiplier" id="amount_multiplier" value="<cfif len(get_odenek.amount_multiplier)><cfoutput>#tlformat(get_odenek.amount_multiplier,6)#</cfoutput></cfif>" onkeyup="return(FormatCurrency(this,event,6));">
                    </div>
                </div>
                <div class="form-group" id="item-is_kidem">
                    <label class="col col-4 col-xs-12"><span class="hide"><cf_get_lang dictionary_id='53333.Kıdeme Dahil'></span></label>
                    <label class="col col-8 col-xs-12">
                        <input type="checkbox" name="is_kidem" id="is_kidem" value="1"<cfif get_odenek.is_kidem eq 1> checked</cfif>> <cf_get_lang dictionary_id='53333.Kıdeme Dahil'>
                    </label>
                </div>
                <div class="form-group" id="item-is_ehesap">
                    <label class="col col-4 col-xs-12"><span class="hide"><cf_get_lang dictionary_id="56369.Üst Düzey IK Yetkisi"></span></label>
                    <label class="col col-8 col-xs-12">
                        <cfif get_odenek.is_ehesap neq 1 or session.ep.ehesap>
                            <cfset kontrol_ehesap = 1>
                            <input type="checkbox" name="is_ehesap" id="is_ehesap" value="1"<cfif get_odenek.is_ehesap eq 1> checked</cfif>>
                            <cf_get_lang dictionary_id="56369.Üst Düzey IK Yetkisi">
                        <cfelse>
                            <input type="checkbox" name="is_income" id="is_income" value="1"<cfif get_odenek.is_income eq 1> checked</cfif>> 
                            <cf_get_lang dictionary_id="59312.Kazançlara Dahil">
                        </cfif>
                    </label>
                </div>
                <cfif isdefined("kontrol_ehesap")>
                <div class="form-group" id="item-is_income">
                    <label class="col col-4 col-xs-12"><span class="hide"><cf_get_lang dictionary_id="59312.Kazançlara Dahil"></span></label>
                    <label class="col col-8 col-xs-12">
                        <input type="checkbox" name="is_income" id="is_income" value="1"<cfif get_odenek.is_income eq 1> checked</cfif>> <cf_get_lang dictionary_id="59312.Kazançlara Dahil">
                    </label>
                </div>
                </cfif>
                <cfif isdefined("is_gov_payroll") and is_gov_payroll eq 1>
                <div class="form-group" id="item-factor_type">
                    <label class="col col-4 col-xs-12"><span class="hide"><cf_get_lang dictionary_id="50801.Katsayı"></span></label>
                    <div class="col col-8 col-xs-12">
                        <select name="factor_type">
                            <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                            <option value="1" <cfif get_odenek.factor_type eq 1>selected</cfif>><cf_get_lang dictionary_id="59313.Aylık Katsayı"></option>
                            <option value="2" <cfif get_odenek.factor_type eq 2>selected</cfif>><cf_get_lang dictionary_id="59314.Taban Aylık Katsayı"></option>
                            <option value="3" <cfif get_odenek.factor_type eq 3>selected</cfif>><cf_get_lang dictionary_id="59315.Yan Ödeme Katsayısı"></option>
                        </select>
                    </div>
                </div>
                </cfif>
                <div class="form-group" id="item-ayni_yardım">
                    <label class="col col-4 col-xs-12"><span class="hide"><cf_get_lang dictionary_id="53972.Aynı Yardım"></span></label>
                    <label class="col col-8 col-xs-12">
                        <input type="checkbox" name="is_ayni_yardim" id="is_ayni_yardim" value="1" <cfif get_odenek.IS_AYNI_YARDIM eq 1>checked</cfif>> <cf_get_lang dictionary_id="53972.Aynı Yardım">
                    </label>
                </div>
                <div class="form-group" id="item-is_not_execution">
                    <label class="col col-4 col-xs-12"><span class="hide"><cf_get_lang dictionary_id="59316.İcraya Dahil Değil"></span></label>
                    <label class="col col-8 col-xs-12">
                        <input type="checkbox" name="is_not_execution" id="is_not_execution" value="1" <cfif get_odenek.is_not_execution eq 1> checked</cfif>> <cf_get_lang dictionary_id="59316.İcraya Dahil Değil">             
                    </label>
                </div>
                <div class="form-group" id="item-child_help">
                    <label class="col col-4 col-xs-12"><span class="hide"><cf_get_lang dictionary_id='46080.Çocuk yardımı'></span></label>
                    <div class="col col-8 col-xs-12">
                        <input type="checkbox" name="child_help" id="child_help" value="1"  <cfif get_odenek.child_help eq 1> checked</cfif>> <cf_get_lang dictionary_id='46080.Çocuk yardımı'>
                    </div>
                </div>
                <div class="form-group" id="item-is_rd_gelir">
                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="59693.ARGE Muafiyet"></label>
                </div>
                <div class="form-group" id="item-is_rd_damga">
                    <label class="col col-4 col-xs-12"><span class="hide"><cf_get_lang dictionary_id ='53252.Damga Vergisi'></span></label>
                    <div class="col col-8 col-xs-12">
                        <input type="checkbox" name="is_rd_damga" id="is_rd_damga" value="1" <cfif get_odenek.is_rd_damga eq 1> checked</cfif>> <cf_get_lang dictionary_id ='53252.Damga Vergisi'>
                    </div>
                </div>
                <div class="form-group" id="item-is_rd_gelir">
                    <label class="col col-4 col-xs-12"><span class="hide"><cf_get_lang dictionary_id ='53250.Gelir Vergisi'></span></label>
                    <div class="col col-8 col-xs-12">
                        <input type="checkbox" name="is_rd_gelir" id="is_rd_gelir" value="1" <cfif get_odenek.is_rd_gelir eq 1> checked</cfif>> <cf_get_lang dictionary_id ='53250.Gelir Vergisi'>                                   
                    </div>
                </div>
                <div class="form-group" id="item-is_rd_ssk">
                    <label class="col col-4 col-xs-12"><span class="hide"><cf_get_lang dictionary_id ='53245.SGK Matrahı'></span></label>
                    <div class="col col-8 col-xs-12">
                        <input type="checkbox" name="is_rd_ssk" id="is_rd_ssk" value="1" <cfif get_odenek.is_rd_ssk eq 1> checked</cfif>><cf_get_lang dictionary_id ='53245.SGK Matrahı'>  
                    </div>
                </div>
            </div>  
        </cf_box_elements>
        <cf_box_footer>
            <div class="col col-6">
                <cf_record_info query_name="get_odenek">
            </div>
            <div class="col col-6">
                <cfif get_odenek.is_ehesap neq 1 or session.ep.ehesap>
                    <cf_workcube_buttons is_upd='1' is_delete='1' del_function="#isDefined('attributes.draggable') ? 'deleteFunc()' : ''#"
                    delete_alert='#getLang('','Tanımlı Ek Ödenek Bilgisini Siliyorsunuz! Emin misiniz?',62840)#' add_function="#iif(isdefined("attributes.draggable"),DE("form_chk() && loadPopupBox('upd_odenek' , #attributes.modal_id#)"),DE(""))#">
                </cfif>
            </div>
        </cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
    set_rules();
    function change_ssk_statue()
    {
        ssk_statue_val = $("#ssk_statue").val();
        if(ssk_statue_val == 2)
        {
            $('#statue_type_div').css('display','');
        }
        else
        {
            $('#statue_type_div').css('display','none');
        }
    }
	function form_chk()
	{
        ssk_statue = $("#ssk_statue").val();//ssk durumu
		statue_type = $("#statue_type").val();//bordro tipi
        if(ssk_statue == 0)
		{
			alert("<cf_get_lang dictionary_id='53606.Social Security Status'>!");
			return false;
		}else if(ssk_statue == 2 && $("#statue_type").val() == 0)
		{
			alert("<cf_get_lang dictionary_id='43738.Tip Seçmelisiniz'>!");
			return false;
		}
		if(document.upd_odenek.is_ayni_yardim.checked==true)
		{  
			if(document.upd_odenek.show.checked==true)
				{
				alert("<cf_get_lang dictionary_id='54603.Ayni Yardım ile Bordroyu Aynı Anda Seçemezsiniz'>!");
				return false;
				}
				
			if(document.upd_odenek.is_kidem.checked==false)
				{
					alert("<cf_get_lang dictionary_id='54605.Ayni Yardım Kıdeme Dahil Bir Ödenektir. Düzenleyiniz'>! ");
					return false;
				}	
		}
		document.upd_odenek.amount.value = filterNum(document.upd_odenek.amount.value);
		if(document.upd_odenek.amount_multiplier.value!='')
			document.upd_odenek.amount_multiplier.value = filterNum(document.upd_odenek.amount_multiplier.value,6);
		if(document.upd_odenek.gelir_vergisi_limiti.value!='')
            document.upd_odenek.gelir_vergisi_limiti.value = filterNum(document.upd_odenek.gelir_vergisi_limiti.value,4);	
            if(document.upd_odenek.gelir_vergisi_muafiyet_orani.value!='')
            document.upd_odenek.gelir_vergisi_muafiyet_orani.value = filterNum(document.upd_odenek.gelir_vergisi_muafiyet_orani.value,4);
		return true;
	}
    <cfif isDefined('attributes.draggable')>
        function deleteFunc() {
            openBoxDraggable('<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_del_odenek&ODKES_ID=#ATTRIBUTES.ODKES_ID#</cfoutput>',<cfoutput>#attributes.modal_id#</cfoutput>);
        }
    </cfif>
    function set_rules()
    {
        dynamic_rules_id = $("#dynamic_rules_id").val();
        if(dynamic_rules_id == 1)
        {
            $('#item-extra_payment_id').css('display','');
        }
        else
        {
            $('#item-extra_payment_id').css('display','none');
        }
    }
    function change_calc_days()
    {
        calc_days_val = $("#calc_days").val();
        if(calc_days_val == 3)
        {
            $('#METHOD option[value=1]').prop("disabled", true);
            $('#METHOD option[value=2]').prop("disabled", true);
            $('#METHOD option[value=3]').prop("disabled", true);
            $('#METHOD option[value=4]').prop("selected", true);
            $('#METHOD option[value=5]').prop("disabled", true);
            $('#METHOD option[value=6]').prop("disabled", true);
            $('#METHOD option[value=7]').prop("disabled", true);
            $('#METHOD option[value=8]').prop("disabled", true);
            
        }
        else
        {
            $('#METHOD option[value=1]').prop("disabled", false);
            $('#METHOD option[value=2]').prop("disabled", false);
            $('#METHOD option[value=3]').prop("disabled", false);
            $('#METHOD option[value=4]').prop("selected", false);
            $('#METHOD option[value=5]').prop("disabled", false);
            $('#METHOD option[value=6]').prop("disabled", false);
            $('#METHOD option[value=7]').prop("disabled", false);
            $('#METHOD option[value=8]').prop("disabled", false);
        }
    }
</script>
