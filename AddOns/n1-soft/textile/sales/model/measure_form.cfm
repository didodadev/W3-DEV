<cfscript>

    maxNr = form["SIZEOFDETAILS"];
    req_id = form["req_id"];
    mh_id = form["measure_header_id"];

    measure = createObject("component", "addons.n1-soft.textile.cfc.measure");

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

        row_index       = iif( isDefined( 'form.ROW_INDEX_' & i ) and len(form["ROW_INDEX_" & i]) and form["ROW_INDEX_" & i] neq "", 'form.ROW_INDEX_' & i, de("0") );
        eb_type         = iif( isDefined( "form.EB_TYPE_" & i ) and len( form["EB_TYPE_" & i] ) and form["EB_TYPE_" & i] neq "", "form.EB_TYPE_" & i, de("0") );
        measure_point   = iif( isDefined( "form.MEASURE_POINT_" & i ) and len( form["MEASURE_POINT_" & i] ) and form["MEASURE_POINT_" & i] neq "", "form.MEASURE_POINT_" & i, de("0") );
        serial_inc      = iif( isDefined( "form.SERIAL_INC_" & i ) and len( form["SERIAL_INC_" & i] ) and form["SERIAL_INC_" & i] neq "", "form.SERIAL_INC_" & i, de("0") );
        desc            = iif( isDefined( "form.DESC_" & i ), "form.DESC_" & i, de("") );
        boy             = iif( isDefined( "form.BOY_" & i ), "form.BOY_" & i, de("") );
        size            = iif( isDefined( "form.SIZE_" & i ), "form.SIZE_" & i, de("") );
        target          = iif( isDefined( "form.TARGET_" & i ) and len( form["TARGET_" & i] ) and form["TARGET_" & i] neq "", "form.TARGET_" & i, de("0") );
        yoi             = iif( isDefined( "form.YOI_" & i ) and len( form["YOI_" & i] ) and form["YOI_" & i] neq "", "form.YOI_" & i, de("0") );
        yog             = iif( isDefined( "form.YOG_" & i ) and len( form["YOG_" & i] ) and form["YOG_" & i] neq "", "form.YOG_" & i, de("0") );
        yof             = iif( isDefined( "form.YOF_" & i ) and len( form["YOF_" & i] ) and form["YOF_" & i] neq "", "form.YOF_" & i, de("0") );
        uog             = iif( isDefined( "form.UOG_" & i ) and len( form["UOG_" & i] ) and form["UOG_" & i] neq "", "form.UOG_" & i, de("0") );
        usg             = iif( isDefined( "form.USG_" & i ) and len( form["USG_" & i] ) and form["USG_" & i] neq "", "form.USG_" & i, de("0") );
        usf             = iif( isDefined( "form.USF_" & i ) and len( form["USF_" & i] ) and form["USF_" & i] neq "", "form.USF_" & i, de("0") );


        measure.insert_measure_items( mh_id, req_id, row_index, eb_type, measure_point, serial_inc, desc, boy, size, target, yoi, yog, yof, uog, usg, usf );
    }
</cfscript>
<script type="text/javascript">
location.href = '<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#&event=measure_form&req_id=#attributes.req_id#&pid=#attributes.pid#&mh_id=#mh_id#</cfoutput>';
</script>