<!--- Kalite Kontrol Sonuclari Tipler Listesinde Ajax Olarak Acilir FBS 20121105 --->
<cfsetting showdebugoutput="no">
<cfquery name="quality_control_result" datasource="#dsn3#">
	SELECT
		QUALITY_CONTROL_ROW_ID RESULT_ID,
		#dsn#.Get_Dynamic_Language(QUALITY_CONTROL_ROW_ID,'#session.ep.language#','QUALITY_CONTROL_ROW','QUALITY_CONTROL_ROW',NULL,NULL,QUALITY_CONTROL_ROW) AS QUALITY_CONTROL_TYPE,
		QUALITY_ROW_DESCRIPTION TYPE_DESCRIPTION,
		RESULT_TYPE RESULT_TYPE,
		QUALITY_VALUE QUALITY_VALUE,
		TOLERANCE TOLERANCE,
		TOLERANCE_2 TOLERANCE_2,
		UNIT,
		CONTROL_OPERATOR,
		SAMPLE_METHOD,
		SAMPLE_NUMBER
	FROM
		QUALITY_CONTROL_ROW
	WHERE
		QUALITY_CONTROL_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.type_id#">
	ORDER BY
		QUALITY_CONTROL_TYPE_ID
</cfquery>
<cf_grid_list>
	<thead>
		<tr>
			<th width="20"><cf_get_lang dictionary_id='57487.No'></th>
			<th width="150"><cf_get_lang dictionary_id='58233.Tanım'></th>
			<th><cf_get_lang dictionary_id='33137.Standart'><cf_get_lang dictionary_id='33616.Değer'></th>
			<th class="text-right"><cf_get_lang dictionary_id='52249.Üst Limit'></th>
			<th class="text-right"><cf_get_lang dictionary_id='52248.Alt Limit'></th>
			<th width="25"><cf_get_lang dictionary_id='57636.Birim'></th>
			<th width="25"><cf_get_lang dictionary_id='57201.Kontrol'></th>
			<th width="100"><cf_get_lang dictionary_id='63292.Örneklem Yöntemi'></th>
			<th class="text-right" width="50"><cf_get_lang dictionary_id='64046.Örnek Miktarı'></th>
			<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
			<th width="20"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></th>
		</tr>
	</thead>
	<tbody>
		<cfif quality_control_result.recordcount>
			<cfoutput query="quality_control_result"> 
				<tr>
					<td>#currentrow#</td>
					<td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=settings.list_quality_control_types&event=updResult&result_id=#result_id#')" >#QUALITY_CONTROL_TYPE#</a></td>
					
				<td class="text-right" width="100">
					<cfif result_type eq 1>
						-
					<cfelseif result_type eq 0>
						#QUALITY_VALUE#
					</cfif>
				</td>
				<td class="text-right" width="100">
					<cfif result_type eq 1>
						-
					<cfelseif result_type eq 0>
						#TLFormat(TOLERANCE)#
					</cfif>
				</td>
				<td class="text-right" width="100">
					<cfif result_type eq 1>
						-
					<cfelseif result_type eq 0>
						#TLFormat(TOLERANCE_2)#
					</cfif>
				</td>
				<td>
				 	<cfif isDefined('unit')>
						 <cfif unit eq 1>mg</cfif>
						 <cfif unit eq 2>gr</cfif> 
						<cfif unit eq 3>kg</cfif> 
						<cfif unit eq 4>mm³</cfif> 
						<cfif unit eq 5>cm³</cfif> 
						<cfif unit eq 6>m³</cfif> 
						<cfif unit eq 7>ml</cfif> 
						<cfif unit eq 8>cl</cfif> 
						<cfif unit eq 9>lt</cfif> 
					</cfif>
				</td>
				<td>
					<cfif isDefined('control_operator')>
						<cfif control_operator eq 1>>=</cfif>
						<cfif control_operator eq 2>></cfif>
						<cfif control_operator eq 3><</cfif>
						<cfif control_operator eq 4>=></cfif>
						<cfif control_operator eq 5>=<</cfif>
					</cfif>
				</td>
				<td>
					<cfif isDefined('sample_method')>
						<cfif sample_method eq 1><cf_get_lang dictionary_id='63293.Rastgele'></cfif>
						<cfif sample_method eq 2><cf_get_lang dictionary_id='63294.Yüzdesel'>%</cfif>
						<cfif sample_method eq 3><cf_get_lang dictionary_id='64043.Katlanarak'></cfif>
					</cfif>
				</td>
				<td class="text-right">
					<cfif isDefined('sample_number')>#TLFormat(sample_number)#</cfif>
				</td>
				<td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=settings.list_quality_control_types&event=updResult&result_id=#result_id#')">#TYPE_DESCRIPTION#</a></td>
				<td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=settings.list_quality_control_types&event=updResult&result_id=#result_id#')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
			</tr>
			</cfoutput>
		<cfelse>
			<tr> 
				<td colspan="8"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
			</tr>
		</cfif>
	</tbody>
</cf_grid_list>
