<cfquery name="get_action_type" datasource="#DSN2#">
    SELECT DISTINCT AC.ACTION_TYPE, SPC.PROCESS_CAT, SPC.PROCESS_TYPE FROM ACCOUNT_CARD_ROWS AS ACR 
        JOIN ACCOUNT_CARD AS AC ON ACR.CARD_ID = AC.CARD_ID 
        JOIN #dsn3#.SETUP_PROCESS_CAT AS SPC ON AC.ACTION_TYPE = SPC.PROCESS_TYPE 
        WHERE ACR.ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.account_id#">
</cfquery>
<cfsavecontent variable="title"><cf_get_lang dictionary_id='60115.Bağlantılı İşlemler'></cfsavecontent>
<cf_box title="#title#" closable="1" draggable="1">
    <div class="row">
        <div class="row" type="row">
            <div class="col col-10">
                <div class="form-group">
                    <label class="col col-12"><cf_get_lang dictionary_id='32065.İşlem Tipleri'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <select class="multip-select" multiple="multiple">
                            <cfoutput query="get_action_type">
                                <option value="#PROCESS_TYPE#">#PROCESS_TYPE# - #PROCESS_CAT#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
            </div>
        </div>
        <div class="row formContentFooter">
            <a href="javascript://" onclick="saveType()" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left"><i class="fa fa-plug"></i><cf_get_lang dictionary_id='58693.Seç'></a>
            <a href="javascript://" onclick="ClearType()" class="ui-wrk-btn ui-wrk-btn-red ui-wrk-btn-addon-left"><i class="fa fa-trash"></i><cf_get_lang dictionary_id='57934.Temizle'></a>
        </div>
    </div>
</cf_box>

<script>
   function saveType(){

       $("#action_type_hidden_<cfoutput>#attributes.type_id#</cfoutput>").val( $(".multip-select").val() );
       $("#action_type_<cfoutput>#attributes.type_id#</cfoutput>").val( $(".multip-select").val().length );

   }

   function ClearType(){
        $("#action_type_hidden_<cfoutput>#attributes.type_id#</cfoutput>").val("");
        $("#action_type_<cfoutput>#attributes.type_id#</cfoutput>").val("");
   }
</script>