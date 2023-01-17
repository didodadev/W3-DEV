﻿<cf_wrk_grid search_header = "#getLang('campaign',47)#" table_name="SOCIAL_MEDIA_SEARCH_WORDS" sort_column="WORD" u_id="WORD_ID" datasource="#dsn#" search_areas = "WORD">
    <cf_wrk_grid_column name="WORD_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="WORD" header="#getLang('main',68)#" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
