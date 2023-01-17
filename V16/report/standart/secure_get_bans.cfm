<!---  
Nurullah DEMIR - 31.08.2010
Banlanan IP adreslerini listeler. 
/fbx_secure.cfm dosyasindaki pasif fonksiyonunu okuyunuz.
--->
<cfparam name="attributes.module_id_control" default="7">
<cfinclude template="report_authority_control.cfm">
<cfsetting showdebugoutput="no">
<cfparam name="attributes.log_status" default="">
<cfparam name="attributes.ip" default="">
<cfparam name="attributes.query_type" default="0">
<cfparam name="attributes.active" default="">
<cfparam name="attributes.from_date" default="">
<cfparam name="attributes.to_date" default="">
<cfparam name="attributes.is_excel" default="">
<cfif len(attributes.from_date) and isdate(attributes.from_date)>
	<cf_date tarih = "attributes.from_date">
</cfif>
<cfif len(attributes.to_date) and isdate(attributes.to_date)>
	<cf_date tarih = "attributes.to_date">
</cfif>
<cfif session.ep.admin eq 1>
	<cfif isdefined("attributes.banip") and len(attributes.banip)>
		<cfquery name="ban_ip" datasource="#dsn#">
			UPDATE 
				WRK_SECURE_BANNED_IP 
			SET 
				ACTIVE = 1 
			WHERE 
				REMOTE_ADDR =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.banip#">
		</cfquery>
	</cfif>
	<cfif isdefined("attributes.removeip") and len(attributes.removeip)>
		<cfquery name="remove_ip" datasource="#dsn#">
			UPDATE 
				WRK_SECURE_BANNED_IP 
			SET 
				ACTIVE = 0 
			WHERE 
				REMOTE_ADDR =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.removeip#">
		</cfquery>	
		<cfquery name="to_passive_log" datasource="#dsn#">
			UPDATE 
				WRK_SECURE_LOG 
			SET
				ACTIVE = 0 
			WHERE 
				REMOTE_ADDR =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.removeip#">
		</cfquery>
	</cfif>
	<cfif isdefined("attributes.banuser") and len(attributes.banuser)>
		<cfquery name="ban_user" datasource="#dsn#">
			UPDATE
				FAILED_LOGINS
			SET
				IS_ACTIVE = 1
			WHERE
				USER_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.banuser#">
		</cfquery>
	</cfif>
	<cfif isdefined("attributes.unbanuser") and len(attributes.unbanuser)>
		<cfquery name="unban_user" datasource="#dsn#">
			UPDATE
				FAILED_LOGINS
			SET
				IS_ACTIVE = 0
			WHERE
				USER_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.unbanuser#">
		</cfquery>
	</cfif>
</cfif>
<cfif isdefined("attributes.form_submitted")>
	<cfif attributes.query_type EQ 0>
		<cfset selectedQueryName = "GET_BANNED_IP">
		<cfset banAction = "banip">
		<cfset unbanAction = "removeip">
		<cfset actionValueColumn = "REMOTE_ADDR">
		<cfquery name="#selectedQueryName#" datasource="#DSN#">
			SELECT 
				REMOTE_ADDR,
				RECORD_DATE,
				LOG_ID,
				ACTIVE,
				EMPLOYEE_ID
			FROM 
				WRK_SECURE_BANNED_IP
			WHERE 
				1=1
			<cfif len(attributes.ip)>
				AND REMOTE_ADDR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ip#">
			</cfif>
			<cfif len(attributes.log_status)>
				AND ACTIVE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.log_status#"> 
			</cfif>
			<cfif len(attributes.from_date)>
				AND RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.from_date#"> 
			</cfif> 
			<cfif len(attributes.to_date)>
				AND RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.to_date#">
			</cfif>
			ORDER BY
				ID desc
		</cfquery>
		<cfset selectedQuery = get_banned_ip>
	<cfelse>
		<cfset selectedQueryName = "GET_BANNED_LOGIN">
		<cfset banAction = "banuser">
		<cfset unbanAction = "unbanuser">
		<cfset actionValueColumn = "USER_NAME">
		<cfquery name="#selectedQueryName#" datasource="#DSN#">
			SELECT
				USER_IP as REMOTE_ADDR,
				USER_NAME,
				LOGIN_ID,
				LOGIN_DATE as RECORD_DATE,
				IS_ACTIVE as ACTIVE
			FROM
				FAILED_LOGINS
			WHERE
				1=1
			<cfif len(attributes.ip)>
				AND USER_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ip#">
			</cfif>
			<cfif len(attributes.log_status)>
				AND IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.log_status#"> 
			</cfif>
			<cfif len(attributes.from_date)>
				AND LOGIN_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.from_date#">
			</cfif>
			<cfif len(attributes.to_date)>
				AND LOGIN_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.to_date#">
			</cfif>
			ORDER BY
				LOGIN_ID desc
		</cfquery>
		<cfset selectedQuery = get_banned_login>
	</cfif>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
