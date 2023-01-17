<cfparam name="attributes.order_id" default="">
<cfparam name="attributes.req_id" default="">
<cfparam name="attributes.st_id" default="">
<cfparam name="attributes.stretching_test_id" default="#attributes.st_id#">
<cfparam name="attributes.required_fabric_meter" default="">
<cfobject name="stretching_test" component="WBP.Fashion.files.cfc.stretching_test">

<cfset attributes.actionid = ''>
<!--- order and req find --->
<cfif len(attributes.order_id)>

	<cfquery name="query_reqid" datasource="#dsn3#">
		select TOP 1 RELATED_ACTION_ID from ORDER_ROW WHERE RELATED_ACTION_TABLE='TEXTILE_SAMPLE_REQUEST' AND RELATED_ACTION_ID>0 AND ORDER_ID=#attributes.order_id#
	</cfquery>

	<cfif query_reqid.recordCount gt 0>
		<cfset attributes.req_id = query_reqid.RELATED_ACTION_ID>
	</cfif>
</cfif>


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

	stretching_test.update_stretching_test(
		attributes.stretching_test_id
		,attributes.process_stage
		,attributes.test_date
		,attributes.project_id
		,attributes.req_id
		,attributes.order_id
		,attributes.waybill
		,attributes.washing_id
		,attributes.production_orderid
		,len(attributes.required_fabric_meter) ? replace(attributes.required_fabric_meter, ",",".") : ''
		,attributes.fabric_arrival_date
		,attributes.notes
		,attributes.emp_id
		,datestartfull
		,datefinishfull
		);

	stretching_test.delete_stretching_test_rows(attributes.stretching_test_id);
</cfscript>
		
<cfloop from="0" to="#attributes.row_count-1#" index="i">
	
	<cfscript>
		rollnr = attributes["rollnr"&i];
		metering = attributes["metering"&i];
		metering = len(metering) ? replace(metering, ",",".") : "";
		test_metering = attributes['test_metering'&i];
		test_metering = len(test_metering) ? replace(test_metering, ",",".") : "";
		fabric_width = attributes['fabric_width'&i];
		fabric_width = len(fabric_width) ? replace(fabric_width, ",",".") : "";
		height_shrinkage = attributes['height_shrinkage'&i];
		height_shrinkage = len(height_shrinkage) ? replace(height_shrinkage, ",",".") : "";
		width_shrinkage = attributes['width_shrinkage'&i];
		width_shrinkage = len(width_shrinkage) ? replace(width_shrinkage, ",",".") : "";
		smooth = attributes["smooth"&i];
		smooth = len(smooth) ? replace(smooth, ",",".") : "";
		colorlot = attributes["colorlot"&i];
		color = attributes['color'&i];
		descone = attributes["descone"&i];
		desctwo = attributes["desctwo"&i];
		product_id = attributes["product_id"&i];

		addResult=stretching_test.add_stretching_test_rows
		(
			stretching_test_id: attributes.stretching_test_id,
			product_id: product_id,
			roll_id: rollnr,
			roll_meter: metering,
			roll_test_meter: test_metering,
			fabric_width: fabric_width,
			height_shrinkage: height_shrinkage,
			width_shrinkage: width_shrinkage,
			smooth: smooth,
			color_lot: colorlot,
			color_name: color,
			desc_one: descone,
			desc_two: desctwo
		);
	</cfscript>
</cfloop>
<cfset stretching_test.delete_stretching_test_group(attributes.stretching_test_id)>
<cfif isDefined("attributes.colorgroup") and len(attributes.colorgroup)>
<cfloop list="#attributes.colorgroup#" index="color">
	<cfscript>
		colorname = color;
		colorwidth = attributes["colorwidth_"&colorname];
		colorwidth = len(colorwidth) ? replace(colorwidth,",",".") : "";
		colorheight = attributes["colorheight_"&colorname];
		colorheight = len(colorheight) ? replace(colorheight,",",".") : "";
		stretching_test.add_stretching_test_group( attributes.stretching_test_id, colorname, colorwidth, colorheight );
	</cfscript>
</cfloop>
</cfif>
<cf_workcube_process
	is_upd='1' 
	old_process_line='#attributes.old_process_line#'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#'
	record_date='#now()#'>

<script>
	window.location.href= '<cfoutput>#request.self#?fuseaction=textile.stretching_test&event=upd&st_id=#attributes.stretching_test_id#</Cfoutput>';
</script>