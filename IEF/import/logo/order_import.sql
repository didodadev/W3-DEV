/* Sipariş Aktarım
settings.form_add_order_import
 */
DECLARE @SQLString NVARCHAR(max)
DECLARE @YERELPARA nvarchar(3)
set @YERELPARA=(SELECT top 1 CURCODE FROM L_CURRENCYLIST WHERE  CURTYPE=(SELECT LOCALCTYP FROM L_CAPIFIRM A WHERE A.NR=@FirmNr) )
 
SET @SQLString = N'select
	  0 as BelgeSatır,
	  CASE WHEN TRCODE=2 THEN 0 ELSE 1 END as SiparisTipi, 
	  '''' as SiparisBasligi, 
	  ''K'' as UyeTipi,
	  CLCARD.CODE as CariKod,
	  ORFICHE.SALESMANREF as SatisCalisanId,
	  CONVERT(VARCHAR, ORFICHE.DATE_ , 104) as SiparisTarihi,
	 CONVERT(VARCHAR, ORFICHE.DATE_ , 104) as SevkTarihi,
	 CONVERT(VARCHAR, ORFICHE.DATE_ , 104)  as TeslimTarihi,
	  ORFICHE.PAYDEFREF as OdemeYontemi,
	  CONVERT(VARCHAR, ORFICHE.DATE_, 104) as VadeTarihi,
	  SHIPINFO.ADDR1+'' ''+SHIPINFO.ADDR2 as TeslimAdresi,
	  '''' as Asama,
	  1 as SiparisOnceligi,
	  ORFICHE.SOURCEINDEX as Depo,
	  1 as Lokasyon,
	  ORFICHE.GENEXP1+'' ''+GENEXP2+'' ''+GENEXP3+'' ''+GENEXP4 as Acıklama,
	  ORFICHE.PROJECTREF as ProjeID,
	  '''' as OzelTanim,
	  (select LOGICALREF from L_SHPTYPES A WHERE A.SCODE=ORFICHE.SHPTYPCOD) as SevkYontemi,
	  ISNULL( (SELECT top 1 CURCODE FROM L_CURRENCYLIST WHERE  CURTYPE = ORFICHE.TRCURR),'''+@YERELPARA+''') as IslemDovizi,
	  ORFICHE.TRRATE as BelgeDovizKuru,
	  0 as TeslimAdresiIlcesi ,
	  0 as SistemNo ,
	  SHIPINFO.LOGICALREF as TeslimAdresiID,
	  0 as SubeID,
	  ORFICHE.LOGICALREF as ReferansNo,
	  ORFICHE.FICHENO as SiparisNo
from LG_'+@FirmNr+'_'+@DonemNr+'_ORFICHE ORFICHE LEFT OUTER JOIN LG_'+@FirmNr+'_CLCARD CLCARD
	ON ORFICHE.CLIENTREF=CLCARD.LOGICALREF LEFT OUTER JOIN LG_'+@FirmNr+'_SHIPINFO SHIPINFO
	ON ORFICHE.SHIPINFOREF=SHIPINFO.LOGICALREF'

EXECUTE sp_executesql @SQLString