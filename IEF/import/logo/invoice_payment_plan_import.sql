
/*
LogoGo3/LogoTiger3 Databaselerinden bilgi alır
Fatura Ödeme Planı Aktarımı
settings.form_add_invoice_payment_plan_import
*/
 
DECLARE @SQLString NVARCHAR(MAX)

SET @SQLString = N'SELECT 
	MUSTERI.CODE as MusteriNo,
	FATURA.GENEXP1+'' ''+FATURA.GENEXP2+'' ''+FATURA.GENEXP3+'' ''+FATURA.GENEXP4 as Aciklama,
	FATURA.FICHENO as FaturaNo,
	FATURA.DATE_ as FaturaTarihi,
	ODEME.DATE_ as VadeTarihi,
	CASE WHEN ODEME.TRRATE>0 then  ODEME.TOTAL*ODEME.TRRATE else ODEME.TOTAL END as TutarTL,
	ODEME.TOTAL as DovizTutar,
	ISNULL( (SELECT top 1 CURCODE FROM L_CURRENCYLIST WHERE  CURTYPE=FATURA.TRCURR),''TRL'')  as ParaBirimi,
	FATURA.PAYDEFREF as OdemePlanID

FROM   LG_'+@FirmNr+'_'+@DonemNr+'_INVOICE AS FATURA INNER JOIN
       LG_'+@FirmNr+'_'+@DonemNr+'_PAYTRANS AS ODEME ON FATURA.LOGICALREF = ODEME.FICHEREF AND ODEME.MODULENR = 4 LEFT OUTER JOIN
       LG_'+@FirmNr+'_CLCARD AS MUSTERI ON FATURA.CLIENTREF = MUSTERI.LOGICALREF'

EXECUTE sp_executesql @SQLString

 