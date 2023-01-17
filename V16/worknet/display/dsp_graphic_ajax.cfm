
<cfsetting showdebugoutput="no">
<cfset cmp = createObject("component","V16.worknet.query.worknet_member") />
<cfset cmp2 = createObject("component","V16.worknet.query.worknet_demand") />
<cfset cmp3 = createObject("component","V16.worknet.query.worknet_product") />
<cfset get_company = cmp.getCompany() />
<cfset get_demand = cmp2.getDemand() />
<cfset get_product = cmp3.getProduct(is_catalog:0) /> 
<cfset get_catalog = cmp3.getProduct(is_catalog:1) /> 
<cf_ajax_list>
	<tbody>
        <tr class="nohover" height="25"><td class="txtbold"><cf_get_lang_main no="2157.Genel"> <cf_get_lang_main no="344.Durum"></td></tr>
        <tr class="nohover">
            <td> 
			<script src="../../../JS/Chart.min.js"></script>
				<canvas id="myChart" style="float:left;max-height:450px;max-width:450px;"></canvas>
				<script>
                 
					var ctx = document.getElementById('myChart');
						var myChart = new Chart(ctx, {
							type: 'bar',
							data: {
								labels: [<cfoutput>"#getLang('main',246)#","#getLang('worknet',88)#","#getLang('main',245)#","#getLang('worknet',154)#"</cfoutput>],
								datasets: [{
									label: "Genel durum",
									backgroundColor: ['rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)','rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)','rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)','rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',],
									data: [<cfoutput>"#get_company.recordcount#","#get_demand.recordcount#","#get_product.recordcount#","#get_catalog.recordcount#"</cfoutput>],
								}]
							},
							options: {}
					});
				</script>
             
            </td>
        </tr>
    </tbody>
</cf_ajax_list> 
