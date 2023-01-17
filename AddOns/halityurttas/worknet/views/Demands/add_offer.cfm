<cfinclude template="../../config.cfm">
<cfif not isdefined("session_base.userid")>
	<cfinclude template="../objects/member_login.cfm">
<cfelse>
    <cf_get_lang_set>
    <cfset cmp = objectResolver.resolveByRequest("#addonNS#.components.demands.demand")>
    <cfset getDemand = cmp.getDemand(demand_id:attributes.demand_id)>
    <br>
    <div class="row">
        <div class="col col-12">
            <h4><cfoutput>#getDemand.fullname# / #getDemand.demand_head#</cfoutput></h4>
        </div>
    </div>
    <cfform name="add_demand_offer" action="#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['create-offer']['fuseaction']#" method="post" enctype="multipart/form-data">
        <input type="hidden" name="demand_id" id="demand_id" value="<cfoutput>#attributes.demand_id#</cfoutput>">
        <div style="display:none;"><cf_workcube_process is_upd='0' is_detail='0'></div>
        
        <div class="row">
            <div class="col col-12 uniqueRow">
                <div class="row formContent">
                    <div class="row" type="row">
                        <!--- col 1 --->
                        <div class="col col-12" type="column" index="1" sort="true">
                            <div class="form-group" id="item-total_amount">
                                <label class="col col-4 col-xs-12"><cf_get_lang no ='106.Toplam Bedel'></label>
                                <div class="col col-6 col-xs-8">
                                    <cfinput type="text" name="total_amount" id="total_amount" maxlength="38" style="width:100px;float:left; " passThrough="onkeyup=""return(FormatCurrency(this,event));""" class="moneybox">
                                </div>
                                <div class="col col-2 col-xs-4">
                                    <cfquery name="GET_MONEYS" datasource="#DSN#">
                                        SELECT MONEY_ID,MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #session_base.period_id#
                                    </cfquery>
                                    <select name="MONEY" style="width:50px;">
                                    <cfoutput query="get_moneys">
                                        <option value="#money#"<cfif money eq session_base.money>selected</cfif>>#money#</option>
                                    </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-today">
                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='233.Teslim Tarihi'></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="hidden" name="today" id="today" value="<cfoutput>#dateformat(now(),'dd/mm/yyyy')#</cfoutput>" />
                                    <div class="input-group">
                                        <input type="text" name="deliver_date" id="deliver_date" value="" maxlength="10" style="width:100px;">
                                        <div class="input-group-addon">
                                            <cf_wrk_date_image date_field="deliver_date">
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-deliver_addres">
                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='1037.Teslim Yeri'></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="deliver_addres" id="deliver_addres" value="" style="width:220px;" maxlength="250">
                                </div>
                            </div>
                            <div class="form-group" id="item-paymethod">
                                <label class="col col-4 col-xs-12"><cf_get_lang_main no ='1104.Ödeme Yöntemi'></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="paymethod" id="paymethod" value="" style="width:220px;" maxlength="250">
                                </div>
                            </div>
                            <div class="form-group" id="item-ship_method">
                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='1703.Sevk Yöntemi'></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="ship_method" id="ship_method" value="" style="width:220px;" maxlength="250">
                                </div>
                            </div>
                            <div class="form-group" id="item-offer_file">
                                <label class="col col-4 col-xs-12"><cf_get_lang_main no ='56.Belge'></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="file" name="offer_file" id="offer_file" style="width:165px;">
                                </div>
                            </div>
                            <div class="form-group" id="item-detail">
                                <label class="col col-4 col-xs-12"><cf_get_lang_main no ='217.Açıklama'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <textarea name="detail" id="detail" style="width:220px; height:80px;"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="col col-12">
                                    <cf_workcube_buttons is_upd='0' add_function="kontrol()">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </cfform>
    <script type="text/javascript">
        function kontrol()
        {
            document.getElementById('total_amount').value = filterNum(document.getElementById('total_amount').value);
            
            if(document.getElementById('deliver_date').value != "")
            {
                if (!date_check_hiddens(document.getElementById('today'), document.getElementById('deliver_date'), "Teslim tarihi bugünden önce olamaz!"))
                    return false;
            }
            
            if(document.add_demand_offer.detail.value == '')
            {	
                alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='217.Açiklama'>!");
                return false;
            }
            
            return true;
        }
        </script>
</cfif>