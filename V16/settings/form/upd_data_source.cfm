<cfset cmpDsn = createObject("component","V16.settings.cfc.data_source") />
<cfset get_dsn = cmpDsn.getDataSource(data_source_id : attributes.data_source_id) />
<cfif get_dsn.TYPE eq 1>
	<cfset getLogoCompDetails = cmpDsn.getLogoCompDetails(dsn_name : get_dsn.DATA_SOURCE_NAME) />
	<cfset getLogoPeriodDetails = cmpDsn.getLogoPeriodDetails(dsn_name : get_dsn.DATA_SOURCE_NAME) />
</cfif>

<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform method="post" name="add_data_source" action="">
			<input type="hidden" name="data_source_id" id="data_source_id" value="<cfoutput>#attributes.data_source_id#</cfoutput>">
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-dsn_name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32893.DSN'>*</label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='32893.DSN'></cfsavecontent>
							<input type="hidden" name="old_data_source_name" id="old_data_source_name" value="<cfoutput>#get_dsn.DATA_SOURCE_NAME#</cfoutput>">
							<input type="text" name="data_source_name" id="data_source_name" value="<cfoutput>#get_dsn.DATA_SOURCE_NAME#</cfoutput>" required="yes" message="<cfoutput>#message#</cfoutput>">
						</div>
					</div>
					<div class="form-group" id="item-type">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='52735.Type'>*</label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='52735.Type'></cfsavecontent>
							<select name="type" id="type" required="yes" message="<cfoutput>#message#</cfoutput>">
								<option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
								<option value="5" <cfif get_dsn.TYPE eq 5>selected</cfif>><cf_get_lang dictionary_id='62672.Eta'></option>
								<option value="1" <cfif get_dsn.TYPE eq 1>selected</cfif>><cf_get_lang dictionary_id='58637.Logo'></option>
								<option value="2" <cfif get_dsn.TYPE eq 2>selected</cfif>><cf_get_lang dictionary_id='62669.Mikro'></option>
								<option value="4" <cfif get_dsn.TYPE eq 4>selected</cfif>><cf_get_lang dictionary_id='62671.Netsis'></option>
								<option value="6" <cfif get_dsn.TYPE eq 6>selected</cfif>><cf_get_lang dictionary_id='62673.NetSuite'></option>
								<option value="7" <cfif get_dsn.TYPE eq 7>selected</cfif>><cf_get_lang dictionary_id='62674.SAP Business One'></option>
								<option value="3" <cfif get_dsn.TYPE eq 3>selected</cfif>><cf_get_lang dictionary_id='62670.SAP Hana'></option>
								<option value="9" <cfif get_dsn.TYPE eq 9>selected</cfif>><cf_get_lang dictionary_id='58783.Workcube'></option>
								<option value="8" <cfif get_dsn.TYPE eq 8>selected</cfif>><cf_get_lang dictionary_id='62675.Workday'></option>
								<option value="10" <cfif get_dsn.TYPE eq 10>selected</cfif>><cf_get_lang dictionary_id='58156.Diğer'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-driver">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='62676.Driver'>*</label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='62676.Driver'></cfsavecontent>
							<select name="driver" id="driver" required="yes" message="<cfoutput>#message#</cfoutput>">
								<option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
								<option value="MSSQLServer" <cfif get_dsn.DRIVER eq "MSSQLServer">selected</cfif>><cf_get_lang dictionary_id='62683.Microsoft SQL Server'></option>
								<option value="MySQL5" <cfif get_dsn.DRIVER eq "MySQL5">selected</cfif>><cf_get_lang dictionary_id='62684.MySQL'></option>
								<option value="Oracle" <cfif get_dsn.DRIVER eq "Oracle">selected</cfif>><cf_get_lang dictionary_id='62685.Oracle'></option>
								<option value="PostgreSQL" <cfif get_dsn.DRIVER eq "PostgreSQL">selected</cfif>><cf_get_lang dictionary_id='62686.PostgreSQL'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-host">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='47987.IP'>*</label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='47987.IP'></cfsavecontent>
							<input type="text" name="host_ip" id="host_ip" value="<cfoutput>#get_dsn.IP#</cfoutput>" required="yes" message="<cfoutput>#message#</cfoutput>">
						</div>
					</div>
					<div class="form-group" id="item-port">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='54830.Port'>*</label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='54830.Port'></cfsavecontent>
							<input type="text" name="port" id="port" value="<cfoutput>#get_dsn.PORT#</cfoutput>" required="yes" message="<cfoutput>#message#</cfoutput>" onkeyup="isNumber(this);">
						</div>
					</div>
					<div class="form-group" id="item-username">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29709.Username'>*</label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='29709.Username'></cfsavecontent>
							<input type="text" name="username" id="username" value="<cfoutput>#get_dsn.USERNAME#</cfoutput>" required="yes" message="<cfoutput>#message#</cfoutput>">
						</div>
					</div>
					<div class="form-group" id="item-password">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57552.Password'>*</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='57552.Password'></cfsavecontent>
								<input type="text" class="input-type-password" name="password" id="password" value="" required="yes" message="<cfoutput>#message#</cfoutput>" oncopy="return false" onpaste="return false" placeholder="<cfoutput>#iIf(len(get_dsn.PASSWORD),DE('&bull;&bull;&bull;&bull;'),DE(''))#</cfoutput>">
								<span class="input-group-addon showPassword" onclick="showPasswordClass('password')"><i class="fa fa-eye"></i></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-cf_password">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33516.CF Password'>*</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='33516.CF Password'></cfsavecontent>
								<input type="text" class="input-type-password" name="cf_password" id="cf_password" value="" required="yes" message="<cfoutput>#message#</cfoutput>" placeholder="<cfoutput>#iIf(len(get_dsn.CF_PASSWORD),DE('&bull;&bull;&bull;&bull;'),DE(''))#</cfoutput>">
								<span class="input-group-addon showPassword" onclick="showPasswordClass('cf_password')"><i class="fa fa-eye"></i></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-details">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
						<div class="col col-8 col-xs-12">
							<textarea name="details" id="details" style="height:120px;"><cfoutput>#get_dsn.DETAILS#</cfoutput></textarea>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_record_info query_name="get_dsn">
				<cf_workcube_buttons type_format="1" is_upd='1' del_function="del_control()">
			</cf_box_footer>
		</cfform>
	</cf_box>
	<cfif get_dsn.TYPE eq 1><!--- Type Logo ise şirket ve mali yıl bilgileri boxı yüklensin. --->
		<cf_box title="#getLang('','Şirket Bilgileri',32212)#">
			<cf_grid_list>
				<thead>
					<tr>
						<th><cf_get_lang dictionary_id='58485.Şirket Adı'></th>
						<th><cf_get_lang dictionary_id='57571.Ünvan'></th>
					</tr>
				</thead>
				<tbody>
					<cfif getLogoCompDetails.recordcount>
						<cfoutput query="getLogoCompDetails">
							<tr>
								<td>#NAME#</td>
								<td>#TITLE#</td>
							</tr>
						</cfoutput>
					<cfelse>
						<tr>
							<td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Yok'></td>
						</tr>
					</cfif>
				</tbody>
			</cf_grid_list>
		</cf_box>
		<cf_box title="#getLang('','Dönem Yıl',38371)#">
			<cf_grid_list>
				<thead>
					<tr>
						<th><cf_get_lang dictionary_id='58485.Şirket Adı'></th>
						<th><cf_get_lang dictionary_id='34219.Dönem Başlangıç'></th>
						<th><cf_get_lang dictionary_id='34218.Dönem Bitiş'></th>
					</tr>
				</thead>
				<tbody>
					<cfif getLogoPeriodDetails.recordcount>
						<cfoutput query="getLogoPeriodDetails">
							<tr>
								<td>#COMP_FULLNAME#</td>
								<td>#BEGDATE#</td>
								<td>#ENDDATE#</td>
							</tr>
						</cfoutput>
					<cfelse>
						<tr>
							<td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Yok'></td>
						</tr>
					</cfif>
				</tbody>
			</cf_grid_list>
		</cf_box>
	</cfif>
</div>

<script type="text/javascript">
	function del_control() {
		if($('#cf_password').val() == ''){
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='33516.CF Password'>");
			$('#cf_password').focus();
			return false;
		}
		document.add_data_source.action = '<cfoutput>#request.self#?fuseaction=settings.data_source&event=del</cfoutput>';
		document.add_data_source.submit();
	}
</script>