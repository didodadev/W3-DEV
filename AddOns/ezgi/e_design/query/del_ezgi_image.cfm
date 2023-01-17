	<cfif attributes.image_type eq "brand"><!--- Parça İse --->
        <cfset table = "EZGI_DESIGN_PIECE_IMAGES">
        <cfset identity_column = "DESIGN_PIECE_ROW_ID">
        <cfset ezgidsn = #dsn3#>
    <cfelseif attributes.image_type eq "product"><!--- Modül İse--->
        <cfset table = "EZGI_DESIGN_MAIN_IMAGES">
        <cfset identity_column = "DESIGN_MAIN_ROW_ID">
        <cfset ezgidsn = #dsn3#>
  	<cfelseif attributes.image_type eq "package"><!--- Paket İse --->
        <cfset table = "EZGI_DESIGN_PACKAGE_IMAGES">
        <cfset identity_column = "DESIGN_PACKAGE_ROW_ID">
        <cfset ezgidsn = #dsn3#>
   	<cfelseif attributes.image_type eq "lift_sub"><!--- Amortisör İse --->
        <cfset table = "EZGI_LIFT_IMAGES">
        <cfset identity_column = "DESIGN_LIFT_TYPE_ID">
        <cfset ezgidsn = #dsn#>
  	<cfelseif attributes.image_type eq "lift_offer"><!--- Amortisör Teklif İse --->
        <cfset table = "EZGI_LIFT_IMAGES">
        <cfset identity_column = "ORDER_ROW_ID">
        <cfset ezgidsn = #dsn#>
    </cfif>
    <cfquery name="get_image" datasource="#ezgidsn#">
    	SELECT
            PATH
    	FROM
        	#table#
      	WHERE
        	#identity_column# = #attributes.image_action_id#	
			<cfif attributes.image_type eq "lift_offer">
                AND EZGI_LIFT_IMAGE_DEFAULT_ID = #attributes.lift_default_id#
            </cfif> 
    </cfquery>
	<cfquery name="DEL_UNIT" datasource="#ezgidsn#">
		DELETE FROM
			#table# 
		WHERE 
			#identity_column# = #attributes.image_action_id#
            <cfif attributes.image_type eq "lift_offer">
                AND EZGI_LIFT_IMAGE_DEFAULT_ID = #attributes.lift_default_id#
            </cfif>
	</cfquery>

	<cffile action="Delete" 
		file="#upload_folder#product#dir_seperator#/#get_image.PATH#">
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
