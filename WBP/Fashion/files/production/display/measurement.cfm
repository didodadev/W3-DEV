
<cfparam name="attributes.order_id_" default="">
<cfparam name="attributes.order_amount_" default="">
<cfparam name="attributes.marj_" default="">

<cfobject name="operation_process" component="WBP.Fashion.files.cfc.operation_process">
<cfobject name="station_process" component="WBP.Fashion.files.cfc.station_process">

<cfif cgi.REQUEST_METHOD eq "POST" and isDefined( "attributes.mode" ) and attributes.mode eq "save_list">
    <cfset predefined_list = station_process.get_predefined_byname( attributes.listname )>
    <cfset predefined_current_id = 0>
    <cfif predefined_list.recordcount>
        <cfset predefined_current_id = predefined_list['PREDEFINED_ID'][1]>
        <cfset station_process.clear_predefined_rows( predefined_current_id )>
    <cfelse>
        <cfset predefined_current_id = station_process.insert_predefined( attributes.listname )>
    </cfif>
    <cfloop index="item" list="#attributes.listitems#">
        <cfset station_process.insert_predefined_row( predefined_current_id, item )>
    </cfloop>
    <cfset GetPageContext().getCFOutput().clear()>
    <cfset predefined_list = station_process.get_predefineds(req_id:attributes.req_id,order_id:attributes.order_id_)>
    <cfset predefined_row_list = station_process.get_predefined_rows( dsn3 )>
    <cfsavecontent variable="predefined_elements"><cfoutput query="predefined_row_list">{ "rowid": #P_OPERATION_ID#, "id": #MAIN_OPERATION_ID#, "operation_type_id": #operation_type_id#, "operation_type": "#operation_type#" },</cfoutput></cfsavecontent>
    {
        "status": true,
        "predefined": "<cfoutput query="predefined_list"><li><a href=\"javascript:void(0);\" onclick=\"setlist(#MAIN_OPERATION_ID#, '#ORDER_NUMBER# #REQ_NO#')\">#ORDER_NUMBER# #REQ_NO#</a></li></cfoutput>",
        "predefined_arr": [ <cfoutput><cfif len(predefined_elements)>#mid(predefined_elements, 1, len(predefined_elements)-1)#</cfif></cfoutput> ]
    }
    <cfabort>
</cfif>
<cfif not isDefined("attributes.main_operation_id")>
    <cfset predefined_list = operation_process.get_predefineds(req_id:attributes.req_id,order_id:attributes.order_id_)>
<cfelse>
    <cfset predefined_list = operation_process.get_predefineds(main_operation_id:attributes.main_operation_id)>
    <cfset attributes.order_id_=predefined_list.ORDER_ID>
    <cfset attributes.req_id=predefined_list.req_id>
    <cfset attributes.req_no=predefined_list.req_no>
    <cfset attributes.order_no=predefined_list.order_number>
    <cfset attributes.order_amount_=predefined_list.AMOUNT>
    <cfset attributes.marj_=predefined_list.MARJ>
</cfif>

<cfset predefined_row_list = operation_process.get_predefined_rows( dsn3 )>
<cfset op_list = operation_process.getOperation( dsn3 )>

<cfset pageHead = "Operasyon Akış Yönetimi">
<cf_catalystHeader>
    
	<!---künye numune özet--->
	<cfinclude template="../../sales/query/get_req.cfm">
	<cfscript>
		CreateCompenent = CreateObject("component","WBP.Fashion.files.cfc.get_sample_request");
		getAsset=CreateCompenent.getAssetRequest(action_id:#attributes.req_id#,action_section:'REQ_ID');
	</cfscript>
	<!---künye numune özet--->
	
	<div class="col col-12">
			<cf_box id="sample_request" closable="0" unload_body = "1"  title="Numune Özet" >
				<div class="col col-10 col-xs-12 ">
						<cfinclude template="../../common/get_opportunity_type.cfm">
						<cfinclude template="../../sales/display/dsp_sample_request.cfm">
				</div>
				<div class="col col-2 col-xs-2">
					<cfinclude template="../../objects/display/asset_image.cfm">
				</div>
			</cf_box>
		</div>
<cfform name="measurement" id="measurement" method="post">
   
    <cfinput type="hidden" name="req_id" value="#attributes.req_id#">
    <cfinput type="hidden" name="req_no" value="#attributes.req_no#">
    <cfinput type="hidden" name="order_no" value="#attributes.order_no#">
	<cfinput type="hidden" name="order_id" value="#attributes.order_id_#">
    <cfinput type="hidden" name="order_amount" value="#attributes.order_amount_#">
    <cfinput type="hidden" name="marj" value="#attributes.marj_#">
    <cfinput type="hidden" name="page_type" id="page_type" value="#predefined_list.is_send#">
    <cfinput type="hidden" name="main_operation_id" id="main_operation_id" value="#predefined_list.MAIN_OPERATION_ID#">
	
	
	
    <div class="row">
        <div class="col col-12 uniqueRow border border-success">
            <div class="row formContent">
                <div class="row " type="row">
				
                    <!--- col 1 --->
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12 "  type="column" index="1" sort="true">
                        <div class="form-group" id="item-stations">
                            <div class="col col-xs-12">
                                <h4>Tanımlı Process Akışları</h4>
                                <ul id="predefined_list" class="ltList">
                                    <cfoutput query="predefined_list">
                                    <li><a href="javascript:void(0);" onclick="setlist(#MAIN_OPERATION_ID#, '#ORDER_NUMBER# #REQ_NO#')">#ORDER_NUMBER# #REQ_NO#</a></li>
                                    </cfoutput>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <!--- col 2 --->
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12 bg-primary" type="column" index="2" sort="true">
                        <div class="form-group" id="item-processlist">
                            <div class="col col-8 col-xs-12">
                                <h4>Tüm Operasyonlar</h4>
                                <ul id="op_list" class="ltList">
                                    <cfoutput query="op_list">
                                    <li data-operation_type_id="#OPERATION_TYPE_ID#">#OPERATION_TYPE#</li>
                                    </cfoutput>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <!--- col 3 ---> <!---operation_process.get_predefined_rows( dsn3 )>--->
                    <cfset predefined_list_as = operation_process.get_predefineds(attributes.req_id,attributes.order_id_)>
                    <cfset predefined_row_list_as = operation_process.get_predefined_rows( dsn3, iif( predefined_list_as.recordcount gt 0, de( predefined_list_as.MAIN_OPERATION_ID ), de( 0 ) ) )>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12 bg-primary" type="column" index="3" sort="true">
                        <div class="form-group" id="item-yapilacak">
                            <div class="col col-xs-12">
                                <h4>İşlem Yapılacak Operasyonlar <a href="javascript:void(0);" onclick="saveListAs()"><i class="fa fa-save"></i></a></h4>
                                <ul id="proc_target" class="ltList" style="padding-bottom: 60px;">
                                    <cfoutput query="predefined_row_list_as">
                                        <li data-operation_type_id="#OPERATION_TYPE_ID#">#OPERATION_TYPE# <cfif predefined_list.is_send neq 1><a href="javascript:void(0)" onclick="$(this).parent().remove()" class="removeme-list"><i class="fa fa-remove"></i></cfif></a></li>
                                    </cfoutput>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row" type="row">
                    <div class="col col-12" style="text-align:right;">
                        <input type="hidden" name="proclist" id="proclist">
                    <cfif predefined_list.is_send neq 1>
                        <!---<cf_workcube_buttons is_upd='0' type_format="1" add_function="kontrol(0)">--->
                        <cfif len(predefined_list.main_operation_id)>
                            <a class="btn btn-danger" onclick="kontrol(-1);">Sil</a>
                        </cfif>
                        <a class="btn btn-primary" onclick="kontrol(1);">Operasyon Dağıt</a>
                    <cfelseif predefined_list.is_send eq 1 and predefined_list.is_order eq 0>
                        <a class="btn btn-danger" onclick="kontrol(-1);">Sil</a>
                        <a class="btn btn-success" onclick="kontrol(1);">Güncelle</a>
                    <cfelseif predefined_list.is_send eq 1 and predefined_list.is_order gt 0>
                        <div class="col col-10" style="text-align:right;">
                        </div>
                         <div class="col col-2" style="text-align:right;">
                                <div class="alert alert-warning">Operasyon Dağıtımı Yapılmıştır...</div>
                          </div> 
                    </cfif>

                    </div>
                </div>
            </div>
        </div>
    </div>

</cfform>
<style>
    .hidden-remove i {
        display: none !important;
    }
    .ltList i {
        display: inline-block;
        float: right;
    }
    #item-yapilacak .removeme-list {
        float: right;
        display: block;
    }
    #item-processlist .removeme-list {
        display: none;
    }
    </style>
<script type="text/javascript" src="/WBP/Fashion/files/js/Sortable.min.js"></script>
<script type="text/javascript">
<cfsavecontent variable="predefined_elements"><cfoutput query="predefined_row_list">{ rowid: #P_OPERATION_ID#, id: #MAIN_OPERATION_ID#, operation_type_id: #operation_type_id#, operation_type: '#operation_type#' },</cfoutput></cfsavecontent>

window.current_list_name = "";

var predefined_row_list = [ <cfoutput><cfif len(predefined_elements)>#mid(predefined_elements, 1, len(predefined_elements)-1)#</cfif></cfoutput> ];

$(document).ready(function() {
    Sortable.create( document.getElementById("op_list"), { sort: false, group: { name: 'process', pull: 'clone', put: false }, animation: 150 } );
    Sortable.create( document.getElementById("proc_target"), { sort: true, group: { name: 'process', pull: false, put: true }, animation: 150, onAdd: doAdd  } );
});
function doAdd(evt) { 
    if ( $(evt.target).find( '[data-operation_type_id="' + $(evt.item).data("operation_type_id") + '"]' ).length > 1 ) {
        $(evt.item).remove();
    }
}
function saveListAs() {

    window.current_list_name = prompt( "Liste adı girin", window.current_list_name );

    if ( current_list_name == null ) return;

    $.ajax({
        url: "<cfoutput>#request.self#?#cgi.QUERY_STRING#</cfoutput>&mode=save_list&isAjax=1",
        method: "POST",
        data: { listname: window.current_list_name, listitems: $("#proc_target li").map( function() {
            return $(this).data('operation_type_id');
        }).get().join(',') }
    }).done( function( data ) {
        var result = JSON.parse( data );
        if ( result.status ) {
            predefined_row_list = result.predefined_arr;
            $("#predefined_list").html( result.predefined );
        } else {
            alert( "Bir hata oluştu!" );
        }
    } );

}

function setlist( id, title ) {

    window.current_list_name = title;

    var datahtml = predefined_row_list.filter( function( elm ) {
        return elm.id == id;
    }).map( function( elm ) {
        return '<li data-operation_type_id="' + elm.operation_type_id + '"><cfif predefined_list.is_send neq 1><a href="javascript:void(0)" onclick="$(this).parent().remove()" class="removeme-list"><i class="fa fa-remove"></i></cfif></a>' + elm.operation_type + '</li>';
    }).join("");

    $("#proc_target").html( datahtml );

}

function kontrol(tip) {

    var list = $("#proc_target li").map( function() {
            return $(this).data('operation_type_id');
        }).get().join(',');

    $("#proclist").val( 
        list
    );
    if($("#proclist").val()=='')
    {
        alert('İşlem Yapılacak Operasyon Tanımlayınız!');
        return false;
    }
    $("#page_type").val(tip);
   if(tip==1)
    {
        $('#measurement').attr('action', '<cfoutput>#request.self#</cfoutput>?fuseaction=textile.tracking&event=measurementQuery');
        $('#measurement').submit();
    }
    if(tip==-1)
    {
        if ( confirm( "Dağıtımı Yapılmış Operasyonlar Silinecek Emin misiniz?" ) ) {
        $('#measurement').attr('action', '<cfoutput>#request.self#</cfoutput>?fuseaction=textile.tracking&event=measurementDel&is_delete');
        $('#measurement').submit();
        }
    }
    if(tip==0)
    {
        $('#measurement').attr('action', '<cfoutput>#request.self#</cfoutput>?fuseaction=textile.tracking&event=measurement');
        $('#measurement').submit();
    }

    return true;
}
</script>