<cfquery name="GET_STOCKBOND" datasource="#DSN3#">
    SELECT
        TOTAL_PURCHASE, OTHER_TOTAL_PURCHASE, STOCKBOND_ID, ROW_EXP_TAHAKKUK_ITEM_ID, DUE_VALUE
    FROM
        STOCKBONDS
    WHERE
    STOCKBONDS.STOCKBOND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stockbond_id#">
</cfquery>

<cf_box title="Getiri Planla" draggable="1" closable="1" design_type="1">
    <cfform name="upd_act_value" method="post" action="#request.self#?fuseaction=credit.emptypopup_stockbond_recurring_yield">
        <input type="hidden" name="submit" value="1">
        <input type="hidden" name="row_id" id="row_id" value="<cfoutput>#attributes.row_id#</cfoutput>">
        <input type="hidden" name="stockbond_id" id="stockbond_id" value="<cfoutput>#GET_STOCKBOND.stockbond_id#</cfoutput>">
        <input type="hidden" name="tahakkuk_item_id" id="tahakkuk_item_id" value="<cfoutput>#GET_STOCKBOND.ROW_EXP_TAHAKKUK_ITEM_ID#</cfoutput>">
            <div class="row" type="row">
                <div class="col col-6 col-md-11 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group">
                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <div class="input-group">
                                <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='59179.Ana Para'>*</label>
                                <input type="text" class="moneybox" name="total_purchase" id="total_purchase" value="<cfoutput>#TLFormat(GET_STOCKBOND.total_purchase)#</cfoutput>" onkeyup="return(FormatCurrency(this,event));" readonly>
                             </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58053.Baslangıç Tarihi'>*</label>
                        <div class="col col-12 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="action_date" id="action_date" validate="#validate_style#" value="#dateformat(now(),dateformat_style)#" maxlength="10" required="yes" message="Tarih Girmelisiniz!" onChange="change_paper_duedate('action_date',1);FaizHesapla('getiri_tutari')">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="action_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang_main no='228.Vade'>*</label>
                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <div class="input-group">
                                <input type="text" name="due_value" id="due_value" maxlength="50" value="<cfoutput>#GET_STOCKBOND.DUE_VALUE#</cfoutput>" onchange="change_paper_duedate('action_date');FaizHesapla('getiri_tutari')">
                                <span class="input-group-addon no-bg"></span>
                                <cfinput type="text" name="due_date" id="due_date" value="" validate="#validate_style#" maxlength="10" onChange="change_paper_duedate('action_date',1);FaizHesapla('getiri_tutari')">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="due_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <div class="input-group">
                                <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='51373.Getiri Oranı'>*</label>
                                <input type="text" class="moneybox" name="getiri_orani" id="getiri_orani" value="" onkeyup="return(FormatCurrency(this,event));" onchange="FaizHesapla(this.value,'1')" onblur="FaizHesapla('getiri_orani')">
                                <span class="input-group-addon no-bg"></span>
                                <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id="51374.Getiri Tutarı">*</label>
                                <input type="text" class="moneybox" name="getiri_tutari" id="getiri_tutari" value="" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" onchange="FaizHesapla(this.value,'1')" onblur="FaizHesapla('getiri_tutari')">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row formContentFooter">
                <div class="col col-12">
                    <div id="SHOW_INFO"></div>
                    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                </div>
            </div>
    </cfform>
</cf_box>
<script>

    change_paper_duedate('action_date');
    function kontrol(){
        if( $("#action_date").val() == '' || $("#due_value").val() == '' || $("#getiri_orani").val() == '' || $("#getiri_tutari").val() == '' ){
            alert("<cf_get_lang dictionary_id='29722.Zorunlu Alanları Doldurun'>");
            return false;
        }
        else{
            unformat_fields();
            AjaxFormSubmit(upd_act_value,'SHOW_INFO',1,'Ekleniyor','Eklendi');
            location.reload();
        }
        return false;
    }

    function unformat_fields()
    {
        $("#getiri_orani").val( filterNum( $("#getiri_orani").val(),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'));
        $("#getiri_tutari").val( filterNum( $("#getiri_tutari").val(),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'));
    }

    function change_paper_duedate(field_name,type,row) 
		{
			paper_date_=eval('document.upd_act_value.action_date.value');
			if(type!=undefined && type==1)
				document.getElementById('due_value').value = datediff(paper_date_,document.getElementById('due_date').value,0);
			else
			{
				if(isNumber(document.getElementById('due_value'))!= false && (document.getElementById('due_value').value != 0))
					document.getElementById('due_date').value = date_add('d',+document.getElementById('due_value').value,paper_date_);
				else
				{
					document.getElementById('due_date').value = paper_date_;
					if(document.getElementById('due_value').value == '')
						document.getElementById('due_value').value = datediff(paper_date_,document.getElementById('due_date').value,0);
				}
			}
	
        }
        
    function FaizHesapla(fieldName){
        var due_value = $("input[name=due_value]").val(); // vade günü
		var tutar = filterNum($("input[name=total_purchase]").val()); // tutar
        var getiri_tutari = filterNum($("input[name=getiri_tutari]").val()); // getiri tutarı
        
        if(due_value > 0) {
            if( tutar > 0 && tutar != '' ){
                var getiri_orani = filterNum($("input[name=getiri_orani]").val()); // getiri oranı 
                var getiri_orani_gunluk =  ( ( getiri_orani / 100 ) / 365 )  * due_value * tutar ;

                if(fieldName == 'getiri_orani') {
                    $("input[name=getiri_tutari]").val( commaSplit( getiri_orani_gunluk ,'2'));
                }else if(fieldName == 'getiri_tutari'){
                    var getiri_orani_currently = ( ( getiri_tutari * 365 ) / due_value / ( tutar / 100 ) );
                    $("input[name=getiri_orani]").val( commaSplit( getiri_orani_currently ,'4'));
                }    
            }  
        }
        else{
            $("input[name=getiri_orani]").val(0);
        }
    }

    $("div#warning_modal").css({"min-width": 200})

</script>
