<cfset pageHead = #getLang('myhome',212)# >
<cf_catalystHeader>
<cfset attributes.offtime_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.offtime_id,accountKey:'wrk') />
<cfif (isDefined('attributes.offtime_id') and (not len(attributes.offtime_id) or not isnumeric(attributes.offtime_id)))>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='58943.Boyle Bir Kayit Bulunmamaktadir'>!");
		window.close(); 
	</script>
	<cfabort>
</cfif>
<cfinclude template="../query/get_offtime.cfm">
<cfif len(get_offtime.startdate)>
	<cfset start_=date_add('h',session.ep.time_zone,get_offtime.startdate)>
<cfelse>
	<cfset start_="">
</cfif>
<cfif len(get_offtime.finishdate)>
	<cfset end_=date_add('h',session.ep.time_zone,get_offtime.finishdate)>
<cfelse>
	<cfset end_="">
</cfif>
<cfif len(get_offtime.work_startdate)>
	<cfset work_startdate=date_add('h',session.ep.time_zone,get_offtime.work_startdate)>
<cfelse>
	<cfset work_startdate="">
</cfif>	
<div class="row"> 
	<div class="col col-12 uniqueRow">
		<div class="row formContent">
			<div class="row" type="row">
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">					
					<div class="form-group" id="item-emp_name">
						<label class="col col-3 col-xs-12 bold"><cf_get_lang dictionary_id='57576.Calışan'></label>
						<div class="col col-9 col-xs-12"> 
							<cfoutput>#GET_EMP_INFO(get_offtime.employee_id,0,1)#</cfoutput>
						</div>
					</div>
					<div class="form-group" id="item-process">
						<label class="col col-3 col-xs-12 bold"><cf_get_lang dictionary_id ='58859.Süreç'></label>
						<div class="col col-9 col-xs-12"> 
							<cfoutput>#get_offtime.employee_id#</cfoutput>
						</div>
					</div>
					<div class="form-group" id="item-GET_OFFTIME_CATS">
						<label class="col col-3 col-xs-12 bold"><cf_get_lang dictionary_id='57486.Kategori'></label>
						<div class="col col-9 col-xs-12"> 
							<cfoutput>
								#GET_OFFTIME.NEW_CAT_NAME#
							</cfoutput>
						</div>
					</div>
					<div class="form-group" id="item-startdate">
						<label class="col col-3 col-xs-12 bold"><cf_get_lang dictionary_id='57501.Başlama'></label>
						<div class="col col-9 col-xs-12"> 
							<cfif len(start_)><cfoutput>#dateformat(start_,dateformat_style)# (#timeformat(start_,timeformat_style)#)</cfoutput></cfif>
						</div>
					</div>
					<div class="form-group" id="item-finishdate">
						<label class="col col-3 col-xs-12 bold"><cf_get_lang dictionary_id='57502.Bitiş'></label>
						<div class="col col-9 col-xs-12"> 
							<cfif len(end_)><cfoutput>#dateformat(end_,dateformat_style)# (#timeformat(end_,timeformat_style)#)</cfoutput></cfif>
						</div>
					</div>
					<div class="form-group" id="item-work_startdate">
						<label class="col col-3 col-xs-12 bold"><cf_get_lang dictionary_id='31153.İşe Başlama'></label>
						<div class="col col-9 col-xs-12"> 
							<cfif len(work_startdate)><cfoutput>#dateformat(work_startdate,dateformat_style)# (#timeformat(work_startdate,timeformat_style)#)</cfoutput></cfif>
						</div>
					</div>
					<div class="form-group" id="item-tel_no">
						<label class="col col-3 col-xs-12 bold"><cf_get_lang dictionary_id='31154.İzinde Ulaşılacak Telefon'></label>							
						<div class="col col-9 col-xs-12">
							<cfoutput>#get_offtime.tel_code# #get_offtime.tel_no#</cfoutput>					
						</div>
					</div>
					<div class="form-group" id="item-address">
						<label class="col col-3 col-xs-12 bold"><cf_get_lang dictionary_id='31155.İzinde Geçirilecek Adres'></label>
						<div class="col col-9 col-xs-12"> 
							<cfoutput>#get_offtime.address#</cfoutput>
						</div>
					</div>
					<div class="form-group" id="item-detail">
						<label class="col col-3 col-xs-12 bold"><cf_get_lang dictionary_id='57629.Açıklama'></label>
						<div class="col col-9 col-xs-12"> 
							<cfoutput>#get_offtime.detail#</cfoutput>
						</div>
					</div>
					<cfif not len(get_offtime.valid)>
						<div class="form-group" id="item-validator_position_1">
							<label class="col col-3 col-xs-12 bold"><cf_get_lang dictionary_id='30920.Onaylayacak'></label>
							<div class="col col-9 col-xs-12"> 
								<cfif len(get_offtime.validator_position_code)>
									<cfoutput>#GET_EMP_INFO(get_offtime.validator_position_code,1,1)#</cfoutput>
								</cfif>
							</div>
						</div>
					<cfelse>
						<div class="form-group" id="item-validator_position_1">
							<label class="col col-3 col-xs-12 bold"><cf_get_lang dictionary_id='30925.Onay Durumu'></label>
							<div class="col col-9 col-xs-12"> 
								<cfif get_offtime.valid EQ 1>
									<cf_get_lang dictionary_id='58699.Onaylandı'> !
									<cfoutput>#GET_EMP_INFO(get_offtime.VALID_EMPLOYEE_ID,0,1)# (#dateformat(get_offtime.validdate,dateformat_style)# #timeformat(get_offtime.validdate,timeformat_style)#)</cfoutput>
										<cfelseif get_offtime.valid EQ 0>
										<cf_get_lang dictionary_id='57617.Reddedildi'> !
									<cfoutput>#GET_EMP_INFO(get_offtime.VALID_EMPLOYEE_ID,0,1)# (#dateformat(get_offtime.validdate,dateformat_style)# #timeformat(get_offtime.validdate,timeformat_style)#)</cfoutput>
								</cfif>
							</div>
						</div>
					</cfif>
				</div>
			</div>	
		</div>
	</div>
</div>