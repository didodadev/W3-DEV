<script src="/JS/assets/plugins/menuDesigner/vue.js"></script>
<cfparam name="attributes.employee_id" default=""> 
<cfscript>
    cmp_period_year = createObject("component","V16.hr.cfc.get_period_year");
    cmp_period_year.dsn = dsn;
    get_period_year = cmp_period_year.get_period_year();
</cfscript>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','İzin Mutabakatları','31567')#">
        <cfform name="add_emp_offtime_contract" method="post" action="#request.self#?fuseaction=hr.emptypopup_add_employee_offtime_contract">
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-10 col-xs-12"  id="approve_app" type="column" index="1" sort="true">
                    <div class="form-group" id="item-emp_name">
                        <label class="col col-4 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'>*</label>
                        <div class="col col-4 col-md-6 col-sm-6 col-xs-12">
                            <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
                            <div class="input-group">
                                <cfinput type="text" name="emp_name" id="emp_name" value="#get_emp_info(attributes.employee_id,0,0)#" readonly required="yes" message="#getLang('','Çalışan Seçiniz','31183')#!">
                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_emp_offtime_contract.employee_id&field_name=add_emp_offtime_contract.emp_name&select_list=1');"></span>
                            </div>
                        </div>
                    </div>  
                    <div class="form-group" id="item-SYSTEM_PAPER_NO">
                        <label class="col col-4 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="57880.Belge No"></label>
                        <div class="col col-4 col-md-6 col-sm-6 col-xs-12">
                            <input type="text" name="SYSTEM_PAPER_NO">
                        </div>
                    </div>                 
                    <div class="form-group" id="item-process">
                        <label class="col col-4 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                        <div class="col col-4 col-md-6 col-sm-6 col-xs-12">
                            <cf_workcube_process is_upd='0' is_detail='0'>
                        </div>
                    </div>
                    <div class="form-group" id="item-sal_year">
                        <label class="col col-4 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='58472.Dönem'></label>
                        <div class="col col-4 col-md-6 col-sm-6 col-xs-12">
                            <select name="sal_year" id="sal_year">
                                <cfoutput query="get_period_year">
                                    <option value="#PERIOD_YEAR#" <cfif session.ep.PERIOD_YEAR eq PERIOD_YEAR>selected</cfif>>#PERIOD_YEAR#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-EX_SAL_YEAR_REMAINDER_DAY">
                        <label class="col col-4 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='63445.Önceki Dönem Kullanılmayan İzin Günü'></label>
                        <div class="col col-4 col-md-6 col-sm-6 col-xs-12">
                            <input type="text" name="EX_SAL_YEAR_REMAINDER_DAY" v-model="EX_SAL_YEAR_REMAINDER_DAY" onkeyup="return(FormatCurrency(this,event,1,'float'));" >
                        </div>
                    </div>
                    <div class="form-group" id="item-EX_SAL_YEAR_OFTIME_DAY">
                        <label class="col col-4 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="59770.Önceki Dönem Kullanılan İzin Günü"></label>
                        <div class="col col-4 col-md-6 col-sm-6 col-xs-12">
                            <input type="text" name="EX_SAL_YEAR_OFTIME_DAY" v-model="EX_SAL_YEAR_OFTIME_DAY" onkeyup="return(FormatCurrency(this,event,1,'float'));" >
                        </div>
                    </div>
                    <div class="form-group" id="item-SAL_YEAR_REMAINDER_DAY">
                        <label class="col col-4 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="59771.İlgili Dönem Hakedilen İzin Günü"></label>
                        <div class="col col-4 col-md-6 col-sm-6 col-xs-12">
                            <input type="text" name="SAL_YEAR_REMAINDER_DAY" v-model="SAL_YEAR_REMAINDER_DAY" onkeyup="return(FormatCurrency(this,event,1,'float'));" >
                        </div>
                    </div>
                    <div class="form-group" id="item-SAL_YEAR_OFTIME_DAY">
                        <label class="col col-4 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="59772.İlgili Dönem Kullanılan İzin Günü"></label>
                        <div class="col col-4 col-md-6 col-sm-6 col-xs-12">
                            <input type="text" name="SAL_YEAR_OFTIME_DAY" v-model="SAL_YEAR_OFTIME_DAY" onkeyup="return(FormatCurrency(this,event,1,'float'));" >
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
                                <input type="radio" name="IS_APPROVE" id="IS_APPROVE" value="1" checked="">
                            </div>
                            <div class="col col-6">
                                <i class="fa fa-thumbs-o-down font-red"></i>
                                <input type="radio" name="IS_APPROVE" id="IS_APPROVE" value="0" checked="">
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-IS_MAIL">
                        <label class="col col-4 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="39210.Mail"></label>
                        <div class="col col-4 col-md-6 col-sm-6 col-xs-12">
                            <div class="col col-4">
                                <i class="fa fa-paper-plane font-green-jungle"></i>
                                <input type="radio" name="IS_MAIL" id="IS_MAIL" value="1" checked="">
                            </div>
                            <div class="col col-6">
                                <i class="fa fa-paper-plane font-red"></i>
                                <input type="radio" name="IS_MAIL" id="IS_MAIL" value="0" checked="">
                            </div>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script>
    var approve_app = new Vue({
        el: '#approve_app',
        data: {   
            EX_SAL_YEAR_REMAINDER_DAY : 0,
            EX_SAL_YEAR_OFTIME_DAY : 0,
            SAL_YEAR_REMAINDER_DAY : 0,
            SAL_YEAR_OFTIME_DAY : 0,
            TOTAL_OFTIME : 0
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
</script>

