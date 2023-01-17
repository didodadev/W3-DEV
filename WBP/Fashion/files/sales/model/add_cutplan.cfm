<cfparam name="attributes.cutplan_id" default="">
<cfobject name="cutplan" component="WBP.Fashion.files.cfc.cutplan">

<cfset attributes.actionid = ''>
<cfscript>

    datestartfull = '';
    if (len(attributes.date_start))
    {
        datestartfull = attributes.date_start & " " & attributes.date_start_hour & ":" & attributes.date_start_minute;
    } else if (len(attributes.emp_id)) {
        datestartfull = '#now()#';
    }
    datefinishfull = '';
    if (len(attributes.date_finish)) 
    {
        datefinishfull = attributes.date_finish & " " & attributes.date_finish_hour & ":" & attributes.date_finish_minute;
    }

    cutplan.upd_cutplan( 
        attributes.cutplan_id,
        attributes.company_id,
        attributes.order_id,
        attributes.process_stage,
        attributes.fabric_name,
        len(attributes.plan_unit_meter) ? replace(attributes.plan_unit_meter, ",", ".") : "",
        len(attributes.plan_arrive_meter) ? replace(attributes.plan_arrive_meter, ",", ".") : "",
        len(attributes.plan_meter) ? replace(attributes.plan_meter, ",", ".") : "",
        len(attributes.marker_meter) ? replace(attributes.marker_meter, ",", ".") : "",
        len(attributes.roll_count) ? replace(attributes.roll_count, ",", ".") : "",
        len(attributes.piece_count) ? replace(attributes.piece_count, ",", ".") : "",
        len(attributes.total_piece_count) ? replace(attributes.total_piece_count, ",", ".") : "",
        len(attributes.marker_size) ? replace(attributes.marker_size, ",", ".") : "",
        len(attributes.margin) ? replace(attributes.margin, ",", ".") : "",
        '',
        attributes.plan_date,
        attributes.emp_id,
        datestartfull,
        datefinishfull
    );

</cfscript>

<cfset cutplan.delete_cutplan_rows(attributes.cutplan_id)>
<cfset cutplan.delete_cutplan_size(attributes.cutplan_id)>

<cfloop from="0" to="#attributes.mainlist_count-1#" index="i">

    <cfscript>
        marker_name = attributes["marker_name_"&i];
        marker_output = attributes["marker_output_"&i];
        cutplan_name = attributes["cutplan_name_"&i];
        marker_height = attributes["marker_height_"&i];
        layer_amount = attributes["layer_amount_"&i];
        assortment_size_amount = attributes["assortment_size_amount_"&i];
        net_marker_meter = attributes["net_marker_meter_"&i];
        gross_marker_height = attributes["gross_marker_height_"&i];
        gross_marker_meter = attributes["gross_marker_meter_"&i];
        marker_unit_meter = attributes["marker_unit_meter_"&i];
        productivity = attributes["productivity_"&i];
        after_cut_meter = attributes["after_cut_meter_"&i];
        marker_width = attributes["marker_width_"&i];
        draft_color = attributes["draft_color_"&i];
        draft_width = attributes["draft_width_"&i];
        draft_height = attributes["draft_height_"&i];
        meto_color = attributes["meto_color_"&i];
        cut_amount = attributes["cut_amount_"&i];

        cutplanrowresult = cutplan.add_cutplan_row(
            attributes.cutplan_id,
            marker_name,
            marker_output,
            cutplan_name,
            len(marker_height) ? replace(marker_height, ",",".") : "",
            len(layer_amount) ? replace(layer_amount, ",",".") : "",
            len(assortment_size_amount) ? replace(assortment_size_amount, ",",".") : "",
            len(net_marker_meter) ? replace(net_marker_meter, ",",".") : "",
            len(gross_marker_height) ? replace(gross_marker_height, ",",".") : "",
            len(gross_marker_meter) ? replace(gross_marker_meter, ",",".") : "",
            len(marker_unit_meter) ? replace(marker_unit_meter, ",",".") : "",
            len(productivity) ? replace(productivity, ",",".") : "",
            len(after_cut_meter) ? replace(after_cut_meter, ",",".") : "",
            len(marker_width) ? replace(marker_width, ",",".") : "",
            draft_color,
            len(draft_width) ? replace(draft_width, ",",".") : "",
            len(draft_height) ? replace(draft_height, ",",".") : "",
            meto_color,
            len(cut_amount) ? replace(cut_amount, ",",".") : ""
        );
        cutplan_rowid = cutplanrowresult.generatedkey;
    </cfscript>

    <cfloop list="#attributes.size_list#" item="size">
        <cfloop list="#attributes["size_" & size]#" item="weight">
            <cfscript>
                amount = attributes["size_cut_amount_" & size & "_" & weight & "_" & i];

                cutplan.add_cutplan_size(
                    attributes.cutplan_id,
                    size,
                    weight,
                    amount,
                    cutplan_rowid
                );
            </cfscript>
        </cfloop>
    </cfloop>

</cfloop>
<!---
<cfobject name="cutactual" component="WBP.Fashion.files.cfc.cutactual">
<cfset cutactual.copyFromPlan(attributes.cutplan_id)>
--->
<cf_workcube_process
	is_upd='1' 
	old_process_line='#attributes.old_process_line#'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#'
	record_date='#now()#'>
<script>
	window.location.href= '<cfoutput>#request.self#?fuseaction=textile.cutplan&event=add&id=#attributes.cutplan_id#</cfoutput>';
</script>