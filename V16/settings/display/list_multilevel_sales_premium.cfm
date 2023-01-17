<cfquery name="GET_MULTI_PREMIUM_LIST" datasource="#dsn3#">
	SELECT 
        MULTILEVEL_PREMIUM_ID, 
        MULTILEVEL_PREMIUM_NAME, 
        START_DATE, 
        FINISH_DATE, 
        MULTILEVEL_PREMIUM_1_RATE, 
        MULTILEVEL_PREMIUM_2_RATE, 
        MULTILEVEL_PREMIUM_3_RATE, 
        MULTILEVEL_PREMIUM_4_RATE, 
        MULTILEVEL_PREMIUM_5_RATE, 
        MULTILEVEL_PREMIUM_6_RATE, 
        MULTILEVEL_PREMIUM_7_RATE, 
        MULTILEVEL_PREMIUM_8_RATE, 
        MULTILEVEL_PREMIUM_9_RATE, 
        MULTILEVEL_PREMIUM_10_RATE, 
        SALES_EMPLOYEE_PREMIUM_RATE, 
        SALES_TEAM_PREMIUM_RATE, 
        SALES_ZONE_PREMIUM_RATE, 
        RECORD_EMP, 
        RECORD_DATE, 
        RECORD_IP, 
        UPDATE_EMP, 
        UPDATE_DATE, 
        UPDATE_IP 
    FROM 
    	MULTILEVEL_SALES_PREMIUM
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent  variable="title"><cf_get_lang_main no='1101.Kademelere Göre Satış Primleri'></cfsavecontent>
	<cf_box title="#title#" uidrop="1" hide_table_column="1" add_href="#request.self#?fuseaction=settings.add_multilevel_sales_premium&event=add">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="100"><cf_get_lang_main no='68.Başlık'></th>
					<th width="90"><cf_get_lang_main no='243.Başlama'></th>
					<th width="90"><cf_get_lang_main no='288.Bitiş'></th>
					<th><cf_get_lang dictionary_id='58710.Kademe'>1 %</th>
					<th><cf_get_lang dictionary_id='58710.Kademe'>2 %</th>
					<th><cf_get_lang dictionary_id='58710.Kademe'>3 %</th>
					<th><cf_get_lang dictionary_id='58710.Kademe'>4 %</th>
					<th><cf_get_lang dictionary_id='58710.Kademe'>5 %</th>
					<th><cf_get_lang dictionary_id='58710.Kademe'>6 %</th>
					<th><cf_get_lang dictionary_id='58710.Kademe'>7 %</th>
					<th><cf_get_lang dictionary_id='58710.Kademe'>8 %</th>
					<th><cf_get_lang dictionary_id='58710.Kademe'>9 %</th>
					<th><cf_get_lang dictionary_id='58710.Kademe'>10 %</th>
					<th><cf_get_lang_main no='164.Çalışan'></th>
					<th><cf_get_lang_main no='1099.Takım'></th>
					<th><cf_get_lang_main no='580.Bölge'></th>
					<th width="20"><a href="<cfoutput>#request.self#?fuseaction=settings.add_multilevel_sales_premium&event=add</cfoutput>"><i class="fa fa-plus"></i></a></th>
				</tr>
			</thead>
			<tbody>
				<cfif GET_MULTI_PREMIUM_LIST.RECORDCOUNT>
					<cfoutput query="GET_MULTI_PREMIUM_LIST">
						<tr class="color-row" height="20">
							<td><a href="#request.self#?fuseaction=settings.add_multilevel_sales_premium&event=upd&premium_id=#MULTILEVEL_PREMIUM_ID#">#MULTILEVEL_PREMIUM_NAME#</a></td>
							<td>#dateformat(GET_MULTI_PREMIUM_LIST.START_DATE,dateformat_style)#</td>
							<td>#dateformat(GET_MULTI_PREMIUM_LIST.FINISH_DATE,dateformat_style)#</td>
							<td>#tlformat(GET_MULTI_PREMIUM_LIST.MULTILEVEL_PREMIUM_1_RATE,2)#</td>
							<td>#tlformat(GET_MULTI_PREMIUM_LIST.MULTILEVEL_PREMIUM_2_RATE,2)#</td>
							<td>#tlformat(GET_MULTI_PREMIUM_LIST.MULTILEVEL_PREMIUM_3_RATE,2)#</td>
							<td>#tlformat(GET_MULTI_PREMIUM_LIST.MULTILEVEL_PREMIUM_4_RATE,2)#</td>
							<td>#tlformat(GET_MULTI_PREMIUM_LIST.MULTILEVEL_PREMIUM_5_RATE,2)#</td>
							<td>#tlformat(GET_MULTI_PREMIUM_LIST.MULTILEVEL_PREMIUM_6_RATE,2)#</td>
							<td>#tlformat(GET_MULTI_PREMIUM_LIST.MULTILEVEL_PREMIUM_7_RATE,2)#</td>
							<td>#tlformat(GET_MULTI_PREMIUM_LIST.MULTILEVEL_PREMIUM_8_RATE,2)#</td>
							<td>#tlformat(GET_MULTI_PREMIUM_LIST.MULTILEVEL_PREMIUM_9_RATE,2)#</td>
							<td>#tlformat(GET_MULTI_PREMIUM_LIST.MULTILEVEL_PREMIUM_10_RATE,2)#</td>
							<td>#tlformat(GET_MULTI_PREMIUM_LIST.SALES_EMPLOYEE_PREMIUM_RATE,2)#</td>
							<td>#tlformat(GET_MULTI_PREMIUM_LIST.SALES_TEAM_PREMIUM_RATE,2)#</td>
							<td>#tlformat(GET_MULTI_PREMIUM_LIST.SALES_ZONE_PREMIUM_RATE,2)#</td>	
							<td><a href="#request.self#?fuseaction=settings.add_multilevel_sales_premium&event=upd&premium_id=#MULTILEVEL_PREMIUM_ID#"><i class="fa fa-pencil"></i></a></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="18"><cf_get_lang_main no='1074.Kayıt Bulunamadı'>!</td>
					</tr>
				</cfif>  
			</tbody>	
		</cf_grid_list>
	</cf_box>
</div>
