<cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfparam name="attributes.module" default="">
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.page" default=1>
<cfparam name="TRANS_TYPES" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif form_varmi eq 1>
	<cfquery name="GET_PROCESS_CATS" datasource="#dsn3#">
		SELECT 
			SPC.PROCESS_CAT_ID,
			#dsn#.Get_Dynamic_Language(SPC.PROCESS_CAT_ID,'#session.ep.language#','SETUP_PROCESS_CAT','PROCESS_CAT',NULL,NULL,SPC.PROCESS_CAT) AS PROCESS_CAT,
			SPC.PROCESS_TYPE,
			SPC.PROCESS_MODULE,				
			SPC.IS_CARI,
			SPC.IS_ACCOUNT,
			SPC.IS_BUDGET,
			SPC.IS_COST,
			SPC.IS_STOCK_ACTION,
            SPC.IS_PAYMETHOD_BASED_CARI,
            SPC.IS_EXP_BASED_ACC,
			SPC.IS_PARTNER,
			SPC.IS_PUBLIC,
			SPC.IS_ROW_PROJECT_BASED_CARI,
			SPC.SPECIAL_CODE,
			SPC.RECORD_DATE,
			SPC.RECORD_IP,
			SPC.RECORD_EMP,
            SPC.INVOICE_TYPE_CODE,
            SPC.PROFILE_ID, 
			M.MODULE_NAME,
            CASE
        	WHEN ACDT.DOCUMENT_TYPE_ID < 0 THEN ACDT.DETAIL
            ELSE ACDT.DOCUMENT_TYPE
        END AS DOCUMENT_TYPE,
            ACPT.PAYMENT_TYPE 
		FROM 
			SETUP_PROCESS_CAT SPC
            	LEFT JOIN #dsn_alias#.ACCOUNT_CARD_DOCUMENT_TYPES ACDT ON ACDT.DOCUMENT_TYPE_ID = SPC.DOCUMENT_TYPE
                LEFT JOIN #dsn_alias#.ACCOUNT_CARD_PAYMENT_TYPES ACPT ON ACPT.PAYMENT_TYPE_ID = SPC.PAYMENT_TYPE,
			#dsn_alias#.MODULES M
		WHERE
			SPC.PROCESS_MODULE = M.MODULE_ID
		<cfif len(attributes.keyword)>
			AND 
			(#dsn#.Get_Dynamic_Language(SPC.PROCESS_CAT_ID,'#session.ep.language#','SETUP_PROCESS_CAT','PROCESS_CAT',NULL,NULL,SPC.PROCESS_CAT)  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
			 <cfif isnumeric(attributes.keyword)>
				 OR SPC.PROCESS_TYPE LIKE <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.keyword#">
			 </cfif>
			 )
		</cfif>
		<cfif len(attributes.module)>
			AND M.MODULE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.module#">
		</cfif>
		<cfif isdefined("TRANS_TYPES") and len(TRANS_TYPES)>
			AND
				(
				1=1
				<cfloop list="#TRANS_TYPES#" delimiters="," index="i">
					<cfif i eq 1>
						AND	IS_CARI=1 
					</cfif>
					<cfif i eq 2>
						AND IS_CARI=0 
					</cfif>
					<cfif i eq 3>
						AND IS_ACCOUNT=1  
					</cfif>
					<cfif i eq 4>
						AND IS_ACCOUNT=0
					</cfif>
					<cfif i eq 5>
						AND IS_BUDGET=1 
					</cfif>
					<cfif i eq 6>
						AND IS_BUDGET=0
					</cfif>
					<cfif i eq 7>
						AND IS_STOCK_ACTION=1
					</cfif>
					<cfif i eq 8>
						AND IS_STOCK_ACTION=0  
					</cfif>
					<cfif i eq 9>
						AND IS_COST=1  
					</cfif>
					<cfif i eq 10>
						AND IS_COST=0  
					</cfif>
               	<cfif session.ep.our_company_info.is_efatura>
                    <cfif i eq 11>
						AND INVOICE_TYPE_CODE='SATIS'  
					</cfif>
                    <cfif i eq 12>
						AND INVOICE_TYPE_CODE='IADE'  
					</cfif>
                    <cfif i eq 13>
						AND PROFILE_ID='TEMELFATURA'  
					</cfif>
                    <cfif i eq 14>
						AND PROFILE_ID='TICARIFATURA'  
					</cfif>
              	</cfif>
					<cfif i eq 15>
                        AND IS_PAYMETHOD_BASED_CARI=1
                    </cfif>
                    <cfif i eq 16>
                        AND IS_PAYMETHOD_BASED_CARI=0  
                    </cfif>
                    <cfif i eq 17>
                        AND IS_EXP_BASED_ACC=1  
                    </cfif>
                    <cfif i eq 18>
                        AND IS_EXP_BASED_ACC=0  
                    </cfif>
				</cfloop>
				)
		</cfif>
		ORDER BY
			SPC.PROCESS_CAT
	</cfquery>
