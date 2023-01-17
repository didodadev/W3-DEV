<cfsetting showdebugoutput="no">
<cfinclude template="get_apps.cfm">
<cf_flat_list>
	<cfif GET_INTERVIEWS.recordcount>
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default=20>
	<cfparam name="attributes.totalrecords" default="#get_interviews.recordcount#">
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
		<thead>
			<tr>
				<th><cf_get_lang_main no ='1050.İsim Soyisim'></th>
				<th><cf_get_lang no ='748.Yaş'></th>
				<th><cf_get_lang_main no='1085.Pozisyon'></th>
				<th><cf_get_lang_main no = '330.Tarih'></th>
			</tr>
		</thead>
		<tbody>
			<cfoutput query="get_interviews" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td><a href="#request.self#?fuseaction=hr.list_cv&event=upd&empapp_id=#EMPAPP_ID#" class="tableyazi">#name# #surname#</a></td>
					<td style="width:30px;">
					  <cfif len(BIRTH_DATE)>
						<cfset YAS = DATEDIFF("yyyy",BIRTH_DATE,NOW())>
						   <cfif YAS NEQ 0>
							 #YAS#
						   </cfif>
					  </cfif>&nbsp;
					</td>
					<td>
						<cfif len(position_id)>
							<cfquery name="get_position" datasource="#dsn#">
								SELECT
									POSITION_NAME
								FROM
									EMPLOYEE_POSITIONS
								WHERE
									POSITION_CODE = #POSITION_ID#
							</cfquery>
							#get_position.position_name#
						</cfif>&nbsp;
					</td>
					<td style="width:65px;">#dateformat(APP_DATE,dateformat_style)#</td>
				</tr>
			</cfoutput>	
		</tbody>
	<cfelse>
		<tbody>
			<tr>
				<td><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
			</tr>
		</tbody>
	</cfif>
</cf_flat_list>

