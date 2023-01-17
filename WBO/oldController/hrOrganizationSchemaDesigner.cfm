<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<script src="../js/jquery-1_7_1_min.js" type="text/javascript"></script>
	<script type="text/javascript">
	    function getCSSColors()
	    {
			try
			{
				var bg_color = $("#color_list").length != null ? rgbToHex($("#color_list").css("background-color")): "";
				var border_color = $("#color_border").length != null ? rgbToHex($("#color_border").css("background-color")): "";
				var flashObj = document.organization_schema ? document.organization_schema: document.getElementById("organization_schema");
				if (flashObj) flashObj.applyCSS(bg_color, border_color);
			} catch (e) { }
	    }
		
		function rgbToHex(value)
		{
			if (value.search("rgb") == -1)
	            return value;
	        else {
	            value = value.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/);
	            function hex(x) {
	                return ("0" + parseInt(x).toString(16)).slice(-2);
	            }
	            return "#" + hex(value[1]) + hex(value[2]) + hex(value[3]);
	        }
		}
	</script>
</cfif>

<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.organization_schema_designer';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/organization_schema_visual_designer.cfm';
</cfscript>
