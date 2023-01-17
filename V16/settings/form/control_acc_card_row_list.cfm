<cfparam name="attributes.acc_period_" default="#session.ep.period_id#">
<cfquery name="get_period" datasource="#dsn#">
	SELECT PERIOD_ID, PERIOD FROM SETUP_PERIOD
</cfquery>
<cfif isdefined("attributes.is_form_submitted") and len(attributes.acc_period_)>
	<cfquery name="GET_PERIODS" datasource="#DSN#">
		SELECT 
			PERIOD,
			PERIOD_ID,
			PERIOD_YEAR,
			OUR_COMPANY_ID
		FROM 
			SETUP_PERIOD 
		WHERE 
			PERIOD_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.acc_period_#">
	</cfquery>
	<cfif GET_PERIODS.recordcount>
		<cfset new_dsn2 = '#dsn#_#get_periods.PERIOD_YEAR#_#get_periods.OUR_COMPANY_ID#'>
		<cfquery name="GET_ACC_CARD" datasource="#new_dsn2#">		
			SELECT DISTINCT
				AC.CARD_ID, 
				CARD_DETAIL, 
				CARD_TYPE, 
				BILL_NO, 
				ACTION_DATE,
				PAPER_NO,
				ACCOUNT_ID
			FROM
				ACCOUNT_CARD_ROWS ACCR, 
				ACCOUNT_CARD AC
			WHERE
				AC.CARD_ID = ACCR.CARD_ID AND
				ACCR.ACCOUNT_ID  NOT IN (SELECT ACCOUNT_CODE FROM ACCOUNT_PLAN)
			ORDER BY ACTION_DATE ASC
		</cfquery>
	<cfelse>
		<cfset GET_ACC_CARD.recordcount=0>
	</cfif>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="form" method="post" action="#request.self#?fuseaction=settings.control_acc_card_list">
			<input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
            <cf_box_search more="0">
                <div class="form-group">
                    <label><cf_get_lang dictionary_id='30172.Muhasebe Dönemi'></label>				
                </div>
				<div class="form-group">
					<select name="acc_period_" id="acc_period_">
						<option value="" selected><cf_get_lang dictionary_id='42199.Dönemler'></option>
						<cfoutput query="get_period">
							<option value="#PERIOD_ID#" <cfif attributes.acc_period_ eq PERIOD_ID>selected</cfif>>#PERIOD#</option>
						</cfoutput>
					</select>					
				</div>	
				<div class="form-group">
					<cf_wrk_search_button is_upd='0' type_format="1" button_type="4">
				</div>
			</cf_box_search>
		</cfform>		
	</cf_box>	
    <cf_box title="#getLang('','Hesap Planında Olmayıp Hareket Gören Hesaplar','44155')#" uidrop="1" hide_table_column="1" > 
		<cf_grid_list>
            <thead>
				<tr>
					<th class="text-center" width="50"><cf_get_lang dictionary_id='57946.Fiş No'></th>
					<th><cf_get_lang dictionary_id='47299.Hesap Kodu'></th>
					<th><cf_get_lang dictionary_id='57880.Belge No'></th>
					<th><cf_get_lang dictionary_id='47348.Fiş Türü'></th>
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<th><cf_get_lang dictionary_id='57742.Tarih'></th>
				</tr>
			</thead>
			<tbody>
				<cfif isdefined("attributes.is_form_submitted") and len(attributes.acc_period_)>
					<cfif GET_ACC_CARD.recordcount>
						<cfoutput query="GET_ACC_CARD">
							<tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
								<td>
								<cfif get_periods.period_id eq session.ep.period_id>
									<a class="tableyazi" href="javascript://" onClick="windowopen('#request.self#?fuseaction=account.popup_list_card_rows&card_id=#GET_ACC_CARD.CARD_ID#','work');">#GET_ACC_CARD.bill_no#</a>
								<cfelse>
									#GET_ACC_CARD.bill_no#
								</cfif>
								</td>
								<td>#GET_ACC_CARD.account_id#</td>
								<td>#GET_ACC_CARD.paper_no#</td>
								<td>
									<cfswitch expression="#GET_ACC_CARD.card_type#" >
										<cfcase value="10"><cf_get_lang dictionary_id='58756.Açılış Fişi'></cfcase>
										<cfcase value="11"><cf_get_lang dictionary_id='48950.Tahsil Fişi'></cfcase>
										<cfcase value="12"><cf_get_lang dictionary_id='48951.Tediye Fişi'></cfcase>
										<cfcase value="13"><cf_get_lang dictionary_id='58452.Mahsup Fişi'></cfcase>
										<cfcase value="14"><cf_get_lang dictionary_id='29435.Özel Fiş'></cfcase>
										<cfcase value="15"><cf_get_lang dictionary_id='57884.Kur Farkı'></cfcase>
										<cfcase value="40"><cf_get_lang dictionary_id='39390.Cari Hesap Açılış Fişi'></cfcase>
									</cfswitch>
								</td>
								<td>#GET_ACC_CARD.card_detail#</td>
								<td>#dateformat(GET_ACC_CARD.action_date,dateformat_style)#</td>
							</tr>
						</cfoutput>				  	
					<cfelse>
						<tr>
							<td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
						</tr>		
					</cfif>
				<cfelse>
					<tr>
						<td colspan="6"><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</td>
					</tr>		
				</cfif>
			</tbody>
			<cfif isdefined("attributes.is_form_submitted") and len(attributes.acc_period_)>
				<tfoot>
					<tr>
						<td><cfoutput>#get_periods.period#</cfoutput></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>			
				</tfoot>
			</cfif>			
		</cf_grid_list>
	</cf_box>
</div>

