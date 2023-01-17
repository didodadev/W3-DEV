<cfinclude template="../query/get_employee_cautions.cfm">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='31012.İhtarlar'></cfsavecontent>
<cf_box title="#message#" closable="0">
	<cf_ajax_list>
		<div class="extra_list">
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='57480.Başlık'></th>
					<th width="100"><cf_get_lang dictionary_id='57630.Tip'></th>
					<th width="125"><cf_get_lang dictionary_id='58586.İşlem Yapan'></th>
					<th nowrap="nowrap"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></th>
					<th nowrap="nowrap"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
				</tr>
			</thead>
			<tbody>
				<cfif GET_EMPLOYEE_CAUTIONS.RECORDCOUNT>
					<cfoutput query="GET_EMPLOYEE_CAUTIONS">	
						<tr>
							<cfif fusebox.circuit eq 'myhome'><!---20131108--->
								<cfset caution_id_ = contentEncryptingandDecodingAES(isEncode:1,content:caution_id,accountKey:session.ep.userid)>
							<cfelse>
								<cfset caution_id_ = caution_id>
							</cfif>
							<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=myhome.popup_view_caution&caution_id=#caution_id_#','small')" class="tableyazi">#caution_head#</a></td>
							<td><cfif len(CAUTION_TYPE_ID)>
								<cfquery name="get_type" datasource="#dsn#">
									SELECT
										CAUTION_TYPE
									FROM
										SETUP_CAUTION_TYPE
									WHERE
										CAUTION_TYPE_ID = #CAUTION_TYPE_ID#
								</cfquery>
									#get_type.CAUTION_TYPE#
								</cfif>
							</td>				
							<td>#get_emp_info(warner,0,1)#</td>				
							<td>#dateformat(caution_date,dateformat_style)#</td>
							<td>#dateformat(record_date,dateformat_style)#</td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="5"><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'> !</td>
					</tr>
				</cfif>		
			</tbody>
		</div>
	</cf_ajax_list>
</cf_box> 