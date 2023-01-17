<cfif isdefined("issubmit")>
	<cfquery name="GETTYPE" datasource="#dsn2#">
		SELECT 
			IS_CH,
			IS_CR,
			IS_BA,
			IS_BS 
		FROM 
			CARI_LETTER
		WHERE 
			CARI_LETTER_ID = #attributes.cari_letter_id#
	</cfquery>
	<cfquery name="ADDMEMBERLETTER" datasource="#dsn2#">
		UPDATE 
			CARI_LETTER_ROW
		SET
			<!--- Mutabakat --->
			<cfif gettype.is_ch eq 1>
				ACCEPT_AMOUNT =  <cfif isdefined("attributes.is_ch_amount") and len(attributes.is_ch_amount)>#filternum(attributes.is_ch_amount)#<cfelse>0</cfif>,
			</cfif>
			<!--- Cari Hatırlatma --->
			<cfif gettype.is_cr eq 1>
				ACCEPT_AMOUNT =  <cfif isdefined("attributes.is_cr_amount") and len(attributes.is_cr_amount)>#filternum(attributes.is_cr_amount)#<cfelse>0</cfif>,
			</cfif>
			<!--- BA --->
			<cfif gettype.is_ba eq 1>
				ACCEPT_TOTAL = <cfif isdefined("attributes.is_ba_total") and len(attributes.is_ba_total)>#filternum(attributes.is_ba_total)#<cfelse>0</cfif>,
				ACCEPT_AMOUNT = <cfif isdefined("attributes.is_ba_amount") and len(attributes.is_ba_amount)>#filternum(attributes.is_ba_amount)#<cfelse>0</cfif>,
			</cfif>
			<!--- BS --->
			<cfif gettype.is_bs eq 1>
				ACCEPT_TOTAL = <cfif isdefined("attributes.is_bs_total") and len(attributes.is_bs_total)>#filternum(attributes.is_bs_total)#<cfelse>0</cfif>,
				ACCEPT_AMOUNT = <cfif isdefined("attributes.is_bs_amount") and len(attributes.is_bs_amount)>#filternum(attributes.is_bs_amount)#<cfelse>0</cfif>,
			</cfif>
			
			ACCEPT_NAME = '#attributes.acceptname#',
			ACCEPT_DETAIL = '#attributes.acceptdetail#',
			ACCEPT_TYPE = <cfif len(attributes.accepttype)>#attributes.accepttype#<cfelse>null</cfif>,
			ACCEPT_STATUS = #attributes.acceptstatus#,
			
			
			ACCEPT_USER = #session.ep.userid#,
			ACCEPT_DATE = #now()#,
			ACCEPT_IP = '#cgi.remote_addr#'
		WHERE 
			CARI_LETTER_ROW_ID = #attributes.cari_letter_row_id#
	</cfquery>
	<script language="javascript">
		window.opener.location.reload();
		window.close();
	</script>
