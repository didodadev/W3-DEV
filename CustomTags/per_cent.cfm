<!--- 20021005 19:26 
example:
<cf_per_cent start_date = '#tarih1#'  = '#tarih2#' width = '100' color1='' color2=''>
	per_cent 		'optional
	start_date 		'optional
	finish_date 	'optional
	width			'optional
	color1			'optional
	color2			'optional
--->
<cfif isDefined('attributes.width')>
	<cfset width = attributes.width>
<cfelse>
	<cfset width = 245>
</cfif>

<cfif isDefined('attributes.color1')>
	<cfset color1 = attributes.color1>
<cfelse>
	<cfset color1 = '00FF66'>
</cfif>

<cfif isDefined('attributes.color2')>
	<cfset color2 = attributes.color2>
<cfelse>
	<cfset color2 = 'FF0000'>
</cfif>
<cfif isdefined("attributes.start_date")>
	<cfif not attributes.start_date is attributes.finish_date>
		<cfif len(attributes.start_date) lt 11>
			<cf_date tarih = 'attributes.start_date' >
			<cf_date tarih = 'attributes.finish_date' >
		</cfif>
		
		<cfif isDefined ('session.ep.time_zone')>
			<cfset simdi = dateadd ('h',session.ep.time_zone,now())>
		<cfelseif isDefined ('session.pp.time_zone')>
			<cfset simdi = dateadd ('h',session.pp.time_zone,now())>
		<cfelse>
			<cfset simdi = now()>
		</cfif>
		
		<cfset fark3 = datediff('n',attributes.start_date,attributes.finish_date)>
		<cfset toplam = fark3>
		
		<cfset fark6 = datediff('n',attributes.start_date,simdi)>
		<cfset fark = fark6>
		
		<cfset per_cent = Round (evaluate( (fark / toplam) * 100))>
		<cfif per_cent gt 100>
			<cfset per_cent = 100>
		</cfif>
	
		<cfset boyut = evaluate(per_cent * (width/100)) >
		<cfoutput>
			<table width="#width#">
				<tr>
					<cfif per_cent gt 0 and per_cent lt 100>
						<td style="background-color:###color1#" width="#boyut#" height="15">% #per_cent#</td>
						<td style="background-color:###color2#" width="#evaluate(width-boyut)#">% #evaluate(100-per_cent)#</td>
					<cfelseif per_cent gte 100>
						<td style="background-color:###color1#" width="#width#" height="15">%100</td>
					<cfelseif per_cent lte 0>
						<td style="background-color:###color2#" width="#width#" height="15">%100</td>
					</cfif>
				</tr>
			</table>
		</cfoutput>
	</cfif>
<cfelse>
	<cfset per_cent = attributes.per_cent>
	<cfset boyut = evaluate(per_cent * (width/100)) >
	<cfoutput>
		<table width="#width#">
			<tr>
				<cfif per_cent gt 0 and per_cent lt 100>
					<td style="background-color:###color1#" width="#boyut#" height="15">% #per_cent#</td>
					<td style="background-color:###color2#" width="#evaluate(width-boyut)#">% #evaluate(100-per_cent)#</td>
				<cfelseif per_cent eq 100>
					<td style="background-color:###color1#" width="#width#" height="15">%100</td>
				<cfelseif per_cent eq 0>
					<td style="background-color:###color2#" width="#width#" height="15">%0</td>
				<cfelseif per_cent gte 100>
					<td style="background-color:###color2#" width="#width#" height="15">%0</td>
				<cfelseif per_cent lte 0>
					<td style="background-color:###color2#" width="#width#" height="15">%100</td>
				</cfif>
			</tr>
		</table>
	</cfoutput>
</cfif>
