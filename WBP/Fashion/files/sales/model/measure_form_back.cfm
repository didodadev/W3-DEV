<cfscript>

	WriteDump( form );

    maxNr = form["SIZEOFDETAILS"];
    req_id = form["req_id"];
    mh_id = form["measure_header_id"];

    measure = createObject("component", "WBP.Fashion.files.cfc.measure");

    if ( mh_id eq "0" )
    {
        mh_id = measure.insert_measure_header( req_id, form["ERATE"], form["BRATE"] );
    }
    else 
    {
        measure.update_measure_header( mh_id, form["ERATE"], form["BRATE"] );    
    }

    measure.delete_measure_items(mh_id);
    
    for ( i = 1; i <= maxNr; i++ ) {
        if (! isDefined( "form.SIZE_" & i ) ) continue;

        measure.insert_measure_items( mh_id, req_id, form["ROW_INDEX_" & i], form["EB_TYPE_" & i], form["MEASURE_POINT_" & i], form["SERIAL_INC_" & i], form["DESC_" & i], form["SIZE_" & i], form["TARGET_" & i], form["YOI_" & i], form["YOG_" & i], form["YOF_" & i], form["UOG_" & i], form["USG_" & i], form["USF_" & i] );
    }
</cfscript>
<script type="text/javascript">
location.href = '<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#&event=measure_form&req_id=#attributes.req_id#&pid=#attributes.pid#&mh_id=#mh_id#</cfoutput>';
</script>