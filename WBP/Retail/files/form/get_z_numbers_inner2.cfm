<br />
<cf_date tarih='attributes.give_date'>
<cfif isdefined("attributes.con_id")>
	<cfquery name="get_zno" datasource="#dsn_Dev#">
    	SELECT * FROM POS_CONS WHERE CON_ID = #attributes.CON_ID#
    </cfquery>
    <cfset satis_ = get_zno.SATIS_TOPLAM>
    <cfset iade_ = get_zno.IADE_TOPLAM>
    
    <!--- gecici --->
    <cfquery name="get_ciro" datasource="#dsn_dev#" result="query_r">
        SELECT
            SUM(ODEME_TUTAR) AS TOPLAM_SATIS
        FROM
            (
            SELECT
                SUM(GAP2.ODEME_TUTAR) AS ODEME_TUTAR
            FROM 
                #dsn_alias#.BRANCH B2,
                GENIUS_ACTIONS GA2,
                GENIUS_ACTIONS_PAYMENTS GAP2,
                #dsn3_alias#.POS_EQUIPMENT PE2
            WHERE 
                GAP2.ODEME_TURU NOT IN (26) AND
                GA2.ACTION_ID = GAP2.ACTION_ID AND
                GA2.FIS_IPTAL = 0 AND
                GA2.BELGE_TURU NOT IN ('2') AND
                PE2.BRANCH_ID = B2.BRANCH_ID AND
                PE2.EQUIPMENT_CODE = GA2.KASA_NUMARASI AND
                YEAR(GA2.FIS_TARIHI) = #year(attributes.give_date)# AND
                MONTH(GA2.FIS_TARIHI) = #month(attributes.give_date)# AND
                DAY(GA2.FIS_TARIHI) = #day(attributes.give_date)# AND
                ZNO = '#attributes.z_number#' AND
                GA2.KASA_NUMARASI = #attributes.kasa_id#
            ) T1
    </cfquery>
    
    
    <cfquery name="get_iade" datasource="#dsn_dev#" result="query_b">
    	SELECT
            SUM(GAP2.ODEME_TUTAR) AS ODEME_TUTAR
        FROM 
            #dsn_alias#.BRANCH B2,
            GENIUS_ACTIONS GA2,
            GENIUS_ACTIONS_PAYMENTS GAP2,
            #dsn3_alias#.POS_EQUIPMENT PE2
        WHERE 
            GA2.ACTION_ID = GAP2.ACTION_ID AND
            GA2.FIS_IPTAL = 0 AND
            GA2.BELGE_TURU = '2' AND
            PE2.BRANCH_ID = B2.BRANCH_ID AND
            PE2.EQUIPMENT_CODE = GA2.KASA_NUMARASI AND
            YEAR(GA2.FIS_TARIHI) = #year(attributes.give_date)# AND
            MONTH(GA2.FIS_TARIHI) = #month(attributes.give_date)# AND
            DAY(GA2.FIS_TARIHI) = #day(attributes.give_date)# AND
            ZNO = '#attributes.z_number#' AND
            GA2.KASA_NUMARASI = #attributes.kasa_id#
    </cfquery>
    <cfif get_iade.recordcount and len(get_iade.ODEME_TUTAR)>
    	<cfset iade_ = get_iade.ODEME_TUTAR>
    <cfelse>
    	<cfset iade_ = 0>
    </cfif>
    <cfif len(get_ciro.TOPLAM_SATIS)>
    	<cfset satis_ = get_ciro.TOPLAM_SATIS - iade_>
    <cfelse>
    	<cfset satis_ = 0>
    </cfif>
    <!--- gecici --->
    
    <cfset kasiyer_fazla_toplam = get_zno.FAZLA_TOPLAM>
    <cfset teslimat_toplam = get_zno.TESLIMAT_TOPLAM>
    <cfset kasiyer_acik_toplam = get_zno.ACIK_TOPLAM>