<cfelse>
	<cfset GET_PROCESS_CATS.RecordCount = 0>
</cfif>
<cfquery name="get_modules" datasource="#dsn#">
	SELECT MODULE_ID, MODULE FROM WRK_MODULE WHERE MODULE IS NOT NULL ORDER BY MODULE
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="42536.Cari İşlem Yapar"></cfsavecontent>
<cfsavecontent variable="message1"><cf_get_lang dictionary_id="42537.Cari İşlem Yapmaz"></cfsavecontent>
<cfsavecontent variable="message2"><cf_get_lang dictionary_id="42548.Muhasebe İşlemi Yapar"></cfsavecontent>
<cfsavecontent variable="message3"><cf_get_lang dictionary_id="42552.Muhasebe İşlemi Yapmaz"></cfsavecontent>
<cfsavecontent variable="message4"><cf_get_lang dictionary_id="42554.Bütçe İşlemi Yapar"></cfsavecontent>
<cfsavecontent variable="message5"><cf_get_lang dictionary_id="42566.Bütçe İşlemi Yapmaz"></cfsavecontent>
<cfsavecontent variable="message6"><cf_get_lang dictionary_id="42568.Stok Hareketi Yapar"></cfsavecontent>
<cfsavecontent variable="message7"><cf_get_lang dictionary_id="42638.Stok Hareketi Yapmaz"></cfsavecontent>
<cfsavecontent variable="message8"><cf_get_lang dictionary_id="42639.Maliyet İşlemi Yapar"></cfsavecontent>
<cfsavecontent variable="message9"><cf_get_lang dictionary_id="42659.Maliyet İşlemi Yapmaz"></cfsavecontent>
<cfsavecontent variable="message10"><cf_get_lang dictionary_id="47788.Fatura Tipi Satış"></cfsavecontent>
<cfsavecontent variable="message11"><cf_get_lang dictionary_id="47787.Fatura Tipi İade"></cfsavecontent>
<cfsavecontent variable="message12"><cf_get_lang dictionary_id="47782.Senaryo Temel Fatura"></cfsavecontent>
<cfsavecontent variable="message13"><cf_get_lang dictionary_id="47781.Senaryo Ticari Fatura"></cfsavecontent>
<cfsavecontent variable="message14"><cf_get_lang dictionary_id="47780.Ödeme Yöntemi Gibi Cari İşlem Yapar"></cfsavecontent>
<cfsavecontent variable="message15"><cf_get_lang dictionary_id="47779.Ödeme Yöntemi Gibi Cari İşlem Yapmaz"></cfsavecontent>
<cfsavecontent variable="message16"><cf_get_lang dictionary_id="47776.Hizmet Kalemi Gibi Muhasebe Yapar"></cfsavecontent>
<cfsavecontent variable="message17"><cf_get_lang dictionary_id="47769.Hizmet Kalemi Gibi Muhasebe Yapmaz"></cfsavecontent>

	
<cfscript>
	TRANS_TYPE = QueryNew("TYPE_ID, TYPE_NAME");
if (session.ep.our_company_info.is_efatura)
	QueryAddRow(TRANS_TYPE,18);
