<cfsetting showdebugoutput="no">
<cfquery name="get_guarantees" datasource="#dsn#">
	SELECT 
	CS.SECUREFUND_ID,
		CS.CONSUMER_ID,
		CS.COMPANY_ID,
		CS.GIVE_TAKE,
		CS.SECUREFUND_CAT_ID,
		SS.SECUREFUND_CAT,
		CS.BANK_BRANCH_ID,
		CS.START_DATE,
		CS.FINISH_DATE,
		CS.ACTION_VALUE,
		CS.ACTION_VALUE2
	FROM 
		COMPANY_SECUREFUND CS
		LEFT JOIN SETUP_SECUREFUND SS ON CS.SECUREFUND_CAT_ID = SS.SECUREFUND_CAT_ID
		LEFT JOIN #DSN3#.RELATED_CONTRACT RC ON RC.CONTRACT_ID=CS.CONTRACT_ID
	WHERE 
		CS.CONTRACT_ID = #attributes.contract_id#
</cfquery>
<cf_grid_list>
	<thead>
		<tr>
			<th width="25"><cf_get_lang dictionary_id='57487.No'></th>
			<th width="100"><cf_get_lang dictionary_id='57658.Üye'></th>
			<th width="80"><cf_get_lang dictionary_id='58488.Alınan'>/<cf_get_lang dictionary_id='58490.Verilen'></th>
			<th width="80"><cf_get_lang dictionary_id='57486.Kategori'></th>
			<th width="150"><cf_get_lang dictionary_id='57521.Banka'><cf_get_lang dictionary_id='57453.Şube'></th>
			<th width="65"><cf_get_lang dictionary_id='57655.Başlama Tarihi'></th>
			<th width="65"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
			<th width="65" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
			<th width="65" style="text-align:right;"><cf_get_lang dictionary_id='57677.Döviz'><cf_get_lang dictionary_id='57673.Tutar'></th>
			<th  width="25"><i class="fa fa-pencil"></i></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_guarantees.recordcount>
			<cfoutput query="get_guarantees">
				<cfset kontrol_date = createodbcdatetime(dateformat(now(),dateformat_style))>
				<cfif finish_date lt kontrol_date><cfset color_ = 'red'><cfelse><cfset color_ = ''></cfif>
				<tr>
					<td><font color="#color_#">#currentrow#</font></td>
					<td>
						<font color="#color_#">
						<cfif len(company_id)>
							#get_par_info(company_id,1,0,0)#
						<cfelseif len(consumer_id)>
							#get_cons_info(consumer_id,0,0)#
						</cfif>
						</font>
					</td>
					<td><font color="#color_#"><cfif give_take eq 0><cf_get_lang dictionary_id='58488.Alınan'><cfelse><cf_get_lang dictionary_id='58490.Verilen'></cfif></font></td>
					<td><font color="#color_#"><cfif len(securefund_cat)>#SECUREFUND_CAT#</cfif></font></td>
					<td>
						<font color="#color_#">
						<cfif len(bank_branch_id)>
							<cfquery name="GET_BANK_BRANCHES" datasource="#DSN3#">
								SELECT BANK_BRANCH_ID,BANK_BRANCH_NAME,BANK_NAME FROM BANK_BRANCH WHERE BANK_BRANCH_ID = #bank_branch_id#
							</cfquery> 
							#GET_BANK_BRANCHES.BANK_NAME# / #GET_BANK_BRANCHES.BANK_BRANCH_NAME#
						</cfif>
						</font>
					</td>
					<td><font color="#color_#">#dateFormat(START_DATE,dateformat_style)#</font></td>
					<td><font color="#color_#">#dateFormat(FINISH_DATE,dateformat_style)#</font></td>
					<td style="text-align:right;"><font color="#color_#">#tlFormat(ACTION_VALUE,2)#</font></td>
					<td style="text-align:right;"><font color="#color_#">#tlFormat(ACTION_VALUE2,2)#</font></td>
					<td><a href="#request.self#?fuseaction=finance.list_securefund&event=upd&securefund_id=#securefund_id#" target="blank"><img src="/images/update_list.gif" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></a></td>
				</tr>
		   </cfoutput>
		<cfelse>
			<tr>
				<td colspan="10"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'> !</td>
			</tr>
		</cfif>
	</tbody>
</cf_grid_list>



