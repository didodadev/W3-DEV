<cfparam  name="attributes.table" default="WORKNET_PRODUCT">
<cfset wrk = createObject("component","V16.worknet.cfc.product")>
<cfset get_relation_worknet = wrk.getRelationWorknet(
	pid     :   attributes.pid,
    table   :   attributes.table
)>
<cfparam name="attributes.totalrecords" default='#get_relation_worknet.recordcount#'>
<cf_flat_list>
    <thead>
        <tr>
            <th width="20"><a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=worknet.list_product&event=popup_addWorknetRelation&pid=#attributes.pid#&form_submitted=1&draggable=1</cfoutput>')"><i class="fa fa-plus"></i></a></th>
            <th><cf_get_lang dictionary_id='58158.Pazaryeri'></th>
            <th width="50"><cf_get_lang dictionary_id='58637.Logo'></th>
        </tr>
    </thead>
    <tbody id="tbodyWorknet">
        <cfif attributes.totalrecords>
            <cfoutput query="get_relation_worknet"<!---  startrow="#attributes.startrow#" maxrows="#attributes.maxrows#" --->>
                <tr id="row_#currentrow#">
                    <td><a href="javascript://" onclick="delData('#WORKNET_ID#','#attributes.pid#',#currentrow#);return false;" title="<cf_get_lang dictionary_id='57463.Sil'>"><i class="fa fa-minus"></i></a></td>
                    <td>#WORKNET#</td>
                    <td>
                        <cfif len(get_relation_worknet.IMAGE_PATH)>
                            <cf_get_server_file output_file="asset/watalogyImages/#IMAGE_PATH#" output_server="#SERVER_IMAGE_PATH_ID#" output_type="0" image_height="20">
                        <cfelse>
                            <img src="/images/no_photo.gif" height="20">
                        </cfif>
                    </td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
            </tr>
        </cfif>
    </tbody>
</cf_flat_list>

<script type="text/javascript">
    var recCount = <cfoutput>#attributes.totalrecords#</cfoutput>;
    function delData(wrkid, pid, rowid){
        $.ajax({
            type:'POST',
            dataType: 'JSON',
            url: 'V16/worknet/cfc/product.cfc?method=deleteRelationWorknet',
            data: 'pid='+pid+'&wrkid='+wrkid,
            success: function (response) {
                if(response.STATUS){
                    $("tr#row_"+rowid).remove();
                    recCount--;
                }
                else alert(response.MESSAGE);
                if(recCount <= 0) $("#tbodyWorknet").append("<tr><td colspan=3><cf_get_lang dictionary_id='63774.Entegre pazaryeri bulunamadı'>.</td></tr>");
            }
        });
	}
</script>