<!----
Semih A. 14.07.2017 ChartJs  CatalystChart 


parametreler

type: pie // bar // line // radar // polarArea // doughnut

query : quer nin 1. sutunu label 2. sutunu data dır

json :  {
            "DATA":[
                ["Lable",Value],
                ["Turbo",178],
                ["Jet Motoru",288],
                ["sss",234]
            ]
        }

color : grafikte her bir name icin renk verilmez ise random gelir.

head : eklenecek !!!

width / height : px cinsinden alir

Ornek Kullanım


<cfquery name="get_work" datasource="#dsn#">
	SELECT
        PROCESS_TYPE_ROWS.STAGE STAGE,
		COUNT(WORK_ID) AS DURUM_SAYI		
	FROM 
		PRO_WORKS,
		PROCESS_TYPE_ROWS
	WHERE
		PROCESS_TYPE_ROWS.PROCESS_ROW_ID = PRO_WORKS.WORK_CURRENCY_ID
		<cfif isdefined('attributes.id') and len(attributes.id)>
			AND PRO_WORKS.PROJECT_ID = #attributes.id#
		</cfif>
	GROUP BY 
		PROCESS_TYPE_ROWS.STAGE
</cfquery>

<cf_catalystChart type="pie" query="#get_work#" height="240">

 ---->


<cfset Randomize(round(rand()*1000000))/>
<cfparam name="attributes.id" default="cc_#round(rand()*10000000)#">
<cfparam name="attributes.type" default="pie">
<cfparam name="attributes.query" default="">
<cfparam name="attributes.colors" default=''>
<cfparam name="attributes.head" default=''>
<cfparam name="attributes.width" default=''>
<cfparam name="attributes.height" default=''>

<div class="catalystChart">
    <canvas id="<cfoutput>#attributes.id#</cfoutput>" width="<cfoutput>#attributes.width#</cfoutput>" height="<cfoutput>#attributes.height#</cfoutput>"></canvas>
</div>
<script>

        function hexToRgb(hex) {
            var bigint = parseInt(hex, 16);
            var r = (bigint >> 16) & 255;
            var g = (bigint >> 8) & 255;
            var b = bigint & 255;	
            return [r,g,b];
        }	

        var colors = <cfif len(attributes.colors) gte 3>JSON.parse(JSON.stringify({"HEXCOLOR":<cfoutput>#attributes.colors#</cfoutput>}));<cfelse>{"HEXCOLOR":[]};</cfif>
       
        var jData = JSON.parse(JSON.stringify(<cfoutput>#Replace(serializeJSON(attributes.query),'//','')#</cfoutput>));
        
        var dataLabels = [];
        var dataVal = []; 
        var bgColor = []; //background
        var bdColor = []; //border
        
        $.each( jData['DATA'], function( index ) {  

            dataLabels.push(this[0]);
            dataVal.push(this[1]); 

            if(colors['HEXCOLOR'][index]){
                var color = hexToRgb(colors['HEXCOLOR'][index]);
            }else{
                var color = [Math.floor((Math.random()*255) + 1),Math.floor((Math.random()*255) + 1),Math.floor((Math.random()*255) + 1)];
            }
           
            bgColor.push('rgba(' + color[0] + ',' + color[1] + ',' + color[2] + ',' + '0.2)');
            bdColor.push('rgba(' + color[0] + ',' + color[1] + ',' + color[2] + ',' + '1)');      
        });

        var ctx = document.getElementById("<cfoutput>#attributes.id#</cfoutput>");
        var myChart = new Chart(ctx, {
            type: '<cfoutput>#attributes.type#</cfoutput>',
            data: {
                labels: dataLabels,
                datasets: [{
                    label            : '<cfoutput>#attributes.head#</cfoutput>',
                    data             : dataVal,
                    backgroundColor  : bgColor,
                    borderColor      : bdColor,
                    borderWidth      : 1
                }]
            }
        });        
    </script>       


