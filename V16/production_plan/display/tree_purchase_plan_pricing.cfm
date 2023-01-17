<cf_xml_page_edit fuseact="prod.tree_purchase_plan_pricing">
<cfset getComponent = createObject('component','V16.production_plan.cfc.get_tree')>
<cfset comp = createObject("component","V16.product.cfc.product_sample") />
<cfset GET_SALES_OPPORTUNITY = getComponent.GET_SALES_OPPORTUNITY( attributes.product_sample_id )>



<cfquery name="pricing_count" datasource="#dsn3#">
    SELECT COUNT(PRODUCT_SAMPLE_ID) AS CNT FROM PRODUCT_SAMPLE_PRICING WHERE PRODUCT_SAMPLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_sample_id#">
</cfquery>
<cfquery name="process_pricing_" datasource="#dsn#">
    SELECT * from PROCESS_TYPE_ROWS_POSID where <cfif len(is_update_price)>PROCESS_ROW_ID=#is_update_price# and </cfif> PRO_POSITION_ID=#session.ep.position_code#
</cfquery>
<cfif pricing_count.CNT gt 0>
    <cfset control_pricing = getComponent.get_pricing( product_sample_id : attributes.product_sample_id )>
    <cfset get_money = getComponent.get_pricing_money( pricing_id : control_pricing.PRICING_ID )>
<cfelse>
    <cfset GET_PRO_TREE = getComponent.get_components(stock_id : attributes.stock_id)>
    <cfset get_money = getComponent.get_money()>
</cfif>

<cfset component_group_type = getComponent.component_group_type(stock_id : attributes.stock_id)>
<cfset GET_MONEY_CURRENCY = getComponent.GET_MONEY_CURRENCY() />


