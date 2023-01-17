<cfif isDefined('caller')>
	<cfset getLang = caller.getLang>
</cfif>
<script type="text/javascript">
	<cfoutput>
		var localizationobj = 
		{
			pagergotopagestring : "#getLang('main',169)#", // Sayfa
			pagershowrowsstring : "#getLang('main',1417)#", // Kayıt Sayısı
			pagerrangestring : " / ",
			pagernextbuttonstring : "#getLang('main',1058)#",
			pagerpreviousbuttonstring : "#getLang('main',1059)#",
			sortascendingstring : "A-Z #getLang('main',1512)#",
			sortdescendingstring : "Z-A #getLang('main',1512)#",
			sortremovestring : "#getLang('main',1512)# #getLang('main',51)#",		
			filterclearstring : "#getLang('main',522)#",
			clearstring : "#getLang('main',522)#",
			todaystring : "#getLang('main',530)#",
			decimalseparator : ',',
			thousandsseparator : '.',
            currencysymbol : " ",
			emptydatastring: "#getLang('main',72)#",
			filterstringcomparisonoperators: ['#getLang('main',2602)#', 'not empty', 'contains', 'contains(match case)',
				'does not contain', 'does not contain(match case)', 'starts with', 'starts with(match case)',
				'ends with', 'ends with(match case)', 'equal', 'equal(match case)', 'null', 'not null'],
			filternumericcomparisonoperators: ['=', '<>', '<', '<=', '>', '=>', 'null', 'not null'],
			filterdatecomparisonoperators: ['=', '<>', '<', '<=', '>', '=>', 'null', 'not null'],
			filterbooleancomparisonoperators: ['=', '<>']
		}
		var days = {
			// full day names
			names: ["#getLang('main',192)#", "#getLang('main',192)#", "#getLang('main',193)#", "#getLang('main',194)#", "#getLang('main',195)#", "#getLang('main',196)#", "#getLang('main',197)#"],
			// abbreviated day names
			namesAbbr: ["#getLang('main',1901)#", "#getLang('main',1902)#", "#getLang('main',1903)#", "#getLang('main',1904)#", "#getLang('main',1905)#", "#getLang('main',1906)#", "#getLang('main',1907)#"],
			// shortest day names
			namesShort: ["#getLang('main',1901)#", "#getLang('main',1902)#", "#getLang('main',1903)#", "#getLang('main',1904)#", "#getLang('main',1905)#", "#getLang('main',1906)#", "#getLang('main',1907)#"]
		};
		
		var months = {
			// full month names (13 months for lunar calendards -- 13th month should be "" if not lunar)
			names: ["#getLang('main',180)#", "#getLang('main',181)#", "#getLang('main',182)#", "#getLang('main',183)#", "#getLang('main',184)#", "#getLang('main',185)#", "#getLang('main',186)#", "#getLang('main',187)#", "#getLang('main',188)#", "#getLang('main',189)#", "#getLang('main',190)#", "#getLang('main',191)#", ""],
			// abbreviated month names
			
			namesAbbr: ["#getLang('main',541)#", "#getLang('main',542)#", "#getLang('main',543)#", "#getLang('main',544)#", "#getLang('main',545)#", "#getLang('main',546)#", "#getLang('main',547)#", "#getLang('main',548)#", "#getLang('main',549)#", "#getLang('main',550)#", "#getLang('main',551)#", "#getLang('','Aralık',951)#", ""]
		};
		localizationobj.days = days;
		localizationobj.months = months;
		localizationobj.decimalseparator = ".";
		localizationobj.thousandsseparator = ",";
	</cfoutput>
</script>