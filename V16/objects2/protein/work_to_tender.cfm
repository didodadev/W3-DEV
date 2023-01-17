
<cfquery name="GET_MONEYS" datasource="#DSN#">
    SELECT
        MONEY_ID,
        MONEY
    FROM
        SETUP_MONEY
    WHERE
        PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.PERIOD_ID#">
</cfquery>
<cfset getOffer = createObject("component", "V16.objects2.protein.data.tender_data" )>
<cfif isDefined("attributes.offer_id") and len(attributes.offer_id)>
    <cfset offer_detail = getOffer.GET_OFFER(offer_id : attributes.offer_id)>
<cfelse>
    <cfset work_detail = getOffer.GET_WORK(work_id : attributes.work_id)>
</cfif>
<form>
    <div class="form-row "> 
        <cfif isDefined("attributes.offer_id") and len(attributes.offer_id)>
            <input type="hidden" name="offer_id" value="<cfoutput>#attributes.offer_id#</cfoutput>">
        <cfelse>
            <input type="hidden" name="work_id" value="<cfoutput>#attributes.work_id#</cfoutput>">
            <input type="hidden" name="stock_id" value="<cfoutput>#attributes.stock_id#</cfoutput>">
        </cfif>
        <div class="form-group col-sm-6 col-md-6 col-lg-3">
            <label class="font-weight-bold"><cf_get_lang dictionary_id='38308.Öngörülen Bütçe'></label>                    
            <input type="text" name="price_tutar" value="<cfoutput>#( isdefined("offer_detail") and len(offer_detail.OTHER_MONEY_VALUE) ) ? TLFormat(offer_detail.OTHER_MONEY_VALUE) : ""#</cfoutput>" class="form-control text-right" onkeyup="return FormatCurrency(this,event,2);" placeholder="<cf_get_lang dictionary_id='29535.Tutar Giriniz'>">                
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
            <label class="font-weight-bold"><cf_get_lang dictionary_id='31639.Yayın Tarihi'></label>
            <input type="date" name="startdate" class="form-control" value="<cfoutput>#( isdefined("offer_detail") and len(offer_detail.STARTDATE) ) ? dateformat(offer_detail.STARTDATE,'yyyy-mm-dd') : ""#</cfoutput>">
        </div>
        <div class="form-group col-sm-5 col-md-5 col-lg-3 ">
            <label class="font-weight-bold"><cf_get_lang dictionary_id='38503.Son Teklif Tarihi'></label>
            <input type="date" name="offer_finishdate" class="form-control" value="<cfoutput>#( isdefined("offer_detail") and len(offer_detail.OFFER_FINISHDATE) ) ? dateformat(offer_detail.OFFER_FINISHDATE,'yyyy-mm-dd') : ""#</cfoutput>">
        </div>
        <div class="form-group col-sm-5 col-md-5 col-lg-3 ">
            <label class="font-weight-bold"><cf_get_lang dictionary_id='36798.Termin'></label>
            <input type="date" name="deliverdate" class="form-control" value="<cfoutput>#( isdefined("offer_detail") and len(offer_detail.DELIVERDATE) ) ? dateformat(offer_detail.DELIVERDATE,'yyyy-mm-dd') : ""#</cfoutput>">
        </div>

        <div class="form-group col-8 col-sm-4 col-md-4 col-lg-3 ">
            <label class="font-weight-bold"><cf_get_lang dictionary_id='38215.Öngörülen Süre'></label>
                <cfif isDefined("offer_detail")>
                    <cfset liste=offer_detail.estimated_time/60>
                    <cfset saat=listfirst(liste,'.')>
                    <cfset dak=offer_detail.estimated_time-saat*60>
                <cfelseif isDefined("work_detail")>
                    <cfset liste=work_detail.estimated_time/60>
                    <cfset saat=listfirst(liste,'.')>
                    <cfset dak=work_detail.estimated_time-saat*60>
                </cfif>
            <div class="form-row">
                <div class="col-6">
                    <input type="text" class="form-control text-right" placeholder="<cf_get_lang dictionary_id='57491.Saat'>" value="<cfoutput>#( isdefined("offer_detail") or isdefined("work_detail") ) ? saat : ""#</cfoutput>">
                </div>
                <div class="col-6">
                    <input type="text" class="form-control text-right" placeholder="<cf_get_lang dictionary_id='58127.Dakika'>" value="<cfoutput>#( isdefined("offer_detail") or isdefined("work_detail") ) ? dak : ""#</cfoutput>">
                </div>
            </div>
        </div>     
    
    </div>
    <p><cf_get_lang dictionary_id='61946.İşin maliyeti veya süresi hakkında bir öngörünüz yok ise inputları boş bırakabilirsiniz.'></p>
    <div class="mb-3">
        <div class="col-md-12 p-0">
            <label for="detail"><cf_get_lang dictionary_id='61947.Katılımcıların doğru fiyat ve termin verebilmesi için ek bilgiler girebilirsiniz.'></label>
            <textarea class="inputStyle" id="editor2" name="offer_detail"><cfoutput>#( isdefined("offer_detail") and len(offer_detail.OFFER_DETAIL) ) ? offer_detail.OFFER_DETAIL : ""#</cfoutput></textarea>
        </div>
    </div>    
    <cfif not isDefined("attributes.offer_id") >
        <div class="mb-3">
            <div class="col-md-12 p-0">
                <label class="checkbox-container font-weight-bold mb-0"> <cf_get_lang dictionary_id='61948.Bu işi Workcube uzmanlar topluluğunun erişimine açmayı kabul ederek teklif vermelerine izin verdim.'>
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
    </cfif>
    <cfif isdefined("offer_detail") and offer_detail.recordcount gt 0 >
        <cf_workcube_buttons is_insert="0" data_action="V16/objects2/protein/data/tender_data:UPD_OFFER" next_page="#site_language_path#/taskdetail?wid=#contentEncryptingandDecodingAES(isEncode:1,content:attributes.work_id,accountKey:"wrk")#">
    <cfelse>
        <cf_workcube_buttons is_insert="1" data_action="V16/objects2/protein/data/tender_data:ADD_OFFER" add_function="kontrol()" next_page="#site_language_path#/taskdetail?wid=#contentEncryptingandDecodingAES(isEncode:1,content:attributes.work_id,accountKey:"wrk")#">
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