else
	QueryAddRow(TRANS_TYPE,14);

	QuerySetCell(TRANS_TYPE,"TYPE_ID",1,1);
	QuerySetCell(TRANS_TYPE,"TYPE_NAME","#message#",1);
	QuerySetCell(TRANS_TYPE,"TYPE_ID",2,2);
	QuerySetCell(TRANS_TYPE,"TYPE_NAME","#message1#",2);
	QuerySetCell(TRANS_TYPE,"TYPE_ID",3,3);
	QuerySetCell(TRANS_TYPE,"TYPE_NAME","#message2#",3);
	QuerySetCell(TRANS_TYPE,"TYPE_ID",4,4);
	QuerySetCell(TRANS_TYPE,"TYPE_NAME","#message3#",4);
	QuerySetCell(TRANS_TYPE,"TYPE_ID",5,5);
	QuerySetCell(TRANS_TYPE,"TYPE_NAME","#message4#",5);
	QuerySetCell(TRANS_TYPE,"TYPE_ID",6,6);
	QuerySetCell(TRANS_TYPE,"TYPE_NAME","#message5#",6);
	QuerySetCell(TRANS_TYPE,"TYPE_ID",7,7);
	QuerySetCell(TRANS_TYPE,"TYPE_NAME","#message6#",7);
	QuerySetCell(TRANS_TYPE,"TYPE_ID",8,8);
	QuerySetCell(TRANS_TYPE,"TYPE_NAME","#message7#",8);
	QuerySetCell(TRANS_TYPE,"TYPE_ID",9,9);
	QuerySetCell(TRANS_TYPE,"TYPE_NAME","#message8#",9);
	QuerySetCell(TRANS_TYPE,"TYPE_ID",10,10);
	QuerySetCell(TRANS_TYPE,"TYPE_NAME","#message9#",10);
	QuerySetCell(TRANS_TYPE,"TYPE_ID",11,11);
	QuerySetCell(TRANS_TYPE,"TYPE_NAME","#message14#",11);
	QuerySetCell(TRANS_TYPE,"TYPE_ID",12,12);
	QuerySetCell(TRANS_TYPE,"TYPE_NAME","#message15#",12);
	QuerySetCell(TRANS_TYPE,"TYPE_ID",13,13);
	QuerySetCell(TRANS_TYPE,"TYPE_NAME","#message16#",13);
	QuerySetCell(TRANS_TYPE,"TYPE_ID",14,14);
	QuerySetCell(TRANS_TYPE,"TYPE_NAME","#message17#",14);
	if (session.ep.our_company_info.is_efatura)
	{
		QuerySetCell(TRANS_TYPE,"TYPE_ID",15,15);
		QuerySetCell(TRANS_TYPE,"TYPE_NAME","#message10#",15);
		QuerySetCell(TRANS_TYPE,"TYPE_ID",16,16);
		QuerySetCell(TRANS_TYPE,"TYPE_NAME","#message11#",16);
		QuerySetCell(TRANS_TYPE,"TYPE_ID",17,17);
		QuerySetCell(TRANS_TYPE,"TYPE_NAME","#message12#",17);
		QuerySetCell(TRANS_TYPE,"TYPE_ID",18,18);
		QuerySetCell(TRANS_TYPE,"TYPE_NAME","#message13#",18);
    }
