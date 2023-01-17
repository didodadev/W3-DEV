<cfif fusebox.fuseaction is 'popup_print_relative'>
<table cellspacing="1" cellpadding="2" width="100%" border="0" class="color-border">
    <tr class="color-row">	
        <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1' trail='0'>
    </tr>
</table>
<!-- sil -->
</cfif>
<cfif listfirst(attributes.fuseaction,'.') is 'myhome'>
	<cfset employee_id_ = contentEncryptingandDecodingAES(isEncode:0,content:employee_id,accountKey:'wrk')>
<cfelse>
	<cfset employee_id_ = employee_id>
</cfif>
<cfquery name="get_employee_detail" datasource="#dsn#">
	SELECT
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		EI.MARRIED,
		EI.TC_IDENTY_NO,
		ED.SEX,
		EP.POSITION_NAME
	FROM
		EMPLOYEES E,
		EMPLOYEES_IDENTY EI,
		EMPLOYEES_DETAIL ED,
		EMPLOYEE_POSITIONS EP
	WHERE
		E.EMPLOYEE_ID = ED.EMPLOYEE_ID AND
		E.EMPLOYEE_ID = EI.EMPLOYEE_ID AND
		E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND
		EP.IS_MASTER = 1 AND
		E.EMPLOYEE_ID = #employee_id_#
</cfquery>

<cfquery name="get_in_outs" datasource="#dsn#" maxrows="1">
	SELECT 
		EIO.SOCIALSECURITY_NO,
		B.BRANCH_NAME,
		B.SSK_NO,
		EIO.SSK_STATUTE,
		EIO.RETIRED_SGDP_NUMBER
	FROM
		EMPLOYEES_IN_OUT EIO,
		BRANCH B
	WHERE
		<cfif isdefined("attributes.branch_id")>EIO.BRANCH_ID = #attributes.branch_id# AND</cfif>
		EIO.EMPLOYEE_ID = #employee_id_# AND
		EIO.FINISH_DATE IS NULL AND
		EIO.BRANCH_ID = B.BRANCH_ID
	ORDER BY IN_OUT_ID DESC
</cfquery>

<cfif get_in_outs.recordcount>
<cfset print_ = 1>
<cfelse>
<cfset print_ = 0>
</cfif>

<cfquery name="GET_RELATIVES" datasource="#DSN#">
  SELECT
  	*
  FROM
 	EMPLOYEES_RELATIVES
  WHERE
	EMPLOYEE_ID=#employee_id_# AND
	(RELATIVE_LEVEL = '3' OR RELATIVE_LEVEL = '4' OR RELATIVE_LEVEL = '5') 
  ORDER BY
  	RELATIVE_LEVEL ASC,BIRTH_DATE,NAME,SURNAME
</cfquery>	

<cfquery name="get_es" dbtype="query" maxrows="1">
	SELECT * FROM GET_RELATIVES WHERE RELATIVE_LEVEL = '3'
</cfquery>

<cfquery name="get_durum" dbtype="query" maxrows="1">
	SELECT * FROM GET_RELATIVES WHERE RELATIVE_LEVEL <> '3' AND (DISCOUNT_STATUS = 0 OR DISCOUNT_STATUS IS NULL) 
</cfquery>

<cfquery name="get_cocuklar" dbtype="query">
	SELECT * FROM GET_RELATIVES WHERE RELATIVE_LEVEL = '4' OR RELATIVE_LEVEL = '5' 
</cfquery>


<cfoutput query="get_in_outs">
<table style="text-align:center" width="100%">
	<tr>
		<!---<td width="300" nowrap><cfinclude template="../../objects/display/view_company_logo.cfm"></td>--->
		<td class="headbold" align="center">
			AİLE DURUMU BİLDİRİMİ<br/>
			#session.ep.period_year#/...Dönemi
		</td>
		<!---<td width="300" nowrap>&nbsp;</td>--->
	</tr>
</table>
<table border="1" style="width:275mm;" cellpadding="3" cellspacing="0" bordercolor="000000">
<tr height="22">
	<td rowspan="5" align="center" width="75" nowrap>Bildirimi Verenin</td>
	<td width="125" nowrap>TC/Vergi Kimlik Nosu</td>
	<td width="250" nowrap>#get_employee_detail.TC_IDENTY_NO#&nbsp;</td>
	<td width="210" nowrap>Sosyal Güvenlik No/Sicil NoKurum Sicil No</td>
	<td width="100%" colspan="2"><cfif SSK_STATUTE eq 2>#RETIRED_SGDP_NUMBER#<cfelse>#SOCIALSECURITY_NO#</cfif>&nbsp;</td>
