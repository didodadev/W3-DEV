<cfobject name="cutstretch" component="WBP.Fashion.files.cfc.cutstretch">
<cfif attributes.cutstretch_id eq "">
    <cfscript>
        result_add_cutstretch = cutstretch.add_cutstretch(attributes.cutactual_id, attributes.project_id, attributes.marker_name, attributes.marker_height, attributes.st_id);
        attributes.cutstretch_id = result_add_cutstretch.generatedkey;
    </cfscript>
</cfif>
<cfset cutstretch.delete_cutstretch_row( attributes.cutstretch_id )>
<cfif isDefined("attributes.rowcount") and len(attributes.rowcount)>
    <cfloop from="#0#" to="#attributes.rowcount-1#" index="i">
        <cfscript>

            rollno = attributes["rollno_"&i];
            color = attributes["color_"&i];
            marker = attributes["marker_"&i];
            stretch_amount1 = attributes["stretch_amount1_"&i];
            stretch_amount2 = attributes["stretch_amount2_"&i];
            undemand_spill_meter = attributes["undemand_spill_meter_"&i];
            flaw_meter = attributes["flaw_meter_"&i];
            additional_meter = attributes["additional_meter_"&i];
            classification_meter = attributes["classification_meter_"&i];
            missing_roll = attributes["missing_roll_"&i];
            waybill_meter = attributes["waybill_meter_"&i];
            stretch_meter = attributes["stretch_meter_"&i];
            
            flaw_meter = len(flaw_meter) ? replace(flaw_meter, ",",".") : "";
            additional_meter = len(additional_meter) ? replace(additional_meter, ",",".") : "";
            classification_meter = len(classification_meter) ? replace(classification_meter, ",",".") : "";
            waybill_meter = len(waybill_meter) ? replace(waybill_meter, ",",".") : "";
            stretch_meter = len(stretch_meter) ? replace(stretch_meter, ",",".") : "";

            cutstretch.add_cutstretch_row( 
                attributes.cutstretch_id,
                rollno,
                color,
                marker,
                stretch_amount1,
                stretch_amount2,
                undemand_spill_meter,
                flaw_meter,
                additional_meter,
                classification_meter,
                missing_roll,
                waybill_meter,
                stretch_meter
            );

        </cfscript>
    </cfloop>
</cfif>

<script>
	window.location.href= '<cfoutput>#request.self#?fuseaction=textile.cutactual&event=cutstretch&project_id=#attributes.project_id#&project_head=#attributes.project_head#&cutactual_id=#attributes.cutactual_id#&st_id=#attributes.st_id#&marker_name=#attributes.marker_name#&marker_height=#attributes.marker_height#</cfoutput>';
</script>