</cfscript>
<cfparam name="attributes.totalrecords" default="#GET_PROCESS_CATS.RecordCount#">
<cfset process_sales_cost_list = "59,76,171,54,55,73,74,62,78,114,115,116,811,591,58,81,113,1131,63,48,50,49,51,110,761,592,1182"><!--- 761 hal irsaliyesi 592 hal fat. IS_COST--->
<cfset process_stock_list = "171,52,53,54,55,59,62,64,65,66,69,690,591,592,531,532,70,71,72,73,74,75,76,77,78,79,80,81,811,82,83,84,85,86,88,761,110,111,112,113,1131,114,115,116,140,141,120,122,118,1182,5311"><!---IS_STOCK_ACTION--->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="list_process_cats" action="#request.self#?fuseaction=settings.list_process_cats" method="post">
			<cfinput type="hidden" name="is_form_submitted" value="1">	
				<cf_box_search more="0">
					<div class="form-group" id="item-keyword">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id="57460.Filtre"></cfsavecontent>
						<cfinput type="text" name="keyword" placeholder="#message#" maxlength="50" value="">
					</div>
					<div class="form-group">
						<div class="input-group large">
							<cf_multiselect_check 
								query_name="TRANS_TYPE"  
								name="TRANS_TYPES"
								width="150" 
								option_value="TYPE_ID" 
								option_name="TYPE_NAME"
								value="#TRANS_TYPES#">
						</div>
					</div>
					<div class="form-group" id="item-module">
						<select name="module" id="module">
							<option value=""><cf_get_lang dictionary_id='42178.Modül'></option>
							<cfoutput query="get_modules">
								<option value="#MODULE_ID#" <cfif MODULE_ID eq attributes.module>selected</cfif>>#MODULE#</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group small">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
					</div>
					<div class="form-group">
						<cf_wrk_search_button search_function="kontrol()" button_type="4">
						<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'> 
					</div>
				</cf_box_search>	
		</cfform>
	</cf_box>

<!-- sil -->
	<cfsavecontent  variable="header"><cf_get_lang dictionary_id="40079.İşlem Kategorileri"></cfsavecontent>
	<cf_box title="#header#" uidrop="1" hide_table_column="1">
		<div class="scroll">
			<cf_grid_list>
				<thead>
					<tr>
						<!-- sil -->
						<th width="20"><i class="fa fa-caret-right" title="<cf_get_lang dictionary_id='58596.Goster'>"></i></th>
						<!-- sil -->
						<th><cf_get_lang dictionary_id='42382.İşlem Kategorisi'></th>
						<th><cf_get_lang dictionary_id='57692.İşlem'></th>
						<th><cf_get_lang dictionary_id='36742.Modül'></th>
					<cfif session.ep.our_company_info.is_efatura>
						<th><cf_get_lang dictionary_id="57441.Fatura "></th> 
						<th><cf_get_lang dictionary_id="59321.Senaryo"></th>
					</cfif>
						<th><cf_get_lang dictionary_id='58061.Cari'></th>
						<th><cf_get_lang dictionary_id='57447.Muhasebe'></th>
						<th><cf_get_lang dictionary_id='57559.Bütçe'></th>
						<th><cf_get_lang dictionary_id='58258.Maliyet'></th>
						<th><cf_get_lang dictionary_id='43231.Stok Hareketi'></th>
						<th><cf_get_lang dictionary_id='58885.Partner'></th>
						<th><cf_get_lang dictionary_id='43232.Public'></th>
						<th><cf_get_lang dictionary_id='57468.Belge'></th>
						<th><cf_get_lang dictionary_id='30057.Ödeme Şekli'></th>
						<th width="20" class="header_icn_none"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.list_process_cats&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					</tr>
				</thead>
				<tbody>
					<cfif get_process_cats.recordcount and form_varmi eq 1>
						<cfoutput query="GET_PROCESS_CATS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
							<tr>
								<!-- sil -->
								<td width="15" class="iconL" onclick="AjaxPageLoad('#request.self#?fuseaction=settings.ajax_emptypopup_process_history&process_cat_id=#PROCESS_CAT_ID#','display_process_info#currentrow#');">
									<a id="items_#currentrow#" href="javascript:void(0)" title="<cf_get_lang dictionary_id='58596.Goster'>"><i class="fa fa-caret-right"></i> </a>
									 
								</td>
								<!-- sil -->
								<td>
									<a class="tableyazi" href="#request.self#?fuseaction=settings.list_process_cats&event=upd&process_cat_id=#PROCESS_CAT_ID#">#PROCESS_CAT#</a>
								</td>
								<td>#PROCESS_TYPE#</td>
								<td>#MODULE_NAME#</td>
							<cfif session.ep.our_company_info.is_efatura>
								<td>#INVOICE_TYPE_CODE#</td>
								<td>#PROFILE_ID#</td>
							</cfif>
								<td style="text-align:center;"><cfif IS_CARI eq 1><b><i class="icon-circle" style="color:##44b6ae"></b></cfif></td>
								<td style="text-align:center;"><cfif IS_ACCOUNT eq 1><b><i class="icon-circle" style="color:##44b6ae"></b></cfif></td>
								<td style="text-align:center;"><cfif IS_BUDGET eq 1><b><i class="icon-circle" style="color:##44b6ae"></b></cfif></td>
								<td style="text-align:center;"><cfif listfind(process_sales_cost_list,get_process_cats.process_type)><cfif IS_COST eq 1><i class="icon-circle" style="color:##44b6ae"></b></cfif></cfif></td>
								<td style="text-align:center;"><cfif listfind(process_stock_list,get_process_cats.process_type)><cfif IS_STOCK_ACTION eq 1><b><i class="icon-circle" style="color:##44b6ae"></b></cfif></cfif></td>
								<td style="text-align:center;"><cfif IS_PARTNER eq 1><b><i class="icon-circle" style="color:##44b6ae"></b></cfif></td>
								<td style="text-align:center;"><cfif IS_PUBLIC eq 1><b><i class="icon-circle" style="color:##44b6ae"></b></cfif></td>
								<td>#DOCUMENT_TYPE#</td>
								<td>#PAYMENT_TYPE#</td>
								<!-- sil -->
								<td>
									<a href="#request.self#?fuseaction=settings.list_process_cats&event=upd&process_cat_id=#PROCESS_CAT_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
								</td>
							</tr>
							<tr class="table_detail" id="items_#currentrow#">
								<td colspan="16">
									<div id="display_process_info#currentrow#"></div>
								</td>
							</tr>
							<!-- sil --> 
						</cfoutput> 
					<cfelse>
						<tr> 
							<td colspan="16"><cfif form_varmi eq 0><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>! </cfif></td>
						</tr>
					</cfif>
				</tbody>
			</cf_grid_list>
		</div>

		<cfset url_str = "settings.list_process_cats">
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif isdefined("attributes.module") and len(attributes.module)>
			<cfset url_str = "#url_str#&module=#attributes.module#">
		</cfif>
		<cfif isdefined("attributes.trans_types") and len(attributes.trans_types)>
			<cfset url_str = "#url_str#&trans_types=#attributes.trans_types#">
		</cfif>
		<cfif isdefined("attributes.is_form_submitted") and len(attributes.is_form_submitted)>
			<cfset url_str = "#url_str#&is_form_submitted=#attributes.is_form_submitted#">
		</cfif>
		<cf_paging	
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#url_str#"> 
	</cf_box>
