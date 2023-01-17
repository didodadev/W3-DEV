<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.start_date") and len(attributes.start_date) and isdate(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
<cfelse>
	<cfset attributes.start_date = createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')>
</cfif>

<cfinclude template="../../../../V16/cash/query/get_cashes_list.cfm">
<link href="../../../../css/assets/template/report/report.css" rel="stylesheet">

<cf_report_list_search title="#getLang('','Kasa Aktarım Raporu',62229)#">
    <cf_report_list_search_area>
        <cfform action="" method="post" name="search_cash">
            <input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
            <div class="row">
                <div class="col col-12 col-xs-12">
                    <div class="row formContent">
                        <div class="row" type="row">
                            <div class="col col-4 col-md-6 col-xs-12">
                                <div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58657.Kasalar'></label>
									<div class="col col-12 col-xs-12">
                                        <select name="cash_list">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfoutput query="get_cashes">
                                                <div class="col col-12 col-xs-12">
                                                    <option value="#cash_id#">#cash_name#</option>
                                                </div>
                                            </cfoutput>
                                        </select>
									</div>
								</div>
                                <div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='62230.Aktarım Kasa'></label>
									<div class="col col-12 col-xs-12">
                                        <select name="to_cash_id">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfoutput query="get_cashes">
                                                <option value="#cash_id#">#cash_name#</option>
                                            </cfoutput>
                                        </select>
									</div>
								</div>
                                <div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
									<div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#getLang('','Başlangıç Tarihi Girmelisiniz',57738)#" required="yes">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                                        </div>
									</div>
								</div>
                            </div>
                        </div>
                    </div>
                    <div class="row ReportContentBorder">
                		<div class="ReportContentFooter">
                            <cf_wrk_search_button button_type="1">
                        </div>
                    </div>
                </div>
            </div>
        </cfform>
    </cf_report_list_search_area>
</cf_report_list_search>

<cfif isdefined("attributes.is_form_submitted")>
    
    <cfif not isdefined("attributes.cash_list")>
    	<script>
			alert('<cf_get_lang dictionary_id='62231.Aktarılacak Kasa Seçmelisiniz'>!');
			history.back();
		</script>
        <cfabort>
    </cfif>

    
    <cfif not len(attributes.to_cash_id)>
    	<script>
			alert('<cf_get_lang dictionary_id='62232.Aktarım Kasa Seçmelisiniz'>!');
			history.back();
		</script>
        <cfabort>
    </cfif>
    
    <cfif listfind(attributes.cash_list,attributes.to_cash_id)>
    	<script>
			alert('<cf_get_lang dictionary_id='62233.Kendi Üstüne Aktarım Yapamazsınız'>!');
			history.back();
		</script>
        <cfabort>
    </cfif>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box>
            <cfform action="#request.self#?fuseaction=retail.cash_report_add" method="post" name="search_cash2">
                <cfinput type="hidden" name="cash_list" value="#attributes.cash_list#">
                <cfinput type="hidden" name="to_cash_id" value="#attributes.to_cash_id#">
                <cfinput type="hidden" name="action_date" value="#dateformat(attributes.start_date,'dd/mm/yyyy')#">
                <cf_box_elements>
                    <div class="col col-4 col-md-4 col-sm-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-get_c">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='62230.Aktarım Kasa'></label>
                            <div class="col col-8 col-sm-12">
                                <cfquery name="get_c" dbtype="query">
                                    SELECT * FROM get_cashes WHERE CASH_ID = #attributes.to_cash_id#
                                </cfquery>
                                <cfoutput>#get_c.cash_name#</cfoutput>
                            </div>
                        </div>
                        <cfset attributes.record_date = "">
                        <cfset attributes.record_date2 = "">
                        <cfset attributes.page_action_type = "">
                        <cfset attributes.project_head = "">
                        <cfset attributes.project_id = "">
                        <cfloop list="#attributes.cash_list#" index="ccc">
                            <cfset attributes.start_date = dateformat(attributes.start_date,'dd/mm/yyyy')>
                            <cfset attributes.finish_date = attributes.start_date>
                            <cfset attributes.cash = ccc>
                            <div class="form-group" id="item-get_c">
                                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57520.Kasa'></label>
                                <div class="col col-8 col-sm-12">
                                    <cfoutput>
                                        <cfquery name="get_c" dbtype="query">
                                            SELECT * FROM get_cashes WHERE CASH_ID = #ccc#
                                        </cfquery>
                                        <cfinput type="hidden" name="cash_id_#ccc#" value="#ccc#">
                                        #get_c.cash_name#
                                    </cfoutput>
                                </div>
                            </div>
                            <div class="form-group" id="item-cash_value">
                                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57673.Tutar'></label>
                                <div class="col col-8 col-sm-12">
                                    <cfoutput>
                                        <cfinclude template="../../../../V16/cash/query/get_cash_actions.cfm">
                                        <cfset debt_ = 0>
                                        <cfset claim_ = 0>
                                        <cfloop query="get_cash_actions">
                                            <cfif len(CASH_ACTION_TO_CASH_ID)>
                                                <cfset debt_ = debt_+CASH_ACTION_VALUE>
                                            <cfelseif len(CASH_ACTION_FROM_CASH_ID)>
                                                <cfset claim_ = claim_+CASH_ACTION_VALUE>
                                            </cfif>
                                        </cfloop>	
                                        <cfinput type="text" name="cash_value_#ccc#" value="#tlformat(debt_ - claim_)#" style="text-align:right; width:75px;" readonly="yes">
                                    </cfoutput>
                                </div>
                            </div>
                        </cfloop>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <cf_workcube_buttons add_function="control()">
                </cf_box_footer>
            </cfform>
        </cf_box>
    </div>

</cfif>
<script>
    function control(){
        val = $("#cash_list").val();
        val2 = $("#cash_value_"+val).val();
        if(filterNum(val2) <= 0)
        {   
            alert('<cf_get_lang dictionary_id='63647.Bakiye 0 dan büyük olmalıdır'>');
            return false;
        }
        else 
        {
            search_cash2.action = "<cfoutput>#request.self#</cfoutput>?fuseaction=retail.cash_report_add" ;
            search_cash2.submit();

        }
        return true;
    }
</script>