<cf_box title="#getLang('','Fiyatlama',63947)#" closable="1" popup_box="1">
    
    <div id="pricing-app">
        <form name="form_pricing" id="form_pricing" method="post" action="">
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12 pdn-l-0">
                <cf_grid_list>
                    <thead>
                        <tr><th colspan="18"><cf_get_lang dictionary_id="35700.Bileşenler"></th></tr>
                        <tr>
                            <th width="15"></th>
                            <th><cf_get_lang dictionary_id='63502.Bileşen Tipi'></th>
                            <th><cf_get_lang dictionary_id="57629.Açıklama"></th>
                            <th><cf_get_lang dictionary_id='58800.Ürün Kodu'></th>
                            <th><cf_get_lang dictionary_id='57692.İşlem'></th>
                            <th><cf_get_lang dictionary_id='62606.Hedef Fiyat'></th>
                            <th><cf_get_lang dictionary_id='63567.Alım Fiyatı'></th>
                            <th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
                            <th><cf_get_lang dictionary_id='57635.Miktar'></th>
                            <th><cf_get_lang dictionary_id='57636.Birim'></th>
                            <th><cf_get_lang dictionary_id="59181.Vergi"></th>
                            <th><cf_get_lang dictionary_id="42519.Vergi Oranı"></th>
                            <th><cf_get_lang dictionary_id="136.Fire Oranı"></th> 
                                <th><cf_get_lang dictionary_id='137.Fire Miktarı'></th>
                            <th><cf_get_lang dictionary_id="33968.İhtiyaç"></th>
                            <th><cf_get_lang dictionary_id="63948.Fire Maliyeti"></th>
                            <th><cf_get_lang dictionary_id="33932.Toplam Fiyat"></th>
                            <th><cf_get_lang dictionary_id="33366.Dövizli Fiyat"></th>
                        </tr>
                    </thead>
                    <tbody>
                        <template v-if = "componentList.length">
                            <tr v-for = "(item, index) in componentList" v-bind:key = "index">
                                <td class="text-center">{{ index + 1 }} </td>
                                <td><div class="form-group"><input type="text" v-model = "item.TYPE"></div></td>
                                <td><div class="form-group"><input type="text" v-model = "item.PRODUCT_NAME"></div></td>
                                <td><div class="form-group"><input type="text" v-model = "item.PRODUCT_CODE"></div></td>
                                <td><div class="form-group"><input type="text" v-model = "item.OPERATION_TYPE"></div></td>
                                <td><div class="form-group"><input type="text" v-model = "item.TARGET_PRICE" class="moneybox" onkeyup="return(FormatCurrency(this,event,4));"></div></td>
                                <td><div class="form-group"><input type="text" v-model = "item.LAST_PRICE" class="moneybox" onkeyup="return(FormatCurrency(this,event,4));"></div></td>
                                <td><div class="form-group"><input type="text" v-model = "item.TARGET_PRICE_CURRENCY" ></div></td>
                                <td><div class="form-group"><input type="text" v-model = "item.AMOUNT" class="moneybox" onkeyup="return(FormatCurrency(this,event,4));"></div></td>
                                <td><div class="form-group"><input type="text" v-model = "item.MAIN_UNIT"></div></td>
                                <td><div class="form-group"><select v-model="item.TAX"><option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option><option v-bind:value="1"><cf_get_lang dictionary_id='63954.Kdv li Alım'></option><option v-bind:value="2"><cf_get_lang dictionary_id='63955.İhraç Kayıtlı Alım'></option><option v-bind:value="3"><cf_get_lang dictionary_id='44261.Dahilde İşlem'></option></select></div></td>
                                <td><div class="form-group"><input type="text" v-model = "item.TAX_RATE" class="moneybox" onkeyup="return(FormatCurrency(this,event,2));"></div></td>
                                <td><div class="form-group"><input type="text" v-model = "item.FIRE_RATE" class="moneybox" onkeyup="return(FormatCurrency(this,event,2));"></div></td>
                                <td><div class="form-group"><input type="text" v-model = "item.FIRE_AMOUNT_" class="moneybox" onkeyup="return(FormatCurrency(this,event,2));"></div></td>
                                <td><div class="form-group"><input type="text" v-model = "item.NEEDED" class="moneybox" onkeyup="return(FormatCurrency(this,event,2));"></div></td>
                                <td><div class="form-group"><input type="text" v-model = "item.fire_amount()" class="moneybox" onkeyup="return(FormatCurrency(this,event,2));"></div></td>
                                <td><div class="form-group"><input type="text" v-model = "item.total_price()" class="moneybox" onkeyup="return(FormatCurrency(this,event,2));"></div></td>
                                <td><div class="form-group"><input type="text" v-model = "item.total_price_other()" class="moneybox" onkeyup="return(FormatCurrency(this,event,2));"></div></td>
                            </tr>
                        </template>
                        <tr>
                            <td class="text-right" colspan="14"><b><cf_get_lang dictionary_id="57492.Toplam"> :</b></td>
                            <td class="text-right">{{ component_fire_amount_total }}</td>
                            <td class="text-right">{{ component_total_price }}</td>
                        </tr>
                    </tbody>
                </cf_grid_list>
            </div>

            <div class="col col-12 col-md-6 col-sm-6 col-xs-12 pdn-l-0">
                <div class="ui-row">
                    <div id="sepetim_total" class="padding-0">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <div class="totalBox">
                                <div class="totalBoxHead font-grey-mint">
                                    <span class="headText"> <cf_get_lang dictionary_id='57677.Döviz'> </span>
                                    <div class="collapse">
                                        <span class="icon-minus"></span>
                                    </div>
                                </div>
                                <div class="totalBoxBody">
                                    <table cellspacing="0">
                                        <cfoutput>
                                            <input id="kur_say" type="hidden" name="kur_say" value="#get_money.recordcount#">
                                            <cfloop query="get_money">
                                                <cfif is_selected eq 1><cfset str_money_bskt_main = money></cfif>
                                                    <tr>
                                                    <td>
                                                        <cfif session.ep.rate_valid eq 1>
                                                            <cfset readonly_info = "yes">
                                                        <cfelse>
                                                            <cfset readonly_info = "no">
                                                        </cfif>
                                                        <input type="hidden" name="hidden_rd_money_#currentrow#" value="#money#" id="hidden_rd_money_#currentrow#">
                                                        <input type="hidden" name="txt_rate1_#currentrow#" value="#rate1#" id="txt_rate1_#currentrow#">
                                                        <input type="radio" name="rd_money" id="rd_money" value="#money#,#rate1#,#rate2#" v-model="selected_money">#money#
                                                    </td>
                                                    <td valign="bottom">#TLFormat(rate1,0)#/<input type="text" class="box" id="txt_rate2_#currentrow#" <cfif readonly_info>readonly</cfif> name="txt_rate2_#currentrow#" <cfif money eq session.ep.money>readonly="yes"</cfif> value="#TLFormat(rate2,rate_round_num_info)#" onKeyUp="return(FormatCurrency(this,event,'#rate_round_num_info#'));" onBlur="if(filterNum(this.value,'#rate_round_num_info#') <=0) this.value=commaSplit(1);"></td>
                                                    </tr>
                                            </cfloop>
                                        </cfoutput>                   	
                                    </table>
                                </div>
                            </div>
                        </div>

                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <div class="totalBox">
                                <div class="totalBoxHead font-grey-mint">
                                    <span class="headText"> <cf_get_lang dictionary_id='817.Bileşen Tiplerine Göre Maliyet'> </span>
                                    <div class="collapse">
                                        <span class="icon-minus"></span>
                                    </div>
                                </div>
                                <div class="totalBoxBody">
                                    <table cellspacing="0">
                                            <tr>
                                                <td width="120px"></td>
                                                <td><cf_get_lang dictionary_id='136.Fire Oranı'>%</td>
                                                <td><cf_get_lang dictionary_id='58258.Maliyet'></td>
                                                <td><cf_get_lang dictionary_id='29471.Fire'></td>
                                                <td><cf_get_lang dictionary_id='57492.Toplam'></td>
                                            </tr>
                                            <template v-if = "Object.keys(cost_group).length">
                                                <tr v-for = "(item, index) in Object.keys(cost_group)">
                                                    <td>
                                                        <div class="form-group" >
                                                            {{ item }} 
                                                        </div>
                                                    </td>
                                                    <td> 
                                                        <div class="form-group" >
                                                            <input type="text"  :id="'wasteId'+index" v-on:keyup= "changeWaste(item, index)">
                                                        </div>
                                                    </td>
                                                    <td class="text-center">{{ commaSplit(cost_group[item].cost,2) }}</td>
                                                    <td class="text-center">{{ commaSplit(cost_group[item].fire,2) }}</td>
                                                    <td class="text-center">{{ commaSplit(cost_group[item].cost + cost_group[item].fire,2) }}</td>
                                                </tr>
                                                <tr>
                                                    <td><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='58258.Maliyet'></td>
                                                        <td></td>
                                                    <td class="text-center">{{ commaSplit(totalCost,2) }}</td>
                                                    <td class="text-center">{{ commaSplit(totalFire,2) }}</td>
                                                    <td class="text-center">{{ commaSplit(totalCost + totalFire,2) }}</td>
                                                </tr>
                                            </template>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <div class="totalBox">
                                <div class="totalBoxHead font-grey-mint">
                                    <span class="headText"> <cf_get_lang dictionary_id='63947.Fiyatlama'> </span>
                                    <div class="collapse">
                                        <span class="icon-minus"></span>
                                    </div>
                                </div>
                                <div class="totalBoxBody">
                                    <table cellspacing="0">
                                        <tr>
                                            <td style="width:150px;"><cf_get_lang dictionary_id='58258.Maliyet'></td>
                                            <td><input type="text" class="box" v-model = "pricing_cost_total"></td>
                                        </tr>
                                        <tr>
                                            <td style="width:150px;"><cf_get_lang dictionary_id='29471.Fire'></td>
                                            <td><input type="text" class="box" v-model = "pricing_fire_total"></td>
                                        </tr>
                                        <tr>
                                            <td style="width:150px;"><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='58258.Maliyet'></td>
                                            <td><input type="text" class="box" v-model = "pricing_cost_last_total"></td>
                                        </tr>
                                        <tr>
                                            <td style="width:150px;"><cf_get_lang dictionary_id='58791.Komisyon'> % <input type="text" class="box" style="max-width:25px;" v-model = "commission_rate"></td>
                                            <td><input type="text" class="box" v-model = "pricing_commission_total"></td>
                                        </tr>
                                        <tr>
                                            <td style="width:150px;"><cf_get_lang dictionary_id='818.Genel Gider'> % <input type="text" class="box" style="max-width:25px;" v-model = "general_cost_rate"></td>
                                            <td><input type="text" class="box" v-model = "pricing_general_cost_total"></td>
                                        </tr>
                                        <tr>
                                            <td style="width:150px;"><cf_get_lang dictionary_id='37719.Kar Oranı'> % <input type="text" class="box" style="max-width:25px;" v-model = "kar_rate"></td>
                                            <td><input type="text" class="box" v-model = "pricing_kar_total"></td>
                                        </tr>
                                        <tr>
                                            <td style="width:150px;"><cf_get_lang dictionary_id='48183.Satış Fiyatı'></td>
                                            <td><input type="text" class="box" v-model = "paper_last_total"></td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12 ">
                <cf_box_elements>
                    <div class="col col-12 col-xs-12">
                        <div class="ui-info-bottom">
                            <cfif pricing_count.CNT gt 0>
                                <cf_record_info query_name = "control_pricing">
                                <div class="form-group" style="padding:0 15px 5px 0;margin: 10px 0 0 5px;">
                                    <input name="description" id="description" type="text" placeholder="<cfoutput>#getLang('','Not',57467)#</cfoutput>" value="<cfoutput>#control_pricing.DESCRIPTION#</cfoutput>">
                                </div>
                                <div class="form-group"  style="padding:0 15px 5px 0;margin: 10px 0 0 5px;">
                                    <cf_workcube_process is_upd='0' is_detail='1' select_value='#control_pricing.process_stage#' fuseaction="prod.tree_purchase_plan_pricing">
                                </div>
                                <div class="form-group"  style="padding:0 5px;margin: 5px 0 0 0px;">
                                    <button type="button" style="padding: 6px 15px !important;margin:7px 0px 7px 0px;min-height: 30px!important;" class="ui-wrk-btn ui-wrk-btn-success" v-on:click = "addPricing('upd')"><cf_get_lang dictionary_id='57464.Güncelle'></button>   
                                </div>
                                <cfif process_pricing_.recordcount>
                                    <div class="form-group"  style="padding:0 5px;margin: 5px 0 0 0px;">
                                        <button type="button" style="padding: 6px 15px !important; margin: 7px 0px 7px 0px;min-height: 30px!important;"  class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-right"  v-on:click = "addsample()"><cf_get_lang dictionary_id='65167.Satış Fiyatını Numume Fiyatına Gönder'></button>
                                    </div>
                                </cfif>
                            <cfelse> 
                                
                                <div style="flex: 1;"></div>
                                <div class="form-group "  style="padding:0 15px 5px 0;margin: 10px 0 0 5px;">
                                    <input name="description" id="description" type="text" placeholder="<cfoutput>#getLang('','Not',57467)#</cfoutput>">
                                </div>
                                <div class="form-group"  style="padding:0 15px 5px 0;margin: 10px 0 0 5px;">
                                    <cf_workcube_process is_upd='0' process_cat_width='120' is_detail='0' fuseaction="prod.tree_purchase_plan_pricing">
                                </div>
                                <div class="form-group"  style="padding:0 5px;margin: 5px 0 0 0px;">
                                    <button type="button" class="ui-wrk-btn ui-wrk-btn-success"  style="padding: 6px 15px !important; margin: 7px 0px 7px 0px;min-height: 30px!important;"  v-on:click = "addPricing('add')"><cf_get_lang dictionary_id='59031.Kaydet'></button>
                                </div>
                                    
                            </cfif>
                        </div>
                    </div>
                </cf_box_elements>
            </div>
        </form>
        <cfset is_pricing_general_cost_total =filternum(is_pricing_general_cost_total)>
        <cfset is_kar_rate_ =filternum(is_kar_rate)>
        
        <cfset is_commission_rate_ =filternum(is_commission_rate)>
        <cfset pricing_cost_rate = iif(len(is_pricing_general_cost_total),(is_pricing_general_cost_total),de(0))>
        <cfset pricing_kar_rate = iif(len(is_kar_rate),(is_kar_rate_),de(0))>
        <cfset pricing_commission_rate = iif(len(is_commission_rate),(is_commission_rate_),de(0))>
        <cfif is_commission_amount_rate eq 1>
            <cfset comission= pricing_commission_rate>
        </cfif>
    <cfif  is_commission_amount_rate eq 0>
        <cfif GET_SALES_OPPORTUNITY.recordcount>
            <cfset comission= filternum(GET_SALES_OPPORTUNITY.ROW_PREMIUM_)>
        <cfelse>
            <cfset comission=0>
        </cfif>
    </cfif>
        
    </div>
   
