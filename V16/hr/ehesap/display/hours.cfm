<cfinclude template="../query/get_hours_all.cfm"> 
<cfscript>
	function GetDayLangID(id)
	{
		if (not Len(id)) id = 1;
		if (id eq 1) dayLangID = 198;
		else if (id eq 2) dayLangID = 192;
		else if (id eq 3) dayLangID = 193;
		else if (id eq 4) dayLangID = 194;
		else if (id eq 5) dayLangID = 195;
		else if (id eq 6) dayLangID = 196;
		else if (id eq 7) dayLangID = 197;
		return dayLangID;
	}
</cfscript>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="53415.Çalışma Saatleri"></cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr> 
					<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id ='57574.Şirket'></th>
					<th><cf_get_lang dictionary_id ="53870.SGK Aylık Çalışma Saati"></th>
					<th><cf_get_lang dictionary_id ="29516.Haftalık Tatil Günü"></th>
					<th><cf_get_lang dictionary_id ="53930.SGK Mesai Saati"></th>
					<th><cf_get_lang dictionary_id ="53896.Hafta içi Günlük Çalışma Saati"></th>
					<th><cf_get_lang dictionary_id ="53918.Cumartesi Çalışma Saati"></th>
					<th width="20" class="header_icn_none text-center">
						<a href="<cfoutput>#request.self#?fuseaction=ehesap.hours&event=add</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='54328.Şirket SSK Çalışma Saati Ekle'>" alt="<cf_get_lang dictionary_id='54328.Şirket SSK Çalışma Saati Ekle'>"></i></a>
					</th>
				</tr>
			</thead>
			<tbody>
				<cfoutput query="get_hours">
				<!---					<cfsavecontent variable="DayNo"><cf_get_lang_main no="#GetDayLangID(weekly_offday)#.Gün değeri"></cfsavecontent>--->
					<tr>
						<td width="25">#currentrow#</td>
						<td><a class="tableyazi" href="#request.self#?fuseaction=ehesap.hours&event=upd&OCH_ID=#OCH_ID#">#nick_name#</a></td>
						<td>#ssk_monthly_work_hours#</td>
						<td><cf_get_lang_main no="#GetDayLangID(weekly_offday)#.Gün değeri"></td>
						<td>#SSK_WORK_HOURS#</td>
						<td>#daily_work_hours#</td>
						<td>#SATURDAY_WORK_HOURS#</td>
						<td style="text-align:center;"><a href="#request.self#?fuseaction=ehesap.hours&event=upd&OCH_ID=#OCH_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
					</tr>
				</cfoutput>
			</tbody>
		</cf_grid_list>
	</cf_box>
</div>
