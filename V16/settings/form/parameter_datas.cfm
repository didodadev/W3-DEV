
<!---
File: parameter_datas.cfm
Author: Workcube-Melek KOCABEY <melekkocabey@workcube.com>
Date: 2020/02/28
Controller: 
Description: Parametre Dataları ekleme sayfadır.
--->
<cfset id=url.idd />
<cfsavecontent  variable="title_name"><cf_get_lang dictionary_id="57693.Parametreler"></cfsavecontent>
<cfsavecontent  variable="description_"><cf_get_lang dictionary_id="36199.description"></cfsavecontent>
<cfsavecontent  variable="detail_"><cf_get_lang dictionary_id="32820.ayrıntı"></cfsavecontent>
<cf_wrk_grid
    EditGrid="grid_2"
    search_header="Datas"
    table_name="SETUP_PARAM_DATA"
    left_menu="1"
    sort_column="PARAM_DATA_TYPE"
    u_id="PARAM_DATA_ID"
    datasource="#dsn#"
    search_areas="PARAM_DATA_TYPE"
    keyword="#id#"
    dictionary_count="2"
>
    <cf_wrk_grid_column name="PARAM_DATA_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="PARAM_DATA_TYPE" header="PARAM_DATA_TYPE"  select="no" display="no" type="int"/>
    <cf_wrk_grid_column name="PARAM_DATA_STATUS" header="#getlang('','Aktif','57493')#" select="yes" type="checkbox" display="yes"/>
    <cf_wrk_grid_column name="PARAM_DATA_DESCRIPTION" header="#description_#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="PARAM_DATA_DETAIL" header="#detail_#" select="yes" display="yes"/>
</cf_wrk_grid>