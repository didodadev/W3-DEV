<cfscript>
		get_district_county_action = createObject("component", "V16.settings.cfc.setupDistrict");
		get_district_county_action.dsn = dsn;
</cfscript>
<cfif isdefined("attributes.old_ims_code") and isdefined("attributes.ims_code")>
	<cfif len(attributes.old_ims_code) and  len(attributes.ims_code) and attributes.old_ims_code neq attributes.ims_code>
    	<cfscript>
				UPD_IMS_CODE = get_district_county_action.UPD_IMS_CODE_FNC
				(ims_code_id :  '#iif(isdefined("attributes.ims_code_id"),"attributes.ims_code_id",DE(""))#');
		</cfscript>
    <cfelseif not len(attributes.old_ims_code) and len(attributes.ims_code)>
			<cfscript>
                INS_IMS_CODE = get_district_county_action.INS_IMS_CODE_FNC
                (
					ims_code :  '#iif(isdefined("attributes.ims_code"),"attributes.ims_code",DE(""))#',
					district_name :  '#iif(isdefined("attributes.district_name"),"attributes.district_name",DE(""))#'
				);
				GET_IMS_CODE = get_district_county_action.GET_IMS_CODE_FNC
				(
					ims_code :  '#iif(isdefined("attributes.ims_code"),"attributes.ims_code",DE(""))#',
					district_name :  '#iif(isdefined("attributes.district_name"),"attributes.district_name",DE(""))#'
				);
			</cfscript>
        <cfset attributes.ims_code_id = #get_ims_code.ims_code_id#>
        <cfset attributes.ims_code = #attributes.ims_code#>
	</cfif>
</cfif>
<cfscript>
	add_ins = get_district_county_action.add_ins_fnc
	(
		ims_code :  '#iif(isdefined("attributes.ims_code"),"attributes.ims_code",DE(""))#',
		district_name :  '#iif(isdefined("attributes.district_name"),"attributes.district_name",DE(""))#',
		county_id :  '#iif(isdefined("attributes.county_id"),"attributes.county_id",DE(""))#',
		post_code :  '#iif(isdefined("attributes.post_code"),"attributes.post_code",DE(""))#',
		ims_code_id : '#iif(isdefined("attributes.ims_code_id"),"attributes.ims_code_id",DE(""))#',
		part_name : '#iif(isdefined("attributes.part_name"),"attributes.part_name",DE(""))#'
	);
</cfscript>
<script type="text/javascript">
	location.href = document.referrer;
</script>
