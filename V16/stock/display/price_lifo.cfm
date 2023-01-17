<!---
	burada oncelikle lifoya gore mal alim maliyeti hesaplaniyor.
	oncelikle rc_all adli bir dizi var bu diziye miktar ,fiyat ve fatura cinsi atanir .
	daha sonrada satis faturalarindan alis faturalarina dogru kontrol edilerek degerler dusulur ve kalan mal miktarlari lifoya gore bulunur 
	daha sonrada fiyatlari ile carpilip yazdirillir.
--->

<cfif isDefined("attributes.stock_id")>
		<cfset total=0>
		<cfquery name="GET_INVOICE" datasource="#DSN2#" >
			(
			SELECT 
				IR.INVOICE_ID,
				'A' AS DURUM,
				I.INVOICE_DATE AS INVOICE_DATE,
				(IR.AMOUNT *PU.MULTIPLIER ) AS MIKTAR,
			<cfif attributes.tax IS 1>
				((((IR.PRICE*(100-IR.DISCOUNT1)*(100-IR.DISCOUNT2)*(100-IR.DISCOUNT3)*(100-IR.DISCOUNT4)*(100-IR.DISCOUNT5))/10000000000)+(((IR.PRICE*(100-IR.DISCOUNT1)*(100-IR.DISCOUNT2)*(100-IR.DISCOUNT3)*(100-IR.DISCOUNT4)*(100-IR.DISCOUNT5))/10000000000)*TAX/100))/PU.MULTIPLIER) AS FIYAT
			<cfelse>
				(((IR.PRICE*(100-IR.DISCOUNT1)*(100-IR.DISCOUNT2)*(100-IR.DISCOUNT3)*(100-IR.DISCOUNT4)*(100-IR.DISCOUNT5))/10000000000)/PU.MULTIPLIER) AS FIYAT
			</cfif>
			FROM 
				INVOICE_ROW IR,
				INVOICE I,
				#dsn3_alias#.PRODUCT_UNIT PU
			WHERE 
				IR.INVOICE_ID = I.INVOICE_ID AND 
				IR.PURCHASE_SALES=0 AND 		 
				IR.STOCK_ID=#attributes.stock_id# AND		
				IR.PRODUCT_ID = PU.PRODUCT_ID AND 
				IR.UNIT = PU.ADD_UNIT
			
			UNION ALL
			
			SELECT
				IR.INVOICE_ID, 
				'S' AS DURUM,
				I.INVOICE_DATE AS INVOICE_DATE,
				(IR.AMOUNT * PU.MULTIPLIER ) AS MIKTAR,
				(IR.PRICE/PU.MULTIPLIER) AS FIYAT
			FROM 
				INVOICE_ROW IR, 
				INVOICE I,
				#dsn3_alias#.PRODUCT_UNIT PU
			WHERE 
				IR.INVOICE_ID = I.INVOICE_ID AND 
				IR.PURCHASE_SALES=1 AND 
				IR.STOCK_ID=#attributes.stock_id# AND 
				IR.PRODUCT_ID= PU.PRODUCT_ID AND 
				IR.UNIT = PU.ADD_UNIT
			)
			ORDER BY 
				INVOICE_DATE
		</cfquery>
		<cfset rc_all=ArrayNew(2)>
		<cfset vr=0>
		<cfset toplam=0>
		<cfloop query="GET_INVOICE">
			<cfscript>
			vr=vr+1;
			rc_all[vr][1]=MIKTAR;
			rc_all[vr][2]=DURUM;
			rc_all[vr][3]=FIYAT;
			if (DURUM eq "S") toplam=toplam-MIKTAR;
			else toplam=toplam+MIKTAR;
			</cfscript>
		</cfloop>
		<cfscript>
		if (toplam neq 0)
			{
			for (i=1; i lte ArrayLen(rc_all); i=i+1)
				{
				a=i-1;
				if ((rc_all[i][2] eq "S") and (i neq 1) and( rc_all[i][1] neq 0))
					{
					for (k=a; k gte 1; k=k-1)
						{
						if ((rc_all[k][2]  eq "A") and (rc_all[k][1]  neq 0))
							{
							if (rc_all[k][1] gte rc_all[i][1])
								{
								rc_all[k][1] = rc_all[k][1] - rc_all[i][1];
								rs_all[i][1]=0;
								break;
								}
							else
								{
								if ((rc_all[k][1] lt rc_all[i][1]))
									{
									rc_all[i][1]=rc_all[i][1]-rc_all[k][1];
									rc_all[k][1]=0;
									}
								}
							}
						if (rc_all[i][1] eq 0) break;
						}
					}
				}
			deger=0;
			for (i=1; i lte ArrayLen(rc_all); i=i+1)
				if (rc_all[i][2] eq "A"  and  rc_all[i][1] neq 0) 
					deger=deger+(rc_all[i][3]*rc_all[i][1]);
			nettotal=deger;
			total=toplam;
			}
		else
			nettotal=0;
		</cfscript>
</cfif>
