<cfsavecontent variable="message"><cf_get_lang dictionary_id='48911.Wex Yetkilendirme İşlemleri'></cfsavecontent>
<cf_popup_box title="#message#">
<cfform name="add_wex_authorization" method="post" action="#request.self#?fuseaction=objects.emptypopup_add_wex_authotization">
<cfinput type="hidden" name="wex_id" value="#attributes.wex_id#">
<div class="row">
	<div class="col col-12 uniqueRow">
    	<div class="row formContent">
        	<div class="row" type="row">
            	<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-subscription_no">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29502.Abone No'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfinput type="hidden" name="subscription_id" id="subscription_id">
                                <cfinput type="text" name="subscription_no" id="subscription_no" readonly>
                                <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_subscription&field_id=add_wex_authorization.subscription_id&field_no=add_wex_authorization.subscription_no&call_function=getCounterType','list','popup_list_subscription');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-counter_type">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41282.Sayaç Tipi'> - <cf_get_lang dictionary_id='48871.Sayaç No'></label>
                        <div class="col col-8 col-xs-12">
                            <select id="counter_id" name="counter_id">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-company">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfinput type="hidden" name="company_id" id="company_id">
                                <cfinput type="text" name="company" id="company" readonly>
                                <span class="input-group-addon btn_Pointer icon-ellipsis" href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=add_wex_authorization.company_id&is_period_kontrol=0&field_comp_name=add_wex_authorization.company&select_list=2</cfoutput>','list');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-domain">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57892.Domain'></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="domain" id="domain">
                        </div>
                    </div>
                    <div class="form-group" id="item-ipControl">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='47987.IP'></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="ipNo" id="ipNo">
                        </div>
                    </div>
                    <div class="form-group" id="item-password">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57552.Şifre'></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="password" name="password" id="password">
                        </div>
                    </div>
                    <div class="form-group" id="item-password">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49523.SMS'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="checkbox" name="sms_control" value="1">
                        </div>
                    </div>
                </div>
            </div>
            <div class="row formContentFooter">
                <div class="col col-12">
                    <cf_workcube_buttons>
                </div>
            </div>
        </div>
    </div>
</div>
</cfform>

<script>

    function getCounterType(){
        Array.prototype.map.call($("select#counter_id option"), function(obj) {
            if(obj.value != "" || obj.value != 0) obj.remove();
        });
        var ajaxConn = GetAjaxConnector();
        var subscription_id = document.getElementById("subscription_id").value;
        var url = "<cfoutput>#request.self#</cfoutput>?fuseaction=sales.emptypopup_list_subscription_counter&type=1&isajax=1&subscription_id=" + subscription_id;
		AjaxRequest(ajaxConn, url, 'GET', '', function(){
            if (ajaxConn.readyState == 4 && ajaxConn.status == 200){
                var response = JSON.parse(ajaxConn.responseText);
                response.forEach(item => {
                    $("<option>").attr({"value":""+item.COUNTER_ID+""}).text(item.COUNTER_TYPE + " - " + item.COUNTER_NO).appendTo("select#counter_id");
                });
            }
        });
    }
</script>