<cfinclude template="../query/get_discipline_event.cfm">
<cfset witness_statement= createObject("component","V16.hr.ehesap.cfc.witness_statement") />
<cfset witness_statement_=witness_statement.GET_WITNESS_STATEMENT(witness_statement_id : attributes.witness_statement_id,event_id:attributes.event_id) />
<cfsavecontent variable="message"><cf_get_lang dictionary_id="61153.Tanık İfadesi Güncelle"></cfsavecontent>
<cf_box title="#message#">
	<cfform name="upd_witness_report" action="" method="post">
        <cf_box_elements vertical="1">
            <input type="hidden" name="event_id" id="event_id" value="<cfoutput>#attributes.event_id#</cfoutput>">
            <input type="hidden" name="witness_statement_id" id="witness_statement_id" value="<cfoutput>#attributes.witness_statement_id#</cfoutput>">
            <div class="col col-6 col-md-6 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='53476.Onay Tarihi'></label>
                    <div class="form-group" id="item-sign_date">
                        <div class="col col-12 col-xs-12">
                            <div class="input-group">
                                <cfinput validate="#validate_style#" type="text" name="sign_date" value="#dateformat(witness_statement_.sign_date,dateformat_style)#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="sign_date"></span>
                            </div>
                        </div>
                    </div>
                <cfsavecontent variable="tanik1"><cf_get_lang dictionary_id='53325.Tanık'>1</cfsavecontent>
                <cf_seperator id="tanik_1" title="#tanik1#">
                <div id="tanik_1">
                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='53325.Tanık'> 1</label>
                    <div class="form-group" id="item-witness1_to">
                        <div class="col col-12 col-xs-12">
                                <cfoutput><input type="hidden" name="witness1_id" id="witness1_id" value="#get_event.witness_1#"></cfoutput>
                                <cfinput  readonly type="text" name="witness1_to" id="witness1_to" value="#get_emp_info(get_event.witness_1,0,0)#">
                        </div>
                    </div>
                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='61151.Tanık İfadesi'></label>
                    <div class="form-group">
                        <div class="col col-12 col-xs-12">
                            <cfoutput><textarea name="witness1_detail" id="witness1_detail">#witness_statement_.witness1_detail#</textarea></cfoutput>
                        </div>
                    </div>
                </div>
                <cfsavecontent variable="tanik2"><cf_get_lang dictionary_id='53325.Tanık'>2</cfsavecontent>
                    <cf_seperator id="tanik_2" title="#tanik2#">
                <div id="tanik_2">
                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='53325.Tanık'> 2</label>
                    <div class="form-group" id="item-witness2_to">
                        <div class="col col-12 col-xs-12">
                                <cfoutput><input type="hidden" name="witness2_id" id="witness2_id" value="#get_event.witness_2#"></cfoutput>
                                <cfinput  readonly type="text" name="witness2_to" id="witness2_to" value="#get_emp_info(get_event.witness_2,0,0)#">
                        </div>
                    </div>
                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='61151.Tanık İfadesi'></label>
                    <div class="form-group">
                        <div class="col col-12 col-xs-12">
                            <cfoutput><textarea name="witness2_detail" id="witness2_detail">#witness_statement_.witness2_detail#</textarea></cfoutput>
                        </div>
                    </div>
                </div>
                <cfsavecontent variable="tanik3"><cf_get_lang dictionary_id='53325.Tanık'>3</cfsavecontent>
                    <cf_seperator id="tanik_3" title="#tanik3#">
                <div id="tanik_3">
                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='53325.Tanık'> 3</label>
                    <div class="form-group" id="item-witness3_to">
                        <div class="col col-12 col-xs-12">
                                <cfoutput><input type="hidden" name="witness3_id" id="witness3_id" value="#get_event.witness_3#"></cfoutput>
                                <cfinput readonly type="text" name="witness3_to" id="witness3_to" value="#get_emp_info(get_event.witness_3,0,0)#">
                        </div>
                    </div>
                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='61151.Tanık İfadesi'></label>
                    <div class="form-group">
                        <div class="col col-12 col-xs-12" >
                            <cfoutput><textarea name="witness3_detail" id="witness3_detail">#witness_statement_.witness3_detail#</textarea></cfoutput>
                        </div>
                    </div>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <div class="col col-6">
               <cf_record_info query_name="witness_statement_">
            </div>
            <div class="col col-6">
                <cf_workcube_buttons is_upd='1' is_delete="0" add_function='save_form()'>
            </div>
        </cf_box_footer>
	</cfform>
</cf_box>
<script>

    function save_form(){  

        event_id = document.getElementById("event_id").value;
        sign_date = document.getElementById("sign_date").value;
        witness_1 = document.getElementById("witness1_id").value;
        witness1_detail = document.getElementById("witness1_detail").value;
        witness_2 =document.getElementById("witness2_id").value;
        witness2_detail = document.getElementById("witness2_detail").value;
        witness_3 = document.getElementById("witness3_id").value;
        witness3_detail = document.getElementById("witness3_detail").value; 
        witness_statement_id=<cfoutput>#attributes.witness_statement_id#</cfoutput>;

        $.ajax({ 
            type:'POST',  
            url:'V16/hr/ehesap/cfc/witness_statement.cfc?method=UPD_WITNESS_STATEMENT',
            data: { 
                
                event_id : event_id,
                sign_date : sign_date,
                witness_1 : witness_1,
                witness1_detail : witness1_detail,
                witness_2 : witness_2,
                witness2_detail : witness2_detail,
                witness_3 : witness_3,
                witness3_detail : witness3_detail,
                witness_statement_id : witness_statement_id,
            },
            
            success: function (returnData) {
                window.close();
                return true;
            },
            error: function () 
            {
                console.log('CODE:8 please, try again..');
                return false; 
            }
           
        }); 
         return false;        	        
    }
</script>  