<cfelse>
    <cfquery name="get_ciro" datasource="#dsn_dev#" result="query_r">
        SELECT
            SUM(ISNULL(ODEME_TUTAR,0)) AS TOPLAM_SATIS
        FROM
            (
            SELECT
                SUM(GAP2.ODEME_TUTAR) AS ODEME_TUTAR
                --SUM(GA2.FIS_TOPLAM) AS ODEME_TUTAR
            FROM 
                #dsn_alias#.BRANCH B2,
                GENIUS_ACTIONS GA2,
                GENIUS_ACTIONS_PAYMENTS GAP2,
                #dsn3_alias#.POS_EQUIPMENT PE2
            WHERE 
                GAP2.ODEME_TURU NOT IN (26) AND
                GA2.ACTION_ID = GAP2.ACTION_ID AND
                GA2.FIS_IPTAL = 0 AND
                GA2.BELGE_TURU NOT IN ('2') AND
                PE2.BRANCH_ID = B2.BRANCH_ID AND
                PE2.EQUIPMENT_CODE = GA2.KASA_NUMARASI AND
                YEAR(GA2.FIS_TARIHI) = #year(attributes.give_date)# AND
                MONTH(GA2.FIS_TARIHI) = #month(attributes.give_date)# AND
                DAY(GA2.FIS_TARIHI) = #day(attributes.give_date)# AND
                ZNO = '#attributes.z_number#' AND
                GA2.KASA_NUMARASI = #attributes.kasa_id#
            ) T1
    </cfquery>
    <cfquery name="get_satis" datasource="#dsn_dev#" result="query_r2">
        SELECT
            SUM(ISNULL(ODEME_TUTAR,0)) AS TOPLAM_SATIS
        FROM
            (
            SELECT
                SUM(GAP2.ODEME_TUTAR) AS ODEME_TUTAR
            FROM 
                #dsn_alias#.BRANCH B2,
                GENIUS_ACTIONS GA2,
                GENIUS_ACTIONS_PAYMENTS GAP2,
                #dsn3_alias#.POS_EQUIPMENT PE2
            WHERE 
                GA2.ACTION_ID = GAP2.ACTION_ID AND
                GA2.FIS_IPTAL = 0 AND
                GA2.BELGE_TURU NOT IN ('2') AND
                GAP2.ODEME_TURU = '0' AND
                PE2.BRANCH_ID = B2.BRANCH_ID AND
                PE2.EQUIPMENT_CODE = GA2.KASA_NUMARASI AND
                YEAR(GA2.FIS_TARIHI) = #year(attributes.give_date)# AND
                MONTH(GA2.FIS_TARIHI) = #month(attributes.give_date)# AND
                DAY(GA2.FIS_TARIHI) = #day(attributes.give_date)# AND
                ZNO = '#attributes.z_number#' AND
                GA2.KASA_NUMARASI = #attributes.kasa_id#
            ) T1
    </cfquery>
    
    <cfquery name="get_iade" datasource="#dsn_dev#" result="query_b">
    	SELECT
            SUM(GAP2.ODEME_TUTAR) AS ODEME_TUTAR
        FROM 
            #dsn_alias#.BRANCH B2,
            GENIUS_ACTIONS GA2,
            GENIUS_ACTIONS_PAYMENTS GAP2,
            #dsn3_alias#.POS_EQUIPMENT PE2
        WHERE 
            GA2.ACTION_ID = GAP2.ACTION_ID AND
            GA2.FIS_IPTAL = 0 AND
            GA2.BELGE_TURU = '2' AND
            PE2.BRANCH_ID = B2.BRANCH_ID AND
            PE2.EQUIPMENT_CODE = GA2.KASA_NUMARASI AND
            YEAR(GA2.FIS_TARIHI) = #year(attributes.give_date)# AND
            MONTH(GA2.FIS_TARIHI) = #month(attributes.give_date)# AND
            DAY(GA2.FIS_TARIHI) = #day(attributes.give_date)# AND
            ZNO = '#attributes.z_number#' AND
            GA2.KASA_NUMARASI = #attributes.kasa_id#
    </cfquery>
    <cfif get_iade.recordcount and len(get_iade.ODEME_TUTAR)>
    	<cfset iade_ = get_iade.ODEME_TUTAR>
    <cfelse>
    	<cfset iade_ = 0>
    </cfif>
    
    <cfset satis_ = get_ciro.TOPLAM_SATIS - iade_>
    <cfset kasiyer_fazla_toplam = 0>
    <cfset teslimat_toplam = get_ciro.TOPLAM_SATIS - get_satis.TOPLAM_SATIS>
    <cfset kasiyer_acik_toplam = satis_ - teslimat_toplam>
</cfif>
<cfoutput>
<input type="hidden" style="width:75px;" class="moneybox" name="iade_toplam" id="iade_toplam" value="#tlformat(iade_)#" readonly="readonly"/>
<table>
	<tr>
    	<td class="formbold">Satış Toplam</td>
        <td><input type="text" style="width:75px;" class="moneybox" name="satis_toplam" id="satis_toplam" value="#tlformat(satis_)#" readonly="readonly"/></td>
        <td class="formbold">Kasiyer Fazla Toplam</td>
        <td><input type="text" style="width:75px;" class="moneybox" name="kasiyer_fazla_toplam" id="kasiyer_fazla_toplam" value="#tlformat(kasiyer_fazla_toplam)#" readonly="readonly"/></td>
    </tr>
    <tr>
    	<td class="formbold">Teslimat Toplam</td>
        <td><input type="text" style="width:75px;" class="moneybox" name="teslimat_toplam" id="teslimat_toplam" value="#tlformat(teslimat_toplam)#" readonly="readonly"/></td>
        <td class="formbold">Kasiyer Açık Toplam</td>
        <td><input type="text" style="width:75px;" class="moneybox" name="kasiyer_acik_toplam" id="kasiyer_acik_toplam" value="#tlformat(kasiyer_acik_toplam)#" readonly="readonly"/></td>
    </tr>
</table>
</cfoutput>