<cfquery name="get_companies" datasource="#dsn#">
	SELECT 
    	COMP_ID, 
        COMPANY_NAME
    FROM 
	    OUR_COMPANY 
</cfquery>
<cf_box title="#getLang('','Banka Talimatları Aktarım','42349')#">
    <cfform name="add_cheque_entry" action="#request.self#?fuseaction=bank.emptypopup_bank_order_copy" method="post" >
        <cf_box_elements>
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group"  id="item-source_company">
                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><cf_get_lang dictionary_id='43575.Hangi Şirketten'></label>
                    <div class="col col-5 col-md-5 col-sm-5 col-xs-12" >
                        <select name="source_company" id="source_company" onchange="show_periods_departments(1)">
                            <cfoutput query="get_companies">
                                <option value="#comp_id#" <cfif isdefined("attributes.source_company") and attributes.source_company eq comp_id>selected<cfelseif comp_id eq session.ep.company_id>selected</cfif>>#company_name#</option>
                            </cfoutput>
                        </select>
                    </div>
                    <div class="col col-5 col-md-5 col-sm-5 col-xs-12"   id="source_div">
                        <select name="from_cmp" id="from_cmp">
                            <cfif isdefined("attributes.source_company") and len(attributes.source_company)>
                                <cfquery name="get_periods" datasource="#dsn#">
                                    SELECT * FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #attributes.source_company# ORDER BY OUR_COMPANY_ID,PERIOD_YEAR
                                </cfquery>
                                <cfoutput query="get_periods">				
                                    <option value="#period_id#" <cfif isdefined("attributes.from_cmp") and attributes.from_cmp eq period_id>selected</cfif>>#period#</option>						
                                </cfoutput>
                            </cfif>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-target_company">
                    <label class="col col-2 col-md-2 col-sm-2 col-xs-12"><cf_get_lang dictionary_id='43576.Hangi Şirkete'></label>
                    <div class="col col-5 col-md-5 col-sm-5 col-xs-12" >
                        <select name="target_company" id="target_company" onchange="show_periods_departments(2)">
                            <cfoutput query="get_companies">
                                <option value="#comp_id#" <cfif isdefined("attributes.target_company") and attributes.target_company eq comp_id>selected<cfelseif comp_id eq session.ep.company_id>selected</cfif>>#company_name#</option>
                            </cfoutput>
                        </select>
                    </div>
                    <div class="col col-5 col-md-5 col-sm-5 col-xs-12" id="target_div" >
                        <select name="to_cmp" id="to_cmp">
                            <cfif isdefined("attributes.target_company") and len(attributes.target_company)>
                                <cfoutput query="get_periods">				
                                    <option value="#period_id#" <cfif isdefined("attributes.to_cmp") and attributes.to_cmp eq period_id>selected</cfif>>#period#</option>						
                                </cfoutput>
                            </cfif>
                        </select>
                    </div>
                </div>
            </div>
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                <label class="col col-12 col-md-12 col-sm-12 col-xs-12 bold "></b><cf_get_lang dictionary_id='57433.Yardım'><br/></label>
                <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='63023.Önceki dönemdeki banka talimatlarının (havale edilmeyen ve aktarılacak dönemde ödeme tarihi, o yıl içinde olup ödenmeyenler) bir sonraki döneme aktarılır.'>
                <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='62988.Aktarım bir kere yapılabilir.'></label>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12 text-right">
                <cf_workcube_buttons type_format="1" is_upd='0'>
            </div>
        </cf_box_footer>           
    </cfform>
</cf_box>
<script type="text/javascript">
    function show_periods_departments(number)
	{
		if(number == 1)
		{
			if(document.getElementById('source_company').value != '')
			{
				var company_id = document.getElementById('source_company').value;
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
				AjaxPageLoad(send_address,'from_cmp',1,'Dönemler');
			}
		}
		else if(number == 2)
		{
			if(document.getElementById('target_company').value != '')
			{
				var company_id = document.getElementById('target_company').value;
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
				AjaxPageLoad(send_address,'to_cmp',1,'Dönemler');
			}
		}
	}
	$(document).ready(function(){
		<cfif NOT (isdefined("attributes.target_company") and len(attributes.target_company))>
			var company_id = document.getElementById('target_company').value;
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
			AjaxPageLoad(send_address,'to_cmp',1,'Dönemler');
		</cfif>
		}
	)
	$(document).ready(function(){
		<cfif NOT (isdefined("attributes.source_company") and len(attributes.source_company))>
			var company_id = document.getElementById('source_company').value;
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
			AjaxPageLoad(send_address,'from_cmp',1,'Dönemler');
		</cfif>
		}
	)
</script>