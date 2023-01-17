<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="Yes">
<cfparam name="attributes.deger_1" default="2">
<cfparam name="attributes.deger_2" default="1">
<cfset a = attributes.deger_1 + attributes.deger_2>
<cfoutput>#attributes.deger_1# + #attributes.deger_2# = #a#</cfoutput>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">



<cf_box title="toplama">
	<cf_sum_tag deger_1="4" deger_2="5">
</cf_box>

