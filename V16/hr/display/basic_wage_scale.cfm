<!---
File: basic_wage_scale.cfm
Author: Workcube-Esma Uysal <esmauysal@workcube.com>
Date:24.09.2019
Controller: -
Description: İlgili pozisyon tipi için minimim ve maximum ücret tutarlarının belirlendiği sayfadır.
--->
<cfset periods = createObject('component','V16.objects.cfc.periods')><!--- Period yılları çekiliyor. --->
<cfset period_years = periods.get_period_year()>
<cfset get_wage_scale = createObject('component','V16.hr.cfc.wage_scale')><!--- Temel Ücret Tanımları. --->
<cfset get_scale = get_wage_scale.GET_WAGE_SCALE(position_id : attributes.position_cat_id,
                                                year : isdefined("attributes.year") ? attributes.year : session.ep.period_year
                                                )>
<cfinclude template = "../query/get_moneys.cfm">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Temel Ücret Skalası','51187')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <div class="column" id="general">
            <cfform name="wage_scale" id="wage_scale" action="" enctype="multipart/form-data" method="post">
                <input type="hidden" id="position_id" name="position_id" value="<cfoutput>#attributes.position_cat_id#</cfoutput>">
                <cf_box_elements>
                    <div class="col col-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-year">
                            <label class="col col-4"><cf_get_lang dictionary_id='58455.Yıl'></label>
                            <div class="col col-8">
                                <select name="year" id="year" onchange="change_year(this.selectedIndex);">
                                    <cfloop from="#period_years.period_year[1]#" to="#period_years.period_year[period_years.recordcount]+3#" index="i">
                                        <cfoutput>
                                            <option value="#i#" <cfif attributes.year eq i>selected </cfif> >#i#</option>
                                        </cfoutput>
                                    </cfloop>
                                </select>
                            </div>
                        </div> 
                        <div class="form-group" id="item-min_sal">
                            <label class="col col-4"><cf_get_lang dictionary_id='51188.En Düşük Ücret'></label>
                            <div class="col col-8">
                                <input type="text" id="min_salary" name="min_salary" value="<cfoutput>#TLFormat(get_scale.min_salary)#</cfoutput>" onkeyup="return(FormatCurrency(this,event));">
                            </div>
                        </div>   
                        <div class="form-group" id="item-gross_net">
                            <label class="col col-4 "><cf_get_lang dictionary_id='53131.Brüt'> / <cf_get_lang dictionary_id='58083.Net'></label>
                            <div class="col col-8">
                                <select name="gross_net" id="gross_net">
                                    <option value="0"<cfif get_scale.gross_net eq 0> selected</cfif>><cf_get_lang dictionary_id='53131.Brüt'></option>
                                    <option value="1"<cfif get_scale.gross_net eq 1> selected</cfif>><cf_get_lang dictionary_id='58083.Net'></option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col col-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-money">
                            <label class="col col-4"><cf_get_lang dictionary_id='57489.Para birimi'></label>
                            <div class="col col-8">
                                <select name="money" id="money">
                                    <cfoutput query="get_moneys">
                                        <option value="#money#" <cfif get_scale.money eq money>selected</cfif>>#money#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-max_sal">
                            <label class="col col-4"><cf_get_lang dictionary_id='51193.En Yüksek Ücret'></label>
                            <div class="col col-8">
                                <input type="text" id="max_salary" name="max_salary" value="<cfoutput>#TLFormat(get_scale.max_salary)#</cfoutput>" onkeyup="return(FormatCurrency(this,event));">
                            </div>
                        </div>   
                    </div>
                </cf_box_elements>
                <cf_box_footer>	
                    <cfif get_scale.recordcount>
                        <cf_record_info query_name="get_scale">
                        <cf_workcube_buttons is_upd='1' is_cancel='0' is_delete = "0" add_function="update_form()">                                    
                    <cfelse>
                        <cf_workcube_buttons is_upd='0' is_cancel='0' add_function="save_form()">
                    </cfif>
                </cf_box_footer>
            </cfform>
        </div>
    </cf_box>
</div>
<script>
    function save_form(){
        position_id =document.getElementById("position_id").value;
        min_salary = document.getElementById("min_salary").value;
        max_salary = document.getElementById("max_salary").value;
        min_salary = filterNum(min_salary,2);
        max_salary = filterNum(max_salary,2);  
        money = document.getElementById("money").value;
        year = document.getElementById("year").value;
        gross_net = document.getElementById("gross_net").value;
        $.ajax({ 
              type:'POST',  
              url:'V16/hr/cfc/wage_scale.cfc?method=SAVE_WAGE_SCALE',  
              data: { 
                position_id : position_id,
                min_salary : min_salary,
                max_salary : max_salary,
                money : money,
                year : year,
                gross_net : gross_net   
            },
            success: function (returnData) {  
                return true;
            },
            error: function () 
            {
                console.log('CODE:8 please, try again..');
                return false; 
            }
        }); 
    }
    function update_form(){
        position_id =document.getElementById("position_id").value;
        min_salary = document.getElementById("min_salary").value;
        max_salary = document.getElementById("max_salary").value;
        min_salary = filterNum(min_salary,2);
        max_salary = filterNum(max_salary,2);  
        money = document.getElementById("money").value;
        year = document.getElementById("year").value;
        gross_net = document.getElementById("gross_net").value;
        $.ajax({ 
              type:'POST',  
              url:'V16/hr/cfc/wage_scale.cfc?method=UPDATE_WAGE_SCALE',  
              data: { 
                position_id : position_id,
                min_salary : min_salary,
                max_salary : max_salary,
                money : money,
                year : year,
                gross_net : gross_net   
            },
            success: function (returnData) {  
                <cfif isDefined('attributes.draggable')>
                    location.href=document.referrer;
                <cfelse>
                    window.reload();
                </cfif>
            },
            error: function () 
            {
                console.log('CODE:8 please, try again..');
                return false; 
            }
        }); 
    }
    function change_year(get_year){
        <cfoutput>
		    location.href='#request.self#?fuseaction=hr.popup_basic_wage_scale&position_cat_id=#attributes.position_cat_id#&year='+wage_scale.year.options[get_year].value;
		</cfoutput>
    }
</script>