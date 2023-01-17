<cfsavecontent variable="message"><cf_get_lang dictionary_id='48911.Wex Yetkilendirme İşlemleri'></cfsavecontent>
<cf_popup_box title="#message#">

<cfset wex_authorization = createObject("component","V16.objects.cfc.wex_authorization")>
<cfset get_wex_authorization_list = wex_authorization.select(auth_id:attributes.auth_id)>

<cfform name="upd_wex_authorization" method="post" action="#request.self#?fuseaction=objects.emptypopup_upd_wex_authotization">
<cfinput type="hidden" name="auth_id" value="#attributes.auth_id#">
<div class="row">
	<div class="col col-12 uniqueRow">
    	<div class="row formContent">
        	<div class="row" type="row">
            	<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-subscription_no">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29502.Abone No'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfinput type="hidden" name="subscription_id" id="subscription_id" value="#get_wex_authorization_list.SUBSCRIPTION_ID#">
                                <cfinput type="text" name="subscription_no" id="subscription_no" value="#get_wex_authorization_list.SUBSCRIPTION_NO#" readonly>
                                <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_subscription&field_id=upd_wex_authorization.subscription_id&field_no=upd_wex_authorization.subscription_no&call_function=getCounterType','list','popup_list_subscription');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-counter_type">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41282.Sayaç Tipi'> - <cf_get_lang dictionary_id='48871.Sayaç No'> *</label>
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
                                <cfinput type="hidden" name="company_id" id="company_id" value="#get_wex_authorization_list.COMPANY_ID#">
                                <cfinput type="text" name="company" id="company" value="#get_wex_authorization_list.FULLNAME#" readonly>
                                <span class="input-group-addon btn_Pointer icon-ellipsis" href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=upd_wex_authorization.company_id&is_period_kontrol=0&field_comp_name=upd_wex_authorization.company&select_list=2</cfoutput>','list');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-domain">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57892.Domain'>*</label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable = "message"><cf_get_lang dictionary_id='60327.Domain alani bos gecilemez'></cfsavecontent>
                            <cfinput type="text" name="domain" id="domain" value="#get_wex_authorization_list.DOMAIN#" required="yes" message="#message#">
                        </div>
                    </div>
                    <div class="form-group" id="item-ipControl">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='47987.IP'>*</label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable = "message"><cf_get_lang dictionary_id='60328.IP alanı boş geçilmez'></cfsavecontent>
                            <cfinput type="text" name="ipNo" id="ipNo" value="#get_wex_authorization_list.IP#" required="yes" message="#message#">
                        </div>
                    </div>
                    <div class="form-group" id="item-password">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57552.Şifre'>*</label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable = "message"><cf_get_lang dictionary_id='60329.Şifre alani bos gecilemez'></cfsavecontent>
                            <cfinput type="password" name="password" id="password" value="#get_wex_authorization_list.PASSWORD#" required="yes" message="#message#">
                        </div>
                    </div>
                    <div class="form-group" id="item-password">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49523.SMS'>*</label>
                        <div class="col col-8 col-xs-12">
                            <input type="checkbox" name="sms_control" id="sms_control" value="1" <cfif get_wex_authorization_list.IS_SMS eq 1>checked</cfif>>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row formContentFooter">
                <div class="col col-12">
                    <cf_workcube_buttons is_upd="1" add_function='kontrol()' delete_page_url="#request.self#?fuseaction=objects.emptypopup_upd_wex_authotization&is_del=1&auth_id=#attributes.auth_id#">
                </div>
            </div>
        </div>
    </div>
</div>
</cfform>

<script>

    getCounterType(<cfoutput>#get_wex_authorization_list.COUNTER_ID#</cfoutput>);

    function kontrol(){
        if(document.add_wex_authorization.subscription_no.value == '' || document.add_wex_authorization.subscription_id.value == ''){
            alert("<cf_get_lang dictionary_id='50995.Abone Seçiniz'>!");
            return false;
        }
        if(document.add_wex_authorization.counter_id.value == ''){
            alert("<cf_get_lang dictionary_id='41282.Sayaç Tipi'> - <cf_get_lang dictionary_id='60331.Sayaç No alanları boş gecilemez'> !"});
            return false;
        }
        if(document.add_subs_counter_pre.domain.value == ''){
            alert("<cf_get_lang dictionary_id='60327.Domain alani bos gecilemez'>!");
            return false;
        }
        if(document.add_subs_counter_pre.ipNo.value == ''){
            alert("<cf_get_lang dictionary_id='60328.IP alani bos gecilemez'>!");
            return false;
        }
        if(document.add_subs_counter_pre.password.value == ''){
            alert("<cf_get_lang dictionary_id='60328.IP alani bos gecilemez'>!");
            return false;
        }
        return false;
    }

    function getCounterType(counter_id = 0){
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
                    var option = $("<option>");
                    if(counter_id == item.COUNTER_ID) option.attr({"selected":"selected"});
                    option.attr({"value":""+item.COUNTER_ID+""}).text(item.COUNTER_TYPE + " - " + item.COUNTER_NO).appendTo("select#counter_id");
                });
            }
        });
    }
</script>