<cfform name="filter" action="#request.self#?fuseaction=report.secure_get_bans" method="post">
	<cf_report_list_search title="#getlang('','Yasaklanmış IP/Kullanıcı Günlükleri',976)#">
		<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-2 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='61516.Ban'> <cf_get_lang dictionary_id='57065.Tipi'></label>
										<div class="col col-12 col-xs-12">
											<select name="query_type" id="query_type" onChange="changeQueryInputType()">
												<option title="IP" value="0" <cfif attributes.query_type EQ 0>selected</cfif>><cf_get_lang dictionary_id='47987.IP'></option>
												<option title="Kullanici" value="1" <cfif attributes.query_type EQ 1>selected</cfif>><cf_get_lang dictionary_id='57930.Kullanıcı'></option>
											</select>
									   </div>
								   </div>
							   </div>
							</div>
						 	<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
							 	<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12" id="queryInputLabel"></label>
										<div class="col col-12 col-xs-12">
											<cfinput type="Text" maxlength="255" value="#attributes.IP#" name="query_input" id="query_input">
										</div>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='1278.Tarih Aralığı'></label>
										<div class="col col-6">
											<div class="input-group">
												<cfinput type="text" name="from_date" value="#dateformat(attributes.from_date,dateformat_style)#" style="width:65px" validate="#validate_style#">
												<span class="input-group-addon"><cf_wrk_date_image date_field="from_date"></span>
											</div>
										</div>
										<div class="col col-6">
											<div class="input-group">
												<cfinput type="text" name="to_date" value="#dateformat(attributes.to_date,dateformat_style)#" style="width:65px" validate="#validate_style#">
												<span class="input-group-addon"><cf_wrk_date_image date_field="to_date"></span>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-2 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='296.Tüm'></label>
										<div class="col col-12 col-xs-12">
											<select name="log_status" id="log_status">
												<option title="<cf_get_lang dictionary_id='970.Tümünü getir'>" value=""><cf_get_lang_main no='322.Seçiniz'></option>
												<option title="<cf_get_lang dictionary_id='971.Banı açılmış kullanıcılar'>" value="0" <cfif attributes.log_status eq 0> selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
												<option title="<cf_get_lang dictionary_id='972.Banlı kullanıcılar'>" value="1" <cfif attributes.log_status eq 1> selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
											</select>
										</div>
									</div>
								</div>
							</div>	
						</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
							<label><cf_get_lang_main no='446.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>
							<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" onKeyUp="isNumber(this)" message="#message#" maxlength="3" style="width:25px;">
							<input type="hidden" name="form_submitted" id="form_submitted" value="1">
							<cf_wrk_report_search_button is_excel="1"  button_type="1" insert='#alert#' search_function='control()'>
						</div>
					</div>
				</div>
			</div>
		</cf_report_list_search_area>
	</cf_report_list_search>
</cfform>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
	<cfset filename="secure_get_bans#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
    <cfheader name="Expires" value="#Now()#">
    <cfcontent type="application/vnd.msexcel;charset=utf-8">
    <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</cfif>
