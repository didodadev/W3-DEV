<cfparam name="attributes.cari_id" default="">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.page" default="1">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.cari_action_id") and len(attributes.cari_action_id) and attributes.kontrol_form eq 1>
	<cfquery name="del_row" datasource="#dsn2#">
		DELETE FROM CARI_ROWS WHERE CARI_ACTION_ID = #attributes.cari_action_id#
	</cfquery>
</cfif>
<cfquery name="get_all_cari" datasource="#dsn2#">
	SELECT
		'BANKA TALİMATI' AS TYPE,
		PAPER_NO,
		ACTION_ID,
		CARI_ACTION_ID
	FROM
		CARI_ROWS WITH (NOLOCK)
	WHERE	
		ACTION_TABLE='BANK_ORDERS'
		AND ACTION_ID NOT IN(SELECT BANK_ORDER_ID FROM BANK_ORDERS WITH (NOLOCK))
        <cfif isDefined("attributes.cari_id") and len(attributes.cari_id)>
        	AND CONVERT(nvarchar(20),CARI_ACTION_ID) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cari_id#%">
        </cfif>
	UNION ALL
	SELECT
		'FATURA' AS TYPE,
		PAPER_NO,
		ACTION_ID,
		CARI_ACTION_ID
	FROM
		CARI_ROWS WITH (NOLOCK)
	WHERE	
		ACTION_TABLE='INVOICE'
		AND ACTION_ID NOT IN(SELECT INVOICE_ID FROM INVOICE WITH (NOLOCK))
        <cfif isDefined("attributes.cari_id") and len(attributes.cari_id)>
        	AND CONVERT(nvarchar(20),CARI_ACTION_ID) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cari_id#%">
        </cfif>
	UNION ALL
	SELECT
		'KASA İŞLEMİ' AS TYPE,
		PAPER_NO,
		ACTION_ID,
		CARI_ACTION_ID
	FROM
		CARI_ROWS WITH (NOLOCK)
	WHERE	
		ACTION_TABLE='CASH_ACTIONS'
		AND ACTION_ID NOT IN(SELECT CASH_ACTIONS.ACTION_ID FROM CASH_ACTIONS WITH (NOLOCK))
        <cfif isDefined("attributes.cari_id") and len(attributes.cari_id)>
        	AND CONVERT(nvarchar(20),CARI_ACTION_ID) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cari_id#%">
        </cfif>
	UNION ALL
	SELECT
		'BANKA İŞLEMİ' AS TYPE,
		PAPER_NO,
		ACTION_ID,
		CARI_ACTION_ID
	FROM
		CARI_ROWS WITH (NOLOCK)
	WHERE	
		ACTION_TABLE='BANK_ACTIONS'
		AND ACTION_ID NOT IN(SELECT BANK_ACTIONS.ACTION_ID FROM BANK_ACTIONS WITH (NOLOCK))
        <cfif isDefined("attributes.cari_id") and len(attributes.cari_id)>
        	AND CONVERT(nvarchar(20),CARI_ACTION_ID) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cari_id#%">
        </cfif>
	UNION ALL
	SELECT
		'ÇEK BORDROSU' AS TYPE,
		PAPER_NO,
		ACTION_ID,
		CARI_ACTION_ID
	FROM
		CARI_ROWS WITH (NOLOCK)
	WHERE	
		ACTION_TABLE='PAYROLL'
		AND ACTION_ID NOT IN(SELECT PAYROLL.ACTION_ID FROM PAYROLL WITH (NOLOCK))
        <cfif isDefined("attributes.cari_id") and len(attributes.cari_id)>
        	AND CONVERT(nvarchar(20),CARI_ACTION_ID) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cari_id#%">
        </cfif>
	UNION ALL
	SELECT
		'SENET BORDROSU' AS TYPE,
		PAPER_NO,
		ACTION_ID,
		CARI_ACTION_ID
	FROM
		CARI_ROWS WITH (NOLOCK)
	WHERE	
		ACTION_TABLE='VOUCHER_PAYROLL'
		AND ACTION_ID NOT IN(SELECT VOUCHER_PAYROLL.ACTION_ID FROM VOUCHER_PAYROLL WITH (NOLOCK))
        <cfif isDefined("attributes.cari_id") and len(attributes.cari_id)>
        	AND CONVERT(nvarchar(20),CARI_ACTION_ID) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cari_id#%">
        </cfif>
	UNION ALL
	SELECT
		'BÜTÇE FİŞİ' AS TYPE,
		PAPER_NO,
		ACTION_ID,
		CARI_ACTION_ID
	FROM
		CARI_ROWS WITH (NOLOCK)
	WHERE	
		ACTION_TABLE='BUDGET_PLAN'
		AND ACTION_ID NOT IN(SELECT BUDGET_PLAN.BUDGET_PLAN_ID FROM #dsn_alias#.BUDGET_PLAN BUDGET_PLAN WITH (NOLOCK))
        <cfif isDefined("attributes.cari_id") and len(attributes.cari_id)>
        	AND CONVERT(nvarchar(20),CARI_ACTION_ID) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cari_id#%">
        </cfif>
	UNION ALL
	SELECT
		'CARİ HAREKET' AS TYPE,
		PAPER_NO,
		ACTION_ID,
		CARI_ACTION_ID
	FROM
		CARI_ROWS WITH (NOLOCK)
	WHERE	
		ACTION_TABLE='CARI_ACTIONS'
		AND ACTION_ID NOT IN(SELECT CARI_ACTIONS.ACTION_ID FROM CARI_ACTIONS WITH (NOLOCK))
        <cfif isDefined("attributes.cari_id") and len(attributes.cari_id)>
        	AND CONVERT(nvarchar(20),CARI_ACTION_ID) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cari_id#%">
        </cfif>
	UNION ALL
	SELECT
		'KREDİ KARTI ÖDEME' AS TYPE,
		PAPER_NO,
		ACTION_ID,
		CARI_ACTION_ID
	FROM
		CARI_ROWS WITH (NOLOCK)
	WHERE	
		ACTION_TABLE='CREDIT_CARD_BANK_EXPENSE'
		AND ACTION_ID NOT IN(SELECT CREDIT_CARD_BANK_EXPENSE.CREDITCARD_EXPENSE_ID FROM #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE CREDIT_CARD_BANK_EXPENSE WITH (NOLOCK))
        <cfif isDefined("attributes.cari_id") and len(attributes.cari_id)>
        	AND CONVERT(nvarchar(20),CARI_ACTION_ID) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cari_id#%">
        </cfif>
	UNION ALL
	SELECT
		'KREDİ KARTI TAHSİLAT' AS TYPE,
		PAPER_NO,
		ACTION_ID,
		CARI_ACTION_ID
	FROM
		CARI_ROWS WITH (NOLOCK)
	WHERE	
		ACTION_TABLE='CREDIT_CARD_BANK_PAYMENTS'
		AND ACTION_ID NOT IN(SELECT CREDIT_CARD_BANK_PAYMENTS.CREDITCARD_PAYMENT_ID FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS CREDIT_CARD_BANK_PAYMENTS WITH (NOLOCK))
        <cfif isDefined("attributes.cari_id") and len(attributes.cari_id)>
        	AND CONVERT(nvarchar(20),CARI_ACTION_ID) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cari_id#%">
        </cfif>
	UNION ALL
	SELECT
		'KREDİ ÖDEME - TAHSİLAT' AS TYPE,
		PAPER_NO,
		ACTION_ID,
		CARI_ACTION_ID
	FROM
		CARI_ROWS WITH (NOLOCK)
	WHERE	
		ACTION_TABLE='CREDIT_CONTRACT_PAYMENT_INCOME'
		AND ACTION_ID NOT IN(SELECT CREDIT_CONTRACT_PAYMENT_INCOME.CREDIT_CONTRACT_PAYMENT_ID FROM CREDIT_CONTRACT_PAYMENT_INCOME WITH (NOLOCK))
        <cfif isDefined("attributes.cari_id") and len(attributes.cari_id)>
        	AND CONVERT(nvarchar(20),CARI_ACTION_ID) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cari_id#%">
        </cfif>
	UNION ALL
	SELECT
		'MASRAF - GELİR FİŞİ' AS TYPE,
		PAPER_NO,
		ACTION_ID,
		CARI_ACTION_ID
	FROM
		CARI_ROWS WITH (NOLOCK)
	WHERE	
		ACTION_TABLE='EXPENSE_ITEM_PLANS'
		AND ACTION_ID NOT IN(SELECT EXPENSE_ITEM_PLANS.EXPENSE_ID FROM EXPENSE_ITEM_PLANS WITH (NOLOCK))
        <cfif isDefined("attributes.cari_id") and len(attributes.cari_id)>
        	AND CONVERT(nvarchar(20),CARI_ACTION_ID) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cari_id#%">
        </cfif>
	UNION ALL
	SELECT
		'ÇEK' AS TYPE,
		PAPER_NO,
		ACTION_ID,
		CARI_ACTION_ID
	FROM
		CARI_ROWS WITH (NOLOCK)
	WHERE	
		ACTION_TABLE='CHEQUE'
		AND PAYROLL_ID NOT IN(SELECT PAYROLL.ACTION_ID FROM PAYROLL WITH (NOLOCK))
        <cfif isDefined("attributes.cari_id") and len(attributes.cari_id)>
        	AND CONVERT(nvarchar(20),CARI_ACTION_ID) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cari_id#%">
        </cfif>
	UNION ALL
	SELECT
		'SENET' AS TYPE,
		PAPER_NO,
		ACTION_ID,
		CARI_ACTION_ID
	FROM
		CARI_ROWS WITH (NOLOCK)
	WHERE	
		ACTION_TABLE='VOUCHER'
		AND PAYROLL_ID NOT IN(SELECT VOUCHER_PAYROLL.ACTION_ID FROM VOUCHER_PAYROLL WITH (NOLOCK))
        <cfif isDefined("attributes.cari_id") and len(attributes.cari_id)>
        	AND CONVERT(nvarchar(20),CARI_ACTION_ID) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cari_id#%">
        </cfif>
</cfquery>
<cfset attributes.totalrecords=get_all_cari.recordcount>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="rapor" action="#request.self#?fuseaction=settings.list_nonoperation_ch_actions" method="post">
			<input name="kontrol_form" value="0" type="hidden">
			<input name="cari_action_id" value="" type="hidden">
			<cf_box_search>
				<div class="form-group"> 
					<cfsavecontent variable="message1"><cf_get_lang dictionary_id='30136.Cari İşlem ID'></cfsavecontent>
					<cfinput type="text" name="cari_id" validate="integer" id="keyword" placeholder="#message1#" value="#attributes.cari_id#" maxlength="50">
				</div>
				<div class="form-group  small"> 
					<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" id="maxrows" style="width:25px;" maxlength="3" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" onKeyUp="isNumber(this)" message="#message#">
				</div>
				<div class="form-group"> <cf_wrk_search_button button_type="4"></div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('main',2340)#">	
		<cf_grid_list>
			<thead>
				<tr> 
					<th><cf_get_lang dictionary_id='57487.NO'></th>
					<th><cf_get_lang dictionary_id='30136.Cari İşlem ID'></th>
					<th><cf_get_lang dictionary_id='42781.İşlem ID'></th>
					<th><cf_get_lang dictionary_id='58772.İşlem No'></th>
					<th><cf_get_lang dictionary_id='61806.İşlem Tipi'></th>
					<th><a href="javascript://"><i class="fa fa-plus"></i></a></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_all_cari.recordcount>
					<cfoutput query="get_all_cari"  startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td>#cari_action_id#</td>
							<td>#action_id#</td>
							<td>#paper_no#</td>
							<td>#type#</td>
							<td width="20"><a href="javascript://" onClick="sil('#cari_action_id#');"><i class="fa fa-minus"></i></a></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr class="color-row">
						<td colspan="6"> <cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>	
		<cfset adres="settings.#listlast(attributes.fuseaction,'.')#">
		<cfif isdefined("attributes.cari_id")>
			<cfset adres = "#adres#&cari_id=#attributes.cari_id#">
		</cfif>
		<cf_paging page="#attributes.page#" 
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="#adres#"> 
	</cf_box>
</div>
<script language="javascript">
	function sil(cari_action_id)
	{
		if(confirm("İşleme Ait Cari Hareket Silinecektir. Emin misiniz?"))
		{
			document.all.kontrol_form.value = 1;
			document.all.cari_action_id.value = cari_action_id;
			document.rapor.submit();
			alert('Silme İşlemi Tamamlandı...');
			document.all.kontrol_form.value = 0;
		}
	}
</script>
