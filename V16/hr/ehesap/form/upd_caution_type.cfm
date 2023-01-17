<cfquery name="get_type" datasource="#dsn#">
  SELECT
    *
  FROM
    SETUP_CAUTION_TYPE
  WHERE
     CAUTION_TYPE_ID = #URL.caution_type_id#
</cfquery>
<cfquery name="get_caution" datasource="#dsn#" maxrows="1">
	SELECT 
		CAUTION_ID 
	FROM 
		EMPLOYEES_CAUTION 
	WHERE 
		CAUTION_TYPE_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.caution_type_id#"> 
</cfquery>
<cf_catalystHeader>
	<cfform action="#request.self#?fuseaction=ehesap.emptypopup_upd_caution_type" name="upd_caution_type" method="post" >
		<input type="hidden" name="counter" id="counter">
		<cfoutput query="get_type">
		<input type="hidden" value="#attributes.caution_type_id#" name="caution_type_id" id="caution_type_id">
        <div class="row">
            <div class="col col-12 uniqueRow">
                <div class="row formContent">
                    <div class="row" type="row">
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group" id="item-is_active">
                                <label class="col col-3 col-xs-12"><span class="hide"><cf_get_lang dictionary_id='57493.Aktif'></span></label>
                                <label class="col col-9 col-xs-12">
                                    <cf_get_lang dictionary_id='57493.Aktif'> <input type="checkbox" name="is_active" id="is_active" value="1" <cfif get_type.is_active eq 1>checked</cfif>>
                                </label>
                            </div>
                            <div class="form-group" id="item-caution_type">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='53103.İhtar Tipi'>*</label>
                                <div class="col col-9 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='53307.ihtar tipi girmelisiniz'></cfsavecontent>
                                    <cfinput type="text" name="caution_type" style="width:200px;" required="yes" message="#message#" maxlength="100" value="#caution_type#">
                                </div>
                            </div>
                            <div class="form-group" id="item-DETAIL">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                                <div class="col col-9 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
                                    <textarea style="width:200px;height:100px;" name="DETAIL" id="DETAIL" maxlength="300" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>">#detail#</textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row formContentFooter">
                        <div class="col col-6">
                            <cf_record_info query_name="get_type">
                        </div>
                        <div class="col col-6">
                            <cf_workcube_buttons is_upd='1' is_delete="#IIF(get_caution.RecordCount,0,1)#" delete_page_url='#request.self#?fuseaction=ehesap.emptypopup_del_caution_type&CAUTION_TYPE_ID=#attributes.caution_type_id#'>
                        </div>
                    </div>
                </div>
            </div>
        </div>
		</cfoutput>
	</cfform>