<cfif IsDefined("attributes.form_submitted")>
	<cf_report_list>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='47987.IP'></th>
				<cfif attributes.query_type EQ 0>
					<th><cf_get_lang dictionary_id='57576.Çalışan'></th>
				<cfelse>
					<th><cf_get_lang dictionary_id='57930.Kullanıcı'></th>
				</cfif>
				<th><cf_get_lang_main no='215.Record Date'></th>
				<th><cf_get_lang_main no='81.Active'></th>
			</tr>
		</thead>
		<tbody>
			<cfif selectedQuery.recordcount>
				<cfoutput query="#selectedQueryName#" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td><a href="#request.self#?fuseaction=report.secure_get_attacks&IP=#remote_addr#">#remote_addr#<a/></td>
						<td><cfif attributes.query_type EQ 0>#get_emp_info(employee_id,0,0)#<cfelse>#user_name#</cfif></td>
						<td><cfif len(record_date)>#DateFormat(date_add("h",2,record_date),"dd/mm/yyyy HH:MM:ss")#</cfif></td>
						<td>
							<cfset actionValue = variables[selectedQueryName][actionValueColumn]>
							<cfif active is "0">
								<cf_get_lang dictionary_id='973.Banı açılmış'>
								<cfif session.ep.admin eq 1>
									[<a href="#request.self#?fuseaction=report.secure_get_bans&#banAction#=#actionValue#&form_submitted=1&query_type=#attributes.query_type#" class="tableyazi"><cf_get_lang dictionary_id='975.banla'>]</a>
								</cfif>
							<cfelse>
								<cf_get_lang dictionary_id='974.Banlı'> 
								<cfif session.ep.admin eq 1>
									[<a href="#request.self#?fuseaction=report.secure_get_bans&#unbanAction#=#actionValue#&form_submitted=1&query_type=#attributes.query_type#" class="tableyazi"><cf_get_lang dictionary_id='60652.ban aç'>]</a>
								</cfif>
							</cfif>
						</td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="3"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Yok'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz'> !</cfif></td>
				</tr>
			</cfif>
		</tbody>
	</cf_report_list>
	<cfif attributes.maxrows lt selectedQuery.recordcount>
		<cfset url_string = "#attributes.fuseaction#">
		<cfset url_string = "#url_string#&log_status=#attributes.log_status#&form_submitted=#attributes.form_submitted#">
		<cfif len(attributes.IP)>
			<cfset url_string = "#url_string#&ip=#attributes.ip#">
		</cfif>
		<cfif isdate(attributes.from_date)>
			<cfset url_string = "#url_string#&from_date=#dateformat(attributes.from_date,dateformat_style)#">
		</cfif>
		<cfif isdate(attributes.to_date)>
			<cfset url_string = "#url_string#&to_date=#dateformat(attributes.to_date,dateformat_style)#">
		</cfif>
		<cfif len(attributes.log_status)>
			<cfset url_string= "#url_string#&active=#attributes.active#">
		</cfif>
		<cf_paging
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#"
			totalrecords="#selectedQuery.recordcount#"
			startrow="#attributes.startrow#"
			adres="#url_string#">
	</cfif>
</cfif>
<script type="text/javascript">
	document.filter.query_input.focus();
	
	function control() {
		if(!checkQueryInput()) return false;
		if ((document.filter.from_date.value != '') && (document.filter.to_date.value != '') &&
	    !date_check(filter.from_date,filter.to_date,"<cf_get_lang no ='1093.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
	         return false;
		if (document.filter.is_excel.checked==false) {
			document.filter.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.secure_get_bans"
			return true;
		} else {
			document.filter.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_secure_get_bans</cfoutput>"
		}	
	}
	
	function checkQueryInput() {
		//Type 0 IP, type 1 Kullanıcı
		var queryType = document.getElementById("query_type").selectedOptions[0].value;
		if (queryType == 0) {
			var input = document.getElementById("query_input").value;
			console.log(input);
			if(input != "" && !input.match(/^(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:[.](?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}$/)) {
				alert('<cf_get_lang dictionary_id='54686.Hatalı'> <cf_get_lang dictionary_id='55440.IP Adresi'>');
				return false;
			}
		}
		return true;
	}

	changeQueryInputType();
	function changeQueryInputType() {
		var queryType = document.getElementById("query_type").selectedOptions[0].value;
		if (queryType == 0) {
			document.getElementById("queryInputLabel").innerText = '<cf_get_lang dictionary_id='47987.IP'>';
		} else {
			document.getElementById("queryInputLabel").innerText = '<cf_get_lang dictionary_id='57930.Kullanıcı'>';
		}
	}
	
</script>
