<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
  <tr class="color-border">
    <td>
      <table width="100%" height="100%" border="0" cellpadding="2" cellspacing="1">
        <tr class="color-list">
          <td height="35" class="headbold" colspan="4"><cf_get_lang no ='974.Toplu Şube Bilgisi Aktar Sonuç'></td>
        </tr>
        <tr class="color-row">
          <td valign="top"><table>
			<cfset companylist = ''>
			<cfset imslist = ''>
			<cfloop from="1" to="#attributes.record_num#" index="i">
				<cfif evaluate("attributes.row_kontrol#i#")>
					<cfset form_company_id = evaluate("attributes.company_id#i#")>
					<cfif len(form_company_id)>
						<cfset companylist = listappend(companylist,form_company_id,',')>
					</cfif>
				</cfif>
			</cfloop>
			<cfloop from="1" to="#attributes.record_num1#" index="i">
				<cfif evaluate("attributes.row_kontrol1#i#")>
					<cfset form_ims_code_id = evaluate("attributes.ims_code_id#i#")>
					<cfif len(form_ims_code_id)>
						<cfset imslist = listappend(imslist,form_ims_code_id,',')>
					</cfif>
				</cfif>
			</cfloop>
			<cfif attributes.is_type eq 0>
				<cfif not len(imslist)>
					<script type="text/javascript">
						alert(" <cf_get_lang no ='973.Lütfen IMS Brickleri Seçiniz'>!");
						history.go(-1);
					</script>
					<cfabort>
				</cfif>
			</cfif>
			<cfif attributes.is_type eq 1>
				<cfif not len(companylist)>
					<script type="text/javascript">
						alert("<cf_get_lang no ='574.Lütfen Müşteri Seçiniz'> !");
						history.go(-1);
					</script>
					<cfabort>
				</cfif>
			</cfif>
			<cfquery name="GET_COMPANY" datasource="#dsn#">
				SELECT
					COMPANY.COMPANY_ID, 
					COMPANY.FULLNAME,
					COMPANY_BRANCH_RELATED.*
				FROM 
					COMPANY, 
					COMPANY_BRANCH_RELATED
				WHERE 
					COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
					COMPANY.COMPANY_ID = COMPANY_BRANCH_RELATED.COMPANY_ID 
					<cfif len(attributes.branch_id)>AND COMPANY_BRANCH_RELATED.BRANCH_ID = #attributes.branch_id#</cfif>
					<cfif attributes.is_type eq 0>
						AND COMPANY.IMS_CODE_ID IN <cfif len(imslist)>(#imslist#)<cfelse>0</cfif>
					</cfif>
					<cfif attributes.is_type eq 1>
						AND COMPANY.COMPANY_ID IN <cfif len(companylist)>(#companylist#)<cfelse>0</cfif>
					</cfif>
				ORDER BY 
					COMPANY.FULLNAME
			</cfquery>
			<cfoutput query="get_company">
				<cfquery name="CHECK_VALUE" datasource="#dsn#">
					SELECT BRANCH_ID FROM COMPANY_BRANCH_RELATED WHERE MUSTERIDURUM IS NOT NULL AND BRANCH_ID = #attributes.target_branch_id# AND COMPANY_ID = #get_company.company_id#
				</cfquery>
				<cfif CHECK_VALUE.recordcount>
					<font color="##FF0000">
					<tr>
						<td>#company_id#</td>
						<td><a href="javascript://" onclick="yonlen(#company_id#);">#fullname#</a></td>
						<td><cf_get_lang no ='972.Bu Müşteride Aktarılmak İstenen Şubede Bir Kaydınız Var'> !<br/></td>
					</tr>
					</font>
				<cfelse>
					<cfquery name="GET_OUR_COMPANY" datasource="#dsn#">
						SELECT COMPANY_ID FROM BRANCH WHERE BRANCH_ID = #attributes.target_branch_id#
					</cfquery>
					<cfquery name="ADD_COMPANY_RELATED" datasource="#dsn#" result="MAX_ID">
						INSERT INTO
							COMPANY_BRANCH_RELATED
						(
							BOLGE_KODU,
							ALTBOLGE_KODU,
							CALISMA_SEKLI,
							PUAN,
							COMPANY_ID,
							OUR_COMPANY_ID,
							BRANCH_ID,
							IS_SELECT,
							RECORD_DATE,
							RECORD_EMP,
							RECORD_IP,
							CARIHESAPKOD,
							MUSTERIDURUM,
							DEPOT_KM,
							DEPOT_DAK,
							MUHASEBEKOD,
							DEPO_STATUS,
							SALES_DIRECTOR,
							TEL_SALE_PREID,
							PLASIYER_ID,
							OPEN_DATE,
							RELATION_START,
							RELATION_STATUS,
							COMP_STATUS,
							SHIPPING_ZONE_CODE,
							TAHSILATCI,
							CEP_SIRA,
							ITRIYAT_GOREVLI,
							BOYUT_TAHSILAT,
							BOYUT_ITRIYAT,
							BOYUT_TELEFON,
							BOYUT_PLASIYER,
							BOYUT_BSM,
							AVERAGE_DUE_DATE,
							OPENING_PERIOD,
							MF_DAY	
						)
						VALUES
						(
							'#get_company.bolge_kodu#',
							'#get_company.altbolge_kodu#',
							'#get_company.calisma_sekli#',
							0,
							#get_company.company_id#,
							#get_our_company.company_id#,
							#attributes.target_branch_id#,
							#attributes.is_active#,
							#now()#,
							#session.ep.userid#,
							'#cgi.remote_addr#',
							<cfif isdefined("attributes.is_muhasebe")>'#get_company.carihesapkod#',<cfelse>NULL,</cfif>
							#attributes.branch_state#,
							<cfif len(get_company.depot_km)>#get_company.depot_km#<cfelse>NULL</cfif>,
							<cfif len(get_company.depot_dak)>#get_company.depot_dak#<cfelse>NULL</cfif>,
							<cfif isdefined("attributes.is_muhasebe")>'#get_company.muhasebekod#',<cfelse>NULL,</cfif>
							#attributes.pro_rows#,
							<cfif len(attributes.bsm_id)>#attributes.bsm_id#,
							<cfelseif len(get_company.SALES_DIRECTOR)>#get_company.SALES_DIRECTOR#,
							<cfelse>NULL,</cfif>
							<cfif len(attributes.telefon_id)>#attributes.telefon_id#,
							<cfelseif len(get_company.TEL_SALE_PREID)>#get_company.TEL_SALE_PREID#,
							<cfelse>NULL,</cfif>
							<cfif len(attributes.saha_id)>#attributes.saha_id#,
							<cfelseif len(get_company.PLASIYER_ID)>#get_company.PLASIYER_ID#,
							<cfelse>NULL,</cfif>
							#now()#,
							<cfif len(get_company.relation_start)>#get_company.relation_start#<cfelse>NULL</cfif>,
							<cfif len(attributes.branch_state)>#attributes.branch_state#<cfelse>NULL</cfif>,
							'-',
							<cfif len(get_company.shipping_zone_code)>'#get_company.shipping_zone_code#'<cfelse>NULL</cfif>,
							<cfif len(attributes.tahsilat_id)>#attributes.tahsilat_id#,
							<cfelseif len(get_company.TAHSILATCI)>#get_company.TAHSILATCI#,
							<cfelse>NULL,</cfif>
							<cfif len(attributes.cep_sira)>'#attributes.cep_sira#'<cfelse>'01'</cfif>,
							<cfif len(attributes.itriyat_id)>#attributes.itriyat_id#,
							<cfelseif len(get_company.ITRIYAT_GOREVLI)>#get_company.ITRIYAT_GOREVLI#,
							<cfelse>NULL,</cfif>
							<cfif len(attributes.yeni_boyut_tahsilat)>'#attributes.yeni_boyut_tahsilat#',
							<cfelseif len(get_company.BOYUT_TAHSILAT)>'#get_company.BOYUT_TAHSILAT#',
							<cfelse>NULL,</cfif>
							<cfif len(attributes.yeni_boyut_itriyat)>'#attributes.yeni_boyut_itriyat#',
							<cfelseif len(get_company.BOYUT_ITRIYAT)>'#get_company.BOYUT_ITRIYAT#',
							<cfelse>NULL,</cfif>
							<cfif len(attributes.yeni_boyut_telefon)>'#attributes.yeni_boyut_telefon#',
							<cfelseif len(get_company.BOYUT_TELEFON)>'#get_company.BOYUT_TELEFON#',
							<cfelse>NULL,</cfif>
							<cfif len(attributes.yeni_boyut_saha)>'#attributes.yeni_boyut_saha#',
							<cfelseif len(get_company.BOYUT_PLASIYER)>'#get_company.BOYUT_PLASIYER#',
							<cfelse>NULL,</cfif>
							<cfif len(attributes.yeni_boyut_bsm)>'#attributes.yeni_boyut_bsm#',
							<cfelseif len(get_company.BOYUT_BSM)>'#get_company.BOYUT_BSM#',
							<cfelse>NULL,</cfif>
							<cfif len(get_company.average_due_date)>#get_company.average_due_date#<cfelse>NULL</cfif>,
							<cfif len(get_company.opening_period)>#get_company.opening_period#<cfelse>NULL</cfif>,
							<cfif len(get_company.mf_day)>#get_company.mf_day#<cfelse>NULL</cfif>
						)
					</cfquery>
					<cfquery name="GET_RISK" datasource="#dsn#">
						SELECT TOTAL_RISK_LIMIT, MONEY FROM COMPANY_CREDIT WHERE COMPANY_ID = #get_company.company_id# AND BRANCH_ID = #get_company.related_id#
					</cfquery>
					<cfquery name="ADD_RISK_LIMIT" datasource="#dsn#">
						INSERT INTO
							COMPANY_CREDIT
						(
							OUR_COMPANY_ID,
							COMPANY_ID,
							TOTAL_RISK_LIMIT,
							MONEY,
							RECORD_DATE,
							RECORD_EMP,
							RECORD_IP,
							BRANCH_ID
						)
						VALUES
						(
							#get_our_company.company_id#,
							#get_company.company_id#,
							<cfif len(get_risk.TOTAL_RISK_LIMIT)>#get_risk.TOTAL_RISK_LIMIT#,<cfelse>NULL,</cfif>
							'#get_risk.money#',
							#now()#,
							#session.ep.userid#,
							'#cgi.remote_addr#',
							#MAX_ID.IDENTITYCOL#
						)
					</cfquery>
					<cfquery name="ADD_COMP_RELATED" datasource="#dsn#">
						INSERT INTO
							COMPANY_PARTNER_STORES_RELATED
						(
							OUR_COMPANY_ID,
							COMPANY_ID
						)
						VALUES
						(
							#get_our_company.company_id#,
							#get_company.company_id#
						)
					</cfquery>
					<font color="##FF0000">
					<tr>
						<td width="50">#company_id#</td>
						<td width="50"><a href="javascript://" onclick="yonlen(#company_id#);">#fullname#</a></td>
						<td><cf_get_lang no ='971.Bu Müşteride Kaydınız Yapıldı'> !<br/></td>
					</tr>
					</font>
				</cfif>
			</cfoutput>
				<tr>
					<td align="center" colspan="3"><a href="javascript://" onclick="window.close();"><cf_get_lang_main no ='141.Kapat'></a></td>
				</tr>
            </table>
        </tr>
      </table>
    </td>
  </tr>
</table>
<script type="text/javascript">
function yonlen(company_id)
{
	opener.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=crm.detail_company&is_branch=1&cpid=' + company_id;
}
</script>
