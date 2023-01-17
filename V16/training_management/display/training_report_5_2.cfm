

<script src="JS/Chart.min.js"></script>
<table cellpadding="0" cellspacing="0" style="height:290mm;width:187mm;" align="center" border="0" bordercolor="#CCCCCC">
	<tr>
	<td align="center"><cfinclude template="../../objects/display/view_company_logo.cfm"></td>
	</tr>
<tr>
<td valign="top" height="100%">
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <cfif isdefined("attributes.kapak_bas")>
    <tr>
	   <td class="headbold" height="35" align="center"><font color="##CC0099"><cfoutput>#attributes.kapak_bas#</cfoutput></font></td>
	</tr>
  <cfelse>
   <tr>
    <td class="headbold" height="35" align="center"><font color="#CC0000"><cf_get_lang no='309.On Test Son Test Sonuçları'></font></td>
   </tr>
  </cfif>
  
</table>
<table>
   <cfloop list="#attributes.class_id_list#" index="i">
	  <cfset attributes.class_id= i>
     <cfquery name="get_trainings" datasource="#DSN#">
	   SELECT
		 AVG(FINALTEST_POINT) AS AVG_FINAL,
		 AVG(PRETEST_POINT) AS AVG_PRE
	   FROM
		 TRAINING_CLASS_RESULTS
	   WHERE
		  CLASS_ID=#attributes.CLASS_ID#
     </cfquery> 
    <cfif LEN(get_trainings.AVG_FINAL)>
	  <cfset thefinal= get_trainings.AVG_FINAL>
    <cfelse>
	  <cfset thefinal= 0>
   </cfif>
    <cfif LEN(get_trainings.AVG_PRE)>
	  <cfset on_test= get_trainings.AVG_PRE>
   <cfelse>
	  <cfset on_test= 0>
   </cfif>
	  
	<tr>
		<td bgcolor="FFFFFF">
		<canvas id="ProjeChart<cfoutput>#i#</cfoutput>" style="float:left;max-height:450px;max-width:350px;"></canvas>

		<script>
			var ctx = document.getElementById('ProjeChart<cfoutput>#i#</cfoutput>');
				var myChart = new Chart(ctx, {
					type: 'pie',
					data: {
						labels: ["Ön Test","Final Test"],
						datasets: [{
							label: "Ön Test",
							backgroundColor: ['rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)'],
							data: [<cfoutput>"#on_test#","#thefinal#"</cfoutput>],
						}]
					},
					options: {}
			});
		</script>
		<!--- <CFCHART show3d="yes" showlegend="yes" font="ARIAL" format="jpg">
			<CFCHARTSERIES type="#attributes.chart_type#" paintstyle="light">
				<CFCHARTDATA item="Ön Test" value="#on_test#">
				<CFCHARTDATA item="Final Test" value="#thefinal#">					
			</CFCHARTSERIES>
		</CFCHART>  --->
		</td>
	</tr>
 </cfloop>
</table>
		</td>
	</tr>
		<tr>
	<td align="center"><cfinclude template="../../objects/display/view_company_info.cfm"></td>
	</tr>
</table>
