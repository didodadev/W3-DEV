<cfsavecontent variable="message"><cf_get_lang dictionary_id='37222.PBS Kategorileri'></cfsavecontent>
<cf_wrk_grid search_header = "#message#" table_name="SETUP_PBS_CAT" left_menu="1" sort_column="PBS_CAT_NAME" u_id="PBS_CAT_ID" datasource="#dsn3#" search_areas = "PBS_CAT_NAME">
    <cf_wrk_grid_column name="PBS_CAT_ID" header="ID" display="no" select="yes"/>

    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57480.Konu'></cfsavecontent>
    <cf_wrk_grid_column name="PBS_CAT_NAME" header="#message#" select="yes" display="yes"/>

    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></cfsavecontent>
    <cf_wrk_grid_column name="RECORD_DATE" header="#message#" type="date" mask="date" width="100" select="no" display="yes"/>
    
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='37915.Kişi Sayısı'></cfsavecontent>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#message#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
