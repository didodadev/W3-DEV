<cfparam name="attributes.req_id" default="">
<cfparam name="attributes.project_id" default="">

<cfobject name="station_process" component="WBP.Fashion.files.cfc.station_process">
<cfset station_list = station_process.get_stations()>
<cfset processcat_list = station_process.get_process_cat()>
<cfset process_list = station_process.get_process()>

<cf_catalystHeader>
<cfform name="add_stretching_test" method="post">
    <cfinput type="hidden" name="opportunity_id" value="#attributes.opp_id#">
    <cfinput type="hidden" name="project_id" value="#attributes.project_id#">

    <div class="row">
        <div class="col col-12 uniqueRow">
            <div class="row formContent">
                <div class="row" type="row">
                    <!--- col 1 --->
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-stations">
                            <div class="col col-xs-12">
                                <h5>Istasyonlar</h5>
                                <ul id="station_list" class="ltList">
                                    <cfoutput query="station_list">
                                    <li><label><input type="radio" name="station" value="#STATION_ID#">#STATION_ID#</label></li>
                                    </cfoutput>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <!--- col 2 --->
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-processcat">
                            <div class="col col-xs-12">
                                <h5>Kayitli Processler</h5>
                                <ul id="proc_cat" class="ltList">
                                    <cfoutput query="processcat_list">
                                    <li data-station="#STATION_ID#"><label><input type="radio" name="process_cat" value="#PROCESS_CAT#">#PROCESS_CAT#</label></li>
                                    </cfoutput>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <!--- col 3 --->
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group" id="item-processlist">
                            <div class="col col-8 col-xs-12">
                                <h5>Kayitli Processler</h5>
                                <ul id="proc_source" class="ltList hidden-remove">
                                    <cfoutput query="process_list">
                                    <li data-processcat="#PROCESS_CAT#">#PROCESS_NAME# <i class="fa fa-close" onclick="$(this).parent().remove()"></i></li>
                                    </cfoutput>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <!--- col 4 --->
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                        <div class="form-group" id="item-">
                            <div class="col col-xs-12">
                                <h5>Yapilacaklar</h5>
                                <ul id="proc_target" class="ltList" style="min-height: 30px;">
                                </ul>
                                <div><input type="text" onkeydown="proc_keydown(event, this)"></div>
                            </div>
                        </div>
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
</style>
<script type="text/javascript" src="/WBP/Fashion/files/js/Sortable.min.js"></script>
<script type="text/javascript">
function proc_keydown( event, item ) {
    if ( event.key == "Enter" ) {
        event.preventDefault();
        $( "#proc_target" ).append( "<li>" + item.value.toUpperCase() + ' <i class="fa fa-close" onclick="$(this).parent().remove()"></i></li>' );
        item.value = "";
    }
}
function station_change() {
    $( '#proc_cat li' ).each( function () {
        $(this).toggle( $('#station_list input[name="station"][value="'+ $(this).data('station') +'"]').is(':checked') );
        $(this).find('input[type="radio"]').prop( "checked", false );
    } );
    category_change();
}
function category_change() {
    $( '#proc_source li' ).each( function () {
        $(this).toggle( $('#proc_cat li input[name="process_cat"][value="'+ $(this).data('processcat') +'"]').is(':checked') );
    } );
} 
$(document).ready(function() {
    $( '#station_list input[name="station"]' ).on( 'change', station_change );
    $( '#proc_cat li input[name="process_cat"]' ).on( 'change', category_change );
    station_change();
    Sortable.create( document.getElementById("proc_source"), { sort: false, group: { name: 'process', pull: 'clone', put: false }, animation: 150 } );
    Sortable.create( document.getElementById("proc_target"), { sort: true, group: { name: 'process', pull: false, put: true }, animation: 150 } );
});
</script>