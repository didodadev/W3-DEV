
<cfquery name="GET_MONEYS" datasource="#DSN#">
    SELECT
        MONEY_ID,
        MONEY
    FROM
        SETUP_MONEY
    WHERE
        PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.PERIOD_ID#">
</cfquery>
<cfif isDefined("attributes.offer_id") and len(attributes.offer_id)>
    <cfset getOffer = createObject("component", "V16.objects2.protein.data.tender_data" )>
    <cfset offer_detail = getOffer.GET_OFFER(offer_id : attributes.offer_id)>
</cfif>
<form>
    <div class="form-row "> 
        <cfif isDefined("attributes.offer_id") and len(attributes.offer_id)>
            <input type="hidden" name="offer_id" value="<cfoutput>#attributes.offer_id#</cfoutput>">
        <cfelse>
            <input type="hidden" name="for_offer_id" value="<cfoutput>#attributes.for_offer_id#</cfoutput>">
        </cfif>
        <div class="form-group col-sm-6 col-md-6 col-lg-3">
            <label class="font-weight-bold"><cf_get_lang dictionary_id='38308.Öngörülen Bütçe'></label>                    
            <input type="text" name="price_tutar" value="<cfoutput>#( isdefined("offer_detail") and len(offer_detail.OTHER_MONEY_VALUE) ) ? TLFormat(offer_detail.OTHER_MONEY_VALUE) : ""#</cfoutput>" class="form-control text-right" onkeyup="return FormatCurrency(this,event,2);" placeholder="<cf_get_lang dictionary_id='61853.Rakam Giriniz'>">                
        </div>

        <div class="form-group col-sm-4 col-md-4 col-lg-2">      
            <label class="font-weight-bold"><cf_get_lang dictionary_id='57489.Para Br'></label>      
            <select class="form-control" name="money" id="money" style="background-color">
                <cfoutput query="get_moneys">
                    <option value="#money#"<cfif isdefined("offer_detail") and len(offer_detail.OTHER_MONEY) eq money>selected<cfelseif money eq session_base.money>selected</cfif>>#money#</option>
                </cfoutput>
            </select>         
        </div>
        <div class="form-group col-sm-5 col-md-5 col-lg-3 ">
            <label class="font-weight-bold"><cf_get_lang dictionary_id='36798.Termin'></label>
            <input type="date" name="deliverdate" class="form-control" value="<cfoutput>#( isdefined("offer_detail") and len(offer_detail.DELIVERDATE) ) ? dateformat(offer_detail.DELIVERDATE,'yyyy-mm-dd') : ""#</cfoutput>">
        </div>

        <div class="form-group col-8 col-sm-4 col-md-4 col-lg-3 ">
            <label class="font-weight-bold"><cf_get_lang dictionary_id='38215.Öngörülen Süre'></label>
            <div class="form-row">
                <div class="col-6">
                    <input type="text" class="form-control text-right" placeholder="<cf_get_lang dictionary_id='57491.Saat'>" >
                </div>
                <div class="col-6">
                    <input type="text" class="form-control text-right" placeholder="<cf_get_lang dictionary_id='58127.Dakika'>" >
                </div>
            </div>
        </div>     
    
    </div>
    <div class="mb-3">
        <div class="col-md-12 p-0">
            <textarea class="inputStyle" id="editor2" name="offer_detail"><cfoutput>#( isdefined("offer_detail") and len(offer_detail.OFFER_DETAIL) ) ? offer_detail.OFFER_DETAIL : ""#</cfoutput></textarea>
        </div>
    </div>    
    <div class="mb-3">
        <div class="col-md-12 p-0">
            <label class="checkbox-container font-weight-bold mb-0"> <cf_get_lang dictionary_id='61852.Karşı teklif işveren tarafından 72 saat içinde kabul edilirse bağlayıcıdır..'>
                <input type="checkbox" name="check">
                <span class="checkmark"></span>
            </label> 
            <cfif isDefined("attributes.x_content_id") and len(attributes.x_content_id)>
                <cfquery name="get_content" datasource="#dsn#">
                    SELECT CONT_HEAD FROM CONTENT WHERE CONTENT_ID = #attributes.x_content_id# AND LANGUAGE_ID = '#session_base.language#'
                </cfquery>
                <cfif get_content.recordcount>
                    <a href="javascript://" onclick="openBoxDraggable('widgetloader?widget_load=viewContent&x_content_id=<cfoutput>#attributes.x_content_id#</cfoutput>&isbox=1&style=maxi&title=<cfoutput>#get_content.CONT_HEAD#</cfoutput>')" class="none-decoration">
                        <p class="ml-4 small"><cf_get_lang dictionary_id='61815.Sözleşmeyi okumak için tıklayınız'>!</p>
                    </a>
                </cfif>
            </cfif>    
        </div>
    </div> 
    <cfif isdefined("offer_detail") and offer_detail.recordcount gt 0 >
        <cf_workcube_buttons is_insert="0" data_action="V16/objects2/protein/data/tender_data:UPD_OFFER" add_function="kontrol" next_page="#site_language_path#/tenderDetail/#attributes.for_offer_id#">
    <cfelse>
        <cf_workcube_buttons is_insert="1" data_action="V16/objects2/protein/data/tender_data:ADD_OFFER" add_function="kontrol" next_page="#site_language_path#/tenderDetail/#attributes.for_offer_id#">
    </cfif>
</form>
<script>

    function kontrol(){
        if( !$("input[name=check]").prop( "checked" )){
            alertMessage({
                title: "Sözleşmeyi Onaylamadınız!",
                message: "Lütfen Sözleşmeyi Okuyup Onaylayın!"
            });
            return false;
        }
    }
    ClassicEditor
        .create(document.querySelector('#editor2'))
        .catch(error => {
            console.error(error);
        });
</script>