<script src="/JS/assets/plugins/menuDesigner/vue.js"></script>
<cfquery name="get_contract" datasource="#dsn#">
	SELECT 
        *
    FROM 
	    EMPLOYEES_OFFTIME_CONTRACT 
    WHERE 
    	EMPLOYEES_OFFTIME_CONTRACT_ID = #attributes.EMPLOYEES_OFFTIME_CONTRACT_ID#
</cfquery>
<cfparam name="attributes.employee_id" default="">
 
<cfscript>
    cmp_period_year = createObject("component","V16.hr.cfc.get_period_year");
    cmp_period_year.dsn = dsn;
    get_period_year = cmp_period_year.get_period_year();
</cfscript>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','İzin Mutabakatları','31567')#">
    <cfform name="upd_emp_offtime_contract" method="post" action="#request.self#?fuseaction=hr.emptypopup_upd_employee_offtime_contract">
        <cf_box_elements>
            <input type="hidden" name="EMPLOYEES_OFFTIME_CONTRACT_ID" value="<cfoutput>#get_contract.EMPLOYEES_OFFTIME_CONTRACT_ID#</cfoutput>">
            <div class="col col-6 col-md-6 col-sm-10 col-xs-12"  id="approve_app" type="column" index="1" sort="true">
                <div class="form-group" id="item-emp_name">
                    <label class="col col-4 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>
                    <div class="col col-4 col-md-6 col-sm-6 col-xs-12">                               
                        <cfoutput>#get_emp_info(get_contract.employee_id,0,0)#</cfoutput>
                    </div>
                </div>  
                <div class="form-group" id="item-SYSTEM_PAPER_NO">
                    <label class="col col-4 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="57880.Belge No"></label>
                    <div class="col col-4 col-md-6 col-sm-6 col-xs-12">
                        <input type="text" name="SYSTEM_PAPER_NO" value="<cfoutput>#get_contract.SYSTEM_PAPER_NO#</cfoutput>">
                    </div>
                </div>                 
                <div class="form-group" id="item-process">
                    <label class="col col-4 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                    <div class="col col-4 col-md-6 col-sm-6 col-xs-12">
                        <cf_workcube_process is_upd='0' id="process_stage" select_value='#get_contract.CONTRACT_STAGE#' is_detail='1'>
                    </div>
                </div>
                <div class="form-group" id="item-sal_year">
                    <label class="col col-4 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='58472.Dönem'></label>
                    <div class="col col-4 col-md-6 col-sm-6 col-xs-12">
                        <select name="sal_year" id="sal_year">
                            <cfoutput query="get_period_year">
                                <option value="#PERIOD_YEAR#" <cfif get_contract.sal_year eq PERIOD_YEAR>selected</cfif>>#PERIOD_YEAR#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-EX_SAL_YEAR_REMAINDER_DAY">
                    <label class="col col-4 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='63445.Önceki Dönem Kullanılmayan İzin Günü'></label>
                    <div class="col col-4 col-md-6 col-sm-6 col-xs-12">
                        <input type="text" name="EX_SAL_YEAR_REMAINDER_DAY" v-model="EX_SAL_YEAR_REMAINDER_DAY" onkeyup="return(FormatCurrency(this,event,1,'float'));" value="<cfoutput>#tlformat(get_contract.EX_SAL_YEAR_REMAINDER_DAY,1)#</cfoutput>">
                    </div>
                </div>
                <div class="form-group" id="item-EX_SAL_YEAR_OFTIME_DAY">
                    <label class="col col-4 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="59770.Önceki Dönem Kullanılan İzin Günü"></label>
                    <div class="col col-4 col-md-6 col-sm-6 col-xs-12">
                        <input type="text" name="EX_SAL_YEAR_OFTIME_DAY" v-model="EX_SAL_YEAR_OFTIME_DAY" onkeyup="return(FormatCurrency(this,event,1,'float'));"  value="<cfoutput>#tlformat(get_contract.EX_SAL_YEAR_OFTIME_DAY,1)#</cfoutput>">
                    </div>
                </div>
                <div class="form-group" id="item-SAL_YEAR_REMAINDER_DAY">
                    <label class="col col-4 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="59771.İlgili Dönem Hakedilen İzin Günü"></label>
                    <div class="col col-4 col-md-6 col-sm-6 col-xs-12">
                        <input type="text" name="SAL_YEAR_REMAINDER_DAY" v-model="SAL_YEAR_REMAINDER_DAY" onkeyup="return(FormatCurrency(this,event,1,'float'));"  value="<cfoutput>#tlformat(get_contract.SAL_YEAR_REMAINDER_DAY,1)#</cfoutput>">
                    </div>
                </div>
                <div class="form-group" id="item-SAL_YEAR_OFTIME_DAY">
                    <label class="col col-4 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="59772.İlgili Dönem Kullanılan İzin Günü"></label>
                    <div class="col col-4 col-md-6 col-sm-6 col-xs-12">
                        <input type="text" name="SAL_YEAR_OFTIME_DAY" v-model="SAL_YEAR_OFTIME_DAY" onkeyup="return(FormatCurrency(this,event,1,'float'));"  value="<cfoutput>#tlformat(get_contract.SAL_YEAR_OFTIME_DAY,1)#</cfoutput>">
                    </div>
                </div>
                <div class="form-group" id="item-SAL_YEAR_OFTIME_DAY">
                    <label class="col col-4 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="59773.Toplam Kalan"></label>
                    <div class="col col-4 col-md-6 col-sm-6 col-xs-12">
                        <label>{{TOTAL_OFTIME | comma_format}}</label>
                    </div>
                </div>
                <div class="form-group" id="item_IS_APPROVE">
                    <label class="col col-4 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="57500.Onay"></label>
                    <div class="col col-4 col-md-6 col-sm-6 col-xs-12">
                        <div class="col col-4">
                            <i class="fa fa-thumbs-o-up font-green-jungle"></i>
                            <input type="radio" name="IS_APPROVE" id="IS_APPROVE" value="1" <cfif get_contract.IS_APPROVE eq 1> checked="checked" </cfif>>
                        </div>
                        <div class="col col-6">
                            <i class="fa fa-thumbs-o-down font-red"></i>
                            <input type="radio" name="IS_APPROVE" id="IS_APPROVE" value="0" <cfif get_contract.IS_APPROVE eq 0> checked="checked"</cfif>>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-IS_MAIL">
                    <label class="col col-4 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="39210.Mail"></label>
                    <div class="col col-4 col-md-6 col-sm-6 col-xs-12">
                        <div class="col col-4">
                            <i class="fa fa-paper-plane font-green-jungle"></i>
                            <input type="radio" name="IS_MAIL" id="IS_MAIL" value="1" <cfif get_contract.IS_MAIL eq 1> checked="checked"</cfif>>
                        </div>
                        <div class="col col-6">
                            <i class="fa fa-paper-plane font-red"></i>
                            <input type="radio" name="IS_MAIL" id="IS_MAIL" value="0" <cfif get_contract.IS_MAIL eq 0> checked="checked"</cfif>>
                        </div>
                    </div>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_record_info query_name="get_contract" record_emp="RECORD_EMP" update_emp="UPDATE_EMP"> 
            <cfif session.ep.admin>
                <cf_workcube_buttons is_upd='1' add_function="kontrol()" is_delete='1' delete_page_url='#request.self#?fuseaction=hr.emptypopup_del_employee_offtime_contract&EMPLOYEES_OFFTIME_CONTRACT_ID=#attributes.EMPLOYEES_OFFTIME_CONTRACT_ID#'>
            <cfelse>
                <cf_workcube_buttons is_upd='1' add_function="kontrol()" is_delete='0'>
            </cfif>
        </cf_box_footer>
    </cfform>
