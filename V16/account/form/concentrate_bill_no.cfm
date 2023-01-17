<!---concentrate_bill_no--->

<!--- edefter kullanılıyor ise yevmiye no silsile halinde gider bu yüzden bir önceki defterin yevmiye nosundan başlamalıdır FA--->
<cfif session.ep.our_company_info.is_edefter eq 1>
	<cfquery name="getNetbooksRowNumber" datasource="#dsn2#">
        SELECT TOP 1 BILL_FINISH_NUMBER,FINISH_DATE FROM NETBOOKS WHERE STATUS = 1 ORDER BY FINISH_DATE DESC
    </cfquery>	
</cfif>
<cf_catalystHeader>
<cfform action="#request.self#?fuseaction=account.emptypopup_concentrate_bill_no" method="post" name="cash_flow_def">
	<div class="row"> 
		<div class="col col-12 uniqueRow"> 		
			<div class="row formContent">
				<div class="row">
					<font color="#FF0000" class="headbold"><cf_get_lang_main no ='1187.Dikkat'>! : <cf_get_lang no ='229.Bu İşlemle Muhasebe Fiş Numaralarınız Değiştirilecektir,İşlem Geri Alınamaz'>!</font>
				</div>
				<div class="row" type="row">
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-acc_card_type">
							<label class="col col-3 col-xs-12"><cf_get_lang_main no="388.İşlem Tipi"></label>
							<div class="col col-9 col-xs-12"> 
								<cfquery name="get_acc_card_type" datasource="#dsn3#">
									SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (10,11,12,13,14,19) ORDER BY PROCESS_TYPE
								</cfquery>
								<select multiple="multiple" name="acc_card_type" id="acc_card_type" style="width:120px;height:60px;">
									<cfoutput query="get_acc_card_type" group="process_type">
										<cfoutput>
										<option value="#process_type#-#process_cat_id#" <cfif isdefined('attributes.acc_card_type') and listfind(attributes.acc_card_type,'#process_type#-#process_cat_id#',',')>selected</cfif>>#process_cat#</option>
										</cfoutput>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-yev_no">
							<label class="col col-3 col-xs-12"><cf_get_lang no ='96.Yevmiye No'></label>
							<div class="col col-9 col-xs-12"> 
								<cfsavecontent variable="message"><cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no ='96.Yevmiye No'></cfsavecontent>
								<cfif session.ep.our_company_info.is_edefter eq 1>
									<cfif len(getNetbooksRowNumber.BILL_FINISH_NUMBER)>
										<cfinput type="text" name="yev_no" required="yes" message="#message#" value="#getNetbooksRowNumber.BILL_FINISH_NUMBER+1#" readonly="yes">
									<cfelse>
										<cfinput type="text" name="yev_no" required="yes" message="#message#" value="1" readonly="yes">
									</cfif>
								<cfelse>
									<cfinput type="text" name="yev_no" required="yes" message="#message#" value="1">
								</cfif>
							</div>
						</div>
						<div class="form-group" id="item-te_bill">
							<label class="col col-3 col-xs-12"><cf_get_lang no='55.Tediye Fiş No'></label>
							<div class="col col-9 col-xs-12"> 
								<cfsavecontent variable="message1"><cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no='55.Tediye Fiş No'></cfsavecontent>
								<cfinput type="text" name="te_bill" required="yes" message="#message1#" value="1">
							</div>
						</div>
						<div class="form-group" id="item-t_bill">
							<label class="col col-3 col-xs-12"><cf_get_lang no='56.Tahsil Fiş No'></label>
							<div class="col col-9 col-xs-12"> 
								<cfsavecontent variable="message2"><cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no='56.Tahsil Fiş No'></cfsavecontent>
								<cfinput type="text" name="t_bill" required="yes" message="#message2#" value="1">
							</div>
						</div>
						<div class="form-group" id="item-m_bill">
							<label class="col col-3 col-xs-12"><cf_get_lang no='57.Mahsup Fiş No'></label>
							<div class="col col-9 col-xs-12"> 
								<cfsavecontent variable="message3"><cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no='57.Mahsup Fiş No'></cfsavecontent>
								<cfinput type="text" name="m_bill" required="yes" message="#message3#" value="1">
							</div>
						</div>
						<div class="form-group" id="item-yev_start_no">
							<label class="col col-3 col-xs-12"><cf_get_lang no='19.Yevmiye'><cf_get_lang_main no ='1186.Başlangıç No'></label>
							<div class="col col-9 col-xs-12"> 
								<cfif session.ep.our_company_info.is_edefter eq 1>
									<cfinput type="text" name="yev_start_no" value="" message="Başlangıç Yevmiye No!" readonly="yes">
								<cfelse>
									<cfinput type="text" name="yev_start_no" value="" message="Başlangıç Yevmiye No!">
								</cfif>
							</div>
						</div>
						<div class="form-group" id="item-yev_start_date">
							<label class="col col-3 col-xs-12"><cf_get_lang_main no ='641.Başlangıç Tarihi'></label>
							<div class="col col-9 col-xs-12"> 
								<div class="input-group">
									<cfif session.ep.our_company_info.is_edefter eq 1>
										<cfif len(getNetbooksRowNumber.finish_date)>
											<cfinput type="text" name="yev_start_date" value="#dateformat(dateadd('d',1,getNetbooksRowNumber.finish_date),dateformat_style)#" style="width:120px;" validate="#validate_style#" maxlength="10" message="Başlangıç Tarihi !">
										<cfelse>
											<cfinput type="text" name="yev_start_date" value="" style="width:120px;" validate="#validate_style#" maxlength="10" message="Başlangıç Tarihi !">
										</cfif>
									<cfelse>
										<cfinput type="text" name="yev_start_date" value="" style="width:120px;" validate="#validate_style#" maxlength="10" message="Başlangıç Tarihi !">
									</cfif>
									<span class="input-group-addon"><cf_wrk_date_image date_field="yev_start_date"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-yev_finish_date">
							<label class="col col-3 col-xs-12"><cf_get_lang_main no ='288.Bitiş Tarihi'></label>
							<div class="col col-9 col-xs-12"> 
								<div class="input-group">
									<cfinput type="text" name="yev_finish_date" value="" style="width:120px;" validate="#validate_style#" maxlength="10" message="Bitiş Tarihi !">
									<span class="input-group-addon"><cf_wrk_date_image date_field="yev_finish_date"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-is_only_yev_no">
							<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="34061.Sadece Yevmiye Numaraları Düzenlensin"></label>
							<div class="col col-9 col-xs-12"> 
								<input type="checkbox" value="1" name="is_only_yev_no" id="is_only_yev_no" checked="checked">
							</div>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-dikkat">
							<label class="col col-12 bold red"><font color="red" size="2"><cf_get_lang_main no ='1187.Dikkat'>!!!</font></label>
							<div class="col col-12"> 
								<cf_get_lang no ='237.Sadece Yevmiye Numaraları Düzenlensin seçili ise fiş numaraları değişmez sadece yevmiye numaraları düzenlenir'>.<br /><br />
								<cf_get_lang no ='247.Sadece Yevmiye Numaraları Düzenlensin seçili değilse yevmiye numaraları fis numaraları ile birlikte düzenlenir'>.<br /><br />
								<cf_get_lang no='19.Yevmiye'><cf_get_lang_main no ='641.Başlangıç Tarihi'>:<cf_get_lang no ='112.Bu tarihten itibaren oluşturulan fişlerin yevmiye ve fiş numaraları düzenlenir'>.<br /><br />
								<cf_get_lang no='19.Yevmiye'><cf_get_lang_main no ='1186.Başlangıç No'>:<cf_get_lang no ='113.Bu numaradan daha büyük yevmiye nolu fişlerin yevmiye numaraları düzenlenir'>.
							</div>
						</div>
					</div>
				</div>	
				<div class="row formContentFooter">	
					<div class="col col-12">
						<cfsavecontent variable="message"><cf_get_lang no='72.Değiştir'></cfsavecontent>
						<cf_workcube_buttons type_format="1" is_upd='0' insert_info='#message#' add_function='kontrol()'> 
					</div> 
				</div>
			</div>
		</div>
	</div>
</cfform>
<script type="text/javascript">
	function kontrol()
	{
		d1 = document.getElementById('yev_start_date').value;
		start_date = d1.substring(6,10)+d1.substring(3,5)+d1.substring(0,2);
		
		d2 = document.getElementById('yev_finish_date').value;
		finish_date = d2.substring(6,10)+d2.substring(3,5)+d2.substring(0,2);
		
		if(start_date>finish_date)
		{
			alert("<cf_get_lang dictionary_id='58862.Başlangıç tarihi bitiş tarihinden büyük olamaz'>!");
			return false;
		}
		<cfif session.ep.our_company_info.is_edefter eq 1 and getNetbooksRowNumber.recordcount>
			if(start_date<=<cfoutput>#dateformat(getNetbooksRowNumber.finish_date,'yyyymmdd')#</cfoutput>)
			{
				alert("Başlangıç tarihi <cfoutput>#dateformat(getNetbooksRowNumber.finish_date,dateformat_style)#</cfoutput> tarihli e-defter bitiş tarihinden küçük ve eşit olamaz !");
				return false;
			}
			return true;
		</cfif>
	}
</script>
