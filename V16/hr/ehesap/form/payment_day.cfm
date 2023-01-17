<cfsavecontent variable = "title"><cf_get_lang dictionary_id = '54821.Ödeme Günü'></cfsavecontent>
<cfinclude template="../query/get_puantaj.cfm">
<cf_box title = "#title#">
    <div class="row">
		<div class="col col-12 uniqueRow">
            <div class="row" type="row">
                <div class="col col-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group col col-8" id="item-payment_day">      
                        <cfoutput> 
                            <label class = "col col-4">#title#</label>
                            <div class="input-group" id="item-payment_day">
                                <input type="text" name="payment_day" id="payment_day" style=""  value="#dateFormat(get_puantaj.payment_date,dateformat_style)#">   
                                <span class="input-group-addon"><cf_wrk_date_image date_field="payment_day"></span>
                            </div>
                        </cfoutput>
                    </div>
                    <div class="form-group" id="item-button">
                        <cf_workcube_buttons is_upd='0' is_cancel='0' add_function="save_form()">
                    </div>
                </div>
            </div>
        </div>
    </div>
</cf_box>
<script>
    function save_form(){
        payment_day =document.getElementById("payment_day").value;
        puantaj_id = '<cfoutput>#attributes.puantaj_id#</cfoutput>';
        $.ajax({ 
                type:'POST',  
                url:'V16/hr/ehesap/cfc/payment_day.cfc?method=UPDATE_PAYMENT_DAY',  
                data: { 
                payment_day : payment_day,
                puantaj_id : puantaj_id
            },
            success: function (returnData) {  
                location.reload();
            },
            error: function () 
            {
                console.log('CODE:8 please, try again..');
                return false; 
            }
        }); 
    }
</script>