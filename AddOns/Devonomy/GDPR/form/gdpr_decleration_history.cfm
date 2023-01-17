<cfset comp = createObject("component","AddOns.Devonomy.GDPR.cfc.gdpr_decleration")/>
<cfset Data_Decleration = comp.Data_Decleration()/>                     
<cf_box  title="#getLang('','Gdpr Tarihçe','64697')#" popup_box="1">
    <cfset temp_ = 0>
    <cfoutput query="Data_Decleration">
        <cfset temp_ = temp_ +1>
        <cf_seperator id="history_#temp_#" header="#GDPR_DECLERATION_ID# - #dateformat(record_date,dateformat_style)# (#timeformat(record_date,timeformat_style)#) - #record_name#" is_closed="1">
            <cf_box_elements id="history_#temp_#" style="display:none;">
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-product_name">
                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12" style="padding-left:15px;padding-right:22px;">
                            #GDPR_DECLERATION_TEXT#
                        </div>                
                    </div> 
                </div>
            </cf_box_elements>
    </cfoutput>
</cf_box>