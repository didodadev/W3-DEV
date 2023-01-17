<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="Yes">
<cfparam name="attributes.width" default="">
<cfparam name="attributes.name" default="">
<cfparam name="attributes.value" default="">
<script type="text/javascript" src="JS/temp/colorpicker/jscolor.js"></script>
<cfoutput>
	<input type="text" name="#attributes.name#" id="#attributes.name#" value="#attributes.value#" maxlength="6" style="width:#attributes.width#px;" class="colorpicker" />
</cfoutput>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">