</div>
<script type="text/javascript">
document.getElementById('keyword').focus();
function kontrol()
{
	//Query Tipler için kontrol		
	if((document.getElementById('TRANS_TYPES').options[0].selected== true && document.getElementById('TRANS_TYPES').options[1].selected== true) || (document.getElementById('TRANS_TYPES').options[2].selected== true && document.getElementById('TRANS_TYPES').options[3].selected== true) || 
	(document.getElementById('TRANS_TYPES').options[4].selected== true && document.getElementById('TRANS_TYPES').options[5].selected== true) || (document.getElementById('TRANS_TYPES').options[6].selected== true && document.getElementById('TRANS_TYPES').options[7].selected== true) ||
	(document.getElementById('TRANS_TYPES').options[8].selected== true && document.getElementById('TRANS_TYPES').options[9].selected== true) || (document.getElementById('TRANS_TYPES').options[10].selected== true && document.getElementById('TRANS_TYPES').options[11].selected== true) ||
	(document.getElementById('TRANS_TYPES').options[12].selected== true && document.getElementById('TRANS_TYPES').options[13].selected== true)
	<cfif session.ep.our_company_info.is_efatura>|| 
		(document.getElementById('TRANS_TYPES').options[14].selected== true && document.getElementById('TRANS_TYPES').options[15].selected== true) ||
		(document.getElementById('TRANS_TYPES').options[16].selected== true && document.getElementById('TRANS_TYPES').options[17].selected== true)
	</cfif>
	)
	{
		alert("<cf_get_lang dictionary_id='47789.Kategorileri Kendi Arasında Seçemezsiniz'>");
		return false;
	}
	return true;
}
</script>
