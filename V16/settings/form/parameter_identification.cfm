<!---
    File: parameter_identification.cfm
    Controller: 
    Folder: settings\form\parameter_identification.cfm
    Author: Workcube-Melek KOCABEY <melekkocabey@workcube.com>
    Date: 2020/02/26 14:23:21
    Description:Parametre Tanımları/Dataları yönetildiği sayfadır.
    History:      
    To Do:
--->
<div class="col col-6 col-md-6 col-sm-6">
    <cfsavecontent  variable="title_name"><cf_get_lang dictionary_id="60370.Parametre Tipleri"></cfsavecontent>
    <cfsavecontent  variable="param_name"><cf_get_lang dictionary_id="57630.Tip"></cfsavecontent>
    <cf_wrk_grid EditGrid="grid_1" search_header = "Params" table_name="SETUP_PARAM_TYPE" btn_pasif="1" left_menu="1" sort_column="PARAM_TYPE_NAME" u_id="PARAM_TYPE_ID" datasource="#dsn#" search_areas = "PARAM_TYPE_NAME" dictionary_count="2">
        <cf_wrk_grid_column name="PARAM_TYPE_ID" header="ID" display="no" select="yes"/>
        <cf_wrk_grid_column name="PARAM_TYPE_NAME" header="#param_name#" select="yes" display="yes"/>
        <cf_wrk_grid_column name="PARAM_XML_NO" header="XML_NO" select="yes" display="yes"/>
        <cf_wrk_grid_column name="RECORD_EMP" header="#getLang('settings',1138)#" type="int"  width="100" select="no" display="yes"/>
    </cf_wrk_grid>
</div>
<div class="col col-6 col-md-6 col-sm-6" id="parameters_data"></div>
<script>
    $('[data-button="list"]').click(function() {
        sendData = '';
         var record = $(this).closest('tr');
            record.find('td').each (function() {
                if($(this).data('upd')=='PARAM_XML_NO'){
                    var did		= $(this).find('PARAM_XML_NO').attr('id');
                    var dval	= trim($(this).html());
                    sendData = dval ;
                }		
            });
            if(sendData == "") sendData = 0;
            var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_parameter_datas&idd="+sendData;
        // alert(AjaxPageLoad(send_address,'',1,''));
        AjaxPageLoad(send_address,'parameters_data',1,'');
    });
</script>
