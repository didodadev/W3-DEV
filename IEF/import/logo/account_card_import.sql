--GO3-TIGER3 MUHASEBE FİŞİ IMPORT account.account_card_import

DECLARE @SQLString NVARCHAR(max)
DECLARE @FISDATE NVARCHAR(10)='07.19.2021'
DECLARE @FisTur int=4 --1=Açılış/2=Tahsil/3=Tediye/4=Mahsup/5=Özel/7=kapanış/248=Özel

DECLARE @YERELPARA nvarchar(3)
set @YERELPARA=(SELECT top 1 CURCODE FROM L_CURRENCYLIST WHERE  CURTYPE=(SELECT LOCALCTYP FROM L_CAPIFIRM A WHERE A.NR=@FirmNr) )
 
SET @SQLString = N'select 

	EMFLINE.ACCOUNTCODE as	HesapKodu,
	EMFLINE.LINEEXP	ACiklama,
	case when EMFLINE.SIGN=0 then ''B'' else ''A''	END BA,
	case when EMFLINE.SIGN=0 then DEBIT else CREDIT end	Tutar,
	EMFLINE.REPORTNET	SistemIkinciDOvizTut,
	 ISNULL( (SELECT top 1 CURCODE FROM L_CURRENCYLIST WHERE  CURTYPE = EMFLINE.TRCURR),'''+@YERELPARA+''')  as IslemDovizi,
	EMFLINE.TRNET	IslemDoviziTutari,
	EMFLINE.BRANCH	SubeID,
	EMFLINE.DEPARTMENT	DepartmanID,
	EMFLINE.PROJECTREF	ProjeID

from LG_'+@FirmNr+'_'+@DonemNr+'_EMFLINE EMFLINE
where EMFLINE.TRCODE='+ STR(@FisTur)+' AND EMFLINE.DATE_='''+CONVERT(VARCHAR, @FISDATE , 104)  +''' '  

 
EXECUTE sp_executesql @SQLString
 



