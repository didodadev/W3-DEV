<cfparam name="attributes.type" default="1">
<cfparam name="attributes.modal_id" default="">
<cfquery name="GET_COMPANY" datasource="#DSN#">
	SELECT 
		COMPANY.FULLNAME,
		COMPANY.TAXNO,
		COMPANY_SECUREFUND.SECUREFUND_ID, 
		COMPANY_SECUREFUND.COMPANY_ID,
		COMPANY_SECUREFUND.GIVE_TAKE,
		COMPANY_SECUREFUND.SECUREFUND_TOTAL,
		COMPANY_SECUREFUND.MONEY_CAT,
		COMPANY_SECUREFUND.FINISH_DATE,
		COMPANY_SECUREFUND.RECORD_EMP,
		COMPANY_SECUREFUND.RECORD_DATE,
		SETUP_SECUREFUND.SECUREFUND_CAT,
		PROCESS_TYPE_ROWS.STAGE
	FROM 
		COMPANY_SECUREFUND, 
		SETUP_SECUREFUND,
		PROCESS_TYPE_ROWS,
		COMPANY,
		OUR_COMPANY,
		COMPANY_BRANCH_RELATED
	WHERE 
		COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
		COMPANY.COMPANY_ID = #attributes.cpid# AND
		COMPANY_SECUREFUND.OUR_COMPANY_ID = OUR_COMPANY.COMP_ID AND 
		COMPANY_SECUREFUND.SECUREFUND_CAT_ID  = SETUP_SECUREFUND.SECUREFUND_CAT_ID AND
		COMPANY_SECUREFUND.BRANCH_ID = COMPANY_BRANCH_RELATED.RELATED_ID AND
		PROCESS_TYPE_ROWS.PROCESS_ROW_ID = COMPANY_SECUREFUND.PROCESS_CAT AND
		COMPANY.COMPANY_ID = COMPANY_SECUREFUND.COMPANY_ID AND
		COMPANY_SECUREFUND.IS_ACTIVE = 1 AND
		COMPANY_SECUREFUND.IS_SUBMIT = 1		
		<cfif len(attributes.type)>AND COMPANY_SECUREFUND.SECUREFUND_STATUS = #attributes.type#</cfif>
	ORDER BY 
		COMPANY_SECUREFUND.FINISH_DATE DESC
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Teminat Yönetimi','51999')#" popup_box="1">
        <cfform name="search_company" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.#fusebox.fuseaction#">
			<cf_box_search>
                <div class="form-group">
                    <label><cf_get_lang dictionary_id='51999.Teminat Yönetimi'><cfoutput>#get_company.fullname#</cfoutput></label>
                </div>
				<div class="form-group">
					<input type="hidden" name="cpid" id="cpid" value="<cfoutput>#attributes.cpid#</cfoutput>">
					<select name="type" id="type">
						<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
						<option value="1" <cfif attributes.type eq 1>selected</cfif>><cf_get_lang dictionary_id='57616.Onaylı'></option>
						<option value="0" <cfif attributes.type eq 0>selected</cfif>><cf_get_lang dictionary_id='51955.Onaysız'></option>
					</select>
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_company' , #attributes.modal_id#)"),DE(""))#">
				</div>
            </cf_box_search>
        </cfform>
    
		<cf_grid_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
					<th width="70"><cf_get_lang dictionary_id='58859.Süreç'></th>
					<th><cf_get_lang dictionary_id='57630.Tip'></th>
					<th width="100"><cf_get_lang dictionary_id='58689.Teminat'></th>
					<th width="75"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
					<th width="55"><cf_get_lang dictionary_id='57483.Kayıt'></th>
					<th width="100"  style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_company.recordcount>
				<cfset toplam = 0>
				<cfoutput query="get_company">
					<tr>
						<td>#currentrow#</td>
						<td>#stage#</td>
						<td><cfif give_take eq 0><cf_get_lang dictionary_id='58488.Alınan'><cfelse><cf_get_lang dictionary_id='58490.Verilen'></cfif></td>
						<td>#securefund_cat#</td>
						<td>#dateformat(finish_date,dateformat_style)#</td>
						<td>#dateformat(record_date,dateformat_style)#</td>
						<td style="text-align:right;">#tlformat(securefund_total)# #money_cat#</td>
					</tr>
					<cfset toplam = toplam + securefund_total>
				</cfoutput>
					<cfoutput>
					<tr>
						<td colspan="6"><cf_get_lang dictionary_id='57492.Toplam'></td>
						<td style="text-align:right;">#tlformat(toplam)# #session.ep.money#</td>
					</tr>
					</cfoutput>
				<cfelse>
					<tr height="22">
						<td colspan="30"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
	</cf_box>
</div>