</cf_box>
</div>
<script>
    var approve_app = new Vue({
        el: '#approve_app',
        data: {   
            EX_SAL_YEAR_REMAINDER_DAY : '<cfoutput>#tlformat(get_contract.EX_SAL_YEAR_REMAINDER_DAY,1)#</cfoutput>',
            EX_SAL_YEAR_OFTIME_DAY : '<cfoutput>#tlformat(get_contract.EX_SAL_YEAR_OFTIME_DAY,1)#</cfoutput>',
            SAL_YEAR_REMAINDER_DAY : '<cfoutput>#tlformat(get_contract.SAL_YEAR_REMAINDER_DAY,1)#</cfoutput>',
            SAL_YEAR_OFTIME_DAY : '<cfoutput>#tlformat(get_contract.SAL_YEAR_OFTIME_DAY,1)#</cfoutput>',
            TOTAL_OFTIME : '<cfoutput>#tlformat(get_contract.EX_SAL_YEAR_REMAINDER_DAY+(get_contract.SAL_YEAR_REMAINDER_DAY-get_contract.SAL_YEAR_OFTIME_DAY),1)#</cfoutput>'
        },
        watch: {
            EX_SAL_YEAR_REMAINDER_DAY: function () {                
                this.TOTAL_OFTIME = parseFloat(this.EX_SAL_YEAR_REMAINDER_DAY.toString().replace(".",",").replace(",",".")) + parseFloat((this.SAL_YEAR_REMAINDER_DAY.toString().replace(",",".")-this.SAL_YEAR_OFTIME_DAY.toString().replace(",",".")));
            },
            SAL_YEAR_REMAINDER_DAY: function () {
                this.TOTAL_OFTIME = parseFloat(this.EX_SAL_YEAR_REMAINDER_DAY.toString().replace(".",",").replace(",",".")) + parseFloat((this.SAL_YEAR_REMAINDER_DAY.toString().replace(",",".")-this.SAL_YEAR_OFTIME_DAY.toString().replace(",",".")));
            },
            SAL_YEAR_OFTIME_DAY: function () {
                this.TOTAL_OFTIME = parseFloat(this.EX_SAL_YEAR_REMAINDER_DAY.toString().replace(".",",").replace(",",".")) + parseFloat((this.SAL_YEAR_REMAINDER_DAY.toString().replace(",",".")-this.SAL_YEAR_OFTIME_DAY.toString().replace(",",".")));
            }
        },
        filters: {
            comma_format: function (value) {
             return value.toString().replace(".",",");
            }        
        } 
        
    })
    function kontrol() {
        if(document.getElementById('process_stage').value == 0)
        {
        alert("<cf_get_lang dictionary_id='58842.Lütfen Süreç Seçiniz'>!")
        return false;
        }
    }
</script>