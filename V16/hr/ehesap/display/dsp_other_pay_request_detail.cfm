<cfquery name="get_payment_request" datasource="#DSN#">
	SELECT 
		*
	FROM 
		SALARYPARAM_GET_REQUESTS 
	WHERE
		SPGR_ID=#attributes.id#
</cfquery>
<cf_catalystHeader>
	<input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
    <div class="row">
    	<div class="col col-12 uniqueRow">
        	<div class="row formContent">
            	<div class="row" type="row">
                	<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    	<div class="form-group" id="item-emp_info">
                        	<label class="col col-3 col-xs-12 txtbold"><cf_get_lang dictionary_id='57576.Çalışan'></label>
                            <label class="col col-9 col-xs-12">
                            	<cfif len(get_payment_request.EMPLOYEE_ID)>
									<cfoutput>#get_emp_info(get_payment_request.EMPLOYEE_ID,0,0)#</cfoutput>
                                </cfif>
                            </label>
                        </div>
                        <div class="form-group" id="item-AMOUNT_GET">
                        	<label class="col col-3 col-xs-12 txtbold"><cf_get_lang dictionary_id='57673.Tutar'></label>
                            <label class="col col-9 col-xs-12">
                            	<cfoutput>#TLFormat(get_payment_request.AMOUNT_GET)#</cfoutput>
                            </label>
                        </div>
                        <div class="form-group" id="item-TAKSIT_NUMBER">
                        	<label class="col col-3 col-xs-12 txtbold"><cf_get_lang dictionary_id="54064.Taksit Sayısı"></label>
                            <label class="col col-9 col-xs-12">
                            	<cfoutput>#get_payment_request.TAKSIT_NUMBER#</cfoutput>
                            </label>
                        </div>
                        <div class="form-group" id="item-DETAIL">
                        	<label class="col col-3 col-xs-12 txtbold"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <label class="col col-9 col-xs-12">
                            	<cfoutput>#get_payment_request.DETAIL#</cfoutput>
                            </label>
                        </div>
                        <div class="form-group" id="item-status">
                        	<label class="col col-3 col-xs-12 txtbold"><cf_get_lang dictionary_id='57756.Durum'></label>
                            <label class="col col-9 col-xs-12">
                            	<cfif get_payment_request.IS_VALID eq 1 >
                                    <cf_get_lang dictionary_id='58699.Onaylandı'>!
                                <cfelse>
                                    <cf_get_lang dictionary_id='57617.Red Edildi'>!
                                </cfif>
                                <cfif len(get_payment_request.VALID_EMP)>
                                    <cfoutput><b>#get_emp_info(get_payment_request.VALID_EMP,0,0)#</b></cfoutput>
                                </cfif>
                            </label>
                        </div>
                    </div>
                </div>
                <div class="row formContentFooter">
                	<div class="col col-6">
                    	<cf_record_info query_name="get_payment_request">
                    </div>
                    <div class="col col-6">
                    	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57463.Sil'></cfsavecontent>
						<cf_workcube_buttons is_upd='0' is_insert ='0' delete_page_url='#request.self#?fuseaction=ehesap.emptypopup_del_other_payment_request&id=#attributes.id#' add_function="kontrol_et()">
                    </div>
                </div>
            </div>
        </div>
    </div>
<script type="text/javascript">
	function kapat()
	{
		window.close();
	}
	function sil()
	{
		window.location.href = '<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_del_other_payment_request&id=#attributes.id#</cfoutput>';
	}
</script>

