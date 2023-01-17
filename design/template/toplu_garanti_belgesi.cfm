<cfquery name="get_serials" datasource="#dsn3#">
	SELECT 
		SGN.SERIAL_NO,
		S.PRODUCT_NAME,
		S.PROPERTY,
		S.BRAND_ID,
		S.PRODUCT_ID,
        S.STOCK_ID
	FROM
		SERVICE_GUARANTY_NEW SGN,
		STOCKS S
	WHERE
		SGN.PERIOD_ID = #session.ep.period_id# AND
		SGN.STOCK_ID = S.STOCK_ID
		<cfif isdefined("attributes.action_row_id") and len(attributes.action_row_id)>
			AND SGN.STOCK_ID=#attributes.action_row_id#
		</cfif>
	ORDER BY 
		SGN.SERIAL_NO
</cfquery>
<cfif len(get_serials.product_id)>
    <cfquery name="get_guaranty" datasource="#dsn3#">
        SELECT 
            * 
        FROM 
            PRODUCT_GUARANTY 
        WHERE 
            PRODUCT_ID=#get_serials.product_id#
    </cfquery>
<cfelse>
	<cfset get_serials.recordcount = 0>
</cfif>

<cfquery name="GET_GUARANTY_DETAIL" datasource="#dsn3#">
	SELECT
		*
	FROM
		SERVICE_GUARANTY_NEW
	WHERE
		GUARANTY_ID=#attributes.action_id#
</cfquery>

<cfset basilacak_sayi = get_serials.recordcount>
<!--- <cfif basilacak_sayi gte 50 and not isdefined("attributes.yazdir")>
	<cfform name="formexport" method="post" action="#request.self#?fuseaction=objects.popupflush_print_files_inner">
	<input type="hidden" name="yazdir" value="1">
	<input type="hidden" name="print_type" value="<cfoutput>#attributes.print_type#</cfoutput>">
	<input type="hidden" name="action_id" value="<cfoutput>#attributes.action_id#</cfoutput>">
	<cfif isdefined("attributes.action_row_id") and len(attributes.action_row_id)>
		<input type="hidden" name="action_row_id" value="<cfoutput>#attributes.action_row_id#</cfoutput>">
	</cfif>
	<input type="hidden" name="form_type" value="<cfoutput>#attributes.form_type#</cfoutput>">
	<input type="hidden" name="is_special" value="1">
	<table width="100%" height="100%" align="center" cellpadding="0" cellspacing="0" border="0">
	<tr>
	  <td align="center" valign="top">
		<table width="98%" border="0" cellpadding="0" cellspacing="0">
		  <tr>
			<td class="color-border">
			  <table width="100%" align="center" cellpadding="2" cellspacing="1" border="0" height="100%">
				<tr height="35" class="color-list">
				  <td class="headbold">&nbsp;Garanti Belgesi Toplu Print</td>
				</tr>
				<tr class="color-row">
				  <td valign="top">
				  	<table>
					  <tr>
						<td>Basılacak Seri Adedi</td>
						<td><cfoutput>#basilacak_sayi#</cfoutput></td>
					  </tr>
					  <tr>
						<td>Başlangıç Seri</td>
						<td><cfinput type="text" name="baslangic" value="1" validate="integer" range="1," message="Baslangiç Seri Sayısını Giriniz!"></td>
					  </tr>
					  <tr>
						<td>Bitiş Seri</td>
						<td><cfinput type="text" name="bitis" value="#basilacak_sayi#" validate="integer" range="1,#basilacak_sayi#" message="Bitis Seri Sayısını Giriniz!"></td>
					  </tr>
					  <tr>
						<td></td>
						<td height="35"><cf_workcube_buttons is_upd='0' insert_info='Çalıştır'> </td>
					  </tr>
					</table>
				  </td>
				</tr>
			  </table>
			</td>
		  </tr>
		</table>
		</cfform>
	  <td> 
	</tr>
	<table>
<cfelse>
	<cfif not isdefined("attributes.bitis")>
		<cfset attributes.baslangic=1>
		<cfset attributes.bitis=basilacak_sayi>
		<cfset attributes.yazdir=1>
	</cfif>
</cfif> --->

<cfif not isdefined("attributes.bitis")>
	<cfset attributes.baslangic=1>
    <cfset attributes.bitis=basilacak_sayi>
    <cfset attributes.yazdir=1>
</cfif>

<cfif isdefined("attributes.yazdir") and len(attributes.yazdir)>
	<cfset fark=attributes.bitis-attributes.baslangic + 1>
<cfoutput>
<table border="0" cellpadding="0" cellspacing="0" style="width:145mm;height:200mm">
    <tr>
        <td style="width:5mm">&nbsp;</td>
        <td style="height:30mm" valign="top">
        <table width="50%" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td style="width:23mm;height:13mm">&nbsp;</td>
                <td style="height:15mm">&nbsp;</td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td><b><cf_get_lang_main no='56.Belge'><cf_get_lang_main no='88.Onay'></b></td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td><b>#dateformat(get_guaranty.DOCUMENT_APPROVA_DATE,dateformat_style)#</b></td>
            </tr>
        </table>
        </td>
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td valign="top">
        <table style="height:20mm" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td style="width:27mm">&nbsp;</td>
            <td>
            <cfquery name="GET_PRO_NAME" datasource="#DSN3#">
                SELECT 
                    P.PRODUCT_NAME,
                    S.PROPERTY
                FROM 
                    PRODUCT P, 
                    STOCKS S
                WHERE 
                    S.STOCK_ID = #GET_GUARANTY_DETAIL.STOCK_ID# 
                    AND S.PRODUCT_ID = P.PRODUCT_ID
            </cfquery>
            	<b>#GET_PRO_NAME.PRODUCT_NAME#</b>
            </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td>
                <cfquery name="get_brand" datasource="#dsn3#">
                    SELECT 
                    	BRAND_NAME
                    FROM 
                    	PRODUCT_BRANDS P,
                        STOCKS S 
                    WHERE 
                    	S.STOCK_ID = #GET_GUARANTY_DETAIL.STOCK_ID# 
                    	AND P.BRAND_ID = S.BRAND_ID
                </cfquery>
            	<b>#get_brand.BRAND_NAME#</b>
            </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td><b>#GET_PRO_NAME.PROPERTY#</b></td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td><b>#GET_GUARANTY_DETAIL.SERIAL_NO#</b></td>
        </tr>
		</table>
		</td>
    </tr>
</table>
<br/>	
</cfoutput>
</cfif>
