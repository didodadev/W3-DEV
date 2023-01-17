<cfscript>
    maxNr = form["SIZEOFDETAILS"];
    oppid = form["req_id"];

    measure = createObject("component", "WBP.Fashion.files.cfc.measure");
    measure.delete_measure_rows(oppid);
    
    for ( i = 1; i <= maxNr; i++ ) {
        if (! isDefined( "form.DETAIL" & i ) ) continue;

        measure.insert_measure_rows( oppid, form["SIZE"&i], form["DETAIL"&i], form["DETAILEN"&i], form["TARGET"&i], form["YOH"&i], form["YOG"&i], form["YOD"&i], form["UOH"&i], form["UOG"&i], form["UOD"&i], form["USH"&i], form["USG"&i], form["USD"&i] );
    }
</cfscript>
<script type="text/javascript">
location.href = '<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#&event=measure_form&req_id=#attributes.req_id#&pid=#attributes.pid#</cfoutput>';
</script>