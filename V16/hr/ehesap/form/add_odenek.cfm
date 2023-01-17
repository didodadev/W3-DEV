<cfinclude template="../query/get_moneys.cfm">
<cfquery name="get_ch_types" datasource="#dsn#">
	SELECT ACC_TYPE_ID,ACC_TYPE_NAME FROM SETUP_ACC_TYPE ORDER BY ACC_TYPE_NAME
</cfquery>
<cfset get_component = createObject("component","V16.hr.cfc.project_allowance")>
<cfset get_allowance = get_component.get_allowance(from_payment: 1)>

<cf_box title="#getLang('','Ek Ödenek Tanımları',45827)# #getLang('','Kayıt',57483)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="add_odenek" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_add_odenek">
        <cf_box_elements>
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-is_active">
                    <label class="col col-4 col-xs-12"><span class="hide"><cf_get_lang dictionary_id='57493.Aktif'></span></label>
                    <div class="col col-8 col-xs-12">
                        <label><cf_get_lang dictionary_id='57493.Aktif'> <input type="checkbox" name="is_active" id="is_active" value="1" checked></label>
                        <label><cf_get_lang dictionary_id='55712.Bordroda'> <input type="checkbox" name="show" id="show" value="1" checked onchange="control_chckbx(this.id)"></label>
                    </div>
                </div>
                <div class="form-group" id="item-ssk_statue">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53606.SSK Durumu'></label>
                    <div class="col col-8 col-xs-12">
                        <cfsavecontent variable="header_"><cf_get_lang dictionary_id='53606.SSK Durumu'></cfsavecontent>
                        <select  name="ssk_statue" id="ssk_statue" onchange="change_ssk_statue(this.value)">
                            <option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <option value="1"><cf_get_lang dictionary_id='45049.Worker'></option>
                            <option value="2"><cf_get_lang dictionary_id='62870.Memur'></option>
                            <option value="3"><cf_get_lang dictionary_id='62871.Serbest Çalışan'></option>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="statue_type_div" style="display:none">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='63047.Bordro Tipi'></label>
                    <div class="col col-8 col-xs-12">
                        <select name="statue_type" id="statue_type">
                            <option value="0"><cf_get_lang dictionary_id='30152.Tipi'></option>
                            <option value="1"><cf_get_lang dictionary_id='40071.Maaş'></option>
                            <option value="2"><cf_get_lang dictionary_id='62888.Döner Sermaye'></option>
                            <option value="3"><cf_get_lang dictionary_id='62956.Ek Ders'></option>
                            <option value="4"><cf_get_lang dictionary_id='58015.Projeler'></option>
                            <option value="6"><cf_get_lang dictionary_id='64673.Jüri Üyeliği'></option>
                            <option value="8"><cf_get_lang dictionary_id='63103.Sanatçı'></option>
                            <option value="10"><cf_get_lang dictionary_id='65182.Münferit Ödeme'></option>
                        </select>
                    </div>
				</div>
                <div class="form-group" id="item-comment">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58233.Tanım'>*</label>
                    <div class="col col-8 col-xs-12">
                        <cfsavecontent variable="message1"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='58233.Tanım'></cfsavecontent>
                        <cfinput type="text" name="comment" value="" required="yes" message="#message1#">
                    </div>
                </div>
                <div class="form-group" id="item-amount">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57673.Tutar'>*</label>
                    <div class="col col-6 col-xs-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='57673.Tutar'></cfsavecontent>
                        <cfinput required="yes" message="#message#" type="text" name="amount" value="" onkeyup="return(FormatCurrency(this,event));">
                    </div>
                    <div class="col col-2 col-xs-12">
                        <select name="money" id="money">
                            <cfoutput query="get_moneys">
                                <option value="#money#" <cfif session.ep.money is money>selected</cfif>>#money#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-SSK">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58714.SSK'></label>
                    <div class="col col-8 col-xs-12">
                        <select name="SSK" id="SSK">
                            <option value="1"><cf_get_lang dictionary_id='55626.Muaf'></option>
                            <option value="2" selected="selected"><cf_get_lang dictionary_id='53402.Muaf Değil'></option>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-TAX">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59181.Vergi'></label>
                    <div class="col col-8 col-xs-12">
                        <select name="TAX" id="TAX">
                            <option value="1"><cf_get_lang dictionary_id='55626.Muaf'></option>
                            <option value="2" selected="selected"><cf_get_lang dictionary_id='53402.Muaf Değil'></option>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-is_damga">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='53252.Damga Vergisi'></label>
                    <div class="col col-8 col-xs-12">
                        <select name="is_damga" id="is_damga">
                            <option value="1"><cf_get_lang dictionary_id='53402.Muaf Değil'></option>
                            <option value="0"><cf_get_lang dictionary_id='55626.Muaf'></option>							
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-is_issizlik">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='54034.İşsizlik Payı'></label>
                    <div class="col col-8 col-xs-12">
                        <select name="is_issizlik" id="is_issizlik">
                            <option value="1"><cf_get_lang dictionary_id='53402.Muaf Değil'></option>
                            <option value="0"><cf_get_lang dictionary_id='55626.Muaf'></option>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-calc_days">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="53970.Tutar Günü"></label>
                    <div class="col col-8 col-xs-12">
                        <select name="calc_days" id="calc_days" onchange="change_calc_days(this.value)">
                            <option value="0"><cf_get_lang dictionary_id="57708.Tümü"></option>
                            <option value="1"><cf_get_lang dictionary_id="57490.Gün"></option>
                            <option value="2"><cf_get_lang dictionary_id="53968.Fiili Gün"></option>
                            <option value="3"><cf_get_lang dictionary_id='64547.Çalışılan Saat'></option>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-SSK_EXEMPTION_TYPE">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59310.SGK Muafiyet Tipi'></label>
                    <div class="col col-8 col-xs-12">
                        <select name="SSK_EXEMPTION_TYPE" id="SSK_EXEMPTION_TYPE">
                            <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                            <option value="1"><cf_get_lang dictionary_id="54012.Tutara Göre"></option>
                            <option value="0"><cf_get_lang dictionary_id="54019.Asgari Ücrete Göre"></option>
                            <option value="2"><cf_get_lang dictionary_id="58457.Günlük"> <cf_get_lang dictionary_id="54019.Asgari Ücrete Göre"></option>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-ssk_muafiyet_orani">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="53973.SGK Muafiyet Oranı"></label>
                    <div class="col col-8 col-xs-12">
                        <cfinput type="text" name="ssk_muafiyet_orani" value="" validate="integer" message="#getLang('','SGK Muafiyet Oranı',53973)#">
                    </div>
                </div>
                <div class="form-group" id="item-gelir_vergisi_muafiyet_orani">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="53998.gelir Vergisi muafiyet tutarı"></label>
                    <div class="col col-8 col-xs-12">
                        <cfinput type="text" name="gelir_vergisi_muafiyet_orani" value="" message="#getLang('','Gelir Vergisi Muafiyet Oranı',53988)#">
                    </div>
                </div>
                <div class="form-group" id="item-gelir_vergisi_limiti">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="53988.Gelir Vergisi Muafiyet Oranı"></label>
                    <div class="col col-8 col-xs-12">
                        <input type="text" name="gelir_vergisi_limiti" id="gelir_vergisi_limiti" value="" onkeyup="return(FormatCurrency(this,event,4));">
                    </div>
                </div>
            </div>  
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                <div class="form-group" id="item-PERIOD">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55238.Periyod'></label>
                    <div class="col col-8 col-xs-12">
                        <select name="PERIOD" id="PERIOD">
                            <option value="1"><cf_get_lang dictionary_id='55936.Ayda'>1</option>
                            <option value="2">3 <cf_get_lang dictionary_id='55936.Ayda'> 1</option>
                            <option value="3">6 <cf_get_lang dictionary_id='55936.Ayda'> 1</option>
                            <option value="4"><cf_get_lang dictionary_id='53312.Yılda'> 1</option>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-METHOD">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="29472.Yöntem"></label>
                    <div class="col col-8 col-xs-12">
                        <select name="METHOD" id="METHOD">
                            <option value="1"><cf_get_lang dictionary_id='53136.Artı'></option>
                            <option value="2">% <cf_get_lang dictionary_id="53243.Aylık Ücret"></option>
                            <option value="3">%<cf_get_lang dictionary_id="53242.Günlük Ücret"></option>
                            <option value="4">% <cf_get_lang dictionary_id="53260.Saatlik"> <cf_get_lang dictionary_id="55123.Ücret"></option>
                            <option value="5"><cf_get_lang dictionary_id='57491.Saat'> x <cf_get_lang dictionary_id='63048.Ödenek Tutarı'></option>
                            <option value="6"><cf_get_lang dictionary_id='57491.Saat'> x <cf_get_lang dictionary_id='63396.N.Ö. Gündüz'></option>
                            <option value="7"><cf_get_lang dictionary_id='57491.Saat'> x <cf_get_lang dictionary_id='63397.N.Ö. Gece ve Tatillerde'></option>
                            <option value="8"><cf_get_lang dictionary_id='57491.Saat'> x <cf_get_lang dictionary_id='63398.İ.Ö. Gece'></option>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-acc_type_id">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="53329.Hesap Tipi"></label>
                    <div class="col col-8 col-xs-12">
                        <select name="acc_type_id" id="acc_type_id">
                            <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                            <cfoutput query="get_ch_types">
                                <option value="#acc_type_id#">#acc_type_name#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-from_salary">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='54032.Net/Brüt'></label>
                    <div class="col col-8 col-xs-12">
                        <select name="from_salary" id="from_salary">
                            <option value="0"><cf_get_lang dictionary_id='54032.Net'></option>
                            <option value="1" selected><cf_get_lang dictionary_id ='56257.Brüt'></option>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-comment_type">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59311.Ödenek Tipi'></label>
                    <div class="col col-8 col-xs-12">
                        <select name="comment_type">
                            <option value="1"><cf_get_lang dictionary_id='56249.Ek Ödenek'></option>
                            <option value="2"><cf_get_lang dictionary_id='53971.Kazanç'></option>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-dynamic_rules">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='64456.Dinamik Kural'></label>
                    <div class="col col-8 col-xs-12">
                        <select name="dynamic_rules_id" id="dynamic_rules_id" onchange="set_rules()">
                            <option value=""><cf_get_lang dictionary_id='64460.Kural Seçiniz'></option>
                            <option value="1"><cf_get_lang dictionary_id='53136.Artı'> <cf_get_lang dictionary_id="53082.Ek Ödenek"></option>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-extra_payment_id">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56249.Ek Ödenek'></label>
                    <div class="col col-8 col-xs-12">
                        <cf_multiselect_check
                            name="extra_payment_id"
                            option_name="comment_pay"
                            option_value="odkes_id"
                            query_name="get_allowance">
                    </div>
                </div>
                
                <div class="form-group" id="item-start_sal_mon">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57501.Başlangıç'></label>
                    <div class="col col-4 col-xs-12">
                        <cfoutput>
                            <select name="start_sal_mon" id="start_sal_mon">
                                <cfloop from="1" to="12" index="j">
                                    <option value="#j#">#listgetat(ay_list(),j,',')#</option>
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
                                    <option value="#j#">#listgetat(ay_list(),j,',')#</option>
                                </cfloop>
                            </select>
                        </cfoutput>
                    </div>
                </div>
                <div class="form-group" id="item-amount_multiplier">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58865.Çarpan"></label>
                    <div class="col col-4 col-xs-12">
                        <cfinput type="text" name="amount_multiplier" value="" onkeyup="return(FormatCurrency(this,event,6));">
                    </div>
                </div>
                <div class="form-group" id="item-is_kidem">
                    <label class="col col-4 col-xs-12"><span class="hide"><cf_get_lang dictionary_id='53333.Kıdeme Dahil'></span></label>
                    <label class="col col-8 col-xs-12">
                        <input type="checkbox" name="is_kidem" id="is_kidem" value="1" checked> <cf_get_lang dictionary_id='53333.Kıdeme Dahil'>
                    </label>
                </div>
                <div class="form-group" id="item-is_income">
                    <label class="col col-4 col-xs-12"><span class="hide"><cf_get_lang dictionary_id='59312.Kazançlara Dahil'></span></label>
                    <label class="col col-8 col-xs-12">
                        <input type="checkbox" name="is_income" id="is_income" value="1"><cf_get_lang dictionary_id='59312.Kazançlara Dahil'>
                    </label>
                </div>
                <cfif isdefined("is_gov_payroll") and is_gov_payroll eq 1>
                <div class="form-group" id="item-factor_type">
                    <label class="col col-4 col-xs-12"><span class="hide"><cf_get_lang dictionary_id='36455.Katsayı'></span></label>
                    <div class="col col-8 col-xs-12">
                        <select name="factor_type">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <option value="1"><cf_get_lang dictionary_id='59313.Aylık Katsayı'></option>
                            <option value="2"><cf_get_lang dictionary_id='59314.Taban Aylık Katsayı'></option>
                            <option value="3"><cf_get_lang dictionary_id='59315.Yan Ödeme Katsayısı'></option>
                        </select>
                    </div>
                </div>
                </cfif>
                <div class="form-group" id="item-ayni_yardım">
                    <label class="col col-4 col-xs-12"><span class="hide"><cf_get_lang dictionary_id="53972.Aynı Yardım"></span></label>
                    <div class="col col-8 col-xs-12">
                        <input type="checkbox" name="ayni_yardım" id="ayni_yardım" value="1" onchange="control_chckbx(this.id)"> <cf_get_lang dictionary_id="53972.Aynı Yardım">
                    </div>
                </div>
                <div class="form-group" id="item-is_not_execution">
                    <label class="col col-4 col-xs-12"><span class="hide"><cf_get_lang dictionary_id='59316.İcraya Dahil Değil'></span></label>
                    <div class="col col-8 col-xs-12">
                        <input type="checkbox" name="is_not_execution" id="is_not_execution" value="1"> <cf_get_lang dictionary_id='59316.İcraya Dahil Değil'>              
                    </div>
                </div>
                <div class="form-group" id="item-child_help">
                    <label class="col col-4 col-xs-12"><span class="hide"><cf_get_lang dictionary_id='46080.Çocuk yardımı'></span></label>
                    <div class="col col-8 col-xs-12">
                        <input type="checkbox" name="child_help" id="child_help" value="1"> <cf_get_lang dictionary_id='46080.Çocuk yardımı'>
                    </div>
                </div>
                <div class="form-group" id="item-is_rd_gelir">
                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='59693.Arge Muafiyet'></label>
                </div>
                <div class="form-group" id="item-is_rd_damga">
                    <label class="col col-4 col-xs-12"><span class="hide"><cf_get_lang dictionary_id ='53252.Damga Vergisi'></span></label>
                    <div class="col col-8 col-xs-12">
                    <input type="checkbox" name="is_rd_damga" id="is_rd_damga" value="1"> <cf_get_lang dictionary_id ='53252.Damga Vergisi'>
                    </div>
                </div>
                <div class="form-group" id="item-is_rd_gelir">
                    <label class="col col-4 col-xs-12"><span class="hide"><cf_get_lang dictionary_id ='53250.Gelir Vergisi'></span></label>
                    <div class="col col-8 col-xs-12">
                        <input type="checkbox" name="is_rd_gelir" id="is_rd_gelir" value="1"> <cf_get_lang dictionary_id ='53250.Gelir Vergisi'>                                   
                    </div>
                </div>
                <div class="form-group" id="item-is_rd_ssk">
                    <label class="col col-4 col-xs-12"><span class="hide"><cf_get_lang dictionary_id ='53245.SGK Matrahı'></span></label>
                    <div class="col col-8 col-xs-12">
                        <input type="checkbox" name="is_rd_ssk" id="is_rd_ssk" value="1"><cf_get_lang dictionary_id ='53245.SGK Matrahı'>  
                    </div>
                </div>       
            </div>  
        </cf_box_elements>
        <cf_box_footer>
            <cf_workcube_buttons is_upd='0' add_function="#iif(isdefined("attributes.draggable"),DE("form_chk() && loadPopupBox('add_odenek' , #attributes.modal_id#)"),DE(""))#">
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

		if(document.add_odenek.ayni_yardım.checked==true)
		{  
			if(document.add_odenek.show.checked==true)
				{
				alert("<cf_get_lang dictionary_id='54603.Ayni Yardım ile Bordroyu Aynı Anda Seçemezsiniz'>!");
				return false;
				}
				
			if(document.add_odenek.is_kidem.checked==false)
				{
					alert("<cf_get_lang dictionary_id='62839.Ayni Yardım Kıdeme Dahil Bir Ödenektir'>! ");
					return false;
				}	
		}
		 add_odenek.amount.value = filterNum(add_odenek.amount.value);
		 if(document.add_odenek.amount_multiplier.value!='')
			document.add_odenek.amount_multiplier.value = filterNum(document.add_odenek.amount_multiplier.value,6);
		if(document.add_odenek.gelir_vergisi_limiti.value!='')
            document.add_odenek.gelir_vergisi_limiti.value = filterNum(document.add_odenek.gelir_vergisi_limiti.value,4);
        if(document.add_odenek.gelir_vergisi_muafiyet_orani.value!='')
            document.add_odenek.gelir_vergisi_muafiyet_orani.value = filterNum(document.add_odenek.gelir_vergisi_muafiyet_orani.value,4);
		return true;
	}
	function control_chckbx(i)
	{
		if ($('#'+i).attr("checked"))
			if (i == 'show')
				$('#ayni_yardım').attr('checked',false);
			else
				$('#show').attr('checked',false);
	}
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
</script>
