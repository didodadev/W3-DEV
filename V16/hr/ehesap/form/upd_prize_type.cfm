<cfquery name="get_type" datasource="#dsn#">
	SELECT
        IS_ACTIVE,
        #dsn#.Get_Dynamic_Language(PRIZE_TYPE_ID,'#session.ep.language#','SETUP_PRIZE_TYPE','DETAIL',NULL,NULL,DETAIL) AS DETAIL,
        PRIZE_TYPE_ID,
        #dsn#.Get_Dynamic_Language(PRIZE_TYPE_ID,'#session.ep.language#','SETUP_PRIZE_TYPE','PRIZE_TYPE',NULL,NULL,PRIZE_TYPE) AS PRIZE_TYPE
	FROM
		SETUP_PRIZE_TYPE
	WHERE
		PRIZE_TYPE_ID = #attributes.prize_type_id#
</cfquery>
<cfquery name="get_prizes" datasource="#dsn#" maxrows="1">
	SELECT
		PRIZE_TYPE_ID
	FROM
		EMPLOYEES_PRIZE
	WHERE
		PRIZE_TYPE_ID = #attributes.prize_type_id#
</cfquery>
<cfsavecontent variable="images"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_add_prize_type"><img src="/images/plus1.gif" title="<cf_get_lang dictionary_id='57582.Ekle'>"></a></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Ödül Tipleri','53504')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform action="#request.self#?fuseaction=ehesap.emptypopup_upd_prize_type" name="upd_prize_type" method="post" >
            <input type="hidden" name="counter" id="counter">
            <cfoutput query="get_type">
                <input type="hidden" value="#attributes.prize_type_id#" name="prize_type_id" id="prize_type_id">
                <cf_box_elements>
                    <div class="col col-6 col-md-6 col-sm-8 col-xs-12" type="column" sort="true" index="1">
                        <div class="form-group" id="item-is_active">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">&nbsp;</label>
                            <label class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cf_get_lang dictionary_id='57493.Aktif'> <input type="checkbox" name="is_active" id="is_active" value="1" <cfif get_type.is_active eq 1>checked</cfif>>
                            </label>
                        </div>
                        <div class="form-group" id="item-prize_type">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='53506.Ödül Tipi'> *</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='53342.ödül tipi girmelisiniz'></cfsavecontent>
                                    <cfinput type="text" name="price_type" style="width:200px;" required="yes" message="#message#" maxlength="100" value="#prize_type#">
                                    <span class="input-group-addon">
                                        <cf_language_info 
                                        table_name="SETUP_PRIZE_TYPE" 
                                        column_name="PRIZE_TYPE" 
                                        column_id_value="#url.prize_type_id#" 
                                        maxlength="500" 
                                        datasource="#dsn#" 
                                        column_id="PRIZE_TYPE_ID" 
                                        control_type="0">
                                    </span>    
                                </div>                                                 
                            </div>
                        </div>
                        <div class="form-group" id="item-DETAIL">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
                                    <cfsavecontent variable="message1"><cf_get_lang dictionary_id="29725.Maksimum Karakter Sayısı"> : 300</cfsavecontent>
                                    <textarea style="width:200px;height:75px;" maxlength="300" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message1#</cfoutput>" name="DETAIL" id="DETAIL">#detail#</textarea>
                                    <span class="input-group-addon">
                                        <cf_language_info 
                                        table_name="SETUP_PRIZE_TYPE" 
                                        column_name="DETAIL" 
                                        column_id_value="#url.prize_type_id#" 
                                        maxlength="500" 
                                        datasource="#dsn#" 
                                        column_id="PRIZE_TYPE_ID" 
                                        control_type="0">
                                    </span> 
                                </div>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>   
                    <cf_record_info query_name="get_type">
                    <cf_workcube_buttons is_upd='1' is_delete="#IIF(get_prizes.RecordCount,0,1)#" delete_page_url='#request.self#?fuseaction=hr.emptypopup_del_prize_type&type_id=#attributes.prize_type_id#'>
                </cf_box_footer>              
            </cfoutput>
        </cfform>
    </cf_box>
</div>