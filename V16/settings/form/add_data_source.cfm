<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform method="post" name="add_data_source" action="">
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-dsn_name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32893.DSN'>*</label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='32893.DSN'></cfsavecontent>
							<input type="text" name="data_source_name" id="data_source_name" value="" required="yes" message="<cfoutput>#message#</cfoutput>">
						</div>
					</div>
					<div class="form-group" id="item-type">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='52735.Type'>*</label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='52735.Type'></cfsavecontent>
							<select name="type" id="type" required="yes" message="<cfoutput>#message#</cfoutput>">
								<option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
								<option value="5"><cf_get_lang dictionary_id='62672.Eta'></option>
								<option value="1"><cf_get_lang dictionary_id='58637.Logo'></option>
								<option value="2"><cf_get_lang dictionary_id='62669.Mikro'></option>
								<option value="4"><cf_get_lang dictionary_id='62671.Netsis'></option>
								<option value="6"><cf_get_lang dictionary_id='62673.NetSuite'></option>
								<option value="7"><cf_get_lang dictionary_id='62674.SAP Business One'></option>
								<option value="3"><cf_get_lang dictionary_id='62670.SAP Hana'></option>
								<option value="9"><cf_get_lang dictionary_id='58783.Workcube'></option>
								<option value="8"><cf_get_lang dictionary_id='62675.Workday'></option>
								<option value="10"><cf_get_lang dictionary_id='58156.Diğer'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-driver">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='62676.Driver'>*</label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='62676.Driver'></cfsavecontent>
							<select name="driver" id="driver" required="yes" message="<cfoutput>#message#</cfoutput>">
								<option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
								<option value="MSSQLServer"><cf_get_lang dictionary_id='62683.Microsoft SQL Server'></option>
								<option value="MySQL5"><cf_get_lang dictionary_id='62684.MySQL'></option>
								<option value="Oracle"><cf_get_lang dictionary_id='62685.Oracle'></option>
								<option value="PostgreSQL"><cf_get_lang dictionary_id='62686.PostgreSQL'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-host">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='47987.IP'>*</label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='47987.IP'></cfsavecontent>
							<input type="text" name="host_ip" id="host_ip" value="" required="yes" message="<cfoutput>#message#</cfoutput>">
						</div>
					</div>
					<div class="form-group" id="item-port">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='54830.Port'>*</label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='54830.Port'></cfsavecontent>
							<input type="text" name="port" id="port" value="" required="yes" message="<cfoutput>#message#</cfoutput>" onkeyup="isNumber(this);">
						</div>
					</div>
					<div class="form-group" id="item-username">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29709.Username'>*</label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='29709.Username'></cfsavecontent>
							<input type="text" name="username" id="username" value="" required="yes" message="<cfoutput>#message#</cfoutput>">
						</div>
					</div>
					<div class="form-group" id="item-password">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57552.Password'>*</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='57552.Password'></cfsavecontent>
								<input type="text" class="input-type-password" name="password" id="password" value="" required="yes" message="<cfoutput>#message#</cfoutput>" oncopy="return false" onpaste="return false">
								<span class="input-group-addon showPassword" onclick="showPasswordClass('password')"><i class="fa fa-eye"></i></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-cf_password">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33516.CF Password'>*</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='33516.CF Password'></cfsavecontent>
								<input type="text" class="input-type-password" name="cf_password" id="cf_password" value="" required="yes" message="<cfoutput>#message#</cfoutput>">
								<span class="input-group-addon showPassword" onclick="showPasswordClass('cf_password')"><i class="fa fa-eye"></i></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-details">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
						<div class="col col-8 col-xs-12">
							<textarea name="details" id="details" style="height:120px;"></textarea>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons type_format="1" is_upd='0'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>