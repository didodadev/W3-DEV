<cfsetting showdebugoutput="no">
<cfquery name="get_file_row" datasource="fileaudit">
	SELECT
		FileName,
		EventTime,
		UserAccount
	FROM
		FA_Events
	WHERE
		UserAccount <> 'ep'
		AND FileName = '#attributes.file_name#'
	ORDER BY
		EventTime DESC
</cfquery>
<cf_form_list>
	<thead>
		<tr>
			<th width="35">No</th>
			<th width="150">İşlemi Yapan</th>
			<th>Değiştirme Tarihi</th>
		</tr>
	</thead>
	<tbody>
		<cfoutput query="get_file_row">
			<tr>
				<td>#currentrow#</td>
				<td>#UserAccount#</td>
				<td>#dateformat(dateadd('h',session.ep.time_zone,EventTime),'DD/MM/YYYY')# #Timeformat(dateadd('h',session.ep.time_zone,EventTime),'HH:MM')#</td>
			</tr>
		</cfoutput>
	</tbody>
</cf_form_list>