</cf_box>


<script>

var PricingApp = new Vue({
    el : "#pricing-app",
    data : {
        componentList : [],
        costpriceList : [],
        selected_money : "<cfoutput>#session.ep.money#</cfoutput>,1,1",
        currencies : <cfoutput>#isdefined("attributes.pricing_id") ? get_moneys_arr : GET_MONEY_CURRENCY#</cfoutput>,
        commission_rate : commaSplit("<cfoutput>#comission#</cfoutput>",4),
        general_cost_rate : commaSplit("<cfoutput>#pricing_cost_rate#</cfoutput>",4),
        kar_rate : commaSplit("<cfoutput>#pricing_kar_rate#</cfoutput>",4),
        totalCost: 0.0,
        totalFire: 0.0
    },
    computed : {
        component_fire_amount_total : function () {
            return commaSplit( this.componentList.reduce( function( acc, val ) {
                return acc + parseFloat( filterNum( val.fire_amount(),4 ) );
            }, 0 ),4 );
        },

        component_total_price : function () {
            return commaSplit( this.componentList.reduce( function( acc, val ) {
                return acc + parseFloat( filterNum( val.total_price(),4 ) );
            }, 0 ),4 );
        },

        pricing_fire_total : function () {
            return commaSplit( parseFloat(filterNum(this.component_fire_amount_total)) ,4 );
        },

        pricing_cost_total : function () {
            return commaSplit( parseFloat(filterNum(this.component_total_price)) - parseFloat(filterNum(this.component_fire_amount_total)) , 4 );
        },

        pricing_cost_last_total : function () {
            return commaSplit( parseFloat(filterNum(this.component_total_price)), 4 );
        },

        pricing_commission_total : function () {
            return commaSplit( parseFloat(filterNum(this.pricing_cost_last_total)) * parseFloat(filterNum(this.commission_rate)) / 100 , 4 );
        },

        pricing_general_cost_total : function () {
            return commaSplit( parseFloat(filterNum(this.pricing_cost_last_total)) * parseFloat(filterNum(this.general_cost_rate)) / 100 , 4 );
        },

        pricing_kar_total : function () {
            return commaSplit( parseFloat(filterNum(this.pricing_cost_last_total)) * parseFloat(filterNum(this.kar_rate)) / 100 , 4 );
        },

        paper_last_total : function () {
            return commaSplit( parseFloat(filterNum(this.pricing_cost_last_total)) - parseFloat(filterNum(this.pricing_commission_total)) - parseFloat(filterNum(this.pricing_general_cost_total)) + parseFloat(filterNum(this.pricing_kar_total)), 4 );
        },
        cost_group: function () {
          
            let resp = [];
            
            this.totalCost = 0.0;
            this.totalFire = 0.0;
            
            this.costpriceList.forEach(element => {
                var cost_fire = this.componentList.filter((e) => { return element.TYPE == e.TYPE || element.TYPE_2 == e.TYPE }).reduce((acc, val) => {
                    if( acc['cost'] !== undefined ) acc['cost'] += parseFloat( filterNum(val.LAST_PRICE) ) *  parseFloat( filterNum(val.AMOUNT) );
                    else acc['cost'] = parseFloat( filterNum(val.LAST_PRICE) ) * parseFloat( filterNum(val.AMOUNT) );
                    this.totalCost += parseFloat( filterNum(val.LAST_PRICE) ) *  parseFloat( filterNum(val.AMOUNT) );

                    if( acc['fire'] !== undefined ) acc['fire'] += parseFloat( filterNum(val.fire_amount()) );
                    else acc['fire'] = parseFloat( filterNum(val.fire_amount()) );
                    this.totalFire += parseFloat( filterNum(val.fire_amount()) );

                    return acc;
                }, []);
                resp[element.TYPE] = cost_fire;
                
            });
            return resp;
        }
    },
    async created(){
        await this.getComp();
    },
    methods : {
        setComponent: function(data){
            var self = this;
            var elm = {
                TYPE : data != null && data.TYPE !== undefined ? data.TYPE : "",
                PRODUCT_NAME : data != null && data.PRODUCT_NAME !== undefined ? data.PRODUCT_NAME : "",
                PRODUCT_CODE : data != null && data.PRODUCT_CODE !== undefined ? data.PRODUCT_CODE : "",
                OPERATION_TYPE : data != null && data.OPERATION_TYPE !== undefined ? data.OPERATION_TYPE : "",
                TARGET_PRICE : data != null && data.TARGET_PRICE != '' ? commaSplit(data.TARGET_PRICE,2) : commaSplit(0,2),
                LAST_PRICE : data != null && data.LAST_PRICE != '' ? commaSplit(data.LAST_PRICE,2) : commaSplit(0,2),
                TARGET_PRICE_CURRENCY : data != null && data.TARGET_PRICE_CURRENCY != '' ? data.TARGET_PRICE_CURRENCY : "TL",
                AMOUNT : data != null && data.AMOUNT !== undefined ? commaSplit(data.AMOUNT,2) : commaSplit(0,2),
                MAIN_UNIT : data != null && data.MAIN_UNIT !== undefined ? data.MAIN_UNIT : '',
                TAX : data != null && data.TAX != '' ? data.TAX : 0,
                TAX_RATE :  data != null && data.TAX_RATE != '' ? data.TAX_RATE : 0,
                FIRE_RATE :   data != null && data.FIRE_RATE != '' ? data.FIRE_RATE : 0 , 
                FIRE_AMOUNT_ :   data != null && data.FIRE_AMOUNT_ != '' ? data.FIRE_AMOUNT_ : 0 , 
                NEEDED : commaSplit(0,2),
                FIRE_AMOUNT : commaSplit(0,2),
                TOTAL_PRICE : commaSplit(0,2),
                TOTAL_PRICE_OTHER : commaSplit(0,2),
                PRODUCT_TREE_ID : data != null && data.PRODUCT_TREE_ID !== undefined ? data.PRODUCT_TREE_ID : ""
               
            }; 

            elm.fire_amount = function(){
                return commaSplit( parseFloat( filterNum( elm.LAST_PRICE, 4 ) ) * parseFloat( elm.FIRE_RATE ) / 100, 4 );
            };

            elm.total_price = function(){
                return commaSplit( parseFloat( filterNum( elm.LAST_PRICE, 4 ) * parseFloat( filterNum( elm.AMOUNT, 4 ) ) ) + parseFloat( filterNum( elm.fire_amount() ) ), 4 );
            };

            elm.total_price_other = function(){
                selected_money = list_getat( self.selected_money, 1, "," );
                row_money = elm.TARGET_PRICE_CURRENCY;

                return ( selected_money == row_money ) 
                    ? commaSplit( parseFloat(filterNum(elm.total_price())) ,4 ) 
                    : commaSplit( (parseFloat(filterNum(elm.total_price(),4)) * self.currencies[row_money] / self.currencies[selected_money]) ,4 );
            };
            
            return elm;
        },

        changeWaste : function(item, elm ){
            wid = document.getElementById("wasteId"+elm).value;
            this.componentList.forEach(element => { 
                if( wid != '' ) if( element.TYPE == item ) element.FIRE_RATE = wid;
            });
        },

        setCostPrice: function(data){
            var self = this;
            var elm = {
                TYPE : data != null && data.TYPE !== undefined ? data.TYPE : "",
                TYPE_2 : data != null && data.TYPE_2 !== undefined ? data.TYPE_2 : "",
                COMMISSION_RATE : 0,
                TOTAL_COST : 0,
                SALES_PRICE : 0
            };
            return elm;
        },

        setRateMarj: function(data){
            var self = this;
            var elm = {
                RATE : data != null && data !== undefined ? data : "",
                COST : 0,
                KAR : 0,
                PRICE : 0
            };
            return elm;
        },

        addPricing: function(event) {
            var self = this;
            var method_name = ( event == 'add' ) ? 'add_pricing' : 'upd_pricing';
            if( confirm('<cf_get_lang dictionary_id='45686.Kaydetmek istediğinize emin misiniz?'>') ){
                var data = new FormData( $("#form_pricing")[0] );
                data.append('component_data', JSON.stringify( self.componentList ));  
                data.append('commission_rate', filterNum( self.commission_rate,2 ));
                data.append('general_cost_rate', filterNum( self.general_cost_rate,2 ));
                data.append('kar_rate', filterNum( self.kar_rate,2 ));
                data.append('product_sample_id', <cfoutput>#product_sample_id#</cfoutput>);
                data.append('currency_id', list_getat( self.selected_money, 1, "," ) );
                data.append('fuseaction', '<cfoutput>#attributes.fuseaction#</cfoutput>');
                data.append('is_update_price', '<cfoutput>#is_update_price#</cfoutput>');
                data.append('paper_last_total', self.paper_last_total);
              
                <cfif pricing_count.CNT gt 0>
                    data.append('pricing_id', <cfoutput>#control_pricing.PRICING_ID#</cfoutput>);
                </cfif>

                AjaxControlPostDataJson('V16/production_plan/cfc/get_tree.cfc?method='+method_name, data, function ( response ) {
            
                    if( response.STATUS ){
                        alert("<cf_get_lang dictionary_id = '61210.İşlem Başarılı'>");
                        location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=prod.tree_purchase_plan&event=det&stock_id=<cfoutput>#attributes.stock_id#</cfoutput>&product_sample_id=<cfoutput>#attributes.product_sample_id#</cfoutput>';
                    }else alert("<cf_get_lang dictionary_id='52126.Bir hata oluştu'>!");
                });

            }
            return false;
        },
        addsample: function() {
            var self = this;
            if( confirm('<cf_get_lang dictionary_id='65168.Satış Fiyatı Numuneye Gönderilecek Emin Misiniz'>?') ){
                var data = new FormData( $("#form_pricing")[0] );
                data.append('component_data', JSON.stringify( self.componentList )); 
            data.append('paper_last_total', self.paper_last_total);
            data.append('fuseaction', '<cfoutput>#attributes.fuseaction#</cfoutput>');
            <cfif pricing_count.CNT gt 0>
                    data.append('pricing_id', <cfoutput>#control_pricing.PRICING_ID#</cfoutput>);
                </cfif>

                    data.append('product_sample_id', <cfoutput>#product_sample_id#</cfoutput>);
                   

                AjaxControlPostDataJson('V16/production_plan/cfc/get_tree.cfc?method=UPD_Sales_Price', data, function ( response ) {
                    if( response.STATUS ){
                        alert("<cf_get_lang dictionary_id = '61210.İşlem Başarılı'>");
                        location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=prod.tree_purchase_plan&event=det&stock_id=<cfoutput>#attributes.stock_id#</cfoutput>&product_sample_id=<cfoutput>#attributes.product_sample_id#</cfoutput>';
                    }else alert("<cf_get_lang dictionary_id='52126.Bir hata oluştu'>!");
                });

            }
            return false;
        },

        async getComp(){
            var self = this;
            
            <cfif pricing_count.CNT gt 0>
                self.commission_rate = commaSplit("<cfoutput>#control_pricing.COMMISSION_RATE#</cfoutput>",2);
                self.general_cost_rate = commaSplit("<cfoutput>#control_pricing.GENERAL_COST_RATE#</cfoutput>",2);
                self.kar_rate = commaSplit("<cfoutput>#control_pricing.KAR_RATE#</cfoutput>",2);
                self.selected_money = "<cfoutput>#get_money.MONEY#,#get_money.RATE1#,#get_money.RATE2#</cfoutput>";

                comp_list = JSON.parse('<cfoutput>#control_pricing.COMPONENT_DATA#</cfoutput>');
                comp_list.forEach(e => { 
                    self.componentList.push( self.setComponent( e )); 
                });
            <cfelse>
                comp_list = JSON.parse('<cfoutput>#GET_PRO_TREE#</cfoutput>');
                comp_list.forEach(e => { 
                    self.componentList.push( self.setComponent( e )); 
                });
            </cfif>
            costprice_list = JSON.parse('<cfoutput>#component_group_type#</cfoutput>');
                costprice_list.forEach(e => { 
                    self.costpriceList.push( self.setCostPrice( e )); 
                });
        }
    }
});

</script>