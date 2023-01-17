<cfset wdo = createObject("component","WBP.Gaudit.files.cfc.gaudit")>
<cfset getPositionCats = WDO.getPositionCats()>
<cfset getPeriods = WDO.getPeriods()>
<cfif attributes.type eq 0>
	<cfsavecontent variable="title"><cf_get_lang dictionary_id = "43947.Sistem Parametre Ayarları"></cfsavecontent>
<cfelseif attributes.type eq 1>
	<cfsavecontent variable="title">Muhasebe Bilgi Formu</cfsavecontent>
<cfelseif attributes.type eq 2>
	<cfsavecontent variable="title">Banka Hesapları Bilgi Formu</cfsavecontent>
<cfelseif attributes.type eq 3>
	<cfsavecontent variable="title">Bilanço</cfsavecontent>
<cfelseif attributes.type eq 4>
	<cfsavecontent variable="title">Gelir Tablosu</cfsavecontent>
<cfelseif attributes.type eq 5>
	<cfsavecontent variable="title">Dip Notlar (Nazım Hesaplar)</cfsavecontent>
<cfelseif attributes.type eq 6>
	<cfsavecontent variable="title">Birlestirilmiş Veriler Defteri (Yevmiye)</cfsavecontent>
<cfelseif attributes.type eq 7>
	<cfsavecontent variable="title">Envanter Defteri</cfsavecontent>
<cfelseif attributes.type eq 8>
	<cfsavecontent variable="title">Geçici Mizan</cfsavecontent>
<cfelseif attributes.type eq 9>
	<cfsavecontent variable="title">Kesin Mizan</cfsavecontent>
