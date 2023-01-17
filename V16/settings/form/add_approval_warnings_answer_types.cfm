<cfparam name="attributes.keyword" default="">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='42775.Approval - Notification Reply Category'></cfsavecontent>
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

<cf_wrk_grid keyword="#attributes.keyword#" search_header = "#message#" table_name="SETUP_WARNING_RESULT" sort_column="SETUP_WARNING_RESULT" u_id="SETUP_WARNING_RESULT_ID" datasource="#dsn#" search_areas = "SETUP_WARNING_RESULT,DETAIL" dictionary_count="2">
    <cf_wrk_grid_column name="SETUP_WARNING_RESULT_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="SETUP_WARNING_RESULT" header="#getLang('main',68)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="DETAIL" header="#getLang('main',217)#" width="500" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>