</tr>
<tr height="22">
	 <td>Çalıştığı İşyeri Ünvanı</td>
	 <td>#branch_name#</td>
	 <td>İşyeri Sicil Numarası</td>
	 <td colspan="2">#ssk_no#</td>
</tr>
<tr height="22">
	 <td>Görevi</td>
	 <td colspan="4">#get_employee_detail.POSITION_NAME#</td>
</tr>
<tr height="22">
	 <td>Adı Soyadı</td>
	 <td colspan="4">#get_employee_detail.employee_name# #get_employee_detail.employee_surname#</td>
</tr>
<tr height="22">
	 <td>Medeni Hali</td>
	 <td>
	 	<cfif get_employee_detail.MARRIED eq 0><img src="/images/ok_list.gif" valign="absmiddle"><cfelse><img src="/images/pod_open.gif" valign="absmiddle"></cfif>Bekar
		<cfif get_employee_detail.MARRIED eq 1><img src="/images/ok_list.gif" valign="absmiddle"><cfelse><img src="/images/pod_open.gif" valign="absmiddle"></cfif>Evli
		<img src="/images/pod_open.gif" valign="absmiddle"><cf_get_lang_main no='744.Diğer'></td>
	 <td><b>Evli İse</b>Eş Doğum Tarihi:<b>#dateformat(get_es.BIRTH_DATE,dateformat_style)#</b></td>
	 <td>Eş TC Kimlik No:<b>#get_es.TC_IDENTY_NO#</b></td>
     <td>Eş Doğum Yeri: <b>#get_es.BIRTH_PLACE#</b></td>
</tr>
<tr height="22">
	<td colspan="6" align="center" class="formbold">ASGARİ GEÇİM İNDİRİMİ İÇİN EŞİN</td>
</tr>
<tr height="22" class="txtbold" align="center">
	<td colspan="2">Adı Soyadı</td>
	<td colspan="2">İş Durumu</td>
	<td colspan="2">Eşin Gelirine/Gelirlerine İlişkin Açıklama</td>
</tr>
<tr height="30">
	<td colspan="2"><cfif get_es.recordcount>#get_es.NAME# #get_es.SURNAME#</cfif></td>
	<td colspan="2">
<cfif get_es.recordcount and get_es.work_status eq 1><img src="/images/ok_list.gif" valign="absmiddle"><cfelse><img src="/images/pod_open.gif" valign="absmiddle"></cfif>Çalışıyor
<cfif get_es.recordcount and get_es.work_status eq 0><img src="/images/ok_list.gif" valign="absmiddle"><cfelse><img src="/images/pod_open.gif" valign="absmiddle"></cfif>Çalışmıyor
<cfif get_es.recordcount and get_es.work_status eq 1><img src="/images/ok_list.gif" valign="absmiddle"><cfelse><img src="/images/pod_open.gif" valign="absmiddle"></cfif>Geliri Olan
<cfif get_es.recordcount and get_es.work_status eq 0><img src="/images/ok_list.gif" valign="absmiddle"><cfelse><img src="/images/pod_open.gif" valign="absmiddle"></cfif>Geliri Olmayan
</td>
	<td colspan="2">#get_es.detail#</td>
</tr>
<tr height="22" class="txtbold">
	<td colspan="4">Eş Çalışıyorsa Çocukların İndirimden Yararlanıp Yararlanmadığı</td>
	<td colspan="2">
<cfif get_durum.recordcount><img src="/images/ok_list.gif" valign="absmiddle"><cfelse><img src="/images/pod_open.gif" valign="absmiddle"></cfif>Evet
<cfif not get_durum.recordcount><img src="/images/ok_list.gif" valign="absmiddle"><cfelse><img src="/images/pod_open.gif" valign="absmiddle"></cfif>Hayır
</td>
</tr>
<tr height="30" class="formbold">
	<td align="center" colspan="6">ASGARİ GEÇİM İNDİRİMİ İÇİN MÜKELLEFLE OTURAN VEYA MÜKELLEF TARAFINDAN BAKILAN ÇOCUKLARIN DURUMU</td>