</cfif>
<form method="post" name="government_audit_report" id="government_audit_report" action="">
	<input type="hidden" name="document_type" id="document_type" value="<cfoutput>#attributes.type#</cfoutput>" />
	<cf_box title="#title#" closable="0">
		<div class="formContent margin-0">
			<cf_box_elements>
				<cfif attributes.type eq 0>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-status">
							<label class="col col-3 col-xs-12">Kurum Kodu</label>
							<div class="col col-9 col-xs-12">
								<input type="text" name="company_code" id="company_code" value=""/>
							</div>
						</div>
						<div class="form-group" id="item-status">
							<label class="col col-3 col-xs-12">Şirket Adı</label>
							<div class="col col-9 col-xs-12">
								<input type="text" name="company_name" id="company_name" value=""/>
							</div>
						</div>
						<div class="form-group" id="item-status">
							<label class="col col-3 col-xs-12">Muhasebe Birimi</label>
							<div class="col col-9 col-xs-12">
								<select name="account_unit_name" id="account_unit_name">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="getPositionCats">
										<option value="#POSITION_CAT_ID#">#POSITION_CAT#</option>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-status">
							<label class="col col-3 col-xs-12">Muhasebe Birim Kodu</label>
							<div class="col col-9 col-xs-12">
								<input type="text" name="account_unit_code" id="account_unit_code" value=""/>
							</div>
						</div>
						<div class="form-group" id="item-status">
							<label class="col col-3 col-xs-12">Default Belge Ayracı</label>
							<div class="col col-9 col-xs-12">
								<input type="text" name="default_brace" id="default_brace" value="" placeholder="|"/>
							</div>
						</div>
					</div>
				<cfelseif attributes.type eq 1>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-status">
							<label class="col col-3 col-xs-12">Belge Oluştur</label>
							<div class="col col-9 col-xs-12">
								<label><input type="radio" name="is_document" value="0"/></label>
							</div>
						</div>
						<div class="form-group" id="item-status">
							<label class="col col-3 col-xs-12">Excel Oluştur</label>
							<div class="col col-9 col-xs-12">
								<label><input type="radio" name="is_document" value="1"/></label>
							</div>
						</div>
					</div>
				<cfelseif attributes.type eq 2>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-status">
							<label class="col col-3 col-xs-12">Dönem</label>
							<div class="col col-9 col-xs-12">
								<select name="year" id="year">
									<cfoutput query="getPeriods">
										<option value="#PERIOD_YEAR#">#PERIOD_YEAR#</option>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-status">
							<label class="col col-3 col-xs-12">Belge Oluştur</label>
							<div class="col col-9 col-xs-12">
								<label><input type="radio" name="is_document" value="0"/></label>
							</div>
						</div>
						<div class="form-group" id="item-status">
							<label class="col col-3 col-xs-12">Excel Oluştur</label>
							<div class="col col-9 col-xs-12">
								<label><input type="radio" name="is_document" value="1"/></label>
							</div>
						</div>
					</div>
				<cfelseif attributes.type eq 3>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-status">
							<label class="col col-3 col-xs-12">Dönem</label>
							<div class="col col-9 col-xs-12">
								<select name="year" id="year">
									<cfoutput query="getPeriods">
										<option value="#PERIOD_YEAR#">#PERIOD_YEAR#</option>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-status">
							<label class="col col-3 col-xs-12">Belge Oluştur</label>
							<div class="col col-9 col-xs-12">
								<label><input type="radio" name="is_document" value="0"/></label>
							</div>
						</div>
						<div class="form-group" id="item-status">
							<label class="col col-3 col-xs-12">Excel Oluştur</label>
							<div class="col col-9 col-xs-12">
								<label><input type="radio" name="is_document" value="1"/></label>
							</div>
						</div>
					</div>
				<cfelseif attributes.type eq 4>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-status">
							<label class="col col-3 col-xs-12">Dönem</label>
							<div class="col col-9 col-xs-12">
								<select name="year" id="year">
									<cfoutput query="getPeriods">
										<option value="#PERIOD_YEAR#">#PERIOD_YEAR#</option>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-status">
							<label class="col col-3 col-xs-12">Belge Oluştur</label>
							<div class="col col-9 col-xs-12">
								<label><input type="radio" name="is_document" value="0"/></label>
							</div>
						</div>
						<div class="form-group" id="item-status">
							<label class="col col-3 col-xs-12">Excel Oluştur</label>
							<div class="col col-9 col-xs-12">
								<label><input type="radio" name="is_document" value="1"/></label>
							</div>
						</div>
					</div>
				<cfelseif attributes.type eq 5>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-status">
							<label class="col col-3 col-xs-12">Dönem</label>
							<div class="col col-9 col-xs-12">
								<select name="year" id="year">
									<cfoutput query="getPeriods">
										<option value="#PERIOD_YEAR#">#PERIOD_YEAR#</option>
									</cfoutput>
								</select>
							</div>
						</div>
					</div>
				<cfelseif attributes.type eq 6>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-status">
							<label class="col col-3 col-xs-12">Başlangıç Tarihi</label>
							<div class="col col-9 col-xs-12">
								<input name="start_date" id="start_date" type="text" maxlength="10" value="" style="width:70px;">
								<cf_wrk_date_image date_field="start_date">
							</div>
						</div>
						<div class="form-group" id="item-status">
							<label class="col col-3 col-xs-12">Bitiş Tarihi</label>
							<div class="col col-9 col-xs-12">
								<input name="finish_date" id="finish_date" type="text" maxlength="10" value="" style="width:70px;">
								<cf_wrk_date_image date_field="finish_date">
							</div>
						</div>
						<div class="form-group" id="item-status">
							<label class="col col-3 col-xs-12">Belge Oluştur</label>
							<div class="col col-9 col-xs-12">
								<label><input type="radio" name="is_document" value="0"/></label>
							</div>
						</div>
						<div class="form-group" id="item-status">
							<label class="col col-3 col-xs-12">Excel Oluştur</label>
							<div class="col col-9 col-xs-12">
								<label><input type="radio" name="is_document" value="1"/></label>
							</div>
						</div>
					</div>
				<cfelseif attributes.type eq 7>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-status">
							<label class="col col-3 col-xs-12">Dönem</label>
							<div class="col col-9 col-xs-12">
								<select name="year" id="year">
									<cfoutput query="getPeriods">
										<option value="#PERIOD_YEAR#">#PERIOD_YEAR#</option>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-status">
							<label class="col col-3 col-xs-12">Belge Oluştur</label>
							<div class="col col-9 col-xs-12">
								<label><input type="radio" name="is_document" value="0"/></label>
							</div>
						</div>
						<div class="form-group" id="item-status">
							<label class="col col-3 col-xs-12">Excel Oluştur</label>
							<div class="col col-9 col-xs-12">
								<label><input type="radio" name="is_document" value="1"/></label>
							</div>
						</div>
					</div>
				<cfelseif attributes.type eq 8>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-status">
							<label class="col col-3 col-xs-12">Dönem</label>
							<div class="col col-9 col-xs-12">
								<select name="year" id="year">
									<cfoutput query="getPeriods">
										<option value="#PERIOD_YEAR#">#PERIOD_YEAR#</option>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-status">
							<label class="col col-3 col-xs-12">Ay</label>
							<div class="col col-9 col-xs-12">
								<select name="monthField">
									<cfloop index="indMonth" from="1" to="12">
										<option value="#indMonth#">#listGetAt(ay_list(),indMonth)#</option>
									</cfloop>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-status">
							<label class="col col-3 col-xs-12">Belge Oluştur</label>
							<div class="col col-9 col-xs-12">
								<label><input type="radio" name="is_document" value="0"/></label>
							</div>
						</div>
						<div class="form-group" id="item-status">
							<label class="col col-3 col-xs-12">Excel Oluştur</label>
							<div class="col col-9 col-xs-12">
								<label><input type="radio" name="is_document" value="1"/></label>
							</div>
						</div>
					</div>
				<cfelseif attributes.type eq 9>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-status">
							<label class="col col-3 col-xs-12">Dönem</label>
							<div class="col col-9 col-xs-12">
								<select name="year" id="year">
									<cfoutput query="getPeriods">
										<option value="#PERIOD_YEAR#">#PERIOD_YEAR#</option>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-status">
							<label class="col col-3 col-xs-12">Ay</label>
							<div class="col col-9 col-xs-12">
								<select name="monthField">
									<cfloop index="indMonth" from="1" to="12">
										<option value="#indMonth#">#listGetAt(ay_list(),indMonth)#</option>
									</cfloop>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-status">
							<label class="col col-3 col-xs-12">Belge Oluştur</label>
							<div class="col col-9 col-xs-12">
								<label><input type="radio" name="is_document" value="0"/></label>
							</div>
						</div>
						<div class="form-group" id="item-status">
							<label class="col col-3 col-xs-12">Excel Oluştur</label>
							<div class="col col-9 col-xs-12">
								<label><input type="radio" name="is_document" value="1"/></label>
							</div>
						</div>
					</div>
				</cfif>
			</cf_box_elements>
			<div class="ui-form-list-btn">	
				<div class="col col-12">
					<input type="button" name="createData" onclick="control(<cfoutput>#attributes.type#</cfoutput>)" value="<cfif attributes.type eq 0>Kaydet<cfelse>Oluştur</cfif>"/>
				</div> 
			</div>
		</div>
	</cf_box>
</form>
<script type="text/javascript">
	function control(type){
		if(type == 1){
			input = $("#form"+type).serialize();
			$.ajax({ url :'WBP/Gaudit/files/cfc/gaudit.cfc?method=saveParams', data : {data : input}, async:false,success : function(res){
				data = $.parseJSON( res );
				}
			});
		}
		else
			return false;
	}
</script>