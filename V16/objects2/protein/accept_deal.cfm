<cfset getComponent = createObject('component','V16.objects2.protein.data.tender_data')>
<cfset get_offer_det = getComponent.GET_OFFER(offer_id : attributes.accepted_offer_id, is_offer_id : 1)>
<cfset get_offer_det_2 = getComponent.GET_OFFER(offer_id : attributes.offer_id)>
<cfform name="accept_deal" id="accept_deal" method="post">
<input type="hidden" name="offer_id" id="offer_id" value="<cfoutput>#attributes.offer_id#</cfoutput>">
<input type="hidden" name="accepted_offer" id="accepted_offer" value="<cfoutput>#attributes.accepted_offer_id#</cfoutput>">
<input type="hidden" name="offer_stage" id="offer_stage" value="459">
<input type="hidden" name="accepted_date" id="accepted_date" value="<cfoutput>#dateformat(get_offer_det.deliverdate,"dd/mm/yyyy")#</cfoutput>">
<input type="hidden" name="old_process_line" id="old_process_line" value="4">
<input type="hidden" name="fuseaction" id="fuseaction" value="purchase.list_offer">
<div class="row">
    <div class="col-md-12">
        <p class="mb-0">İşveren : <cfoutput>#get_offer_det_2.COMPANY_PARTNER_NAME# #get_offer_det_2.COMPANY_PARTNER_SURNAME# / #get_offer_det_2.NICKNAME#</cfoutput></p>
        <p>Yüklenici : <cfoutput>#get_par_info(listdeleteduplicates(get_offer_det.offer_to_partner),0,1,0,1)#</cfoutput> </p>
    </div>
</div>
<div class="table-responsive-sm">
    <table class="table table-borderless">
        <thead class="text-center">
            <tr>
                <th scope="col"><cf_get_lang dictionary_id='57645.Delivery Date'></th>
                <th scope="col"><cf_get_lang dictionary_id='38215.Estimated Time'></th>
                <th scope="col"><cf_get_lang dictionary_id='61800.?'></th>
            </tr>
        </thead>
        <tbody class="border-top text-center">
            <tr>
                <td scope="row"><cfoutput>#dateformat(get_offer_det.deliverdate,"dd.mm.yyyy")#</cfoutput></td>
                <td>
                    <cfif len(get_offer_det.estimated_time)>
                        <cfset est_time_h = get_offer_det.estimated_time / 60>                       
                        <cfset est_time_m = get_offer_det.estimated_time % 60>
                    <cfelse>
                        <cfset est_time_h = 0>
                        <cfset est_time_m = 0>
                    </cfif>
                </td>
                <td><cfoutput>#TlFormat(get_offer_det.other_money_value)#  #get_offer_det.OTHER_MONEY#</cfoutput></td>
            </tr>
        </tbody>
    </table>
</div>
<div class="row mb-3">
    <div class="col-md-12">
        <label><cf_get_lang dictionary_id='61801.?'></label>
        <div id="editor">
        </div>
    </div>
</div>
<div class="row mb-3">
    <div class="col-md-12">
        <label class="checkbox-container font-weight-bold"><cf_get_lang dictionary_id='61803.?'><cf_get_lang dictionary_id='61804.?'>
            <input type="checkbox">
            <span class="checkmark"></span>
            </label>    
            <a href="#" class="none-decoration">
            <p class="ml-4">> <cf_get_lang dictionary_id='61802.?'></p>
        </a>                                 
    </div>
</div> 
    <cf_workcube_buttons is_insert="1" data_action="V16/objects2/protein/data/tender_data:UPD_OFFER_PROCESS" next_page="#site_language_path#/tenderDetail/#attributes.offer_id#">
</cfform>
<script>
    ClassicEditor
        .create(document.querySelector('#editor'))
        .catch(error => {
            console.error(error);
        });
</script>

