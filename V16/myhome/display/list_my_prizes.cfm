<cfinclude template="../query/get_employee_prizes.cfm">  

<cfsavecontent variable="message"><cf_get_lang dictionary_id='31013.Ödüllerim'></cfsavecontent>
<cf_box title="#message#" closable="0">
	<cf_ajax_list>
		<div class="extra_list">
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id='58577.Sira'></th>
					<th><cf_get_lang dictionary_id='31164.Ödül'></th>
					<th width="100"><cf_get_lang dictionary_id='57630.Tip'></th>
					<th width="125"><cf_get_lang dictionary_id='58586.İşlem Yapan'></th>
					<th nowrap="nowrap"><cf_get_lang dictionary_id='31165.Veriliş Tarihi'></th>
					<th nowrap="nowrap"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
				</tr>
			</thead>
			<tbody>
				<cfif GET_EMPLOYEE_PRIZES.RECORDCOUNT>
					<cfoutput query="GET_EMPLOYEE_PRIZES">
						<tr>
							<cfif fusebox.circuit eq 'myhome'><!---20131109--->
								<cfset prize_id_ = contentEncryptingandDecodingAES(isEncode:1,content:prize_id,accountKey:session.ep.userid)>
							<cfelse>
								<cfset prize_id_ = prize_id>
							</cfif>
							<td width="35">#currentrow#</td>
							<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=myhome.popup_view_prize&prize_id=#prize_id_#','small')" class="tableyazi">#prize_head#</a></td>
							<td>
								<cfif len(PRIZE_TYPE_ID)>
									<cfquery name="get_type" datasource="#dsn#">
									SELECT
										PRIZE_TYPE
									FROM
										SETUP_PRIZE_TYPE
									WHERE
										PRIZE_TYPE_ID = #PRIZE_TYPE_ID#
									</cfquery>
									#get_type.PRIZE_TYPE#
								</cfif>
							</td>				
							<td>#get_emp_info(prize_give_person,0,1)#</td>				
							<td>#dateformat(prize_date,dateformat_style)#</td>
							<td>#dateformat(record_date,dateformat_style)#</td>
						</tr>
					</cfoutput>	
				<cfelse>
					<tr>
						<td colspan="6"><cf_get_lang dictionary_id ='57484.Kayıt Yok'> !</td>
					</tr>
				</cfif>	
			</tbody>
		</div>
	</cf_ajax_list>
</cf_box>