<cfelse>
	<div class="col col-12 col-xs-12">
		<cfform name="acceptletter" method="post" action="index.cfm?fuseaction=finance.popup_accept_cari_letter">
			<input type="hidden" name="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
			<input type="hidden" name="cari_letter_row_id" value="<cfoutput>#attributes.cari_letter_row_id#</cfoutput>">
			<input type="hidden" name="cari_letter_id" value="<cfoutput>#attributes.cari_letter_id#</cfoutput>">
			<input type="hidden" name="acceptstatus" value="<cfoutput>#attributes.acceptstatus#</cfoutput>">
			<input type="hidden" name="issubmit" value="1">
			<cfif attributes.acceptstatus eq 1>
				<cfset headstatus = "#getLang('','Onayla',58475)#">
			<cfelse>
				<cfset headstatus = "#getLang('','Reddet',58461)#">
			</cfif>
			<cfquery name="GETMAIN" datasource="#dsn2#">
				SELECT 
					IS_CH,
					IS_CR,
					IS_BA,
					IS_BS
				FROM 
					CARI_LETTER
				WHERE 
					CARI_LETTER_ID = #attributes.cari_letter_id# 
			</cfquery>
			<cfquery name="GETAMOUNT" datasource="#dsn2#">
				SELECT 
					IS_CH_AMOUNT,
					IS_CR_AMOUNT,
					IS_BA_TOTAL,
					IS_BA_AMOUNT,
					IS_BS_TOTAL,
					IS_BS_AMOUNT
				FROM 
					CARI_LETTER_ROW 
				WHERE 
					CARI_LETTER_ROW_ID = #attributes.cari_letter_row_id# 
			</cfquery>
		
			<cf_box title="#headstatus#"><!---Deneme Süresi Bilgileri--->
				<cf_box_elements>
					<div class="col col-8 col-xs-12">
					<cfif getmain.is_ch eq 1>
						<div class="form-group">
							<label class="col col-4 col-xs-6"><cf_get_lang dictionary_id='57673.Tutar'></label>
							<input type="text" name="is_ch_amount" id="is_ch_amount"  value="<cfoutput>#tlformat(getamount.is_ch_amount)#</cfoutput>" class="moneybox"  onkeyup="return(FormatCurrency(this,event));">
						</div> 
					</cfif>
					<cfif getmain.is_cr eq 1>
						<div class="form-group">
							<label class="col col-4 col-xs-6"><cf_get_lang dictionary_id='57673.Tutar'></label>
							<input type="text" name="is_cr_amount" id="is_cr_amount"  value="<cfoutput>#tlformat(getamount.is_cr_amount)#</cfoutput>" class="moneybox"  onkeyup="return(FormatCurrency(this,event));">
						</div> 
					</cfif>
					<cfif getmain.is_ba eq 1>
						<div class="form-group">
							<label class="col col-4 col-xs-6"><cf_get_lang dictionary_id='57635.Miktar'></label>
							<input type="text" name="is_ba_total" id="is_ba_total"  value="<cfoutput>#getamount.is_ba_total#</cfoutput>" class="moneybox">
						</div> 
						<div class="form-group">
							<label class="col col-4 col-xs-6"><cf_get_lang dictionary_id='57673.Tutar'></label>
							<input type="text" name="is_ba_amount" id="is_ba_amount"  value="<cfoutput>#tlformat(getamount.is_ba_amount)#</cfoutput>" class="moneybox"  onkeyup="return(FormatCurrency(this,event));">
						</div> 
					</cfif>
					<cfif getmain.is_bs eq 1>
						<div class="form-group">
							<label class="col col-4 col-xs-6"><cf_get_lang dictionary_id='57635.Miktar'></label>
							<input type="text" name="is_bs_total" id="is_bs_total"  value="<cfoutput>#getamount.is_bs_total#</cfoutput>" class="moneybox">
						</div> 
						<div class="form-group">
							<label class="col col-4 col-xs-6"><cf_get_lang dictionary_id='57673.Tutar'></label>
							<input type="text" name="is_bs_amount" id="is_bs_amount"  value="<cfoutput>#tlformat(getamount.is_bs_amount)#</cfoutput>" class="moneybox"  onkeyup="return(FormatCurrency(this,event));">
						</div> 
					</cfif>
					<div class="form-group">
						<label class="col col-4 col-xs-6"><cfif attributes.acceptstatus eq 1><cf_get_lang dictionary_id='30982.Onaylayan'><cfelse><cf_get_lang dictionary_id='31898.Reddeden'></cfif></label>
						<input type="text" name="acceptname" id="acceptname" value="">
					</div>   
					<div class="form-group">
						<label class="col col-4 col-xs-6"><cfif attributes.acceptstatus eq 1><cf_get_lang dictionary_id='57500.Onay'> <cf_get_lang dictionary_id='57629.Açıklama'><cfelse><cf_get_lang dictionary_id='29537.Red'> <cf_get_lang dictionary_id='57629.Açıklama'></cfif></label>
						<textarea name="acceptdetail" id="acceptdetail" style="height:100px;"></textarea>
					</div> 
					<div class="form-group">
						<label class="col col-4 col-xs-6"><cfif attributes.acceptstatus eq 1><cf_get_lang dictionary_id='57500.Onay'> <cf_get_lang dictionary_id='57065.Tipi'><cfelse><cf_get_lang dictionary_id='29537.Red'> <cf_get_lang dictionary_id='57065.Tipi'></cfif></label>
						<cfquery name="GETMETHOD" datasource="#dsn#">
							SELECT * FROM SETUP_COMMETHOD
						</cfquery>
						<select name="accepttype" id="accepttype">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="getmethod">
								<option value="#commethod_id#">#commethod#</option>
							</cfoutput>
						</select>
					</div>      
				</div>  
				</cf_box_elements>        
				<cf_box_footer>
					<cf_workcube_buttons is_upd='1' add_function='kontrol()' is_delete='0'>
				</cf_box_footer>
			</cf_box>
		</cfform>
	</div>
	<script language="javascript">
		function kontrol()
		{
			if(document.acceptletter.acceptname.value=="")
			{
				alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='29831.Kişi'>!");
				return false;
			}
			if(document.acceptletter.acceptdetail.value=="")
			{
				alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='57629.Açıklama'>!");
				return false;
			}
			if(document.acceptletter.accept_type.value=="")
			{
				alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='57065.Tipi'>!");
				return false;
			}
		}
	</script>
</cfif>