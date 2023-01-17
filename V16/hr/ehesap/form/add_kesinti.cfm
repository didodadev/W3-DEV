<cf_xml_page_edit fuseact="ehesap.popup_form_add_kesinti">
<cfinclude template="../query/get_moneys.cfm">
<cfquery name="get_ch_types" datasource="#dsn#">
    SELECT 
        ACC_TYPE_ID,
        ACC_TYPE_NAME,
        RECORD_EMP,
        RECORD_IP,
        RECORD_DATE,
        UPDATE_EMP,
        UPDATE_IP,
        UPDATE_DATE 
    FROM 
	    SETUP_ACC_TYPE 
    ORDER BY 
    	ACC_TYPE_NAME
</cfquery>
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
    <cf_box>
        <cfform name="add_odenek" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_add_kesinti">
            <cf_box_elements>
                <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-is_active">
                        <label class="col col-4 col-xs-12"><span class="hide"><cf_get_lang dictionary_id='57493.Aktif'></span></label>
                        <div class="col col-4 col-xs-12">
                            <label><cf_get_lang dictionary_id='57493.Aktif'><input type="checkbox" name="is_active" id="is_active" value="1" checked></label>
                        </div>
                        <div class="col col-4 col-xs-12">
                            <label><cf_get_lang dictionary_id='53179.Bordroda'><input type="checkbox" name="show" id="show" value="1" checked></label>
                        </div>
                    </div>
                    <div class="form-group" id="item-comment">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58233.Tanım'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="comment" id="comment" value="">
                        </div>
                    </div>
                    <div class="form-group" id="item-PERIOD">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53310.Periyod'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="PERIOD" id="PERIOD">
                                <option value="1"><cf_get_lang dictionary_id='53311.Ayda'> 1</option>
                                <option value="2">3 <cf_get_lang dictionary_id='53311.Ayda'> 1</option>
                                <option value="3">6 <cf_get_lang dictionary_id='53311.Ayda'> 1</option>
                                <option value="4"><cf_get_lang dictionary_id='53312.Yılda'> 1</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-METHOD">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="29472.Yöntem"></label>
                        <div class="col col-8 col-xs-12">
                            <select name="METHOD" id="METHOD">
                                <option value="1"><cf_get_lang dictionary_id='53134.Eksi'></option>
                                <option value="2">% <cf_get_lang dictionary_id="58724.Ay"></option>
                                <option value="3">% <cf_get_lang dictionary_id="57490.Gün"></option>
                                <option value="4">% <cf_get_lang dictionary_id="57491.Saat"></option>
                                <option value="5">% <cf_get_lang dictionary_id="53971.Kazanç"></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-from_salary">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='54032.Net / Brüt'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="from_salary" id="from_salary">
                                <option value="0"><cf_get_lang dictionary_id='53145.Net Ücretden Kesilsin'></option>
                                <option value="1"><cf_get_lang dictionary_id='53507.Brüt Ücretden Kesilsin'></option>
                            </select>
                        </div>
                    </div>
                    <cfif is_show_account_code eq 1>
                        <div class="form-group" id="item-account_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="hidden" name="account_code" id="account_code" >
                                    <cfinput type="Text" name="account_name" id="account_name" onFocus="AutoComplete_Create('account_name','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','','ACCOUNT_CODE,ACCOUNT_NAME','account_code,account_name','','3','225');">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_name=add_odenek.account_name&field_id=add_odenek.account_code','list');" title="<cf_get_lang dictionary_id='58811.Muhasebe Kodu'>"></span>
                                </div>
                            </div>
                        </div>
                    </cfif>
                    <div class="form-group" id="item-calc_days">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="53967.Kesinti Günü"></label>
                        <div class="col col-8 col-xs-12">
                            <select name="calc_days" id="calc_days">
                                <option value="0"><cf_get_lang dictionary_id="57708.Tümü"></option>
                                <option value="1"><cf_get_lang dictionary_id="57490.Gün"></option>
                                <option value="2"><cf_get_lang dictionary_id="53968.Fiili Gün"></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-TAX">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="53969.Vergi Muafiyeti"></label>
                        <div class="col col-8 col-xs-12">
                            <select name="TAX" id="TAX">
                                <option value="1"><cf_get_lang dictionary_id="53250.Gelir Vergisi"> + <cf_get_lang dictionary_id="53252.Damga Vergisi"></option>
                                <option value="3"><cf_get_lang dictionary_id="53250.Gelir Vergisi"></option>
                                <option value="2" selected="selected"><cf_get_lang dictionary_id="53402.Muaf Değil"></option>
                            </select>
                        </div>
                    </div>
                    <cfif is_show_member_type eq 1>
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
                    </cfif>
                </div>  
                <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-amount">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57635.Miktar'></label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57635.miktar'></cfsavecontent>
                            <cfinput required="yes" message="#message#" type="text" name="amount" value="" onkeyup="return(FormatCurrency(this,event));">
                        </div>
                    </div>
                    <div class="form-group" id="item-start_sal_mon">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57501.Başlangıç'></label>
                        <div class="col col-8 col-xs-12">
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
                        <div class="col col-8 col-xs-12">
                            <cfoutput>
                                <select name="end_sal_mon" id="end_sal_mon">
                                    <cfloop from="1" to="12" index="j">
                                        <option value="#j#">#listgetat(ay_list(),j,',')#</option>
                                    </cfloop>
                                </select>
                            </cfoutput>
                        </div>
                    </div>
                    <div class="form-group" id="item-money">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57489.Para Birimi"></label>
                        <div class="col col-8 col-xs-12">
                            <select name="money" id="money">
                                <cfoutput query="get_moneys">
                                    <option value="#money#" <cfif session.ep.money is money>selected</cfif>>#money#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <cfif is_show_member eq 1>
                        <div class="form-group" id="item-member_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="company_id" id="company_id">
                                    <input type="hidden" name="consumer_id" id="consumer_id">
                                    <cfinput  name="member_name" id="member_name" type="text" value="" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'\',\'0\',\'0\',\'2\',\'0\'','COMPANY_ID,CONSUMER_ID','company_id,consumer_id','','3','180','');">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_consumer=add_odenek.consumer_id&select_list=2,3&field_comp_name=add_odenek.member_name&field_comp_id=add_odenek.company_id&field_member_name=add_odenek.member_name</cfoutput>','list')" title="<cf_get_lang_main no='107.Cari Hesap'>"></span>
                                </div>
                            </div>
                        </div>
                    </cfif>
                    <div class="form-group" id="item-is_inst_avans">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='54036.Taksitlendirilmiş Avans'></label>
                        <label class="col col-8 col-xs-12">
                            <input type="checkbox" name="is_inst_avans" id="is_inst_avans" value="1">              
                        </label>
                    </div>
                    <div class="form-group" id="item-is_demand">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59317.Avans Taleplerinde Seçilebilir"></label>
                        <label class="col col-8 col-xs-12">
                            <input type="checkbox" name="is_demand" id="is_demand" value="1">              
                        </label>
                    </div>
                    <div class="form-group" id="item-is_disciplinary_punishment">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43318.Disiplin Cezası'></label>
                        <label class="col col-8 col-xs-12">
                            <input type="checkbox" name="is_disciplinary_punishment" id="is_disciplinary_punishment" value="1">              
                        </label>
                    </div>
                    <cf_duxi name="is_union_information" type="checkbox"  data="" value="1" label="65022" hint="sendika kesintisi">
                    <div class="form-group" id="item-is_net_to_gross" style="display:none">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='65416.Net Ücretse Brüt Olarak Kesilsin'></label>
                        <label class="col col-8 col-xs-12">
                            <input type="checkbox" name="is_net_to_gross" id="is_net_to_gross" value="1">              
                        </label>
                    </div>
                </div>  
                <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="3" sort="true" id="union_information_div" style="display:none">
                    <cf_duxi type="text" name="union_information_name" hint="Sendika adı" label="64957">
                    <cf_duxi type="text" name="union_information_address" hint="adres" label="63895">
                    <cf_duxi type="text" name="union_information_bank_name" hint="banka adı" label="30349">
                    <cf_duxi type="text" name="union_information_branch_name" hint="şube adı" label="29532">
                    <cf_duxi type="text" name="union_information_account_name" hint="hesap numarası" label="58178">
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-12">
                    <cf_workcube_buttons is_upd='0' add_function='form_chk()'>
                </div>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	function form_chk()
	{
		add_odenek.amount.value = filterNum(add_odenek.amount.value);
		return true;
	}
    $( "#is_union_information" ).on( "click", function() {
        open_info_div();
    });

    $( "#from_salary" ).change(function() {
        if($(this).val() == 1)
        {
            $("#item-is_net_to_gross").show();
        }else{
            $("#item-is_net_to_gross").hide();
        }
    });
    function open_info_div() {
        if ($('#is_union_information').is(':checked')) {
            $('#union_information_div').show();
        }else
        {
            $('#union_information_div').hide();
        }
    }
</script>
