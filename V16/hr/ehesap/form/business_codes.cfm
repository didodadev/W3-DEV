<cfparam name="attributes.keyword" default="">
<cfsavecontent variable="message"><cf_get_lang dictionary_id="53840.Meslek Kodları"></cfsavecontent>
<cfform name="list" id="list" method="post" action="">
    <input type="hidden" name="is_submit" id="is_submit" value="1">
    <cf_box>
        <cf_box_search plus="0">
            <div class="form-group">
                <input type="text" name="keyword" id="keyword" placeholder="<cf_get_lang dictionary_id='57460.Filtre'>" value="<cfoutput>#attributes.keyword#</cfoutput>" />
            </div>
            <div class="form-group">
                <cf_wrk_search_button button_type="4">
            </div>
        </cf_box_search>
    </cf_box>
</cfform>
<cf_wrk_grid keyword="#attributes.keyword#" search_header = "#message#" table_name="SETUP_BUSINESS_CODES" left_menu="1" sort_column="BUSINESS_CODE_NAME" u_id="BUSINESS_CODE_ID" datasource="#dsn#" search_areas = "BUSINESS_CODE_NAME,BUSINESS_CODE"  dictionary_count="2">
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="58527.ID"></cfsavecontent>
    <cf_wrk_grid_column name="BUSINESS_CODE_ID" header="#message#" display="no" select="yes"/>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="58585.Kod"></cfsavecontent>
    <cf_wrk_grid_column name="BUSINESS_CODE" width="300" header="#message#" select="yes" display="yes"/>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="53861.Meslek Grubu"></cfsavecontent>
    <cf_wrk_grid_column name="BUSINESS_CODE_NAME" header="#message#" select="yes" display="yes"/>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57493.Aktif"></cfsavecontent>
    <cf_wrk_grid_column name="IS_ACTIVE" header="#message#" type="boolean" width="100" select="yes" display="yes"/>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57627.Kayıt Tarihi"></cfsavecontent>
    <cf_wrk_grid_column name="RECORD_DATE" header="#message#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="53848.Güncelleme Tarihi"></cfsavecontent>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#message#" type="date" mask="date" width="100" select="no" display="yes"/>
</cf_wrk_grid>
