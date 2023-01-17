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
		E.EMPLOYEE_ID = #attributes.action_id#
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
		EIO.EMPLOYEE_ID = #attributes.action_id# AND
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
    INNER JOIN (SELECT 
            MAX(RELATIVE_ID) AS ROW_ID
        FROM 
            EMPLOYEES_RELATIVES
        GROUP BY
            TC_IDENTY_NO
        ) RELATIVE_TABLE
        ON EMPLOYEES_RELATIVES.RELATIVE_ID = RELATIVE_TABLE.ROW_ID
  WHERE
	EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND
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
	<table style="width:16cm;heigth:29cm;" class="book">
		<tr>
			<td class="headbold" align="center">
				<cf_get_lang dictionary_id="30884.AİLE DURUMU BİLDİRİMİ"> <br/>
				#session.ep.period_year#/...<cf_get_lang dictionary_id="33596.Dönemi">
			</td>
			<td width="300" nowrap>&nbsp;</td>
		</tr>
	</table>
<table border="1" style="width:16cm;heigth:29cm;" cellpadding="3" cellspacing="0" bordercolor="000000" class="book">
	<tr height="22">
		<td rowspan="5" align="center" width="75" nowrap><cf_get_lang dictionary_id="38673.Bildirimi Verenin"></td>
		<td width="125" nowrap><cf_get_lang dictionary_id="32325.TC/Vergi Kimlik No"></td>
		<td width="250" nowrap>#get_employee_detail.TC_IDENTY_NO#&nbsp;</td>
		<td width="210" nowrap><cf_get_lang dictionary_id="31245.Sosyal Güvenlik No">/<cf_get_lang dictionary_id="32328.Sicil No">/<cf_get_lang dictionary_id="32329.Kurum Sicil No"></td>
		<td width="100%" colspan="2"><cfif SSK_STATUTE eq 2>#RETIRED_SGDP_NUMBER#<cfelse>#SOCIALSECURITY_NO#</cfif>&nbsp;</td>
	</tr>
	<tr height="22">
		 <td><cf_get_lang dictionary_id="38674.Çalıştığı İşyeri Ünvanı"></td>
		 <td>#branch_name#</td>
		 <td><cf_get_lang dictionary_id="44617.İşyeri Sicil Numarası"></td>
		 <td colspan="2">#ssk_no#</td>
	</tr>
	<tr height="22">
		 <td><cf_get_lang dictionary_id="53916.Görevi"></td>
		 <td colspan="4">#get_employee_detail.POSITION_NAME#</td>
	</tr>
	<tr height="22">
		 <td><cf_get_lang dictionary_id="32370.Adı Soyadı"></td>
		 <td colspan="4">#get_employee_detail.employee_name# #get_employee_detail.employee_surname#</td>
	</tr>
	<tr height="22">
		 <td><cf_get_lang dictionary_id="30693.Medeni Hali"></td>
		 <td>
			<cfif get_employee_detail.MARRIED eq 0><img src="/images/ok_list.gif"><cfelse><img src="/images/pod_open.gif"></cfif> <cf_get_lang dictionary_id="30694.Bekar">
			<cfif get_employee_detail.MARRIED eq 1><img src="/images/ok_list.gif"><cfelse><img src="/images/pod_open.gif"></cfif> <cf_get_lang dictionary_id="55743.Evli">
			<img src="/images/pod_open.gif"> <cf_get_lang dictionary_id="58156.Diğer">	 </td>
		 <td><b><cf_get_lang dictionary_id="38646.Evli İse"></b> <cf_get_lang dictionary_id="38647.Eş Doğum T."> : <b>#dateformat(get_es.BIRTH_DATE,dateformat_style)#</b></td>
		 <td><cf_get_lang dictionary_id="38645.Eş TC K. No"> : <b>#get_es.TC_IDENTY_NO#</b></td>
		 <td><cf_get_lang dictionary_id="38644.Eş Doğum Yeri"> : <b>#get_es.BIRTH_PLACE#</b></td>
	</tr>
	<tr height="22">
		<td colspan="6" align="center" class="formbold"><cf_get_lang dictionary_id="38641.ASGARİ GEÇİM İNDİRİMİ İÇİN EŞİN"></td>
	</tr>
	<tr height="22" class="txtbold" align="center">
		<td colspan="2"><cf_get_lang dictionary_id="32370.Adı Soyadı"></td>
		<td colspan="2"><cf_get_lang dictionary_id="40121.İş Durumu"></td>
		<td colspan="2"><cf_get_lang dictionary_id="38640.Eşin Gelirine/Gelirlerine İlişkin Açıklama"></td>
	</tr>
	<tr height="30">
		<td colspan="2"><cfif get_es.recordcount>#get_es.NAME# #get_es.SURNAME#</cfif></td>
		<td colspan="2">
	<cfif get_es.recordcount and get_es.work_status eq 1><img src="/images/ok_list.gif"><cfelse><img src="/images/pod_open.gif"></cfif> <cf_get_lang dictionary_id="40137.Çalışıyor">
	<cfif get_es.recordcount and get_es.work_status eq 0><img src="/images/ok_list.gif"><cfelse><img src="/images/pod_open.gif"></cfif> <cf_get_lang dictionary_id="56365.Çalışmıyor">
	<cfif get_es.recordcount and get_es.work_status eq 1><img src="/images/ok_list.gif"><cfelse><img src="/images/pod_open.gif"></cfif> <cf_get_lang dictionary_id="38637.Geliri Olan">
	<cfif get_es.recordcount and get_es.work_status eq 0><img src="/images/ok_list.gif"><cfelse><img src="/images/pod_open.gif"></cfif> <cf_get_lang dictionary_id="38636.Geliri Olmayan">		
	</td>
		<td colspan="2">#get_es.detail#</td>
	</tr>
	<tr height="22" class="txtbold">
		<td colspan="4"><cf_get_lang dictionary_id="38635.Eş Çalışıyorsa Çocukların İndirimden Yararlanıp Yararlanmadığı"></td>
		<td colspan="2">
	<cfif get_durum.recordcount><img src="/images/ok_list.gif"><cfelse><img src="/images/pod_open.gif"></cfif> <cf_get_lang dictionary_id="57495.Evet">
	<cfif not get_durum.recordcount><img src="/images/ok_list.gif"><cfelse><img src="/images/pod_open.gif"></cfif> <cf_get_lang dictionary_id="57496.Hayır">
	</td>
	</tr>
	<tr height="30" class="formbold">
		<td align="center" colspan="6"><cf_get_lang dictionary_id="38634.ASGARİ GEÇİM İNDİRİMİ İÇİN MÜKELLEFLE OTURAN VEYA MÜKELLEF TARAFINDAN BAKILAN ÇOCUKLARIN DURUMU"></td>
	</tr>
	<tr>
		<td colspan="6">
			<!--- cocuklar --->
			<table cellpadding="3" align="center" width="99%">
				<tr bgcolor="f5f5f5" class="printbold">
				<td rowspan="2" align="center" nowrap><cf_get_lang dictionary_id="32370.Adı Soyadı"></td>
				<td rowspan="2" align="center" nowrap><cf_get_lang dictionary_id="58025.TC Kimlik"></td>
				<td rowspan="2" align="center" nowrap><cf_get_lang dictionary_id="58727.Doğum Tarihi"></td>
				<td rowspan="2" align="center" nowrap><cf_get_lang dictionary_id="38633.Doğum"><br/><cf_get_lang dictionary_id="58664.Yeri"> </td>
				<td rowspan="2" align="center" width="5" nowrap>C</td>
					<td rowspan="2" align="center" nowrap><cf_get_lang dictionary_id="58033.Baba Adı"></td>
					<td rowspan="2" align="center" nowrap><cf_get_lang dictionary_id="58440.Ana Adı"></td>
					<td rowspan="2" align="center" width="165" nowrap><cf_get_lang dictionary_id="38632.Öz, Üvey Evlat Edinilmiş">,<br/><cf_get_lang dictionary_id="38631.Nafakası Sağlanılan Çocuk">,<br/><cf_get_lang dictionary_id="38630.Ana, Babasını Kaybetmiş Torun"></td>
					<td colspan="3" align="center" nowrap><cf_get_lang dictionary_id="38629.Yüksek Öğretime Devam Ediyorsa"></td>
					<td align="center"><cf_get_lang dictionary_id="54291.Açıklama"></td>
					</tr>
					<tr bgcolor="f5f5f5" class="printbold">
						<td align="center" nowrap><cf_get_lang dictionary_id="38628.Kayıt T."></td>
						<td align="center" nowrap><cf_get_lang dictionary_id="57709.Okul"></td>
						<td align="center" nowrap><cf_get_lang dictionary_id="32326.Sınıf"></td>
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
						<td align="center">#dateformat(BIRTH_DATE,dateformat_style)#</td>
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
						<td align="center">#dateformat(EDUCATION_RECORD_DATE,dateformat_style)#</td>
						<td>#EDUCATION_SCHOOL_NAME#</td>
						<td align="center">#EDUCATION_CLASS_NAME#</td>
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
					<cf_get_lang dictionary_id="61187.Yukarıda yer alan ve asgari geçim indiriminde kullanılacak bilgiler alt satırdaki hususlar göz önüne almak suretiyle tarafımdan doldurulmuş olup durumumda bir değişiklik olması halinde"> <cf_get_lang dictionary_id="61188.en geç yedi gün içinde yazılı olarak bildirimde bulunacağımı, yanlış veya geç bilgi vermemden dolayı işverenin zararları karşılayacağımı, tüm hak hakedişlerimden herhangi bir bildirime ve sınırlamaya tabi olmaksızın mahsup edilebileceğini, zarar işyerinden ayrıldıktan sonra ortaya çıkması halinde yasal faizden aşağı olmamak üzere en yüksek işletme kredisi tarafımdan tahsil edileceğini kabul ve taahhüt ediyorum.">			</td>
					<td width="75"></td>
				</tr>
				<tr>
					<td  class="formbold" style="text-align:right;">
						<cf_get_lang dictionary_id="32370.Adı Soyadı"> : <br/>
						<cf_get_lang dictionary_id="58957.İmza"> / <cf_get_lang dictionary_id="57742.Tarih"> :					</td>
					<td valign="top">
						#get_employee_detail.employee_name# #get_employee_detail.employee_surname#<br/>
						#dateformat(now(),dateformat_style)#					</td>
				</tr>
			</table>
			<!--- cocuklar --->	
		</td>
	</tr>
</table>
</cfoutput>