</tr>
<tr>
	<td colspan="6">
		<!--- cocuklar --->
			<table cellpadding="3" align="center" width="99%">
				<tr bgcolor="f5f5f5" class="printbold">
				<td rowspan="2" align="center" nowrap>Adı Soyadı</td>
				<td rowspan="2" align="center" nowrap>TC Kimlik</td>
				<td rowspan="2" align="center" nowrap>Doğum Tarihi</td>
				<td rowspan="2" align="center" nowrap>Doğum Yeri</td>
				<td rowspan="2" align="center" width="5" nowrap>C</td>
					<td rowspan="2" align="center" nowrap>Baba Adı</td>
					<td rowspan="2" align="center" nowrap>Ana Adı</td>
					<td rowspan="2" align="center" width="165" nowrap>Öz,Üvey Evlat Edinilmiş,Nafakası Sağlanılan Çocuk,Ana, Babasını Kaybetmiş Torun</td>
					<td colspan="3" align="center" nowrap>Yüksek Öğretime Devam Ediyorsa</td>
					<td align="center">Açıklama</td>
					</tr>
					<tr bgcolor="f5f5f5" class="printbold">
						<td align="center" nowrap>Kayıt Tarihi</td>
						<td align="center" nowrap>Okul</td>
						<td align="center" nowrap>Sınıf</td>
						<td>&nbsp;</td>
					</tr>
					<cfset sayi_ = 0>
				<cfif get_cocuklar.recordcount>
					<cfloop query="get_cocuklar">
					<cfif discount_status eq 1>
					<cfset sayi_ = sayi_ + 1>
					<tr bgcolor="fAfAfA" class="print">
						<td>#name# #surname#</td>
						<td>#TC_IDENTY_NO#</td>
						<td>#dateformat(BIRTH_DATE,dateformat_style)#</td>
						<td>#BIRTH_PLACE#</td>
						<td><cfif sex eq 1>E<cfelse>K</cfif></td>
						<td>
							<cfif get_employee_detail.sex eq 1>
								#get_employee_detail.employee_name#
							<cfelseif get_employee_detail.sex eq 0 and get_es.recordcount>
								#get_es.name#
							<cfelse>
								-
							</cfif>						</td>
						<td>
							<cfif get_employee_detail.sex eq 0>
								#get_employee_detail.employee_name#
							<cfelseif get_employee_detail.sex eq 1 and get_es.recordcount>
								#get_es.name#
							<cfelse>
								-
							</cfif>						</td>
						<td>-</td>
						<td>-</td>
						<td>#EDUCATION_OLD#</td>
						<td>-</td>
						<td>#detail#</td>
					</tr>
					</cfif>
					</cfloop>
				</cfif>
				<cfif sayi_ lt 7>
					<cfloop from="1" to="#7-sayi_#" index="ccc">
					<tr bgcolor="fAfAfA">
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					</tr>
					</cfloop>
				</cfif>
			</table>
			<br/>
			<table width="95%" align="center">
			<tr>
                <td>
                    Yukarıda yer alan ve asgari geçim indiriminde kullanılacak bilgiler alt satırdaki hususlar göz önüne almak suretiyle tarafımdan
                    doldurulmuş olup durumumda bir değişiklik olması halinde en geç yedi gün içinde yazılı olarak bildirimde bulunacağımı, yanlış veya geç
                    bilgi vermemden dolayı işverenin zararları karşılayacağımı, tüm hak hakedişlerimden herhangi bir bildirime ve
                    sınırlamaya tabi olmaksızın mahsup edilebileceğini, zarar işyerinden ayrıldıktan sonra ortaya çıkması halinde yasal faizden aşağı
                    olmamak üzere en yüksek işletme kredisi tarafımdan tahsil edileceğini kabul ve taahhüt ediyorum.
            	</td>
			<td width="75"></td>				
				</tr>
				<tr>
					<td  class="formbold" style="text-align:right;">
						Adı Soyadı:<br/>
						İmzası/Tarihi:</td>
					<td valign="top">
						#get_employee_detail.employee_name# #get_employee_detail.employee_surname#<br/>
						#dateformat(now(),dateformat_style)#</td>
				</tr>
			</table>
		<!--- cocuklar --->	</td>
</tr>
</table>
</cfoutput>
