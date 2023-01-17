<cfset wrk = createObject("component","V16.worknet.cfc.worknet_add_member")>
<cfset get_relation_worknet = wrk.getRelationWorknet(
	cpid     :   attributes.cpid
)>
<cfparam name="attributes.totalrecords" default='#get_relation_worknet.recordcount#'>

<cf_flat_list>
    <thead>
        <tr>
            <th width="20"><a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=worknet.form_list_company&event=popup_addWorknetRelation&cpid=#attributes.cpid#&draggable=1&form_submitted=1</cfoutput>')"><i class="fa fa-plus"></i></a></th>
            <th><cf_get_lang dictionary_id='58158.Pazaryeri'></th>
            <th width="50"><cf_get_lang dictionary_id='58637.Logo'></th>
        </tr>
    </thead>
    <tbody id="tbodyWorknet">
        <cfif attributes.totalrecords>
            <cfoutput query="get_relation_worknet"<!---  startrow="#attributes.startrow#" maxrows="#attributes.maxrows#" --->>
                <tr id="row_#currentrow#">
                    <td><a href="javascript://" onclick="delData('#WORKNET_ID#','#attributes.cpid#',#currentrow#); return false;"><i class="fa fa-minus"></i></a></td>
                    <td>#WORKNET#</td>
                    <td>
                        <cfif len(get_relation_worknet.IMAGE_PATH)>
                            <cf_get_server_file output_file="asset/watalogyImages/#IMAGE_PATH#" output_server="#SERVER_IMAGE_PATH_ID#" output_type="0" image_height="30">
                        <cfelse>
                            <img src="/images/no_photo.gif" height="30">
                        </cfif>
                    </td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="3"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
            </tr>
        </cfif>
    </tbody>
</cf_flat_list>

<script type="text/javascript">
    var recCount = <cfoutput>#attributes.totalrecords#</cfoutput>;
    function delData(wrkid, compid, rowid){
        $.ajax({
            type:'POST',
            dataType: 'JSON',
            url: 'V16/worknet/cfc/worknet_add_member.cfc?method=deleteRelationWorknet',
            data: 'cpid='+compid+'&wrkid='+wrkid,
            success: function (response) {
                if(response.STATUS){
                    $("#row_"+rowid).remove();
                    recCount--;
                }
                else{
                    alert(response.MESSAGE);
                }
                if(recCount <= 0){
                    $("#tbodyWorknet").append("<tr><td colspan=3>Entegre pazaryeri bulunamadi.</td></tr>");
                }
            }
        });
	}
</script>