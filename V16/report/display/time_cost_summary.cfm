<cfquery name="GET_MY_WORKS" datasource="#DSN#">
	SELECT 
		PW.WORK_ID,
		PW.WORK_CURRENCY_ID,
		(SELECT SUM((ISNULL(TOTAL_TIME_HOUR,0)*60) + ISNULL(TOTAL_TIME_MINUTE,0)) FROM PRO_WORKS_HISTORY WHERE PW.WORK_ID = PRO_WORKS_HISTORY.WORK_ID GROUP BY WORK_ID)  HARCANAN_DAKIKA 
	FROM 
		PRO_WORKS PW
	WHERE  
		<cfif isdefined('attributes.type') and attributes.type eq 1>
			PW.PROJECT_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND 
		</cfif>
		PW.WORK_STATUS = 1	
	ORDER BY 
		HARCANAN_DAKIKA DESC
</cfquery>

<div class="col col-12 col-xs-12" style="margin-top:2%;"></div>

<div class="col col-12 col-xs-12">
				<cfquery name="GET_WORK" dbtype="query">
					SELECT 
						COUNT(WORK_ID) WORK_COUNT 
					FROM 
						GET_MY_WORKS 
					WHERE 
						HARCANAN_DAKIKA <= 60 
				</cfquery>
				<cfif get_work.recordcount>
					<cfset item1="<1 saat">
					<cfset value1="#get_work.work_count#">
				<cfelse>
					<cfset item1="<1 saat">
					<cfset value1="0">
				</cfif>
				<cfquery name="GET_WORK" dbtype="query">
					SELECT 
						COUNT(WORK_ID) WORK_COUNT 
					FROM 
						GET_MY_WORKS 
					WHERE 
						HARCANAN_DAKIKA > 60 AND 
						HARCANAN_DAKIKA <= 120 
				</cfquery>
				<cfif get_work.recordcount>
					<cfset item2="1 saat<x<2 saat">
					<cfset value2="#get_work.work_count#">
				<cfelse>
					<cfset item2="1 saat<x<2 saat">
					<cfset value2="0">
				</cfif>
				<cfquery name="GET_WORK" dbtype="query">
					SELECT 
						COUNT(WORK_ID) WORK_COUNT 
					FROM 
						GET_MY_WORKS 
					WHERE 
						HARCANAN_DAKIKA > 120 AND 
						HARCANAN_DAKIKA <= 300 
				</cfquery>
				<cfif get_work.recordcount>
					<cfset item3="2 saat<x<5 saat">
					<cfset value3="#get_work.work_count#">
				<cfelse>
					<cfset item3="2 saat<x<5 saat">
					<cfset value3="0">
				</cfif>
				<cfquery name="GET_WORK" dbtype="query">
					SELECT 
						COUNT(WORK_ID) WORK_COUNT 
					FROM 
						GET_MY_WORKS 
					WHERE 
						HARCANAN_DAKIKA > 300 AND 
						HARCANAN_DAKIKA <= 600 
				</cfquery>
				<cfif get_work.recordcount>
					<cfset item4="5 saat<x<10 saat">
					<cfset value4="#get_work.work_count#">	
				<cfelse>
					<cfset item4="5 saat<x<10 saat">
					<cfset value4="0">
				</cfif>
				<cfquery name="GET_WORK" dbtype="query">
					SELECT 
						COUNT(WORK_ID) WORK_COUNT 
					FROM 
						GET_MY_WORKS 
					WHERE 
						HARCANAN_DAKIKA > 600 AND 
						HARCANAN_DAKIKA <= 1440 
				</cfquery>
				<cfif get_work.recordcount>
					<cfset item5="10 saat<x<1 gün">
					<cfset value5="#get_work.work_count#">
				<cfelse>
					<cfset item5="10 saat<x<1 gün">
					<cfset value5="0">
				</cfif>
				<cfquery name="GET_WORK" dbtype="query">
					SELECT 
						COUNT(WORK_ID) WORK_COUNT 
					FROM 
						GET_MY_WORKS 
					WHERE 
						HARCANAN_DAKIKA > 1440 AND 
						HARCANAN_DAKIKA <= 10080 
				</cfquery>
				<cfif get_work.recordcount>
					<cfset item6="1 gün< x < 1 hafta">
					<cfset value6="#get_work.work_count#">
				<cfelse>
					<cfset item6="1 gün<x<1 hafta">
					<cfset value6="0">
				</cfif>

		<cfif attributes.type eq 1>
			<canvas id="myChart6"></canvas>
			<script>
				var ctx = document.getElementById('myChart6');
				var myChart6 = new Chart(ctx, {
					type: 'bar',
					data: {
							labels: [<cfoutput>"#item1#","#item2#","#item3#","#item4#","#item5#","#item6#"</cfoutput>],
							datasets: [{
							label: "<cfoutput><cf_get_lang dictionary_id='48273.Zaman Harcamalarına Göre'></cfoutput>",
							backgroundColor: [<cfloop from="1" to="6" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
							data: [<cfoutput>"#value1#","#value2#","#value3#","#value4#","#value5#","#value6#"</cfoutput>],
								}]
							},
					options: {}
				});
			</script>
		</cfif>  
		<cfif attributes.type eq 2>
			<canvas id="myChart61"></canvas>
			<script>
				var ctx = document.getElementById('myChart61');
				var myChart61 = new Chart(ctx, {
					type: 'bar',
					data: {
							labels: [<cfoutput>"#item1#","#item2#","#item3#","#item4#","#item5#","#item6#"</cfoutput>],
							datasets: [{
							label: "<cfoutput><cf_get_lang dictionary_id='48273.Zaman Harcamalarına Göre'></cfoutput>",
							backgroundColor: [<cfloop from="1" to="6" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
							data: [<cfoutput>"#value1#","#value2#","#value3#","#value4#","#value5#","#value6#"</cfoutput>],
								}]
							},
					options: {}
				});
			</script>
		</cfif>
</div>

