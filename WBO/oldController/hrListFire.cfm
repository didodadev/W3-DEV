<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfscript>
		bu_ay_basi = CreateDate(year(now()),month(now()),1);
		bu_ay_sonu = DaysInMonth(bu_ay_basi);
	</cfscript>
	<cfparam name="attributes.branch_id" default="">
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.hierarchy" default="">
	<cfparam name="attributes.inout_statue" default="">
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfparam name="attributes.startdate" default="#date_add('m',-1,bu_ay_basi)#">
	<cfparam name="attributes.finishdate" default="#Createdate(year(bu_ay_basi),month(bu_ay_basi),bu_ay_sonu)#">
	<cfscript>
		if (not isdefined("attributes.keyword"))
			arama_yapilmali = 1;
		else
			arama_yapilmali = 0;
		if (arama_yapilmali eq 1)
			get_in_outs.recordcount = 0;
		else
			include "../hr/ehesap/query/get_in_outs.cfm";
		include "../hr/ehesap/query/get_our_comp_and_branchs.cfm";
		attributes.startrow=((attributes.page-1)*attributes.maxrows)+1;
		adres=attributes.fuseaction;
		adres = "#adres#&keyword=#attributes.keyword#";
		adres = "#adres#&hierarchy=#attributes.hierarchy#";
		adres = "#adres#&branch_id=#attributes.branch_id#";
		adres = "#adres#&inout_statue=#attributes.inout_statue#";
		if (isdefined("attributes.startdate") and isdate(attributes.startdate))
			adres = "#adres#&startdate=#dateformat(attributes.startdate,'dd/mm/yyyy')#";
		if (isdefined("attributes.finishdate") and isdate(attributes.finishdate))
			adres = "#adres#&finishdate=#dateformat(attributes.finishdate,'dd/mm/yyyy')#";
	</cfscript>
	<cfparam name="attributes.totalrecords" default='#get_in_outs.recordcount#'>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function() {
			$('#keyword').focus();
		});
	</cfif>
</script>

<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_fire';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/list_fire.cfm';
</cfscript>
