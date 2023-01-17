<cftry>
	<cfquery name="GET_COMPANY_BRANCH_CONTRACT" datasource="hedef_crm">
		SELECT * FROM HEDEF.HEDEF_MUSTERI_OPSIYON_TANIM WHERE HEDEFKODU = #attributes.cpid#
	</cfquery>
	<cfif get_company_branch_contract.recordcount>
		<cfset depo_kodu_list = valuelist(get_company_branch_contract.depo_kodu)>
		<cfquery name="GET_COMPANY_BRANCH" datasource="#DSN#">
			SELECT
				CBDK.BOYUT_KODU,
				CBR.CUSTOMER_CONTRACT_STATUTE
			FROM 
				BRANCH B,
				COMPANY_BOYUT_DEPO_KOD CBDK,	
				COMPANY_BRANCH_RELATED CBR
			WHERE
				CBDK.W_KODU = B.BRANCH_ID AND
				CBDK.BOYUT_KODU IN(#depo_kodu_list#) AND
				CBR.BRANCH_ID = B.BRANCH_ID AND
				CBR.MUSTERIDURUM NOT IN (1,4,66) AND
				CBR.BRANCH_ID = CBDK.W_KODU AND
				CBR.MUSTERIDURUM IS NOT NULL AND
				CBR.COMPANY_ID =  #attributes.cpid#
		</cfquery>
	</cfif>
	<cfcatch>
		<cfset get_company_branch_contract.recordcount = 0>
	</cfcatch>
</cftry>
<input type="hidden" name="frame_fuseaction" id="frame_fuseaction" value="<cfif isdefined("attributes.frame_fuseaction") and len(attributes.frame_fuseaction)><cfoutput>#attributes.frame_fuseaction#</cfoutput></cfif>">
<cfsavecontent variable="title"><cf_get_lang_main no='25.Anlaşmalar'></cfsavecontent>
<cf_box title="#title#">
<cf_grid_list>
    <thead>
        <tr>
            <th><cf_get_lang_main no='75.No'></th>
            <th width="70"><cf_get_lang no='1037.Anlaşma Müşteri'><cf_get_lang_main no='482.Statü'></th>
            <th width="65"><cf_get_lang_main no='239.Anlaşma'><cf_get_lang_main no='1181.Tarihi'></th>
            <th width="65"><cf_get_lang_main no='89.Başlangıç Tarihi'></th>
            <th width="65"><cf_get_lang no='288.Bitiş Tarihi'></th>
            <th width="65"><cf_get_lang_main no='1054.Değiştirme Tarihi'></th>
            <th width="40"><cf_get_lang no='996.Depo Kodu'></th>
            <th><cf_get_lang no='1038.Grup'></th>
            <th><cf_get_lang_main no='1050.İsim Soyisim'></th>
            <th width="60"><cf_get_lang no='1039.Ciro Prim'></th>
            <th width="75"><cf_get_lang no='1040.Fat Altı-Puan'></th>
            <th width="50"><cf_get_lang no='783.OPS Gün'></th>
        </tr>
    </thead>
    <tbody>
        <cfif get_company_branch_contract.recordcount>
        <cfoutput query="get_company_branch_contract">
            <cfquery name="GET_COMPANY_BRANCH_ROW" dbtype="query">
            SELECT * FROM GET_COMPANY_BRANCH WHERE BOYUT_KODU = '#depo_kodu#'
            </cfquery>
                <tr>
                    <td>#anlasma_no#</td>
                    <td><cfif get_company_branch_row.recordcount and get_company_branch_row.customer_contract_statute eq 1>A</cfif></td>
                    <td>#dateformat(anlasma_tarihi,dateformat_style)#</td>	
                    <td>#dateformat(baslangic_tarihi,dateformat_style)#</td>
                    <td>#dateformat(bitis_tarihi,dateformat_style)#</td>
                    <td>#dateformat(degistirme_tarihi,dateformat_style)#</td>
                    <td>#depo_kodu#</td>
                    <td>#grup#</td>
                    <td>#isim#</td>
                    <td>#ciroprimi#</td>
                    <td>#puan#</td>
                    <td>#gun#</td>
                </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td colspan="12"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
        </tr>
    </cfif>
    </tbody>
</cf_grid_list>
</cf_box>
