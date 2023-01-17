<cfparam name="attributes.start_date" default="#dateformat(date_add('m',-1,CreateDate(year(now()),month(now()),1)),dateformat_style)#">
<cfparam name="attributes.finish_date" default="#dateformat(CreateDate(year(now()),month(now()),DaysInMonth(now())),dateformat_style)#"> 
<cfquery name="get_in_out" datasource="#dsn#">
	SELECT IN_OUT_ID FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = #session.ep.userid#
</cfquery>
<cfif len(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
</cfif>
<cfif len(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
</cfif>
<cfinclude template="../query/get_visits.cfm">
<cfinclude template="../query/get_related_visits.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#GET_FEES.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform action="#request.self#?fuseaction=myhome.list_my_visits" method="post" name="list_visits">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='30943.Viziteler'></cfsavecontent>
	<cf_medium_list_search title="#message#">
		<cf_medium_list_search_area>
			<table>
				<tr>
					<td>
						<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date, dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10">
						<cf_wrk_date_image date_field="start_date">
					</td>
					<td>
						<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date, dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10">
						<cf_wrk_date_image date_field="finish_date">
					</td>					
					<td>
						<cfsavecontent variable="message_date"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
						<cf_wrk_search_button search_function="date_check(list_visits.start_date,list_visits.finish_date,'#message_date#')">
					</td>
				</tr>
			</table>
		</cf_medium_list_search_area>
	</cf_medium_list_search>
</cfform>
<br />
<cf_medium_list>  
	<thead>
		<tr>
			<th colspan="7"><cf_get_lang dictionary_id="31453.Vizitelerim"></th>
		</tr>
		<tr>
			<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
			<th width="150"><cf_get_lang dictionary_id='57576.Çalışan'></th>
			<th width="95"><cf_get_lang dictionary_id='31463.Viziteye Çıkış'></th>
			<th width="95"><cf_get_lang dictionary_id='31464.Vizite Tarihi'></th>
			<th width="85"><cf_get_lang dictionary_id='31465.İş Kazası'></th>
			<th width="150"><cf_get_lang dictionary_id='57500.Onay'></th>
			<th class="header_icn_none"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=myhome.popup_ssk_fee_self&my_emp_id=#session.ep.userid#&inout_id=#get_in_out.in_out_id#</cfoutput>','medium')"><img src="/images/plus_list.gif" title="<cf_get_lang dictionary_id='57582.Ekle'>"></a></td><!-- sil -->
		</tr>
	</thead>
	<tbody>
		<cfif GET_FEES.RECORDCOUNT>
			<cfoutput query="GET_FEES" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td width="35">#currentrow#</td>
					<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');" class="tableyazi">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a></td>
					<td>#dateformat(FEE_DATE,dateformat_style)# #FEE_HOUR#:00</td>
					<td>#dateformat(FEE_DATEOUT,dateformat_style)# #FEE_HOUROUT#:00</td>
					<td><cfif accident eq 1><cf_get_lang dictionary_id='31465.İş Kazası'><cfelse><cf_get_lang dictionary_id='31466.Normal Vizite'></cfif></td>
					<td>
						<cfif len(validator_pos_code)>
                        	<cfif valid EQ 1>
                            	<cf_get_lang dictionary_id='57616.Onaylı'>-#get_emp_info(VALID_EMP,0,0)#
                            <cfelseif valid EQ 0>
                                <cf_get_lang dictionary_id='57617.Reddedildi'>-#get_emp_info(VALID_EMP,0,0)#
                           	<cfelseif valid EQ "">
                            	IK <cf_get_lang dictionary_id ='57615.Onay Bekliyor'>
                            </cfif>
                     	<cfelse>
							<cfif VALID_2 eq 1>
                                <cf_get_lang dictionary_id='35921.İkinci Amir'> <cf_get_lang dictionary_id='57616.Onaylı'>
                          	<cfelseif VALID_2 eq 0>
                            	<cf_get_lang dictionary_id='35921.İkinci Amir'> <cf_get_lang dictionary_id='57617.Reddedildi'>
							<cfelseif VALID_2 eq "" and len(VALID_1)>
                            <cfif VALID_1 eq 1>
                                <cf_get_lang dictionary_id='35921.İkinci Amir'> <cf_get_lang dictionary_id ='57615.Onay Bekliyor'>
                            <cfelseif VALID_1 eq 0>
                                <cf_get_lang dictionary_id='35927.Birinci Amir'> <cf_get_lang dictionary_id='57617.Reddedildi'>
                            </cfif>
                          	<cfelseif VALID_1 eq "">
								<cf_get_lang dictionary_id='35927.Birinci Amir'> <cf_get_lang dictionary_id ='57615.Onay Bekliyor'>
                            </cfif>
                      	</cfif>
					</td>
                    <!-- sil -->
					<td style="text-align:center;">
                    	<cfif fusebox.circuit eq 'myhome'>
                        	<cfset fee_id_ = contentEncryptingandDecodingAES(isEncode:1,content:fee_id,accountKey:session.ep.userid)>
                            <cfset my_emp_id_ = contentEncryptingandDecodingAES(isEncode:1,content:session.ep.userid,accountKey:session.ep.userid)>
                            <cfset inout_id_ = contentEncryptingandDecodingAES(isEncode:1,content:get_in_out.in_out_id,accountKey:session.ep.userid)>
                            <cfset employee_id_ = contentEncryptingandDecodingAES(isEncode:1,content:employee_id,accountKey:session.ep.userid)>
                      	<cfelse>
                          	<cfset fee_id_ = fee_id>
                            <cfset my_emp_id_ = session.ep.userid>
                            <cfset inout_id_ = get_in_out.in_out_id>
                            <cfset employee_id_ = employee_id>
                       	</cfif>
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=myhome.popup_ssk_fee_self_print&fee_id=#fee_id_#&employee_id=#employee_id_#','page')"><img src="/images/print2.gif" title="<cf_get_lang dictionary_id='57474.Yazdır'>"></a> 
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=myhome.popup_upd_ssk_fee_self&fee_id=#fee_id_#&my_emp_id=#my_emp_id_#&inout_id=#inout_id_#','medium')"><img src="/images/update_list.gif" title="<cf_get_lang dictionary_id='57464.Guncelle'>"></a>
					</td>
                    <!-- sil -->
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="7"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
			</tr>
		</cfif>
	</tbody>
</cf_medium_list> 
<br/>
<cf_medium_list>
	<thead>
		<tr>
			<th colspan="5" class="color-list"><cf_get_lang dictionary_id="31467.Yakın Viziteleri"></th>
		</tr>
		<tr>
			<th width="150"><cf_get_lang dictionary_id='31468.Çalışan Yakını'></th>
			<th width="150"><cf_get_lang dictionary_id='31277.Yakınlık Derecesi'></th>
			<th width="150"><cf_get_lang dictionary_id='31464.Vizite Tarihi'></th>
			<th width="150"><cf_get_lang dictionary_id='57500.Onay'></th>
			<th class="header_icn_none"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=myhome.popup_ssk_fee_relative&my_emp_id=#session.ep.userid#&inout_id=#get_in_out.in_out_id#</cfoutput>','medium')"><img src="/images/plus_list.gif" title="<cf_get_lang dictionary_id='57582.ekle'>"></a></th><!-- sil -->
		</tr>
	</thead>
	<tbody>
		<cfif GET_REL_FEES.RECORDCOUNT>
			<cfoutput query="GET_REL_FEES" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td>#ILL_NAME# #ILL_SURNAME#</td>
					<td>#ILL_RELATIVE#</td>
					<td>#dateformat(FEE_DATE,dateformat_style)# #FEE_HOUR#:00</td>
					<td>
                    	<cfif len(validator_pos_code)>
                        	<cfif valid EQ 1>
                            	<cf_get_lang dictionary_id='57616.Onaylı'>-#get_emp_info(VALID_EMP,0,0)#
                            <cfelseif valid EQ 0>
                                <cf_get_lang dictionary_id='57617.Reddedildi'>-#get_emp_info(VALID_EMP,0,0)#
                           	<cfelseif valid EQ "">
                            	<cf_get_lang dictionary_id='58692.IK'> <cf_get_lang dictionary_id ='57615.Onay Bekliyor'>
                            </cfif>
                     	<cfelse>
							<cfif VALID_2 eq 1>
                                <cf_get_lang dictionary_id='35921.İkinci Amir'> <cf_get_lang dictionary_id='57616.Onaylı'>
                          	<cfelseif VALID_2 eq 0>
                            	<cf_get_lang dictionary_id='35921.İkinci Amir'> <cf_get_lang dictionary_id='57617.Reddedildi'>
							<cfelseif VALID_2 eq "" and len(VALID_1)>
                                <cfif VALID_1 eq 1>
                                    <cf_get_lang dictionary_id='35921.İkinci Amir'> <cf_get_lang dictionary_id ='57615.Onay Bekliyor'>
                                <cfelseif VALID_1 eq 0>
                                    <cf_get_lang dictionary_id='35927.Birinci Amir'> <cf_get_lang dictionary_id='57617.Reddedildi'>
                                </cfif>
                          	<cfelseif VALID_1 eq "">
								<cf_get_lang dictionary_id='35927.Birinci Amir'> <cf_get_lang dictionary_id ='57615.Onay Bekliyor'>
                            </cfif>
                      	</cfif>
					</td>
                    <!-- sil -->
					<td style="text-align:center;">
                    	<cfif fusebox.circuit eq 'myhome'>
                        	<cfset fee_id_ = contentEncryptingandDecodingAES(isEncode:1,content:fee_id,accountKey:session.ep.userid)>
                            <cfset employee_id_ = contentEncryptingandDecodingAES(isEncode:1,content:employee_id,accountKey:session.ep.userid)>
                      	<cfelse>
                          	<cfset fee_id_ = fee_id>
                            <cfset employee_id_ = employee_id>
                       	</cfif>
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=myhome.popup_ssk_fee_relative_print&fee_id=#fee_id_#&employee_id=#employee_id_#','page')"><img src="/images/print2.gif" title="<cf_get_lang dictionary_id='57474.Yazdır'>"></a>
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=myhome.popup_upd_ssk_fee_relative&fee_id=#fee_id_#','medium')"><img src="/images/update_list.gif" title="<cf_get_lang dictionary_id='57464.güncelle'>"></a></td>
					</td>
                    <!-- sil -->
				</tr>
			</cfoutput>
			<cfelse>
				<tr>
					<td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
				</tr>
		</cfif>
	</tbody>
</cf_medium_list>
<br/>
<cf_medium_list>
	<thead>
		<tr>
			<th colspan="6" class="color-list"><cf_get_lang dictionary_id="31085.Onay Bekleyen Viziteler"></th>
		</tr>
		<tr>
			<th width="150"><cf_get_lang dictionary_id='57576.Çalışan'></th>
			<th width="95"><cf_get_lang dictionary_id='31463.Viziteye Çıkış'></th>
			<th width="95"><cf_get_lang dictionary_id='31464.Vizite Tarihi'></th>
			<th width="85"><cf_get_lang dictionary_id='31465.İş Kazası'></th>
			<th width="150"><cf_get_lang dictionary_id='57500.Onay'></th>
			<th class="header_icn_none"></th>
		</tr>
	</thead>
	<tbody>
		<cfif GET_OTHER_FEES.RECORDCOUNT>
			<cfoutput query="GET_OTHER_FEES" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
                    <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');" class="tableyazi">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a></td>
                    <td>#dateformat(FEE_DATE,dateformat_style)# #FEE_HOUR#:00</td>
                    <td>#dateformat(FEE_DATEOUT,dateformat_style)# #FEE_HOUROUT#:00</td>
                    <td><cfif accident eq 1><cf_get_lang dictionary_id='31465.İş Kazası'><cfelse><cf_get_lang dictionary_id='31466.Normal Vizite'></cfif></td>
                    <td>
                        <cfif len(VALID_EMP)>
                            #get_emp_info(VALID_EMP,0,1)# <cfif valid eq 1><cf_get_lang dictionary_id="58699.Onaylandı"><cfelse><cf_get_lang dictionary_id='57617.Reddedildi'></cfif>
                        <cfelse>
                            #get_emp_info(validator_pos_code,1,1)#
                            <cf_get_lang dictionary_id='57615.Onay Bekliyor'>
                        </cfif>
                    </td>
                    <!-- sil -->
                    <td style="text-align:center;">
                    	<cfif fusebox.circuit eq 'myhome'>
                        	<cfset fee_id_ = contentEncryptingandDecodingAES(isEncode:1,content:fee_id,accountKey:session.ep.userid)>
                            <cfset my_emp_id_ = contentEncryptingandDecodingAES(isEncode:1,content:session.ep.userid,accountKey:session.ep.userid)>
                            <cfset inout_id_ = contentEncryptingandDecodingAES(isEncode:1,content:get_in_out.in_out_id,accountKey:session.ep.userid)>
                      	<cfelse>
                          	<cfset fee_id_ = fee_id>
                            <cfset my_emp_id_ = session.ep.userid>
                            <cfset inout_id_ = get_in_out.in_out_id>
                       	</cfif>
                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=myhome.popup_upd_ssk_fee_self_other&fee_id=#fee_id_#&my_emp_id=#my_emp_id_#&inout_id=#inout_id_#','small')"><img src="/images/update_list.gif" title="<cf_get_lang dictionary_id='57464.güncelle'>"></a>
                    </td>
                    <!-- sil -->
				</tr>
			</cfoutput>
			<cfelse>
				<tr>
					<td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
				</tr>
		</cfif>
	</tbody>
</cf_medium_list>
<br/>
<cf_medium_list>
	<thead>
		<tr>
			<th colspan="5" class="color-list"><cf_get_lang dictionary_id="31088.Onay Bekleyen Yakın Viziteleri"></th>
		</tr>
		<tr>
			<th width="150"><cf_get_lang dictionary_id='31468.Çalışan Yakını'></th>
			<th width="150"><cf_get_lang dictionary_id='31277.Yakınlık Derecesi'></th>
			<th width="85"><cf_get_lang dictionary_id='31464.Vizite Tarihi'></th>
			<th width="150"><cf_get_lang dictionary_id='57500.Onay'></th>
			<th class="header_icn_none"></th>
		</tr>
	</thead>
	<tbody>
		<cfif GET_OTHER_REL_FEES.RECORDCOUNT>
			<cfoutput query="GET_OTHER_REL_FEES" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td>#ILL_NAME# #ILL_SURNAME#</td>
					<td>#ILL_RELATIVE#</td>
					<td>#dateformat(FEE_DATE,dateformat_style)# #FEE_HOUR#:00</td>
					<td>
						<cfif len(VALID_EMP)>
							#get_emp_info(VALID_EMP,0,1)# <cfif valid eq 1><cf_get_lang dictionary_id='58699.Onaylandı'><cfelse><cf_get_lang dictionary_id='57617.Reddedildi'></cfif>
						<cfelse>
							#get_emp_info(validator_pos_code,1,1)#
							<cf_get_lang dictionary_id='57615.Onay Bekliyor'>
						</cfif>
					</td>
                    <!-- sil -->
					<td style="text-align:center;">
                    	<cfif fusebox.circuit eq 'myhome'>
                        	<cfset fee_id_ = contentEncryptingandDecodingAES(isEncode:1,content:fee_id,accountKey:session.ep.userid)>
                            <cfset my_emp_id_ = contentEncryptingandDecodingAES(isEncode:1,content:session.ep.userid,accountKey:session.ep.userid)>
                            <cfset inout_id_ = contentEncryptingandDecodingAES(isEncode:1,content:get_in_out.in_out_id,accountKey:session.ep.userid)>
                      	<cfelse>
                          	<cfset fee_id_ = fee_id>
                            <cfset my_emp_id_ = session.ep.userid>
                            <cfset inout_id_ = get_in_out.in_out_id>
                       	</cfif>
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=myhome.popup_upd_ssk_fee_self_other_rel&fee_id=#fee_id_#&my_emp_id=#my_emp_id_#&inout_id=#inout_id_#','small')"><img src="/images/update_list.gif" title="<cf_get_lang dictionary_id='57464.güncelle'>"></a>
					</td>
                    <!-- sil -->
				</tr>
			</cfoutput>
			<cfelse>
				<tr>
					<td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
				</tr>
		</cfif>
	</tbody>
</cf_medium_list>