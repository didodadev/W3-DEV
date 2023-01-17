
<cfobject name="station_process" component="addons.n1-soft.textile.cfc.station_process">

<cfif cgi.REQUEST_METHOD eq "POST" and isDefined( "attributes.mode" ) and attributes.mode eq "save_list">
    <cfset predefined_list = station_process.get_predefined_byname( attributes.listname )>
    <cfset predefined_current_id = 0>
    <cfif predefined_list.recordcount>
        <cfset predefined_current_id = predefined_list['PREDEFINED_ID'][1]>
        <cfset station_process.clear_predefined_rows( predefined_current_id )>
        <cfif isDefined( "attributes.op" ) and attributes.op eq "rm">
            <cfset station_process.delete_predefined( predefined_current_id )>
        </cfif>
    <cfelse>
        <cfif not ( isDefined( "attributes.op" ) and attributes.op eq "rm" )>
            <cfset predefined_current_id = station_process.insert_predefined( attributes.listname, 0 )>
        </cfif>
    </cfif>
    <cfif not ( isDefined( "attributes.op" ) and attributes.op eq "rm" )>
        <cfloop index="item" list="#attributes.listitems#">
            <cfset station_process.insert_predefined_row( predefined_current_id, item )>
        </cfloop>
    </cfif>
    
    <cfset GetPageContext().getCFOutput().clear()>
    <cfset predefined_list = station_process.get_predefineds(0)>
    <cfset predefined_row_list = station_process.get_predefined_rows( dsn3 )>
    <cfsavecontent variable="predefined_elements"><cfoutput query="predefined_row_list">{ "rowid": #PREDEFINED_ROW_ID#, "id": #PREDEFINED_ID#, "stationid": #STATION_ID#, "station": "#OPERATION_TYPE#" },</cfoutput></cfsavecontent>
    {
        "status": true,
        "predefined": "<cfoutput query="predefined_list"><li><a href=\"javascript:void(0);\" style=\"width:80%; display:inline-block;\" onclick=\"setlist(#PREDEFINED_ID#, '#PREDEFINED_TITLE#')\">#PREDEFINED_TITLE#</a><a href=\"javascript:void(0)\" style=\"width:15%; display:inline-block;\" onclick=\"removeList('#PREDEFINED_TITLE#')\"><i class=\"fa fa-remove\"></i></a></li></cfoutput>",
        "predefined_arr": [ <cfoutput><cfif len(predefined_elements)>#mid(predefined_elements, 1, len(predefined_elements)-1)#</cfif></cfoutput> ]
    }
    <cfabort>
</cfif>

<cfset CreateCompenent = CreateObject("component","AddOns.N1-Soft.textile.cfc.get_req_supplier_rival")>
<cfset get_operation=CreateCompenent.getOperation()>

<cfset predefined_list = station_process.get_predefineds(0)>
<cfset predefined_row_list = station_process.get_predefined_rows( dsn3 )>
<cfset station_list = station_process.get_stations( dsn3 )>

<cfset pageHead = "İş Akış Process">
<cf_catalystHeader>
<cfform name="measurement" method="post">
    <cfinput type="hidden" name="req_id" value="#attributes.req_id#">

    <div class="row">
        <div class="col col-12 uniqueRow">
            <div class="row formContent">
                <div class="row" type="row">
                    <!--- col 1 --->
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-stations">
                            <div class="col col-8 col-xs-12">
                                <h5>Tanımlı Process Akışları</h5>
                                <ul id="predefined_list" class="ltList">
                                    <cfoutput query="predefined_list">
                                    <li><a href="javascript:void(0);" style="width:80%; display:inline-block;" onclick="setlist(#PREDEFINED_ID#, '#PREDEFINED_TITLE#')">#PREDEFINED_TITLE#</a><a href="javascript:void(0)" style="width:15%; display:inline-block;" onclick="removeList('#PREDEFINED_TITLE#')"><i class="fa fa-remove"></i></a></li>
                                    </cfoutput>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <!--- col 2 --->
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-processlist">
                            <div class="col col-8 col-xs-12">
                                <h5>Kayitli Processler</h5>
                                <ul id="station_list" class="ltList">
                                    <cfoutput query="get_operation">
                                    <li data-stationid="#operation_type_id#">#OPERATION_TYPE# <a href="javascript:void(0)" onclick="$(this).parent().remove()" class="removeme-list"><i class="fa fa-remove"></i></a></li>
                                    </cfoutput>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <!--- col 3 --->
                    <cfset predefined_list_as = station_process.get_predefineds(attributes.req_id)>
                    <cfset predefined_row_list_as = station_process.get_predefined_rows( dsn3, iif( predefined_list_as.recordcount gt 0, de( predefined_list_as.PREDEFINED_ID ), de( 0 ) ) )>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group" id="item-yapilacak">
                            <div class="col col-8 col-xs-12">
                                <h5>Yapilacaklar <a href="javascript:void(0);" onclick="saveListAs()"><i class="fa fa-save"></i></a></h5>
                                <ul id="proc_target" class="ltList" style="padding-bottom: 60px;">
                                <cfoutput query="predefined_row_list_as">
                                    <li data-stationid="#STATION_ID#">#OPERATION_TYPE# <a href="javascript:void(0)" onclick="$(this).parent().remove()" class="removeme-list"><i class="fa fa-remove"></i></a></li>
                                </cfoutput>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row" type="row">
                    <div class="col col-12">
                        <input type="hidden" name="proclist" id="proclist">
                        <cf_workcube_buttons is_upd='0' type_format="1" add_function="kontrol()">
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
<script type="text/javascript" src="/AddOns/N1-Soft/textile/js/Sortable.min.js"></script>
<script type="text/javascript">
<cfsavecontent variable="predefined_elements"><cfoutput query="predefined_row_list">{ rowid: #PREDEFINED_ROW_ID#, id: #PREDEFINED_ID#, stationid: #STATION_ID#, station: '#OPERATION_TYPE#' },</cfoutput></cfsavecontent>

window.current_list_name = "";

var predefined_row_list = [ <cfoutput><cfif len(predefined_elements)>#mid(predefined_elements, 1, len(predefined_elements)-1)#</cfif></cfoutput> ];

$(document).ready(function() {
    Sortable.create( document.getElementById("station_list"), { sort: false, group: { name: 'process', pull: 'clone', put: false }, animation: 150 } );
    Sortable.create( document.getElementById("proc_target"), { sort: true, group: { name: 'process', pull: false, put: true }, animation: 150, onAdd: doAdd } );
});

function doAdd(evt) { 
    if ( $(evt.target).find( '[data-stationid="' + $(evt.item).data("stationid") + '"]' ).length > 1 ) {
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
            return $(this).data('stationid');
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

function removeList( name ) {
    if ( confirm( "Emin misiniz?" ) ) {
        $.ajax({
            url: "<cfoutput>#request.self#?#cgi.QUERY_STRING#</cfoutput>&mode=save_list&op=rm&isAjax=1",
            method: "POST",
            data: { listname: name }
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
}

function setlist( id, title ) {

    window.current_list_name = title;

    var datahtml = predefined_row_list.filter( function( elm ) {
        return elm.id == id;
    }).map( function( elm ) {
        return '<li data-stationid="' + elm.stationid + '">' + elm.station + ' <a href="javascript:void(0)" onclick="$(this).parent().remove()" class="removeme-list"><i class="fa fa-remove"></i></a></li>';
    }).join("");

    $("#proc_target").html( datahtml );

}

function kontrol() {

    var list = $("#proc_target li").map( function() {
            return $(this).data('stationid');
        }).get().join(',');

    $("#proclist").val( 
        list
    );

    return true;
}
</script>