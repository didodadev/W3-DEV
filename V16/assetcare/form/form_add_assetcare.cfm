<cfparam  name="attributes.style" default="1">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfinclude  template="add_assetcare.cfm">
	<cf_box title="#getlang('','Bakım Kayıt',48029)#">
		<cfinclude  template="list_assetcare.cfm">
	</cf_box>
</div>	
<!--- 	<iframe frameborder="0" name="add_form" id="add_form" src="<cfoutput>#request.self#?fuseaction=assetcare.popup_add_assetcare&style=1</cfoutput>&iframe=1" width="100%" height="300"></iframe>
 --->	

<!--- 		<iframe frameborder="0"  name="list_cares" id="list_cares" src="<cfoutput>#request.self#?fuseaction=assetcare.popup_list_assetcare</cfoutput>&iframe=1" width="100%" height="250"></iframe>
 --->
	<!--- <cf_box_elements id="add_assetcare">
		<iframe frameborder="0" name="add_form" id="add_form" src="<cfoutput>#request.self#?fuseaction=assetcare.popup_add_assetcare&style=1</cfoutput>&iframe=1" width="100%" height="300"></iframe>
	</cf_box_elements>
	<cf_grid_list id="add_assetcare_bask">
		<iframe frameborder="0"  name="list_cares" id="list_cares" src="<cfoutput>#request.self#?fuseaction=assetcare.popup_list_assetcare</cfoutput>&iframe=1" width="100%" height="100"></iframe>
	</cf_grid_list> --->


