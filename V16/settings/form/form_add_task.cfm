<!---
<cf_wrk_table
	header="d:790"
    name="GET_PARTNER_TASK"
    query="GET_PARTNER_TASK"
    userInfo="1"
    tableName="SETUP_PARTNER_POSITION"
       	column1="PARTNER_POSITION_ID,m:1165,hidden,integer,0,0,0,0,0,0,0,0"
        column2="PARTNER_POSITION,m:161,text,string,1,1,1,0,0,0,0,100"
		column3="DETAIL,m:217,text,string,1,1,1,0,0,0,0,0"
		column4="IS_UNIVERSITY,d:1111,radio,integer,1,1,1,get_task_types,TYPE_NAME,0,IS_UNIVERSITY,0">
		--->
<cf_wrk_grid search_header = "#getLang('settings',790)#" table_name="SETUP_PARTNER_POSITION" sort_column="PARTNER_POSITION" u_id="PARTNER_POSITION_ID" datasource="#dsn#" search_areas = "PARTNER_POSITION,">
    <cf_wrk_grid_column name="PARTNER_POSITION_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="PARTNER_POSITION" width="300" header="#getLang('main',161)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="DETAIL" header="#getLang('main',217)#" width="500" select="yes" display="yes"/>
	<cf_wrk_grid_column name="IS_UNIVERSITY" header="#getLang('settings',1111)#" width="150" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
</cf_wrk_grid>
