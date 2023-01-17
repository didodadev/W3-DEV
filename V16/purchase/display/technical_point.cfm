<cfquery name="get_coming_for_offer_row" datasource="#dsn3#">
    SELECT
        ORW.PRODUCT_ID,
        ORW.PRODUCT_NAME,
        ORW.QUANTITY
    FROM
        OFFER O,
        OFFER_ROW ORW
    WHERE
        O.OFFER_ID = ORW.OFFER_ID AND
        O.OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.coming_offer_id#">
    ORDER BY
        ORW.OFFER_ROW_ID
</cfquery>
<cfquery name="get_coming_offer_details" datasource="#dsn3#">
    SELECT OFFER_NUMBER FROM OFFER WHERE OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.coming_offer_id#">
</cfquery>
<cfsavecontent variable="box_title"><cf_get_lang dictionary_id="35341.Teknik Puanlama"></cfsavecontent>
<cf_box id="technical_point_box" title="#box_title#" collapsable="0" draggable="1" closable="1">
    <cfform name="add_technical_point" method="post" action="">
        <div class="row">
            <div class="col col-12 col-xs-12 uniqueRow">
                <div class="form-group">
                    <label class="col col-12 col-xs-12 txtbold font-sm control-label text-center">
                        <cfoutput>#get_par_info(attributes.comp_par_id,0,1,0,1)#/#get_coming_offer_details.OFFER_NUMBER#</cfoutput>
                    </label>
                </div>
            </div>
            <hr>
            <div class="col col-12 col-xs-12 uniqueRow">
                <div class="form-group">
                    <label class="col col-4 col-xs-12 txtbold font-sm control-label padding-left-0 text-center">
                        <cf_get_lang dictionary_id="58221.Ürün Adı">
                    </label>
                    <label class="col col-3 col-xs-12 txtbold font-sm control-label padding-left-0 text-center">
                        <cf_get_lang dictionary_id="35353.Teknik Puan">
                    </label>
                    <label class="col col-5 col-xs-12 txtbold font-sm control-label padding-left-0 text-center">
                        <cf_get_lang dictionary_id="36199.Açıklama">
                    </label>
                </div>
            </div>
            <hr>
        </div>
        <div class="row">
            <div class="col col-12 col-xs-12 uniqueRow">
                <cfinput type="hidden" name="offer_id" value="#attributes.coming_offer_id#">
                <cfinput type="hidden" name="for_offer_id" value="#attributes.for_offer_id#">
                <cfinput type="hidden" name="company_id" value="#attributes.company_id#">
                <cfinput type="hidden" name="record_count" value="#get_coming_for_offer_row.recordCount#">
                <cfset counter = 1>
                <cfloop query="#get_coming_for_offer_row#">
                    <cfinput type="hidden" name="product_id#counter#" value="#PRODUCT_ID#">
                    <div class="form-group">
                        <label class="col col-4 col-xs-12 control-label padding-left-0"><cfoutput>#counter# - #PRODUCT_NAME#</cfoutput></label>
                        <div class="col col-3 col-xs-12 padding-left-0">
                            <select name="point_number<cfoutput>#counter#</cfoutput>" id="point_number<cfoutput>#counter#</cfoutput>" <cfif quantity eq 0>disabled</cfif>>
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfloop index="i" from="1" to="10">
                                    <cfoutput><option value="#i#">#i#</option></cfoutput>
                                </cfloop>
                            </select>
                        </div>
                        <div class="col col-5 col-xs-12 padding-left-0 ">
                            <input type="text" name="description<cfoutput>#counter#</cfoutput>" id="description<cfoutput>#counter#</cfoutput>" value="" <cfif quantity eq 0>disabled</cfif>>
                        </div>
                    </div>
                    <cfset counter = counter + 1>
                </cfloop>
            </div>
        </div>
        <div class="row formContentFooter padding-top-5 padding-bottom-5 text-right" style="height:35px !important;">
            <cf_workcube_buttons is_upd='0'<!---  add_function="control()" --->>
        </div>
    </cfform>
</cf_box>
<script type="text/javascript">
    function control(){
        for(i = 1; i <= parseInt($('#record_count').val()); i++){
            if($('#point_number' + i).val() == ''){
                alertObject({message: "<cf_get_lang dictionary_id='57471.Eksik veri'> : " + i + ".<cf_get_lang dictionary_id='58508.Satır'> - <cf_get_lang dictionary_id="35353.Teknik Puan">"});
                $('#point_number' + i).focus();
                return false;
            }
        }
        return true;
    }
</script>