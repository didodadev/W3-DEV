<!--- <cf_wrk_table
	header="Sınav Tipleri"
    name="test_type"
    query="get_test_type"
    userInfo="1"
    tableName="SETUP_TEST_TYPE"
       	column1="ID,d:1165,hidden,integer,0,0,0,0,0,0,0,0"
        column2="TEST_TYPE,Tip,text,string,1,1,1,0,0,0,0,50"
        column3="TEST_DETAIL,m:217,textarea,string,1,1,0,0,0,0,0,200"> --->
<cfsavecontent  variable="title_name"><cf_get_lang dictionary_id="59282.Sınav Tipleri"></cfsavecontent>
    <cfsavecontent  variable="colon_name"><cf_get_lang dictionary_id="59088.Tip"></cfsavecontent>
<cf_wrk_grid search_header = "#title_name#" table_name="SETUP_TEST_TYPE" sort_column="TEST_TYPE" u_id="ID" datasource="#dsn#" search_areas = "TEST_TYPE">
    <cf_wrk_grid_column name="ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="TEST_TYPE" width="300" header="#colon_name#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="TEST_DETAIL" header="#getLang('main',217)#" width="500" select="yes" display="yes"/>
    <cf_wrk_grid_column name="RECORD_EMP" header="#getLang('settings',1138)#" type="int"  width="100" select="no" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
</cf_wrk_grid>
