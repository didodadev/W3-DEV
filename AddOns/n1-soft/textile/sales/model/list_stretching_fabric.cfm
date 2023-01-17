<cfscript>

    onlyIds = arrayFilter( listToArray( form.FIELDNAMES ), function(elm) {
        return findNoCase( "FABRIC_ID", elm ) > 0;
    });
    maxNr = arrayReduce(onlyIds, function( result, elm ) {
        result = result?: 0;
        if ( result lt mid( elm, len("FABRIC_ID")+1, len(elm) ) ) {
            result = mid( elm, len("FABRIC_ID")+1, len(elm) );
        }
        return result;
    });

    fabric = createObject("component", "addons.n1-soft.textile.cfc.fabric");

    for ( i = 1; i <= maxNr; i++ ) {
        prm = {};
        if ( isDefined("form.FABRIC_ID" & i) ) {
            prm.fabric_id = form["FABRIC_ID" & i];
        } else {
            continue;
        }
        if ( isDefined("form.HEIGHT_SHRINKAGE" & i) ) {
            prm.height_shrinkage = form["HEIGHT_SHRINKAGE" & i];
        }
        if ( isDefined("form.WIDTH_SHRINGKAGE" & i) ) {
            prm.width_shringkage = form["WIDTH_SHRINGKAGE" & i];
        }
        if ( isDefined("form.SMOOTH" & i) ) {
            prm.smooth = form["SMOOTH" & i];
        }
        if ( isDefined("form.COLOR" & i) ) {
            prm.color = form["COLOR" & i];
        }
        if ( isDefined("form.HEIGHT_COLOR" & i) ) {
            prm.height_color = form["HEIGHT_COLOR" & i];
        }
        if ( isDefined("form.WIDTH_COLOR" & i) ) {
            prm.width_color = form["WIDTH_COLOR" & i];
        }
        if ( isDefined("form.IS_SHRINKAGE_REQUEST" & i) ) {
            prm.is_shrinkage_request = form["IS_SHRINKAGE_REQUEST" & i];
        }
        fabric.update_fabric(argumentCollection=prm);
    }

</cfscript>
<script type="text/javascript">
refresh_box('stretching_test_list','index.cfm?fuseaction=textile.stretching_test&event=list_stretching_fabric&opp_id=&project_id=','0');
</script>